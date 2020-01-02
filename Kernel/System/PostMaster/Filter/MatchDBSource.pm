# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::Filter::MatchDBSource;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::PostMaster::Filter',
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
                Key           => 'Kernel::System::PostMaster::Filter::MatchDBSource',
                Value         => "Need $_!",
            );
            return;
        }
    }

    # get postmaster filter object
    my $PostMasterFilter = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');

    # get all db filters
    my %JobList = $PostMasterFilter->FilterList();

    for ( sort keys %JobList ) {

        my %NamedCaptures;

        # get config options
        my %Config = $PostMasterFilter->FilterGet( Name => $_ );

        my @Match;
        my @Set;
        if ( $Config{Match} ) {
            @Match = @{ $Config{Match} };
        }
        if ( $Config{Set} ) {
            @Set = @{ $Config{Set} };
        }
        my $StopAfterMatch = $Config{StopAfterMatch} || 0;
        my $Prefix         = '';
        if ( $Config{Name} ) {
            $Prefix = "Filter: '$Config{Name}' ";
        }

        # match 'Match => ???' stuff
        my $Matched       = 0;    # Numbers are required because of the bitwise or in the negation.
        my $MatchedNot    = 0;
        my $MatchedResult = '';
        for my $Index ( 0 .. ( scalar @Match ) - 1 ) {
            my $Key   = $Match[$Index]->{Key};
            my $Value = $Match[$Index]->{Value};

            # match only email addresses
            if ( defined $Param{GetParam}->{$Key} && $Value =~ /^EMAILADDRESS:(.*)$/ ) {
                my $SearchEmail    = $1;
                my @EmailAddresses = $Self->{ParserObject}->SplitAddressLine(
                    Line => $Param{GetParam}->{$Key},
                );
                my $LocalMatched = 0;
                RECIPIENT:
                for my $Recipients (@EmailAddresses) {

                    my $Email = $Self->{ParserObject}->GetEmailAddress( Email => $Recipients );

                    next RECIPIENT if !$Email;

                    if ( $Email =~ /^$SearchEmail$/i ) {

                        $LocalMatched = 1;

                        if ($SearchEmail) {
                            $MatchedResult = $SearchEmail;
                            $NamedCaptures{email} = $SearchEmail;
                        }

                        $Self->{CommunicationLogObject}->ObjectLog(
                            ObjectLogType => 'Message',
                            Priority      => 'Debug',
                            Key           => 'Kernel::System::PostMaster::Filter::MatchDBSource',
                            Value         => "$Prefix'$Param{GetParam}->{$Key}' =~ /$Value/i matched!",
                        );

                        last RECIPIENT;
                    }
                }

                # Switch LocalMatched if Config has a negation.
                if ( $Config{Not}->[$Index]->{Value} ) {
                    $LocalMatched = !$LocalMatched;
                }

                if ( !$LocalMatched ) {
                    $MatchedNot = 1;
                }
                else {
                    $Matched = 1;
                }
            }

            # match string
            elsif (
                defined $Param{GetParam}->{$Key} &&
                (
                    ( !$Config{Not}->[$Index]->{Value} && $Param{GetParam}->{$Key} =~ m{$Value}i )
                    ||
                    ( $Config{Not}->[$Index]->{Value} && $Param{GetParam}->{$Key} !~ m{$Value}i )
                )
                )
            {

                # don't lose older match values if more than one header is
                # used for matching.
                $Matched = 1;
                if ($1) {
                    $MatchedResult = $1;
                }

                if (%+) {
                    my @Keys   = keys %+;
                    my @Values = values %+;

                    @NamedCaptures{@Keys} = @Values;
                }

                my $Op = $Config{Not}->[$Index]->{Value} ? '!' : "=";

                $Self->{CommunicationLogObject}->ObjectLog(
                    ObjectLogType => 'Message',
                    Priority      => 'Debug',
                    Key           => 'Kernel::System::PostMaster::Filter::MatchDBSource',
                    Value         => "successful $Prefix'$Param{GetParam}->{$Key}' $Op~ /$Value/i !",
                );
            }
            else {

                $MatchedNot = 1;

                $Self->{CommunicationLogObject}->ObjectLog(
                    ObjectLogType => 'Message',
                    Priority      => 'Debug',
                    Key           => 'Kernel::System::PostMaster::Filter::MatchDBSource',
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
                $Value =~ s/\[\*\* \\(\w+) \*\*\]/$NamedCaptures{$1}/xmsg;

                $Param{GetParam}->{$Key} = $Value;

                $Self->{CommunicationLogObject}->ObjectLog(
                    ObjectLogType => 'Message',
                    Priority      => 'Notice',
                    Key           => 'Kernel::System::PostMaster::Filter::MatchDBSource',
                    Value         => $Prefix
                        . "Set param '$Key' to '$Value' (Message-ID: $Param{GetParam}->{'Message-ID'}) ",
                );
            }

            # stop after match
            if ($StopAfterMatch) {
                $Self->{CommunicationLogObject}->ObjectLog(
                    ObjectLogType => 'Message',
                    Priority      => 'Notice',
                    Key           => 'Kernel::System::PostMaster::Filter::MatchDBSource',
                    Value         => $Prefix
                        . "Stopped filter processing because of used 'StopAfterMatch' (Message-ID: $Param{GetParam}->{'Message-ID'}) ",
                );
                return 1;
            }
        }
    }
    return 1;
}

1;
