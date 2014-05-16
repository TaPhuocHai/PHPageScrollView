PHPageScrollView
================

* A UIView subclass that allows scrolling of multiple pages
* Support storyboard.
* Like UITableView, PHPageScrollView define both a dataSource and a delegate. It flexible for implement.
* Have function : deleteViewAtIndex for delete any view in PHPageScrollView

## Examples

<img src="https://raw.githubusercontent.com/taphuochai/PHPageScrollView/master/example.png"/ width=320 height=480>


## Usage

* Init and set property

         self.pageScrollView.delegate = self;
         self.pageScrollView.dataSource = self;
         
* Call `reloadData` to load view

         [self.pageScrollView reloadData];
         
* Implement `PHPageScrollViewDelegate` and `PHPageScrollViewDataSource` 
* Scroll to page

         - (void)scrollToPage:(NSUInteger)pageNumber animation:(BOOL)animation;      
         
* Delete a page

		- (void)deleteViewAtIndex:(NSInteger)index animated:(BOOL)animated;
		
* Get page
		
		- (UIView*)viewForRowAtIndex:(NSInteger)index;
		         

## Requirements

* iOS 5.0 through iOS 7.0 or later.
* ARC memory management.


## License

Copyright (c) 2014 Phuoc Hai <taphuochai@gmail.com>

PHPageScrollView is licensed under MIT License Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software