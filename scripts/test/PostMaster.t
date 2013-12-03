# --
# PostMaster.t - PostMaster tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::PostMaster;
use Kernel::System::PostMaster::Filter;
use Kernel::System::Ticket;
use Kernel::Config;

use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::DynamicField;
use Kernel::System::UnitTest::Helper;
use Kernel::System::User;

# helper object
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 1,
);

# create local config object
my $ConfigObject = Kernel::Config->new();

# user object
my $UserObject = Kernel::System::User->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# add or update dynamic fields if needed
my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$Self} );

my @DynamicfieldIDs;
my @DynamicFieldUpdate;
my %NeededDynamicfields = (
    TicketFreeKey1  => 1,
    TicketFreeText1 => 1,
    TicketFreeKey2  => 1,
    TicketFreeText2 => 1,
    TicketFreeKey3  => 1,
    TicketFreeText3 => 1,
    TicketFreeTime1 => 1,
    TicketFreeTime2 => 1,
    TicketFreeTime3 => 1,
    TicketFreeTime4 => 1,
    TicketFreeTime5 => 1,
    TicketFreeTime6 => 1,
);

# list available dynamic fields
my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
    Valid      => 0,
    ResultType => 'HASH',
);
$DynamicFields = ( ref $DynamicFields eq 'HASH' ? $DynamicFields : {} );
$DynamicFields = { reverse %{$DynamicFields} };

for my $FieldName ( sort keys %NeededDynamicfields ) {
    if ( !$DynamicFields->{$FieldName} ) {

        # create a dynamic field
        my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $FieldName,
            Label      => $FieldName . "_test",
            FieldOrder => 9991,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue => 'a value',
            },
            ValidID => 1,
            UserID  => 1,
        );

        # verify dynamic field creation
        $Self->True(
            $FieldID,
            "DynamicFieldAdd() successful for Field $FieldName",
        );

        push @DynamicfieldIDs, $FieldID;
    }
    else {
        my $DynamicField
            = $DynamicFieldObject->DynamicFieldGet( ID => $DynamicFields->{$FieldName} );

        if ( $DynamicField->{ValidID} > 1 ) {
            push @DynamicFieldUpdate, $DynamicField;
            $DynamicField->{ValidID} = 1;
            my $SuccessUpdate = $DynamicFieldObject->DynamicFieldUpdate(
                %{$DynamicField},
                Reorder => 0,
                UserID  => 1,
                ValidID => 1,
            );

            # verify dynamic field creation
            $Self->True(
                $SuccessUpdate,
                "DynamicFieldUpdate() successful update for Field $DynamicField->{Name}",
            );
        }
    }
}

my %NeededXHeaders = (
    'X-OTRS-DynamicField-TicketFreeKey1'  => 1,
    'X-OTRS-DynamicField-TicketFreeText1' => 1,
    'X-OTRS-DynamicField-TicketFreeKey2'  => 1,
    'X-OTRS-DynamicField-TicketFreeText2' => 1,
    'X-OTRS-DynamicField-TicketFreeKey3'  => 1,
    'X-OTRS-DynamicField-TicketFreeText3' => 1,
    'X-OTRS-DynamicField-TicketFreeTime1' => 1,
    'X-OTRS-DynamicField-TicketFreeTime2' => 1,
    'X-OTRS-DynamicField-TicketFreeTime3' => 1,
    'X-OTRS-DynamicField-TicketFreeTime4' => 1,
    'X-OTRS-DynamicField-TicketFreeTime5' => 1,
    'X-OTRS-DynamicField-TicketFreeTime6' => 1,
    'X-OTRS-TicketKey1'                   => 1,
    'X-OTRS-TicketValue1'                 => 1,
    'X-OTRS-TicketKey2'                   => 1,
    'X-OTRS-TicketValue2'                 => 1,
    'X-OTRS-TicketKey3'                   => 1,
    'X-OTRS-TicketValue3'                 => 1,
    'X-OTRS-TicketTime1'                  => 1,
    'X-OTRS-TicketTime2'                  => 1,
    'X-OTRS-TicketTime3'                  => 1,
    'X-OTRS-TicketTime4'                  => 1,
    'X-OTRS-TicketTime5'                  => 1,
    'X-OTRS-TicketTime6'                  => 1,
    'X-OTRS-Owner'                        => 1,
    'X-OTRS-OwnerID'                      => 1,
    'X-OTRS-Responsible'                  => 1,
    'X-OTRS-ResponsibleID'                => 1,
);

my $XHeaders          = $ConfigObject->Get('PostmasterX-Header');
my @PostmasterXHeader = @{$XHeaders};
HEADER:
for my $Header ( sort keys %NeededXHeaders ) {
    next HEADER if ( grep $_ eq $Header, @PostmasterXHeader );
    push @PostmasterXHeader, $Header;
}
$ConfigObject->Set(
    Key   => 'PostmasterX-Header',
    Value => \@PostmasterXHeader
);

