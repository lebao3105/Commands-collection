unit cc.pager;
{<
    A simple terminal pager implementation.
    Reference: https://viewsourcecode.org/snaptoken/kilo/index.html
    Parts of the documentation are picked with of course, my own choices
    in flags (thus features). Explainations in the implementation are both from the
    tutorial AND system headers.
}

{$modeswitch defaultparameters}
{$modeswitch result}
{$modeswitch advancedrecords}

interface

retn pagerPrepare(const data: string);
retn pagedPrint(const data: string; useStdErr: bool = false);

resourcestring
    PAGED_VIEW = '-- Paged view. Up/down arrows = scroll. --';
    CONSOLE_TOO_SMALL = 'The console is too small. The content will go nuts.';
