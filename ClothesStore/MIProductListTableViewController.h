//
//  MIProductListTableViewController.h
//  ClothesStore
//
//  Created by Jensen Galan on 3/28/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MIProductCatalogViewModel;
@class MICartViewModel;

@interface MIProductListTableViewController : UITableViewController

- (void)setupWithProductCatalogViewModel:(MIProductCatalogViewModel *)productCatalogViewModel
                           cartViewModel:(MICartViewModel *)cartViewModel
                       categoryToDisplay:(NSString *)categoryToDisplay;

@end

NS_ASSUME_NONNULL_END
