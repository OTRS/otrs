# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::LinkObject::Ticket;

use strict;
use warnings;

use List::Util qw(first);

use Kernel::Output::HTML::Layout;
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CustomerCompany',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::Priority',
    'Kernel::System::State',
    'Kernel::System::Type',
    'Kernel::System::User',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::Output::HTML::LinkObject::Ticket - layout backend module

=head1 DESCRIPTION

All layout functions of link object (ticket).


=head2 new()

create an object

    $BackendObject = Kernel::Output::HTML::LinkObject::Ticket->new(
        UserLanguage => 'en',
        UserID       => 1,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(UserLanguage UserID)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # We need our own LayoutObject instance to avoid block data collisions
    #   with the main page.
    $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new( %{$Self} );

    # define needed variables
    $Self->{ObjectData} = {
        Object     => 'Ticket',
        Realname   => 'Ticket',
        ObjectName => 'SourceObjectID',
    };

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 0,
        ObjectType => ['Ticket'],
    );

    return $Self;
}

=head2 TableCreateComplex()

return an array with the block data

Return

    %BlockData = (
        {
            ObjectName  => 'TicketID',
            ObjectID    => '14785',

            Object    => 'Ticket',
            Blockname => 'Ticket',
            Headline  => [
                {
                    Content => 'Number#',
                    Width   => 130,
                },
                {
                    Content => 'Title',
                },
                {
                    Content => 'Created',
                    Width   => 110,
                },
            ],
            ItemList => [
                [
                    {
                        Type     => 'Link',
                        Key      => $TicketID,
                        Content  => '123123123',
                        CssClass => 'StrikeThrough',
                    },
                    {
                        Type      => 'Text',
                        Content   => 'The title',
                        MaxLength => 50,
                    },
                    {
                        Type    => 'TimeLong',
                        Content => '2008-01-01 12:12:00',
                    },
                ],
                [
                    {
                        Type    => 'Link',
                        Key     => $TicketID,
                        Content => '434234',
                    },
                    {
                        Type      => 'Text',
                        Content   => 'The title of ticket 2',
                        MaxLength => 50,
                    },
                    {
                        Type    => 'TimeLong',
                        Content => '2008-01-01 12:12:00',
                    },
                ],
            ],
        },
    );

    @BlockData = $BackendObject->TableCreateComplex(
        ObjectLinkListWithData => $ObjectLinkListRef,
    );

=cut

sub TableCreateComplex {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ObjectLinkListWithData} || ref $Param{ObjectLinkListWithData} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ObjectLinkListWithData!',
        );
        return;
    }

    # create needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # convert the list
    my %LinkList;
    for my $LinkType ( sort keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( sort keys %{$LinkTypeList} ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            for my $TicketID ( sort keys %{$DirectionList} ) {

                $LinkList{$TicketID}->{Data} = $DirectionList->{$TicketID};
            }
        }
    }

    my $ComplexTableData = $ConfigObject->Get("LinkObject::ComplexTable");
    my $DefaultColumns;
    if (
        $ComplexTableData
        && IsHashRefWithData($ComplexTableData)
        && $ComplexTableData->{Ticket}
        && IsHashRefWithData( $ComplexTableData->{Ticket} )
        )
    {
        $DefaultColumns = $ComplexTableData->{"Ticket"}->{"DefaultColumns"};
    }

    my @TimeLongTypes = (
        "Created",
        "Changed",
        "EscalationDestinationDate",
        "FirstResponseTimeDestinationDate",
        "UpdateTimeDestinationDate",
        "SolutionTimeDestinationDate",
    );

    # define the block data
    my $TicketHook        = $ConfigObject->Get('Ticket::Hook');
    my $TicketHookDivider = $ConfigObject->Get('Ticket::HookDivider');

    my @Headline;

    # Get needed objects.
    my $UserObject     = $Kernel::OM->Get('Kernel::System::User');
    my $JSONObject     = $Kernel::OM->Get('Kernel::System::JSON');
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    # load user preferences
    my %Preferences = $UserObject->GetPreferences(
        UserID => $Self->{UserID},
    );

    if ( !$DefaultColumns || !IsHashRefWithData($DefaultColumns) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Missing configuration for LinkObject::ComplexTable###Ticket!',
        );
        return;
    }

