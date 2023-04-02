//
//  ProblemModel.h
//  ProjectManagement
//
//  Created by 王帅 on 2023/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProblemModel : NSObject

@property(nonatomic,assign) CGFloat rowHeight;
@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,strong) NSIndexPath * indexPath;

/// 创建者
@property(nonatomic,strong) NSString * createBy;
/// 创建时间
@property(nonatomic,strong) NSString * createTime;
@property(nonatomic,strong) NSString * fatherId;
@property(nonatomic,strong) NSString * fatherOptionId;
///整改提示
@property(nonatomic,strong) NSString * hint;
///问题id
@property(nonatomic,strong) NSString * Id;
///选项内容
@property(nonatomic,strong) NSArray<ProblemModel*> * optionContent;
///依据ID
@property(nonatomic,strong) NSString * situationId;
///问题标题
@property(nonatomic,strong) NSString * subject;
///问题类型 1 选择 2 填空
@property(nonatomic,strong) NSString * type;



@property(nonatomic,strong) NSString * start;

@property(nonatomic,strong) NSString * cutOff;
///选项或输入描述
@property(nonatomic,strong) NSString * value;
///选项或输入描述ID
@property(nonatomic,strong) NSString * optionId;
///是否合格标识
@property(nonatomic,strong) NSString * standard;
@property(nonatomic,strong) NSArray<ProblemModel*> * childProblems;

@end

NS_ASSUME_NONNULL_END
