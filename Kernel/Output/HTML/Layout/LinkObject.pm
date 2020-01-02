# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Layout::LinkObject;

use strict;
use warnings;

use Kernel::System::LinkObject;
use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::Layout::LinkObject - all LinkObject-related HTML functions

=head1 DESCRIPTION

All LinkObject-related HTML functions

=head1 PUBLIC INTERFACE

=head2 LinkObjectTableCreate()

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    if ( $Param{ViewMode} =~ m{ \A Simple }xms ) {

        return $Self->LinkObjectTableCreateSimple(
            LinkListWithData               => $Param{LinkListWithData},
            ViewMode                       => $Param{ViewMode},
            AdditionalLinkListWithDataJSON => $Param{AdditionalLinkListWithDataJSON},
        );
    }
    else {

        return $Self->LinkObjectTableCreateComplex(
            LinkListWithData               => $Param{LinkListWithData},
            ViewMode                       => $Param{ViewMode},
            AJAX                           => $Param{AJAX},
            SourceObject                   => $Param{Object},
            ObjectID                       => $Param{Key},
            AdditionalLinkListWithDataJSON => $Param{AdditionalLinkListWithDataJSON},
        );
    }
}

=head2 LinkObjectTableCreateComplex()

create a complex output table

    my $String = $LayoutObject->LinkObjectTableCreateComplex(
        LinkListWithData => $LinkListRef,
        ViewMode         => 'Complex', # (Complex|ComplexAdd|ComplexDelete|ComplexRaw)
    );

=cut

