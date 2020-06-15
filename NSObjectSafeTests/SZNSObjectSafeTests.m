//
//  SZNSObjectSafeTests.m
//  SZNSObjectSafeTests
//
//  Created by hsz on 2018/10/19.
//  Copyright © 2018 Welltang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>

/*
 模拟器测试 iPhone 11 Pro Max    iOS13
 */
@interface TestObject : NSObject

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString *name;

@end

@implementation TestObject

@end

@interface SZNSObjectSafeTests : XCTestCase

@end

@implementation SZNSObjectSafeTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testNull {
    [NSNull performSelector:@selector(test)];
    [NSNull performSelector:@selector(array)];
    [[NSNull new] performSelector:@selector(test:) withObject:@1];
    [[NSNull new] performSelector:@selector(addObject:) withObject:@1];
}

- (void)testCache {
    NSCache *cache = [[NSCache alloc] init];
    
    [cache setObject:nil forKey:@"test"];
    [cache setObject:@1 forKey:nil];// 不会crash
    
    [cache setObject:nil forKey:@"test" cost:1];
    [cache setObject:@1 forKey:nil cost:1];// 不会crash
}

- (void)testUserdefault {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:@1 forKey:nil];// 不会crash
    [userDefault setObject:nil forKey:@"test"];// 不会crash
    
    id result1 = [userDefault objectForKey:nil];// 不会crash
    id result2 = [userDefault objectForKey:@"test"];// 不会crash
    
    [userDefault removeObjectForKey:nil];// 不会crash
    [userDefault removeObjectForKey:@"test"];// 不会crash
    
    // 非(NSString, NSData, NSNumber, NSDate, NSArray, and NSDictionary)对象
    [userDefault setObject:[NSObject new] forKey:@"test"];
}

- (void)testSetAndMutableSet {
    NSSet *set = [NSSet setWithObject:nil];
    NSMutableSet *mutableSet = [NSMutableSet setWithObject:nil];
    
    NSMutableSet *mutableSet1 = [NSMutableSet set];
    [mutableSet1 addObject:nil];
    [mutableSet1 removeObject:nil];
}

- (void)testOrderSetAndMutableOrderSet {
    NSOrderedSet *placeOrderSet = [NSOrderedSet alloc];
//    NSLog(@"%@ --- %@", placeOrderSet, placeOrderSet.class);

    NSOrderedSet *orderSet = [[NSOrderedSet alloc] init];
    NSLog(@"%@ --- %@", orderSet, orderSet.class);

    [placeOrderSet initWithObject:nil];
    [NSOrderedSet orderedSetWithObject:nil];
    id obj = [orderSet objectAtIndex:100];
    
    NSMutableOrderedSet *mutableOrderSet = [NSMutableOrderedSet orderedSetWithObject:nil];
    id obj2 = [mutableOrderSet objectAtIndex:100];
    [mutableOrderSet addObject:nil];
    [mutableOrderSet insertObject:nil atIndex:0];
    [mutableOrderSet insertObject:[NSObject new] atIndex:100];
    [mutableOrderSet removeObject:nil];// 不会crash
    [mutableOrderSet removeObjectAtIndex:100];
    [mutableOrderSet replaceObjectAtIndex:100 withObject:[NSObject new]];
    [mutableOrderSet replaceObjectAtIndex:0 withObject:nil];
}

- (void)testDictionaryAndMutableDictionary {
    NSObject *obj = nil;
    
    // __NSDictionary0
    NSDictionary *dic0 = @{@"key":obj};
    NSDictionary *dic1 = [NSDictionary dictionaryWithObject:obj forKey:@"key"];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:obj, @"key", nil];// 不会crash
    NSDictionary *dic3 = [[NSDictionary alloc] initWithDictionary:nil];// 不会crash
    NSDictionary *dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:obj, @"key", nil];// 不会crash
    NSLog(@"%@  %@", dic0, dic0.class);
    NSLog(@"%@  %@", dic1, dic1.class);
    NSLog(@"%@  %@", dic2, dic2.class);
    NSLog(@"%@  %@", dic3, dic3.class);
    NSLog(@"%@  %@", dic4, dic4.class);
    
    // __NSDictionaryM
    NSMutableDictionary *dic5 = @{@"1":@2}.mutableCopy;
    NSLog(@"%@  %@", dic5, dic5.class);
    [dic5 setObject:nil forKey:@"test"];
    [dic5 setObject:@1 forKey:nil];
    [dic5 removeObjectForKey:nil];
    [dic5 setObject:nil forKeyedSubscript:@"test"];// 不会crash
    [dic5 setObject:@1 forKeyedSubscript:nil];
    
    // __NSPlaceholderDictionary (类簇)
    NSDictionary *dic6 = [NSDictionary alloc];
