//
//  EQPageCyclePageImageView.h
//  EQPageCycle
//
//  Created by Eason Qian on 15/9/10.
//  Copyright (c) 2015年 Eason Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EQPageCyclePageImageView, EQPageControl;

@protocol EQPageCyclePageImageViewDataSource <NSObject>

/**
 *  轮播图数量
 *
 *  @param aPageView
 *
 *  @return
 */
- (NSUInteger)numberOfPagesInPageView:(EQPageCyclePageImageView *)aPageView;
/**
 *  轮播图view
 *
 *  @param aPageView self
 *  @param aIndex    次序
 *
 *  @return
 */
@optional
- (NSString *)pageView:(EQPageCyclePageImageView *)aPageView imageUrlStringAtIndex:(NSUInteger)aIndex;

@end

@protocol EQPageCyclePageImageViewDelegate <NSObject>

@optional
/**
 *  点击事件
 *
 *  @param aPageView
 *  @param aIndex
 */
- (void)pageView:(EQPageCyclePageImageView *)aPageView didSelectedPageAtIndex:(NSUInteger)aIndex;

/**
 *	功能:从当前页 切换另一页时,此方法会被调用
 *
 *	@param pageView :
 *	@param aIndex   :另一页面的索引
 */
- (void)pageView:(EQPageCyclePageImageView *)pageView didChangeToIndex:(NSUInteger)aIndex;

/**
 *  功能:非循环页面，滑动到最后一页继续往后滑动
 */
- (void)pageViewScrollEndOfPage:(EQPageCyclePageImageView *)aPageView;

@end


@interface EQPageCyclePageImageView : UIView

@property (nonatomic, weak) id <EQPageCyclePageImageViewDataSource> dataSource;
@property (nonatomic, weak) id <EQPageCyclePageImageViewDelegate> delegate;

/**
 *  reload之后显示第几个图片
 */
@property (nonatomic) NSInteger startPageIndex;

/**
 *  轮播循环间隔
 */
@property (nonatomic) NSTimeInterval interval;
/**
 *  分页控件
 */
@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic) BOOL disableAutoRunPage;//是否禁止自动轮播

@property (nonatomic) BOOL disableCycle;//是否禁止循环

@property (nonatomic) NSInteger itemHeight;

- (instancetype)initWithFrame:(CGRect)frame itemWidth:(CGFloat)itemWidth itemHeight:(CGFloat)itemHeight;
/**
 *  刷新数据
 */
- (void)reloadData;

@end
