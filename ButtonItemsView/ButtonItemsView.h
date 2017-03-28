//
//  MoreCityView.h
//  zhibo
//
//  Created by xhs on 16/2/23.
//  Copyright © 2016年 zhwx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ItemSelectType_single,   //单选
    ItemSelectType_more,     //多选
}ItemSelectType;

@interface ItemProperty : NSObject

@property(nonatomic,assign) CGFloat o_buttonHight;         //按钮高度= 40.0
@property(nonatomic,assign) CGFloat o_buttonSapce;         //按钮之间的间距= 15.0
@property(nonatomic,assign) CGFloat o_buttonUpDownSapce;   //按钮上下之间的间距
@property(nonatomic,assign) CGFloat o_buttonBlank;         //按钮内部左右的空白= 20*2
@property(nonatomic,assign) CGFloat o_leftMargin;          //左边距= 15.0
@property(nonatomic,assign) CGFloat o_topMargin;           //上边距= 15.0
@property(nonatomic,assign) CGFloat o_titleHeight;         //标题高= 30.0
@property(nonatomic,assign) CGFloat o_titleTop;            //标题上边距=5.0

@property (nonatomic,assign) BOOL o_needTitle;             //是否需要标题 默认NO
@property (nonatomic,assign) BOOL o_needPlaceHold;         //是否需要提示语 默认NO

@property (nonatomic,strong) NSArray *o_styleButtons;      //items按钮（和传入数据数组的数量一致）
@end


@protocol ButtonItemsViewDelegate <NSObject>

/**
 *  选择标签   每次点击调用  model:字符串或者自定义对象
 */
- (void)toClickItemIndex:(NSInteger)index buttonItemsView:(UIView *)view model:(id)model;

@end

/**
 *  多个按钮 视图自适应
 */
@interface ButtonItemsView : UIView

@property (nonatomic,assign) ItemSelectType o_type;   //单选或者多选

@property (nonatomic,assign) id<ButtonItemsViewDelegate>o_delegate;

/**
 *  设置标题
 */
- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)color;
- (void)setTitleFont:(UIFont *)font;
@property (nonatomic,strong) UILabel *o_titleLabel;

/**
 *  设置提示语
 */
- (void)setPlaceHold:(NSString *)title;

/**
 *  获取默认属性 在此基础上修改单个或多个属性
 */
- (ItemProperty *)getDefItemProperty;

/**
 *  获取默认按钮
 */
+ (UIButton *)getDefItemButton;

/**
 *  刷新视图 按钮数组 -获取高度
 *  citys:项目数组 字符串类型
 *  width:视图宽
 *  placeHold:当没有一个item的时候 显示提示文字
 *  itemProperty:设置边距、风格等 无设置使用默认值
 */
- (CGFloat)reloadView:(NSArray *)items withWidth:(CGFloat)width itemProperty:(ItemProperty*)property;

/**
 *  如果传入的是对象数组 name：对象中需要显示的key
 */
- (CGFloat)reloadViewModels:(NSArray *)models withKey:(NSString *)name withWidth:(CGFloat)width itemProperty:(ItemProperty*)property;


/**
 *  如果传入的是对象数组 name：对象中需要显示的key
 */
+ (CGFloat)getHightModels:(NSArray *)items keyName:(NSString *)name withWidth:(CGFloat)width itemProperty:(ItemProperty *)property;

/**
 *  获取高度 width：视图宽度 可提前计算出所需高度
 */
+ (CGFloat)getHight:(NSArray *)items withWidth:(CGFloat)width itemProperty:(ItemProperty*)property;

/**
 *  获取选中数组
 */
- (NSArray *)getSelectObjs;

/**
 *  获取选中的index集合
 */
- (NSArray *)getSelectIndexs;

@end
