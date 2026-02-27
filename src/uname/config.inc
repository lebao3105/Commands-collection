const
{$ifdef NEED_ARGA}
	ARGA: array of TOption = (
		(Name: 'all';       		Has_Arg: 0; Flag: Nil; Value: 'a'),
		(Name: 'formatted';			Has_Arg: 0; Flag: Nil; Value: 'f'),
		(Name: 'kernel-name';     	Has_Arg: 0; Flag: Nil; Value: 's'),
		(Name: 'kernel-release';    Has_Arg: 0; Flag: Nil; Value: 'r'),
		(Name: 'kernel-version';	Has_Arg: 0; Flag: Nil; Value: 'v'),
		(Name: 'machine';			Has_Arg: 0; Flag: Nil; Value: 'm'),
		(Name: 'nodename';			Has_Arg: 0; Flag: Nil; Value: 'n'),
		(Name: 'processor';			Has_Arg: 0; Flag: Nil; Value: 'p'),
		(Name: 'hardware-platform'; Has_Arg: 0; Flag: Nil; Value: 'i'),
		(Name: 'operating-system';  Has_Arg: 0; Flag: Nil; Value: 'o'),
		ARGA_SUFFIX
	);

	ARGA_SHORTOPTS: string = 'afsvrnmnpio';
{$endif}

{$ifdef NEED_PROGRAM_HELP}
{$define PROGRAM_HELP :=
	CREATE_ARG_HELP('a', 'all', ALL_DES) +
	CREATE_ARG_HELP('f', 'formatted', FORMATTED_DES) +
	CREATE_ARG_HELP('s', 'kernel-name', KERN_NAME_DES) +
	CREATE_ARG_HELP('r', 'kernel-release', KERN_REL_DES) +
	CREATE_ARG_HELP('v', 'kernel-version', KERN_VER_DES) +
	CREATE_ARG_HELP('m', 'machine', MACHINE_DES) +
	CREATE_ARG_HELP('n', 'nodename', NODENAME_DES) +
	CREATE_ARG_HELP('p', 'processor', PROCESSOR_DES) +
	CREATE_ARG_HELP('i', 'hardware-platform', HARDWARE_DES) +
	CREATE_ARG_HELP('o', 'operating-system', OPERATING_DES)
}
	PROGRAM_NAME: string = 'uname';
{$endif}
