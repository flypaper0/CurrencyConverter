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

- (void)prepareForReuse {
    self.valueTextField.text = @"";
}


// MARK: - UITextFieldDelegate
- (IBAction)valueDidChanged:(UITextField *)sender {
    NSString *value = [[sender.text stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (([self.delegate respondsToSelector:@selector(textFieldValueDidChangedTo:inCellWithIndex:)])) {
        [self.delegate textFieldValueDidChangedTo: value.floatValue inCellWithIndex: self.tag];
    }
    sender.text = [NSString stringWithFormat:@"- %@", value];
}

@end
