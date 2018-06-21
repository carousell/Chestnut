//
//  CRSCurrencyField.m
//  Chestnut-demo
//
//  Created by Theodore Felix Leo on 6/14/17.
//  Copyright © 2017 jyllandsgatan. All rights reserved.
//

#import "CRSCurrencyField.h"

@implementation CRSCurrencyField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addTarget:self action:@selector(editingDidBegin:a:) forControlEvents:UIControlEventEditingDidBegin];

    }
    return self;
}

- (void)editingChanged:(UITextField *)textField {
    NSLog(@"%@", textField.text);
    textField.text = @"lol";
}

- (void)editingDidBegin:(UITextField *)textField a:(id)a {

}

@end
