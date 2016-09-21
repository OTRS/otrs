# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::webservices::examples::BugzillaConnector_pre;
## nofilter(TidyAll::Plugin::OTRS::Perl::PerlCritic)

use strict;
use warnings;

use base qw(var::webservices::examples::Base);

our @ObjectDependencies = ();

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Response = (
        Success => 1,
    );

    # Dynamic fields definition
    my @DynamicFields = (
        {
            Name       => 'PreWebBugzillaID',
            Label      => 'Bugzilla ID',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10000,
            Config     => {
                Link =>
                    'https://landfill.bugzilla.org/bugzilla-5.0-branch/show_bug.cgi?id=[% Data.PreWebBugzillaID | uri %]',
            },
        },
    );

    %Response = $Self->DynamicFieldsAdd(
        DynamicFieldList => \@DynamicFields,
    );

    return %Response;
}

1;
