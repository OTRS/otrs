# --
# Kernel/System/Loader.pm - CSS/JavaScript loader backend
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: Loader.pm,v 1.2 2010-05-21 13:05:57 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Loader;

use strict;
use warnings;

#use Kernel::System::CacheInternal;
use CSS::Minifier qw();
use JavaScript::Minifier qw();

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::Loader - CSS/JavaScript loader backend

=head1 SYNOPSIS

All valid functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::Loader;

    my $LoaderObject = Kernel::System::Loader->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    #    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
    #        %{$Self},
    #        Type => 'Valid',
    #        TTL  => 60 * 60 * 3,
    #    );

    return $Self;
}

=item MinifyCSS()

returns a minified version of the given CSS Code

    my $MinifiedCSS = $LoaderObject->MinifyCSS(Code => $CSS);

=cut

sub MinifyCSS {
    my ( $Self, %Param ) = @_;

    my $Code = $Param{Code} || '';

    my $Result = CSS::Minifier::minify( input => $Code );

    #print "CSS::Minifier took ", Time::HiRes::tv_interval($time), " seconds.\n\n";

    #
    # a few optimizations can be made for the minified CSS that CSS::Minifier doesn't yet do
    #
    # remove remaining linebreaks
    $Result =~ s/\r?\n\s*//smxg;

    # remove superfluous whitespace after commas in chained selectors
    $Result =~ s/,\s*/,/smxg;

    return $Result;
}

=item MinifyJavaScript()

returns a minified version of the given JavaScript Code

    my $MinifiedJS = $LoaderObject->MinifyJavaScript(Code => $JavaScript);

=cut

sub MinifyJavaScript {
    my ( $Self, %Param ) = @_;

    my $Code = $Param{Code} || '';

    my $Result = JavaScript::Minifier::minify( input => $Code );

    return $Result;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2010-05-21 13:05:57 $

=cut
