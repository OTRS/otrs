# --
# Kernel/Modules/AdminPOP3.pm - to add/update/delete POP3 acounts
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminPOP3.pm,v 1.14 2006-02-28 06:02:43 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminPOP3;

use strict;
use Kernel::System::POP3Account;

use vars qw($VERSION);
$VERSION = '$Revision: 1.14 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    $Self->{POP3Account} = Kernel::System::POP3Account->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my %GetParam = ();
    my @Params = (qw(ID Login Password Host Comment ValidID QueueID Trusted DispatchingBy));
    foreach (@Params) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
    }
    # ------------------------------------------------------------ #
    # delete
    # ------------------------------------------------------------ #
    if ($Self->{Subaction} eq 'Delete') {
        if ($Self->{POP3Account}->POP3AccountDelete(%GetParam)) {
            return $Self->{LayoutObject}->Redirect(OP => 'Action=$Env{"Action"}');
        }
        else {
           return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'AddAction') {
        if (my $ID = $Self->{POP3Account}->POP3AccountAdd(
            %GetParam,
            QueueID => 0,
            DispatchingBy => 0,
            Trusted => 0,
            ValidID => 1,
            UserID => $Self->{UserID},
        )) {
            return $Self->{LayoutObject}->Redirect(
                OP => 'Action=$Env{"Action"}&Subaction=Update&ID='.$ID,
            );
        }
        else {
           return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # ------------------------------------------------------------ #
    # update
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'Update') {
        my %Data = $Self->{POP3Account}->POP3AccountGet(%GetParam);
        if (!%Data) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
        else {
            return $Self->_MaskUpdate(%Data);
        }
    }
    # ------------------------------------------------------------ #
    # update action
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'UpdateAction') {
        if ($Self->{POP3Account}->POP3AccountUpdate(%GetParam, UserID => $Self->{UserID})) {
            return $Self->{LayoutObject}->Redirect(OP => 'Action=$Env{"Action"}');
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        my %List = $Self->{POP3Account}->POP3AccountList(Valid => 0);

        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResult',
            Data => {
                %Param,
            },
        );
        foreach my $Key (sort keys %List) {
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => {
                    $Self->{POP3Account}->POP3AccountGet(ID => $Key),
                },
            );
        }

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPOP3',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
sub _MaskUpdate {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{'TrustedOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'Trusted',
        SelectedID => $Param{Trusted},
    );

    $Param{'DispatchingOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            From => 'Dispatching by email To: field.',
            Queue => 'Dispatching by selected Queue.',
        },
        Name => 'DispatchingBy',
        SelectedID => $Param{DispatchingBy},
    );

    $Param{'QueueOption'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'queue',
            Valid => 1,
          ),
          '' => '-',
        },
        Name => 'QueueID',
        SelectedID => $Param{QueueID},
        OnChangeSubmit => 0,
    );
    $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
        },
    );
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminPOP3', Data => \%Param);
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --
1;
