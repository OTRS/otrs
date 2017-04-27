# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::MigrateTicketStats;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::Stats',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateTicketStats - Migrate ticket stats to new ticket search article field names.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

    my $Stats = $StatsObject->GetStatsList(
        UserID => 1,
    );

    STAT:
    for my $StatID ( @{ $Stats // [] } ) {
        my $Stat = $StatsObject->StatsGet(
            StatID => $StatID,
        );

        next STAT if !defined $Stat->{UseAsRestriction};

        # Rename old-style article fields in search parameters.
        my %SearchParamMap = (
            Body    => 'MIMEBase_Body',
            Cc      => 'MIMEBase_Cc',
            From    => 'MIMEBase_From',
            Subject => 'MIMEBase_Subject',
            To      => 'MIMEBase_To',
        );

        # Determine which restrictions need to be updated.
        my @NewUseAsRestriction;

        RESTRICTION:
        for my $Restriction ( @{ $Stat->{UseAsRestriction} // [] } ) {
            next RESTRICTION if !$Restriction->{Selected};
            next RESTRICTION if !$SearchParamMap{ $Restriction->{Element} };

            $Restriction->{Element} = $SearchParamMap{ $Restriction->{Element} };
            push @NewUseAsRestriction, $Restriction;
        }

        next STAT if !@NewUseAsRestriction;

        # Update only changed restrictions, StatsUpdate() will preserve the rest of configuration.
        my $Success = $StatsObject->StatsUpdate(
            StatID => $StatID,
            Hash   => {
                UseAsRestriction => \@NewUseAsRestriction,
            },
            UserID => 1,
        );
        if ( !$Success ) {
            print "\nCould not update stat '$Stat->{Title}'.\n";
            return;
        }
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
