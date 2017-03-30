//
//  MIProductCatalogViewModel.m
//  ClothesStore
//
//  Created by Jensen Galan on 3/28/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import "MIProductCatalogViewModel.h"
#import "MIProduct.h"
#import "Bolts.h"

@interface MIProductCatalogViewModel ()

@property (nonatomic, strong)   NSArray<MIProduct *>    *allProducts;

@end

@implementation MIProductCatalogViewModel

- (BFTask *)updateProductCatalog {
    
    BFTaskCompletionSource *catalogTask = [BFTaskCompletionSource taskCompletionSource];
    
    [[MIProduct fetchProductCatalog] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
        if (t.error) {
            [catalogTask setError:t.error];
        }
        else {
            self.allProducts = t.result;
            [catalogTask setResult:self.allProducts];
        }
        return nil;
    }];
    
    return catalogTask.task;
}

- (NSArray *)allCategories {
    
    NSMutableSet <NSString *> *allCategoriesSet = [NSMutableSet new];
    for (MIProduct *product in self.allProducts) {
        [allCategoriesSet addObject:product.category];
    }
    return [allCategoriesSet allObjects];
}

- (NSArray *)allProductIDsForCategory:(NSString *)category {
    
    NSMutableSet *allProductIDsForCategory = [NSMutableSet new];
    for (MIProduct *product in self.allProducts) {
        if ([product.category isEqualToString:category]) {
            [allProductIDsForCategory addObject:product.productId];
        }
    }
    return [allProductIDsForCategory allObjects];
}

- (NSString *)productNameForProductId:(NSNumber *)productId {
    MIProduct *product = [self productForProductID:productId];
    return product.name;
}

- (NSNumber * _Nullable)productPriceForProductId:(NSNumber *)productId {
    MIProduct *product = [self productForProductID:productId];
    return product.price;
}

- (NSNumber * _Nullable)productStockForProductId:(NSNumber *)productId {
    MIProduct *product = [self productForProductID:productId];
    return product.stock;
}

- (BOOL)productInStockProductId:(NSNumber *)productId {
    MIProduct *product = [self productForProductID:productId];
    return product.inStock;
}

- (MIProduct *)productForProductID:(NSNumber *)productID {
    MIProduct *productToReturn;
    for (MIProduct *product in self.allProducts) {
        if ([product.productId isEqualToNumber:productID]) {
            productToReturn = product;
            break;
        }
    }
    return productToReturn;
}

- (NSString *)formattedTotalForProductIDsAndQuantities:(NSDictionary <NSNumber *, NSNumber *> *)productIDsAndQuantitiesDictionary {
    
    float total = 0;
    
    NSArray *allProductIDs = [productIDsAndQuantitiesDictionary allKeys];
    for (NSNumber *productId in allProductIDs) {
        // NOTE: move this to a hashed lookup
        for (MIProduct *product in self.allProducts) {
            if ([product.productId isEqualToNumber:productId]) {
                NSNumber *quantityInCart = [productIDsAndQuantitiesDictionary objectForKey:productId];
                total += [quantityInCart integerValue] * [product.price floatValue];
            }
        }
    }
    
    return [NSString stringWithFormat:@"$%.02f", (float)total];
}

@end
