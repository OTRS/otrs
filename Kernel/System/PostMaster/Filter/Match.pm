# --
# Kernel/System/PostMaster/Filter/Match.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::Match;

use strict;
use warnings;

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

    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(JobConfig GetParam)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get config options
    my %Config;
    my %Match;
    my %Set;
    my $StopAfterMatch;
    if ( $Param{JobConfig} && ref $Param{JobConfig} eq 'HASH' ) {
        %Config = %{ $Param{JobConfig} };
        if ( $Config{Match} ) {
            %Match = %{ $Config{Match} };
        }
        if ( $Config{Set} ) {
            %Set = %{ $Config{Set} };
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
    for ( sort keys %Match ) {

        # match only email addresses
        if ( $Param{GetParam}->{$_} && $Match{$_} =~ /^EMAILADDRESS:(.*)$/ ) {
            my $SearchEmail    = $1;
            my @EmailAddresses = $Self->{ParserObject}->SplitAddressLine(
                Line => $Param{GetParam}->{$_},
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
                    if ( $Self->{Debug} > 1 ) {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'debug',
                            Message  => "$Prefix'$Param{GetParam}->{$_}' =~ /$Match{$_}/i matched!",
                        );
                    }
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
        elsif ( $Param{GetParam}->{$_} && $Param{GetParam}->{$_} =~ /$Match{$_}/i ) {

            # don't lose older match values if more than one header is
            # used for matching.
            $Matched = 1;
            if ($1) {
                $MatchedResult = $1;
            }
            if ( $Self->{Debug} > 1 ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'debug',
                    Message  => "$Prefix'$Param{GetParam}->{$_}' =~ /$Match{$_}/i matched!",
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
    return 1;
}

1;
