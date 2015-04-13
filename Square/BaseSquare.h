//
//  BaseSquare.h
//  Square
//
//  Created by qianfeng on 13-11-12.
//  Copyright (c) 2013年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

//描述一个按钮的位置
typedef struct Square{
    NSInteger x;
    NSInteger y;
}Square;

/*
 A对象 发送消息-> B对象
 A是被代理 B是代理
 
 在被代理中
 1. 声明一个协议 (N组接口) 不需要实现
 2. id <xxx协议> delegate 成员变量 实现它的点语法
 3. 通知代理方法
    if(delegate && [delegate respsonseSelector(xxx)])
    {
        [delegate perfromSelector(xxx)];
    }
    
 在代理中
 1. 遵守<xxx>协议
 2. 设置代理 a.delegate =b;
 3. 实现接口
 */
@protocol SquareMoveToBottom <NSObject>
- (void)squareMoveToBottom;
@end

//- (void) squareMoveToBottom
//一个方块的位置
@interface BaseSquare : NSObject
{
    Square point1;
    Square point2;
    Square point3;
    Square point4;
}

@property (nonatomic, retain)id <SquareMoveToBottom>delegate;
@property (nonatomic, assign) NSInteger numSquare;
@property (nonatomic, assign) NSInteger status;
- (void)moveDown;
- (void)moveLeft;
- (void)moveRight;
- (void)setSquareBtnHidden:(BOOL)hidden;
- (BOOL)getBtnStatusX:(NSInteger)x andY:(NSInteger)y;
- (BOOL)beyoundBoundsX:(NSInteger)x andY:(NSInteger)y;
- (void)rotationSquare;

@end
