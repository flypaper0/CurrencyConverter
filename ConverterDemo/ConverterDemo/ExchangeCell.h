//
//  ExchangeCell.h
//  ConverterDemo
//
//  Created by Artur Guseinov on 20/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExchangeCellDelegate <NSObject>

- (void)textFieldValueDidChangedTo:(float)value inCellWithIndex:(NSUInteger)index;

@end


@interface ExchangeCell : UICollectionViewCell

@property (weak, nonatomic) id <ExchangeCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end
