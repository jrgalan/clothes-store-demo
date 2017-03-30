//
//  MICategoryListTableViewCell.m
//  ClothesStore
//
//  Created by Jensen Galan on 3/29/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import "MICategoryListTableViewCell.h"

@interface MICategoryListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation MICategoryListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupCellWithCategoryName:(NSString *)categoryName {
    self.categoryLabel.text = categoryName;
}

@end
