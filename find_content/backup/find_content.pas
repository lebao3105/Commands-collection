program find_content;
uses Sysutils;
var 
    fn : string;
    rd : string;
    srch : string;
    res : longint;
    p : byte;
    n:integer;
    target_file:TextFile;

procedure upstring (var s : string);
begin
  for p := 1 to length(s) do
    s[p] := upcase(s[p]);
end;

function searchfile (target: string; find : string) : longint;
var
  cmp : string;
  line : longint;
begin
  line := 0;
  searchfile := 0;
  upstring (find);
  assign (target_file,target);
  reset (target_file);
  while not eof(target_file) do
    begin
      readln (target_file,rd);
      inc (line);
      cmp := rd;
      upstring(cmp);
      if pos(find,cmp) > 0 then
        begin
          searchfile := line;
          close (target_file);
          exit;
        end;
    end;
  close (target_file);
end;
begin
    if ParamCount = 0 then 
        begin
            writeln('At least 3 arguments needed. Aborting.');
            exit;
        end;
    if ParamCount = 1 then 
        begin 
            writeln('Missing argument. Aborting.'); 
            exit; 
        end;
    if ParamCount = 2 then 
        begin 
            writeln('Missing argument. Aborting.'); 
            exit; 
        end
    else
    for n := 2 to ParamCount do begin
        if ParamStr(n) = '--target' then
            if ParamStr(n) = ParamStr(ParamCount) then begin
                writeln('Missing the target file name.');
                exit;
            end
        else
        for i := 1 to n - 1 do
        res := searchfile(ParamStr(n+1), ParamStr(i));
        if res > 0 then 
            writeln(ParamStr(i), ' found in line 'res, ' : ', rd)
        else
            writeln('Your wanted word(s) ', ParamStr(i), ' was not found.');
    end;
end.
