//
//  MainViewController.m
//  Chestnut-demo
//
//  Created by Theodore Felix Leo on 19/8/15.
//  Copyright (c) 2015 jyllandsgatan. All rights reserved.
//

#import "MainViewController.h"

#import "CHNTextField.h"
#import "CRSCurrencyField.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) CHNTextField *priceTextField;

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
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(40, 10, 240, 44)];
    [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Log price" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    tableView.tableFooterView = button;
    tableView.tableFooterView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapButton:(id)sender {
    NSLog(@"%@", [self.priceTextField amount]);
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
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
            self.priceTextField = priceTextField;
            [cell.contentView addSubview:priceTextField];
        }
        return cell;
    } else if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PriceCell2"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PriceCell2"];
            cell.textLabel.text = @"Item Price";
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterCurrencyStyle;
            formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_TW"];
            formatter.maximumFractionDigits = 0;
            CRSCurrencyField *priceTextField = [[CRSCurrencyField alloc] initWithFrame:CGRectMake(140, 0, 170, 44)];
//            priceTextField.formatter = formatter;
            priceTextField.placeholder = @"Set Price";
            priceTextField.minimumFontSize = 10;
            priceTextField.adjustsFontSizeToFitWidth = YES;
            priceTextField.clearButtonMode = UITextFieldViewModeNever;
            priceTextField.textAlignment = NSTextAlignmentRight;
//            self.priceTextField = priceTextField;
            [cell.contentView addSubview:priceTextField];
        }
        return cell;
    }
    return nil;
}


@end
