//
//  STListViewController.h
//  StartupTools
//
//  Created by 24k on 16/1/8.
//  Copyright © 2016年 Loopeer. All rights reserved.
//

#import "STBaseViewController.h"
#import "LLArray.h"
@interface STListViewController : STBaseViewController {
    
}

#define WeakSelf __weak typeof(self) weakSelf = self;

@property (strong ,nonatomic) LLArray *dataSource;
@property (assign ,nonatomic) NSInteger pageSize;
@property (assign ,nonatomic) NSInteger currentPage;
@property (assign ,nonatomic) NSInteger totalCount;
@property (strong ,nonatomic) id dataModel;
@property (strong ,nonatomic) UITableView *tableView;
@property (strong ,nonatomic) LLArray *secondaryData;

#pragma mark - defaultAPI
- (void)loadDataWithUrl:(NSString *)url
             HTTPMethod:(STHTTPMethodType)method
            pageEnabled:(BOOL)enable
                 params:(NSMutableDictionary *)params
            isFirstLoad:(BOOL)firstLoad;

#pragma mark - anotherAPI
- (void)loadAnotherDataWithUrl:(NSString *)url
             HTTPMethod:(STHTTPMethodType)method
            pageEnabled:(BOOL)enable
                 params:(NSMutableDictionary *)params
            isFirstLoad:(BOOL)firstLoad;

- (void)generateViewWithResult:(id)result isFirstLoad:(BOOL)firstLoad;

- (void)loadDataIsFirst:(BOOL)first;

@end