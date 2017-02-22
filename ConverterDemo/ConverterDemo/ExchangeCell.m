//
//  ExchangeCell.m
//  ConverterDemo
//
//  Created by Artur Guseinov on 20/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import "ExchangeCell.h"

@interface ExchangeCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;


@end

@implementation ExchangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


// MARK: - UITextFieldDelegate

@end
