//
//  MKBPMSwitchController.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMSwitchController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKHudManager.h"
#import "MKAlertController.h"

#import "MKBPMCountdownPickerView.h"

#import "MKBPMCentralManager.h"
#import "MKBPMInterface+MKBPMConfig.h"

#import "MKBPMSwitchModel.h"

#import "MKBPMSettingController.h"

@interface MKBPMSwitchController ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIButton *switchButton;

@property (nonatomic, strong)UILabel *stateLabel;

@property (nonatomic, strong)UILabel *delayTimeLabel;

@property (nonatomic, strong)UIButton *timerButton;

@property (nonatomic, strong)MKBPMSwitchModel *dataModel;

///  0:过载  1:过流  2:过压  3:欠压
@property (nonatomic, assign)NSInteger overType;

/// 第一次读取数据需要更新状态，后续不需要
@property (nonatomic, assign)BOOL needUpdateOverState;

@end

@implementation MKBPMSwitchController

- (void)dealloc {
    NSLog(@"MKBPMSwitchController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDatasFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self addNotifications];
    self.needUpdateOverState = YES;
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bpm_popToRootViewControllerNotification" object:nil];
}

- (void)rightButtonMethod {
    MKBPMSettingController *vc = [[MKBPMSettingController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - notes
- (void)deviceSwitchStateChanged:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    if ([dic[@"isOn"] boolValue] != self.dataModel.isOn) {
        self.delayTimeLabel.hidden = YES;
        self.dataModel.isOn = [dic[@"isOn"] boolValue];
    }
    [self updateViewState];
}

- (void)receiveCountdown:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    NSInteger seconds = [dic[@"remainingTime"] integerValue];
    self.delayTimeLabel.hidden = NO;
    BOOL isOn = [dic[@"isOn"] boolValue];
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    NSString *time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    NSString *msg = [NSString stringWithFormat:@"Device will turn %@ after %@",(isOn ? @"ON" : @"OFF"),time];
    self.delayTimeLabel.text = msg;
}

- (void)receiveDeviceLoadChanged:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    if (![MKBaseViewController isCurrentViewControllerVisible:self]) {
        return;
    }
    BOOL load = [dic[@"load"] boolValue];
    NSString *msg = (load ? @"Load starts working now!" : @"Load stops working now!");
    [self.view showCentralToast:msg];
}

- (void)deviceOverload:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    BOOL overload = [userInfo[@"overload"] boolValue];
    if (!overload) {
        return;
    }
    self.overType = 0;
    [self performSelector:@selector(presentOverNoteAlert) withObject:nil afterDelay:1.f];
}

- (void)deviceOvercurrent:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    BOOL overcurrent = [userInfo[@"overcurrent"] boolValue];
    if (!overcurrent) {
        return;
    }
    self.overType = 1;
    [self performSelector:@selector(presentOverNoteAlert) withObject:nil afterDelay:1.f];
}

- (void)deviceOvervoltage:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    BOOL overvoltage = [userInfo[@"overvoltage"] boolValue];
    if (!overvoltage) {
        return;
    }
    self.overType = 2;
    [self performSelector:@selector(presentOverNoteAlert) withObject:nil afterDelay:1.f];
}

- (void)deviceUndervoltage:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    BOOL undervoltage = [userInfo[@"undervoltage"] boolValue];
    if (!undervoltage) {
        return;
    }
    self.overType = 3;
    [self performSelector:@selector(presentOverNoteAlert) withObject:nil afterDelay:1.f];
}

