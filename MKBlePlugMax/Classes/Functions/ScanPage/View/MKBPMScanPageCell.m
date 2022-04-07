//
//  MKBPMScanPageCell.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMScanPageCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKBPMScanPageModel.h"

@interface MKBPMScanPageCellIconView : UIView

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKBPMScanPageCellIconView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2.f);
        make.width.mas_equalTo(20.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(20.f);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-2.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - getter
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(12.f);
    }
    return _msgLabel;
}

@end

static CGFloat const offset_X = 15.f;
static CGFloat const rssiIconWidth = 20.f;
static CGFloat const rssiIconHeight = 14.f;
static CGFloat const connectButtonWidth = 80.f;
static CGFloat const connectButtonHeight = 30.f;
static CGFloat const batteryIconWidth = 22.f;
static CGFloat const batteryIconHeight = 12.f;

@interface MKBPMScanPageCell ()

@property (nonatomic, strong)UIImageView *rssiIcon;

@property (nonatomic, strong)UILabel *rssiLabel;

@property (nonatomic, strong)UILabel *deviceNameLabel;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UIButton *connectButton;

@property (nonatomic, strong)UILabel *txPowerLabel;

@property (nonatomic, strong)UILabel *stateLabel;

@property (nonatomic, strong)MKBPMScanPageCellIconView *voltageView;

@property (nonatomic, strong)MKBPMScanPageCellIconView *currentView;

@property (nonatomic, strong)MKBPMScanPageCellIconView *powerView;

@property (nonatomic, strong)MKBPMScanPageCellIconView *powerFactorView;

@property (nonatomic, strong)MKBPMScanPageCellIconView *frequencyOfCurrentView;

@property (nonatomic, strong)MKBPMScanPageCellIconView *energyView;

@end

@implementation MKBPMScanPageCell

+ (MKBPMScanPageCell *)initCellWithTableView:(UITableView *)tableView {
    MKBPMScanPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBPMScanPageCellIdenty"];
    if (!cell) {
        cell = [[MKBPMScanPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBPMScanPageCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.rssiIcon];
        [self.contentView addSubview:self.rssiLabel];
        [self.contentView addSubview:self.deviceNameLabel];
        [self.contentView addSubview:self.macLabel];
        [self.contentView addSubview:self.connectButton];
        [self.contentView addSubview:self.txPowerLabel];
        [self.contentView addSubview:self.stateLabel];
        [self.contentView addSubview:self.voltageView];
        [self.contentView addSubview:self.currentView];
        [self.contentView addSubview:self.powerView];
        [self.contentView addSubview:self.powerFactorView];
        [self.contentView addSubview:self.frequencyOfCurrentView];
        [self.contentView addSubview:self.energyView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.rssiIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(10.f);
        make.width.mas_equalTo(rssiIconWidth);
        make.height.mas_equalTo(rssiIconHeight);
    }];
    [self.rssiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rssiIcon.mas_centerX);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.rssiIcon.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.connectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(connectButtonWidth);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(connectButtonHeight);
    }];
    CGFloat nameWidth = (kViewWidth - 2 * offset_X - rssiIconWidth - 10.f - 8.f - connectButtonWidth);
    CGSize nameSize = [NSString sizeWithText:self.deviceNameLabel.text
                                     andFont:self.deviceNameLabel.font
                                  andMaxSize:CGSizeMake(nameWidth, MAXFLOAT)];
    [self.deviceNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiIcon.mas_right).mas_offset(15.f);
        make.centerY.mas_equalTo(self.rssiIcon.mas_centerY);
        make.right.mas_equalTo(self.connectButton.mas_left).mas_offset(-8.f);
        make.height.mas_equalTo(nameSize.height);
    }];
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deviceNameLabel.mas_left);
        make.right.mas_equalTo(self.connectButton.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.deviceNameLabel.mas_bottom).mas_offset(3.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(self.connectButton.mas_width);
        make.top.mas_equalTo(self.macLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.stateLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
        
    }];
    
    CGFloat offset_X = 15.f;
    CGFloat viewWidth = (self.contentView.frame.size.width - 4 * offset_X) / 3;
    CGFloat viewHeight = 30.f;
    [self.voltageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(viewWidth);
        make.top.mas_equalTo(self.stateLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(viewHeight);
    }];
    [self.currentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(viewWidth);
        make.centerY.mas_equalTo(self.voltageView.mas_centerY);
        make.height.mas_equalTo(viewHeight);
    }];
    [self.powerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(viewWidth);
        make.centerY.mas_equalTo(self.voltageView.mas_centerY);
        make.height.mas_equalTo(viewHeight);
    }];
    
    [self.powerFactorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(viewWidth);
        make.top.mas_equalTo(self.voltageView.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(viewHeight);
    }];
    [self.frequencyOfCurrentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(viewWidth);
        make.centerY.mas_equalTo(self.powerFactorView.mas_centerY);
        make.height.mas_equalTo(viewHeight);
    }];
    [self.energyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(viewWidth);
        make.centerY.mas_equalTo(self.powerFactorView.mas_centerY);
        make.height.mas_equalTo(viewHeight);
    }];
}

