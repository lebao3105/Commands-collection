{$define HAS_BONUS_HELP}
{$define ALLOW_DOUBLE_SPECIFIER}

const
	ARGA: array of TOption = (
		(Long: 'get'; 	Kind: EOptKind.FLAG_WITH_VAL; Short: 'g'; Help: GET_DES),
		(Long: 'set'; 	Kind: EOptKind.FLAG_WITH_VAL; Short: 's'; Help: SET_DES),
		(Long: 'unset'; Kind: EOptKind.FLAG_WITH_VAL; Short: 'u'; Help: UNSET_DES),
		(Long: 'clean'; Kind: EOptKind.FLAG;		  Short: 'c'; Help: CLEAN_DES),
		ARGA_SUFFIX
	);
