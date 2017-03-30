//
//  MIProductDetailViewController.m
//  ClothesStore
//
//  Created by Jensen Galan on 3/28/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import "MIProductDetailViewController.h"
#import "MICheckoutCartTableViewController.h"
#import "MIProductCatalogViewModel.h"
#import "MICartViewModel.h"
#import "UIColor+MIDefaultColors.h"

NSString *const MIProductDetailToCartSegue = @"MIProductDetailToCartSegue";

@interface MIProductDetailViewController ()

@property (nonatomic, strong)   NSNumber                    *productIdToDisplay;

@property (nonatomic, strong)   MIProductCatalogViewModel   *productCatalogViewModel;
@property (nonatomic, strong)   MICartViewModel             *cartViewModel;

@property (weak, nonatomic)     IBOutlet UILabel            *productNameLabel;
@property (weak, nonatomic)     IBOutlet UILabel            *priceLabel;
@property (weak, nonatomic)     IBOutlet UILabel            *inStockLabel;
@property (weak, nonatomic)     IBOutlet UILabel            *stockCountLabel;
@property (weak, nonatomic)     IBOutlet UIView             *quantityView;
@property (weak, nonatomic)     IBOutlet UILabel            *quantityLabel;
@property (weak, nonatomic)     IBOutlet UIButton           *addToCartButton;

@property (nonatomic)           NSInteger                   currentQuantitySelected;

@end

@implementation MIProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUIForProductDetail];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = NSLocalizedString(@"Product Details", @"Product Details");
    [self setupCurrentProductQuantityAndInCartQuantity];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
}

- (void)setupWithProductCatalogViewModel:(MIProductCatalogViewModel *)productCatalogViewModel cartViewModel:(MICartViewModel *)cartViewModel productIdToDisplay:(NSNumber *)productIdToDisplay {
    self.productCatalogViewModel = productCatalogViewModel;
    self.cartViewModel = cartViewModel;
    self.productIdToDisplay = productIdToDisplay;
}

- (void)setupUIForProductDetail {
    self.productNameLabel.text = [self.productCatalogViewModel productNameForProductId:self.productIdToDisplay];
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", [self.productCatalogViewModel productPriceForProductId:self.productIdToDisplay]];
                            
    BOOL productInStock = [self.productCatalogViewModel productInStockProductId:self.productIdToDisplay];
    self.inStockLabel.text = productInStock ? NSLocalizedString(@"In stock", @"In stock") : NSLocalizedString(@"Out of stock", @"Out of stock");
    self.inStockLabel.textColor = productInStock ? [UIColor defaultGreenColor] : [UIColor defaultRedColor];
    
    if (productInStock) {
        [self setupCurrentProductQuantityAndInCartQuantity];
        self.quantityView.backgroundColor = [UIColor defaultLightGrayBackgroundColor];
    }
    else {
        self.stockCountLabel.hidden = YES;
        self.quantityView.hidden = YES;
    }
    
    self.addToCartButton.layer.cornerRadius = 4.f;
    self.addToCartButton.layer.masksToBounds =YES;
}

- (void)setupCurrentProductQuantityAndInCartQuantity {

    NSString *quantityTextForLabel = [NSString stringWithFormat:@"Only %@ left", [self.productCatalogViewModel productStockForProductId:self.productIdToDisplay]];
    
    NSNumber *quantityCurrentlyInCart = [self.cartViewModel quantityInCartForProductId:self.productIdToDisplay];
    if ([quantityCurrentlyInCart integerValue] > 0) {
        NSString *quantityCurrentlyInCartString = [NSString stringWithFormat:@"  (%@ in cart)", quantityCurrentlyInCart];
        quantityTextForLabel = [quantityTextForLabel stringByAppendingString:quantityCurrentlyInCartString];
    }
    
    self.stockCountLabel.text = quantityTextForLabel;
    
    self.currentQuantitySelected = 1;
    
    [self updateShoppingCartButton];
}

