//
//  ExchangeCell.m
//  ConverterDemo
//
//  Created by Artur Guseinov on 20/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import "ExchangeCell.h"

@interface ExchangeCell () <UITextFieldDelegate>

@end

@implementation ExchangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


// MARK: - UITextFieldDelegate
- (IBAction)valueDidChanged:(UITextField *)sender {
    if (([self.delegate respondsToSelector:@selector(textFieldValueDidChangedTo:inCellWithIndex:)])) {
        [self.delegate textFieldValueDidChangedTo: sender.text.floatValue inCellWithIndex: self.tag];
    }
}

- (void)prepareForReuse {
    self.valueTextField.text = @"";
}

@end
