//
//  ImagesTableViewCell.h
//  ProjectManagement
//
//  Created by maiyou on 2022/12/1.
//

#import <UIKit/UIKit.h>
@import HXPhotoPicker;

NS_ASSUME_NONNULL_BEGIN

@interface ImagesTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,strong) HXPhotoManager * manager;
@property(nonatomic,strong) NSString * images;
@property(nonatomic,assign) NSInteger row;
@property(nonatomic,copy)void(^updateFrame)(CGFloat,NSInteger);
@property(nonatomic,copy)void(^changeComplete)(NSArray *,NSInteger);
@property(nonatomic,assign) BOOL canEdit;

@end

NS_ASSUME_NONNULL_END
