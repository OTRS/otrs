# --
# Kernel/Output/HTML/LayoutLinkObject.pm - provides generic HTML output for LinkObject
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LayoutLinkObject.pm,v 1.11 2008-07-05 15:03:28 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::LayoutLinkObject;

use strict;
use warnings;

use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

=item LinkObjectTableCreate()

create a output table

    my $String = $LayoutObject->LinkObjectTableCreate(
        LinkListWithData => $LinkListWithDataRef,
        ViewMode         => 'Simple', # (Simple|SimpleRaw|Complex|ComplexAdd|ComplexDelete|ComplexRaw)
    );

=cut

sub LinkObjectTableCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(LinkListWithData ViewMode)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    if ( $Param{ViewMode} =~ m{ \A Simple }xms ) {

        return $Self->LinkObjectTableCreateSimple(
            LinkListWithData => $Param{LinkListWithData},
            ViewMode         => $Param{ViewMode},
        );
    }
    else {

        return $Self->LinkObjectTableCreateComplex(
            LinkListWithData => $Param{LinkListWithData},
            ViewMode         => $Param{ViewMode},
        );
    }
}

=item LinkObjectTableCreateComplex()

create a complex output table

    my $String = $LayoutObject->LinkObjectTableCreateComplex(
        LinkListWithData => $LinkListRef,
        ViewMode         => 'Complex', # (Complex|ComplexAdd|ComplexDelete|ComplexRaw)
    );

=cut

