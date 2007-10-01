# --
# Kernel/System/Encode.pm - character encodings
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Encode.pm,v 1.21 2007-10-01 09:43:45 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Encode;

use strict;
use warnings;

use vars qw(@ISA $VERSION);

$VERSION = qw($Revision: 1.21 $) [1];

=head1 NAME

Kernel::System::Encode - character encodings

=head1 SYNOPSIS

This module will use Perl's Encode module (Perl 5.8.0 or higher required).
If the Perl version is lower then 5.8.0, no encoding will be possible. The
return string is still the same charset.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a language object

    use Kernel::Config;
    use Kernel::System::Encode;

    my $ConfigObject = Kernel::Config->new();

    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );

=cut

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # check needed objects
    for (qw(ConfigObject)) {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    # 0=off; 1=on;
    $Self->{Debug} = 0;

    # check if Perl 5.8.0 encode is available
    if ( eval "require Encode" ) {
        $Self->{CharsetEncodeSupported} = 1;
    }
    else {
        if ( $Self->{Debug} ) {
            print STDERR "Charset encode not supported withyour perl version!\n";
        }
    }

    # get internal charset
    if (   $Self->{CharsetEncodeSupported}
        && $Self->{ConfigObject}->Get('DefaultCharset') =~ /^utf(-8|8)$/i )
    {
        $Self->{UTF8Support} = 1;
    }

    # encode STDOUT and STDERR
    $Self->SetIO( \*STDOUT, \*STDERR );
    return $Self;
}

=item EncodeSupported()

Returns true or false if charset encoding is possible (depends on Perl version =< 5.8.0).

    if ($EncodeObject->EncodeSupported()) {
        print "Charset encoding is possible!\n";
    }
    else {
        print "Sorry, charset encoding is not possible!\n";
    }

=cut

sub EncodeSupported {
    my $Self = shift;
    return $Self->{CharsetEncodeSupported};
}

=item EncodeInternalUsed()

Returns the internal used charset if possible. E. g. if "EncodeSupported()"
is true and Kernel/Config.pm "DefaultCharset" is "utf-8", then utf-8 is
the internal charset. It returns false if no internal charset (utf-8) is
used.

    my $Charset = $EncodeObject->EncodeInternalUsed();

=cut

sub EncodeInternalUsed {
    my $Self = shift;
    if ( $Self->{UTF8Support} ) {
        return 'utf-8';
    }
    else {
        return;
    }
}

=item EncodeFrontendUsed()

Returns the used frontend charset if possible. E. g. if "EncodeSupported()"
is true and Kernel/Config.pm "DefaultCharset" is "utf-8", then utf-8 is
the frontend charset. It returns false if no frontend charset (utf-8) is
used (then the translation charset (from translation file) will be used).

    my $Charset = $EncodeObject->EncodeFrontendUsed();

=cut

sub EncodeFrontendUsed {
    my $Self = shift;
    if ( $Self->{UTF8Support} ) {
        return 'utf-8';
    }
    else {
        return;
    }
}

=item Convert()

Convert one charset to an other charset.

    my $utf8 = $EncodeObject->Convert(
        Text => $iso_8859_1_string,
        From => 'iso-8859-1',
        To => 'utf-8',
    );

    my $iso_8859_1 = $EncodeObject->Convert(
        Text => $utf-8_string,
        From => 'utf-8',
        To => 'iso-8859-1',
    );

There is also a Force => 1 option if you need to force the
already converted string.

=cut

