//
//  UITextView+Placeholder.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/12/2.
//

#import "UITextView+Placeholder.h"

@implementation UITextView (Placeholder)

- (void)setPlaceholder:(NSString *)placeholder{
    UILabel * placeHolderStr = [self valueForKey:@"_placeholderLabel"];
    if (!placeHolderStr){
        placeHolderStr = [[UILabel alloc] init];
    }
    placeHolderStr.text = placeholder;
    placeHolderStr.numberOfLines = 0;
    placeHolderStr.textColor = [UIColor colorWithHexString:@"#9EA6BB"];
    placeHolderStr.font = [UIFont systemFontOfSize:14];
    [placeHolderStr sizeToFit];
    [self addSubview:placeHolderStr];
    placeHolderStr.font = self.font;
    [self setValue:placeHolderStr forKey:@"_placeholderLabel"];
}

@end
