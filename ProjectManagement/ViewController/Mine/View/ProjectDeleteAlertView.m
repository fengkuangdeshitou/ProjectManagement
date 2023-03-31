//
//  ProjectDeleteAlertVIew.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/12/2.
//

#import "ProjectDeleteAlertView.h"

@interface ProjectDeleteAlertView ()

@property(nonatomic,copy)void(^completion)(void);

@end

@implementation ProjectDeleteAlertView

+ (void)showDeleteAlertViewWithBlock:(void (^)(void))completion{
    ProjectDeleteAlertView * alertView = [NSBundle.mainBundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    alertView.frame = UIScreen.mainScreen.bounds;
    alertView.alpha = 0;
    alertView.completion = completion;
    [UIApplication.sharedApplication.keyWindow addSubview:alertView];
    [alertView show];
}

- (void)show{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
}

- (IBAction)deleteAction:(id)sender{
    if (self.completion){
        self.completion();
    }
    [self dismiss];
}

- (IBAction)dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