sub Convert {
    my $Self  = shift;
    my %Param = @_;
    if ( !defined( $Param{Text} ) || $Param{Text} eq '' ) {
        return;
    }

    # check needed stuff
    for (qw(From To)) {
        if ( !defined( $Param{$_} ) ) {
            print STDERR "Need $_!\n";
            return;
        }
    }

    # if there is no charset encode supported (min. Perl 5.8.0)
    if ( !$Self->{CharsetEncodeSupported} ) {
        return $Param{Text};
    }

    # if no encode is needed
    if ( $Param{From} =~ /^$Param{To}$/i ) {
        if ( $Param{To} =~ /^utf(-8|8)/i ) {
            Encode::_utf8_on( $Param{Text} );
        }
        return $Param{Text};
    }

    # encode is needed
    else {
        if ( $Param{Force} ) {
            Encode::_utf8_off( $Param{Text} );
        }
        if ( !eval { Encode::from_to( $Param{Text}, $Param{From}, $Param{To} ) } ) {
            print STDERR
                "Charset encode '$Param{From}' -=> '$Param{To}' ($Param{Text}) not supported!\n";
        }
        else {

            # set utf-8 flag
            if ( $Param{To} =~ /^utf(8|-8)$/i ) {

                #                Encode::encode_utf8($Param{Text});
                Encode::_utf8_on( $Param{Text} );
            }
            if ( $Self->{Debug} ) {
                print STDERR "Charset encode '$Param{From}' -=> '$Param{To}' ($Param{Text})!\n";
            }
        }
        return $Param{Text};
    }
}

=item SetIO()

Set array of file handles to utf-8 output.

    $EncodeObject->SetIO(\*STDOUT, \*STDERR);

=cut

sub SetIO {
    my $Self  = shift;
    my @Array = @_;
    if (   $Self->{CharsetEncodeSupported}
        && $Self->EncodeFrontendUsed()
        && $Self->EncodeFrontendUsed() =~ /utf(-8|8)/i )
    {
        for (@Array) {
            if ( defined($_) && ref($_) eq 'GLOB' ) {
                binmode( $_, ":utf8" );
            }
        }
    }
    return;
}

=item Encode()

Convert internal used charset (e. g. utf-8) into given charset (utf-8), if
"EncodeInternalUsed()" returns one. Should be used on all I/O interfaces
if data is already utf-8.

    $EncodeObject->Encode(\$String);

=cut

sub Encode {
    my $Self = shift;
    my $What = shift;

    # internel charset
    if (   $Self->{CharsetEncodeSupported}
        && $Self->EncodeFrontendUsed()
        && $Self->EncodeFrontendUsed() =~ /utf(-8|8)/i )
    {
        if ( defined($What) && ref($What) eq 'ARRAY' ) {
            for my $I ( @{$What} ) {
                if ( defined($I) ) {
                    $I = Encode::decode_utf8($I);
                    Encode::_utf8_on($I);
                }
            }
        }
        elsif ( defined($What) && ref($What) eq 'SCALAR' ) {
            if ( defined( ${$What} ) ) {
                ${$What} = Encode::decode_utf8( ${$What} );
                Encode::_utf8_on( ${$What} );
            }
        }
        elsif ( defined($What) ) {
            $What = Encode::decode_utf8($What);
            Encode::_utf8_on($What);
        }
    }
    return $What;
}

=item Decode()

Convert given charset into the internal used charset (utf-8), if
"EncodeInternalUsed()" returns one. Should be used on all I/O interfaces.

    my $String = $EncodeObject->Decode(
        Text => $String,
        From => $SourceCharset,
    );

=cut

sub Decode {
    my $Self  = shift;
    my %Param = @_;
    if ( !defined $Param{Text} ) {
        return;
    }

    # check needed stuff
    for (qw(From)) {
        if ( !defined( $Param{$_} ) ) {
            print STDERR "Need $_!\n";
            return;
        }
    }

    # internel charset
    if ( $Self->EncodeInternalUsed() ) {
        return $Self->Convert( %Param, To => $Self->EncodeInternalUsed() );
    }
    else {
        return $Param{Text};
    }
}

=item EncodeOutput()

Convert utf8 to a sequence of octets. All possible characters have
a UTF-8 representation so this function cannot fail.

This should be used in for output of utf8 chars.

    $EncodeObject->EncodeOutput(\$String);

=cut

sub EncodeOutput {
    my $Self = shift;
    my $What = shift;

    # internel charset
    if (   $Self->{CharsetEncodeSupported}
        && $Self->EncodeFrontendUsed()
        && $Self->EncodeFrontendUsed() =~ /utf(-8|8)/i )
    {
        if ( Encode::is_utf8( ${$What} ) ) {
            ${$What} = Encode::encode_utf8( ${$What} );
        }
    }
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.21 $ $Date: 2007-10-01 09:43:45 $

=cut
