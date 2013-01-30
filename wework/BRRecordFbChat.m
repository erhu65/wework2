//
//  BRRecordFbChat.m
//  BirthdayReminder
//
//  Created by Peter2 on 1/1/13.
//  Copyright (c) 2013 Nick Kuh. All rights reserved.
//

#import "BRRecordFbChat.h"

@implementation BRRecordFbChat

-(id)initWithJsonDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        
        self.type = [dic objectForKey:@"type"];
        self.fbId = [dic objectForKey:@"fbId"];
        self.fbName = [dic objectForKey:@"fbName"];
        self.uniquDataKey = [dic objectForKey:@"uniquDataKey"];
        
        //self.socketOwnerFbId = [dic objectForKey:@"senderFbId"];
        //self.senderFbId = [dic objectForKey:@"senderFbId"];
        self.msg = [dic objectForKey:@"msg"];
        //self.currentYoutubeKey = [dic objectForKey:@"currentYoutubeKey"];
//        if([self.currentYoutubeKey length] > 0){
//            BRRecordVideo* video =  [kSharedModel findVideoByYoutubeKey:self.currentYoutubeKey];
//            self.videoName = video.name;
//        } else {
//            
        //self.videoName = @"";
        //self.currentPlaybackTime = [dic objectForKey:@"currentPlaybackTime"];
        self.created_at = [NSDate date];
        
        self.strImgUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?", self.fbId];
        
        PRPLog(@"[self description]:%@  -[%@ , %@] \n ",
               [self description],
               NSStringFromClass([self class]),
               NSStringFromSelector(_cmd));
    }
    
    return self;
}

-(NSString*)description
{
    [super description];
    return [NSString stringWithFormat:@"self.type: %@ \n\
            self.fbId: %@ \n\
            self.msg: %@ \n\
            self.uniquDataKey %@",
            self.type,
            self.fbId,
            self.msg,
            self.uniquDataKey];
}
@end
