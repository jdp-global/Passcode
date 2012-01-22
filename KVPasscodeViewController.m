//
//  KVPasscodeViewController.m
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

#import "KVPasscodeViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioServices.h>

@interface KVPasscodeViewController () {
    UIColor *defaultTextColor;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
- (void)internalResetWithAnimation:(NSNumber *)animationStyleNumber;
- (void)notifyDelegate:(NSString *)passcode;

@end

@implementation KVPasscodeViewController

@synthesize delegate;

@synthesize animationView;

@synthesize titleLabel;
@synthesize instructionLabel;

@synthesize bulletField0;
@synthesize bulletField1;
@synthesize bulletField2;
@synthesize bulletField3;

- (void)dealloc {
    animationView = nil;
    
    titleLabel = nil;
    instructionLabel = nil;
    
    bulletField0 = nil;
    bulletField1 = nil;
    bulletField2 = nil;
    bulletField3 = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaultTextColor = [UIColor colorWithRed:0.32f green:0.41f blue:0.47f alpha:1.0f];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // Add animation view
    animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 204)];
    [self.view addSubview:animationView];
    
    // Add Enter passcode label
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 31)];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    titleLabel.textColor = defaultTextColor;
    titleLabel.shadowColor = [UIColor whiteColor];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Enter your passcode:";
    [animationView addSubview:titleLabel];
    
    // Add first passcode field
    bulletField0 = [[UITextField alloc] initWithFrame:CGRectMake(30, 71, 56, 56)];
    bulletField0.borderStyle = UITextBorderStyleBezel;
    bulletField0.font = [UIFont fontWithName:@"Helvetica" size:32.0f];
    bulletField0.textAlignment = UITextAlignmentCenter;
    bulletField0.secureTextEntry = YES;
    bulletField0.keyboardType = UIKeyboardTypeNumberPad;
    bulletField0.backgroundColor = [UIColor whiteColor];
    bulletField0.enabled = NO;
    [animationView addSubview:bulletField0];
    
    // Add second passcode field
    bulletField1 = [[UITextField alloc] initWithFrame:CGRectMake(98, 71, 56, 56)];
    bulletField1.borderStyle = UITextBorderStyleBezel;
    bulletField1.font = [UIFont fontWithName:@"Helvetica" size:32.0f];
    bulletField1.textAlignment = UITextAlignmentCenter;
    bulletField1.secureTextEntry = YES;
    bulletField1.keyboardType = UIKeyboardTypeNumberPad;
    bulletField1.backgroundColor = [UIColor whiteColor];
    bulletField1.enabled = NO;
    [animationView addSubview:bulletField1];
    
    // Add third passcode field
    bulletField2 = [[UITextField alloc] initWithFrame:CGRectMake(161, 71, 56, 56)];
    bulletField2.borderStyle = UITextBorderStyleBezel;
    bulletField2.font = [UIFont fontWithName:@"Helvetica" size:32.0f];
    bulletField2.textAlignment = UITextAlignmentCenter;
    bulletField2.secureTextEntry = YES;
    bulletField2.keyboardType = UIKeyboardTypeNumberPad;
    bulletField2.backgroundColor = [UIColor whiteColor];
    bulletField2.enabled = NO;
    [animationView addSubview:bulletField2];
    
    // Add fourth passcode field
    bulletField3 = [[UITextField alloc] initWithFrame:CGRectMake(234, 71, 56, 56)];
    bulletField3.borderStyle = UITextBorderStyleBezel;
    bulletField3.font = [UIFont fontWithName:@"Helvetica" size:32.0f];
    bulletField3.textAlignment = UITextAlignmentCenter;
    bulletField3.secureTextEntry = YES;
    bulletField3.keyboardType = UIKeyboardTypeNumberPad;
    bulletField3.backgroundColor = [UIColor whiteColor];
    bulletField3.enabled = NO;
    [animationView addSubview:bulletField3];
    
    // Add instructions label
    instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 143, 300, 41)];
    instructionLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
    instructionLabel.textAlignment = UITextAlignmentCenter;
    instructionLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    instructionLabel.textColor = defaultTextColor;
    instructionLabel.shadowColor = [UIColor whiteColor];
    instructionLabel.shadowOffset = CGSizeMake(0, 1);
    instructionLabel.backgroundColor = [UIColor clearColor];
    [animationView addSubview:instructionLabel];
    
    // Add fake field
    fakeField = [[UITextField alloc] initWithFrame:CGRectZero];
    fakeField.delegate = self;
    fakeField.keyboardType = UIKeyboardTypeNumberPad;
    fakeField.secureTextEntry = YES;
    fakeField.text = @"";
    [fakeField becomeFirstResponder];
    [self.view addSubview:fakeField];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"Passcode", @"");
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    fakeField = nil;
    
    self.animationView = nil;
    
    self.titleLabel = nil;
    self.instructionLabel = nil;
    
    self.bulletField0 = nil;
    self.bulletField1 = nil;
    self.bulletField2 = nil;
    self.bulletField3 = nil;
}

