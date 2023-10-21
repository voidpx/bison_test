/*
 * main.c file
 */

#include "Expression.h"
#include "Parser.h"
#include "Lexer.h"

#include <stdio.h>

int yyparse(SExpression **expression, yyscan_t scanner);

SExpression *getAST(const char *expr)
{
    SExpression *expression;
    yyscan_t scanner;
    YY_BUFFER_STATE state;

    if (yylex_init(&scanner)) {
        /* could not initialize */
        return NULL;
    }

    state = yy_scan_string(expr, scanner);

    if (yyparse(&expression, scanner)) {
        /* error parsing */
        return NULL;
    }

    yy_delete_buffer(state, scanner);

    yylex_destroy(scanner);

    return expression;
}

int main(void)
{
//    char test[] = " 4 + 2*10 + 3*( 5 + 1 ) - 33";
    char b[1024];
    size_t n = 1024;
    char* p = b;
    while (1) {
		int r = getline(&p, &n, stdin);
		if (r < 0) {
			break;
		}
		SExpression *e = getAST(p);
		double result = evaluate(e);
		printf("%g\n", result);
//		printf("Result of '%s' is %d\n", test, result);
		deleteExpression(e);
    }
    return 0;
}
