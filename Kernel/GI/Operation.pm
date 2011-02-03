# --
# Kernel/GI/Operation.pm - GenericInterface operation interface
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Operation.pm,v 1.1 2011-02-03 13:31:13 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GI::Operation;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::GI::Operation

=head1 SYNOPSIS

GenericInterface data Operation interface.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. This will return the Operation backend for the specified Operation.

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GI::Operation;

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
    my $OperationObject = Kernel::GI::Operation->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,

        Operation => 'Ticket::TicketCreate',    # the local operation to use
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    #my $Self = {};
    #bless( $Self, $Type );

    # check needed objects
    #for (qw(MainObject ConfigObject LogObject EncodeObject TimeObject DBObject)) {
    #    $Self->{$_} = $Param{$_} || die "Got no $_!";
    #}

    # TODO: implement backend loading and returning

    return;
}

=item Run()

perform Operation

    my $Result = $OperationObject->Run(
        Data => {                               # data payload before Operation
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # result data payload after Operation
            ...
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    #TODO implement

}

=item _Auth()

helper function which authenticates Agents or Customers.
This function is used by the different Operations.

    my $UserID = $ControllerObject->_Auth(
        Type     => 'Agent',    # Agent or Customer
        Username => 'User',
        Password => 'PW',
        TTL      => 60*60*24,   # TTL for caching of successful logins
    );

Returns UserID (for Agents), CustomerUserID (for Customers), or undef
(on authentication failure).

=cut

sub _Auth {
    my ( $Self, %Param ) = @_;

    # TODO decide if this function may need to be moved somewhere else

    # TODO implement

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

$Revision: 1.1 $ $Date: 2011-02-03 13:31:13 $

=cut
