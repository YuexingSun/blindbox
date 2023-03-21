//
//  ZXMapNavManager.m
//  ZXHY
//
//  Created by Bern Mac on 8/17/21.
//

#import "ZXMapNavManager.h"
#import "ZXLocationTransFormTool.h"




@implementation ZXMapNavManager


+ (UIAlertController *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)coord currentLocation:(CLLocationCoordinate2D)currentCoord{

    //调用地图
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"前往导航" preferredStyle:UIAlertControllerStyleActionSheet];

    //百度地图

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {

        UIAlertAction *baiduMapAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //坐标转换
            ZXLocationTransFormTool *locationTransFormTool = [[[ZXLocationTransFormTool alloc] initWithLatitude:currentCoord.latitude andLongitude:currentCoord.longitude] transformFromGDToBD];


            ZXLocationTransFormTool *locationTransFormToolEnd = [[[ZXLocationTransFormTool alloc] initWithLatitude:coord.latitude andLongitude:coord.longitude] transformFromGDToBD];
            
            

        NSString *baiduParameterFormat = @"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving";

        NSString *urlString = [[NSString stringWithFormat:

                                baiduParameterFormat,

                                locationTransFormTool.latitude,//用户当前的位置

                                locationTransFormTool.longitude,//用户当前的位置

                                locationTransFormToolEnd.latitude,

                                locationTransFormToolEnd.longitude]

                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        if (@available(iOS 10.0, *)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:NULL];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }

        }];

        [actionSheet addAction:baiduMapAction];

    }

    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://map/"]]) {

        UIAlertAction *gaodeMapAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            
            //坐标转换
            ZXLocationTransFormTool *locationTransFormTool = [[[ZXLocationTransFormTool alloc] initWithLatitude:currentCoord.latitude andLongitude:currentCoord.longitude] transformFromGDToGPS];
            
            ZXLocationTransFormTool *locationTransFormToolEnd = [[ZXLocationTransFormTool alloc] initWithLatitude:coord.latitude andLongitude:coord.longitude];
            
            
            NSString *gaodeParameterFormat = @"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%lf&slon=%lf&sname=我的位置&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=0";
            
            
            NSString *urlString = [[NSString stringWithFormat:

                                    gaodeParameterFormat,

                                    locationTransFormTool.latitude,

                                    locationTransFormTool.longitude,

                                    locationTransFormToolEnd.latitude,

                                    locationTransFormToolEnd.longitude,

                                    @"终点"]

            stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

       
            if (@available(iOS 10.0, *)){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:NULL];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }

        }];

        [actionSheet addAction:gaodeMapAction];

    }

    //苹果地图

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        //起点

        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        
        
        //坐标转换
//        ZXLocationTransFormTool *locationTransFormToolEnd = [[[ZXLocationTransFormTool alloc] initWithLatitude:coord.latitude andLongitude:coord.longitude ] transformFromGDToGPS];

        ZXLocationTransFormTool *locationTransFormToolEnd = [[ZXLocationTransFormTool alloc] initWithLatitude:coord.latitude andLongitude:coord.longitude ];

        //终点
        CLLocationCoordinate2D desCorrdinate = CLLocationCoordinate2DMake(locationTransFormToolEnd.latitude, locationTransFormToolEnd.longitude);
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCorrdinate addressDictionary:nil]];

        //默认驾车

        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]

        launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,

        MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard],

        MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];

    }]];

    //取消按钮

    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    [actionSheet dismissViewControllerAnimated:YES completion:nil];

    }];

    [actionSheet addAction:action3];

    return actionSheet;

}


+ (void)zx_openLocationPermissions{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]){
            [[UIApplication sharedApplication] openURL:url];
        }
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [[WGUIManager wg_topViewController] presentViewController:alert animated:YES completion:nil];
}

@end
