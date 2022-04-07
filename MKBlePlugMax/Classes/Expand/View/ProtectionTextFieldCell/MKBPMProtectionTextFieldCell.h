//
//  MKBPMProtectionTextFieldCell.h
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/30.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBPMProtectionTextFieldCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *textValue;

@property (nonatomic, copy)NSString *placeHolder;

@property (nonatomic, assign)NSInteger maxLen;

@end

@protocol MKBPMProtectionTextFieldCellDelegate <NSObject>

- (void)bpm_protectionTextFieldChanged:(NSInteger)index value:(NSString *)value;

@end

@interface MKBPMProtectionTextFieldCell : MKBaseCell

@property (nonatomic, strong)MKBPMProtectionTextFieldCellModel *dataModel;

@property (nonatomic, weak)id <MKBPMProtectionTextFieldCellDelegate>delegate;

+ (MKBPMProtectionTextFieldCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
