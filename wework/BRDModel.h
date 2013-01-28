//
//  BRDModel.h
//  BirthdayReminder
//
//  Created by Nick Kuh on 26/07/2012.
//  Copyright (c) 2012 Nick Kuh. All rights reserved.
//
#define BRNotificationFacebookMeDidUpdate        @"BRNotificationFacebookMeDidUpdate"

#define BRNotificationFacebookFriendsDidUpdate        @"BRNotificationFacebookFriendsDidUpdate"

#define BRNotificationAddressBookBirthdaysDidUpdate        @"BRNotificationAddressBookBirthdaysDidUpdate"
#define BRNotificationFacebookBirthdaysDidUpdate            @"BRNotificationFacebookBirthdaysDidUpdate"
#define BRNotificationCachedBirthdaysDidUpdate          @"BRNotificationCachedBirthdaysDidUpdate"

#define BRNotificationMainCategoriesDidUpdate            @"BRNotificationMainCategoriesDidUpdate"

#define BRNotificationSubCategoriesDidUpdate            @"BRNotificationSubCategoriesDidUpdate"

#define BRNotificationVideosDidUpdate            @"BRNotificationVideosDidUpdate"
#define BRNotificationVideoDidUpdate            @"BRNotificationVideoDidUpdate"

#define BRNotificationGetVideoMsgsDidUpdate @"BRNotificationGetVideoMsgsDidUpdate"
#define BRNotificationDidPostVideoMsg @"BRNotificationPostVideoMsgDidUpdate"

#define BRNotificationSocketURLDidUpdate            @"BRNotificationSocketURLDidUpdate"
#define BRNotificationRegisterUdidDidUpdate            @"BRNotificationRegisterUdidDidUpdate"


typedef enum mainCategoriesSortType {
    mainCategoriesSortTypeNoSort = 0,
    mainCategoriesSortTypeSortByName = 1,
    mainCategoriesSortTypeSortByDate = 2
    
} mainCategoriesSortType;

typedef enum subCategoriesSortType {
    subCategoriesSortTypeNoSort = 0,
    subCategoriesSortTypeSortByName = 1,
    subCategoriesSortTypeSortByDate = 2
    
} subCategoriesSortType;

@class BRRecordMainCategory;
@class BRRecordSubCategory;
@class BRRecordVideo;
@class ACAccount;

@interface BRDModel : NSObject

+ (BRDModel*)sharedInstance;

@property (nonatomic, strong) ACAccount* facebookAccount;
@property(nonatomic, strong)NSDictionary* lang;
@property(nonatomic, strong)NSDictionary* theme;

@property(nonatomic, strong)NSDictionary* fbMe;
@property(nonatomic, strong)NSString* fbName;
@property(nonatomic, strong)NSString* fbId;
@property(nonatomic, strong)NSString* access_token;

@property(nonatomic, assign)BOOL isEnebleToggleFavorite;

@property(nonatomic, strong)NSMutableArray* mArrFriends;
@property (nonatomic,readonly) NSArray *addressBookBirthdays;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveChanges;
- (void)cancelChanges;

-(NSMutableDictionary *) getExistingBirthdaysWithUIDs:(NSArray *)uids;
- (void)fetchAddressBookBirthdays;
- (void)fetchFacebookBirthdays;
- (void)fetchFbFriendsWithVideosCount:(NSString*)access_token fbId:(NSString*)fbId
                            withBlock:(void (^)(NSDictionary* userInfo))block;

- (void)fetchFacebookMe;

@property BOOL mainCategoriesSortIsDesc;
@property BOOL isUserMainCategoryFavoriteNeedUpdate;
@property BOOL isUserVideoFavoriteNeedUpdate;
@property mainCategoriesSortType mainCategoriesSortType;



- (void)fetchMainCategoriesWithPage:(NSNumber*)page 
                          WithBlock:(void (^)(NSDictionary* userInfo))block;

-(NSMutableArray*)mainCategoriesSort:(NSMutableArray*)docs;

@property(nonatomic, strong)NSString* socketUrl;

- (void)postMsg:(NSString*)message
      ByVideoId:(NSString*) videoId
           fbId:(NSString*)fbId 
         fbName:(NSString*)fbNmae;
- (void)fetchVideoMsgsByVideoId:(NSString*)videoId 
                       withPage:(NSNumber*)page
                      withBlock:(void (^)(NSDictionary* userInfo))block;
-(void)delMsgById:(NSString*)msgId
          VideoId:(NSString*)videoId;


- (void)postMyRoom:(NSString*)roomName
              fbId:(NSString*)fbId 
            fbName:(NSString*)fbNmae
         withBlock:(void (^)(NSDictionary* userInfo))block;
- (void)fetchMyRoomsByFbId:(NSString*)fbId 
                       withPage:(NSNumber*)page
                      withBlock:(void (^)(NSDictionary* userInfo))block;
- (void)updMyRoom:(NSString*)roomName
              _id:(NSString*)_id
        withBlock:(void (^)(NSDictionary* userInfo))block;

-(void)delMyRoomById:(NSString*)_id
withBlock:(void (^)(NSDictionary* userInfo))block;




- (void)getSocketUrl;
- (void)registerUdid:(NSString*)udid;
- (void)getProductsWithBlock:(void (^)(NSDictionary* userInfo))block;

-(void) importBirthdays:(NSArray *)birthdaysToImport;
- (void)postToFacebookWall:(NSString *)message withFacebookID:(NSString *)facebookID;



@end
