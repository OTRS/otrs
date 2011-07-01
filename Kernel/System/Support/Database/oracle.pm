# --
# Kernel/System/Support/Database/oracle.pm - all required system information
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: oracle.pm,v 1.1 2011-07-01 14:36:04 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Support::Database::oracle;

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
    my $Checks = $Self->{ConfigObject}->Get('Support::Database::Oracle');

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

sub _OracleHomeCheck {
    my ( $Self, %Param ) = @_;

    my $Data = {};

    # check ORACLE_HOME
    my $Check   = 'Failed';
    my $Message = 'No ORACLE_HOME setting found.';
    if ( $ENV{ORACLE_HOME} ) {
        if ( !-e $ENV{ORACLE_HOME} ) {
            $Message = "ORACLE_HOME don't exists ($ENV{ORACLE_HOME}).";
            $Check   = 'Failed';
        }
        else {
            $Message = "Your ORACLE_Home configuration is $ENV{ORACLE_HOME}.";
            $Check   = 'OK';
        }
    }
    $Data = {
        Name        => 'ORACLE_HOME',
        Description => "Check ORACLE_HOME configuration.",
        Comment     => $Message,
        Check       => $Check,
    };
    return $Data;
}

sub _NLSLangCheck {
    my ( $Self, %Param ) = @_;

    # check NLS_LANG
    my $Check   = 'Failed';
    my $Message = 'No NLS_LANG configuration found.';
    if ( $ENV{NLS_LANG} ) {
        if ( $Self->{ConfigObject}->Get('DefaultCharset') =~ /utf(\-8|8)/i ) {
            if ( $ENV{NLS_LANG} !~ /utf(\-8|8)/ ) {
                $Message = "$ENV{NLS_LANG}, need .utf8 in NLS_LANG (e. g. german_germany.utf8).";
                $Check   = 'Failed';
            }
            else {
                $Message = "Your NLS_LANG configuration is $ENV{NLS_LANG}.";
                $Check   = 'OK';
            }
        }
        else {
            $Message = "Your NLS_LANG configuration is $ENV{NLS_LANG}";
            $Check   = 'OK';
        }
    }
    my $Data = {
        Name        => 'NLS_LANG',
        Description => "Check NLS_LANG.",
        Comment     => $Message,
        Check       => $Check,
    };
    return $Data;
}

sub _NLSDateFormatCheck {
    my ( $Self, %Param ) = @_;

    # check NLS_DATE_FORMAT
    my $Check   = 'Failed';
    my $Message = 'No NLS_DATE_FORMAT setting found.';
    if ( $ENV{NLS_DATE_FORMAT} ) {
        if ( $ENV{NLS_DATE_FORMAT} ne "YYYY-MM-DD HH24:MI:SS" ) {
            $Message
                = "Need format 'YYYY-MM-DD HH24:MI:SS' for NLS_DATE_FORMAT (not $ENV{NLS_DATE_FORMAT}).";
            $Check = 'Failed';
        }
        else {
            $Message = "Your NLS_DATE_FORMAT setting is $ENV{NLS_DATE_FORMAT}.";
            $Check   = 'OK';
        }
    }
    my $Data = {
        Name        => 'NLS_DATE_FORMAT',
        Description => "Check NLS_DATE_FORMAT.",
        Comment     => $Message,
        Check       => $Check,
    };
    return $Data;
}

sub _NLSDateFormatSelectCheck {
    my ( $Self, %Param ) = @_;

    # check NLS_DATE_FORMAT
    my $Check   = 'Failed';
    my $Message = 'NLS_DATE_FORMAT seems to be wrong';
    my $CreateTime;

    $Self->{DBObject}->Prepare( SQL => "SELECT create_time FROM valid", Limit => 1 );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $CreateTime = $Row[0];
    }

    if ($CreateTime) {
        if ( $CreateTime !~ /^\d\d\d\d-(\d|\d\d)-(\d|\d\d)\s(\d|\d\d):(\d|\d\d):(\d|\d\d)/ ) {
            $Message
                = "$CreateTime is not the right format 'yyyy-mm-dd hh:mm::ss' (please check \$ENV{NLS_DATE_FORMAT}).";
            $Check = 'Failed';
        }
        else {
            $Message = "NLS_DATE_Format has the right format ($CreateTime).";
            $Check   = 'OK';
        }
    }
    my $Data = {
        Name        => 'NLS_DATE_SELECT_FORMAT',
        Description => "Check NLS_DATE_FORMAT by using SELECT statement.",
        Comment     => $Message,
        Check       => $Check,
    };
    return $Data;
}

sub _TableCheck {
    my ( $Self, %Param ) = @_;

    my $Data = {};

    # table check
    my $File = $Self->{ConfigObject}->Get('Home') . "/scripts/database/otrs-schema.xml";
    if ( -f $File ) {
        my $Count   = 0;
        my $Check   = 'Failed';
        my $Message = '';
        my $Content = '';
        my $In;
        if ( open( $In, '<', "$File" ) ) {
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
                $Message = "Table don't exists: $Message.";
            }
            else {
                $Check   = 'OK';
                $Message = "$Count tables checked.";
            }
            $Data = {
                Name        => 'Table Check',
                Description => "Check existing framework tables.",
                Comment     => $Message,
                Check       => $Check,
            };
        }
        else {
            $Data = {
                Name        => 'Table Check',
                Description => "Check existing framework tables.",
                Comment     => "Can't open file $File: $!",
                Check       => 'Critical',
            };
        }
    }
    else {
        $Data = {
            Name        => 'Table Check',
            Description => "Check existing framework tables.",
            Comment     => "Can't find file $File!",
            Check       => 'Critical',
        };
    }
    return $Data;
}

sub _CurrentTimestampCheck {
    my ( $Self, %Param ) = @_;
    my $Data   = {};
    my $DbTime = '';

    # Current Timestamp check
    my $Check   = '';
    my $Message = '';
    $Self->{DBObject}
        ->Prepare( SQL => "SELECT to_char(current_timestamp,'YYYY-MM-DD HH24:MI:SS') FROM DUAL" );
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
