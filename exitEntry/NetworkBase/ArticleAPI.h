//
//  ArticleAPI.h
//  exitEntry
//
//  Created by 尹楠 on 17/3/19.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "CommonAPI.h"

@interface ArticleAPI : CommonAPI

- (void)getRecommendCultures;
- (void)getRecommendArticles;
- (void)getArticlesWithColumnId:(NSInteger)columnId page:(NSInteger)page;
- (void)getArticle:(NSInteger)articleId;

@end
