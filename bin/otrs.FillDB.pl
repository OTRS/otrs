#!/usr/bin/perl
# --
# bin/otrs.FillDB.pl - fill db with demo data
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Getopt::Std;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::User;
use Kernel::System::CustomerUser;
use Kernel::System::Group;
use Kernel::System::Queue;
use Kernel::System::Ticket;
use Kernel::System::PostMaster;
use Kernel::System::LinkObject;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

sub _CommonObjects {
    my %Objects;
    $Objects{ConfigObject} = Kernel::Config->new();

    # set dummy sendmail module
    $Objects{ConfigObject}->Set(
        Key   => 'SendmailModule',
        Value => 'Kernel::System::Email::DoNotSendEmail',
    );

    # set env config
    $Objects{ConfigObject}->Set(
        Key   => 'CheckEmailInvalidAddress',
        Value => 0,
    );

    $Objects{EncodeObject} = Kernel::System::Encode->new(%Objects);
    $Objects{LogObject}    = Kernel::System::Log->new(
        LogPrefix => 'OTRS-otrs.FillDB.pl',
        %Objects,
    );
    $Objects{TimeObject}         = Kernel::System::Time->new(%Objects);
    $Objects{MainObject}         = Kernel::System::Main->new(%Objects);
    $Objects{DBObject}           = Kernel::System::DB->new(%Objects);
    $Objects{UserObject}         = Kernel::System::User->new(%Objects);
    $Objects{CustomerUserObject} = Kernel::System::CustomerUser->new(%Objects);
    $Objects{GroupObject}        = Kernel::System::Group->new(%Objects);
    $Objects{QueueObject}        = Kernel::System::Queue->new(%Objects);
    $Objects{TicketObject}       = Kernel::System::Ticket->new(%Objects);
    $Objects{LinkObject}         = Kernel::System::LinkObject->new(%Objects);
    $Objects{DynamicFieldObject} = Kernel::System::DynamicField->new(%Objects);
    $Objects{DynamicFieldBackendObject}
        = Kernel::System::DynamicField::Backend->new(%Objects);

    return \%Objects;
}

