# --
# Kernel/Modules/AdminMailAccount.pm - to add/update/delete MailAccount acounts
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AdminMailAccount.pm,v 1.6 2009-02-16 11:20:52 tr Exp $
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
$VERSION = qw($Revision: 1.6 $) [1];

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
    $Self->{QueueObject} = Kernel::System::Queue->new(%Param);
    $Self->{MailAccount} = Kernel::System::MailAccount->new(%Param);
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %GetParam = ();
    my @Params   = (qw(ID Login Password Host Type Comment ValidID QueueID Trusted DispatchingBy));
    for (@Params) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
    }

    # ------------------------------------------------------------ #
    # Run
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Run' ) {
        my %Data = $Self->{MailAccount}->MailAccountGet(%GetParam);
        if ( !%Data ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
        else {
            my $Ok = $Self->{MailAccount}->MailAccountFetch(
                %Data,
                Limit  => 15,
                UserID => $Self->{UserID},
            );
            if ( !$Ok ) {
                return $Self->{LayoutObject}->ErrorScreen();
            }
            else {
                return $Self->{LayoutObject}->Redirect( OP => 'Action=$Env{"Action"}&Ok=1' );
            }
        }
    }

    # ------------------------------------------------------------ #
    # delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {
        if ( $Self->{MailAccount}->MailAccountDelete(%GetParam) ) {
            return $Self->{LayoutObject}->Redirect( OP => 'Action=$Env{"Action"}' );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {
        my $ID = $Self->{MailAccount}->MailAccountAdd(
            %GetParam,
            QueueID       => 0,
            DispatchingBy => 0,
            Trusted       => 0,
            ValidID       => 1,
            UserID        => $Self->{UserID},
        );
        if ($ID) {
            return $Self->{LayoutObject}->Redirect(
                OP => 'Action=$Env{"Action"}&Subaction=Update&ID=' . $ID,
            );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # ------------------------------------------------------------ #
    # update
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Update' ) {
        my %Data = $Self->{MailAccount}->MailAccountGet(%GetParam);
        if ( !%Data ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
        else {
            return $Self->_MaskUpdate(%Data);
        }
    }

    # ------------------------------------------------------------ #
    # update action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UpdateAction' ) {
        if ( $Self->{MailAccount}->MailAccountUpdate( %GetParam, UserID => $Self->{UserID} ) ) {
            return $Self->{LayoutObject}->Redirect( OP => 'Action=$Env{"Action"}' );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        my $Ok      = $Self->{ParamObject}->GetParam( Param => 'Ok' );
        my %Backend = $Self->{MailAccount}->MailAccountBackendList();
        my %List    = $Self->{MailAccount}->MailAccountList( Valid => 0 );
        $Param{'TypeOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => { $Self->{MailAccount}->MailAccountBackendList() },
            Name       => 'Type',
            SelectedID => $Param{Type} || 'POP3',
        );

        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => { %Param, },
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResult',
            Data => { %Param, },
        );
        for my $Key ( sort { $List{$a} cmp $List{$b} } keys %List ) {
            my %Data = $Self->{MailAccount}->MailAccountGet( ID => $Key );
            if ( !$Backend{ $Data{Type} } ) {
                $Data{Type} .= '(not installed!)';
            }
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => \%Data,
            );
        }

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

sub _MaskUpdate {
    my ( $Self, %Param ) = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => { $Self->{ValidObject}->ValidList(), },
        Name       => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{'TypeOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => { $Self->{MailAccount}->MailAccountBackendList() },
        Name       => 'Type',
        SelectedID => $Param{Type},
    );

    $Param{'TrustedOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name       => 'Trusted',
        SelectedID => $Param{Trusted},
    );

    $Param{'DispatchingOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            From  => 'Dispatching by email To: field.',
            Queue => 'Dispatching by selected Queue.',
        },
        Name       => 'DispatchingBy',
        SelectedID => $Param{DispatchingBy},
    );

    $Param{'QueueOption'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => {
            '' => '-',
            $Self->{QueueObject}->QueueList( Valid => 1 ),
        },
        Name           => 'QueueID',
        SelectedID     => $Param{QueueID},
        OnChangeSubmit => 0,
    );
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => { %Param, },
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => { %Param, },
    );
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output( TemplateFile => 'AdminMailAccount', Data => \%Param );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
