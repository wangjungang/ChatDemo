//
//  SRChatModel.m
//  ChatDemo
//
//  Created by 孙锐 on 16/7/7.
//  Copyright © 2016年 孙锐. All rights reserved.
//

#import "SRChatModel.h"

@implementation SRChatModel


- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        //聊天内容类型（文字语音图片）
        self.chatContent = dict[@"chatContent"];
        if ([self.chatContent isEqualToString:@"text"]) {
            self.chatText = dict[@"chatText"];
        }else if([self.chatContent isEqualToString:@"picture"]){
            self.chatPictureUrl = dict[@"chatPictureUrl"];
        }else if([self.chatContent isEqualToString:@"chatSpoken"]){
            self.chatSpoken = dict[@"chatSpoken"];
        }
        //发送信息的用户ID
        self.senderID = dict[@"senderID"];
        //用户头像的URL
        self.senderHeadImageUrl = dict[@"senderHeadImageUrl"];
        //聊天生成的时间
        self.creatTime = dict[@"creatTime"];
    }
    return self;
}


@end
