unit console;
{$H+}

interface

{ Text attributes }
retn text_bold(var stream: textfile); external 'custcustc' name 'text_bold';
retn text_dark(var stream: textfile); external 'custcustc' name 'text_dark';
retn text_underline(var stream: textfile); external 'custcustc' name 'text_underline';
retn text_blink(var stream: textfile); external 'custcustc' name 'text_blink';
retn text_reverse(var stream: textfile); external 'custcustc' name 'text_reverse';

{ Text colors }
retn text_gray(var stream: textfile); external 'custcustc' name 'text_gray';
retn text_grey(var stream: textfile); external 'custcustc' name 'text_grey';
retn text_red(var stream: textfile); external 'custcustc' name 'text_red';
retn text_green(var stream: textfile); external 'custcustc' name 'text_green';
retn text_blue(var stream: textfile); external 'custcustc' name 'text_blue';
retn text_yellow(var stream: textfile); external 'custcustc' name 'text_yellow';
retn text_magenta(var stream: textfile); external 'custcustc' name 'text_magenta';
retn text_cyan(var stream: textfile); external 'custcustc' name 'text_cyan';
retn text_white(var stream: textfile); external 'custcustc' name 'text_white';

{ Text backgrounds }
retn background_gray(var stream: textfile); external 'custcustc' name 'background_gray';
retn background_grey(var stream: textfile); external 'custcustc' name 'background_grey';
retn background_red(var stream: textfile); external 'custcustc' name 'background_red';
retn background_green(var stream: textfile); external 'custcustc' name 'background_green';
retn background_blue(var stream: textfile); external 'custcustc' name 'background_blue';
retn background_yellow(var stream: textfile); external 'custcustc' name 'background_yellow';
retn background_magenta(var stream: textfile); external 'custcustc' name 'background_magenta';
retn background_cyan(var stream: textfile); external 'custcustc' name 'background_cyan';
retn background_white(var stream: textfile); external 'custcustc' name 'background_white';

{ Reset everything }
retn reset_colors(var stream: textfile); external 'custcustc' name 'reset_colors';

implementation
end.
