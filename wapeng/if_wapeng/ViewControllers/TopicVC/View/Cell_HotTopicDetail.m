//
//  Cell_HotTopicDetail.m
//  if_wapeng
//
//  Created by 早上好 on 14-9-11.
//  Copyright (c) 2014年 funeral. All rights reserved.
//
#define AttachmentImageSize 60
#define TopicNameLabelFrame self.TopicNameLabel.frame
#import "Cell_HotTopicDetail.h"
#import "MyParserTool.h"
#import "Constant_general.h"
#import "UIImageView+WebCache.h"
@implementation Cell_HotTopicDetail

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    self.ivArr = [[NSMutableArray alloc]initWithObjects:self.iv1,self.iv2,self.iv3,self.iv4,self.iv5,self.iv6,self.iv7,self.iv8,self.iv9, nil];
    NSLog(@"%d",self.ivArr.count);
     //头像设置
    if ([self.hotTopicDetail.authorPhoto isEqualToString:@"111111"]){
        self.authorPhotoIV.image = [UIImage imageNamed:@"tab_selected.jpg"];
    }else if([self.hotTopicDetail.authorPhoto isEqualToString:@"22222"]){
        self.authorPhotoIV.image = [UIImage imageNamed:@"匿名"];
    }else{
        [self.authorPhotoIV setImageWithURL:[NSURL URLWithString:self.hotTopicDetail.authorPhoto] placeholderImage:[UIImage imageNamed:@"zjgw_logo@2x.png"]];
    }
    self.authorPhotoIV.layer.cornerRadius = AllCornerRadius;
    self.authorPhotoIV.layer.masksToBounds = YES;
    //家长昵称
    self.petName.text = self.hotTopicDetail.petName;
    if (self.hotTopicDetail.anonymousFlag == 2) {
        //孩子年龄(解析宝宝性别拼写字符串)
        if (self.hotTopicDetail.childAge != 0 && ![@""isEqualToString:self.hotTopicDetail.childGender]) {
            self.childAge.text= [NSString stringWithFormat:@"%@/%@",self.hotTopicDetail.childGender,self.hotTopicDetail.childAge];
        }else{
            self.childAge.text = @"无宝宝";
        }

    }else{
        self.childAge.hidden = YES;
    }
   
    //话题是否关闭
    self.isClose.text = self.hotTopicDetail.isClosed;
    //话题题目
    self.TopicNameLabel.text = self.hotTopicDetail.TopicTitle;
//    //话题内容
    NSLog(@"------------- TopicContent = %@----------",self.hotTopicDetail.TopicContent);
    
    self.TopicContent = [[TQRichTextView alloc]initWithFrame:CGRectMake(TopicNameLabelFrame.origin.x, TopicNameLabelFrame.origin.y+TopicNameLabelFrame.size.height + 10, kMainScreenWidth * 0.6, [self.hotTopicDetail getTopicContentViewHeight])];
    self.TopicContent.font = [UIFont systemFontOfSize:ContentFontSize];
    self.TopicContent.text = self.hotTopicDetail.TopicContent;
    [self addSubview:self.TopicContent];
    self.TopicContent.backgroundColor = [UIColor whiteColor];
//    self.TopicContent.text = self.hotTopicDetail.TopicContent;
    //点赞数
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d",self.hotTopicDetail.likeCount];
    //评论数
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d",self.hotTopicDetail.commentCount];
    
    //附带图片
//    self.imageGroupView = [[UIView alloc]initWithFrame:CGRectMake(TopicNameLabelFrame.origin.x, TopicNameLabelFrame.origin.y+TopicNameLabelFrame.size.height + 10 + self.TopicContent.frame.size.height +20, kMainScreenWidth * 0.6, [self.hotTopicDetail getTopicImageGroupHeight])];
    CGRect igFrame = self.imageGroupView.frame;
    igFrame = CGRectMake(TopicNameLabelFrame.origin.x, TopicNameLabelFrame.origin.y+TopicNameLabelFrame.size.height + 10 + self.TopicContent.frame.size.height +20, kMainScreenWidth * 0.6, [self.hotTopicDetail getTopicImageGroupHeight]+5);
    self.imageGroupView.frame = igFrame;
    
    
    
    
    int k = 0;
        for (int i = 0; i<3; i++) {
            if ((k + 1)>self.hotTopicDetail.attachmentList.count) {
                break;
            }else{
                for (int j = 0; j<3; j++) {
                    if ((k + 1)>self.hotTopicDetail.attachmentList.count) {
                        break;
                    }else{
                    //
                        NSString * imageStr = self.hotTopicDetail.attachmentList[k];
                        k++;
                        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake((AttachmentImageSize+5)*j, i*(5+AttachmentImageSize), AttachmentImageSize, AttachmentImageSize)];
                        [iv sd_setImageWithURL:[NSURL URLWithString:imageStr]];
                        iv.backgroundColor = [UIColor redColor];
                        [self.imageGroupView addSubview: iv];
                    //
                    }
                }
            }
        }

//        [self.contentView addSubview:self.imageGroupView];
    
    NSLog(@"------- %f",[self.hotTopicDetail getTopicImageGroupHeight]);
    //点赞数评论数我在
    self.otherView.frame = CGRectMake(TopicNameLabelFrame.origin.x, TopicNameLabelFrame.origin.y+TopicNameLabelFrame.size.height + 10 + self.TopicContent.frame.size.height +20 + [self.hotTopicDetail getTopicImageGroupHeight] + 30, kMainScreenWidth-TopicNameLabelFrame.origin.x*2, 94);
    //定位地点名称
    [self.location setTitle:self.hotTopicDetail.placeName forState:UIControlStateNormal];

    //点赞图片设置
    if (self.hotTopicDetail.viewSupportFlag == 1) {
        self.clickGood.image = [UIImage imageNamed:@"good_1.png"];
    }else{
        self.clickGood.image = [UIImage imageNamed:@"good_2.png"];
    }
    
//    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
//    
//    aView.backgroundColor = [UIColor whiteColor];
//    
//    self.selectedBackgroundView = aView;
    

//    [self.superview layoutSubviews];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (IBAction)clickLike {
////            [self requestClickGoodData:item._id setActtype:flag isAuthor:0 indexPath:indexPath.row];
//    NSLog(@"点赞");
//}
- (IBAction)clickLocation {
    NSLog(@"点击位置");
}

@end
