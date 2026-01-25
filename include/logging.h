#pragma once

void debug(const char* format, ...);
void info(const char* format, ...);
void warn(const char* format, ...);
void error(const char* format, ...);
void fatal(const char* format, ...);
void fatal_and_terminate(int exit_code, const char* format, ...);
char confirmation(const char* format, ...);