//    NSLog(@"%@  %@", dic6, dic6.class);
}

- (void)testArrayAndMutableArray {
    // __NSCFArray __NSArrayReversed __NSFrozenArrayM __NSArrayI_Transfer未测试
    NSObject *obj = nil;
    NSArray *arr = [NSArray arrayWithObject:nil];
    NSArray *ar = @[obj];
    
    NSLog(@"start");
    NSArray *arr0 = [NSArray array];// __NSArray0
    NSLog(@"%@  ---  %@", arr0, arr0.class);
    NSArray *arr1 = @[@1, @2];// __NSArrayI
    NSLog(@"%@  ---  %@", arr1, arr1.class);
    NSArray *arr2 = @[[NSObject new]];// __NSSingleObjectArrayI
    NSLog(@"%@  ---  %@", arr2, arr2.class);
    NSArray *arr3 = @[@1];// __NSSingleObjectArrayI
    NSLog(@"%@  ---  %@", arr3, arr3.class);
    NSArray *arr4 = [NSArray alloc];// __NSPlaceholderArray
//    NSLog(@"%@  ---  %@", arr4, arr4.class);
    
    NSArray *tempArr1 = @[arr0, arr1, arr2, arr3];
    for (NSArray *a in tempArr1) {
        [a objectAtIndex:100];
        [a subarrayWithRange:NSMakeRange(0, 100)];
        [a objectAtIndexedSubscript:100];
    }
    
    NSMutableArray *arr5 = @[].mutableCopy;
    NSLog(@"%@  ---  %@", arr5, arr5.class);
    NSMutableArray *arr6 = [NSMutableArray arrayWithArray:arr5];
    NSLog(@"%@  ---  %@", arr6, arr6.class);
    
    NSArray *tempArr2 = @[arr5, arr6];
    for (NSMutableArray *ma in tempArr2) {
        [ma objectAtIndex:100];
        [ma objectAtIndexedSubscript:100];
        [ma subarrayWithRange:NSMakeRange(0, 100)];
        
        [ma addObject:nil];
        
        [ma insertObject:nil atIndex:0];
        [ma insertObject:@5 atIndex:100];
        
        [ma removeObject:nil];// 不会crash
        [ma removeObjectAtIndex:100];
        
        [ma replaceObjectAtIndex:0 withObject:nil];
        [ma replaceObjectAtIndex:100 withObject:@5];
        
        [ma removeObjectsInRange:NSMakeRange(20, 100)];
    }
}

- (void)testDataAndMutableData {
    // __NSCFData _NSInlineData
    NSData *data1 = [NSData data];// _NSZeroData
    NSLog(@"%@ --- %@", data1, data1.class);
    NSData *data2 = [NSData alloc];// _NSPlaceholderData
//    NSLog(@"%@ --- %@", data2, data2.class);
    NSMutableData *data3 = [NSMutableData data];// NSConcreteMutableData
    NSLog(@"%@ --- %@", data3, data3.class);
    NSMutableData *data4 = [NSMutableData alloc];// NSConcreteMutableData
    NSLog(@"%@ --- %@", data4, data4.class);
    
    NSArray *tempArr = @[data1];
    for (NSData *data in tempArr) {
        [data subdataWithRange:NSMakeRange(100, 100)];
        [data rangeOfData:nil options:NSDataSearchAnchored range:NSMakeRange(100, 100)];
    }
    
    [data3 resetBytesInRange:NSMakeRange(100, 100)];
    [data3 replaceBytesInRange:NSMakeRange(100, 100) withBytes:"abc"];
    [data3 replaceBytesInRange:NSMakeRange(100, 100) withBytes:"abc" length:100];
    [data3 rangeOfData:nil options:NSDataSearchAnchored range:NSMakeRange(100, 100)];
    [data3 subdataWithRange:NSMakeRange(100, 100)];
}

