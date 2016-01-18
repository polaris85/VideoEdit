//
//  YouTubeUploader.m
//  YouTubeSample_iOS
//
//  Created by Manuel Carrasco Molina on 08.01.12.
//  Copyright (c) 2012 Pomcast. All rights reserved.
//

#import "YouTubeUploader.h"
#import "GDataEntryYouTubeUpload.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface YouTubeUploader (Private)

- (GDataServiceGoogleYouTube *)youTubeService;
- (BOOL)isSignedIn;
- (NSString *)signedInUsername;
- (void)runSignin:(NSString*)path;

@end
    
@implementation YouTubeUploader
@synthesize filepath;
@synthesize uploadProgressView = _uploadProgressView;
@synthesize delegate = _delegate;

static NSString *const kKeychainItemName = @"YouTube: VideoShare";

#pragma mark - Public Methods

- (id)init {
    if ((self = [super init])) {
        GTMOAuth2Authentication *auth=nil;
        auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                     clientID:CLIENT_ID
                                                                 clientSecret:CLIENT_SECRET];
        //[auth retain];
        auth.shouldAuthorizeAllRequests=YES;
        [[self youTubeService] setAuthorizer:auth];
    }
    return self;
}

- (void)logout {
    GDataServiceGoogleYouTube *service = [self youTubeService];
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
    [service setAuthorizer:nil];
    NSLog(@"Logged Out");
}

- (void)uploadVideoFile:(NSString*)path {
    NSLog(@"About to upload %@", path);
    
    if (![self isSignedIn]) {
        // Sign in
        [self runSignin:path];
    }else{
        GDataServiceGoogleYouTube *service = [self youTubeService];
        [service setYouTubeDeveloperKey:DEV_KEY];
        
        NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:kGDataServiceDefaultUser];
        
        // load the file data
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
        NSString *filename = [path lastPathComponent];
        
        // gather all the metadata needed for the mediaGroup
        GDataMediaTitle *title = [GDataMediaTitle textConstructWithString:[filename stringByDeletingPathExtension]];
        GDataMediaCategory *category = [GDataMediaCategory mediaCategoryWithString:@"Entertainment"];
        [category setScheme:kGDataSchemeYouTubeCategory];
        BOOL isPrivate = NO;//YES for private.
        
        
        
        GDataMediaDescription *desc=[GDataMediaDescription  textConstructWithString:@"Testing Description...."];
        
        
        GDataYouTubeMediaGroup *mediaGroup = [GDataYouTubeMediaGroup mediaGroup];
        [mediaGroup setMediaTitle:title];
        [mediaGroup addMediaCategory:category];
        [mediaGroup setIsPrivate:isPrivate];
        [mediaGroup setMediaDescription:desc];
        NSString *mimeType = [GDataUtilities MIMETypeForFileAtPath:path
                                                   defaultMIMEType:@"video/mp4"];
        
        // create the upload entry with the mediaGroup and the file
        GDataEntryYouTubeUpload *entry;
        entry = [GDataEntryYouTubeUpload uploadEntryWithMediaGroup:mediaGroup
                                                        fileHandle:fileHandle
                                                          MIMEType:mimeType
                                                              slug:filename];
        
        [service setServiceUploadProgressSelector:@selector(ticket:hasDeliveredByteCount:ofTotalByteCount:)];
        
        GDataServiceTicket *ticket;
        ticket = [service fetchEntryByInsertingEntry:entry
                                          forFeedURL:url
                                            delegate:self
                                   didFinishSelector:@selector(uploadTicket:finishedWithEntry:error:)];
    }
    
    
}

#pragma mark - Private Methods

- (BOOL)isSignedIn {
    NSString *name = [self signedInUsername];
    NSLog(@"name: %@", name);
    return (name != nil);
}

- (GDataServiceGoogleYouTube *)youTubeService {
    // A "service" object handles networking tasks.  Service objects
    // contain user authentication information as well as networking
    // state information (such as cookies and the "last modified" date for
    // fetched data.)
    
    static GDataServiceGoogleYouTube* service = nil;
    if (!service) {
        service = [[GDataServiceGoogleYouTube alloc] init];
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
        [service setIsServiceRetryEnabled:YES];
    }
    [service setYouTubeDeveloperKey:DEV_KEY];
    return service;
}

- (NSString *)signedInUsername {
    // Get the email address of the signed-in user
    GTMOAuth2Authentication *auth1 = [[self youTubeService] authorizer];
    BOOL isSignedIn = auth1.canAuthorize;
    if (isSignedIn) {
        return auth1.userEmail;
    } else {
        return nil;
    }
}

- (void)runSignin:(NSString*)path {
    // Show the OAuth 2 sign-in controller
    NSString *scope = [GDataServiceGoogleYouTube authorizationScope];
    
    id completionHandler = ^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth2, NSError *error) {
        // TODO: Check the error and don't dismiss if an error has occured.
        NSLog(@"----****  %@\n%@\n%@", viewController, auth2, error);
                
            [self.delegate dismissViewControllerAnimated:YES completion:^{
                
                
                
                self.filepath=path;
                
                if (error) {
                    
                    MBAlertView *alt=[MBAlertView alertWithBody:[error localizedDescription] cancelTitle:@"OK" cancelBlock:nil];
                    
                    alt.size=CGSizeMake(300, 200);
                    [alt addToDisplayQueue];
                    [alt release];
                    
                    
                    
                }else{
                
                    
                    /*
                    linkingHud=[ MBHUDView hudWithBody:@"Checking for you tube linking" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0 show:YES];
                     
                     
                     
                    [self  lookforUTubeLinking];
                     */
                    
                    
                    [self init];
                    if ([[[self youTubeService] authorizer] canAuthorize]) {
                        [self uploadVideoFile:self.filepath];
                    }
                    

                
                }
                
                               
                
                
                
                           }];
            
            
            
            
            
            
            
            
            
            
            
            
        
        
        
    };
    
    GTMOAuth2ViewControllerTouch *viewController = [GTMOAuth2ViewControllerTouch controllerWithScope:scope
                                                                                            clientID:CLIENT_ID 
                                                                                        clientSecret:CLIENT_SECRET
                                                                                    keychainItemName:kKeychainItemName
                                                                                   completionHandler:completionHandler];

    [self.delegate presentViewController:viewController animated:YES completion:^{
        NSLog(@"Google Sign In presented");
    }];
}

