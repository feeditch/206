#import "Global.h"
#import "AppDelegate.h"
#import "App.h"
#import "User.h"

@implementation Global

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        
        if ( self.managedObjectContext == nil )
        {
            self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        }
        
        /*
         Fetch existing App objects.
         Create a fetch request; find the User entity and assign it to the request; then execute the fetch.
         */
        NSFetchRequest *request_app = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity_app = [NSEntityDescription entityForName:@"App" inManagedObjectContext:self.managedObjectContext];
        [request_app setEntity:entity_app];
        
        // Execute the fetch -- create a mutable copy of the result.
        NSError *error_app = nil;
        NSMutableArray *mutableFetchResults_app = [[self.managedObjectContext executeFetchRequest:request_app error:&error_app] mutableCopy];
        
        if ( mutableFetchResults_app == nil )
        {
            // Handle the error.
            NSLog(@"Empty fetch results.");
        }
        
        // Set self's apps array to the mutable array, then clean up.
        [self setAppsArray:mutableFetchResults_app];
        
        /*
         Fetch existing User objects.
         Create a fetch request; find the User entity and assign it to the request; then execute the fetch.
         */
        NSFetchRequest *request_user = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity_user = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        [request_user setEntity:entity_user];
        
        // Execute the fetch -- create a mutable copy of the result.
        NSError *error_user = nil;
        NSMutableArray *mutableFetchResults_user = [[self.managedObjectContext executeFetchRequest:request_user error:&error_user] mutableCopy];
        
        if ( mutableFetchResults_user == nil )
        {
            // Handle the error.
            NSLog(@"Empty fetch results.");
        }
        
        // Set self's users array to the mutable array, then clean up.
        [self setUsersArray:mutableFetchResults_user];
    }
    
    return self;
}

- (NSString *)readProperty:(NSString *)property
{
    if ( [self.appsArray count] == 0 )
    {
        [self writeValue:@"" forProperty:@"token"];
    }
        
    App *app = (App *)[self.appsArray objectAtIndex:0];
    self.usageCount = [[app usageCount] intValue];
    self.lastRefreshedDate = [app lastRefreshedDate];
    
    User *user = (User *)[self.usersArray objectAtIndex:0];
    self.token = [user token];
    self.name = [user name];
    self.gender = [user gender];
    self.email = [user email];
    self.hash = [user userPicHash];
    self.country = [user country];
    self.bio = [user bio];
    self.userid = [[user userid] intValue];
    self.fbConnected = [[user fbConnected] boolValue];
    self.twitterConnected = [[user twitterConnected] boolValue];
    
    if ([property isEqualToString:@"usageCount"]) {
        return [NSString stringWithFormat:@"%d", self.usageCount];
    } else if ([property isEqualToString:@"lastRefreshedDate"]) {
        return self.lastRefreshedDate;
    } else if ([property isEqualToString:@"token"]) {
        return self.token;
    } else if ([property isEqualToString:@"name"]) {
        return self.name;
    } else if ([property isEqualToString:@"gender"]) {
        return self.gender;
    } else if ([property isEqualToString:@"email"]) {
        return self.email;
    } else if ([property isEqualToString:@"userPicHash"]) {
        return self.hash;
    } else if ([property isEqualToString:@"country"]) {
        return self.country;
    } else if ([property isEqualToString:@"bio"]) {
        return self.bio;
    } else if ([property isEqualToString:@"userid"]) {
        return [NSString stringWithFormat:@"%d", self.userid];
    } else if ([property isEqualToString:@"fbConnected"]) {
        return [NSString stringWithFormat:@"%@", self.fbConnected ? @"YES" : @"NO"];
    } else if ([property isEqualToString:@"twitterConnected"]) {
        return [NSString stringWithFormat:@"%@", self.twitterConnected ? @"YES" : @"NO"];
    } else {
        return @"Error! Invalid property!";
    }
}

