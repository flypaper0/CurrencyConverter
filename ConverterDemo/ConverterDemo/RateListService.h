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
- (void)didFailedWithError:(NSError *)error;
@end


@interface RateListService : AFHTTPSessionManager

- (instancetype)initWithDelegate:(id <RateListServiceDelegate>)delegate;

- (void)getRateListForCurrencies:(NSArray<Currency *> *)currencies;

@property (nonatomic, weak) id <RateListServiceDelegate> delegate;

@end


