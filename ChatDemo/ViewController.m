//
//  ViewController.m
//  ChatDemo
//
//  Created by 孙锐 on 16/7/4.
//  Copyright © 2016年 孙锐. All rights reserved.
//

#import "ViewController.h"
#import "ChatCell.h"
#import "SRChatFrameInfo.h"
#import "SRChatModel.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlyMSC.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,IFlyRecognizerViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *frientTableView;
@property (nonatomic, strong) UILabel *topNameLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *callButton;
@property (nonatomic, strong) UIButton *writeButton;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, strong) UIButton *addImageButton;
@property (nonatomic, strong) UIButton *personButton;
@property (nonatomic, strong) UIButton *spokenButton;
@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) UIView *chatView;
@property (nonatomic, strong) UITapGestureRecognizer *tapToHideKeyboard;
@property (nonatomic, assign) NSString * senderID;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, strong) UILabel *voiceTextLabel;

#define screenWidth

@end

@implementation ViewController

- (void)viewDidLoad {
    self.senderID = @"0001";
    NSArray *arr = [self getData];
    [self.view addSubview:self.inputView];
    _dataArr = [NSMutableArray arrayWithArray:arr];
    _dataSource = [[NSMutableArray alloc]init];
    [self reloadDataSourceWithNumber:20];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [super viewDidLoad];
    [self addAllControl];
    [self.chatTableView setContentOffset:CGPointMake(0,self.chatTableView.bounds.size.height)];
//    [self addVoiceDiscriminate];
    // Do any additional setup after loading the view, typically from a nib.
    //下拉刷新
}
//加载datasource
-(void)reloadDataSourceWithNumber:(long)count{
    _dataSource = [[NSMutableArray alloc]init];
    long dataCount = _dataArr.count;
    if (dataCount>=count) {
        long j=0;
        long m=count;
        for (long i=count; i >0; i--) {
            
            [_dataSource insertObject:_dataArr[dataCount-m] atIndex:j];
            m--;
            j++;
        }
    }else{
        for (int i=0; i<_dataArr.count; i++) {
            [_dataSource insertObject:_dataArr[i] atIndex:i];
        }
    }
}

//添加语音识别

