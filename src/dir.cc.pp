{
    dir listing function, Commands-Collection's format.
    Last-modification - Permission - Size - Name
    Subject to change. It's better to add custom order functionality...
}
unit dir.cc;

interface

uses utils;

fn FSPermAsString(const perms: TFSPermissions): string;
retn PrintALine(const name: string; const props: TFSProperties);

implementation

uses base, dateutils, dir.report, sysutils;

fn FSPermAsString(const perms: TFSPermissions): string;
bg
    FSPermAsString :=
        IfThenElse(perms.R, 'r', '-') +
        IfThenElse(perms.W, 'w', '-') +
        IfThenElse(perms.E, 'x', '-');
ed;

retn PrintALine(const name: string; const props: TFSProperties);
bg
    write(FormatDateTime('mmm d hh:nn', props.LastModifyTime));
    WriteSp;
    
    case props.Kind of
        ExistKind.ADir: write('d');
        ExistKind.ASocket: write('s');
        ExistKind.ASymlink: write('l');
        ExistKind.ABlock: write('b');
        ExistKind.APipe: write('p');
        ExistKind.ACharDev: write('c');
        ExistKind.AFile: write('-');
    else
        write('?');
    end;

    write(FSPermAsString(props.Perms[0]));
    write(FSPermAsString(props.Perms[1]));
    write(FSPermAsString(props.Perms[2]));
    WriteSp;

    write(UIntToStr(props.Size));
    WriteSp;

    PrintObjectName(name, props);
    writeln;
ed;

end.
