//
//  WCBarButtonItem.h
//  Lottery360
//
//  Created by wesley chen on 15/4/27.
//  Copyright (c) 2015年 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCBarButtonItem : UIBarButtonItem

// Override properties
@property (nonatomic, strong) UIColor *tintColor;

// Substitutes of UIBarItem's image and title
@property (nonatomic, strong) UIImage *barItemImage;
@property (nonatomic, copy) NSString *barItemTitle;
/*!
 *  The title transition animation allowed or not which is new-added in iOS 7+
 *
 *  Defautl is NO
 */
@property (nonatomic, assign) BOOL titleTransitionAnimated;

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

// 支持UITextAttributeFont和UITextAttributeTextColor
- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state;

@end
