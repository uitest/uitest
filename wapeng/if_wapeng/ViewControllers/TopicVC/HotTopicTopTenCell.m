//
//  HotTopicTopTenCell.m
//  if_wapeng
//
//  Created by 符杰 on 14-10-21.
//  Copyright (c) 2014年 funeral. All rights reserved.
//

#import "HotTopicTopTenCell.h"

@implementation HotTopicTopTenCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.contentView.backgroundColor = [UIColor grayColor];
        self.contentView.backgroundColor = kRGB(237, 237, 237);
        self.bg = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,0)];
//        self.bg.image = [UIImage imageNamed:@"cellBGView.png"];
        [self.contentView addSubview:self.bg];
        
        
//        self.v = [[UIView alloc]  initWithFrame:CGRectMake(5, 2, 100, 20)];
//        UILabel * top = [[UILabel alloc]  initWithFrame:CGRectMake(12, 0, 29, 20)];
//        top.text = @"TOP:";
//        top.font = [UIFont systemFontOfSize:15];
//        top.textColor = [UIColor yellowColor];
//        [self.v addSubview:top];

        self.topLable = [[UILabel alloc]  initWithFrame:CGRectMake(7, 2, 70, 20)];
        self.topLable.textColor = [UIColor yellowColor];
        self.topLable.font = [UIFont systemFontOfSize:15];
        [self.bg addSubview:self.topLable];
//        [bg  addSubview:self.v];

        CGFloat y = 3;
        self.comment = [[UILabel alloc]  initWithFrame:CGRectMake(10, 0, 28, 20)];
        self.comment.text = @"回复:";
//        CGSize size = [hui.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:Nil].size;
        self.comment.font = [UIFont systemFontOfSize:12];
//        hui.backgroundColor = [UIColor redColor];
        [self.bg addSubview:self.comment];
        self.replyLable = [[UILabel alloc]  initWithFrame:CGRectMake(CGRectGetMaxX(self.comment.frame), 0, 40, 20)];
        self.replyLable.font = [UIFont systemFontOfSize:12];
        [self.bg addSubview:self.replyLable];
        self.acquaintance = [[UILabel alloc]  initWithFrame:CGRectMake(CGRectGetMaxX(self.replyLable.frame), 0, 28, 20)];
        self.acquaintance.text = @"熟人:";
        self.acquaintance.font = [UIFont systemFontOfSize:12];
        [self.bg  addSubview:self.acquaintance];
        
        self.personLable = [[UILabel alloc]  initWithFrame:CGRectMake(CGRectGetMaxX(self.acquaintance.frame), 0, 40, 20)];
        self.personLable.font = [UIFont systemFontOfSize:12];
        [self.bg  addSubview:self.personLable];

//
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLable.frame) + 4,self.bg.frame.size.width, 1)];
        image.image = [UIImage imageNamed:@"cutlinehot"];
        [self.bg  addSubview:image];
        
        self.contentLable = [[TQRichTextView alloc]  initWithFrame:CGRectMake(10, CGRectGetMaxY(image.frame) + 10, kMainScreenWidth * 0.65, 0)];
        self.contentLable.backgroundColor = [UIColor whiteColor];
        self.contentLable.font = [UIFont systemFontOfSize:18];
        //        self.contentLable.numberOfLines = 0;
        //        self.contentLable.lineBreakMode = NSLineBreakByCharWrapping;
        [self.bg  addSubview:self.contentLable];
        
        self.headImageView = [[UIImageView alloc]  initWithFrame:CGRectMake(self.bg.frame.size.width - 90, CGRectGetMaxY(image.frame), 60, 60)];
        self.headImageView.image = [UIImage imageNamed:@"2.png"];
        [self.bg addSubview:self.headImageView];
        
        self.nameLable = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, 70, 20)];
        self.nameLable.center = CGPointMake(CGRectGetMaxX(self.headImageView.frame) - 30, CGRectGetMaxY(self.headImageView.frame) + 10);
        self.nameLable.textAlignment = NSTextAlignmentCenter;
        self.nameLable.font = [UIFont systemFontOfSize:15];
        [self.bg addSubview:self.nameLable];
        self.bg.userInteractionEnabled = YES;
        
        NSLog(@"frame  ---- %f",CGRectGetMaxY(self.nameLable.frame));
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)layoutSubviews
{
//    self.bg.image = [UIImage imageNamed:@"cellBGView.png"];
    CGRect frame = self.contentView.frame;
    self.bg.frame = frame;
}

@end

