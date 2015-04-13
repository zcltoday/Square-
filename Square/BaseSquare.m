//
//  BaseSquare.m
//  Square
//
//  Created by qianfeng on 13-11-12.
//  Copyright (c) 2013年 qianfeng. All rights reserved.
//

#import "BaseSquare.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation BaseSquare

- (id)init{
    self = [super init];
    if (self) {
        _numSquare = arc4random()%7;
        _status = 0;
        [self initsquare];
        }
    return self;
}

- (void)initsquare{
    switch (_numSquare) {
        case 0: //长条
            point1.x = 6;
            point1.y = 0;
            point2.x = 7;
            point2.y = 0;
            point3.x = 8;
            point3.y = 0;
            point4.x = 9;
            point4.y = 0;
            break;
        case 1: //田型
            point1.x = 6;
            point1.y = 0;
            point2.x = 7;
            point2.y = 0;
            point3.x = 6;
            point3.y = 1;
            point4.x = 7;
            point4.y = 1;
            break;
        case 3:  //反L型
            point1.x = 6;
            point1.y = 0;
            point2.x = 6;
            point2.y = 1;
            point3.x = 7;
            point3.y = 1;
            point4.x = 8;
            point4.y = 1;
            break;
        case 2: //向左闪电
            point1.x = 6;
            point1.y = 0;
            point2.x = 7;
            point2.y = 0;
            point3.x = 7;
            point3.y = 1;
            point4.x = 8;
            point4.y = 1;
            break;
        case 4: //土型
            point1.x = 7;
            point1.y = 0;
            point2.x = 6;
            point2.y = 1;
            point3.x = 7;
            point3.y = 1;
            point4.x = 8;
            point4.y = 1;
            break;
        case 5://L
            point1.x = 6;
            point1.y = 0;
            point2.x = 6;
            point2.y = 1;
            point3.x = 6;
            point3.y = 2;
            point4.x = 7;
            point4.y = 2;
            break;
        case 6://向右闪电
            point1.x = 6;
            point1.y = 1;
            point2.x = 7;
            point2.y = 1;
            point3.x = 7;
            point3.y = 0;
            point4.x = 8;
            point4.y = 0;
        default:
            break;
    }
}

- (void)setSquareBtnHidden:(BOOL)hidden{
    AppDelegate *dele = [UIApplication sharedApplication].delegate;
    ViewController *ctl = dele.viewController;
    
    UIButton *b1 = (UIButton *)[ctl.customView viewWithTag:14*point1.y +point1.x +100];
    UIButton *b2 = (UIButton *)[ctl.customView viewWithTag:14*point2.y +point2.x +100];
    UIButton *b3 = (UIButton *)[ctl.customView viewWithTag:14*point3.y +point3.x +100];
    UIButton *b4 = (UIButton *)[ctl.customView viewWithTag:14*point4.y +point4.x +100];
    
    b1.backgroundColor = [self myColour];
    b2.backgroundColor = [self myColour];
    b3.backgroundColor = [self myColour];
    b4.backgroundColor = [self myColour];
    
    b1.alpha = 0.5;
    b2.alpha = 0.5;
    b3.alpha = 0.5;
    b4.alpha = 0.5;

    b1.hidden = hidden;
    b2.hidden = hidden;
    b3.hidden = hidden;
    b4.hidden = hidden;
}

- (UIColor *)myColour{
    switch (_numSquare) {
        case 0:
            return [UIColor greenColor];
        case 1:
            return [UIColor blueColor];
        case 2:
            return [UIColor cyanColor];
        case 3:
            return [UIColor redColor];
        case 4:
            return [UIColor yellowColor];
        case 5:
            return [UIColor orangeColor];
        case 6:
            return [UIColor magentaColor];
    }
    return [UIColor blackColor];
}
- (BOOL)getBtnStatusX:(NSInteger)x andY:(NSInteger)y{
    AppDelegate *dele = [UIApplication sharedApplication].delegate;
    ViewController *ctl = dele.viewController;
    UIButton *b = (UIButton *)[ctl.customView viewWithTag:14*y +x +100];
    return b.hidden;
}

- (BOOL)beyoundBoundsX:(NSInteger)x andY:(NSInteger)y{
//    越界  如果下一行有按钮也不会往下掉
    if (x < 0 || x > 13 || y > 19 || ![self getBtnStatusX:x andY:y]) {
        return YES;
    }
    return NO;
}