sub LinkObjectTableCreateComplex {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # create new instance of the layout object
    my $LayoutObject  = Kernel::Output::HTML::Layout->new( %{$Self} );
    my $LayoutObject2 = Kernel::Output::HTML::Layout->new( %{$Self} );

    # check needed stuff
    for my $Argument (qw(LinkListWithData ViewMode)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check link list
    if ( ref $Param{LinkListWithData} ne 'HASH' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'LinkListWithData must be a hash reference!',
        );
        return;
    }

    return if !%{ $Param{LinkListWithData} };

    # convert the link list
    my %LinkList;
    for my $Object ( sort keys %{ $Param{LinkListWithData} } ) {

        for my $LinkType ( sort keys %{ $Param{LinkListWithData}->{$Object} } ) {

            # extract link type List
            my $LinkTypeList = $Param{LinkListWithData}->{$Object}->{$LinkType};

            for my $Direction ( sort keys %{$LinkTypeList} ) {

                # extract direction list
                my $DirectionList = $Param{LinkListWithData}->{$Object}->{$LinkType}->{$Direction};

                for my $ObjectKey ( sort keys %{$DirectionList} ) {

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
            Action                 => $Self->{Action},
            ObjectID               => $Param{ObjectID},
        );

        next OBJECT if !@BlockData;

        push @OutputData, @BlockData;
    }

    # error handling
    for my $Block (@OutputData) {

        ITEM:
        for my $Item ( @{ $Block->{ItemList} } ) {
            if ( !grep { $_->{Key} } @{$Item} ) {
                $Item->[0] = {
                    Type => 'Text',
                    Content =>
                        'ERROR: Key attribute not found in any column of the item list.',
                };
            }

            next ITEM if $Block->{Object};

            if ( !$Block->{Object} ) {
                $Item->[0] = {
                    Type    => 'Text',
                    Content => 'ERROR: Object attribute not found in the block data.',
                };
            }
        }
    }

    # get config option to show the link delete button
    my $ShowDeleteButton = $Kernel::OM->Get('Kernel::Config')->Get('LinkObject::ShowDeleteButton');

    # add "linked as" column to the table
    for my $Block (@OutputData) {

        # define the headline column
        my $Column = {
            Content => $Kernel::OM->Get('Kernel::Language')->Translate('Linked as'),
        };

        # add new column to the headline
        push @{ $Block->{Headline} }, $Column;

        # permission check
        my $SourcePermission;
        if ( $Param{SourceObject} && $Param{ObjectID} && $ShowDeleteButton ) {

            # get source permission
            $SourcePermission = $Kernel::OM->Get('Kernel::System::LinkObject')->ObjectPermission(
                Object => $Param{SourceObject},
                Key    => $Param{ObjectID},
                UserID => $Self->{UserID},
            );

            # we show the column headline if we got source permission
            if ($SourcePermission) {
                $Column = {
                    Content  => $Kernel::OM->Get('Kernel::Language')->Translate('Delete'),
                    CssClass => 'Center Last',
                };

                # add new column to the headline
                push @{ $Block->{Headline} }, $Column;
            }

        }
        for my $Item ( @{ $Block->{ItemList} } ) {

            my %LinkDeleteData;
            my $TargetPermission;

            # Search for key.
            my ($ItemWithKey) = grep { $_->{Key} } @{$Item};

            if ( $Param{SourceObject} && $Param{ObjectID} && $ItemWithKey->{Key} && $ShowDeleteButton ) {

                for my $LinkType ( sort keys %{ $LinkList{ $Block->{Object} }->{ $ItemWithKey->{Key} } } ) {

                    # get target permission
                    $TargetPermission = $Kernel::OM->Get('Kernel::System::LinkObject')->ObjectPermission(
                        Object => $Block->{Object},
                        Key    => $ItemWithKey->{Key},
                        UserID => $Self->{UserID},
                    );

                    # build the delete link only if we also got target permission
                    if ($TargetPermission) {

                        my %InstantLinkDeleteData;

                        # depending on the link type direction source and target must be switched
                        if ( $LinkList{ $Block->{Object} }->{ $ItemWithKey->{Key} }->{$LinkType} eq 'Source' ) {
                            $LinkDeleteData{SourceObject} = $Block->{Object};
                            $LinkDeleteData{SourceKey}    = $ItemWithKey->{Key};
                            $LinkDeleteData{TargetIdentifier}
                                = $Param{SourceObject} . '::' . $Param{ObjectID} . '::' . $LinkType;
                        }
                        else {
                            $LinkDeleteData{SourceObject} = $Param{SourceObject};
                            $LinkDeleteData{SourceKey}    = $Param{ObjectID};
                            $LinkDeleteData{TargetIdentifier}
                                = $Block->{Object} . '::' . $ItemWithKey->{Key} . '::' . $LinkType;
                        }
                    }
                }
            }

            # define check-box cell
            my $CheckboxCell = {
                Type         => 'LinkTypeList',
                Content      => '',
                LinkTypeList => $LinkList{ $Block->{Object} }->{ $ItemWithKey->{Key} },
                Translate    => 1,
            };

            # add check-box cell to item
            push @{$Item}, $CheckboxCell;

            # check if delete icon should be shown
            if ( $Param{SourceObject} && $Param{ObjectID} && $SourcePermission && $ShowDeleteButton ) {

                if ($TargetPermission) {

                    # build delete link
                    push @{$Item}, {
                        Type      => 'DeleteLinkIcon',
                        CssClass  => 'Center Last',
                        Translate => 1,
                        %LinkDeleteData,
                    };
                }
                else {
                    # build no delete link, instead use empty values
                    # to keep table formatting correct
                    push @{$Item}, {
                        Type     => 'Plain',
                        CssClass => 'Center Last',
                        Content  => '',
                    };
                }
            }
        }
    }

    return @OutputData if $Param{ViewMode} && $Param{ViewMode} eq 'ComplexRaw';

    if ( $Param{ViewMode} eq 'ComplexAdd' ) {

        for my $Block (@OutputData) {

            # define the headline column
            my $Column;

            # add new column to the headline
            unshift @{ $Block->{Headline} }, $Column;

            for my $Item ( @{ $Block->{ItemList} } ) {

                # search for key
                my ($ItemWithKey) = grep { $_->{Key} } @{$Item};

                # define check-box cell
                my $CheckboxCell = {
                    Type    => 'Checkbox',
                    Name    => 'LinkTargetKeys',
                    Content => $ItemWithKey->{Key},
                };

                # add check-box cell to item
                unshift @{$Item}, $CheckboxCell;
            }
        }
    }

    if ( $Param{ViewMode} eq 'ComplexDelete' ) {

        for my $Block (@OutputData) {

            # define the headline column
            my $Column = {
                Content => ' ',
            };

            # add new column to the headline
            unshift @{ $Block->{Headline} }, $Column;

            for my $Item ( @{ $Block->{ItemList} } ) {

                # search for key
                my ($ItemWithKey) = grep { $_->{Key} } @{$Item};

                # define check-box delete cell
                my $CheckboxCell = {
                    Type         => 'CheckboxDelete',
                    Object       => $Block->{Object},
                    Content      => '',
                    Key          => $ItemWithKey->{Key},
                    LinkTypeList => $LinkList{ $Block->{Object} }->{ $ItemWithKey->{Key} },
                    Translate    => 1,
                };

                # add check-box cell to item
                unshift @{$Item}, $CheckboxCell;
            }
        }
    }

    # # create new instance of the layout object
    # my $LayoutObject  = Kernel::Output::HTML::Layout->new( %{$Self} );
    # my $LayoutObject2 = Kernel::Output::HTML::Layout->new( %{$Self} );

    # output the table complex block
    $LayoutObject->Block(
        Name => 'TableComplex',
    );

    # set block description
    my $BlockDescription = $Param{ViewMode} eq 'ComplexAdd' ? Translatable('Search Result') : Translatable('Linked');

    my $BlockCounter = 0;

    my $Config             = $Kernel::OM->Get('Kernel::Config')->Get("LinkObject::ComplexTable") || {};
    my $SettingsVisibility = $Kernel::OM->Get('Kernel::Config')->Get("LinkObject::ComplexTable::SettingsVisibility")
        || {};

    my @SettingsVisible = ();

    if ( IsHashRefWithData($SettingsVisibility) ) {
        for my $Key ( sort keys %{$SettingsVisibility} ) {

            for my $Item ( @{ $SettingsVisibility->{$Key} } ) {

                # check if it's not in array
                if ( !grep { $Item eq $_ } @SettingsVisible ) {
                    push @SettingsVisible, $Item;
                }
            }
        }
    }

    # get OriginalAction
    my $OriginalAction = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'OriginalAction' )
        || $Self->{Action};

    my @LinkObjectTables;
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
                Blockname        => $Block->{Blockname} . ' (' . scalar @{ $Block->{ItemList} } . ')',
                Name             => $Block->{Blockname},
                NameForm         => $Block->{Blockname},
                AJAX             => $Param{AJAX},
            },
        );

        # check if registered in SysConfig
        if (
            # AgentLinkObject not allowed because it would result in nested forms
            $OriginalAction ne 'AgentLinkObject'
            && IsHashRefWithData($Config)
            && $Config->{ $Block->{Blockname} }
            && grep { $OriginalAction eq $_ } @SettingsVisible
            )
        {
            my $SourceObjectData = '';
            if ( $Block->{ObjectName} && $Block->{ObjectID} ) {
                $SourceObjectData = "<input type='hidden' name='$Block->{ObjectName}' value='$Block->{ObjectID}' />";
            }

            $LayoutObject->Block(
                Name => 'ContentLargePreferences',
                Data => {
                    Name => $Block->{Blockname},
                },
            );

            my %Preferences = $Self->ComplexTablePreferencesGet(
                Config  => $Config->{ $Block->{Blockname} },
                PrefKey => "LinkObject::ComplexTable-" . $Block->{Blockname},
            );

            # Add translations for the allocation lists for regular columns.
            for my $Column ( @{ $Block->{AllColumns} } ) {
                $LayoutObject->AddJSData(
                    Key   => 'Column' . $Column->{ColumnName},
                    Value => $LayoutObject->{LanguageObject}->Translate( $Column->{ColumnTranslate} ),
                );
            }

            # Prepare LinkObjectTables for JS config.
            push @LinkObjectTables, $Block->{Blockname};

            $LayoutObject->Block(
                Name => 'ContentLargePreferencesForm',
                Data => {
                    Name     => $Block->{Blockname},
                    NameForm => $Block->{Blockname},
                },
            );

            $LayoutObject->Block(
                Name => $Preferences{Name} . 'PreferencesItem' . $Preferences{Block},
                Data => {
                    %Preferences,
                    NameForm                       => $Block->{Blockname},
                    NamePref                       => $Preferences{Name},
                    Name                           => $Block->{Blockname},
                    SourceObject                   => $Param{SourceObject},
                    DestinationObject              => $Block->{Blockname},
                    OriginalAction                 => $OriginalAction,
                    SourceObjectData               => $SourceObjectData,
                    AdditionalLinkListWithDataJSON => $Param{AdditionalLinkListWithDataJSON},
                },
            );
        }

        # output table headline
        for my $HeadlineColumn ( @{ $Block->{Headline} } ) {

            # output a headline column block
            $LayoutObject->Block(
                Name => 'TableComplexBlockColumn',
                Data => $HeadlineColumn,
            );
        }

        # output item list
        for my $Row ( @{ $Block->{ItemList} } ) {

            # output a table row block
            $LayoutObject->Block(
                Name => 'TableComplexBlockRow',
            );

            for my $Column ( @{$Row} ) {

                # create the content string
                my $Content = $Self->_LinkObjectContentStringCreate(
                    Object       => $Block->{Object},
                    ContentData  => $Column,
                    LayoutObject => $LayoutObject2,
                );

                # output a table column block
                $LayoutObject->Block(
                    Name => 'TableComplexBlockRowColumn',
                    Data => {
                        %{$Column},
                        Content => $Content,
                    },
                );
            }
        }

        if ( $Param{ViewMode} eq 'ComplexAdd' ) {

            # output the action row block
            $LayoutObject->Block(
                Name => 'TableComplexBlockActionRow',
            );

            $LayoutObject->Block(
                Name => 'TableComplexBlockActionRowBulk',
                Data => {
                    Name        => Translatable('Bulk'),
                    TableNumber => $BlockCounter,
                },
            );

            # output the footer block
            $LayoutObject->Block(
                Name => 'TableComplexBlockFooterAdd',
                Data => {
                    LinkTypeStrg => $Param{LinkTypeStrg} || '',
                },
            );
        }

        elsif ( $Param{ViewMode} eq 'ComplexDelete' ) {

            # output the action row block
            $LayoutObject->Block(
                Name => 'TableComplexBlockActionRow',
            );

            $LayoutObject->Block(
                Name => 'TableComplexBlockActionRowBulk',
                Data => {
                    Name        => Translatable('Bulk'),
                    TableNumber => $BlockCounter,
                },
            );

            # output the footer block
            $LayoutObject->Block(
                Name => 'TableComplexBlockFooterDelete',
            );
        }
        else {

            # output the footer block
            $LayoutObject->Block(
                Name => 'TableComplexBlockFooterNormal',
            );
        }

        # increase BlockCounter to set correct IDs for Select All Check-boxes
        $BlockCounter++;
    }

    # Send LinkObjectTables to JS.
    $LayoutObject->AddJSData(
        Key   => 'LinkObjectTables',
        Value => \@LinkObjectTables,
    );

    return $LayoutObject->Output(
        TemplateFile => 'LinkObject',
        AJAX         => $Param{AJAX},
    );
}

