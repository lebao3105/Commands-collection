const
{$ifdef NEED_ARGA}
	ARGA: array of TOption = (
		(Name: 'format'; Has_Arg: 1; Flag: Nil; Value: 'f'),
		ARGA_SUFFIX
	);
	ARGA_SHORTOPTS: string = 'f:';
{$endif}

{$ifdef NEED_PROGRAM_HELP}
	{$define PROGRAM_HELP :=
		CREATE_ARG_VAL_WITH_DEF_HELP(
			'f', 'format', 'FORMAT', DEFAULT_FORMAT, 'Time format'
		)
	}
	PROGRAM_NAME: string = 'calltime';
{$endif}
