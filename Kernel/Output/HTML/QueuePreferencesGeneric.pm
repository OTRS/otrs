# --
# Kernel/Output/HTML/QueuePreferencesGeneric.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: QueuePreferencesGeneric.pm,v 1.1 2008-02-11 11:33:49 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::QueuePreferencesGeneric;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get env
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem QueueObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}

sub Param {
    my $Self = shift;
    my %Param = @_;
    my @Params = ();
    my $GetParam = $Self->{ParamObject}->GetParam(Param => $Self->{ConfigItem}->{PrefKey});
    if (!defined($GetParam)) {
        $GetParam = defined($Param{QueueData}->{$Self->{ConfigItem}->{PrefKey}}) ? $Param{QueueData}->{$Self->{ConfigItem}->{PrefKey}} : $Self->{ConfigItem}->{DataSelected};
    }
    push (@Params, {
            %Param,
            Name => $Self->{ConfigItem}->{PrefKey},
            SelectedID => $GetParam,
        },
    );
    return @Params;
}

sub Run {
    my $Self = shift;
    my %Param = @_;

    foreach my $Key (keys %{$Param{GetParam}}) {
        my @Array = @{$Param{GetParam}->{$Key}};
        foreach (@Array) {
            # pref update db
            $Self->{QueueObject}->QueuePreferencesSet(
                QueueID => $Param{QueueData}->{QueueID},
                Key => $Key,
                Value => $_,
            );
        }
    }
    $Self->{Message} = 'Preferences updated successfully!';
    return 1;
}

sub Error {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Error} || '';
}

sub Message {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Message} || '';
}

1;
