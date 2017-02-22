//
//  StorageService.h
//  ConverterDemo
//
//  Created by Artur Guseinov on 22/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Balance.h"


@protocol StorageServiceDelegate <NSObject>
- (void)didReceivedBalancesFromStorage:(NSArray<Balance *> *)balances;
- (void)didUpdateBalances:(NSArray<Balance *> *)balance atIndexes:(NSArray<NSNumber *> *)indexes;
@end


@interface StorageService : NSObject

@property (nonatomic, weak) id <StorageServiceDelegate> delegate;

- (instancetype)initWithDelegate:(id <StorageServiceDelegate>)delegate;
- (void)getBalances;

@end

