/*
 
 GSLimitationChecker.m
 
 Copyright (c) 2013 Truong Vinh Tran
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "GSLimitationChecker.h"

#define GSLIMITATION_INTERVAL 5

@interface GSLimitationChecker()

//timer to launch the message
@property(nonatomic,retain) NSTimer *timer;

//date when it will be expire
@property(nonatomic,retain) NSDate *expire;

//title shwon in the alert
@property(nonatomic,retain) NSString* title;

//message shown after expired
@property(nonatomic,retain) NSString *msg;

//alert for blocking actions
@property(nonatomic,retain) UIAlertView *alert;

@property(nonatomic,retain) NSString *buttonLabel;

/** Method is used to check every interval for the valid date.
 *
 */
- (void)checkInterval;

@end

@implementation GSLimitationChecker

@synthesize timer;
@synthesize expire;
@synthesize title = _title;
@synthesize msg = _msg;
@synthesize alert;
@synthesize delegate = _delegate;
@synthesize buttonLabel;

static GSLimitationChecker *instance = nil;

- (void)appDidEnterBackground{
  if(self.alert){
    [self.alert dismissWithClickedButtonIndex:0 animated:NO];
    self.alert = nil;
  }
}

- (void)appDidEnterForeground{
  dispatch_async(dispatch_get_main_queue(), ^{
    [self checkInterval];
  });
}



- (void)checkInterval{
  
  if (self.expire) {
    NSDate *now = [NSDate date];
    NSDate *endDate = self.expire;
    
    if ([now compare:endDate] == NSOrderedDescending&&!self.alert) {
      if (_delegate) {
        //alert with OK button
        self.alert = [[UIAlertView alloc] initWithTitle:_title message:_msg delegate:self cancelButtonTitle:nil otherButtonTitles:self.buttonLabel,nil];
      }else{
        //already expired
        self.alert = [[UIAlertView alloc] initWithTitle:_title message:_msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.alert show];
      });
    }
  }
}

- (void)initAll{
  
  //app went to background. dismiss it and let the timer relaunch it
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(appDidEnterBackground)
                                               name:UIApplicationDidEnterBackgroundNotification
                                             object:nil];
  
  //app went to foreground. continue
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(appDidEnterForeground)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
}

+ (GSLimitationChecker*)sharedInstance{
  if (instance==nil) {
    instance = [[super allocWithZone:NULL] init];
    [instance initAll];
  }
  return instance;
}


#pragma mark - Implementations

- (void)expiredAt:(NSDate*)expireDate withTitle:(NSString*)title withMessage:(NSString*)message{
  
  if(!self.timer){
    //check before the timer start
    [self appDidEnterForeground];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:GSLIMITATION_INTERVAL target:self selector:@selector(checkInterval) userInfo:nil repeats:YES];
  }
  self.expire = expireDate;
  _title = title;
  _msg = message;
}

- (void)expiredAt:(NSDate *)expireDate forTarget:(id<GSLimitationCheckerDelegate>)target andButtonLabel:(NSString*)label withTitle:(NSString *)title withMessage:(NSString *)message{
  if(!self.timer){
    //check before the timer start
    [self appDidEnterForeground];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:GSLIMITATION_INTERVAL target:self selector:@selector(checkInterval) userInfo:nil repeats:YES];
  }
  self.expire = expireDate;
  _title = title;
  _msg = message;
  
  _delegate = target;
  self.buttonLabel = label;
}

- (void)killAllChecker{
  self.expire = nil;
  [self.timer invalidate];
  
  //remove the alert
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
  });
  
  //remove both notification
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Alert Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
  if (alertView.cancelButtonIndex != buttonIndex) {
    if (_delegate) {
      if ([_delegate respondsToSelector:@selector(pressedButton)]) {
        [_delegate pressedButton];
      }
    }
  }
}

@end
