unit utils;
{$modeswitch out}
{$modeswitch defaultparameters}
{$modeswitch result}
{$scopedenums on}
{$H+}

interface

uses base, regexpr,
     types (* TStringDynArray *);

{$ifdef IMPL}
{$undef IMPL}
{$endif}

{$I regex.inc}
{$I fs.inc}

implementation

uses sysutils,
     logging, baseunix, dateutils;

{$define IMPL}
{$I fs.inc}
{$I regex.inc}
{$undef IMPL}

initialization

Regexer := TRegExpr.Create;

finalization

Regexer.Free;

end.
