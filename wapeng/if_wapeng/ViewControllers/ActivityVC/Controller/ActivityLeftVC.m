//
//  ActivityLeftVC.m
//  if_wapeng
//
//  Created by 心 猿 on 14-8-7.
//  Copyright (c) 2014年 funeral. All rights reserved.
//
//nameArray = @[@[@"商家组织的活动", @"个人组织的活动", @""], @[@"今日十大", @"分类活动", @"",@"我的活动", @"text"]];
typedef NS_ENUM(NSInteger, ACT_LIST_1)
{
    ACT_SELLER = 0,//商家活动
    ACT_PERSION = 1//个人活动
};

typedef NS_ENUM(NSInteger, ACT_LIST_2)
{
    ACT_TEN= 0, //今日十大
    ACT_CAREGORY = 1,//分类活动
    ACT_MYACT = 3//我的活动
};
#define SECTION_0            0
#define SECTION_1            1
#define PARENT_USER          1 //家长用户
#define TEACTER_USER         2 //教师用户
#define OGANIZATION_USER     3 //机构用户
#define dTagHeaderBtn        100
#define kMaxTag              100
#import <QuartzCore/QuartzCore.h>
#import "ActivityLeftVC.h"
#import "SVProgressHUD.h"
#import "SellerAcitvityVC.h"//商家活动， 搜索结果等
#import "CommonVC.h"
#import "CommonVC02.h"
#import "UIViewController+MMDrawerController.h"
#import "AllActivityVC.h"
#import "WaterFlowVC.h"
#import "ChildBrowserVC.h"

#import "UIColor+AddColor.h"
#import "AppDelegate.h"
#import "Cell_ActivityLeft.h"
#import "MyDatumVC.h"
#import "ASIViewController.h"
#import "ASIVC02.h"
#import "ASIVC03.h"

#import "UserInfoConnectionTask.h"
#import "UIButton+AFNetworking.h"
@interface ActivityLeftVC ()<getUserInfoDelegate>
{
     AppDelegate * app;
}
@end

@implementation ActivityLeftVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _hotWordArr = [[NSMutableArray alloc]init];
    }
    return self;
}

//在这里获得热词
-(void)viewWillAppear:(BOOL)animated
{
    //让中菜单的子菜单隐藏键盘
    [[NSNotificationCenter defaultCenter] postNotificationName:dNoti_HiddenLeftKeyBoard object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
     self.navigationController.navigationBar.hidden = NO;
}

///获得热词
-(void)getHotWord
{
    NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
    NSString * ddid = [d objectForKey:UD_ddid];
    AFN_HttpBase * afn = [[AFN_HttpBase alloc]init];
    
    __weak ActivityLeftVC * weakSelf = self;
    
    [afn thirdRequestWithUrl:dUrl_ACT_1_1_1 succeed:^(NSObject *obj, BOOL isFinished) {
        
        NSDictionary * dict = (NSDictionary *)obj;
        
        NSArray * list = [[dict objectForKey:@"value"] objectForKey:@"list"];
        
        for (NSDictionary * dict in list) {
            
            NSString * hotWord = [NSString stringWithFormat:@"%@", [dict objectForKey:@"content"]];
            //添加热词
            [weakSelf.hotWordArr addObject:hotWord];
        }
        
        NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
        
        [d setObject:weakSelf.hotWordArr forKey:UD_hotWord];
        
    } failed:^(NSObject *obj, BOOL isFinished) {
        
    } andKeyValuePairs:@"D_ID", ddid, @"activitySearchWordQuery.pageNum", @"1", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createUI];
    
    UserInfoConnectionTask * task = [[UserInfoConnectionTask alloc]init];
    
    task.tag = kMaxTag;
    
    task.delegate = self;
    
    [task getUserInfo];
    
    app = [AppDelegate shareInstace];
}

//创建UI
-(void)createUI
{
    //虚拟的nav
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 88)];
    navView.backgroundColor = [UIColor whiteColor];
    navView.backgroundColor = kRGB(76, 108, 200);
    UIButton * headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    headButton.tag = dTagHeaderBtn;
    
    headButton.frame = CGRectMake(30, 19, 60, 60);
    headButton.layer.masksToBounds = YES;
    headButton.layer.cornerRadius = 8;
    headButton.layer.borderWidth = 5;
    headButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    [headButton setImage:[UIImage imageNamed:@"saga2.jpg"] forState:UIControlStateNormal];
    
    [headButton addTarget:self action:@selector(headerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:headButton];
    
    UILabel * acitiLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, headButton.frame.origin.y , 100, 24)];
    acitiLabel.text = @"活动";
    acitiLabel.textColor = [UIColor whiteColor];
    [navView addSubview:acitiLabel];
    
    UILabel * nickNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(120, headButton.frame.origin.y + 30, 100, 24)];
    nickNameLbl.textColor = [UIColor colorWithHexString:@"#949494"];
    nickNameLbl.text = [app.loginDict objectForKey:@"petName"];
    nickNameLbl.font = [UIFont systemFontOfSize:13];
    [navView addSubview:nickNameLbl];
    
    [self.view addSubview:navView];
    
