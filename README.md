# UUActionSheet

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ChaneyLau/UUActionSheet/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/UUActionSheet.svg?style=flat)](https://cocoapods.org/pods/UUActionSheet)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/UUActionSheet.svg?style=flat)](https://cocoapods.org/pods/UUActionSheet)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;


自定义样式的`ActionSheet`，使用方式和`UIActionsheet`相同，代理也是仿照`UIActionSheet`写的。


## 使用 

1. `pod "UUActionSheet"`;
2. `pod install` / `pod update`;
3. `#import <UUActionSheet.h>`.

## 示例 


```objc
UUActionSheet *actionSheet = [[UUActionSheet alloc] initWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:@"退出登录"
                                                otherButtonTitles:@"换账号登录",nil];
[actionSheet showInView:self.view.window];
```

```objc
#pragma mark - UUActionSheetDelegate
- (void)actionSheet:(UUActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex: %ld",buttonIndex);
}
```

## 效果图

![UUActionSheet](Screenshot.png)