- (void)writeValue:(NSString *)value forProperty:(NSString *)property
{
    App *app;
    User *user;
    
    if ([value isEqual:[NSNull null]]) {
        value = @"";
    }
    
    if ([self.appsArray count] == 0) {
        app = (App *)[NSEntityDescription insertNewObjectForEntityForName:@"App" inManagedObjectContext:self.managedObjectContext];
        
        if ([property isEqualToString:@"usageCount"]) {
            [app setUsageCount:value];
        } else if ([property isEqualToString:@"lastRefreshedDate"]) {
            [app setLastRefreshedDate:value];
        }
        
        // Commit the change.
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
        }
        
        [self.appsArray insertObject:app atIndex:0];
    } else {
        app = (App *)[self.appsArray objectAtIndex:0];
        
        if ([property isEqualToString:@"usageCount"]) {
            [app setUsageCount:value];
        } else if ([property isEqualToString:@"lastRefreshedDate"]) {
            [app setLastRefreshedDate:value];
        }
        
        // Commit the change.
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
        }
    }
    
    if ([self.usersArray count] == 0) {
        user = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        
        if ([property isEqualToString:@"token"]) {
            [user setToken:value];
        } else if ([property isEqualToString:@"name"]) {
            [user setName:value];
        } else if ([property isEqualToString:@"gender"]) {
            [user setGender:value];
        } else if ([property isEqualToString:@"email"]) {
            [user setEmail:value];
        } else if ([property isEqualToString:@"userPicHash"]) {
            [user setUserPicHash:value];
        } else if ([property isEqualToString:@"country"]) {
            [user setCountry:value];
        } else if ([property isEqualToString:@"bio"]) {
            [user setBio:value];
        } else if ([property isEqualToString:@"userid"]) {
            [user setUserid:value];
        } else if ([property isEqualToString:@"fbConnected"]) {
            [user setFbConnected:value];
        } else if ([property isEqualToString:@"twitterConnected"]) {
            [user setTwitterConnected:value];
        }
        
        // Commit the change.
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
        }
        
        [self.usersArray insertObject:user atIndex:0];
    }
    else
    {
        user = (User *)[self.usersArray objectAtIndex:0];
        
        if ( [property isEqualToString:@"token"] )
        {
            [user setToken:value];
        } else if ([property isEqualToString:@"name"]) {
            [user setName:value];
        } else if ([property isEqualToString:@"gender"]) {
            [user setGender:value];
        } else if ([property isEqualToString:@"email"]) {
            [user setEmail:value];
        } else if ([property isEqualToString:@"userPicHash"]) {
            [user setUserPicHash:value];
        } else if ([property isEqualToString:@"country"]) {
            [user setCountry:value];
        } else if ([property isEqualToString:@"bio"]) {
            [user setBio:value];
        } else if ([property isEqualToString:@"userid"]) {
            [user setUserid:value];
        } else if ([property isEqualToString:@"fbConnected"]) {
            [user setFbConnected:value];
        } else if ([property isEqualToString:@"twitterConnected"]) {
            [user setTwitterConnected:value];
        }
        
        // Commit the change.
        NSError *error;
        if ( ![self.managedObjectContext save:&error] )
        {
            // Handle the error.
        }
    }
}

- (void)clearAll
{
    App *app = (App *)[self.appsArray objectAtIndex:0];
    User *user = (User *)[self.usersArray objectAtIndex:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *dateNow = [[NSDate alloc] init];
    
    [app setLastRefreshedDate:[formatter stringFromDate:dateNow]];
    
    [user setToken:@""];
    [user setName:@""];
    [user setGender:@""];
    [user setEmail:@""];
    [user setUserPicHash:@""];
    [user setCountry:@""];
    [user setBio:@""];
    [user setUserid:@"-1"];
    [user setFbConnected:@""];
    [user setTwitterConnected:@""];
    
    // Commit the change.
    NSError *error;
    if ( ![self.managedObjectContext save:&error] )
    {
        // Handle the error.
    }
}

@end
