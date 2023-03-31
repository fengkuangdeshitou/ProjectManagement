//
//  MLDataSource.h
//  ProjectManagement
//
//  Created by maiyou on 2023/3/31.
//

#import <Foundation/Foundation.h>
#import "MLPAutoCompleteTextFieldDataSource.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLDataSource : NSObject<MLPAutoCompleteTextFieldDataSource,UITextFieldDelegate>

@property(nonatomic,strong) BMKSuggestionSearch *search;
@property(nonatomic,strong) BMKSuggestionSearchOption* option;
@property(nonatomic,strong) NSMutableArray * dataArray;

@end

NS_ASSUME_NONNULL_END