#pragma mark - event method
- (void)connectButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bpm_scanCellConnectButtonPressed:)]) {
        [self.delegate bpm_scanCellConnectButtonPressed:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBPMScanPageModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBPMScanPageModel.class]) {
        return;
    }
    //顶部
    self.rssiLabel.text = [NSString stringWithFormat:@"%lddBm",(long)_dataModel.rssi];
    self.deviceNameLabel.text = (ValidStr(_dataModel.deviceName) ? _dataModel.deviceName : @"N/A");
    self.macLabel.text = [@"MAC: " stringByAppendingString:(ValidStr(_dataModel.macAddress) ? _dataModel.macAddress : @"N/A")];
    self.stateLabel.text = _dataModel.scanTime;
    self.txPowerLabel.text = [NSString stringWithFormat:@"%@%lddBm",@"Tx Power:  ",(long)[_dataModel.txPower integerValue]];
    self.connectButton.hidden = !_dataModel.connectable;
    
    //下面的参数
    self.voltageView.msgLabel.text = [_dataModel.voltage stringByAppendingString:@" V"];
    self.currentView.msgLabel.text = [_dataModel.current stringByAppendingString:@" A"];
    self.powerView.msgLabel.text = [_dataModel.power stringByAppendingString:@" W"];
    self.powerFactorView.msgLabel.text = [_dataModel.powerFactor stringByAppendingString:@" %"];
    self.frequencyOfCurrentView.msgLabel.text = [_dataModel.frequencyOfCurrent stringByAppendingString:@" HZ"];
    self.energyView.msgLabel.text = [_dataModel.energy stringByAppendingString:@" KWh"];
    if (_dataModel.overLoad) {
        self.stateLabel.text = @"OverLoad";
        return;
    }
    if (_dataModel.overCurrent) {
        self.stateLabel.text = @"OverCurrent";
        return;
    }
    if (_dataModel.overPressure) {
        self.stateLabel.text = @"OverVoltage";
        return;
    }
    if (_dataModel.underVoltage) {
        self.stateLabel.text = @"SagVoltage";
        return;
    }
    if (!_dataModel.switchStatus) {
        self.stateLabel.text = @"OFF";
        return;
    }
    if (_dataModel.switchStatus) {
        self.stateLabel.text = @"ON";
        return;
    }
}

#pragma mark - getter
- (UIImageView *)rssiIcon {
    if (!_rssiIcon) {
        _rssiIcon = [[UIImageView alloc] init];
        _rssiIcon.image = LOADICON(@"MKBlePlugMax", @"MKBPMScanPageCell", @"bpm_scan_rssiIcon.png");
    }
    return _rssiIcon;
}

- (UILabel *)rssiLabel {
    if (!_rssiLabel) {
        _rssiLabel = [[UILabel alloc] init];
        _rssiLabel.textColor = RGBCOLOR(102, 102, 102);
        _rssiLabel.textAlignment = NSTextAlignmentCenter;
        _rssiLabel.font = MKFont(10.f);
    }
    return _rssiLabel;
}

