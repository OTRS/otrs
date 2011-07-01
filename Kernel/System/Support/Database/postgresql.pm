# --
# Kernel/System/Support/Database/postgresql.pm - all required system information
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: postgresql.pm,v 1.1 2011-07-01 14:36:04 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Support::Database::postgresql;

use strict;
use warnings;

use Kernel::System::XML;
use Kernel::System::Time;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ConfigObject LogObject MainObject DBObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create additional objects
    $Self->{XMLObject}  = Kernel::System::XML->new( %{$Self} );
    $Self->{TimeObject} = Kernel::System::Time->new( %{$Self} );

    return $Self;
}

sub AdminChecksGet {
    my ( $Self, %Param ) = @_;

    # get names of available checks from sysconfig
    my $Checks = $Self->{ConfigObject}->Get('Support::Database::PostgreSQL');

    # find out which checks should are enabled in sysconfig
    my @EnabledCheckFunctions;
    if ( $Checks && ref $Checks eq 'HASH' ) {

        # get all enabled check function names
        @EnabledCheckFunctions = sort grep { $Checks->{$_} } keys %{$Checks};
    }

    # to store the result
    my @DataArray;

    FUNCTIONNAME:
    for my $FunctionName (@EnabledCheckFunctions) {

        # prepend an underscore
        $FunctionName = '_' . $FunctionName;

        # run function and get check data
        my $Check = $Self->$FunctionName();

        next FUNCTIONNAME if !$Check;

        # attach check data if valid
        push @DataArray, $Check;
    }

    return \@DataArray;
}

sub _TableCheck {
    my ( $Self, %Param ) = @_;

    my $Data = {};

    # table check
    my $File = $Self->{ConfigObject}->Get('Home') . '/scripts/database/otrs-schema.xml';
    if ( -f $File ) {
        my $Count   = 0;
        my $Check   = 'Failed';
        my $Message = '';
        my $Content = '';
        my $In;
        if ( open( $In, '<', $File ) ) {
            while (<$In>) {
                $Content .= $_;
            }
            close($In);
            my @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash( String => $Content );
            for my $Table ( @{ $XMLHash[1]->{database}->[1]->{Table} } ) {
                if ($Table) {
                    $Count++;
                    if (
                        $Self->{DBObject}->Prepare(
                            SQL   => "select * from $Table->{Name}",
                            Limit => 1
                        )
                        )
                    {
                        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                        }
                    }
                    else {
                        $Message .= "$Table->{Name}, ";
                    }
                }
            }
            if ($Message) {
                $Message = "nonexisting table(s): $Message.";
            }
            else {
                $Check   = 'OK';
                $Message = "$Count tables checked.";
            }
            $Data = {
                Name        => 'Table Check',
                Description => 'Check existing framework tables.',
                Comment     => $Message,
                Check       => $Check,
            };
        }
        else {
            $Data = {
                Name        => 'Table Check',
                Description => 'Check existing framework tables.',
                Comment     => "Can't open file $File: $!",
                Check       => 'Critical',
            };
        }
    }
    else {
        $Data = {
            Name        => 'Table Check',
            Description => 'Check existing framework tables.',
            Comment     => "Can't find file $File!",
            Check       => 'Critical',
        };
    }
    return $Data;
}

sub _DateStyleCheck {
    my ( $Self, %Param ) = @_;

    my $Data = {};

    # Datestyle check
    my $Check   = 'Failed';
    my $Message = 'No DateStyle found.';
    $Self->{DBObject}->Prepare( SQL => 'show all' );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Row[0] =~ /^DateStyle/i ) {
            if ( $Row[1] =~ /^ISO/i ) {
                $Check   = 'OK';
                $Message = "$Row[1]";
            }
            else {
                $Check   = 'Failed';
                $Message = "Unknown DateStyle ($Row[1]) need ISO.";
            }
        }
    }
    $Data = {
        Name        => 'DateStyle',
        Description => 'Check DateStyle.',
        Comment     => $Message,
        Check       => $Check,
        },
        return $Data;
}