=head2 LinkObjectTableCreateSimple()

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need LinkListWithData!',
        );
        return;
    }

    # get type list
    my %TypeList = $Kernel::OM->Get('Kernel::System::LinkObject')->TypeList(
        UserID => $Self->{UserID},
    );

    return if !%TypeList;

    my %OutputData;
    OBJECT:
    for my $Object ( sort keys %{ $Param{LinkListWithData} } ) {

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

        for my $LinkType ( sort keys %LinkOutputData ) {

            $OutputData{$LinkType}->{$Object} = $LinkOutputData{$LinkType}->{$Object};
        }
    }

    return %OutputData if $Param{ViewMode} && $Param{ViewMode} eq 'SimpleRaw';

    # create new instance of the layout object
    my $LayoutObject  = Kernel::Output::HTML::Layout->new( %{$Self} );
    my $LayoutObject2 = Kernel::Output::HTML::Layout->new( %{$Self} );

    my $Count = 0;
    for my $LinkTypeLinkDirection ( sort { lc $a cmp lc $b } keys %OutputData ) {
        $Count++;

        # output the table simple block
        if ( $Count == 1 ) {
            $LayoutObject->Block(
                Name => 'TableSimple',
            );
        }

        # investigate link type name
        my @LinkData     = split q{::}, $LinkTypeLinkDirection;
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
                my $Content = $Self->_LinkObjectContentStringCreate(
                    Object       => $Object,
                    ContentData  => $Item,
                    LayoutObject => $LayoutObject2,
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

    # show no linked object available
    if ( !$Count ) {
        $LayoutObject->Block(
            Name => 'TableSimpleNone',
            Data => {},
        );
    }

    return $LayoutObject->Output(
        TemplateFile => 'LinkObject',
    );
}

=head2 LinkObjectSelectableObjectList()

return a selection list of link-able objects

    my $String = $LayoutObject->LinkObjectSelectableObjectList(
        Object   => 'Ticket',
        Selected => $Identifier,  # (optional)
    );

=cut

sub LinkObjectSelectableObjectList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Object} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Object!'
        );
        return;
    }

    # get possible objects list
    my %PossibleObjectsList = $Kernel::OM->Get('Kernel::System::LinkObject')->PossibleObjectsList(
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

        push @SelectableTempList,   \@SelectableList;
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

    # create new instance of the layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # create target object string
    my $TargetObjectStrg = $LayoutObject->BuildSelection(
        Data     => \@SelectableObjectList,
        Name     => 'TargetIdentifier',
        Class    => 'Modernize',
        TreeView => 1,
    );

    return $TargetObjectStrg;
}