//    self.tableView.tableHeaderView = navView;
    
    nameArray = @[@[@"商家组活动", @"个人活动", @""], @[@"今日十大", @"",@"我的活动",@"", @"text", @"text2"]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(navView.frame), kMainScreenWidth, kMainScreenHeight - CGRectGetHeight(navView.frame)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#30353b"];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.separatorColor = [UIColor grayColor];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark --点击头像进入个人资料
-(void)headerButtonClick
{
    UserInfoConnectionTask * task = [[UserInfoConnectionTask alloc]init];
    task.tag = kMaxTag + 1;
    task.delegate = self;
    [task getUserInfo];
}

#pragma mark--tableViewDeleagte

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * name = @[@"   身边", @"   全网"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, kMainScreenWidth, 30)];
    label.textColor = [UIColor grayColor];
    label.text = name[section];
    return label;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [nameArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[nameArray objectAtIndex:section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell * cell = [[Cell_ActivityLeft alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor colorWithHexString:@"#30353b"];
    UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth * 0.618, CGRectGetHeight(cell.frame))];
    la.text = [[nameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    la.textColor = [UIColor whiteColor];
    la.font = [UIFont systemFontOfSize:14];
    la.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:la];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - 左菜单
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    switch (indexPath.section) {
        case SECTION_0:
        {
            switch (indexPath.row) {
                case ACT_SELLER:
                {
                    SellerAcitvityVC * vc = [[SellerAcitvityVC alloc]init];
                    vc.pageType = 3;
                    vc.title = @"商家活动";
                    [app.mTbc reloadTBCWithController:vc];
                }
                    break;
                case ACT_PERSION:
                {
                    CommonVC02 * vc = [[CommonVC02 alloc]init];
                    vc.title = @"用户活动";
                    vc.pageType = 2;
                    [app.mTbc reloadTBCWithController:vc];
                }
                    break;
                case 2:
                {
                    NSLog(@"占位");
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case SECTION_1:
        {
            switch (indexPath.row) {
                case ACT_TEN:
                {
                    CommonVC * vc = [[CommonVC alloc]init];
                    vc.title = @"今日十大";
                    vc.pageType = 1;
                    [app.mTbc reloadTBCWithController:vc];
                    
                }
                    break;
                case ACT_CAREGORY:
                {
                    WaterFlowVC * waterVC = [[WaterFlowVC alloc]init];
                    waterVC.loginDict = app.loginDict;
                    [app.mTbc reloadTBCWithController:waterVC];
                }
                    break;
                case 2:
                {
                    
                    CommonVC02 * vc = [[CommonVC02 alloc]init];
                    //                    vc.vcType = vc_userActivity;
                    vc.pageType = 1;
                    vc.title = @"我的活动";
                    [app.mTbc reloadTBCWithController:vc];
                    
                }
                    break;
                case ACT_MYACT:
                {
//                    CommonVC02 * vc = [[CommonVC02 alloc]init];
////                    vc.vcType = vc_userActivity;
//                    vc.pageType = 1;
//                    vc.title = @"我的活动";
//                    [app.mTbc reloadTBCWithController:vc];
                    
                }
                    break;
                case 4:
                {
                    //测试用的
                    ASIViewController * asi = [[ASIViewController alloc]init];
                    [app.mTbc reloadTBCWithController:asi];
                }
                    break;
                case 5:
                {
//                    ASIVC02 * asi = [[ASIVC02 alloc]initWithNibName:@"ASIVC02" bundle:nil];
                    
                    app.mTbc.mainView.hidden = YES;
                    ASIVC03 * asi = [[ASIVC03 alloc]initWithNibName:@"ASIVC03" bundle:nil];

                    [app.mTbc reloadTBCWithController:asi];
                }
                    break;
                default:
                    break;
            }

        }
        default:
            break;
    }
     [self.mm_drawerController setCenterViewController:app.mTbc withCloseAnimation:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
#pragma mark - 获取个人信息

-(void)getItemFinished:(UserInfoConnectionTask *)task
{
    DataItem * item = nil;
    
    item = task.item;
    
    if (task.tag == kMaxTag) {
        
        NSString * urlStr = item.relativePath;
        
        NSURL * url = [NSURL URLWithString:urlStr];
        
        UIButton * btn = (UIButton *)[self.view viewWithTag:dTagHeaderBtn];
        
//        [btn setImageForState:UIControlStateNormal withURL:url placeholderImage:kDefaultPic];
        
        
        [btn setImage:item.photoImage forState:UIControlStateNormal];
    }
    if (task.tag == kMaxTag + 1) {
        MyDatumVC * vc = [[MyDatumVC alloc]init];
        vc.type = 1;
        vc.item = item;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
        nc.navigationBar.translucent = NO;
        [self presentViewController:nc animated:YES completion:nil];
    }
}

#pragma mark - UserInfoTaskDelegate

-(void)getItemFailed:(UserInfoConnectionTask *)task
{
    if (task.tag == kMaxTag) {
        
        MyDatumVC * vc = [[MyDatumVC alloc]init];
        vc.type = 1;
        vc.item = task.item;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
        nc.navigationBar.translucent = NO;
        [self presentViewController:nc animated:YES completion:nil];
    }
}
@end
