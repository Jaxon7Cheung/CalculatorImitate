//
//  Stack.m
//  CalculatorImitate
//
//  Created by 张旭洋 on 2023/9/27.
//

#import "Stack.h"

@implementation Stack

//- (void)initStack {
//    _top = -1;
//}
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        _top = -1;
//    }
//    return self;
//}

- (instancetype)init {
    self = [super init];
    if (self) {
        _stack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)pushStack: (NSMutableString *)element {
    [_stack addObject: element];
}

- (NSMutableString *)popStack {
    if ([_stack count] > 0) {
        NSMutableString* lastString = [_stack lastObject];
        [_stack removeLastObject];
        return lastString;
    }
    return nil;
}

- (NSMutableString *)getTop {
    if ([_stack count] > 0) {
        NSMutableString* lastString = [_stack lastObject];
        return lastString;
    }
    return nil;
}

- (BOOL)isEmpty {
    return _stack.count == 0;
}

@end
