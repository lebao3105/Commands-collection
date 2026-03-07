const
{$ifdef NEED_ARGA}
	ARGA: array of TOption = (
		(Long: 'get'; 	Kind: EOptKind.FLAG_WITH_VAL; Short: 'g'),
		(Long: 'set'; 	Kind: EOptKind.FLAG_WITH_VAL; Short: 's'),
		(Long: 'unset'; Kind: EOptKind.FLAG_WITH_VAL; Short: 'u'),
		(Long: 'clean'; Kind: EOptKind.FLAG; Short: 'c'),
		ARGA_SUFFIX
	);
	ARGA_SHORTOPTS = 'g:s:u:c';
{$endif}

{$ifdef NEED_PROGRAM_HELP}
{$define PROGRAM_HELP :=
		CREATE_ARG_VAL_HELP('g', 'get', 'VAR', GET_DES) +
		CREATE_ARG_VAL_HELP('s', 'set', 'VAR=VAL', SET_DES) +
		CREATE_ARG_VAL_HELP('u', 'unset', 'VAR', UNSET_DES) +
		CREATE_ARG_HELP('c', 'clean', CLEAN_DES)
}

	PROJECT_NAME = 'env';
{$endif}
