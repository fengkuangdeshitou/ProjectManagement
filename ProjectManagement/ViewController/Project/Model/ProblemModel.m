//
//  ProblemModel.m
//  ProjectManagement
//
//  Created by 王帅 on 2023/4/1.
//

#import "ProblemModel.h"

@implementation ProblemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"Id":@"id"
    };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"optionContent":[self class],
        @"childProblems":[self class]
    };
}

@end
