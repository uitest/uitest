//
//  ActivityDetailVC.m
//  if_wapeng
//
//  Created by 心 猿 on 14-8-7.
//  Copyright (c) 2014年 funeral. All rights reserved.
//

#define MAN     1 //男孩
#define WOMAN   2 //女孩
#define ZAN     1 //点赞
#define CANCEL_ZAN  2//取消赞
#define COLLECT     1//收藏
#define CANCEL_COLLECT 2//取消收藏
#define MAXTAG  10000
#define dTag_tf 100
#define dTag_lbl 101
#define dTag_tv 102
#define dTag_toolView 103
#define dTag_headerAction(i) 104 + i
#import "ActivityDetailVC.h"
#import "Cell_ActivityDetail.h"
#import "Cell_AcitivityDetail2.h"
#import "UIViewController+MMDrawerController.h"
#import "UIViewController+General.h"
#import "UIView+WhenTappedBlocks.h"
#import "UIImageView+WebCache.h"
//#import "MJPhotoBrowser.h"
//#import "MJPhoto.h"
#import "DialogView.h"
#import "UIImage+Stretch.h"
#import "Item_AcitivtyDetail.h"
#import "UIImageView+WebCache.h"
#import "TimeTool.h"
#import "Item_ACT_RemarkList.h"
#import "UIButton+FlexSpace.h"
#import "RDRStickyKeyboardView.h"
#import "WUDemoKeyboardBuilder.h"
#import "AppDelegate.h"
#import "MyParserTool.h"//解析
#import "MyLongPressGestureRecognizer.h"
#import "MyMenuItem.h"

#import "MessageData.h"

#import "PublicStringTool.h"
@interface ActivityDetailVC ()<JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
{
    CGRect _tableFrame;
    UITextField * aTextField;
    NSInteger pageIndex;
    
    NSInteger replayType;//回复的是活动详情还是活动评论 0 1
}
@property (nonatomic, strong) Item_AcitivtyDetail * item;

//@property (nonatomic, strong) NSIndexPath * index;//记录哪一行点击回复叫出的键盘
@property (nonatomic, assign) int op;//五项操作

@property (nonatomic, assign) int newIndex;

@property (nonatomic, strong) UITextView * textView;

@end

@implementation ActivityDetailVC


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    AppDelegate * app = [AppDelegate shareInstace];
    app.mTbc.mainView.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:YES];
    AppDelegate * app = [AppDelegate shareInstace];
    app.mTbc.mainView.hidden = NO;
}
-(void)navItemClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createPhotoBrowser:(int)tag image:(UIImage *)image
{
//    tag = 1;
//    int count = 9;
//    // 1.封装图片数据
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i<count; i++) {
//        // 替换为中等尺寸图片
//        //        NSString *url = [_urls[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString:nil]; // 图片路径
//        photo.srcImageView = (UIImageView *)[self.view viewWithTag:1001]; // 来源于哪个UIImageView
//        //        photo.placeholder = image;
//        [photos addObject:photo];
//    }
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = tag; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
}

