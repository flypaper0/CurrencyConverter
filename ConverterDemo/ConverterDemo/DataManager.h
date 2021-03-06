//
//  DataManager.h
//  ConverterDemo
//
//  Created by Artur Guseinov on 22/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RateListService.h"
#import "StorageService.h"
#import "ExchangeCell.h"


@protocol DataManagerDelegate <NSObject>

- (void)reloadBottomCollectionView;

@end


@interface DataManager : NSObject <UICollectionViewDataSource, ExchangeCellDelegate>

@property (weak, nonatomic) id <DataManagerDelegate> delegate;
@property (strong, nonatomic) NSArray<Currency *> * currencies ;
@property (strong, nonatomic) Currency *selectedTopCurrency;
@property (strong, nonatomic) Currency *selectedBottomCurrency;
@property float valueForExchange;

- (instancetype)initWithDelegate:(id <DataManagerDelegate>)delegate;

- (void)selectTopCurrencyAtIndex:(NSUInteger)index;
- (void)selectBottomCurrencyAtIndex:(NSUInteger)index;
- (BOOL)isCurrenciesEqual;

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