=head2 LinkObjectSearchOptionList()

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Object!'
        );
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

=head2 ComplexTablePreferencesGet()

get items needed for AllocationList initialization.

    my %Preferences = $LayoutObject->ComplexTablePreferencesGet(
        Config  => {
            'DefaultColumns' => {
                'Age' => 1,
                'EscalationTime' => 1,
                ...
            },
            Priority => {
                'Age' => 120,
                'TicketNumber' => 100,
                ...
            }
        }.
        PrefKey => "LinkObject::ComplexTable-Ticket",
    );

returns:
    %Preferences =  {
        'ColumnsAvailable' => '["Age","Changed","CustomerID","CustomerName","CustomerUserID",...]',
        'Block' => 'AllocationList',
        'Translation' => 1,
        'Name' => 'ContentLarge',
        'Columns' => '{"Columns":{"SLA":0,"Type":0,"Owner":0,"Service":0,"CustomerUserID":0,...}}',
        'Desc' => 'Shown Columns',
        'ColumnsEnabled' => '["State","TicketNumber","Title","Created","Queue"]',
    };

=cut

sub ComplexTablePreferencesGet {
    my ( $Self, %Param ) = @_;

    # configure columns
    my @ColumnsEnabled;
    my @ColumnsAvailable;
    my @ColumnsAvailableNotEnabled;

    # check for default settings
    if (
        $Param{Config}->{DefaultColumns}
        && IsHashRefWithData( $Param{Config}->{DefaultColumns} )
        )
    {
        @ColumnsAvailable = grep { $Param{Config}->{DefaultColumns}->{$_} }
            keys %{ $Param{Config}->{DefaultColumns} };
        @ColumnsEnabled = grep { $Param{Config}->{DefaultColumns}->{$_} eq '2' }
            keys %{ $Param{Config}->{DefaultColumns} };

        if (
            $Param{Config}->{Priority}
            && IsHashRefWithData( $Param{Config}->{Priority} )
            )
        {
            # sort according to priority defined in SysConfig
            @ColumnsEnabled
                = sort { $Param{Config}->{Priority}->{$a} <=> $Param{Config}->{Priority}->{$b} } @ColumnsEnabled;
        }
    }

    # check if the user has filter preferences for this widget
    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    # get JSON object
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    # if preference settings are available, take them
    if ( $Preferences{ $Param{PrefKey} } ) {

        my $ColumnsEnabled = $JSONObject->Decode(
            Data => $Preferences{ $Param{PrefKey} },
        );

        @ColumnsEnabled = grep { $ColumnsEnabled->{Columns}->{$_} == 1 }
            keys %{ $ColumnsEnabled->{Columns} };

        if ( $ColumnsEnabled->{Order} && @{ $ColumnsEnabled->{Order} } ) {
            @ColumnsEnabled = @{ $ColumnsEnabled->{Order} };
        }

        # remove duplicate columns
        my %UniqueColumns;
        my @ColumnsEnabledAux;

        for my $Column (@ColumnsEnabled) {
            if ( !$UniqueColumns{$Column} ) {
                push @ColumnsEnabledAux, $Column;
            }
            $UniqueColumns{$Column} = 1;
        }

        # set filtered column list
        @ColumnsEnabled = @ColumnsEnabledAux;
    }

    my %Columns;
    for my $ColumnName ( sort { $a cmp $b } @ColumnsAvailable ) {
        $Columns{Columns}->{$ColumnName} = ( grep { $ColumnName eq $_ } @ColumnsEnabled ) ? 1 : 0;
        if ( !grep { $_ eq $ColumnName } @ColumnsEnabled ) {
            push @ColumnsAvailableNotEnabled, $ColumnName;
        }
    }
    $Columns{Order} = \@ColumnsEnabled;

    my %Params = (
        Desc             => Translatable('Shown Columns'),
        Name             => "ContentLarge",
        Block            => 'AllocationList',
        Columns          => $JSONObject->Encode( Data => \%Columns ),
        ColumnsEnabled   => $JSONObject->Encode( Data => \@ColumnsEnabled ),
        ColumnsAvailable => $JSONObject->Encode( Data => \@ColumnsAvailableNotEnabled ),
        Translation      => 1,
    );

    return %Params;
}

