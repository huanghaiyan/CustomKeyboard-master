//
//  ViewController.m
//  CustomKeyboard-master
//
//  Created by 黄海燕 on 17/1/5.
//  Copyright © 2017年 huanghy. All rights reserved.
//

#import "ViewController.h"

#define KEY_WIDTH 106
#define KEY_HEIGHT 53


@interface ViewController ()
@property(nonatomic, strong) UITextField *textF;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.textF.keyboardType = UIKeyboardTypeNumberPad;
    self.textF.borderStyle = UITextBorderStyleRoundedRect;
    self.textF.backgroundColor = [UIColor redColor];
    self.textF.center = self.view.center;
    [self.textF addTarget:self action:@selector(editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.view addSubview:self.textF];

    
}
#pragma mark - 处理TextField响应事件
- (void)editingDidBegin:(UITextField *)textF {
    [self.textF becomeFirstResponder];
}

//3.实现通知处理
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    if (doneInKeyboardButton.superview)
    {
        [doneInKeyboardButton removeFromSuperview];
    }
    
}

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat normalKeyboardHeight = kbSize.height;
    int cnt = [[UIApplication sharedApplication] windows].count;
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:cnt-1];
    // create custom button
    if (doneInKeyboardButton == nil)
    {
        doneInKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        doneInKeyboardButton.frame = CGRectMake(18, tempWindow.frame.size.height-53, 106, 53);
        
        doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        [doneInKeyboardButton setImage:[UIImage imageNamed:@"fingerprint.png"] forState:UIControlStateNormal];
        [doneInKeyboardButton setImage:[UIImage imageNamed:@"fingerprint.png"] forState:UIControlStateHighlighted];
        [doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    // locate keyboard view
    
    
    if (doneInKeyboardButton.superview == nil)
    {
        // 注意这里直接加到window上
        [tempWindow addSubview:doneInKeyboardButton];
    }
    
}  

-(void)finishAction
{
    NSLog(@"指纹");
}

#pragma mark - 处理视图响应事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textF resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //1. 先注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//2. 在dealloc中反注册通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