# disable not needed event module
$ConfigObject->Set(
    Key => 'Ticket::EventModulePost###TicketDynamicFieldDefault',
);

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
            my $FilterRand1 = 'filter' . int rand 1000000;
            my $FilterRand2 = 'filter' . int rand 1000000;
            my $FilterRand3 = 'filter' . int rand 1000000;
            my $FilterRand4 = 'filter' . int rand 1000000;
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
            $PostMasterFilter->FilterAdd(
                Name           => $FilterRand4,
                StopAfterMatch => 0,
                Match          => {
                    Subject => 'NOT REGEX',
                    To      => 'darthvader@otrs.org',
                },
                Not => {
                    To => 1,
                },
                Set => {
                    'X-OTRS-Ignore' => 'yes',
                },
            );

            # get rand sender address
            my $UserRand1 = 'example-user' . ( int rand 1000000 ) . '@example.com';

            FILE:
            for my $File (qw(1 2 3 5 6 11 17 18 21 22 23)) {

                my $NamePrefix = "#$NumberModule $StorageModule $TicketSubjectConfig $File ";

                # new ticket check
                my $Location = $ConfigObject->Get('Home')
                    . "/scripts/test/sample/PostMaster/PostMaster-Test$File.box";
                my $ContentRef = $Self->{MainObject}->FileRead(
                    Location => $Location,
                    Mode     => 'binmode',
                    Result   => 'ARRAY',
                );
                my @Content;
                for my $Line ( @{$ContentRef} ) {
                    if ( $Line =~ /^From:/ ) {
                        $Line = "From: \"Some Realname\" <$UserRand1>\n";
                    }
                    push @Content, $Line;
                }

                # follow up check
                my @ContentNew = ();
                for my $Line (@Content) {
                    push @ContentNew, $Line;
                }
                my @Return;

                $ConfigObject->Set(
                    Key   => 'PostmasterDefaultState',
                    Value => 'new'
                );
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        %{$Self},
                        ConfigObject => $ConfigObject,
                        Email        => \@Content,
                    );

                    @Return = $PostMasterObject->Run();
                }

                if ( $File != 22 ) {
                    $Self->Is(
                        $Return[0] || 0,
                        1,
                        $NamePrefix . ' Run() - NewTicket',
                    );

                    $Self->True(
                        $Return[1] || 0,
                        $NamePrefix . ' Run() - NewTicket/TicketID',
                    );
                }
                else {
                    $Self->Is(
                        $Return[0] || 0,
                        5,
                        $NamePrefix . ' Run() - NewTicket',
                    );

                    $Self->False(
                        $Return[1],
                        $NamePrefix . ' Run() - NewTicket/TicketID',
                    );

                    next FILE;
                }

                # new/clear ticket object
                my $TicketObject = Kernel::System::Ticket->new(
                    %{$Self},
                    ConfigObject => $ConfigObject,
                );
                my %Ticket = $TicketObject->TicketGet(
                    TicketID      => $Return[1],
                    DynamicFields => 1,
                );
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
                            Key    => 'DynamicField_TicketFreeKey1',
                            Result => 'Key1',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeText1',
                            Result => 'Text1',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeKey2',
                            Result => undef,
                        },
                        {
                            Key    => 'DynamicField_TicketFreeText2',
                            Result => undef,
                        },
                        {
                            Key    => 'DynamicField_TicketFreeKey3',
                            Result => 'Key3',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeText3',
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
                        ArticleID     => $ArticleIDs[0],
                        DynamicFields => 1,
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
                        ArticleID     => $ArticleIDs[0],
                        DynamicFields => 1,
                    );
                    my @Tests = (
                        {
                            Key    => 'DynamicField_TicketFreeKey1',
                            Result => 'Test',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeText1',
                            Result => 'ABC',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeKey2',
                            Result => 'Test2',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeText2',
                            Result => 'ABC2',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeTime1',
                            Result => '2008-01-12 13:14:15',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeTime2',
                            Result => '2008-01-12 13:15:16',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeTime3',
                            Result => '2008-01-12 13:16:17',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeTime4',
                            Result => '2008-01-12 13:17:18',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeTime5',
                            Result => '2008-01-12 13:18:19',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeTime6',
                            Result => '2008-01-12 13:19:20',
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
                        ArticleID     => $ArticleIDs[0],
                        DynamicFields => 1,
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
                        ArticleID     => $ArticleIDs[0],
                        DynamicFields => 1,
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
                $ConfigObject->Set(
                    Key   => 'PostmasterFollowUp',
                    Value => 'new'
                );
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        %{$Self},
                        ConfigObject => $ConfigObject,
                        Email        => \@Content,
                    );
                    @Return = $PostMasterObject->Run();
                }
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
                %Ticket = $TicketObject->TicketGet(
                    TicketID      => $Return[1],
                    DynamicFields => 1,
                );
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
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        %{$Self},
                        ConfigObject => $ConfigObject,
                        Email        => \@Content,
                    );
                    @Return = $PostMasterObject->Run();
                }
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
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        %{$Self},
                        ConfigObject => $ConfigObject,
                        Email        => \@Content,
                    );
                    @Return = $PostMasterObject->Run();
                }
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
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        %{$Self},
                        ConfigObject => $ConfigObject,
                        Email        => \@Content,
                    );
                    @Return = $PostMasterObject->Run();
                }
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
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        %{$Self},
                        ConfigObject => $ConfigObject,
                        Email        => \@Content,
                    );
                    @Return = $PostMasterObject->Run();
                }
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
                %Ticket = $TicketObject->TicketGet(
                    TicketID      => $Return[1],
                    DynamicFields => 1,
                );
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
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        %{$Self},
                        TicketObject => $TicketObject,
                        ConfigObject => $ConfigObject,
                        Email        => \@Content,
                    );
                    @Return = $PostMasterObject->Run();
                }

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
                %Ticket = $TicketObject->TicketGet(
                    TicketID      => $Return[1],
                    DynamicFields => 1,
                );
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
            $PostMasterFilter->FilterDelete( Name => $FilterRand4 );
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
            Queue                        => 'Misc',
            DynamicField_TicketFreeKey3  => 'Key3',
            DynamicField_TicketFreeText3 => 'Text3',
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
            Queue                        => 'Misc',
            DynamicField_TicketFreeKey1  => 'Key1#2',
            DynamicField_TicketFreeText1 => 'Text1#2',
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

    my @Return;
    {
        my $PostMasterObject = Kernel::System::PostMaster->new(
            %{$Self},
            ConfigObject => $ConfigObject,
            Email        => \$Email,
        );

        @Return = $PostMasterObject->Run();
    }
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
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 1,
    );
    for my $Test (@Tests) {
        next if !$Test->{Check};
        for my $Key ( sort keys %{ $Test->{Check} } ) {
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

# revert changes to dynamic fields
for my $DynamicField (@DynamicFieldUpdate) {
    my $SuccessUpdate = $DynamicFieldObject->DynamicFieldUpdate(
        Reorder => 0,
        UserID  => 1,
        %{$DynamicField},
    );
    $Self->True(
        $SuccessUpdate,
        "Reverted changes on ValidID for $DynamicField->{Name} field.",
    );
}

for my $DynamicFieldID (@DynamicfieldIDs) {

    # delete the dynamic field
    my $FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => 1,
    );
    $Self->True(
        $FieldDelete,
        "Deleted dynamic field with id $DynamicFieldID.",
    );
}

# test X-OTRS-(Owner|Responsible)
my $Login = $HelperObject->TestUserCreate();
my $UserID = $UserObject->UserLookup( UserLogin => $Login );

my %OwnerResponsibleTests = (
    Owner => {
        File  => 'Owner',
        Check => {
            Owner => $Login,
        },
    },
    OwnerID => {
        File  => 'OwnerID',
        Check => {
            OwnerID => $UserID,
        },
    },
    Responsible => {
        File  => 'Responsible',
        Check => {
            Responsible => $Login,
        },
    },
    ResponsibleID => {
        File  => 'ResponsibleID',
        Check => {
            ResponsibleID => $UserID,
        },
    },
);

for my $Test ( sort keys %OwnerResponsibleTests ) {
    my $FileSuffix = $OwnerResponsibleTests{$Test}->{File};
    my $Location   = $ConfigObject->Get('Home')
        . "/scripts/test/sample/PostMaster/PostMaster-Test-$FileSuffix.box";
    my $ContentRef = $Self->{MainObject}->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Result   => 'ARRAY',
    );

    for my $Line ( @{$ContentRef} ) {
        $Line =~ s{ ^ (X-OTRS-(?:Owner|Responsible):) .*? $ }{$1$Login}x;
        $Line =~ s{ ^ (X-OTRS-(?:Owner|Responsible)ID:) .*? $ }{$1$UserID}x;
    }

    my $PostMasterObject = Kernel::System::PostMaster->new(
        %{$Self},
        ConfigObject => $ConfigObject,
        Email        => $ContentRef,
    );

    my @Return = $PostMasterObject->Run();

    $Self->Is(
        $Return[0] || 0,
        1,
        $Test . ' Run() - NewTicket',
    );

    $Self->True(
        $Return[1],
        $Test . ' Run() - NewTicket/TicketID',
    );

    my $TicketObject = Kernel::System::Ticket->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 0,
    );

    for my $Field ( sort keys %{ $OwnerResponsibleTests{$Test}->{Check} } ) {
        $Self->Is(
            $Ticket{$Field},
            $OwnerResponsibleTests{$Test}->{Check}->{$Field},
            $Test . ' Check Field - ' . $Field,
        );
    }
}

1;
