# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::Filter::Match;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get parser object
    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject!";

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(JobConfig GetParam)) {
        if ( !$Param{$_} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::Match',
                Value         => "Need $_!",
            );
            return;
        }
    }

    # get config options
    my %Config;
    my @Match;
    my @Set;
    my $StopAfterMatch;
    if ( $Param{JobConfig} && ref $Param{JobConfig} eq 'HASH' ) {
        %Config = %{ $Param{JobConfig} };

        if ( IsArrayRefWithData( $Config{Match} ) ) {
            @Match = @{ $Config{Match} };
        }
        elsif ( IsHashRefWithData( $Config{Match} ) ) {
            for my $Key ( sort keys %{ $Config{Match} } ) {
                push @Match, {
                    Key   => $Key,
                    Value => $Config{Match}->{$Key},
                };
            }
        }

        if ( IsArrayRefWithData( $Config{Set} ) ) {
            @Set = @{ $Config{Set} };
        }
        elsif ( IsHashRefWithData( $Config{Set} ) ) {

            for my $Key ( sort keys %{ $Config{Set} } ) {
                push @Set, {
                    Key   => $Key,
                    Value => $Config{Set}->{$Key},
                };
            }
        }
        $StopAfterMatch = $Config{StopAfterMatch} || 0;
    }

    my $Prefix = '';
    if ( $Config{Name} ) {
        $Prefix = "Filter: '$Config{Name}' ";
    }

    # match 'Match => ???' stuff
    my $Matched       = '';
    my $MatchedNot    = 0;
    my $MatchedResult = '';
    for my $Index ( 0 .. ( scalar @Match ) - 1 ) {
        my $Key   = $Match[$Index]->{Key};
        my $Value = $Match[$Index]->{Value};

        # match only email addresses
        if ( $Param{GetParam}->{$Key} && $Value =~ /^EMAILADDRESS:(.*)$/ ) {
            my $SearchEmail    = $1;
            my @EmailAddresses = $Self->{ParserObject}->SplitAddressLine(
                Line => $Param{GetParam}->{$Key},
            );
            my $LocalMatched;
            RECIPIENTS:
            for my $Recipients (@EmailAddresses) {

                my $Email = $Self->{ParserObject}->GetEmailAddress( Email => $Recipients );

                if ( $Email =~ /^$SearchEmail$/i ) {

                    $LocalMatched = 1;

                    if ($SearchEmail) {
                        $MatchedResult = $SearchEmail;
                    }
                    $Self->{CommunicationLogObject}->ObjectLog(
                        ObjectLogType => 'Message',
                        Priority      => 'Debug',
                        Key           => 'Kernel::System::PostMaster::Filter::Match',
                        Value         => "$Prefix'$Param{GetParam}->{$Key}' =~ /$Value/i matched!",
                    );

                    last RECIPIENTS;
                }
            }
            if ( !$LocalMatched ) {
                $MatchedNot = 1;
            }
            else {
                $Matched = 1;
            }
        }

        # match string
        elsif ( $Param{GetParam}->{$Key} && $Param{GetParam}->{$Key} =~ /$Value/i ) {

            # don't lose older match values if more than one header is
            # used for matching.
            $Matched = 1;

            if ($1) {
                $MatchedResult = $1;
            }

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::Filter::Match',
                Value         => "$Prefix'$Param{GetParam}->{$Key}' =~ /$Value/i matched!",
            );
        }
        else {

            $MatchedNot = 1;

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::Filter::Match',
                Value         => "$Prefix'$Param{GetParam}->{$Key}' =~ /$Value/i matched NOT!",
            );
        }
    }

    # should I ignore the incoming mail?
    if ( $Matched && !$MatchedNot ) {

        for my $SetItem (@Set) {
            my $Key   = $SetItem->{Key};
            my $Value = $SetItem->{Value};
            $Value =~ s/\[\*\*\*\]/$MatchedResult/;
            $Param{GetParam}->{$Key} = $Value;

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Notice',
                Key           => 'Kernel::System::PostMaster::Filter::Match',
                Value => $Prefix . "Set param '$Key' to '$Value' (Message-ID: $Param{GetParam}->{'Message-ID'})",
            );
        }

        # stop after match
        if ($StopAfterMatch) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Notice',
                Key           => 'Kernel::System::PostMaster::Filter::Match',
                Value         => $Prefix
                    . "Stopped filter processing because of used 'StopAfterMatch' (Message-ID: $Param{GetParam}->{'Message-ID'})",
            );
            return 1;
        }
    }
    return 1;
}

1;
