const
    ARGA: array of TOption = (
        (Long: 'ignore';     Kind: FLAG;          Short: 'g'; Help: IGNORE_DES),
        (Long: 'dry-run';    Kind: FLAG;          Short: 'd'; Help: DRY_RUN_DES),
        (Long: 'filter';     Kind: FLAG_WITH_VAL; Short: 'x'; Help: FILTER_DES),
        (Long: 'recursive';  Kind: FLAG;          Short: 'r'; Help: RECURSIVE_DES),
        (Long: 'keep-going'; Kind: FLAG;          Short: 'k'; Help: KEEP_GOING_DES),
        ARGA_VERBOSE,
        ARGA_SUFFIX
    );
