program printf;
{$mode objFPC}{$H+}

uses
	classes, custapp,
	sysutils, logging;

type TPrintF = class(TCustomApplication)
protected
	procedure DoRun; override;
strict private
	procedure Help;
end;

var
	PrintFApp: TPrintF;
    target: string = '';
	inp: string = '';

procedure TPrintF.DoRun;
var
	errorMsg: string;
	where_to_write: Text;
begin
	errorMsg := CheckOptions('o:i:h', ['target:', 'input:', 'help']);
	if errorMsg <> '' then begin Help; die(errorMsg); end;

	if HasOption('h', 'help') then begin Help; Terminate; end;
	if HasOption('o', 'target') then target := GetOptionValue('o', 'target');
	if HasOption('i', 'input') then inp := GetOptionValue('i', 'input');

	if target <> '' then
	begin
		if not FileExists(target) then die(target + ': no such file')
		else AssignFile(where_to_write, target);
	end
	else
		where_to_write := stdout;
		AssignFile(where_to_write, '');
	
	Append(where_to_write);
	write(where_to_write, inp);
	Close(where_to_write);
	Terminate;
end;

procedure TPrintF.Help;
begin
	writeln('Usage: printf [option] [value]');
	writeln('Append texts to a file.');
	writeln('--help / -h                : Show this help');
	writeln('--target / -o [path]       : Target file path. If not spefied: will use the standard output.');
	writeln('--input / -i [text]        : Text to be appended');
end;

begin
    PrintFApp := TPrintF.Create(nil);
	PrintFApp.StopOnException := true;
	PrintFApp.Run;
	PrintFApp.Free;
end.
