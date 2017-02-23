//
//  StorageService.h
//  ConverterDemo
//
//  Created by Artur Guseinov on 22/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"


@protocol StorageServiceDelegate <NSObject>
- (void)didExchangeCurrensies;
- (void)didReceivedCurrenciesFromStorage:(NSArray<Currency *> *)currencies ;
- (void)didUpdateCurrencies:(NSArray<Currency *> *)currency atIndexes:(NSArray<NSNumber *> *)indexes;
@end


@interface StorageService : NSObject

@property (nonatomic, weak) id <StorageServiceDelegate> delegate;

- (instancetype)initWithDelegate:(id <StorageServiceDelegate>)delegate;
- (void)getCurrencies;
- (void)convertCurrency:(Currency *)currency amount:(float)amount to:(Currency *)toCurrency amount:(float)toAmount;

@end

