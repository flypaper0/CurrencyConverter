//
//  ViewController.m
//  ConverterDemo
//
//  Created by Artur Guseinov on 20/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import "ViewController.h"
#import "ExchangeCell.h"
#import "DataManager.h"

@interface ViewController () <DataManagerDelegate, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *topPageControl;
@property (weak, nonatomic) IBOutlet UIPageControl *bottomPageControl;

@property DataManager *dataManager;
@property RateListService *rateListService;
@property StorageService *storageService;

@end


@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UINib *nib = [UINib nibWithNibName: @"ExchangeCell" bundle:nil];
  [self.topCollectionView registerNib:nib forCellWithReuseIdentifier:@"ExchangeCell"];
  [self.bottomCollectionView registerNib:nib forCellWithReuseIdentifier:@"ExchangeCell"];
  
  self.dataManager = [[DataManager alloc] initWithDelegate:self];
  self.topCollectionView.dataSource = self.dataManager;
  self.bottomCollectionView.dataSource = self.dataManager;

  self.rateListService = [[RateListService alloc] initWithDelegate:self.dataManager];
  [self.rateListService getRateListForCurrency: USD];
  
  self.storageService = [[StorageService alloc] initWithDelegate:self.dataManager];
  [self.storageService getBalances];
}


// MARK: - DataManagerDelegate

- (void)reloadTopCollectionView {
  [self.topCollectionView reloadData];
}

- (void)reloadBottomCollectionView {
  [self.bottomCollectionView reloadData];
}


// MARK: - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return collectionView.frame.size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (scrollView == self.topCollectionView) {
    CGFloat pageWidth = self.topCollectionView.frame.size.width;
    self.topPageControl.currentPage = self.topCollectionView.contentOffset.x / pageWidth;
  } else {
    CGFloat pageWidth = self.bottomCollectionView.frame.size.width;
    self.bottomPageControl.currentPage = self.bottomCollectionView.contentOffset.x / pageWidth;
  }
}

@end