sub Run {

    my $CommonObjects = _CommonObjects();

    # Refresh common objects after a certain number of loop iterations.
    #   This will call event handlers and clean up caches to avoid excessive mem usage.
    my $CommonObjectRefresh = 50;

    # get dynamic fields
    my $TicketDynamicField = $CommonObjects->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    my $ArticleDynamicField = $CommonObjects->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Article'],
    );

    # get options
    my %Opts = ();
    getopt( 'hqugtramc', \%Opts );
    if ( $Opts{h} ) {
        print <<EOF;
otrs.FillDB.pl - OTRS fill db with data
Copyright (C) 2001-2012 OTRS AG, http://otrs.org/

usage: otrsFillDB.pl -q <QUEUES> -t <TICKETS> -m <MODIFY_TICKETS> -a <ARTICLES> -f <SETSEENFLAG> -u <USERS> -g <GROUPS> -c <CUSTOMERUSERS> -r <REALLYDOTHIS>
EOF
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
    if ( !$Opts{a} ) {
        print STDERR
            "NOTICE: No -a <COUNTOFARTICLES> given, take default number of articles (10)!\n";
    }
    if ( !$Opts{c} ) {
        print STDERR
            "NOTICE: No -c <COUNTOFCUSTOMERS> given, will not create any new customers!\n";
    }
    if ( !$Opts{t} ) {
        print STDERR "ERROR: Need -t <COUNTOFTICKETS>\n";
        exit(1);
    }

    # check if DB is empty
    $CommonObjects->{DBObject}->Prepare( SQL => 'SELECT count(*) FROM ticket' );
    my $Check = 0;
    while ( my @Row = $CommonObjects->{DBObject}->FetchrowArray() ) {
        $Check = $Row[0];
    }
    if ( $Check && $Check > 1 && ( !$Opts{r} || $Opts{r} !~ /^yes$/i ) ) {
        print STDERR "ERROR: Sorry, can't do this. It looks like an productive database!\n";
        print STDERR
            "ERROR: You have $Check tickets in there. Only do this on non productive system\n";
        print STDERR "ERROR: Your really want to do this? Use '-r yes'\n";
        exit(1);
    }

    # groups
    my @GroupIDs;
    if ( !$Opts{g} ) {
        @GroupIDs = GroupGet($CommonObjects);
    }
    else {
        @GroupIDs = GroupCreate( $CommonObjects, $Opts{g} );
    }

    # users
    my @UserIDs;
    if ( !$Opts{u} ) {
        @UserIDs = UserGet($CommonObjects);
    }
    else {
        @UserIDs = UserCreate( $CommonObjects, $Opts{u}, \@GroupIDs );
    }

    # queues
    my @QueueIDs;
    if ( !$Opts{q} ) {
        @QueueIDs = QueueGet($CommonObjects);
    }
    else {
        @QueueIDs = QueueCreate( $CommonObjects, $Opts{q}, \@GroupIDs );
    }

    if ( $Opts{c} ) {
        CustomerCreate( $CommonObjects, $Opts{c} );
    }

    # articles - use default if not set
    if ( !$Opts{a} ) {
        $Opts{a} = 10;
    }

    my $Counter = 1;

    # create tickets
    my @TicketIDs = ();
    for ( 1 .. $Opts{'t'} ) {
        my $TicketUserID =

            my $TicketID = $CommonObjects->{TicketObject}->TicketCreate(
            Title        => RandomSubject(),
            QueueID      => $QueueIDs[ int( rand($#QueueIDs) ) ],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerNo   => int( rand(1000) ),
            CustomerUser => RandomAddress(),
            OwnerID      => $UserIDs[ int( rand($#UserIDs) ) ],
            UserID       => $UserIDs[ int( rand($#UserIDs) ) ],
            );

        if ( $Opts{f} ) {

            # bulk-insert the flags directly for improved performance
            my $SQL
                = 'INSERT INTO ticket_flag (ticket_id, ticket_key, ticket_value, create_time, create_by) VALUES ';
            my @Values;
            for my $UserID (@UserIDs) {
                push @Values, "($TicketID, 'Seen', 1, current_timestamp, $UserID)";
            }
            while ( my @ValuesPart = splice( @Values, 0, 50 ) ) {
                $CommonObjects->{DBObject}->Do( SQL => $SQL . join( ',', @ValuesPart ) );
            }
        }

        if ($TicketID) {

            print "NOTICE: Ticket with ID '$TicketID' created.\n";

            for ( 1 .. $Opts{'a'} ) {
                my $ArticleID = $CommonObjects->{TicketObject}->ArticleCreate(
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
                    UserID         => $UserIDs[ int( rand($#UserIDs) ) ],
                    NoAgentNotify => 1,    # if you don't want to send agent notifications
                );

                if ( $Opts{f} ) {

                    # bulk-insert the flags directly for improved performance
                    my $SQL
                        = 'INSERT INTO article_flag (article_id, article_key, article_value, create_time, create_by) VALUES ';
                    my @Values;
                    for my $UserID (@UserIDs) {
                        push @Values, "($ArticleID, 'Seen', 1, current_timestamp, $UserID)";
                    }
                    while ( my @ValuesPart = splice( @Values, 0, 50 ) ) {
                        $CommonObjects->{DBObject}->Do( SQL => $SQL . join( ',', @ValuesPart ) );
                    }
                }

                DYNAMICFIELD:
                for my $DynamicFieldConfig ( @{$ArticleDynamicField} ) {
                    next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                    next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Article';
                    next DYNAMICFIELD if $DynamicFieldConfig->{InternalField};

                    # set a random value
                    my $Result = $CommonObjects->{DynamicFieldBackendObject}->RandomValueSet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ObjectID           => $ArticleID,
                        UserID             => $UserIDs[ int( rand($#UserIDs) ) ],
                    );

                    if ( $Result->{Success} ) {
                        print "NOTICE: Article with ID '$ArticleID' set dynamic field "
                            . "$DynamicFieldConfig->{Name}: $Result->{Value}.\n";
                    }
                }

                print "NOTICE: New Article '$ArticleID' created for Ticket '$TicketID'.\n";
            }

            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{$TicketDynamicField} ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Ticket';
                next DYNAMICFIELD if $DynamicFieldConfig->{InternalField};

                # set a random value
                my $Result = $CommonObjects->{DynamicFieldBackendObject}->RandomValueSet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ObjectID           => $TicketID,
                    UserID             => $UserIDs[ int( rand($#UserIDs) ) ],
                );

                if ( $Result->{Success} ) {
                    print "NOTICE: Ticket with ID '$TicketID' set dynamic field "
                        . "$DynamicFieldConfig->{Name}: $Result->{Value}.\n";
                }
            }

            push( @TicketIDs, $TicketID );

            if ( $Counter++ % $CommonObjectRefresh == 0 ) {
                $CommonObjects = _CommonObjects();
            }
        }
    }

    if ( $Opts{m} ) {

        # update tickets
        my %States = $CommonObjects->{TicketObject}->StateList(
            QueueID => 1,
            UserID  => 1,
        );
        my @StateList = ();
        for ( sort keys %States ) {
            push( @StateList, $_ );
        }
        my %Priorities = $CommonObjects->{TicketObject}->PriorityList(
            QueueID => 1,
            UserID  => 1,
        );
        my @PriorityList = ();
        for ( sort keys %Priorities ) {
            push( @PriorityList, $_ );
        }

        for my $TicketID (@TicketIDs) {
            my %Ticket = $CommonObjects->{TicketObject}->TicketGet(
                TicketID      => $TicketID,
                DynamicFields => 0,
            );

            # add email
            my @Files = glob $CommonObjects->{ConfigObject}->Get('Home')
                . '/scripts/test/sample/PostMaster/PostMaster-Test*.box';
            my $File    = $Files[ int( rand( $#Files + 1 ) ) ];
            my @Content = ();
            my $Input;
            open( $Input, '<', $File ) || die $!;    ## no critic

            #    binmode(IN);
            while ( my $Line = <$Input> ) {
                if ( $Line =~ /^Subject:/ ) {
                    $Line = 'Subject: ' . $CommonObjects->{TicketObject}->TicketSubjectBuild(
                        TicketNumber => $Ticket{TicketNumber},
                        Subject      => $Line,
                    );
                }
                push( @Content, $Line );
            }
            close($Input);

            my $PostMasterObject = Kernel::System::PostMaster->new(
                %{$CommonObjects},
                Email => \@Content,
            );
            my @Return = $PostMasterObject->Run();

            # add article
            my $ArticleID = $CommonObjects->{TicketObject}->ArticleCreate(
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
                UserID         => $UserIDs[ int( rand($#UserIDs) ) ],
                NoAgentNotify => 1,    # if you don't want to send agent notifications
            );
            print "NOTICE: Article added to Ticket '$TicketID/$ArticleID'.\n";

            # set state
            # try more times to get an closed state to be more real
            my $StateID = '';
            for ( 1 .. 12 ) {
                $StateID = $StateList[ int( rand( $#StateList + 1 ) ) ];
                if ( $States{$StateID} =~ /^close/ ) {
                    last;
                }
            }
            $CommonObjects->{TicketObject}->StateSet(
                StateID  => $StateID,
                TicketID => $TicketID,
                SendNoNotification => 1,    # optional 1|0 (send no agent and customer notification)
                UserID => $UserIDs[ int( rand($#UserIDs) ) ],
            );
            print "NOTICE: State updated of Ticket '$TicketID/$States{$StateID}'.\n";

            # priority update
            if ( $TicketID / 2 ne ( int( $TicketID / 2 ) ) ) {
                my $PriorityID = $PriorityList[ int( rand( $#PriorityList + 1 ) ) ];
                $CommonObjects->{TicketObject}->PrioritySet(
                    TicketID   => $TicketID,
                    PriorityID => $PriorityID,
                    UserID     => $UserIDs[ int( rand($#UserIDs) ) ],
                );
                print "NOTICE: Priority updated of Ticket '$TicketID/$Priorities{$PriorityID}'.\n";
            }

=cut
            # link tickets
            if ( $TicketID / 2 ne ( int( $TicketID / 2 ) ) ) {
                my $TicketIDChild = $TicketIDs[ int( rand( $#TicketIDs + 1 ) ) ];

                $CommonObjects->{LinkObject}->LinkAdd(
                    SourceObject => 'Ticket',
                    SourceKey    => $TicketID,
                    TargetObject => 'Ticket',
                    TargetKey    => $TicketIDChild,
                    Type         => 'ParentChild',
                    State        => 'Valid',
                    UserID       => $UserIDs[int(rand($#UserIDs))],
                );
                print "NOTICE: Link Ticket $TicketID ParentChild to Ticket $TicketIDChild.\n";
            }
=cut

            if ( $Counter++ % $CommonObjectRefresh == 0 ) {
                $CommonObjects = _CommonObjects();
            }
        }
    }
}

#
# Helper functions below
#
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
    for ( 1 .. 50 ) {
        $Body .= $Text[ int( rand( $#Text + 1 ) ) ] . "\n";
    }
    return $Body;
}

sub QueueGet {
    my $CommonObjects = shift;

    my @QueueIDs = ();
    my %Queues   = $CommonObjects->{QueueObject}->GetAllQueues();
    for ( sort keys %Queues ) {
        push @QueueIDs, $_;
    }
    return @QueueIDs;
}

sub QueueCreate {
    my $CommonObjects = shift;
    my $Count         = shift || return;
    my @GroupIDs      = @{ shift() };

    my @QueueIDs = ();
    for ( 1 .. $Count ) {
        my $Name = 'fill-up-queue' . int( rand(100_000_000) );
        my $ID   = $CommonObjects->{QueueObject}->QueueAdd(
            Name              => $Name,
            ValidID           => 1,
            GroupID           => $GroupIDs[ int( rand( scalar @GroupIDs ) ) ],
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
    my $CommonObjects = shift;

    my @GroupIDs = ();
    my %Groups = $CommonObjects->{GroupObject}->GroupList( Valid => 1 );
    for ( sort keys %Groups ) {
        push @GroupIDs, $_;
    }
    return @GroupIDs;
}

sub GroupCreate {
    my $CommonObjects = shift;
    my $Count = shift || return;

    my @GroupIDs = ();
    for ( 1 .. $Count ) {
        my $Name = 'fill-up-group' . int( rand(100_000_000) );
        my $ID   = $CommonObjects->{GroupObject}->GroupAdd(
            Name    => $Name,
            ValidID => 1,
            UserID  => 1,
        );
        if ($ID) {
            print "NOTICE: Group '$Name' with ID '$ID' created.\n";
            push( @GroupIDs, $ID );

            # add root to every group
            $CommonObjects->{GroupObject}->GroupMemberAdd(
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
    my $CommonObjects = shift;

    my @UserIDs = ();
    my %Users   = $CommonObjects->{UserObject}->UserList(
        Type  => 'Short',    # Short|Long
        Valid => 1,          # not required
    );
    for ( sort keys %Users ) {
        push @UserIDs, $_;
    }
    return @UserIDs;
}

sub UserCreate {
    my $CommonObjects = shift;
    my $Count         = shift || return;
    my @GroupIDs      = @{ shift() };

    my @UserIDs = ();
    for ( 1 .. $Count ) {
        my $Name = 'fill-up-user' . int( rand(100_000_000) );
        my $ID   = $CommonObjects->{UserObject}->UserAdd(
            UserFirstname => "$Name-Firstname",
            UserLastname  => "$Name-Lastname",
            UserLogin     => $Name,
            UserEmail     => $Name . '@example.com',
            ValidID       => 1,
            ChangeUserID  => 1,
        );
        if ($ID) {
            print "NOTICE: User '$Name' with ID '$ID' created.\n";
            push( @UserIDs, $ID );
            for my $GroupID (@GroupIDs) {
                my $GroupAdd = int( rand(3) );
                if ( $GroupAdd == 2 ) {
                    $CommonObjects->{GroupObject}->GroupMemberAdd(
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
                    $CommonObjects->{GroupObject}->GroupMemberAdd(
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

sub CustomerCreate {
    my $CommonObjects = shift;
    my $Count = shift || return;

    for ( 1 .. $Count ) {
        my $Name      = 'fill-up-user' . int( rand(100_000_000) );
        my $UserLogin = $CommonObjects->{CustomerUserObject}->CustomerUserAdd(
            Source         => 'CustomerUser',            # CustomerUser source config
            UserFirstname  => $Name,
            UserLastname   => $Name,
            UserCustomerID => $Name,
            UserLogin      => $Name,
            UserEmail      => $Name . '@example2.com',
            ValidID        => 1,
            UserID         => 1,
        );
        print "NOTICE: CustomerUser '$Name' created.\n";
    }
}

Run();

exit 0;