# Get default column priority from SysConfig
# Each column in table (Title, State, Type,...) has defined Priority in SysConfig. System use this priority to sort columns, if user doesn't have own settings.
    my %SortOrder;
    if (
        $ComplexTableData->{"Ticket"}->{"Priority"}
        && IsHashRefWithData( $ComplexTableData->{"Ticket"}->{"Priority"} )
        )
    {
        %SortOrder = %{ $ComplexTableData->{"Ticket"}->{"Priority"} };
    }

    my %UserColumns = %{$DefaultColumns};

    if ( $Preferences{'LinkObject::ComplexTable-Ticket'} ) {

        my $ColumnsEnabled = $JSONObject->Decode(
            Data => $Preferences{'LinkObject::ComplexTable-Ticket'},
        );

        if (
            $ColumnsEnabled
            && IsHashRefWithData($ColumnsEnabled)
            && $ColumnsEnabled->{Order}
            && IsArrayRefWithData( $ColumnsEnabled->{Order} )
            )
        {
            # Clear sort order
            %SortOrder = ();

            DEFAULTCOLUMN:
            for my $DefaultColumn ( sort keys %UserColumns ) {
                my $Index = 0;

                for my $UserSetting ( @{ $ColumnsEnabled->{Order} } ) {
                    $Index++;
                    if ( $DefaultColumn eq $UserSetting ) {
                        $UserColumns{$DefaultColumn} = 2;
                        $SortOrder{$DefaultColumn}   = $Index;

                        next DEFAULTCOLUMN;
                    }
                }

                # not found, means user chose to hide this item
                if ( $UserColumns{$DefaultColumn} == 2 ) {
                    $UserColumns{$DefaultColumn} = 1;
                }

                if ( !$SortOrder{$DefaultColumn} ) {
                    $SortOrder{$DefaultColumn} = 0;    # Set 0, it system will hide this item anyways
                }
            }
        }
    }
    else {
        # user has no own settings
        for my $Column ( sort keys %UserColumns ) {
            if ( !$SortOrder{$Column} ) {
                $SortOrder{$Column} = 0;               # Set 0, it system will hide this item anyways
            }
        }
    }

    # Define Headline columns

    # Sort
    my @AllColumns;
    COLUMN:
    for my $Column ( sort { $SortOrder{$a} <=> $SortOrder{$b} } keys %UserColumns ) {

        my $ColumnTranslate = $Column;
        if ( $Column eq 'EscalationTime' ) {
            $ColumnTranslate = Translatable('Service Time');
        }
        elsif ( $Column eq 'EscalationResponseTime' ) {
            $ColumnTranslate = Translatable('First Response Time');
        }
        elsif ( $Column eq 'EscalationSolutionTime' ) {
            $ColumnTranslate = Translatable('Solution Time');
        }
        elsif ( $Column eq 'EscalationUpdateTime' ) {
            $ColumnTranslate = Translatable('Update Time');
        }
        elsif ( $Column eq 'PendingTime' ) {
            $ColumnTranslate = Translatable('Pending till');
        }
        elsif ( $Column eq 'CustomerCompanyName' ) {
            $ColumnTranslate = Translatable('Customer Name');
        }
        elsif ( $Column eq 'CustomerID' ) {
            $ColumnTranslate = Translatable('Customer ID');
        }
        elsif ( $Column eq 'CustomerName' ) {
            $ColumnTranslate = Translatable('Customer User Name');
        }
        elsif ( $Column eq 'CustomerUserID' ) {
            $ColumnTranslate = Translatable('Customer User ID');
        }
        elsif ( $Column =~ m{ \A DynamicField_ }xms ) {
            my $DynamicFieldConfig;

            DYNAMICFIELD:
            for my $DFConfig ( @{ $Self->{DynamicField} } ) {
                next DYNAMICFIELD if !IsHashRefWithData($DFConfig);
                next DYNAMICFIELD if 'DynamicField_' . $DFConfig->{Name} ne $Column;

                $DynamicFieldConfig = $DFConfig;
                last DYNAMICFIELD;
            }
            next COLUMN if !IsHashRefWithData($DynamicFieldConfig);

            $ColumnTranslate = $DynamicFieldConfig->{Label};
        }

        push @AllColumns, {
            ColumnName      => $Column,
            ColumnTranslate => $ColumnTranslate,
        };

        # if enabled by default
        if ( $UserColumns{$Column} == 2 ) {
            my $ColumnName = '';

            # Ticket fields
            if ( $Column !~ m{\A DynamicField_}xms ) {
                $ColumnName = $Column eq 'TicketNumber' ? $TicketHook : $ColumnTranslate;
            }

            # Dynamic fields (get label from the translated column).
            else {
                $ColumnName = $ColumnTranslate;
            }

            push @Headline, {
                Content => $ColumnName,
            };
        }
    }

    # create the item list (table content)
    my @ItemList;
    for my $TicketID (
        sort { $LinkList{$a}{Data}->{Age} <=> $LinkList{$b}{Data}->{Age} }
        keys %LinkList
        )
    {

        # extract ticket data
        my $Ticket = $LinkList{$TicketID}{Data};

        # set css
        my $CssClass;
        my @StatesToStrike = @{ $ConfigObject->Get('LinkObject::StrikeThroughLinkedTicketStateTypes') || [] };
        if ( first { $Ticket->{StateType} eq $_ } @StatesToStrike ) {
            $CssClass = 'StrikeThrough';
        }

        my @ItemColumns;

        # Sort
        COLUMN:
        for my $Column ( sort { $SortOrder{$a} <=> $SortOrder{$b} } keys %UserColumns ) {

            # if enabled by default
            if ( $UserColumns{$Column} == 2 ) {

                my %Hash;
                if ( grep { $_ eq $Column } @TimeLongTypes ) {
                    $Hash{'Type'} = 'TimeLong';
                }
                else {
                    $Hash{'Type'} = 'Text';
                }

                if ( $Column eq 'Title' ) {
                    $Hash{MaxLength} = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::SubjectSize') || 50;
                }

                # Ticket fields
                if ( $Column !~ m{\A DynamicField_}xms ) {

                    if ( $Column eq 'TicketNumber' ) {

                        %Hash = (
                            Type    => 'Link',
                            Key     => $TicketID,
                            Content => $Ticket->{TicketNumber},
                            Link    => $Self->{LayoutObject}->{Baselink}
                                . 'Action=AgentTicketZoom;TicketID='
                                . $TicketID,
                            Title    => "$TicketHook$TicketHookDivider$Ticket->{TicketNumber}",
                            CssClass => $CssClass,
                        );
                    }
                    elsif ( $Column eq 'EscalationTime' ) {

                        $Hash{'Content'} = $Self->{LayoutObject}->CustomerAge(
                            Age   => $Ticket->{'EscalationTime'},
                            Space => ' '
                        );
                    }
                    elsif ( $Column eq 'Age' ) {
                        $Hash{'Content'} = $Self->{LayoutObject}->CustomerAge(
                            Age   => $Ticket->{Age},
                            Space => ' ',
                        );
                    }
                    elsif ( $Column eq 'EscalationSolutionTime' ) {

                        $Hash{'Content'} = $Self->{LayoutObject}->CustomerAge(
                            Age                => $Ticket->{SolutionTime} || 0,
                            TimeShowAlwaysLong => 1,
                            Space              => ' ',
                        );
                    }
                    elsif ( $Column eq 'EscalationResponseTime' ) {

                        $Hash{'Content'} = $Self->{LayoutObject}->CustomerAge(
                            Age                => $Ticket->{FirstResponseTime} || 0,
                            TimeShowAlwaysLong => 1,
                            Space              => ' ',
                        );
                    }
                    elsif ( $Column eq 'EscalationUpdateTime' ) {
                        $Hash{'Content'} = $Self->{LayoutObject}->CustomerAge(
                            Age                => $Ticket->{UpdateTime} || 0,
                            TimeShowAlwaysLong => 1,
                            Space              => ' ',
                        );
                    }
                    elsif ( $Column eq 'PendingTime' ) {
                        $Hash{'Content'} = $Self->{LayoutObject}->CustomerAge(
                            Age   => $Ticket->{'UntilTime'},
                            Space => ' '
                        );
                    }
                    elsif ( $Column eq 'Owner' ) {

                        # get owner info
                        my %OwnerInfo = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                            UserID => $Ticket->{OwnerID},
                        );
                        $Hash{'Content'} = $OwnerInfo{'UserFullname'};
                    }
                    elsif ( $Column eq 'Responsible' ) {

                        # get responsible info
                        my %ResponsibleInfo = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                            UserID => $Ticket->{ResponsibleID},
                        );
                        $Hash{'Content'} = $ResponsibleInfo{'UserFullname'};
                    }
                    elsif ( $Column eq 'CustomerName' ) {

                        # get customer name
                        my $CustomerName;
                        if ( $Ticket->{CustomerUserID} ) {
                            $CustomerName = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerName(
                                UserLogin => $Ticket->{CustomerUserID},
                            );
                        }
                        $Hash{'Content'} = $CustomerName;
                    }
                    elsif ( $Column eq 'CustomerCompanyName' ) {
                        my %CustomerCompany = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyGet(
                            CustomerID => $Ticket->{CustomerID},
                        );
                        $Hash{'Content'} = $CustomerCompany{CustomerCompanyName};
                    }
                    elsif ( $Column eq 'State' || $Column eq 'Priority' || $Column eq 'Lock' ) {
                        $Hash{'Content'} = $LanguageObject->Translate( $Ticket->{$Column} );
                    }
                    else {
                        $Hash{'Content'} = $Ticket->{$Column};
                    }
                }

                # Dynamic fields
                else {
                    my $DynamicFieldConfig;
                    my $DFColumn = $Column;
                    $DFColumn =~ s{DynamicField_}{}g;

                    DYNAMICFIELD:
                    for my $DFConfig ( @{ $Self->{DynamicField} } ) {
                        next DYNAMICFIELD if !IsHashRefWithData($DFConfig);
                        next DYNAMICFIELD if $DFConfig->{Name} ne $DFColumn;

                        $DynamicFieldConfig = $DFConfig;
                        last DYNAMICFIELD;
                    }
                    next COLUMN if !IsHashRefWithData($DynamicFieldConfig);

                    # get field value
                    my $Value = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ObjectID           => $TicketID,
                    );

                    my $ValueStrg = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->DisplayValueRender(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Value              => $Value,
                        ValueMaxChars      => 20,
                        LayoutObject       => $Self->{LayoutObject},
                    );

                    $Hash{'Content'} = $ValueStrg->{Title};
                }

                push @ItemColumns, \%Hash;
            }
        }

        push @ItemList, \@ItemColumns;
    }

    return if !@ItemList;

    my %Block = (
        Object     => $Self->{ObjectData}->{Object},
        Blockname  => $Self->{ObjectData}->{Realname},
        ObjectName => $Self->{ObjectData}->{ObjectName},
        ObjectID   => $Param{ObjectID},
        Headline   => \@Headline,
        ItemList   => \@ItemList,
        AllColumns => \@AllColumns,
    );

    return ( \%Block );
}

