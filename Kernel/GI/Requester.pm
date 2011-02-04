# --
# Kernel/GI/Requester.pm - GenericInterface Requester handler
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Requester.pm,v 1.2 2011-02-04 11:30:55 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GI::Requester;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::GI::Requester

=head1 SYNOPSIS

GenericInterface handler for sending web service requests to remote providers.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GI::Requester;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $RequesterObject = Kernel::GI::Requester->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(MainObject ConfigObject LogObject EncodeObject TimeObject DBObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item Run()

receives the current incoming web service request, handles it,
and returns an appropriate answer based on the configured requested
web service.

    my $Result = $RequesterObject->Run(
        WebserviceID     => 1,                      # ID of the configured remote web service to use OR
        WebserviceConfig => {                       # Web service configuration data (optional, WebserviceID or WebserviceConfig must be passed)
            ...
        },
        Invoker          => 'Nagios::TicketLocked', # Name of the Invoker to be used for sending the request
        Data             => {                       # Data payload for the Invoker request (remote webservice)
            ...
        },
    );

    $Result = {
        Success         => 1,   # 0 or 1
        ErrorMessage    => '',  # if an error occurred
        Data            => {    # Data payload of Invoker result (web service response)
            ...
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    #TODO: implement

}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2011-02-04 11:30:55 $

=cut
