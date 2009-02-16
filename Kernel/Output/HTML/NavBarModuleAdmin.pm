# --
# Kernel/Output/HTML/NavBarModuleAdmin.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: NavBarModuleAdmin.pm,v 1.9 2009-02-16 11:16:22 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBarModuleAdmin;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

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
    my ( $Self, %Param ) = @_;

    my $Output = '';

    if ( $Param{Type} ne 'Admin' ) {
        return '';
    }
    $Self->{LayoutObject}->Block(
        Name => 'AdminNavBar',
        Data => {},
    );

    # get all Frontend::Module
    my %NavBarModule         = ();
    my $FrontendModuleConfig = $Self->{ConfigObject}->Get('Frontend::Module');
    for my $Module ( sort keys %{$FrontendModuleConfig} ) {
        my %Hash = %{ $FrontendModuleConfig->{$Module} };
        if (
            $Hash{NavBarModule}
            && $Hash{NavBarModule}->{Module} eq 'Kernel::Output::HTML::NavBarModuleAdmin'
            )
        {

            # check permissions (only show accessable modules)
            my $Shown = 0;
            for my $Permission (qw(GroupRo Group)) {

                # array access restriction
                if ( $Hash{$Permission} && ref $Hash{$Permission} eq 'ARRAY' ) {
                    for ( @{ $Hash{$Permission} } ) {
                        my $Key = 'UserIs' . $Permission . '[' . $_ . ']';
                        if (
                            $Self->{LayoutObject}->{$Key}
                            && $Self->{LayoutObject}->{$Key} eq 'Yes'
                            )
                        {
                            $Shown = 1;
                        }

                    }
                }

                # scalar access restriction
                elsif ( $Hash{$Permission} ) {
                    my $Key = 'UserIs' . $Permission . '[' . $Hash{$Permission} . ']';
                    if ( $Self->{LayoutObject}->{$Key} && $Self->{LayoutObject}->{$Key} eq 'Yes' ) {
                        $Shown = 1;
                    }
                }

                # no access restriction
                elsif ( !$Hash{GroupRo} && !$Hash{Group} ) {
                    $Shown = 1;
                }

            }
            next if !$Shown;

            my $Key = sprintf( "%07d", $Hash{NavBarModule}->{Prio} || 0 );
            for ( 1 .. 51 ) {
                if ( $NavBarModule{$Key} ) {
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
    for my $Module ( sort keys %NavBarModule ) {
        $Self->{LayoutObject}->Block(
            Name => $NavBarModule{$Module}->{NavBarModule}->{Block} || 'Item',
            Data => $NavBarModule{$Module},
        );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminNavigationBar',
        Data         => \%Param,
    );

    return $Output;
}

1;
