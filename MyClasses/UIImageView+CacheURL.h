//
//  UIImageView+CacheURL.h
//  Vodka
//
//  Created by xiaoming on 15/11/5.
//  Copyright © 2015年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//    NSFileManager *fileManager = [NSFileManager defaultManager];      千万不用忘了初始化。


#import <UIKit/UIKit.h>

@interface UIImageView (CacheURL)
///传人urlString 和默认图。获取网络图片。----不放到缓存里面
-(void)setURLString:(NSString *)urlString placeholderImage:(UIImage *)image;
///传人urlString 和默认图。获取网络图片。----不放到缓存里面   relativePath 传 nil @"" 跟上面的方法一样，都是 tempCache 路径下。
-(void)setURLString:(NSString *)urlString placeholderImage:(UIImage *)defaultImage relativePath:(NSString *)relativePath;
///清空本地缓存。----下面的方法，是可以放在你任何想清除缓存的地方的。
-(void)cleanDisk;
@end
