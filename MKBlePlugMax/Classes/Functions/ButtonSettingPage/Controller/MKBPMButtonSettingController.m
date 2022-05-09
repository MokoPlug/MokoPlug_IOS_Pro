//
//  MKBPMButtonSettingController.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/30.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMButtonSettingController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"

#import "MKBPMInterface+MKBPMConfig.h"

#import "MKBPMButtonSettingModel.h"

@interface MKBPMButtonSettingController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBPMButtonSettingModel *dataModel;

@end

@implementation MKBPMButtonSettingController

- (void)dealloc {
    NSLog(@"MKBPMButtonSettingController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Switch function
        [self configSwitchIsOn:isOn];
        return;
    }
    if (index == 1) {
        //Reset function
        [self configResetIsOn:isOn];
        return;
    }
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

- (void)configSwitchIsOn:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBPMInterface bpm_configButtonSwitchFunction:isOn
                                          sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        self.dataModel.switchIsOn = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[0];
        cellModel.isOn = isOn;
    }
                                       failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView reloadData];
    }];
}

- (void)configResetIsOn:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBPMInterface bpm_configResetByButton:isOn
                                   sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        self.dataModel.resetIsOn = isOn;
        MKTextSwitchCellModel *cellModel = self.dataList[1];
        cellModel.isOn = isOn;
    }
                                failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView reloadData];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Switch function";
    cellModel1.isOn = self.dataModel.switchIsOn;
    [self.dataList addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Reset function";
    cellModel2.isOn = self.dataModel.resetIsOn;
    [self.dataList addObject:cellModel2];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Button Setting";
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
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKBPMButtonSettingModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBPMButtonSettingModel alloc] init];
    }
    return _dataModel;
}

@end
