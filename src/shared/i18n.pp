unit i18n;
{
    Simple Pascal unit that simply includes an application's
    i18n.inc file for you know, localizations.

    This is done to make sure all application-specific strings
    are not put inside any shared units, like cc.getopts, while
    (still) being able to accessed everywhere.

    The unit has no function, no types and variables either.
    There is no need to merge CC and application .po files
    into one, since msgfmt accepts more than one file.
}

interface

{$push}{$warn 5028 off} // Unused resourcestring
{$I i18n.inc}
{$pop}

implementation

uses {$ifdef FPC_DOTTEDUNITS}
     system.gettext
     {$else}
     gettext
     {$endif}
     ;

initialization

TranslateResourceStrings(LOC_PATH);

end.
