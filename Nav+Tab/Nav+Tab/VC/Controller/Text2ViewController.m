//
//  Text2ViewController.m
//  Nav+Tab
//
//  Created by ugamehome on 16/9/12.
//  Copyright © 2016年 ugamehome. All rights reserved.
//

//aircraft 180 80 8 car 225 70  8 castle 300 231 16 rocket 150 282 8 yacht 160 90 12
#define GiftName @"name"
#define GiftWidth @"width"
#define GiftHeight @"Height"
#define GiftNum @"Num"
#define GiftId @"giftId"
#define GiftShowType @"showType"
#import "Text2ViewController.h"

@interface Text2ViewController (){
    UIImageView *flameAnimation;
    UILabel *giftLable;
    NSTimer * _timer;
    NSMutableArray *o_giftArr;
    NSMutableArray *o_giftImages;
    CAKeyframeAnimation *pathAnimation;
    int selectIndex;
    NSMutableArray *allTime;
}
@property (nonatomic,strong)UIView *o_giftView;
@end

@implementation Text2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    o_giftArr = [[NSMutableArray alloc]init];
    allTime  = [[NSMutableArray alloc]init];
    NSDictionary *aircraft = [NSDictionary dictionaryWithObjectsAndKeys:@"aircraft",GiftName,@"150",GiftWidth,@"66",GiftHeight,@"8",GiftNum,@"2",GiftId,@"1",GiftShowType, nil];
    [o_giftArr addObject:aircraft];
     NSDictionary *car = [NSDictionary dictionaryWithObjectsAndKeys:@"car",GiftName,@"180",GiftWidth,@"55",GiftHeight,@"8",GiftNum,@"2",GiftId,@"1",GiftShowType, nil];
    [o_giftArr addObject:car];
     NSDictionary *castle = [NSDictionary dictionaryWithObjectsAndKeys:@"castle",GiftName,@"150",GiftWidth,@"116",GiftHeight,@"16",GiftNum,@"2",GiftId,@"3",GiftShowType, nil];
    [o_giftArr addObject:castle];
    NSDictionary *rocket = [NSDictionary dictionaryWithObjectsAndKeys:@"rocket",GiftName,@"150",GiftWidth,@"141",GiftHeight,@"8",GiftNum,@"2",GiftId,@"2",GiftShowType, nil];
    [o_giftArr addObject:rocket];
    NSDictionary *yacht = [NSDictionary dictionaryWithObjectsAndKeys:@"yacht",GiftName,@"150",GiftWidth,@"83",GiftHeight,@"8",GiftNum,@"2",GiftId,@"1",GiftShowType, nil];
    [o_giftArr addObject:yacht];
    
    self.view .backgroundColor = [UIColor whiteColor];
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(20, 64, 70, 50)];
    [but setTitle:@"点击变化多端" forState:UIControlStateNormal];
    [but setBackgroundColor:[UIColor grayColor]];
    [but addTarget:self action:@selector(sendGift) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
}

- (void)sendGift{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSDictionary *dic ;
        if (selectIndex == 5) {
            selectIndex = 0;
        }
        dic = [o_giftArr objectAtIndex:selectIndex];
        selectIndex ++;
        
        o_giftImages = [[NSMutableArray alloc]init];
        _o_giftView = [[UIView alloc]init];
        flameAnimation = [[UIImageView alloc] init];
        flameAnimation.tag = 3001;
        giftLable = [[UILabel alloc]init];
        _o_giftView.backgroundColor = [UIColor clearColor];
        
        giftLable.font = [UIFont systemFontOfSize:15];
        giftLable.textColor = [UIColor blackColor];
        [_o_giftView addSubview:flameAnimation];
        [_o_giftView addSubview:giftLable];
        
        flameAnimation.width = [dic[GiftWidth]intValue];
        flameAnimation.height = [dic[GiftHeight]intValue];
        giftLable.y = CGRectGetMaxY(flameAnimation.frame);
        giftLable.width = [dic[GiftWidth]intValue];
        giftLable.height = 20;
        giftLable.textAlignment = NSTextAlignmentCenter;
        CGPoint point = CGPointMake((screenWidth-flameAnimation.width)/2, (screenHeight-flameAnimation.height)/2);//中心点
        _o_giftView.frame = CGRectMake(point.x, point.y, flameAnimation.width, CGRectGetMaxY(giftLable.frame));
        
        [o_giftImages removeAllObjects];
        int num = [dic[GiftNum] intValue];
        for (int i = 1; i <= num; i++) {
            NSString *imageStr = nil;
            if (i >= 10) {
                imageStr = [NSString stringWithFormat: @"anim_%@_000%d",dic[GiftName],i];
            }else{
                imageStr = [NSString stringWithFormat: @"anim_%@_0000%d",dic[GiftName],i];
            }
            UIImage *image = [UIImage imageNamed: imageStr];
            [o_giftImages addObject:image];
        }
        
        flameAnimation.animationImages = o_giftImages;
        
        flameAnimation.animationRepeatCount = 0;
        // start animating
        [flameAnimation startAnimating];
        
        
        if ([dic[GiftShowType] intValue] < 3) {
            pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            pathAnimation.calculationMode = kCAAnimationPaced;
            pathAnimation.fillMode = kCAFillModeForwards;
            pathAnimation.removedOnCompletion = NO;
            pathAnimation.duration = 5;
            pathAnimation.repeatCount = 1;
            CGMutablePathRef curvedPath = CGPathCreateMutable();
            if([dic[GiftShowType] intValue] == 1){
                CGPathMoveToPoint(curvedPath, NULL, screenWidth+point.x, point.y);
                CGPathAddQuadCurveToPoint(curvedPath, NULL, screenWidth+point.x, point.y, -flameAnimation.width, point.y);
            }else{
                CGPathMoveToPoint(curvedPath, NULL, screenWidth+point.x, screenHeight);
                CGPathAddQuadCurveToPoint(curvedPath, NULL, screenWidth+point.x, screenHeight, -flameAnimation.width, 0);
            }
            pathAnimation.path = curvedPath;
            CGPathRelease(curvedPath);
            //    在指定路径后，指定动画的对象，（在此用UIImageView举例：）
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            giftLable.text = @"神奇的卡布达送得超级打飞机";
            [self.view addSubview:_o_giftView];
            _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f  target:self selector:@selector(timerFire:)userInfo:nil repeats:YES];
            [allTime addObject:_timer];
            if ([dic[GiftShowType] intValue] < 3) {
                [_o_giftView.layer addAnimation:pathAnimation
                                         forKey:@"moveTheSquare"];
            }
        });
    });
}

-(void)timerFire:(id)userinfo {
    NSTimer *timer = [allTime firstObject];
    [allTime removeObject:timer];
    [timer invalidate];
    timer = nil;
    NSLog(@"还有几个--》%lu",(unsigned long)[self.view.subviews count]);
    UIView *view = self.view.subviews [1];
    UIImageView *imageView = (UIImageView*)[view viewWithTag:3001];
    [imageView stopAnimating];
    [view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
