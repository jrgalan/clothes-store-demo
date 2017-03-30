//
//  MICheckoutCartTableViewController.m
//  ClothesStore
//
//  Created by Jensen Galan on 3/28/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import "MICheckoutCartTableViewController.h"
#import "MIProductCatalogViewModel.h"
#import "MICartViewModel.h"
#import "MIProductInCartTableViewCell.h"
#import "MICartTotalTableViewCell.h"

NSString *const MITotalCellIdentifier   = @"MITotalCell";
NSString *const MICartCellIdentifier    = @"MICartCell";

#define NUMBER_OF_SECTIONS          3
#define CART_TOTAL_SECTION          0
#define ITEMS_IN_CART_SECTION       1
#define ITEMS_IN_WISHLIST_SECTION   2

@interface MICheckoutCartTableViewController () <MIProductInCartTableViewCellDelegate>

@property (nonatomic, strong)   MIProductCatalogViewModel   *productCatalogViewModel;
@property (nonatomic, strong)   MICartViewModel             *cartViewModel;
@property (nonatomic, strong)   NSArray <NSNumber *>        *productIDsInCart;
@property (nonatomic, strong)   NSArray <NSNumber *>        *productIDsInWishList;

@end

@implementation MICheckoutCartTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelection = NO;
    self.navigationItem.title = NSLocalizedString(@"Cart", @"Shopping Cart");
    
    [self refreshProductIDsInCartAndWishList];
}

- (void)setupWithProductCatalogViewModel:(MIProductCatalogViewModel *)productCatalogViewModel cartViewModel:(MICartViewModel *)cartViewModel {
    self.productCatalogViewModel = productCatalogViewModel;
    self.cartViewModel = cartViewModel;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == CART_TOTAL_SECTION) {
        return 1;
    }
    else if (section == ITEMS_IN_CART_SECTION) {
        return self.productIDsInCart.count;
    }
    else if (section == ITEMS_IN_WISHLIST_SECTION) {
        return self.productIDsInWishList.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == CART_TOTAL_SECTION) {
        MICartTotalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MITotalCellIdentifier forIndexPath:indexPath];
        [cell setupCellWithTotalPrice:[self.productCatalogViewModel formattedTotalForProductIDsAndQuantities:[self.cartViewModel allProductIDsWithQuantities]]];
        return cell;
    }
    else if (indexPath.section == ITEMS_IN_CART_SECTION) {
        MIProductInCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MICartCellIdentifier forIndexPath:indexPath];
        if (indexPath.row < self.productIDsInCart.count) {
            NSNumber *productId = [self.productIDsInCart objectAtIndex:indexPath.row];
            [cell setupCellWithProductName:[self.productCatalogViewModel productNameForProductId:productId]
                                     price:[NSString stringWithFormat:@"$%@", [self.productCatalogViewModel productPriceForProductId:productId]]
                                   inStock:[self.productCatalogViewModel productInStockProductId:productId]
                                stockCount:[self.productCatalogViewModel productStockForProductId:productId]
                            quantityInCart:[self.cartViewModel quantityInCartForProductId:productId]
                                  cellType:MIProductInCartCellTypeCart];
            cell.delegate = self;
        }
        return cell;
    }
    else {
        MIProductInCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MICartCellIdentifier forIndexPath:indexPath];
        if (indexPath.row < self.productIDsInWishList.count) {
            NSNumber *productId = [self.productIDsInWishList objectAtIndex:indexPath.row];
            [cell setupCellWithProductName:[self.productCatalogViewModel productNameForProductId:productId]
                                     price:[NSString stringWithFormat:@"$%@", [self.productCatalogViewModel productPriceForProductId:productId]]
                                   inStock:[self.productCatalogViewModel productInStockProductId:productId]
                                stockCount:[self.productCatalogViewModel productStockForProductId:productId]
                            quantityInCart:[self.cartViewModel quantityInCartForProductId:productId]
                                  cellType:MIProductInCartCellTypeWishList];
            cell.delegate = self;
        }
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == ITEMS_IN_CART_SECTION && self.productIDsInCart.count > 0) {
        return NSLocalizedString(@"My Cart", @"My Cart");
    }
    else if (section == ITEMS_IN_WISHLIST_SECTION && self.productIDsInWishList.count > 0) {
        return NSLocalizedString(@"My Wish List", @"My Wish List");
    }
    else {
        return nil;
    }
}

- (IBAction)tappedCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)productInCartTableViewCellDidTapDeleteProduct:(MIProductInCartTableViewCell *)productInCartTableViewCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:productInCartTableViewCell];
    
    if (indexPath.section == ITEMS_IN_CART_SECTION && indexPath.row < self.productIDsInCart.count) {
        NSNumber *productId = [self.productIDsInCart objectAtIndex:indexPath.row];
        [self.cartViewModel removeProductInCartWithProductId:productId];
        [self refreshProductIDsInCartAndWishList];
        [self.tableView reloadData];
    }
    else if (indexPath.section == ITEMS_IN_WISHLIST_SECTION && indexPath.row < self.productIDsInWishList.count) {
        NSNumber *productId = [self.productIDsInWishList objectAtIndex:indexPath.row];
        [self.cartViewModel removeProductInWishListProductId:productId];
        [self refreshProductIDsInCartAndWishList];
        [self.tableView reloadData];
    }
}

- (void)productInCartTableViewCellDidTapSaveProductForLater:(MIProductInCartTableViewCell *)productInCartTableViewCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:productInCartTableViewCell];
    if (indexPath.section == ITEMS_IN_CART_SECTION && indexPath.row < self.productIDsInCart.count) {
        NSNumber *productId = [self.productIDsInCart objectAtIndex:indexPath.row];
        [self.cartViewModel moveProductFromCartToWishListProductWithID:productId];
        [self refreshProductIDsInCartAndWishList];
        [self.tableView reloadData];
    }
}

- (void)productInCartTableViewCellDidTapMoveProductToCart:(MIProductInCartTableViewCell *)productInCartTableViewCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:productInCartTableViewCell];
    if (indexPath.section == ITEMS_IN_WISHLIST_SECTION && indexPath.row < self.productIDsInWishList.count) {
        NSNumber *productId = [self.productIDsInWishList objectAtIndex:indexPath.row];
        if ([self.productCatalogViewModel productInStockProductId:productId]) {
            [self.cartViewModel moveProductFromWishListToCartProductWithID:productId];
            [self refreshProductIDsInCartAndWishList];
            [self.tableView reloadData];
        }
        else {
            [self alertOutOfStock];
        }
    }
}

- (void)refreshProductIDsInCartAndWishList {
    self.productIDsInCart = [self.cartViewModel allProductIDsInCart];
    self.productIDsInWishList = [self.cartViewModel allProductIDsInWishList];
}

#pragma mark Alerts

- (void)alertOutOfStock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Sorry", @"Sorry")
                                                                   message:NSLocalizedString(@"This product is currently out of stock", @"This product is currently out of stock")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

@end
