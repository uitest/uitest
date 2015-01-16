//
//  ChangeHospitalVC.h
//  if_wapeng
//
//  Created by 心 猿 on 14-12-24.
//  Copyright (c) 2014年 funeral. All rights reserved.
//
@protocol ChangeHospitalDelegate <NSObject>

-(void)changeHospitalWithCityID:(NSString *)cityID areaID:(NSString *)areaID hospitalID:(NSString *)hospitalID hospitalName:(NSString *)hospitalName;
@end
#import <UIKit/UIKit.h>

@interface ChangeHospitalVC : UIViewController
{
    
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSString * cityID;//城市id
@property (nonatomic, strong) NSString * areaID;//区域id
@property (nonatomic, strong) id <ChangeHospitalDelegate> delegate;
@end
