const
	ARGA: array of TOption = (
		(Long: 'list';           Kind: EOptKind.FLAG; Short: 'l'; Help: LIST_DES),
		(Long: 'all';            Kind: EOptKind.FLAG; Short: 'a'; Help: ALL_DES),
		(Long: 'color';          Kind: EOptKind.FLAG; Short: 'c'; Help: COLOR_DES),
		(Long: 'directory';      Kind: EOptKind.FLAG; Short: 'd'; Help: DIR_ONLY_DES),
		(Long: 'ignore';         Kind: EOptKind.FLAG_WITH_VAL; Short: 'i'; Help: IGNORE_DES),
		(Long: 'ignore-backups'; Kind: EOptKind.FLAG; Short: 'B'; Help: IGNORE_BCK_DES),
		(Long: 'recursive';      Kind: EOptKind.FLAG; Short: 'R'; Help: RECURSIVE_DES),
		ARGA_SUFFIX
	);
