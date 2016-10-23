//
//  WCBarButtonItem.m
//  Lottery360
//
//  Created by wesley chen on 15/4/27.
//  Copyright (c) 2015年 wesley chen. All rights reserved.
//

#import "WCBarButtonItem.h"
#import <objc/runtime.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define WC_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define WC_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#ifndef IOS7_OR_LATER
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

#ifndef UICOLOR_RGB
#define UICOLOR_RGB(color) [UIColor colorWithRed : (((color) >> 16) & 0xFF) / 255.0 green : (((color) >> 8) & 0xFF) / 255.0 blue : ((color) & 0xFF) / 255.0 alpha : 1.0]
#endif

@interface UIImage (Addition)
- (UIImage *)imageWithAlpha:(CGFloat)alpha;
@end

@implementation UIImage (Addition)

- (UIImage *)imageWithAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

@interface WCBarButtonItem ()
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) id receiver;
@property (nonatomic, strong) UIButton *barButton;
@end

@implementation WCBarButtonItem

@synthesize tintColor = _tintColor;

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
    if (IOS7_OR_LATER) {
        self = [super initWithImage:image style:style target:target action:action];
    }
    else {
        _receiver = target;
        _selector = action;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        button.exclusiveTouch = YES;
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:[image imageWithAlpha:0.5] forState:UIControlStateHighlighted];
//        button.backgroundColor = [UIColor yellowColor];
        self = [super initWithCustomView:button];
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _barButton = button;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
    if (IOS7_OR_LATER) {
        self = [super initWithTitle:title style:style target:target action:action];
    }
    else {
        _receiver = target;
        _selector = action;
        
        UIFont *font = (style == UIBarButtonItemStyleDone ? [UIFont boldSystemFontOfSize:17] : [UIFont systemFontOfSize:17]);
        CGSize textSize = WC_TEXTSIZE(title, font);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, textSize.width, 44);
//        button.backgroundColor = [UIColor yellowColor];
        button.exclusiveTouch = YES;
        button.titleLabel.font = font; // http://stackoverflow.com/questions/18946317/ios-7-what-is-uibarbuttonitems-default-font
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:UICOLOR_RGB(0x0076FF) forState:UIControlStateNormal];
        [button setTitleColor:UICOLOR_RGB(0x0076FF) forState:UIControlStateSelected];
        [button setTitleColor:[UICOLOR_RGB(0x0076FF) colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
        [button setTitleColor:[UICOLOR_RGB(0x8E8E93) colorWithAlphaComponent:0.8] forState:UIControlStateDisabled];
        
        self = [super initWithCustomView:button];
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _barButton = button;
    }
    
    return self;
}

- (void)buttonClicked:(UIButton *)sender {
    IMP imp = [_receiver methodForSelector:_selector];
    void (*func)(id, SEL, UIBarButtonItem *) = (void *)imp;
    func(_receiver, _selector, self);
}

#pragma mark - Setters

- (void)setTintColor:(UIColor *)tintColor {
    if (IOS7_OR_LATER) {
        [super setTintColor:tintColor];
    }
    else {
        [_barButton setTitleColor:tintColor forState:UIControlStateNormal];
        [_barButton setTitleColor:tintColor forState:UIControlStateSelected];
        [_barButton setTitleColor:[tintColor colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
        [_barButton setTitleColor:[UICOLOR_RGB(0x8E8E93) colorWithAlphaComponent:0.8] forState:UIControlStateDisabled];
    }
}

- (void)setBarItemImage:(UIImage *)barItemImage {
    if (IOS7_OR_LATER) {
        self.image = barItemImage;
    }
    else {
        [_barButton setImage:barItemImage forState:UIControlStateNormal];
        _barItemImage = barItemImage;
    }
}

- (void)setBarItemTitle:(NSString *)barItemTitle {
    if (IOS7_OR_LATER) {
        if (!_titleTransitionAnimated) {
            [UIView setAnimationsEnabled:NO];
        }
        self.title = barItemTitle;
        if (!_titleTransitionAnimated) {
            [UIView setAnimationsEnabled:YES];
        }
    }
    else {
        [_barButton setTitle:barItemTitle forState:UIControlStateNormal];
    }
}

- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state {
    if (IOS7_OR_LATER) {
        [super setTitleTextAttributes:attributes forState:state];
    }
    else {
        UIFont *font = attributes[UITextAttributeFont];
        UIColor *textColor = attributes[UITextAttributeTextColor];
        
        if (textColor) {
            [_barButton setTitleColor:textColor forState:UIControlStateNormal];
            [_barButton setTitleColor:[textColor colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
        }
        
        if (font) {
            _barButton.titleLabel.font = font;
        }
    }
}

@end
