# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Article::MIMEBase;

use strict;
use warnings;

use parent 'Kernel::Output::HTML::Article::Base';

use Mail::Address;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CheckItem',
    'Kernel::System::CustomerUser',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ArticleFields()

Returns common article fields for a MIMEBase article.

    my %ArticleFields = $LayoutObject->ArticleFields(
        TicketID  => 123,   # (required)
        ArticleID => 123,   # (required)
    );

Returns:

    %ArticleFields = (
        Sender => {                     # mandatory
            Label => 'Sender',
            Value => 'John Doe',
            Prio  => 100,
        },
        Subject => {                    # mandatory
            Label => 'Subject',
            Value => 'Article subject',
            Prio  => 200,
        },
        PGP => {
            Label => 'PGP',             # mandatory
            Value => 'Value',           # mandatory
            Class => 'Class',           # optional
            ...
        },
        ...
    );

=cut

sub ArticleFields {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Result;

    my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject         = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $MainObject           = $Kernel::OM->Get('Kernel::System::Main');
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        %Param,
        DynamicFields => 0,
    );

    my %Article = $ArticleBackendObject->ArticleGet(
        %Param,
        DynamicFields => 1,
        RealNames     => 1,
    );

    # cleanup subject
    $Article{Subject} = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSubjectClean(
        TicketNumber => $Ticket{TicketNumber},
        Subject      => $Article{Subject} || '',
        Size         => 0,
    );

    $Result{Subject} = {
        Label => 'Subject',
        Value => $Article{Subject},
    };

    # run article view modules
    my $Config = $ConfigObject->Get('Ticket::Frontend::ArticleViewModule');

    if ( ref $Config eq 'HASH' ) {
        my %Jobs = %{$Config};

        JOB:
        for my $Job ( sort keys %Jobs ) {

            # load module
            next JOB if !$MainObject->Require( $Jobs{$Job}->{Module} );

            my $Object = $Jobs{$Job}->{Module}->new(
                TicketID  => $Self->{TicketID},
                ArticleID => $Param{ArticleID},
                UserID    => $Param{UserID} || 1,
            );

            # run module
            my @Data = $Object->Check(
                Article => \%Article,
                %Ticket, Config => $Jobs{$Job}
            );
            for my $DataRef (@Data) {
                if ( !$DataRef->{Successful} ) {
                    $DataRef->{Result} = 'Error';
                }
                else {
                    $DataRef->{Result} = 'Notice';
                }

                $Result{ $DataRef->{Key} } = {
                    Label => $DataRef->{Key},
                    Value => $DataRef->{Value},
                    Class => $DataRef->{Result},
                    Type  => 'ArticleOption',
                };

                for my $Warning ( @{ $DataRef->{Warnings} } ) {
                    $Result{ $DataRef->{Key} } = {
                        Label => $Warning->{Key},
                        Value => $Warning->{Value},
                        Class => $Warning->{Result},
                        Type  => 'ArticleOption',
                    };
                }
            }

            # TODO: Check how to implement this.
            # # filter option
            # $Object->Filter(
            #     Article => \%Article,
            #     %Ticket, Config => $Jobs{$Job}
            # );
        }
    }

    # do some strips && quoting
    my $RecipientDisplayType = $ConfigObject->Get('Ticket::Frontend::DefaultRecipientDisplayType') || 'Realname';
    my $SenderDisplayType    = $ConfigObject->Get('Ticket::Frontend::DefaultSenderDisplayType')    || 'Realname';
    KEY:
    for my $Key (qw(From To Cc Bcc)) {
        next KEY if !$Article{$Key};

        my $DisplayType = $Key eq 'From'             ? $SenderDisplayType : $RecipientDisplayType;
        my $HiddenType  = $DisplayType eq 'Realname' ? 'Value'            : 'Realname';
        $Result{$Key} = {
            Label                   => $Key,
            Value                   => $Article{$Key},
            Realname                => $Article{ $Key . 'Realname' },
            ArticleID               => $Article{ArticleID},
            $HiddenType . Hidden    => 'Hidden',
            HideInCustomerInterface => $Key eq 'Bcc' ? 1 : undef,
        };
        if ( $Key eq 'From' ) {
            $Result{Sender} = {
                Label                => Translatable('Sender'),
                Value                => $Article{From},
                Realname             => $Article{FromRealname},
                $HiddenType . Hidden => 'Hidden',
                HideInTimelineView   => 1,
                HideInTicketPrint    => 1,
            };
        }
    }

    # Assign priority.
    my $Priority = 100;
    for my $Key (qw(From To Cc Bcc)) {
        if ( $Result{$Key} ) {
            $Result{$Key}->{Prio} = $Priority;
            $Priority += 100;
        }
    }

    my @FieldsWithoutPrio = grep { !$Result{$_}->{Prio} } sort keys %Result;

    my $BasePrio = 100000;
    for my $Key (@FieldsWithoutPrio) {
        $Result{$Key}->{Prio} = $BasePrio++;
    }

    return %Result;
}

