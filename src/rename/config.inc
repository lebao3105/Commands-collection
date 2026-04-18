{$define ALLOW_PAIRS}
{$push}
	{$warn 3177 off}
const
    PAIR_NUM: uint16 = 2;
	ARGA: array of TOption = (
		(Long: 'symlink'; 			Kind: EOptKind.FLAG; Short: 's'; Help: SYMLINK_DES),
		(Long: 'dry-run'; 			Kind: EOptKind.FLAG; Short: 'd'; Help: DRY_RUN_DES),
		(Long: 'bulk'; 				Kind: EOptKind.FLAG; Short: 'b'; Help: BULK_DES),
		(Long: 'regex'; 			Kind: EOptKind.FLAG; Short: 'r'; Help: REGEX_DES),
		(Long: 'no-overrides'; 		Kind: EOptKind.FLAG; Short: 'o'; Help: IGN_EXISTS_DES),
		(Long: 'interactive'; 		Kind: EOptKind.FLAG; Short: 'i'; Help: INTERACTIVE_DES),
		(Long: 'last'; 				Kind: EOptKind.FLAG; Short: 'l'; Help: LAST_OCC_DES),
		(Long: 'keep-attributes'; 	Kind: EOptKind.FLAG; Short: 'k'; Help: KEEP_ATTRS_DES),
		(Long: 'opposites'; 		Kind: EOptKind.FLAG; Short: 'p'; Help: OPPOSITES_DES),
        ARGA_USE_PAIRS,
		ARGA_VERBOSE,
		ARGA_SUFFIX
	);
{$pop}