-(void)addVoiceDiscriminate{

    self.iflyRecognizerView = [[IFlyRecognizerView alloc]initWithCenter:self.view.center];
    self.iflyRecognizerView.delegate = self;
    [self.view addSubview:self.iflyRecognizerView];
    [self.iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名,默认目录是documents
    [self.iflyRecognizerView setParameter: @"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //设置返回的数据格式为默认plain
    [self.iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    self.voiceTextLabel.frame = CGRectMake(0*scaleW, 130*scaleH, 400*scaleW, 200*scaleH);
    [self.view addSubview:self.voiceTextLabel];
    [self startListenning:self.iflyRecognizerView];//可以建一个按钮,点击按钮调用此方法
}
//开始识别
- (void)startListenning:(id)sender{
    [self.iflyRecognizerView start];
    NSLog(@"开始识别");
}

//返回文字处理
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [NSMutableString new];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    NSLog(@"DIC:%@",dic);
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    //把相应的控件赋值为result.例如:label.text = result;
    if(self.voiceTextLabel.text){
        self.voiceTextLabel.text=[NSString stringWithFormat:@"%@%@",self.voiceTextLabel.text,result];
    }else{
        self.voiceTextLabel.text=result;
    }
    [self.voiceTextLabel removeFromSuperview];
    self.inputTextField.text = self.voiceTextLabel.text;
    
}
//出错处理
- (void)onError:(IFlySpeechError *)error{
    
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

//加载所有控件
-(void)addAllControl{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.inputTextField.delegate = self;
    [self.view setBackgroundColor:UIChatViewColor];
    [self.view addSubview:self.bottomView];
    [self.inputTextField becomeFirstResponder];
    [self.view addSubview:self.chatView];
    [self.view addSubview:self.topView];
    [self.view addGestureRecognizer:self.tapToHideKeyboard];

}

//代理实现



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    long i= indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *object = _dataSource[i];
    SRChatModel *model = [[SRChatModel alloc]init];
    if ([object[@"senderID"] isEqualToString:self.senderID]) {
        model.isSender = 1;
    }else{
        model.isSender = 0;
    }
    model.senderID = object[@"senderID"];
    model.chatText = object[@"chatText"];
    model.chatContent = object[@"chatContent"];
    model.chatPictureUrl = object[@"chatPictureUrl"];
    ChatCell *cell = [[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier Model:model];
    
    return cell.height+30*scaleH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //获得dataSource；
    long i= indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *object = _dataSource[i];
    SRChatModel *model = [[SRChatModel alloc]init];
    if ([object[@"senderID"] isEqualToString:self.senderID]) {
        model.isSender = 1;
    }else{
        model.isSender = 0;
    }
    model.senderID = object[@"senderID"];
    model.chatText = object[@"chatText"];
    model.chatContent = object[@"chatContent"];
    model.chatPictureUrl = object[@"chatPictureUrl"];
    ChatCell *cell = [[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier Model:model];
    return cell;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.inputTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //点击键盘中send时的事件。
    NSString *innerText = textField.text;
    int count = 0;
    for (int i=0; i<_dataArr.count; i++) {
        count = i+1;
    }
    NSDictionary *dictionary = @{@"senderID":self.senderID,@"chatText":innerText,@"chatContent":@"text",@"chatPictureUrl":@""};
    [_dataArr insertObject:dictionary atIndex:count];
    textField.text = nil;
//    int nowCount = (int)_dataSource.count;
    [self reloadDataSourceWithNumber:20];
    
    [self.chatTableView reloadData];
    NSIndexPath * index  = [NSIndexPath indexPathForRow:_dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];


    return YES;
}


#pragma mark click
//发送语音按钮的点击时间
-(void)turnToCall:(id)sender{

    [self.inputView removeFromSuperview];
    [self.callButton removeFromSuperview];
    self.inputTextField.text = nil;
    [self.bottomView addSubview:self.writeButton];
    [self.bottomView addSubview:self.spokenButton];
}


-(void)startSpoken{

    [self addVoiceDiscriminate];
}


-(void)turnToWrite:(id)sender{

    [self.spokenButton removeFromSuperview];
    [self.writeButton removeFromSuperview];
    [self.bottomView addSubview:self.callButton];
    [self.bottomView addSubview:self.inputView];
    [self.inputTextField becomeFirstResponder];

}

-(void)hideKeyboard:(id)sender{

    [self.inputTextField resignFirstResponder];
}

-(void)showFace:(id)sender{
    
    
}

-(void)addImage:(id)sender{
    
    
}

-(void)showPersonInformation:(id)sender{
    
    
}

-(void)keyboardWillShow:(NSNotification*)notification{
//    NSDictionary*info=[notification userInfo];
    //调整UI位置
    self.bottomView.transform = CGAffineTransformMakeTranslation(0, -271);
    self.chatView.transform = CGAffineTransformMakeTranslation(0, -271);
    self.chatTableView.frame = CGRectMake(0, 0, screenW, 911*scaleH);
}
-(void)keyboardWillHide:(NSNotification*)notification{
    self.chatTableView.frame = CGRectMake(0, 0*scaleH, screenW, 911*scaleH);
    self.bottomView.transform = CGAffineTransformIdentity;
    self.chatView.transform = CGAffineTransformIdentity;
    //在这里调整UI位置
}

-(void) refreshView:(UIRefreshControl *)refresh
{
    long count = _dataSource.count;
    [self reloadDataSourceWithNumber:count+10];
    [self.chatTableView reloadData];
    [refresh endRefreshing];
}


#pragma mark getters
//顶端黑色view的设置
-(UIView *)topView{

    if (!_topView) {
        _topView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, screenW, 125*scaleH)];
        [_topView setBackgroundColor:UIThemeColor];
        [_topView addSubview:self.topNameLabel];
        [_topView addSubview:self.personButton];
    }
    return _topView;
}

//个人信息按钮
-(UIButton *)personButton{

    if (!_personButton) {
        _personButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _personButton.frame = CGRectMake(570*scaleW, 65*scaleH, 38*scaleW, 38*scaleH);
        [_personButton setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
        [_personButton addTarget:self action:@selector(showPersonInformation:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _personButton;
}

//顶端人名label的设置
-(UILabel *)topNameLabel{

    if (!_topNameLabel) {
        _topNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*scaleW, 40*scaleH, 480*scaleW, 85*scaleH)];
        _topNameLabel.textAlignment = NSTextAlignmentCenter;
        _topNameLabel.text = @"孙小原";
        _topNameLabel.textColor = [UIColor whiteColor];
        _topNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:40*scaleW];
    }
    return _topNameLabel;
}

//底端输入文字的view
-(UIView *)bottomView{

    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 1036*scaleH, screenW, 100*screenH)];
        [_bottomView setBackgroundColor:UIBottomViewColor];
        [_bottomView addSubview:self.callButton];
        [_bottomView addSubview:self.inputView];
        [_bottomView addSubview:self.addImageButton];
        [_bottomView addSubview:self.faceButton];
    }
    return _bottomView;
}

