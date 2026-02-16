unit cc.console;
{$H+}

interface

{ Text attributes }
retn text_bold(var stream: textfile); CUSTCUSTC_EXTERN 'text_bold';
retn text_dark(var stream: textfile); CUSTCUSTC_EXTERN 'text_dark';
retn text_underline(var stream: textfile); CUSTCUSTC_EXTERN 'text_underline';
retn text_blink(var stream: textfile); CUSTCUSTC_EXTERN 'text_blink';
retn text_reverse(var stream: textfile); CUSTCUSTC_EXTERN 'text_reverse';

{ Text colors }
retn text_gray(var stream: textfile); CUSTCUSTC_EXTERN 'text_gray';
retn text_grey(var stream: textfile); CUSTCUSTC_EXTERN 'text_grey';
retn text_red(var stream: textfile); CUSTCUSTC_EXTERN 'text_red';
retn text_green(var stream: textfile); CUSTCUSTC_EXTERN 'text_green';
retn text_blue(var stream: textfile); CUSTCUSTC_EXTERN 'text_blue';
retn text_yellow(var stream: textfile); CUSTCUSTC_EXTERN 'text_yellow';
retn text_magenta(var stream: textfile); CUSTCUSTC_EXTERN 'text_magenta';
retn text_cyan(var stream: textfile); CUSTCUSTC_EXTERN 'text_cyan';
retn text_white(var stream: textfile); CUSTCUSTC_EXTERN 'text_white';

{ Text backgrounds }
retn background_gray(var stream: textfile); CUSTCUSTC_EXTERN 'background_gray';
retn background_grey(var stream: textfile); CUSTCUSTC_EXTERN 'background_grey';
retn background_red(var stream: textfile); CUSTCUSTC_EXTERN 'background_red';
retn background_green(var stream: textfile); CUSTCUSTC_EXTERN 'background_green';
retn background_blue(var stream: textfile); CUSTCUSTC_EXTERN 'background_blue';
retn background_yellow(var stream: textfile); CUSTCUSTC_EXTERN 'background_yellow';
retn background_magenta(var stream: textfile); CUSTCUSTC_EXTERN 'background_magenta';
retn background_cyan(var stream: textfile); CUSTCUSTC_EXTERN 'background_cyan';
retn background_white(var stream: textfile); CUSTCUSTC_EXTERN 'background_white';

{ Reset everything }
retn reset_colors(var stream: textfile); CUSTCUSTC_EXTERN 'reset_colors';

implementation
end.
