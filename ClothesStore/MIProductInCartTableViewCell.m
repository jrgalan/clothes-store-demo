//
//  MIProductInCartTableViewCell.m
//  ClothesStore
//
//  Created by Jensen Galan on 3/29/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import "MIProductInCartTableViewCell.h"
#import "UIColor+MIDefaultColors.h"

@interface MIProductInCartTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *inStockLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityInCartLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *saveForLaterOrMoveToCartButton;

@property (nonatomic) MIProductInCartCellType cellType;

@end

@implementation MIProductInCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupCellWithProductName:(NSString *)productName price:(NSString *)price inStock:(BOOL)inStock stockCount:(NSNumber *)stockCount quantityInCart:(NSNumber *)quantityInCart cellType:(MIProductInCartCellType)cellType {
    
    self.productNameLabel.text = productName;
    self.productPriceLabel.text = price;
    
    self.inStockLabel.text = inStock ? NSLocalizedString(@"In stock", @"In stock") : NSLocalizedString(@"Out of stock", @"Out of stock");
    self.inStockLabel.textColor = inStock ? [UIColor defaultGreenColor] : [UIColor defaultRedColor];
    
    NSString *leftInStockString = NSLocalizedString(@"left in stock", @"left in stock");
    self.stockNumberLabel.text = [NSString stringWithFormat:@"%@ %@", stockCount, leftInStockString];
    self.stockNumberLabel.hidden = !inStock;
    
    self.cellType = cellType;
    
    if (self.cellType == MIProductInCartCellTypeCart) {
        self.quantityTitleLabel.hidden = NO;
        self.quantityInCartLabel.hidden = NO;
        self.quantityInCartLabel.text = [NSString stringWithFormat:@"%@", quantityInCart];
        [self.saveForLaterOrMoveToCartButton setTitle:NSLocalizedString(@"Save for later", @"Save for later")
                                             forState:UIControlStateNormal];
    }
    else if (self.cellType == MIProductInCartCellTypeWishList) {
        self.quantityTitleLabel.hidden = YES;
        self.quantityInCartLabel.hidden = YES;
        [self.saveForLaterOrMoveToCartButton setTitle:NSLocalizedString(@"Move to cart", @"Move to cart")
                                             forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)tappedDeleteProduct:(id)sender {
    if ([self.delegate respondsToSelector:@selector(productInCartTableViewCellDidTapDeleteProduct:)]) {
        [self.delegate productInCartTableViewCellDidTapDeleteProduct:self];
    }
}

- (IBAction)tappedSaveForLaterOrMoveToCart:(id)sender {
    
    if (self.cellType == MIProductInCartCellTypeCart) {
        if ([self.delegate respondsToSelector:@selector(productInCartTableViewCellDidTapSaveProductForLater:)]) {
            [self.delegate productInCartTableViewCellDidTapSaveProductForLater:self];
        }
    }
    else if (self.cellType == MIProductInCartCellTypeWishList) {
        if ([self.delegate respondsToSelector:@selector(productInCartTableViewCellDidTapMoveProductToCart:)]) {
            [self.delegate productInCartTableViewCellDidTapMoveProductToCart:self];
        }
    }
    
}

@end
