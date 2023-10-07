//
//  ViewController.h
//  CalculatorImitate
//
//  Created by 张旭洋 on 2023/9/27.
//

#import <UIKit/UIKit.h>
#import "CalculatorView.h"
#import "CalculatorModel.h"

@interface ViewController : UIViewController

@property (nonatomic, strong)CalculatorView* calculatorView;
@property (nonatomic, strong)CalculatorModel* calculatorModel;

@property (nonatomic, assign)BOOL operateLimit;
@property (nonatomic, assign)BOOL pointLimitByNum;
@property (nonatomic, assign)BOOL pointLimitByOper;
@property (nonatomic, assign)BOOL equalPressed;

@end

