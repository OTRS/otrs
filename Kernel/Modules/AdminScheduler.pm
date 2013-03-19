# --
# Kernel/Modules/AdminScheduler.pm - Utilities for scheduler
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminScheduler;

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

    my $Output;

    # show result site
    if ( $Self->{Subaction} eq 'Start' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # set home directory
        my $Home = $Self->{ConfigObject}->Get('Home');

        # set scheduler program (for *Nix or Win32)
        my $Scheduler = $Home . '/bin/otrs.Scheduler.pl';
        if ( $^O =~ /^mswin/i ) {
            $Scheduler = "\"$^X\" " . $Home . '/bin/otrs.Scheduler4win.pl';
            $Scheduler =~ s{/}{\\}g
        }

        # set force start parameter
        my $ForceStart = $Self->{ParamObject}->GetParam( Param => 'ForceStart' );

        # start scheduler from the command line
        my $Success = system("$Scheduler -a start $ForceStart");

        # invert system call return code to be like in standard perl functions
        $Success = !$Success;

        # build JSON output
        my $JSON = $Self->{LayoutObject}->JSONEncode(
            Data => {
                Success => $Success,
            },
        );

        # send JSON response
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );

    }
    elsif ( $Self->{Subaction} eq 'AJAX' ) {

        # html search mask output
        $Self->{LayoutObject}->Block(
            Name => 'StartAJAX',
            Data => {
                %Param,
            },
        );

        my $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminScheduler',
            Data         => \%Param,
        );
        return $Self->{LayoutObject}->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Charset     => $Self->{LayoutObject}->{UserCharset},
            Content     => $Output,
            Type        => 'inline'
        );
    }

    # show dialog in a white screen
    $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Self->{LayoutObject}->Block(
        Name => 'Search',
        Data => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminScheduler',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
