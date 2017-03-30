//
//  MIProductListTableViewCell.m
//  ClothesStore
//
//  Created by Jensen Galan on 3/29/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import "MIProductListTableViewCell.h"
#import "UIColor+MIDefaultColors.h"

@interface MIProductListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *inStockLabel;

@end

@implementation MIProductListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupCellWithProductName:(NSString *)productName price:(NSString *)price inStock:(BOOL)inStock {
    self.productNameLabel.text = productName;
    self.priceLabel.text = price;
    self.inStockLabel.text = inStock ? NSLocalizedString(@"In stock", @"In stock") : NSLocalizedString(@"Out of stock", @"Out of stock");
    self.inStockLabel.textColor = inStock ? [UIColor defaultGreenColor] : [UIColor defaultRedColor];
}

@end
