

@interface Global : NSObject

@property (nonatomic, retain) NSMutableArray *appsArray;
@property (nonatomic, retain) NSMutableArray *usersArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *lastRefreshedDate;
@property (nonatomic) int usageCount;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *hash;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *bio;
@property (nonatomic) int userid;
@property (nonatomic) BOOL fbConnected;
@property (nonatomic) BOOL twitterConnected;

- (NSString *)readProperty:(NSString *)property;
- (void)writeValue:(NSString *)value forProperty:(NSString *)property;
- (void)clearAll;

@end
