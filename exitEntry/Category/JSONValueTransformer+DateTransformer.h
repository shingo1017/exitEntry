//
//  DateTransformer.h
//  copybook
//
//  Created by 尹楠 on 16/12/28.
//  Copyright © 2016年 尹楠. All rights reserved.
//

#import "JSONValueTransformer+DateTransformer.h"
#import "JSONModel.h"

@interface JSONValueTransformer (DateTransformer)

-(NSDate*)__NSDateFromNSString:(NSString*)string;
-(NSString*)__JSONObjectFromNSDate:(NSDate*)date;

@end
