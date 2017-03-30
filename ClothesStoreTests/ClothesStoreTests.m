//
//  ClothesStoreTests.m
//  ClothesStoreTests
//
//  Created by Jensen Galan on 3/28/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MICartViewModel.h"

@interface ClothesStoreTests : XCTestCase

@property (nonatomic, strong) MICartViewModel *cartViewModel;
@end

@implementation ClothesStoreTests

- (void)setUp {
    [super setUp];
    self.cartViewModel = [[MICartViewModel alloc] init];
}

- (void)tearDown {
    self.cartViewModel = nil;
    [super tearDown];
}

// Cart tests

- (void)testAddToCart {
    [self.cartViewModel addToCartProductWithID:@(1) quantity:1];
    NSArray *allProductIDsInCart = [self.cartViewModel allProductIDsInCart];
    XCTAssertTrue([allProductIDsInCart containsObject:@(1)], @"Should have ProductId 1 in Cart, but don't");
}

- (void)testRemoveFromCart {
    [self.cartViewModel addToCartProductWithID:@(1) quantity:1];
    [self.cartViewModel removeProductInCartWithProductId:@(1)];
    NSArray *allProductIDsInCart = [self.cartViewModel allProductIDsInCart];
    XCTAssertTrue(![allProductIDsInCart containsObject:@(1)], @"Should not have ProductId 1 in Cart, but do");
}

- (void)testMoveProductFromCartToWishList {
    [self.cartViewModel addToCartProductWithID:@(1) quantity:1];
    [self.cartViewModel moveProductFromCartToWishListProductWithID:@(1)];
    NSArray *allProductIDsInWishList = [self.cartViewModel allProductIDsInWishList];
    XCTAssertTrue([allProductIDsInWishList containsObject:@(1)], @"Should have ProductId 1 in Wish List, but don't");
}

- (void)testMoveProductFromCartToWishListIsRemovedFromCart {
    [self.cartViewModel addToCartProductWithID:@(1) quantity:1];
    [self.cartViewModel moveProductFromCartToWishListProductWithID:@(1)];
    NSArray *allProductIDsInCart = [self.cartViewModel allProductIDsInCart];
    XCTAssertTrue(![allProductIDsInCart containsObject:@(1)], @"Should not have ProductId 1 in Cart, but do");
}

// Wish List Tests

- (void)testAddToWishList {
    [self.cartViewModel addToWishListProductWithID:@(1)];
    NSArray *allProductIDsInWishList = [self.cartViewModel allProductIDsInWishList];
    XCTAssertTrue([allProductIDsInWishList containsObject:@(1)], @"Should have ProductId 1 in Wish List, but don't");
}

- (void)testRemoveFromWishList {
    [self.cartViewModel addToWishListProductWithID:@(1)];
    [self.cartViewModel removeProductInWishListProductId:@(1)];
    NSArray *allProductIDsInWishList = [self.cartViewModel allProductIDsInWishList];
    XCTAssertTrue(![allProductIDsInWishList containsObject:@(1)], @"Should not have ProductId 1 in Wish List, but do");
}

- (void)testMoveProductFromWishListToCart {
    [self.cartViewModel addToWishListProductWithID:@(1)];
    [self.cartViewModel moveProductFromWishListToCartProductWithID:@(1)];
    NSArray *allProductIDsInCart = [self.cartViewModel allProductIDsInCart];
    XCTAssertTrue([allProductIDsInCart containsObject:@(1)], @"Should have ProductId 1 in Cart, but don't");
}

- (void)testMoveProductFromWishListToCartRemovedFromWishLIst {
    [self.cartViewModel addToWishListProductWithID:@(1)];
    [self.cartViewModel moveProductFromWishListToCartProductWithID:@(1)];
    NSArray *allProductIDsInWishList = [self.cartViewModel allProductIDsInWishList];
    XCTAssertTrue(![allProductIDsInWishList containsObject:@(1)], @"Should not have ProductId 1 in Wish List, but do");
}

// Products in Cart Tests

- (void)testOneProductInCart {
    [self.cartViewModel addToCartProductWithID:@(1) quantity:1];
    XCTAssertTrue([[self.cartViewModel quantityInCartForProductId:@(1)] isEqualToNumber:@(1)], @"Should have one Product in Cart, but different");
}

- (void)testTwoProductsInCart {
    [self.cartViewModel addToCartProductWithID:@(1) quantity:2];
    XCTAssertTrue([[self.cartViewModel quantityInCartForProductId:@(1)] isEqualToNumber:@(2)], @"Should have two Products in Cart, but different");
}

- (void)testZeroProductsInCart {
    XCTAssertTrue([self.cartViewModel anyProductsInCart] == NO, @"Should have no Products in Cart, but do");
}

- (void)testHasProductsInCart {
    [self.cartViewModel addToCartProductWithID:@(1) quantity:1];
    XCTAssertTrue([self.cartViewModel anyProductsInCart] == YES, @"Should have Products in Cart, but don't");
}

@end
