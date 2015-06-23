//
//  main.m
//  CaesarCipher
//
//  Created by Michael Kavouras on 6/21/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaesarCipher : NSObject

- (NSString *)decode:(NSString *)string offset:(int)offset;
- (NSString *)encode:(NSString *)string offset:(int)offset;
- (BOOL) isEqual:(NSString*)first other:(NSString*)second;

@end

@implementation CaesarCipher

- (NSString *)encode:(NSString *)string offset:(int)offset {
    unsigned long count = [string length];
    unichar result[count];
    unichar buffer[count];
    [string getCharacters:buffer range:NSMakeRange(0, count)];
    
    for (int i = 0; i < count; i++) {
        if (buffer[i] == ' ' || ispunct(buffer[i])) {
            result[i] = buffer[i];
            continue;
        }
        
   
        int low = islower(buffer[i]) ? 'a' : 'A';
        result[i] = (buffer[i]%low + offset)%26 + low;
    }
    
    return [NSString stringWithCharacters:result length:count];
}

- (NSString *)decode:(NSString *)string offset:(int)offset {
    return [self encode:string offset: (26 - offset)];
}

//comparison method
- (BOOL) isEqual:(NSString*)first other:(NSString*)second{
    if ([first length]!= [second length]){
        return NO;
    }
    //run through all possible offsets and see if one matches
    CaesarCipher * temp = [[CaesarCipher alloc] init];
    for (int i=1; i<26; i++){
        NSString *holder = [temp encode:second offset:i];
        if([first isEqualToString:holder]){
            return YES;
        }
    }
    return NO;
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
       
        CaesarCipher *str = [[CaesarCipher alloc] init];
        
        NSString *test = @"$my NAME, is VarinDra?";
        NSString *cipher = [str encode:test offset:3];
        NSString *reverse = [str decode:cipher offset:3];
        
        NSLog(@"%@\n",test);
        NSLog(@"%@\n",cipher);
        NSLog(@"%@\n",reverse);
    
                
                
        if([str isEqual:cipher other:[str encode:@"hello I am sphagetti" offset:4]]){
            NSLog(@"Yeah");
        }
        else{
            NSLog(@"Nope");
        }
        
        
        

    }
}