- (void)testAttributeStringAndMutableAttributeString {
    NSAttributedString *s1 = [NSAttributedString alloc];// NSConcreteAttributedString
    NSLog(@"%@ --- %@", s1, s1.class);
    
    NSMutableAttributedString *s2 = [NSMutableAttributedString alloc];// NSConcreteMutableAttributedString
    NSLog(@"%@ --- %@", s2, s2.class);
    
    NSAttributedString *s3 = [[NSAttributedString alloc] initWithString:@"abc" attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];// NSConcreteAttributedString
    NSLog(@"%@ --- %@", s3, s3.class);
    
    NSMutableAttributedString *s4 = [[NSMutableAttributedString alloc] initWithString:@"abc" attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];// NSConcreteMutableAttributedString
    NSLog(@"%@ --- %@", s4, s4.class);
    
    [s4 appendAttributedString:nil];
    
    // NSConcreteAttributedString & NSConcreteMutableAttributedString init
    NSArray *tempArr1 = @[s1, s2];
    for (NSAttributedString *s in tempArr1) {
        NSAttributedString *s11 = [s initWithString:nil];
        NSAttributedString *s12 = [s initWithAttributedString:nil];
        NSAttributedString *s13 = [s initWithString:nil attributes:@{}];
        NSLog(@"%@ %@ %@", s11, s12, s13);
    }
    
    // NSConcreteAttributedString & NSConcreteMutableAttributedString out of range
    NSArray *tempArr2 = @[s3, s4];
    for (NSAttributedString *s in tempArr2) {
        NSAttributedString *ss = [s attributedSubstringFromRange:NSMakeRange(0, 100)];
        NSRange range1;
        [s attribute:NSForegroundColorAttributeName atIndex:100 effectiveRange:&range1];
        [s enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, 100) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {

        }];
        [s enumerateAttributesInRange:NSMakeRange(0, 100) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {

        }];
        NSLog(@"%@ %@", ss, s);
    }
    
    
    // NSConcreteMutableAttributedString
    [s4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 100)];// out of range
    [s4 addAttribute:NSFontAttributeName value:nil range:NSMakeRange(0, 1)];// nil value
    [s4 addAttribute:nil value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];// nil key // 不会crash
    [s4 addAttributes:@{} range:NSMakeRange(0, 100)];// out of range
    [s4 addAttributes:nil range:NSMakeRange(0, 1)];// nil attribute
    [s4 setAttributes:@{} range:NSMakeRange(0, 100)];// out of range
    [s4 setAttributes:nil range:NSMakeRange(0, 1)];// nil attribute // 不会crash
    [s4 removeAttribute:@{} range:NSMakeRange(0, 100)];// // out of range
    [s4 removeAttribute:nil range:NSMakeRange(0, 1)];// nil attribute
    [s4 deleteCharactersInRange:NSMakeRange(0, 100)];// out of range
    [s4 replaceCharactersInRange:NSMakeRange(0, 100) withString:@"d"];// // out of range
    [s4 replaceCharactersInRange:NSMakeRange(0, 1) withString:nil];// nil string
    [s4 replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:nil];// nil attributeString
    [s4 replaceCharactersInRange:NSMakeRange(0, 100) withAttributedString:[[NSAttributedString alloc] initWithString:@"d"]];// out of range
}

