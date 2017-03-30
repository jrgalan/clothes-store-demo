//
//  MIProductCatalogViewModel.h
//  ClothesStore
//
//  Created by Jensen Galan on 3/28/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;

NS_ASSUME_NONNULL_BEGIN

@interface MIProductCatalogViewModel : NSObject

@property (nonatomic, strong)   NSArray<NSString *>     *allCategories;

- (BFTask *)updateProductCatalog;

- (NSArray <NSNumber *> * _Nullable)allProductIDsForCategory:(NSString *)category;

- (NSString * _Nullable)productNameForProductId:(NSNumber *)productId;
- (NSNumber * _Nullable)productPriceForProductId:(NSNumber *)productId;
- (NSNumber * _Nullable)productStockForProductId:(NSNumber *)productId;
- (BOOL)productInStockProductId:(NSNumber *)productId;

- (NSString *)formattedTotalForProductIDsAndQuantities:(NSDictionary <NSNumber *, NSNumber *> *)productIDsAndQuantitiesDictionary;

@end

NS_ASSUME_NONNULL_END
