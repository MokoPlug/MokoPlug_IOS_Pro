//
//  MKBPMSettingController.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/29.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMSettingController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKTextSwitchCell.h"
#import "MKTableSectionLineHeader.h"
#import "MKAlertController.h"

#import "MKBPMInterface+MKBPMConfig.h"

#import "MKBPMSettingModel.h"

#import "MKBPMAdvertisementController.h"
#import "MKBPMPowerOnModeController.h"
#import "MKBPMPeriodicalReportingController.h"
#import "MKBPMEnergyReportController.h"
#import "MKBPMProtectionSwitchController.h"
#import "MKBPMLoadStatusController.h"
#import "MKBPMButtonSettingController.h"
#import "MKBPMIndicatorController.h"
#import "MKBPMDeviceInfoController.h"

@interface MKBPMSettingController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)NSMutableArray *section6List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKBPMSettingModel *dataModel;

@property (nonatomic, strong)UITextField *passwordTextField;

@property (nonatomic, strong)UITextField *confirmTextField;

@property (nonatomic, copy)NSString *passwordAsciiStr;

@property (nonatomic, copy)NSString *confirmAsciiStr;

@end

@implementation MKBPMSettingController

- (void)dealloc {
    NSLog(@"MKBPMSettingController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDataFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3 || section == 4 || section == 6) {
        return 10.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //Advertisement
        MKBPMAdvertisementController *vc = [[MKBPMAdvertisementController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        //Change Password
        [self configPassword];
        return;
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        //Power On Default Mode
        MKBPMPowerOnModeController *vc = [[MKBPMPowerOnModeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 3 && indexPath.row == 1) {
        //Periodical Reporting
        MKBPMPeriodicalReportingController *vc = [[MKBPMPeriodicalReportingController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 3 && indexPath.row == 2) {
        //Energy ReportSetting
        MKBPMEnergyReportController *vc = [[MKBPMEnergyReportController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 3 && indexPath.row == 3) {
        //Protection Switch
        MKBPMProtectionSwitchController *vc = [[MKBPMProtectionSwitchController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 3 && indexPath.row == 4) {
        //Notification Switch
        MKBPMLoadStatusController *vc = [[MKBPMLoadStatusController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 4 && indexPath.row == 0) {
        //Indicator Setting
        MKBPMIndicatorController *vc = [[MKBPMIndicatorController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 4 && indexPath.row == 1) {
        //Button Setting
        MKBPMButtonSettingController *vc = [[MKBPMButtonSettingController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 6 && indexPath.row == 0) {
        //Device Information
        MKBPMDeviceInfoController *vc = [[MKBPMDeviceInfoController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return (self.dataModel.verification ? self.section2List.count : 0);
    }
    if (section == 3) {
        return self.section3List.count;
    }
    if (section == 4) {
        return self.section4List.count;
    }
    if (section == 5) {
        return self.section5List.count;
    }
    if (section == 6) {
        return self.section6List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 3) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 4) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 5) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section5List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section6List[indexPath.row];
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Connectable
        [self configConnectable:isOn];
        return;
    }
    if (index == 1) {
        //Password verification
        [self passwordVerification:isOn];
        return;
    }
    if (index == 2) {
        //Erase Energy When Reset
        [self eraseEnergyReset:isOn];
        return;
    }
}

#pragma mark - event method
- (void)resetDeviceAction {
    [self factoryReset];
}

- (void)disconnectDevice {
    NSString *msg = @"Please confirm again whether to disconnect the device.";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Disconnect Device"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bpm_needDismissAlert";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bpm_popToRootWithoutAlertNotification" object:nil];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateViewState];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateViewState {
    MKTextSwitchCellModel *cellModel1 = self.section1List[0];
    cellModel1.isOn = self.dataModel.connectable;
    
    MKTextSwitchCellModel *cellModel2 = self.section1List[1];
    cellModel2.isOn = self.dataModel.verification;
    
    MKTextSwitchCellModel *cellModel3 = self.section5List[0];
    cellModel3.isOn = self.dataModel.eraseEnergy;
    
    self.defaultTitle = SafeStr(self.dataModel.deviceName);
    
    [self.tableView reloadData];
}

#pragma mark - 恢复出厂设置

- (void)factoryReset {
    NSString *msg = @"Please confirm again whether to reset the device.";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Reset Device"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bpm_needDismissAlert";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self sendResetCommandToDevice];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)sendResetCommandToDevice{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBPMInterface bpm_factoryResetWithSucBlock:^{
        [[MKHudManager share] hide];
//        [self.view showCentralToast:@"Factory reset successfully!Please reconnect the device."];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 设置可连接状态
- (void)configConnectable:(BOOL)connectable {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBPMInterface bpm_configConnectableStatus:connectable sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.connectable = connectable;
        MKTextSwitchCellModel *cellModel = self.section1List[0];
        cellModel.isOn = connectable;
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 密码校验
- (void)passwordVerification:(BOOL)verification {
    NSString *msg = (verification ? @"Device will be disconnected, you need enter the password to connect." : @"No password required for the next connection, please confirm again whether to disable it.");
    NSString *title = (verification ? @"Enable verification" : @"Disable verification");
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:title
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bpm_needDismissAlert";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.tableView mk_reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
    [alertView addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self configPasswordVerification:verification];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)configPasswordVerification:(BOOL)verification {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBPMInterface bpm_configNeedPassword:verification sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.verification = verification;
        MKTextSwitchCellModel *cellModel = self.section1List[1];
        cellModel.isOn = verification;
        [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 清除电能存储
- (void)eraseEnergyReset:(BOOL)reset {
    NSString *msg = @"When turn on this option, when perform a reset, the energy data will be deleted.";
    NSString *title = @"Warning";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:title
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bpm_needDismissAlert";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.tableView mk_reloadRow:0 inSection:5 withRowAnimation:UITableViewRowAnimationNone];
    }];
    [alertView addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self configEraseEnergyReset:reset];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)configEraseEnergyReset:(BOOL)reset {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBPMInterface bpm_configResetClearEnergy:reset sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.eraseEnergy = reset;
        MKTextSwitchCellModel *cellModel = self.section5List[0];
        cellModel.isOn = reset;
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadRow:0 inSection:5 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 设置密码
- (void)configPassword{
    @weakify(self);
    NSString *msg = @"The password should be 8 characters.";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Change Password"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bpm_needDismissAlert";
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        @strongify(self);
        self.passwordTextField = nil;
        self.passwordTextField = textField;
        self.passwordAsciiStr = @"";
        [self.passwordTextField setPlaceholder:@"Enter new password"];
        [self.passwordTextField addTarget:self
                                   action:@selector(passwordTextFieldValueChanged:)
                         forControlEvents:UIControlEventEditingChanged];
    }];
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        @strongify(self);
        self.confirmTextField = nil;
        self.confirmTextField = textField;
        self.confirmAsciiStr = @"";
        [self.confirmTextField setPlaceholder:@"Enter new password again"];
        [self.confirmTextField addTarget:self
                                  action:@selector(passwordTextFieldValueChanged:)
                        forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self setPasswordToDevice];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)passwordTextFieldValueChanged:(UITextField *)textField{
    NSString *inputValue = textField.text;
    if (!ValidStr(inputValue)) {
        textField.text = @"";
        if (textField == self.passwordTextField) {
            self.passwordAsciiStr = @"";
        }else if (textField == self.confirmTextField) {
            self.confirmAsciiStr = @"";
        }
        return;
    }
    NSInteger strLen = inputValue.length;
    NSInteger dataLen = [inputValue dataUsingEncoding:NSUTF8StringEncoding].length;
    
    NSString *currentStr = @"";
    if (textField == self.passwordTextField) {
        currentStr = self.passwordAsciiStr;
    }else {
        currentStr = self.confirmAsciiStr;
    }
    if (dataLen == strLen) {
        //当前输入是ascii字符
        currentStr = inputValue;
    }
    if (currentStr.length > 8) {
        textField.text = [currentStr substringToIndex:8];
        if (textField == self.passwordTextField) {
            self.passwordAsciiStr = [currentStr substringToIndex:8];
        }else {
            self.confirmAsciiStr = [currentStr substringToIndex:8];
        }
    }else {
        textField.text = currentStr;
        if (textField == self.passwordTextField) {
            self.passwordAsciiStr = currentStr;
        }else {
            self.confirmAsciiStr = currentStr;
        }
    }
}

- (void)setPasswordToDevice{
    NSString *password = self.passwordTextField.text;
    NSString *confirmpassword = self.confirmTextField.text;
    if (!ValidStr(password) || !ValidStr(confirmpassword) || password.length != 8 || confirmpassword.length != 8) {
        [self.view showCentralToast:@"The password should be 8 characters.Please try again."];
        return;
    }
    if (![password isEqualToString:confirmpassword]) {
        [self.view showCentralToast:@"Password do not match!"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBPMInterface bpm_configPassword:password sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    [self loadSection6Datas];
    
    for (NSInteger i = 0; i < 7; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Advertisement";
    cellModel.showRightIcon = YES;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Connectable";
    [self.section1List addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Password verification";
    [self.section1List addObject:cellModel2];
}

- (void)loadSection2Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Change Password";
    cellModel.showRightIcon = YES;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Power On Default Mode";
    cellModel1.showRightIcon = YES;
    [self.section3List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Periodical Reporting";
    cellModel2.showRightIcon = YES;
    [self.section3List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"Energy Reporting Setting";
    cellModel3.leftMsgTextFont = MKFont(14.f);
    cellModel3.showRightIcon = YES;
    [self.section3List addObject:cellModel3];
    
    MKNormalTextCellModel *cellModel4 = [[MKNormalTextCellModel alloc] init];
    cellModel4.leftMsg = @"Protection Switch";
    cellModel4.showRightIcon = YES;
    [self.section3List addObject:cellModel4];
    
    MKNormalTextCellModel *cellModel5 = [[MKNormalTextCellModel alloc] init];
    cellModel5.leftMsg = @"Notification Switch";
    cellModel5.showRightIcon = YES;
    [self.section3List addObject:cellModel5];
}

- (void)loadSection4Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Indicator Setting";
    cellModel1.showRightIcon = YES;
    [self.section4List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Button Setting";
    cellModel2.showRightIcon = YES;
    [self.section4List addObject:cellModel2];
}

- (void)loadSection5Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"Erase Energy When Reset";
    [self.section5List addObject:cellModel];
}

- (void)loadSection6Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Device Information";
    cellModel.showRightIcon = YES;
    [self.section6List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.tableFooterView = [self footerView];
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (NSMutableArray *)section5List {
    if (!_section5List) {
        _section5List = [NSMutableArray array];
    }
    return _section5List;
}

- (NSMutableArray *)section6List {
    if (!_section6List) {
        _section6List = [NSMutableArray array];
    }
    return _section6List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKBPMSettingModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBPMSettingModel alloc] init];
    }
    return _dataModel;
}

- (UIView *)footerView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 150.f)];
    footerView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    UILabel *resetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20.f, kViewWidth, 44.f)];
    resetLabel.backgroundColor = COLOR_WHITE_MACROS;
    resetLabel.textColor = DEFAULT_TEXT_COLOR;
    resetLabel.font = MKFont(15.f);
    resetLabel.textAlignment = NSTextAlignmentCenter;
    resetLabel.text = @"Reset Device";
    [resetLabel addTapAction:self selector:@selector(resetDeviceAction)];
    [footerView addSubview:resetLabel];
    
    UILabel *disconnectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20.f + 44.f + 10.f, kViewWidth, 44.f)];
    disconnectLabel.backgroundColor = COLOR_WHITE_MACROS;
    disconnectLabel.textColor = DEFAULT_TEXT_COLOR;
    disconnectLabel.font = MKFont(15.f);
    disconnectLabel.textAlignment = NSTextAlignmentCenter;
    disconnectLabel.text = @"Disconnect";
    [disconnectLabel addTapAction:self selector:@selector(disconnectDevice)];
    [footerView addSubview:disconnectLabel];
    
    return footerView;
}

@end
