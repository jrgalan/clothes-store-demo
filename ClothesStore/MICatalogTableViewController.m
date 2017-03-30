//
//  MICatalogTableViewController.m
//  ClothesStore
//
//  Created by Jensen Galan on 3/28/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import "MICatalogTableViewController.h"
#import "MIProductCatalogViewModel.h"
#import "MICartViewModel.h"
#import "MIProductListTableViewController.h"
#import "MICheckoutCartTableViewController.h"
#import "MICategoryListTableViewCell.h"

#import "Bolts.h"
#import "MBProgressHUD.h"

NSString *const MIProductListSegue      = @"MIProductListSegue";
NSString *const MICatalogToCartSegue    = @"MICatalogToCartSegue";
NSString *const MICatalogCellIdentifier = @"MICatalogCell";

@interface MICatalogTableViewController ()

@property (nonatomic, strong)   NSArray <NSString *>        *categoryArray;
@property (nonatomic, strong)   MIProductCatalogViewModel   *productCatalogViewModel;
@property (nonatomic, strong)   MICartViewModel             *cartViewModel;
@property (nonatomic, copy)     NSString                    *categorySelected;

@end

@implementation MICatalogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    
    self.productCatalogViewModel = [[MIProductCatalogViewModel alloc] init];
    self.cartViewModel = [[MICartViewModel alloc] init];
    
    [self updateProductCatalog];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = NSLocalizedString(@"Browse Categories", @"Browse Categories");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
}

- (void)updateProductCatalog {
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[self.productCatalogViewModel updateProductCatalog] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });

        if (t.error) {
            [self alertSomethingWentWrong:t.error.localizedDescription];
        }
        else {
            self.categoryArray = [self.productCatalogViewModel allCategories];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });

        }
        
        return nil;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MICategoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MICatalogCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.categoryArray.count) {
        NSString *category = [self.categoryArray objectAtIndex:indexPath.row];
        [cell setupCellWithCategoryName:category];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.categorySelected = [self.categoryArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:MIProductListSegue sender:self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:MIProductListSegue]) {
        MIProductListTableViewController *productListTVC = segue.destinationViewController;
        [productListTVC setupWithProductCatalogViewModel:self.productCatalogViewModel
                                           cartViewModel:self.cartViewModel
                                       categoryToDisplay:self.categorySelected];
    }
    else if ([segue.identifier isEqualToString:MICatalogToCartSegue]) {
        UINavigationController *navController = segue.destinationViewController;
        MICheckoutCartTableViewController *checkoutCartTVC = navController.viewControllers[0];
        [checkoutCartTVC setupWithProductCatalogViewModel:self.productCatalogViewModel
                                            cartViewModel:self.cartViewModel];
    }
}

#pragma mark Alerts

- (void)alertSomethingWentWrong:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Something went wrong", @"Something went wrong")
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:NSLocalizedString(@"Try again", @"Try again")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self updateProductCatalog];
                                                     }];
    
    [alert addAction:tryAgain];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}


@end
