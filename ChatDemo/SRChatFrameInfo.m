//
//  SRChatFrameInfo.m
//  ChatDemo
//
//  Created by 孙锐 on 16/7/7.
//  Copyright © 2016年 孙锐. All rights reserved.
//

#import "SRChatFrameInfo.h"
#import "SRChatModel.h"
#import <UIKit/UIKit.h>

@implementation SRChatFrameInfo


- (instancetype)initWithModel:(SRChatModel *)model
{
    self = [super init];
    if (self) {
        [self setCellFrameWithModel:model];
    }
    return self;
}


//获取聊天信息的model
-(void)setCellFrameWithModel:(SRChatModel *)model{
    if ([model.chatContent isEqualToString:@"text"]) {
        [self getObjectFrameOfTextViewWithChatContent:model.chatContent AndInfo:model.chatText];
    }else if([model.chatContent isEqualToString:@"picture"]){
        [self getObjectFrameOfTextViewWithChatContent:model.chatContent AndInfo:model.chatPictureUrl];
    }
    [self getTextViewFrameWithisSender:model.isSender AndChatContent:model.chatContent];
    [self getHeadViewFrameWithisSender:model.isSender];
    [self getHeadImageViewFrame];
}
//获取头像view的坐标
-(void)getHeadViewFrameWithisSender:(BOOL)isSender{

    if (isSender == 0) {
        self.headViewFrame = CGRectMake(20*scaleW, 0, 80*scaleW, 80*scaleH);
    }else{
        self.headViewFrame = CGRectMake(screenW-100*scaleW, 0, 80*scaleW, 80*scaleH);
    }
}
//获取聊天内容气泡的view
-(void)getTextViewFrameWithisSender:(BOOL)isSender AndChatContent:(NSString *)chatContent{

    if (isSender == 0) {
        if ([chatContent isEqualToString:@"text"]) {
            self.textViewFrame = CGRectMake(120*scaleW, 0, self.textLabelWidth+50*scaleW, self.textLabelFrame.size.height+40*scaleH);
        }else if ([chatContent isEqualToString:@"picture"]){
            self.textViewFrame = CGRectMake(120*scaleW, 0, self.pictureViewFrame.size.width+20*scaleW,self.pictureViewFrame.size.height+20*scaleH);
        }
    }else{
        if ([chatContent isEqualToString:@"text"]) {
            self.textViewFrame = CGRectMake(screenW-180*scaleW-self.textLabelWidth, 0, self.textLabelWidth+60*scaleW, self.textLabelFrame.size.height+40*scaleH);
        }else if ([chatContent isEqualToString:@"picture"]){
            self.textViewFrame = CGRectMake(screenW-140*scaleW-self.pictureViewFrame.size.width, 0, self.pictureViewFrame.size.width+20*scaleW, self.pictureViewFrame.size.height+20*scaleH);
        }
    }
    self.cellHeight = self.textViewFrame.size.height;
}
//获取头像view中的imageview的位置
-(void)getHeadImageViewFrame{
 
    self.headImageViewFrame = CGRectMake(0, 0, self.headViewFrame.size.width, self.headViewFrame.size.height);
}
//获取聊天气泡中的控件frame(语音除外)
-(void)getObjectFrameOfTextViewWithChatContent:(NSString *)chatContent AndInfo:(NSString *)info{

    if ([chatContent isEqualToString:@"text"]) {
        //如果发送内容为文字，计算文字高度。
        CGSize textLabelSize;
//        textLabelSize = CGSizeMake(350*scaleW, 60*scaleH);
        textLabelSize = [info boundingRectWithSize:CGSizeMake(350*scaleW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:30*scaleW]} context:nil].size;
        self.textLabelWidth = textLabelSize.width;
        self.textLabelFrame = CGRectMake(30*scaleW, 20*scaleH, textLabelSize.width, textLabelSize.height);
    }else if ([chatContent isEqualToString:@"picture"]){
        //如果发送内容为图片，设置图片尺寸。
        NSURL *url = [NSURL URLWithString:info];
        UIImage *image;
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        //计算图片合理尺寸
        CGFloat standardWidthHeightRatio = kPictureImageViewMaxWidth / kPictureImageViewMaxHeight;
        CGFloat widthHeightRatio = 0;
        CGFloat h = image.size.height;
        CGFloat w = image.size.width;
        if (w > kPictureImageViewMaxWidth || w > kPictureImageViewMaxHeight) {
            widthHeightRatio = w / h;
            if (widthHeightRatio > standardWidthHeightRatio) {
                w = kPictureImageViewMaxWidth;
                h = w * (image.size.height / image.size.width);
            } else {
                h = kPictureImageViewMaxHeight;
                w = h * widthHeightRatio;
            }
        }
        //设置图片内容的尺寸
        self.pictureViewFrame = CGRectMake(10*scaleW, 10*scaleH, w, h);
    }
}



@end
