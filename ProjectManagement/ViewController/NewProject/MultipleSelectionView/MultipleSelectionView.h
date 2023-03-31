//
//  MultipleSelectionView.h
//  ProjectManagement
//
//  Created by 王帅 on 2023/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultipleSelectionView : UIView

@property(nonatomic,strong) NSArray * dataArray;
@property(nonatomic,strong,readonly) NSMutableArray * selectedArray;

@end

NS_ASSUME_NONNULL_END
