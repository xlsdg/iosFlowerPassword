//
//  LZTViewController.m
//  FlowerPassword
//
//  Created by xLsDg on 14-8-12.
//  Copyright (c) 2014年 Xiao Lu Software Development Group. All rights reserved.
//

#import "LZTViewController.h"
#import "LZTFlowerPassword.h"

@interface LZTViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *keyField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;

- (IBAction)copyCode:(id)sender;
- (IBAction)copyInfo:(id)sender;
- (IBAction)fieldChange:(id)sender;
@end

@implementation LZTViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.codeField.layer.borderWidth = 2.0f;
    self.codeField.layer.borderColor = [[UIColor colorWithRed:22.0f/255.0f
                                                        green:139.0f/255.0f
                                                         blue:195.0f/255.0f
                                                        alpha:1.0]
                                        CGColor];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(keyboardWillHide:)
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardDidShow:(NSNotification*)notif {
    NSDictionary *userInfo = [notif userInfo];
    NSValue *keyboardInfo = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [keyboardInfo CGRectValue].size;

    CGRect keyFieldFrame = self.keyField.frame;

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        int offset = keyFieldFrame.origin.y + 40 - (self.view.frame.size.width - keyboardSize.width);
        if (offset>0) {
            self.view.frame = CGRectMake(offset, 0, self.view.frame.size.width, self.view.frame.size.height);
        }
    }

    NSTimeInterval animationDuration = 0.30f;

    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notif {
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.pwdField resignFirstResponder];
    [self.keyField resignFirstResponder];
}

- (IBAction)copyCode:(id)sender {
    if (([[self.pwdField text] length] > 0) && ([[self.keyField text] length] > 0)) {
        LZTFlowerPassword *fp = [[LZTFlowerPassword alloc] initWithPassword:self.pwdField.text
                                                                      key:self.keyField.text];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:[fp getCode]];
        [self.codeField setText:[fp code]];
    }
}

- (IBAction)copyInfo:(id)sender {
    if (([[self.pwdField text] length] > 0) && ([[self.keyField text] length] > 0)) {
        [self.codeField setText:@"复制成功"];
    }
}

- (IBAction)fieldChange:(id)sender {
    if (([[self.pwdField text] length] > 0) && ([[self.keyField text] length] > 0)) {
        LZTFlowerPassword *fp = [[LZTFlowerPassword alloc] init];
        [self.codeField setText:[fp calcWithPassword:self.pwdField.text key:self.keyField.text]];

    } else {
        [self.codeField setText:@""];
    }
}

@end
