# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminRegistration;

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

    my $RegistrationState = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGet(
        Key => 'Registration::State',
    ) || '';

    # if system is not yet registered, subaction should be 'register'
    if ( $RegistrationState ne 'registered' ) {

        $Self->{Subaction} ||= 'OTRSIDValidate';

        # subaction can't be 'Deregister' or UpdateNow
        if ( $Self->{Subaction} eq 'Deregister' || $Self->{Subaction} eq 'UpdateNow' ) {
            $Self->{Subaction} = 'OTRSIDValidate';
        }
    }

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $RegistrationObject = $Kernel::OM->Get('Kernel::System::Registration');
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');

    # ------------------------------------------------------------ #
    # Scheduler not running screen
    # ------------------------------------------------------------ #
    if (
        $Self->{Subaction} ne 'OTRSIDValidate'
        && $RegistrationState ne 'registered'
        && !$Self->_SchedulerRunning()
        )
    {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $LayoutObject->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        $LayoutObject->Block(
            Name => 'SchedulerNotRunning',
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # check OTRS ID
    # ------------------------------------------------------------ #

    elsif ( $Self->{Subaction} eq 'CheckOTRSID' ) {

        my $OTRSID   = $ParamObject->GetParam( Param => 'OTRSID' )   || '';
        my $Password = $ParamObject->GetParam( Param => 'Password' ) || '';

        my %Response = $RegistrationObject->TokenGet(
            OTRSID   => $OTRSID,
            Password => $Password,
        );

        # redirect to next page on success
        if ( $Response{Token} ) {
            my $NextAction = $RegistrationState ne 'registered' ? 'Register' : 'Deregister';
            return $LayoutObject->Redirect(
                OP => "Action=AdminRegistration;Subaction=$NextAction;Token="
                    . $LayoutObject->LinkEncode( $Response{Token} )
                    . ';OTRSID='
                    . $LayoutObject->LinkEncode($OTRSID),
            );
        }

        # redirect to current screen with error message
        my %Result = (
            Success => $Response{Success} ? 'OK' : 'False',
            Message => $Response{Reason} || '',
            Token   => $Response{Token}  || '',
        );

        my $Output = $LayoutObject->Header();
        $Output .= $Response{Reason}
            ? $LayoutObject->Notify(
            Priority => 'Error',
            Info     => $Response{Reason},
            )
            : '';
        $Output .= $LayoutObject->NavigationBar();
        $LayoutObject->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        $LayoutObject->Block(
            Name => 'OTRSIDValidation',
            Data => \%Param,
        );

        $LayoutObject->Block(
            Name => 'OTRSIDValidationForm',
            Data => \%Param,
        );

        my $Block = $RegistrationState ne 'registered'
            ? 'OTRSIDRegistration'
            : 'OTRSIDDeregistration';

        $LayoutObject->Block(
            Name => $Block,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # OTRS ID validation
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'OTRSIDValidate' ) {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $LayoutObject->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        my $EntitlementStatus  = 'forbidden';
        my $OTRSBusinessObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');

        if ( $RegistrationState eq 'registered' ) {

            # Only call cloud service for a registered system
            $EntitlementStatus = $OTRSBusinessObject->OTRSBusinessEntitlementStatus(
                CallCloudService => 1,
            );
        }

        # users should not be able to de-register their system if they either have
        # OTRS Business Solution installed or are entitled to use it (by having a valid contract).
        if (
            $RegistrationState eq 'registered'
            && ( $OTRSBusinessObject->OTRSBusinessIsInstalled() || $EntitlementStatus ne 'forbidden' )
            )
        {

            $LayoutObject->Block( Name => 'ActionList' );
            $LayoutObject->Block( Name => 'ActionOverview' );

            $LayoutObject->Block(
                Name => 'OTRSIDDeregistrationNotPossible',
            );
        }
        else {

            $LayoutObject->Block(
                Name => 'OTRSIDValidation',
                Data => \%Param,
            );

            # check if the scheduler is not running
            if ( $RegistrationState ne 'registered' && !$Self->_SchedulerRunning() ) {

                $LayoutObject->Block(
                    Name => 'OTRSIDValidationSchedulerNotRunning',
                );
            }
            else {

                $LayoutObject->Block(
                    Name => 'OTRSIDValidationForm',
                    Data => \%Param,
                );
            }

            my $Block = $RegistrationState ne 'registered' ? 'OTRSIDRegistration' : 'OTRSIDDeregistration';
            $LayoutObject->Block(
                Name => $Block,
            );
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # registration
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Register' ) {

        my %GetParam;
        $GetParam{Token}  = $ParamObject->GetParam( Param => 'Token' );
        $GetParam{OTRSID} = $ParamObject->GetParam( Param => 'OTRSID' );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $LayoutObject->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        $Param{SystemTypeOption} = $LayoutObject->BuildSelection(
            Data          => [qw( Production Test Training Development )],
            PossibleNone  => 1,
            Name          => 'Type',
            SelectedValue => $Param{SystemType},
            Class         => 'Validate_Required ' . ( $Param{Errors}->{'TypeIDInvalid'} || '' ),
        );

        my $EnvironmentObject = $Kernel::OM->Get('Kernel::System::Environment');
        my %OSInfo            = $EnvironmentObject->OSInfoGet();
        my %DBInfo            = $EnvironmentObject->DBInfoGet();

        $LayoutObject->Block(
            Name => 'Registration',
            Data => {
                FQDN        => $ConfigObject->Get('FQDN'),
                OTRSVersion => $ConfigObject->Get('Version'),
                PerlVersion => sprintf( "%vd", $^V ),
                %Param,
                %GetParam,
                %OSInfo,
                %DBInfo,
            },
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # deregistration
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Deregister' ) {

        my %GetParam;
        $GetParam{Token}  = $ParamObject->GetParam( Param => 'Token' );
        $GetParam{OTRSID} = $ParamObject->GetParam( Param => 'OTRSID' );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $LayoutObject->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        $LayoutObject->Block(
            Name => 'Deregistration',
            Data => \%GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my ( %GetParam, %Errors );
        for my $Parameter (qw(SupportDataSending Type Description OTRSID Token)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Type)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            $RegistrationObject->Register(
                Token              => $GetParam{Token},
                OTRSID             => $GetParam{OTRSID},
                SupportDataSending => $GetParam{SupportDataSending} || 'No',
                Type               => $GetParam{Type},
                Description        => $GetParam{Description},
            );

            return $LayoutObject->Redirect(
                OP => 'Action=AdminRegistration',
            );
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );

        $Self->_Edit(
            Action => 'Add',
            Errors => \%Errors,
            %GetParam,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # edit screen
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Edit' ) {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $LayoutObject->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        my %RegistrationData = $RegistrationObject->RegistrationDataGet();

        $Param{Description} //= $RegistrationData{Description};

        $Param{SystemTypeOption} = $LayoutObject->BuildSelection(
            Data          => [qw( Production Test Training Development )],
            PossibleNone  => 1,
            Name          => 'Type',
            SelectedValue => $Param{Type} // $RegistrationData{Type},
            Class         => 'Validate_Required ' . ( $Param{Errors}->{'TypeIDInvalid'} || '' ),
        );

        # fallback for support data sending switch
        if ( !defined $RegistrationData{SupportDataSending} ) {
            $RegistrationData{SupportDataSending} = 'No';
        }

        # check SupportDataSending if it is enable
        $Param{SupportDataSendingChecked} = '';
        if ( $RegistrationData{SupportDataSending} eq 'Yes' ) {
            $Param{SupportDataSendingChecked} = 'checked="checked"';
        }

        $LayoutObject->Block(
            Name => 'Edit',
            Data => {
                FQDN        => $ConfigObject->Get('FQDN'),
                OTRSVersion => $ConfigObject->Get('Version'),
                PerlVersion => sprintf( "%vd", $^V ),
                %Param,
            },
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # edit action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'EditAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $RegistrationType   = $ParamObject->GetParam( Param => 'Type' );
        my $Description        = $ParamObject->GetParam( Param => 'Description' );
        my $SupportDataSending = $ParamObject->GetParam( Param => 'SupportDataSending' ) || 'No';

        my %Result = $RegistrationObject->RegistrationUpdateSend(
            Type               => $RegistrationType,
            Description        => $Description,
            SupportDataSending => $SupportDataSending,
        );

        # log change
        if ( $Result{Success} ) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message =>
                    "System Registration: User $Self->{UserID} changed Description: '$Description', Type: '$RegistrationType'.",
            );

        }

        return $LayoutObject->Redirect(
            OP => 'Action=AdminRegistration',
        );
    }

    # ------------------------------------------------------------ #
    # deregister action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DeregisterAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        $RegistrationObject->Deregister(
            OTRSID => $ParamObject->GetParam( Param => 'OTRSID' ),
            Token  => $ParamObject->GetParam( Param => 'Token' ),
        );

        return $LayoutObject->Redirect(
            OP => 'Action=Admin',
        );
    }

    # ------------------------------------------------------------ #
    # sent data overview
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SentDataOverview' ) {
        return $Self->_SentDataOverview();
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        my %RegistrationData = $RegistrationObject->RegistrationDataGet();

        $Self->_Overview(
            %RegistrationData,
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $LayoutObject->Block( Name => 'HeaderEdit' );
    }
    else {
        $LayoutObject->Block( Name => 'HeaderNew' );
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionUpdate' );
    $LayoutObject->Block( Name => 'ActionSentDataOverview' );
    $LayoutObject->Block( Name => 'ActionDeregister' );

    $LayoutObject->Block(
        Name => 'OverviewRegistered',
        Data => \%Param,
    );

    return 1;
}

sub _SentDataOverview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    my %RegistrationData = $Kernel::OM->Get('Kernel::System::Registration')->RegistrationDataGet();

    $LayoutObject->Block(
        Name => 'SentDataOverview',
    );

    my $RegistrationState = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGet(
        Key => 'Registration::State',
    ) || '';

    if ( $RegistrationState ne 'registered' ) {
        $LayoutObject->Block( Name => 'SentDataOverviewNoData' );
    }
    else {
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my %OSInfo       = $Kernel::OM->Get('Kernel::System::Environment')->OSInfoGet();
        my %System       = (
            PerlVersion     => sprintf( "%vd", $^V ),
            OSType          => $OSInfo{OS},
            OSVersion       => $OSInfo{OSName},
            OTRSVersion     => $ConfigObject->Get('Version'),
            FQDN            => $ConfigObject->Get('FQDN'),
            DatabaseVersion => $Kernel::OM->Get('Kernel::System::DB')->Version(),
            SupportDataSending => $Param{SupportDataSending} || $RegistrationData{SupportDataSending} || 'No',
        );
        my $RegistrationUpdateDataDump = $Kernel::OM->Get('Kernel::System::Main')->Dump( \%System );

        my $SupportDataDump;
        if ( $System{SupportDataSending} eq 'Yes' ) {
            my %SupportData = $Kernel::OM->Get('Kernel::System::SupportDataCollector')->Collect();
            $SupportDataDump = $Kernel::OM->Get('Kernel::System::Main')->Dump( $SupportData{Result} );
        }

        $LayoutObject->Block(
            Name => 'SentDataOverviewData',
            Data => {
                RegistrationUpdate => $RegistrationUpdateDataDump,
                SupportData        => $SupportDataDump,
            },
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminRegistration',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _SchedulerRunning {
    my ( $Self, %Param ) = @_;

    # try to get scheduler PID
    my %PID = $Kernel::OM->Get('Kernel::System::PID')->PIDGet(
        Name => 'otrs.Scheduler',
    );

    my $PIDUpdateTime = $Kernel::OM->Get('Kernel::Config')->Get('Scheduler::PIDUpdateTime') || 600;

    # check if scheduler process is registered in the DB and if the update was not too long ago
    if ( !%PID || ( time() - $PID{Changed} > 4 * $PIDUpdateTime ) ) {
        return;
    }

    return 1;
}

1;
