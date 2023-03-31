//
//  ProjectContainerView.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/11/30.
//

#import "ProjectContainerView.h"
@import SGPagingView;
#import "ProjectListView.h"

@interface ProjectContainerView ()<SGPagingTitleViewDelegate>

@property(nonatomic,strong) SGPagingTitleView * titleView;
@property(nonatomic,strong) UIScrollView * scrollView;
@property(nonatomic,strong) NSArray<NSString *> * titleArray;

@end

@implementation ProjectContainerView

- (UIScrollView *)scrollView{
    if (!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.bounces = false;
        _scrollView.pagingEnabled = true;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.scrollEnabled = false;
    }
    return _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        self.titleArray = @[@"全部",@"评测中",@"审核中",@"已通过",@"未通过"];
        SGPagingTitleViewConfigure * config = [[SGPagingTitleViewConfigure alloc] init];
        config.color = [UIColor colorWithHexString:@"#555C6D"];
        config.selectedColor = [UIColor colorWithHexString:COLOR_MAIN_COLOR];
        config.font = [UIFont systemFontOfSize:14];
        config.selectedFont = config.font;
        config.indicatorColor = config.selectedColor;
        config.indicatorToBottomDistance = 20;
        config.indicatorFixedWidth = 10;
        config.indicatorType = IndicatorTypeFixed;
        config.showBottomSeparator = false;
        self.titleView = [[SGPagingTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64) titles:self.titleArray configure:config];
        self.titleView.delegate = self;
        [self addSubview:self.titleView];
        
    }
    return self;
}

- (void)setType:(NSString *)type{
    _type = type;
    for (int i=0; i<self.titleArray.count; i++) {
        ProjectListView * list = [[ProjectListView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, self.titleView.height,SCREEN_WIDTH, self.height-self.titleView.height)];
        list.type = type;
        list.status = [NSString stringWithFormat:@"%d",i-1];
        [self.scrollView addSubview:list];
    }
    self.scrollView.contentSize = CGSizeMake(self.titleArray.count*SCREEN_WIDTH, 0);
}

- (void)setIsPrivate:(BOOL)isPrivate{
    _isPrivate = isPrivate;
    for (ProjectListView * view in self.scrollView.subviews) {
        view.isPrivate = self.isPrivate;
    }
}

- (void)pagingTitleViewWithTitleView:(SGPagingTitleView *)titleView index:(NSInteger)index{
    [self.scrollView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:true];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
