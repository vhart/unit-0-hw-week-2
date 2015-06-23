//
//  main.m
//  Election
//
//  Created by Michael Kavouras on 6/21/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

// forward declarations
@class Contender;
@class Election;

// Contender class
@interface Contender : NSObject

- (instancetype)initWithName:(NSString *)name;
    
- (void)addVote;
- (NSInteger)votesReceived;
- (NSString *)name;

@end

@implementation Contender {
    NSInteger _votesReceived;
    NSString *_name;
}

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        _votesReceived = 0;
        _name = name;
        return self;
    }
    return nil;
}

- (void)addVote {
    _votesReceived++;
}

- (NSInteger)votesReceived {
    return _votesReceived;
}

- (NSString *)name {
    return _name;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ received %ld votes", _name, _votesReceived];
}

@end


@interface Election : NSObject

- (instancetype)initWithElectionName:(NSString *)name;

- (void)setElectionName:(NSString *)name;
- (NSString *)electionName;

- (void)addContender:(Contender *)contender;
- (void)vote;
- (void)vote:(NSInteger)index;
- (void)displayCandidates;
- (void)displayResults;
- (void)winnerIs;

@end


// Election class
@implementation Election {
    NSString *_electionName;
    NSMutableArray *_listOfContenders;
    NSMutableArray *_listOfWinners;
}

- (instancetype)initWithElectionName:(NSString *)name {
    if (self = [super init]) {
        _electionName = name;
        return self;
    }
    return nil;
}

- (void)addContender:(Contender *)contender {
   if (_listOfContenders == nil) {
       _listOfContenders = [[NSMutableArray alloc] init];
   }
    [_listOfContenders addObject:contender];
}

- (void)setElectionName:(NSString *)name {
    _electionName = name;
}

- (NSString *)electionName {
    return _electionName;
}

- (void)vote:(NSInteger)index {
    Contender *contender = (Contender *)[_listOfContenders objectAtIndex:index];
    [contender addVote];
}

- (void)displayCandidates {
    for (Contender *c in _listOfContenders) {
        NSLog(@"%@", [c name]);
    }
}


- (void)displayResults {
    printf("\n%s\n", [_electionName UTF8String]);
    for (Contender *c in _listOfContenders) {
        usleep(4e5);
        printf("%s\n", [[c description] UTF8String]);
    }
    usleep(4e5);
}

- (void)vote {
    NSInteger i = 1;
    
    for (Contender *c in _listOfContenders) {
        printf("\nIndex = %ld, Contender = %s", i, [[c name] UTF8String]);
        i++;
    }
    
    printf("\n");
    
    BOOL voted = NO;
    
    while (!voted) {
        printf("\nEnter the index of the Contender you want to vote for: ");
        int vote;
        scanf("%d", &vote);
        
        int index = vote - 1;
        
        if (index >= 0 && index < _listOfContenders.count) {
            [self vote:index];
            voted = true;
        } else {
            printf("Contender does not exist...\n");
        }
    }
        
}

- (void)winnerIs {
    NSInteger i=0;
    int count = 1;
    if (_listOfWinners == nil){
        _listOfWinners = [[NSMutableArray alloc] init];
    }
    
    for (Contender *c in _listOfContenders){
        if (i == [c votesReceived]){
            count++;
        }
        if(i < [c votesReceived]){
            i = [c votesReceived];
            count = 1;
        }
        
    }
    int j = 1;
    NSString *print = [NSString stringWithFormat:@"\n%@", (count==1) ? @"The winner is: " : @"We have a tie between: "] ;
    for (Contender *c in _listOfContenders){
        if(i == [c votesReceived] && j == count){
            print = [print stringByAppendingFormat:@"%@",(count==1) ?[c name] : [@"and " stringByAppendingString:[c name]]];
            j++;
            continue;
        }
        if( i == [c votesReceived]){
            print = [print stringByAppendingFormat:@"%@ ",(count == 2)? [c name] : [@", " stringByAppendingString:[c name]]];
            j++;
        }
    }
    
    printf("%s",[[print description] UTF8String]);
}

@end


// ElectionManager class
@interface ElectionManager : NSObject

- (void)manage:(Election *)race;
- (void)initiatePolling;
- (void)displayResults;
- (BOOL)pollsOpen;
- (void)winnerIs;

@end

@implementation ElectionManager {
    NSMutableArray *_races;
}

- (void)manage:(Election *)race {
    if (_races == nil) {
        _races = [[NSMutableArray alloc] init];
    }
    [_races addObject:race];
}

- (void)initiatePolling {
    while ([self pollsOpen]) {
        for (Election *race in _races) {
            printf("\nVOTE FOR ONE! \n");
            [race vote];
        }
    }
}

- (void)displayResults {
    printf("Results of voting...\n");
    for (Election *race in _races) {
        [race displayResults];
    }
}

- (BOOL)pollsOpen {
    printf("Type 0 to close polls otherwise enter 1 to continue: ");
    int answer;
    scanf("%d", &answer);
    fpurge(stdin);
    
    return answer != 0;
}

- (void)winnerIs {
    for(Election *race in _races){
        [race winnerIs];
    }
}

@end

@interface VotingSimulator: NSObject

-(instancetype)initWithManager:(ElectionManager *)manager;
//-(ElectionManager *)manager;
-(void)runElection;

@end

@implementation VotingSimulator {
 ElectionManager * _manager;
}

-(instancetype)initWithManager:(ElectionManager *)manager{
    if (self = [super init]) {
        _manager = manager;
        return self;
    }
    return nil;
}

-(void)runElection {
    [_manager initiatePolling];
    printf("\n");
    [_manager displayResults];
    [_manager winnerIs];
}

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Contender *first = [[Contender alloc] initWithName:@"Blue"];
        Contender *second = [[Contender alloc] initWithName:@"Red"];
        Contender *third = [[Contender alloc] initWithName:@"Green"];
        
        Election *bam = [[Election alloc] initWithElectionName:@"Color Race"];
        ElectionManager *Jah_mez = [[ElectionManager alloc] init];
        [Jah_mez manage:bam];
        [bam addContender: first];
        [bam addContender: second];
        [bam addContender: third];
        
        VotingSimulator *voting2015 = [[VotingSimulator alloc] initWithManager:Jah_mez];
        [voting2015 runElection];
        
        
        
    }
    return 0;
}
