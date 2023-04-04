//
//  APIUrl.h
//  ProjectManagement
//
//  Created by maiyou on 2022/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIUrl : NSObject

extern NSString * const Host;

extern NSString * const Uploads;

extern NSString * const Login;

extern NSString * const UserInfo;

extern NSString * const PcProjectList;

extern NSString * const ProjectDetail;

extern NSString * const PcProjectClasses;

extern NSString * const PcProjectClassesSecondLevel;

extern NSString * const PcProjectSubentry;

extern NSString * const PcProjectSubentrySecondLevel;

extern NSString * const PcProjectGroup;

extern NSString * const RemoveProject;

extern NSString * const AddProject;

extern NSString * const CheckInformList;

extern NSString * const CheckInformNum;

extern NSString * const EditUserInfo;

extern NSString * const EvaluationAdd;

extern NSString * const SubmitEvaluation;

extern NSString * const PcProjectEvaluationBasis;

extern NSString * const PcProjectEvaluationSituation;

extern NSString * const PcProjectEvaluationConclusion;

extern NSString * const ProjectEvaluationSituation;

extern NSString * const Problem;

extern NSString * const BasisListToProject;

extern NSString * const EvaluatingDetails;

@end

NS_ASSUME_NONNULL_END

