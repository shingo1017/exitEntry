//
//  HomeView.m
//  exitEntry
//
//  Created by 尹楠 on 17/3/15.
//  Copyright © 2017年 尹楠. All rights reserved.
//

#import "HomeView.h"
#import "CommonAPI.h"
#import "ArticleAPI.h"
#import "Banner.h"
#import "BookView.h"
#import "ArticleDetailView.h"
#import "ArticleListView.h"
#import "FeedbackView.h"
#import "CertificateView.h"
#import "UIImage+Additions.h"
#import "MJRefreshComponent+Customize.h"
#import "LoginAPI.h"

@interface HomeView ()

@end

@implementation HomeView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldReloadStatusNotification:) name:K_DID_LOGIN_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldReloadStatusNotification:) name:K_SHOULD_RELOAD_STATUS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldReloadDataNotification:) name:K_SHOULD_RELOAD_DATA_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeLanguageNotification:) name:K_DID_CHANGE_LANGUAGE_NOTIFICATION object:nil];
    
    navigationBarWidget.title = text(@"房山出入境");
    navigationBarWidget.backButtonHidden = YES;
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _bookButton.backgroundColor = MAIN_COLOR;
    
//    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:text(@"涉外法律法规")];
//    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//    UIImage *image = [[UIImage imageNamed:@"法律"] scaleToSizeWithWidth:20];
//    textAttachment.image = image;
//    NSAttributedString *iconAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
//    [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 0) withAttributedString:iconAttributedString];
//    [_regulationButton setAttributedTitle:mutableAttributedString forState:UIControlStateNormal];
    [_regulationButton setTitle:text(@"法律法规") forState:UIControlStateNormal];
    _regulationButton.backgroundColor = MAIN2_COLOR;
    [_messageButton setTitle:text(@"留言板") forState:UIControlStateNormal];
    _messageButton.backgroundColor = MAIN3_COLOR;
    [_proclamationButton setTitle:text(@"公示公告") forState:UIControlStateNormal];
    _proclamationButton.backgroundColor = MAIN_COLOR;
    _proclamationButton.hidden = YES;
    [_serviceButton setTitle:text(@"服务指南") forState:UIControlStateNormal];
    _serviceButton.backgroundColor = MAIN2_COLOR;
    _serviceButton.hidden = YES;
    [_reminderButton setTitle:text(@"温馨提示") forState:UIControlStateNormal];
    _reminderButton.backgroundColor = MAIN2_COLOR;
    _reminderButton.hidden = YES;
    [_moreButton setTitle:text(@"更多") forState:UIControlStateNormal];
    _moreButton.backgroundColor = MAIN3_COLOR;
    _moreButton.hidden = YES;
    
    _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160) delegate:self placeholderImage:nil];
    _bannerView.autoScroll = YES;
    _bannerView.autoScrollTimeInterval = 3.0f;
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [_mainScrollView addSubview:_bannerView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self reloadData];
    }];
    [header.stateLabel setHidden:YES];
    [header.lastUpdatedTimeLabel setHidden:YES];
    [_mainScrollView setMj_header:header];
    
    [self fillData];
    
    [self getBanners];
    [self getRecommendArticles];
    [self getRecommendCultures];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    ((AppDelegate *) [UIApplication sharedApplication].delegate).mainNavigationController = self.navigationController;
    [((MainTabBarController *) self.tabBarController) showNewTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
    
    [[LoginAPI sharedInstance] refreshBookStatus];
    
    [self getBanners];
    [self getRecommendArticles];
    [self getRecommendCultures];
}

- (void)fillData {
    
    if ([User defaultUser].bookStatus == BookStatusNotSubmit)
        [_bookButton setTitle:text(@"境外人员办理注册登记") forState:UIControlStateNormal];
    else if ([User defaultUser].bookStatus == BookStatusCertificateReady)
        [_bookButton setTitle:[NSString stringWithFormat:@"%@\r\n%@", [User defaultUser].bookStatusText, text(@"点此下载电子证书")] forState:UIControlStateNormal];
    else
        [_bookButton setTitle:[User defaultUser].bookStatusText forState:UIControlStateNormal];
    
    [_mainScrollView.mj_header endRefreshing];
}

