#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SFCompatibility.h"
#import "SFEvent.h"
#import "SFQueueConfig.h"
#import "Sift.h"

FOUNDATION_EXPORT double SiftVersionNumber;
FOUNDATION_EXPORT const unsigned char SiftVersionString[];

