%{

/*
 * Parser.y file
 * To generate the parser run: "bison Parser.y"
 */

#include "Expression.h"
#include "Parser.h"
#include "Lexer.h"

// reference the implementation provided in Lexer.l
int yyerror(SExpression **expression, yyscan_t scanner, const char *msg);

%}

%code requires {
  typedef void* yyscan_t;
}

%output  "Parser.c"
%defines "Parser.h"

%define api.pure
%lex-param   { yyscan_t scanner }
%parse-param { SExpression **expression }
%parse-param { yyscan_t scanner }

%union {
    double value1;
    SExpression *expression1;
}

%token TOKEN_LPAREN   "("
%token TOKEN_RPAREN   ")"
%token TOKEN_PLUS     "+"
%token TOKEN_MINUS    "-"
%token TOKEN_STAR     "*"
%token TOKEN_DIV      "/"

%token <value1> TOKEN_NUMBER "number"

%type <expression1> expr

/* Precedence (increasing) and associativity:
   a+b+c is (a+b)+c: left associativity
   a+b*c is a+(b*c): the precedence of "*" is higher than that of "+". */
%left "+" "-"
%left "*" "/"

%%

input
    : expr { *expression = $1; }
    ;

expr
    : expr[L] "+" expr[R] { $$ = createOperation( eADD, $L, $R ); }
    | expr[L] "*" expr[R] { $$ = createOperation( eMULTIPLY, $L, $R ); }
    | expr[L] "-" expr[R] { $$ = createOperation( eMINUS, $L, $R ); }
    | expr[L] "/" expr[R] { $$ = createOperation( eDIV, $L, $R ); }
    | "(" expr[E] ")"     { $$ = $E; }
    | "number"            { $$ = createNumber($1); }
    ;

%%
