//
//  APIUrl.m
//  ProjectManagement
//
//  Created by maiyou on 2022/12/29.
//

#import "APIUrl.h"

@implementation APIUrl

NSString * const Host = @"http://120.79.249.114:9001";

NSString * const Uploads = @"app/common/uploads";

NSString * const Login = @"app/login/login";

NSString * const UserInfo = @"app/user/getInfo";

NSString * const PcProjectList = @"app/project/getPcProjectList";

NSString * const ProjectDetail = @"app/project/getPcProjectDetails";

NSString * const PcProjectClasses = @"app/project/getPcProjectClasses";

NSString * const PcProjectClassesSecondLevel = @"app/project/getPcProjectClassesSecondLevel";

NSString * const PcProjectSubentry = @"app/project/getPcProjectSubentry";

NSString * const PcProjectSubentrySecondLevel = @"app/project/getPcProjectSubentrySecondLevel";

NSString * const PcProjectGroup = @"app/project/getPcProjectGroup";

NSString * const RemoveProject = @"app/project/remove";

NSString * const AddProject = @"app/project/addProject";

NSString * const CheckInformList = @"app/checkInform/getCheckInformList";

NSString * const CheckInformNum = @"app/checkInform/getCheckInformNum";

NSString * const EditUserInfo = @"app/user/edit";

NSString * const EvaluationAdd = @"app/evaluation/add";

NSString * const SubmitEvaluation = @"app/evaluation/submitEvaluation";

NSString * const PcProjectEvaluationBasis = @"app/evaluation/getPcProjectEvaluationBasis";

NSString * const PcProjectEvaluationSituation = @"app/evaluation/getPcProjectEvaluationSituation";

NSString * const PcProjectEvaluationConclusion = @"app/evaluation/getPcProjectEvaluationConclusion";

NSString * const ProjectEvaluationSituation = @"app/evaluation/getProjectEvaluationSituation";

NSString * const Problem = @"app/problem/getProblem";

NSString * const BasisListToProject = @"app/problem/getBasisListToProject";

NSString * const EvaluatingDetails = @"app/evaluation/getEvaluatingDetails";


@end
