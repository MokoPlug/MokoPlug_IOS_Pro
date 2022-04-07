#pragma mark - MKPBCentralManager

typedef NS_ENUM(NSInteger, mk_bpm_centralConnectStatus) {
    mk_bpm_centralConnectStatusUnknow,                                           //未知状态
    mk_bpm_centralConnectStatusConnecting,                                       //正在连接
    mk_bpm_centralConnectStatusConnected,                                        //连接成功
    mk_bpm_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_bpm_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_bpm_centralManagerStatus) {
    mk_bpm_centralManagerStatusUnable,                           //不可用
    mk_bpm_centralManagerStatusEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, mk_bpm_switchStatus) {
    mk_bpm_switchStatusPowerOff,        //the switch state is off when the device is just powered on.
    mk_bpm_switchStatusPowerOn,         //the switch state is on when the device is just powered on
    mk_bpm_switchStatusRevertLast,      //when the device is just powered on, the switch returns to the state before the power failure.
};

typedef NS_ENUM(NSInteger, mk_bpm_productModel) {
    mk_bpm_productModel_FE,                        //Europe and France
    mk_bpm_productModel_America,                  //America
    mk_bpm_productModel_UK,                      //UK
};

typedef NS_ENUM(NSInteger, mk_bpm_indicatorBleConnectedStatus) {
    mk_bpm_indicatorBleConnectedStatus_off,                            //off
    mk_bpm_indicatorBleConnectedStatus_solidBlueForFiveSeconds,        //Solid blue for 5 seconds
    mk_bpm_indicatorBleConnectedStatus_solidBlue,                      //Solid blue
};

typedef NS_ENUM(NSInteger, mk_bpm_txPower) {
    mk_bpm_txPowerNeg40dBm,   //RadioTxPower:-40dBm
    mk_bpm_txPowerNeg20dBm,   //-20dBm
    mk_bpm_txPowerNeg8dBm,    //-8dBm
    mk_bpm_txPowerNeg4dBm,    //-4dBm
    mk_bpm_txPower0dBm,       //0dBm
    mk_bpm_txPower4dBm,       //4dBm
    mk_bpm_txPower8dBm,       //8dBm
};

typedef NS_ENUM(NSInteger, mk_bpm_ledColorType) {
    mk_bpm_ledColorTransitionDirectly,
    mk_bpm_ledColorTransitionSmoothly,
    mk_bpm_ledColorWhite,
    mk_bpm_ledColorRed,
    mk_bpm_ledColorGreen,
    mk_bpm_ledColorBlue,
    mk_bpm_ledColorOrange,
    mk_bpm_ledColorCyan,
    mk_bpm_ledColorPurple,
};

#pragma mark ****************************************Protocol************************************************

@protocol mk_bpm_deviceTimeProtocol <NSObject>

@property (nonatomic, assign)NSInteger year;

@property (nonatomic, assign)NSInteger month;

@property (nonatomic, assign)NSInteger day;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger minutes;

@property (nonatomic, assign)NSInteger seconds;

@end

@protocol mk_bpm_ledColorConfigProtocol <NSObject>

/*
 Blue.
 European and French specifications:1 <=  b_color <= 4411.
 American specifications:1 <=  b_color <= 2155.
 British specifications:1 <=  b_color <= 3584.
 */
@property (nonatomic, assign)NSInteger b_color;

/*
 Green.
 European and French specifications:b_color < g_color <= 4412.
 American specifications:b_color < g_color <= 2156.
 British specifications:b_color < g_color <= 3584.
 */
@property (nonatomic, assign)NSInteger g_color;

/*
 Yellow.
 European and French specifications:g_color < y_color <= 4413.
 American specifications:g_color < y_color <= 2157.
 British specifications:g_color < y_color <= 3585.
 */
@property (nonatomic, assign)NSInteger y_color;

/*
 Orange.
 European and French specifications:y_color < o_color <= 4414.
 American specifications:y_color < o_color <= 2158.
 British specifications:y_color < o_color <= 3586.
 */
@property (nonatomic, assign)NSInteger o_color;

/*
 Red.
 European and French specifications:o_color < r_color <= 4415.
 American specifications:o_color < r_color <= 2159.
 British specifications:o_color < r_color <= 3587.
 */
@property (nonatomic, assign)NSInteger r_color;

/*
 Purple.
 European and French specifications:r_color < p_color <=  4416.
 American specifications:r_color < p_color <=  2160.
 British specifications:r_color < p_color <=  3588.
 */
@property (nonatomic, assign)NSInteger p_color;

@end


#pragma mark ****************************************Delegate************************************************

@protocol mk_bpm_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param deviceModel device
/*
 @{
 @"rssi":rssi,
 @"peripheral":peripheral,
 @"deviceName":(advDic[CBAdvertisementDataLocalNameKey] ? advDic[CBAdvertisementDataLocalNameKey] : @""),
 @"macAddress":macAddress,
 @"voltage":voltage,            //V
 @"current":current,            //mA
 @"power":power,    //W
 @"powerFactor":powerFactor,    //1%
 @"frequencyOfCurrent":frequencyOfCurrent,  //Hz
 @"energy":totalEnergy,    //kW*h
 @"txPower":txPower,
 @"switchStatus":@(switchStatus),     //The state of the switch.
 @"load":@(load),               //With or without load.
 @"overLoad":@(overLoad),       //Overload
 @"overCurrent":@(overCurrent), //OverCurrent
 @"overPressure":@(overPressure), //Overvoltage
 @"underVoltage":@(underVoltage),   //Undervoltage
 @"needPassword":@(needPassword),   //Whether a connection password is required.
 @"connectable":@(connectable),     //connectable
 }
 */
- (void)mk_bpm_receiveDevice:(NSDictionary *)deviceModel;

@optional

/// Starts scanning equipment.
- (void)mk_bpm_startScan;

/// Stops scanning equipment.
- (void)mk_bpm_stopScan;

@end
