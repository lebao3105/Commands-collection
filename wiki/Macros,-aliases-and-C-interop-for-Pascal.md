## Macros and aliases

### Pascal

Most required definitions are defined in the main xmake.lua. Some more are created by the compiler can be found [here](https://www.freepascal.org/docs-html/prog/progse5.html#x136-137002r1).

To define something:

```pascal
{$define NAME:=VALUE}
// e.g
{$define CC_VER:=1.0}
```

```bash
$ fpc ... -dNAME:=VALUE
// e.g
$ fpc ... -dCC_VER:=1.0
```

Function macros are NOT allowed!

To check for a definition:

```pascal
{$ifdef NAME}
    {$if defined(NAME2) or defined(NAME3)}
    ...
    {$endif}
    ...
{$endif NAME} (* You can do that insert *)
```

### C

Most basic definitions can be found in include/base.h. They should be properly documented.

Nothing else to say.

## C interop for Pascal

### The `external` keyword

All the C stuff **from CC**, for all programs AND for a specific program, are put in a library named custcustC.

Its reference / `external` name is always `custcustc`.

Pascal's `external` uses the following syntax:

```pascal
[procedure/function] what[param list]: value_type; external lib name 'obj_name';
```

* `name 'obj_name'` is optional if the name in Pascal matches the one to be imported.
* `lib` is the library name / file name(?) - can be removed(\*)
* Externals can not be `const`.

\*: You can use the `{$linklib NAME}` macro.

CUSTCUSTC_EXTERN is defined in order to make the import more clear:

```pascal
var
	PRESS_ANY_KEY: pchar; CUSTCUSTC_EXTERN 'get_PRESS_ANY_KEY';
```

### C type conversion

TODO.