-(void)replayAction
{
    NSLog(@"回复");
}
/**收藏活动**/
-(void)collectAct
{
    static BOOL isConllect = NO;
    
    isConllect = !isConllect;
    
    int  a = 0;
    if (isConllect == YES) {
        
        a = COLLECT;
    }else{
        
        a = CANCEL_COLLECT;
    }
    
    NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
    NSString *  ddid = [d objectForKey:UD_ddid];
    
    NSString * store = [NSString stringWithFormat:@"%d", a];
    
        NSDictionary * postDict = [[NSDictionary alloc]initWithObjectsAndKeys:ddid,@"D_ID", @"1", @"activityStore.type", self.activityID , @"activityStore.activity.id" , store,@"activityStore.actType", nil];
    
    NSLog(@"{postDict:%@}", postDict);
    
    [http fiveReuqestUrl:dUrl_ACT_1_6_1 postDict:postDict succeed:^(NSObject *obj, BOOL isFinished) {
        
        if (a == COLLECT) {
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        }
        
        if (a == CANCEL_COLLECT) {
            [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
        }
        
        
        
    } failed:^(NSObject *obj, BOOL isFinished) {
        
        [SVProgressHUD showErrorWithStatus:@"收藏失败"];
        
    }];

}
//活动回复收藏
-(void)collectAcitivityWithID:(NSString *)replayId
{
    static BOOL isConllect = NO;
    
    isConllect = !isConllect;
    
    int  a = 0;
    if (isConllect == YES) {
        
        a = COLLECT;
    }else{
        
        a = CANCEL_COLLECT;
    }
    
    NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
    NSString *  ddid = [d objectForKey:UD_ddid];
    
    NSString * store = [NSString stringWithFormat:@"%d", a];
    
//    Item_ACT_RemarkList * item = [_dataArray objectAtIndex:index];
    
    NSDictionary * postDict = [[NSDictionary alloc]initWithObjectsAndKeys:ddid,@"D_ID", @"2", @"activityStore.type", self.activityID , @"activityStore.activity.id" , store,@"activityStore.actType", replayId,@"activityStore.activityReply.id", nil];
    
    NSLog(@"{postDict:%@}", postDict);
    
    [http fiveReuqestUrl:dUrl_ACT_1_6_1 postDict:postDict succeed:^(NSObject *obj, BOOL isFinished) {
        
        if (a == COLLECT) {
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        }
        
        if (a == CANCEL_COLLECT) {
            [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
        }
        
        
        
    } failed:^(NSObject *obj, BOOL isFinished) {
        
        [SVProgressHUD showErrorWithStatus:@"收藏失败"];
        
    }];
}
/**对活动回复进行回复**/

-(void)remarkRemarkListWithString:(NSString *)content aid:(NSString *)aid
{
    NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
    
    NSString * ddid = [d objectForKey:UD_ddid];
    
    __weak ActivityDetailVC * weakSelf = self;
    
    [http thirdRequestWithUrl:dUrl_ACT_1_10_1 succeed:^(NSObject *obj, BOOL isFinished) {
        
        [SVProgressHUD showSuccessWithStatus:@"回复成功"];
         [weakSelf.tableView footerBeginRefreshing];
        
    } failed:^(NSObject *obj, BOOL isFinished) {
        
        [SVProgressHUD showErrorWithStatus:@"回复失败"];
        
    } andKeyValuePairs:@"D_ID", ddid, @"activityReply.content", [PublicStringTool unifyStringWithAndiordString:content], @"activityReply.activity.id", aid, nil];
    
}
/**活动回复举报**/
-(void)waringWithAString:(NSString *)string andAid:(NSString *)aId
{
    NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
    
    NSString * ddid = [d objectForKey:UD_ddid];
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:ddid, @"D_ID", [PublicStringTool unifyStringWithAndiordString:string], @"activityReplyReport.content", aId,@"activityReplyReport.activityReply.id", nil];
    
    [http fiveReuqestUrl:dURl_ACT_1_8_2 postDict:postDict succeed:^(NSObject *obj, BOOL isFinished) {
         [SVProgressHUD showSuccessWithStatus:@"举报成功"];
    } failed:^(NSObject *obj, BOOL isFinished) {
        [SVProgressHUD showErrorWithStatus:@"举报失败"];
    }];
}
/**活动举报**/
-(void)warningWithString:(NSString *)string
{
    NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
    
    NSString * ddid = [d objectForKey:UD_ddid];
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:ddid, @"D_ID", [PublicStringTool unifyStringWithAndiordString:string], @"activityReport.content", self.activityID,@"activityReport.activity.id", nil];

    
    [http fiveReuqestUrl:dUrl_ACT_1_4_1 postDict:postDict succeed:^(NSObject *obj, BOOL isFinished) {
        
        [SVProgressHUD showSuccessWithStatus:@"举报成功"];
        
       
        
    } failed:^(NSObject *obj, BOOL isFinished) {
        
        [SVProgressHUD showErrorWithStatus:@"举报失败"];
    }];
}

#pragma mark - 请求回复列表
-(void)httpRequestWithPageIndex:(int)newPageIndex
{
    NSString * page = [NSString stringWithFormat:@"%d", newPageIndex];
    NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
    NSString * ddid = [d objectForKey:UD_ddid];
    NSMutableDictionary * postDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:ddid, @"D_ID", page, @"activityReplyQuery.pageNum", self.activityID ,@"activityReplyQuery.activityID", nil];
    NSLog(@"postDict:%@", postDict);
    
    __weak ActivityDetailVC * weakSelf = self;
    
    [http fiveReuqestUrl:dUrl_ACT_1_10_2 postDict:postDict succeed:^(NSObject *obj, BOOL isFinished) {
        
        NSDictionary * root = (NSDictionary *)obj;
        
        weakSelf.isButtom = [[[root objectForKey:@"value"] objectForKey:@"isButtom"]integerValue];
        NSLog(@"%d-> %d", weakSelf.isButtom,[[[root objectForKey:@"value"] objectForKey:@"isButtom"]integerValue]);
        
        NSArray * list = [[root objectForKey:@"value"] objectForKey:@"list"];
        
        
        if (list.count != 0) {
            
            for (NSDictionary * dict in list) {
                
                Item_ACT_RemarkList * item = [[Item_ACT_RemarkList alloc]init];
                item.buttonSelected = NO;
                item.content = [NSString stringWithFormat:@"%@", [dict objectForKey:@"content"]];
                item.supports = [[dict objectForKey:@"supports"]integerValue];
                NSArray * temp = [[dict objectForKey:@"author"] objectForKey:@"childInfoList"];
                
                item.name = @"";
                if (isNotNull(temp)) {
                
                    NSDictionary * child = temp[0];
                    
                    if (isNotNull(child)) {
                       
                        item.gender = [[child objectForKey:@"gender"]integerValue];
                         item.name = [NSString stringWithFormat:@"%@", [[child objectForKey:@"kindergarten"] objectForKey:@"name"]];
                    }
                }
                
                
                item.photoUrl = [NSString stringWithFormat:@"%@%@",dUrl_PhotoPrefixion, [[[dict objectForKey:@"author"] objectForKey:@"photo"] objectForKey:@"relativePath"]];
               
                item.rid = [dict objectForKey:@"id"];
                
                item.createTime = [dict objectForKey:@"createTime"];
                NSArray * array = [[dict objectForKey:@"author"] objectForKey:@"childInfoList"];
                
                item.birthday = kNullData;
                
                if (isNotNull(array)) {
                  
                    if (isNotNull(array[0])) {
                        item.birthday = [NSString stringWithFormat:@"%@", [array[0] objectForKey:@"birthday"]];
                    }

            }
                
                NSLog(@"%@", [dict objectForKey:@"petName"] );
                
                item.petName = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"author"] objectForKey:@"petName"]];
                item.isButtom = [[[root objectForKey:@"value"] objectForKey:@"isButtom"]integerValue];
                NSLog(@"%@", item.petName);
                
                NSLog(@"%@", item.birthday);
                [_dataArray addObject:item];
            }
        }else{
            
            [SVProgressHUD showSuccessWithStatus:dTips_noMoreData];
        }
        
        if (self.operation == 1) {
            
            NSIndexSet * set = [NSIndexSet indexSetWithIndex:1];
            
            [weakSelf.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationTop];
        }else{
            
            [weakSelf.tableView reloadData];
            
        }
        
        [weakSelf.tableView footerEndRefreshing];
        [weakSelf.tableView headerEndRefreshing];
        
    } failed:^(NSObject *obj, BOOL isFinished) {
        
        [weakSelf.tableView footerEndRefreshing];
        [weakSelf.tableView headerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:dTips_requestError];
    }];
}

