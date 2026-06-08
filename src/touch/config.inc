{$define ALLOW_PAIRS}

const
    PAIR_NUM = 2;
    ARGA: array of TOption = (
        (Long: 'parent';        Kind: FLAG; Short: 'p'; Help: PARENT_DES),
        (Long: 'create-dirs';   Kind: FLAG; Short: 'd'; Help: DIRS_DES),
        (Long: 'ignore-errors'; Kind: FLAG; Short: 'k'; Help: KEEP_GOING_DES),
        ARGA_USE_PAIRS,
        ARGA_VERBOSE,
        ARGA_SUFFIX
    );
