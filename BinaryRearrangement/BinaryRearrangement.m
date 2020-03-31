//
//  BinaryRearrangement.m
//  BinaryRearrangement
//
//  Created by 123 on 2020/3/31.
//  Copyright © 2020 Apparitionqk. All rights reserved.
//

#import "BinaryRearrangement.h"
#import <dlfcn.h>
#import <libkern/OSAtomic.h>

@implementation BinaryRearrangement
//二进制重排
- (void)rearrangement {
    NSMutableArray <NSString *> *symbolsNames = [NSMutableArray array];
       while (YES) {
           SYNode *node = OSAtomicDequeue(&symbollist, offsetof(SYNode, next));
           if (node == NULL) {
               break;
           }
           Dl_info info;
           dladdr(node->pc, &info);
           NSString *symbolName = @(info.dli_sname);
           BOOL isObjcMethod = [symbolName hasPrefix:@"-["] || [symbolName hasPrefix:@"-["];
           NSString *adjustName = isObjcMethod ? symbolName : [@"_" stringByAppendingString:symbolName];
           [symbolsNames addObject:adjustName];
       };
    //去重
    NSEnumerator *ent = [symbolsNames reverseObjectEnumerator];
    //取反
    NSMutableArray <NSString *>*funcs = [NSMutableArray arrayWithCapacity:symbolsNames.count];
    NSString *entName;
    while (entName = [ent nextObject]) {
        if (![funcs containsObject:entName]) {
            [funcs addObject:entName];
        }
    }
    //去掉当前函数
    NSString *currentFunction = [NSString stringWithFormat:@"%s", __FUNCTION__];
    [funcs removeObject:currentFunction];
    //数组变为字符串
    NSString *orderContent = [funcs componentsJoinedByString:@"\n"];
    //写入文件
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Apparitionqk.order"];
    NSError *error = nil;
    BOOL writeSuccess = [orderContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"orderContent == %@\n writeSuccess == %@", funcs, writeSuccess ? filePath : error.localizedDescription);
}
void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                                    uint32_t *stop) {
  static uint64_t N;  // Counter for the guards.
  if (start == stop || *start) return;  // Initialize only once.
  printf("INIT: %p %p\n", start, stop);
  for (uint32_t *x = start; x < stop; x++)
    *x = ++N;  // Guards should start from 1.
}

//原子队列
static OSQueueHead symbollist = OS_ATOMIC_QUEUE_INIT;
//定义结构体
typedef struct {
    void *pc;
    void *next;
}SYNode;

void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
    if (!*guard) return;
    // Duplicate the guard check.
  // If you set *guard to 0 this code will not be called again for this edge.
  // Now you can get the PC and do whatever you want:
  //   store it somewhere or symbolize it and print right away.
  // The values of `*guard` are as you set them in
  // __sanitizer_cov_trace_pc_guard_init and so you can make them consecutive
  // and use them to dereference an array or a bit vector.
    void *PC = __builtin_return_address(0);
//    char PcDescr[1024];
//
    SYNode *node = malloc(sizeof(SYNode));
    *node = (SYNode){PC, NULL};
    OSAtomicEnqueue(&symbollist, node, offsetof(SYNode, next));
}
@end
