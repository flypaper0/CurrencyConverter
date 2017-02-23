//
//  RateListService.m
//  ConverterDemo
//
//  Created by Artur Guseinov on 21/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import "RateListService.h"

static NSString * const FixerBaseURLString = @"http://api.fixer.io/";

@implementation RateListService

int attemptCounter = 0;
int maxAttemptCounter = 3;
dispatch_group_t group;

- (instancetype)initWithDelegate:(id <RateListServiceDelegate>)delegate
{
    self = [super initWithBaseURL:[NSURL URLWithString:FixerBaseURLString]];
    if (self) {
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.delegate = delegate;
    }
    return self;
}


#pragma mark -

- (void)getRateListForCurrencies:(NSArray<Currency *> *)currencies {
    
    group = dispatch_group_create();
    
    for (Currency *currency in currencies) {
        [self getRateListForCurrency:currency andPerformExchange: NO];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        attemptCounter = 0;
        
        if (([self.delegate respondsToSelector:@selector(didReceivedRateLists)])) {
            [self.delegate didReceivedRateLists];
        }
    });
}

- (void)getRateListForCurrency:(Currency *)currency andPerformExchange:(BOOL)performExchangeNeeded {
    dispatch_group_enter(group);
    
    NSDictionary *parameters = @{@"base": currency.currencyString};
    
    __weak typeof(self) weakSelf = self;
    [self GET:@"latest" parameters:parameters progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        RateList *rateList = [[RateList alloc] initWithAttributes:JSON];
        currency.rateList = rateList;
        [realm commitWriteTransaction];
        
        if (([self.delegate respondsToSelector:@selector(didReceivedRateListFor:andPerformExchange:)])) {
            [self.delegate didReceivedRateListFor:currency andPerformExchange: performExchangeNeeded];
        }
        
        dispatch_group_leave(group);
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        
        attemptCounter++;
        if (attemptCounter == maxAttemptCounter) {
            if (([self.delegate respondsToSelector:@selector(didFailedWithError:)])) {
                [self.delegate didFailedWithError:error];
            }
        }
        
        [weakSelf getRateListForCurrency:currency andPerformExchange: performExchangeNeeded];
    }];
}

@end
