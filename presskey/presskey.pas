program presskey;
{$mode objfpc}{$h+}
uses
    crt, warn, color,
    classes, custapp;

type TPressKey = class(TCustomApplication)
protected
    procedure DoRun; override;
end;

var
    PressKeyApp: TPressKey;
	no_lndown: boolean;

procedure print_message(message:string);
begin
	if no_lndown then write(message) else writeln(message);
    repeat until (KeyPressed);
	halt(0);
end;

procedure TPressKey.DoRun;
var
	errorMsg: string;
begin
	errorMsg := CheckOptions('c:h', ['custom-message:', 'help', 'no-linedown']);
	if errorMsg <> '' then begin writeln(errorMsg); halt(1); end;
	if ParamCount = 0 then print_message('Press any key to continue...');

	if HasOption('h', 'help') then
	begin
		writeln(ParamStr(0) + ' [option]=[value]');
		writeln('Pauses the current execution until a key is pressed.');
		writeln('Available options:');
		writeln('--help / -h						Show this help');
		writeln('--custom-message / -c [value]		Set a custom message');
		writeln('--no-linedown						Do not append \n at the end of the message');
		halt(0);
	end;

	if HasOption('no-linedown') then no_lndown := true;
	if HasOption('c', 'custom-message') then print_message(GetOptionValue('c', 'custom-message'));
end;

begin
	// is this a bad usage of TPressKey and ParamCount?
	// if ParamCount = 0 then print_message('Press any key to continue...')
	PressKeyApp := TPressKey.Create(nil);
	PressKeyApp.StopOnException := true; // will there be exceptions?
	PressKeyApp.Run;
	PressKeyApp.Free;
end.
