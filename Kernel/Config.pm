# --
# Config.pl - Config file for OpenTRS kernel
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Config.pm,v 1.1 2001-12-02 14:35:39 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
 
package Kernel::Config;

use strict;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.1 $ ';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    # get Log Object
    $Self->{LogObject} = $Param{LogObject};

    # 0=off; 1=on;
    $Self->{DEBUG} = 1;

    # load config
    $Self->Load();
    return $Self;
}
# --
sub Load {
    my $Self = shift;
    # debug
    if ($Self->{DEBUG} > 0) {
        $Self->{LogObject}->Log(Priority=>'debug', MSG=>'Kernel::Config->Load()');
    }

    # data

    # full qualified domain name of your system
    $Self->{FQDN} = 'avro.linuxatwork.de';
    # where is sendmail located
    $Self->{Sendmail} = '/usr/sbin/sendmail -t -f ';
    # send all outgoing email via bcc to
    $Self->{SendmailBcc} = '';
    # default queue of all
    $Self->{DefaultQueue} = 'Raw';

}
# --
sub Get {
    my $Self = shift;
    my $What = shift;
    # debug
    if ($Self->{DEBUG} > 0) {
        $Self->{LogObject}->Log(
          Priority=>'debug', 
          MSG=>"Kernel::Config->Get('$What') --> $Self->{$What}"
        );
    }
    return $Self->{$What};
}
# --

1;