=head2 ComplexTablePreferencesSet()

set user preferences.

    my $Success = $LayoutObject->ComplexTablePreferencesSet(
        DestinationObject => 'Ticket',
    );

=cut

sub ComplexTablePreferencesSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw( DestinationObject)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # needed objects
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $JSONObject   = $Kernel::OM->Get('Kernel::System::JSON');

    my $Result = 'Unknown';
    my $Config = $ConfigObject->Get("LinkObject::ComplexTable") || {};

    # get default preferences
    my %Preferences = $Self->ComplexTablePreferencesGet(
        Config  => $Config->{ $Param{DestinationObject} },
        PrefKey => "LinkObject::ComplexTable-" . $Param{DestinationObject},
    );

    if ( !%Preferences ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No preferences for $Param{DestinationObject}!"
        );
        return;
    }

    # get params
    my $Value = $ParamObject->GetParam( Param => $Preferences{Name} );

    # decode JSON value
    my $Preference = $JSONObject->Decode(
        Data => $Value,
    );

    # remove Columns (not needed)
    delete $Preference->{Columns};

    if ( $Param{DestinationObject} eq 'Ticket' ) {

        # Make sure that ticket number is always present, otherwise there will be problems.
        if ( !grep { $_ eq 'TicketNumber' } @{ $Preference->{Order} } ) {
            unshift @{ $Preference->{Order} }, 'TicketNumber';
        }
    }

    if ( IsHashRefWithData($Preference) ) {

        $Value = $JSONObject->Encode(
            Data => $Preference,
        );

        # update runtime vars
        $Self->{ $Preferences{Name} } = $Value;

        # update session
        $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $Preferences{Name},
            Value     => $Value,
        );

        # update preferences
        if ( !$ConfigObject->Get('DemoSystem') ) {
            $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
                UserID => $Self->{UserID},
                Key    => "LinkObject::ComplexTable-" . $Param{DestinationObject},
                Value  => $Value,
            );

            return 1;
        }
    }

    return 0;
}

