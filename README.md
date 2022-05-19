# MK117B iOS Software Development Kit Guide

* This SDK only support devices based on MK117B.

# Design instructions

* We divide the communications between SDK and devices into two stages: Scanning stage, Connection stage.For ease of understanding, let’s take a look at the related classes and the relationships between them.

`MKBPMCentralManager`：global manager, check system’s bluetooth status, listen status changes, the most important is scan and connect to devices;

`MKBPMInterface`: When the device is successfully connected, the device data can be read through the interface in`MKBPMInterface`;

`MKBPMInterface+MKBPMConfig.h`: When the device is successfully connected, you can configure the device data through the interface in`MKBPMInterface+MKBPMConfig.h`;


## Scanning Stage

in this stage, `MKBPMCentralManager ` will scan and analyze the advertisement data of MK117B devices.


## Connection Stage

Through the scanned data, you can know whether the current device needs a password when connecting. If a password is required, call the method `connectPeripheral:password:sucBlock:failedBlock:`, and if no password is required, call the method `connectPeripheral:sucBlock:failedBlock:` .


# Get Started

### Development environment:

* Xcode9+， due to the DFU and Zip Framework based on Swift4.0, so please use Xcode9 or high version to develop;
* iOS12, we limit the minimum iOS system version to 12.0；

### Import to Project

CocoaPods

SDK-BPM is available through CocoaPods.To install it, simply add the following line to your Podfile, and then import <MKBlePlugMax/MKBPMSDK.h>:

**pod 'MKBlePlugMax/SDK'**


* <font color=#FF0000 face="黑体">!!!on iOS 10 and above, Apple add authority control of bluetooth, you need add the string to “info.plist” file of your project: Privacy - Bluetooth Peripheral Usage Description - “your description”. as the screenshot below.</font>

* <font color=#FF0000 face="黑体">!!! In iOS13 and above, Apple added permission restrictions on Bluetooth APi. You need to add a string to the project’s info.plist file: Privacy-Bluetooth Always Usage Description-“Your usage description”.</font>


## Start Developing

### Get sharedInstance of Manager

First of all, the developer should get the sharedInstance of Manager:

```
MKBPMCentralManager *manager = [MKBPMCentralManager shared];
```

#### 1.Start scanning task to find devices around you,please follow the steps below:

* 1.Set the scan delegate and complete the related delegate methods.

```
manager.delegate = self;
```

* 2.you can start the scanning task in this way:

```
[manager startScan];
```

* 3.at the sometime, you can stop the scanning task in this way:

```
[manager stopScan];
```

#### 2.Connect to device

* 1.If the device requires a connection password, the connection method is as follows:

```
[[MKBPMCentralManager shared] connectPeripheral:peripheral password:password sucBlock:^(CBPeripheral *peripheral) {
        //Success
    } failedBlock:^(NSError *error) {
        //Failed
    }];
```

* 3.If the device does not require a connection password, the connection method is as follows:

```
[[MKBPMCentralManager shared] connectPeripheral:peripheral sucBlock:^(CBPeripheral *peripheral) {
        //Success
    } failedBlock:^(NSError *error) {
        //Failed
    }];
```

#### 3.Get State

Through the manager, you can get the current Bluetooth status of the mobile phone, and the connection status of the device. If you want to monitor the changes of these two states, you can register the following notifications to achieve:

* When the Bluetooth status of the mobile phone changes，<font color=#FF0000 face="黑体">`mk_bpm_centralManagerStateChangedNotification`</font> will be posted.You can get status in this way:

```
[[MKBPMCentralManager shared] centralStatus];
```

* When the device connection status changes， <font color=#FF0000 face="黑体"> `mk_bpm_peripheralConnectStateChangedNotification` </font> will be posted.You can get the status in this way:

```
[MKBPMCentralManager shared].connectStatus;
```


#### 4.Monitoring device disconnect reason.

Register for <font color=#FF0000 face="黑体"> `mk_bpm_deviceDisconnectTypeNotification ` </font> notifications to monitor data.

 
```

[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:mk_bpm_deviceDisconnectTypeNotification
                                               object:nil];
```


```
#pragma mark - note
- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    //After connecting the device, if no password is entered within one minute, it returns 0x01. After successful password change, it returns 0x02.The device restart ,it returns 0x04.
}
```


#### 5.Monitor switch state changes

* 1.Register for <font color=#FF0000 face="黑体"> `mk_bpm_deviceSwitchStatusChangedNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceSwitchStateChanged:)
                                                 name:mk_bpm_deviceSwitchStatusChangedNotification
                                               object:nil];
```

```
#pragma mark - notes
- (void)deviceSwitchStateChanged:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    BOOL isOn = [dic[@"isOn"] boolValue];
    if (isOn) {
        //ON
    }else {
    //OFF
    }
}
```

#### 6.Listen for changes in device load status


* 1.Register for <font color=#FF0000 face="黑体"> `mk_bpm_deviceLoadStatusChangedNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceLoadChanged:)
                                                 name:mk_bpm_deviceLoadStatusChangedNotification
                                               object:nil];
