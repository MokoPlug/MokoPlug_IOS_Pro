//
//  Target_MokoPlug_BPM_Module.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/4/7.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "Target_MokoPlug_BPM_Module.h"

#import "MKBPMScanController.h"
#import "MKBPMAboutController.h"

@implementation Target_MokoPlug_BPM_Module

- (UIViewController *)Action_MokoPlug_BPM_Module_ScanController:(NSDictionary *)params {
    return [[MKBPMScanController alloc] init];
}


/// 关于页面

- (UIViewController *)Action_MokoPlug_BPM_Module_AboutController:(NSDictionary *)params {
    return [[MKBPMAboutController alloc] init];
}

@end
