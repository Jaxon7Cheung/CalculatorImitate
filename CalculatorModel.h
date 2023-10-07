//
//  calculatorModel.h
//  CalculatorImitate
//
//  Created by 张旭洋 on 2023/9/27.
//

#import <Foundation/Foundation.h>
#import "Stack.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalculatorModel : NSObject {
    
    
}

- (NSMutableString *)Calculate: (NSMutableString *)inputFix;

- (NSMutableArray *)processFix: (NSMutableString *)inputFix;



@end

NS_ASSUME_NONNULL_END
