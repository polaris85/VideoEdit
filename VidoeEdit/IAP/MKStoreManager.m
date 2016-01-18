//
//  MKStoreManager.m
//
//  Created by Mugunth Kumar on 15-Nov-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//  mugunthkumar.com
//

#import "MKStoreManager.h"
#import "AppDelegate.h"


@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;

static NSString *ownServer = nil;

// all your features should be managed one and only by StoreManager
static NSString *featureAId = @"";

BOOL magPurchased;
BOOL FlashPurchased;
BOOL TFPurchased;
BOOL EMPurchased;
BOOL SAPurchased;

static __weak id<MKStoreKitDelegate> _delegate;
static MKStoreManager* _sharedStoreManager; // self

- (void)dealloc {
	
	[_sharedStoreManager release];
	[storeObserver release];
	[super dealloc];
}

+ (id)delegate {
	
    return _delegate;
}

+ (void)setDelegate:(id)newDelegate {
	
    _delegate = newDelegate;	
}

+ (BOOL) magPurchased {
	
	return magPurchased;
}

+ (BOOL) FlashPurchased {
	
	return FlashPurchased;
}

+ (BOOL) TFPurchased {
	
	return TFPurchased;
}

+ (BOOL) EMPurchased {
	
	return EMPurchased;
}

+ (BOOL) SAPurchased {
	
	return SAPurchased;
}

+ (MKStoreManager*)sharedManager
{

	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            [[self alloc] init]; // assignment not done here
//			_sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];			
////			[_sharedStoreManager requestProductData];
//			
//			NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
//			magPurchased = [userDefaults boolForKey:featureAId]; 
////			featureBPurchased = [userDefaults boolForKey:featureBId]; 	
			
			_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    return _sharedStoreManager;
}


#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            _sharedStoreManager = [super allocWithZone:zone];			
            return _sharedStoreManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}


- (void) requestProductData
{
	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: 
								 [NSSet setWithObjects: featureAId, nil]];
	request.delegate = self;
	[request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[purchasableObjects addObjectsFromArray:response.products];
	// populate UI
	for(int i=0;i<[purchasableObjects count];i++)
	{
		
		SKProduct *product = [purchasableObjects objectAtIndex:i];
		NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],
			  [[product price] doubleValue], [product productIdentifier]);
	}
	
	[request autorelease];
}

- (void) buyFeature:(NSString*) featureId
{
	
	NSLog(@"feature=%@",featureId);
	
	if([self canCurrentDeviceUseFeature: featureId])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed",@"") message:NSLocalizedString(@"You can use this feature for this session.",@"")
													   delegate:self cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		[self provideContent:featureId shouldSerialize:NO];
		return;
	}
	
	if ([SKPaymentQueue canMakePayments])
	{
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed",@"") message:NSLocalizedString(@"You are not authorized to purchase from AppStore",@"")
													   delegate:self cancelButtonTitle:NSLocalizedString(@"OK" ,@"")otherButtonTitles: nil];
		[alert show];
		[alert release];
	
	}
}

- (BOOL) canCurrentDeviceUseFeature: (NSString*) featureID
{
	//NSString *uniqueID = [[UIDevice currentDevice] uniqueIdentifier];
    UIDevice *device = [UIDevice currentDevice];
    NSString *uniqueID = [[device identifierForVendor] UUIDString];
	// check udid and featureid with developer's server
	
	if(ownServer == nil) return NO; // sanity check
	
	NSURL *url = [NSURL URLWithString:ownServer];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url 
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                                          timeoutInterval:60];
	
	[theRequest setHTTPMethod:@"POST"];		
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	NSString *postData = [NSString stringWithFormat:@"productid=%@&udid=%@", featureID, uniqueID];
	
	NSString *length = [NSString stringWithFormat:@"%d", [postData length]];	
	[theRequest setValue:length forHTTPHeaderField:@"Content-Length"];	
	
	[theRequest setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
		
	NSHTTPURLResponse* urlResponse = nil;
	NSError *error = [[[NSError alloc] init] autorelease];  
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest
												 returningResponse:&urlResponse 
															 error:&error];  
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];

	BOOL retVal = NO;
	if([responseString isEqualToString:@"YES"])		
	{
		retVal = YES;
	}
	
	[responseString release];
	return retVal;
}
							 
- (void) buyMag:(NSString *)productid
{
	featureAId=productid;
	[self requestProductData];
	[self buyFeature:productid];
}


- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to complete your purchase",@"") message:messageToBeShown
												   delegate:self cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles: nil];
	[alert show];
	[alert release];
	
}

-(void) provideContent: (NSString*) productIdentifier shouldSerialize: (BOOL) serialize
{
    if(serialize)
    {
        NSLog(@"purchase_string= %@", productIdentifier);
        AppDelegate *app = [[UIApplication sharedApplication]delegate];
        if([productIdentifier isEqualToString:tenfx] && [app.comeoutpurchasestr isEqualToString:tenfx])
            app.comeinpurchasestr = @"teneffect";
        else if([productIdentifier isEqualToString:othertenfx] && [app.comeoutpurchasestr isEqualToString:othertenfx])
            app.comeinpurchasestr = @"otherteneffect";
        else if([productIdentifier isEqualToString:tentransition] && [app.comeoutpurchasestr isEqualToString:tentransition])
            app.comeinpurchasestr = @"tenfx";
        else if([productIdentifier isEqualToString:allfxtransition] && [app.comeoutpurchasestr isEqualToString:allfxtransition])
            app.comeinpurchasestr = @"allfxeffect";
        else
            app.comeinpurchasestr = @"";
          NSLog(@"purchase_string= %@", productIdentifier);
    }
}


@end
