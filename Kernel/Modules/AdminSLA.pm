# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSLA;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $SLAObject    = $Kernel::OM->Get('Kernel::System::SLA');
    my %Error        = ();

    # ------------------------------------------------------------ #
    # sla edit
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'SLAEdit' ) {

        # header
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # html output
        $Output .= $Self->_MaskNew(
            %Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # sla save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SLASave' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get params
        my %GetParam;
        for my $Param (
            qw(SLAID Name Calendar FirstResponseTime FirstResponseNotify SolutionTime SolutionNotify UpdateTime UpdateNotify ValidID Comment)
            )
        {
            $GetParam{$Param} = $ParamObject->GetParam( Param => $Param ) || '';
        }

        # check needed stuff
        %Error = ();
        if ( !$GetParam{Name} ) {
            $Error{'NameInvalid'} = 'ServerError';
        }

        my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

        # if no errors occurred
        if ( !%Error ) {

            # get service ids
            my @ServiceIDs = $ParamObject->GetArray( Param => 'ServiceIDs' );
            $GetParam{ServiceIDs} = \@ServiceIDs;

            # save to database
            if ( !$GetParam{SLAID} ) {

                # add a new sla
                $GetParam{SLAID} = $SLAObject->SLAAdd(
                    %GetParam,
                    UserID => $Self->{UserID},
                );
                if ( !$GetParam{SLAID} ) {
                    $Error{Message} = $LogObject->GetLogEntry(
                        Type => 'Error',
                        What => 'Message',
                    );
                }
            }
            else {

                # update the sla
                my $Success = $SLAObject->SLAUpdate(
                    %GetParam,
                    UserID => $Self->{UserID},
                );
                if ( !$Success ) {
                    $Error{Message} = $LogObject->GetLogEntry(
                        Type => 'Error',
                        What => 'Message',
                    );
                }
            }

            if ( !%Error ) {

                # update preferences
                my %SLAData = $SLAObject->SLAGet(
                    SLAID  => $GetParam{SLAID},
                    UserID => $Self->{UserID},
                );
                my %Preferences = ();
                if ( $ConfigObject->Get('SLAPreferences') ) {
                    %Preferences = %{ $ConfigObject->Get('SLAPreferences') };
                }
                for my $Item ( sort keys %Preferences ) {
                    my $Module = $Preferences{$Item}->{Module}
                        || 'Kernel::Output::HTML::SLAPreferences::Generic';

                    # load module
                    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
                        return $LayoutObject->FatalError();
                    }

                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Item},
                        Debug      => $Self->{Debug},
                    );
                    my $Note;
                    my @Params = $Object->Param( SLAData => \%SLAData );
                    if (@Params) {
                        my %GetParam = ();
                        for my $ParamItem (@Params) {
                            my @Array = $ParamObject->GetArray( Param => $ParamItem->{Name} );
                            $GetParam{ $ParamItem->{Name} } = \@Array;
                        }
                        if (
                            !$Object->Run(
                                GetParam => \%GetParam,
                                SLAData  => \%SLAData
                            )
                            )
                        {
                            $Note .= $LayoutObject->Notify( Info => $Object->Error() );
                        }
                    }
                }

                return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
            }

        }

        # header
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Error{Message}
            ? $LayoutObject->Notify(
            Priority => 'Error',
            Info     => $Error{Message},
            )
            : '';

        # html output
        $Output .= $Self->_MaskNew(
            %Param,
            %GetParam,
            %Error,
        );

        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # sla overview
    # ------------------------------------------------------------ #
    else {

        # output header
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # check if service is enabled to use it here
        if ( !$ConfigObject->Get('Ticket::Service') ) {
            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
                Data     => $LayoutObject->{LanguageObject}->Translate( "Please activate %s first!", "Service" ),
                Link =>
                    $LayoutObject->{Baselink}
                    . 'Action=AdminSysConfig;Subaction=Edit;SysConfigGroup=Ticket;SysConfigSubGroup=Core::Ticket#Ticket::Service',
            );
        }

        # output overview
        $LayoutObject->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );

        $LayoutObject->Block( Name => 'ActionList' );
        $LayoutObject->Block( Name => 'ActionAdd' );

        # output overview result
        $LayoutObject->Block(
            Name => 'OverviewList',
            Data => {
                %Param,
            },
        );

        # get service list
        my %ServiceList = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
            Valid        => 0,
            KeepChildren => 1,
            UserID       => $Self->{UserID},
        );

        # get valid list
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

        # get sla list
        my %SLAList = $SLAObject->SLAList(
            Valid  => 0,
            UserID => $Self->{UserID},
        );

        # if there are any SLA's defined, they are shown
        if (%SLAList) {
            SLAID:
            for my $SLAID ( sort { lc $SLAList{$a} cmp lc $SLAList{$b} } keys %SLAList ) {

                # get the sla data
                my %SLAData = $SLAObject->SLAGet(
                    SLAID  => $SLAID,
                    UserID => $Self->{UserID},
                );

                # build the service list
                my @ServiceList;
                for my $ServiceID (
                    sort { lc $ServiceList{$a} cmp lc $ServiceList{$b} }
                    @{ $SLAData{ServiceIDs} }
                    )
                {
                    push @ServiceList, $ServiceList{$ServiceID} || '-';
                }

                # output overview list row
                $LayoutObject->Block(
                    Name => 'OverviewListRow',
                    Data => {
                        %SLAData,
                        Service => $ServiceList[0] || '-',
                        Valid => $ValidList{ $SLAData{ValidID} },
                    },
                );

                next SLAID if scalar @ServiceList <= 1;

                # remove the first service id
                shift @ServiceList;

                for my $ServiceName (@ServiceList) {

                    # output overview list row
                    $LayoutObject->Block(
                        Name => 'OverviewListRow',
                        Data => {
                            Service => $ServiceName,
                        },
                    );
                }
            }
        }

        # otherwise a no data found msg is displayed
        else {
            $LayoutObject->Block(
                Name => 'NoDataFoundMsg',
                Data => {},
            );
        }

        # generate output
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSLA',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }
}

