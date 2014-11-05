//
//  BAMathProblem.m
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 11/5/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import "BAMathProblem.h"

@implementation BAMathProblem

-(BOOL)isAnswerCorrect:(int)answer
{
    if(self.answer == answer)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(NSString*)ToString
{
    NSString *result = [NSString stringWithFormat:@"%d %@ %d", self.operand1, self.operation, self.operand2];
    return result;
}

-(instancetype) initGenerateProblem
{
    self = [super init];
    if(self)
    {
        int operationInt = 1 + arc4random_uniform(3);
        int lBound, uBound;
        
        switch(operationInt)
        {
            case 1:
                self.operation = @"+";
                lBound = 101;
                uBound = 9999;
                
                self.operand1 = lBound + arc4random_uniform(uBound - lBound + 1);
                self.operand2 = lBound + arc4random_uniform(uBound - lBound + 1);
                self.answer = self.operand1 + self.operand2;
                
                break;
            case 2:
                self.operation = @"-";
                lBound = 101;
                uBound = 9999;
                
                self.operand1 = lBound + arc4random_uniform(uBound - lBound + 1);
                self.operand2 = lBound + arc4random_uniform(uBound - lBound + 1);
                self.answer = self.operand1 - self.operand2;
                break;
                
            case 3:
                self.operation = @"*";
                lBound = 11;
                uBound = 99;
                
                self.operand1 = lBound + arc4random_uniform(uBound - lBound + 1);
                self.operand2 = lBound + arc4random_uniform(uBound - lBound + 1);
                self.answer = self.operand1 * self.operand2;
                break;
        }
    }
    return self;
    
}

@end