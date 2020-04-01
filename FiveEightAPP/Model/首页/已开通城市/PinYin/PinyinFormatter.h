//  MeiShi
//
//  Created by caochun on 16/9/9.
//  Copyright © 2016年 More. All rights reserved.
//

#ifndef _PinyinFormatter_H_
#define _PinyinFormatter_H_

@class HanyuPinyinOutputFormat;

@interface PinyinFormatter : NSObject {
}

+ (NSString *)formatHanyuPinyinWithNSString:(NSString *)pinyinStr
                withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat;
+ (NSString *)convertToneNumber2ToneMarkWithNSString:(NSString *)pinyinStr;
- (id)init;
@end

#endif // _PinyinFormatter_H_
