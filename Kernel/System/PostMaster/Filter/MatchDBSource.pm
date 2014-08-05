# --
# Kernel/System/PostMaster/Filter/MatchDBSource.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::MatchDBSource;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::EmailParser',
    'Kernel::System::Log',
    'Kernel::System::PostMaster::Filter',
);
our $ObjectManagerAware = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(JobConfig GetParam)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get postmaster filter object
    my $PostMasterFilter = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');

    # get all db filters
    my %JobList = $PostMasterFilter->FilterList();

    for ( sort keys %JobList ) {

        # get config options
        my %Config = $PostMasterFilter->FilterGet( Name => $_ );

        my %Match;
        my %Set;
        if ( $Config{Match} ) {
            %Match = %{ $Config{Match} };
        }
        if ( $Config{Set} ) {
            %Set = %{ $Config{Set} };
        }
        my $StopAfterMatch = $Config{StopAfterMatch} || 0;
        my $Prefix = '';
        if ( $Config{Name} ) {
            $Prefix = "Filter: '$Config{Name}' ";
        }

        # get email parser object
        my $EmailParserObject = $Kernel::OM->Get('Kernel::System::EmailParser');

        # match 'Match => ???' stuff
        my $Matched       = '';
        my $MatchedNot    = 0;
        my $MatchedResult = '';
        for ( sort keys %Match ) {

            # match only email addresses
            if ( defined $Param{GetParam}->{$_} && $Match{$_} =~ /^EMAILADDRESS:(.*)$/ ) {
                my $SearchEmail    = $1;
                my @EmailAddresses = $EmailParserObject->SplitAddressLine(
                    Line => $Param{GetParam}->{$_},
                );
                my $LocalMatched;
                RECIPIENT:
                for my $Recipients (@EmailAddresses) {
                    my $Email = $EmailParserObject->GetEmailAddress( Email => $Recipients );
                    next RECIPIENT if !$Email;
                    if ( $Email =~ /^$SearchEmail$/i ) {
                        $LocalMatched = 1;
                        if ($SearchEmail) {
                            $MatchedResult = $SearchEmail;
                        }
                        if ( $Self->{Debug} > 1 ) {
                            $Kernel::OM->Get('Kernel::System::Log')->Log(
                                Priority => 'debug',
                                Message =>
                                    "$Prefix'$Param{GetParam}->{$_}' =~ /$Match{$_}/i matched!",
                            );
                        }
                        last RECIPIENT;
                    }
                }
                if ( !$LocalMatched ) {
                    $MatchedNot = 1;
                }
                else {
                    $Matched = 1;
                }

                # switch MatchedNot and $Matched
                if ( $Config{Not}->{$_} ) {
                    $MatchedNot ^= 1;
                    $Matched    ^= 1;
                }
            }

            # match string
            elsif (
                defined $Param{GetParam}->{$_} &&
                (
                    ( !$Config{Not}->{$_} && $Param{GetParam}->{$_} =~ m{$Match{$_}}i )
                    ||
                    ( $Config{Not}->{$_} && $Param{GetParam}->{$_} !~ m{$Match{$_}}i )
                )
                )
            {

                # don't lose older match values if more than one header is
                # used for matching.
                $Matched = 1;
                if ($1) {
                    $MatchedResult = $1;
                }

                if ( $Self->{Debug} > 1 ) {
                    my $Op = $Config{Not}->{$_} ? '!' : "=";

                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'debug',
                        Message =>
                            "successful $Prefix'$Param{GetParam}->{$_}' $Op~ /$Match{$_}/i !",
                    );
                }
            }
            else {
                $MatchedNot = 1;
                if ( $Self->{Debug} > 1 ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'debug',
                        Message  => "$Prefix'$Param{GetParam}->{$_}' =~ /$Match{$_}/i matched NOT!",
                    );
                }
            }
        }

        # should I ignore the incoming mail?
        if ( $Matched && !$MatchedNot ) {
            for ( sort keys %Set ) {
                $Set{$_} =~ s/\[\*\*\*\]/$MatchedResult/;
                $Param{GetParam}->{$_} = $Set{$_};
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message  => $Prefix
                        . "Set param '$_' to '$Set{$_}' (Message-ID: $Param{GetParam}->{'Message-ID'}) ",
                );
            }

            # stop after match
            if ($StopAfterMatch) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message  => $Prefix
                        . "Stopped filter processing because of used 'StopAfterMatch' (Message-ID: $Param{GetParam}->{'Message-ID'}) ",
                );
                return 1;
            }
        }
    }
    return 1;
}

1;
