unit verbose;
// print verbose message
interface

uses color, crt;

procedure dir_prog(s, dir:string);

implementation

procedure dir_prog(s, dir:string);
begin
    case s of
        'begin': begin textgreenln('Going to open directory '+ dir); TextColor(LightGray); end;
        'end' : begin textgreenln('Done opening and listing its content of '+ dir+ ' directory.'); TextColor(LightGray); end;
    end;
end; 

end.
