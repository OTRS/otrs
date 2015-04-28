# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::PluginBase;

use strict;
use warnings;

use Scalar::Util qw();

our $StatusUnknown = 0;
our $StatusInfo    = 1;
our $StatusOK      = 2;
our $StatusWarning = 3;
our $StatusProblem = 4;

our %Status2Name = (
    $StatusUnknown => 'Unknown',
    $StatusOK      => 'OK',
    $StatusWarning => 'Warning',
    $StatusProblem => 'Problem',
    $StatusInfo    => 'Information',
);

our @ObjectDependencies = ();

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash ref to object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

# Override this in the plugins to specify their DisplayPath
sub GetDisplayPath {
    return 'General';
}

sub AddResultUnknown {
    my ( $Self, %Param ) = @_;

    return $Self->_AddResult(
        %Param,
        Status => $StatusUnknown,
    );
}

sub AddResultInformation {
    my ( $Self, %Param ) = @_;

    return $Self->_AddResult(
        %Param,
        Status => $StatusInfo,
    );
}

sub AddResultOk {
    my ( $Self, %Param ) = @_;

    return $Self->_AddResult(
        %Param,
        Status => $StatusOK,
    );
}

sub AddResultWarning {
    my ( $Self, %Param ) = @_;

    return $Self->_AddResult(
        %Param,
        Status => $StatusWarning,
    );
}

sub AddResultProblem {
    my ( $Self, %Param ) = @_;

    return $Self->_AddResult(
        %Param,
        Status => $StatusProblem,
    );
}

sub _AddResult {
    my ( $Self, %Param ) = @_;

    my %Result = %Param;
    $Result{Identifier} //= '';
    $Result{Identifier} =~ s{:+}{_};    # Replace all :: in the Identifier
    if ( $Result{Identifier} ) {
        $Result{Identifier} = Scalar::Util::blessed($Self) . "::$Result{Identifier}";
    }
    else {
        $Result{Identifier} = Scalar::Util::blessed($Self);
    }

    $Result{DisplayPath} //= $Self->GetDisplayPath();

    $Self->{Results} //= [];
    push @{ $Self->{Results} }, \%Result;
    return;
}

sub GetResults {
    my ( $Self, %Param ) = @_;

    return (
        Success => 1,
        Result  => $Self->{Results} // [],
    );
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
