//
//  MKBPMProtectionTextFieldCell.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/30.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMProtectionTextFieldCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKTextField.h"
#import "MKCustomUIAdopter.h"

@implementation MKBPMProtectionTextFieldCellModel
@end

@interface MKBPMProtectionTextFieldCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)MKTextField *textField;

@end

@implementation MKBPMProtectionTextFieldCell

+ (MKBPMProtectionTextFieldCell *)initCellWithTableView:(UITableView *)tableView {
    MKBPMProtectionTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBPMProtectionTextFieldCellIdenty"];
    if (!cell) {
        cell = [[MKBPMProtectionTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBPMProtectionTextFieldCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(5.f);
        make.bottom.mas_equalTo(-5.f);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBPMProtectionTextFieldCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBPMProtectionTextFieldCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.textField.text = SafeStr(_dataModel.textValue);
    self.textField.placeholder = SafeStr(_dataModel.placeHolder);
    self.textField.maxLength = _dataModel.maxLen;
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                          placeHolder:@""
                                                             textType:mk_realNumberOnly];
        @weakify(self);
        _textField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bpm_protectionTextFieldChanged:value:)]) {
                [self.delegate bpm_protectionTextFieldChanged:self.dataModel.index value:text];
            }
        };
    }
    return _textField;
}

@end
