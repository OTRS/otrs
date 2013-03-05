# --
# NumberGenerator.t - ticket module testscript
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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
        
        for my $TicketHook (qw(Ticket# Tickétø# Reg$Ex*Special+Chars)) {

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
    
                # Simple test: find ticket number in subject
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
    
                my $TicketNumberFound = $TicketObject->GetTNByString($Subject);
    
                $Self->Is(
                    $TicketNumberFound,
                    $TicketNumber,
                    "$Backend - $TicketSubjectFormat - $Count - GetTNByString",
                );
    
                # More complex test: find ticket number in string with both ticket numbers
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
