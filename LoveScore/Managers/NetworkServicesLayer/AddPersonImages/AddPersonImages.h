//
//  AddPersonImages.h
//  LoveScore
//
//  Created by Oleksandr on 12/19/15.
//  Copyright © 2015 KindGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIHTTPClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface AddPersonImages : NSObject

- (RACSignal *)deletePhotoWithPersonId:(NSString *)personId andImagesArrayId:(NSArray *)array;

- (RACSignal *)uploadImage:(NSArray *)imagesArray
                    inView:(UIView *)imageView
                   forUUID:(NSString *)uuid
               imagesNames:(NSArray *)imagesName;
@end
