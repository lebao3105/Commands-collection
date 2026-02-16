#include "../include/logging.h"
#include "../include/termcolor.h"

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#define VLOG(format, to_f) \
	va_list args; \
	va_start(args, format); \
	vfprintf(to_f, format, args); \
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

	VLOG(format, stdout);
	fputs("\n", stdout);

	#ifdef NDEBUG
	}
	#endif
}

void info(const char* format, ...)
{
	text_bold(stdout); text_blue(stdout);
	fputs("info: ", stdout);
	reset_colors(stdout);

	VLOG(format, stdout);
	fputs("\n", stdout);
}

void warn(const char* format, ...)
{
	text_bold(stdout); text_yellow(stdout);
	fputs("warn: ", stdout);
	reset_colors(stdout);

	VLOG(format, stdout);
	fputs("\n", stdout);
}

void error(const char* format, ...)
{
	text_bold(stderr); text_red(stderr);
	fputs("error: ", stderr);
	reset_colors(stderr);

	VLOG(format, stderr);
	fputs("\n", stderr);
}

void fatal(const char* format, ...)
{
	text_bold(stderr); text_red(stderr);
	fputs("fatal: ", stderr);
	reset_colors(stderr);

	VLOG(format, stderr);
	fputs("\n", stderr);
}

void fatal_and_terminate(int exit_code, const char* format, ...)
{
	text_bold(stderr); text_red(stderr);
	fputs("fatal: ", stderr);
	reset_colors(stderr);

	VLOG(format, stderr);
	fputs("\n", stderr);
	exit(exit_code);
}

char confirmation(const char* format, ...)
{
	VLOG(format, stdout);
	fputs("\n", stdout);

	text_bold(stdout); text_yellow(stdout);
	fputs("confirm [yYnNaA]: ", stdout);
	reset_colors(stdout);

	return (char)getchar();
}
