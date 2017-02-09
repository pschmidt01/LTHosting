//
//  flyerViewController.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageEditorView.h"
#import "borderToolViewController.h"
#import "textToolViewController.h"
#import "horizontalViewPicker.h"
#import "flexibleIlluminatedButton.h"

@interface flyerViewController : UIViewController <CAAnimationDelegate, toolKitSuperController, UIGestureRecognizerDelegate, horizontalViewPickerDelegate, horizontalViewPickerDataSource, illuminatedButtonResponder, flexibleIlluminatedSource, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *topBarView;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)doneButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)backButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *imageContainerView;

@property (strong, nonatomic) IBOutlet UIView *bottomBarView;

@property (strong, nonatomic) IBOutlet UIView *toolView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *toolViewHeight;

@end