- (void)moveDown{
    //    先隐藏 然后自加 最后显示
    [self setSquareBtnHidden:YES];
    
//    判断是否越界
    if ([self beyoundBoundsX:point1.x andY:point1.y+1] ||
        [self beyoundBoundsX:point2.x andY:point2.y+1] ||
        [self beyoundBoundsX:point3.x andY:point3.y+1] ||
        [self beyoundBoundsX:point4.x andY:point4.y+1]) {
        
        [self setSquareBtnHidden:NO];

//        准备下一个代理
        if(_delegate && [_delegate respondsToSelector:@selector(squareMoveToBottom)])
        {
            [_delegate performSelector:@selector(squareMoveToBottom)];
        }
        return;
    }
    point1.y++;
    point2.y++;
    point3.y++;
    point4.y++;
    [self setSquareBtnHidden:NO];
}

- (void)moveLeft{
    [self setSquareBtnHidden:YES];

    if ([self beyoundBoundsX:point1.x-1 andY:point1.y] ||
        [self beyoundBoundsX:point2.x-1 andY:point2.y] ||
        [self beyoundBoundsX:point3.x-1 andY:point3.y] ||
        [self beyoundBoundsX:point4.x-1 andY:point4.y]) {
        
        [self setSquareBtnHidden:NO];
        return;
    }
    point1.x--;
    point2.x--;
    point3.x--;
    point4.x--;
    [self setSquareBtnHidden:NO];
}

- (void)moveRight{
    [self setSquareBtnHidden:YES];
    
    if ([self beyoundBoundsX:point1.x+1 andY:point1.y] ||
        [self beyoundBoundsX:point2.x+1 andY:point2.y] ||
        [self beyoundBoundsX:point3.x+1 andY:point3.y] ||
        [self beyoundBoundsX:point4.x+1 andY:point4.y]) {
        
        [self setSquareBtnHidden:NO];
        return;
    }
    point1.x++;
    point2.x++;
    point3.x++;
    point4.x++;
    [self setSquareBtnHidden:NO];
}

- (void)rotationSquare{
    [self setSquareBtnHidden:YES];
    switch (_numSquare) {
        case 0:
            [self change0];
            break;
        case 1:
            break;
        case 2:
            [self change2];
            break;
        case 3:
            [self change3];
            break;
        case 4:
            [self change4];
            break;
        case 5:
            [self change5];
            break;
        case 6:
            [self change6];
        default:
            break;
    }
    [self setSquareBtnHidden:NO];

}

- (void)change0{
    if (_status == 0) {
        if ([self beyoundBoundsX:point2.x-1 andY:point2.y+1]||
            [self beyoundBoundsX:point3.x-2 andY:point3.y+2]||
            [self beyoundBoundsX:point4.x-3 andY:point4.y+3]) {
            
            [self setSquareBtnHidden:NO];
            return;
        }
        point2.x-=1;
        point2.y+=1;
        point3.x-=2;
        point3.y+=2;
        point4.x-=3;
        point4.y+=3;
        _status = 1;
    } else {
        if ([self beyoundBoundsX:point2.x+1 andY:point2.y-1]||
            [self beyoundBoundsX:point3.x+2 andY:point3.y-2]||
            [self beyoundBoundsX:point4.x+3 andY:point4.y-3]) {
            
            [self setSquareBtnHidden:NO];
            return;
        }
        point2.x+=1;
        point2.y-=1;
        point3.x+=2;
        point3.y-=2;
        point4.x+=3;
        point4.y-=3;
        _status = 0;
    }
}

- (void)change2{
    if (_status == 0) {
        if ([self beyoundBoundsX:point1.x+1 andY:point1.y]||
            [self beyoundBoundsX:point2.x andY:point2.y+1]||
            [self beyoundBoundsX:point3.x-1 andY:point3.y]||
            [self beyoundBoundsX:point4.x-2 andY:point4.y+1]) {
            
            [self setSquareBtnHidden:NO];
            return;
        }
        point1.x+=1;
        point3.x-=1;
        point2.y+=1;
        point4.x-=2;
        point4.y+=1;
        _status = 1;
    } else {
        if ([self beyoundBoundsX:point1.x-1 andY:point1.y]||
            [self beyoundBoundsX:point2.x andY:point2.y-1]||
            [self beyoundBoundsX:point3.x+1 andY:point3.y]||
            [self beyoundBoundsX:point4.x+2 andY:point4.y-1]) {
            
            [self setSquareBtnHidden:NO];
            return;
        }
        point1.x-=1;
        point3.x+=1;
        point2.y-=1;
        point4.x+=2;
        point4.y-=1;
        _status = 0;
    }
}

