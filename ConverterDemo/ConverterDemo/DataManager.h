//
//  DataManager.h
//  ConverterDemo
//
//  Created by Artur Guseinov on 22/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RateListService.h"
#import "StorageService.h"


@protocol DataManagerDelegate <NSObject>
- (void)reloadTopCollectionView;
- (void)reloadBottomCollectionView;
@end


@interface DataManager : NSObject <RateListServiceDelegate, StorageServiceDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <DataManagerDelegate> delegate;

- (instancetype)initWithDelegate:(id <DataManagerDelegate>)delegate;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
