/*
 
 GSLimitationChecker.h
 
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

#import <Foundation/Foundation.h>

//helping protocol for press button events
@protocol GSLimitationCheckerDelegate <NSObject>

//Button in the alert will be pressed
- (void)pressedButton;

@end


/*! Class to check wether the limit is already over.*/
@interface GSLimitationChecker : NSObject<UIAlertViewDelegate>

//delegate for the alert with button
@property(nonatomic,weak) id<GSLimitationCheckerDelegate> delegate;

/** Method to get the singleton instance of Limitationchecker.
 *  @return the instance of GSLimitationChecker
 */
+ (GSLimitationChecker*)sharedInstance;

/** Method to set the expire date and show the message.
 *  @param expireDate is the date of expire
 *  @param title is the title of the alert
 *  @param message is the text which will be shown
 */
- (void)expiredAt:(NSDate*)expireDate withTitle:(NSString*)title withMessage:(NSString*)message;

/** Method to set the expire date and show the message.
 *  @param expireDate is the date of expire
 *  @param target is the object which can handle the pressedButton
 *  @param label is the button label for the alert
 *  @param title is the title of the alert
 *  @param message is the text which will be shown
 */
- (void)expiredAt:(NSDate *)expireDate forTarget:(id<GSLimitationCheckerDelegate>)target andButtonLabel:(NSString*)label withTitle:(NSString *)title withMessage:(NSString *)message;

/** Method to kill all checker
 *
 */
- (void)killAllChecker;
@end
