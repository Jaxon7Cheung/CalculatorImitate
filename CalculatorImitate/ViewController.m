//
//  ViewController.m
//  CalculatorImitate
//
//  Created by 张旭洋 on 2023/9/27.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //×÷
    //2*(3+5)+7/1-4
    /*(3.5+(-2.8))*4.2+0-1.6*1/2
     带小数、负数
     */
    /*
     3.141592653589793238*2.718281828459045 = 8.53973422267356632479980570093771
     数据类型NSDecimalNumber可以精确表示小数点后多达38位的数字，精度甚至大于手机的一倍
     
     //6.(9)
     */
    [self createView];
    [self createModel];
    
    
}

- (void)createView {
    self.calculatorView = [[CalculatorView alloc] initWithFrame: self.view.frame];
    [self.view addSubview: self.calculatorView];
    self.calculatorView.showField.text = @"";
    
    //添加事件
    for (UIButton* button in self.calculatorView.buttonArray) {
        [button addTarget: self action: @selector(pressButton:) forControlEvents: UIControlEventTouchUpInside];
    }
    [self.calculatorView.ACButton addTarget: self action: @selector(pressACButton:) forControlEvents: UIControlEventTouchUpInside];
    [self.calculatorView.equalButton addTarget: self action: @selector(pressEqualButton:) forControlEvents: UIControlEventTouchUpInside];
    [self.calculatorView.pointButton addTarget: self action: @selector(pressPointButton:) forControlEvents: UIControlEventTouchUpInside];
    
    //限制
    self.operateLimit = NO;
    self.pointLimitByNum = NO;
    self.pointLimitByOper = YES;
}

- (void) pressButton: (UIButton*)button {
    if (button.tag / 100 == 1) {
        [self pressBracButton: button];
    } else if (button.tag / 100 == 2) {
        [self pressOperButton: button];
    } else if (button.tag / 100 == 3) {
        [self pressNumberButton: button];
    }
}

- (void)pressBracButton: (UIButton *)button {
    if (button.tag == 101) {
        NSString* oldText = self.calculatorView.showField.text;
        NSString* newText = [NSString stringWithFormat: @"%@%@", oldText, button.titleLabel.text];
        self.calculatorView.showField.text = newText;
            
    } else {  //102
        NSString* oldText = self.calculatorView.showField.text;
        NSString* newText = [NSString stringWithFormat: @"%@%@", oldText, button.titleLabel.text];
        self.calculatorView.showField.text = newText;
    }
    
    self.operateLimit = NO;
    self.pointLimitByNum = NO;
    self.pointLimitByOper = YES;
}

- (void)pressOperButton: (UIButton *)button {
        if (button.tag == 201) {
            NSString* oldText = self.calculatorView.showField.text;
            NSString* newText;
            if (!self.operateLimit) {
                if ([oldText isEqualToString: @""]) {
                    newText = [[NSString alloc] initWithFormat: @"0%@", button.titleLabel.text];
                } else {
                    newText = [NSString stringWithFormat: @"%@%@", oldText, button.titleLabel.text];
                }
            } else {
                newText = [oldText stringByReplacingCharactersInRange: NSMakeRange(oldText.length - 1, 1) withString: button.titleLabel.text];
            }
            
            self.calculatorView.showField.text = newText;
        } else if (button.tag == 202) {
            NSString* oldText = self.calculatorView.showField.text;
            NSString* newText;
            if (!self.operateLimit) {
                if ([oldText isEqualToString: @""]) {
                    newText = [[NSString alloc] initWithFormat: @"0%@", button.titleLabel.text];
                } else {
                    newText = [NSString stringWithFormat: @"%@%@", oldText, button.titleLabel.text];
                }
            } else {
                newText = [oldText stringByReplacingCharactersInRange: NSMakeRange(oldText.length - 1, 1) withString: button.titleLabel.text];
            }
            self.calculatorView.showField.text = newText;
        } else if (button.tag == 203) {
            NSString* oldText = self.calculatorView.showField.text;
            NSString* newText;
            if (!self.operateLimit) {
                if ([oldText isEqualToString: @""]) {
                    newText = [[NSString alloc] initWithFormat: @"0%@", button.titleLabel.text];
                } else {
                    newText = [NSString stringWithFormat: @"%@%@", oldText, button.titleLabel.text];
                }
            } else {
                newText = [oldText stringByReplacingCharactersInRange: NSMakeRange(oldText.length - 1, 1) withString: button.titleLabel.text];
            }
            self.calculatorView.showField.text = newText;
        } else {  //204
            NSString* oldText = self.calculatorView.showField.text;
            NSString* newText;
            if (!self.operateLimit) {
                if ([oldText isEqualToString: @""]) {
                    newText = [[NSString alloc] initWithFormat: @"0%@", button.titleLabel.text];
                } else {
                    newText = [NSString stringWithFormat: @"%@%@", oldText, button.titleLabel.text];
                }
            } else {
                newText = [oldText stringByReplacingCharactersInRange: NSMakeRange(oldText.length - 1, 1) withString: button.titleLabel.text];
            }
            self.calculatorView.showField.text = newText;
        }
    
    self.operateLimit = YES;
    self.pointLimitByNum = NO;
    self.pointLimitByOper = YES;
    
}

