//
//  Currency.h
//  ConverterDemo
//
//  Created by Artur Guseinov on 22/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import <Realm/Realm.h>
#import "RateList.h"

@class Currency;

@interface Currency : RLMObject

@property int index;
@property NSString *currencyString;
@property double amount;
@property RateList *rateList;

- (instancetype)initWithIndex:(int)index currencyString:(NSString *)currencyString andAmount:(float)amount;
+ (NSString *)primaryKey;
- (NSString *)returnCurrencySymbol;

@end
