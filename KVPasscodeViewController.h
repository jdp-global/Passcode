//
//  KVPasscodeViewController.h
//  Koolistov
//
//  Created by Johan Kool on 3/17/11.
//  Copyright 2011 Koolistov. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are 
//  permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this list of 
//    conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright notice, this list 
//    of conditions and the following disclaimer in the documentation and/or other materials 
//    provided with the distribution.
//  * Neither the name of KOOLISTOV nor the names of its contributors may be used to 
//    endorse or promote products derived from this software without specific prior written 
//    permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
//  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
//  THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT 
//  OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import <UIKit/UIKit.h>

@class KVPasscodeViewController;

@protocol KVPasscodeViewControllerDelegate <NSObject>

- (void)passcodeController:(KVPasscodeViewController *)controller passcodeEntered:(NSString *)passCode;

@end

typedef enum {
    KVPasscodeAnimationStyleNone,
    KVPasscodeAnimationStyleInvalid,
    KVPasscodeAnimationStyleConfirm
} KVPasscodeAnimationStyle;

@interface KVPasscodeViewController : UIViewController <UITextFieldDelegate> {
    id <KVPasscodeViewControllerDelegate> delegate;
    
    UIView *animationView;
    
    UILabel *titleLabel;
    UILabel *instructionLabel;
    
    UITextField *bulletField0;
    UITextField *bulletField1;
    UITextField *bulletField2;
    UITextField *bulletField3;
 
    UITextField *fakeField;
}

@property (nonatomic, strong) id <KVPasscodeViewControllerDelegate> delegate; 

@property (nonatomic, strong) UIView *animationView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *instructionLabel;

@property (nonatomic, strong) UITextField *bulletField0;
@property (nonatomic, strong) UITextField *bulletField1;
@property (nonatomic, strong) UITextField *bulletField2;
@property (nonatomic, strong) UITextField *bulletField3;

- (void)resetWithAnimation:(KVPasscodeAnimationStyle)animationStyle;
- (void)setPasscodeBackgroundColor:(UIColor *)backgroundColor;
- (void)setInstructionText:(NSString *)instructionText;
- (void)setErrorText:(NSString *)errorText;
- (void)setNavigationText:(NSString *)titleText;
- (void)setTitleText:(NSString *)titleText;

@end
