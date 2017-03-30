//
//  MIProduct.h
//  ClothesStore
//
//  Created by Jensen Galan on 3/28/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;

NS_ASSUME_NONNULL_BEGIN

@interface MIProduct : NSObject

@property (nullable, nonatomic, copy)   NSString    *category;
@property (nullable, nonatomic, copy)   NSString    *name;
@property (nullable, nonatomic, copy)   NSNumber    *oldPrice;
@property (nullable, nonatomic, copy)   NSNumber    *price;
@property (nullable, nonatomic, copy)   NSNumber    *productId;
@property (nullable, nonatomic, copy)   NSNumber    *stock;
@property (nonatomic, assign)           BOOL        inStock;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (BFTask *)fetchProductCatalog;

@end

NS_ASSUME_NONNULL_END