#pragma mark - event method
- (void)switchButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    
    [MKBPMInterface bpm_configSwitchState:!self.dataModel.isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.delayTimeLabel.hidden = YES;
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)timerButtonPressed {
    MKBPMCountdownPickerViewModel *timeModel = [[MKBPMCountdownPickerViewModel alloc] init];
    timeModel.hour = @"0";
    timeModel.minutes = @"0";
    timeModel.titleMsg = (self.dataModel.isOn ? @"Countdown timer(off)" : @"Countdown timer(on)");
    MKBPMCountdownPickerView *pickView = [[MKBPMCountdownPickerView alloc] init];
    pickView.timeModel = timeModel;
    @weakify(self);
    [pickView showTimePickViewBlock:^(MKBPMCountdownPickerViewModel *timeModel) {
        @strongify(self);
        [self setDelay:[timeModel.hour integerValue] minutes:[timeModel.minutes integerValue]];
    }];
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateViewState];
        if (self.needUpdateOverState) {
            self.needUpdateOverState = NO;
            [self updateOverState];
        }
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)setDelay:(NSInteger)hour minutes:(NSInteger)minutes {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    NSInteger second = hour * 60 * 60 + minutes * 60;
    [MKBPMInterface bpm_configCountdown:second sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)clearOverload {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBPMInterface bpm_clearOverloadWithSucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)clearOvercurrent {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBPMInterface bpm_clearOvercurrentWithSucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)clearOvervoltage {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBPMInterface bpm_clearOvervoltageWithSucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)clearUndervoltage {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBPMInterface bpm_clearUndervoltageWithSucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - Private method
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceSwitchStateChanged:)
                                                 name:mk_bpm_deviceSwitchStatusChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCountdown:)
                                                 name:mk_bpm_deviceCountdownNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceLoadChanged:)
                                                 name:mk_bpm_deviceLoadStatusChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOverload:)
                                                 name:mk_bpm_receiveOverloadNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOvercurrent:)
                                                 name:mk_bpm_receiveOverCurrentNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOvervoltage:)
                                                 name:mk_bpm_receiveOvervoltageNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceUndervoltage:)
                                                 name:mk_bpm_receiveUndervoltageNotification
                                               object:nil];
}

- (void)updateOverState {
    if (self.dataModel.overload) {
        self.overType = 0;
        [self presentOverNoteAlert];
        return;
    }
    if (self.dataModel.overcurrent) {
        self.overType = 1;
        [self presentOverNoteAlert];
        return;
    }
    if (self.dataModel.overvoltage) {
        self.overType = 2;
        [self presentOverNoteAlert];
        return;
    }
    if (self.dataModel.undervoltage) {
        self.overType = 3;
        [self presentOverNoteAlert];
        return;
    }
}

/// 过载、过流、过压、欠压状态推出的弹窗
- (void)presentOverNoteAlert {
    NSString *msg = @"Detect the socket overload, please confirm whether to exit the over-load status?";
    if (self.overType == 1) {
        msg = @"Detect the socket overcurrent, please confirm whether to exit the over-current status?";
    }else if (self.overType == 2) {
        msg = @"Detect the socket overvoltage, please confirm whether to exit the overvoltage status?";
    }else if (self.overType == 3) {
        msg = @"Detect the socket undervoltage, please confirm whether to exit the undervoltage status?";
    }
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Warning"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bpm_needDismissAlert";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bpm_popToRootWithoutAlertNotification" object:nil];
    }];
    [alertView addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self performSelector:@selector(presentDismissOverAlert) withObject:nil afterDelay:0.8f];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