sub LinkObjectTableCreateComplex {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(LinkListWithData ViewMode)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check link list
    if ( ref $Param{LinkListWithData} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'LinkListWithData must be a hash referance!',
        );
        return;
    }

    return if !%{ $Param{LinkListWithData} };

    # convert the link list
    my %LinkList;
    for my $Object ( keys %{ $Param{LinkListWithData} } ) {

        for my $LinkType ( keys %{ $Param{LinkListWithData}->{$Object} } ) {

            # extract link type List
            my $LinkTypeList = $Param{LinkListWithData}->{$Object}->{$LinkType};

            for my $Direction ( keys %{$LinkTypeList} ) {

                # extract direction list
                my $DirectionList = $Param{LinkListWithData}->{$Object}->{$LinkType}->{$Direction};

                for my $ObjectKey ( keys %{$DirectionList} ) {

                    $LinkList{$Object}->{$ObjectKey}->{$LinkType} = $Direction;
                }
            }
        }
    }

    my @OutputData;
    OBJECT:
    for my $Object ( sort { lc $a cmp lc $b } keys %{ $Param{LinkListWithData} } ) {

        # load backend
        my $BackendObject = $Self->_LoadLinkObjectLayoutBackend(
            Object => $Object,
        );

        next OBJECT if !$BackendObject;

        # get block data
        my @BlockData = $BackendObject->TableCreateComplex(
            ObjectLinkListWithData => $Param{LinkListWithData}->{$Object},
        );

        next OBJECT if !@BlockData;

        push @OutputData, @BlockData;
    }

    # error handling
    for my $Block (@OutputData) {

        ITEM:
        for my $Item ( @{ $Block->{ItemList} } ) {

            next ITEM if $Item->[0]->{Key} && $Block->{Object};

            if ( !$Block->{Object} ) {
                $Item->[0] = {
                    Type    => 'Text',
                    Content => 'ERROR: Object attribute not found in the block data.',
                };
            }
            else {
                $Item->[0] = {
                    Type => 'Text',
                    Content =>
                        'ERROR: Key attribute not found in the first column of the item list.',
                };
            }
        }
    }

    # add "linked as" column to the table
    for my $Block (@OutputData) {

        # define the headline column
        my $Column = {
            Content => 'Linked as',
            Width   => 90,
        };

        # add new column to the headline
        push @{ $Block->{Headline} }, $Column;

        for my $Item ( @{ $Block->{ItemList} } ) {

            # define checkbox cell
            my $CheckboxCell = {
                Type         => 'LinkTypeList',
                Content      => '',
                LinkTypeList => $LinkList{ $Block->{Object} }->{ $Item->[0]->{Key} },
                Translate    => 1,
            };

            # add checkbox cell to item
            push @{$Item}, $CheckboxCell;
        }
    }

    return @OutputData if $Param{ViewMode} && $Param{ViewMode} eq 'ComplexRaw';

    if ( $Param{ViewMode} eq 'ComplexAdd' ) {

        for my $Block (@OutputData) {

            # define the headline column
            my $Column = {
                Content => ' ',
                Width   => 27,
            };

            # add new column to the headline
            unshift @{ $Block->{Headline} }, $Column;

            for my $Item ( @{ $Block->{ItemList} } ) {

                # define checkbox cell
                my $CheckboxCell = {
                    Type    => 'Checkbox',
                    Name    => 'LinkTargetKeys',
                    Content => $Item->[0]->{Key},
                };

                # add checkbox cell to item
                unshift @{$Item}, $CheckboxCell;
            }
        }
    }

    if ( $Param{ViewMode} eq 'ComplexDelete' ) {

        for my $Block (@OutputData) {

            # define the headline column
            my $Column = {
                Content => ' ',
                Width   => 27,
            };

            # add new column to the headline
            unshift @{ $Block->{Headline} }, $Column;

            for my $Item ( @{ $Block->{ItemList} } ) {

                # define checkbox delete cell
                my $CheckboxCell = {
                    Type         => 'CheckboxDelete',
                    Object       => $Block->{Object},
                    Content      => '',
                    Key          => $Item->[0]->{Key},
                    LinkTypeList => $LinkList{ $Block->{Object} }->{ $Item->[0]->{Key} },
                    Translate    => 1,
                };

                # add checkbox cell to item
                unshift @{$Item}, $CheckboxCell;
            }
        }
    }

    # create new instance of the layout object
    my $LayoutObject = Kernel::Output::HTML::Layout->new( %{$Self} );

    # output the table complex block
    $LayoutObject->Block(
        Name => 'TableComplex',
    );

    # set block description
    my $BlockDescription = $Param{ViewMode} eq 'ComplexAdd' ? 'Search Result' : 'Linked';

    BLOCK:
    for my $Block (@OutputData) {

        next BLOCK if !$Block->{ItemList};
        next BLOCK if ref $Block->{ItemList} ne 'ARRAY';
        next BLOCK if !@{ $Block->{ItemList} };

        # output the block
        $LayoutObject->Block(
            Name => 'TableComplexBlock',
            Data => {
                BlockDescription => $BlockDescription,
                Blockname        => $Block->{Blockname} || '',
            },
        );

        # output table headline
        for my $HeadlineColumn ( @{ $Block->{Headline} } ) {

            # output a headline column block
            $LayoutObject->Block(
                Name => 'TableComplexBlockColumn',
                Data => $HeadlineColumn,
            );
        }

        # output item list
        my $CssClass = '';
        for my $Row ( @{ $Block->{ItemList} } ) {

            # output a table row block
            $LayoutObject->Block(
                Name => 'TableComplexBlockRow',
            );

            # set the css class
            $CssClass = $CssClass eq 'searchpassive' ? 'searchactive' : 'searchpassive';

            for my $Column ( @{$Row} ) {

                # create the content string
                my $Content = $Self->LinkObjectContentStringCreate(
                    Object      => $Block->{Object},
                    ContentData => $Column,
                );

                # output a table column block
                $LayoutObject->Block(
                    Name => 'TableComplexBlockRowColumn',
                    Data => {
                        %{$Column},
                        Content  => $Content,
                        CssClass => $CssClass,
                    },
                );
            }
        }

        if ( $Param{ViewMode} eq 'ComplexAdd' ) {

            # output the footer block
            $LayoutObject->Block(
                Name => 'TableComplexBlockFooterAdd',
                Data => {
                    Colspan => scalar @{ $Block->{Headline} },
                    LinkTypeStrg => $Param{LinkTypeStrg} || '',
                },
            );
        }
        elsif ( $Param{ViewMode} eq 'ComplexDelete' ) {

            # output the footer block
            $LayoutObject->Block(
                Name => 'TableComplexBlockFooterDelete',
                Data => {
                    Colspan => scalar @{ $Block->{Headline} },
                },
            );
        }
        else {

            # output the footer block
            $LayoutObject->Block(
                Name => 'TableComplexBlockFooterNormal',
                Data => {
                    Colspan => scalar @{ $Block->{Headline} },
                },
            );
        }
    }

    return $LayoutObject->Output(
        TemplateFile => 'LinkObject',
    );
}