- (void)updateShoppingCartButton {
    UIBarButtonItem* rightButton = self.navigationItem.rightBarButtonItem;
    UIImage *cartImage = [self.cartViewModel anyProductsInCart] ? [UIImage imageNamed:@"ic_add_shopping_cart"] :[UIImage imageNamed:@"ic_shopping_cart"];
    [rightButton setImage:cartImage];
}

- (void)setCurrentQuantitySelected:(NSInteger)currentQuantitySelected {
   // side effect
    _currentQuantitySelected = currentQuantitySelected;
    self.quantityLabel.text = [NSString stringWithFormat:@"Qty: %ld", (long)_currentQuantitySelected];
}

- (IBAction)tappedSubtractQuantityButton:(id)sender {
    if (self.currentQuantitySelected > 1) {
        self.currentQuantitySelected--;
    }
}

- (IBAction)tappedAddQuantityButton:(id)sender {
    NSNumber *currentStockCount = [self.productCatalogViewModel productStockForProductId:self.productIdToDisplay];
    NSNumber *quantityCurrentlyInCart = [self.cartViewModel quantityInCartForProductId:self.productIdToDisplay];
    if (self.currentQuantitySelected < ([currentStockCount integerValue] - [quantityCurrentlyInCart integerValue])) {
        self.currentQuantitySelected++;
    }
}

- (IBAction)tappedAddToCartButton:(id)sender {
    BOOL productInStock = [self.productCatalogViewModel productInStockProductId:self.productIdToDisplay];
    NSNumber *quantityCurrentlyInCart = [self.cartViewModel quantityInCartForProductId:self.productIdToDisplay];
    NSNumber *currentStockCount = [self.productCatalogViewModel productStockForProductId:self.productIdToDisplay];
    
    if (!productInStock) {
         [self alertOutOfStock];
    }
    else if (([quantityCurrentlyInCart integerValue] + 1) <= [currentStockCount integerValue]) {
        [self.cartViewModel addToCartProductWithID:self.productIdToDisplay
                                          quantity:self.currentQuantitySelected];
        [self alertProductAddedWithMessage:NSLocalizedString(@"Added to Cart!", @"Added to Cart!")];
        [self setupCurrentProductQuantityAndInCartQuantity];
    }
    else {
        [self alertProductAddedWithMessage:NSLocalizedString(@"You have the entire stock\nin your cart!", @"You have the entire stock in your cart!")];
    }
}

- (IBAction)tappedSaveToWishListButton:(id)sender {
    NSNumber *quantityCurrentlyInCart = [self.cartViewModel quantityInCartForProductId:self.productIdToDisplay];
    
    if ([quantityCurrentlyInCart integerValue] > 0) {
        [self alertProductAddedWithMessage:NSLocalizedString(@"You already have this\n product in your cart!", @"You already have this product in your cart!")];
    }
    else {
        [self.cartViewModel addToWishListProductWithID:self.productIdToDisplay];
        [self alertProductAddedWithMessage:NSLocalizedString(@"Added to Wish List!", @"Added to Wish List!")];
    }
}

#pragma mark Alerts

- (void)alertOutOfStock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Out of stock", @"Out of stock")
                                                                   message:NSLocalizedString(@"Would you like to save\nthis product for later?", @"Would you like to save this product for later?")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *addToWishList = [UIAlertAction actionWithTitle:NSLocalizedString(@"Save to Wish List", @"Save to Wish List")
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [self.cartViewModel addToWishListProductWithID:self.productIdToDisplay];
                                                            }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:addToWishList];
    [alert addAction:cancelAction];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

- (void)alertProductAddedWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *viewCart = [UIAlertAction actionWithTitle:NSLocalizedString(@"View Cart", @"View Cart")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self performSegueWithIdentifier:MIProductDetailToCartSegue
                                                                                   sender:self];
                                                     }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Continue Shopping", @"Continue Shopping")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:viewCart];
    [alert addAction:cancelAction];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:MIProductDetailToCartSegue]) {
        UINavigationController *navController = segue.destinationViewController;
        MICheckoutCartTableViewController *checkoutCartTVC = navController.viewControllers[0];
        [checkoutCartTVC setupWithProductCatalogViewModel:self.productCatalogViewModel
                                            cartViewModel:self.cartViewModel];
    }
}

@end
