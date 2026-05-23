// All codes can be seen at
// https://en.wikipedia.org/wiki/ANSI_escape_code#Select_Graphic_Rendition_parameters

{$define ANSI_CODE_RESET     := ANSIEscapeSequence(#27'[0m')}
{$define ANSI_CODE_BOLD      := ANSIEscapeSequence(#27'[1m')}
{$define ANSI_CODE_UNDERLINE := ANSIEscapeSequence(#27'[4m')}
{$define ANSI_CODE_BLINK     := ANSIEscapeSequence(#27'[5m')}
// Attr no. 6: rapid blink
// Attr no. 7: swap fore & back
// Attr no. 8: hide
// Attr no. 9: crossed out (wow this exists)
{$define ANSI_CODE_NO_BOLD      := ANSIEscapeSequence(#27'[22m')}
{$define ANSI_CODE_NO_UNDERLINE := ANSIEscapeSequence(#27'[24m')}
{$define ANSI_CODE_NO_BLINK     := ANSIEscapeSequence(#27'[25m')}
{$define ANSI_CODE_RESET_FORE   := ANSIEscapeSequence(#27'[39m')}
{$define ANSI_CODE_RESET_BACK   := ANSIEscapeSequence(#27'[49m')}