=item LinkObjectTableCreateSimple()

create a simple output table

    my $String = $LayoutObject->LinkObjectTableCreateSimple(
        LinkListWithData => $LinkListWithDataRef,
        ViewMode         => 'SimpleRaw',            # (optional) (Simple|SimpleRaw)
    );

=cut

sub LinkObjectTableCreateSimple {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{LinkListWithData} || ref $Param{LinkListWithData} ne 'HASH' ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need LinkListWithData!' );
        return;
    }

    # load link core module
    if ( !$Self->{LinkObject} ) {
        $Self->{LinkObject} = Kernel::System::LinkObject->new( %{$Self} );
    }

    # get type list
    my %TypeList = $Self->{LinkObject}->TypeList(
        UserID => $Self->{UserID},
    );

    return if !%TypeList;

    my %OutputData;
    OBJECT:
    for my $Object ( keys %{ $Param{LinkListWithData} } ) {

        # load backend
        my $BackendObject = $Self->_LoadLinkObjectLayoutBackend(
            Object => $Object,
        );

        next OBJECT if !$BackendObject;

        # get link output data
        my %LinkOutputData = $BackendObject->TableCreateSimple(
            ObjectLinkListWithData => $Param{LinkListWithData}->{$Object},
        );

        next OBJECT if !%LinkOutputData;

        for my $LinkType ( keys %LinkOutputData ) {

            $OutputData{$LinkType}->{$Object} = $LinkOutputData{$LinkType}->{$Object};
        }
    }

    return %OutputData if $Param{ViewMode} && $Param{ViewMode} eq 'SimpleRaw';

    # create new instance of the layout object
    my $LayoutObject = Kernel::Output::HTML::Layout->new( %{$Self} );

    # output the table simple block
    $LayoutObject->Block(
        Name => 'TableSimple',
    );

    for my $LinkTypeLinkDirection ( sort { lc $a cmp lc $b } keys %OutputData ) {

        # investigate link type name
        my @LinkData = split q{::}, $LinkTypeLinkDirection;
        my $LinkTypeName = $TypeList{ $LinkData[0] }->{ $LinkData[1] . 'Name' };

        # output the type block
        $LayoutObject->Block(
            Name => 'TableSimpleType',
            Data => {
                LinkTypeName => $LinkTypeName,
            },
        );

        # extract object list
        my $ObjectList = $OutputData{$LinkTypeLinkDirection};

        for my $Object ( sort { lc $a cmp lc $b } keys %{$ObjectList} ) {

            for my $Item ( @{ $ObjectList->{$Object} } ) {

                # create the content string
                my $Content = $Self->LinkObjectContentStringCreate(
                    Object      => $Object,
                    ContentData => $Item,
                );

                # output the type block
                $LayoutObject->Block(
                    Name => 'TableSimpleTypeRow',
                    Data => {
                        %{$Item},
                        Content => $Content,
                    },
                );
            }
        }
    }

    return $LayoutObject->Output(
        TemplateFile => 'LinkObject',
    );
}

=item LinkObjectContentStringCreate()

return a output string

    my $String = $LayoutObject->LinkObjectContentStringCreate(
        Object      => 'Ticket',
        ContentData => $HashRef,
    );

=cut

