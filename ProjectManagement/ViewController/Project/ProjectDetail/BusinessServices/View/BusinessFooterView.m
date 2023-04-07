//
//  BusinessFooterView.m
//  ProjectManagement
//
//  Created by 王帅 on 2023/3/31.
//

#import "BusinessFooterView.h"
#import "BusinessInputTableViewCell.h"

@interface BusinessFooterView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong) BusinessFooterView * footer;
@property(nonatomic,strong) NSIndexPath * indexPath;

@end

@implementation BusinessFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.answerArray = [[NSMutableArray alloc] init];
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = [UIColor colorWithHexString:@"#DEDEDE"];
        self.tableView.backgroundColor = UIColor.whiteColor;
        self.tableView.scrollEnabled = false;
        self.tableView.clipsToBounds = false;
        if (@available(iOS 15.0, *)) {
            self.tableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
            self.tableView.contentInsetAdjustmentBehavior = 2;
        }
        self.tableView.showsHorizontalScrollIndicator = false;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        [self addSubview:self.tableView];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.tableView registerNib:[UINib nibWithNibName:@"BusinessInputTableViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessInputTableViewCell"];
    }
    return self;
}

- (void)setDataArray:(NSArray<ProblemModel *> *)dataArray{
    _dataArray = dataArray;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.answer enumerateObjectsUsingBlock:^(ProblemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (int i=0; i<self.dataArray.count; i++) {
                ProblemModel * model = self.dataArray[i];
                NSArray * optionContent = model.optionContent;
                for (ProblemModel * option in optionContent) {
                    if ([obj.optionId isEqualToString:option.optionId]){
                        option.isSelected = true;
                    }
                }
            }
        }];
        [self.tableView reloadData];
        [self updateTableViewContentSize];
    });
}

- (void)setAnswer:(NSArray<ProblemModel *> *)answer{
    _answer = answer;
    if (self.answerArray.count > 0){
        return;
    }
    [answer enumerateObjectsUsingBlock:^(ProblemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        [params setValue:obj.optionId forKey:@"optionId"];
        [params setValue:obj.problemId forKey:@"problemId"];
        [params setValue:obj.result forKey:@"result"];
        [self.answerArray addObject:params];
    }];
    
}

- (void)updateTableViewContentSize{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView setNeedsLayout];
        [self.tableView layoutIfNeeded];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGFloat height = ceilf(self.tableView.contentSize.height);
            self.height = height;
            self.tableView.height = height;
        });
    });
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = ceilf(self.tableView.contentSize.height);
    if(self.tableViewContentHeightCompletion){
        self.tableViewContentHeightCompletion(height);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    BusinessInputTableViewCell * cell = (BusinessInputTableViewCell *)textField.superview.superview;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    ProblemModel * model = self.dataArray[indexPath.section];
    NSArray * filter = [self.answerArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"problemId == %@",model.Id]];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithDictionary:filter.count > 0 ? filter.firstObject : @{}];
    [params setValue:model.optionContent[indexPath.row].optionId forKey:@"optionId"];
    [params setValue:textField.text forKey:@"result"];
    NSLog(@"params=%@",params);
    
    [params setValue:model.Id forKey:@"problemId"];
    if (filter.count > 0){
        NSArray * filterAnswer = [self.answerArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"optionId == %@",model.optionContent[indexPath.row].optionId]];
        if (filterAnswer.count > 0){
            for (int i=0; i<self.answerArray.count; i++) {
                NSDictionary * dict = self.answerArray[i];
                if ([dict[@"optionId"] isEqualToString:model.optionContent[indexPath.row].optionId]){
                    [self.answerArray replaceObjectAtIndex:i withObject:params];
                }
            }
        }else{
            [self.answerArray addObject:params];
        }
    }else{
        [self.answerArray addObject:params];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return self.canEdit;
}

- (NSString *)getAnswerWithOptionId:(NSString *)optionId{
    NSString * value = @"";
    for (NSDictionary * dict in self.answerArray) {
        if ([dict[@"optionId"] isEqualToString:optionId]){
            value = [NSString stringWithFormat:@"%@",dict[@"result"]];
        }
    }
    return value;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProblemModel * model = self.dataArray[indexPath.section];
    if (model.type.intValue == 2){
        BusinessInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BusinessInputTableViewCell class]) forIndexPath:indexPath];
        cell.textfield.placeholder = model.optionContent[indexPath.row].value;
        cell.textfield.delegate = self;
        cell.textfield.text = [self getAnswerWithOptionId:model.optionContent[indexPath.row].optionId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        cell.textLabel.text = model.optionContent[indexPath.row].value;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if (model.optionContent[indexPath.row].isSelected){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.canEdit){
        return;
    }
    if (self.indexPath == indexPath){
        return;
    }
    self.indexPath = indexPath;
    ProblemModel * model = self.dataArray[indexPath.section];
    model.indexPath = indexPath;
    for (ProblemModel * obj in model.optionContent) {
        obj.isSelected = false;
    }
    ProblemModel * rowModel = model.optionContent[indexPath.row];
    rowModel.isSelected = !rowModel.isSelected;
    NSArray * filter = [self.answerArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"problemId == %@",model.Id]];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithDictionary:filter.count > 0 ? filter.firstObject : @{}];
    [params setValue:model.Id forKey:@"problemId"];
    [params setValue:rowModel.optionId forKey:@"optionId"];
    if (filter.count > 0){
        for (int i=0; i<self.answerArray.count; i++) {
            NSDictionary * dict = self.answerArray[i];
            if ([dict[@"problemId"] isEqualToString:model.Id]){
                [self.answerArray replaceObjectAtIndex:i withObject:params];
            }
        }
    }else{
        [self.answerArray addObject:params];
    }
    NSLog(@"answerArray=%@",self.answerArray);
    [self.tableView reloadData];
    [self updateTableViewContentSize];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray[section].optionContent.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    ProblemModel * model = self.dataArray[section];
    return [model.subject boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    ProblemModel * sectionModel = self.dataArray[section];
    if (sectionModel.indexPath){
        ProblemModel * model = sectionModel.optionContent[sectionModel.indexPath.row];
        if (model.isSelected && model.childProblems.count > 0){
            return model.rowHeight == 0 ? 100 : model.rowHeight;
        }else{
            return 0.01;
        }
    }else{
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ProblemModel * model = self.dataArray[section];
    CGFloat height = [model.subject boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-50, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+30;
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(15, height/2-4, 8, 8)];
    view.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_COLOR];
    view.layer.cornerRadius = 4;
    [header addSubview:view];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, SCREEN_WIDTH-50, height)];
    title.text = model.subject;
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor colorWithHexString:@"#333333"];
    [header addSubview:title];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    ProblemModel * sectionModel = self.dataArray[section];
    if (!sectionModel.indexPath){
        return nil;
    }
    ProblemModel * model = sectionModel.optionContent[sectionModel.indexPath.row];
    if (model.isSelected){
        BusinessFooterView * footer = [[BusinessFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        footer.clipsToBounds = true;
        footer.canEdit = self.canEdit;
        footer.dataArray = model.childProblems;
        footer.tableViewContentHeightCompletion = ^(CGFloat height){
            model.rowHeight = height;
            [UIView performWithoutAnimation:^{
                [tableView beginUpdates];
                [tableView endUpdates];
            }];
        };
        return footer;
    }else{
        return nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
