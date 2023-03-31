//
//  MLDataSource.m
//  ProjectManagement
//
//  Created by maiyou on 2023/3/31.
//

#import "MLDataSource.h"
#import "MLAutoCompleteObject.h"

@implementation MLDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc] init];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textfieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
        self.search = [[BMKSuggestionSearch alloc] init];
        self.search.delegate = self;
        self.option = [[BMKSuggestionSearchOption alloc] init];
    }
    return self;
}

- (void)textfieldTextChange:(NSNotification *)notification{
    UITextField * tf = notification.object;
    self.option.cityname = tf.text;
    self.option.keyword  = tf.text;
    BOOL flag = [self.search suggestionSearch:self.option];
    if (flag) {
        NSLog(@"Sug检索发送成功");
    }  else  {
        NSLog(@"Sug检索发送失败");
    }
}

- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:( BMKSuggestionSearchResult*)result errorCode:(BMKSearchErrorCode)error{
    [self.dataArray removeAllObjects];
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        for (BMKSuggestionInfo * info in result.suggestionList) {
            if (info.address.length > 0){
                MLAutoCompleteObject * obj = [[MLAutoCompleteObject alloc] init];
                obj.countryName = info.address;
                [self.dataArray addObject:obj];
            }
        }
    }
    else {
        NSLog(@"检索失败");
    }
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler{
    handler(self.dataArray);
}

@end
