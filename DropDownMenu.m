//  DayDropDownMenu.m
//
//  Copyright (c) 2013 Kevin Randrup. All rights reserved.
//

#import "DropDownMenu.h"

@interface DropDownMenu () <UIActionSheetDelegate>
@end

@implementation DropDownMenu

#pragma mark - Setup/Teardown

- (void)setup
{
    NSString *title = [self titleForState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal]; //Add arrow if title set in storyboard
    [self addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
}

- (void)awakeFromNib
{
    [self setup];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)removeFromSuperview
{
    self.delegate = nil;
    [super removeFromSuperview];
}

#pragma mark - Title

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    title = [title stringByAppendingString:@" \u25BC"]; //Unicode - Down arrow
    [super setTitle:title forState:state];
    [self sizeToFit];
}

#pragma mark - Selection

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *item = [actionSheet buttonTitleAtIndex:buttonIndex]; //Not cancel
        if ([self.items containsObject:item]) {
            if (self.selectionBlock)
                self.selectionBlock(item);
            if (self.delegate) {
                [self.delegate dropDownMenu:self didSelectItem:item];
            }
        }
    }
}

- (void)tap
{
    if ([self.items count]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        for (NSString *item in self.items) {
            [actionSheet addButtonWithTitle:item];
        }
        [actionSheet showFromRect:self.frame inView:self.superview animated:YES];
    }
}

@end
