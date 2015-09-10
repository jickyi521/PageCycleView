//
//  ViewController.m
//  EQPageCycle
//
//  Created by Eason Qian on 15/9/10.
//  Copyright (c) 2015年 Eason Qian. All rights reserved.
//


#import "ViewController.h"
#import "EQBannerView.h"
#import "EQPageCyclePageImageView.h"

@interface ViewController ()<EQPageCyclePageImageViewDataSource>

@property (strong, nonatomic) EQBannerView *bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.bannerView = [[EQBannerView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 150)];
    [self.view addSubview:self.bannerView];
    [self.bannerView setupBannerView];
     self.bannerView.pageView.dataSource = self;
    [self.bannerView.pageView reloadData];
}

#pragma mark - <OTSCyclePageImageViewDataSource> && <OTSCyclePageImageViewDelegate>

- (NSUInteger)numberOfPagesInPageView:(EQPageCyclePageImageView *)aPageView
{
    return 10;
}

- (void)pageView:(EQPageCyclePageImageView *)aPageView didSelectedPageAtIndex:(NSUInteger)aIndex
{
    
}


@end
