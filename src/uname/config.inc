{$define HAS_BONUS_HELP}

const
	ARGA: array of TOption = (
		(Long: 'all';       		Kind: FLAG; Short: 'a'; Help: ALL_DES),
		(Long: 'formatted';			Kind: FLAG; Short: 'f'; Help: FORMATTED_DES),
		(Long: 'kernel-name';     	Kind: FLAG; Short: 's'; Help: KERN_NAME_DES),
		(Long: 'kernel-release';    Kind: FLAG; Short: 'r'; Help: KERN_REL_DES),
		(Long: 'kernel-version';	Kind: FLAG; Short: 'v'; Help: KERN_VER_DES),
		(Long: 'machine';			Kind: FLAG; Short: 'm'; Help: MACHINE_DES),
		(Long: 'nodename';			Kind: FLAG; Short: 'n'; Help: NODENAME_DES),
		(Long: 'processor';			Kind: FLAG; Short: 'p'; Help: PROCESSOR_DES),
		(Long: 'operating-system';  Kind: FLAG; Short: 'o'; Help: OPERATING_DES),
		ARGA_SUFFIX
	);
