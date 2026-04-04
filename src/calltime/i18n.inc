resourcestring
{$ifdef NEED_PROGRAM_HELP}
{$define HAS_BONUS_HELP}
    FORMAT_DES = 'Time format';
    PROGRAM_DESC = 'Returns the current time and date, in style.';
    PROGRAM_BONUS_HELP = 'Consult https://www.freepascal.org/docs-html/rtl/sysutils/formatchars.html '
                        +'for more information about time format strings.';
{$else}
    TIME_IS = 'The current time is: ';
    DEFAULT_FORMAT = 'dddd mmmm dd yyyy tt';
{$endif}
