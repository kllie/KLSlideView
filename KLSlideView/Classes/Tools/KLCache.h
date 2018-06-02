//
//  KLCache.h
//  KLSlideView
//
//  Created by neville on 2017/7/11.
//  Copyright © 2017年 anywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLCacheProtocol.h"

@interface KLCache : NSObject <KLCacheProtocol>

/**
 create a KLCache object

 @param count The count of cache, Usually the same as the TabbarItem number, Default is 3
 @return KLCache object
 */
- (id)initWithCount:(NSInteger)count;

// -----------------
//  KLCacheProtocol
// -----------------

- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

@end
