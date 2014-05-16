//
//  PHPageScrollView.m
//  PHPageScrollView
//
//  Created by Ta Phuoc Hai on 3/28/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHPageScrollView.h"

@interface PHPageScrollView () <UIScrollViewDelegate>

@property (nonatomic, readonly) float          leftRightOffset;
@property (nonatomic, strong)   UIScrollView * scrollView;
@property (nonatomic, strong)   UIPanGestureRecognizer * panGesture;
@property (nonatomic, strong)   NSMutableArray * viewsInPage;

@end

@implementation PHPageScrollView {
    CGPoint   _firstCenterPoint;
    CGSize    _cellSize;
    NSInteger _numberOfCell;
    
    CGPoint  _lastVelocityScrollView;
}

- (void)initializeValue
{
    _padding = 10;
    _currentPageIndex = 0;
    self.clipsToBounds = YES;
}

- (void)awakeFromNib
{
    [self initializeValue];
    [self reloadData];
}

- (void)reloadData
{
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(numberOfPageInPageScrollView:)]) {
        return;
    }
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(pageScrollView:viewForRowAtIndex:)]) {
        return;
    }
    
    // Default size
    _cellSize.width = self.frame.size.width - self.padding * 2 - 10 * 2;
    // User size
    if ([self.delegate respondsToSelector:@selector(sizeCellForPageScrollView:)]) {
        _cellSize = [self.delegate sizeCellForPageScrollView:self];
    }
    
    _numberOfCell = [self.delegate numberOfPageInPageScrollView:self];
    
    float startX = self.leftRightOffset;
    float topY   = (self.frame.size.height - _cellSize.height)/2;
    
    // Remove all old view
    [[self.scrollView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    // Clean up
    self.viewsInPage = nil;
    self.viewsInPage = [NSMutableArray array];
    
    // Add cell
    for (int i = 0; i < _numberOfCell; i ++) {
        UIView * cell = [self.dataSource pageScrollView:self viewForRowAtIndex:i];
        cell.frame = CGRectMake(startX, topY, _cellSize.width, _cellSize.height);
        [self.scrollView addSubview:cell];
        startX += self.padding + _cellSize.width;
        [self.viewsInPage addObject:cell];
    }
    
    // Add right padding
    float scrollViewSizeWith = startX - self.padding + (self.frame.size.width - _cellSize.width)/2;
    self.scrollView.contentSize = CGSizeMake(scrollViewSizeWith, 1);
}

- (UIView*)viewForRowAtIndex:(NSInteger)index
{
    if (index < self.viewsInPage.count) {
        return self.viewsInPage[index];
    }
    return nil;
}

- (void)deleteViewAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (!self.viewsInPage.count) return;
    UIView * viewForDelete = [self viewForRowAtIndex:index];
    if (!viewForDelete) return;
    
    // Shift left
    for (int i = index + 1; i < _numberOfCell; i ++) {
        UIView * view = [self viewForRowAtIndex:i];
        
        CGRect newFrame = view.frame;
        newFrame.origin.x -= (_cellSize.width + self.padding);
        if (animated) {
            [UIView animateWithDuration:0.35 animations:^{
                view.frame = newFrame;
            }];
        } else {
            view.frame = newFrame;
        }
    }
    
    // Animation hiden
    if (animated) {
        [UIView animateWithDuration:0.35 animations:^{
            viewForDelete.alpha = 0;
        }completion:^(BOOL finished) {
            [self.viewsInPage removeObject:viewForDelete];
        }];
    } else {
        viewForDelete.alpha = 0;
        [self.viewsInPage removeObject:viewForDelete];
    }
    _numberOfCell --;
    
    // Update scrollView contentSize
    CGSize newSize = self.scrollView.contentSize;
    newSize.width -= (_cellSize.width + self.padding);
    if (animated) {
        [UIView animateWithDuration:0.35 animations:^{
            self.scrollView.contentSize = newSize;
        }completion:^(BOOL finished) {
            [self updateCurrentPage];
        }];
    } else {
        self.scrollView.contentSize = newSize;
        [self updateCurrentPage];
    }
}

