//
//  ImagesTableViewCell.m
//  ProjectManagement
//
//  Created by maiyou on 2022/12/1.
//

#import "ImagesTableViewCell.h"

@interface ImagesTableViewCell ()<HXPhotoViewCellCustomProtocol>

@property(nonatomic,strong)HXPhotoView * photoView;
@property(nonatomic,assign)BOOL flag;

@end

@implementation ImagesTableViewCell
- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.manager = [HXPhotoManager managerWithType:HXPhotoManagerSelectedTypePhoto];
    self.manager.configuration.photoCanEdit = false;
    self.photoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(15, 47, SCREEN_WIDTH-30, 0) manager:self.manager];
    self.photoView.addImageName = @"addImage";
    self.photoView.lineCount = 3;
    self.photoView.spacing = 15;
    self.photoView.cellCustomProtocol = self;
    HXWeakSelf
    self.photoView.updateFrameBlock = ^(CGRect frame) {
        if (weakSelf.updateFrame){
            weakSelf.updateFrame(frame.size.height,weakSelf.row);
        }
    };
    self.photoView.changeCompleteBlock = ^(NSArray<HXPhotoModel *> * _Nonnull allList, NSArray<HXPhotoModel *> * _Nonnull photos, NSArray<HXPhotoModel *> * _Nonnull videos, BOOL isOriginal) {
        if (weakSelf.changeComplete){
            weakSelf.changeComplete(photos,weakSelf.row);
        }
    };
    [self.contentView addSubview:self.photoView];
//    UIImage * image = [self makeImageWithView:self.view withSize:CGSizeMake(103, 103)];
//    [APIRequest.shareInstance postUrl:Uploads params:@{} images:@[image] success:^(NSDictionary * _Nonnull result) {
//
//        } failure:^(NSString * _Nonnull errorMsg) {
//
//        }];
}

- (void)setImages:(NSString *)images{
    _images = images;
    if (!self.flag){
        self.flag = true;
        [self.manager clearSelectedList];
        NSArray * array = [images componentsSeparatedByString:@","];
        NSMutableArray * modelArray = [[NSMutableArray alloc] init];
        for (NSString * url in array) {
            HXCustomAssetModel * model = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:[Host stringByAppendingString:url]] selected:true];
            [modelArray addObject:model];
        }
        [self.manager addCustomAssetModel:modelArray];
        [self.photoView refreshView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
