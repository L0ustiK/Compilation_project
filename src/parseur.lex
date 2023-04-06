%{
#include <stdio.h>
#include <string.h>
#include "tree.h"
#include "gram.tab.h"
int yylex();
int lineno = 1;
%}

%option noyywrap
%x COMMENT

%%
void {return VOID;}
if {return IF;}
else {return ELSE;}
while {return WHILE;}
return {return RETURN;}
int|char {yylval.name = strdup(yytext); return TYPE;}

[+-] {yylval.const_val = yytext[0]; return ADDSUB;}
[*/%] {yylval.const_val = yytext[0]; return DIVSTAR;}
[<>][=]? {return ORDER;}
[!=][=] {return EQ;}
&& {return AND;}
"||" {return OR;}

[_a-zA-Z][_a-zA-Z0-9]* {yylval.name = strdup(yytext); return IDENT;}

0|[1-9][0-9]* {yylval.const_val = atoi(yytext); return NUM;}
\'.\' {yylval.const_val = yytext[1]; return CHARACTER;}

[(){},=;!] {return yytext[0];}

\/\/.* ; /* // comment */
\/\* { BEGIN COMMENT; }
<COMMENT>\*\/ { BEGIN INITIAL; }
<COMMENT>.|\n ;

<<EOF>> {return 0;}
[ \t] {}
\n {lineno++;}
. {return 1;}
%%