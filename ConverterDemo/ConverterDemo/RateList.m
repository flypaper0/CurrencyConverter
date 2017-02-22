//
//  RateList.m
//  ConverterDemo
//
//  Created by Artur Guseinov on 21/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import "RateList.h"
#import "RateListService.h"


@implementation RateList

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }
  
  self.base = [attributes valueForKeyPath:@"base"];
  self.rates = [attributes valueForKeyPath:@"rates"];
  
  return self;
}

@end
