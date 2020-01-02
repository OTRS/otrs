# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::LinkObject::Appointment;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);
use Kernel::Output::HTML::Layout;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Calendar',
    'Kernel::System::Log',
    'Kernel::System::Web::Request',
    'Kernel::System::JSON',
    'Kernel::System::User',
);

=head1 NAME

Kernel::Output::HTML::LinkObject::Appointment - layout backend module

=head1 DESCRIPTION

All layout functions of link object (appointment).

=head2 new()

create an object

    $BackendObject = Kernel::Output::HTML::LinkObject::Appointment->new(
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

    # create our own LayoutObject instance to avoid block data collisions with the main page
    $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new( %{$Self} );

    # define needed variables
    $Self->{ObjectData} = {
        Object     => 'Appointment',
        Realname   => 'Appointment',
        ObjectName => 'SourceObjectID',
    };

    return $Self;
}

=head2 TableCreateComplex()

return an array with the block data

Return

    %BlockData = (
        {
            ObjectName => 'SourceObjectID',
            ObjectID   => 1,
            Object     => 'Appointment',
            Blockname  => 'Appointment',
            Headline   => [
                {
                    Content => 'Title',
                },
                {
                    Content => 'Description',
                    Width   => 200,
                },
                {
                    Content => 'Start Time',
                    Width   => 150,
                },
                {
                    Content => 'End Time',
                    Width   => 150,
                },
            ],
            ItemList => [
                [
                    {
                        Type      => 'Link',
                        Key       => $AppointmentID,
                        Content   => 'Appointment title',
                        MaxLength => 70,
                    },
                    {
                        Type      => 'Text',
                        Content   => 'Appointment description',
                        MaxLength => 100,
                    },
                    {
                        Type    => 'TimeLong',
                        Content => '2016-01-01 12:00:00',
                    },
                    {
                        Type    => 'TimeLong',
                        Content => '2016-01-01 13:00:00',
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

            for my $AppointmentID ( sort keys %{$DirectionList} ) {

                $LinkList{$AppointmentID}->{Data} = $DirectionList->{$AppointmentID};
            }
        }
    }

    my $ComplexTableData = $ConfigObject->Get("LinkObject::ComplexTable");
    my $DefaultColumns;
    if (
        $ComplexTableData
        && IsHashRefWithData($ComplexTableData)
        && $ComplexTableData->{Appointment}
        && IsHashRefWithData( $ComplexTableData->{Appointment} )
        )
    {
        $DefaultColumns = $ComplexTableData->{"Appointment"}->{"DefaultColumns"};
    }

    my @TimeLongTypes = (
        "Created",
        "Changed",
        "StartTime",
        "EndTime",
        "NotificationTime",
    );

    # define the block data
    my @Headline = (
        {
            Content => 'Title',
        },
    );

    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # load user preferences
    my %Preferences = $UserObject->GetPreferences(
        UserID => $Self->{UserID},
    );

    if ( !$DefaultColumns || !IsHashRefWithData($DefaultColumns) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Missing configuration for LinkObject::ComplexTable###Appointment!',
        );
        return;
    }

    # Get default column priority from SysConfig
    # Each column in table (Title, StartTime, EndTime,...) has defined Priority in SysConfig.
    # System use this priority to sort columns, if user doesn't have own settings.
    my %SortOrder;

    if (
        $ComplexTableData->{"Appointment"}->{"Priority"}
        && IsHashRefWithData( $ComplexTableData->{"Appointment"}->{"Priority"} )
        )
    {
        %SortOrder = %{ $ComplexTableData->{"Appointment"}->{"Priority"} };
    }

    my %UserColumns = %{$DefaultColumns};

    if ( $Preferences{'LinkObject::ComplexTable-Appointment'} ) {
        my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

        my $ColumnsEnabled = $JSONObject->Decode(
            Data => $Preferences{'LinkObject::ComplexTable-Appointment'},
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
        if ( $Column eq 'CalendarName' ) {
            $ColumnTranslate = Translatable('Calendar name');
        }
        elsif ( $Column eq 'StartTime' ) {
            $ColumnTranslate = Translatable('Start date');
        }
        elsif ( $Column eq 'EndTime' ) {
            $ColumnTranslate = Translatable('End date');
        }
        elsif ( $Column eq 'NotificationTime' ) {
            $ColumnTranslate = Translatable('Notification');
        }

        push @AllColumns, {
            ColumnName      => $Column,
            ColumnTranslate => $ColumnTranslate,
        };

        next COLUMN if $Column eq 'Title';    # Always present, already added.

        # if enabled by default
        if ( $UserColumns{$Column} == 2 ) {

            # appointment fields
            my $ColumnName = $ColumnTranslate;

            push @Headline, {
                Content => $ColumnName,
            };
        }
    }

    # create the item list (table content)
    my @ItemList;

    APPOINTMENTID:
    for my $AppointmentID (
        sort { $LinkList{$a}{Data}->{AppointmentID} <=> $LinkList{$b}{Data}->{AppointmentID} }
        keys %LinkList
        )
    {
        next APPOINTMENTID if !$AppointmentID;

        # extract appointment and calendar data
        my $Appointment = $LinkList{$AppointmentID}{Data};
        my %Calendar    = $Kernel::OM->Get('Kernel::System::Calendar')->CalendarGet(
            CalendarID => $Appointment->{CalendarID},
        );

        # Title be present (since it contains master link to the appointment)
        my @ItemColumns = (
            {
                Type    => 'Link',
                Key     => $AppointmentID,
                Content => $Appointment->{Title},
                Link    => $Self->{LayoutObject}->{Baselink}
                    . 'Action=AgentAppointmentCalendarOverview;AppointmentID='
                    . $AppointmentID,
                MaxLength => 70,
            },
        );

        # Sort
        COLUMN:
        for my $Column ( sort { $SortOrder{$a} <=> $SortOrder{$b} } keys %UserColumns ) {

            next COLUMN if $Column eq 'Title';    # Always present, already added.

            # if enabled by default
            if ( $UserColumns{$Column} == 2 ) {

                my %Hash;
                if ( grep { $_ eq $Column } @TimeLongTypes ) {
                    $Hash{'Type'} = 'TimeLong';
                }
                else {
                    $Hash{'Type'} = 'Text';
                }

                if ( $Column eq 'NotificationTime' ) {
                    $Hash{'Content'} = $Appointment->{NotificationDate};
                }
                elsif ( $Column eq 'Created' ) {
                    $Hash{'Content'} = $Appointment->{CreateTime};
                }
                elsif ( $Column eq 'Changed' ) {
                    $Hash{'Content'} = $Appointment->{ChangeTime};
                }
                elsif ( $Column eq 'CalendarName' ) {
                    $Hash{'Content'} = $Calendar{CalendarName};
                }
                else {
                    $Hash{'Content'} = $Appointment->{$Column};
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
            Appointment => [
                {
                    Type    => 'Link',
                    Content => 'A:1',
                    Title   => 'Title of appointment',
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
            Message  => 'Need ObjectLinkListWithData!',
        );
        return;
    }

    my %LinkOutputData;
    for my $LinkType ( sort keys %{ $Param{ObjectLinkListWithData} } ) {

        # extract link type List
        my $LinkTypeList = $Param{ObjectLinkListWithData}->{$LinkType};

        for my $Direction ( sort keys %{$LinkTypeList} ) {

            # extract direction list
            my $DirectionList = $Param{ObjectLinkListWithData}->{$LinkType}->{$Direction};

            my @ItemList;
            for my $AppointmentID (
                sort {
                    lc $DirectionList->{$a}->{NameShort} cmp lc $DirectionList->{$b}->{NameShort}
                } keys %{$DirectionList}
                )
            {

                # extract appointment data
                my $Appointment = $DirectionList->{$AppointmentID};

                # define item data
                my %Item = (
                    Type    => 'Link',
                    Content => "A:$AppointmentID",
                    Title   => Translatable('Appointment'),
                    Link    => $Self->{LayoutObject}->{Baselink}
                        . 'Action=AgentAppointmentCalendarOverview;AppointmentID='
                        . $AppointmentID,
                    MaxLength => 20,
                );

                push @ItemList, \%Item;
            }

            # add item list to link output data
            $LinkOutputData{ $LinkType . '::' . $Direction }->{Appointment} = \@ItemList;
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

Return an array hash with select-able objects.

Returns:

    @SelectableObjectList = (
        {
            Key   => 'Appointment',
            Value => 'Appointment',
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
            Key       => 'AppointmentTitle',
            Name      => 'Title',
            InputStrg => $FormString,
            FormData  => '1234',
        },
        {
            Key       => 'AppointmentDescription',
            Name      => 'Description',
            InputStrg => $FormString,
            FormData  => 'BlaBla',
        },
        {
            Key       => 'AppointmentCalendarID',
            Name      => 'Calendar',
            InputStrg => $FormString,
            FormData  => 'Calendar1',
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
            Key  => 'AppointmentTitle',
            Name => Translatable('Title'),
            Type => 'Text',
        },
        {
            Key  => 'AppointmentDescription',
            Name => Translatable('Description'),
            Type => 'Text',
        },
        {
            Key  => 'AppointmentCalendarID',
            Name => Translatable('Calendar'),
            Type => 'List',
        },
    );

    # add formkey
    for my $Row (@SearchOptionList) {
        $Row->{FormKey} = 'SEARCH::' . $Row->{Key};
    }

    # add form data and input string
    ROW:
    for my $Row (@SearchOptionList) {

        next ROW if $Row->{Type} eq 'Hidden';

        # Prepare text input fields.
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
        }

        # Prepare drop down lists.
        elsif ( $Row->{Type} eq 'List' ) {

            # get form data
            my @FormData = $Kernel::OM->Get('Kernel::System::Web::Request')->GetArray( Param => $Row->{FormKey} );
            $Row->{FormData} = \@FormData;

            if ( $Row->{Key} eq 'AppointmentCalendarID' ) {
                my @CalendarList = $Kernel::OM->Get('Kernel::System::Calendar')->CalendarList(
                    UserID     => $Self->{UserID},
                    Permission => 'rw',
                    ValidID    => 1,
                );

                my @CalendarData = map {
                    {
                        Key   => $_->{CalendarID},
                        Value => $_->{CalendarName},
                    }
                } sort { $a->{CalendarName} cmp $b->{CalendarName} } @CalendarList;

                $Row->{InputStrg} = $Self->{LayoutObject}->BuildSelection(
                    Data       => \@CalendarData,
                    Name       => $Row->{FormKey},
                    SelectedID => $Row->{FormData},
                    Class      => 'Modernize',
                    Multiple   => 1,
                );
            }
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
