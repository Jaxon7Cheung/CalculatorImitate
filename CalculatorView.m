//
//  calculatorView.m
//  CalculatorImitate
//
//  Created by 张旭洋 on 2023/9/27.
//

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
