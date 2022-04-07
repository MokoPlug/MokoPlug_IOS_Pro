//
//  MKBPMIndicatorColorController.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2021/10/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMIndicatorColorController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKBPMIndicatorColorModel.h"

#import "MKBPMIndicatorColorCell.h"
#import "MKBPMIndicatorColorHeaderView.h"

@interface MKBPMIndicatorColorController ()<UITableViewDelegate,
UITableViewDataSource,
MKBPMIndicatorColorHeaderViewDelegate,
MKBPMIndicatorColorCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBPMIndicatorColorHeaderView *tableHeaderView;

@property (nonatomic, strong)MKBPMIndicatorColorModel *dataModel;

@property (nonatomic, strong)UIButton *statusButton;

@end

@implementation MKBPMIndicatorColorController

- (void)dealloc {
    NSLog(@"MKBPMIndicatorColorController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
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
    return 70.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.dataModel.colorType == bpm_ledColorTransitionDirectly || self.dataModel.colorType == bpm_ledColorTransitionSmoothly) ? self.dataList.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKBPMIndicatorColorCell *cell = [MKBPMIndicatorColorCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKBPMIndicatorColorHeaderViewDelegate
- (void)bpm_colorSettingPickViewTypeChanged:(NSInteger)colorType {
    if (self.dataModel.colorType == colorType) {
        return;
    }
    self.dataModel.colorType = colorType;
    [self.tableView reloadData];
}

#pragma mark - MKBPMIndicatorColorCellDelegate
- (void)bpm_ledColorChanged:(NSString *)value index:(NSInteger)index {
    MKBPMIndicatorColorCellModel *cellModel = self.dataList[index];
    cellModel.textValue = value;
}

#pragma mark - event method
- (void)statusButtonPressed {
    self.statusButton.selected = !self.statusButton.selected;
    UIImage *image = (self.statusButton.selected ? LOADICON(@"MKBlePlugMax", @"MKBPMIndicatorColorController", @"bpm_switchSelectedIcon.png") : LOADICON(@"MKBlePlugMax", @"MKBPMIndicatorColorController", @"bpm_switchUnselectedIcon.png"));
    [self.statusButton setImage:image forState:UIControlStateNormal];
    self.tableView.hidden = !self.statusButton.selected;
    self.dataModel.isOn = self.statusButton.selected;
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
        self.statusButton.selected = self.dataModel.isOn;
        UIImage *image = (self.statusButton.selected ? LOADICON(@"MKBlePlugMax", @"MKBPMIndicatorColorController", @"bpm_switchSelectedIcon.png") : LOADICON(@"MKBlePlugMax", @"MKBPMIndicatorColorController", @"bpm_switchUnselectedIcon.png"));
        [self.statusButton setImage:image forState:UIControlStateNormal];
        self.tableView.hidden = !self.statusButton.selected;
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    MKBPMIndicatorColorCellModel *bModel = self.dataList[0];
    self.dataModel.b_color = [bModel.textValue integerValue];
    MKBPMIndicatorColorCellModel *gModel = self.dataList[1];
    self.dataModel.g_color = [gModel.textValue integerValue];
    MKBPMIndicatorColorCellModel *yModel = self.dataList[2];
    self.dataModel.y_color = [yModel.textValue integerValue];
    MKBPMIndicatorColorCellModel *oModel = self.dataList[3];
    self.dataModel.o_color = [oModel.textValue integerValue];
    MKBPMIndicatorColorCellModel *rModel = self.dataList[4];
    self.dataModel.r_color = [rModel.textValue integerValue];
    MKBPMIndicatorColorCellModel *pModel = self.dataList[5];
    self.dataModel.p_color = [pModel.textValue integerValue];
    
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
    [self.tableHeaderView updateColorType:self.dataModel.colorType];
    
    MKBPMIndicatorColorCellModel *bModel = [[MKBPMIndicatorColorCellModel alloc] init];
    bModel.msg = @"Measured power for blue LED(W)";
    bModel.placeholder = @"";
    bModel.index = 0;
    bModel.textValue = [NSString stringWithFormat:@"%ld",(long)self.dataModel.b_color];
    [self.dataList addObject:bModel];
    
    MKBPMIndicatorColorCellModel *gModel = [[MKBPMIndicatorColorCellModel alloc] init];
    gModel.msg = @"Measured power for green LED(W)";
    gModel.placeholder = @"";
    gModel.index = 1;
    gModel.textValue = [NSString stringWithFormat:@"%ld",(long)self.dataModel.g_color];
    [self.dataList addObject:gModel];
    
    MKBPMIndicatorColorCellModel *yModel = [[MKBPMIndicatorColorCellModel alloc] init];
    yModel.msg = @"Measured power for yellow LED(W)";
    yModel.placeholder = @"";
    yModel.index = 2;
    yModel.textValue = [NSString stringWithFormat:@"%ld",(long)self.dataModel.y_color];
    [self.dataList addObject:yModel];
    
    MKBPMIndicatorColorCellModel *oModel = [[MKBPMIndicatorColorCellModel alloc] init];
    oModel.msg = @"Measured power for orange LED(W)";
    oModel.placeholder = @"";
    oModel.index = 3;
    oModel.textValue = [NSString stringWithFormat:@"%ld",(long)self.dataModel.o_color];
    [self.dataList addObject:oModel];
    
    MKBPMIndicatorColorCellModel *rModel = [[MKBPMIndicatorColorCellModel alloc] init];
    rModel.msg = @"Measured power for red LED(W)";
    rModel.placeholder = @"";
    rModel.index = 4;
    rModel.textValue = [NSString stringWithFormat:@"%ld",(long)self.dataModel.r_color];
    [self.dataList addObject:rModel];
    
    MKBPMIndicatorColorCellModel *pModel = [[MKBPMIndicatorColorCellModel alloc] init];
    pModel.msg = @"Measured power for purple LED(W)";
    pModel.placeholder = @"";
    pModel.index = 5;
    pModel.textValue = [NSString stringWithFormat:@"%ld",(long)self.dataModel.p_color];
    [self.dataList addObject:pModel];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Indicator Setting";
    [self.rightButton setImage:LOADICON(@"MKBlePlugMax", @"MKBPMIndicatorColorController", @"bpm_slotSaveIcon.png") forState:UIControlStateNormal];
    
    UIView *buttonView = [[UIView alloc] init];
    buttonView.backgroundColor = COLOR_WHITE_MACROS;
    [self.view addSubview:buttonView];
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.height.mas_equalTo(44.f);
    }];
    [buttonView addSubview:self.statusButton];
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(buttonView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    UILabel *msgLabel = [self msgLabel];
    [buttonView addSubview:msgLabel];
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.statusButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(buttonView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(buttonView.mas_bottom);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.tableHeaderView;
    }
    return _tableView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKBPMIndicatorColorHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[MKBPMIndicatorColorHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 200.f)];
        _tableHeaderView.delegate = self;
    }
    return _tableHeaderView;
}

- (MKBPMIndicatorColorModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBPMIndicatorColorModel alloc] init];
    }
    return _dataModel;
}

- (UIButton *)statusButton {
    if (!_statusButton) {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusButton addTarget:self
                          action:@selector(statusButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
        [_statusButton setImage:LOADICON(@"MKBlePlugMax", @"MKBPMIndicatorColorController", @"bpm_switchUnselectedIcon.png") forState:UIControlStateNormal];
    }
    return _statusButton;
}

- (UILabel *)msgLabel {
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.textColor = DEFAULT_TEXT_COLOR;
    msgLabel.font = MKFont(15.f);
    msgLabel.text = @"Indicator status";
    return msgLabel;
}

@end
