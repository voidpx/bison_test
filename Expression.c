/*
 * Expression.c
 * Implementation of functions used to build the syntax tree.
 */

#include "Expression.h"

#include <stdlib.h>

/**
 * @brief Allocates space for expression
 * @return The expression or NULL if not enough memory
 */
static SExpression *allocateExpression()
{
    SExpression *b = (SExpression *)malloc(sizeof(SExpression));

    if (b == NULL)
        return NULL;

    b->type = eVALUE;
    b->value = 0;

    b->left = NULL;
    b->right = NULL;

    return b;
}

SExpression *createNumber(double value)
{
    SExpression *b = allocateExpression();

    if (b == NULL)
        return NULL;

    b->type = eVALUE;
    b->value = value;

    return b;
}

SExpression *createOperation(EOperationType type, SExpression *left, SExpression *right)
{
    SExpression *b = allocateExpression();

    if (b == NULL)
        return NULL;

    b->type = type;
    b->left = left;
    b->right = right;

    return b;
}

void deleteExpression(SExpression *b)
{
    if (b == NULL)
        return;

    deleteExpression(b->left);
    deleteExpression(b->right);

    free(b);
}

double evaluate(SExpression *e)
{
    switch (e->type) {
        case eVALUE:
            return e->value;
        case eMULTIPLY:
            return evaluate(e->left) * evaluate(e->right);
        case eADD:
            return evaluate(e->left) + evaluate(e->right);
        case eMINUS:
			return evaluate(e->left) - evaluate(e->right);
		case eDIV:
			return evaluate(e->left) / evaluate(e->right);
        default:
            /* should not be here */
            return 0;
    }
}
