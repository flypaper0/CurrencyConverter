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

- (void)getRateListForCurrency:(Currency)currency {
  
  NSDictionary *parameters = @{@"base": currencyString(currency)};
  
  [self GET:@"latest" parameters:parameters progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
    
    RateList *rateList = [[RateList alloc] initWithAttributes:JSON];
    
    if (([self.delegate respondsToSelector:@selector(didReceivedRateList:)])) {
      [self.delegate didReceivedRateList:rateList];
    }
  } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
    if (([self.delegate respondsToSelector:@selector(didFailedWithError:)])) {
      [self.delegate didFailedWithError:error];
    }
  }];
}

@end
