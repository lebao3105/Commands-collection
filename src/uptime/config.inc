{$define HAS_BONUS_HELP}

const
    ARGA: array of TOption = (
        (Long: 'raw';    Kind: EOptKind.FLAG; Short: 'r'; Help: RAW_DES),
        (Long: 'since';  Kind: EOptKind.FLAG; Short: 's'; Help: SINCE_DES),
        (Long: 'pretty'; Kind: EOptKind.FLAG; Short: 'p'; Help: PRETTY_DES),
        ARGA_SUFFIX
    );
