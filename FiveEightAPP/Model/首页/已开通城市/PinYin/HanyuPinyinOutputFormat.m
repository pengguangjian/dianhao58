//
//  HanyuPinyinOutputFormat.h
//  MeiShi
//
//  Created by caochun on 16/9/9.
//  Copyright © 2016年 More. All rights reserved.
//

#include "HanyuPinyinOutputFormat.h"

@implementation HanyuPinyinOutputFormat
@synthesize vCharType=_vCharType;
@synthesize caseType=_caseType;
@synthesize toneType=_toneType;

- (id)init {
  if (self = [super init]) {
    [self restoreDefault];
  }
  return self;
}

- (void)restoreDefault {
    _vCharType = VCharTypeWithUAndColon;
    _caseType = CaseTypeLowercase;
    _toneType = ToneTypeWithToneNumber;
}

@end
