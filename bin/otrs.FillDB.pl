#!/usr/bin/perl -w
# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use strict;
use warnings;

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::Queue;
use Kernel::System::Ticket;
use Kernel::System::PostMaster;
use Kernel::System::LinkObject;

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.FillDB.pl',
    %CommonObject,
);
$CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
$CommonObject{UserObject}   = Kernel::System::User->new(%CommonObject);
$CommonObject{GroupObject}  = Kernel::System::Group->new(%CommonObject);
$CommonObject{QueueObject}  = Kernel::System::Queue->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);
$CommonObject{LinkObject}   = Kernel::System::LinkObject->new(%CommonObject);

# set dummy sendmail module
$CommonObject{ConfigObject}->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# get options
my %Opts = ();
getopt( 'hqugtr', \%Opts );
if ( $Opts{h} ) {
    print "otrs.FillDB.pl - OTRS fill db with data\n";
    print "Copyright (C) 2001-2018 OTRS AG, https://otrs.com/\n";
    print
        "usage: otrsFillDB.pl -q <COUNTOFQUEUES> -t <COUNTOFTICKET> -u <COUNTOFUSERS> -g <COUNTOFGROUPS> -r <REALLYDOTHIS>\n";
    exit 1;
}
if ( !$Opts{g} ) {
    print STDERR "NOTICE: No -g <COUNTOFGROUPS> given, take existing groups!\n";
}
if ( !$Opts{u} ) {
    print STDERR "NOTICE: No -u <COUNTOFUSERS> given, take existing users!\n";
}
if ( !$Opts{q} ) {
    print STDERR "NOTICE: No -q <COUNTOFQUEUES> given, take existing queues!\n";
}
if ( !$Opts{t} ) {
    print STDERR "ERROR: Need -t <COUNTOFTICKET>\n";
    exit(1);
}

# check if DB is empty
$CommonObject{DBObject}->Prepare( SQL => 'SELECT count(*) FROM ticket' );
my $Check = 0;
while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
    $Check = $Row[0];
}
if ( $Check && $Check > 1 && ( !$Opts{r} || $Opts{r} !~ /^yes$/i ) ) {
    print STDERR "ERROR: Sorry, can't do this. It looks like an productive database!\n";
    print STDERR "ERROR: You have $Check tickets in there. Only do this on non productive system\n";
    print STDERR "ERROR: Your really want to do this? Use '-r yes'\n";
    exit(1);
}

# set env config
$CommonObject{ConfigObject}->Set(
    Key   => 'CheckEmailInvalidAddress',
    Value => 0,
);

# groups
my @GroupIDs;
if ( !$Opts{g} ) {
    @GroupIDs = GroupGet();
    $Opts{g} = $#GroupIDs;
}
else {
    @GroupIDs = GroupCreate( $Opts{g} );
}

# users
my @UserIDs;
if ( !$Opts{u} ) {
    @UserIDs = UserGet();
    $Opts{u} = $#UserIDs;
}
else {
    @UserIDs = UserCreate( $Opts{u} );
}

# queues
my @QueueIDs;
if ( !$Opts{q} ) {
    @QueueIDs = QueueGet();
    $Opts{q} = $#QueueIDs;
}
else {
    @QueueIDs = QueueCreate( $Opts{q} );
}

# create tickets
my @TicketIDs = ();
foreach ( 1 .. $Opts{'t'} ) {
    my $TicketID = $CommonObject{TicketObject}->TicketCreate(
        Title        => RandomSubject(),
        QueueID      => $QueueIDs[ int( rand( $Opts{q} ) ) ],
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'new',
        CustomerNo   => int( rand(1000) ),
        CustomerUser => RandomAddress(),
        OwnerID      => $UserIDs[ int( rand( $Opts{u} ) ) ],
        UserID       => $UserIDs[ int( rand( $Opts{u} ) ) ],

        # OTRS 2.0 comapt.
        CreateUserID => $UserIDs[ int( rand( $Opts{u} ) ) ],
    );

    if ($TicketID) {

        print "NOTICE: Ticket with ID '$TicketID' created.\n";

        foreach ( 1 .. 10 ) {
            my $ArticleID = $CommonObject{TicketObject}->ArticleCreate(
                TicketID       => $TicketID,
                ArticleType    => 'note-external',
                SenderType     => 'customer',
                From           => RandomAddress(),
                To             => RandomAddress(),
                Cc             => RandomAddress(),
                Subject        => RandomSubject(),
                Body           => RandomBody(),
                ContentType    => 'text/plain; charset=ISO-8859-15',
                HistoryType    => 'NewTicket',
                HistoryComment => 'Some free text!',
                UserID         => $UserIDs[ int( rand( $Opts{u} ) ) ],
                NoAgentNotify  => 1,                                     # if you don't want to send agent notifications
            );

            print "NOTICE: New Article '$ArticleID' created for Ticket '$TicketID'.\n";
        }

        foreach my $Count ( 1 .. 2 ) {
            my %FreeText = RandomFreeText($Count);
            if (%FreeText) {
                $CommonObject{TicketObject}->TicketFreeTextSet(
                    TicketID => $TicketID,
                    Key      => $FreeText{Key},
                    Value    => $FreeText{Value},
                    Counter  => $Count,
                    UserID   => $UserIDs[ int( rand( $Opts{u} ) ) ],
                );

                print
                    "NOTICE: Ticket with ID '$TicketID' updated free text $Count $FreeText{Key}:$FreeText{Value}.\n";
            }
        }

        push( @TicketIDs, $TicketID );
    }
}