sub _UTF8ServerCheck {
    my ( $Self, %Param ) = @_;

    my $Data = {};

    # utf-8 server check
    if ( $Self->{ConfigObject}->Get('DefaultCharset') =~ /utf(\-8|8)/i ) {
        my $Check   = 'Failed';
        my $Message = 'No server_encoding found.';
        $Self->{DBObject}->Prepare( SQL => 'show all' );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            if ( $Row[0] =~ /^server_encoding/i ) {
                $Message
                    = "Setting server_encoding found, but it's set to '$Row[1]' (need to be UNICODE or UTF8).";
                if ( $Row[1] =~ /(UNICODE|utf(8|\-8))/i ) {
                    $Check   = 'OK';
                    $Message = "$Row[1]";
                }
            }
        }
        $Data = {
            Name        => 'Server Connection (utf8)',
            Description => 'Check the utf8 server connection.',
            Comment     => $Message,
            Check       => $Check,
        };
    }
    return $Data;
}

sub _UTF8ClientCheck {
    my ( $Self, %Param ) = @_;

    my $Data = {};

    # utf-8 client check
    if ( $Self->{ConfigObject}->Get('DefaultCharset') =~ /utf(\-8|8)/i ) {
        my $Check   = 'Failed';
        my $Message = 'No client_encoding found.';
        $Self->{DBObject}->Prepare( SQL => 'show all' );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            if ( $Row[0] =~ /^client_encoding/i ) {
                $Message
                    = "Setting client_encoding found, but it's set to '$Row[1]' (need to be UNICODE or UTF8)";
                if ( $Row[1] =~ /(UNICODE|utf(8|\-8))/i ) {
                    $Check   = 'OK';
                    $Message = "$Row[1]";
                }
            }
        }
        $Data = {
            Name        => 'Client Connection (utf8)',
            Description => 'Check the utf8 client connection.',
            Comment     => $Message,
            Check       => $Check,
        };
    }
    return $Data;
}

sub _VersionCheck {
    my ( $Self, %Param ) = @_;

    my $Data = {};

    # version check
    my $Check   = 'Failed';
    my $Message = 'No PostgreSQL version found.';
    $Self->{DBObject}->Prepare( SQL => 'show server_version' );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Row[0] =~ /^(\d{1,3}).*$/ ) {
            if ( $1 > 7 ) {
                $Check   = 'OK';
                $Message = "PostgreSQL $Row[0]";
            }
            else {
                $Check   = 'Failed';
                $Message = "You use PostgreSQL version $Row[0], you should use 8.x or higner.";
            }
        }
        else {
            $Check   = 'Failed';
            $Message = "Unknown PostgreSQL version $Row[0].";
        }
    }
    $Data = {
        Name        => 'Version',
        Description => 'Check database version.',
        Comment     => $Message,
        Check       => $Check,
    };
    return $Data;
}

sub _CurrentTimestampCheck {
    my ( $Self, %Param ) = @_;
    my $Data   = {};
    my $DbTime = '';

    # Current Timestamp check
    my $Check   = '';
    my $Message = '';
    $Self->{DBObject}->Prepare( SQL => "SELECT current_timestamp" );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $DbTime = $Row[0];
    }
    my $TimeApplicationServer = $Self->{TimeObject}->SystemTime();
    my $TimeDatabaseServer    = $Self->{TimeObject}->TimeStamp2SystemTime(
        String => $DbTime,
    );

    my $TimeDifference = 0;
    my $Range          = 10;
    $TimeDifference = $TimeApplicationServer - $TimeDatabaseServer;
    if ( ( $TimeDifference >= ( $Range * -1 ) ) && ( $TimeDifference <= $Range ) ) {
        $Check = 'OK';
        $Message
            = 'There is no difference between application server time and database server time.';
    }
    else {
        $Check = 'Failed';
        $Message
            = 'There is a material difference ('
            . $TimeDifference
            . " seconds) between application server ($TimeApplicationServer) and database server ($TimeDatabaseServer) time.";
    }

    $Data = {
        Name        => 'Current Timestamp Check',
        Description => 'Check "System Time" vs "Current Timestamp".',
        Comment     => $Message,
        Check       => $Check,
    };
    return $Data;
}
1;
