//
//  DataManager.m
//  ConverterDemo
//
//  Created by Artur Guseinov on 22/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import "DataManager.h"


@implementation DataManager

static NSString *identifier = @"ExchangeCell";
static NSUInteger topCollectionViewTag = 1001;
static NSUInteger bottomCollectionViewTag = 1002;


- (instancetype)initWithDelegate:(id <DataManagerDelegate>)delegate
{
  self = [super init];
  if (self) {
    self.delegate = delegate;
  }
  return self;
}

- (void)selectCurrencyAtIndex:(NSUInteger)index {
  self.selectedCurrency = self.currencies[index];
}

// MARK: - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.currencies.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ExchangeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  cell.tag = indexPath.row;
  
  Currency *currency = self.currencies [indexPath.row];
  cell.currencyLabel.text = currency.currencyString;
  cell.balanceLabel.text = [NSString stringWithFormat:@"You have %@ %.2f", currency.returnCurrencySymbol, currency.amount];
  
  if (collectionView.tag == topCollectionViewTag) {
    cell.delegate = self;
  } else if (collectionView.tag == bottomCollectionViewTag) {
    cell.valueTextField.userInteractionEnabled = NO;
    cell.balanceLabel.textColor = [UIColor whiteColor];
    cell.balanceLabel.alpha = 0.5;
    
    if (self.selectedCurrency.rateList.rates) {
      
      if (self.selectedCurrency.currencyString == currency.currencyString) {
        cell.valueTextField.text = @"-";
        return cell;
      }
      
      NSDictionary* json = [NSJSONSerialization JSONObjectWithData:self.selectedCurrency.rateList.rates
                                                           options:kNilOptions
                                                             error:nil];
      NSString *rateString = (NSString *)json[currency.currencyString];
      float rate = rateString.floatValue;
      cell.valueTextField.text = [NSString stringWithFormat:@"%.2f", self.valueForExchange * rate];
    }
  }
  
  return cell;
}


// MARK: - ExchangeCellDelegate

- (void)textFieldValueDidChangedTo:(float)value inCellWithIndex:(NSUInteger)index {
  
  self.valueForExchange = value;
  
  if ([self.delegate respondsToSelector:@selector(reloadBottomCollectionView)]) {
    [self.delegate reloadBottomCollectionView];
  }
  
}


@end
