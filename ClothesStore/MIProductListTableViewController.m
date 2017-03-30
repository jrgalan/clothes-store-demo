//
//  MIProductListTableViewController.m
//  ClothesStore
//
//  Created by Jensen Galan on 3/28/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import "MIProductListTableViewController.h"
#import "MIProductCatalogViewModel.h"
#import "MICartViewModel.h"
#import "MIProductDetailViewController.h"
#import "MICheckoutCartTableViewController.h"
#import "MIProductListTableViewCell.h"

NSString *const MIProductDetailSegue        = @"MIProductDetailSegue";
NSString *const MIProductListToCartSegue    = @"MIProductListToCartSegue";
NSString *const MIProductCellIdentifier     = @"MIProductCell";

@interface MIProductListTableViewController ()

@property (nonatomic, strong)   MIProductCatalogViewModel   *productCatalogViewModel;
@property (nonatomic, strong)   MICartViewModel             *cartViewModel;
@property (nonatomic, strong)   NSArray <NSNumber *>        *allProductIDsForCategory;
@property (nonatomic, copy)     NSString                    *categoryToDisplay;
@property (nonatomic, strong)   NSNumber                    *productIdSelected;

@end

@implementation MIProductListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.categoryToDisplay;
    [self updateShoppingCartButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
}

- (void)updateShoppingCartButton {
    UIBarButtonItem* rightButton = self.navigationItem.rightBarButtonItem;
    UIImage *cartImage = [self.cartViewModel anyProductsInCart] ? [UIImage imageNamed:@"ic_add_shopping_cart"] :[UIImage imageNamed:@"ic_shopping_cart"];
    [rightButton setImage:cartImage];
}

- (void)setupWithProductCatalogViewModel:(MIProductCatalogViewModel *)productCatalogViewModel cartViewModel:(MICartViewModel *)cartViewModel categoryToDisplay:(NSString *)categoryToDisplay {
    self.productCatalogViewModel = productCatalogViewModel;
    self.cartViewModel = cartViewModel;
    self.categoryToDisplay = categoryToDisplay;
    self.allProductIDsForCategory = [self.productCatalogViewModel allProductIDsForCategory:self.categoryToDisplay];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allProductIDsForCategory.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MIProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MIProductCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.allProductIDsForCategory.count) {
        NSNumber *productId = [self.allProductIDsForCategory objectAtIndex:indexPath.row];
        [cell setupCellWithProductName:[self.productCatalogViewModel productNameForProductId:productId]
                                 price:[NSString stringWithFormat:@"$%@", [self.productCatalogViewModel productPriceForProductId:productId]]
                               inStock:[self.productCatalogViewModel productInStockProductId:productId]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.allProductIDsForCategory.count) {
        self.productIdSelected = [self.allProductIDsForCategory objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:MIProductDetailSegue sender:self];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:MIProductDetailSegue]) {
        MIProductDetailViewController *productDetailVC = segue.destinationViewController;
        [productDetailVC setupWithProductCatalogViewModel:self.productCatalogViewModel
                                            cartViewModel:self.cartViewModel
                                       productIdToDisplay:self.productIdSelected];
    }
    else if ([segue.identifier isEqualToString:MIProductListToCartSegue]) {
        UINavigationController *navController = segue.destinationViewController;
        MICheckoutCartTableViewController *checkoutCartTVC = navController.viewControllers[0];
        [checkoutCartTVC setupWithProductCatalogViewModel:self.productCatalogViewModel
                                            cartViewModel:self.cartViewModel];
    }
}

@end
