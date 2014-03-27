# --
# PostMaster.t - PostMaster tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: PostMaster.t,v 1.26 2010-12-10 15:15:15 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::PostMaster::LoopProtection;
use Kernel::System::PostMaster;
use Kernel::System::PostMaster::Filter;
use Kernel::System::Ticket;
use Kernel::Config;

# create local config object
my $ConfigObject = Kernel::Config->new();

for my $Module (qw(DB FS)) {
    $ConfigObject->Set(
        Key   => 'LoopProtectionModule',
        Value => "Kernel::System::PostMaster::LoopProtection::$Module",
    );

    my $LoopProtectionObject = Kernel::System::PostMaster::LoopProtection->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );

    # get rand sender address
    my $UserRand1 = 'example-user' . int( rand(1000000) ) . '@example.com';

    my $Check = $LoopProtectionObject->Check( To => $UserRand1 );

    $Self->True(
        $Check || 0,
        "#$Module - Check() - $UserRand1",
    );

    for ( 1 .. 42 ) {
        my $SendEmail = $LoopProtectionObject->SendEmail( To => $UserRand1 );
        $Self->True(
            $SendEmail || 0,
            "#$Module - SendEmail() - #$_ ",
        );
    }

    $Check = $LoopProtectionObject->Check( To => $UserRand1 );

    $Self->False(
        $Check || 0,
        "#$Module - Check() - $UserRand1",
    );
}

