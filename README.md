# UUActionSheet

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/CheeryLau/UUActionSheet/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/UUActionSheet.svg?style=flat)](https://cocoapods.org/pods/UUActionSheet)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/UUActionSheet.svg?style=flat)](https://cocoapods.org/pods/UUActionSheet)&nbsp;

![UUActionSheet](UUActionSheet.gif)


仿微信/新浪微博的ActionSheet，使用方式和UIActionsheet相同。

## 安装[CocoaPods]

1. `pod "UUActionSheet"`;
2. `pod install` / `pod update`;
3. `#import <UUActionSheet.h>`.

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

## 后记

如有问题，欢迎给我[留言](https://github.com/CheeryLau/UUActionSheet/issues)，如果这个工具对你有些帮助，请给我一个star，谢谢。😘😘😘😘

💡 💡 💡 
欢迎访问我的[主页](https://github.com/CheeryLau)，希望以下工具也会对你有帮助。

1、自定义视频采集/图像选择及编辑/音频录制及播放等：[MediaUnitedKit](https://github.com/CheeryLau/MediaUnitedKit)

2、类似滴滴出行侧滑抽屉效果：[MMSideslipDrawer](https://github.com/CheeryLau/MMSideslipDrawer)

3、图片选择器基于AssetsLibrary框架：[MMImagePicker](https://github.com/CheeryLau/MMImagePicker)

4、图片选择器基于Photos框架：[MMPhotoPicker](https://github.com/CheeryLau/MMPhotoPicker)

5、webView支持顶部进度条和侧滑返回:[MMWebView](https://github.com/CheeryLau/MMWebView)

6、多功能滑动菜单控件：[MenuComponent](https://github.com/CheeryLau/MenuComponent)

7、仿微信朋友圈：[MomentKit](https://github.com/CheeryLau/MomentKit)

8、图片验证码：[MMCaptchaView](https://github.com/CheeryLau/MMCaptchaView)

9、源生二维码扫描与制作：[MMScanner](https://github.com/CheeryLau/MMScanner)

10、简化UIButton文字和图片对齐：[UUButton](https://github.com/CheeryLau/UUButton)

11、基础组合动画：[CAAnimationUtil](https://github.com/CheeryLau/CAAnimationUtil)

