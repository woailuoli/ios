//
//  InstanceTableViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/10.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InstanceTableViewCell : UITableViewCell
@property (nonatomic, strong) void ((^btnClick)(UIButton*));

@property (nonatomic,copy)      NSDictionary    *dic;
@property (nonatomic,strong)    UIImageView     *imageViewLeft;
@property (nonatomic,strong)    UILabelAlignToTopLeft         *labelTitle;
@property (nonatomic,strong)    UILabel         *labelPrice;
@property (nonatomic,strong)    UILabel         *labelPriceOrigin;
@property (nonatomic,strong)    UILabel         *labelGoodsSalesNumber;

@property (nonatomic,strong)    UIButton        *buttonDetail;
@end

NS_ASSUME_NONNULL_END
