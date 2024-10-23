/* CMSC 430 Compiler Theory and Design
   Project 1 Skeleton
   UMGC CITE, Summer 2023
   Robert Carswell
   6 February 2024

   This file contains flex input file with the following changes were made during
	Project 1 and identified below with 1 modified lexeme and operator.
	Some are not listded because of comment errors but I addedd integer 
	and updated comment literals to include the regex becasue "--" no longer
   workes.*/

%{
#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		(?:\/\/|--).*\n
line		[\n]
id		[A-Za-z](_{0,2}[A-Za-z0-9])*
digit		[0-9]
dec		{digit}+
char		('.'|'\\b'|'\\t'|'\\n'|'\\b'|'\\f')
punc		[\(\),:;]
reals	[0-9]*\.[0-9]+([Ee]([+-]?[0-9]+)?)?
integers		[?<=#][A-Fa-f0-9]([A-Fa-f0-9])*

%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine(); }
"+"		{ ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
"&"		{ ECHO; return(ANDOP); }
"<"		{ ECHO; return(RELOP); }
"=>"		{ ECHO; return(ARROW); }
begin		{ ECHO; return(BEGIN_); }
case		{ ECHO; return(CASE); }
character	{ ECHO; return(CHARACTER); }
else		{ ECHO; return(ELSE); }
end		{ ECHO; return(END); }
endswitch	{ ECHO; return(ENDSWITCH); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
list		{ ECHO; return(LIST); }
of		{ ECHO; return(OF); }
others		{ ECHO; return(OTHERS); }
returns		{ ECHO; return(RETURNS); }
switch		{ ECHO; return(SWITCH); }
when		{ ECHO; return(WHEN); }

elsif		{ ECHO; return(ELSIF);}  //added project 1
endfold	{ ECHO; return(ENDFOLD); } //added project 1
endif		{ ECHO; return(ENDIF); } //added project 1
fold		{ ECHO; return(FOLD); } //added project 1
if		{ ECHO; return(IF); } //added project 1
left		{ ECHO; return(LEFT); } //added project 1
real		{ ECHO; return(REAL); } //added project 1
right		{ ECHO; return(RIGHT); } //added project 1
then		{ ECHO; return(THEN); } //added project 1

"|"		{ ECHO; return(OROP); } //added project 1
"!"		{ ECHO; return(NOTOP); } //added project 1

"="		{ ECHO; return(RELOP); } //added project 1
"<>"		{ ECHO; return(RELOP); } //added project 1
">"		{ ECHO; return(RELOP); } //added project 1
">="		{ ECHO; return(RELOP); } //added project 1
"<="		{ ECHO; return(RELOP); } //added project 1

"-"		{ ECHO; return(ADDOP); } //added project 1

"/"		{ ECHO; return(MULOP); } //added project 1

"%"		{ ECHO; return(MODOP); } //updated project 2

"^"		{ ECHO; return(EXPOP); } //added project 1

"~"		{ ECHO; return(NEGOP); } //added project 1

{integers} { ECHO; return(INT_LITERAL);}
{reals} { ECHO; return(REAL_LITERAL);}
{id}		{ ECHO; return(IDENTIFIER);}
{dec}		{ ECHO; return(INT_LITERAL); }
{char}		{ ECHO; return(CHAR_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%

