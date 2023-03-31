//
//  MultipleSelectionView.m
//  ProjectManagement
//
//  Created by 王帅 on 2023/2/28.
//

#import "MultipleSelectionView.h"
#import "ProjectTagTableViewCell.h"
#import "ProjectModel.h"

@interface MultipleSelectionView ()<TagListViewDelegate,UITableViewDelegate>

@property(nonatomic,weak)IBOutlet UITableView * tableView;

@end

@implementation MultipleSelectionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [NSBundle.mainBundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        _selectedArray = [[NSMutableArray alloc] init];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProjectTagTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProjectTagTableViewCell class])];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectTagTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectTagTableViewCell class]) forIndexPath:indexPath];
    cell.tagView.delegate = self;
    cell.tags = self.dataArray;
    return cell;
}

- (void)tagPressed:(NSString *)title tagView:(TagView *)tagView sender:(TagListView *)sender{
    tagView.selected = !tagView.selected;
    ProjectModel * model = [self getModelForTitle:title array:self.dataArray];
    if (tagView.selected){
        [_selectedArray addObject:model];
    }else{
        [_selectedArray removeObject:model];
    }
}

- (ProjectModel *)getModelForTitle:(NSString *)title array:(NSArray *)array{
    for (ProjectModel * model in array) {
        if ([model.name isEqualToString:title]){
            return model;
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return UIView.new;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
