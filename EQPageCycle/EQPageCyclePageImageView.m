//
//  EQPageCyclePageImageView.m
//  EQPageCycle
//
//  Created by Eason Qian on 15/9/10.
//  Copyright (c) 2015年 Eason Qian. All rights reserved.
//

#import "EQPageCyclePageImageView.h"

@interface EQPageCyclePageImageView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic) NSUInteger totalPageCount;
@property (nonatomic) NSUInteger pageCount;
@property (nonatomic) CGFloat itemWidth;
@property (nonatomic) CGFloat itemGapWidth;
@property (nonatomic) NSUInteger animateNum;

@property (nonatomic, strong) NSTimer *weakTimer;
@property (nonatomic, strong) NSMutableArray *itemPages;

@end

@implementation EQPageCyclePageImageView

- (instancetype)initWithFrame:(CGRect)frame itemWidth:(CGFloat)itemWidth itemHeight:(CGFloat)itemHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemWidth = itemWidth;
        self.itemHeight = itemHeight;
        self.itemGapWidth = (UI_CURRENT_SCREEN_WIDTH-itemWidth)/2;
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];
        [self p_EQPageCyclePageImageView_setup];
    }
    return self;
}

- (void)p_EQPageCyclePageImageView_setup
{
    self.interval = 5.f;
    self.itemPages = [NSMutableArray new];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    [self addSubview:self.scrollView];
    self.scrollView.delegate = self;
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:self.itemGapWidth]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-self.itemGapWidth]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRetateAction) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark- Property
- (NSUInteger)totalPageCount
{
    if (self.disableCycle) {
        return self.pageCount;
    }
    else {
        return self.pageCount ? (self.pageCount + 4) : 0;
    }
}

#pragma mark- PubliceInterface
- (void)reloadData
{
    [self updateConstraintsIfNeeded];
    [self.weakTimer invalidate];
    [self.itemPages makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemPages removeAllObjects];
    
    self.pageCount = [self.dataSource numberOfPagesInPageView:self];
    if (self.pageCount <= 1) {
        self.disableAutoRunPage = YES;
        self.scrollView.scrollEnabled = NO;
    } else {
        self.disableAutoRunPage = NO;
        self.scrollView.scrollEnabled = YES;
    }
    
    self.pageControl.numberOfPages = self.pageCount;
    CGFloat y = 0;
    CGFloat x = 0;
    CGFloat itemHeight = self.itemHeight;
    for (NSInteger index = 0; index < self.totalPageCount; index++) {
        x = index * self.itemWidth;
        CGRect frame = CGRectMake(x, y, self.itemWidth, itemHeight);
        UILabel *lableItem = [[UILabel alloc] initWithFrame:frame];
        lableItem.backgroundColor = [self randomColor];
        lableItem.text = [NSNumber numberWithInteger:index].stringValue;
        lableItem.textAlignment = NSTextAlignmentCenter;
        
        if (index == self.startPageIndex) {
            lableItem.alpha = 1;
        }else{
            lableItem.alpha = 0.5;
        }
        [self.scrollView addSubview:lableItem];
        [self.itemPages addObject:lableItem];
    }
    
    self.scrollView.contentSize = CGSizeMake(x + self.itemWidth, itemHeight);
    [self showPageAtCurrentRow:self.startPageIndex animated:YES];
    [self bringSubviewToFront:self.pageControl];
    [self runAutoPage];
}

#pragma mark- PrivateInterface

