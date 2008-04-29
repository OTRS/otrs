# --
# PostMaster.t - PostMaster tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: PostMaster.t,v 1.8 2008-04-29 22:01:57 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use Kernel::System::PostMaster::LoopProtection;
use Kernel::System::PostMaster;
use Kernel::System::Ticket;

for my $Module (qw(DB FS)) {
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

    for (1..42) {
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

for my $NumberModule (qw(AutoIncrement DateChecksum Date Random)) {
    $Self->{ConfigObject}->Set(
        Key => 'Ticket::NumberGenerator',
        Value => "Kernel::System::Ticket::Number::$NumberModule",
    );
    for my $StorageModule (qw(ArticleStorageDB ArticleStorageFS)) {
        $Self->{ConfigObject}->Set(
            Key => 'Ticket::StorageModule',
            Value => "Kernel::System::Ticket::$StorageModule",
        );

        # get rand sender address
        my $UserRand1 = 'example-user'.int(rand(1000000)).'@example.com';

        for my $File (qw(1 2 3 5 6 11)) {

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
            for my $Line (@Content) {
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
                "#$NumberModule $StorageModule $File Run() - NewTicket",
            );
            $Self->True(
                $Return[1] || 0,
                "#$NumberModule $StorageModule $File Run() - NewTicket/TicketID",
            );

            # new/clear ticket object
            $Self->{TicketObject} = Kernel::System::Ticket->new(%{$Self});
            my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Return[1]);
            my @ArticleIDs = $Self->{TicketObject}->ArticleIndex(
                TicketID => $Return[1],
            );

            if ($File == 3) {
                # check body
                my %Article = $Self->{TicketObject}->ArticleGet(
                    ArticleID => $ArticleIDs[0],
                );
                my $MD5 = $Self->{MainObject}->MD5sum( String => $Article{Body} ) || '';
                $Self->Is(
                    $MD5,
                    'b50d85781d2ac10c210f99bf8142badc',
                    "#$NumberModule $StorageModule $File md5 body check",
                );

                # check attachments
                my %Index = $Self->{TicketObject}->ArticleAttachmentIndex(
                    ArticleID => $ArticleIDs[0],
                    UserID => 1,
                );
                my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                    ArticleID => $ArticleIDs[0],
                    FileID => 2,
                    UserID => 1,
                );
                $MD5 = $Self->{MainObject}->MD5sum( String => $Attachment{Content} ) || '';
                $Self->Is(
                    $MD5,
                    '4e78ae6bffb120669f50bca56965f552',
                    "#$NumberModule $StorageModule $File md5 attachment check",
                );

            }

            if ($File == 5) {
                # check body
                my %Article = $Self->{TicketObject}->ArticleGet(
                    ArticleID => $ArticleIDs[0],
                );
                my @Tests = (
                    {
                        Key    => 'TicketFreeKey1',
                        Result => 'Test',
                    },
                    {
                        Key    => 'TicketFreeText1',
                        Result => 'ABC',
                    },
                    {
                        Key    => 'TicketFreeKey2',
                        Result => 'Test2',
                    },
                    {
                        Key    => 'TicketFreeText2',
                        Result => 'ABC2',
                    },
                    {
                        Key    => 'TicketFreeTime1',
                        Result => '2008-01-12 13:14:00',
                    },
                    {
                        Key    => 'TicketFreeTime2',
                        Result => '2008-01-12 13:15:00',
                    },
                    {
                        Key    => 'TicketFreeTime3',
                        Result => '2008-01-12 13:16:00',
                    },
                    {
                        Key    => 'TicketFreeTime4',
                        Result => '2008-01-12 13:17:00',
                    },
                    {
                        Key    => 'TicketFreeTime5',
                        Result => '2008-01-12 13:18:00',
                    },
                    {
                        Key    => 'TicketFreeTime6',
                        Result => '2008-01-12 13:19:00',
                    },
                );
                for my $Test ( @Tests ) {
                    $Self->Is(
                        $Article{ $Test->{Key} } || '',
                        $Test->{Result} || '-',
                        "#$NumberModule $StorageModule $File $Test->{Key} check",
                    );
                }
            }

            if ($File == 6) {

                # check body
                my %Article = $Self->{TicketObject}->ArticleGet(
                    ArticleID => $ArticleIDs[0],
                );
                my $MD5 = $Self->{MainObject}->MD5sum( String => $Article{Body} ) || '';
                $Self->Is(
                    $MD5,
                    '2ac290235a8cad953a1837c77701c5dc',
                    "#$NumberModule $StorageModule $File md5 body check",
                );

                # check attachments
                my %Index = $Self->{TicketObject}->ArticleAttachmentIndex(
                    ArticleID => $ArticleIDs[0],
                    UserID => 1,
                );
                my $FileID = 4;
                if ($StorageModule eq 'ArticleStorageDB') {
                    $FileID = 2;
                }
                my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                    ArticleID => $ArticleIDs[0],
                    FileID => $FileID,
                    UserID => 1,
                );
                $MD5 = $Self->{MainObject}->MD5sum( String => $Attachment{Content} ) || '';
                $Self->Is(
                    $MD5,
                    '5ee767f3b68f24a9213e0bef82dc53e5',
                    "#$NumberModule $StorageModule $File md5 attachment check",
                );

            }
            if ($File == 11) {

                # check body
                my %Article = $Self->{TicketObject}->ArticleGet(
                    ArticleID => $ArticleIDs[0],
                );
                my $MD5 = $Self->{MainObject}->MD5sum( String => $Article{Body} ) || '';

                $Self->Is(
                    $MD5,
                    '52f20c90a1f0d8cf3bd415e278992001',
                    "#$NumberModule $StorageModule $File md5 body check",
                );
            }

            # send follow up #1
            @Content = ();
            for my $Line (@ContentNew) {
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
                "#$NumberModule $StorageModule $File Run() - FollowUp",
            );
            $Self->True(
                $Return[1] || 0,
                "#$NumberModule $StorageModule $File Run() - FollowUp/TicketID",
            );

            # new/clear ticket object
            $Self->{TicketObject} = Kernel::System::Ticket->new(%{$Self});
            %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Return[1]);
            $Self->Is(
                $Ticket{State} || 0,
                'new',
                "#$NumberModule $StorageModule $File Run() - FollowUp/State check",
            );
            my $StateSet = $Self->{TicketObject}->StateSet(
                State => 'pending reminder',
                TicketID => $Return[1],
                UserID => 1,
            );
            $Self->True(
                $StateSet || 0,
                "#$NumberModule $StorageModule $File StateSet() - pending reminder",
            );

            # send follow up #2
            @Content = ();
            for my $Line (@ContentNew) {
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
                "#$NumberModule $StorageModule $File Run() - FollowUp",
            );
            $Self->True(
                $Return[1] || 0,
                "#$NumberModule $StorageModule $File Run() - FollowUp/TicketID",
            );

            # send follow up #3
            @Content = ();
            for my $Line (@ContentNew) {
                if ($Line =~ /^Subject:/) {
                    $Line = 'Subject: '.$Self->{ConfigObject}->Get('Ticket::Hook').": $Ticket{TicketNumber}";
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
                "#$NumberModule $StorageModule $File Run() - FollowUp (Ticket::Hook#: xxxxxxxxxx)",
            );
            $Self->True(
                $Return[1] || 0,
                "#$NumberModule $StorageModule $File Run() - FollowUp/TicketID",
            );

            # send follow up #4
            @Content = ();
            for my $Line (@ContentNew) {
                if ($Line =~ /^Subject:/) {
                    $Line = 'Subject: '.$Self->{ConfigObject}->Get('Ticket::Hook').":$Ticket{TicketNumber}";
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
                "#$NumberModule $StorageModule $File Run() - FollowUp (Ticket::Hook#:xxxxxxxxxx)",
            );
            $Self->True(
                $Return[1] || 0,
                "#$NumberModule $StorageModule $File Run() - FollowUp/TicketID",
            );

            # send follow up #5
            @Content = ();
            for my $Line (@ContentNew) {
                if ($Line =~ /^Subject:/) {
                    $Line = 'Subject: '.$Self->{ConfigObject}->Get('Ticket::Hook')."$Ticket{TicketNumber}";
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
                "#$NumberModule $StorageModule $File Run() - FollowUp (Ticket::Hook#xxxxxxxxxx)",
            );
            $Self->True(
                $Return[1] || 0,
                "#$NumberModule $StorageModule $File Run() - FollowUp/TicketID",
            );

            # new/clear ticket object
            $Self->{TicketObject} = Kernel::System::Ticket->new(%{$Self});
            %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Return[1]);
            $Self->Is(
                $Ticket{State} || 0,
                'open',
                "#$NumberModule $StorageModule $File Run() - FollowUp/PostmasterFollowUpState check",
            );
            $StateSet = $Self->{TicketObject}->StateSet(
                State => 'closed successful',
                TicketID => $Return[1],
                UserID => 1,
            );
            $Self->True(
                $StateSet || 0,
                "#$NumberModule $StorageModule $File StateSet() - closed successful",
            );

            # send follow up #3
            @Content = ();
            for my $Line (@ContentNew) {
                if ($Line =~ /^Subject:/) {
                    $Line = 'Subject: '.$Self->{TicketObject}->TicketSubjectBuild(
                        TicketNumber => $Ticket{TicketNumber},
                        Subject => $Line,
                    );
                }
                push (@Content, $Line);
            }
            $Self->{ConfigObject}->Set(Key => 'PostmasterFollowUpStateClosed', Value => 'new');
            $Self->{PostMasterObject} = Kernel::System::PostMaster->new(
                %{$Self},
                TicketObject => $Self->{TicketObject},
                Email => \@Content,
            );
            @Return = $Self->{PostMasterObject}->Run();
            $Self->Is(
                $Return[0] || 0,
                2,
                "#$NumberModule $StorageModule $File Run() - FollowUp",
            );
            $Self->True(
                $Return[1] || 0,
                "#$NumberModule $StorageModule $File Run() - FollowUp/TicketID",
            );

            # new/clear ticket object
            $Self->{TicketObject} = Kernel::System::Ticket->new(%{$Self});
            %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Return[1]);
            $Self->Is(
                $Ticket{State} || 0,
                'new',
                "#$NumberModule $StorageModule $File Run() - FollowUp/PostmasterFollowUpStateClosed check",
            );

            # delete ticket
            my $Delete = $Self->{TicketObject}->TicketDelete(
                TicketID => $Return[1],
                UserID => 1,
            );
            $Self->True(
                $Delete || 0,
                "#$NumberModule $StorageModule $File TicketDelete()",
            );
        }
    }
}

1;
