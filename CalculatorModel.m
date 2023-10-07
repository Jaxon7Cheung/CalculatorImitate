//
//  calculatorModel.m
//  CalculatorImitate
//
//  Created by 张旭洋 on 2023/9/27.
//

#import "CalculatorModel.h"

static Stack* _stringStack;

@interface CalculatorModel () {
//    //字符栈
//    Stack* _stringStack;
    //分隔字符串
    //NSMutableArray* _processArray;
    //后缀表达式
    //NSMutableArray* _postFix;
    //计算结果
    //NSString* _answerString;
}
@end

@implementation CalculatorModel


- (NSMutableString *)Calculate:(NSMutableString *)inputFix  {
    NSMutableArray* processedArray = [[NSMutableArray alloc] init];
    processedArray = [self processFix: inputFix];
    
    NSMutableArray* postfix = [[NSMutableArray alloc] init];
    postfix = [self infixToPostfix: processedArray];
    NSMutableString* answerString = [[NSMutableString alloc] init];
    answerString = [self calculatePostfix: postfix];
    
    return answerString;
}

//计算后缀
- (NSMutableString *)calculatePostfix: (NSMutableArray *)postfix {
    Stack* stack = [[Stack alloc] init];
    NSDictionary* priority = @{@"+": @(1), @"-": @(1), @"×": @(2), @"÷": @(2)};
    for (NSMutableString* string in postfix) {
        if ([priority.allKeys containsObject: string]) {
//            CGFloat a = [[stack popStack] doubleValue];
//            CGFloat b = [[stack popStack] doubleValue];
            NSDecimalNumber* a = [[NSDecimalNumber alloc] initWithString: [stack popStack]];
            NSDecimalNumber* b = [[NSDecimalNumber alloc] initWithString: [stack popStack]];
            NSDecimalNumber* result = [self jJcC: string aValue: a bValue: b];
            
            NSString* resultString = [result stringValue];
            NSMutableString* resultMutableString = [resultString mutableCopy];
            [stack pushStack: resultMutableString];
        } else {
            [stack pushStack: string];
        }
    }
    
    return [stack popStack];
}
//加减乘除
- (NSDecimalNumber *)jJcC: (NSString *)ope aValue: (NSDecimalNumber *)a bValue: (NSDecimalNumber *)b {
    if ([ope isEqualToString: @"×"]) {
        return [b decimalNumberByMultiplyingBy: a];
    } else if ([ope isEqualToString: @"÷"]) {
        return  [b decimalNumberByDividingBy: a];
    } else if ([ope isEqualToString: @"+"]) {
        return [b decimalNumberByAdding: a];
    } else if ([ope isEqualToString: @"-"]) {
        return [b decimalNumberBySubtracting: a];
    } else {
        return nil;
    }
}

//中缀转后缀
- (NSMutableArray *)infixToPostfix: (NSMutableArray *)processedArray {
    _stringStack = [[Stack alloc] init];
    NSMutableArray* postFix = [[NSMutableArray alloc] init];
    NSDictionary* priority = @{@"+": @(1), @"-": @(1), @"×": @(2), @"÷": @(2)};
    
    for (NSMutableString* string in processedArray) {
        if ([self isNumber: string]) {  //运算数
            [postFix addObject: string];
        } else if ([string isEqualToString: @"("]) {
            [_stringStack pushStack: string];
        } else if ([string isEqualToString: @")"]) {
            NSString* top = [_stringStack getTop];
            while (![_stringStack isEmpty] && ![top isEqualToString: @"("]) {
                [postFix addObject: top];
                [_stringStack popStack];
                top = [_stringStack getTop];
            }
            [_stringStack popStack];
        } else if ([priority.allKeys containsObject: string]) {  //操作符
            NSString* top = [_stringStack getTop];
            while (![_stringStack isEmpty] && ([priority[top] intValue] >= [priority[string] intValue])) {
                [postFix addObject: top];
                [_stringStack popStack];
                top = [_stringStack getTop];
            }
            [_stringStack pushStack: string];
        }
    }
    
    while (![_stringStack isEmpty]) {
        [postFix addObject: [_stringStack getTop]];
        [_stringStack popStack];
    }
    
    return postFix;
}

//分隔字符串
- (NSMutableArray *)processFix:(NSMutableString *)inputFix {

    NSMutableArray *componentsArray = [NSMutableArray array];
    NSMutableString *currentNumberString = [NSMutableString string];
    BOOL needToAddSymbol = YES;

    for (NSInteger i = 0; i < inputFix.length; i++) {
        unichar character = [inputFix characterAtIndex:i];
        
        if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:character] || character == '.' || (character == '-' && needToAddSymbol)) {
            // 当前字符是数字、小数点或负号，并且需要添加符号
            [currentNumberString appendFormat:@"%C", character];
            needToAddSymbol = NO;
        } else if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:character] || character == '.') {
            // 当前字符是数字或小数点，数字已经开始，不需要添加符号
            [currentNumberString appendFormat:@"%C", character];
        } else {
            // 当前字符是运算符或括号的字符
            if (currentNumberString.length > 0) {
                // 将之前解析的数字添加到componentsArray中
                [componentsArray addObject:currentNumberString];
                // 重置currentNumberString
                currentNumberString = [NSMutableString string];
            }
            
            // 将当前的运算符或括号字符添加到componentsArray中
            [componentsArray addObject:[NSString stringWithFormat:@"%C", character]];
            
            needToAddSymbol = YES;
        }
    }

    // 将最后解析的数字添加到componentsArray中
    if (currentNumberString.length > 0) {
        [componentsArray addObject:currentNumberString];
    }
    
    return componentsArray;
    
}

//判断运算数
- (BOOL)isNumber: (NSMutableString *)string {
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSCharacterSet *dotCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"."];

    // 去除字符串中的空格和符号
    NSString *strippedString = [string stringByTrimmingCharactersInSet:nonDigitCharacterSet];

    NSScanner *scanner = [NSScanner scannerWithString:strippedString];
    double doubleValue;

    // 使用scanner判断是否可以将字符串转换为double类型
    BOOL isNumeric = [scanner scanDouble:&doubleValue];

    // 对于小数，需进一步判断是否只包含一个小数点
    BOOL hasDot = [strippedString rangeOfCharacterFromSet:dotCharacterSet].location != NSNotFound;
    BOOL isValid = isNumeric && (!hasDot || ([strippedString componentsSeparatedByString:@"."].count == 2));

    if (isValid) {
        // 判断字符串是否以负号开头并修正数值
        if ([string hasPrefix:@"-"]) {
            doubleValue *= -1.0;
        }
        
//        NSLog(@"The string is a number.");
//        NSLog(@"Numeric value: %f", doubleValue);
        return YES;
    } else {
        return NO;
    }
}

@end
