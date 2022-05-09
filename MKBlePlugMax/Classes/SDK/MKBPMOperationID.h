typedef NS_ENUM(NSInteger, mk_bpm_taskOperationID) {
    mk_bpm_defaultTaskOperationID,
    
#pragma mark - Read
    mk_bpm_taskReadDeviceModelOperation,        //读取产品型号
    mk_bpm_taskReadMacAddressOperation,         //读取Mac地址
    mk_bpm_taskReadFirmwareOperation,           //读取固件版本
    mk_bpm_taskReadHardwareOperation,           //读取硬件类型
    mk_bpm_taskReadSoftwareOperation,           //读取软件版本
    mk_bpm_taskReadManufacturerOperation,       //读取厂商信息
    mk_bpm_taskReadDeviceTypeOperation,         //读取产品类型
    
#pragma mark - 密码特征
    mk_bpm_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 设备参数
    mk_bpm_taskReadDeviceNameOperation,         //读取设备名称
    mk_bpm_taskReadConnectationNeedPasswordOperation,   //读取密码开关
    mk_bpm_taskReadPasswordOperation,           //读取密码
    mk_bpm_taskReadPowerOnSwitchStatusOperation,    //读取默认开关状态
    mk_bpm_taskReadSwitchReportIntervalOperation,   //读取开关状态上报间隔
    mk_bpm_taskReadPowerReportIntervalOperation,    //读取电量上报间隔
    mk_bpm_taskReadIndicatorBleAdvertisingStatusOperation,  //读取网络指示灯广播状态开关
    mk_bpm_taskReadIndicatorBleConnectedStatusOperation,    //读取网络指示灯连接状态
    mk_bpm_taskReadPowerIndicatorStatusOperation,           //读取电源指示灯开关指示
    mk_bpm_taskReadPowerIndicatorProtectionSignalOperation, //读取电源指示灯保护触发指示
    mk_bpm_taskReadTxPowerOperation,            //读取TxPower
    mk_bpm_taskReadResetByButtonOperation,      //读取按键恢复出厂设置
    mk_bpm_taskReadButtonSwitchFunctionOperation,   //读取按键控制功能开关
    mk_bpm_taskReadResetClearEnergyOperation,       //读取恢复出厂设置的时候是否清除电能
    mk_bpm_taskReadSpecificationsOfDeviceOperation, //读取设备规格
    mk_bpm_taskReadAdvIntervalOperation,        //读取广播间隔
    mk_bpm_taskReadDeviceConnectableOperation,  //读取可连接状态
    mk_bpm_taskReadEnergyStorageIntervalOperation,  //读取电能存储间隔
    mk_bpm_taskReadEnergyStorageChangeThresholdOperation,   //读取功率变化存储阈值
    mk_bpm_taskReadOverLoadProtectionOperation,              //读取过载保护信息
    mk_bpm_taskReadOverVoltageProtectionOperation,           //读取过压保护信息
    mk_bpm_taskReadUnderVoltageProtectionOperation,            //读取欠压保护信息
    mk_bpm_taskReadOverCurrentProtectionOperation,           //读取过流保护信息
    mk_bpm_taskReadPowerIndicatorColorOperation,             //读取功率指示灯颜色
    mk_bpm_taskReadLoadStatusNotificationsOperation,         //读取负载通知开关
    
#pragma mark - 设备控制参数
    mk_bpm_taskReadSwitchStateOperation,        //读取开关状态
    mk_bpm_taskReadPowerDataOperation,          //读取电量数据
    mk_bpm_taskReadTotalEnergyDataOperation,    //查询总累计电能数据
    mk_bpm_taskReadMonthlyEnergyDataOperation,  //查询最近30天的电能数据
    mk_bpm_taskReadHourlyEnergyDataOperation,   //查询当天每小时电能数据
    
#pragma mark - 配置设备参数
    mk_bpm_taskConfigDeviceNameOperation,       //配置设备名称
    mk_bpm_taskConfigNeedPasswordOperation,     //配置密码开关
    mk_bpm_taskConfigPasswordOperation,         //修改密码
    mk_bpm_taskConfigPowerOnSwitchStatusOperation,  //配置默认开关状态
    mk_bpm_taskConfigSwitchReportIntervalOperation, //配置开关状态上报间隔
    mk_bpm_taskConfigPowerReportIntervalOperation,  //配置电量上报间隔
    mk_bpm_taskConfigIndicatorBleAdvertisingStatusOperation,    //配置网络指示灯广播状态开关
    mk_bpm_taskConfigIndicatorBleConnectedStatusOperation,      //配置网络指示灯连接状态
    mk_bpm_taskConfigPowerIndicatorStatusOperation,             //配置电源指示灯开关指示
    mk_bpm_taskConfigPowerIndicatorProtectionSignalOperation,   //配置电源指示灯保护触发指示
    mk_bpm_taskConfigTxPowerOperation,          //配置设备TxPower
    mk_bpm_taskConfigResetByButtonOperation,    //配置按键恢复出厂设置
    mk_bpm_taskConfigButtonSwitchFunctionOperation, //配置按键控制功能开关
    mk_bpm_taskConfigResetClearEnergyOperation,     //配置恢复出厂设置是否清除电能数据
    mk_bpm_taskConfigAdvIntervalOperation,      //配置广播间隔
    mk_bpm_taskConfigConnectableStatusOperation,    //配置可连接状态
    mk_bpm_taskConfigEnergyStorageIntervalOperation,    //配置电能存储间隔
    mk_bpm_taskConfigEnergyStorageChangeThresholdOperation, //配置功率变化存储阈值
    mk_bpm_taskConfigOverLoadOperation,                          //配置过载保护信息
    mk_bpm_taskConfigOverVoltageOperation,                       //配置过压保护信息
    mk_bpm_taskConfigUnderVoltageOperation,                        //配置欠压保护信息
    mk_bpm_taskConfigOverCurrentOperation,                       //配置过流保护信息
    mk_bpm_taskConfigPowerIndicatorColorOperation,              //配置功率指示灯颜色
    mk_bpm_taskConfigLoadStatusNotificationsOperation,          //配置负载通知开关
    
#pragma mark - 配置控制类参数
    mk_bpm_taskConfigSwitchStateOperation,      //配置开关状态
    mk_bpm_taskClearOverloadOperation,          //解除过载状态
    mk_bpm_taskClearOvercurrentOperation,       //解除过流状态
    mk_bpm_taskClearOvervoltageOperation,       //解除过压状态
    mk_bpm_taskClearUndervoltageOperation,      //解除欠压状态
    mk_bpm_taskConfigCountdownOperation,        //配置倒计时
    mk_bpm_taskClearAllEnergyDatasOperation,    //清除电能数据
    mk_bpm_taskConfigDeviceTimeOperation,       //同步时间
    mk_bpm_taskFactoryResetOperation,           //恢复出厂设置
};
