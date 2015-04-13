//
//  ViewController.m
//  Square
//
//  Created by qianfeng on 13-11-12.
//  Copyright (c) 2013年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BaseSquare.h"

/*
 俄罗斯方块  
 00  0   00 000  0        00    0
 00  000 0    0  0 0000    00  000
         0      00
  1  2  432   4
 234 31  1   13
     4        2
 */
@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc{
    self.customView = nil;
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _customView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, 400)];
    _customView.backgroundColor = [UIColor clearColor];
    _customView.layer.cornerRadius = 5.0;
    _customView.layer.borderColor = [UIColor blackColor].CGColor;
    _customView.layer.borderWidth = 2.0;
    [self.view addSubview:_customView];
    
    _num = 0;
    _time = 0;
    for (int i = 0; i < 4; i++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];

        b.frame = CGRectMake(100+55*i, 420, 50, 30);
        switch (i) {
            case 0:
                [b setTitle:@"左移" forState:UIControlStateNormal];
                [self.view addSubview:b];
                [b addTarget:self action:@selector(squareLeftMove) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                [b setTitle:@"加速" forState:UIControlStateNormal];
                [b addTarget:self action:@selector(squareQuickMoveDown) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                [b setTitle:@"右移" forState:UIControlStateNormal];
                [b addTarget:self action:@selector(squareRightMove) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 3:
                [b setTitle:@"旋转" forState:UIControlStateNormal];
                [self.view addSubview:b];
                [b addTarget:self action:@selector(squareLeftChange) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                break;
        }
        [self.view addSubview:b];
    }
    
    _labei = [[UILabel alloc] initWithFrame:CGRectMake(10, 420, 80, 30)];
    _labei.text = @"0";
    _labei.font = [UIFont systemFontOfSize:22];
    _labei.backgroundColor = [UIColor grayColor];
    _labei.textColor = [UIColor whiteColor];
    _labei.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_labei];

    for (int i = 0; i < 20; i++) {
        for (int j = 0 ; j < 14; j++) {
            if (i == 0) {
            }
            UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [b setFrame:CGRectMake(20*j, 20*i, 20, 20)];
            b.tag = 100 +14*i +j;
            b.hidden = YES;
            b.backgroundColor = [UIColor clearColor];
            b.layer.cornerRadius = 5.0;
            b.layer.borderColor = [UIColor blackColor].CGColor;
            b.layer.borderWidth = 1.0;

            [_customView addSubview:b];
        }
        
    }
    [self creatSquare];
    //    启动下落线程
    [self performSelectorInBackground:@selector(squareMoveDown) withObject:nil];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTap)];
    tap.numberOfTapsRequired = 2;
    [_customView addGestureRecognizer:tap];
    [tap release];
}

- (void)myTap{
    [_square rotationSquare];
}
- (void)squareLeftChange{
    [_square rotationSquare];
}

//- (void)squareRightChange{
//    
//}

- (void)squareLeftMove{
    [_square moveLeft];
}

- (void)squareRightMove{
    [_square moveRight];
}

BOOL isQuick = 0;
- (void)squareQuickMoveDown{
    isQuick = !isQuick;
}

//在子线程中运行
- (void)squareMoveDown{
    while (1) {
//        让runLoop睡眠1秒
//        在子线程中无法刷新UI 刷新只能放在主线程(系统自动创建主线程)
        if (isQuick) {
            [NSThread sleepForTimeInterval:0.1 + 0.2 *_time];
        }
        else {
            [NSThread sleepForTimeInterval:0.5 + _time];
        }

//        线程间的通讯
        [self performSelectorOnMainThread:@selector(refreshUI) withObject:nil waitUntilDone:YES];
    }
}

//该方法在主线程中运行
- (void)refreshUI{
    [_square moveDown];
}

//后台线程_square一直在往下掉 掉到最底层 会以代理的形式通知ctl 再次创建方块 同时把之前的_square对象释放 并且置为nil 在这一瞬间_square MoveDown无效 直到_square又指向一个新的对象空间 再继续往下掉 整个过程线程都没有停止过
- (void)creatSquare{
//    释放之前的方块
    if (_squareBak) {
        [_squareBak release];
        _squareBak = nil;
    }
    
//    创建新的方块对象
    _squareBak = [[BaseSquare alloc] init];
    _squareBak.delegate = self;
//    弱引用关系  地址空间一样 指向同一个对象
    _square = _squareBak;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deleteSquare{
    for (int i = 19; i >= 0; i--) {
        BOOL pos = YES;
        for (int j = 0 ; j < 14; j++) {
            UIButton *b = (UIButton *)[_customView viewWithTag:14*i +j +100];
            if (b.hidden) {
                pos = NO;
                break;
            }
        }
        if (pos) {
            _num += 450;
            _labei.text = [NSString stringWithFormat:@"%d", _num];
            [self setLineBtnHiddenY:i];
            [self setLineBtnDropY:i];
            i++;
        }
    }
}

- (void)setLineBtnHiddenY:(NSInteger)y{
    for (int i = 0; i < 14; i++) {
        UIButton *b = (UIButton *)[_customView viewWithTag:y*14 +i +100];
        b.hidden = YES;
    }
}

- (void)setLineBtnDropY:(NSInteger)y{
    for (int k = y; k > 0; k--) {
        for (int j = 0; j < 14; j++) {
            UIButton *b = (UIButton *)[_customView viewWithTag:14*k +j +100];
            UIButton *b1 = (UIButton *)[_customView viewWithTag:14*(k-1) +j +100];
            b.hidden = b1.hidden;
            b.backgroundColor = b1.backgroundColor;
            if (k == 1) {
                b1.hidden = YES;
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    纪录手指点击的坐标
    UITouch *touch = [touches anyObject];
    prePoint = [touch locationInView:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    纪录手指放开的坐标
    UITouch *touch = [touches anyObject];
    curPoint = [touch locationInView:self.view];
    
    if (curPoint.x > prePoint.x) {
        int temp = (curPoint.x - prePoint.x)/20;
        for (int i = 0; i < temp; i++) {
            [_square moveRight];
        }
    } else if(curPoint.x < prePoint.x) {
        int temp = (prePoint.x - curPoint.x)/20;
        for (int i = 0; i < temp; i++) {
            [_square moveLeft];
        }
    }
}
#pragma mark -squareMoveToBottom
- (void)squareMoveToBottom{
    isQuick = 0;
    [self deleteSquare];
    
//    创建另外一个方块
    [self creatSquare];
    _num += 50;
    if (_num >= 2000 && _time <= 0.3) {
        _time += 0.05;
    }
    _labei.text = [NSString stringWithFormat:@"%d", _num];
}
@end