=begin Internal:

=head2 _LinkObjectContentStringCreate()

return a output string

    my $String = $LayoutObject->_LinkObjectContentStringCreate(
        Object       => 'Ticket',
        ContentData  => $HashRef,
        LayoutObject => $LocalLayoutObject,
    );

=cut

sub _LinkObjectContentStringCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object ContentData LayoutObject)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # load link core module
    my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

    # load backend
    my $BackendObject = $Self->_LoadLinkObjectLayoutBackend(
        Object => $Param{Object},
    );

    # create content string in backend module
    if ($BackendObject) {

        my $ContentString = $BackendObject->ContentStringCreate(
            %Param,
            LinkObject   => $LinkObject,
            LayoutObject => $Param{LayoutObject},
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
        my %TypeList = $LinkObject->TypeList(
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
                $LinkName = $Param{LayoutObject}->{LanguageObject}->Translate($LinkName);
            }

            push @LinkNameList, $LinkName;
        }

        # join string
        my $String = join qq{\n}, @LinkNameList;

        # transform ascii to html
        $Content->{Content} = $Param{LayoutObject}->Ascii2Html(
            Text           => $String || '-',
            HTMLResultMode => 1,
            LinkFeature    => 0,
        );
    }

    # prepare checkbox delete
    elsif ( $Content->{Type} eq 'CheckboxDelete' ) {

        $Blockname = 'Plain';

        # get type list
        my %TypeList = $LinkObject->TypeList(
            UserID => $Self->{UserID},
        );

        return if !%TypeList;

        LINKTYPE:
        for my $LinkType ( sort { lc $a cmp lc $b } keys %{ $Content->{LinkTypeList} } ) {

            next LINKTYPE if $LinkType eq 'NOTLINKED';

            # extract direction
            my $Direction = $Content->{LinkTypeList}->{$LinkType};

            # extract linkname
            my $LinkName = $TypeList{$LinkType}->{ $Direction . 'Name' };

            # translate
            if ( $Content->{Translate} ) {
                $LinkName = $Param{LayoutObject}->{LanguageObject}->Translate($LinkName);
            }

            # run checkbox block
            $Param{LayoutObject}->Block(
                Name => 'Checkbox',
                Data => {
                    %{$Content},
                    Name    => 'LinkDeleteIdentifier',
                    Title   => $LinkName,
                    Content => $Content->{Object} . '::' . $Content->{Key} . '::' . $LinkType,
                },
            );
        }

        $Content->{Content} = $Param{LayoutObject}->Output(
            TemplateFile => 'LinkObject',
        );
    }

    elsif ( $Content->{Type} eq 'TimeLong' ) {
        $Blockname = 'TimeLong';
    }

    elsif ( $Content->{Type} eq 'Date' ) {
        $Blockname = 'Date';
    }

    # prepare text
    elsif ( $Content->{Type} eq 'Text' || !$Content->{Type} ) {

        $Blockname = $Content->{Translate} ? 'TextTranslate' : 'Text';
        $Content->{Content} ||= '-';
    }

    # run block
    $Param{LayoutObject}->Block(
        Name => $Blockname,
        Data => $Content,
    );

    return $Param{LayoutObject}->Output(
        TemplateFile => 'LinkObject',
    );
}

=head2 _LoadLinkObjectLayoutBackend()

load a linkobject layout backend module

    $BackendObject = $LayoutObject->_LoadLinkObjectLayoutBackend(
        Object => 'Ticket',
    );

=cut

sub _LoadLinkObjectLayoutBackend {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    if ( !$Param{Object} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'Need Object!',
        );
        return;
    }

    # check if object is already cached
    return $Self->{Cache}->{LoadLinkObjectLayoutBackend}->{ $Param{Object} }
        if $Self->{Cache}->{LoadLinkObjectLayoutBackend}->{ $Param{Object} };

    my $GenericModule = "Kernel::Output::HTML::LinkObject::$Param{Object}";

    # load the backend module
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($GenericModule) ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Can't load backend module $Param{Object}!"
        );
        return;
    }

    # create new instance
    my $BackendObject = $GenericModule->new(
        %{$Self},
        %Param,
    );

    if ( !$BackendObject ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Can't create a new instance of backend module $Param{Object}!",
        );
        return;
    }

    # cache the object
    $Self->{Cache}->{LoadLinkObjectLayoutBackend}->{ $Param{Object} } = $BackendObject;

    return $BackendObject;
}

=end Internal:

=cut

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
