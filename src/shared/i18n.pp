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

    Multi-line strings are allowed.
}

{$modeswitch out}
{$modeswitch anonymousfunctions}
{$modeswitch MultiLineStrings}

interface

{$push}{$warn 5028 off} // Unused resourcestring
{$I i18n.inc}

implementation

uses gettext, sysutils, cc.logging;

var where_to_read: string;

initialization

where_to_read := GetEnvironmentVariable('CC_I18N_LOC');
if where_to_read = '' then
    where_to_read := {$I %LOC_PATH%};

Debug('.mo path: %s', [ where_to_read ]);
TranslateResourceStrings(where_to_read);

end.
