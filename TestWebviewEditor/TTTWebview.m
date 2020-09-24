//
//  TTTWebview.m
//  TestWebviewEditor
//
//  Created by  joy on 2020/9/24.
//  Copyright © 2020  joy. All rights reserved.
//

#import "TTTWebview.h"
#import <objc/runtime.h>

@implementation TTTWebview

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupSystemKeyboardState:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupSystemKeyboardState:) name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

-(id)hookInputAccessoryView
{
    return nil;
}

- (UIKeyboardAppearance)hookKeyboardAppearance{
    return UIKeyboardAppearanceDark;
}

-(void)setupSystemKeyboardState:(NSNotification*)notify{
    UIView *first = (id)[self currentFirstResponder];
    if ([first isFirstResponder]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            {
                SEL oldSEL = @selector(inputAccessoryView);
                SEL newSEL = @selector(hookInputAccessoryView);
                Class aClass = first.class;
                Class bClass = [TTTWebview class];
                class_addMethod(aClass, newSEL, class_getMethodImplementation(bClass, newSEL),nil);
                Method oldMethod = class_getInstanceMethod(aClass, oldSEL);
                Method newMethod = class_getInstanceMethod(aClass, newSEL);
                method_exchangeImplementations(oldMethod, newMethod);
            }
            {
                SEL oldSEL = @selector(keyboardAppearance);
                SEL newSEL = @selector(hookKeyboardAppearance);
                Class aClass = first.class;
                Class bClass = [TTTWebview class];
                class_addMethod(aClass, oldSEL, class_getMethodImplementation(bClass, newSEL),nil);
            }
        });
    }
}

-(UIView *)currentFirstResponder
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    UIView *firstResponder;
    if ([self respondsToSelector:@selector(firstResponder)]) {
        firstResponder = [self performSelector:@selector(firstResponder)];
    }
    #pragma clang diagnostic pop
    return firstResponder;
}



@end
