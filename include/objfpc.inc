{$ifdef UNICODE}
{$define HAD_UNICODE}
{$endif}

{$mode objfpc}

{$ifdef HAD_UNICODE}
{$H-}
{$modeswitch unicodestrings}
{$undef HAD_UNICODE}
{$endif}
