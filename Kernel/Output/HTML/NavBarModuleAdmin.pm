# --
# Kernel/Output/HTML/NavBarModuleAdmin.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: NavBarModuleAdmin.pm,v 1.5 2007-10-01 10:23:49 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NavBarModuleAdmin;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject TicketObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}

sub Run {
    my $Self   = shift;
    my %Param  = @_;
    my $Output = '';

    if ( $Param{Type} ne 'Admin' ) {
        return '';
    }
    $Self->{LayoutObject}->Block(
        Name => 'AdminNavBar',
        Data => {},
    );

    # get all Frontend::Module
    my %NavBarModule = ();
    my $FrontendModuleConfig = $Self->{ConfigObject}->Get('Frontend::Module');
    for my $Module ( sort keys %{$FrontendModuleConfig} ) {
        my %Hash = %{$FrontendModuleConfig->{$Module}};
        if ($Hash{NavBarModule} && $Hash{NavBarModule}->{Module} eq 'Kernel::Output::HTML::NavBarModuleAdmin') {
            my $Key = sprintf("%07d", $Hash{NavBarModule}->{Prio}||0);
            foreach (1..51) {
                if ($NavBarModule{$Key}) {
                    $Hash{NavBarModule}->{Prio}++;
                    $Key = sprintf( "%07d", $Hash{NavBarModule}->{Prio} );
                }
                if ( !$NavBarModule{$Key} ) {
                    last;
                }
            }
            $NavBarModule{$Key} = {
                'Frontend::Module' => $Module,
                %Hash,
                %{ $Hash{NavBarModule} },
            };

        }
    }
    for ( sort keys %NavBarModule ) {
        $Self->{LayoutObject}->Block(
            Name => $NavBarModule{$_}->{NavBarModule}->{Block} || 'Item',
            Data => $NavBarModule{$_},
        );
    }

    $Output
        .= $Self->{LayoutObject}->Output( TemplateFile => 'AdminNavigationBar', Data => \%Param );

    return $Output;
}

1;
