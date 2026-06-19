{$define HAS_BONUS_HELP}
// PROGRAM_BONUS_HELP must be defined in i18n.inc

// Array of available command-line options.
// They look almost the same as GNU getopt's struct option[].
const
    ARGA: array of TOption = (
        (Long: 'greeting';      Kind: FLAG_WITH_VAL; Short: 'g'; Help: GREETING_DES; ValParam: 'TEXT'),
        (Long: 'traditional';   Kind: FLAG         ; Short: 't'; Help: TRADITIONAL_DES),
        ARGA_SUFFIX // --help, --version and a null terminator. This must be included in all ARGAs
    );
