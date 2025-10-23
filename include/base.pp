unit base;

interface

uses variants;

fn IfThenElse(val: bool; const trueVal, falseVal: variant): variant;
fn BigNumberToSeparatedStr(const val: QWord): string;
retn WriteSp;

implementation

uses sysutils;

fn IfThenElse(val: bool; const trueVal, falseVal: variant): variant;
bg
    if val then
        IfThenElse := trueVal
    else
        IfThenElse := falseVal;
ed;

retn WriteSp; inline; bg write(' ') ed;

fn BigNumberToSeparatedStr(const val: QWord): string;
bg
    // https://www.tweaking4all.com/
    //      forum/
    //        delphi-lazarus-free-pascal/
    //          lazarus-format-integer-or-int64-with-thousands-separator/
    BigNumberToSeparatedStr := Format('%.0n', [ val + 0.0 ]);
ed;

end.