- (void)getBanners {
    
    CommonAPI *commonAPI = [CommonAPI new];
    [commonAPI setSuccessBlock:^(id result) {
        
        NSArray *banners = [Banner arrayOfModelsFromDictionaries:result error:nil];
        NSMutableArray *bannerImageUrls = [NSMutableArray new];
        for (Banner *banner in banners) {
            
            [bannerImageUrls addObject:banner.imageUrl];
        }
        _bannerView.imageURLStringsGroup = bannerImageUrls;
    }];
    [commonAPI getHomeBanners];
}

- (void)getRecommendCultures {
    
    ArticleAPI *articleAPI = [ArticleAPI new];
    [articleAPI setSuccessBlock:^(id result) {
        
        NSArray *articles = [Article arrayOfModelsFromDictionaries:result[@"data"] error:nil];
        
        [_cultureCollectionSectionWidget removeFromSuperview];
        
        _cultureCollectionSectionWidget = [[CollectionSectionWidget alloc] initWithFrame:CGRectMake(0, _regulationButton.bottom + 10, SCREEN_WIDTH, 0)];
        _cultureCollectionSectionWidget.delegate = self;
        _cultureCollectionSectionWidget.title = text(@"房山旅游文化");
        _cultureCollectionSectionWidget.articles = articles;
        _cultureCollectionSectionWidget.hidden = YES;
        [_mainScrollView addSubview:_cultureCollectionSectionWidget];
        
        [self fitSize];
    }];
    [articleAPI getRecommendCultures];
}

