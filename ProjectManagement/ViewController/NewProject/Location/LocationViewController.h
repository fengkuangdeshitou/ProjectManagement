//
//  LocationViewController.h
//  ProjectManagement
//
//  Created by maiyou on 2023/3/31.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationViewController : BaseViewController

@property (nonatomic, strong) BMKLocationManager * locationManager; //当前位置对象
@property (nonatomic, strong) BMKUserLocation * userLocation; //当前位置对象
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, copy) void(^locationCompletion)(CLLocationCoordinate2D centerCoordinate,NSString * locationName);

@end

NS_ASSUME_NONNULL_END
