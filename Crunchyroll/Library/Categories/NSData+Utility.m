//
//  NSData+Utility.m
//  Crunchyroll
//
//  Created by Genry on 6/1/14.
//  Copyright (c) 2014 Genry. All rights reserved.
//

#import "NSData+Utility.h"

@implementation NSData (Utility)

-(CCHImageType)contentTypeForImageData {
    uint8_t c;
    [self getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return CCHImageTypeJPEG;
        case 0x89:
            return CCHImageTypePNG;
        case 0x47:
            return CCHImageTypeGIF;
        case 0x49:
        case 0x4D:
            return CCHImageTypeTIFF;
    }
    return CCHImageTypeUndefined;
}

@end
