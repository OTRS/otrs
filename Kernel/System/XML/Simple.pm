# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::XML::Simple;

use strict;
use warnings;

use XML::LibXML::Simple;

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::XML::Simple - Turn XML into a Perl structure

=head1 DESCRIPTION

Turn XML into a Perl structure.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $XMLSimpleObject = $Kernel::OM->Get('Kernel::System::XML::Simple');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 XMLIn()

Turns given XML data into Perl structure.
The resulting Perl structure can be in adjusted with options.
Available options can be found here:
http://search.cpan.org/~markov/XML-LibXML-Simple-0.97/lib/XML/LibXML/Simple.pod#Parameter_%options

    # XML from file:
    my $PerlStructure = $XMLSimpleObject->XMLIn(
        XMLInput => '/xml/items.xml',
        Options  => {
            ForceArray   => 1,
            ForceContent => 1,
            ContentKey   => 'Content',
        },
    );

    # XML from string:
    my $PerlStructure = $XMLSimpleObject->XMLIn(
        XMLInput => '<MyXML><Item Type="String">My content</Item><Item Type="Number">23</Item></MyXML>',
        Options  => {
            ForceArray   => 1,
            ForceContent => 1,
            ContentKey   => 'Content',
        },
    );

    Results in:

    my $PerlStructure = {
        Item => [
            {
                Type    => 'String',
                Content => 'My content',
            },
            {
                Type    => 'Number',
                Content => '23',
            },
        ],
    };

=cut

sub XMLIn {
    my ( $Self, %Param ) = @_;

    if ( !$Param{XMLInput} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need parameter XMLInput!",
        );
        return;
    }

    if ( exists $Param{Options} && ref $Param{Options} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Parameter Options needs to be a hash ref!",
        );
        return;
    }

    my $PerlStructure;
    eval {

        my $XMLSimpleObject = XML::LibXML::Simple->new();

        $PerlStructure = $XMLSimpleObject->XMLin(
            $Param{XMLInput},
            $Param{Options} ? %{ $Param{Options} } : (),
        );
    };

    my $Error = $@;
    if ($Error) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error parsing XML: $Error",
        );
        return;
    }

    return $PerlStructure;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
