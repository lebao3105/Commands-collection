const
    ARGA: array of TOption = (
        (Long: 'ignore';     Kind: EOptKind.FLAG;          Short: 'g'; Help: IGNORE_DES),
        (Long: 'dry-run';    Kind: EOptKind.FLAG;          Short: 'd'; Help: DRY_RUN_DES),
        (Long: 'filter';     Kind: EOptKind.FLAG_WITH_VAL; Short: 'x'; Help: FILTER_DES),
        (Long: 'recursive';  Kind: EOptKind.FLAG;          Short: 'r'; Help: RECURSIVE_DES),
        (Long: 'keep-going'; Kind: EOptKind.FLAG;          Short: 'k'; Help: KEEP_GOING_DES),
        ARGA_VERBOSE,
        ARGA_SUFFIX
    );