# use different subject format
for my $TicketSubjectConfig ( 'Right', 'Left' ) {
    $ConfigObject->Set(
        Key   => 'Ticket::SubjectFormat',
        Value => $TicketSubjectConfig,
    );

    # use different ticket number generators
    for my $NumberModule (qw(AutoIncrement DateChecksum Date Random)) {
        my $PostMasterFilter = Kernel::System::PostMaster::Filter->new(
            %{$Self},
            ConfigObject => $ConfigObject,
        );
        $ConfigObject->Set(
            Key   => 'Ticket::NumberGenerator',
            Value => "Kernel::System::Ticket::Number::$NumberModule",
        );

        # use different storage backends
        for my $StorageModule (qw(ArticleStorageDB ArticleStorageFS)) {
            $ConfigObject->Set(
                Key   => 'Ticket::StorageModule',
                Value => "Kernel::System::Ticket::$StorageModule",
            );

            # add rand postmaster filter
            my $FilterRand1 = 'filter' . int( rand(1000000) );
            my $FilterRand2 = 'filter' . int( rand(1000000) );
            my $FilterRand3 = 'filter' . int( rand(1000000) );
            $PostMasterFilter->FilterAdd(
                Name           => $FilterRand1,
                StopAfterMatch => 0,
                Match          => {
                    Subject => 'test',
                    To      => 'EMAILADDRESS:darthvader@otrs.org',
                },
                Set => {
                    'X-OTRS-Queue'        => 'Misc',
                    'X-OTRS-TicketKey1'   => 'Key1',
                    'X-OTRS-TicketValue1' => 'Text1',
                },
            );
            $PostMasterFilter->FilterAdd(
                Name           => $FilterRand2,
                StopAfterMatch => 0,
                Match          => {
                    Subject => 'test',
                    To      => 'EMAILADDRESS:darthvader2@otrs.org',
                },
                Set => {
                    'X-OTRS-TicketKey2'   => 'Key2',
                    'X-OTRS-TicketValue2' => 'Text2',
                },
            );
            $PostMasterFilter->FilterAdd(
                Name           => $FilterRand3,
                StopAfterMatch => 0,
                Match          => {
                    Subject => 'test 1',
                    To      => 'otrs.org',
                },
                Set => {
                    'X-OTRS-TicketKey3'   => 'Key3',
                    'X-OTRS-TicketValue3' => 'Text3',
                },
            );

            # get rand sender address
            my $UserRand1 = 'example-user' . int( rand(1000000) ) . '@example.com';

            for my $File (qw(1 2 3 5 6 11 17 18)) {

                my $NamePrefix = "#$NumberModule $StorageModule $TicketSubjectConfig $File ";

                # new ticket check
                my @Content;
                my $MailFile = $ConfigObject->Get('Home')
                    . "/scripts/test/sample/PostMaster/PostMaster-Test$File.box";
                open( IN, '<', $MailFile ) || die $!;
                binmode(IN);
                while ( my $Line = <IN> ) {
                    if ( $Line =~ /^From:/ ) {
                        $Line = "From: \"Some Realname\" <$UserRand1>\n";
                    }
                    push @Content, $Line;
                }
                close(IN);

                # follow up check
                my @ContentNew = ();
                for my $Line (@Content) {
                    push @ContentNew, $Line;
                }

                my $PostMasterObject = Kernel::System::PostMaster->new(
                    %{$Self},
                    ConfigObject => $ConfigObject,
                    Email        => \@Content,
                );

                my @Return = $PostMasterObject->Run();
                $Self->Is(
                    $Return[0] || 0,
                    1,
                    $NamePrefix . ' Run() - NewTicket',
                );
                $Self->True(
                    $Return[1] || 0,
                    $NamePrefix . ' Run() - NewTicket/TicketID',
                );

                # new/clear ticket object
                my $TicketObject = Kernel::System::Ticket->new(
                    %{$Self},
                    ConfigObject => $ConfigObject,
                );
                my %Ticket = $TicketObject->TicketGet( TicketID => $Return[1] );
                my @ArticleIDs = $TicketObject->ArticleIndex(
                    TicketID => $Return[1],
                );

                if ( $File == 1 ) {
                    my @Tests = (
                        {
                            Key    => 'Queue',
                            Result => 'Misc',
                        },
                        {
                            Key    => 'TicketFreeKey1',
                            Result => 'Key1',
                        },
                        {
                            Key    => 'TicketFreeText1',
                            Result => 'Text1',
                        },
                        {
                            Key    => 'TicketFreeKey2',
                            Result => '',
                        },
                        {
                            Key    => 'TicketFreeText2',
                            Result => '',
                        },
                        {
                            Key    => 'TicketFreeKey3',
                            Result => 'Key3',
                        },
                        {
                            Key    => 'TicketFreeText3',
                            Result => 'Text3',
                        },
                    );
                    for my $Test (@Tests) {
                        $Self->Is(
                            $Ticket{ $Test->{Key} },
                            $Test->{Result},
                            $NamePrefix . " $Test->{Key} check",
                        );
                    }
                }

                if ( $File == 3 ) {

                    # check body
                    my %Article = $TicketObject->ArticleGet(
                        ArticleID => $ArticleIDs[0],
                    );
                    my $MD5 = $Self->{MainObject}->MD5sum( String => $Article{Body} ) || '';
                    $Self->Is(
                        $MD5,
                        'b50d85781d2ac10c210f99bf8142badc',
                        $NamePrefix . ' md5 body check',
                    );

                    # check attachments
                    my %Index = $TicketObject->ArticleAttachmentIndex(
                        ArticleID => $ArticleIDs[0],
                        UserID    => 1,
                    );
                    my %Attachment = $TicketObject->ArticleAttachment(
                        ArticleID => $ArticleIDs[0],
                        FileID    => 2,
                        UserID    => 1,
                    );
                    $MD5 = $Self->{MainObject}->MD5sum( String => $Attachment{Content} ) || '';
                    $Self->Is(
                        $MD5,
                        '4e78ae6bffb120669f50bca56965f552',
                        $NamePrefix . ' md5 attachment check',
                    );

                }

                if ( $File == 5 ) {

                    # check body
                    my %Article = $TicketObject->ArticleGet(
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
                    for my $Test (@Tests) {
                        $Self->Is(
                            $Article{ $Test->{Key} } || '',
                            $Test->{Result} || '-',
                            $NamePrefix . " $Test->{Key} check",
                        );
                    }
                }

                if ( $File == 6 ) {

                    # check body
                    my %Article = $TicketObject->ArticleGet(
                        ArticleID => $ArticleIDs[0],
                    );
                    my $MD5 = $Self->{MainObject}->MD5sum( String => $Article{Body} ) || '';
                    $Self->Is(
                        $MD5,
                        '2ac290235a8cad953a1837c77701c5dc',
                        $NamePrefix . ' md5 body check',
                    );

                    # check attachments
                    my %Index = $TicketObject->ArticleAttachmentIndex(
                        ArticleID => $ArticleIDs[0],
                        UserID    => 1,
                    );
                    my %Attachment = $TicketObject->ArticleAttachment(
                        ArticleID => $ArticleIDs[0],
                        FileID    => 2,
                        UserID    => 1,
                    );
                    $MD5 = $Self->{MainObject}->MD5sum( String => $Attachment{Content} ) || '';
                    $Self->Is(
                        $MD5,
                        '0596f2939525c6bd50fc2b649e40fbb6',
                        $NamePrefix . ' md5 attachment check',
                    );

                }
                if ( $File == 11 ) {

                    # check body
                    my %Article = $TicketObject->ArticleGet(
                        ArticleID => $ArticleIDs[0],
                    );
                    my $MD5 = $Self->{MainObject}->MD5sum( String => $Article{Body} ) || '';

                    $Self->Is(
                        $MD5,
                        '52f20c90a1f0d8cf3bd415e278992001',
                        $NamePrefix . ' md5 body check',
                    );
                }

                # send follow up #1
                @Content = ();
                for my $Line (@ContentNew) {
                    if ( $Line =~ /^Subject:/ ) {
                        $Line = 'Subject: ' . $TicketObject->TicketSubjectBuild(
                            TicketNumber => $Ticket{TicketNumber},
                            Subject      => $Line,
                        );
                    }
                    push @Content, $Line;
                }
                $PostMasterObject = Kernel::System::PostMaster->new(
                    %{$Self},
                    ConfigObject => $ConfigObject,
                    Email        => \@Content,
                );
                @Return = $PostMasterObject->Run();
                $Self->Is(
                    $Return[0] || 0,
                    2,
                    $NamePrefix . ' Run() - FollowUp',
                );
                $Self->True(
                    $Return[1] || 0,
                    $NamePrefix . ' Run() - FollowUp/TicketID',
                );

                # new/clear ticket object
                $TicketObject = Kernel::System::Ticket->new(
                    %{$Self},
                    ConfigObject => $ConfigObject,
                );
                %Ticket = $TicketObject->TicketGet( TicketID => $Return[1] );
                $Self->Is(
                    $Ticket{State} || 0,
                    'new',
                    $NamePrefix . ' Run() - FollowUp/State check',
                );
                my $StateSet = $TicketObject->StateSet(
                    State    => 'pending reminder',
                    TicketID => $Return[1],
                    UserID   => 1,
                );
                $Self->True(
                    $StateSet || 0,
                    $NamePrefix . ' StateSet() - pending reminder',
                );

                # send follow up #2
                @Content = ();
                for my $Line (@ContentNew) {
                    if ( $Line =~ /^Subject:/ ) {
                        $Line = 'Subject: ' . $TicketObject->TicketSubjectBuild(
                            TicketNumber => $Ticket{TicketNumber},
                            Subject      => $Line,
                        );
                    }
                    push @Content, $Line;
                }
                $PostMasterObject = Kernel::System::PostMaster->new(
                    %{$Self},
                    ConfigObject => $ConfigObject,
                    Email        => \@Content,
                );
                @Return = $PostMasterObject->Run();
                $Self->Is(
                    $Return[0] || 0,
                    2,
                    $NamePrefix . ' Run() - FollowUp',
                );
                $Self->True(
                    $Return[1] || 0,
                    $NamePrefix . ' Run() - FollowUp/TicketID',
                );

                # send follow up #3
                @Content = ();
                for my $Line (@ContentNew) {
                    if ( $Line =~ /^Subject:/ ) {
                        $Line
                            = 'Subject: '
                            . $ConfigObject->Get('Ticket::Hook')
                            . ": $Ticket{TicketNumber}";
                    }
                    push @Content, $Line;
                }
                $PostMasterObject = Kernel::System::PostMaster->new(
                    %{$Self},
                    ConfigObject => $ConfigObject,
                    Email        => \@Content,
                );
                @Return = $PostMasterObject->Run();
                $Self->Is(
                    $Return[0] || 0,
                    2,
                    $NamePrefix . ' Run() - FollowUp (Ticket::Hook#: xxxxxxxxxx)',
                );
                $Self->True(
                    $Return[1] || 0,
                    $NamePrefix . ' Run() - FollowUp/TicketID',
                );

                # send follow up #4
                @Content = ();
                for my $Line (@ContentNew) {
                    if ( $Line =~ /^Subject:/ ) {
                        $Line
                            = 'Subject: '
                            . $ConfigObject->Get('Ticket::Hook')
                            . ":$Ticket{TicketNumber}";
                    }
                    push @Content, $Line;
                }
                $PostMasterObject = Kernel::System::PostMaster->new(
                    %{$Self},
                    ConfigObject => $ConfigObject,
                    Email        => \@Content,
                );
                @Return = $PostMasterObject->Run();
                $Self->Is(
                    $Return[0] || 0,
                    2,
                    $NamePrefix . ' Run() - FollowUp (Ticket::Hook#:xxxxxxxxxx)',
                );
                $Self->True(
                    $Return[1] || 0,
                    $NamePrefix . ' Run() - FollowUp/TicketID',
                );

                # send follow up #5
                @Content = ();
                for my $Line (@ContentNew) {
                    if ( $Line =~ /^Subject:/ ) {
                        $Line
                            = 'Subject: '
                            . $ConfigObject->Get('Ticket::Hook')
                            . $Ticket{TicketNumber};
                    }
                    push @Content, $Line;
                }
                $PostMasterObject = Kernel::System::PostMaster->new(
                    %{$Self},
                    ConfigObject => $ConfigObject,
                    Email        => \@Content,
                );
                @Return = $PostMasterObject->Run();
                $Self->Is(
                    $Return[0] || 0,
                    2,
                    $NamePrefix . ' Run() - FollowUp (Ticket::Hook#xxxxxxxxxx)',
                );
                $Self->True(
                    $Return[1] || 0,
                    $NamePrefix . ' Run() - FollowUp/TicketID',
                );

                # new/clear ticket object
                $TicketObject = Kernel::System::Ticket->new(
                    %{$Self},
                    ConfigObject => $ConfigObject,
                );
                %Ticket = $TicketObject->TicketGet( TicketID => $Return[1] );
                $Self->Is(
                    $Ticket{State} || 0,
                    'open',
                    $NamePrefix . ' Run() - FollowUp/PostmasterFollowUpState check',
                );
                $StateSet = $TicketObject->StateSet(
                    State    => 'closed successful',
                    TicketID => $Return[1],
                    UserID   => 1,
                );
                $Self->True(
                    $StateSet || 0,
                    $NamePrefix . ' StateSet() - closed successful',
                );

                # send follow up #3
                @Content = ();
                for my $Line (@ContentNew) {
                    if ( $Line =~ /^Subject:/ ) {
                        $Line = 'Subject: ' . $TicketObject->TicketSubjectBuild(
                            TicketNumber => $Ticket{TicketNumber},
                            Subject      => $Line,
                        );
                    }
                    push @Content, $Line;
                }
                $ConfigObject->Set(
                    Key   => 'PostmasterFollowUpStateClosed',
                    Value => 'new'
                );
                $PostMasterObject = Kernel::System::PostMaster->new(
                    %{$Self},
                    TicketObject => $TicketObject,
                    ConfigObject => $ConfigObject,
                    Email        => \@Content,
                );
                @Return = $PostMasterObject->Run();
                $Self->Is(
                    $Return[0] || 0,
                    2,
                    $NamePrefix . ' Run() - FollowUp',
                );
                $Self->True(
                    $Return[1] || 0,
                    $NamePrefix . ' Run() - FollowUp/TicketID',
                );

                # new/clear ticket object
                $TicketObject = Kernel::System::Ticket->new(
                    %{$Self},
                    ConfigObject => $ConfigObject,
                );
                %Ticket = $TicketObject->TicketGet( TicketID => $Return[1] );
                $Self->Is(
                    $Ticket{State} || 0,
                    'new',
                    $NamePrefix . ' Run() - FollowUp/PostmasterFollowUpStateClosed check',
                );

                # delete ticket
                my $Delete = $TicketObject->TicketDelete(
                    TicketID => $Return[1],
                    UserID   => 1,
                );
                $Self->True(
                    $Delete || 0,
                    $NamePrefix . ' TicketDelete()',
                );
            }
            $PostMasterFilter->FilterDelete( Name => $FilterRand1 );
            $PostMasterFilter->FilterDelete( Name => $FilterRand2 );
            $PostMasterFilter->FilterDelete( Name => $FilterRand3 );
        }
    }
}

# filter test
my @Tests = (
    {
        Name  => '#1 - From Test',
        Match => {
            From => 'sender@example.com',
        },
        Set => {
            'X-OTRS-Queue'        => 'Misc',
            'X-OTRS-TicketKey1'   => 'Key1',
            'X-OTRS-TicketValue1' => 'Text1',
            'X-OTRS-TicketKey3'   => 'Key3',
            'X-OTRS-TicketValue3' => 'Text3',
        },
        Check => {
            Queue           => 'Misc',
            TicketFreeKey3  => 'Key3',
            TicketFreeText3 => 'Text3',
        },
    },
    {
        Name  => '#2 - From Test',
        Match => {
            From => 'EMAILADDRESS:sender@example.com',
        },
        Set => {
            'X-OTRS-Queue'        => 'Misc',
            'X-OTRS-TicketKey1'   => 'Key1#2',
            'X-OTRS-TicketValue1' => 'Text1#2',
            'X-OTRS-TicketKey4'   => 'Key4#2',
            'X-OTRS-TicketValue4' => 'Text4#2',
        },
        Check => {
            Queue           => 'Misc',
            TicketFreeKey1  => 'Key1#2',
            TicketFreeText1 => 'Text1#2',
        },
    },
    {
        Name  => '#3 - From Test',
        Match => {
            From => 'EMAILADDRESS:not_this_sender@example.com',
        },
        Set => {
            'X-OTRS-Queue'        => 'Misc',
            'X-OTRS-TicketKey1'   => 'Key1#3',
            'X-OTRS-TicketValue1' => 'Text1#3',
            'X-OTRS-TicketKey3'   => 'Key3#3',
            'X-OTRS-TicketValue3' => 'Text3#3',
        },
    },
);

# set filter
my $PostMasterFilter = Kernel::System::PostMaster::Filter->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
for my $Type (qw(Config DB)) {
    for my $Test (@Tests) {
        if ( $Type eq 'DB' ) {
            $PostMasterFilter->FilterAdd(
                Name           => $Test->{Name},
                StopAfterMatch => 0,
                %{$Test},
            );
        }
        else {
            $ConfigObject->Set(
                Key   => 'PostMaster::PreFilterModule###' . $Test->{Name},
                Value => {
                    %{$Test},
                    Module => 'Kernel::System::PostMaster::Filter::Match',
                },
            );
        }
    }

    my $Email = 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: some subject

Some Content in Body
';

    my $PostMasterObject = Kernel::System::PostMaster->new(
        %{$Self},
        ConfigObject => $ConfigObject,
        Email        => \$Email,
    );

    my @Return = $PostMasterObject->Run();
    $Self->Is(
        $Return[0] || 0,
        1,
        "#Filter $Type Run() - NewTicket",
    );
    $Self->True(
        $Return[1] || 0,
        "#Filter $Type Run() - NewTicket/TicketID",
    );

    # new/clear ticket object
    my $TicketObject = Kernel::System::Ticket->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );
    my %Ticket = $TicketObject->TicketGet( TicketID => $Return[1] );
    for my $Test (@Tests) {
        next if !$Test->{Check};
        for my $Key ( %{ $Test->{Check} } ) {
            $Self->Is(
                $Ticket{$Key},
                $Test->{Check}->{$Key},
                "#Filter $Type Run() - $Key",
            );
        }
    }

    # delete ticket
    my $Delete = $TicketObject->TicketDelete(
        TicketID => $Return[1],
        UserID   => 1,
    );
    $Self->True(
        $Delete || 0,
        "#Filter $Type TicketDelete()",
    );

    # remove filter
    for my $Test (@Tests) {
        if ( $Type eq 'DB' ) {
            $PostMasterFilter->FilterDelete( Name => $Test->{Name} );
        }
        else {
            $ConfigObject->Set(
                Key   => 'PostMaster::PreFilterModule###' . $Test->{Name},
                Value => undef,
            );
        }
    }
}

1;
