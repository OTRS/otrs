# --
# Config.pl - Config file for OpenTRS kernel
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Config.pm,v 1.3 2001-12-05 20:32:08 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
 
package Kernel::Config;

use strict;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.3 $';
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
    $Self->{DEBUG} = 0;

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

    # -data-
    # system ID
    $Self->{SystemID} = 10; 
    # full qualified domain name of your system
    $Self->{FQDN} = 'avro.linuxatwork.de';
    # where is sendmail located
    $Self->{Sendmail} = '/usr/sbin/sendmail -t -f ';
    # send all outgoing email via bcc to
    $Self->{SendmailBcc} = '';
    # default queue of all
    $Self->{DefaultQueue} = 'Raw';

    # -DB settings-
    $Self->{DatabaseHost} = 'localhost';
    $Self->{Database} = 'OpenTRS';
    $Self->{DatabaseUser} = 'root';
    $Self->{DatabasePw} = '';
    $Self->{DatabaseDSN} = 'DBI:mysql';


    # -directories-
    # root directory
    $Self->{Home} = '/opt/OpenTRS';

    # directory for all sessen id informations
    $Self->{SessionDir} = $Self->{Home} . '/var/sessions';

    # -web stuff-
    # global CGI handle
    $Self->{CGIHandle} = 'index.pl';

}
# --
sub Get {
    my $Self = shift;
    my $What = shift;
    # debug
    if ($Self->{DEBUG} > 0) {
        $Self->{LogObject}->Log(
          Priority=>'debug', 
          MSG=>"->Get('$What') --> $Self->{$What}"
        );
    }

    # warn if the value is not def
    if (!$Self->{$What}) {
        $Self->{LogObject}->Log(
          Priority=>'error',
          MSG=>"No value for '$What' in Config.pm found!"
        );
    }
    return $Self->{$What};
}
# --

1;

