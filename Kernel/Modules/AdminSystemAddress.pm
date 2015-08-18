# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSystemAddress;

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

    my $LayoutObject        = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject         = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');

    #create local object
    my $CheckItemObject = Kernel::System::CheckItem->new( %{$Self} );

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';
        my %Data = $SystemAddressObject->SystemAddressGet(
            ID => $ID,
        );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %Data,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemAddress',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Realname QueueID Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
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
                $SystemAddressObject->SystemAddressUpdate(
                    %GetParam,
                    UserID => $Self->{UserID},
                )
                )
            {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output
                    .= $LayoutObject->Notify( Info => 'System e-mail address updated!' );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminSystemAddress',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action => 'Change',
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemAddress',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam = ();
        $GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemAddress',
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

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Realname QueueID Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
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
            my $AddressID = $SystemAddressObject->SystemAddressAdd(
                %GetParam,
                UserID => $Self->{UserID},
            );

            if ($AddressID) {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify( Info => 'System e-mail address added!' );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminSystemAddress',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
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
            TemplateFile => 'AdminSystemAddress',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemAddress',
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

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );
    $Param{QueueOption} = $LayoutObject->AgentQueueListOption(
        Data       => { $Kernel::OM->Get('Kernel::System::Queue')->QueueList( Valid => 1 ), },
        Name       => 'QueueID',
        SelectedID => $Param{QueueID},
        Class => 'Modernize Validate_Required ' . ( $Param{Errors}->{'QueueIDInvalid'} || '' ),
        OnChangeSubmit => 0,
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %{ $Param{Errors} },
        },
    );

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $LayoutObject->Block( Name => 'HeaderEdit' );
    }
    else {
        $LayoutObject->Block( Name => 'HeaderAdd' );
    }

    # add the correct server error msg for the system email address
    if ( $Param{Name} && $Param{Errors}->{ErrorType} ) {
        $LayoutObject->Block(
            Name => 'Email' . $Param{Errors}->{ErrorType} . 'ServerErrorMsg',
            Data => {},
        );
    }
    else {
        $LayoutObject->Block(
            Name => "RequiredFieldServerErrorMsg",
            Data => {},
        );
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $Output       = '';

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );

    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );

    my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
    my %List                = $SystemAddressObject->SystemAddressList(
        Valid => 0,
    );

    # get valid list
    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

    # get queue list
    my %QueueList = $Kernel::OM->Get('Kernel::System::Queue')->QueueList();

    for my $ListKey ( sort { $List{$a} cmp $List{$b} } keys %List ) {

        my %Data = $SystemAddressObject->SystemAddressGet( ID => $ListKey );
        $LayoutObject->Block(
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
