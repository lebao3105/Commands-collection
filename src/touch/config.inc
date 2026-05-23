{$define ALLOW_PAIRS}

const
    PAIR_NUM = 2;
    ARGA: array of TOption = (
        (Long: 'parent';        Kind: EOptKind.FLAG; Short: 'p'; Help: PARENT_DES),
        (Long: 'create-dirs';   Kind: EOptKind.FLAG; Short: 'd'; Help: DIRS_DES),
        (Long: 'ignore-errors'; Kind: EOptKind.FLAG; Short: 'k'; Help: KEEP_GOING_DES),
        ARGA_USE_PAIRS,
        ARGA_VERBOSE,
        ARGA_SUFFIX
    );
