//
//  UIImageView+CacheURL.m
//  Vodka
//
//  Created by xiaoming on 15/11/5.
//  Copyright © 2015年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//

#import "UIImageView+CacheURL.h"

@implementation UIImageView (CacheURL)

#pragma mark - 传人urlString 和默认图。获取网络图片。----不放到缓存里面
-(void)setURLString:(NSString *)urlString placeholderImage:(UIImage *)image{
    [self setURLString:urlString placeholderImage:image relativePath:nil];
}

#pragma mark - 传人urlString 和默认图。获取网络图片。----不放到缓存里面 relativePath 传 nil @"" 跟上面的方法一样，都是 tempCache 路径下。
-(void)setURLString:(NSString *)urlString placeholderImage:(UIImage *)defaultImage relativePath:(NSString *)relativePath{
    if (relativePath == nil || [relativePath isEqualToString:@""]) {
        relativePath = @"tempCache";
    }
    self.image = defaultImage;
    if ([self isEmptyString:urlString]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *resultImage = nil;///从网上获取成功后的image
        //从缓存中读取。
        resultImage = [UIImage imageWithContentsOfFile:[self absolutePath:relativePath urlString:urlString systemPath:nil]];
        if (resultImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = resultImage;
            });
            return;
        }
        ///没有缓存的情况下。
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *resultData = [NSData dataWithContentsOfURL:url];
        resultImage = [UIImage imageWithData:resultData];
        if (resultImage) {
            ///缓存data数据。
            NSString *aFileName = [self absolutePath:relativePath urlString:nil systemPath:nil];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:aFileName]) {
                ////withIntermediateDirectories  YES 表示可以创建多级目录。
                if (![fileManager createDirectoryAtPath:aFileName withIntermediateDirectories:YES attributes:nil error:nil]) {
                    NSLog(@"createFile error occurred");
                }
                
            }
            NSString *resultFileString = [self absolutePath:relativePath urlString:urlString systemPath:nil];
            if ([resultData writeToFile:resultFileString atomically:YES]) {
                NSLog(@"保存成功");
            }else{
                NSLog(@"保存失败");
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = resultImage;
            });
        }
    });
}

#pragma mark - 判断是否是空字符串
- (BOOL)isEmptyString:(NSString *)string{
    if(string == nil){
        return YES;
    }
    if([string isKindOfClass:[[NSNull null] class]]){
        return YES;
    }
    if([string isEqualToString:@""]){
        return YES;
    }
    if([string isEqualToString:@"<null>"])
        return YES;
    if([string isEqualToString:@"(null)"])
        return YES;
    return NO;
}

#pragma mark - 从本地文件读取数据。
-(NSString *)absolutePath:(NSString*)relativePath urlString:(NSString *)urlString systemPath:(NSString *)systemPath{
    if (relativePath == nil || [relativePath isEqualToString:@""]) {
        relativePath = @"tempCache";
    }
    NSString *path0 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path1 = [path0 stringByAppendingPathComponent:relativePath];
    if(urlString && ![urlString isEqualToString:@""]){///创建路径的时候不需要url，读，取的时候，需要url。
        NSString *path2 = [path1 stringByAppendingPathComponent:[urlString stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
        return path2;
    }
    return path1;
}

#pragma mark - 清除本地缓存
-(void)cleanDisk{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path0 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *defaultPath = [NSString stringWithFormat:@"%@/tempCache",path0];
    NSLog(@"defaultPaht ==== %@",defaultPath);
    [self folderSizeAtPath:defaultPath];
    if ([fileManager removeItemAtPath:defaultPath error:nil]) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
    
    [self folderSizeAtPath:defaultPath];
}

#pragma mark - 通常用于删除缓存的时，计算缓存大小
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
#pragma mark - 遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    if (!folderPath || [folderPath isEqualToString:@""]) {
        NSString *path0 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        folderPath = [NSString stringWithFormat:@"%@/tempCache",path0];
    }
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
    {
        NSLog(@"大小为0");
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    NSLog(@"文件大小====%f M ",folderSize/(1024.0*1024.0));
    return folderSize/(1024.0*1024.0);
}
@end
