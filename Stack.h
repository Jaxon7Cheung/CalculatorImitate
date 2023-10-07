//
//  Stack.h
//  CalculatorImitate
//
//  Created by 张旭洋 on 2023/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Stack : NSObject {
    NSMutableArray<NSMutableString *>* _stack;
    //NSInteger _top;
}

- (void)pushStack: (NSMutableString *)element;
- (NSMutableString *)popStack;
- (NSMutableString *)getTop;
- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END
