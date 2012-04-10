//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Max Keil on 06.04.12.
//  Copyright (c) 2012. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()

@property (nonatomic) BOOL userIsInTheMiddleOnEnteringANumber;
@property (nonatomic) BOOL userAlreadySetAFloatingPoint;
@property (nonatomic, strong) CalculatorBrain * brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize cache = _cache;
@synthesize userIsInTheMiddleOnEnteringANumber = _userIsInTheMiddleOnEnteringANumber;
@synthesize userAlreadySetAFloatingPoint = _userAlreadySetAFloatingPoint;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    // Check if the user currently pressed the floating point.
    if ([digit isEqualToString:@"."]) {
        if (self.userAlreadySetAFloatingPoint) {
            return;
        }
        self.userAlreadySetAFloatingPoint = YES;
    }
    if ([digit isEqualToString:@"π"]) {
        digit = [[NSNumber numberWithDouble:M_PI] stringValue];
        if (self.userIsInTheMiddleOnEnteringANumber) {
            [self enterPressed];
            [self.brain pushOperand:M_PI];
            digit = [[NSNumber numberWithDouble:[self.brain performOperation:@"*"]] stringValue];
        }
    }
    if (self.userIsInTheMiddleOnEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOnEnteringANumber = YES;
    }

}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOnEnteringANumber) {
        [self enterPressed];
    }
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    [self addToHistory:sender.currentTitle];
    
}

- (IBAction)enterPressed
{    
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self addToHistory:self.display.text];
    self.userIsInTheMiddleOnEnteringANumber = self.userAlreadySetAFloatingPoint = NO;
    
}

- (IBAction)clearDisplay {
    self.display.text = @"0";
    [self clearHistory];
    [self.brain clearOperandStack];
    self.userIsInTheMiddleOnEnteringANumber = self.userAlreadySetAFloatingPoint = NO;
    
}

- (void)clearHistory
{
    self.cache.text = @"";
}

- (void)addToHistory:(NSString *)text
{
    self.cache.text = [[self.cache.text stringByAppendingString:text] stringByAppendingString:@" "];
}

@end
