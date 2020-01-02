# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Base;

use strict;
use warnings;

use utf8;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

=head1 NAME

Kernel::Output::HTML::Base - Base class for Output classes

=head1 DESCRIPTION

    package Kernel::Output::HTML::ToolBar::MyToolBar;
    use parent 'Kernel::Output::HTML::Base';

    # methods go here

=head1 PUBLIC INTERFACE

=head2 new()

Creates an object. Call it not on this class, but on a subclass.

    use Kernel::Output::HTML::ToolBar::MyToolBar;
    my $Object = Kernel::Output::HTML::ToolBar::MyToolBar->new(
        UserID  => 123,
    );

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
