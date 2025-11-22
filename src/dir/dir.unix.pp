{
    dir detailed item listing, GNU coreutils format:
    Permission - Links - Owner - Group - Size - Modification time - Name
}
unit dir.unix;

interface

uses utils;

function GetFSTypeString(const kind: ExistKind): string;

implementation

const
	FSTYPE_LETTERS: array of char = (
		'-', 'd', 'l', 's', 'b', 'p', 'c', '?'
	);

function GetFSTypeString(const kind: ExistKind): string;
bg
	GetFSTypeString := FSTYPE_LETTERS[ord(kind)];
ed;

end.