# update tickets
my %States = $CommonObject{TicketObject}->StateList(
    QueueID => 1,
    UserID  => 1,
);
my @StateList = ();
foreach ( keys %States ) {
    push( @StateList, $_ );
}
my %Priorities = $CommonObject{TicketObject}->PriorityList(
    QueueID => 1,
    UserID  => 1,
);
my @PriorityList = ();
foreach ( keys %Priorities ) {
    push( @PriorityList, $_ );
}

foreach my $TicketID (@TicketIDs) {
    my %Ticket = $CommonObject{TicketObject}->TicketGet( TicketID => $TicketID );

    # add email
    my @Files = glob $CommonObject{ConfigObject}->Get('Home')
        . '/scripts/test/sample/PostMaster-Test*.box';
    my $File    = $Files[ int( rand( $#Files + 1 ) ) ];
    my @Content = ();
    open( IN, '<', $File ) || die $!;

    #    binmode(IN);
    while ( my $Line = <IN> ) {
        if ( $Line =~ /^Subject:/ ) {
            $Line = 'Subject: ' . $CommonObject{TicketObject}->TicketSubjectBuild(
                TicketNumber => $Ticket{TicketNumber},
                Subject      => $Line,
            );
        }
        push( @Content, $Line );
    }
    close(IN);

    my $PostMasterObject = Kernel::System::PostMaster->new(
        %CommonObject,
        Email => \@Content,
    );
    my @Return = $PostMasterObject->Run();

    # add article
    my $ArticleID = $CommonObject{TicketObject}->ArticleCreate(
        TicketID       => $TicketID,
        ArticleType    => 'note-external',
        SenderType     => 'agent',
        From           => RandomAddress(),
        To             => RandomAddress(),
        Cc             => RandomAddress(),
        Subject        => RandomSubject(),
        Body           => RandomBody(),
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'AddNote',
        HistoryComment => 'Some free text!',
        UserID         => $UserIDs[ int( rand( $Opts{'u'} ) ) ],
        NoAgentNotify  => 1,                                       # if you don't want to send agent notifications
    );
    print "NOTICE: Article added to Ticket '$TicketID/$ArticleID'.\n";

    # set state
    # try more times to get an closed state to be more real
    my $StateID = '';
    foreach ( 1 .. 12 ) {
        $StateID = $StateList[ int( rand( $#StateList + 1 ) ) ];
        if ( $States{$StateID} =~ /^close/ ) {
            last;
        }
    }
    $CommonObject{TicketObject}->StateSet(
        StateID            => $StateID,
        TicketID           => $TicketID,
        SendNoNotification => 1,           # optional 1|0 (send no agent and customer notification)
        UserID => $UserIDs[ int( rand( $Opts{'u'} ) ) ],
    );
    print "NOTICE: State updated of Ticket '$TicketID/$States{$StateID}'.\n";

    # priority update
    if ( $TicketID / 2 ne ( int( $TicketID / 2 ) ) ) {
        my $PriorityID = $PriorityList[ int( rand( $#PriorityList + 1 ) ) ];
        $CommonObject{TicketObject}->PrioritySet(
            TicketID   => $TicketID,
            PriorityID => $PriorityID,
            UserID     => $UserIDs[ int( rand( $Opts{'u'} ) ) ],
        );
        print "NOTICE: Priority updated of Ticket '$TicketID/$Priorities{$PriorityID}'.\n";
    }

    # link tickets
    if ( $TicketID / 2 ne ( int( $TicketID / 2 ) ) ) {
        my $TicketIDChild = $TicketIDs[ int( rand( $#TicketIDs + 1 ) ) ];

        #        $CommonObject{LinkObject}->LinkAdd(
        #            SourceObject => 'Ticket',
        #            SourceKey    => $TicketID,
        #            TargetObject => 'Ticket',
        #            TargetKey    => $TicketIDChild,
        #            Type         => 'ParentChild',
        #            State        => 'Valid',
        #            UserID       => $UserIDs[int(rand($Opts{'u'}))],
        #        );
        print "NOTICE: Link Ticket $TicketID ParentChild to Ticket $TicketIDChild.\n";
    }
}

sub RandomFreeText {
    my $Count = shift || return;
    my $Name = int( rand(500) );
    if ( $Count == 1 ) {
        return (
            Key   => 'TicketKey1',
            Value => $Name
        );
    }
    elsif ( $Count == 2 ) {
        return (
            Key   => 'TicketKey2',
            Value => $Name
        );
    }
    return;
}

sub RandomAddress {
    my $Name   = int( rand(1_000) );
    my @Domain = (
        'example.com',
        'example-sales.com',
        'example-support.com',
        'example.net',
        'example-sales.net',
        'example-support.net',
        'company.com',
        'company-sales.com',
        'company-support.com',
        'fast-company-example.com',
        'fast-company-example-sales.com',
        'fast-company-example-support.com',
        'slow-company-example.com',
        'slow-company-example-sales.com',
        'slow-company-example-support.com',
    );

    return $Name . '@' . $Domain[ int( rand( $#Domain + 1 ) ) ];
}

sub RandomSubject {
    my @Text = (
        'some subject alalal',
        'Re: subject alalal 1234',
        'Re: Some Problem with my ...',
        'Re: RE: AW: subject with very long lines',
        'and we go an very long way to home',
        'Ask me about performance',
        'What is the real questions?',
        'Do not get out of your house!',
        'Some other smart subject!',
        'Why am I here?',
        'No problem, everything is ok!',
        'Good morning!',
        'Hello again!',
        'What a wonderful day!',
        '1237891234123412784 2314 test testsetsetset set set',
    );
    return $Text[ int( rand( $#Text + 1 ) ) ];
}

sub RandomBody {
    my $Body = '';
    my @Text = (
        'some body  alalal',
        'Re: body alalal 1234',
        'and we go an very long way to home',
        'here are some other lines with what ever on information',
        'Re: RE: AW: body with  very long lines body with  very long lines body with  very long lines body with  very long lines ',
        '1237891234123412784 2314 test testsetsetset set set',
        "alal \t lala",
        'Location of the City and County of San Francisco, California',
        'The combination of cold ocean water and the high heat of the California mainland create',
        ' fall, which are the warmest months of the year. Due to its sharp topography',
        'climate with little seasonal temperature variation',
        'wet winters and dry summers.[31] In addition, since it is surrounded on three sides by water,',
        'San Francisco is located on the west coast of the U.S. at the tip of the San Francisco Peninsula',
        'Urban planning projects in the 1950s and 1960s saw widespread destruction and redevelopment of westside ',
        'The license explicitly separates any kind of "Document" from "Secondary Sections", which may not be integrated with the Document',
        'any subject matter itself. While the Document itself is wholly editable',
        "\n",
        "\r",
        'The goal of invariant sections, ever since the 80s when we first made the GNU',
        'Manifesto an invariant section in the Emacs Manual, was to make',
        'sure they could not be removed. Specifically, to make sure that distributors',
        ' Emacs that also distribute non-free software could not remove the statements of our philosophy,',
        'which they might think of doing because those statements criticize their actions.',
        'The definition of a "transparent" format is complicated, and may be difficult to apply. For example, drawings are required to be in a format that allows',
        'them to be revised straightforwardly with "some widely available drawing editor." The definition',
        'of "widely available" may be difficult to interpret, and may change over time, since, e.g., the open-source',
        'Inkscape editor is rapidly maturing, but has not yet reached version 1.0. This section, which was rewritten somewhat between versions 1.1 and 1.2 of the license, uses the terms',
        '"widely available" and "proprietary" inconsistently and without defining them. According to a strict interpretation of the license, the references to "generic text editors" ',
        'could be interpreted as ruling out any non-human-readable format even if used by an open-source ',
        'word-processor; according to a loose interpretation, however, Microsoft Word .doc format could',
        'qualify as transparent, since a subset of .doc files can be edited perfectly using ',
        'and the format therefore is not one "that can be read and edited only by proprietary word processors.',
        'In addition to being an encyclopedic reference, Wikipedia has received major media attention as an online source of breaking',
        'news as it is constantly updated.[14][15] When Time Magazine recognized "You" as their Person of',
        'the Year 2006, praising the accelerating success of on-line collaboration and interaction by millions',
        'of users around the world, Wikipedia was the first particular "Web 2.0" service mentioned.',
        'Repeating thoughts and actions is an essential part of learning. ',
        'Thinking about a specific memory will make it easy to recall. This is the reason why reviews are',
        'such an integral part of education. On first performing a task, it is difficult as there is no path',
        'from axon to dendrite. After several repetitions a pathway begins to form and the',
        'task becomes easier. When the task becomes so easy that you can perform it at any time, the pathway',
        'is fully formed. The speed at which a pathway is formed depends on the individual, but ',
        'is usually localised resulting in talents.[citation needed]',
    );
    foreach ( 1 .. 50 ) {
        $Body .= $Text[ int( rand( $#Text + 1 ) ) ] . "\n";
    }
    return $Body;
}

sub QueueGet {
    my @QueueIDs = ();
    my %Queues   = $CommonObject{QueueObject}->GetAllQueues();
    foreach ( keys %Queues ) {
        push @QueueIDs, $_;
    }
    return @QueueIDs;
}

sub QueueCreate {
    my $Count = shift || return;
    my @QueueIDs = ();
    foreach ( 1 .. $Count ) {
        my $Name = 'fill-up-queue' . int( rand(100_000_000) );
        my $ID   = $CommonObject{QueueObject}->QueueAdd(
            Name              => $Name,
            ValidID           => 1,
            GroupID           => $GroupIDs[ int( rand( $Opts{'g'} ) ) ],
            FirstResponseTime => 0,
            UpdateTime        => 0,
            SolutionTime      => 0,
            SystemAddressID   => 1,
            SalutationID      => 1,
            SignatureID       => 1,
            UserID            => 1,
            MoveNotify        => 0,
            StateNotify       => 0,
            LockNotify        => 0,
            OwnerNotify       => 0,
            Comment           => 'Some Comment',
        );
        if ($ID) {
            print "NOTICE: Queue '$Name' with ID '$ID' created.\n";
            push( @QueueIDs, $ID );
        }
    }
    return @QueueIDs;
}

sub GroupGet {
    my @GroupIDs = ();
    my %Groups = $CommonObject{GroupObject}->GroupList( Valid => 1 );
    foreach ( keys %Groups ) {
        push @GroupIDs, $_;
    }
    return @GroupIDs;
}

sub GroupCreate {
    my $Count = shift || return;
    my @GroupIDs = ();
    foreach ( 1 .. $Count ) {
        my $Name = 'fill-up-group' . int( rand(100_000_000) );
        my $ID   = $CommonObject{GroupObject}->GroupAdd(
            Name    => $Name,
            ValidID => 1,
            UserID  => 1,
        );
        if ($ID) {
            print "NOTICE: Group '$Name' with ID '$ID' created.\n";
            push( @GroupIDs, $ID );

            # add root to every group
            $CommonObject{GroupObject}->GroupMemberAdd(
                GID        => $ID,
                UID        => 1,
                Permission => {
                    ro        => 1,
                    move_into => 1,
                    create    => 1,
                    owner     => 1,
                    priority  => 0,
                    rw        => 1,
                },
                UserID => 1,
            );
        }
    }
    return @GroupIDs;
}

sub UserGet {
    my @UserIDs = ();
    my %Users   = $CommonObject{UserObject}->UserList(
        Type  => 'Short',    # Short|Long
        Valid => 1,          # not required
    );
    foreach ( keys %Users ) {
        push @UserIDs, $_;
    }
    return @UserIDs;
}

sub UserCreate {
    my $Count = shift || return;
    my @UserIDs = ();
    foreach ( 1 .. $Count ) {
        my $Name = 'fill-up-user' . int( rand(100_000_000) );
        my $ID   = $CommonObject{UserObject}->UserAdd(
            UserFirstname => "$Name-Firstname",
            UserLastname  => "$Name-Lastname",
            UserLogin     => $Name,
            UserEmail     => $Name . '@example.com',
            ValidID       => 1,
            ChangeUserID  => 1,

            # compat to OTRS 2.0
            Firstname => "$Name-Firstname",
            Lastname  => "$Name-Lastname",
            Login     => $Name,
            Email     => $Name . '@example.com',
            UserID    => 1,
        );
        if ($ID) {
            print "NOTICE: User '$Name' with ID '$ID' created.\n";
            push( @UserIDs, $ID );
            foreach my $GroupID (@GroupIDs) {
                my $GroupAdd = int( rand(3) );
                if ( $GroupAdd == 2 ) {
                    $CommonObject{GroupObject}->GroupMemberAdd(
                        GID        => $GroupID,
                        UID        => $ID,
                        Permission => {
                            ro        => 1,
                            move_into => 1,
                            create    => 1,
                            owner     => 1,
                            priority  => 0,
                            rw        => 1,
                        },
                        UserID => 1,
                    );
                }
                elsif ( $GroupAdd == 1 ) {
                    $CommonObject{GroupObject}->GroupMemberAdd(
                        GID        => $GroupID,
                        UID        => $ID,
                        Permission => {
                            ro        => 1,
                            move_into => 1,
                            create    => 1,
                            owner     => 0,
                            priority  => 0,
                            rw        => 0,
                        },
                        UserID => 1,
                    );
                }
            }
        }
    }
    return @UserIDs;
}
