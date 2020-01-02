# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::Filter::SMIMEFetchFromCustomer;

use strict;
use warnings;

use Kernel::System::EmailParser;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Crypt::SMIME',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    # Get parser object.
    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject!";

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(JobConfig GetParam)) {
        if ( !$Param{$Needed} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::SMIMEFetchFromCustomer',
                Value         => "Need $Needed!",
            );
            return;
        }
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    return 1 if !$ConfigObject->Get('SMIME');
    return 1 if !$ConfigObject->Get('SMIME::FetchFromCustomer');

    my $CryptObject;
    eval {
        $CryptObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');
    };
    return 1 if !$CryptObject;

    my @EmailAddressOnField = $Self->{ParserObject}->SplitAddressLine(
        Line => $Self->{ParserObject}->GetParam( WHAT => 'From' ),
    );

    my $IncomingMailAddress;

    for my $EmailAddress (@EmailAddressOnField) {
        $IncomingMailAddress = $Self->{ParserObject}->GetEmailAddress(
            Email => $EmailAddress,
        );
    }

    return 1 if !$IncomingMailAddress;

    my @Files = $CryptObject->FetchFromCustomer(
        Search => $IncomingMailAddress,
    );

    return 1;
}

1;