/// 过载、过流、过压、欠压状态推出二级的弹窗
- (void)presentDismissOverAlert {
    NSString *msg = @"If YES, the socket will exit overload status, and please make sure it is within the protection threshold. If NO, you need manually reboot it to exit this status.";
    if (self.overType == 1) {
        msg = @"If YES, the socket will exit overcurrent status, and please make sure it is within the protection threshold. If NO, you need manually reboot it to exit this status.";
    }else if (self.overType == 2) {
        msg = @"If YES, the socket will exit overvoltage status, and please make sure it is within the protection threshold. If NO, you need manually reboot it to exit this status.";
    }else if (self.overType == 3) {
        msg = @"If YES, the socket will exit undervoltage status, and please make sure it is within the protection threshold. If NO, you need manually reboot it to exit this status.";
    }
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Warning"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bpm_needDismissAlert";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bpm_popToRootWithoutAlertNotification" object:nil];
    }];
    [alertView addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        if (self.overType == 0) {
            [self clearOverload];
            return;
        }
        if (self.overType == 1) {
            [self clearOvercurrent];
            return;
        }
        if (self.overType == 2) {
            [self clearOvervoltage];
            return;
        }
        if (self.overType == 3) {
            [self clearUndervoltage];
            return;
        }
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - UI
- (void)updateViewState{
    self.defaultTitle = SafeStr(self.dataModel.deviceName);
    self.custom_naviBarColor = (self.dataModel.isOn ? UIColorFromRGB(0x0188cc) : UIColorFromRGB(0x303a4b));
    [self.backView setBackgroundColor:(self.dataModel.isOn ? UIColorFromRGB(0xf2f2f2) : UIColorFromRGB(0x303a4b))];
    UIImage *switchIcon = (self.dataModel.isOn ? LOADICON(@"MKBlePlugMax", @"MKBPMSwitchController", @"bpm_switchButtonOn.png") : LOADICON(@"MKBlePlugMax", @"MKBPMSwitchController", @"bpm_switchButtonOff.png"));
    [self.switchButton setImage:switchIcon forState:UIControlStateNormal];
    self.stateLabel.textColor = (self.dataModel.isOn ? UIColorFromRGB(0x0188cc) : UIColorFromRGB(0x808080));
    self.stateLabel.text = (self.dataModel.isOn ? @"Socket is on" : @"Socket is off");
}

- (void)loadSubViews {
    [self.rightButton setImage:LOADICON(@"MKBlePlugMax", @"MKBPMSwitchController", @"bpm_moreIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
    }];
    [self.backView addSubview:self.switchButton];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backView.mas_centerX);
        make.width.mas_equalTo(200.f);
        make.top.mas_equalTo(60.f);
        make.height.mas_equalTo(200.f);
    }];
    [self.backView addSubview:self.stateLabel];
    [self.backView addSubview:self.delayTimeLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(-20.f);
        make.top.mas_equalTo(self.switchButton.mas_bottom).mas_offset(45.f);
        make.height.mas_equalTo(3 * MKFont(15.f).lineHeight);
    }];
    [self.delayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(-20.f);
        make.top.mas_equalTo(self.stateLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.backView addSubview:self.timerButton];
    [self.timerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backView.mas_centerX);
        make.width.mas_equalTo(90.f);
        make.top.mas_equalTo(self.delayTimeLabel.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
    return _backView;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setImage:LOADICON(@"MKBlePlugMax", @"MKBPMSwitchController", @"bpm_switchButtonOff.png") forState:UIControlStateNormal];
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = UIColorFromRGB(0x0188cc);
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.font = MKFont(15.f);
        _stateLabel.text = @"Socket is on";
        _stateLabel.numberOfLines = 0;
    }
    return _stateLabel;
}

- (UILabel *)delayTimeLabel{
    if (!_delayTimeLabel) {
        _delayTimeLabel = [[UILabel alloc] init];
        _delayTimeLabel.textColor = UIColorFromRGB(0x0188cc);
        _delayTimeLabel.textAlignment = NSTextAlignmentCenter;
        _delayTimeLabel.font = MKFont(15.f);
    }
    return _delayTimeLabel;
}

- (UIButton *)timerButton {
    if (!_timerButton) {
        _timerButton = [MKCustomUIAdopter customButtonWithTitle:@"Set timer"
                                                         target:self
                                                         action:@selector(timerButtonPressed)];
    }
    return _timerButton;
}

- (MKBPMSwitchModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBPMSwitchModel alloc] init];
    }
    return _dataModel;
}

@end
