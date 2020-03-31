//
//  BinaryRearrangement.h
//  BinaryRearrangement
//
//  Created by 123 on 2020/3/31.
//  Copyright © 2020 Apparitionqk. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 1、Scheme -> Run -> Environment Variables ->  添加 "DYLD_PRINT_STATISTICS"，打印启动时间
 2、TARGETS -> Build Setting -> Other C Flags -> (OC:-fsanitize-coverage=func,trace-pc-guard); (swift :-sanitize-coverage=undefined) clang加载重排代码
 3、在合适的地方导入头文件，初始化并调用rearrangement
 4、运行，取出order文件
       Window -> Devices and Simulators -> INSTALLED APPS -> 选中APP -> 设置按钮 -> Download Containers -> 显示包内容 -> AppData -> tmp -> *.order
 5、将order文件移动到项目根目录
 6、TARGETS -> Build Setting -> Order File -> 填写文件路径或者将文件拖过去
 */
@interface BinaryRearrangement : NSObject
- (void)rearrangement;
@end
