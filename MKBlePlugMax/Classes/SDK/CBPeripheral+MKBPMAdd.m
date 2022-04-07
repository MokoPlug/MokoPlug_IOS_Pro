//
//  CBPeripheral+MKBPMAdd.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKBPMAdd.h"

#import <objc/runtime.h>

static const char *bpm_manufacturerKey = "bpm_manufacturerKey";
static const char *bpm_macAddressKey = "bpm_macAddressKey";
static const char *bpm_deviceModelKey = "bpm_deviceModelKey";
static const char *bpm_hardwareKey = "bpm_hardwareKey";
static const char *bpm_softwareKey = "bpm_softwareKey";
static const char *bpm_firmwareKey = "bpm_firmwareKey";

static const char *bpm_passwordKey = "bpm_passwordKey";
static const char *bpm_notifyKey = "bpm_notifyKey";
static const char *bpm_paramConfigKey = "bpm_paramConfigKey";
static const char *bpm_customConfigKey = "bpm_customConfigKey";

static const char *bpm_passwordNotifySuccessKey = "bpm_passwordNotifySuccessKey";
static const char *bpm_notifyNotifySuccessKey = "bpm_notifyNotifySuccessKey";
static const char *bpm_paramConfigNotifySuccessKey = "bpm_paramConfigNotifySuccessKey";
static const char *bpm_customConfigNotifySuccessKey = "bpm_customConfigNotifySuccessKey";

@implementation CBPeripheral (MKPBAdd)

- (void)bpm_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &bpm_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A25"]]) {
                objc_setAssociatedObject(self, &bpm_macAddressKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &bpm_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &bpm_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &bpm_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &bpm_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
                objc_setAssociatedObject(self, &bpm_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &bpm_notifyKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
                objc_setAssociatedObject(self, &bpm_paramConfigKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
                objc_setAssociatedObject(self, &bpm_customConfigKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }
        return;
    }
}

- (void)bpm_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        objc_setAssociatedObject(self, &bpm_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &bpm_notifyNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        objc_setAssociatedObject(self, &bpm_paramConfigNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        objc_setAssociatedObject(self, &bpm_customConfigNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)bpm_connectSuccess {
    if (![objc_getAssociatedObject(self, &bpm_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &bpm_notifyNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &bpm_paramConfigNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &bpm_customConfigNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.bpm_manufacturer || !self.bpm_macAddress || !self.bpm_deviceModel || !self.bpm_hardware || !self.bpm_software || !self.bpm_firmware) {
        return NO;
    }
    if (!self.bpm_password || !self.bpm_notify || !self.bpm_paramConfig || !self.bpm_customConfig) {
        return NO;
    }
    return YES;
}

- (void)bpm_setNil {
    objc_setAssociatedObject(self, &bpm_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bpm_macAddressKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bpm_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bpm_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bpm_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bpm_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &bpm_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bpm_notifyKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bpm_paramConfigKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bpm_customConfigKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &bpm_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bpm_notifyNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bpm_paramConfigNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bpm_customConfigNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)bpm_manufacturer {
    return objc_getAssociatedObject(self, &bpm_manufacturerKey);
}

- (CBCharacteristic *)bpm_macAddress {
    return objc_getAssociatedObject(self, &bpm_macAddressKey);
}

- (CBCharacteristic *)bpm_deviceModel {
    return objc_getAssociatedObject(self, &bpm_deviceModelKey);
}

- (CBCharacteristic *)bpm_hardware {
    return objc_getAssociatedObject(self, &bpm_hardwareKey);
}

- (CBCharacteristic *)bpm_software {
    return objc_getAssociatedObject(self, &bpm_softwareKey);
}

- (CBCharacteristic *)bpm_firmware {
    return objc_getAssociatedObject(self, &bpm_firmwareKey);
}

- (CBCharacteristic *)bpm_password {
    return objc_getAssociatedObject(self, &bpm_passwordKey);
}

- (CBCharacteristic *)bpm_notify {
    return objc_getAssociatedObject(self, &bpm_notifyKey);
}

- (CBCharacteristic *)bpm_paramConfig {
    return objc_getAssociatedObject(self, &bpm_paramConfigKey);
}

- (CBCharacteristic *)bpm_customConfig {
    return objc_getAssociatedObject(self, &bpm_customConfigKey);
}

@end
