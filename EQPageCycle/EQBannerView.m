//
//  EQBannerView.m
//  EQPageCycle
//
//  Created by Eason Qian on 15/9/10.
//  Copyright (c) 2015年 Eason Qian. All rights reserved.
//

#import "EQBannerView.h"
#import "EQPageCyclePageImageView.h"

@implementation EQBannerView

- (void)setupBannerView
{
    
    self.pageView = [[EQPageCyclePageImageView alloc] initWithFrame:CGRectZero itemWidth:UI_CURRENT_SCREEN_WIDTH*2/3 itemHeight:self.frame.size.height];
    [self addSubview:self.pageView];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.pageControl];
    
    self.pageView.pageControl = self.pageControl;
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.pageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.pageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.pageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.pageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:7.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retateScreen) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)doRetateAction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)retateScreen
{
    CGRect frame = self.frame;
    frame.size.width = UI_CURRENT_SCREEN_WIDTH;
    self.frame = frame;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
