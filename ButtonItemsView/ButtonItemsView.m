//
//  MoreCityView.m
//  zhibo
//
//  Created by xhs on 16/2/23.
//  Copyright © 2016年 zhwx. All rights reserved.
//

#import "ButtonItemsView.h"

#define ButtonTag 888

#define kbuttonHight 40.0        //按钮高度
#define kbuttonSapce 15.0         //按钮左右之间的间距
#define kbuttonUpDownSapce 15.0      //按钮上下之间的间距
#define kbuttonBlank 20*2        //按钮内部左右的空白
#define kleftMargin 15.0         //左边距
#define ktopMargin 15.0          //上边距
#define ktitleHeight 30.0        //标题高
#define ktitleTop 5.0            //标题上边距

const static NSString *o_checkYES = @"YES";
const static NSString *o_checkNO = @"NO";

@interface ButtonItemsView()
{
    UILabel *o_placeHoldLabel;
    
    CGFloat o_buttonHight;        //按钮高度
    CGFloat o_buttonSapce;         //按钮之间的间距
    CGFloat o_buttonBlank;        //按钮内部左右的空白
    CGFloat o_buttonUpDownBlank;   //按钮上下之间的间距
    CGFloat o_leftMargin;         //左边距
    CGFloat o_topMargin;          //上边距
    CGFloat o_titleHeight;        //标题高
    CGFloat o_titleTop;            //标题上边距
    
    NSMutableArray *o_items;      //按钮集合
    
    NSArray *o_itemDatas;      //传入的数组
    BOOL o_isModel;           //判断传入的是否自定义对象
    
}
@end


@implementation ButtonItemsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initObj];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initObj];
}

- (void)initObj
{
    o_buttonHight = kbuttonHight;        //按钮高度
    o_buttonSapce = kbuttonSapce;         //按钮之间的间距
    o_buttonUpDownBlank = kbuttonUpDownSapce;
    o_buttonBlank = kbuttonBlank;        //按钮内部左右的空白
    o_leftMargin = kleftMargin;         //左边距
    o_topMargin = ktopMargin;          //上边距
    o_titleHeight = ktitleHeight;        //标题高
    o_titleTop = ktitleTop;             //标题上边距
}

/**
 *  获取默认属性 在此基础上修改单个或多个属性
 */
- (ItemProperty *)getDefItemProperty
{
    ItemProperty *info = [[ItemProperty alloc]init];
    info.o_buttonHight = o_buttonHight;
    info.o_buttonSapce = o_buttonSapce;
    info.o_buttonBlank = o_buttonBlank;
    info.o_leftMargin = o_leftMargin;
    info.o_topMargin = o_topMargin;
    info.o_titleHeight = o_titleHeight;
    info.o_buttonUpDownSapce = o_buttonUpDownBlank;
    info.o_titleTop = o_titleTop;
    return info;
}

- (void)setTitle:(NSString *)title
{
    _o_titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)color
{
    _o_titleLabel.textColor = color;
}

- (void)setTitleFont:(UIFont *)font
{
    _o_titleLabel.font = font;
}

- (void)setPlaceHold:(NSString *)title
{
    o_placeHoldLabel.text = title;
}

- (void)setO_type:(ItemSelectType)o_type
{
    _o_type = o_type;
}


/**
 *  如果传入的是对象数组 name：对象中需要显示的key
 */
- (CGFloat)reloadViewModels:(NSArray *)models withKey:(NSString *)name withWidth:(CGFloat)width itemProperty:(ItemProperty*)property
{
    o_itemDatas = models;
    o_isModel = YES;
    
    NSMutableArray *names = [NSMutableArray array];
    
    for (id model in models) {
        NSString *nameStr = [model valueForKey:name];
        [names addObject:nameStr];
    }
    
    return [self reloadView:names withWidth:width
               itemProperty:property];
}

/**
 *  刷新视图 城市数组 -获取高度
 *  citys:项目数组 字符串类型
 *  width:视图宽
 *  placeHold:当没有一个item的时候 显示提示文字
 *  itemProperty:设置边距、风格等 无设置使用默认值
 */
