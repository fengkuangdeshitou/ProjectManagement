//
//  BaseViewController+BarButtonItem.m
//  ProjectManagement
//
//  Created by 王帅 on 2022/12/2.
//

#import "BaseViewController+BarButtonItem.h"
#import <objc/runtime.h>

@implementation BaseViewController (BarButtonItem)

+ (void)load {
    swizzleMethod([self class], @selector(viewDidAppear:), @selector(ac_viewDidAppear));
}

- ( void)ac_viewDidAppear{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style: UIBarButtonItemStylePlain target:self action:nil];
    [self ac_viewDidAppear];
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector){
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod( class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod( class, swizzledSelector);
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    // the method doesn’t exist and we just added one
    if(didAddMethod) {
        class_replaceMethod( class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
