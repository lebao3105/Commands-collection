{
    dir detailed item listing, GNU coreutils format:
    Permission - Links - Owner - Group - SIze - Modification time - Name
}
unit dir.unix;

interface

uses baseunix, utils;

fn FSPermAsString(const perms: TFSPermissions): string;
retn PrintALine(const name: string; const props: TFSProperties);

implementation

uses base, dateutils, dir.report, sysutils, idcache;

fn FSPermAsString(const perms: TFSPermissions): string;
bg
    FSPermAsString :=
        IfThenElse(perms.R, 'r', '-') +
        IfThenElse(perms.W, 'w', '-') +
        IfThenElse(perms.E, 'x', '-');
ed;

retn PrintALine(const name: string; const props: TFSProperties);
var
    itemPasswd: TCacheEntry;
    itemGroup: TCacheEntry;

bg
    itemPasswd := getpw(props.Uid, false);
    itemGroup := getpw(props.Gid, true);

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

    write(itemPasswd.name);
    WriteSp;
    write(itemGroup.name);
    WriteSp;

    write(UIntToStr(props.Size));
    WriteSp;

    write(FormatDateTime('mmm d hh:nn', props.LastModifyTime));
    WriteSp;

    PrintObjectName(name, props);
    writeln;
ed;

end.
