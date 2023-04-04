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
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = [UIColor colorWithHexString:@"#DEDEDE"];
        self.tableView.backgroundColor = UIColor.whiteColor;
        self.tableView.scrollEnabled = false;
        self.tableView.clipsToBounds = false;
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
    [self.tableView reloadData];
    [self updateTableViewContentSize];
}

- (void)setAnswer:(NSArray<ProblemModel *> *)answer{
    _answer = answer;
    self.answerArray = [[NSMutableArray alloc] init];
    [answer enumerateObjectsUsingBlock:^(ProblemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        [params setValue:obj.optionId forKey:@"optionId"];
        [params setValue:obj.problemId forKey:@"problemId"];
        [params setValue:obj.result forKey:@"result"];
        [self.answerArray addObject:params];
    }];
    NSLog(@"self.answerArray=%@",self.answerArray);
}

- (void)updateTableViewContentSize{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView setNeedsLayout];
        [self.tableView layoutIfNeeded];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.answer enumerateObjectsUsingBlock:^(ProblemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                for (int i=0; i<self.dataArray.count; i++) {
                    ProblemModel * model = self.dataArray[i];
                    NSArray * optionContent = model.optionContent;
                    for (ProblemModel * option in optionContent) {
                        if (model.type.intValue == 1){
                            option.isSelected = true;
                        }
                    }
                }
            }];
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
    [params setValue:model.optionContent[model.indexPath.row].optionId forKey:@"optionId"];
    [params setValue:textField.text forKey:@"result"];
    [params setValue:model.Id forKey:@"problemId"];
    for (ProblemModel * answerModel in self.answer) {
        if ([model.optionContent[model.indexPath.row].optionId isEqualToString:answerModel.optionId]){
            answerModel.result = textField.text;
        }
    }
    NSLog(@"params=%@",params);
}

- (NSString *)getAnswerWithOptionId:(NSString *)optionId{
    NSString * value = @"";
    for (ProblemModel * model in self.answer) {
        if ([model.optionId isEqualToString:optionId]){
            value = model.result;
        }
    }
    return value;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProblemModel * model = self.dataArray[indexPath.section];
    if (model.type.intValue == 2){
        BusinessInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BusinessInputTableViewCell class]) forIndexPath:indexPath];
        cell.textfield.placeholder = model.optionContent[model.indexPath.row].value;
        cell.textfield.delegate = self;
        cell.textfield.text = [self getAnswerWithOptionId:model.optionContent[model.indexPath.row].optionId];
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
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
    NSLog(@"params=%@",params);
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
