//
//  SRChatModel.h
//  ChatDemo
//
//  Created by 孙锐 on 16/7/7.
//  Copyright © 2016年 孙锐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRChatModel : NSObject

@property (nonatomic, strong) NSString *chatContent;
@property (nonatomic, strong) NSString *chatText;
@property (nonatomic, strong) NSString *chatPictureUrl;
@property (nonatomic, strong) NSString *chatSpoken;
@property (nonatomic, strong) NSString *senderID;
@property (nonatomic, strong) NSString *senderHeadImageUrl;
@property (nonatomic, strong) NSString *creatTime;
@property (nonatomic, assign) BOOL isSender;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
