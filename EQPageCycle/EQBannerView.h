//
//  EQBannerView.h
//  EQPageCycle
//
//  Created by Eason Qian on 15/9/10.
//  Copyright (c) 2015年 Eason Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EQPageCyclePageImageView;

@interface EQBannerView : UIView

@property (strong, nonatomic) EQPageCyclePageImageView *pageView;
@property (strong, nonatomic) UIPageControl *pageControl;

- (void)setupBannerView;

@end
