# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Diff;

use strict;
use warnings;

use Text::Diff::HTML;
use Text::Diff::FormattedHTML;

# Prevent used once warning.
use Kernel::System::ObjectManager;

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Diff - Compare two strings and display difference

=head1 DESCRIPTION

Compare two strings and display difference.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $DiffObject = $Kernel::OM->Get('Kernel::System::Diff');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Compare()
Compare two strings and return diff.

    $DiffObject->Compare(
        Source => 'String 1',       # (required) String
        Target => 'String 2',       # (required) String
    );

    Result:
    my %Diff = (
        HTML  => '<table class="DataTable diff">
<tr class=\'change\'><td><em>1</em></td><td><em>1</em></td><td>Test <del>1</del></td><td>Test <ins>2</ins></td></tr>
</table>
',
        Plain => '<div class="file"><span class="fileheader"></span><div class="hunk"><span class="hunkheader">@@ -1 +1 @@
</span><del>- Test 1</del><ins>+ Test 2</ins><span class="hunkfooter"></span></div><span class="filefooter"></span></div>'
        },
    );

=cut

sub Compare {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Source Target)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Result;

    # Get HTML diff.
    $Result{HTML} = diff_strings( { vertical => 0 }, $Param{Source}, $Param{Target} );

    # Find the table class(es) and add the OTRS DataTable class.
    $Result{HTML} =~ s{class='diff'}{class="DataTable diff"}xmsg;

    # Add <span>'s to <td>'s.
    $Result{HTML} =~ s{<td>(\d+)<\/td>}{<td><em>$1</em></td>}xmsg;
    $Result{HTML} =~ s{<td>(.[^<]*)<\/td>}{<td><span>$1</span></td>}xmsg;

    # Get plain diff.
    $Result{Plain} = Text::Diff::diff( \$Param{Source}, \$Param{Target}, { STYLE => "Text::Diff::HTML" } );

    return %Result;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
