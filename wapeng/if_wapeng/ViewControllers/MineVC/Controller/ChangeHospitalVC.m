//
//  ChangeHospitalVC.m
//  if_wapeng
//
//  Created by 心 猿 on 14-12-24.
//  Copyright (c) 2014年 funeral. All rights reserved.
//

#import "ChangeHospitalVC.h"
#import "ChangeCityVC01.h"
#import "ChageCityItem.h"
#import "R04_tableViewItem.h"
#import "UIViewController+General.h"
@interface ChangeHospitalVC ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    AFN_HttpBase * http;
}

@property (nonatomic, strong) UISearchBar * searchBar;

@end

@implementation ChangeHospitalVC


-(id)init
{
    if (self = [super init]) {
        self.dataArray = [[NSMutableArray alloc]init];
        http = [[AFN_HttpBase alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:@"changeCity" object:nil];
    
    UISearchBar * searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 35)];
    searchBar.placeholder = @"医院名称关键字";
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBar.frame), kMainScreenWidth, kMainScreenHeight - 44 - searchBar.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupRefresh:self.tableView];
    [self.view addSubview:self.tableView];
    
//    __weak ChangeHospitalVC * weakSelf = self;
//    [self.tableView addHeaderWithCallback:^{
//        
//    [weakSelf requestHospitalDataWithCity:weakSelf.cityID WithArea:weakSelf.areaID];
//        
//          }];
    
    //创建右边导航栏
    [self createRightItem];
    [self initLeftItem];
    
}

-(void)navItemClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)receiveNoti:(NSNotification *)notify
{
    NSLog(@"%@___%@", self.areaID, self.cityID);
    ChageCityItem * item = notify.object;
    self.cityID = item.mid;
    self.areaID = item.sid;
      NSLog(@"%@___%@", self.areaID, self.cityID);
//    [self requestHospitalDataWithCity:item.mid WithArea:item.sid];
}

- (void)setupRefresh:(UITableView *)newTableView
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [newTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    //    [self.leftTableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    newTableView.headerPullToRefreshText = @"下拉即可刷新";
    newTableView.headerReleaseToRefreshText = @"松开马上刷新";
    newTableView.headerRefreshingText = @"正在刷新";
}
-(void)headerRereshing
{
    [self requestHospitalDataWithCity:self.cityID WithArea:self.areaID];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView headerBeginRefreshing];
}
-(void)changeCity
{
    ChangeCityVC01 * changeCityVC01 = [[ChangeCityVC01 alloc]init];
    [self.navigationController pushViewController:changeCityVC01 animated:YES];
}

-(void)createRightItem
{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"换个城市" style:UIBarButtonItemStyleDone target:self action:@selector(changeCity)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark - uitableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"ID";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    
    if (nil == cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    R04_tableViewItem * item = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    R04_tableViewItem * item = [self.dataArray objectAtIndex:indexPath.row];
    
    
       [self.delegate changeHospitalWithCityID:self.cityID areaID:self.areaID hospitalID:item._id hospitalName:item.name];
//    if ([self.delegate respondsToSelector:@selector(changeHospitalWithCityID:areaID:hospitalID:hospitalName:)]) {
//        
//     
//    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 设置医院所需要的参数hospitalQuery.cityID，hospitalQuery.zoneAreaID
/**获得医院信息**/
-(void)requestHospitalDataWithCity:(NSString *)cityId WithArea:(NSString *)areaId
{
    __weak ChangeHospitalVC * weakSelf = self;

    [http thirdRequestWithUrl:dUrl_PUB_1_2_1 succeed:^(NSObject *obj, BOOL isFinished) {
        
        
        NSLog(@"%@", NSStringFromCGRect(weakSelf.tableView.frame));

        
        NSDictionary* dicResult  = (NSDictionary *)obj;
        
        NSDictionary * valueDic  = [dicResult  objectForKey:@"value"];
        NSString *sValue=[NSString stringWithFormat:@"%@",valueDic];
        if ([sValue isEqualToString:@"<null>"]) {
            [SVProgressHUD showSuccessWithStatus:@"没有数据"];
            [weakSelf.tableView headerEndRefreshing];
            [weakSelf.tableView footerEndRefreshing];
            [weakSelf.tableView reloadData];
            
            return;
        }
        
        NSArray *array=[valueDic objectForKey:@"list"];
        if (array.count==0) {
            [SVProgressHUD showSuccessWithStatus
             :@"没有数据"];
             [weakSelf.tableView headerEndRefreshing];
            return;
        }
        [self.dataArray  removeAllObjects];
        for (int i = 0; i<array.count; i++) {
            R04_tableViewItem * item = [[R04_tableViewItem alloc] init];
            NSDictionary * d1 = [array  objectAtIndex:i];
            NSString  * name = [d1  objectForKey:@"name"];
            NSString  * hospitalId = [d1  objectForKey:@"id"];
            item.name = name;
            item._id = hospitalId;
            [self.dataArray addObject:item];
        }
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [weakSelf.tableView reloadData];
    } failed:^(NSObject *obj, BOOL isFinished) {
        [SVProgressHUD showSuccessWithStatus:@"传参有误"];
    } andKeyValuePairs:@"hospitalQuery.cityID",
     cityId,@"hospitalQuery.zoneAreaID",areaId,@"hospitalQuery.name",self.searchBar.text,nil];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self requestHospitalDataWithCity:self.cityID WithArea:self.areaID];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


@end
