//
//  MKBPMSingleSelectedCell.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/31.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMSingleSelectedCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKBPMSingleSelectedCellModel
@end

@interface MKBPMSingleSelectedCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIImageView *selectedIcon;

@end

@implementation MKBPMSingleSelectedCell

+ (MKBPMSingleSelectedCell *)initCellWithTableView:(UITableView *)tableView {
    MKBPMSingleSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBPMSingleSelectedCellIdenty"];
    if (!cell) {
        cell = [[MKBPMSingleSelectedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBPMSingleSelectedCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.selectedIcon];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.selectedIcon.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.selectedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(15.f);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBPMSingleSelectedCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBPMSingleSelectedCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.selectedIcon.hidden = !_dataModel.selected;
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

- (UIImageView *)selectedIcon {
    if (!_selectedIcon) {
        _selectedIcon = [[UIImageView alloc] init];
        _selectedIcon.image = LOADICON(@"MKBlePlugMax", @"MKBPMSingleSelectedCell", @"bpm_modifyPowerOnSelectedIcon.png");
    }
    return _selectedIcon;
}

@end
