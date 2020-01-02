# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentSchedulerInfo;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (
        qw(ParamObject LayoutObject LogObject ConfigObject MainObject)
        )
    {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # set home directory
    my $Home = $Self->{ConfigObject}->Get('Home');

    my %Data = (
        WatchdogCron   => $Home . '/var/cron/scheduler_watchdog',
        CronExecutable => $Home . '/bin/Cron.sh',
    );

    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentSchedulerInfo',
        Data         => {
            %Param,
            %Data,
        },
    );
    return $Self->{LayoutObject}->Attachment(
        NoCache     => 1,
        ContentType => 'text/html',
        Charset     => $Self->{LayoutObject}->{UserCharset},
        Content     => $Output,
        Type        => 'inline'
    );
}

1;
