//
//  ProjectModel.h
//  ProjectManagement
//
//  Created by 王帅 on 2023/1/7.
//

#import <Foundation/Foundation.h>
#import "ProblemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProjectModel : NSObject

@property(nonatomic,strong) NSString * Id;
@property(nonatomic,strong) NSString * projectId;
@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,assign) BOOL isAllConfig;
/// 建设单位
@property(nonatomic,strong) NSString * constructionUnit;
/// 项目地址名称
@property(nonatomic,strong) NSString * addressName;
@property(nonatomic,strong) NSString * address;
/// 0不合格 1合格
@property(nonatomic,strong) NSString * resultContrast;
/// 项目综述
@property(nonatomic,strong) NSString * review;
/// 状态（0评测中 1审核中 2 审核通过 3 审核未通过）
@property(nonatomic,strong) NSString * status;
/// 来源（0后台 1App）
@property(nonatomic,strong) NSString * source;
/// 项目类型(1使用评测 2督导评测 3设计评估)
@property(nonatomic,strong) NSString * type;
@property(nonatomic,strong) NSString * serialNumber;
@property(nonatomic,strong) NSString * contacts;
@property(nonatomic,strong) NSString * phone;
@property(nonatomic,strong) NSString * content;
@property(nonatomic,strong) NSArray<NSString *> * subentryClassesList;
/// 使用群体
@property(nonatomic,strong) NSString * groupNames;
/// 项目使用群体信息
@property(nonatomic,strong) NSArray<NSString*> * groupList;
/// 二级分项类别评测信息
@property(nonatomic,strong) NSArray<ProjectModel*> * subentryClassesSecondLevelEvaluation;
@property(nonatomic,strong) ProjectModel * evaluation;
/// 测评面积/道路总长
@property(nonatomic,strong) NSString * value;
/// 评测结论内容
@property(nonatomic,strong) NSString * conclusionContent;
/// 评测结论id
@property(nonatomic,strong) NSString * conclusionId;
/// 评测情况内容
@property(nonatomic,strong) NSString * conditionContent;
/// 评测情况id
@property(nonatomic,strong) NSString * conditionId;
/// 评测依据内容
@property(nonatomic,strong) NSString * basisContent;
/// 评测依据id
@property(nonatomic,strong) NSString * basisId;
/// 是否整改(1是 0否)
@property(nonatomic,strong) NSString * abarbeitung;
/// 整改前圖片 多个使用逗号隔开
@property(nonatomic,strong) NSString * beforeUrl;
/// 整改后圖片 多个使用逗号隔开
@property(nonatomic,strong) NSString * afterUrl;
/// 测评圖片
@property(nonatomic,strong) NSString * evaluationUrl;
/// 结果圖片
@property(nonatomic,strong) NSString * resultUrl;
/// 设计评估图片 逗号隔开
@property(nonatomic,strong) NSString * url;
/// 整改要求
@property(nonatomic,strong) NSString * askFor;
/// 评测意见
@property(nonatomic,strong) NSString * opinion;
/// 评测建议
@property(nonatomic,strong) NSString * suggest;
/// 整改要求/建议
@property(nonatomic,strong) NSArray<NSString*> * rectificationRequest;
/// 项目类别
@property(nonatomic,strong) NSString * classesNames;
/// 项目类别ID
@property(nonatomic,strong) NSString * classesId;
/// 项目二级类别ID
@property(nonatomic,strong) NSString * classesSecondLevelId;
/// 项目分项类别ID
@property(nonatomic,strong) NSString * subentryClassesId;
/// 项目二级分项类别ID
@property(nonatomic,strong) NSString * subentryClassesSecondLevelId;
@property(nonatomic,strong) NSString * groupId;
@property(nonatomic,strong) NSArray<NSString *> * classesSecondLevelList;
@property(nonatomic,strong) NSArray<ProblemModel *> * optionContent;
@property(nonatomic,strong) NSArray<ProblemModel *> * answer;

@end

NS_ASSUME_NONNULL_END
