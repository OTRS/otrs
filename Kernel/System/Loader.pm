# --
# Kernel/System/Loader.pm - CSS/JavaScript loader backend
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: Loader.pm,v 1.3 2010-05-26 12:18:50 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Loader;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

use Kernel::System::CacheInternal;

use CSS::Minifier qw();
use JavaScript::Minifier qw();

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
    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;

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

    my $LoaderObject = Kernel::System::Loader->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject EncodeObject LogObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %{$Self},
        Type => 'Loader',
        TTL  => 60 * 60 * 3,
    );

    return $Self;
}

=item GetMinifiedFile()

returns the minified contents of a given CSS or JavaScript file.
Uses caching internally.

    my $MinifiedCSS = $LoaderObject->GetMinifiedFile(
        Location => $Filename,
        Type     => 'CSS',      # CSS | JavaScript
    );

=cut

sub GetMinifiedFile {
    my ( $Self, %Param ) = @_;

    my $Location = $Param{Location};
    if ( !$Location ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Location!",
        );
        return;
    }

    my %ValidTypeParams = (
        CSS        => 1,
        JavaScript => 1,
    );

    if ( !$Param{Type} || !$ValidTypeParams{ $Param{Type} } ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need Type! Must be one of '" . join( ', ', keys %ValidTypeParams ) . "'."
        );
        return;
    }

    my $FileMTime = $Self->{MainObject}->FileGetMTime(
        Location => $Location
    );

    my $CacheKey = "$Location:$FileMTime";

    # check if a cached version exists
    my $CacheContent = $Self->{CacheInternalObject}->Get(
        Key => $CacheKey
    );

    if ( ref $CacheContent eq 'SCALAR' ) {
        return ${$CacheContent};
    }

    # no cache available, read and minify file
    my $FileContents = $Self->{MainObject}->FileRead(
        Location => $Location
    );

    if ( ref $FileContents ne 'SCALAR' ) {
        return;
    }

    my $Result = $Self->MinifyCSS( Code => $$FileContents );

    # and put it in the cache
    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \$Result,
    );

    return $Result;
}

=item MinifyCSS()

returns a minified version of the given CSS Code

    my $MinifiedCSS = $LoaderObject->MinifyCSS(Code => $CSS);

=cut

sub MinifyCSS {
    my ( $Self, %Param ) = @_;

    my $Code = $Param{Code} || '';

    my $Result = CSS::Minifier::minify( input => $Code );

    # a few optimizations can be made for the minified CSS that CSS::Minifier doesn't yet do

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

$Revision: 1.3 $ $Date: 2010-05-26 12:18:50 $

=cut
