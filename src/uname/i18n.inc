resourcestring
    ALL_DES = 'Show everything';
    FORMATTED_DES = 'More human-friendly output';
    KERN_NAME_DES = 'Show the kernel name';
    KERN_REL_DES = 'Show the kernel release';
    KERN_VER_DES = 'Show the kernel version';
    MACHINE_DES = 'Show the machine hardware name';
    NODENAME_DES = 'Show the network node name';
    PROCESSOR_DES = 'Show the processor type';
    OPERATING_DES = 'Show the operating system';

    PROGRAM_DESC = 'Prints system informations';
    PROGRAM_BONUS_HELP =
        'With nothing else provided, -s will be omitted.' + CRNL +
        '-f must be provided before any other flags, else you ' +
        'will either get a mixed output, or no -f effect at all.' + CRNL +
        '-o and -p outputs may differ from GNU uname''s output due to the ' +
        'underlying implementation.' + CRNL +
        'For -o, check the following site for all identifies from GNU:' +
        'https://github.com/coreutils/gnulib/blob/master/m4/host-os.m4';

    PROCESSOR_TYPE      = 'Processor type: ';
    UNKNOWN             = 'Unknown';
    OPERATING_SYSTEM    = 'Operating system: ';
    UNAME_FAILED        = 'uname() failed: %s';
    KERNEL_NAME         = 'Kernel name: ';
    KERNEL_RELEASE      = 'Kernel release: ';
    KERNEL_VERSION      = 'Kernel version: ';
    MACHINE_HWNAME      = 'Machine hardware name: ';
    NETWORK_NODENAME    = 'Network node name: ';
