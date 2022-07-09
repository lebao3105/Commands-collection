unit verbose;
// print verbose message
interface

uses color, crt;

procedure dir_prog(s, dir:string);
procedure cat_prog(s, file_name:string);

implementation

procedure dir_prog(s, dir:string);
begin
    case s of
        'begin': begin textgreenln('Going to open directory '+ dir); TextColor(White); end;
        'end' : begin textgreenln('Done opening and listing its content of '+ dir+ ' directory.'); TextColor(White); end;
    end;
end;

procedure cat_prog(s, file_name:string);
begin
    if s = 'begin' then
        textgreenln('cat is going to read the content of file: '+ file_name);
  		textgreenln('=========================================');
        TextColor(White);
    if s = 'end' then
        textgreenln('Done reading file name '+ file_name);
        TextColor(White);
end;    

end.