// progress callback

- (void)ticket:(GDataServiceTicket *)ticket hasDeliveredByteCount:(unsigned long long)numberOfBytesRead ofTotalByteCount:(unsigned long long)dataLength 
{
    float progress = (float)numberOfBytesRead/dataLength;
    NSLog(@"numberOfBytesRead/dataLength => %llu/%llu = %f",numberOfBytesRead, dataLength, progress);
    [_uploadProgressView setProgress:progress animated:YES];
}


// upload callback
- (void)uploadTicket:(GDataServiceTicket *)ticket
   finishedWithEntry:(GDataEntryYouTubeVideo *)videoEntry
               error:(NSError *)error {
    NSLog(@"%@ %@", [videoEntry title], error);
   
    if (error) {
        
        NSRange  Trange=[[error localizedDescription] rangeOfString:@"NoLinkedYouTubeAccount" options:NSLiteralSearch];
        if (Trange.location==NSNotFound) {
               MBAlertView *alt=[MBAlertView alertWithBody:[error localizedDescription] cancelTitle:@"OK" cancelBlock:nil];
             ;
            alt.size=CGSizeMake(300, 200);
            [alt addToDisplayQueue];
            [alt release];
            
        }else{
            
            MBAlertView *alt=[MBAlertView alertWithBody:@"Your Google account is not linked with You tube account, Wanna connect now.?" cancelTitle:@"NO" cancelBlock:nil];
            [alt addButtonWithText:@"YES" type:MBAlertViewItemTypePositive block:^{
                
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://m.youtube.com/create_channel"]];
                
                
            }];
            alt.size=CGSizeMake(300, 200);
            [alt addToDisplayQueue];
            [alt release];
            
            
        }

        
    }else{
        
        MBAlertView *alt=[MBAlertView alertWithBody:@"Video is successfully uploaded to Youtube." cancelTitle:@"OK" cancelBlock:nil];
        NSLog(@"test=%@", videoEntry.HTMLLink.href);
        alt.size=CGSizeMake(300, 200);
        [alt addToDisplayQueue];
        [alt release];
    }
    
    [_uploadProgressView setProgress:0 animated:YES];
}


- (void)dealloc {
    [filepath release];
    [_uploadProgressView release];
    [super dealloc];
}

#pragma mark CHeckforYouTubeLInking
-(void)lookforUTubeLinking{
    
    
    GTMOAuth2Authentication *auth=[[self youTubeService]authorizer];
    
    
    NSLog(@"[auth canAuthorize]---%d",[auth canAuthorize]);
    
    if ([auth canAuthorize]) {
        
        
        NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/channels?v=2"]];

        
        [auth authorizeRequest:req completionHandler:^(NSError *error) {
            
            
            if (error) {
                NSLog(@"***------%@",[error localizedDescription]);
            }else{
                NSURLResponse *response = nil;
                NSError *error;
                
                NSData *data = [NSURLConnection sendSynchronousRequest:req
                                                     returningResponse:&response
                                                                 error:&error];
                
                NSString *output = nil;
                if (data) {
                    // API fetch succeeded
                    
                    output = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease];
                    NSLog(@"output--%@",output);
                    [linkingHud dismiss];
                    //Token invalid
                    
                    
                    
                    
                    NSRange  Trange=[output rangeOfString:@"NoLinkedYouTubeAccount" options:NSLiteralSearch];
                    NSLog(@"%@",NSStringFromRange(Trange));
                    if (Trange.location ==NSNotFound) {
                        
                        
                        NSLog(@"Account is linked with uTube");
                        
                        
                        NSLog(@"%d",__LINE__);
                        
                        
                        [self init];
                        if ([[[self youTubeService] authorizer] canAuthorize]) {
                            [self uploadVideoFile:self.filepath];
                        }
                    }else{
                        
                        NSLog(@"%d",__LINE__);
                        NSLog(@"account is not linked with utube");
                        
                        //show alert having text that , u have no NoLinkedYouTubeAccount with this gmail account.
                        
                        //please go to you tube to associated ur gmail account with u tube.
                        //https://m.youtube.com/create_channel
                        
                        
                        MBAlertView *alt=[MBAlertView alertWithBody:@"Your Google account is not linked with You tube account, Wanna connect now.?" cancelTitle:@"NO" cancelBlock:nil];
                        [alt addButtonWithText:@"YES" type:MBAlertViewItemTypePositive block:^{
                            
                            
                            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://m.youtube.com/create_channel"]];
                            
                            
                        }];
                        alt.size=CGSizeMake(300, 200);
                        [alt addToDisplayQueue];
                        [alt release];
                        
                        
                        
                        
                    }
                }
            
            }
            
            
        }];
        
        
    }
    
}

@end
