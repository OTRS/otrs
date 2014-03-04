#!/usr/bin/perl
# --
# bin/cgi-bin/rpc.pl - soap handle
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

use SOAP::Transport::HTTP;
use Kernel::System::ObjectManager;

use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::Queue;
use Kernel::System::CustomerUser;
use Kernel::System::CustomerCompany;
use Kernel::System::Ticket;
use Kernel::System::LinkObject;

SOAP::Transport::HTTP::CGI->dispatch_to('Core')->handle();

package Core;

sub new {
    my $Self = shift;

    my $Class = ref($Self) || $Self;
    bless {} => $Class;

    return $Self;
}

sub Dispatch {
    my ( $Self, $User, $Pw, $Object, $Method, %Param ) = @_;

    $User ||= '';
    $Pw   ||= '';
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        LogObject => {
            LogPrefix => 'OTRS-RPC',
        },
    );

    my %CommonObject = $Kernel::OM->ObjectHash(
        Objects => [qw(ConfigObject EncodeObject LogObject MainObject DBObject
                      PIDObject TimeObject UserObject GroupObject QueueObject
                      CustomerUserObject CustomerCompanyObject TicketObject
                      LinkObject)],
    );

    my $RequiredUser     = $CommonObject{ConfigObject}->Get('SOAP::User');
    my $RequiredPassword = $CommonObject{ConfigObject}->Get('SOAP::Password');

    if (
        !defined $RequiredUser
        || !length $RequiredUser
        || !defined $RequiredPassword || !length $RequiredPassword
        )
    {
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message  => "SOAP::User or SOAP::Password is empty, SOAP access denied!",
        );
        return;
    }

    if ( $User ne $RequiredUser || $Pw ne $RequiredPassword ) {
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message  => "Auth for user $User (pw $Pw) failed!",
        );
        return;
    }

    if ( !$CommonObject{$Object} ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "No such Object $Object!",
        );
        return "No such Object $Object!";
    }

    return $CommonObject{$Object}->$Method(%Param);
}

=item DispatchMultipleTicketMethods()

to dispatch multiple ticket methods and get the TicketID

    my $TicketID = $RPC->DispatchMultipleTicketMethods(
        $SOAP_User,
        $SOAP_Pass,
        'TicketObject',
        [ { Method => 'TicketCreate', Parameter => \%TicketData }, { Method => 'ArticleCreate', Parameter => \%ArticleData } ],
    );

=cut

sub DispatchMultipleTicketMethods {
    my ( $Self, $User, $Pw, $Object, $MethodParamArrayRef ) = @_;

    $User ||= '';
    $Pw   ||= '';

    # common objects
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        LogObject => {
            LogPrefix => 'OTRS-RPC',
        },
    );

    my %CommonObject = $Kernel::OM->ObjectHash(
        Objects => [qw(ConfigObject EncodeObject LogObject MainObject DBObject
                      PIDObject TimeObject UserObject GroupObject QueueObject
                      CustomerUserObject CustomerCompanyObject TicketObject
                      LinkObject)],
    );

    my $RequiredUser     = $CommonObject{ConfigObject}->Get('SOAP::User');
    my $RequiredPassword = $CommonObject{ConfigObject}->Get('SOAP::Password');

    if (
        !defined $RequiredUser
        || !length $RequiredUser
        || !defined $RequiredPassword || !length $RequiredPassword
        )
    {
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message  => "SOAP::User or SOAP::Password is empty, SOAP access denied!",
        );
        return;
    }

    if ( $User ne $RequiredUser || $Pw ne $RequiredPassword ) {
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message  => "Auth for user $User (pw $Pw) failed!",
        );
        return;
    }

    if ( !$CommonObject{$Object} ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "No such Object $Object!",
        );
        return "No such Object $Object!";
    }

    my $TicketID;
    my $Counter;

    for my $MethodParamEntry ( @{$MethodParamArrayRef} ) {

        my $Method    = $MethodParamEntry->{Method};
        my %Parameter = %{ $MethodParamEntry->{Parameter} };

        # push ticket id to params if there is no ticket id
        if ( !$Parameter{TicketID} && $TicketID ) {
            $Parameter{TicketID} = $TicketID;
        }

        my $ReturnValue = $CommonObject{$Object}->$Method(%Parameter);

        # remember ticket id if method was TicketCreate
        if ( !$Counter && $Object eq 'TicketObject' && $Method eq 'TicketCreate' ) {
            $TicketID = $ReturnValue;
        }

        $Counter++;
    }

    return $TicketID;
}

1;
