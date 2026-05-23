unit cc.fs;
{<
    File system-related tasks:
    * (Recursively or not) iterate directories
    * stat() an entity (a file / folder / etc)
}

{$modeswitch out}
{$modeswitch result}
{$scopedenums on}

interface

type
	{ Enum of file system entity types. }
	EFSEntityKind = (
	    NormalFile,
		Dir,
		Symlink,
		Pipe,
	    Socket,
		Block,
		CharDev,
		Door,
	    StatFailure
	);

	{ Record of file system entity permissions. }
	TFSPermissions = record
	    E: bool; //< Executable permission
		R: bool; //< Read permission
		W: bool; //< Write permission
	end;

	{ File system entity properties. }
	TFSProperties = record
	    { Entity's permissions.
		  0st index: Owner
		  1st index: Groups
		  2nd index: Others }
	    Perms: array[0..2] of TFSPermissions;
		SetUserID_OnExec, SetGroupID_OnExec: bool;

	    Kind: EFSEntityKind;
	    Size: qword;

		{ Self-explanatory, converted to Pascal's DateTime. }
	    LastAccessTime: double;

		{ Self-explanatory, converted to Pascal's DateTime. }
	    LastModifyTime: double;

	    HardLinkCount: cardinal;

		{ If the entity is a symlink and this is empty,
		  consider the entity to be a broken symlink. }
		PointsTo: string;

	    Gid, Uid: cardinal;
	end;

	TIterateDirResult = record
	    fullpath, name: ansistring;
	    info: TFSProperties;
	end;

	PIterateDirResult = ^TIterateDirResult;

	TIterateDirCallback = retn(const p: PIterateDirResult);

{ Reads path, and write its attributes into info.
  Returns a boolean indicating whether the operation succeed or not. }
fn PopulateFSInfo(const path: string; out info: TFSProperties): bool;

{ Iterates path, and run callback on each entry. Print the directory name if printPath is true.
  Iterates recursively when recursively is true. If an element / p itself is unreadable,
  the provided TIterateDirResult will have its info.Kind set to EFSEntityKind.AStatFailure. }
retn Iteratedir(const path: string; callback: TIteratedirCallback; recursively, printPath: bool);

{ Returns the absolute path name that points to file_name, with no
  . and .. and symlinks being involved. Returns a pointer to the
  buffer containing the generated pathname upon successful operation.
  Ortherwise, errno will be set and the result is Nil. }
fn RealPath(const file_name: pchar; resolved_name: pchar): pchar; external 'libc' name 'realpath';

{ Gets the type of the entity. }
fn GetFSEntityType(const p: string): EFSEntityKind;

{ Converts system.IOResult to a localized string. If IOResult is 0, returns an empty string.
  This requires IOChecks to be turned off using {$I-} or {$IOChecks off}. }
fn IOResultToString: string;

resourcestring
  // DOS Errors
  ERR_FILE_NOT_FOUND         = 'file not found';
  ERR_PATH_NOT_FOUND         = 'path not found';
  ERR_TOO_MANY_OPEN_FILES    = 'too many open files';
  ERR_ACCESS_DENIED          = 'access denied';
  ERR_INVALID_FILE_HANDLE    = 'invalid file handle';
  ERR_INVALID_FILE_ACCESS    = 'invalid file-access mode';
  ERR_INVALID_DISK_NUMBER    = 'invalid disk number';
  ERR_CANNOT_REMOVE_DIR      = 'cannot remove current directory';
  ERR_CANNOT_RENAME_VOLUMES  = 'cannot rename across volumes';

  // I/O Errors
  ERR_DISK_READ              = 'error when reading from disk';
  ERR_DISK_WRITE             = 'error when writing to disk';
  ERR_FILE_NOT_ASSIGNED      = 'file not assigned';
  ERR_FILE_NOT_OPEN          = 'file not open';
  ERR_FILE_NOT_OPEN_INPUT    = 'file not opened for input';
  ERR_FILE_NOT_OPEN_OUTPUT   = 'file not opened for output';
  ERR_INVALID_NUMBER         = 'invalid number';

  // Fatal Errors
  ERR_WRITE_PROTECTED        = 'disk is write protected';
  ERR_UNKNOWN_DEVICE         = 'unknown device';
  ERR_DRIVE_NOT_READY        = 'drive not ready';
  ERR_UNKNOWN_COMMAND        = 'unknown command';
  ERR_CRC_CHECK_FAILED       = 'cRC check failed';
  ERR_INVALID_DRIVE          = 'invalid drive specified';
  ERR_SEEK_ERROR             = 'seek error on disk';
  ERR_INVALID_MEDIA_TYPE     = 'invalid media type';
  ERR_SECTOR_NOT_FOUND       = 'sector not found';
  ERR_PRINTER_OUT_OF_PAPER   = 'printer out of paper';
  ERR_DEVICE_WRITE           = 'error when writing to device';
  ERR_DEVICE_READ            = 'error when reading from device';
  ERR_HARDWARE_FAILURE       = 'hardware failure';

  // Default fallback
  ERR_UNKNOWN_IO_RESULT      = 'unknown I/O error (Code %d)';
