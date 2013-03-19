# --
# Kernel/System/ReferenceData.pm - Provides reference data to OTRS
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ReferenceData;

use strict;
use warnings;

use Locale::Country qw(all_country_names);

use vars qw(@ISA);

=head1 NAME

Kernel::System::ReferenceData - ReferenceData lib

=head1 SYNOPSIS

Contains reference data. For now, this is limited to just a list of ISO country
codes.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::ReferenceData;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $ReferenceDataObject = Kernel::System::ReferenceData->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        EncodeObject => $EncodeObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject LogObject EncodeObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

=item CountryList()

return a list of countries as a hash reference. The countries are based on ISO
3166-2 and are provided by the Perl module Locale::Code::Country, or optionally
from the SysConfig setting ReferenceData::OwnCountryList.

    my $CountryList = $ReferenceDataObject->CountryList(
       Result => 'CODE', # optional: returns CODE => Country pairs conform ISO 3166-2.
    );

=cut

sub CountryList {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Result} || $Param{Result} ne 'CODE' ) {
        $Param{Result} = undef;
    }

    my $Countries = $Self->{ConfigObject}->Get('ReferenceData::OwnCountryList');

    if ( $Param{Result} && $Countries ) {

        # return Code => Country pairs from SysConfig
        return $Countries;
    }
    elsif ($Countries) {

        # return Country => Country pairs from SysConfig
        my %CountryJustNames = map { $_ => $_ } values %$Countries;
        return \%CountryJustNames;
    }

    my @CountryNames = all_country_names();

    if ( $Param{Result} ) {

        # return Code => Country pairs from ISO list
        my %Countries;
        for my $Country (@CountryNames) {
            $Countries{$Country} = country2code( $Country, 1 );
        }
        return \%Countries;
    }

    # return Country => Country pairs from ISO list
    my %CountryNames = map { $_ => $_ } @CountryNames;

    return \%CountryNames;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
