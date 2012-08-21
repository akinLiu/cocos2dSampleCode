//
//  Store.m
//  Mole It
//
//  Created by Todd Perkins on 4/21/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "Store.h"
#import "Constants.h"
#import "AppDelegate.h"

@implementation Store

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    return self;
}

-(void)makePurchase
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:currentPurchase];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    //[self showAlert];
}

- (void) requestProductData
{
    if ([SKPaymentQueue canMakePayments])
    {
        // Display a store to the user.
        CCLOG(@"presenting store...");
    }
    else
    {
        // Warn the user that purchases are disabled.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"In-app Purchases Disabled" message:@"In-app purchases are not enabled on your device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [self showAlert];
    currentPurchase = IAP_SKIN; // change when more products are added!
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject: currentPurchase]];
    request.delegate = self;
    [request start];
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *myProduct = response.products;
    SKProduct *product = [myProduct objectAtIndex:0];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:product.price];
    currentPurchase = product.productIdentifier;
    //[self hideAlert];
    [self makePurchase];
    
    //CCLOG(@"name: %@, description: %@, price: %@", product.localizedTitle, product.localizedDescription, formattedString);
    
    
    // populate UI
    [request autorelease];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    // Your application should implement these two methods.
    [self hideAlert];
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    [self hideAlert];
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Optionally, display an error here.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:@"Your payment did not go through." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void)recordTransaction: (SKPaymentTransaction *)transaction
{
    
}

-(void)provideContent: (NSString *)contentID
{
    // unlock stuff!
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:contentID];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([contentID isEqualToString:IAP_SKIN])
    {
        [delegate setCurrentSkin:SKIN_JETPACK];
    }
    
}

-(void)alertViewCancel:(UIAlertView *)alertView
{
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self makePurchase];
    }
}

- (void)hideAlert {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert release];
    alert = nil;
}

- (void)showAlert {
    if (alert)
        return;
    alert = [[UIAlertView alloc] initWithTitle:nil message:@"Retrieving Data" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.center = CGPointMake(alert.bounds.size.width * 0.5f, alert.bounds.size.height * 0.5f);
    
    [indicator startAnimating];
    [alert addSubview:indicator];
    [indicator release];
}



- (void)dealloc
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert release];
    [super dealloc];
}

@end
