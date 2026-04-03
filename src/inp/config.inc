const
	ARGA: array of TOption = (
		(Long: 'message';			Kind: EOptKind.FLAG_WITH_VAL; Short: 'm'; Help: MSG_DES),
		(Long: 'hide-input'; 		Kind: EOptKind.FLAG; 		  Short: 't'; Help: HIDEOKOJIMA_DES),
		(Long: 'require-enter';     Kind: EOptKind.FLAG;          Short: 'e'; Help: REQENTER_DES),
		(Long: 'require-chars';	    Kind: EOptKind.FLAG_WITH_VAL; Short: 'k'; Help: REQCHAR_DES),
		(Long: 'loop';	            Kind: EOptKind.FLAG;          Short: 'l'; Help: LOOP_DES),
		(Long: 'show-availables';   Kind: EOptKind.FLAG;          Short: 'o'; Help: SHOWAVAI_DES),
		(Long: 'case-sensitive';    Kind: EOptKind.FLAG;          Short: 's'; Help: CASESENS_DES),
		ARGA_SUFFIX
	);

	ARGA_SHORTOPTS: string = 'm:tek:los';