- (void)setPasscodeBackgroundColor:(UIColor *)backgroundColor {
    self.view.backgroundColor = backgroundColor;
}

- (void)setInstructionText:(NSString *)instructionText {
    self.instructionLabel.text = instructionText;
    self.instructionLabel.textColor = defaultTextColor;
}

- (void)setErrorText:(NSString *)errorText {
    self.instructionLabel.text = errorText;
    self.instructionLabel.textColor = [UIColor redColor];
}

- (void)setNavigationText:(NSString *)titleText {
    self.navigationItem.title = titleText;
}

- (void)setTitleText:(NSString *)titleText {
    self.navigationItem.title = titleText;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)internalResetWithAnimation:(NSNumber *)animationStyleNumber {    
    KVPasscodeAnimationStyle animationStyle = [animationStyleNumber intValue];
    switch (animationStyle) {
        case KVPasscodeAnimationStyleInvalid:
        {
            
            // Vibrate to indicate error
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            [animation setDelegate:self]; 
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
            [animation setDuration:0.025];
            [animation setRepeatCount:8];
            [animation setAutoreverses:YES];
            [animation setFromValue:[NSValue valueWithCGPoint:
                                     CGPointMake([animationView center].x - 14.0f, [animationView center].y)]];
            [animation setToValue:[NSValue valueWithCGPoint:
                                   CGPointMake([animationView center].x + 14.0f, [animationView center].y)]];
            [[animationView layer] addAnimation:animation forKey:@"position"];
            break;
        }
        case KVPasscodeAnimationStyleConfirm:
        {
            
            // This will cause the 'new' fields to appear without bullets already in them
            self.bulletField0.text = nil;
            self.bulletField1.text = nil;
            self.bulletField2.text = nil;
            self.bulletField3.text = nil;
            
            CATransition *transition = [CATransition animation]; 
            [transition setDelegate:self]; 
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
            [transition setType:kCATransitionPush]; 
            [transition setSubtype:kCATransitionFromRight]; 
            [transition setDuration:0.5f];
            [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]]; 
            [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1]; 
            [[animationView layer] addAnimation:transition forKey:@"swipe"];
            break;
        }
        case KVPasscodeAnimationStyleNone:
        default:
            self.bulletField0.text = nil;
            self.bulletField1.text = nil;
            self.bulletField2.text = nil;
            self.bulletField3.text = nil;
            
            fakeField.text = @"";
            break;
    }
}

- (void)resetWithAnimation:(KVPasscodeAnimationStyle)animationStyle {   
    // Do the animation a little later (for better animation) as it's likely this method is called in our delegate method
    [self performSelector:@selector(internalResetWithAnimation:) withObject:[NSNumber numberWithInt:animationStyle] afterDelay:0];
}

- (void)notifyDelegate:(NSString *)passcode {
    [self.delegate passcodeController:self passcodeEntered:passcode];
    fakeField.text = @"";
}

#pragma mark - CAAnimationDelegate 
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.bulletField0.text = nil;
    self.bulletField1.text = nil;
    self.bulletField2.text = nil;
    self.bulletField3.text = nil;
    
    fakeField.text = @"";
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *passcode = [textField text];
    passcode = [passcode stringByReplacingCharactersInRange:range withString:string];

    switch ([passcode length]) {
        case 0:
            self.bulletField0.text = nil;
            self.bulletField1.text = nil;
            self.bulletField2.text = nil;
            self.bulletField3.text = nil;
            break;
        case 1:
            self.bulletField0.text = @"*";
            self.bulletField1.text = nil;
            self.bulletField2.text = nil;
            self.bulletField3.text = nil;
            break;
        case 2:
            self.bulletField0.text = @"*";
            self.bulletField1.text = @"*";
            self.bulletField2.text = nil;
            self.bulletField3.text = nil;
            break;
        case 3:
            self.bulletField0.text = @"*";
            self.bulletField1.text = @"*";
            self.bulletField2.text = @"*";
            self.bulletField3.text = nil;
            break;
        case 4:
            self.bulletField0.text = @"*";
            self.bulletField1.text = @"*";
            self.bulletField2.text = @"*";
            self.bulletField3.text = @"*";
        
            // Notify delegate a little later so we have a chance to show the 4th bullet
            [self performSelector:@selector(notifyDelegate:) withObject:passcode afterDelay:0];
            
            return NO;
            
            break;
        default:
            break;
    }

    return YES;
}

@end