- (void)change3{
    switch (_status) {
        case 0:
            if ([self beyoundBoundsX:point2.x+1 andY:point2.y]||
                [self beyoundBoundsX:point2.x andY:point2.y-1]||
                [self beyoundBoundsX:point3.x-1 andY:point3.y]||
                [self beyoundBoundsX:point4.x-2 andY:point4.y+1]) {
                
                [self setSquareBtnHidden:NO];
                return;
            }
            point1.x+=1;
            point2.y-=1;
            point3.x-=1;
            point4.x-=2;
            point4.y+=1;
            _status = 1;
                break;
        case 1:
            if ([self beyoundBoundsX:point1.x+1 andY:point1.y+1]||
                [self beyoundBoundsX:point2.x+2 andY:point2.y]||
                [self beyoundBoundsX:point3.x+1 andY:point3.y-1]||
                [self beyoundBoundsX:point4.x andY:point4.y-2]) {
                
                [self setSquareBtnHidden:NO];
                return;
            }
            point1.x+=1;
            point1.y+=1;
            point2.x+=2;
            point3.x+=1;
            point3.y-=1;
            point4.y-=2;
            _status = 2;
            break;
        case 2:
            if ([self beyoundBoundsX:point1.x-2 andY:point1.y+1]||
                [self beyoundBoundsX:point2.x-1 andY:point2.y+2]||
                [self beyoundBoundsX:point3.x andY:point3.y+1]||
                [self beyoundBoundsX:point4.x+1 andY:point4.y]) {
                
                [self setSquareBtnHidden:NO];
                return;
            }
            point1.x-=2;
            point1.y+=1;
            point2.x-=1;
            point2.y+=2;
            point3.y+=1;
            point4.x+=1;
            _status = 3;
            break;
        case 3:
            if ([self beyoundBoundsX:point1.x andY:point1.y-2]||
                [self beyoundBoundsX:point2.x-1 andY:point2.y-1]||
                [self beyoundBoundsX:point3.x andY:point3.y]||
                [self beyoundBoundsX:point4.x+1 andY:point4.y+1]) {
                
                [self setSquareBtnHidden:NO];
                return;
            }
            point1.y-=2;
            point2.x-=1;
            point2.y-=1;
            point4.x+=1;
            point4.y+=1;
            _status = 0;
            break;
        default:
            break;
    }
}

- (void)change4{
    switch (_status) {
        case 0:
            if ([self beyoundBoundsX:point1.x andY:point1.y+1]||
                [self beyoundBoundsX:point2.x andY:point2.y-1]||
                [self beyoundBoundsX:point3.x-1 andY:point3.y]||
                [self beyoundBoundsX:point4.x-2 andY:point4.y+1]) {
                
                [self setSquareBtnHidden:NO];
                return;
            }
            point1.y+=1;
            point2.y-=1;
            point3.x-=1;
            point4.x-=2;
            point4.y+=1;
            _status = 1;
            break;
        case 1:
            if ([self beyoundBoundsX:point1.x andY:point1.y]||
                [self beyoundBoundsX:point2.x+2 andY:point2.y]||
                [self beyoundBoundsX:point3.x+1 andY:point3.y-1]||
                [self beyoundBoundsX:point4.x andY:point4.y-2]) {
                
                [self setSquareBtnHidden:NO];
                return;
            }
            point2.x+=2;
            point3.x+=1;
            point3.y-=1;
            point4.y-=2;
            _status = 2;
            break;
        case 2:
            if ([self beyoundBoundsX:point1.x-1 andY:point1.y]||
                [self beyoundBoundsX:point2.x-1 andY:point2.y+2]||
                [self beyoundBoundsX:point3.x andY:point3.y+1]||
                [self beyoundBoundsX:point4.x+1 andY:point4.y]) {
                
                [self setSquareBtnHidden:NO];
                return;
            }
            point1.x-=1;
            point2.x-=1;
            point2.y+=2;
            point3.y+=1;
            point4.x+=1;
            _status = 3;
            break;
        case 3:
            if ([self beyoundBoundsX:point1.x+1 andY:point1.y-1]||
                [self beyoundBoundsX:point2.x-1 andY:point2.y-1]||
                [self beyoundBoundsX:point3.x andY:point3.y]||
                [self beyoundBoundsX:point4.x+1 andY:point4.y+1]) {
                
                [self setSquareBtnHidden:NO];
                return;
            }
            point1.x+=1;
            point1.y-=1;
            point2.x-=1;
            point2.y-=1;
            point4.x+=1;
            point4.y+=1;
            _status = 0;
            break;
        default:
            break;
    }
}

