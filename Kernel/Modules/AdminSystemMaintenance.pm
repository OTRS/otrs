# --
# Kernel/Modules/AdminSystemMaintenance.pm - to control all system maintenance actions
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSystemMaintenance;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::SystemMaintenance;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(ParamObject DBObject LayoutObject LogObject ConfigObject TimeObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    # create additional objects
    $Self->{ValidObject}             = Kernel::System::Valid->new(%Param);
    $Self->{SystemMaintenanceObject} = Kernel::System::SystemMaintenance->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $SystemMaintenanceID = $Self->{ParamObject}->GetParam( Param => 'SystemMaintenanceID' ) || '';
    my $WantSessionID       = $Self->{ParamObject}->GetParam( Param => 'WantSessionID' )       || '';

    my $SessionVisibility = 'Collapsed';

    # ------------------------------------------------------------ #
    # kill session id
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Kill' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        $Self->{SessionObject}->RemoveSessionID( SessionID => $WantSessionID );
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=AdminSystemMaintenance;Subaction=SystemMaintenanceEdit;SystemMaintenanceID=$SystemMaintenanceID;Kill=1"
        );
    }

    # ------------------------------------------------------------ #
    # kill all session ids
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'KillAll' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my @Sessions = $Self->{SessionObject}->GetAllSessionIDs();
        SESSIONS:
        for my $Session (@Sessions) {
            next SESSIONS if $Session eq $WantSessionID;
            $Self->{SessionObject}->RemoveSessionID( SessionID => $Session );
        }

        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=AdminSystemMaintenance;Subaction=SystemMaintenanceEdit;SystemMaintenanceID=$SystemMaintenanceID;KillAll=1"
        );
    }

    # ------------------------------------------------------------ #
    # SystemMaintenanceNew
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SystemMaintenanceNew' ) {

        return $Self->_ShowEdit(
            %Param,
            Action => 'New',
        );
    }

    # ------------------------------------------------------------ #
    # SystemMaintenanceNewAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SystemMaintenanceNewAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # check required parameters
        my %Error;
        my @NotifyData;

        # get SystemMaintenance parameters from web browser
        my $SystemMaintenanceData = $Self->_GetParams(
            Error => \%Error,
        );

        # a StartDate should always be defined before StopDate
        if (
            (
                defined $SystemMaintenanceData->{StartDate}
                && defined $SystemMaintenanceData->{StopDate}
            )
            && $SystemMaintenanceData->{StartDate} > $SystemMaintenanceData->{StopDate}
            )
        {

            # set server error
            $Error{StartDateServerError} = 'ServerError';

            # add notification
            push @NotifyData, {
                Priority => 'Error',
                Info     => "Start date shouldn't be defined after Stop date!",
            };
        }

        if ( !$SystemMaintenanceData->{Comment} ) {

            # add server error class
            $Error{CommentServerError} = 'ServerError';

        }

        if ( !$SystemMaintenanceData->{ValidID} ) {

            # add server error class
            $Error{ValidIDServerError} = 'ServerError';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {

            return $Self->_ShowEdit(
                %Error,
                %Param,
                NotifyData            => \@NotifyData,
                SystemMaintenanceData => $SystemMaintenanceData,
                Action                => 'New',
            );
        }

        my $SystemMaintenanceID = $Self->{SystemMaintenanceObject}->SystemMaintenanceAdd(
            StartDate        => $SystemMaintenanceData->{StartDate},
            StopDate         => $SystemMaintenanceData->{StopDate},
            Comment          => $SystemMaintenanceData->{Comment},
            LoginMessage     => $SystemMaintenanceData->{LoginMessage},
            ShowLoginMessage => $SystemMaintenanceData->{ShowLoginMessage},
            NotifyMessage    => $SystemMaintenanceData->{NotifyMessage},
            ValidID          => $SystemMaintenanceData->{ValidID},
            UserID           => $Self->{UserID},
        );

        # show error if can't create
        if ( !$SystemMaintenanceID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error creating the SystemMaintenance",
            );
        }

        # redirect to edit screen
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=SystemMaintenanceEdit;SystemMaintenanceID=$SystemMaintenanceID;Saved=1"
        );
    }

    # ------------------------------------------------------------ #
    # Edit View
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SystemMaintenanceEdit' ) {

        # initialize notify container
        my @NotifyData;

        # check for SystemMaintenanceID
        if ( !$SystemMaintenanceID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need SystemMaintenanceID!",
            );
        }

        # get system maintenance data
        my $SystemMaintenanceData = $Self->{SystemMaintenanceObject}->SystemMaintenanceGet(
            ID     => $SystemMaintenanceID,
            UserID => $Self->{UserID},
        );

        # include time stamps on the correct key
        for my $Key (qw(StartDate StopDate)) {

            # try to convert SystemTime to TimeStamp
            $SystemMaintenanceData->{ $Key . 'TimeStamp' } = $Self->{TimeObject}->SystemTime2TimeStamp(
                SystemTime => $SystemMaintenanceData->{$Key},
            );
        }

        # check for valid system maintenance data
        if ( !IsHashRefWithData($SystemMaintenanceData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Could not get data for SystemMaintenanceID $SystemMaintenanceID",
            );
        }

        if ( $Self->{ParamObject}->GetParam( Param => 'Saved' ) ) {

            # add notification
            push @NotifyData, {
                Priority => 'Notice',
                Info     => "System Maintenance was saved successfully!",
            };
        }

        if ( $Self->{ParamObject}->GetParam( Param => 'Kill' ) ) {

            # add notification
            push @NotifyData, {
                Priority => 'Notice',
                Info     => 'Session has been killed!',
            };

            # set class for expanding sessions widget
            $SessionVisibility = 'Expanded';
        }

        if ( $Self->{ParamObject}->GetParam( Param => 'KillAll' ) ) {

            # add notification
            push @NotifyData, {
                Priority => 'Notice',
                Info     => 'All sessions has been killed, exept the current one!',
            };

            # set class for expanding sessions widget
            $SessionVisibility = 'Expanded';
        }

        return $Self->_ShowEdit(
            %Param,
            SystemMaintenanceID   => $SystemMaintenanceID,
            SystemMaintenanceData => $SystemMaintenanceData,
            NotifyData            => \@NotifyData,
            SessionVisibility     => $SessionVisibility,
            Action                => 'Edit',
        );

    }

    # ------------------------------------------------------------ #
    # System Maintenance edit action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SystemMaintenanceEditAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # check required parameters
        my %Error;
        my @NotifyData;

        # get SystemMaintenance parameters from web browser
        my $SystemMaintenanceData = $Self->_GetParams(
            Error => \%Error,
        );

        # a StartDate should always be defined before StopDate
        if (
            (
                defined $SystemMaintenanceData->{StartDate}
                && defined $SystemMaintenanceData->{StopDate}
            )
            && $SystemMaintenanceData->{StartDate} > $SystemMaintenanceData->{StopDate}
            )
        {
            $Error{StartDateServerError} = 'ServerError';

            # add notification
            push @NotifyData, {
                Priority => 'Error',
                Info     => "Start date shouldn't be defined after Stop date!",
            };
        }

        if ( !$SystemMaintenanceData->{Comment} ) {

            # add server error class
            $Error{CommentServerError} = 'ServerError';

        }

        if ( !$SystemMaintenanceData->{ValidID} ) {

            # add server error class
            $Error{ValidIDServerError} = 'ServerError';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {

            return $Self->_ShowEdit(
                %Error,
                %Param,
                NotifyData            => \@NotifyData,
                SystemMaintenanceID   => $SystemMaintenanceID,
                SystemMaintenanceData => $SystemMaintenanceData,
                Action                => 'Edit',
            );
        }

        # otherwise update configuration and return to edit screen
        my $UpdateResult = $Self->{SystemMaintenanceObject}->SystemMaintenanceUpdate(
            ID               => $SystemMaintenanceID,
            StartDate        => $SystemMaintenanceData->{StartDate},
            StopDate         => $SystemMaintenanceData->{StopDate},
            Comment          => $SystemMaintenanceData->{Comment},
            LoginMessage     => $SystemMaintenanceData->{LoginMessage},
            ShowLoginMessage => $SystemMaintenanceData->{ShowLoginMessage},
            NotifyMessage    => $SystemMaintenanceData->{NotifyMessage},
            ValidID          => $SystemMaintenanceData->{ValidID},
            UserID           => $Self->{UserID},
        );

        # show error if can't create
        if ( !$UpdateResult ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error updating the SystemMaintenance",
            );
        }

        # redirect to edit screen
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=SystemMaintenanceEdit;SystemMaintenanceID=$SystemMaintenanceID;Saved=1"
        );
    }

    # ------------------------------------------------------------ #
    # System Maintenance Delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        if ( !$SystemMaintenanceID ) {
            $Self->{LogObject}->Log(
                Message  => "No System Maintenance ID $SystemMaintenanceID",
                Priority => 'error',
            );
        }

        my $Delete = $Self->{SystemMaintenanceObject}->SystemMaintenanceDelete(
            ID     => $SystemMaintenanceID,
            UserID => $Self->{UserID},
        );
        if ( !$Delete ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message =>
                    "Was not possible to delete the SystemMaintenance entry : $SystemMaintenanceID!",
            );
        }
        return $Self->{LayoutObject}->Redirect( OP => 'Action=AdminSystemMaintenance' );

    }

    # ------------------------------------------------------------ #
    # else, show system maintenance list
    # ------------------------------------------------------------ #
    else {

        my $SystemMaintenanceList = $Self->{SystemMaintenanceObject}->SystemMaintenanceListGet(
            UserID => $Self->{UserID},
        );

        if ( !scalar @{$SystemMaintenanceList} ) {

            # no data found block
            $Self->{LayoutObject}->Block(
                Name => 'NoDataRow',
            );
        }
        else {

            for my $SystemMaintenance ( @{$SystemMaintenanceList} ) {

                # set the valid state
                $SystemMaintenance->{ValidID}
                    = $Self->{ValidObject}->ValidLookup( ValidID => $SystemMaintenance->{ValidID} );

                # include time stamps on the correct key
                for my $Key (qw(StartDate StopDate)) {

                    # try to convert SystemTime to TimeStamp
                    $SystemMaintenance->{ $Key . 'TimeStamp' } = $Self->{TimeObject}->SystemTime2TimeStamp(
                        SystemTime => $SystemMaintenance->{$Key},
                    );
                }

                # create blocks
                $Self->{LayoutObject}->Block(
                    Name => 'ViewRow',
                    Data => {
                        %{$SystemMaintenance},
                    },
                );
            }
        }

        # generate output
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSystemMaintenance',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # get SystemMaintenance information
    my $SystemMaintenanceData = $Param{SystemMaintenanceData} || {};

    my %TimeConfig;
    for my $Prefix (qw(StartDate StopDate)) {

        # time setting if available
        if (
            $SystemMaintenanceData->{ $Prefix . 'TimeStamp' }
            && $SystemMaintenanceData->{ $Prefix . 'TimeStamp' }
            =~ m{^(\d\d\d\d)-(\d\d)-(\d\d)\s(\d\d):(\d\d):(\d\d)$}xi
            )
        {
            $TimeConfig{$Prefix}->{ $Prefix . 'Year' }   = $1;
            $TimeConfig{$Prefix}->{ $Prefix . 'Month' }  = $2;
            $TimeConfig{$Prefix}->{ $Prefix . 'Day' }    = $3;
            $TimeConfig{$Prefix}->{ $Prefix . 'Hour' }   = $4;
            $TimeConfig{$Prefix}->{ $Prefix . 'Minute' } = $5;
            $TimeConfig{$Prefix}->{ $Prefix . 'Second' } = $6;
        }
    }

    # start date info
    $Param{StartDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %{$SystemMaintenanceData},
        %{ $TimeConfig{StartDate} },
        Prefix           => 'StartDate',
        Format           => 'DateInputFormatLong',
        YearPeriodPast   => 0,
        YearPeriodFuture => 0,
        StartDateClass   => $Param{StartDateInvalid} || ' ',
        Validate         => 1,
    );

    # stop date info
    $Param{StopDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %{$SystemMaintenanceData},
        %{ $TimeConfig{StopDate} },
        Prefix           => 'StopDate',
        Format           => 'DateInputFormatLong',
        YearPeriodPast   => 0,
        YearPeriodFuture => 0,
        StopDateClass    => $Param{StopDateInvalid} || ' ',
        Validate         => 1,
    );

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();

    $Param{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $SystemMaintenanceData->{ValidID} || 1,
        Class      => 'Validate_Required ' . ( $Param{ValidIDServerError} || '' ),
    );

    if (
        defined $SystemMaintenanceData->{ShowLoginMessage}
        && $SystemMaintenanceData->{ShowLoginMessage} == '1'
        )
    {
        $Param{Checked} = 'checked="checked"';
    }

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # show notifications if any
    if ( $Param{NotifyData} ) {
        for my $Notification ( @{ $Param{NotifyData} } ) {
            $Output .= $Self->{LayoutObject}->Notify(
                %{$Notification},
            );
        }
    }

    # get all sessions
    my @List     = $Self->{SessionObject}->GetAllSessionIDs();
    my $Table    = '';
    my $Counter  = @List;
    my %MetaData = ();
    my @UserSessions;
    $MetaData{UserSession}         = 0;
    $MetaData{CustomerSession}     = 0;
    $MetaData{UserSessionUniq}     = 0;
    $MetaData{CustomerSessionUniq} = 0;

    if ( $Param{Action} eq 'Edit' ) {

        for my $SessionID (@List) {
            my $List = '';
            my %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $SessionID );
            $MetaData{"$Data{UserType}Session"}++;
            if ( !$MetaData{"$Data{UserLogin}"} ) {
                $MetaData{"$Data{UserType}SessionUniq"}++;
                $MetaData{"$Data{UserLogin}"} = 1;
            }

            $Data{UserType} = 'Agent' if ( $Data{UserType} ne 'Customer' );

            # store data to be used later for showing a users session table
            push @UserSessions, {
                SessionID     => $SessionID,
                UserFirstname => $Data{UserFirstname},
                UserLastname  => $Data{UserLastname},
                UserType      => $Data{UserType},
            };
        }

        # show users session table
        for my $UserSession (@UserSessions) {

            # create blocks
            $Self->{LayoutObject}->Block(
                Name => $UserSession->{UserType} . 'Session',
                Data => {
                    %{$UserSession},
                    %Param,
                },
            );
        }

        # no customer sessions found
        if ( !$MetaData{CustomerSession} ) {

            $Self->{LayoutObject}->Block(
                Name => 'CustomerNoDataRow',
            );
        }

        # no agent sessions found
        if ( !$MetaData{UserSession} ) {

            $Self->{LayoutObject}->Block(
                Name => 'AgentNoDataRow',
            );
        }
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => "AdminSystemMaintenance$Param{Action}",
        Data         => {
            Counter => $Counter,
            %Param,
            %{$SystemMaintenanceData},
            %MetaData
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;

    # get parameters from web browser
    for my $ParamName (
        qw(
        StartDateYear StartDateMonth StartDateDay StartDateHour StartDateMinute
        StopDateYear StopDateMonth StopDateDay StopDateHour StopDateMinute
        Comment LoginMessage ShowLoginMessage NotifyMessage ValidID )
        )
    {
        my $EmptyValue = ( $ParamName eq 'ShowLoginMessage' ? 0 : undef );
        $GetParam->{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName ) || $EmptyValue;
    }

    ITEM:
    for my $Item (qw(StartDate StopDate)) {

        my %DateStructure;

        # check needed stuff
        PERIOD:
        for my $Period (qw(Year Month Day Hour Minute)) {

            if ( !defined $GetParam->{ $Item . $Period } ) {
                $Param{Error}->{ $Item . 'Invalid' } = 'ServerError';
                next ITEM;
            }

            $DateStructure{$Period} = $GetParam->{ $Item . $Period };
        }

        # check date
        if ( !$Self->{TimeObject}->Date2SystemTime( %DateStructure, Second => 0 ) ) {
            $Param{Error}->{ $Item . 'Invalid' } = 'ServerError';
            next ITEM;
        }

        # try to convert date to a SystemTime
        $GetParam->{$Item} = $Self->{TimeObject}->Date2SystemTime(
            %DateStructure,
            Second => 0,
        );

        # try to convert SystemTime to TimeStamp
        $GetParam->{ $Item . 'TimeStamp' } = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $GetParam->{$Item},
        );
    }

    return $GetParam;
}

1;
