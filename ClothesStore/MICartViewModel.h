//
//  MICartViewModel.h
//  ClothesStore
//
//  Created by Jensen Galan on 3/28/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MICartViewModel : NSObject

- (NSArray <NSNumber *> *)allProductIDsInCart;
- (NSArray <NSNumber *> *)allProductIDsInWishList;
- (NSMutableDictionary <NSNumber *, NSNumber *>  *)allProductIDsWithQuantities;

// Add, move, and remove items from Cart
- (void)addToCartProductWithID:(NSNumber *)productId
                      quantity:(NSInteger)quantityToAdd;

- (void)removeProductInCartWithProductId:(NSNumber *)productId;
- (void)moveProductFromCartToWishListProductWithID:(NSNumber *)productId;

// Add, move, and remove items from Wish List
- (void)addToWishListProductWithID:(NSNumber *)productId;
- (void)removeProductInWishListProductId:(NSNumber *)productIdToRemove;
- (void)moveProductFromWishListToCartProductWithID:(NSNumber *)productId;

- (NSNumber * _Nullable)quantityInCartForProductId:(NSNumber *)productId;

@end

NS_ASSUME_NONNULL_END
