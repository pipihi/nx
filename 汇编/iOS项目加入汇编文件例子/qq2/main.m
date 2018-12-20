//
//  main.m
//  qq
//
//  Created by Beauty-jishu on 2018/11/23.
//  Copyright © 2018年 Beauty-jishu. All rights reserved.
//

@import Foundation;
#import <OpenGLESImage/OpenGLESImage.h>

#import <stdio.h>

extern int add(int a, int b);


int main(int argc, const char * argv[]) {
    
    int c = add(1, 2);
    printf("c=%d", c);
    
    return 0;
}

