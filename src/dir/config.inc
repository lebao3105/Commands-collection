const
	ARGA: array of TOption = (
		(Long: 'list';           Kind: EOptKind.FLAG; Short: 'l'),
		(Long: 'all';            Kind: EOptKind.FLAG; Short: 'a'),
		(Long: 'color';          Kind: EOptKind.FLAG; Short: 'c'),
		(Long: 'directory';      Kind: EOptKind.FLAG; Short: 'd'),
		(Long: 'ignore';         Kind: EOptKind.FLAG_WITH_VAL; Short: 'i'),
		(Long: 'ignore-backups'; Kind: EOptKind.FLAG; Short: 'B'),
		(Long: 'recursive';      Kind: EOptKind.FLAG; Short: 'R'),
		ARGA_SUFFIX
	);
	ARGA_SHORTOPTS = 'lacdBRi:';

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
