//
//  main.m
//  Person
//
//  Created by Michael Kavouras on 6/21/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person: NSObject

- (void)setName:(NSString *)name;
- (NSString *)name;

- (void)setCity:(NSString *)city;
- (NSString *)city;

- (void)setPhoneNumber:(NSString *)phoneNumber;
- (NSString *)phoneNumber;

- (Person *) registerChild;
- (BOOL)checkSameCity:(Person *)other;


@end

@implementation Person {
    NSString *_name;
    NSString *_phoneNumber;
    NSString *_city;
}

- (void)setName:(NSString *)name {
    _name = name;
}

- (NSString *)name {
    return _name;
}

- (void)setCity:(NSString *)city {
    _city = city;
}

- (NSString *)city {
    return _city;
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    _phoneNumber = phoneNumber;
}

- (NSString *)phoneNumber {
    return _phoneNumber;
}

- (Person *)registerChild {
    Person *child = [[Person alloc] init];
    [child setName:@"Abc"];
    [child setCity:self.city];
    [child setPhoneNumber:self.phoneNumber];
    return child;
}

- (BOOL)checkSameCity:(Person *)other{
    if([_city isEqualToString:[other city]]){
        return YES;
    }
        return NO;
}

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        Person *parent = [[Person alloc] init];
        [parent setPhoneNumber:@"555-555-5555"];
        [parent setCity:@"NY"];
        Person *kid = [parent registerChild];
        NSLog(@"%@ \n%@",[kid name], [kid phoneNumber]);
        NSLog(@"%d",[parent checkSameCity:kid]);
        
        
    }
    return 0;
}
