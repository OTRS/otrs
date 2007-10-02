# --
# Kernel/System/Main.pm - main core components
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Main.pm,v 1.15 2007-10-02 10:38:58 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Main;

use strict;
use warnings;
use Digest::MD5 qw(md5_hex);
use Kernel::System::Encode;
use Data::Dumper;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.15 $) [1];

=head1 NAME

Kernel::System::Main - main object

=head1 SYNOPSIS

All main functions to load modules or to die.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create new object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get common objects
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    for (qw(ConfigObject LogObject)) {
        die "Got no $_" if ( !$Self->{$_} );
    }

    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    return $Self;
}

=item Require()

require/load a module

    my $Loaded = $MainObject->Require('Kernel::System::Example');

=cut

sub Require {
    my ( $Self, $Module ) = @_;

    my $Result = 0;
    if ( !$Module ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need module!',
        );
    }
    $Module =~ s/::/\//g;
    $Module .= '.pm';

    # check if module is already loaded
    if ( exists $INC{$Module} ) {

        # just return if it's already loaded
        if ( $INC{$Module} ) {
            return 1;
        }

        # if was not possible to load, log it
        else {
            $Self->{LogObject}->Log(
                Caller   => 1,
                Priority => 'error',
                Message  => "Compilation failed in require!",
            );
            return;
        }
    }

    # find full path of module
    for my $Prefix (@INC) {
        my $File = $Prefix . '/' . $Module;
        if ( -f $File ) {
            $INC{$Module} = $File;
            $Result = do $File;
            last;
        }
    }

    # if there was an error
    if ($@) {
        $INC{$Module} = undef;
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => "$@",
        );
        return;
    }

    # return true if module is loaded
    elsif ($Result) {

        # log loaded module
        if ( $Self->{Debug} > 1 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "Module: $Module loaded!",
            );
        }
        return 1;
    }

    # if there is no file, show not found error
    else {
        delete $INC{$Module};
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => "Module $Module not found!",
        );
        return;
    }
}

=item Die()

to die

    $MainObject->Die('some message to die');

=cut

sub Die {
    my ( $Self, %Param ) = @_;

    if ( $Param{Message} ) {
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => "$Param{Message}",
        );
    }
    else {
        $Self->{LogObject}->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => "Died!",
        );
    }
    exit;
}

=item FilenameCleanUp()

to clean up filenames which can be used in any case (also quoting is done)

    my $Filename = $MainObject->FilenameCleanUp(
        Filename => 'me_to/alal.xml',
        Type => 'Local', # Local|Attachment|MD5
    );

    my $Filename = $MainObject->FilenameCleanUp(
        Filename => 'some:file.xml',
        Type => 'MD5', # Local|Attachment|MD5
    );

=cut

