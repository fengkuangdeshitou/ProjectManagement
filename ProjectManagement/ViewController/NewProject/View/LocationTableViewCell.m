//
//  LocationTableViewCell.m
//  ProjectManagement
//
//  Created by maiyou on 2023/3/31.
//

#import "LocationTableViewCell.h"
#import "MLAutoCompleteCell.h"
#import "MLDataSource.h"

@interface LocationTableViewCell ()<UITextFieldDelegate,BMKGeoCodeSearchDelegate>

@property(nonatomic,strong) MLDataSource * autocompleteDataSource;


@end

@implementation LocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.autocompleteDataSource = [[MLDataSource alloc] init];
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.maximumNumberOfAutoCompleteRows = 5;
    self.textField.autoCompleteDataSource = self.autocompleteDataSource;
    [self.textField setAutoCompleteTableAppearsAsKeyboardAccessory:YES];
    [self.textField registerAutoCompleteCellClass:[MLAutoCompleteCell class]
                           forCellReuseIdentifier:@"CustomCellId"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
