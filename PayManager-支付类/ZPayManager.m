//
//  ZPayManager.m
//  TinyShop
//
//  Created by zhwx on 15/12/9.
//  Copyright © 2015年 zhenwanxiang. All rights reserved.
//

#import "ZPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayOrder.h"
#import "DataSigner.h"
#import "SNSWeiXinService.h"
#import "UPPayPluginPro.h"
#import "MBProgressHUD.h"



//支付宝 错误码
#define SUCCESSFUL_STATUS @"9000"
#define ORDER_PAY_FALSE @"4000"
#define NET_ERROR @"6002"
#define USER_CANCEL @"6001"

#define Alipay_AppScheme @"TinyShop"


//接入模式设定,两个值: @"00":代表接入生产环境(正式版 本需要); @"01":代表接入开发测试环境(测 试版本需要);
#define kUnionpayMode             @"00"


@interface ZPayManager()<SNSWeiXinPayServiceDelegate,UPPayPluginDelegate,MBProgressHUDDelegate>

//菊花
@property (nonatomic,strong) MBProgressHUD* o_processHud;
@property (nonatomic,copy)NSString* o_processMessage;


@end



@implementation ZPayManager

+(instancetype) shareInstance
{
    static ZPayManager* __payManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __payManager = [[ZPayManager alloc] init];
    });
    return __payManager;
}

#pragma mark- 支付宝
/**
 *  支付宝支付
 *
 *  @param tradeNo     交易号
 *  @param productName 商品名称
 *  @param amount      金额
 *  @param callBackUrl 回调地址
 */
-(void) payOrderByAlixPayWithTradeNo:(NSString*)tradeNo
                         productName:(NSString*)productName
                              amount:(double)amount
                         callbackUrl:(NSString*)callBackUrl
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    AlipayOrder *aliOrder = [[AlipayOrder alloc] init];
    aliOrder.partner = PARTNER;
    aliOrder.seller = SELLER;
    aliOrder.tradeNO = tradeNo; //订单ID（由商家自行制定）
    aliOrder.productName = productName; //商品标题
    aliOrder.productDescription = productName; //商品描述
    aliOrder.amount = [NSString stringWithFormat:@"%.2f", amount]; //商品价格
    aliOrder.notifyURL = callBackUrl; //回调URL
    
    aliOrder.service = @"mobile.securitypay.pay";
    aliOrder.paymentType = @"1";
    aliOrder.inputCharset = @"utf-8";
    aliOrder.itBPay = @"30m";
    aliOrder.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = Alipay_AppScheme;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [aliOrder description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    id<DataSigner> signer = CreateRSADataSigner(RSA_PRIVATE);
    NSString *signedString = [signer signString:orderSpec];
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderSpec, signedString, @"RSA"];
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        NSString *status = [resultDic objectForKey:@"resultStatus"];
        if ([status isEqualToString:SUCCESSFUL_STATUS]) {
            //成功
            if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
                [_o_delegate payFinishedWithResult:ZPayResultType_Success payType:ZPayType_Alipay error:nil];
            }
            
        } else if ([status isEqualToString:ORDER_PAY_FALSE]) {
            //失败
            if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
                [_o_delegate payFinishedWithResult:ZPayResultType_Failed payType:ZPayType_Alipay error:nil];
            }
        } else if ([status isEqualToString:USER_CANCEL]) {
            //取消
            if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
                [_o_delegate payFinishedWithResult:ZPayResultType_Cancel payType:ZPayType_Alipay error:nil];
            }
        } else if ([status isEqualToString:NET_ERROR]) {
            //网络错误
            if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
                [_o_delegate payFinishedWithResult:ZPayResultType_NetError payType:ZPayType_Alipay error:nil];
            }
        }else{
            if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
                [_o_delegate payFinishedWithResult:ZPayResultType_Failed payType:ZPayType_Alipay error:nil];
            }
        }
        
    }];
    
    
}



#pragma mark- 微信

/**
 *  微信支付
 *
 *  @param partnerId 商家向财付通申请的商家id
 *  @param prepayId  预支付订单
 *  @param nonceStr  随机串，防重发
 *  @param timeStamp 时间戳，防重发
 *  @param package   商家根据财付通文档填写的数据和签名
 *  @param sign      商家根据微信开放平台文档对数据做的签名
 */
-(void) payOrderByWeiXinWithPartnerId:(NSString*)partnerId
                             prepayId:(NSString*)prepayId
                             nonceStr:(NSString*)nonceStr
                            timeStamp:(NSInteger)timeStamp
                              package:(NSString*)package
                                 sign:(NSString*)sign
{
    if (![self isValidateWeiXinApp]) {
        return;
    }
    
    //设置 接收回调
    SNSWeiXinService* wxs = [SNSWeiXinService shareInstanced];
    wxs.o_payDelegate = self;
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = partnerId;
    req.prepayId            = prepayId;
    req.nonceStr            = nonceStr;
    req.timeStamp           = timeStamp;
    req.package             = package;
    req.sign                = sign;
    [WXApi sendReq:req];
}



/**
 *  微信支付 (此方法 已过期)
 *
 *  @param tradeNo     交易号
 *  @param productName 商品名称
 *  @param amount      金额
 */
