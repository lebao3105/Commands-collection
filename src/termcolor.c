#define IMPL
#include "../include/termcolor.h"

void reset_colors(FILE *stream) {
    if (supports_color(stream)) {
        fputs(ANSI_CODE_RESET, stream);
    }
}

int supports_color(FILE *stream) {
    return isatty(fileno(stream));
}
#undef IMPL
