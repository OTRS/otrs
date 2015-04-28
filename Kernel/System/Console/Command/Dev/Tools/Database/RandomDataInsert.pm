# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Dev::Tools::Database::RandomDataInsert;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Group',
    'Kernel::System::Queue',
    'Kernel::System::Ticket',
    'Kernel::System::User',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Insert random data into the OTRS database for testing purposes.');
    $Self->AddOption(
        Name        => 'generate-tickets',
        Description => "Specify how many tickets should be generated.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );
    $Self->AddOption(
        Name        => 'articles-per-ticket',
        Description => "Specify how many articles should be generated per ticket.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );
    $Self->AddOption(
        Name        => 'generate-users',
        Description => "Specify how many users should be generated.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );
    $Self->AddOption(
        Name        => 'generate-customer-users',
        Description => "Specify how many customer users should be generated.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );
    $Self->AddOption(
        Name        => 'generate-groups',
        Description => "Specify how many groups should be generated.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );
    $Self->AddOption(
        Name        => 'generate-queues',
        Description => "Specify how many queues should be generated.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );
    $Self->AddOption(
        Name        => 'mark-tickets-as-seen',
        Description => "Specify if the generated tickets should be marked as seen.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AdditionalHelp("<red>Please don't use this command in production environments.</red>\n");

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # set dummy sendmail module to avoid notifications
    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'SendmailModule',
        Value => 'Kernel::System::Email::DoNotSendEmail',
    );
    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'CheckEmailAddresses',
        Value => 0,
    );

    # Refresh common objects after a certain number of loop iterations.
    #   This will call event handlers and clean up caches to avoid excessive mem usage.
    my $CommonObjectRefresh = 50;

    # get dynamic fields
    my $TicketDynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    my $ArticleDynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Article'],
    );

    # groups
    my @GroupIDs;
    if ( !$Self->GetOption('generate-groups') ) {
        @GroupIDs = GroupGet();
    }
    else {
        @GroupIDs = GroupCreate( $Self->GetOption('generate-groups') );
    }

    # users
    my @UserIDs;
    if ( !$Self->GetOption('generate-users') ) {
        @UserIDs = UserGet();
    }
    else {
        @UserIDs = UserCreate( $Self->GetOption('generate-users'), \@GroupIDs );
    }

    # queues
    my @QueueIDs;
    if ( !$Self->GetOption('generate-queues') ) {
        @QueueIDs = QueueGet();
    }
    else {
        @QueueIDs = QueueCreate( $Self->GetOption('generate-queues'), \@GroupIDs );
    }

    if ( $Self->GetOption('generate-customer-users') ) {
        CustomerCreate( $Self->GetOption('generate-customer-users') );
    }

    my $Counter = 1;

    # create tickets
    my @TicketIDs;
    for ( 1 .. $Self->GetOption('generate-tickets') ) {
        my $TicketUserID =

            my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
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

        if ( $Self->GetOption('mark-tickets-as-seen') ) {

            # bulk-insert the flags directly for improved performance
            my $SQL = 'INSERT INTO ticket_flag (ticket_id, ticket_key, ticket_value, create_time, create_by) VALUES ';
            my @Values;
            for my $UserID (@UserIDs) {
                push @Values, "($TicketID, 'Seen', 1, current_timestamp, $UserID)";
            }
            while ( my @ValuesPart = splice( @Values, 0, 50 ) ) {
                $Kernel::OM->Get('Kernel::System::DB')->Do( SQL => $SQL . join( ',', @ValuesPart ) );
            }
        }

        if ($TicketID) {

            print "Ticket with ID '$TicketID' created.\n";

            for ( 1 .. $Self->GetOption('articles-per-ticket') // 10 ) {
                my $ArticleID = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleCreate(
                    TicketID       => $TicketID,
                    ArticleType    => 'note-external',
                    SenderType     => 'customer',
                    From           => RandomAddress(),
                    To             => RandomAddress(),
                    Cc             => RandomAddress(),
                    Subject        => RandomSubject(),
                    Body           => RandomBody(),
                    ContentType    => 'text/plain; charset=ISO-8859-15',
                    HistoryType    => 'AddNote',
                    HistoryComment => 'Some free text!',
                    UserID         => $UserIDs[ int( rand($#UserIDs) ) ],
                    NoAgentNotify  => 1,                                 # if you don't want to send agent notifications
                );

                if ( $Self->GetOption('mark-tickets-as-seen') ) {

                    # bulk-insert the flags directly for improved performance
                    my $SQL
                        = 'INSERT INTO article_flag (article_id, article_key, article_value, create_time, create_by) VALUES ';
                    my @Values;
                    for my $UserID (@UserIDs) {
                        push @Values, "($ArticleID, 'Seen', 1, current_timestamp, $UserID)";
                    }
                    while ( my @ValuesPart = splice( @Values, 0, 50 ) ) {
                        $Kernel::OM->Get('Kernel::System::DB')->Do( SQL => $SQL . join( ',', @ValuesPart ) );
                    }
                }

                DYNAMICFIELD:
                for my $DynamicFieldConfig ( @{$ArticleDynamicField} ) {
                    next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                    next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Article';
                    next DYNAMICFIELD if $DynamicFieldConfig->{InternalField};

                    # set a random value
                    my $Result = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->RandomValueSet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ObjectID           => $ArticleID,
                        UserID             => $UserIDs[ int( rand($#UserIDs) ) ],
                    );

                    if ( $Result->{Success} ) {
                        print "Article with ID '$ArticleID' set dynamic field "
                            . "$DynamicFieldConfig->{Name}: $Result->{Value}.\n";
                    }
                }

                print "New Article '$ArticleID' created for Ticket '$TicketID'.\n";
            }

            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{$TicketDynamicField} ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Ticket';
                next DYNAMICFIELD if $DynamicFieldConfig->{InternalField};

                # set a random value
                my $Result = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->RandomValueSet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ObjectID           => $TicketID,
                    UserID             => $UserIDs[ int( rand($#UserIDs) ) ],
                );

                if ( $Result->{Success} ) {
                    print "Ticket with ID '$TicketID' set dynamic field "
                        . "$DynamicFieldConfig->{Name}: $Result->{Value}.\n";
                }
            }

            push( @TicketIDs, $TicketID );

            if ( $Counter++ % $CommonObjectRefresh == 0 ) {
                $Kernel::OM->ObjectsDiscard(
                    Objects => ['Kernel::System::Ticket'],
                );
            }
        }
    }

    return $Self->ExitCodeOk();
}

#
# Helper functions below
#
sub RandomAddress {
    my $Name   = int( rand(1_000) );
    my @Domain = (
        'example.com',
        'example-sales.com',
        'example-service.com',
        'example.net',
        'example-sales.net',
        'example-service.net',
        'company.com',
        'company-sales.com',
        'company-service.com',
        'fast-company-example.com',
        'fast-company-example-sales.com',
        'fast-company-example-service.com',
        'slow-company-example.com',
        'slow-company-example-sales.com',
        'slow-company-example-service.com',
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
    my @QueueIDs;
    my %Queues = $Kernel::OM->Get('Kernel::System::Queue')->GetAllQueues();
    for ( sort keys %Queues ) {
        push @QueueIDs, $_;
    }
    return @QueueIDs;
}

sub QueueCreate {
    my $Count = shift || return;
    my @GroupIDs = @{ shift() };

    my @QueueIDs;
    for ( 1 .. $Count ) {
        my $Name = 'fill-up-queue' . int( rand(100_000_000) );
        my $ID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
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
            print "Queue '$Name' with ID '$ID' created.\n";
            push( @QueueIDs, $ID );
        }
    }
    return @QueueIDs;
}

sub GroupGet {
    my @GroupIDs;
    my %Groups = $Kernel::OM->Get('Kernel::System::Group')->GroupList( Valid => 1 );
    for ( sort keys %Groups ) {
        push @GroupIDs, $_;
    }
    return @GroupIDs;
}

sub GroupCreate {
    my $Count = shift || return;

    my @GroupIDs;
    for ( 1 .. $Count ) {
        my $Name = 'fill-up-group' . int( rand(100_000_000) );
        my $ID   = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $Name,
            ValidID => 1,
            UserID  => 1,
        );
        if ($ID) {
            print "Group '$Name' with ID '$ID' created.\n";
            push( @GroupIDs, $ID );

            # add root to every group
            $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupUserAdd(
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
    my @UserIDs;
    my %Users = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Short',    # Short|Long
        Valid => 1,          # not required
    );
    for ( sort keys %Users ) {
        push @UserIDs, $_;
    }
    return @UserIDs;
}

sub UserCreate {
    my $Count = shift || return;
    my @GroupIDs = @{ shift() };

    my @UserIDs;
    for ( 1 .. $Count ) {
        my $Name = 'fill-up-user' . int( rand(100_000_000) );
        my $ID   = $Kernel::OM->Get('Kernel::System::User')->UserAdd(
            UserFirstname => "$Name-Firstname",
            UserLastname  => "$Name-Lastname",
            UserLogin     => $Name,
            UserEmail     => $Name . '@example.com',
            ValidID       => 1,
            ChangeUserID  => 1,
        );
        if ($ID) {
            print "User '$Name' with ID '$ID' created.\n";
            push( @UserIDs, $ID );
            for my $GroupID (@GroupIDs) {
                my $GroupAdd = int( rand(3) );
                if ( $GroupAdd == 2 ) {
                    $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupUserAdd(
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
                    $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupUserAdd(
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
    my $Count = shift || return;

    for ( 1 .. $Count ) {
        my $Name      = 'fill-up-user' . int( rand(100_000_000) );
        my $UserLogin = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',            # CustomerUser source config
            UserFirstname  => $Name,
            UserLastname   => $Name,
            UserCustomerID => $Name,
            UserLogin      => $Name,
            UserEmail      => $Name . '@example2.com',
            ValidID        => 1,
            UserID         => 1,
        );
        print "CustomerUser '$Name' created.\n";
    }
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