- (void)pressNumberButton: (UIButton *)button {
    NSString* oldText = self.calculatorView.showField.text;
    NSString* newText;
    if ([button.titleLabel.text isEqualToString: @"     0     "]) {
        newText = [NSString stringWithFormat: @"%@0", oldText];
    } else {
        newText = [NSString stringWithFormat: @"%@%@", oldText, button.titleLabel.text];
    }
    self.calculatorView.showField.text = newText;
    
    self.operateLimit = NO;
    if (self.pointLimitByOper) {
        self.pointLimitByNum = YES;
    }
}

- (void)pressACButton: (UIButton *)button {
    self.calculatorView.showField.text = @"";
    
    self.operateLimit = NO;
    self.pointLimitByNum = NO;
    self.pointLimitByOper = YES;;
    
}

- (void)pressEqualButton: (UIButton *)button {
    if ([self.calculatorView.showField.text isEqualToString: @""]) return;
    
    if  ([self isInfixLogical: self.calculatorView.showField.text]) {
        NSMutableString* showText = [self.calculatorView.showField.text mutableCopy];
        NSString* answer = [self.calculatorModel Calculate: showText];
        NSLog(@"%@", answer);
        self.calculatorView.showField.text = answer;
    } else {
        self.calculatorView.showField.text = @"ERROR";
        //0.77秒后自动AC
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 0.77 target:self selector:@selector(pressACButton:) userInfo:nil repeats:NO];
    }
}

- (void)pressPointButton: (UIButton *)button {
    if (self.pointLimitByNum && self.pointLimitByOper) {
        NSString* oldText = self.calculatorView.showField.text;
        NSString* newText = [NSString stringWithFormat: @"%@%@", oldText, button.titleLabel.text];
        self.calculatorView.showField.text = newText;
        
        self.operateLimit = NO;
        self.pointLimitByNum = NO;
        self.pointLimitByOper = NO;
    }
    
}

- (BOOL)isInfixLogical: (NSString *)infix {
    NSDictionary* oper = @{@"+": @(1), @"-": @(1), @"×": @(2), @"÷": @(2)};
    unichar lastChar = [infix characterAtIndex: infix.length - 1];
    NSString* lastCh = [NSString stringWithCharacters: &lastChar length: 1];
    //NSLog(@"%i", [oper.allKeys containsObject: lastCh]);
    if ([oper.allKeys containsObject: lastCh]) return NO;
    
    NSMutableArray* stack = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < infix.length; ++i) {
        unichar c = [infix characterAtIndex: i];
        if (c == '(') {
            [stack addObject: @(c)];
        } else if (c == ')') {
            if (stack.count == 0) return NO;
            [stack removeLastObject];
        }
    }
    if (stack.count > 0) return NO;
    
    NSMutableArray* processedArray = [[NSMutableArray alloc] init];
    CalculatorModel* calculatorModel = [[CalculatorModel alloc] init];
    NSMutableString* newInfix = [infix mutableCopy];
    processedArray = [calculatorModel processFix: newInfix];
    
    NSString* divide = [[NSString alloc] init];
    NSString* zero = [[NSString alloc] init];
    for (NSInteger i = 1; i < processedArray.count; ++i) {
        divide = processedArray[i - 1];
        zero = processedArray[i];
        if ([divide isEqualToString: @"÷"] && [zero isEqualToString: @"0"]) return NO;
    }
    
    return YES;
}

- (void)createModel {
    self.calculatorModel = [[CalculatorModel alloc] init];
}

@end
