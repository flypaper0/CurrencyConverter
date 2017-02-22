//
//  DataManager.m
//  ConverterDemo
//
//  Created by Artur Guseinov on 22/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import "DataManager.h"
#import "ExchangeCell.h"


@implementation DataManager

static NSString *identifier = @"ExchangeCell";

- (instancetype)initWithDelegate:(id <DataManagerDelegate>)delegate
{
  self = [super init];
  if (self) {
    self.delegate = delegate;
  }
  return self;
}


// MARK: - RateListServiceDelegate

- (void)didReceivedRateList:(RateList*)rateList {
  NSLog(@"%@", rateList);
}

- (void)didFailedWithError:(NSError *)error {
  
}


// MARK: - StorageServiceDelegate

- (void)didReceivedBalancesFromStorage:(NSArray<Balance *> *)balances {
  
}

- (void)didUpdateBalances:(NSArray<Balance *> *)balance atIndexes:(NSArray<NSNumber *> *)indexes {
  NSLog(@"%@", indexes);
}


// MARK: - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 3;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ExchangeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  return cell;
}


@end
