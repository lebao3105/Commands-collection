const
{$ifdef NEED_ARGA}
	ARGA: array of TOption = (
		(Name: 'get'; 	Has_Arg: 1; Flag: Nil; Value: 'g'),
		(Name: 'set'; 	Has_Arg: 1; Flag: Nil; Value: 's'),
		(Name: 'unset'; Has_Arg: 1; Flag: Nil; Value: 'u'),
		(Name: 'clean'; Has_Arg: 0; Flag: Nil; Value: 'c'),
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
