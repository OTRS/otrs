# --
# Kernel/Output/HTML/PreferencesTheme.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: PreferencesTheme.pm,v 1.4 2007-03-20 14:24:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::PreferencesTheme;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
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
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}

sub Param {
    my $Self = shift;
    my %Param = @_;
    my @Params = ();
    push (@Params, {
            %Param,
            Name => $Self->{ConfigItem}->{PrefKey},
            Data => {
                $Self->{DBObject}->GetTableData(
                    What => 'theme, theme',
                    Table => 'theme',
                    Valid => 1,
                ),
            },
            SelectedID => $Self->{ParamObject}->GetParam(Param => 'UserTheme') ||
                $Param{UserData}->{UserTheme} ||
                $Self->{ConfigObject}->Get('DefaultTheme'),
            Block => 'Option',
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
            if (!$Self->{ConfigObject}->Get('DemoSystem')) {
                $Self->{UserObject}->SetPreferences(
                    UserID => $Param{UserData}->{UserID},
                    Key => $Key,
                    Value => $_,
                );
            }
            # update SessionID
            if ($Param{UserData}->{UserID} eq $Self->{UserID}) {
                $Self->{SessionObject}->UpdateSessionID(
                    SessionID => $Self->{SessionID},
                    Key => $Key,
                    Value => $_,
                );
            }
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
