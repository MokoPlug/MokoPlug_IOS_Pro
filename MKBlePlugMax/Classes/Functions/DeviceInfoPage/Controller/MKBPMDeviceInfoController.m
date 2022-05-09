//
//  MKBPMDeviceInfoController.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2021/5/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMDeviceInfoController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKAlertController.h"

#import "MKBPMTextButtonCell.h"

#import "MKBPMDeviceInfoModel.h"

#import "MKBPMUpdateController.h"

@interface MKBPMDeviceInfoController ()<UITableViewDelegate,
UITableViewDataSource,
MKBPMTextButtonCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKBPMDeviceInfoModel *dataModel;

@end

@implementation MKBPMDeviceInfoController

- (void)dealloc {
    NSLog(@"MKBPMDeviceInfoController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return self.section2List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel =  self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKBPMTextButtonCell *cell = [MKBPMTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel =  self.section2List[indexPath.row];
    return cell;
}

#pragma mark - MKBPMTextButtonCellDelegate
/// 用户点击了右侧按钮
/// @param index cell所在序列号
- (void)bpm_textButtonCell_buttonAction:(NSInteger)index {
    if (index == 0) {
        //DFU
        MKBPMUpdateController *vc = [[MKBPMUpdateController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (index == 0) {
        //DFU
        
        NSString *msg = @"Please disconnect the load device before DFU, otherwise there may be security risks.";
        MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@""
                                                                           message:msg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        alertView.notificationName = @"mk_bpm_needDismissAlert";
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:cancelAction];
        @weakify(self);
        UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            
        }];
        [alertView addAction:moreAction];
        
        [self presentViewController:alertView animated:YES completion:nil];
        return;
    }
}

#pragma mark - interface
- (void)readDataFromDevice {
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

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
        
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Product model";
    cellModel1.rightMsg = SafeStr(self.dataModel.productMode);
    [self.section0List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Manufacturer";
    cellModel2.rightMsg = SafeStr(self.dataModel.manu);
    [self.section0List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"Software Version";
    cellModel3.rightMsg = SafeStr(self.dataModel.software);
    [self.section0List addObject:cellModel3];
}

- (void)loadSection1Datas {
    MKBPMTextButtonCellModel *cellModel = [[MKBPMTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.leftMsg = @"Firmware Version";
    cellModel.rightMsg = SafeStr(self.dataModel.firmware);
    cellModel.rightButtonTitle = @"DFU";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"MAC Address";
    cellModel.rightMsg = SafeStr(self.dataModel.macAddress);
    [self.section2List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Device Information";
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
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

- (MKBPMDeviceInfoModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBPMDeviceInfoModel alloc] init];
    }
    return _dataModel;
}

@end
