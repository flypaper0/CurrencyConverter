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

@interface ViewController () <DataManagerDelegate, RateListServiceDelegate, StorageServiceDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

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
  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  self.navigationController.navigationBar.translucent = YES;
    
  self.dataManager = [[DataManager alloc] initWithDelegate: self];
  self.topCollectionView.dataSource = self.dataManager;
  self.bottomCollectionView.dataSource = self.dataManager;

  self.rateListService = [[RateListService alloc] initWithDelegate:self];
  
  self.storageService = [[StorageService alloc] initWithDelegate:self];
  [self.storageService getCurrencies];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

// MARK: - RateListServiceDelegate

- (void)didReceivedRateLists {
  NSLog(@"All rate lists received");
}

- (void)didFailedWithError:(NSError *)error {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:error.localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
  [alertController addAction:ok];
  
  [self presentViewController:alertController animated:YES completion:nil];
}


// MARK: - StorageServiceDelegate

- (void)didReceivedCurrenciesFromStorage:(NSArray<Currency *> *)currencies  {
  self.dataManager.currencies  = currencies;
  
  [self.dataManager selectCurrencyAtIndex:self.bottomPageControl.currentPage];
  
  [self.topCollectionView reloadData];
  [self.bottomCollectionView reloadData];
  
  [self.rateListService getRateListForCurrencies: currencies];
}

- (void)didUpdateCurrencies:(NSArray<Currency *> *)currencies atIndexes:(NSArray<NSNumber *> *)indexes {
  self.dataManager.currencies = currencies;
  
  NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:indexes.count];
  for (NSNumber *index in indexes) {
    [indexPaths addObject:[NSIndexPath indexPathForItem: index.integerValue inSection:1]];
  }
  
  if ([self.topCollectionView.visibleCells containsObject:indexPaths.firstObject]) {
    [self.topCollectionView reloadItemsAtIndexPaths:indexPaths];
  }
  
  if ([self.bottomCollectionView.visibleCells containsObject:indexPaths.firstObject]) {
    [self.bottomCollectionView reloadItemsAtIndexPaths:indexPaths];
  }
}


// MARK: - DataManagerDelegate

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
    [self.dataManager selectCurrencyAtIndex:self.topPageControl.currentPage];
  } else {
    CGFloat pageWidth = self.bottomCollectionView.frame.size.width;
    self.bottomPageControl.currentPage = self.bottomCollectionView.contentOffset.x / pageWidth;
  }
}

@end
