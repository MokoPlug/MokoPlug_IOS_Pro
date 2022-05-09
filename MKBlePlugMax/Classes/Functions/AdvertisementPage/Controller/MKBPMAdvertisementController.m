//
//  MKBPMAdvertisementController.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/29.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMAdvertisementController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"

#import "MKBPMAdvTxPowerCell.h"

#import "MKBPMAdvertisementModel.h"

@interface MKBPMAdvertisementController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKBPMAdvTxPowerCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)MKBPMAdvertisementModel *dataModel;

@end

@implementation MKBPMAdvertisementController

- (void)dealloc {
    NSLog(@"MKBPMAdvertisementController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 70.f;
    }
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
    MKBPMAdvTxPowerCell *cell = [MKBPMAdvTxPowerCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //adv name
        self.dataModel.advName = value;
        MKTextFieldCellModel *cellModel = self.section0List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //interval
        self.dataModel.advInterval = value;
        MKTextFieldCellModel *cellModel = self.section0List[1];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - MKBPMAdvTxPowerCellDelegate
- (void)mk_bpm_txPowerValueChanged:(mk_bpm_deviceTxPower)txPower {
    //Tx Power
    self.dataModel.txPower = txPower;
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"ADV Name";
    cellModel1.maxLength = 20;
    cellModel1.textPlaceholder = @"1 ~ 20Characters";
    cellModel1.textFieldType = mk_normal;
    cellModel1.textFieldValue = self.dataModel.advName;
    [self.section0List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"ADV Interval";
    cellModel2.maxLength = 3;
    cellModel2.unit = @"x 100ms";
    cellModel2.textPlaceholder = @"1 ~ 100";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textFieldValue = self.dataModel.advInterval;
    [self.section0List addObject:cellModel2];
}

- (void)loadSection1Datas {
    MKBPMAdvTxPowerCellModel *cellModel = [[MKBPMAdvTxPowerCellModel alloc] init];
    cellModel.txPower = self.dataModel.txPower;
    [self.section1List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Advertisement";
    [self.rightButton setImage:LOADICON(@"MKBlePlugMax", @"MKBPMAdvertisementController", @"bpm_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (MKBPMAdvertisementModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBPMAdvertisementModel alloc] init];
    }
    return _dataModel;
}

@end
