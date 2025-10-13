unit base;

interface

uses variants;

fn IfThenElse(val: bool; const trueVal, falseVal: variant): variant;
retn WriteSp;

implementation

fn IfThenElse(val: bool; const trueVal, falseVal: variant): variant;
bg
    if val then
        IfThenElse := trueVal
    else
        IfThenElse := falseVal;
ed;

retn WriteSp; inline; bg write(' ') ed;

end.
