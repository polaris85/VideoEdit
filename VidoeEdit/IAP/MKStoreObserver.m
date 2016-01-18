//
//  MKStoreObserver.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//

#import "MKStoreObserver.h"
#import "MKStoreManager.h"
#import "AppDelegate.h"

static MKStoreObserver* _sharedObject = nil;
NSString *const MKStoreObserverProductPurchasedNotification = @"MKStoreObserverProductPurchasedNotification";
@implementation MKStoreObserver
@synthesize arrayRet;
@synthesize FlashLevel,EMLevel,SALevel,TFLevel;


+ (id)sharedObject {
    @synchronized(self) {
        if (_sharedObject == nil) {
            _sharedObject = [[self alloc] init];
        }
    }
    return _sharedObject;
}


- (NSString *)dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}



- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
        
   			case SKPaymentTransactionStatePurchased:
            {
                 NSLog(@"------success");
                [self completeTransaction:transaction];
            }
                 break;
				
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"-------failed");
               [self failedTransaction:transaction];
            }
               break;
				
            case SKPaymentTransactionStateRestored:
            {
				NSLog(@"-------restored");
               [self restoreTransaction:transaction];
            }
				break;
            default:
				
                break;
		}			
	}
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{	
    NSUserDefaults *userdefalts = [NSUserDefaults standardUserDefaults];
    [userdefalts setBool:true forKey:@"purchaseflage"];
    [userdefalts synchronize];
    if (transaction.error.code == SKErrorPaymentCancelled )		
    {		
		NSLog(@"cancelled");
	}

	if (transaction.error.code == SKErrorPaymentNotAllowed ) {		
		NSLog(@"pay not allowd");
	}
	
	if (transaction.error.code == SKErrorPaymentInvalid ) {		
		NSLog(@"invalid");
	}
    
    if (transaction.error.code == SKErrorClientInvalid ) {
		NSLog(@"SKErrorClientInvalid");
	}
	
	if (transaction.error.code == SKErrorUnknown ) {
		NSLog(@"SKErrorUnknown");
	}

	if (transaction.error.code == SKErrorStoreProductNotAvailable ) {
		NSLog(@"SKErrorStoreProductNotAvailable");
	}

	
   [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"test_purchase=%@",transaction.payment.productIdentifier);
    
    [self provideContent: transaction.payment.productIdentifier shouldSerialize:YES];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    isRestoring = YES;
   [self provideContent: transaction.originalTransaction.payment.productIdentifier shouldSerialize:YES];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];	
}


-(void) provideContent: (NSString*)productIdentifier shouldSerialize: (BOOL) serialize
{
    if(serialize)
    {
         NSUserDefaults *userdefalts = [NSUserDefaults standardUserDefaults];
        [userdefalts setBool:true forKey:@"purchaseflage"];
        [userdefalts synchronize];
        if(!isRestoring)
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
        else
        {
            NSLog(@"purchase_string= %@", productIdentifier);
            AppDelegate *app = [[UIApplication sharedApplication]delegate];
            if([productIdentifier isEqualToString:tenfx])
                app.comeinpurchasestr = @"teneffect";
            else if([productIdentifier isEqualToString:othertenfx])
                app.comeinpurchasestr = @"otherteneffect";
            else if([productIdentifier isEqualToString:tentransition])
                app.comeinpurchasestr = @"tenfx";
            else if([productIdentifier isEqualToString:allfxtransition])
                app.comeinpurchasestr = @"allfxeffect";
            else
                app.comeinpurchasestr = @"";
            NSLog(@"purchase_string= %@", productIdentifier);
            isRestoring = NO;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:MKStoreObserverProductPurchasedNotification object:productIdentifier userInfo:nil];
    }
    
}


@end
