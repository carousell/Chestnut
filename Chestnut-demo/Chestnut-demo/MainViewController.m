//
//  MainViewController.m
//  Chestnut-demo
//
//  Created by Theodore Felix Leo on 19/8/15.
//  Copyright (c) 2015 jyllandsgatan. All rights reserved.
//

#import "MainViewController.h"

#import "CHNTextField.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    tableView.rowHeight = 44;
    tableView.allowsSelection = NO;
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PriceCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PriceCell"];
        cell.textLabel.text = @"Item Price";
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_TW"];
        formatter.maximumFractionDigits = 0;
        CHNTextField *priceTextField = [[CHNTextField alloc] initWithFrame:CGRectMake(140, 0, 170, 44)];
        priceTextField.formatter = formatter;
        priceTextField.placeholder = @"Set Price";
        priceTextField.minimumFontSize = 10;
        priceTextField.adjustsFontSizeToFitWidth = YES;
        priceTextField.clearButtonMode = UITextFieldViewModeNever;
        priceTextField.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:priceTextField];
    }
    return cell;
}


@end
