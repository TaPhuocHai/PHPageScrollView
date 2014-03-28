//
//  PHPageScrollView.h
//  PHPageScrollView
//
//  Created by Ta Phuoc Hai on 3/28/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHPageScrollView;
@protocol PHPageScrollViewDelegate <NSObject>
@required
- (NSInteger)numberOfPageInPageScrollView:(PHPageScrollView*)pageScrollView;
@optional
- (CGSize)sizeCellForPageScrollView:(PHPageScrollView*)pageScrollView;
- (void)pageScrollView:(PHPageScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index;

- (void)pageScrollViewWillBeginDragging:(PHPageScrollView *)pageScrollView;
- (void)pageScrollView:(PHPageScrollView*)pageScrollView willScrollToPageAtIndex:(NSInteger)index;
- (void)pageScrollView:(PHPageScrollView*)pageScrollView didScrollToPageAtIndex:(NSInteger)index;
@end

@protocol PHPageScrollViewDataSource <NSObject>
@required
- (UIView*)pageScrollView:(PHPageScrollView*)pageScrollView viewForRowAtIndex:(int)index;
@end

@interface PHPageScrollView : UIView

@property (nonatomic)           CGFloat   padding;
@property (nonatomic, readonly) NSInteger currentPageIndex;

@property (nonatomic, assign) id<PHPageScrollViewDataSource> dataSource;
@property (nonatomic, assign) id<PHPageScrollViewDelegate> delegate;

- (void)reloadData;
- (void)scrollToPage:(NSUInteger)pageNumber animation:(BOOL)animation;
- (void)deleteViewAtIndex:(NSInteger)index animated:(BOOL)animated;

- (UIView*)viewForRowAtIndex:(NSInteger)index;

@end
