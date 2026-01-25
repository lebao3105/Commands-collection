#include "../include/logging.h"
#include "../include/termcolor.h"

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#define VLOG(format) \
	va_list args; \
	va_start(args, format); \
	vprintf(format, args); \
	va_end(args)

void debug(const char* format, ...)
{
	#ifdef NDEBUG
	if (getenv("DEBUG"))
	{
	#endif

	text_bold(stdout); text_magenta(stdout);
	fputs("debug: ", stdout);
	reset_colors(stdout);

	VLOG(format);

	#ifdef NDEBUG
	}
	#endif
}

void info(const char* format, ...)
{
	text_bold(stdout); text_blue(stdout);
	fputs("info: ", stdout);
	reset_colors(stdout);

	VLOG(format);
}

void warn(const char* format, ...)
{
	text_bold(stdout); text_yellow(stdout);
	fputs("warn: ", stdout);
	reset_colors(stdout);

	VLOG(format);
}

void error(const char* format, ...)
{
	text_bold(stderr); text_red(stderr);
	fputs("error: ", stderr);
	reset_colors(stderr);

	VLOG(format);
}

void fatal(const char* format, ...)
{
	text_bold(stderr); text_red(stderr);
	fputs("fatal: ", stderr);
	reset_colors(stderr);

	VLOG(format);
}

void fatal_and_terminate(int exit_code, const char* format, ...)
{
	text_bold(stderr); text_red(stderr);
	fputs("fatal: ", stderr);
	reset_colors(stderr);

	VLOG(format);
	exit(exit_code);
}

char confirmation(const char* format, ...)
{
	text_bold(stdout); text_yellow(stdout);
	fputs("confirm [yYnNaA]: ", stderr);
	reset_colors(stdout);

	VLOG(format);
	return (char)getchar();
}
