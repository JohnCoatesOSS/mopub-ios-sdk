//
//  MPSpecHelper.m
//  MoPub
//
//  Copyright (c) 2013 MoPub. All rights reserved.
//

#import "MPSpecHelper.h"
#import "MPInterstitialAdController.h"
#import "GSConstants.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

static BOOL beforeAllDidRun = NO;

FakeMPInstanceProvider *fakeProvider;

void verify_fake_received_selectors(id<CedarDouble> fake, NSArray *selectors)
{
    fake.sent_messages.count should equal(selectors.count);

    for (int i = 0; i < [[fake sent_messages] count]; i++) {
        [[fake sent_messages][i] selector] should equal(NSSelectorFromString(selectors[i]));
    }

    [fake reset_sent_messages];
}

void log_sent_messages(id<CedarDouble> fake)
{
    for (NSInvocation *invocation in fake.sent_messages) {
        NSLog(@"================> %@", NSStringFromSelector(invocation.selector));
    }
}

@implementation MPSpecHelper

+ (void)beforeEach
{
    if (!beforeAllDidRun) {
        usleep(200000);
        beforeAllDidRun = YES;
        [MMAdView setLogLevel:MMLOG_LEVEL_OFF];
        [GSConstants setGUID:@"GreystripeGUID"]; //silences greystripe complaints further down the line
    }

    fakeProvider = [[[FakeMPInstanceProvider alloc] init] autorelease];
}

+ (void)afterEach
{
    [[MPInterstitialAdController sharedInterstitialAdControllers] removeAllObjects];
}

@end