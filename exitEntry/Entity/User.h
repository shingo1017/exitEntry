/*!
 @header User.h
 @abstract 用户实体类
 @author 尹楠
 @version 1.00 2014/05/13 创建
 */

#import <Foundation/Foundation.h>
#import "JSONModel.h"

typedef NS_ENUM(NSInteger, BookStatus){
    BookStatusNotSubmit = -1,            // 未提交
    BookStatusWatingForReview = 0,      // 等待审核
    BookStatusRejected = 1,             // 已拒绝
    BookStatusApproved = 2,             // 审核通过
    BookStatusCertificateReady = 3,     // 证书可下载
    BookStatusInReview = 4,             // 审核中
};

/*!
 @class
 @abstract 用户实体类。
*/
@interface User : JSONModel

/*!
 @property
 @abstract Id。
*/
@property(nonatomic, copy) NSString *id;

/*!
 @property
 @abstract apiKey。
 */
@property(nonatomic, copy) NSString *apiKey;

/*!
 @property
 @abstract 电话。
 */
@property(nonatomic, copy) NSString *phoneNumber;

/*!
 @property
 @abstract 用户名。
 */
@property(nonatomic, copy) NSString *name;

/*!
 @property
 @abstract 审核状态。
 */
@property(nonatomic, assign) BookStatus bookStatus;

/*!
 @property
 @abstract 审核状态文本。
 */
@property(nonatomic, copy) NSString *bookStatusText;

+ (User *)defaultUser;

+ (void)setDefaultUser:(User *)user;

+ (BOOL)checkPermission;

+ (BOOL)isLogin;

@end
