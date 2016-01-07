//
//  LPGridView.m
//  StartupTools
//
//  Created by 24k on 15/12/3.
//  Copyright © 2015年 Loopeer. All rights reserved.
//

#import "LPGridView.h"
@implementation LPGridView {
    NSInteger       _rows;
    NSInteger       _columns;
    CGFloat         _itemMargin;
    CGFloat         _leftMargin;
    CGFloat         _rightMargin;
    CGFloat         _topMargin  ;
    CGFloat         _bottomMargin;
    NSInteger       _numberOfMarginInColumns ;
    NSInteger       _numberOfMarginInRows ;
    NSMutableArray  *_viewArrays;
    NSMutableArray  *_horizontalSeparateLineArray;
    NSMutableArray  *_verticalSeparateLineArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _viewArrays = [[NSMutableArray alloc]init];
        _itemWidth  = 0;
        _horizontalSeparateLineArray = [[NSMutableArray alloc]init];
        _verticalSeparateLineArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setupViews {
    if (!_dataSource) {
        return ;
    }
    if (![_dataSource respondsToSelector:@selector(numberOfRowsInGridView:)]) {
        return;
    }
    if (![_dataSource respondsToSelector:@selector(numberOfColumnsInGridView:)]) {
        return;
    }
    if (![_dataSource respondsToSelector:@selector(gridView:itemForIndex:)]) {
        return;
    }
    
     _rows = [_dataSource numberOfRowsInGridView:self];
    _columns = [_dataSource numberOfColumnsInGridView:self];
    //item间距
    _itemMargin               = 0;
    //view左侧距每行第一个item的距离
    _leftMargin                = 0 ;
    _rightMargin               = 0 ;
    _topMargin                 = 0 ;
    _bottomMargin              = 0 ;
    _numberOfMarginInColumns   = _columns +1 ;
    _numberOfMarginInRows      = _rows +1 ;

    for (int i = 0 ; i < _rows; i++) {


        for (int j = 0 ; j < _columns ; j++) {

            GridViewIndex index;
            index.row = i ;
            index.column = j ;
            
            
            UIView * view = [_dataSource gridView:self itemForIndex:index];
            
            if (view  == nil) {
                continue;
            }
            view.tag = 5000 + i *_columns + j;
            [_viewArrays addObject:view];
            
            
            [self addSubview:view];
            if (i == _rows-1 && j == _columns -1) {
                [view setHidden:YES];
            }
            if (i == _rows-1 &&j == 0) {
                [view setHidden:YES];
            }
        }
    }
//    for(int i = 0 ; i<_rows-1;i++){
//        UIView *horizontalLine = [[UIView alloc]init];
//        horizontalLine.backgroundColor = [UIColor ST_F0E9E6_separatorColor];
//        horizontalLine.tag = 6000 + i;
//        [_horizontalSeparateLineArray addObject:horizontalLine];
//        //
//        if (i == 1) {
//            [horizontalLine setHidden:YES];
//        }
//        [self addSubview:horizontalLine];
//    }
//    for (int i = 0; i < _columns-1; i++) {
//        
//        UIView *verticalLine = [[UIView alloc]init];
//        verticalLine.backgroundColor = [UIColor ST_F0E9E6_separatorColor];
//        verticalLine.tag = 7000 +i;
//        [_verticalSeparateLineArray addObject:verticalLine];
//        
//        [self addSubview:verticalLine];
//    }
}

- (void)updateConstraints {
    
    CGFloat itemWidth =  _itemWidth?_itemWidth: (CGRectGetWidth(self.frame) - (_numberOfMarginInColumns - 2)*_itemMargin - _leftMargin  - _rightMargin) /_columns;
    CGFloat itemHeight = (CGRectGetHeight(self.frame) - (_numberOfMarginInRows-2)*_itemMargin - _topMargin - _bottomMargin - 48 - 64)/_rows;

    for (int i = 0 ; i < _rows; i++) {
        for (int j = 0 ; j < _columns ; j++) {
            
            GridViewIndex index;
            index.row = i ;
            index.column = j ;
            UIView *view = _viewArrays[i * _columns+j];
            
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                //|1 |2 |3 |4 |5 |6 |7 |
                //|1 |2 |3 |4 |5 |6 |7 |
                //|1 |2 |3 |4 |5 |6 |7 |
                //|1 |2 |3 |4 |5 |6 |7 |
                //左边margin 从1开始
                //itemWidth 从0开始
                //上面margin 从1开始
                //itemHeight 从0开始
                make.left.equalTo(self).offset(_leftMargin + _itemMargin * j + itemWidth *j);
                make.top.equalTo(self).offset(_topMargin + _itemMargin * i  + itemHeight *i);
                make.width.mas_equalTo(itemWidth);
                make.height.mas_equalTo(itemHeight);
            }];
        }
    }
    
//    for (UIView *horizontalLine in _horizontalSeparateLineArray) {
//        [horizontalLine mas_updateConstraints:^(MASConstraintMaker *make) {
//            //item margin + top margin + item height
//            NSInteger i = horizontalLine.tag - 6000;
//            make.top.mas_equalTo(self).offset(_itemMargin * (i - 1) + _topMargin + itemHeight*(i+1));
//            
//            make.left.mas_equalTo(self).offset(38);
//            make.right.mas_equalTo(self).offset(-38);
//            make.height.mas_equalTo(0.5);
//        }];
//    }
//    
//    for (UIView *verticalLine in _verticalSeparateLineArray) {
//        [verticalLine mas_updateConstraints:^(MASConstraintMaker *make) {
//            NSInteger i = verticalLine.tag - 7000;
//            make.top.mas_equalTo(topItem);
//            
//            make.left.mas_equalTo(self).offset(_itemMargin * (i - 1) + _leftMargin + itemWidth*(i+1));
//            make.bottom.mas_equalTo(bottomItem);
//            make.width.mas_equalTo(0.5);
//        }];
//    }
    
    [super updateConstraints];
}

- (void)gridViewDidTapItem:(UIGestureRecognizer *)recognizer {
    NSLog(@"%ld",recognizer.view.tag);
    NSInteger index = recognizer.view.tag - 5000;
    NSInteger row = index/_columns;
    NSInteger columns = index %_columns;
    GridViewIndex gridIndex;
    gridIndex.row = row;
    gridIndex.column = columns;
    NSLog(@"%ld,%ld",gridIndex.row,gridIndex.column);
    if ([_delegate respondsToSelector:@selector(gridView:didClickItemAtIndex:)]) {
        [_delegate gridView:self didClickItemAtIndex:gridIndex];
    }
}

- (void)setDataSource:(id<LPGridViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self setupViews];
    [self updateConstraints];
}

- (void)setDelegate:(id<LPGridViewDelegate>)delegate {
    _delegate = delegate;
    for (UIView * view in [self subviews]) {
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gridViewDidTapItem:)];
        [view addGestureRecognizer:tap];
    }
}

@end