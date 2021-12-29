program pwd;
uses sysutils;
begin
    writeln('pwd shows the current directory. And now its output is...');
    writeln(GetCurrentDir); // that's it
    exit;
end.
