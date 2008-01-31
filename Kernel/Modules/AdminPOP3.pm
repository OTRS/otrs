# --
# Kernel/Modules/AdminPOP3.pm - to add/update/delete POP3 acounts
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminPOP3.pm,v 1.21 2008-01-31 06:22:12 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminPOP3;

use strict;
use warnings;

use Kernel::System::POP3Account;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.21 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = { %Param };
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{POP3Account} = Kernel::System::POP3Account->new(%Param);
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %GetParam = ();
    my @Params   = (qw(ID Login Password Host Comment ValidID QueueID Trusted DispatchingBy));
    for (@Params) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
    }

    # ------------------------------------------------------------ #
    # delete
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Delete' ) {
        if ( $Self->{POP3Account}->POP3AccountDelete(%GetParam) ) {
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
        if (my $ID = $Self->{POP3Account}->POP3AccountAdd(
                %GetParam,
                QueueID       => 0,
                DispatchingBy => 0,
                Trusted       => 0,
                ValidID       => 1,
                UserID        => $Self->{UserID},
            )
            )
        {
            return $Self->{LayoutObject}
                ->Redirect( OP => 'Action=$Env{"Action"}&Subaction=Update&ID=' . $ID, );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # ------------------------------------------------------------ #
    # update
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Update' ) {
        my %Data = $Self->{POP3Account}->POP3AccountGet(%GetParam);
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
        if ( $Self->{POP3Account}->POP3AccountUpdate( %GetParam, UserID => $Self->{UserID} ) ) {
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
        my %List = $Self->{POP3Account}->POP3AccountList( Valid => 0 );

        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => { %Param, },
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResult',
            Data => { %Param, },
        );
        for my $Key ( sort keys %List ) {
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => { $Self->{POP3Account}->POP3AccountGet( ID => $Key ), },
            );
        }

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPOP3',
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
            $Self->{DBObject}->GetTableData(
                What  => 'id, name',
                Table => 'queue',
                Valid => 1,
            ),
            '' => '-',
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
    $Output .= $Self->{LayoutObject}->Output( TemplateFile => 'AdminPOP3', Data => \%Param );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
