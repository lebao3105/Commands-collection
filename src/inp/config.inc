{$define HAS_BONUS_HELP}

const
	ARGA: array of TOption = (
		(Long: 'message';			Kind: FLAG_WITH_VAL; Short: 'm'; Help: MSG_DES),
		(Long: 'hide-input'; 		Kind: FLAG; 		  Short: 't'; Help: HIDEOKOJIMA_DES),
		(Long: 'require-enter';     Kind: FLAG;          Short: 'e'; Help: REQENTER_DES),
		(Long: 'require-chars';	    Kind: FLAG_WITH_VAL; Short: 'k'; Help: REQCHAR_DES),
		(Long: 'loop';	            Kind: FLAG;          Short: 'l'; Help: LOOP_DES),
		(Long: 'show-availables';   Kind: FLAG;          Short: 'o'; Help: SHOWAVAI_DES),
		(Long: 'case-sensitive';    Kind: FLAG;          Short: 's'; Help: CASESENS_DES),
		ARGA_SUFFIX
	);
