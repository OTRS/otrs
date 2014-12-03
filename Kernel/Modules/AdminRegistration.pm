# --
# Kernel/Modules/AdminRegistration.pm - to register the OTRS system
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminRegistration;

use strict;
use warnings;

use Kernel::System::Environment;
use Kernel::System::Registration;
use Kernel::System::SystemData;
use Kernel::System::OTRSBusiness;
use Kernel::System::PID;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (qw(ParamObject LayoutObject ConfigObject LogObject SessionObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }
    $Self->{EnvironmentObject}  = Kernel::System::Environment->new(%Param);
    $Self->{RegistrationObject} = Kernel::System::Registration->new(%Param);
    $Self->{SystemDataObject}   = Kernel::System::SystemData->new(%Param);
    $Self->{OTRSBusinessObject} = Kernel::System::OTRSBusiness->new(%Param);
    $Self->{PIDObject}          = Kernel::System::PID->new(%Param);

    $Self->{RegistrationState} = $Self->{SystemDataObject}->SystemDataGet(
        Key => 'Registration::State',
    ) || '';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # if system is not yet registered, subaction should be 'register'
    if ( $Self->{RegistrationState} ne 'registered' ) {

        $Self->{Subaction} ||= 'OTRSIDValidate';

        # subaction can't be 'Deregister' or UpdateNow
        if ( $Self->{Subaction} eq 'Deregister' || $Self->{Subaction} eq 'UpdateNow' ) {
            $Self->{Subaction} = 'OTRSIDValidate';
        }
    }

    # ------------------------------------------------------------ #
    # Scheduler not running screen
    # ------------------------------------------------------------ #
    if (   $Self->{Subaction} ne 'OTRSIDValidate'
        && $Self->{RegistrationState} ne 'registered'
        && !$Self->_SchedulerRunning() )
    {

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        $Self->{LayoutObject}->Block(
            Name => 'SchedulerNotRunning',
        );

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # check OTRS ID
    # ------------------------------------------------------------ #

    elsif ( $Self->{Subaction} eq 'CheckOTRSID' ) {

        my $OTRSID   = $Self->{ParamObject}->GetParam( Param => 'OTRSID' )   || '';
        my $Password = $Self->{ParamObject}->GetParam( Param => 'Password' ) || '';

        my %Response = $Self->{RegistrationObject}->TokenGet(
            OTRSID   => $OTRSID,
            Password => $Password,
        );

        # redirect to next page on success
        if ( $Response{Token} ) {
            my $NextAction = $Self->{RegistrationState} ne 'registered' ? 'Register' : 'Deregister';
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AdminRegistration;Subaction=$NextAction;Token="
                    . $Self->{LayoutObject}->LinkEncode( $Response{Token} )
                    . ';OTRSID='
                    . $Self->{LayoutObject}->LinkEncode($OTRSID),
            );
        }

        # redirect to current screen with error message
        my %Result = (
            Success => $Response{Success} ? 'OK' : 'False',
            Message => $Response{Reason} || '',
            Token   => $Response{Token}  || '',
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Response{Reason}
            ? $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => $Response{Reason},
            )
            : '';
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        $Self->{LayoutObject}->Block(
            Name => 'OTRSIDValidation',
            Data => \%Param,
        );

        my $Block = $Self->{RegistrationState} ne 'registered'
            ? 'OTRSIDRegistration'
            : 'OTRSIDDeregistration';

        $Self->{LayoutObject}->Block(
            Name => $Block,
        );

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # OTRS ID validation
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'OTRSIDValidate' ) {

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        my $EntitlementStatus = 'forbidden';
        if ( $Self->{RegistrationState} eq 'registered' ) {

            # Only call cloud service for a registered system
            $EntitlementStatus = $Self->{OTRSBusinessObject}->OTRSBusinessEntitlementStatus(
                CallCloudService => 1,
            );
        }

        # users should not be able to de-register their system if they either have
        # OTRS Business Solution installed or are entitled to use it (by having a valid contract).
        if (
            $Self->{RegistrationState} eq 'registered'
            && ( $Self->{OTRSBusinessObject}->OTRSBusinessIsInstalled() || $EntitlementStatus ne 'forbidden' )
            )
        {

            $Self->{LayoutObject}->Block( Name => 'ActionList' );
            $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

            $Self->{LayoutObject}->Block(
                Name => 'OTRSIDDeregistrationNotPossible',
            );
        }
        else {

            $Self->{LayoutObject}->Block(
                Name => 'OTRSIDValidation',
                Data => \%Param,
            );

            # check if the scheduler is not running
            if ( $Self->{RegistrationState} ne 'registered' && !$Self->_SchedulerRunning() ) {

                $Self->{LayoutObject}->Block(
                    Name => 'OTRSIDValidationSchedulerNotRunning',
                );
            }
            else {

                $Self->{LayoutObject}->Block(
                    Name => 'OTRSIDValidationForm',
                    Data => \%Param,
                );
            }

            my $Block = $Self->{RegistrationState} ne 'registered' ? 'OTRSIDRegistration' : 'OTRSIDDeregistration';
            $Self->{LayoutObject}->Block(
                Name => $Block,
            );
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # registration
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Register' ) {

        my %GetParam;
        $GetParam{Token}  = $Self->{ParamObject}->GetParam( Param => 'Token' );
        $GetParam{OTRSID} = $Self->{ParamObject}->GetParam( Param => 'OTRSID' );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        $Param{SystemTypeOption} = $Self->{LayoutObject}->BuildSelection(
            Data          => [qw( Production Test Training Development )],
            PossibleNone  => 1,
            Name          => 'Type',
            SelectedValue => $Param{SystemType},
            Class         => 'Validate_Required ' . ( $Param{Errors}->{'TypeIDInvalid'} || '' ),
        );

        my %OSInfo = $Self->{EnvironmentObject}->OSInfoGet();
        my %DBInfo = $Self->{EnvironmentObject}->DBInfoGet();

        $Self->{LayoutObject}->Block(
            Name => 'Registration',
            Data => {
                FQDN        => $Self->{ConfigObject}->Get('FQDN'),
                OTRSVersion => $Self->{ConfigObject}->Get('Version'),
                PerlVersion => sprintf( "%vd", $^V ),
                %Param,
                %GetParam,
                %OSInfo,
                %DBInfo,
            },
        );

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # deregistration
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Deregister' ) {

        my %GetParam;
        $GetParam{Token}  = $Self->{ParamObject}->GetParam( Param => 'Token' );
        $GetParam{OTRSID} = $Self->{ParamObject}->GetParam( Param => 'OTRSID' );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        $Self->{LayoutObject}->Block(
            Name => 'Deregistration',
            Data => \%GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my ( %GetParam, %Errors );
        for my $Parameter (qw(SupportDataSending Type Description OTRSID Token)) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Type)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            $Self->{RegistrationObject}->Register(
                Token              => $GetParam{Token},
                OTRSID             => $GetParam{OTRSID},
                SupportDataSending => $GetParam{SupportDataSending} || 'No',
                Type               => $GetParam{Type},
                Description        => $GetParam{Description},
            );

            return $Self->{LayoutObject}->Redirect(
                OP => 'Action=AdminRegistration',
            );
        }

        # something has gone wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );

        $Self->_Edit(
            Action => 'Add',
            Errors => \%Errors,
            %GetParam,
        );

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # edit screen
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Edit' ) {

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        my %RegistrationData = $Self->{RegistrationObject}->RegistrationDataGet();

        $Param{Description} //= $RegistrationData{Description};

        $Param{SystemTypeOption} = $Self->{LayoutObject}->BuildSelection(
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

        $Self->{LayoutObject}->Block(
            Name => 'Edit',
            Data => {
                FQDN        => $Self->{ConfigObject}->Get('FQDN'),
                OTRSVersion => $Self->{ConfigObject}->Get('Version'),
                PerlVersion => sprintf( "%vd", $^V ),
                %Param,
            },
        );

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # edit action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'EditAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $RegistrationType   = $Self->{ParamObject}->GetParam( Param => 'Type' );
        my $Description        = $Self->{ParamObject}->GetParam( Param => 'Description' );
        my $SupportDataSending = $Self->{ParamObject}->GetParam( Param => 'SupportDataSending' ) || 'No';

        my %Result = $Self->{RegistrationObject}->RegistrationUpdateSend(
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

        return $Self->{LayoutObject}->Redirect(
            OP => 'Action=AdminRegistration',
        );
    }

    # ------------------------------------------------------------ #
    # deregister action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DeregisterAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        $Self->{RegistrationObject}->Deregister(
            OTRSID => $Self->{ParamObject}->GetParam( Param => 'OTRSID' ),
            Token  => $Self->{ParamObject}->GetParam( Param => 'Token' ),
        );

        return $Self->{LayoutObject}->Redirect(
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
        my %RegistrationData = $Self->{RegistrationObject}->RegistrationDataGet();

        $Self->_Overview(
            %RegistrationData,
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEdit' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderNew' );
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionUpdate' );
    $Self->{LayoutObject}->Block( Name => 'ActionSentDataOverview' );
    $Self->{LayoutObject}->Block( Name => 'ActionDeregister' );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewRegistered',
        Data => \%Param,
    );

    return 1;
}

sub _SentDataOverview {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    my %RegistrationData = $Self->{RegistrationObject}->RegistrationDataGet();

    $Self->{LayoutObject}->Block(
        Name => 'SentDataOverview',
    );

    if ( $Self->{RegistrationState} ne 'registered' ) {
        $Self->{LayoutObject}->Block( Name => 'SentDataOverviewNoData' );
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

        $Self->{LayoutObject}->Block(
            Name => 'SentDataOverviewData',
            Data => {
                RegistrationUpdate => $RegistrationUpdateDataDump,
                SupportData        => $SupportDataDump,
            },
        );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminRegistration',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _SchedulerRunning {
    my ( $Self, %Param ) = @_;

    # try to get scheduler PID
    my %PID = $Self->{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    my $PIDUpdateTime = $Self->{ConfigObject}->Get('Scheduler::PIDUpdateTime') || 600;

    # check if scheduler process is registered in the DB and if the update was not too long ago
    if ( !%PID || ( time() - $PID{Changed} > 4 * $PIDUpdateTime ) ) {
        return;
    }

    return 1;
}

1;
