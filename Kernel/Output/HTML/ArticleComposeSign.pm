# --
# Kernel/Output/HTML/ArticleComposeSign.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: ArticleComposeSign.pm,v 1.9 2007-01-08 17:00:42 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::ArticleComposeSign;

use strict;
use Mail::Address;
use Kernel::System::Crypt;
use Kernel::System::Queue;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject ParamObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{QueueObject} = Kernel::System::Queue->new(%Param);

    return $Self;
}

sub Option {
    my $Self = shift;
    my %Param = @_;
    return ('SignKeyID');
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    if (!$Param{From}) {
        return;
    }
    my %KeyList = ();
    my @SearchAddress = Mail::Address->parse($Param{From});
    my $CryptObjectPGP = Kernel::System::Crypt->new(%{$Self}, CryptType => 'PGP');
    if ($CryptObjectPGP) {
        my @PrivateKeys = $CryptObjectPGP->PrivateKeySearch(
            Search => $SearchAddress[0]->address(),
        );
        foreach my $DataRef (@PrivateKeys) {
            $KeyList{"PGP::Inline::$DataRef->{Key}"} = "PGP-Inline: $DataRef->{Key} $DataRef->{Identifier}";
            $KeyList{"PGP::Detached::$DataRef->{Key}"} = "PGP-Detached: $DataRef->{Key} $DataRef->{Identifier}";
        }
    }
    my $CryptObjectSMIME = Kernel::System::Crypt->new(%{$Self}, CryptType => 'SMIME');
    if ($CryptObjectSMIME) {
        my @PrivateKeys = $CryptObjectSMIME->PrivateSearch(
            Search => $SearchAddress[0]->address(),
        );
        foreach my $DataRef (@PrivateKeys) {
            $KeyList{"SMIME::Detached::$DataRef->{Hash}"} = "SMIME-Detached: $DataRef->{Hash} $DataRef->{Email}";
        }
    }
    if (%KeyList) {
        $KeyList{''} = '-none-';
        if ((!defined($Param{SignKeyID}) || ($Param{ExpandCustomerName} && $Param{ExpandCustomerName} == 3)) && $Param{QueueID}) {
            my %Queue = $Self->{QueueObject}->QueueGet(ID => $Param{QueueID});
            $Param{SignKeyID} = $Queue{DefaultSignKey} || '';
        }
        my $List = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%KeyList,
            Name => 'SignKeyID',
            SelectedID => $Param{SignKeyID}
        );
        $Self->{LayoutObject}->Block(
            Name => 'Option',
            Data => {
                Key => 'Sign',
                Value => $List,
            },
        );
    }
    return;
}

sub ArticleOption {
    my $Self = shift;
    my %Param = @_;
    if ($Param{SignKeyID}) {
        my ($Type, $SubType, $Key) = split (/::/, $Param{SignKeyID});
        return (
            Sign => {
                Type => $Type,
                SubType => $SubType,
                Key => $Key,
            },
        );
    }
    return;
}

sub Error {
    my $Self = shift;
    my %Param = @_;
    if ($Self->{Error}) {
        return %{$Self->{Error}};
    }
    else {
        return;
    }
}

1;
