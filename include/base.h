#pragma once

#include <libintl.h>
#include <limits.h>

#define TO_STR(X) #X

/*
 * This macro will generate a
 * variable that returns the specified
 * C definition's value.
 */
#define GET_DEFINITION_VAL(NAME) \
	const char* get_##NAME = NAME;

#define _(String) gettext(String)

// Allocate a string from count(the parameter) c(the parameter)s
// Since allocating memory is involved, free() is neccessary.
extern const char *StringOfCharP(const char c, const int count);

// Converts an integer to a string.
extern const char *IntToStrP(int num);