sub FilenameCleanUp {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Filename} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Filename!"
        );
        return;
    }

    if ( $Param{Type} && $Param{Type} =~ /^md5/i ) {
        $Param{Filename} = md5_hex( $Param{Filename} );
    }

    # replace invalid token for attachment file names
    elsif ( $Param{Type} && $Param{Type} =~ /^attachment/i ) {

        # replace invalid token like < > ? " : ; | \ / or *
        $Param{Filename} =~ s/[ <>\?":\\\*\|\/;\[\]]/_/g;

        # replace utf8 and iso
        $Param{Filename} =~ s/(\x{00C3}\x{00A4}|\x{00A4})/ae/g;
        $Param{Filename} =~ s/(\x{00C3}\x{00B6}|\x{00B6})/oe/g;
        $Param{Filename} =~ s/(\x{00C3}\x{00BC}|\x{00FC})/ue/g;
        $Param{Filename} =~ s/(\x{00C3}\x{009F}|\x{00C4})/Ae/g;
        $Param{Filename} =~ s/(\x{00C3}\x{0096}|\x{0096})/Oe/g;
        $Param{Filename} =~ s/(\x{00C3}\x{009C}|\x{009C})/Ue/g;
        $Param{Filename} =~ s/(\x{00C3}\x{009F}|\x{00DF})/ss/g;
        $Param{Filename} =~ s/-+/-/g;

        # cut the string if too long
        if ( length( $Param{Filename} ) > 100 ) {
            my $Ext = '';
            if ( $Param{Filename} =~ /^.*(\.(...|....))$/ ) {
                $Ext = $1;
            }
            $Param{Filename} = substr( $Param{Filename}, 0, 95 ) . $Ext;
        }
    }
    else {

        # replace invalid token like [ ] * : ? " < > ; | \ /
        $Param{Filename} =~ s/[<>\?":\\\*\|\/;\[\]]/_/g;
    }

    return $Param{Filename};
}

=item FileRead()

to read files from file system

    my $ContentSCALARRef = $MainObject->FileRead(
        Directory => 'c:\some\location',
        Filename => 'me_to/alal.xml',
        # or Location
        Location => 'c:\some\location\me_to\alal.xml'
    );

    my $ContentARRAYRef = $MainObject->FileRead(
        Directory => 'c:\some\location',
        Filename => 'me_to/alal.xml',
        # or Location
        Location => 'c:\some\location\me_to\alal.xml'

        Result => 'ARRAY', # optional - SCALAR|ARRAY
    );

    my $ContentSCALARRef = $MainObject->FileRead(
        Directory => 'c:\some\location',
        Filename => 'me_to/alal.xml',
        # or Location
        Location => 'c:\some\location\me_to\alal.xml'

        Mode => 'binmode', # optional - binmode|utf8
        Type => 'Local', # optional - Local|Attachment|MD5
        Result => 'SCALAR', # optional - SCALAR|ARRAY
        DisableWarnings => 1, # optional
    );

=cut

sub FileRead {
    my ( $Self, %Param ) = @_;

    my $FH;
    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename => $Param{Filename},
            Type     => $Param{Type} || 'Local',    # Local|Attachment|MD5
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s/\/\//\//g;
    }
    else {
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => "Need Filename and Directory or Location!" );

    }

    # check if file exists
    if ( !-e $Param{Location} ) {
        if ( !$Param{DisableWarnings} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "File '$Param{Location}' doesn't exists!"
            );
        }
        return;
    }

    # open file
    my $Mode = '<';
    if ( $Param{Mode} && $Param{Mode} =~ /^(utf8|utf\-8)/i ) {
        $Mode = '<:utf8';
    }
    if ( open( $FH, $Mode, $Param{Location} ) ) {

        # read whole file
        my @Array;
        my $String;
        if ( !$Param{Mode} || $Param{Mode} =~ /^binmode/i ) {
            binmode($FH);
        }
        while ( my $Line = <$FH> ) {
            if ( $Param{Result} && $Param{Result} eq 'ARRAY' ) {
                push( @Array, $Line );
            }
            else {
                $String .= $Line;

            }
        }
        close($FH);
        if ( $Param{Result} && $Param{Result} eq 'ARRAY' ) {
            return \@Array;
        }
        else {
            return \$String;
        }
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't open '$Param{Location}': $!",
        );
        return;
    }
}

=item FileWrite()

to write data to file system

    my $FileLocation = $MainObject->FileWrite(
        Directory => 'c:\some\location',
        Filename => 'me_to/alal.xml',
        # or Location
        Location => 'c:\some\location\me_to\alal.xml'

        Content => \$Content,
    );

    my $FileLocation = $MainObject->FileWrite(
        Directory => 'c:\some\location',
        Filename => 'me_to/alal.xml',
        # or Location
        Location => 'c:\some\location\me_to\alal.xml'

        Content => \$Content,
        Mode => 'binmode', # binmode|utf8
        Type => 'Local', # optional - Local|Attachment|MD5
        Permission => '644', # unix file permissions
    );

=cut

sub FileWrite {
    my ( $Self, %Param ) = @_;

    my $FH;
    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename => $Param{Filename},
            Type     => $Param{Type} || 'Local',    # Local|Attachment|MD5
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s/\/\//\//g;
    }
    else {
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => "Need Filename and Directory or Location!" );

    }

    # open file
    my $Mode = '>';
    if ( $Param{Mode} && $Param{Mode} =~ /^(utf8|utf\-8)/i ) {
        $Mode = '>:utf8';
    }
    if ( !open( $FH, $Mode, $Param{Location} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't write '$Param{Location}': $!",
        );
        return;
    }
    else {

        # read whole file
        if ( !$Param{Mode} || $Param{Mode} =~ /^binmode/i ) {
            binmode($FH);
        }
        print $FH ${ $Param{Content} };
        close($FH);

        # set permission
        if ( $Param{Permission} ) {
            if ( length( $Param{Permission} ) == 3 ) {
                $Param{Permission} = "0$Param{Permission}";
            }
            chmod( oct( $Param{Permission} ), $Param{Location} );
        }
        if ( $Param{Filename} ) {
            return $Param{Filename};
        }
        else {
            return $Param{Location};
        }
    }
}

=item FileDelete()

to delete a file from file system

    my $Success = $MainObject->FileDelete(
        Directory => 'c:\some\location',
        Filename => 'me_to/alal.xml',
        # or Location
        Location => 'c:\some\location\me_to\alal.xml'

        DisableWarnings => 1, # optional
    );

