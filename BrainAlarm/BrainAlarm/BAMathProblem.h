//
//  BAMathProblem.h
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 11/4/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAMathProblem : NSObject

@property int answer;
@property int operand1;
@property int operand2;
@property NSString *operation;

-(BOOL) isAnswerCorrect:(int)answer;
-(NSString*)ToString;
-(instancetype)initGenerateProblem;

@end