//请求第一个section的数据
-(void)httpRequest
{
//    NSMutableDictionary * postDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys, @"activityQuery.activityID" ,nil];
    
    NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
    
    NSString * ddid = [d objectForKey:UD_ddid];
    
    NSMutableDictionary * postDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.activityID, @"activityQuery.activityID", ddid , @"D_ID",nil];
    
    [self startHttpRequestWithUrl:dUrl_ACT_1_2_6 postDict:postDict];
}
#pragma mark - 请求活动详情
-(void)startHttpRequestWithUrl:(NSString *)url  postDict:(NSMutableDictionary *)postDict
{
    
    NSLog(@"{postDict}%@", postDict);
    
    __weak ActivityDetailVC * weakSelf = self;
    
    [http fiveReuqestUrl:url postDict:postDict succeed:^(NSObject *obj, BOOL isFinished) {
        
        //移除所有内容
        [weakSelf.smallArr1 removeAllObjects];
        
        NSMutableDictionary * dict = (NSMutableDictionary *)obj;
        //活动
        NSDictionary * value = [dict objectForKey:@"value"];
        
        Item_AcitivtyDetail * item  = [[Item_AcitivtyDetail alloc]init];
        item.age = [NSString stringWithFormat:@"%@", [value objectForKey:@"age"]];
        item.createTime = [value objectForKey:@"createTime"];
        item.petName = [[value objectForKey:@"author"] objectForKey:@"petName"];
        item.relativePath = [NSString stringWithFormat:@"%@%@", dUrl_PhotoPrefixion, [[[value objectForKey:@"author"] objectForKey:@"photo"] objectForKey:@"relativePath"]];
        item.content = [value objectForKey:@"content"];
        item.isOpen = [[value objectForKey:@"open"]integerValue];

        item.limitTime = [value objectForKey:@"limitTime"];
        NSArray * childInfo = [[value objectForKey:@"author"] objectForKey:@"childInfoList" ];
        
        item.gender = @"";
        if (isNotNull(childInfo) ) {
            
            if (childInfo.count != 0) {
                item.gender = [NSString stringWithFormat:@"%@", [[childInfo firstObject] objectForKey:@"gender"]];
            }
           
        }
       
        item.title = [value objectForKey:@"title"];
        item.replies = [[value objectForKey:@"replies"] intValue];
        item.placeName = [NSString stringWithFormat:@"%@", [value objectForKey:@"placeName"]];
        item.supports = [[value objectForKey:@"supports"] intValue];
        
        
        item.birthTime = kNullData;
        if (isNotNull([value objectForKey:@"author"]) ) {
            
            if (isNotNull([[value objectForKey:@"author"] objectForKey:@"childInfoList"])) {
                if ([[[value objectForKey:@"author"] objectForKey:@"childInfoList"] count] != 0) {
                    NSDictionary * d = [[value objectForKey:@"author"] objectForKey:@"childInfoList"][0];
                    item.birthTime = [d objectForKey:@"birthday"];
                }
            }
          
        }
        
      
        
        if (![[value objectForKey:@"activityAttachmentList"] isKindOfClass:[NSNull class]]) {
            
            NSArray * activityAttachmentList = [value objectForKey:@"activityAttachmentList"];
            for (NSDictionary * dict in activityAttachmentList) {
                
                
                if (![[dict objectForKey:@"attachment"] isKindOfClass:[NSNull class]]) {
                    
                    if (![[[dict objectForKey:@"attachment"] objectForKey:@"relativePath"] isKindOfClass:[NSNull class]]) {
                        NSString * url = [NSString stringWithFormat:@"%@%@", dUrl_PhotoPrefixion,[[dict objectForKey:@"attachment"] objectForKey:@"relativePath"]];
                        
                        [item.urlArray addObject:url];

                    }
                }
            }
    
        }
        

        [weakSelf.smallArr1 addObject:item];
        
        NSLog(@"%@", weakSelf.smallArr1[0]);
        [weakSelf.tableView reloadData];
        
    } failed:^(NSObject *obj, BOOL isFinished) {
        
        
    }];
}