- (UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [[UILabel alloc] init];
        _deviceNameLabel.textAlignment = NSTextAlignmentLeft;
        _deviceNameLabel.font = MKFont(15.f);
        _deviceNameLabel.textColor = DEFAULT_TEXT_COLOR;
    }
    return _deviceNameLabel;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _macLabel;
}

- (UIButton *)connectButton{
    if (!_connectButton) {
        _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_connectButton setBackgroundColor:NAVBAR_COLOR_MACROS];
        [_connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
        [_connectButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_connectButton.titleLabel setFont:MKFont(15.f)];
        [_connectButton.layer setMasksToBounds:YES];
        [_connectButton.layer setCornerRadius:10.f];
        [_connectButton addTarget:self
                           action:@selector(connectButtonPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _connectButton;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = DEFAULT_TEXT_COLOR;
        _stateLabel.textAlignment = NSTextAlignmentLeft;
        _stateLabel.font = MKFont(12.f);
        _stateLabel.text = @"N/A";
    }
    return _stateLabel;
}

- (UILabel *)txPowerLabel {
    if (!_txPowerLabel) {
        _txPowerLabel = [[UILabel alloc] init];
        _txPowerLabel.textColor = DEFAULT_TEXT_COLOR;
        _txPowerLabel.font = MKFont(12.f);
        _txPowerLabel.textAlignment = NSTextAlignmentRight;
    }
    return _txPowerLabel;
}

- (MKBPMScanPageCellIconView *)voltageView {
    if (!_voltageView) {
        _voltageView = [[MKBPMScanPageCellIconView alloc] init];
        _voltageView.icon.image = LOADICON(@"MKBlePlugMax", @"MKBPMScanPageCell", @"bpm_scan_voltageIcon.png");
    }
    return _voltageView;
}

- (MKBPMScanPageCellIconView *)currentView {
    if (!_currentView) {
        _currentView = [[MKBPMScanPageCellIconView alloc] init];
        _currentView.icon.image = LOADICON(@"MKBlePlugMax", @"MKBPMScanPageCell", @"bpm_scan_currentIcon.png");
    }
    return _currentView;
}

- (MKBPMScanPageCellIconView *)powerView {
    if (!_powerView) {
        _powerView = [[MKBPMScanPageCellIconView alloc] init];
        _powerView.icon.image = LOADICON(@"MKBlePlugMax", @"MKBPMScanPageCell", @"bpm_scan_powerIcon.png");
    }
    return _powerView;
}

- (MKBPMScanPageCellIconView *)powerFactorView {
    if (!_powerFactorView) {
        _powerFactorView = [[MKBPMScanPageCellIconView alloc] init];
        _powerFactorView.icon.image = LOADICON(@"MKBlePlugMax", @"MKBPMScanPageCell", @"bpm_scan_powerFactorIcon.png");
    }
    return _powerFactorView;
}

- (MKBPMScanPageCellIconView *)frequencyOfCurrentView {
    if (!_frequencyOfCurrentView) {
        _frequencyOfCurrentView = [[MKBPMScanPageCellIconView alloc] init];
        _frequencyOfCurrentView.icon.image = LOADICON(@"MKBlePlugMax", @"MKBPMScanPageCell", @"bpm_scan_frequencyOfCurrentcon.png");
    }
    return _frequencyOfCurrentView;
}

- (MKBPMScanPageCellIconView *)energyView {
    if (!_energyView) {
        _energyView = [[MKBPMScanPageCellIconView alloc] init];
        _energyView.icon.image = LOADICON(@"MKBlePlugMax", @"MKBPMScanPageCell", @"bpm_scan_energyIcon.png");
    }
    return _energyView;
}

- (UILabel *)createLabelWithFont:(UIFont *)font {
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.textColor = RGBCOLOR(102, 102, 102);
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.font = font;
    return msgLabel;
}

@end
