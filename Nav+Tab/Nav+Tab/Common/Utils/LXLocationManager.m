//
//  ZLocationManager.m
//  PaixieMall
//
//  Created by zhwx on 15/1/8.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#import "LXLocationManager.h"
//#import "TalkingData.h"

@interface LXLocationManager()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager* o_locationManager;


@end


@implementation LXLocationManager

+(instancetype) sharedInstance
{
    static LXLocationManager* _locationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationManager = [[LXLocationManager alloc] init];
    });
    return _locationManager;
}


-(id) init
{
    if (self = [super init]) {
        self.o_locationManager = [[CLLocationManager alloc] init];
        
        self.o_locationManager.delegate = self;
        self.o_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.o_locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    
    return self;
}


#pragma mark- CLLocationManagerDelegate
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.o_newLocation = newLocation;
    __unsafe_unretained LXLocationManager* _myself = self;
    
//    [TalkingData setLatitude:newLocation.coordinate.latitude
//                   longitude:newLocation.coordinate.longitude];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CLGeocoder* geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks && placemarks.count>0) {
                
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                NSString *country = placemark.ISOcountryCode;
//                NSString *city = placemark.locality;
//                NSLog(@"placemark = %@",placemarks.description);
                
                _myself.o_placmark = placemark;
                
                if ([_myself.o_delegate respondsToSelector:@selector(completionReverseGeocodeLocation:)]) {
                    [_myself.o_delegate completionReverseGeocodeLocation:_myself];
                }
                
                [_myself stopUpdateLocation];
                
            }
        }];
    });
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            
            if ([self.o_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                
                [self.o_locationManager requestWhenInUseAuthorization];
            }
            
            break;
            
        default:
            
            break;
    }
    
}

-(void) startUpdateLocation
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([CLLocationManager locationServicesEnabled]) {
            NSLog(@"定位服务已开启");
        }
        [self.o_locationManager startUpdatingLocation];
    });
}

-(void) stopUpdateLocation
{
    [self.o_locationManager stopUpdatingLocation];
}

@end

