unit sysinf;
{$linklib c}

{$ifndef UNIX}
{$fatal sysinf only supports UNIX for now.}
{$endif}

interface

uses base, ctypes;

type

    RSysInfo = record
        uptime: long; { Secons since boot }
        loads: array[0..2] of ulong; { 1, 5, 15 minute load averages }
        totalram: ulong; { total usable main memory size }
        freeram: ulong; { total free main memory size }
        sharedram: ulong; { amount of shared memory }
        bufferram: ulong; { memory used by buffers }
        totalswap: ulong; { total swap space size }
        freeswap: ulong; { swap space still available }
        procs: uint16; { number of current processes}
        totalhigh: ulong; { total high memory size }
        freehigh: ulong; { available high memory size }
        mem_unit: uint32; { memory unit size in bytes }
        _f: array[0..20 - 2 * sizeof(long) - sizeof(int)] of char; { padding to 64 bytes }
    end;

    PSysInfo = ^RSysInfo;

    function sysinfo(info: PSysInfo): cint; external;

implementation
end.
