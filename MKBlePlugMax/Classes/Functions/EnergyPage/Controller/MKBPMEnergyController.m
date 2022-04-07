//
//  MKBPMEnergyController.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMEnergyController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "UISegmentedControl+MKAdd.h"

#import "MKHudManager.h"
#import "MKAlertController.h"

#import "MKBPMInterface+MKBPMConfig.h"

#import "MKBPMEnergyModel.h"

#import "MKBPMEnergyHourlyView.h"
#import "MKBPMEnergyDailyView.h"
#import "MKBPMEnergyTotalView.h"

#import "MKBPMSettingController.h"

static CGFloat const segmentWidth = 240.f;
static CGFloat const segmentHeight = 30.f;

#define segmentOffset_Y (defaultTopInset + 20.f)
#define tableViewOffset_Y (segmentOffset_Y + segmentHeight + 5.f)
#define tableViewHeight (kViewHeight - VirtualHomeHeight - tableViewOffset_Y - 49.f)

@interface MKBPMEnergyController ()<UIScrollViewDelegate,
MKBPMEnergyTotalViewDelegate>

@property (nonatomic, strong)UISegmentedControl *segment;

@property (nonatomic, strong)MKBPMEnergyHourlyView *hourView;

@property (nonatomic, strong)MKBPMEnergyDailyView *dailyView;

@property (nonatomic, strong)MKBPMEnergyTotalView *totalView;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)MKBPMEnergyModel *dataModel;

@property (nonatomic, assign)BOOL isScrolling;

@end

@implementation MKBPMEnergyController

- (void)dealloc {
    NSLog(@"MKBPMEnergyController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDatasFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bpm_popToRootViewControllerNotification" object:nil];
}

- (void)rightButtonMethod {
    MKBPMSettingController *vc = [[MKBPMSettingController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isScrolling) {
        return;
    }
    NSInteger index = scrollView.contentOffset.x / kViewWidth;
    if (index == self.segment.selectedSegmentIndex) {
        return;
    }
    [self.segment setSelectedSegmentIndex:index];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.isScrolling = NO;
}

#pragma mark - MKBPMEnergyTotalViewDelegate
- (void)bpm_resetEnergyData {
    NSString *msg = @"After reset, all energy data will be deleted, please confirm again whether to reset it？";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Reset Energy Data"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bpm_needDismissAlert";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self clearAllEnergyDatas];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - event method
- (void)segmentValueChanged {
    NSInteger index = self.scrollView.contentOffset.x / kViewWidth;
    if (index == self.segment.selectedSegmentIndex) {
        return;
    }
    self.isScrolling = YES;
    [self.scrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * kViewWidth, 0) animated:YES];
}

#pragma mark - interface
- (void)readDatasFromDevice {
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

- (void)clearAllEnergyDatas {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBPMInterface bpm_clearAllEnergyDatasWithSucBlock:^{
        [[MKHudManager share] hide];
        [self readDatasFromDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UI
- (void)updateViewState {
    self.defaultTitle = self.dataModel.deviceName;
    
    [self.hourView updateHourlyDatas:self.dataModel.hourlyDic];
    [self.dailyView updateDailyDatas:self.dataModel.dailyDic];
    [self.totalView updateTotalEnergy:self.dataModel.totalEnergy];
}

- (void)loadSubViews {
    [self.rightButton setImage:LOADICON(@"MKBlePlugMax", @"MKBPMEnergyController", @"bpm_moreIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.segment];
    [self.segment setFrame:CGRectMake((kViewWidth - segmentWidth) / 2, segmentOffset_Y, segmentWidth, segmentHeight)];
    [self.view addSubview:self.scrollView];
    [self.scrollView setFrame:CGRectMake(0, tableViewOffset_Y, kViewWidth, tableViewHeight)];
    [self.scrollView addSubview:self.hourView];
    [self.hourView setFrame:CGRectMake(0, 0, kViewWidth, tableViewHeight)];
    [self.scrollView addSubview:self.dailyView];
    [self.dailyView setFrame:CGRectMake(kViewWidth, 0, kViewWidth, tableViewHeight)];
    [self.scrollView addSubview:self.totalView];
    [self.totalView setFrame:CGRectMake(2 * kViewWidth, 0, kViewWidth, tableViewHeight)];
}

#pragma mark - getter
- (UISegmentedControl *)segment {
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"Hourly",@"Daily",@"Total"]];
        [_segment mk_setTintColor:NAVBAR_COLOR_MACROS];
        _segment.selectedSegmentIndex = 0;
        [_segment addTarget:self
                     action:@selector(segmentValueChanged)
           forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(3 * kViewWidth, 0);
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (MKBPMEnergyHourlyView *)hourView {
    if (!_hourView) {
        _hourView = [[MKBPMEnergyHourlyView alloc] init];
    }
    return _hourView;
}

- (MKBPMEnergyDailyView *)dailyView {
    if (!_dailyView) {
        _dailyView = [[MKBPMEnergyDailyView alloc] init];
    }
    return _dailyView;
}

- (MKBPMEnergyTotalView *)totalView {
    if (!_totalView) {
        _totalView = [[MKBPMEnergyTotalView alloc] init];
        _totalView.delegate = self;
    }
    return _totalView;
}

- (MKBPMEnergyModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBPMEnergyModel alloc] init];
    }
    return _dataModel;
}

@end
