//
//  STFooterTextField.m
//  StartupTools
//
//  Created by 24k on 16/1/13.
//  Copyright © 2016年 Loopeer. All rights reserved.
//

#import "STFooterTextField.h"

@implementation STFooterTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification 
                                                   object:nil];		
    }
    [self setUpViews];
    return self;
}

- (void)setUpViews{
    _FooterViewDefaultHeight = self.frame.size.height;
    self.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1];
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake( 0 , 0 , self.frame.size.width, _FooterViewDefaultHeight)];
    containerView.backgroundColor = [UIColor whiteColor];
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 8, self.frame.size.width-12, 40)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textView.layer.borderColor = [UIColor blackColor].CGColor;
    textView.layer.borderWidth = 0.5;
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 5;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    textView.returnKeyType = UIReturnKeySend; //just as an example
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"Type to see the textView grow!";
    textView.layer.cornerRadius = 5.0;
    // textView.animateHeightChange = NO; //turns off animation
    [self addSubview:containerView];
    
    [containerView addSubview:textView];
    
    self.backgroundColor = [UIColor whiteColor];
    containerView.layer.borderWidth = 0.5;
    containerView.layer.borderColor = [UIColor blackColor].CGColor;
    
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

//Code from Brett Schumann
- (void)keyboardWillShow:(NSNotification *)note {
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    NSLog(@"%f",containerView.frame.origin.y);
    containerFrame.origin.y = self.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    
    // commit animations
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)note {
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    CGRect viewFrame = self.frame;
    viewFrame.origin.y -= _FooterViewDefaultHeight ;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView {
    growingTextView.text = nil;
    return YES;
}

@end