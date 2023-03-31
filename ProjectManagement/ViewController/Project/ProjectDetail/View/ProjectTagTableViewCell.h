//
//  ProjectTagTableViewCell.h
//  ProjectManagement
//
//  Created by maiyou on 2022/12/1.
//

#import <UIKit/UIKit.h>
@import TagListView;

NS_ASSUME_NONNULL_BEGIN

@interface ProjectTagTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet TagListView * tagView;
@property(nonatomic,strong) NSArray * tags;
@property(nonatomic,copy)void(^tagListViewFrameChange)(void);

@end

NS_ASSUME_NONNULL_END
