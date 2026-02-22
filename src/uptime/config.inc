const
{$ifdef NEED_ARGA}
    ARGA: array of TOption = (
        (Name: 'raw'; Has_Arg: 0; Flag: Nil; Value: 'r'),
        (Name: 'since'; Has_Arg: 0; Flag: Nil; Value: 's'),
        (Name: 'pretty'; Has_Arg: 0; Flag: Nil; Value: 'p'),
        ARGA_SUFFIX
    );
    ARGA_SHORTOPTS: string = 'rsp';
{$endif}

{$ifdef NEED_PROGRAM_HELP}
    {$define PROGRAM_HELP :=
        CREATE_ARG_HELP('r', 'raw', RAW_DES) +
        CREATE_ARG_HELP('s', 'since', SINCE_DES) +
        CREATE_ARG_HELP('p', 'pretty', PRETTY_DES)
    }
    PROGRAM_NAME: string = 'uptime';
{$endif}