- (CGFloat)reloadView:(NSArray *)items withWidth:(CGFloat)width itemProperty:(ItemProperty *)property
{
    [self removeAllSubViews];
    o_items = [NSMutableArray array];
    
    
    if (!o_isModel) {
        o_itemDatas = items;
    }
    
    o_isModel = NO;
    
    if (property) {
        o_buttonHight = property.o_buttonHight;        //按钮高度
        o_buttonSapce = property.o_buttonSapce;        //按钮之间的间距
        o_buttonBlank = property.o_buttonBlank;        //按钮内部左右的空白
        o_buttonUpDownBlank = property.o_buttonUpDownSapce;  //按钮上下之间的间距
        o_leftMargin = property.o_leftMargin;          //左边距
        o_topMargin = property.o_topMargin;            //上边距
        o_titleHeight = property.o_titleHeight;        //标题高
        o_titleTop = property.o_titleTop;              //标题上边距
    }
    
    if (property.o_needTitle) {
        _o_titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(o_leftMargin, o_titleTop, width-2*o_leftMargin, o_titleHeight)];
        _o_titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_o_titleLabel];
    }
    
    //视图的高度
    CGFloat selfHight = 0.0;
    
    //city为字符串
    for (int i = 0 ; i<items.count; i++) {
        NSString *cityName = items[i];
        
        UIButton *styleButton;
        if (property.o_styleButtons.count>0) {
            styleButton = [property.o_styleButtons objectAtIndex:i];
        }
        
        CGFloat buttonWidth =  [ButtonItemsView getButtonWidth:cityName withWidth:width buttonBlank:o_buttonBlank font:property.o_styleButtons.count>0?styleButton.titleLabel.font.pointSize:[ButtonItemsView getDefItemButton].titleLabel.font.pointSize];
        
        UIButton *lastButton = nil;
        if (i>=1) {
            lastButton = [self viewWithTag:(ButtonTag+i)-1];
        }
        
        UIButton *button;
        if (property.o_styleButtons.count>0) {
            button = styleButton;
        }else{
            button = [ButtonItemsView getDefItemButton];
        }
        
        
        button.tag = ButtonTag + i;
        
        //如果当前是第一个按钮
        if (!lastButton) {
            button.frame = CGRectMake(o_leftMargin, property.o_needTitle?o_topMargin+o_titleHeight+o_titleTop:o_topMargin, buttonWidth, o_buttonHight);
        }else{
            //如果当前行已经显示不完全 换行
            BOOL isShow = (width - (lastButton.right+o_buttonSapce+o_leftMargin))>=buttonWidth;
            if (isShow) {
                button.frame = CGRectMake(lastButton.right+o_buttonSapce, lastButton.top, buttonWidth, o_buttonHight);
            }else{
                //换行
                button.frame = CGRectMake(o_leftMargin, lastButton.bottom+o_buttonUpDownBlank, buttonWidth, o_buttonHight);
            }
        }
    
        
        //最后一个按钮 获取视图所需的高度
        if (i==items.count-1) {
            selfHight = button.bottom + o_topMargin;
        }
        
        [button setTitle:cityName forState:UIControlStateNormal];
        [button addTarget:self action:@selector(toClickCityButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [o_items addObject:button];   //按钮集合
        
    }
    
    //设置提示文字
    if (items.count==0&&property.o_needPlaceHold) {
        CGFloat height = [ButtonItemsView getHight:@[@"一行"] withWidth:width itemProperty:property];
        o_placeHoldLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, width-20, height)];
        o_placeHoldLabel.font = [UIFont systemFontOfSize:15.0];
        o_placeHoldLabel.textColor = RGBCOLOR(212, 212, 212);
        [self addSubview:o_placeHoldLabel];
        return height+2*o_topMargin;
    }
    
    return selfHight;
}



/**
 *  如果传入的是对象数组 name：对象中需要显示的key
 */
+ (CGFloat)getHightModels:(NSArray *)items keyName:(NSString *)name withWidth:(CGFloat)width itemProperty:(ItemProperty *)property
{
    NSMutableArray *names = [NSMutableArray array];
    
    for (id model in items) {
        NSString *nameStr = [model valueForKey:name];
        [names addObject:nameStr];
    }
    return [self getHight:names withWidth:width itemProperty:property];
}


/**
 *  获取高度
 */
