😶‍🌫️😶‍🌫️😶‍🌫️


## 前言

仿写了iPhone上的计算器，可以进行四则运算多项式的计算。
- 整体设计模式为MVC模式
- UI布局调用了CocoPods中的Masonry库
- 计算思路详见这篇文章：[实现简易四则运算](https://blog.csdn.net/XY_Mckevince/article/details/133276273?csdn_share_tail=%7B%22type%22:%22blog%22,%22rType%22:%22article%22,%22rId%22:%22133276273%22,%22source%22:%22XY_Mckevince%22%7D)

运行结果：
![img](https://github.com/Jaxon7Cheung/CalculatorImitate/blob/master/aa8c0b90f34a45df85c6c55bdfffac84.gif)



## UI界面（View）

先配置好Masonry：

先来看看接口界面的代码（**.h**文件）：

```objectivec
@interface CalculatorView : UIView

//用于传给Controller
@property (nonatomic, strong) NSArray* operArray;
@property (nonatomic, strong) NSMutableArray* buttonArray;

@property (nonatomic, strong) UITextField* showField;

@property (nonatomic, strong) UIButton* ACButton;
@property (nonatomic, strong) UIButton* equalButton;
@property (nonatomic, strong) UIButton* pointButton;

@end
```
`operArray`存储字符：加、减、乘、除、括号、清除。

`ACButton, equalButton, pointButton`分别存储AC按钮、等于按钮和小数点按钮。

`buttonArray`存储除上面3个以外的其他按钮，方便打包传给Controller界面。

显示数字的界面用`textField`显示。


如下是实现界面（**.m**文件）：

```objectivec
#import "CalculatorView.h"
#import "Masonry.h"
#define SIZE 85
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation CalculatorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor blackColor];
    
    self.operArray = [[NSArray alloc] initWithObjects: @"+", @"-", @"×", @"÷", @"AC", @"(", @")", nil];
    //1 2 3 + 4 5 6 - 7 8 9 * ( ) /
    self.buttonArray = [[NSMutableArray alloc] init];
    
    self.showField = [[UITextField alloc] init];
    self.showField.backgroundColor = [UIColor blackColor];
    self.showField.textColor = [UIColor whiteColor];
    self.showField.textAlignment = NSTextAlignmentRight;
    self.showField.font = [UIFont systemFontOfSize: 60];
    //不可交互
    self.showField.userInteractionEnabled = NO;
    //字体大小自适应
    self.showField.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:self.showField];
    
    [self.showField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-600);
        make.width.equalTo(@(WIDTH));
    }];
    
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            UIButton* button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
            button.titleLabel.font = [UIFont systemFontOfSize: 42];
            button.layer.cornerRadius = SIZE / 2;
            [self addSubview: button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self).offset(-(70 + (SIZE + 15) * (i + 1)));
                make.left.equalTo(self).offset(3 + (SIZE + 15) * j);
                make.size.equalTo(@SIZE);
            }];
            
            if (i == 3 && j < 3) {  //AC和括号 101 102
                button.backgroundColor = [UIColor grayColor];
                [button setTitle: self.operArray[i + j + 1] forState: UIControlStateNormal];
                [button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
                button.tag = 100 + j;
                if (j == 0) {
                    self.ACButton = button;
                } else {
                    [self.buttonArray addObject: button];
                }
            } else if (j == 3) {  //操作符
                button.backgroundColor = [UIColor colorWithRed: 251.0f / 255.0f green:151.0f / 255.0f blue:15.0f / 255.0f alpha: 1.0];
                [button setTitle: self.operArray[i] forState: UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.tag = 200 + i + 1;

                [self.buttonArray addObject: button];
            } else {  //数字
                button.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
                NSString* title = [NSString stringWithFormat:@"%d", j + 3 * i + 1];
                [button setTitle:title forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.tag = 300 + i * 3 + j + 1;

                [self.buttonArray addObject: button];
            }
        }
    }
    
    for (int i = 0; i < 3; i++) {  //0 . =
        UIButton* button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        button.titleLabel.font = [UIFont systemFontOfSize: 42];
        button.layer.cornerRadius = SIZE / 2;
        [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        
        [self addSubview: button];
        
        if (i == 0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self).offset(-70);
                make.left.equalTo(self).offset(0);
                make.width.equalTo(@(SIZE * 2 + 15));
                make.height.equalTo(@SIZE);
            }];
            [button setTitle:@"     0     " forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
            button.tag = 310;

            [self.buttonArray addObject:button];
        } else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self).offset(-70);
                make.left.equalTo(self).offset(200 + (SIZE + 15) * (i - 1));
                make.size.equalTo(@SIZE);
            }];
            if (i == 1) {
                [button setTitle:@"." forState:UIControlStateNormal];
                button.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
                button.tag = 311;

                self.pointButton = button;
            } else {
                [button setTitle:@"=" forState:UIControlStateNormal];
                button.backgroundColor = [UIColor colorWithRed:251.0f / 255.0f green:151.0f / 255.0f blue:15.0f / 255.0f alpha:1];
                button.tag = 400;

                self.equalButton = button;
            }
        }
    }
}

@end

```
双层循环创建上侧4x4个按钮，从`1`开始，最后遍历到`÷`

`0`、`.`、`=`按钮单独在循环中创建

要给每个按钮设置`tag`值，以便点击事件函数识别传进来的是哪个按钮

![在这里插入图片描述](https://img-blog.csdnimg.cn/ece4e1ded12e4cb88468d4fd1569dbf3.png#pic_center)


这里可以将`textField`的`adjustsFontSizeToFitWidth`属性值设置为YES，作用时当字符串宽度超过屏幕宽度时，字体大小自动适应，效果如下：

![在这里插入图片描述](https://img-blog.csdnimg.cn/5a378385ed46406aa99085d2fdb33021.gif#pic_center =177x)

## 表达式计算（Model）

之前用C语言做了一个简易的四则运算表达式的计算程序，下面继续沿用程序中的==中缀转后缀==这一思路，用OC语言编写程序

OC的Foundation框架提供了集合类数据结构如NSMutableArray，我们可以用NSMutableArray存储运算数、操作符这些字符串对象，模拟一个栈

**Stack.h**
```objectivec
@interface Stack : NSObject {
    NSMutableArray<NSMutableString *>* _stack;
}

- (void)pushStack: (NSMutableString *)element;
- (NSMutableString *)popStack;
- (NSMutableString *)getTop;
- (BOOL)isEmpty;

@end
```

**Stack.m**

```objectivec
#import "Stack.h"

@implementation Stack

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

```

大体思路为：
- 输入NSMutableString中缀表达式字符串
- - `(3.5+(-2.8))*4.2+0-1.6*1/2` 
- 分隔字符串，将连续的运算数、操作符依次存入NSMutableArray里
- - `( 3.5 + ( -2.8 ) ) * 4.2 + 0 - 1.6 * 1 / 2, nil`
- 将NSMutableArray里的中缀顺序转换成后缀顺序
- - `3.5 2.8 - + 4.2 * 0 + 1.6 1 * 2 / -, nil`
- 计算后缀表达式

核心代码：

```objectivec
- (NSMutableString *)Calculate:(NSMutableString *)inputFix  {
    //分隔
    NSMutableArray* processedArray = [[NSMutableArray alloc] init];
    processedArray = [self processFix: inputFix];
    
    //中缀转后缀
    NSMutableArray* postfix = [[NSMutableArray alloc] init];
    postfix = [self infixToPostfix: processedArray];
    
    //计算后缀
    NSMutableString* answerString = [[NSMutableString alloc] init];
    answerString = [self calculatePostfix: postfix];
    
    return answerString;
}
```
==具体实现见文末源码==

一些方法函数可根据需要选择公开或者不公开

如若有NSString，可拷贝其mutableCopy的可变副本进行使用

- 加减乘除运算数据类型用的是`NSDecimalNumber`，精确度贼高，可精确到小数点后30多位，可实现较大数字的运算

```objectivec
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
```
最后调用`NSDecimalNumber`的`stringValue`方法将对象转换成字符串

- 比较巧妙的是一个字典就可以**判断运算符**以及其**优先级的比较**：

```objectivec
NSDictionary* priority = @{@"+": @(1), @"-": @(1), @"×": @(2), @"÷": @(2)};

//判断运算符
if ([priority.allKeys containsObject: string]) {
    return YES;
} else {
    return NO;
}

//得到string字符的优先级（value值）
NSInteger x = [priority[string] intValue];
```

## 事件函数的逻辑（Controller）

这部分主要实现按钮的点击反馈，表达式的判错，运算符输入的限制，并将View和Model的信息集合起来

**ViewController.h**

```objectivec
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
```

`operateLimit`限制了只能输入一个运算符，当点击另一运算符时直接切换

`pointLimitByNum、pointLimitByOper`前者限制小数点只能出现在数字后面、后者限制两个小数点之间必需要有一个运算符，综合这两点就可以达到**一个数字仅包含一个小数点的效果**

`equalPressed`限制了等号输入

- 以下是点击等号的事件函数，其余都是字符串输入有关的方法
```objectivec
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
```