=head2 TableCreateSimple()

return a hash with the link output data

Return

    %LinkOutputData = (
        Normal::Source => {
            Ticket => [
                {
                    Type     => 'Link',
                    Content  => 'T:55555',
                    Title    => 'Ticket#555555: The ticket title',
                    CssClass => 'StrikeThrough',
                },
                {
                    Type    => 'Link',
                    Content => 'T:22222',
                    Title   => 'Ticket#22222: Title of ticket 22222',
                },
            ],
        },
        ParentChild::Target => {
            Ticket => [
                {
                    Type    => 'Link',
                    Content => 'T:77777',
                    Title   => 'Ticket#77777: Ticket title',
                },
            ],
        },
    );

    %LinkOutputData = $BackendObject->TableCreateSimple(
        ObjectLinkListWithData => $ObjectLinkListRef,
    );

=cut

sub TableCreateSimple {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ObjectLinkListWithData} || ref $Param{ObjectLinkListWithData} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ObjectLinkListWithData!'
        );
        return;
    }

    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $TicketHook        = $ConfigObject->Get('Ticket::Hook');
    my $TicketHookDivider = $ConfigObject->Get('Ticket::HookDivider');

    my %LinkOutputData;
    for my $LinkType ( sort keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( sort keys %{$LinkTypeList} ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            my @ItemList;
            for my $TicketID ( sort { $a <=> $b } keys %{$DirectionList} ) {

                # extract ticket data
                my $Ticket = $DirectionList->{$TicketID};

                # set css
                my $CssClass;
                my @StatesToStrike = @{ $ConfigObject->Get('LinkObject::StrikeThroughLinkedTicketStateTypes') || [] };

                if ( first { $Ticket->{StateType} eq $_ } @StatesToStrike ) {
                    $CssClass = 'StrikeThrough';
                }

                # define item data
                my %Item = (
                    Type    => 'Link',
                    Content => 'T:' . $Ticket->{TicketNumber},
                    Title   => "$TicketHook$TicketHookDivider$Ticket->{TicketNumber}: $Ticket->{Title}",
                    Link    => $Self->{LayoutObject}->{Baselink}
                        . 'Action=AgentTicketZoom;TicketID='
                        . $TicketID,
                    CssClass => $CssClass,
                );

                push @ItemList, \%Item;
            }

            # add item list to link output data
            $LinkOutputData{ $LinkType . '::' . $Direction }->{Ticket} = \@ItemList;
        }
    }

    return %LinkOutputData;
}

