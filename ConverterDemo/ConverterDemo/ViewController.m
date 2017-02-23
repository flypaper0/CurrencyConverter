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
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;

@property DataManager *dataManager;
@property RateListService *rateListService;
@property StorageService *storageService;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.exchangeButton.enabled = NO;
    
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponderInCollectionView:self.topCollectionView forCellAtIndex:0];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)presentAlertControllerWithError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:error.domain
                                                                             message:error.localizedDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)exchangeButtonPressed:(UIButton *)sender {
    [self.rateListService getRateListForCurrency:self.dataManager.selectedTopCurrency andPerformExchange:YES];
}


// MARK: - RateListServiceDelegate

- (void)didReceivedRateLists {
    NSLog(@"All rate lists received");
}

- (void)didFailedWithError:(NSError *)error {
    [self presentAlertControllerWithError:error];
}


- (void)didReceivedRateListFor:(Currency *)currency andPerformExchange:(BOOL)performExchangeNeeded {
    if (performExchangeNeeded == YES) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:currency.rateList.rates
                                                             options:kNilOptions
                                                               error:nil];
        NSString *rateString = (NSString *)json[self.dataManager.selectedBottomCurrency.currencyString];
        float rate = rateString.floatValue;
        
        [self.storageService convertCurrency:currency amount:self.dataManager.valueForExchange to:self.dataManager.selectedBottomCurrency amount:self.dataManager.valueForExchange * rate];
        self.dataManager.valueForExchange = 0;
    }
}


// MARK: - StorageServiceDelegate

- (void)didReceivedCurrenciesFromStorage:(NSArray<Currency *> *)currencies  {
    self.dataManager.currencies  = currencies;
    
    [self.dataManager selectTopCurrencyAtIndex:self.topPageControl.currentPage];
    [self.dataManager selectBottomCurrencyAtIndex:self.bottomPageControl.currentPage];
    
    [self.topCollectionView reloadData];
    [self.bottomCollectionView reloadData];
    
    [self.rateListService getRateListForCurrencies: currencies];
    [NSTimer scheduledTimerWithTimeInterval:30
                                     target:self
                                   selector:@selector(updateTimer:)
                                   userInfo:currencies
                                    repeats:YES];
}

- (void)updateTimer:(NSTimer *)timer {
    NSArray<Currency *> * currencies = timer.userInfo;
    [self.rateListService getRateListForCurrencies: currencies];
}



- (void)didUpdateCurrencies:(NSArray<Currency *> *)currencies atIndexes:(NSArray<NSNumber *> *)indexes {
    self.dataManager.currencies = currencies;
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:indexes.count];
    for (NSNumber *index in indexes) {
        [indexPaths addObject:[NSIndexPath indexPathForItem: index.integerValue inSection:0]];
    }
    [self.topCollectionView performBatchUpdates:^{
        [self.topCollectionView reloadItemsAtIndexPaths:indexPaths];
    } completion:^(BOOL finished) {}];
    
    [self.bottomCollectionView performBatchUpdates:^{
        [self.bottomCollectionView reloadItemsAtIndexPaths:indexPaths];
    } completion:^(BOOL finished) {}];
}

- (void)didExchangeCurrensies {
}

- (void)didFailedExchangeWithError:(NSError *)error {
    [self presentAlertControllerWithError:error];
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
        [self.dataManager selectTopCurrencyAtIndex:self.topPageControl.currentPage];
        
        [self becomeFirstResponderInCollectionView:self.topCollectionView forCellAtIndex:self.topPageControl.currentPage];
        
    } else {
        CGFloat pageWidth = self.bottomCollectionView.frame.size.width;
        self.bottomPageControl.currentPage = self.bottomCollectionView.contentOffset.x / pageWidth;
        [self.dataManager selectBottomCurrencyAtIndex:self.bottomPageControl.currentPage];
    }
    
    self.exchangeButton.enabled = !self.dataManager.isCurrenciesEqual;
    
}

- (void)becomeFirstResponderInCollectionView:(UICollectionView *)collectionView forCellAtIndex: (NSUInteger)index {
    ExchangeCell *cell = (ExchangeCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [cell.valueTextField becomeFirstResponder];
}

@end
