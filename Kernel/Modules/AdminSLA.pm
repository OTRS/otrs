# --
# Kernel/Modules/AdminSLA.pm - admin frontend to manage slas
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminSLA.pm,v 1.18 2008-11-16 18:18:14 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminSLA;

use strict;
use warnings;

use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.18 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{ServiceObject} = Kernel::System::Service->new(%Param);
    $Self->{SLAObject}     = Kernel::System::SLA->new(%Param);
    $Self->{ValidObject}   = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # sla edit
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'SLAEdit' ) {

        # get params
        my %SLAData;
        $SLAData{SLAID} = $Self->{ParamObject}->GetParam( Param => 'SLAID' );

        if ( $SLAData{SLAID} ) {

            # get sla data
            %SLAData = $Self->{SLAObject}->SLAGet(
                SLAID  => $SLAData{SLAID},
                UserID => $Self->{UserID},
            );
        }
        else {
            $SLAData{ServiceID} = $Self->{ParamObject}->GetParam( Param => 'ServiceID' );
        }

        # get service list
        my %ServiceList = $Self->{ServiceObject}->ServiceList(
            Valid  => 0,
            UserID => $Self->{UserID},
        );

        # generate ServiceOptionStrg
        my $TreeView = 0;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $TreeView = 1;
        }
        $Param{ServiceOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%ServiceList,
            Name        => 'ServiceIDs',
            SelectedID  => $SLAData{ServiceIDs} || [],
            Multiple    => 1,
            Size        => 5,
            TreeView    => $TreeView,
            Sort        => 'TreeView',
            Translation => 0,
            Max         => 200,
        );

        # generate CalendarOptionStrg
        my %CalendarList;
        for ( '', 1 .. 50 ) {
            if ( $Self->{ConfigObject}->Get("TimeVacationDays::Calendar$_") ) {
                $CalendarList{$_} = "Calendar $_ - "
                    . $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $_ . "Name" );
            }
        }
        $SLAData{CalendarOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%CalendarList,
            Name         => 'Calendar',
            SelectedID   => $SLAData{Calendar},
            PossibleNone => 1,
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
        $SLAData{FirstResponseNotifyOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%NotifyLevelList,
            Name         => 'FirstResponseNotify',
            SelectedID   => $SLAData{FirstResponseNotify},
            PossibleNone => 1,
        );
        $SLAData{UpdateNotifyOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%NotifyLevelList,
            Name         => 'UpdateNotify',
            SelectedID   => $SLAData{UpdateNotify},
            PossibleNone => 1,
        );
        $SLAData{SolutionNotifyOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%NotifyLevelList,
            Name         => 'SolutionNotify',
            SelectedID   => $SLAData{SolutionNotify},
            PossibleNone => 1,
        );

        # generate ValidOptionStrg
        my %ValidList = $Self->{ValidObject}->ValidList();
        $SLAData{ValidOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%ValidList,
            Name       => 'ValidID',
            SelectedID => $SLAData{ValidID} || 1,
        );

        # output sla edit
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'SLAEdit',
            Data => {
                %Param,
                %SLAData,
            },
        );

        # show each preferences setting
        my %Preferences = ();
        if ( $Self->{ConfigObject}->Get('SLAPreferences') ) {
            %Preferences = %{ $Self->{ConfigObject}->Get('SLAPreferences') };
        }
        for my $Item ( sort keys %Preferences ) {
            my $Module = $Preferences{$Item}->{Module}
                || 'Kernel::Output::HTML::SLAPreferencesGeneric';

            # load module
            if ( !$Self->{MainObject}->Require($Module) ) {
                return $Self->{LayoutObject}->FatalError();
            }
            my $Object = $Module->new(
                %{$Self},
                ConfigItem => $Preferences{$Item},
                Debug      => $Self->{Debug},
            );
            my @Params = $Object->Param( SLAData => \%SLAData );
            if (@Params) {
                for my $ParamItem (@Params) {
                    $Self->{LayoutObject}->Block(
                        Name => 'SLAItem',
                        Data => { %Param, },
                    );
                    if (
                        ref( $ParamItem->{Data} ) eq 'HASH'
                        || ref( $Preferences{$Item}->{Data} ) eq 'HASH'
                        )
                    {
                        $ParamItem->{'Option'} = $Self->{LayoutObject}->OptionStrgHashRef(
                            %{ $Preferences{$Item} },
                            %{$ParamItem},
                        );
                    }
                    $Self->{LayoutObject}->Block(
                        Name => $ParamItem->{Block} || $Preferences{$Item}->{Block} || 'Option',
                        Data => {
                            %{ $Preferences{$Item} },
                            %{$ParamItem},
                        },
                    );
                }
            }
        }

        # output overview
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSLA',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # sla save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SLASave' ) {

        # get params
        my %GetParam;
        for my $Param (
            qw(SLAID Name Calendar FirstResponseTime FirstResponseNotify SolutionTime SolutionNotify UpdateTime UpdateNotify ValidID Comment)
            )
        {
            $GetParam{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
        }

        # get service ids
        my @ServiceIDs = $Self->{ParamObject}->GetArray( Param => 'ServiceIDs' );
        $GetParam{ServiceIDs} = \@ServiceIDs;

        # save to database
        if ( !$GetParam{SLAID} ) {

            # add a new sla
            $GetParam{SLAID} = $Self->{SLAObject}->SLAAdd(
                %GetParam,
                UserID => $Self->{UserID},
            );
            if ( !$GetParam{SLAID} ) {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
        else {

            # update the sla
            my $Success = $Self->{SLAObject}->SLAUpdate(
                %GetParam,
                UserID => $Self->{UserID},
            );
            if ( !$Success ) {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }

        # update preferences
        my %SLAData = $Self->{SLAObject}->SLAGet(
            SLAID  => $GetParam{SLAID},
            UserID => $Self->{UserID},
        );
        my %Preferences = ();
        if ( $Self->{ConfigObject}->Get('SLAPreferences') ) {
            %Preferences = %{ $Self->{ConfigObject}->Get('SLAPreferences') };
        }
        for my $Item ( sort keys %Preferences ) {
            my $Module = $Preferences{$Item}->{Module}
                || 'Kernel::Output::HTML::SLAPreferencesGeneric';

            # load module
            if ( !$Self->{MainObject}->Require($Module) ) {
                return $Self->{LayoutObject}->FatalError();
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
                    my @Array = $Self->{ParamObject}->GetArray( Param => $ParamItem->{Name} );
                    $GetParam{ $ParamItem->{Name} } = \@Array;
                }
                if ( !$Object->Run( GetParam => \%GetParam, SLAData => \%SLAData ) ) {
                    $Note .= $Self->{LayoutObject}->Notify( Info => $Object->Error() );
                }
            }
        }

        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # sla overview
    # ------------------------------------------------------------ #
    else {

        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # check if service is enabled to use it here
        if ( !$Self->{ConfigObject}->Get('Ticket::Service') ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data     => '$Text{"You need to activate %s first to use it!", "Service"}',
                Link =>
                    '$Env{"Baselink"}Action=AdminSysConfig&Subaction=Edit&SysConfigGroup=Ticket&SysConfigSubGroup=Core::Ticket#Ticket::Service"',
            );
        }

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );

        # output overview result
        $Self->{LayoutObject}->Block(
            Name => 'OverviewList',
            Data => {
                %Param,
            },
        );

        # get service list
        my %ServiceList = $Self->{ServiceObject}->ServiceList(
            Valid  => 0,
            UserID => $Self->{UserID},
        );

        # get valid list
        my %ValidList = $Self->{ValidObject}->ValidList();

        # get sla list
        my %SLAList = $Self->{SLAObject}->SLAList(
            Valid  => 0,
            UserID => $Self->{UserID},
        );

        my $CssClass = '';
        SLAID:
        for my $SLAID ( sort { lc $SLAList{$a} cmp lc $SLAList{$b} } keys %SLAList ) {

            # set output object
            $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';

            # get the sla data
            my %SLAData = $Self->{SLAObject}->SLAGet(
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
            $Self->{LayoutObject}->Block(
                Name => 'OverviewListRow',
                Data => {
                    %SLAData,
                    Service => $ServiceList[0] || '-',
                    CssClass => $CssClass,
                    Valid    => $ValidList{ $SLAData{ValidID} },
                },
            );

            next SLAID if scalar @ServiceList <= 1;

            # remove the first service id
            shift @ServiceList;

            for my $ServiceName (@ServiceList) {

                # output overview list row
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewListRow',
                    Data => {
                        Service  => $ServiceName,
                        CssClass => $CssClass,
                    },
                );
            }
        }

        # generate output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSLA',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

1;
