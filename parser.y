/* CMSC 430 Compiler Theory and Design
   Project 1 Skeleton
   UMGC CITE, Summer 2023
   Robert Carswell
   6 February 2024

   Added new tokens ELSE, ELSIF, ENDFOLD, ENDIF, FOLD, IF, 
   LEFT, REAL, RIGHT, THEN, OROP, NOTOP, MODOP, EXPOP, NEGOP
   Added gramer for if, then, else statments, and list_choice
   Modified: varaible to handle 0 or more, parameter to be conditional
   and handle 0 or more opertions that are seperated by a comma
   Added ANDOP | OROP | ADDOP | NOTOP | MULOP | MODOP | EXPOP | NEGOP
   operator precedence and associativity
   Added error productions to each level*/

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER INT_LITERAL CHAR_LITERAL

%token ADDOP MULOP ANDOP RELOP ARROW

%token BEGIN_ CASE CHARACTER ELSE END ENDSWITCH FUNCTION INTEGER IS LIST OF OTHERS
	RETURNS SWITCH WHEN

%token REAL IF THEN ELSIF ENDIF FOLD ENDFOLD LEFT RIGHT NOTOP OROP NEGOP REAL_LITERAL
	MODOP EXPOP
%%

function:	
	function_header variables body ;

function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';'| error ';' ;

parameters:
	parameter optional_parameter | %empty ;

optional_parameter:
	optional_parameter optional_parameters | %empty ;

optional_parameters:
	',' parameter ;

parameter:
	IDENTIFIER ':' type ;

type:
	INTEGER | REAL | CHARACTER ;
	
variables:
	variables variable |error ';' | %empty ;
    
variable:	
	IDENTIFIER ':' type IS statement |
	IDENTIFIER ':' LIST OF type IS list ';' ;

list:
	'(' expression lists ')' ;

lists:
	lists expressions | %empty ; 
	
expressions:
	',' expression ;

body:
	BEGIN_ statement_  END ';' ;

statement_:
	statement  ;
    
statement:
	expression ';' |
	WHEN condition ',' expression ':' expression ';' |
	SWITCH expression IS cases OTHERS ARROW statement ENDSWITCH ';' |
	IF condition THEN statement elsifs ELSE statement ENDIF ';'|
	FOLD direction operator list_choice ENDFOLD ';'| error ';' ;

elsifs:
	elsifs elsif | %empty ;

elsif:
	ELSIF condition THEN statement ;

cases:
	cases case | error ';'| %empty ;
	
case:
	CASE INT_LITERAL ARROW statement ; 

direction: LEFT | RIGHT ;

operator: OROP | ANDOP | NOTOP | ADDOP | MULOP | MODOP | EXPOP | NEGOP;

list_choice: list | IDENTIFIER ;

condition:
	condition2 ;

condition2:
	condition2 OROP condition3 | condition3 ;

condition3:
	condition3 ANDOP condition4 | condition4 ;

condition4:
	NOTOP conditions | conditions ;

conditions:
	'(' condition2 ')' | 
    expression RELOP expression ;


expression:
	expression2 ;

expression2:
	expression2 ADDOP expression3 | expression3 ;
	
expression3:
	expression3 MULOP expression4 | expression3 MODOP expression4 | expression4 ;

expression4:
	expression5 | expression4 EXPOP expression5 ;

expression5:
	NEGOP primary | primary ;

primary:
	'(' expression2 ')' |
	INT_LITERAL | REAL_LITERAL | 
	CHAR_LITERAL |
	IDENTIFIER '(' expression2 ')' |
	IDENTIFIER ;

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
