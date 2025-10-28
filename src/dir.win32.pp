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
        ExistKind.AFile:        write('          ');
        ExistKind.ADir:         write(' <Folder> ');
        ExistKind.ASocket:      write(' <Socket> ');
        ExistKind.ACharDev:     write(' <Device> ');
        ExistKind.ASymlink:     write('  <Syml>  ');
        ExistKind.ABlock:       write('  <Block> ');
        ExistKind.APipe:        write('  <Pipe>  ');
        ExistKind.AStatFailure: write('  <????>  ');
        // the most bullshit kind of alignment. Ever.
    end;
    WriteSp;

    write(UIntToStr(props.Size));
    WriteSp;

    PrintObjectName(name, props);
    writeln;
ed;

end.