-(void)notify:(NSNotification *)notify
{
    [self.textView resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"活动详情";
    
    _dataArray = [[NSMutableArray alloc]init];
    _smallArr1 = [[NSMutableArray alloc]init];
    _smallArr2 = [[NSMutableArray alloc]init];
    http = [[AFN_HttpBase alloc]init];

    self.textView =  self.inputToolBarView.textView;
    
    self.textView.backgroundColor = [UIColor grayColor];
    
    NSLog(@"frame = %@", NSStringFromCGRect(self.textView.frame));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:dNoti_HiddenLeftKeyBoard object:nil];
    

    [self initLeftItem];

    
    [self httpRequest];
   
    pageIndex = 1;
    
    [self httpRequestWithPageIndex:pageIndex];
    [self setupRefresh:self.tableView];
    
    self.delegate = self;
}


-(void)footerRereshing
{
    self.operation = 2;
    
    if (self.isButtom == 1) {
        
        [self.tableView footerEndRefreshing];
        
        [SVProgressHUD showSuccessWithStatus:dTips_noMoreData];
        
        return;
    }
    
    pageIndex++;
    
    [self httpRequestWithPageIndex:pageIndex];
}
-(void)headerRereshing
{
    self.operation = 1;
    
    [_dataArray removeAllObjects];
    
    pageIndex = 1;
    
    [self httpRequestWithPageIndex:pageIndex];

}

#pragma mark - tableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_smallArr1 count];
    }
    else{
        return [_dataArray count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString * strID = @"ID";
        
        Cell_ActivityDetail * cell = [tableView dequeueReusableCellWithIdentifier:strID];
        
        if (nil == cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"Cell_ActivityDetail" owner:self options:nil]lastObject];
        }
        
        if (_smallArr1.count == 0) {
            
            return cell;
        }
        
        Item_AcitivtyDetail * item = _smallArr1[indexPath.row];
        
        [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:item.relativePath] placeholderImage:[UIImage imageNamed:@"saga2.jpg"]];
        
        cell.pNameLabel.text = item.petName;
        
        cell.contentLabel.text = item.title;
        
        NSMutableString * str = [TimeTool getBabyAgeWithBirthday:item.birthTime publicTime:item.createTime];
        
        if ([item.gender isEqualToString:@"1"]) {
            
            cell.cNameLabel.text = [NSString stringWithFormat:@"王子：%@", str];
            cell.cNameLabel.textColor = [UIColor blueColor];
            
        }else{
            
             cell.cNameLabel.text = [NSString stringWithFormat:@"公主：%@", str];
            
            cell.cNameLabel.textColor = [UIColor redColor];
        }
        
        
        if ( [TimeTool limitTime:item.limitTime] && item.isOpen) {
            
            cell.stateLabel.text = @"活动进行中";
            cell.stateLabel.textColor = [UIColor blueColor];
        }else{
            cell.stateLabel.text = @"活动已关闭";
            cell.stateLabel.textColor = [UIColor blueColor];
        }
        cell.upTImeLabel.text  =[TimeTool getUTCFormateDate:item.createTime];
        
        CGRect frame = cell.detailLabel.frame;
        MyParserTool * parser = [MyParserTool shareInstance];
        
        CGSize size = [parser sizeWithRawString:item.content constrainsToWidth:frame.size.width Font:[UIFont systemFontOfSize:13]];

        frame.size = size;
        
        cell.detailLabel.backgroundColor = [UIColor whiteColor];
        
        cell.detailLabel.text = item.content;
        
        cell.detailLabel.frame = frame;
        
        [cell.praiseBtn setTitle:[NSString stringWithFormat:@"%d", item.supports] forState:UIControlStateNormal];
        
        int i = 0;
        
        CGRect lastImageViewFrame = CGRectZero;
        
        for (NSString * url in item.urlArray) {
            
            UIImageView * iv = [[UIImageView alloc]init];
            
            iv.backgroundColor = [UIColor greenColor];
            
            iv.frame = CGRectMake(CGRectGetMaxX(cell.headerImage.frame) + 5, CGRectGetMaxY(cell.detailLabel.frame) + 10, (kMainScreenWidth - CGRectGetMaxX(cell.headerImage.frame) - 5) / 3.0 - 10, (kMainScreenWidth - CGRectGetMaxX(cell.headerImage.frame) - 5) / 3.0 - 10);
            
            if ( i % 3 == 0) {
                
                CGRect frame = iv.frame;
                
                frame.origin.x = CGRectGetMaxX(cell.headerImage.frame) + 5;
                
                iv.frame = frame;
            }
            if ( i  % 3 == 1) {
                
                CGRect frame = iv.frame;
                
                frame.origin.x = CGRectGetMaxX(cell.headerImage.frame) + 5 + (kMainScreenWidth - CGRectGetMaxX(cell.headerImage.frame) - 5) / 3.0;
                iv.frame = frame;
            }
            
            if (i % 3 == 2) {
                
                CGRect frame = iv.frame;
                
                frame.origin.x = CGRectGetMaxX(cell.headerImage.frame) + 5 + (kMainScreenWidth - CGRectGetMaxX(cell.headerImage.frame) - 5) * 2 / 3.0 ;
                iv.frame = frame;
            }
            
            if (i < 3) {
                
                frame = iv.frame;
                frame.origin.y = CGRectGetMaxY(cell.detailLabel.frame) + 10;
                iv.frame = frame;
            }else if (i < 5)
            {
                frame = iv.frame;
                frame.origin.y = CGRectGetMaxY(cell.detailLabel.frame) + 10 +( kMainScreenWidth - CGRectGetMaxX(cell.headerImage.frame) - 5) / 3.0 + 10;
                iv.frame = frame;
                
            }
            else{
                frame = iv.frame;
                frame.origin.y = CGRectGetMaxY(cell.detailLabel.frame) + 10 +( kMainScreenWidth - CGRectGetMaxX(cell.headerImage.frame) - 5) * 2 / 3.0 + 10;
                
                iv.frame = frame;

            }
            
            [cell addSubview:iv];
            
            NSURL * newUrl = [NSURL URLWithString:url];
            
            [iv setImageWithURL:newUrl placeholderImage:[UIImage imageNamed:@"saga2.jpg"]];
            
            lastImageViewFrame = iv.frame;
            i++;
        }
        
        
        frame =cell.praiseBtn.frame;
        
        frame.origin.y = CGRectGetMaxY(lastImageViewFrame) + 10;
        cell.praiseBtn.frame = frame;
