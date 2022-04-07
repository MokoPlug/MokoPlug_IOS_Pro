//
//  CTMediator+MKBPMAdd.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/4/7.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "CTMediator+MKBPMAdd.h"

#import "MKMacroDefines.h"

#import "MKMokoPlugBPMModuleKey.h"

@implementation CTMediator (MKBPMAdd)

- (UIViewController *)CTMediator_MokoPlug_BPM_AboutPage {
    UIViewController *viewController = [self performTarget:kTarget_MokoPlug_module
                                                    action:kAction_MokoPlug_aboutPage
                                                    params:@{}
                                         shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    }
    return [self performTarget:kTarget_MokoPlug_bpm_module
                        action:kAction_MokoPlug_bpm_aboutPage
                        params:@{}
             shouldCacheTarget:NO];
}

#pragma mark - private method
- (UIViewController *)Action_MokoPlug_ViewControllerWithTarget:(NSString *)targetName
                                                        action:(NSString *)actionName
                                                        params:(NSDictionary *)params{
    UIViewController *viewController = [self performTarget:targetName
                                                    action:actionName
                                                    params:params
                                         shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

@end