//语音输入的按钮
-(UIButton *)callButton{

    if (!_callButton) {
        _callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callButton setImage:[UIImage imageNamed:@"语音"] forState:UIControlStateNormal] ;
        _callButton.frame = CGRectMake(10*scaleW, 23*scaleH, 56*scaleW, 56*scaleH);
        [_callButton addTarget:self action:@selector(turnToCall:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callButton;
}

//文字输入的按钮
-(UIButton *)writeButton{
    
    if (!_writeButton) {
        _writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_writeButton setImage:[UIImage imageNamed:@"文字"] forState:UIControlStateNormal] ;
        _writeButton.frame = CGRectMake(10*scaleW, 23*scaleH, 56*scaleW, 56*scaleH);
        [_writeButton addTarget:self action:@selector(turnToWrite:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _writeButton;
}


//添加本地图片及调用相机使用的按钮
-(UIButton *)addImageButton{
    
    if (!_addImageButton) {
        _addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImageButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal] ;
        _addImageButton.frame = CGRectMake(575*scaleW, 23*scaleH, 56*scaleW, 56*scaleH);
        [_addImageButton addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImageButton;
}

//表情按钮。暂不使用
-(UIButton *)faceButton{
    
    if (!_faceButton) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceButton setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal] ;
        _faceButton.frame = CGRectMake(500*scaleW, 23*scaleH, 56*scaleW, 56*scaleH);
        [_faceButton addTarget:self action:@selector(showFace:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}

//输入框的view
-(UIView *)inputView{
    
    if (!_inputView) {
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(85*scaleW, 15*scaleH, 400*scaleW, 72*scaleH)];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"输入框"]];
        imageView.frame =CGRectMake(0, 0, 400*scaleW, 72*scaleH);
        [_inputView addSubview:imageView];
        [_inputView addSubview:self.inputTextField];
    }
    return _inputView;
}

//输入框的textfield
-(UITextField *)inputTextField{

    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(20*scaleW, 0, 380*scaleW, 72*scaleH)];
        _inputTextField.font = [UIFont systemFontOfSize:33*scaleH];
        _inputTextField.keyboardType = UIKeyboardTypeDefault;
        _inputTextField.returnKeyType =UIReturnKeySend;

        
    }
    return _inputTextField;
}

//按住说话的按钮
-(UIButton *)spokenButton{

    if (!_spokenButton) {
        _spokenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _spokenButton.frame = CGRectMake(85*scaleW, 15*scaleH, 400*scaleW, 72*scaleH);
        [_spokenButton setImage:[UIImage imageNamed:@"输入语音"] forState:UIControlStateNormal];
        [_spokenButton addTarget:self action:@selector(startSpoken) forControlEvents:UIControlEventTouchUpInside];
    }
    return _spokenButton;
}

//聊天界面的tableview
-(UITableView *)chatTableView{

    if (!_chatTableView) {
        _chatTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.802) style:UITableViewStylePlain];
        [_chatTableView registerClass:[ChatCell class] forCellReuseIdentifier:@"Cell"];
        _chatTableView.backgroundColor = UIChatViewColor;
        _chatTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _chatTableView.allowsSelection = NO;
        _chatTableView.dataSource=self;
        _chatTableView.delegate=self;
        _chatTableView.showsVerticalScrollIndicator = NO;
        _chatTableView.contentInset = UIEdgeInsetsMake(12,0, 0, 0);
        NSIndexPath * index  = [NSIndexPath indexPathForRow:1 inSection:0];
        [_chatTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_chatTableView addSubview:self.refreshControl];

    }
    return _chatTableView;
}

//聊天界面的view
-(UIView *)chatView{

    if (!_chatView) {
        _chatView = [[UIView alloc]initWithFrame:CGRectMake(0, 125*scaleH, screenW, 911*scaleH)];
        [_chatView addSubview:self.chatTableView];
    }
    return _chatView;
}

//设置下滑收起键盘的手势
-(UITapGestureRecognizer *)tapToHideKeyboard{
  
    if (!_tapToHideKeyboard) {
        _tapToHideKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    }
    return _tapToHideKeyboard;
}






-(NSArray *)getData{

    NSArray *arr= @[
                    @{@"senderID":@"0001",@"chatText":@"你好韦富钟",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0002",@"chatText":@"这段文字要很长很长，因为我要测试他能不能多换几行",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"这段儿短点",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0002",@"chatText":@"嗯哼",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"发几个表情符号～～～～～～～～ － 。－",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"你好韦富钟",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0002",@"chatText":@"这段文字要很长很长，因为我要测试他能不能多换几行",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"这段儿短点",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0002",@"chatText":@"嗯哼",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"发几个表情符号～～～～～～～～ － 。－",@"chatContent":@"text",@"chatPictureUrl":@""},      @{@"senderID":@"0001",@"chatText":@"你好韦富钟",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0002",@"chatText":@"这段文字要很长很长，因为我要测试他能不能多换几行",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"这段儿短点",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0002",@"chatText":@"嗯哼",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"发几个表情符号～～～～～～～～ － 。－",@"chatContent":@"text",@"chatPictureUrl":@""}
                    ];
    return arr;
}

-(UIRefreshControl *)refreshControl{

    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
        [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松开加载更多"]];

    }
    return _refreshControl;
}

-(UILabel *)voiceTextLabel{

    if (!_voiceTextLabel) {
        _voiceTextLabel = [[UILabel alloc]init];
        _voiceTextLabel.backgroundColor = [UIColor grayColor];
        _voiceTextLabel.alpha = 0.8 ;
        _voiceTextLabel.font = [UIFont systemFontOfSize:50*scaleW];
        _voiceTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _voiceTextLabel;
}

@end
