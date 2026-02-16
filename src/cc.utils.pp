unit cc.utils;
{$modeswitch out}
{$modeswitch defaultparameters}
{$modeswitch result}
{$scopedenums on}
{$H+}

interface

uses
    cc.base,
    {$ifdef FPC_DOTTEDUNITS}
    system.regexpr,
    system.types
    {$else}
    regexpr,
    types (* TStringDynArray *)
    {$endif}
    ;

{$ifdef IMPL}
{$undef IMPL}
{$endif}

{$I regex.inc}
{$I fs.inc}

implementation

uses
    cc.logging,
    {$ifdef FPC_DOTTEDUNITS}
    unixapi.base,
    system.dateutils,
    system.sysutils
    {$else}
    baseunix,
    sysutils,
    dateutils
    {$endif}
    ;

{$define IMPL}
{$I fs.inc}
{$I regex.inc}
{$undef IMPL}

initialization

Regexer := TRegExpr.Create;

finalization

Regexer.Free;

end.
