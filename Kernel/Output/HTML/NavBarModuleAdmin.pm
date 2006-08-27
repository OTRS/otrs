# --
# Kernel/Output/HTML/NavBarModuleAdmin.pm
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: NavBarModuleAdmin.pm,v 1.3 2006-08-27 22:25:33 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NavBarModuleAdmin;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject TicketObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';

    if ($Param{Type} ne 'Admin') {
        return '';
    }
    $Self->{LayoutObject}->Block(
        Name => 'AdminNavBar',
        Data => { },
    );

    # get all Frontend::Module
    my %NavBarModule = ();
    foreach my $Module (sort keys %{$Self->{ConfigObject}->Get('Frontend::Module')}) {
        my %Hash = %{$Self->{ConfigObject}->Get('Frontend::Module')->{$Module}};
        if ($Hash{NavBarModule} && $Hash{NavBarModule}->{Module} eq 'Kernel::Output::HTML::NavBarModuleAdmin') {
            my $Key = sprintf("%07d", $Hash{NavBarModule}->{Prio}||0);
            foreach (1..51) {
                if ($NavBarModule{$Key}) {
                    $Hash{NavBarModule}->{Prio}++;
                    $Key = sprintf("%07d", $Hash{NavBarModule}->{Prio});
                }
                if (!$NavBarModule{$Key}) {
                    last;
                }
            }
            $NavBarModule{$Key} = {
                'Frontend::Module' => $Module,
                %Hash,
                %{$Hash{NavBarModule}},
            };

        }
    }

    foreach (sort keys %NavBarModule) {
        $Self->{LayoutObject}->Block(
            Name => $NavBarModule{$_}->{NavBarModule}->{Block} || 'Item',
            Data => $NavBarModule{$_},
        );
    }

    $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminNavigationBar', Data => \%Param);

    return $Output;
}

1;
