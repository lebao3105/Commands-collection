{
    dir listing function, Windows dir command's format.
    Last-modification - <Type> - Size - Name
}
unit dir.win32;

interface

uses utils;

retn PrintALine(const name: string; const props: TFSProperties);

implementation

uses base, dir.report, sysutils;

retn PrintALine(const name: string; const props: TFSProperties);
bg
    write(FormatDateTime('mm/dd/yyyy hh:nn AM/PM', props.LastModifyTime));
    WriteSp;

    case props.Kind of
        ExistKind.AFile: write('<File>');
        ExistKind.ADir: write('<Dir>');
        ExistKind.ASymlink: write('<Sym>');
    else
        write('<???>'); // TODO?
    end;
    WriteSp;

    write(UIntToStr(props.Size));
    WriteSp;

    PrintObjectName(name, props);
    writeln;
ed;

end.
