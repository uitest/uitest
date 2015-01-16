//
//  Item_BabyInfo.h
//  if_wapeng
//
//  Created by iwind on 14-11-19.
//  Copyright (c) 2014年 funeral. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item_BabyInfo : NSObject
//@property(nonatomic,strong)NSString * name;
////@property(nonatomic,strong)NSString * gender;
//@property(nonatomic,strong)NSString * childDay;
//@property(nonatomic,strong)NSString * cityName;
//@property(nonatomic,strong)NSString * hospital;
//@property(nonatomic,strong)NSString * school;
//@property(nonatomic,strong)NSString * gradeBan;

@property (nonatomic, strong) NSString * babyName; //宝宝名称
@property (nonatomic, assign) int gender;//宝宝性别
@property (nonatomic, strong) NSString * birthday;//出生日期
@property (nonatomic, strong) NSString * zoneName;//出生城市
@property (nonatomic, strong) NSString * hospitalName;//医院名称
@property (nonatomic, strong) NSString * mDescription;//学校
@property (nonatomic, strong) NSString * className;//班级名称
@property (nonatomic, strong) NSString * petName;//学校

@property (nonatomic, strong) NSString * childID;//孩子id

@property (nonatomic, strong) NSString * childkindergartenID;//幼儿园id

@property (nonatomic, strong) NSString * childKindergarten;

@property (nonatomic, strong) NSString * hospitalID;//医院id

@property (nonatomic, strong) NSString * customerKindergarten;//自定义幼儿园名称

@property (nonatomic, strong) NSString * classID;//班级id

@property (nonatomic, strong) NSString *areaID;//区域id
@property (nonatomic, strong) NSString * cityID;
@property (nonatomic, strong) NSString * latitude;//纬度
@property (nonatomic, strong) NSString * longtitude;//经度
@end
;