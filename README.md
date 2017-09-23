# UUActionSheet

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/dexianyinjiu/UUActionSheet/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/UUActionSheet.svg?style=flat)](https://cocoapods.org/pods/UUActionSheet)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/UUActionSheet.svg?style=flat)](https://cocoapods.org/pods/UUActionSheet)&nbsp;

仿微信/新浪微博的ActionSheet，使用方式和UIActionsheet相同，支持屏幕旋转。

![UUActionSheet](UUActionSheet.gif)

## 安装[CocoaPods]

1. `pod 'UUActionSheet', '~> 1.3'`;
2. `pod install` / `pod update`;
3. `#import <UUActionSheet/UUActionSheet.h>`.

For example：

```objc
UUActionSheet *actionSheet = [[UUActionSheet alloc] initWithTitle:@"After the exit will not delete any historical data, the next login can still use this account."
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:@"Logout"
                                                otherButtonTitles:@"Okay",nil];
[actionSheet showInView:self.view.window];
```

```objc
#pragma mark - UUActionSheetDelegate
- (void)actionSheet:(UUActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex:%ld",buttonIndex);
}
```

## END

有问题可以联系我【QQ:1539901764 要备注来源哦】，如果这个工具对你有些帮助，请给我一个star、watch。O(∩_∩)O谢谢
