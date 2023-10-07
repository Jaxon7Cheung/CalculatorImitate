//
//  calculatorView.h
//  CalculatorImitate
//
//  Created by 张旭洋 on 2023/9/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalculatorView : UIView

//用于传给Controller
@property (nonatomic, strong) NSArray* operArray;
@property (nonatomic, strong) NSMutableArray* buttonArray;

@property (nonatomic, strong) UITextField* showField;

@property (nonatomic, strong) UIButton* ACButton;
@property (nonatomic, strong) UIButton* equalButton;
@property (nonatomic, strong) UIButton* pointButton;

@end

NS_ASSUME_NONNULL_END
