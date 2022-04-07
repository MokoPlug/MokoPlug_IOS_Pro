//
//  MKBPMBleConnectedIndicatorController.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/31.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMBleConnectedIndicatorController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"

#import "MKBPMInterface.h"
#import "MKBPMInterface+MKBPMConfig.h"

#import "MKBPMSingleSelectedCell.h"

@interface MKBPMBleConnectedIndicatorController ()<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKBPMBleConnectedIndicatorController

- (void)dealloc {
    NSLog(@"MKBPMBleConnectedIndicatorController销毁");
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    mk_bpm_indicatorBleConnectedStatus status = mk_bpm_indicatorBleConnectedStatus_off;
    if (indexPath.row == 0) {
        status = mk_bpm_indicatorBleConnectedStatus_solidBlue;
    }else if (indexPath.row == 1) {
        status = mk_bpm_indicatorBleConnectedStatus_solidBlueForFiveSeconds;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBPMInterface bpm_configIndicatorBleConnectedStatus:status sucBlock:^{
        [[MKHudManager share] hide];
        for (NSInteger i = 0; i < self.dataList.count; i ++) {
            MKBPMSingleSelectedCellModel *cellModel = self.dataList[i];
            cellModel.selected = (i == indexPath.row);
        }
        [self.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKBPMSingleSelectedCell *cell = [MKBPMSingleSelectedCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKBPMInterface bpm_readIndicatorBleConnectedStatusWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self loadSectionDatas:[returnData[@"result"][@"status"] integerValue]];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}


#pragma mark - loadSectionDatas
- (void)loadSectionDatas:(NSInteger)index {
    MKBPMSingleSelectedCellModel *cellModel1 = [[MKBPMSingleSelectedCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Solid blue";
    cellModel1.selected = (index == 2);
    [self.dataList addObject:cellModel1];
    
    MKBPMSingleSelectedCellModel *cellModel2 = [[MKBPMSingleSelectedCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Solid blue for 5 seconds";
    cellModel2.selected = (index == 1);
    [self.dataList addObject:cellModel2];
    
    MKBPMSingleSelectedCellModel *cellModel3 = [[MKBPMSingleSelectedCellModel alloc] init];
    cellModel3.index = 0;
    cellModel3.msg = @"OFF";
    cellModel3.selected = (index == 0);
    [self.dataList addObject:cellModel3];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Indicator  Setting";
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

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
