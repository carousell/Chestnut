//
//  CHNTextField.h
//  Chestnut-demo
//
//  Created by Theodore Felix Leo on 19/8/15.
//  Copyright (c) 2015 jyllandsgatan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHNTextField;
@protocol CHNTextFieldDelegate <NSObject>

@optional
- (BOOL)textFieldShouldBeginEditing:(CHNTextField *)textField;
- (BOOL)textFieldShouldEndEditing:(CHNTextField *)textField;
- (void)CHNTextField:(CHNTextField *)textField didUpdateAmount:(NSDecimalNumber *)amount;

@end

@interface CHNTextField : UITextField

@property (strong, nonatomic) NSNumberFormatter *formatter;
@property (assign, nonatomic) BOOL shouldClearOnBeginEditing;
@property (strong, nonatomic) NSDecimalNumber *amount;
@property (weak, nonatomic) id<CHNTextFieldDelegate> CHNTextFieldDelegate;

- (NSString *)decimalAmountString;
- (void)setDecimalAmountString:(NSString *)decimalAmountString;

@end
