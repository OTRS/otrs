# --
# Config.pm - Config file for OpenTRS kernel
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Config.pm,v 1.6 2001-12-23 13:31:56 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
 
package Kernel::Config;

use strict;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.6 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    # get Log Object
    $Self->{LogObject} = $Param{LogObject};

    # 0=off; 1=on;
    $Self->{Debug} = 0;

    # load config
    $Self->Load();
    return $Self;
}
# --
sub Load {
    my $Self = shift;
    # debug
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(Priority=>'debug', MSG=>'Kernel::Config->Load()');
    }

    # --
    # system data
    # --
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

    # --
    # DB settings
    # --
    # database host
    $Self->{DatabaseHost} = 'localhost';
    # database name
#    $Self->{Database} = 'OpenTRS';
    $Self->{Database} = 'otrs';
    # database user
    $Self->{DatabaseUser} = 'root';
    # password of database user
    $Self->{DatabasePw} = '';
    # database DNS
    $Self->{DatabaseDSN} = 'DBI:mysql';

    # --
    # default agent settings
    # --
    # default viewable tickets a page
    $Self->{ViewableTickets} = 25;
    # max viewable tickets a page
    $Self->{MaxLimit} = 150;
    # default reload time
    $Self->{Refresh} = 180;
    # highlight age 1 in min
    $Self->{HighlightAge1} = 27500;
    $Self->{HighlightColor1} = 'orange';
    # highlight age 2 in min
    $Self->{HighlightAge2} = 29160;
    $Self->{HighlightColor2} = 'red';

    # --
    # AgentUtil
    # --
    # default limit for Tn search
    $Self->{SearchLimitTn} = 20;
    # default limit for Txt search
    $Self->{SearchLimitTxt} = 20;


    # --
    # directories
    # --
    # root directory
    $Self->{Home} = '/opt/OpenTRS';
    # directory for all sessen id informations
    $Self->{SessionDir} = $Self->{Home} . '/var/sessions';
    # counter log
    $Self->{CounterLog} = $Self->{Home} . '/var/log/TicketCounter.log';
    # article fs dir
    $Self->{ArticleDir} = $Self->{Home} . '/var/article';

    # --
    # web stuff
    # --
    # global CGI handle
    $Self->{CGIHandle} = 'index.pl';

}
# --
sub Get {
    my $Self = shift;
    my $What = shift;
    # debug
    if ($Self->{Debug} > 0) {
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

