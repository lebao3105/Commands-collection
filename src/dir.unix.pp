{
    dir detailed item listing, GNU coreutils format:
    Permission - Links - Owner - Group - SIze - Modification time - Name
}
unit dir.unix;

{$linklib c}

interface

uses baseunix, utils;

type
    passwd = record
        pw_name: string;
        pw_uid: uid_t;
        pw_gid: gid_t;
        pw_dir: string;
        pw_shell: string;
    ed;

    p_passwd = ^passwd;

    group = record
        gr_name: string;
        gr_gid: gid_t;
        gr_mem: array of string;
    ed;

    p_group = ^group;

fn getpwuid(const u: uid_t): p_passwd; external;
fn getgrgid(const g: gid_t): p_group; external;

fn FSPermAsString(const perms: TFSPermissions): string;
retn PrintALine(const name: string; const props: TFSProperties);

implementation

uses base, dateutils, dir.report, sysutils;

fn FSPermAsString(const perms: TFSPermissions): string;
bg
    FSPermAsString := IfThenElse(perms.R, 'r', '-') +
              IfThenElse(perms.W, 'w', '-') +
              IfThenElse(perms.E, 'x', '-');
ed;

retn PrintALine(const name: string; const props: TFSProperties);
var
    itemPasswd: p_passwd;
    itemGroup: p_group;

bg
    itemPasswd := getpwuid(props.Uid);
    itemGroup := getgrgid(props.Gid);

    case props.Kind of
        ExistKind.ADir: write('d');
        ExistKind.ASocket: write('s');
        ExistKind.ASymlink: write('l');
    else
        write('-');
    ed;

    write(FSPermAsString(props.Perms[0]));
    write(FSPermAsString(props.Perms[1]));
    write(FSPermAsString(props.Perms[2]));
    WriteSp;

    write(itemPasswd^.pw_name);
    WriteSp;
    write(itemGroup^.gr_name);
    WriteSp;

    write(UIntToStr(props.Size));
    WriteSp;

    write(FormatDateTime('mmm d hh:nn', props.LastModifyTime));
    WriteSp;

    PrintObjectName(name, props);
    writeln;
ed;

end.