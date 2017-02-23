//
//  Currency.m
//  ConverterDemo
//
//  Created by Artur Guseinov on 22/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import "Currency.h"

@implementation Currency

- (instancetype)initWithIndex:(int)index currencyString:(NSString *)currencyString andAmount:(float)amount  {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.index = index;
    self.currencyString = currencyString;
    self.amount = amount;
    
    return self;
}

+ (NSString *)primaryKey {
    return @"currencyString";
}

// MARK: - Helpers

+ (NSArray *)allCurrencies {
    return @[@"EUR",@"USD",@"GBP"];
}

+ (NSArray *)symbols {
    return @[@"€",@"$",@"£"];
}

- (NSString *)returnCurrencySymbol {
    return [Currency.symbols objectAtIndex:[Currency.allCurrencies indexOfObject:self.currencyString]];
}



@end
