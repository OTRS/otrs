# --
# Kernel/Output/HTML/NavBarModuleAdmin.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBarModuleAdmin;

use strict;
use warnings;

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

    # only show it on admin start screen
    return '' if $Self->{LayoutObject}->{Action} ne 'Admin';

    $Self->{LayoutObject}->Block(
        Name => 'AdminNavBar',
        Data => {},
    );

    # get all Frontend::Module
    my %NavBarModule;
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
    my %Count;
    for my $Module ( sort keys %NavBarModule ) {
        my $BlockName = $NavBarModule{$Module}->{NavBarModule}->{Block} || 'Item';
        $Self->{LayoutObject}->Block(
            Name => $BlockName,
            Data => $NavBarModule{$Module},
        );
        if ( $Count{$BlockName}++ % 2 ) {
            $Self->{LayoutObject}->Block( Name => $BlockName . 'Clear' );
        }
    }

    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminNavigationBar',
        Data         => \%Param,
    );

    return $Output;
}

1;
