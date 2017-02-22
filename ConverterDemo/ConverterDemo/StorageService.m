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

- (void)getBalances {
  
  __weak RLMResults<Balance *> *balances = [[Balance allObjects] sortedResultsUsingKeyPath:@"index" ascending:YES];
  
  self.notificationToken = [balances addNotificationBlock:^(RLMResults<Balance *> *results, RLMCollectionChange *changes, NSError *error) {
    if (error) {
      NSLog(@"Failed to open Realm on background worker: %@", error);
      return;
    }

    if (changes) {
      if (([self.delegate respondsToSelector:@selector(didUpdateBalances:atIndexes:)])) {
        [self.delegate didUpdateBalances:(NSArray *)balances atIndexes:changes.modifications];
      }
    }
  }];
  
  // Generate mock balance
  if (balances.count == 0) {
    [self firstEnterConfiguration];
    balances = [Balance allObjects];
  }
  
  if (([self.delegate respondsToSelector:@selector(didReceivedBalancesFromStorage:)])) {
    [self.delegate didReceivedBalancesFromStorage:(NSArray *)balances];
  }
}


- (void)firstEnterConfiguration {

  RLMRealm *realm = [RLMRealm defaultRealm];
  
  Balance *eurBalance = [[Balance alloc] init];
  eurBalance.index = 0;
  eurBalance.balance = 100;
  eurBalance.currency = @"EUR";
  [realm transactionWithBlock:^{
    [realm addObject:eurBalance];
  }];

  Balance *usdBalance = [[Balance alloc] init];
  usdBalance.index = 1;
  usdBalance.balance = 100;
  usdBalance.currency = @"USD";
  [realm transactionWithBlock:^{
    [realm addObject:usdBalance];
  }];
  
  Balance *gbpBalance = [[Balance alloc] init];
  gbpBalance.index = 2;
  gbpBalance.balance = 100;
  gbpBalance.currency = @"GBP";
  [realm transactionWithBlock:^{
    [realm addObject:gbpBalance];
  }];
}

- (void)dealloc {
  [self.notificationToken stop];
}


@end
