# --
# Kernel/Modules/AdminMailAccount.pm - to add/update/delete MailAccount accounts
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminMailAccount;

use strict;
use warnings;

use Kernel::System::Queue;
use Kernel::System::MailAccount;
use Kernel::System::Valid;

use vars qw($VERSION);

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
    $Self->{QueueObject} = Kernel::System::Queue->new(%Param);
    $Self->{MailAccount} = Kernel::System::MailAccount->new(%Param);
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %GetParam = ();
    my @Params
        = (
        qw(ID Login Password Host Type TypeAdd Comment ValidID QueueID IMAPFolder Trusted DispatchingBy)
        );
    for my $Parameter (@Params) {
        $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
    }

    # ------------------------------------------------------------ #
    # Run
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Run' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my %Data = $Self->{MailAccount}->MailAccountGet(%GetParam);
        if ( !%Data ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        my $Ok = $Self->{MailAccount}->MailAccountFetch(
            %Data,
            Limit  => 15,
            UserID => $Self->{UserID},
        );
        if ( !$Ok ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
        return $Self->{LayoutObject}->Redirect( OP => 'Action=AdminMailAccount;Ok=1' );
    }

    # ------------------------------------------------------------ #
    # delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Delete = $Self->{MailAccount}->MailAccountDelete(%GetParam);
        if ( !$Delete ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
        return $Self->{LayoutObject}->Redirect( OP => 'Action=AdminMailAccount' );
    }

    # ------------------------------------------------------------ #
    # add new mail account
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddNew' ) {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_MaskAddMailAccount(
            Action => 'AddNew',
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminMailAccount',
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

        my %Errors;

        # check needed data
        for my $Needed (qw(Login Password Host)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'AddInvalid' } = 'ServerError';
            }
        }
        for my $Needed (qw(TypeAdd ValidID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add mail account
            my $ID = $Self->{MailAccount}->MailAccountAdd(
                %GetParam,
                Type   => $GetParam{'TypeAdd'},
                UserID => $Self->{UserID},
            );
            if ($ID) {
                $Self->_Overview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Mail account added!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminMailAccount',
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
        $Self->_MaskAddMailAccount(
            Action => 'AddNew',
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminMailAccount',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # update
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Update' ) {
        my %Data   = $Self->{MailAccount}->MailAccountGet(%GetParam);
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_MaskUpdateMailAccount(
            Action => 'Update',
            %Data,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminMailAccount',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # update action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UpdateAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my %Errors;

        # check needed data
        for my $Needed (qw(Login Password Host)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'EditInvalid' } = 'ServerError';
            }
        }
        for my $Needed (qw(Type ValidID DispatchingBy QueueID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }
        if ( !$GetParam{Trusted} ) {
            $Errors{TrustedInvalid} = 'ServerError' if ( $GetParam{Trusted} != 0 );
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update mail account
            my $Update = $Self->{MailAccount}->MailAccountUpdate(
                %GetParam,
                UserID => $Self->{UserID},
            );
            if ($Update) {
                $Self->_Overview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Mail account updated!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminMailAccount',
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
        $Self->_MaskUpdateMailAccount(
            Action => 'Update',
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminMailAccount',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        $Self->_Overview();

        my $Ok = $Self->{ParamObject}->GetParam( Param => 'Ok' );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        if ($Ok) {
            $Output .= $Self->{LayoutObject}->Notify( Info => 'Finished' );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminMailAccount',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my %Backend = $Self->{MailAccount}->MailAccountBackendList();

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

    my %List = $Self->{MailAccount}->MailAccountList( Valid => 0 );

    # if there are any mail accounts, they are shown
    if (%List) {
        for my $ListKey ( sort { $List{$a} cmp $List{$b} } keys %List ) {
            my %Data = $Self->{MailAccount}->MailAccountGet( ID => $ListKey );
            if ( !$Backend{ $Data{Type} } ) {
                $Data{Type} .= '(not installed!)';
            }

            my @List = $Self->{ValidObject}->ValidIDsGet();

            for my $ListElement (@List) {
                if ( $Data{ValidID} eq $ListElement ) {
                    $Data{Invalid} = '';
                    last;
                }
                else {
                    $Data{Invalid} = 'Invalid';
                }
            }

            $Data{ShownValid} = $Self->{ValidObject}->ValidLookup(
                ValidID => $Data{ValidID},
            );

            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => \%Data,
            );
        }
    }

    # otherwise a no data found msg is displayed
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }
    return 1;
}

sub _MaskUpdateMailAccount {
    my ( $Self, %Param ) = @_;

    # get valid list
    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    # build ValidID string
    $Param{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );

    $Param{TypeOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => { $Self->{MailAccount}->MailAccountBackendList() },
        Name       => 'Type',
        SelectedID => $Param{Type} || $Param{TypeAdd} || '',
        Class      => 'Validate_Required ' . ( $Param{Errors}->{'TypeInvalid'} || '' ),
    );

    $Param{TrustedOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name       => 'Trusted',
        SelectedID => $Param{Trusted} || 0,
        Class      => $Param{Errors}->{'TrustedInvalid'} || '',
    );

    $Param{DispatchingOption} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            From  => 'Dispatching by email To: field.',
            Queue => 'Dispatching by selected Queue.',
        },
        Name       => 'DispatchingBy',
        SelectedID => $Param{DispatchingBy},
        Class      => 'Validate_Required ' . ( $Param{Errors}->{'DispatchingByInvalid'} || '' ),
    );

    $Param{QueueOption} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => { $Self->{QueueObject}->QueueList( Valid => 1 ) },
        Name => 'QueueID',
        SelectedID     => $Param{QueueID},
        OnChangeSubmit => 0,
        Class          => 'Validate_Required ' . ( $Param{Errors}->{'QueueIDInvalid'} || '' ),
    );
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => { %Param, },
    );
    $Self->{LayoutObject}->Block(
        Name => 'ActionList',
    );
    $Self->{LayoutObject}->Block(
        Name => 'ActionOverview',
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %{ $Param{Errors} },
        },
    );

    return 1;
}