- (void)change5{
    switch (_status) {
        case 0:
            if ([self beyoundBoundsX:point1.x+2 andY:point1.y]||
                [self beyoundBoundsX:point2.x+1 andY:point2.y-1]||
                [self beyoundBoundsX:point3.x andY:point3.y-2]||
                [self beyoundBoundsX:point4.x-1 andY:point4.y-1]) {
                
                [self setSquareBtnHidden:NO];
                return;
            }
            point1.x+=2;
            point2.x+=1;
            point2.y-=1;
            point3.y-=2;
            point4.x-=1;
            point4.y-=1;
            _status = 1;
            break;
        case 1:
            if ([self beyoundBoundsX:point1.x-1 andY:point1.y+2]||
                [self beyoundBoundsX:point2.x andY:point2.y+1]||
                [self beyoundBoundsX:point3.x+1 andY:point3.y]||
                [self beyoundBoundsX:point4.x andY:point4.y-1]) {
                
                [self setSquareBtnHidden:NO];
                return;
            }
            point1.x-=1;
            point1.y+=2;
            point2.y+=1;
            point3.x+=1;
            point4.y-=1;
            _status = 2;
            break;
        case 2:
            if ([self beyoundBoundsX:point1.x-1 andY:point1.y-1]||
                [self beyoundBoundsX:point2.x andY:point2.y]||
                [self beyoundBoundsX:point3.x+1 andY:point3.y+1]||
                [self beyoundBoundsX:point4.x+2 andY:point4.y]) {
                
                [self setSquareBtnHidden:NO];
                return;
            }
            point1.x-=1;
            point1.y-=1;
            point3.x+=1;
            point3.y+=1;
            point4.x+=2;
            _status = 3;
            break;
        case 3:
            if ([self beyoundBoundsX:point1.x andY:point1.y-1]||
                [self beyoundBoundsX:point2.x-1 andY:point2.y]||
                [self beyoundBoundsX:point3.x-2 andY:point3.y+1]||
                [self beyoundBoundsX:point4.x-1 andY:point4.y+2]) {
                
                [self setSquareBtnHidden:NO];
                return;
            }
            point1.y-=1;
            point2.x-=1;
            point3.x-=2;
            point3.y+=1;
            point4.x-=1;
            point4.y+=2;
            _status = 0;
            break;
        default:
            break;
    }

}
- (void)change6{
    if (_status == 0) {
        if ([self beyoundBoundsX:point1.x andY:point1.y-1]||
            [self beyoundBoundsX:point2.x-1 andY:point2.y]||
            [self beyoundBoundsX:point3.x andY:point3.y+1]||
            [self beyoundBoundsX:point4.x-1 andY:point4.y+2]) {
            
            [self setSquareBtnHidden:NO];
            return;
        }
        point1.y-=1;
        point3.y+=1;
        point2.x-=1;
        point4.x-=1;
        point4.y+=2;
        _status = 1;
    } else {
        if ([self beyoundBoundsX:point1.x andY:point1.y+1]||
            [self beyoundBoundsX:point2.x+1 andY:point2.y]||
            [self beyoundBoundsX:point3.x andY:point3.y-1]||
            [self beyoundBoundsX:point4.x+1 andY:point4.y-2]) {
            
            [self setSquareBtnHidden:NO];
            return;
        }
        point1.y+=1;
        point3.y-=1;
        point2.x+=1;
        point4.x+=1;
        point4.y-=2;
        _status = 0;
    }

}
@end