=head2 ArticlePreview()

Returns article preview for a MIMEBase article.

    $LayoutObject->ArticlePreview(
        TicketID   => 123,     # (required)
        ArticleID  => 123,     # (required)
        ResultType => 'plain', # (optional) plain|HTML. Default HTML.
        MaxLength  => 50,      # (optional) performs trimming (for plain result only)
    );

Returns article preview in scalar form:

    $ArticlePreview = 'Hello, world!';

If HTML preview was requested, but HTML content does not exist for an article, this function will return undef.

=cut

sub ArticlePreview {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( $Param{MaxLength} && !IsPositiveInteger( $Param{MaxLength} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "MaxLength must be positive integer!"
        );

        return;
    }

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    my %Article = $ArticleBackendObject->ArticleGet(
        %Param,
        DynamicFields => 0,
    );

    my $Result;

    if ( $Param{ResultType} && $Param{ResultType} eq 'plain' ) {

        # plain
        $Result = $Article{Body};

        if ( $Param{MaxLength} ) {

            # trim
            $Result = substr( $Result, 0, $Param{MaxLength} );
        }
    }
    else {
        my $HTMLBodyAttachmentID = $Self->HTMLBodyAttachmentIDGet(%Param);

        if ($HTMLBodyAttachmentID) {

            # Preview doesn't include inline images...
            my %Data = $ArticleBackendObject->ArticleAttachment(
                ArticleID => $Param{ArticleID},
                FileID    => $HTMLBodyAttachmentID,
            );

            # Get the charset directly from the attachment hash and convert content to the internal charset (utf-8).
            #   Please see bug#13367 for more information.
            my $Charset;
            if ( $Data{ContentType} =~ m/.+?charset=("|'|)(?<Charset>.+)/ig ) {
                $Charset = $+{Charset};
                $Charset =~ s/"|'//g;
            }
            else {
                $Charset = 'us-ascii';
            }

            $Result = $Kernel::OM->Get('Kernel::System::Encode')->Convert(
                Text  => $Data{Content},
                From  => $Charset,
                To    => 'utf-8',
                Check => 1,
            );
        }
    }

    return $Result;
}

=head2 HTMLBodyAttachmentIDGet()

Returns HTMLBodyAttachmentID.

    my $HTMLBodyAttachmentID = $LayoutObject->HTMLBodyAttachmentIDGet(
        TicketID  => 123,     # (required)
        ArticleID => 123,     # (required)
    );

Returns

    $HTMLBodyAttachmentID = 23;

=cut

sub HTMLBodyAttachmentIDGet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    # Get a HTML attachment.
    my %AttachmentIndexHTMLBody = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID    => $Param{ArticleID},
        OnlyHTMLBody => 1,
    );

    my ($HTMLBodyAttachmentID) = sort keys %AttachmentIndexHTMLBody;

    return $HTMLBodyAttachmentID;
}

=head2 ArticleCustomerRecipientsGet()

Get customer users from an article to use as recipients.

    my @CustomerUserIDs = $LayoutObject->ArticleCustomerRecipientsGet(
        TicketID  => 123,     # (required)
        ArticleID => 123,     # (required)
    );

Returns array of customer user IDs who should receive a message:

    @CustomerUserIDs = (
        'customer-1',
        'customer-2',
        ...
    );

=cut

sub ArticleCustomerRecipientsGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Article = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param)->ArticleGet(%Param);
    return if !%Article;

    my $RecipientEmail = $Article{From};

    # Check ReplyTo.
    if ( $Article{ReplyTo} ) {
        $RecipientEmail = $Article{ReplyTo};
    }

    # Check article type and use To in case sender is not customer.
    if ( $Article{SenderType} !~ /customer/ ) {
        $RecipientEmail = $Article{To};
        $Article{ReplyTo} = '';
    }

    my $CheckItemObject    = $Kernel::OM->Get('Kernel::System::CheckItem');
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    my @CustomerUserIDs;

    EMAIL:
    for my $Email ( Mail::Address->parse($RecipientEmail) ) {
        next EMAIL if !$CheckItemObject->CheckEmail( Address => $Email->address() );

        # Get single customer user from customer backend based on the email address.
        my %CustomerSearch = $CustomerUserObject->CustomerSearch(
            PostMasterSearch => $Email->address(),
            Limit            => 1,
        );
        next EMAIL if !%CustomerSearch;

        # Save customer user ID if not already present in the list.
        for my $CustomerUserID ( sort keys %CustomerSearch ) {
            push @CustomerUserIDs, $CustomerUserID if !grep { $_ eq $CustomerUserID } @CustomerUserIDs;
        }
    }

    return @CustomerUserIDs;
}

1;