sub LinkObjectContentStringCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object ContentData)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # load link core module
    if ( !$Self->{LinkObject} ) {
        $Self->{LinkObject} = Kernel::System::LinkObject->new( %{$Self} );
    }

    # load backend
    my $BackendObject = $Self->_LoadLinkObjectLayoutBackend(
        Object => $Param{Object},
    );

    # create content string in backend module
    if ($BackendObject) {

        my $ContentString = $BackendObject->ContentStringCreate(
            %Param,
            LinkObject => $Self->{LinkObject},
        );

        return $ContentString if defined $ContentString;
    }

    # extract content
    my $Content = $Param{ContentData};

    # set blockname
    my $Blockname = $Content->{Type};

    # set global default value
    $Content->{MaxLength} ||= 100;

    # prepare linktypelist
    if ( $Content->{Type} eq 'LinkTypeList' ) {

        $Blockname = 'Plain';

        # get type list
        my %TypeList = $Self->{LinkObject}->TypeList(
            UserID => $Self->{UserID},
        );

        return if !%TypeList;

        my @LinkNameList;
        LINKTYPE:
        for my $LinkType ( sort { lc $a cmp lc $b } keys %{ $Content->{LinkTypeList} } ) {

            next LINKTYPE if $LinkType eq 'NOTLINKED';

            # extract direction
            my $Direction = $Content->{LinkTypeList}->{$LinkType};

            # extract linkname
            my $LinkName = $TypeList{$LinkType}->{ $Direction . 'Name' };

            # translate
            if ( $Content->{Translate} ) {
                $LinkName = $Self->{LayoutObject}->{LanguageObject}->Get($LinkName);
            }

            push @LinkNameList, $LinkName;
        }

        # join string
        my $String = join qq{\n}, @LinkNameList;

        # transform ascii to html
        $Content->{Content} = $Self->{LayoutObject}->Ascii2Html(
            Text => $String || '-',
            HTMLResultMode => 1,
            LinkFeature    => 0,
        );
    }

    # prepare checkbox delete
    if ( $Content->{Type} eq 'CheckboxDelete' ) {

        $Blockname = 'Plain';

        # get type list
        my %TypeList = $Self->{LinkObject}->TypeList(
            UserID => $Self->{UserID},
        );

        return if !%TypeList;

        # create new instance of the layout object
        my $LayoutObject = Kernel::Output::HTML::Layout->new( %{$Self} );

        LINKTYPE:
        for my $LinkType ( sort { lc $a cmp lc $b } keys %{ $Content->{LinkTypeList} } ) {

            next LINKTYPE if $LinkType eq 'NOTLINKED';

            # extract direction
            my $Direction = $Content->{LinkTypeList}->{$LinkType};

            # extract linkname
            my $LinkName = $TypeList{$LinkType}->{ $Direction . 'Name' };

            # translate
            if ( $Content->{Translate} ) {
                $LinkName = $Self->{LayoutObject}->{LanguageObject}->Get($LinkName);
            }

            # run checkbox block
            $LayoutObject->Block(
                Name => 'Checkbox',
                Data => {
                    %{$Content},
                    Name    => 'LinkDeleteIdentifier',
                    Title   => $LinkName,
                    Content => $Content->{Object} . '::' . $Content->{Key} . '::' . $LinkType,
                },
            );
        }

        $Content->{Content} = $LayoutObject->Output(
            TemplateFile => 'LinkObject',
        );
    }

    # prepare text
    elsif ( $Content->{Type} eq 'Text' || !$Content->{Type} ) {

        $Blockname = $Content->{Translate} ? 'TextTranslate' : 'Text';
        $Content->{Content} ||= '-';
    }

    # run block
    $Self->{LayoutObject}->Block(
        Name => $Blockname,
        Data => $Content,
    );

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'LinkObject',
    );
}

=item LinkObjectSelectableObjectList()

return a selection list of linkable objects

    my $String = $LayoutObject->LinkObjectSelectableObjectList(
        Object   => 'Ticket',
        Selected => $Identifier,  # (optional)
    );

=cut

