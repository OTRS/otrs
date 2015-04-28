# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# check all number generators
for my $Backend (qw(AutoIncrement Date DateChecksum Random)) {

    # check subject formats
    for my $TicketSubjectFormat (qw(Left Right)) {

        # Make sure that the TicketObject gets recreated for each loop.
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );

        $ConfigObject->Set(
            Key   => 'Ticket::NumberGenerator',
            Value => 'Kernel::System::Ticket::Number::' . $Backend,
        );
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectFormat',
            Value => $TicketSubjectFormat,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        $Self->True(
            $TicketObject->isa( 'Kernel::System::Ticket::Number::' . $Backend ),
            "TicketObject loaded the correct backend",
        );

        for my $TicketHook ( 'Ticket#', 'Tickétø#', 'Reg$Ex*Special+Chars' ) {

            $ConfigObject->Set(
                Key   => 'Ticket::Hook',
                Value => $TicketHook,
            );

            for my $Count ( 1 .. 100 ) {

                # Produce a ticket number for a foreign system
                $ConfigObject->Set(
                    Key   => 'SystemID',
                    Value => '01',
                );

                my $ForeignTicketNumber = $TicketObject->TicketCreateNumber();

                $Self->True(
                    scalar $ForeignTicketNumber,
                    "$Backend - $TicketSubjectFormat - $Count - TicketCreateNumber() - result $ForeignTicketNumber",
                );

                # Now Produce a ticket number for our local system
                $ConfigObject->Set(
                    Key   => 'SystemID',
                    Value => '10',
                );
                my $TicketNumber = $TicketObject->TicketCreateNumber();

                $Self->True(
                    scalar $TicketNumber,
                    "$Backend - $TicketSubjectFormat - $Count - TicketCreateNumber() - result $TicketNumber",
                );

                #
                # Simple test: find ticket number in subject
                #
                my $Subject = $TicketObject->TicketSubjectBuild(
                    TicketNumber => $TicketNumber,
                    Subject      => 'Test',
                );

                $Self->True(
                    scalar $Subject,
                    "$Backend - $TicketSubjectFormat - $Count - TicketSubjectBuild() - result $Subject",
                );

                my $CleanSubject = $TicketObject->TicketSubjectClean(
                    TicketNumber => $TicketNumber,
                    Subject      => $Subject,
                );

                $Self->Is(
                    $CleanSubject,
                    'Test',
                    "$Backend - $TicketSubjectFormat - $Count - TicketSubjectClean() - result $CleanSubject",
                );

                #
                # Subject with spaces around ticket number
                #
                my $SubjectWithSpaces = $Subject;
                $SubjectWithSpaces =~ s{\[(.*)\]}{[ $1 ]};

                my $CleanSubjectFromSpaces = $TicketObject->TicketSubjectClean(
                    TicketNumber => $TicketNumber,
                    Subject      => $SubjectWithSpaces,
                );

                $Self->Is(
                    $CleanSubjectFromSpaces,
                    'Test',
                    "$Backend - $TicketSubjectFormat - $Count - TicketSubjectClean() - result $CleanSubject",
                );

                my $TicketNumberFound = $TicketObject->GetTNByString($Subject);

                $Self->Is(
                    $TicketNumberFound,
                    $TicketNumber,
                    "$Backend - $TicketSubjectFormat - $Count - GetTNByString",
                );

                #
                # Subject with spaces around ticket number
                #
                my $SubjectWithPrefix = $TicketObject->TicketSubjectBuild(
                    TicketNumber => $TicketNumber,
                    Subject      => 'GF: Test',
                );

                $Self->True(
                    scalar $SubjectWithPrefix,
                    "$Backend - $TicketSubjectFormat - $Count - TicketSubjectBuild() - result $Subject",
                );

                my $CleanSubjectWithPrefix = $TicketObject->TicketSubjectClean(
                    TicketNumber => $TicketNumber,
                    Subject      => $SubjectWithPrefix,
                );

                $Self->Is(
                    $CleanSubjectWithPrefix,
                    'GF: Test',
                    "$Backend - $TicketSubjectFormat - $Count - TicketSubjectClean() - result $CleanSubject",
                );

                #
                # More complex test: find ticket number in string with both ticket numbers
                #
                my $CombinedSubject = $TicketObject->TicketSubjectBuild(
                    TicketNumber => $ForeignTicketNumber,
                    Subject      => 'Test',
                );
                $CombinedSubject .= ' ' . $Subject;

                $TicketNumberFound = $TicketObject->GetTNByString($CombinedSubject);

                $Self->Is(
                    $TicketNumberFound,
                    $TicketNumber,
                    "$Backend - $TicketSubjectFormat - $Count - GetTNByString - $CombinedSubject",
                );
            }
        }
    }
}

1;
