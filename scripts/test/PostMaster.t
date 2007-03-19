# --
# PostMaster.t - PostMaster tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: PostMaster.t,v 1.1 2007-03-19 22:27:19 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::PostMaster::LoopProtection;
use Kernel::System::PostMaster;
use Kernel::System::Ticket;

$Self->{TicketObject} = Kernel::System::Ticket->new(%{$Self});

foreach my $Module (qw(DB FS)) {
    $Self->{ConfigObject}->Set(
        Key => 'LoopProtectionModule',
        Value => "Kernel::System::PostMaster::LoopProtection::$Module",
    );

    $Self->{LoopProtectionObject} = Kernel::System::PostMaster::LoopProtection->new(%{$Self});

    # get rand sender address
    my $UserRand1 = 'example-user'.int(rand(1000000)).'@example.com';

    my $Check = $Self->{LoopProtectionObject}->Check(
        To => $UserRand1,
    );

    $Self->True(
        $Check || 0,
        "#$Module - Check() - $UserRand1",
    );

    foreach (1..42) {
        my $SendEmail = $Self->{LoopProtectionObject}->SendEmail(
            To => $UserRand1,
        );
        $Self->True(
            $SendEmail || 0,
            "#$Module - SendEmail() - #$_ ",
        );
    }

    $Check = $Self->{LoopProtectionObject}->Check(
        To => $UserRand1,
    );

    $Self->False(
        $Check || 0,
        "#$Module - Check() - $UserRand1",
    );
}

# get rand sender address
my $UserRand1 = 'example-user'.int(rand(1000000)).'@example.com';
foreach my $File (1..2) {
    # new ticket check
    my @Content = ();
    open(IN, "< ".$Self->{ConfigObject}->Get('Home')."/scripts/test/sample/PostMaster-Test$File.box") || die $!;
    binmode(IN);
    while (my $Line = <IN>) {
        if ($Line =~ /^From:/) {
            $Line = "From: \"Some Realname\" <$UserRand1>\n";
        }
        push (@Content, $Line);
    }
    close(IN);

    # follow up check
    my @ContentNew = ();
    foreach my $Line (@Content) {
        push (@ContentNew, $Line);
    }

    $Self->{PostMasterObject} = Kernel::System::PostMaster->new(
        %{$Self},
        Email => \@Content,
    );

    my @Return = $Self->{PostMasterObject}->Run();
    $Self->Is(
        $Return[0] || 0,
        1,
        "#$File Run() - NewTicket",
    );
    $Self->True(
        $Return[1] || 0,
        "#$File Run() - NewTicket/TicketID",
    );
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Return[1]);
    @Content = ();
    foreach my $Line (@ContentNew) {
        if ($Line =~ /^Subject:/) {
            $Line = 'Subject: '.$Self->{TicketObject}->TicketSubjectBuild(
                TicketNumber => $Ticket{TicketNumber},
                Subject => $Line,
            );
        }
        push (@Content, $Line);
    }
    $Self->{PostMasterObject} = Kernel::System::PostMaster->new(
        %{$Self},
        Email => \@Content,
    );
    @Return = $Self->{PostMasterObject}->Run();
    $Self->Is(
        $Return[0] || 0,
        2,
        "#$File Run() - FollowUp",
    );
    $Self->True(
        $Return[1] || 0,
        "#$File Run() - FollowUp/TicketID",
    );
    $Self->{TicketObject}->StateSet(
        State => 'closed successful',
        TicketID => $Return[1],
        UserID => 1,
    );

}
1;