```

```
- (void)receiveDeviceLoadChanged:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    
    BOOL load = [dic[@"load"] boolValue];
    if (load) {
        //Load starts working 
    }else {
        //Load stops working
    }
}
```

#### 7.Monitor the total accumulated energy data of the device

Register for <font color=#FF0000 face="黑体"> `mk_bpm_receiveTotalEnergyDataNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTotalEnergy:)
                                                     name:mk_bpm_receiveTotalEnergyDataNotification
                                                   object:nil];

```

```
#pragma mark - note
- (void)receiveTotalEnergy:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    //10.55 KWh
    NSString *energyValue = dic[@"total"];
}
```

#### 8.Monitor the energy data of the device in the last 30 days

Register for <font color=#FF0000 face="黑体"> `mk_bpm_receiveMonthlyEnergyDataNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveDailyDatas:)
                                                     name:mk_bpm_receiveMonthlyEnergyDataNotification
                                                   object:nil];

```

```
#pragma mark - note
- (void)receiveDailyDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    /*
    @{
        @"year":2022,
        @"month":05,
        @"day":01,
        @"hour":01,
        @"number":5,    //The number of energyList array data.
        @"energyList":energyList    //The first data is the electric energy data (KWh) of 2022-05-01, the second is the electric energy data (KWh) of 2022-04-30, ... the last data is the electric energy data of 2022-04-27.
    };
    */
    
}
```

#### 9.Monitor the energy data of the device every hour of the day

Register for <font color=#FF0000 face="黑体"> `mk_bpm_receiveHourlyEnergyDataNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveHourlyDatas:)
                                                     name:mk_bpm_receiveHourlyEnergyDataNotification
                                                   object:nil];

```

```
#pragma mark - note
- (void)receiveHourlyDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    /*
    @{
        @"year":2022,
        @"month":05,
        @"day":01,
        @"hour":05,
        @"number":5,    
        @"energyList":energyList    //The first data is the electric energy data (KWh) of 04:00~05:00 on 2022-05-01, the second is the electric energy data (KWh) of 03:00~04:00, ... The last data is Energy data from 00:00~01:00.
    };
    */
}
```

#### 10.Monitor device overload status

Register for <font color=#FF0000 face="黑体"> `mk_bpm_receiveOverloadNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOverload:)
                                                 name:mk_bpm_receiveOverloadNotification
                                               object:nil];

```

```
- (void)deviceOverload:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    BOOL overload = [userInfo[@"overload"] boolValue];
    if (overload) {
          //overload
        return;
    }
}
```

#### 11.Monitor device overcurrent status

Register for <font color=#FF0000 face="黑体"> `mk_bpm_receiveOverCurrentNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOvercurrent:)
                                                 name:mk_bpm_receiveOverCurrentNotification
                                               object:nil];

```

```
- (void)deviceOvercurrent:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    BOOL overcurrent = [userInfo[@"overcurrent"] boolValue];
    if (overcurrent) {
          //overcurrent
        return;
    }
}
```

#### 12.Monitor device overvoltage status

Register for <font color=#FF0000 face="黑体"> `mk_bpm_receiveOvervoltageNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOvervoltage:)
                                                 name:mk_bpm_receiveOvervoltageNotification
                                               object:nil];

```

```
- (void)deviceOvervoltage:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    BOOL overvoltage = [userInfo[@"overvoltage"] boolValue];
    if (overvoltage) {
    //overvoltage
        return;
    }
}
```

#### 13.Monitor device undervoltage status

Register for <font color=#FF0000 face="黑体"> `mk_bpm_receiveUndervoltageNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOverload:)
                                                 name:mk_bpm_receiveUndervoltageNotification
                                               object:nil];

```

```
- (void)deviceUndervoltage:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo)) {
        return;
    }
    BOOL undervoltage = [userInfo[@"undervoltage"] boolValue];
    if (undervoltage) {
    //undervoltage
        return;
    }
}
```

#### 14.Monitor device countdown notifications

Register for <font color=#FF0000 face="黑体"> `mk_bpm_deviceCountdownNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveCountdown:)
                                                     name: mk_bpm_deviceCountdownNotification
                                                   object:nil];

```

```
- (void)receiveCountdown:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    /*
    @{
            @"remainingTime":@"50",    //The remaining time for the socket switch state to change (unit: s).
            @"isOn":@(YES),        //Switch state after remainingTime.
        };
    */
}
```

#### 15.Monitor the current battery data of the device

Register for <font color=#FF0000 face="黑体"> `mk_bpm_devicePowerDataNotification ` </font> notifications to monitor data.

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePowerDatas:)
                                                 name:mk_bpm_devicePowerDataNotification
                                               object:nil];

```

```
#pragma mark - notes
- (void)receivePowerDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    /*
    @{
            @"voltage":@"220.1",        //V
            @"current":@"1000",        //mA
            @"power":@"5.5",            //W
            @"frequencyOfCurrent":@"55.55",        //Hz
            @"powerFactor":@"5.55",
        };
    */
}
```


# Change log

* 20220519 first version
