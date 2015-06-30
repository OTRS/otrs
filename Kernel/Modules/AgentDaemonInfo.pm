# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentDaemonInfo;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # set home directory
    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my %Data = (
        DaemonCron     => $Home . '/var/cron/otrs_daemon',
        CronExecutable => $Home . '/bin/Cron.sh',
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentDaemonInfo',
        Data         => {
            %Param,
            %Data,
        },
    );
    return $LayoutObject->Attachment(
        NoCache     => 1,
        ContentType => 'text/html',
        Charset     => $LayoutObject->{UserCharset},
        Content     => $Output,
        Type        => 'inline'
    );
}

1;