- (void)testStringAndMutableString {
    NSString *s0 = @"abc";// __NSCFConstantString
    NSLog(@"%@ --- %@", s0, s0.class);
    
    NSString *s1 = [NSString stringWithFormat:@"abc"];// NSTaggedPointerString
    NSLog(@"%@ --- %@", s1, s1.class);
    
    NSMutableString *s2 = [NSMutableString stringWithFormat:@"abcdefghigklmnopqrstuvwxyz"];// __NSCFString
    NSLog(@"%@ --- %@", s2, s2.class);
    
    NSString *s3 = [NSString stringWithFormat:@"abcdefghigklmnopqrstuvwxyz"];// __NSCFString
    NSLog(@"%@ --- %@", s3, s3.class);
    
    NSString *s4 = [NSString alloc];// NSPlaceholderString (类簇)
//    NSLog(@"%@ --- %@", s4, s4.class);// crash (Did you forget to nest alloc and init?)
    
    NSMutableString *s5 = [NSMutableString alloc];// NSPlaceholderMutableString
//    NSLog(@"%@ --- %@", s5, s5.class);// crash (Did you forget to nest alloc and init?)
    
    // stringWithUTF8String:参数传空
    [NSString stringWithUTF8String:NULL];
    [NSMutableString stringWithUTF8String:NULL];
    // stringWithCString:encoding:参数为空
    [NSString stringWithCString:NULL encoding:NSUTF8StringEncoding];
    [NSMutableString stringWithCString:NULL encoding:NSUTF8StringEncoding];
    
    // NSPlaceholderString init 参数为空
    NSArray *tempArr1 = @[s4, s5];
    for (NSString *s in tempArr1) {
        NSString *s41 = [s4 initWithString:nil];
        NSString *s42 = [s4 initWithUTF8String:NULL];
        NSString *s43 = [s4 initWithCString:NULL encoding:NSUTF8StringEncoding];
        NSLog(@"%@ %@ %@", s41, s42, s43);
    }
    
    // __NSCFConstantString & NSTaggedPointerString
    // todo hsz 添加异常抛出
    NSArray *tempArr2 = @[s0, s1];
    for (NSString *s in tempArr2) {
        NSString *s61 = [s stringByAppendingString:nil];
        NSString *s62 = [s substringToIndex:100];
        NSString *s63 = [s substringFromIndex:100];
        NSString *s64 = [s substringWithRange:NSMakeRange(0, 100)];
        NSRange range1 = [s rangeOfString:@"bc" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 100) locale:nil];
        NSLog(@"%@ %@ %@ %@ %@", s61, s62, s63, s64, NSStringFromRange(range1));
    }
    
    // __NSCFString
    [s2 appendString:nil];
    [s2 insertString:@"test" atIndex:100];
    [s2 deleteCharactersInRange:NSMakeRange(10, 100)];
    NSString *s23 = [s2 stringByAppendingString:nil];
    NSString *s24 = [s2 substringFromIndex:100];
    NSString *s25 = [s2 substringToIndex:100];
    NSString *s26 = [s2 substringWithRange:NSMakeRange(0, 100)];
    NSRange range3 = [s2 rangeOfString:@"cd" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 100) locale:nil];
    NSLog(@"%@ %@ %@ %@ %@ %@", s2, s23, s24, s25, s26, NSStringFromRange(range3));
}

// todo hsz StringAndMutableString
- (void)todoAddString {
    //    [s0 stringByAppendingFormat:nil];
    //    [s0 stringsByAppendingPaths:nil];
    //    [s0 stringByAppendingPathComponent:nil];
    //    [s0 stringByAppendingPathExtension:nil];
}

- (void)testNSObject {
    TestObject *testObj = [TestObject new];
    
    // 1.observer
    // 1.1 观察对象为空
    [self addObserver:nil forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];// 不会crash
    // 1.2 keyPath长度为0
    [self addObserver:testObj forKeyPath:@"" options:NSKeyValueObservingOptionNew context:nil];
    // 1.3 观察不存在keyPath
    [self addObserver:testObj forKeyPath:@"age1" options:NSKeyValueObservingOptionNew context:nil];// 不会crash
    
    // 2.Method
    // 2.1 未实现对象方法
    [testObj performSelector:@selector(testFunction)];
    // 2.2 未实现类方法
    [TestObject performSelector:@selector(testFunction)];
    
    // 3.KVC
    // 3.1 设置不存在的key
    [testObj setValue:@1 forKey:@"age1"];
    // 3.2 设置不存在的keyPath
    [testObj setValue:@1 forKeyPath:@"test.age1"];
    // 3.3 获取不存在的key的value
    [testObj valueForKey:@"age1"];
    // 3.4 获取不存在的keyPath的value
    [testObj valueForKeyPath:@"test.age1"];
    // 3.5 设置空值
    [testObj setValue:nil forKey:@"age"];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
