/*!
 @header BookInfo.h
 @abstract 用户实体类
 @author 尹楠
 @version 1.00 2014/05/13 创建
 */

#import <Foundation/Foundation.h>
#import "JSONModel.h"

/*!
 @class
 @abstract 用户实体类。
*/
@interface BookInfo : JSONModel

/*!
 @property
 @abstract Id。
*/
@property(nonatomic, assign) NSInteger id;

/*!
 @property
 @abstract 本人照片网址。
 */
@property(nonatomic, copy) NSURL *myPhotoUrl;

/*!
 @property
 @abstract 护照照片网址。
 */
@property(nonatomic, copy) NSURL *passportPhotoUrl;

/*!
 @property
 @abstract 国家。
*/
@property(nonatomic, copy) NSString *country;

/*!
 @property
 @abstract 证件类型。
 */
@property(nonatomic, copy) NSString *identityType;

/*!
 @property
 @abstract 证件号。
 */
@property(nonatomic, copy) NSString *identityNumber;

/*!
 @property
 @abstract 证件有效期。
 */
@property(nonatomic, strong) NSDate *identityExpireDate;

/*!
 @property
 @abstract 人员类型。
 */
//@property(nonatomic, copy) NSString *personType;

/*!
 @property
 @abstract 人员地域类型。
 */
//@property(nonatomic, copy) NSString *personAreaType;

/*!
 @property
 @abstract 英文名。
 */
@property(nonatomic, copy) NSString *englishFirstName;

/*!
 @property
 @abstract 英文姓。
 */
@property(nonatomic, copy) NSString *englishLastName;

/*!
 @property
 @abstract 中文名。
 */
@property(nonatomic, copy) NSString *name;

/*!
 @property
 @abstract 性别。
 */
//@property(nonatomic, copy) NSString *gender;

/*!
 @property
 @abstract 出生日期。
 */
//@property(nonatomic, strong) NSDate *birthday;

/*!
 @property
 @abstract 出生地。
 */
@property(nonatomic, copy) NSString *homeplace;

/*!
 @property
 @abstract 职业。
 */
@property(nonatomic, copy) NSString *occupation;

/*!
 @property
 @abstract 工作机构。
 */
@property(nonatomic, copy) NSString *workingOrganization;

/*!
 @property
 @abstract 联系电话。
 */
@property(nonatomic, copy) NSString *phoneNumber;

/*!
 @property
 @abstract 紧急联系人姓名。
 */
@property(nonatomic, copy) NSString *emergencyContact;

/*!
 @property
 @abstract 紧急联系人的联系电话。
 */
@property(nonatomic, copy) NSString *emergencyContactPhoneNumber;

/*!
 @property
 @abstract 入境照片网址。
 */
@property(nonatomic, copy) NSURL *enterPhotoUrl;

/*!
 @property
 @abstract 签证照片网址。
 */
@property(nonatomic, copy) NSURL *visaPhotoUrl;

/*!
 @property
 @abstract 签证（注）种类。
 */
@property(nonatomic, copy) NSString *visaType;

/*!
 @property
 @abstract 签证（注）有效期。
 */
@property(nonatomic, strong) NSDate *visaExpireDate;

/*!
 @property
 @abstract 入境日期。
 */
@property(nonatomic, strong) NSDate *enterDate;

/*!
 @property
 @abstract 入境口岸。
 */
@property(nonatomic, copy) NSString *entryPort;

/*!
 @property
 @abstract 停留事由。
 */
@property(nonatomic, copy) NSString *stayReason;

/*!
 @property
 @abstract 停留有效期。
 */
//@property(nonatomic, strong) NSDate *stayExpireDate;

/*!
 @property
 @abstract 入住日期。
 */
//@property(nonatomic, strong) NSDate *checkInDate;

/*!
 @property
 @abstract 拟定离开日期。
 */
@property(nonatomic, strong) NSDate *checkOutDate;

/*!
 @property
 @abstract 是否有房屋租赁合同。
 */
@property(nonatomic, assign) BOOL haveContract;

/*!
 @property
 @abstract 房主身份证照片网址。
 */
@property(nonatomic, copy) NSURL *landlordIdentityPhotoUrl;

/*!
 @property
 @abstract 房屋租赁合同照片网址。
 */
@property(nonatomic, copy) NSArray *houseRentalContractPhotos;

/*!
 @property
 @abstract 住房详细地址。
 */
@property(nonatomic, copy) NSString *houseAddress;

/*!
 @property
 @abstract 住房所属派出所。
 */
//@property(nonatomic, copy) NSString *policeStation;

/*!
 @property
 @abstract 住房所属社区。
 */
//@property(nonatomic, copy) NSString *community;

/*!
 @property
 @abstract 住房种类。
 */
@property(nonatomic, copy) NSString *houseType;

/*!
 @property
 @abstract 房东国家。
 */
@property(nonatomic, copy) NSString *landlordCountry;

/*!
 @property
 @abstract 房东身份证号。
 */
@property(nonatomic, copy) NSString *landlordIdentityNumber;

/*!
 @property
 @abstract 房东中文名。
 */
@property(nonatomic, copy) NSString *landlordName;

/*!
 @property
 @abstract 房东性别。
 */
@property(nonatomic, copy) NSString *landlordGender;

/*!
 @property
 @abstract 房东联系电话。
 */
@property(nonatomic, copy) NSString *landlordPhoneNumber;

/*!
 @property
 @abstract 离开日期。
 */
@property(nonatomic, strong) NSDate *leaveCountryDate;

/*!
 @property
 @abstract 离开原因。
 */
@property(nonatomic, copy) NSString *leaveReason;

/*!
 @property
 @abstract 去往目的地。
 */
@property(nonatomic, copy) NSString *whereToGo;

/*!
 @property
 @abstract 拒绝原因。
 */
@property(nonatomic, copy) NSString *rejectReason;

/*!
 @property
 @abstract 电子证书下载地址。
 */
@property(nonatomic, copy) NSURL *certificatePhotoUrl;

+ (BookInfo *)defaultBookInfo;

+ (void)setDefaultBookInfo:(BookInfo *)bookInfo;

- (NSString *)baseInfoVerification;
- (NSString *)visaInfoVerification;
- (NSString *)stayInfoVerification;
- (NSString *)writeOffVerification;

- (BOOL)isGAT;
- (void)prepareSubmit;
- (void)save;
- (void)delete;

@end
