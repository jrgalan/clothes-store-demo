//
//  MIProductInCartTableViewCell.h
//  ClothesStore
//
//  Created by Jensen Galan on 3/29/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MIProductInCartTableViewCell;

@protocol MIProductInCartTableViewCellDelegate <NSObject>
- (void)productInCartTableViewCellDidTapDeleteProduct:(MIProductInCartTableViewCell *)productInCartTableViewCell;
- (void)productInCartTableViewCellDidTapSaveProductForLater:(MIProductInCartTableViewCell *)productInCartTableViewCell;
- (void)productInCartTableViewCellDidTapMoveProductToCart:(MIProductInCartTableViewCell *)productInCartTableViewCell;
@end

@interface MIProductInCartTableViewCell : UITableViewCell

typedef enum : NSUInteger {
    MIProductInCartCellTypeCart,
    MIProductInCartCellTypeWishList
} MIProductInCartCellType;

@property (nonatomic, weak) id<MIProductInCartTableViewCellDelegate>   delegate;

- (void)setupCellWithProductName:(NSString *)productName
                           price:(NSString *)price
                         inStock:(BOOL)inStock
                      stockCount:(NSNumber *)stockCount
                  quantityInCart:(NSNumber *)quantityInCart
                        cellType:(MIProductInCartCellType)cellType;

@end
