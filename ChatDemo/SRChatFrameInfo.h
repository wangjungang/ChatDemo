//
//  SRChatFrameInfo.h
//  ChatDemo
//
//  Created by 孙锐 on 16/7/7.
//  Copyright © 2016年 孙锐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SRChatModel.h"

@class SRChatModel;

@interface SRChatFrameInfo : NSObject

@property (nonatomic, assign) CGFloat textLabelWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGRect headViewFrame;
@property (nonatomic, assign) CGRect textViewFrame;
@property (nonatomic, assign) CGRect headImageViewFrame;
@property (nonatomic, assign) CGRect textLabelFrame;
@property (nonatomic, assign) CGRect pictureViewFrame;


- (instancetype)initWithModel:(SRChatModel *)model;


@end