=head2 ContentStringCreate()

return a output string

    my $String = $BackendObject->ContentStringCreate(
        ContentData => $HashRef,
    );

=cut

sub ContentStringCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ContentData} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ContentData!'
        );
        return;
    }

    return;
}

=head2 SelectableObjectList()

return an array hash with select-able objects

Return

    @SelectableObjectList = (
        {
            Key   => 'Ticket',
            Value => 'Ticket',
        },
    );

    @SelectableObjectList = $BackendObject->SelectableObjectList(
        Selected => $Identifier,  # (optional)
    );

=cut

sub SelectableObjectList {
    my ( $Self, %Param ) = @_;

    my $Selected;
    if ( $Param{Selected} && $Param{Selected} eq $Self->{ObjectData}->{Object} ) {
        $Selected = 1;
    }

    # object select list
    my @ObjectSelectList = (
        {
            Key      => $Self->{ObjectData}->{Object},
            Value    => $Self->{ObjectData}->{Realname},
            Selected => $Selected,
        },
    );

    return @ObjectSelectList;
}

=head2 SearchOptionList()

return an array hash with search options

Return

    @SearchOptionList = (
        {
            Key       => 'TicketNumber',
            Name      => 'Ticket#',
            InputStrg => $FormString,
            FormData  => '1234',
        },
        {
            Key       => 'Title',
            Name      => 'Title',
            InputStrg => $FormString,
            FormData  => 'BlaBla',
        },
    );

    @SearchOptionList = $BackendObject->SearchOptionList(
        SubObject => 'Bla',  # (optional)
    );

