# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSystemMaintenance;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

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

    my $LayoutObject            = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject             = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $SessionObject           = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $SystemMaintenanceObject = $Kernel::OM->Get('Kernel::System::SystemMaintenance');
    my $TimeObject              = $Kernel::OM->Get('Kernel::System::Time');

    my $SystemMaintenanceID = $ParamObject->GetParam( Param => 'SystemMaintenanceID' ) || '';
    my $WantSessionID       = $ParamObject->GetParam( Param => 'WantSessionID' )       || '';

    my $SessionVisibility = 'Collapsed';

    # ------------------------------------------------------------ #
    # kill session id
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Kill' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        $SessionObject->RemoveSessionID( SessionID => $WantSessionID );
        return $LayoutObject->Redirect(
            OP =>
                "Action=AdminSystemMaintenance;Subaction=SystemMaintenanceEdit;SystemMaintenanceID=$SystemMaintenanceID;Kill=1"
        );
    }

    # ------------------------------------------------------------ #
    # kill all session ids
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'KillAll' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my @Sessions = $SessionObject->GetAllSessionIDs();
        SESSIONS:
        for my $Session (@Sessions) {
            next SESSIONS if $Session eq $WantSessionID;
            $SessionObject->RemoveSessionID( SessionID => $Session );
        }

        return $LayoutObject->Redirect(
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
        $LayoutObject->ChallengeTokenCheck();

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

        my $SystemMaintenanceID = $SystemMaintenanceObject->SystemMaintenanceAdd(
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
            return $LayoutObject->ErrorScreen(
                Message => "There was an error creating the SystemMaintenance",
            );
        }

        # redirect to edit screen
        return $LayoutObject->Redirect(
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
            return $LayoutObject->ErrorScreen(
                Message => "Need SystemMaintenanceID!",
            );
        }

        # get system maintenance data
        my $SystemMaintenanceData = $SystemMaintenanceObject->SystemMaintenanceGet(
            ID     => $SystemMaintenanceID,
            UserID => $Self->{UserID},
        );

        # include time stamps on the correct key
        for my $Key (qw(StartDate StopDate)) {

            # try to convert SystemTime to TimeStamp
            $SystemMaintenanceData->{ $Key . 'TimeStamp' } = $TimeObject->SystemTime2TimeStamp(
                SystemTime => $SystemMaintenanceData->{$Key},
            );
        }

        # check for valid system maintenance data
        if ( !IsHashRefWithData($SystemMaintenanceData) ) {
            return $LayoutObject->ErrorScreen(
                Message => "Could not get data for SystemMaintenanceID $SystemMaintenanceID",
            );
        }

        if ( $ParamObject->GetParam( Param => 'Saved' ) ) {

            # add notification
            push @NotifyData, {
                Priority => 'Notice',
                Info     => "System Maintenance was saved successfully!",
            };
        }

        if ( $ParamObject->GetParam( Param => 'Kill' ) ) {

            # add notification
            push @NotifyData, {
                Priority => 'Notice',
                Info     => 'Session has been killed!',
            };

            # set class for expanding sessions widget
            $SessionVisibility = 'Expanded';
        }

        if ( $ParamObject->GetParam( Param => 'KillAll' ) ) {

            # add notification
            push @NotifyData, {
                Priority => 'Notice',
                Info     => 'All sessions have been killed, except for your own.',
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
        $LayoutObject->ChallengeTokenCheck();

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
        my $UpdateResult = $SystemMaintenanceObject->SystemMaintenanceUpdate(
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
            return $LayoutObject->ErrorScreen(
                Message => "There was an error updating the SystemMaintenance",
            );
        }

        # redirect to edit screen
        return $LayoutObject->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=SystemMaintenanceEdit;SystemMaintenanceID=$SystemMaintenanceID;Saved=1"
        );
    }

    # ------------------------------------------------------------ #
    # System Maintenance Delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        if ( !$SystemMaintenanceID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "No System Maintenance ID $SystemMaintenanceID",
                Priority => 'error',
            );
        }

        my $Delete = $SystemMaintenanceObject->SystemMaintenanceDelete(
            ID     => $SystemMaintenanceID,
            UserID => $Self->{UserID},
        );
        if ( !$Delete ) {
            return $LayoutObject->ErrorScreen(
                Message =>
                    "Was not possible to delete the SystemMaintenance entry : $SystemMaintenanceID!",
            );
        }
        return $LayoutObject->Redirect( OP => 'Action=AdminSystemMaintenance' );

    }

    # ------------------------------------------------------------ #
    # else, show system maintenance list
    # ------------------------------------------------------------ #
    else {

        my $SystemMaintenanceList = $SystemMaintenanceObject->SystemMaintenanceListGet(
            UserID => $Self->{UserID},
        );

        if ( !scalar @{$SystemMaintenanceList} ) {

            # no data found block
            $LayoutObject->Block(
                Name => 'NoDataRow',
            );
        }
        else {

            for my $SystemMaintenance ( @{$SystemMaintenanceList} ) {

                # set the valid state
                $SystemMaintenance->{ValidID} = $Kernel::OM->Get('Kernel::System::Valid')
                    ->ValidLookup( ValidID => $SystemMaintenance->{ValidID} );

                # include time stamps on the correct key
                for my $Key (qw(StartDate StopDate)) {

                    # try to convert SystemTime to TimeStamp
                    $SystemMaintenance->{ $Key . 'TimeStamp' } = $TimeObject->SystemTime2TimeStamp(
                        SystemTime => $SystemMaintenance->{$Key},
                    );
                }

                # create blocks
                $LayoutObject->Block(
                    Name => 'ViewRow',
                    Data => {
                        %{$SystemMaintenance},
                    },
                );
            }
        }

        # generate output
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemMaintenance',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

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
    $Param{StartDateString} = $LayoutObject->BuildDateSelection(
        %{$SystemMaintenanceData},
        %{ $TimeConfig{StartDate} },
        Prefix           => 'StartDate',
        Format           => 'DateInputFormatLong',
        YearPeriodPast   => 0,
        YearPeriodFuture => 1,
        StartDateClass   => $Param{StartDateInvalid} || ' ',
        Validate         => 1,
    );

    # stop date info
    $Param{StopDateString} = $LayoutObject->BuildDateSelection(
        %{$SystemMaintenanceData},
        %{ $TimeConfig{StopDate} },
        Prefix           => 'StopDate',
        Format           => 'DateInputFormatLong',
        YearPeriodPast   => 0,
        YearPeriodFuture => 1,
        StopDateClass    => $Param{StopDateInvalid} || ' ',
        Validate         => 1,
    );

    # get valid list
    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $SystemMaintenanceData->{ValidID} || 1,
        Class      => 'Modernize Validate_Required ' . ( $Param{ValidIDServerError} || '' ),
    );

    if (
        defined $SystemMaintenanceData->{ShowLoginMessage}
        && $SystemMaintenanceData->{ShowLoginMessage} == '1'
        )
    {
        $Param{Checked} = 'checked="checked"';
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # show notifications if any
    if ( $Param{NotifyData} ) {
        for my $Notification ( @{ $Param{NotifyData} } ) {
            $Output .= $LayoutObject->Notify(
                %{$Notification},
            );
        }
    }

    # get all sessions
    my @List     = $SessionObject->GetAllSessionIDs();
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
            my %Data = $SessionObject->GetSessionIDData( SessionID => $SessionID );
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
            $LayoutObject->Block(
                Name => $UserSession->{UserType} . 'Session',
                Data => {
                    %{$UserSession},
                    %Param,
                },
            );
        }

        # no customer sessions found
        if ( !$MetaData{CustomerSession} ) {

            $LayoutObject->Block(
                Name => 'CustomerNoDataRow',
            );
        }

        # no agent sessions found
        if ( !$MetaData{UserSession} ) {

            $LayoutObject->Block(
                Name => 'AgentNoDataRow',
            );
        }
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => "AdminSystemMaintenance$Param{Action}",
        Data         => {
            Counter => $Counter,
            %Param,
            %{$SystemMaintenanceData},
            %MetaData
        },
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my $GetParam;

    # get parameters from web browser
    for my $ParamName (
        qw(
        StartDateYear StartDateMonth StartDateDay StartDateHour StartDateMinute
        StopDateYear StopDateMonth StopDateDay StopDateHour StopDateMinute
        Comment LoginMessage ShowLoginMessage NotifyMessage ValidID )
        )
    {
        $GetParam->{$ParamName} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $ParamName );
    }
    $Param{ShowLoginMessage} ||= 0;

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
        if ( !$TimeObject->Date2SystemTime( %DateStructure, Second => 0 ) ) {
            $Param{Error}->{ $Item . 'Invalid' } = 'ServerError';
            next ITEM;
        }

        # try to convert date to a SystemTime
        $GetParam->{$Item} = $TimeObject->Date2SystemTime(
            %DateStructure,
            Second => 0,
        );

        # try to convert SystemTime to TimeStamp
        $GetParam->{ $Item . 'TimeStamp' } = $TimeObject->SystemTime2TimeStamp(
            SystemTime => $GetParam->{$Item},
        );
    }

    return $GetParam;
}

1;
