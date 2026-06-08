{$define HAS_BONUS_HELP}

const
	ARGA: array of TOption = (
		(Long: 'list';           Kind: FLAG; Short: 'l'; Help: LIST_DES),
		(Long: 'all';            Kind: FLAG; Short: 'a'; Help: ALL_DES),
		(Long: 'color';          Kind: FLAG; Short: 'c'; Help: COLOR_DES),
		(Long: 'directory';      Kind: FLAG; Short: 'd'; Help: DIR_ONLY_DES),
		(Long: 'ignore';         Kind: FLAG_WITH_VAL; Short: 'i'; Help: IGNORE_DES),
		(Long: 'ignore-backups'; Kind: FLAG; Short: 'B'; Help: IGNORE_BCK_DES),
		(Long: 'recursive';      Kind: FLAG; Short: 'R'; Help: RECURSIVE_DES),
		ARGA_SUFFIX
	);
