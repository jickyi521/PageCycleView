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
    self.bannerView = [[EQBannerView alloc] initWithFrame:CGRectMake(0, 64, UI_CURRENT_SCREEN_WIDTH, 150)];
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

//#pragma mark -Roate Screen

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration//for  ios7
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self roateScreen];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator//for ios8 up
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self roateScreen];
}

- (void)roateScreen
{
    
//    CGRect frame = self.bannerView.frame;
//    frame.size.width = UI_CURRENT_SCREEN_WIDTH;
//    self.bannerView.frame = frame;
}

@end
