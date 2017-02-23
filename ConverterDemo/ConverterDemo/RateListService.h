//
//  Networking.h
//  ConverterDemo
//
//  Created by Artur Guseinov on 21/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "RateList.h"
#import "Currency.h"

@protocol RateListServiceDelegate <NSObject>
- (void)didReceivedRateLists;
- (void)didReceivedRateListFor:(Currency *)currency andPerformExchange:(BOOL)performExchangeNeeded;
- (void)didFailedWithError:(NSError *)error;
@end


@interface RateListService : AFHTTPSessionManager

- (instancetype)initWithDelegate:(id <RateListServiceDelegate>)delegate;

- (void)getRateListForCurrencies:(NSArray<Currency *> *)currencies;
- (void)getRateListForCurrency:(Currency *)currency andPerformExchange:(BOOL)performExchangeNeeded;

@property (nonatomic, weak) id <RateListServiceDelegate> delegate;

@end


