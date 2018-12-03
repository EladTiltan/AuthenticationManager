//
//  AuthenticationManager.m
//  HotMobile
//
//  Created by elad damari on 03/10/2018.
//  Copyright © 2018 HOT. All rights reserved.
//

#import "AuthenticationManager.h"
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

@implementation AuthenticationManager

#pragma mark Initiate Methods

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setDeviceOwnerAuthenticationType];
    }
    return self;
}

- (void)setDeviceOwnerAuthenticationType
{
    if (@available(iOS 11.0, *))
    {
        LAContext *context                  = [[LAContext alloc] init];
        NSError *error                      = nil;
        if                                  ( [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error] )
        {
            if (context.biometryType        == LABiometryTypeTouchID)
            {
                self.authenticationType     = DeviceOwnerAuthenticationTypeNON;
            }
            else if (context.biometryType   == LABiometryTypeFaceID)
            {
                self.authenticationType     = DeviceOwnerAuthenticationTypeFaceID;
            }
            else
            {
                self.authenticationType     = DeviceOwnerAuthenticationTypeNON;
            }
        }
    }
    else
    {
        self.authenticationType             = DeviceOwnerAuthenticationTypeNON;
    }
}



#pragma mark Flow Methods

- (void)authenicate
{
    LAContext *context                      = [[LAContext alloc] init];
    context.localizedCancelTitle            = @"Enter Username/Password";
    context.localizedFallbackTitle          = @"Fallback title";
    
    NSString *reasonText;
    if (self.authenticationType == DeviceOwnerAuthenticationTypeFaceID) reasonText = @"נא הבט למצלמה כדי להתחבר";
    else                                                                reasonText = @"נא להניח את האצבע על כפתור הבית כדי להתחבר";
    
    [context evaluatePolicy                 : LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reasonText reply:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success)                    [self authenticationSuccess];
            else                            [self authenticationFailureWithError:error];
        });
    }];
}

- (void)authenticationSuccess
{
    NSLog(@"User is authenticated successfully. -->> Do Programmatically Login.");
    if (self.onAuthenticationSuccess) self.onAuthenticationSuccess();
}

- (void)authenticationFailureWithError:(NSError *)authenticationError
{
    switch (authenticationError.code)
    {
        case LAErrorAuthenticationFailed:
            NSLog(@"Authentication Failed. -->> show login popup?");
            break;
            
        case LAErrorUserCancel:
            NSLog(@"User pressed Cancel button");
            break;
            
        case LAErrorUserFallback:
            NSLog(@"User pressed \"Enter Password\". -->> show login popup?");
            break;
            
        default:
            NSLog(@"DeviceOwnerAuthentication is not configured. -->> show login popup?");
            break;
    }
    
    if (self.onAuthenticationFailure) self.onAuthenticationFailure(authenticationError);
}


@end
