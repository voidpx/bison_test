%{

/*
 * Lexer.l file
 * To generate the lexical analyzer run: "flex Lexer.l"
 */

#include "Expression.h"
#include "Parser.h"

#include <stdio.h>

%}

%option outfile="Lexer.c" header-file="Lexer.h"
%option warn nodefault

%option reentrant noyywrap never-interactive nounistd
%option bison-bridge

%%

[ \r\n\t]*   { continue; /* Skip blanks. */ }
[0-9]+(\.[0-9]+)?       { sscanf(yytext, "%lf", &yylval->value1); return TOKEN_NUMBER; }

"*"          { return TOKEN_STAR; }
"+"          { return TOKEN_PLUS; }
"-"          { return TOKEN_MINUS; }
"/"          { return TOKEN_DIV; }
"("          { return TOKEN_LPAREN; }
")"          { return TOKEN_RPAREN; }

.            { continue; /* Ignore unexpected characters. */}

%%

int yyerror(SExpression **expression, yyscan_t scanner, const char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
    return 0;
}

