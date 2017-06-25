//
//  ArticleAPI.m
//  exitEntry
//
//  Created by 尹楠 on 17/3/19.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "ArticleAPI.h"

#define GET_ARTICLES_URL        @"api/article"
#define GET_ARTICLE_URL         @"api/article/%zi"

@implementation ArticleAPI

- (void)getRecommendCultures {
    
//    NSArray *mockData = [NSArray arrayWithContentsOfFile:FILE_BUNDLE_PATH(@"getRecommendCultures.plist")];
//    if (nil != self.successBlock)
//        self.successBlock(mockData);
    
    self.requestURL = GET_ARTICLES_URL;
    self.method = NetworkBaseMethodGet;
    self.params = @{ @"type" : @"3" };
    
    [self startRequest];
}

- (void)getRecommendArticles {
    
    self.requestURL = GET_ARTICLES_URL;
    self.method = NetworkBaseMethodGet;
    self.params = @{ @"type" : @"2" };
    self.httpHeaderField = [NetworkBase commonHeaderWithLanguage:@"zh-CN"];
    
    [self startRequest];
}

- (void)getArticlesWithColumnId:(NSInteger)columnId page:(NSInteger)page {
    
    self.requestURL = GET_ARTICLES_URL;
    self.method = NetworkBaseMethodGet;
    self.params = @{
                    @"type" : @(columnId),
                    @"page" : @(page),
                    };
    if (columnId == 2 || columnId == 4)
        self.httpHeaderField = [NetworkBase commonHeaderWithLanguage:@"zh-CN"];
    else {
        
        NSString *lan = ((AppDelegate *)[UIApplication sharedApplication].delegate).language;
        if ([lan isEqualToString:@"zh-Hans"])
            lan = @"zh-CN";
        
        self.httpHeaderField = [NetworkBase commonHeaderWithLanguage:lan];
    }
    
    [self startRequest];
}

- (void)getArticle:(NSInteger)articleId {
    
    self.requestURL = [NSString stringWithFormat:GET_ARTICLE_URL, articleId];
    self.method = NetworkBaseMethodGet;
    
    [self startRequest];
}

@end
