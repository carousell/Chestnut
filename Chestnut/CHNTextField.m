//
//  CHNTextField.m
//  Chestnut-demo
//
//  Created by Theodore Felix Leo on 19/8/15.
//  Copyright (c) 2015 jyllandsgatan. All rights reserved.
//

#import "CHNTextField.h"

#define MAX_VALUE   @"9999999999999"
#define MAX_DIGITS  13

@interface CHNTextFieldDelegateWrapper : NSObject <UITextFieldDelegate>
@property (weak, nonatomic) id<CHNTextFieldDelegate> delegate;
@end

@interface CHNTextField ()

@property (strong, nonatomic) CHNTextFieldDelegateWrapper *delegateWrapper;
@property (strong, nonatomic) NSMutableString *amountNormalizedString;

@end

@implementation CHNTextField

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)dealloc {
    self.delegate = nil;
}

- (void)initialize {
    CHNTextFieldDelegateWrapper *delegateWrapper = [[CHNTextFieldDelegateWrapper alloc] init];
    self.delegateWrapper = delegateWrapper;
    self.delegate = delegateWrapper;
    self.keyboardType = UIKeyboardTypeDecimalPad;
    self.amountNormalizedString = [NSMutableString string];
}

- (void)setCHNTextFieldDelegate:(id<CHNTextFieldDelegate>)CHNTextFieldDelegate {
    self.delegateWrapper.delegate = CHNTextFieldDelegate;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (self.clearButtonMode == UITextFieldViewModeNever) {
        return [super editingRectForBounds:bounds];
    } else {
        CGRect original = [super editingRectForBounds:bounds];
        original.size.width += 10;
        return original;
    }
}

- (void)setFormatter:(NSNumberFormatter *)formatter {
    _formatter = formatter;
    NSInteger fractionDigits = _formatter.maximumFractionDigits > 0 ? 2 : 0;
    _formatter.maximumFractionDigits = fractionDigits;
    _formatter.minimumFractionDigits = fractionDigits;
}

- (void)setAmount:(NSDecimalNumber *)amount {
    _amount = amount;
    if (amount) {
        NSMutableString *decimalString = [[amount stringValue] mutableCopy];
        NSInteger maximumFractionDigits = self.formatter.maximumFractionDigits;
        NSRange decimalPointRange = [decimalString rangeOfString:@"." options:NSBackwardsSearch];
        if (maximumFractionDigits <= 0) {
            if (decimalPointRange.location != NSNotFound) {
                [decimalString replaceCharactersInRange:NSMakeRange(decimalPointRange.location, decimalString.length - decimalPointRange.location) withString:@""];
            }
        } else {
            if (decimalPointRange.location == NSNotFound) {
                [decimalString appendString:@"."];
                decimalPointRange.location = decimalString.length - 1;
            }
            while (decimalString.length - decimalPointRange.location < maximumFractionDigits + 1) {
                [decimalString appendString:@"0"];
            }
            [decimalString replaceOccurrencesOfString:@"." withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, decimalString.length)];
        }
        self.amountNormalizedString = decimalString;
    } else {
        self.amountNormalizedString = [NSMutableString string];
    }
    self.text = [self.formatter stringFromNumber:amount];
}

- (NSString *)decimalAmountString {
    if (!self.amount) {
        return nil;
    }
    
    NSMutableString *decimalAmountString = [NSMutableString stringWithString:[self.amount stringValue]];
    NSInteger maximumFractionDigits = self.formatter.maximumFractionDigits;
    NSRange decimalPointRange = [decimalAmountString rangeOfString:@"." options:NSBackwardsSearch];
    if (maximumFractionDigits > 0 && decimalPointRange.location != NSNotFound) {
        while (decimalAmountString.length - decimalPointRange.location < maximumFractionDigits + 1) {
            [decimalAmountString appendString:@"0"];
        }
    }
    return [NSString stringWithString:decimalAmountString];
}

- (void)setDecimalAmountString:(NSString *)decimalAmountString {
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:decimalAmountString locale:[NSLocale localeWithLocaleIdentifier:@"en"]];
    NSInteger fractionDigits = self.formatter.maximumFractionDigits;
    NSDecimalNumberHandler *roundBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:fractionDigits raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    amount = [amount decimalNumberByRoundingAccordingToBehavior:roundBehavior];
    self.amount = amount;
}

#pragma mark Private

- (void)updateAmount:(NSDecimalNumber *)amount {
    _amount = amount;
    self.text = [self.formatter stringFromNumber:amount];
}

@end

@implementation CHNTextFieldDelegateWrapper

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
		CHNTextField *currentTextField = (CHNTextField *)textField;
		return [self.delegate textFieldShouldBeginEditing:currentTextField];
	}
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        CHNTextField *currentTextField = (CHNTextField *)textField;
        return [self.delegate textFieldShouldEndEditing:currentTextField];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    CHNTextField *currencyTextField = (CHNTextField *)textField;
    currencyTextField.amount = nil;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    CHNTextField *currencyTextField = (CHNTextField *)textField;
    NSNumberFormatter *formatter = currencyTextField.formatter;
    
    if (currencyTextField.shouldClearOnBeginEditing) {
        currencyTextField.amount = [NSDecimalNumber zero];
        currencyTextField.shouldClearOnBeginEditing = NO;
    }
    
    NSInteger maximumFractionDigits = formatter.maximumFractionDigits;
    NSMutableString *amountNormalizedString = currencyTextField.amountNormalizedString;
    if (string.length) {
        if (amountNormalizedString.length >= MAX_DIGITS) {
            [amountNormalizedString setString:MAX_VALUE];
        } else {
            [amountNormalizedString appendString:[NSString stringWithFormat:@"%ld", (long)[string integerValue]]];
        }
    } else {
        if (amountNormalizedString.length > 1) {
            [amountNormalizedString deleteCharactersInRange:NSMakeRange(amountNormalizedString.length - 1, 1)];
        } else {
            [amountNormalizedString setString:@"0"];
        }
    }
    
    NSMutableString *decimalString = [amountNormalizedString mutableCopy];
    if (maximumFractionDigits > 0) {
        while (decimalString.length <= maximumFractionDigits) {
            [decimalString insertString:@"0" atIndex:0];
        }
        [decimalString insertString:@"." atIndex:decimalString.length - maximumFractionDigits];
    }
    
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:decimalString locale:[NSLocale localeWithLocaleIdentifier:@"en"]];
    [currencyTextField updateAmount:amount];

    if ([self.delegate respondsToSelector:@selector(CHNTextField:didUpdateAmount:)]) {
        [self.delegate CHNTextField:currencyTextField didUpdateAmount:amount];
    }
    
    return NO;
}

@end
