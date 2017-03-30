//
//  MICartViewModel.m
//  ClothesStore
//
//  Created by Jensen Galan on 3/28/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import "MICartViewModel.h"

@interface MICartViewModel ()

@property (nonatomic, strong) NSMutableArray <NSNumber *>                   *productIDsInCart;
@property (nonatomic, strong) NSMutableArray <NSNumber *>                   *productIDsInWishList;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSNumber *>  *productIDsWithQuantities;

@end

@implementation MICartViewModel

- (instancetype)init {
    if (self = [super init]) {
        _productIDsInCart = [NSMutableArray new];
        _productIDsInWishList = [NSMutableArray new];
        _productIDsWithQuantities = [NSMutableDictionary new];
    }
    return self;
}

- (NSArray *)allProductIDsInCart {
    return [self.productIDsInCart copy];
}

- (NSArray *)allProductIDsInWishList {
    return [self.productIDsInWishList copy];
}

- (NSMutableDictionary *)allProductIDsWithQuantities {
    return self.productIDsWithQuantities;
}

- (void)addToCartProductWithID:(NSNumber *)productId quantity:(NSInteger)quantityToAdd {
    
    // if Product was in Wish List, remove when adding to Cart
    [self removeProductInWishListProductId:productId];
    
    if ([self.productIDsWithQuantities objectForKey:productId]) {
        NSInteger quantity = [[self.productIDsWithQuantities objectForKey:productId] integerValue];
        quantity = quantity + quantityToAdd;
        [self.productIDsWithQuantities setObject:@(quantity) forKey:productId];
    }
    else {
        [self.productIDsWithQuantities setObject:@(quantityToAdd) forKey:productId];
        [self.productIDsInCart addObject:productId];
    }
}

- (void)removeProductInCartWithProductId:(NSNumber *)productIdToRemove {
    
    // 1. remove from Products/Quantites dictionary
    if ([self.productIDsWithQuantities objectForKey:productIdToRemove]) {
        [self.productIDsWithQuantities removeObjectForKey:productIdToRemove];
    }
    
    // 2. remove from ProductIDs array (used for ordering -> better solution create object to encapsulate
    NSInteger indexToRemove = -1;
    for (NSInteger i=0; i < self.productIDsInCart.count; i++) {
        NSNumber *productId = self.productIDsInCart[i];
        if ([productId isEqualToNumber:productIdToRemove]) {
            indexToRemove = i;
            break;
        }
    }
    if (indexToRemove >= 0) {
        [self.productIDsInCart removeObjectAtIndex:indexToRemove];
    }
    
}

- (void)moveProductFromCartToWishListProductWithID:(NSNumber *)productId {
    [self removeProductInCartWithProductId:productId];
    [self addToWishListProductWithID:productId];
}

- (void)addToWishListProductWithID:(NSNumber *)productId {
    for (NSNumber *existingProductId in self.productIDsInWishList) {
        if ([existingProductId isEqualToNumber:productId]) {
            return;
        }
    }
    
    [self.productIDsInWishList addObject:productId];
             
}

- (void)removeProductInWishListProductId:(NSNumber *)productIdToRemove {
    NSInteger indexToRemove = -1;
    for (NSInteger i=0; i < self.productIDsInWishList.count; i++) {
        NSNumber *productId = self.productIDsInWishList[i];
        if ([productId isEqualToNumber:productIdToRemove]) {
            indexToRemove = i;
            break;
        }
    }
    if (indexToRemove >= 0) {
        [self.productIDsInWishList removeObjectAtIndex:indexToRemove];
    }
    
}

- (void)moveProductFromWishListToCartProductWithID:(NSNumber *)productId {
    [self addToCartProductWithID:productId
                        quantity:1];
}

- (NSNumber *)quantityInCartForProductId:(NSNumber *)productId {
    return [self.productIDsWithQuantities objectForKey:productId];
}

- (BOOL)anyProductsInCart {
    return self.productIDsInCart.count > 0;
}

@end
