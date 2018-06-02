//
//  KLCacheProtocol.h
//  KLSlideView
//
//  Created by neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KLCacheProtocol <NSObject>

/**
 Setter

 @param object object
 @param key key
 */
- (void)setObject:(id)object forKey:(NSString *)key;

/**
 Getter

 @param key key
 @return object
 */
- (id)objectForKey:(NSString *)key;

@end
