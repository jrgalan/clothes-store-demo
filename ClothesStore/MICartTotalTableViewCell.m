//
//  MICartTotalTableViewCell.m
//  ClothesStore
//
//  Created by Jensen Galan on 3/29/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import "MICartTotalTableViewCell.h"

@interface MICartTotalTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel    *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton   *proceedToCheckoutButton;

@end

@implementation MICartTotalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.proceedToCheckoutButton.layer.cornerRadius = 4.f;
    self.proceedToCheckoutButton.layer.masksToBounds =YES;
    self.proceedToCheckoutButton.enabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupCellWithTotalPrice:(NSString *)formattedTotalPrice {
    self.totalLabel.text = formattedTotalPrice;
}

@end