sub _MaskAddMailAccount {

    my ( $Self, %Param ) = @_;

    # get valid list
    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    # build ValidID string
    $Param{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );

    $Param{TypeOptionAdd} = $Self->{LayoutObject}->BuildSelection(
        Data       => { $Self->{MailAccount}->MailAccountBackendList() },
        Name       => 'TypeAdd',
        SelectedID => $Param{Type} || $Param{TypeAdd} || '',
        Class      => 'Validate_Required ' . ( $Param{Errors}->{'TypeAddInvalid'} || '' ),
    );

    $Param{TrustedOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name       => 'Trusted',
        SelectedID => $Param{Trusted} || 0,
    );

    $Param{DispatchingOption} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            From  => 'Dispatching by email To: field.',
            Queue => 'Dispatching by selected Queue.',
        },
        Name       => 'DispatchingBy',
        SelectedID => $Param{DispatchingBy},
        Class      => 'Validate_Required ' . ( $Param{Errors}->{'DispatchingByInvalid'} || '' ),
    );

    $Param{QueueOption} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => { $Self->{QueueObject}->QueueList( Valid => 1 ) },
        Name => 'QueueID',
        SelectedID     => $Param{QueueID},
        OnChangeSubmit => 0,
        Class          => 'Validate_Required ' . ( $Param{Errors}->{'QueueIDInvalid'} || '' ),
    );
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => { %Param, },
    );
    $Self->{LayoutObject}->Block(
        Name => 'ActionList',
    );
    $Self->{LayoutObject}->Block(
        Name => 'ActionOverview',
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewAdd',
        Data => {
            %Param,
            %{ $Param{Errors} },
        },
    );

    return 1;
}

1;
