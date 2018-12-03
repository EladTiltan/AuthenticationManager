//
//  AuthenticationManager.h
//  HotMobile
//
//  Created by elad damari on 03/10/2018.
//  Copyright © 2018 HOT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DeviceOwnerAuthenticationTypes
{
    DeviceOwnerAuthenticationTypeNON,
    DeviceOwnerAuthenticationTypeTouchID,
    DeviceOwnerAuthenticationTypeFaceID
} AuthenticationType;

@interface AuthenticationManager : NSObject

@property (nonatomic) AuthenticationType authenticationType;

@property (nonatomic, copy) void (^onAuthenticationSuccess)(void);
@property (nonatomic, copy) void (^onAuthenticationFailure)(NSError *authenticationError);

- (void)authenicate;

@end