//        cell.praiseBtn.backgroundColor = [UIColor redColor];
        [cell.praiseBtn setLayout:OTSImageLeftTitleRightStyle spacing:5];
        [cell.praiseBtn setImage:[UIImage imageNamed:@"good_n"] forState:UIControlStateNormal];
        [cell.praiseBtn setImage:[UIImage imageNamed:@"good_d"] forState:UIControlStateSelected];
        [cell.praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.praiseBtn.frame = frame;
        
        [cell.discussLabel addTarget:self action:@selector(discussBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        cell.discussLabel.backgroundColor = [UIColor redColor];
        
        [cell.discussLabel setTitle:[NSString stringWithFormat:@"%d", item.replies] forState:UIControlStateNormal];
        
        [cell.discussLabel setImage:[UIImage imageNamed:@"pinglun2.png"] forState:UIControlStateNormal];
        
        [cell.discussLabel setLayout:OTSImageLeftTitleRightStyle spacing:5];
        
        frame = cell.discussLabel.frame;
        frame.origin.y = CGRectGetMaxY(lastImageViewFrame) + 10;
        cell.discussLabel.frame = frame;
        
        return cell;
    }else{
        static NSString * strID = @"ID2";
        
        Cell_AcitivityDetail2 * cell = [tableView dequeueReusableCellWithIdentifier:strID];
        
        if (nil == cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"Cell_AcitivityDetail2" owner:self options:nil]lastObject];
        }
        
        Item_ACT_RemarkList * item = _dataArray[indexPath.row];
        cell.contentLbl.text = item.content;
        
        cell.contentLbl.userInteractionEnabled = YES;
        
        MyLongPressGestureRecognizer * lpgr = [[MyLongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick:)];
        lpgr.tag = indexPath.row;
        
        [cell.contentLbl addGestureRecognizer:lpgr];
        
        cell.pNameLabel.text = item.petName;
        
        NSLog(@"%@", item.petName);
        
        cell.cNameLabel.text = item.name;
   
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:item.photoUrl] placeholderImage:[UIImage imageNamed:@"saga2.jpg"]];
        NSMutableString * age = [TimeTool getBabyAgeWithBirthday:item.birthday publicTime:item.createTime];
        if (item.gender == 2) {
            
            cell.cNameLabel.textColor = [UIColor redColor];
            cell.cNameLabel.text = [NSString stringWithFormat:@"公主/%@",age];
        }
        if (item.gender == 1) {
            
            cell.cNameLabel.textColor = [UIColor blueColor];
            cell.cNameLabel.text = [NSString stringWithFormat:@"王子/%@",age];
        }
        
        NSString * zanCount = [NSString stringWithFormat:@"%d", item.supports];
        
        [cell.zanBtn setTitle:zanCount forState:UIControlStateNormal];
        [cell.zanBtn addTarget:self action:@selector(praiseBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
        
        if (item.buttonSelected == NO) {
            [cell.zanBtn setImage:[UIImage imageNamed:@"good_n"] forState:UIControlStateNormal];
            [cell.zanBtn setLayout:OTSImageLeftTitleRightStyle spacing:5];
        }else{
            [cell.zanBtn setImage:[UIImage imageNamed:@"good_d"] forState:UIControlStateNormal];
            [cell.zanBtn setLayout:OTSImageLeftTitleRightStyle spacing:5];
        }
        
        cell.zanBtn.tag = MAXTAG + indexPath.row;
        
        return cell;
    }
}
- (BOOL)canBecomeFirstResponder{
    
    return YES;
    
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    SEL action1 = @selector(menuItemClick1:);
    
    SEL action2 = @selector(menuItemClick2:);
    
    SEL action3 = @selector(menuItemClick3:);
    
    SEL action4 = @selector(menuItemClick4:);
    
    SEL action5 = @selector(menuItemClick5:);
    
    if (action == action1) {
        
        return YES;
    }
    if (action == action2) {
        
        return YES;
        
    }
    if (action == action3) {
        
        return YES;
        
    }
    
    if (action == action4) {
        
        return YES;
    }
    
    if (action == action5) {
        
        return YES;
        
    }
    
//    if (action == @selector(menuItemClick:)) {
//        return YES;
//    }
    return NO;
    
}