sub _MaskNew {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get params
    my %SLAData;
    $SLAData{SLAID} = $ParamObject->GetParam( Param => 'SLAID' ) || '';

    if ( $SLAData{SLAID} ) {

        # get sla data
        %SLAData = $Kernel::OM->Get('Kernel::System::SLA')->SLAGet(
            SLAID  => $SLAData{SLAID},
            UserID => $Self->{UserID},
        );
    }
    else {
        $SLAData{ServiceID} = $ParamObject->GetParam( Param => 'ServiceID' );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get list type
    my $ListType = $ConfigObject->Get('Ticket::Frontend::ListType');

    # get service list
    my %ServiceList = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
        Valid        => 1,
        KeepChildren => 1,
        UserID       => $Self->{UserID},
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # generate ServiceOptionStrg
    $Param{ServiceOptionStrg} = $LayoutObject->BuildSelection(
        Data        => \%ServiceList,
        Name        => 'ServiceIDs',
        SelectedID  => $SLAData{ServiceIDs} || [],
        Multiple    => 1,
        Size        => 5,
        Translation => 0,
        TreeView    => ( $ListType eq 'tree' ) ? 1 : 0,
        Max         => 200,
        Class       => 'Modernize',
    );

    # generate CalendarOptionStrg
    my %CalendarList;
    for my $CalendarNumber ( '', 1 .. 50 ) {
        if ( $ConfigObject->Get("TimeVacationDays::Calendar$CalendarNumber") ) {
            $CalendarList{$CalendarNumber} = "Calendar $CalendarNumber - "
                . $ConfigObject->Get( "TimeZone::Calendar" . $CalendarNumber . "Name" );
        }
    }
    $SLAData{CalendarOptionStrg} = $LayoutObject->BuildSelection(
        Data         => \%CalendarList,
        Name         => 'Calendar',
        SelectedID   => $Param{Calendar} || $SLAData{Calendar},
        Translation  => 0,
        PossibleNone => 1,
        Class        => 'Modernize',
    );
    my %NotifyLevelList = (
        10 => '10%',
        20 => '20%',
        30 => '30%',
        40 => '40%',
        50 => '50%',
        60 => '60%',
        70 => '70%',
        80 => '80%',
        90 => '90%',
    );
    $SLAData{FirstResponseNotifyOptionStrg} = $LayoutObject->BuildSelection(
        Data         => \%NotifyLevelList,
        Name         => 'FirstResponseNotify',
        SelectedID   => $Param{FirstResponseNotify} || $SLAData{FirstResponseNotify},
        Translation  => 0,
        PossibleNone => 1,
    );
    $SLAData{UpdateNotifyOptionStrg} = $LayoutObject->BuildSelection(
        Data         => \%NotifyLevelList,
        Name         => 'UpdateNotify',
        SelectedID   => $Param{UpdateNotify} || $SLAData{UpdateNotify},
        Translation  => 0,
        PossibleNone => 1,
    );
    $SLAData{SolutionNotifyOptionStrg} = $LayoutObject->BuildSelection(
        Data         => \%NotifyLevelList,
        Name         => 'SolutionNotify',
        SelectedID   => $Param{SolutionNotify} || $SLAData{SolutionNotify},
        Translation  => 0,
        PossibleNone => 1,
    );

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $SLAData{ValidOptionStrg} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $SLAData{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize',
    );

    # output sla edit
    $LayoutObject->Block(
        Name => 'Overview',
        Data => {
            %Param
        },
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    $LayoutObject->Block(
        Name => 'SLAEdit',
        Data => {
            %Param,
            %SLAData,
        },
    );

    # shows header
    if ( $SLAData{SLAID} ) {
        $LayoutObject->Block( Name => 'HeaderEdit' );
    }
    else {
        $LayoutObject->Block( Name => 'HeaderAdd' );
    }

    # show each preferences setting
    my %Preferences = ();
    if ( $ConfigObject->Get('SLAPreferences') ) {
        %Preferences = %{ $ConfigObject->Get('SLAPreferences') };
    }
    for my $Item ( sort keys %Preferences ) {
        my $Module = $Preferences{$Item}->{Module}
            || 'Kernel::Output::HTML::SLAPreferences::Generic';

        # load module
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
            return $LayoutObject->FatalError();
        }
        my $Object = $Module->new(
            %{$Self},
            ConfigItem => $Preferences{$Item},
            Debug      => $Self->{Debug},
        );
        my @Params = $Object->Param( SLAData => \%SLAData );
        if (@Params) {
            for my $ParamItem (@Params) {
                $LayoutObject->Block(
                    Name => 'SLAItem',
                    Data => { %Param, },
                );
                if (
                    ref( $ParamItem->{Data} ) eq 'HASH'
                    || ref( $Preferences{$Item}->{Data} ) eq 'HASH'
                    )
                {
                    my %BuildSelectionParams = (
                        %{ $Preferences{$Item} },
                        %{$ParamItem},
                    );
                    $BuildSelectionParams{Class} = join( ' ', $BuildSelectionParams{Class} // '', 'Modernize' );

                    $ParamItem->{'Option'} = $LayoutObject->BuildSelection(
                        %BuildSelectionParams,
                    );
                }
                $LayoutObject->Block(
                    Name => $ParamItem->{Block} || $Preferences{$Item}->{Block} || 'Option',
                    Data => {
                        %{ $Preferences{$Item} },
                        %{$ParamItem},
                    },
                );
            }
        }
    }

    # get output back
    return $LayoutObject->Output(
        TemplateFile => 'AdminSLA',
        Data         => \%Param
    );
}

1;
