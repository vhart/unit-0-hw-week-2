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

//Method for printing the winner's name or if tied, the tying names
- (void)winnerIs {
    NSInteger i=0;
    int count = 1;
    //iterate through contenders and record MAX number of votes
    for (Contender *c in _listOfContenders){
        
        //if multiple contenders have the same vote count, increase count value by 1
        if (i == [c votesReceived]){
            count++;
        }
        //Every time a higher vote count is found, set the count back to 1
        if(i < [c votesReceived]){
            i = [c votesReceived];
            count = 1;
        }
        
    }
    int j = 1;
    
    //ternary conditional to determine if there is one winner or a tie: count = 1 if only one winner, count > 1 if a tie
    NSString *print = [NSString stringWithFormat:@"\n%@", (count==1) ? @"The winner is: " : @"We have a tie between: "] ;
    
    //iterate through contenders again, although a nested for loop with an if statement could be used as well
    for (Contender *c in _listOfContenders){
        
        //determines if to print a single name, namely if there is ONLY one winner; appends "and" if there is a tie;
        if(i == [c votesReceived] && j == count){
            print = [print stringByAppendingFormat:@"%@",(count==1) ?[c name] : [@"and " stringByAppendingString:[c name]]];
            j++;
            continue;
        }
        
        //if only a tie between two we need no comma just a name; if more than two add commas
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

//Voting Simulator class
@interface VotingSimulator: NSObject

//custom initializing method, idea borrowed from initializers above!
-(instancetype)initWithManager:(ElectionManager *)manager;
-(void)runElection;

@end

@implementation VotingSimulator {
 ElectionManager * _manager;
}
//initialize with a manager decided
-(instancetype)initWithManager:(ElectionManager *)manager{
    if (self = [super init]) {
        _manager = manager;
        return self;
    }
    return nil;
}

/*1. manager will initial polling
  2. Polling will continue until user quits polling, at which point
     manager will display results of poll
  3. System will load the winnerIs method and wait until display results is completed before executing the printing of the winnerIs method. winnerIs traverses to manager
      then manager executes winnerIs on the election, and election prints result!
 
 Thats it, program exits
 */
-(void)runElection {
    [_manager initiatePolling];
    printf("\n");
    [_manager displayResults];
    [_manager winnerIs];
}

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        //three contenders
        Contender *first = [[Contender alloc] initWithName:@"Blue"];
        Contender *second = [[Contender alloc] initWithName:@"Red"];
        Contender *third = [[Contender alloc] initWithName:@"Green"];
        
        //election
        Election *bam = [[Election alloc] initWithElectionName:@"Color Race"];
        
        //manager
        ElectionManager *Jah_mez = [[ElectionManager alloc] init];
        [Jah_mez manage:bam];
        
        //add contenders
        [bam addContender: first];
        [bam addContender: second];
        [bam addContender: third];
        
        //voting simulator created and then election begins
        VotingSimulator *voting2015 = [[VotingSimulator alloc] initWithManager:Jah_mez];
        [voting2015 runElection];
        
        
        
    }
    return 0;
}