- (void)runAutoPage
{
    [self.weakTimer invalidate];
    self.weakTimer = nil;
    if (self.totalPageCount && !self.disableAutoRunPage) {
        
        __weak typeof(self)weakSelf = self;
        self.weakTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:weakSelf selector:@selector(runCyclePageImageView) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.weakTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)showPageAtCurrentRow:(NSInteger )currentRow animated:(BOOL)animated
{
    if (currentRow == 0) {
        currentRow = self.pageCount;
    }
    CGPoint contentOffset = CGPointMake(currentRow * self.itemWidth, 0);
    
    //第一次进来offset相等导致图片alpha = 0.5的bug
    if (self.scrollView.contentOffset.x == contentOffset.x) {
        [self animationInRow:currentRow];
    }else{
        [self.scrollView setContentOffset:contentOffset animated:animated];
    }
}

- (void)runCyclePageImageView
{
    if (self.totalPageCount && !self.disableAutoRunPage)
    {
        CGPoint offset = self.scrollView.contentOffset;
        NSInteger row =  offset.x / self.itemWidth;
        NSInteger currentRow = row + 1;
        [self showPageAtCurrentRow:currentRow animated:YES];
    }
}

- (void)setDisableAutoRunPage:(BOOL)disableAutoRunPage
{
    _disableAutoRunPage = disableAutoRunPage;
    [self runAutoPage];
}

- (void)showPageToNext:(BOOL)next
{
    [self.weakTimer invalidate];
    CGPoint offset = self.scrollView.contentOffset;
    NSInteger row =  offset.x / self.itemWidth;
    NSInteger currentRow = row;
    
    if (next) {
        currentRow = row + 1;
    } else {
        currentRow = row - 1;
    }
    [self showPageAtCurrentRow:currentRow animated:YES];
    [self runAutoPage];
}

- (void)animationInRow:(NSInteger)row
{
    self.animateNum = row;
    UILabel *lableView = (UILabel *)[self.itemPages objectAtIndex:row];
    if (!lableView) {
        return;
    }
    [self.itemPages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *itemView = (UILabel *)obj;
        if (idx != row) {
            itemView.alpha = 0.5;
        }
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        lableView.alpha = 1;
    }];
    
    // NSLog(@"%s   %li", __PRETTY_FUNCTION__, (long)row);
}

- (void)doRetateAction
{
    self.itemWidth = (UI_CURRENT_SCREEN_WIDTH - 2*self.itemGapWidth);
    self.startPageIndex = self.animateNum;
    [self reloadData];

}

- (UIColor *)randomColor
{
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return color;
}

#pragma mark - <UIScrollViewDelegate>

/**
 *  这个代理才是scrollView开始拖动时调用的
 *
 *  @param scrollView
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    [self.weakTimer invalidate];
    
    CGPoint offset = scrollView.contentOffset;
    NSInteger row =  offset.x / self.itemWidth;
    if (row == 0) {
        [self.scrollView setContentOffset:CGPointMake(self.pageCount * self.itemWidth, 0)animated:NO];
    }else if (row >= (self.totalPageCount - 2)){
        [self.scrollView setContentOffset:CGPointMake(row%self.pageCount * self.itemWidth, 0)animated:NO];
    }
    NSInteger currentPageCount = row % self.pageCount;
    self.pageControl.currentPage = currentPageCount;
    
    //        NSLog(@"%s  row = %li ", __PRETTY_FUNCTION__, (long)row);
}

- (void)scrollViewDidEnded:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    NSInteger row =  offset.x / self.itemWidth;
    
    if (row >= (self.totalPageCount - 2)){
        [self.scrollView setContentOffset:CGPointMake(row%self.pageCount * self.itemWidth, 0)animated:NO];
    }
    
    NSInteger currentPageCount = row % self.pageCount;
    self.pageControl.currentPage = currentPageCount;
    if ([self.delegate respondsToSelector:@selector(pageView:didChangeToIndex:)]) {
        [self.delegate pageView:self didChangeToIndex:currentPageCount];
        if (self.disableCycle) {
            if (currentPageCount == self.pageCount - 1) {
                [self.delegate pageViewScrollEndOfPage:self];
            }
        }
    }
    [self animationInRow:row >= (self.totalPageCount - 2)?currentPageCount:row];
    
    // NSLog(@"%s  row = %li ", __PRETTY_FUNCTION__, (long)row);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    /**
     * 拖拽结束后如果没有减速动画(即decelerate = NO)，那么拖拽才算真正的结束
     * 接下来的scrollViewWillBeginDecelerating、scrollViewDidEndDecelerating这两个代理方法也不会被调用
     */
    
    if (!decelerate) {
        [self scrollViewDidEnded:scrollView];
        [self runAutoPage];
    }
    
    //        NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEnded:scrollView];
    [self runAutoPage];
    
    //        NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEnded:scrollView];
    
    //        NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //        NSLog(@"%s", __PRETTY_FUNCTION__);
}


@end
