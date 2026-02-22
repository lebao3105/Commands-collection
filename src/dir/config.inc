const
{$ifdef NEED_ARGA}
	ARGA: array of TOption = (
		(Name: 'list';           Has_Arg: 0; Flag: Nil; Value: 'l'),
		(Name: 'all';            Has_Arg: 0; Flag: Nil; Value: 'a'),
		(Name: 'color';          Has_Arg: 0; Flag: Nil; Value: 'c'),
		(Name: 'directory';      Has_Arg: 0; Flag: Nil; Value: 'd'),
		(Name: 'ignore';         Has_Arg: 1; Flag: Nil; Value: 'i'),
		(Name: 'ignore-backups'; Has_Arg: 0; Flag: Nil; Value: 'B'),
		(Name: 'recursive';      Has_Arg: 0; Flag: Nil; Value: 'R'),
		ARGA_SUFFIX
	);
	ARGA_SHORTOPTS = 'lacdBRi:';
{$endif}

{$ifdef NEED_PROGRAM_HELP}
{$define PROGRAM_HELP :=
	CREATE_ARG_HELP('l', 'list', LIST_DES) +
	CREATE_ARG_HELP('a', 'all', ALL_DES) +
	CREATE_ARG_HELP('c', 'color', COLOR_DES) +
	CREATE_ARG_HELP('d', 'directory', DIR_ONLY_DES) +
	CREATE_ARG_HELP('B', 'ignore-backups', IGNORE_BCK_DES) +
	CREATE_ARG_HELP('R', 'recursive', RECURSIVE_DES) +
	CREATE_ARG_VAL_HELP('i', 'ignore', 'PATTERN', IGNORE_DES)
}
	PROGRAM_NAME = 'dir';
{$endif}
