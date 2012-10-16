# --
# NumberGenerator.t - ticket module testscript
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: NumberGenerator.t,v 1.3 2012-10-16 09:54:10 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::Ticket;

# create local objects
my $ConfigObject = Kernel::Config->new();

# check all number generators
for my $Backend (qw(AutoIncrement Date DateChecksum Random)) {
    $ConfigObject->Set(
        Key   => 'Ticket::NumberGenerator',
        Value => 'Kernel::System::Ticket::Number::' . $Backend,
    );

    # check subject formats
    for my $TicketSubjectFormat (qw(Left Right)) {
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectFormat',
            Value => $TicketSubjectFormat,
        );

        my $TicketObject = Kernel::System::Ticket->new(
            %{$Self},
            ConfigObject => $ConfigObject,
        );

        for my $Count ( 1 .. 100 ) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();

            $Self->True(
                scalar $TicketNumber,
                "$Backend - $TicketSubjectFormat - $Count - TicketCreateNumber() - result $TicketNumber",
            );

            my $Subject = $TicketObject->TicketSubjectBuild(
                TicketNumber => $TicketNumber,
                Subject      => 'Test',
            );

            $Self->True(
                scalar $Subject,
                "$Backend - $TicketSubjectFormat - $Count - TicketSubjectBuild() - result $Subject",
            );

            my $TicketNumberFound = $TicketObject->GetTNByString($Subject);

            $Self->Is(
                $TicketNumberFound,
                $TicketNumber,
                "$Backend - $TicketSubjectFormat - $Count - GetTNByString",
            );
        }
    }
}

1;
