//
//  JMFormViewController.m
//  JMFormDescription
//
//  Created by jerome morissard on 23/09/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMFormViewController.h"
#import "JMFormViewController+formDescription.h"

#import "JMFormListSelectionTableViewController.h"

#import "JMFormScrollView.h"
#import "JMFormViews.h"
#import "JMFormModel.h"

@interface JMFormViewController ()
@property (weak, nonatomic) IBOutlet JMFormScrollView *formScrollView;
@property (strong, nonatomic) JMFormModel *formModel;
@property (strong, nonatomic) JMFormDescription *formDescription;

@end

@implementation JMFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Complete your model
    self.formModel = [JMFormModel new];
    self.formModel.coloChoices = @[@"blue",@"red", @"grey"];
    self.formModel.listPlaceholder = @"choose a color";
    
    //generate Layout description
    self.formDescription = [self generateFormDescriptionUsingModel:self.formModel];
    [self.formScrollView reloadScrollViewWithFormDescription:self.formDescription.formViewDescriptions];
}

#pragma mark - JMFormDelegate

- (void)textUpdatedFromCell:(JMTextfieldFormView *)formView textfield:(UITextField *)textfield toText:(NSString *)text
{
    NSLog(@"%@ change text to %@",formView,text);
    NSInteger index = [self.formScrollView indexForFormView:formView];
    NSString *modelKey = [self.formDescription modelKeyForDescriptionAtIndex:index];
    [self.formModel setValue:text forKey:modelKey];
}

- (void)textUpdatedFromCell:(JMTextViewFormView *)formView textView:(UITextView *)textView toText:(NSString *)text
{
    NSLog(@"%@ change text to %@",formView,text);
    NSInteger index = [self.formScrollView indexForFormView:formView];
    NSString *modelKey = [self.formDescription modelKeyForDescriptionAtIndex:index];
    [self.formModel setValue:text forKey:modelKey];
}

- (void)switchChangedFromCell:(JMSwitchFormView *)formView toValue:(BOOL)value
{
    NSLog(@"%@ change switch to %d",formView,value);
    [self.view endEditing:NO];
    NSInteger index = [self.formScrollView indexForFormView:formView];
    NSString *modelKey = [self.formDescription modelKeyForDescriptionAtIndex:index];
    [self.formModel setValue:@(value) forKey:modelKey];
    
    self.formDescription = [self generateFormDescriptionUsingModel:self.formModel];
    [self.formScrollView reloadScrollViewWithFormDescription:self.formDescription.formViewDescriptions];
}

- (void)buttonPressedFromCell:(JMButtonFormView *)formView withTitleValue:(NSString *)value
{
    NSLog(@"%@ button Pressed to %@",formView,value);
    [self.view endEditing:NO];
}

- (void)listPressedFromCell:(JMListFormView *)formView withSelectedValue:(NSString *)value
{
    NSLog(@"%@ listPressedFromCell Pressed to %@",formView,value);
    NSInteger index = [self.formScrollView indexForFormView:formView];
    [self.view endEditing:NO];

    JMFormListSelectionTableViewController *listVc = [JMFormListSelectionTableViewController new];
    JMListFormViewDescription *desc = [self.formDescription.formViewDescriptions objectAtIndex:index];
    listVc.values = desc.choices;
    listVc.formDelegate = self;
    listVc.modelKey = desc.modelKey;
    listVc.title = desc.title;
    UINavigationController *nacV = [[UINavigationController alloc] initWithRootViewController:listVc];
    [self presentViewController:nacV animated:YES completion:NULL];
}

- (void)selectedChoice:(NSString *)choice forModelKey:(NSString *)modelKey
{
    [self.view endEditing:NO];
    [self.formModel setValue:choice forKeyPath:modelKey];
    [self dismissViewControllerAnimated:YES completion:^{
        self.formDescription = [self generateFormDescriptionUsingModel:self.formModel];
        [self.formScrollView reloadScrollViewWithFormDescription:self.formDescription.formViewDescriptions];
    }];
}

- (void)scrollToFormView:(JMFormView *)formView
{
    [self.formScrollView scrollRectToVisible:formView.frame animated:YES];
}

#pragma mark - Keyboard ...

- (BOOL)nextFormViewAvailableAfterFormView:(JMFormView *)formView
{
    JMFormView *nextForm = [self.formScrollView nextFirstResponderFormViewFromView:formView];
    return nextForm!=nil;
}

- (BOOL)previousFormViewAvailableBeforeFormView:(JMFormView *)formView
{
    JMFormView *previousForm = [self.formScrollView previousFirstResponderFormViewFromView:formView];
    return previousForm!=nil;
}

- (void)presentNextFormViewAvailableAfterFormView:(JMFormView *)formView
{
    JMFormView *nextForm = [self.formScrollView nextFirstResponderFormViewFromView:formView];
    [nextForm formViewBecomeFirstResponder];
}

- (void)presentPreviousFormViewAvailableBeforeFormView:(JMFormView *)formView
{
    JMFormView *previousForm = [self.formScrollView previousFirstResponderFormViewFromView:formView];
    [previousForm formViewBecomeFirstResponder];
}

#pragma mark - IBactions

- (IBAction)customSelector1:(id)sender
{
    [self.view endEditing:NO];
    NSLog(@"%s",__FUNCTION__);
}

@end