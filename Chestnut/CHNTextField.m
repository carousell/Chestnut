//
//  CHNTextField.m
//  Chestnut-demo
//
//  Created by Theodore Felix Leo on 19/8/15.
//  Copyright (c) 2015 jyllandsgatan. All rights reserved.
//

#import "CHNTextField.h"

#define MAX_PRICE @"9999999999999"
#define MAX_PRICE_DIGITS 13

@interface CHNTextFieldDelegateWrapper : NSObject <UITextFieldDelegate>

@end

@interface CHNTextField ()

@property (strong, nonatomic) CHNTextFieldDelegateWrapper *delegateWrapper;
@property (strong, nonatomic) NSDecimalNumber *price;
@property (strong, nonatomic) NSMutableString *normalizedPriceString;

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

- (void)dealloc {
    self.delegate = nil;
}

- (void)initialize {
    CHNTextFieldDelegateWrapper *delegateWrapper = [[CHNTextFieldDelegateWrapper alloc] init];
    self.delegateWrapper = delegateWrapper;
    self.delegate = delegateWrapper;
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.normalizedPriceString = [NSMutableString string];
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
    _formatter.minimumFractionDigits = _formatter.maximumFractionDigits;
}

- (void)setText:(NSString *)text {
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:text locale:[NSLocale localeWithLocaleIdentifier:@"en"]];
    if (price == [NSDecimalNumber notANumber]) {
        super.text = @"";
        self.price = [NSDecimalNumber zero];
        self.normalizedPriceString = [NSMutableString string];
    } else {
        super.text = [self.formatter stringFromNumber:price];
        self.price = price;
    }
}

@end

@implementation CHNTextFieldDelegateWrapper

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    CHNTextField *priceTextField = (CHNTextField *)textField;
    NSNumberFormatter *formatter = priceTextField.formatter;

    NSMutableString *normalizedPriceString = priceTextField.normalizedPriceString;
    if (string.length) {
        if (normalizedPriceString.length >= MAX_PRICE_DIGITS) {
            [normalizedPriceString setString:MAX_PRICE];
        } else {
            [normalizedPriceString appendString:[NSString stringWithFormat:@"%ld", (long)[string integerValue]]];
        }
    } else {
        if (normalizedPriceString.length > 1) {
            [normalizedPriceString deleteCharactersInRange:NSMakeRange(normalizedPriceString.length - 1, 1)];
        } else {
            [normalizedPriceString setString:@"0"];
        }
    }
    
    priceTextField.text = normalizedPriceString;
    
    NSMutableString *priceString = [normalizedPriceString mutableCopy];
    NSInteger maximumFractionDigits = formatter.maximumFractionDigits;
    if (maximumFractionDigits > 0) {
        while (priceString.length <= maximumFractionDigits) {
            [priceString insertString:@"0" atIndex:0];
        }
        [priceString insertString:@"." atIndex:priceString.length - maximumFractionDigits];
    }
    
    priceTextField.text = priceString;
    return NO;
}

@end
