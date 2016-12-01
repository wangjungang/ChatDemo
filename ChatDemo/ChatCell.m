//
//  ChatCell.m
//  ChatDemo
//
//  Created by 孙锐 on 16/7/5.
//  Copyright © 2016年 孙锐. All rights reserved.
//

#import "ChatCell.h"
#import "SRChatModel.h"
#import "SRChatFrameInfo.h"

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Model:(SRChatModel *)model
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIChatViewColor;
        
        self.frameInfo = [[SRChatFrameInfo alloc]initWithModel:model];
        self.headView.frame = self.frameInfo.headViewFrame;
        self.headImageView.frame = self.frameInfo.headImageViewFrame;
        self.textView.frame = self.frameInfo.textViewFrame;
        self.pictureView.frame = self.frameInfo.pictureViewFrame;
        self.textChatLabel.frame = self.frameInfo.textLabelFrame;
        self.height = self.frameInfo.cellHeight;
        [self chooseToSetPositionWith:model.isSender];
        [self getHeadViewImageWithID:model.senderID];
        [self getTextViewWithType:model.chatContent];
        [self getTextField:model.chatText];
        [self getPictureView:model.chatPictureUrl];
    }
    return self;
}


-(void)layoutSubviews{
    
    self.headView.frame = self.frameInfo.headViewFrame;
    self.headImageView.frame = self.frameInfo.headImageViewFrame;
    self.textView.frame = self.frameInfo.textViewFrame;
    self.pictureView.frame = self.frameInfo.pictureViewFrame;
    self.textChatLabel.frame = self.frameInfo.textLabelFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//获得发送语音的长度
-(void)getLengthofSpoken:(NSTimeInterval *)timeInterval{

    self.voiceLength = timeInterval;
}

//获得发送的图片
-(void)getPictureView:(NSString *)pictureUrl{
    
    self.pictureUrl = [NSURL URLWithString:pictureUrl];
}


//获得输入的文字
-(void)getTextField:(NSString *)text{

    self.textChatLabel.text = text;
}


//通过用户ID获取头像
-(void)getHeadViewImageWithID:(NSString *)userID{

    if ([userID isEqualToString:@"0001"]) {
        self.headImageView.image = [UIImage imageNamed:@"可乐"];
    }else if ([userID isEqualToString:@"0002"]){
        self.headImageView.image =[UIImage imageNamed:@"猫"];
    }
}


//根据气泡和头像放在左侧还是右侧
-(void)chooseToSetPositionWith:(BOOL)isSender{
    
    if(isSender == 1){
        //放在右边
        [self getRightCell];
    }
    else if(isSender == 0){
        //放在左边
        [self getLeftCell];
    }
    [self addSubview:self.headView];
    [self addSubview:self.textView];
    
}

//获得左侧的cell
-(void)getLeftCell{
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"绿气泡"]];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.frame = CGRectMake(0, 0, self.textView.bounds.size.width, self.textView.bounds.size.height);
    [self.textView addSubview:imageView];

}

//获得右侧的cell
-(void)getRightCell{

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白气泡"]];
    imageView.frame = CGRectMake(0, 0, self.textView.bounds.size.width, self.textView.bounds.size.height);
    imageView.backgroundColor = [UIColor clearColor];
    [self.textView addSubview:imageView];


}

//计算cell需要的长度
-(void)getCellHeight{

     self.height =  self.textView.bounds.size.height + 20*scaleH;
}


//获取聊天内容的类型（文字、语音、图片）并生成对应的textview
-(void)getTextViewWithType:(NSString *)type{
    
    if ([type isEqualToString: @"spoken"]) {
        //生成语音的气泡
    }else if ([type isEqualToString: @"text"]){
        //生成文字的气泡
        [self.textView addSubview:self.textChatLabel];
    }else if ([type isEqualToString:@"picture"]){
        //生成图片的气泡
        [self.textView addSubview:self.pictureView];
    }
}


#pragma mark getters
//创建头像
-(UIView *)headView{

    if (!_headView) {
        _headView = [[UIView alloc]init];
        [_headView addSubview:self.headImageView];
    }
    return _headView;
}

//创建头像imageview
-(UIImageView *)headImageView{

    if (!_headImageView) {
        _headImageView  = [[UIImageView alloc]init];
    }
    return _headImageView;
}

//创建聊天内容的view
-(UIView *)textView{

    if (!_textView) {
        _textView = [[UIView alloc]init];
        _textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}

//聊天内容的label
-(UILabel *)textChatLabel{

    if (!_textChatLabel) {
        _textChatLabel = [[UILabel alloc]init];
        _textChatLabel.backgroundColor = [UIColor clearColor];
        [_textChatLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30*scaleW]];
        _textChatLabel.lineBreakMode = UILineBreakModeWordWrap;
        _textChatLabel.numberOfLines = 0;
    }
    return  _textChatLabel;
}

-(UIView *)pictureView{

    if (!_pictureView) {
        _pictureView = [[UIView alloc]init];
        _pictureView.backgroundColor = [UIColor clearColor];
    }
    return _pictureView;
}

@end