#pragma mark - 弹出UIMenuController

-(void)longPressClick:(MyLongPressGestureRecognizer *)lpgr
{
    if (lpgr.state == UIGestureRecognizerStateEnded) {
        
        NSArray * titles = @[@"回复", @"收藏", @"复制", @"举报", @"删除"];
        UIMenuController * menu = [UIMenuController sharedMenuController];
    
       NSInteger index = lpgr.tag;
        
        NSIndexPath * path = [NSIndexPath indexPathForRow:index inSection:1];
        
        self.index = path;
        
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:path];
        
        [menu setTargetRect:cell.frame inView:cell.superview];
        
        UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:[titles objectAtIndex:0] action:@selector(menuItemClick1:)];
        UIMenuItem * item2 = [[UIMenuItem alloc]initWithTitle:[titles objectAtIndex:1] action:@selector(menuItemClick2:)];
        UIMenuItem * item3 = [[UIMenuItem alloc]initWithTitle:[titles objectAtIndex:2] action:@selector(menuItemClick3:)];
        UIMenuItem * item4 = [[UIMenuItem alloc]initWithTitle:[titles objectAtIndex:3] action:@selector(menuItemClick4:)];
        UIMenuItem * item5 = [[UIMenuItem alloc]initWithTitle:[titles objectAtIndex:4] action:@selector(menuItemClick5:)];
        
        NSArray * itemsArr =@[item1, item2, item3, item4, item5];
        
        [menu setMenuItems:itemsArr];
        
        
        [menu setArrowDirection:UIMenuControllerArrowDown];

        [menu setMenuVisible:YES animated:YES];

    }
    
}