+ (CGFloat)getHight:(NSArray *)items withWidth:(CGFloat)width itemProperty:(ItemProperty *)property
{
    CGFloat height = 0.0;
    CGFloat right = (property?property.o_leftMargin:kleftMargin);
    for (int i = 0; i<items.count; i++) {
        
        if (i==0) {
            height = (property?property.o_buttonHight:kbuttonHight)+(property?property.o_topMargin:ktopMargin)*2;
        }
        
        UIButton *styleButton = [property.o_styleButtons objectAtIndex:i];
        
        NSString *cityName = items[i];
        CGFloat buttonWidth = [self getButtonWidth:cityName withWidth:width buttonBlank:(property?property.o_buttonBlank:kbuttonBlank) font:property.o_styleButtons.count>0?styleButton.titleLabel.font.pointSize:[ButtonItemsView getDefItemButton].titleLabel.font.pointSize];
        
        if ((width - (right+(property?property.o_leftMargin:kleftMargin)))>=buttonWidth) {
            right = right+buttonWidth+ (property?property.o_buttonSapce:kbuttonSapce);
        }else{
            //换行
            right = (property?property.o_leftMargin:kleftMargin)+buttonWidth+(property?property.o_buttonSapce:kbuttonSapce);
            height = height + (property?property.o_buttonHight:kbuttonHight)+(property?property.o_buttonUpDownSapce:kbuttonUpDownSapce);
        }
        
    }
    
    if (property.o_needPlaceHold) {
        if (height == 0) {
            CGFloat oneHeight = [ButtonItemsView getHight:@[@"一行"] withWidth:width itemProperty:property];
            return property.o_needTitle?oneHeight+(property?property.o_titleHeight:ktitleHeight)+(property?property.o_titleTop:ktitleTop):oneHeight;
        }
    }
    
    return property.o_needTitle?height+ (property?property.o_titleHeight:ktitleHeight)+(property?property.o_titleTop:ktitleTop):height;
}
/**
 *  点击按钮
 */
- (void)toClickCityButton:(UIButton *)button
{
    NSInteger index = button.tag - ButtonTag;
    
    for(UIButton *tButton in o_items){
        
        if (_o_type == ItemSelectType_single) {
            //单选
            if (index == tButton.tag-ButtonTag) {
                if (tButton.selected) {
                    tButton.selected = NO;
                    
                    
                }else{
                    tButton.selected = YES;
                }
            }else{
                tButton.selected = NO;
            }
        }else{
            //多选
            if (index == tButton.tag-ButtonTag) {
                tButton.selected = !tButton.selected;
            }
        }
        
    }
    
    if ([_o_delegate respondsToSelector:@selector(toClickItemIndex:buttonItemsView:model:)]) {
        [_o_delegate toClickItemIndex:index buttonItemsView:self model:o_itemDatas[index]];
    }
}

/**
 *  获取当前city文字宽度
 */
+ (CGFloat)getButtonWidth:(NSString *)cityName withWidth:(CGFloat)width buttonBlank:(CGFloat)buttonBlank font:(CGFloat)font
{
    CGSize citySize = [ZUtilsString getSizeWithTextFontSize:font withText:cityName withWidth:width];
    
    //加上两边空白
    return citySize.width + buttonBlank;
}

/**
 *  获取默认按钮
 */
+ (UIButton *)getDefItemButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 1, 1);
    button.cornerRadius = 6.0;
    button.borderWidth = 1.0;
    button.borderColor = RGBCOLOR(224, 224, 224);
    [button setTitleColor:RGBCOLOR(118, 123, 138) forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(118, 123, 138) forState:UIControlStateSelected];
    [button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    return button;
}

- (NSArray *)getSelectObjs
{
    NSMutableArray *selectObjs = [NSMutableArray array];
    for (int i = 0;i<o_items.count;i++) {
        UIButton *button = o_items[i];
        if (button.selected) {
            NSInteger index = button.tag-ButtonTag;
            [selectObjs addObject:o_itemDatas[index]];
        }
    }
    return selectObjs;
}

- (NSArray *)getSelectIndexs
{
    NSMutableArray *selectIndexs = [NSMutableArray array];
    for (int i = 0;i<o_items.count;i++) {
        UIButton *button = o_items[i];
        if (button.selected) {
            NSInteger index = button.tag-ButtonTag;
            [selectIndexs addObject:@(index)];
        }
    }
    return selectIndexs;
}

@end

@implementation ItemProperty

@end