- (void)getRecommendArticles {
    
    ArticleAPI *articleAPI = [ArticleAPI new];
    [articleAPI setSuccessBlock:^(id result) {
        
        NSArray *articles = [Article arrayOfModelsFromDictionaries:result[@"data"] error:nil];
        
        [_regulationTableSectionWidget removeFromSuperview];
        
        _regulationTableSectionWidget = [[TableSectionWidget alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _regulationTableSectionWidget.delegate = self;
        _regulationTableSectionWidget.title = text(@"房山新闻");
        _regulationTableSectionWidget.articles = articles;
        _regulationTableSectionWidget.showDateTime = YES;
        _regulationTableSectionWidget.hidden = YES;
        [_mainScrollView addSubview:_regulationTableSectionWidget];
        
        [self fitSize];
    }];
    [articleAPI getRecommendArticles];
}

- (void)fitSize {
    
    _regulationTableSectionWidget.top = _regulationButton.bottom + 10;
    _regulationTableSectionWidget.height = [_regulationTableSectionWidget suggestHeightWithShowDateTime:YES];
    _regulationTableSectionWidget.hidden = NO;
    
    _cultureCollectionSectionWidget.top = _regulationTableSectionWidget.bottom + 10;
    _cultureCollectionSectionWidget.height = [_cultureCollectionSectionWidget suggestHeight];
    _cultureCollectionSectionWidget.hidden = NO;
    
    _proclamationButton.width = SCREEN_WIDTH / 2 - 1;
    _proclamationButton.left = 0;
    _proclamationButton.top = _cultureCollectionSectionWidget.bottom + 10;
    _proclamationButton.hidden = NO;
    
    _serviceButton.width = SCREEN_WIDTH / 2 - 1;
    _serviceButton.left = _proclamationButton.right + 1;
    _serviceButton.top = _proclamationButton.top;
    _serviceButton.hidden = NO;
    
    _reminderButton.width = SCREEN_WIDTH / 2 - 1;
    _reminderButton.left = _proclamationButton.left;
    _reminderButton.top = _proclamationButton.bottom + 1;
    _reminderButton.hidden = NO;
    
    _moreButton.width = SCREEN_WIDTH / 2 - 1;
    _moreButton.left = _serviceButton.left;
    _moreButton.top = _reminderButton.top;
    _moreButton.hidden = NO;
    
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.width, _reminderButton.bottom + 10);
}

- (IBAction)bookButtonClicked:(id)sender {
    
    if ([User defaultUser].bookStatus == BookStatusNotSubmit || [User defaultUser].bookStatus == BookStatusRejected) {
        
        if ([User checkPermission]) {
            
            //登记注册
            BookView *bookView = [self.storyboard instantiateViewControllerWithIdentifier:@"BookView"];
            [MAIN_NAVIGATIONCONTROLLER pushViewController:bookView animated:YES];
        }
    }
    else if ([User defaultUser].bookStatus == BookStatusCertificateReady) {
        
        CertificateView *certificateView = [self.storyboard instantiateViewControllerWithIdentifier:@"CertificateView"];
        [MAIN_NAVIGATIONCONTROLLER pushViewController:certificateView animated:YES];
    }
}

- (IBAction)regulationButtonClicked:(id)sender {
    
    //法律法规
    ArticleListView *articleListView = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleListView"];
    articleListView.columnId = 1;
    articleListView.title = text(@"法律法规");
    [MAIN_NAVIGATIONCONTROLLER pushViewController:articleListView animated:YES];
}

- (IBAction)messageButtonClicked:(id)sender {
    
    //用户留言
    if ([User checkPermission]) {
        
        FeedbackView *feedbackView = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackView"];
        feedbackView.title = text(@"用户留言");
        [MAIN_NAVIGATIONCONTROLLER pushViewController:feedbackView animated:YES];
    }
}

- (void)didClickedCollectionSectionWidgetMoreButton:(CollectionSectionWidget *)collectionSectionWidget {
    
    //旅游文化
    ArticleListView *articleListView = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleListView"];
    articleListView.columnId = 3;
    articleListView.title = text(@"房山旅游文化");
    [MAIN_NAVIGATIONCONTROLLER pushViewController:articleListView animated:YES];
}

- (void)collectionSectionWidget:(CollectionSectionWidget *)collectionSectionWidget didClickedArticle:(Article *)article {
    
    ArticleDetailView *articleDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleDetailView"];
    articleDetailView.title = article.title;
    articleDetailView.article = article;
    [MAIN_NAVIGATIONCONTROLLER pushViewController:articleDetailView animated:YES];
}

- (void)tableSectionWidget:(TableSectionWidget *)tableSectionWidget didClickedArticle:(Article *)article {
    
    ArticleDetailView *articleDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleDetailView"];
    articleDetailView.showDateTime = tableSectionWidget.showDateTime;
    articleDetailView.title = article.title;
    articleDetailView.article = article;
    [MAIN_NAVIGATIONCONTROLLER pushViewController:articleDetailView animated:YES];
}

- (IBAction)proclamationButtonClicked:(id)sender {
    
    //公示公告
    ArticleListView *articleListView = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleListView"];
    articleListView.columnId = 4;
    articleListView.title = text(@"公示公告");
    [MAIN_NAVIGATIONCONTROLLER pushViewController:articleListView animated:YES];
}

- (IBAction)serviceButtonClicked:(id)sender {
    
    //服务指南
    ArticleListView *articleListView = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleListView"];
    articleListView.columnId = 5;
    articleListView.title = text(@"服务指南");
    [MAIN_NAVIGATIONCONTROLLER pushViewController:articleListView animated:YES];
}

- (IBAction)reminderButtonClicked:(id)sender {
    
    //温馨提示
    ArticleListView *articleListView = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleListView"];
    articleListView.columnId = 6;
    articleListView.title = text(@"温馨提示");
    [MAIN_NAVIGATIONCONTROLLER pushViewController:articleListView animated:YES];
}

- (IBAction)moreButtonClicked:(id)sender {
    
    //更多
    ArticleListView *articleListView = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleListView"];
    articleListView.columnId = 2;
    articleListView.title = text(@"更多");
    [MAIN_NAVIGATIONCONTROLLER pushViewController:articleListView animated:YES];
}

- (void)shouldReloadStatusNotification:(NSNotification *)notification {

    [self fillData];
}

- (void)shouldReloadDataNotification:(NSNotification *)notification {
    
    [self getBanners];
    [self getRecommendArticles];
    [self getRecommendCultures];
}

- (void)didChangeLanguageNotification:(NSNotification *)notification {
    
    navigationBarWidget.title = text(@"房山出入境");
    
    [self fillData];
    
    [_regulationButton setTitle:text(@"法律法规") forState:UIControlStateNormal];
    [_messageButton setTitle:text(@"留言板") forState:UIControlStateNormal];
    [_proclamationButton setTitle:text(@"公示公告") forState:UIControlStateNormal];
    [_serviceButton setTitle:text(@"服务指南") forState:UIControlStateNormal];
    [_reminderButton setTitle:text(@"温馨提示") forState:UIControlStateNormal];
    [_moreButton setTitle:text(@"更多") forState:UIControlStateNormal];
    
    [self getRecommendArticles];
    [self getRecommendCultures];
}

@end