-(void) payOrderByWeiXinWithTradeNo:(NSString*)tradeNo
                        productName:(NSString*)productName
                             amount:(double)amount __deprecated
{
    if (![self isValidateWeiXinApp]) {
        return;
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"WX" forKey:@"bank_type"];
    [params setObject:productName forKey:@"body"];
    [params setObject:@"1" forKey:@"fee_type"];
    [params setObject:@"UTF-8" forKey:@"input_charset"];
    [params setObject:WX_APP_CALL_BACK_URL forKey:@"notify_url"];
    [params setObject:productName forKey:@"out_trade_no"];
    [params setObject:WX_APP_PARTNER_ID forKey:@"partner"];
    [params setObject:[ZUtilsNet getIPAddressWithIsIp4:YES] forKey:@"spbill_create_ip"];
    [params setObject:FORMAT(@"%d",(NSInteger)(amount*100)) forKey:@"total_fee"];//用整形
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showMBProgressHUD];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        SNSWeiXinService* wxs = [SNSWeiXinService shareInstanced];
        wxs.o_payDelegate = self;
        AccessTokenResp* tokenResp = [wxs getPayAccessToken];
        
        if (tokenResp && tokenResp.o_errorCode == 0) {
            
            WeiXinPayOrder* wxOrder = [wxs getPayOrderInfoWithPackage:params];
            if (wxOrder && wxOrder.o_errcode == 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideMBProgressHUD];
                    //调微信APP 支付
                    [wxs sendWXPayRequestWithPrepayId:wxOrder.o_prepayid];
                });
                return;
            }
            
        }
        //获取相关数据异常
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideMBProgressHUD];
            if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
                [_o_delegate payFinishedWithResult:ZPayResultType_DataException payType:ZPayType_Alipay error:nil];
            }
        });
        
    });
    
}

-(BOOL) isValidateWeiXinApp
{
    BOOL isInstalled = [WXApi isWXAppInstalled];
    if (!isInstalled) {
        //未安装微信
        if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
            [_o_delegate payFinishedWithResult:ZPayResultType_UnInstall payType:ZPayType_WeiXin error:nil];
        }
        
        return NO;
    }
    
    BOOL isSupport = [WXApi isWXAppSupportApi];
    if (!isSupport) {
        
        //不支持
        if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
            [_o_delegate payFinishedWithResult:ZPayResultType_UnSupport payType:ZPayType_WeiXin error:nil];
        }
        return NO;
    }
    
    return YES;
}



#pragma mark- SNSWeiXinPayServiceDelegate
-(void) weixinPaySuccess:(PayResp*) resp
{
    if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
        [_o_delegate payFinishedWithResult:ZPayResultType_Success payType:ZPayType_WeiXin error:nil];
    }
}

-(void) weixinPayFail:(PayResp*) resp
{
    //可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。
    if (resp.errCode == -1) {
        if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
            [_o_delegate payFinishedWithResult:ZPayResultType_Failed payType:ZPayType_WeiXin error:resp.errStr];
        }
    //无需处理。发生场景：用户不支付了，点击取消，返回APP。
    }else if (resp.errCode == -2){
        if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
            [_o_delegate payFinishedWithResult:ZPayResultType_Cancel payType:ZPayType_WeiXin error:nil];
        }
    }
    
}



#pragma mark- 银联

/**
 *  银联支付
 *
 *  @param tn 银联支付tn值
 */
-(void) payOrderByUnionPayWithTN:(NSString*)tn
{
    [UPPayPluginPro startPay:tn mode:kUnionpayMode viewController:_o_payVC delegate:self];
    
}


- (void)UPPayPluginResult:(NSString *)result
{
    //success、fail、cancel
    //银联返回结果
    
    if ([result isEqualToString:@"success"]) {
        if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
            [_o_delegate payFinishedWithResult:ZPayResultType_Success payType:ZPayType_Union error:nil];
        }
    }else if ([result isEqualToString:@"cancel"]) {
        if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
            [_o_delegate payFinishedWithResult:ZPayResultType_Cancel payType:ZPayType_Union error:nil];
        }
    }else{
        if ([_o_delegate respondsToSelector:@selector(payFinishedWithResult:payType:error:)]) {
            [_o_delegate payFinishedWithResult:ZPayResultType_Failed payType:ZPayType_Union error:nil];
        }
    }
}




#pragma mark- 获取微信 token信息 进度条
- (MBProgressHUD *) showMBProgressHUD
{
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    //每次创建新的
    if (self.o_processHud) {
        [self.o_processHud removeFromSuperview];
        self.o_processHud = nil;
    }
    
    if (!self.o_processHud) {
        self.o_processHud = [[MBProgressHUD alloc] initWithView:keyWindow];
        self.o_processHud.labelText = self.o_processMessage;
        self.o_processHud.mode = MBProgressHUDModeIndeterminate;
        self.o_processHud.delegate = self;
        
        [keyWindow addSubview: self.o_processHud];
    }
    [keyWindow bringSubviewToFront:self.o_processHud];
    
    return self.o_processHud;
}


- (void) hideMBProgressHUD
{
    [self.o_processHud hide:YES];
}

@end