sub LinkObjectSelectableObjectList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Object} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Object!' );
        return;
    }

    # load link core module
    if ( !$Self->{LinkObject} ) {
        $Self->{LinkObject} = Kernel::System::LinkObject->new( %{$Self} );
    }

    # get possible objects list
    my %PossibleObjectsList = $Self->{LinkObject}->PossibleObjectsList(
        Object => $Param{Object},
        UserID => $Self->{UserID},
    );

    return if !%PossibleObjectsList;

    # get the select lists
    my @SelectableObjectList;
    my @SelectableTempList;
    my $AddBlankLines;
    POSSIBLEOBJECT:
    for my $PossibleObject ( sort { lc $a cmp lc $b } keys %PossibleObjectsList ) {

        # load backend
        my $BackendObject = $Self->_LoadLinkObjectLayoutBackend(
            Object => $PossibleObject,
        );

        return if !$BackendObject;

        # get object select list
        my @SelectableList = $BackendObject->SelectableObjectList(
            %Param,
        );

        next POSSIBLEOBJECT if !@SelectableList;

        push @SelectableTempList, \@SelectableList;
        push @SelectableObjectList, @SelectableList;

        next POSSIBLEOBJECT if $AddBlankLines;

        # check each keys if blank lines must be added
        ROW:
        for my $Row (@SelectableList) {
            next ROW if !$Row->{Key} || $Row->{Key} !~ m{ :: }xms;
            $AddBlankLines = 1;
            last ROW;
        }
    }

    # add blank lines
    if ($AddBlankLines) {

        # reset list
        @SelectableObjectList = ();

        # define blank line entry
        my %BlankLine = (
            Key      => '-',
            Value    => '-------------------------',
            Disabled => 1,
        );

        # insert the blank lines
        for my $Elements (@SelectableTempList) {
            push @SelectableObjectList, @{$Elements};
        }
        continue {
            push @SelectableObjectList, \%BlankLine;
        }

        # add blank lines in top of the list
        unshift @SelectableObjectList, \%BlankLine;
    }

    # create target object string
    my $TargetObjectStrg = $Self->{LayoutObject}->BuildSelection(
        Data     => \@SelectableObjectList,
        Name     => 'TargetIdentifier',
        TreeView => 1,
        OnChange => 'document.compose.submit(); return false;',
    );

    return $TargetObjectStrg;
}

=item LinkObjectSearchOptionList()

return a list of search options

    my @SearchOptionList = $LayoutObject->LinkObjectSearchOptionList(
        Object    => 'Ticket',
        SubObject => 'Bla',     # (optional)
    );

=cut

sub LinkObjectSearchOptionList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Object} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Object!' );
        return;
    }

    # load backend
    my $BackendObject = $Self->_LoadLinkObjectLayoutBackend(
        Object => $Param{Object},
    );

    return if !$BackendObject;

    # get search option list
    my @SearchOptionList = $BackendObject->SearchOptionList(
        %Param,
    );

    return @SearchOptionList;
}

=item _LoadLinkObjectLayoutBackend()

load a linkobject layout backend module

    $BackendObject = $LayoutObject->_LoadLinkObjectLayoutBackend(
        Object => 'Ticket',
    );

=cut

sub _LoadLinkObjectLayoutBackend {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Object} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Object!',
        );
        return;
    }

    # check if object is already cached
    return $Self->{Cache}->{LoadLinkObjectLayoutBackend}->{ $Param{Object} }
        if $Self->{Cache}->{LoadLinkObjectLayoutBackend}->{ $Param{Object} };

    my $GenericModule = "Kernel::Output::HTML::LinkObject$Param{Object}";

    # load the backend module
    if ( !$Self->{MainObject}->Require($GenericModule) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't load backend module $Param{Object}!"
        );
        return;
    }

    # create new instance
    my $BackendObject = $GenericModule->new(
        %{$Self},
        %Param,
        LayoutObject => $Self,
    );

    if ( !$BackendObject ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't create a new instance of backend module $Param{Object}!",
        );
        return;
    }

    # cache the object
    $Self->{Cache}->{LoadLinkObjectLayoutBackend}->{ $Param{Object} } = $BackendObject;

    return $BackendObject;
}

1;
