//
//  RateList.h
//  ConverterDemo
//
//  Created by Artur Guseinov on 21/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import <Realm/Realm.h>

@class RateList;

@interface RateList : RLMObject

@property NSString *base;
@property NSData *rates;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (BOOL)isEqual:(RateList *)rateList;

@end

