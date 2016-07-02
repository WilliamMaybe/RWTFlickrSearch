//
//  RWTFlickrSearchImpl.m
//  RWTFlickrSearch
//
//  Created by William Zhang on 16/7/1.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchImpl.h"
#import "RWTFlickrSearchResults.h"
#import "RWTFlickrPhoto.h"
#import <objectiveflickr/ObjectiveFlickr.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RWTFlickrPhotoMetadata.h"

@interface RWTFlickrSearchImpl () <OFFlickrAPIRequestDelegate>

@property (nonatomic, strong) NSMutableSet<OFFlickrAPIRequest *> *requests;
@property (nonatomic, strong) OFFlickrAPIContext *flickrContext;

@end

@implementation RWTFlickrSearchImpl

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSString *OFSampleAppAPIKey = @"YOUR_API_KEY_GOES_HERE";
        NSString *OFSampleAppAPISharedSecret = @"YOUR_SECRET_GOES_HERE";
        
        _flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OFSampleAppAPIKey sharedSecret:OFSampleAppAPISharedSecret];
        _requests = [NSMutableSet set];
    }
    return self;
}

- (RACSignal *)flickrSearchSignal:(NSString *)searchString
{
    
    return [self signalFromAPIMethod:@"flickr.photos.search"
                          arguements:@{@"text":searchString, @"sort":@"interstingness-desc"}
                           transform:^id(NSDictionary *response) {
                               
                               RWTFlickrSearchResults *results = [RWTFlickrSearchResults new];
                               results.searchString = searchString;
                               results.totalResults = [[response valueForKeyPath:@"photos.total"] integerValue];
                               
                               NSArray *photos = [response valueForKeyPath:@"photos.photo"];
                               results.photos = [photos linq_select:^id(NSDictionary *jsonPhoto) {
                                   RWTFlickrPhoto *photo = [RWTFlickrPhoto new];
                                   
                                   photo.title      = [jsonPhoto objectForKey:@"title"];
                                   photo.identifier = [jsonPhoto objectForKey:@"id"];
                                   photo.url        = [NSURL URLWithString:[jsonPhoto objectForKey:@"url"]];
                                   
                                   return photo;
                               }];
                               
                               return results;
                           }];
}

- (RACSignal *)flickrImageMetadata:(NSString *)identifier
{
    return [self signalFromAPIMethod:@"flickr.photos.identifier" arguements:nil transform:^id(NSDictionary *response) {
        
        RWTFlickrPhotoMetadata *metadata = [[RWTFlickrPhotoMetadata alloc] init];
        
        metadata.favorites = [response[@"favorites"] unsignedIntegerValue];
        metadata.comments  = [response[@"comments"] unsignedIntegerValue];
        
        return metadata;
    }];
    
}

- (RACSignal *)signalFromAPIMethod:(NSString *)method
                        arguements:(NSDictionary *)args
                         transform:(id (^)(NSDictionary *response))block
{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSDictionary *response = @{
                                   @"searchString" : @"heiehi",
                                   @"photos" : @{
                                           @"total" : @(10),
                                           @"photo" :@[
                                                   @{
                                                       @"title" : @"dog1",
                                                       @"url"   : @"http://t-1.tuzhan.com/422022f85414/c-2/l/2013/05/23/22/ee4dd25e87fb4b27b63710ea6945491b.jpg",
                                                       @"id"    : @"1"
                                                       },
                                                   
                                                   @{
                                                       @"title" : @"dog2",
                                                       @"url"   : @"http://img.club.pchome.net/kdsarticle/2013/11small/21/fd548da909d64a988da20fa0ec124ef3_1000x750.jpg",
                                                       @"id"    : @"2"
                                                       },
                                                   
                                                   @{
                                                       @"title" : @"dog3",
                                                       @"url"   : @"http://img3.3lian.com/2013/v8/72/d/61.jpg",
                                                       @"id"    : @"3"
                                                       }]
                                           }
                                   };
        
        if ([method isEqualToString:@"flickr.photos.search"])
        {
            response = @{
                         @"searchString" : @"heiehi",
                         @"photos" : @{
                                 @"total" : @(10),
                                 @"photo" :@[
                                         @{
                                             @"title" : @"dog1",
                                             @"url"   : @"http://t-1.tuzhan.com/422022f85414/c-2/l/2013/05/23/22/ee4dd25e87fb4b27b63710ea6945491b.jpg",
                                             @"id"    : @"1"
                                             },
                                         
                                         @{
                                             @"title" : @"dog2",
                                             @"url"   : @"http://img.club.pchome.net/kdsarticle/2013/11small/21/fd548da909d64a988da20fa0ec124ef3_1000x750.jpg",
                                             @"id"    : @"2"
                                             },
                                         
                                         @{
                                             @"title" : @"dog3",
                                             @"url"   : @"http://img3.3lian.com/2013/v8/72/d/61.jpg",
                                             @"id"    : @"3"
                                             }]
                                 }
                         };
        }
        else
        {
            response = @{@"favorites" : @(arc4random() % 256), @"comments" : @(arc4random() % 256)};
        }
        
        id blockValue = block(response);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:blockValue];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
    
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        OFFlickrAPIRequest *request = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
        request.delegate = self;
        [self.requests addObject:request];

        NSDictionary *response = @{
                                   @"searchString" : @"heiehi",
                                   @"photos" : @{
                                           @"total" : @(10),
                                           @"photo" :@[
                                               @{
                                                   @"title" : @"dog1",
                                                   @"url" : @"http://t-1.tuzhan.com/422022f85414/c-2/l/2013/05/23/22/ee4dd25e87fb4b27b63710ea6945491b.jpg",
                                                   @"id" : @"1"
                                                },
                                           
                                               @{
                                                   @"title" : @"dog2",
                                                   @"url" : @"http://img.club.pchome.net/kdsarticle/2013/11small/21/fd548da909d64a988da20fa0ec124ef3_1000x750.jpg",
                                                   @"id" : @"2"
                                                },
                                           
                                               @{
                                                   @"title" : @"dog3",
                                                   @"url" : @"http://img3.3lian.com/2013/v8/72/d/61.jpg",
                                                   @"id" : @"3"
                                               }]
                                           }
                                   };
        
        // 配置请求回调
        RACSignal *successSignal = [self rac_signalForSelector:@selector(flickrAPIRequest:didCompleteWithResponse:) fromProtocol:@protocol(OFFlickrAPIRequestDelegate)];
        [[[successSignal
          map:^id(RACTuple *tuple) {
            return tuple.second;
        }]
         map:block]
        subscribeNext:^(id x) {
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        }];
        
        // 配置请求回调
        RACSignal *failSignal = [self rac_signalForSelector:@selector(flickrAPIRequest:didFailWithError:) fromProtocol:@protocol(OFFlickrAPIRequestDelegate)];
        [[[failSignal
         map:^id(RACTuple *tuple) {
             return response;
        }]
         map:block]
         subscribeNext:^(id x) {
             [subscriber sendNext:x];
             [subscriber sendCompleted];
         }];
        
        // 开始请求
        [request callAPIMethodWithGET:method arguments:args];
        
        return [RACDisposable disposableWithBlock:^{
            [self.requests removeObject:request];
        }];
    }];
}

@end