#pragma mark - 回复
- (void)menuItemClick1:(UIMenuItem *)menuItem
{
    
//    if (self.index.section == 0) {
//        
//        [self remarkRemarkListWithString:nil aid:self.activityID];
//    }
    
    Item_ACT_RemarkList * item = _dataArray[self.index.row];
    
    NSString * ceshi = @"bingbingbing";
    
    replayType = 1;
    //回复
//    [self remarkRemarkListWithString:ceshi aid:self.activityID];
    
    self.op = 1;
    
    if (self.index.section == 1) {
        
        Item_ACT_RemarkList * item = _dataArray[self.index.row];
        
        self.textView.text = [NSString stringWithFormat:@"回复%@",item.petName];
    }
    
    [self.textView becomeFirstResponder];
    
    [self.textView becomeFirstResponder];
}
- (void)menuItemClick2:(UIMenuItem *)menuItem
{
    
    self.op =2;
    if (self.index.section == 0) {
        [self collectAct];
        
        return;
    }
    Item_ACT_RemarkList * item = _dataArray[self.index.row];
    NSLog(@"收藏");
    [self collectAcitivityWithID:item.rid];

}
- (void)menuItemClick3:(UIMenuItem *)menuItem
{
    self.op = 3;
    if (self.index == 0) {
        
        Item_AcitivtyDetail * item =[_smallArr1 objectAtIndex:self.index.row];
        
        UIPasteboard * pasteBoard = [UIPasteboard generalPasteboard];
        pasteBoard.string = item.content;
    }
    
    Item_ACT_RemarkList * item = _dataArray[self.index.row];
    
    UIPasteboard * pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = item.content;
    
    NSLog(@"复制");
}
- (void)menuItemClick4:(UIMenuItem *)menuItem
{
    
    self.op = 4;
    [self.textView becomeFirstResponder];
    
    [self.textView becomeFirstResponder];
    
    if (self.index.section == 1) {
        
        Item_ACT_RemarkList * item = _dataArray[self.index.row];
        
        self.textView.text = [NSString stringWithFormat:@"举报%@",item.petName];
    }
    
}
- (void)menuItemClick5:(UIMenuItem *)menuItem
{
    self.op = 5;
    Item_ACT_RemarkList * item = _dataArray[self.index.row];
    NSLog(@"删除");
}
-(void)menuItemClick:(UIMenuItem *)menuItem
{
     NSArray * titles = @[@"回复", @"收藏", @"复制", @"举报", @"删除"];
    
    int i = 0;
    for (NSString * str in titles) {
        
        if ([menuItem.title isEqualToString:str]) {
            
            self.op = i;
            
            break;
        }
        
        i++;
    }
    switch (self.index.section) {
        case 0:
        {
            switch (self.op) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    
                }
                    break;
                case 2:
                {
                    
                }
                    break;
                case 3:
                {
                    
                }
                    break;
                case 4:
                {
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            
            Item_ACT_RemarkList * item = _dataArray[self.index.row];
            
    
//            NSArray * titles = @[@"回复", @"收藏", @"复制", @"举报", @"删除"];
            
            switch (self.op) {
                case 0:
                {
                    
                    NSString * ceshi = @"测试";
                    //回复
                    [self remarkRemarkListWithString:ceshi aid:self.activityID];
                }
                    break;
                case 1:
                {
                    //收藏
                    [self collectAcitivityWithID:item.rid];
                }
                    break;
                case 2:
                {
                    //复制
                    UIPasteboard * pasteBoard = [UIPasteboard generalPasteboard];
                    pasteBoard.string = item.content;
                }
                    break;
                case 3:
                {
                    //举报
                    
                    NSString * string = @"举报";

                    [self warningWithString:string];
                }
                    break;
                case 4:
                {
                    //删除
                }
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
}
#pragma mark - 返回高度


#pragma mark - 点击红块
-(void)headerViewAction:(UIButton *)btn
{
    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:btn.tag - 104];
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:    UITableViewScrollPositionTop animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * name = @[@"发起人",@"回应"];
    
    UIView * mainView = [[UIView alloc]init];
    
    mainView.backgroundColor = [UIColor whiteColor];
    
    mainView.frame = CGRectMake(0, 0, kMainScreenWidth, 30);
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[name objectAtIndex:section] forState:UIControlStateNormal];
    button.tag = dTag_headerAction(section);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(headerViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage resizedImage:@"活动详情--发起人.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 80, 30);
    [mainView addSubview:button];
    
    return mainView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        NSLog(@"哈哈哈");
        
        NSArray * titles = @[@"回复", @"收藏", @"复制", @"举报", @"删除"];
        UIMenuController * menu = [UIMenuController sharedMenuController];
        
        self.index = indexPath;
        
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [menu setTargetRect:cell.frame inView:cell.superview];
        
        UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:[titles objectAtIndex:0] action:@selector(menuItemClick1:)];
        UIMenuItem * item2 = [[UIMenuItem alloc]initWithTitle:[titles objectAtIndex:1] action:@selector(menuItemClick2:)];
        UIMenuItem * item3 = [[UIMenuItem alloc]initWithTitle:[titles objectAtIndex:2] action:@selector(menuItemClick3:)];
        UIMenuItem * item4 = [[UIMenuItem alloc]initWithTitle:[titles objectAtIndex:3] action:@selector(menuItemClick4:)];
        UIMenuItem * item5 = [[UIMenuItem alloc]initWithTitle:[titles objectAtIndex:4] action:@selector(menuItemClick5:)];
        
        NSArray * itemsArr =@[item1, item2, item3, item4, item5];
        
        [menu setMenuItems:itemsArr];
        
        
        [menu setArrowDirection:UIMenuControllerArrowDown];
        
        [menu setMenuVisible:YES animated:YES];
        
    }
}
#pragma mark --暂时这么写,等有键盘了再把它替换掉

-(void)sendText:(NSString *)string type:(int)pageType index:(int)index
{
    if (pageType == 1) {
        
        NSLog(@"对回复举报");
        
        Item_ACT_RemarkList * item = _dataArray[index];
        
        [self waringWithAString:string andAid:item.rid];
    }
    if (pageType == 2) {
        //对回复回复
        [self remarkRemarkListWithString:string aid:self.activityID];
    }
    if (pageType == 3) {
        
        //对活动回复
        [self remarkRemarkListWithString:string aid:self.activityID];
     
    }
    if (pageType == 4) {
        
        //对活动举报
        [self warningWithString:string];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
//kMainScreenWidth - CGRectGetMaxX(cell.headerImage.frame) - 5) / 3.0
        
        Item_AcitivtyDetail * aItem = _smallArr1[indexPath.row];
        CGSize size = [[MyParserTool shareInstance] sizeWithRawString:aItem.content constrainsToWidth:320 Font:[UIFont systemFontOfSize:13]];
        
        return 120 + size.height + (aItem.urlArray.count / 3) *( (kMainScreenWidth - 72) / 3.0 + 10);
    }
    
    Item_ACT_RemarkList * item = _dataArray[indexPath.row];
    return [item height];
}