#pragma mark - Animation

- (void)scrollToPage:(NSUInteger)pageNumber animation:(BOOL)animation
{
    float changeOffset = 0;
    if (pageNumber) {
        changeOffset = (_cellSize.width * pageNumber) + (self.padding*pageNumber);
        if (changeOffset >= self.scrollView.contentSize.width) {
        }
    }
    
    if (changeOffset == self.scrollView.contentOffset.x) {
        return;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageScrollView:willScrollToPageAtIndex:)]) {
        [self.delegate pageScrollView:self willScrollToPageAtIndex:pageNumber];
    }
    
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.contentOffset = CGPointMake(changeOffset, 0);
        }completion:^(BOOL finished) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(pageScrollView:didScrollToPageAtIndex:)]) {
                [self.delegate pageScrollView:self didScrollToPageAtIndex:pageNumber];
            }
        }];
    } else {
        self.scrollView.contentOffset = CGPointMake(changeOffset, 0);
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(pageScrollView:didScrollToPageAtIndex:)]) {
            [self.delegate pageScrollView:self didScrollToPageAtIndex:pageNumber];
        }
    }
}

#pragma mark - Properties

- (NSMutableArray*)viewsInPage
{
    if (!_viewsInPage) {
        _viewsInPage = [NSMutableArray array];
    }
    return _viewsInPage;
}

- (void)setPadding:(CGFloat)padding
{
    [self reloadData];
}

- (UIPanGestureRecognizer*)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
    return _panGesture;
}

- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizesSubviews = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.multipleTouchEnabled = NO;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (float)leftRightOffset
{
    return (self.frame.size.width - _cellSize.width)/2;
}

#pragma mark - Action

- (void)handlePanGesture:(UIPanGestureRecognizer*)panGesture
{
    CGPoint translatedPoint = [panGesture translationInView:self];
    
    if ([panGesture state] == UIGestureRecognizerStateBegan) {
        _firstCenterPoint = self.center;
    }
    translatedPoint = CGPointMake(_firstCenterPoint.x+translatedPoint.x, _firstCenterPoint.y);
    self.center = translatedPoint;
    
    if ([panGesture state] == UIGestureRecognizerStateEnded) {
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _lastVelocityScrollView = CGPointMake(0, 0);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageScrollViewWillBeginDragging:)]) {
        [self.delegate pageScrollViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updateCurrentPage];
        [self scrollToPage:self.currentPageIndex animation:YES];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    
    [self updateCurrentPage];
    if (ABS(_lastVelocityScrollView.x) > 0.5) {
        // next
        if (_lastVelocityScrollView.x > 0.5) {
            if (_currentPageIndex + 1 < _numberOfCell) {
                _currentPageIndex += 1;
            }
        }
        // prev
        else {
            if (_currentPageIndex - 1 >= 0) {
                _currentPageIndex -= 1;
            }
        }
    }
    
    [self scrollToPage:self.currentPageIndex animation:YES];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    _lastVelocityScrollView = velocity;
}


//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self updateCurrentPage];
//    [self scrollToPage:self.currentPageIndex animation:YES];
//}

#pragma mark -

- (void)updateCurrentPage
{
    float leftRightPadding = self.leftRightOffset;
    // Find index page
    float leftCompare = leftRightPadding;
    int   currentIndexFinding = 0;
    
    if (self.scrollView.contentOffset.x <= leftRightPadding + _cellSize.width/2) {
        _currentPageIndex = 0;
    } else {
        currentIndexFinding ++;
        leftCompare += _cellSize.width + self.padding;
        for (int i = 1; i < _numberOfCell; i ++) {
            if (self.scrollView.contentOffset.x > leftCompare + _cellSize.width/2) {
                currentIndexFinding ++;
                leftCompare += _cellSize.width + self.padding;
            } else {
                break;
            }
        }
        _currentPageIndex = currentIndexFinding;
    }
}

#pragma mark - Clean up

- (void)dealloc
{
    _viewsInPage = nil;
    [[self.scrollView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
}

@end
