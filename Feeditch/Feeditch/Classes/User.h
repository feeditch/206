@interface User : NSManagedObject

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *userPicHash;
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *fbConnected;
@property (nonatomic, retain) NSString *twitterConnected;
@property (nonatomic, retain) NSString *bio;
@property (nonatomic, retain) NSString *country;

@end
