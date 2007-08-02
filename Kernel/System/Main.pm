# --
# Kernel/System/Main.pm - main core components
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Main.pm,v 1.9 2007-08-02 11:31:42 martin Exp $
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
$VERSION = '$Revision: 1.9 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{Debug} = $Param{Debug} || 0;

    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
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
    my $Self = shift;
    my $Module = shift;
    if (!$Module) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need module!",
        );
    }
    if (eval "require $Module") {
        # log loaded module
        if ($Self->{Debug} > 1) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "Module: $Module loaded!",
            );
        }
        return 1;
    }
    else {
        # check if file name exists
        my $FileName = $Module.'.pm';
        $FileName =~ s/::/\//g;
        my $Error = 0;
        foreach my $Prefix (@INC) {
            my $File = "$Prefix/$FileName";
            if (-f $File) {
                $Error = $File;
                last;
            }
        }
        # if file name exists, show syntax error
        if ($Error) {
            my $R = do $Error;
            $Self->{LogObject}->Log(
                Caller => 1,
                Priority => 'error',
                Message => "$@",
            );
        }
        # if there is no file, show not found error
        else {
            $Self->{LogObject}->Log(
                Caller => 1,
                Priority => 'error',
                Message => "Module '$Module' not found!",
            );
        }
        return;
    }
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
    my $Self = shift;
    my %Param = @_;

    if (!$Param{Filename}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need Filename!"
        );
        return;
    }

    if ($Param{Type} && $Param{Type} =~ /^md5/i) {
        $Param{Filename} = md5_hex($Param{Filename});
    }
    # replace invalid token for attachment file names
    elsif ($Param{Type} && $Param{Type} =~ /^attachment/i) {
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
        if (length($Param{Filename}) > 100) {
            my $Ext = '';
            if ($Param{Filename} =~ /^.*(\.(...|....))$/) {
                $Ext = $1;
            }
            $Param{Filename} = substr($Param{Filename},0,95).$Ext;
        }
    }
    else {
        # replace invalid token like [ ] * : ? " < > ; | \ /
        $Param{Filename} =~ s/[<>\?":\\\*\|\/;\[\]]/_/g;
    }

    return $Param{Filename};
}

=item Die()

to die

    $MainObject->Die('some message to die');

=cut

sub Die {
    my $Self = shift;
    my %Param = @_;
    if ($Param{Message}) {
        $Self->{LogObject}->Log(
            Caller => 1,
            Priority => 'error',
            Message => "$Param{Message}",
        );
    }
    else {
        $Self->{LogObject}->Log(
            Caller => 1,
            Priority => 'error',
            Message => "Died!",
        );
    }
    exit;
}

=item FileRead()

to read files from file system

    my $ContentSCALARRef = $MainObject->FileRead(
        Directory => 'c:\some\location\',
        Filename => 'me_to/alal.xml',
    );

    my $ContentSCALARRef = $MainObject->FileRead(
        Directory => 'c:\some\location\',
        Filename => 'me_to/alal.xml',
        Mode => 'binmode', # optional - binmode|utf8
        Type => 'Local', # optional - Local|Attachment|MD5
        DisableWarnings => 1, # optional
    );

=cut

sub FileRead {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(Filename)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # filename clean up
    $Param{Filename} = $Self->FilenameCleanUp(
        Filename => $Param{Filename},
        Type => $Param{Type} || 'Local', # Local|Attachment|MD5
    );
    my $FileLocation = "$Param{Directory}/$Param{Filename}";
    # check if file exists
    if (!-e $FileLocation) {
        if (!$Param{DisableWarnings}) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "File '$FileLocation' doesn't exists!"
            );
        }
        return;
    }
    # open file
    my $Mode = '<';
    if ($Param{Mode} && $Param{Mode} =~ /^(utf8|utf\-8)/i) {
        $Mode = '<:utf8';
    }
    if (open (IN, $Mode, $FileLocation)) {
        # read whole file
        my $Data;
        if (!$Param{Mode} || $Param{Mode} =~ /^binmode/i) {
            binmode(IN);
        }
        while (my $Line = <IN>) {
            $Data .= $Line;
        }
        close (IN);
        return \$Data;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't open '$FileLocation': $!",
        );
        return;
    }
}

=item FileWrite()

to write files to file system

    my $FileLocation = $MainObject->FileWrite(
        Directory => 'c:\some\location\',
        Filename => 'me_to/alal.xml',
        Content => \$Content,
    );

    my $FileLocation = $MainObject->FileWrite(
        Directory => 'c:\some\location\',
        Filename => 'me_to/alal.xml',
        Content => \$Content,
        Mode => 'binmode', # binmode|utf8
        Type => 'Local', # optional - Local|Attachment|MD5
    );

=cut

