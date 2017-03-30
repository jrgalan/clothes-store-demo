//
//  MIProduct.m
//  ClothesStore
//
//  Created by Jensen Galan on 3/28/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import "MIProduct.h"
#import "AFHTTPSessionManager.h"
#import "Bolts.h"

@implementation MIProduct

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _category   = [dictionary objectForKey:@"category"];
        _name       = [dictionary objectForKey:@"name"];
        _oldPrice   = [dictionary objectForKey:@"oldPrice"];
        _price      = [dictionary objectForKey:@"price"];
        _productId  = [dictionary objectForKey:@"productId"];
        _stock      = [dictionary objectForKey:@"stock"];
    }
    return self;
}

+ (BFTask *)fetchProductCatalog {
    
    BFTaskCompletionSource *productTask = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *url = @"https://s3.amazonaws.com/active-tools/products.json";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {

        NSMutableArray *allProducts = [NSMutableArray new];
        for (NSDictionary *product in responseObject) {
            MIProduct *newProduct = [[MIProduct alloc] initWithDictionary:product];
            [allProducts addObject:newProduct];
        }
        
        [productTask setResult:allProducts];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [productTask setError:error];
    }];
    
    return productTask.task;
}

- (BOOL)inStock {
    return self.stock.integerValue > 0;
}

@end
