//
//  ViewController.m
//  RefreshViewTest
//
//  Created by sam on 2019/6/25.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ViewController.h"
#import "HJRefreshView.h"
#import "HJFootRefreshView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,HJRefreshViewDelegate,HJFootRefreshViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) HJRefreshView *refreshView;
@property (nonatomic,strong) HJFootRefreshView *footRefreshView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    self.dataArray = [NSMutableArray array];
    for (int i = 0; i < 18; i++) {
        [self.dataArray addObject:@"12121"];
    }
    
    self.refreshView = [[HJRefreshView alloc] initWithTargeView:self.tableView];
    self.refreshView.delegate = self;
    
    self.footRefreshView = [[HJFootRefreshView alloc] initWithTargeView:self.tableView];
    self.footRefreshView.delegate = self;
    
}

//下拉到可以刷新的位置时候调用
- (void)pullToRefreshViewDidStartLoading {
    [self.refreshView startRefresh];
    
    static int num1 = 0;
    dispatch_async(dispatch_queue_create("queue", NULL), ^{
        sleep(2);
        for (int i = 0; i < 10; i++) {
            num1++;
            [self.dataArray insertObject:[NSString stringWithFormat:@"下拉刷新的第%d数据",num1] atIndex:0];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshView stopRefresh];
            [self.footRefreshView setNeedsLayout];
            [self.tableView reloadData];
        });
    });
    
    
}

//上拉到可以刷新的位置时候调用
- (void)pullUpToRefreshViewDidStartLoading {
    [self.footRefreshView startRefresh];
    
    static int num2 = 0;
    dispatch_async(dispatch_queue_create("queue", NULL), ^{
        sleep(2);
        for (int i = 0; i < 10; i++) {
            num2++;
            [self.dataArray addObject:[NSString stringWithFormat:@"上拉加载的第%d数据",num2]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.footRefreshView stopRefresh];
            
        });
    });
}

- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    self.tableView.rowHeight = 40;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
@end
