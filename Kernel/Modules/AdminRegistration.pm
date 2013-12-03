# --
# Kernel/Modules/AdminRegistration.pm - to register the OTRS system
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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
use Kernel::System::SysConfig;
use Kernel::System::SystemData;

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
    $Self->{SysConfigObject}    = Kernel::System::SysConfig->new(%Param);
    $Self->{SystemDataObject}   = Kernel::System::SystemData->new(%Param);

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
    # check OTRS ID
    # ------------------------------------------------------------ #

    if ( $Self->{Subaction} eq 'CheckOTRSID' ) {

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
                OP =>
                    "Action=AdminRegistration;Subaction=$NextAction;Token=$Response{Token};OTRSID=$OTRSID",
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

        my $Block
            = $Self->{RegistrationState} ne 'registered'
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

        $Self->{LayoutObject}->Block(
            Name => 'OTRSIDValidation',
            Data => \%Param,
        );

        my $Block
            = $Self->{RegistrationState} ne 'registered'
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
        for my $Parameter (qw(Type Description OTRSID Token)) {
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
                Token       => $GetParam{Token},
                OTRSID      => $GetParam{OTRSID},
                Type        => $GetParam{Type},
                Description => $GetParam{Description},
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

        my $RegistrationType = $Self->{ParamObject}->GetParam( Param => 'Type' );
        my $Description      = $Self->{ParamObject}->GetParam( Param => 'Description' );

        my %Result = $Self->{RegistrationObject}->RegistrationUpdateSend(
            Type        => $RegistrationType,
            Description => $Description,
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

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {

        $Self->{RegistrationObject}->RegistrationUpdateSend();
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
    $Self->{LayoutObject}->Block( Name => 'ActionDeregister' );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewRegistered',
        Data => \%Param,
    );

    return 1;
}

1;
