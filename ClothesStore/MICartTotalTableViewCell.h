//
//  MICartTotalTableViewCell.h
//  ClothesStore
//
//  Created by Jensen Galan on 3/29/17.
//  Copyright © 2017 Miki Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MICartTotalTableViewCell : UITableViewCell

- (void)setupCellWithTotalPrice:(NSString *)formattedTotalPrice;

@end
