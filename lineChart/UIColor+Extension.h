//
//  UIColor+Extension.h
//  keyikeyi
//
//  Created by keyi on 15/10/8.
//  Copyright © 2015年 tenghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/// 16进制颜色字符串转color
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)color;

@end
