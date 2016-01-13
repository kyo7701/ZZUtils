//
//  STFooterTextField.h
//  StartupTools
//
//  Created by 24k on 16/1/13.
//  Copyright © 2016年 Loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
@interface STFooterTextField : UIView<HPGrowingTextViewDelegate>{
    UIView *containerView;
    HPGrowingTextView *textView;
}

@property (assign ,nonatomic)CGFloat FooterViewDefaultHeight;

@end
