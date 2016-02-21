//
//  STListViewController.m
//  StartupTools
//
//  Created by 24k on 16/1/8.
//  Copyright © 2016年 Loopeer. All rights reserved.
//

#import "STListViewController.h"
#import "LLArray.h"
#import "SVPullToRefresh.h"

@implementation STListViewController {
    
}

#pragma mark - lifeCycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

-(void)loadView{
    [super loadView];
    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor ST_F0E9E6_separatorColor];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self customRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataIsFirst:YES];
}

- (void)updateViewConstraints {
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [super updateViewConstraints];
}

#pragma mark - API

- (void)loadDataWithUrl:(NSString *)url
             HTTPMethod:(STHTTPMethodType)method
            pageEnabled:(BOOL)enable
                 params:(NSMutableDictionary *)params
            isFirstLoad:(BOOL)firstLoad{
    switch (method) {
        case STHTTPMethodTypeGet:{
            [self getDataWithUrl:url pageEnabled:enable params:[params mutableCopy] isFirstLoad:firstLoad isDefaultApi:YES];
            break;
        }
        case STHTTPMethodTypePost:{
            [self postDataWithUrl:url pageEnabled:enable params:[params mutableCopy] isFirstLoad:firstLoad isDefaulApi:YES];
            break;
        }
            
        default:
            break;
    }
    
}

- (void)loadAnotherDataWithUrl:(NSString *)url
                    HTTPMethod:(STHTTPMethodType)method
                   pageEnabled:(BOOL)enable
                        params:(NSMutableDictionary *)params
                   isFirstLoad:(BOOL)firstLoad {
    switch (method) {
        case STHTTPMethodTypeGet:{
            [self getDataWithUrl:url pageEnabled:enable params:[params mutableCopy] isFirstLoad:firstLoad isDefaultApi:NO];
            break;
        }
        case STHTTPMethodTypePost:{
            [self postDataWithUrl:url pageEnabled:enable params:[params mutableCopy] isFirstLoad:firstLoad isDefaulApi:NO];
            break;
        }
            
        default:
            break;
    }
}

- (void)getDataWithUrl:(NSString *)url
           pageEnabled:(BOOL)enable
                params:(NSMutableDictionary *)params
           isFirstLoad:(BOOL)firsLoad
          isDefaultApi:(BOOL)isDefault {
    if (enable) {
        if (firsLoad) {
            params[@"page"] = @1;
        } else {
            params[@"page"] = @(_dataSource.page + 1);
        }
        if (_dataSource.pageSize == 0) {
            params[@"page_size"] = @10;
        } else {
            params[@"page_size"] = @(_dataSource.pageSize);
        }
    }
    [[LPNetworkRequest sharedInstance]GET:url parameters:params startImmediately:YES configurationHandler:^(LPNetworkRequestConfiguration *configuration) {
        NSNumber *flag = [NSNumber numberWithBool:([self.dataSource count]>0)?1:0];
        configuration.userInfo = @{kLPNetworkRequestShowLoadingDisable:flag};
    } completionHandler:^(NSError *error, id result, BOOL isFromCache, AFHTTPRequestOperation *operation) {
        [self dealWithData:result isFirstLoad:firsLoad];
        [self generateViewWithResult:result isFirstLoad:firsLoad];
    }];
}

- (void)postDataWithUrl:(NSString *)url
            pageEnabled:(BOOL)enable
                 params:(NSMutableDictionary *)params
            isFirstLoad:(BOOL)firsLoad
            isDefaulApi:(BOOL)isDefault {
    if (enable) {
        if (firsLoad) {
            params[@"page"] = @1;
        } else {
            params[@"page"] = @(_dataSource.page + 1);
        }
        if (_dataSource.pageSize == 0) {
            params[@"page_size"] = @10;
        } else {
            params[@"page_size"] = @(_dataSource.pageSize);
        }
    }
    [[LPNetworkRequest sharedInstance]POST:url parameters:params startImmediately:YES configurationHandler:^(LPNetworkRequestConfiguration *configuration) {
        NSNumber *flag = [NSNumber numberWithBool:([self.dataSource count]>0)?1:0];
        configuration.userInfo = @{kLPNetworkRequestShowLoadingDisable:flag};
    } completionHandler:^(NSError *error, id result, BOOL isFromCache, AFHTTPRequestOperation *operation) {
        [self dealWithData:result isFirstLoad:firsLoad];
        [self generateViewWithResult:self.dataSource isFirstLoad:firsLoad];
    }];
}

#pragma mark - generateData

- (void)dealWithData:(id)result isFirstLoad:(BOOL)firstLoad{
    NSArray *array = [MTLJSONAdapter modelsOfClass:[self.dataModel class] fromJSONArray:result[@"data"] error:nil];
    
    //分页
    if (firstLoad) {
        _dataSource = [[LLArray alloc] init];
    } else {
        _totalCount = [self.dataSource count];
    }
    [_dataSource addObjectsFromArray:array];
    _dataSource.page = [result[@"page"] integerValue];
    _dataSource.pageSize = [result[@"page_size"] integerValue];
    _dataSource.totalSize = [result[@"total_size"] integerValue];
}

- (void)generateViewWithResult:(id)result isFirstLoad:(BOOL)firstLoad {
    NSLog(@"mustOverrideThisMethod");
    NSArray *array = result[@"data"];
    
    if (firstLoad) {
        [self.tableView reloadData];
    } else {
        NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < array.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.totalCount + i inSection:0];
            [indexPathArray addObject:indexPath];
        }
        if (indexPathArray.count > 0) {
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
    }
    
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView.infiniteScrollingView stopAnimating];
    if (![self.dataSource hasMore]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.infiniteScrollingView.enabled = NO;
            self.tableView.showsInfiniteScrolling = NO;
        });
    } else {
        self.tableView.infiniteScrollingView.enabled = YES;
        self.tableView.showsInfiniteScrolling = YES;
    }
}

- (void)loadDataIsFirst:(BOOL)first {
    
}

-(void)customRefresh{
    WeakSelf;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadDataIsFirst:YES];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadDataIsFirst:NO];
    }];
}

@end