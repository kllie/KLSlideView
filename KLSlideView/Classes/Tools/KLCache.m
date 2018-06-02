//
//  KLCache.m
//  KLSlideView
//
//  Created by neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//

#import "KLCache.h"

@interface KLCache ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, assign) NSInteger capacity;

@end

@implementation KLCache

- (id)initWithCount:(NSInteger)count {
    if (self = [super init]) {
        _capacity = 3;
        if (count > 0) {
            _capacity = count;
        }
        _dictionary = [NSMutableDictionary dictionaryWithCapacity:_capacity];
        _keys = [NSMutableArray arrayWithCapacity:_capacity];
    }
    return self;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    if (![_keys containsObject:key]) {
        if (_keys.count < _capacity) {
            [_dictionary setValue:object forKey:key];
            [_keys addObject:key];
        } else {
            NSString *longTimeUnusedKey = [_keys firstObject];
            [_dictionary setValue:nil forKey:longTimeUnusedKey];
            [_keys removeObjectAtIndex:0];

            [_dictionary setValue:object forKey:key];
            [_keys addObject:key];
        }
    } else {
        [_dictionary setValue:object forKey:key];
        [_keys removeObject:key];
        [_keys addObject:key];
    }
}

- (id)objectForKey:(NSString *)key {
    if ([_keys containsObject:key]) {
        [_keys removeObject:key];
        [_keys addObject:key];

        return [_dictionary objectForKey:key];
    } else {
        return nil;
    }
}

@end
