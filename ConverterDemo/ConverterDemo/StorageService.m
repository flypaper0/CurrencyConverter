//
//  StorageService.m
//  ConverterDemo
//
//  Created by Artur Guseinov on 22/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import "StorageService.h"

@interface StorageService ()

@property RLMNotificationToken *notificationToken;

@end

@implementation StorageService

- (instancetype)initWithDelegate:(id <StorageServiceDelegate>)delegate
{
  self = [super init];
  if (self) {
    self.delegate = delegate;
  }
  return self;
}

- (void)getCurrencies {
  
  __weak RLMResults<Currency *> *currencies  = [[Currency allObjects] sortedResultsUsingKeyPath:@"index" ascending:YES];
  
  self.notificationToken = [currencies  addNotificationBlock:^(RLMResults<Currency *> *results, RLMCollectionChange *changes, NSError *error) {
    if (error) {
      NSLog(@"Failed to open Realm on background worker: %@", error);
      return;
    }

    if (changes) {
      if ([self.delegate respondsToSelector:@selector(didUpdateCurrencies:atIndexes:)]) {
        [self.delegate didUpdateCurrencies:(NSArray *)currencies  atIndexes:changes.modifications];
      }
    }
  }];
  
  // Generate mock currencies
  if (currencies .count == 0) {
    [self firstEnterConfiguration];
    currencies  = [Currency allObjects];
  }
  
  if ([self.delegate respondsToSelector:@selector(didReceivedCurrenciesFromStorage:)]) {
    [self.delegate didReceivedCurrenciesFromStorage:(NSArray *)currencies ];
  }
}

- (void)convertCurrency:(Currency *)currency amount:(float)amount to:(Currency *)toCurrency amount:(float)toAmount {
  RLMRealm *realm = [RLMRealm defaultRealm];
  [realm beginWriteTransaction];
  currency.amount -= amount;
  toCurrency.amount += toAmount;
  [realm commitWriteTransaction];
  
  if ([self.delegate respondsToSelector:@selector(didExchangeCurrensies)]) {
    [self.delegate didExchangeCurrensies];
  }
}

- (void)firstEnterConfiguration {

  RLMRealm *realm = [RLMRealm defaultRealm];
  
  Currency *eurCurrency = [[Currency alloc] initWithIndex:0 currencyString:@"EUR" andAmount:100];
  Currency *usdCurrency = [[Currency alloc] initWithIndex:1 currencyString:@"USD" andAmount:100];
  Currency *gbpCurrency = [[Currency alloc] initWithIndex:2 currencyString:@"GBP" andAmount:100];
  
  [realm transactionWithBlock:^{
    [realm addObjects:@[eurCurrency, usdCurrency, gbpCurrency]];
  }];
}

- (void)dealloc {
  [self.notificationToken stop];
}


@end