=cut

sub FileDelete {
    my ( $Self, %Param ) = @_;

    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename => $Param{Filename},
            Type     => $Param{Type} || 'Local',    # Local|Attachment|MD5
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s/\/\//\//g;
    }
    else {
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => "Need Filename and Directory or Location!" );

    }

    # check if file exists
    if ( !-e $Param{Location} ) {
        if ( !$Param{DisableWarnings} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "File '$Param{Location}' dosn't exists!"
            );
        }
        return;
    }

    # delete file
    if ( !unlink( $Param{Location} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't delete '$Param{Location}': $!",
        );
        return;
    }
    else {
        return 1;
    }
}

=item MD5sum()

get a md5 sum of a file or an string

    my $MD5Sum = $MainObject->MD5sum(
        Filename => '/path/to/me_to_alal.xml',
    );

    my $MD5Sum = $MainObject->MD5sum(
        String => \$SomeString,
    );

=cut

sub MD5sum {
    my ( $Self, %Param ) = @_;

    my $FH;
    if ( !$Param{Filename} && !$Param{String} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Filename or String!" );
        return;
    }

    # check if file exists
    if ( $Param{Filename} && !-e $Param{Filename} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "File '$Param{Filename}' doesn't exists!"
        );
        return;
    }

    # md5sum file
    if ( $Param{Filename} ) {
        if ( open( $FH, '<', $Param{Filename} ) ) {
            binmode($FH);
            my $MD5sum = Digest::MD5->new()->addfile($FH)->hexdigest();
            close($FH);
            return $MD5sum;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't write '$Param{Filename}': $!",
            );
            return;
        }
    }

    # md5sum string
    if ( $Param{String} ) {
        if ( ref( $Param{String} ) ne 'SCALAR' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need a SCALAR reference like 'String => \$Content' in String param.",
            );
            return;
        }
        else {
            $Self->{EncodeObject}->EncodeOutput( $Param{String} );
            return md5_hex( ${ $Param{String} } );
        }
    }
}

=item Dump()

dump variable to an string

    my $Dump = $MainObject->Dump(
        $SomeVariable,
    );

    my $Dump = $MainObject->Dump(
        {
            Key1 => $SomeVariable,
        },
    );

=cut

sub Dump {
    my ( $Self, $Data ) = @_;

    my $String;
    if ( !defined($Data) ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need \$String in Dump()!" );
        return;
    }

    # mild pretty print
    $Data::Dumper::Indent = 1;

    # This Dump() is using Data::Dumer with a utf8 workarounds to handle
    # the bug [rt.cpan.org #28607] Data::Dumper::Dumper is dumping utf8
    # strings as latin1/8bit instead of utf8. Use Storable module used for
    # workaround.
    # -> http://rt.cpan.org/Ticket/Display.html?id=28607
    if (   $Self->{ConfigObject}->Get('DefaultCharset') =~ /utf(8|\-8)/i
        && $Self->Require('Storable') )
    {

        # Clone the data because we need to disable the utf8 flag in all
        # reference variables and we want not to do this in the orig.
        # variables because this will still used in the system.
        my $DataNew = Storable::dclone( \$Data );

        # Disable utf8 flag.
        $Self->_Dump($DataNew);

        # Dump it as binary strings.
        $String = Data::Dumper::Dumper( ${$DataNew} );

        # Enable utf8 flag.
        Encode::_utf8_on($String);
    }

    # fallback if Storable can not be loaded
    else {
        $String = Data::Dumper::Dumper($Data);
    }

    return $String;
}

sub _Dump {
    my ( $Self, $Data ) = @_;

    if ( !ref( ${$Data} ) ) {
        Encode::_utf8_off( ${$Data} );
    }
    elsif ( ref( ${$Data} ) eq 'SCALAR' ) {
        $Self->_Dump( ${$Data} );
    }
    elsif ( ref( ${$Data} ) eq 'HASH' ) {
        for my $Key ( keys %{ ${$Data} } ) {
            if ( defined( ${$Data}->{$Key} ) ) {
                $Self->_Dump( \${$Data}->{$Key} );
            }
        }
    }
    elsif ( ref( ${$Data} ) eq 'ARRAY' ) {
        for my $Key ( 0 .. $#{ ${$Data} } ) {
            if ( defined( ${$Data}->[$Key] ) ) {
                $Self->_Dump( \${$Data}->[$Key] );
            }
        }
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Unknown ref '" . ref( ${$Data} ) . "'!",
        );
    }
    return;
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

$Revision: 1.15 $ $Date: 2007-10-02 10:38:58 $

=cut
