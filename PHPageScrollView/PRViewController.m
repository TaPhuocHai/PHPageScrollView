//
//  PRViewController.m
//  PHPageScrollView
//
//  Created by Ta Phuoc Hai on 3/28/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PRViewController.h"
#import "PHPageScrollView.h"

@interface PRViewController () <PHPageScrollViewDataSource, PHPageScrollViewDelegate>

@property (weak, nonatomic) IBOutlet PHPageScrollView *pageScrollView;

@end

@implementation PRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageScrollView.delegate = self;
    self.pageScrollView.dataSource = self;
    [self.pageScrollView reloadData];
}

- (IBAction)deleteButtonTouch:(id)sender
{
    [self.pageScrollView deleteViewAtIndex:self.pageScrollView.currentPageIndex animated:YES];
}

#pragma mark -

- (NSInteger)numberOfPageInPageScrollView:(PHPageScrollView*)pageScrollView
{
    return 6;
}

- (CGSize)sizeCellForPageScrollView:(PHPageScrollView*)pageScrollView
{
    return CGSizeMake(280, 280);
}

- (UIView*)pageScrollView:(PHPageScrollView*)pageScrollView viewForRowAtIndex:(int)index
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 280)];
    view.backgroundColor = [UIColor yellowColor];
    return view;
}

- (void)pageScrollView:(PHPageScrollView*)pageScrollView didScrollToPageAtIndex:(NSInteger)index
{
    
}

- (void)pageScrollView:(PHPageScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index
{
    
}

@end