=cut

sub SearchOptionList {
    my ( $Self, %Param ) = @_;

    my $ParamHook = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Hook') || 'Ticket#';

    # search option list
    my @SearchOptionList = (
        {
            Key  => 'TicketNumber',
            Name => $ParamHook,
            Type => 'Text',
        },
        {
            Key  => 'TicketTitle',
            Name => Translatable('Title'),
            Type => 'Text',
        },
        {
            Key  => 'TicketFulltext',
            Name => Translatable('Fulltext'),
            Type => 'Text',
        },
        {
            Key  => 'StateIDs',
            Name => Translatable('State'),
            Type => 'List',
        },
        {
            Key  => 'PriorityIDs',
            Name => Translatable('Priority'),
            Type => 'List',
        },
    );

    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Type') ) {
        push @SearchOptionList,
            {
            Key  => 'TypeIDs',
            Name => Translatable('Type'),
            Type => 'List',
            };
    }

    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ArchiveSystem') ) {
        push @SearchOptionList,
            {
            Key  => 'ArchiveID',
            Name => Translatable('Archive search'),
            Type => 'List',
            };
    }

    # add formkey
    for my $Row (@SearchOptionList) {
        $Row->{FormKey} = 'SEARCH::' . $Row->{Key};
    }

    # add form data and input string
    ROW:
    for my $Row (@SearchOptionList) {

        # prepare text input fields
        if ( $Row->{Type} eq 'Text' ) {

            # get form data
            $Row->{FormData} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $Row->{FormKey} );

            # parse the input text block
            $Self->{LayoutObject}->Block(
                Name => 'InputText',
                Data => {
                    Key   => $Row->{FormKey},
                    Value => $Row->{FormData} || '',
                },
            );

            # add the input string
            $Row->{InputStrg} = $Self->{LayoutObject}->Output(
                TemplateFile => 'LinkObject',
            );

            next ROW;
        }

        # prepare list boxes
        if ( $Row->{Type} eq 'List' ) {

            # get form data
            my @FormData = $Kernel::OM->Get('Kernel::System::Web::Request')->GetArray( Param => $Row->{FormKey} );
            $Row->{FormData} = \@FormData;

            my $Multiple = 1;

            my %ListData;
            if ( $Row->{Key} eq 'StateIDs' ) {
                %ListData = $Kernel::OM->Get('Kernel::System::State')->StateList(
                    UserID => $Self->{UserID},
                );
            }
            elsif ( $Row->{Key} eq 'PriorityIDs' ) {
                %ListData = $Kernel::OM->Get('Kernel::System::Priority')->PriorityList(
                    UserID => $Self->{UserID},
                );
            }
            elsif ( $Row->{Key} eq 'TypeIDs' ) {
                %ListData = $Kernel::OM->Get('Kernel::System::Type')->TypeList(
                    UserID => $Self->{UserID},
                );
            }
            elsif ( $Row->{Key} eq 'ArchiveID' ) {
                %ListData = (
                    ArchivedTickets    => Translatable('Archived tickets'),
                    NotArchivedTickets => Translatable('Unarchived tickets'),
                    AllTickets         => Translatable('All tickets'),
                );
                if ( !scalar @{ $Row->{FormData} } ) {
                    $Row->{FormData} = ['NotArchivedTickets'];
                }
                $Multiple = 0;
            }

            # add the input string
            $Row->{InputStrg} = $Self->{LayoutObject}->BuildSelection(
                Data       => \%ListData,
                Name       => $Row->{FormKey},
                SelectedID => $Row->{FormData},
                Size       => 3,
                Multiple   => $Multiple,
                Class      => 'Modernize',
            );

            next ROW;
        }

        if ( $Row->{Type} eq 'Checkbox' ) {

            # get form data
            $Row->{FormData} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $Row->{FormKey} );

            # parse the input text block
            $Self->{LayoutObject}->Block(
                Name => 'Checkbox',
                Data => {
                    Name    => $Row->{FormKey},
                    Title   => $Row->{FormKey},
                    Content => $Row->{FormKey},
                    Checked => $Row->{FormData} || '',
                },
            );

            # add the input string
            $Row->{InputStrg} = $Self->{LayoutObject}->Output(
                TemplateFile => 'LinkObject',
            );

            next ROW;
        }
    }

    return @SearchOptionList;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
