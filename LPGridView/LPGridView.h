//
//  LPGridView.h
//  StartupTools
//
//  Created by 24k on 15/12/3.
//  Copyright © 2015年 Loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
/**
 *  网格布局View
 */
struct GridViewIndex {
    NSInteger row;
    NSInteger column;
};
typedef struct GridViewIndex GridViewIndex;

@protocol LPGridViewDelegate;
@protocol LPGridViewDataSource;

@interface LPGridView : UIView

@property (weak , nullable, nonatomic) id <LPGridViewDataSource> dataSource;
@property (weak , nullable, nonatomic) id <LPGridViewDelegate> delegate;
@property (assign ,nonatomic)  CGFloat  itemWidth;

@end


@protocol LPGridViewDelegate<NSObject>;

//delegate

//点击事件的处理
@required

/**
 *  GridViewDelegate
 *
 *  @param gridView The view which you pass to achive some action
 *  @param index    The item's index
 */
-(void)gridView:(nullable LPGridView *)gridView didClickItemAtIndex:(GridViewIndex)indexPath;

@end;

@protocol LPGridViewDataSource<NSObject>;

//dataSource
//需要加上index  
@required

- (NSInteger)numberOfRowsInGridView:(nullable LPGridView *)gridView;

- (NSInteger)numberOfColumnsInGridView:(nullable LPGridView *)gridView;


//控件大小
//-(CGSize)gridView:(nullable LPGridView *)gridView sizeForItemAtIndex:(nullable NSIndexPath *)indexPath;


//控件样式
- (nullable UIView *)gridView:(nullable LPGridView *)gridView itemForIndex:(GridViewIndex)indexPath;



@end