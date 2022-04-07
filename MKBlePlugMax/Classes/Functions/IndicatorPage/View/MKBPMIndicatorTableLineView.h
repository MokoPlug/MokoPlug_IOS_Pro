//
//  MKBPMIndicatorTableLineView.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/31.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBPMIndicatorTableLineViewModel : NSObject

/// msg内容
@property (nonatomic, copy)NSAttributedString *text;

@end

@interface MKBPMIndicatorTableLineView : UITableViewHeaderFooterView

@property (nonatomic, strong)MKBPMIndicatorTableLineViewModel *headerModel;

+ (MKBPMIndicatorTableLineView *)initHeaderViewWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
