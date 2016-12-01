//
//  ChatCell.h
//  ChatDemo
//
//  Created by 孙锐 on 16/7/5.
//  Copyright © 2016年 孙锐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SRChatFrameInfo.h"
#import "SRChatModel.h"

@interface ChatCell : UITableViewCell
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) UILabel *textChatLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) NSString *chatType;
@property (nonatomic, strong) UIView *pictureView;
@property (nonatomic, strong) NSURL *pictureUrl;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat textLabelWidth;
@property (nonatomic, assign) NSTimeInterval *voiceLength;
@property (nonatomic, strong) SRChatFrameInfo *frameInfo;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Model:(SRChatModel *)model;

@end
