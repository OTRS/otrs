# --
# Kernel/Modules/AdminSystemAddress.pm - to add/update/delete system addresses
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSystemAddress;

use strict;
use warnings;

use Kernel::System::Queue;
use Kernel::System::SystemAddress;
use Kernel::System::Valid;
use Kernel::System::CheckItem;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }
    $Self->{QueueObject}         = Kernel::System::Queue->new(%Param);
    $Self->{SystemAddressObject} = Kernel::System::SystemAddress->new(%Param);
    $Self->{ValidObject}         = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    #create local object
    my $CheckItemObject = Kernel::System::CheckItem->new( %{$Self} );

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
        my %Data = $Self->{SystemAddressObject}->SystemAddressGet( ID => $ID, );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %Data,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSystemAddress',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Realname QueueID Comment ValidID)) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Name Realname QueueID ValidID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # check email address
        if (
            $GetParam{Name}
            && !$CheckItemObject->CheckEmail( Address => $GetParam{Name} )
            )
        {
            $Errors{NameInvalid} = 'ServerError';
            $Errors{ErrorType}   = $CheckItemObject->CheckErrorType();
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update email system address
            if (
                $Self->{SystemAddressObject}->SystemAddressUpdate(
                    %GetParam,
                    UserID => $Self->{UserID},
                )
                )
            {
                $Self->_Overview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output
                    .= $Self->{LayoutObject}->Notify( Info => 'System e-mail address updated!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminSystemAddress',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action => 'Change',
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSystemAddress',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam = ();
        $GetParam{Name} = $Self->{ParamObject}->GetParam( Param => 'Name' );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSystemAddress',
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

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Realname QueueID Comment ValidID)) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Name Realname QueueID ValidID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # check email address
        if (
            $GetParam{Name}
            && !$CheckItemObject->CheckEmail( Address => $GetParam{Name} )
            )
        {
            $Errors{NameInvalid} = 'ServerError';
            $Errors{ErrorType}   = $CheckItemObject->CheckErrorType();
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add user
            my $AddressID = $Self->{SystemAddressObject}->SystemAddressAdd(
                %GetParam,
                UserID => $Self->{UserID},
            );

            if ($AddressID) {
                $Self->_Overview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'System e-mail address added!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminSystemAddress',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
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
            TemplateFile => 'AdminSystemAddress',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSystemAddress',
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

    # get valid list
    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );
    $Param{QueueOption} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => { $Self->{QueueObject}->QueueList( Valid => 1 ), },
        Name => 'QueueID',
        SelectedID     => $Param{QueueID},
        Class          => 'Validate_Required ' . ( $Param{Errors}->{'QueueIDInvalid'} || '' ),
        OnChangeSubmit => 0,
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %{ $Param{Errors} },
        },
    );

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEdit' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderAdd' );
    }

    # add the correct server error msg for the system email address
    if ( $Param{Name} && $Param{Errors}->{ErrorType} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Email' . $Param{Errors}->{ErrorType} . 'ServerErrorMsg',
            Data => {},
        );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => "RequiredFieldServerErrorMsg",
            Data => {},
        );
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionAdd' );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );
    my %List = $Self->{SystemAddressObject}->SystemAddressList( Valid => 0, );

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();

    # get queue list
    my %QueueList = $Self->{QueueObject}->QueueList();

    for my $ListKey ( sort { $List{$a} cmp $List{$b} } keys %List ) {

        my %Data = $Self->{SystemAddressObject}->SystemAddressGet( ID => $ListKey );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResultRow',
            Data => {
                Valid => $ValidList{ $Data{ValidID} },
                Queue => $QueueList{ $Data{QueueID} },
                %Data,
            },
        );
    }
    return 1;
}

1;