sub FileWrite {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(Directory Filename)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # filename clean up
    $Param{Filename} = $Self->FilenameCleanUp(
        Filename => $Param{Filename},
        Type => $Param{Type} || 'Local', # Local|Attachment|MD5
    );
    my $FileLocation = "$Param{Directory}/$Param{Filename}";
    # open file
    my $Mode = '>';
    if ($Param{Mode} && $Param{Mode} =~ /^(utf8|utf\-8)/i) {
        $Mode = '>:utf8';
    }
    if (!open (OUT, $Mode, $FileLocation)) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't write '$FileLocation': $!",
        );
        return;
    }
    else {
        # read whole file
        if (!$Param{Mode} || $Param{Mode} =~ /^binmode/i) {
            binmode(OUT);
        }
        print OUT ${$Param{Content}};
        close (OUT);
        return $Param{Filename};
    }
}

=item FileDelete ()

to delete a file from file system

    my $Success = $MainObject->FileDelete(
        Directory => 'c:\some\location\',
        Filename => 'me_to/alal.xml',
        DisableWarnings => 1, # optional
    );

=cut

sub FileDelete {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(Directory Filename)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # filename clean up
    $Param{Filename} = $Self->FilenameCleanUp(
        Filename => $Param{Filename},
        Type => $Param{Type} || 'Local', # Local|Attachment|MD5
    );
    my $FileLocation = "$Param{Directory}/$Param{Filename}";
    # check if file exists
    if (! -e $FileLocation) {
        if (!$Param{DisableWarnings}) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "File '$FileLocation' dosn't exists!"
            );
        }
        return;
    }
    # delete file
    if (!unlink($FileLocation)) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't delete '$FileLocation': $!",
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
    my $Self = shift;
    my %Param = @_;
    if (!$Param{Filename} && !$Param{String}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Filename or String!");
        return;
    }
    # check if file exists
    if ($Param{Filename} && !-e $Param{Filename}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "File '$Param{Filename}' doesn't exists!"
        );
        return;
    }
    # md5sum file
    if ($Param{Filename}) {
        if (open(FILE, '<', $Param{Filename})) {
            binmode(FILE);
            my $MD5sum = Digest::MD5->new()->addfile(*FILE)->hexdigest();
            close(FILE);
            return $MD5sum;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Can't write '$Param{Filename}': $!",
            );
            return;
        }
    }
    # md5sum string
    if ($Param{String}) {
        if (ref($Param{String}) ne 'SCALAR') {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Need a SCALAR reference like 'String => \$Content' in String param.",
            );
            return;
        }
        else {
            $Self->{EncodeObject}->EncodeOutput($Param{String});
            return md5_hex(${$Param{String}});
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
    my $Self = shift;
    my $Data = shift;
    my $String;
    if (!defined($Data)) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need \$String in Dump()!");
        return;
    }
    # load Data::Dumper
    if (!$Self->Require('Data::Dumper')) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can not use Dump() without Data::Dumper!");
        return;
    }
    # mild pretty print
    $Data::Dumper::Indent = 1;
    # This Dump() is using Data::Dumer with a utf8 workarounds to handle
    # the bug [rt.cpan.org #28607] Data::Dumper::Dumper is dumping utf8
    # strings as latin1/8bit instead of utf8. Use Storable module used for
    # workaround.
    # -> http://rt.cpan.org/Ticket/Display.html?id=28607
    if ($Self->{ConfigObject}->Get('DefaultCharset') =~ /utf(8|\-8)/i && $Self->Require('Storable')) {
        # Clone the data because we need to disable the utf8 flag in all
        # reference variables and we want not to do this in the orig.
        # variables because this will still used in the system.
        my $DataNew = Storable::dclone(\$Data);
        # Disable utf8 flag.
        $Self->_Dump($DataNew);
        # Dump it as binary strings.
        $String = Data::Dumper::Dumper(${$DataNew});
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
    my $Self = shift;
    my $Data = shift;
    if (!ref(${$Data})) {
        Encode::_utf8_off(${$Data});
    }
    elsif (ref(${$Data}) eq 'SCALAR') {
        $Self->_Dump(${$Data});
    }
    elsif (ref(${$Data}) eq 'HASH') {
        foreach my $Key (keys %{${$Data}}) {
            if (defined(${$Data}->{$Key})) {
               $Self->_Dump(\${$Data}->{$Key});
            }
        }
    }
    elsif (ref(${$Data}) eq 'ARRAY') {
        foreach my $Key (0..$#{${$Data}}) {
            if (defined(${$Data}->[$Key])) {
                $Self->_Dump(\${$Data}->[$Key]);
            }
        }
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Unknown ref '".ref(${$Data})."'!",
        );
    }
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

$Revision: 1.9 $ $Date: 2007-08-02 11:31:42 $

=cut