#pragma mark  对发起人的内容进行评论
-(void)discussBtnClick{
    
}

#pragma mark  对活动内容点赞
-(void)praiseBtnClick:(UIButton *)sender{
    /**
     *  赞：改变sender的selected的属性为YES
     *  取消赞：改变sender的selected的属性为NO
     *  刷新该行
     */
    
    NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
    
    NSString * ddid = [d objectForKey:UD_ddid];
    
     Item_AcitivtyDetail * item = _smallArr1[0];
    
    int a = 0;
    if (sender.selected == YES) {
        
        a = 2;
        
        item.supports--;
        
        NSString * str = [NSString stringWithFormat:@"%d", item.supports];
        [sender setTitle:str forState:UIControlStateNormal];
    
    }
    if (sender.isSelected == NO) {
        
        item.supports++;
        
        a = 1;
        
        NSString * str = [NSString stringWithFormat:@"%d", item.supports];
        [sender setTitle:str forState:UIControlStateNormal];
    }
    sender.selected = !sender.selected;
    
    NSString * type = [NSString stringWithFormat:@"%d", a];
    
    [http thirdRequestWithUrl:dUrl_ACT_1_5_1 succeed:^(NSObject *obj, BOOL isFinished) {
        
        if ( a == 1) {
            [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
        }
        if (a == 2) {
             [SVProgressHUD showSuccessWithStatus:@"取消成功"];
        }
       
        
    } failed:^(NSObject *obj, BOOL isFinished) {
        
        [SVProgressHUD showErrorWithStatus:@"点赞失败"];
        
    } andKeyValuePairs:@"D_ID", ddid , @"activitySupport.activity.id", self.activityID, @"activitySupport.actType", type, nil];
}

#pragma mark  对回应内容点赞
-(void)praiseBtnClick1:(UIButton *)sender{
    
    NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
    
    NSString * ddid = [d objectForKey:UD_ddid];
    
    int a;
 
    NSString * type = [NSString stringWithFormat:@"%d", a];
    
    Item_ACT_RemarkList * item = [_dataArray objectAtIndex:sender.tag - MAXTAG];
     item.buttonSelected = !item.buttonSelected;
    if (item.buttonSelected == YES) {
        
        a = 1;
    }else{
        a = 2;
    }
    
    __weak ActivityDetailVC * weakSelf = self;
    
    [http thirdRequestWithUrl:dUrl_ACT_1_8_1 succeed:^(NSObject *obj, BOOL isFinished) {
        
        if (a == 1) {
            
            item.supports++;
            [weakSelf.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
        }
        if (a == 2) {
            item.supports--;
            [weakSelf.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:@"取消赞成功"];
        }
        
    } failed:^(NSObject *obj, BOOL isFinished) {
        
        [SVProgressHUD showErrorWithStatus:@"失败"];
        
    } andKeyValuePairs:@"D_ID", ddid, @"activityReplySupport.activityReply.id", item.rid, @"activityReplySupport.acttype", type , nil];
}

///发送请求接口。
#pragma mark - msgdelegate
#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    
    if (self.index.section == 0  && self.op == 1) {
        
        [self remarkRemarkListWithString:text aid:self.activityID];
    }
    
    if (self.index.section == 0 && self.op == 1) {
        [self remarkRemarkListWithString:text aid:self.activityID];
    }
    
    if (self.index.section == 0 && self.op == 4) {
        
        [self warningWithString:text];
        
    }
    
    if (self.index.section == 1 && self.op == 4) {
        
            Item_ACT_RemarkList * item = _dataArray[self.index.row];
       
        
        [self waringWithAString:text andAid:item.rid];
        
    }
    if (self.index.section == 1) {
        
         Item_ACT_RemarkList * item = _dataArray[self.index.row];
        
        [self waringWithAString:text andAid:item.rid];
    }
    [self.inputToolBarView.textView resignFirstResponder];
    
    [self.tableView scrollToRowAtIndexPath:self.index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [self finishSend:NO andIndexPath:self.index];
}

#pragma - mark - 点击表情按钮触发的方法

- (void)cameraPressed:(id)sender{
    
    if (self.textView.isFirstResponder) {
        if (self.textView.emoticonsKeyboard) [self.textView switchToDefaultKeyboard];
        else [self.textView switchToEmoticonsKeyboard:[WUDemoKeyboardBuilder sharedEmoticonsKeyboard]];
    }else{
        [self.textView switchToEmoticonsKeyboard:[WUDemoKeyboardBuilder sharedEmoticonsKeyboard]];
        [self.textView becomeFirstResponder];
    }
    
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}
@end