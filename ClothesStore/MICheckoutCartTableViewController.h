//
//  MICheckoutCartTableViewController.h
//  ClothesStore
//
//  Created by Jensen Galan on 3/28/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MIProductCatalogViewModel;
@class MICartViewModel;

@interface MICheckoutCartTableViewController : UITableViewController

- (void)setupWithProductCatalogViewModel:(MIProductCatalogViewModel *)productCatalogViewModel
                           cartViewModel:(MICartViewModel *)cartViewModel;

@end

NS_ASSUME_NONNULL_END
