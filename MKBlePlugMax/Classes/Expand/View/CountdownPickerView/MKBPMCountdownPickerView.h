//
//  MKBPMCountdownPickerView.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/29.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBPMCountdownPickerViewModel : NSObject

@property (nonatomic, copy)NSString *hour;

@property (nonatomic, copy)NSString *minutes;

@property (nonatomic, copy)NSString *titleMsg;

@end

@interface MKBPMCountdownPickerView : UIView

@property (nonatomic, strong)MKBPMCountdownPickerViewModel *timeModel;

- (void)showTimePickViewBlock:(void (^)(MKBPMCountdownPickerViewModel *timeModel))Block;

@end

NS_ASSUME_NONNULL_END
