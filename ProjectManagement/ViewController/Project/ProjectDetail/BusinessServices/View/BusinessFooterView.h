//
//  BusinessFooterView.h
//  ProjectManagement
//
//  Created by 王帅 on 2023/3/31.
//

#import <UIKit/UIKit.h>
#import "ProblemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusinessFooterView : UIView

@property(nonatomic,strong) NSArray<ProblemModel*> * dataArray;
@property(nonatomic,strong) NSArray<ProblemModel *> * answer;
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,copy) void(^tableViewContentHeightCompletion)(CGFloat contentHeight);
@property(nonatomic,strong) NSMutableArray * answerArray;
@property(nonatomic,assign) BOOL canEdit;

@end

NS_ASSUME_NONNULL_END
