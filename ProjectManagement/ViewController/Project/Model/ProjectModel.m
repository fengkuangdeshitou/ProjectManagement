//
//  ProjectModel.m
//  ProjectManagement
//
//  Created by 王帅 on 2023/1/7.
//

#import "ProjectModel.h"

@implementation ProjectModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"Id":@"id"
    };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"subentryClassesSecondLevelEvaluation":[self class]
    };
}

@end
