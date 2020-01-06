# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Email::MailQueue;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::MailQueue',
    'Kernel::System::PID',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Mail queue management.');
    $Self->AddOption(
        Name        => 'send',
        Description => "Attempt to send all possible mails from the mail queue.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'list',
        Description => "List available messages in the mail queue (can be used with --filter).",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'delete',
        Description => "Delete messages from the mail queue (must be used with --filter).",
        Required    => 0,
        Multiple    => 0,
        HasValue    => 0,
        ValueRegex  => qr/^.+$/smx,
    );
    $Self->AddOption(
        Name        => 'delete-all',
        Description => "Delete all messages from the mail queue.",
        Required    => 0,
        Multiple    => 0,
        HasValue    => 0,
        ValueRegex  => qr/^.+$/smx,
    );
    $Self->AddOption(
        Name => 'filter',
        Description =>
            'Filter actions on messages (can be used with --list and --delete). Example: --filter="ID::1" (Possible filters: ID|ArticleID|CommunicationID|Sender|Recipient|Attempts)',
        Required   => 0,
        Multiple   => 1,
        HasValue   => 1,
        ValueRegex => qr/^.+$/smx,
    );
    $Self->AddOption(
        Name => 'force',
        Description =>
            'Force the send of the messages even if send time hasn\'t been reached (can be used with --send). Example: --send --force',
        Required => 0,
        Multiple => 0,
        HasValue => 0,
    );
    $Self->AddOption(
        Name => 'verbose',
        Description =>
            'Display debug information (can be used with --send). Example: --send --verbose',
        Required => 0,
        Multiple => 0,
        HasValue => 0,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my %Options;
    for my $Option (qw(delete delete-all list send)) {
        $Options{$Option} = 1 if $Self->GetOption($Option);
    }

    if ( scalar keys %Options > 1 ) {
        $Self->Print( $Self->GetUsageHelp() );
        die "Only one type of action allowed per execution!\n";
    }

    if ( !%Options ) {
        $Self->Print( $Self->GetUsageHelp() );
        die "Either --delete, --delete-all, --list or --send must be given!\n";
    }

    my $Filter = $Self->GetOption('filter');

    if ( $Options{delete} && !IsArrayRefWithData($Filter) ) {
        die "--filter must be provided on --delete at least one time!\n";
    }

    if ( $Options{send} ) {

        my $PIDObject = $Kernel::OM->Get('Kernel::System::PID');
        my $Force     = $Self->GetOption('force');

        if ( !$Force ) {
            my %PID = $PIDObject->PIDGet(
                Name => 'MaintMailQueueSending',
            );

            if (%PID) {
                die "Message sending already in progress! Skipping...\n";
            }
        }

        my $Success = $PIDObject->PIDCreate(
            Name  => 'MaintMailQueueSending',
            Force => $Force,
        );

        if ( !$Success ) {
            die "Unable to register sending process! Skipping...\n";
        }
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Filter = $Self->GetOption('filter');

    my $Success;

    #
    # send
    #
    if ( $Self->GetOption('send') ) {
        $Success = $Self->Send();
    }

    #
    # delete
    #
    elsif ( $Self->GetOption('delete-all') ) {
        $Success = $Self->Delete();
    }
    elsif ( $Self->GetOption('delete') ) {
        $Success = $Self->Delete( Filter => $Filter );
    }

    #
    # list
    #
    elsif ( $Self->GetOption('list') ) {
        $Success = $Self->List( Filter => $Filter );
    }

    if ($Success) {
        $Self->Print("<green>Done.</green>\n\n");
        return $Self->ExitCodeOk();
    }

    $Self->PrintError("Failed.\n\n");
    return $Self->ExitCodeError();
}

sub Send {
    my ( $Self, %Param ) = @_;

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

    my $List = $MailQueueObject->List();

    if ( !IsArrayRefWithData($List) ) {
        $Self->Print("\n<yellow>No messages available for sending.</yellow>\n");
        return 1;
    }

    my $Success = 1;

    my $SendCounter  = 0;
    my $ForceSending = $Self->GetOption('force');
    my $Verbose      = $Self->GetOption('verbose');

    MAILQUEUE:
    for my $Item (@$List) {

        my $Result = $MailQueueObject->Send(
            %{$Item},
            Force => $ForceSending,
        );

        if ( $Result->{Status} eq 'Pending' ) {
            $Self->Print("\n<yellow>Pending message with ID '$Item->{ID}' was not sent.</yellow>\n");
            $Self->Print("\n<yellow>$Result->{Message}</yellow>\n") if ($Verbose);
        }
        elsif ( $Result->{Status} eq 'Failed' ) {
            $Self->PrintError("\nCould not send message with ID '$Item->{ID}'! Please refer to the log.\n");
            $Self->Print("\n<yellow>$Result->{Message}</yellow>\n") if ($Verbose);
            $Success = 0;
        }
        else {
            $SendCounter++;
            $Self->Print("\n<yellow>Message with ID '$Item->{ID}' successfully sent.</yellow>\n") if ($Verbose);
        }
    }

    if ($SendCounter) {
        $Self->Print("\n<green>$SendCounter message(s) successfully sent!</green>\n");
    }
    else {
        $Self->Print("\n<yellow>No messages available for sending.</yellow>\n");
    }

    return $Success;
}

sub List {
    my ( $Self, %Param ) = @_;

    my %FilterOptions = $Self->_ValidateParams(%Param);

    my $List = $Kernel::OM->Get('Kernel::System::MailQueue')->List(%FilterOptions);

    if ( !IsArrayRefWithData($List) ) {
        $Self->Print("\n<yellow>Mail queue is empty.</yellow>\n");
        return 1;
    }

    my @TableHeaders = (
        'ID',
        'ArticleID',
        'Attempts',
        'Sender',
        'Recipient',
        'Due Time',
        'Last SMTP Code',
        'Last SMTP Message',
    );

    my @TableBody;

    for my $Item ( @{$List} ) {

        my $ArticleID = $Item->{ArticleID} ? $Item->{ArticleID}                   : '-';
        my $Attempts  = $Item->{Attempts}  ? "<yellow>$Item->{Attempts}</yellow>" : $Item->{Attempts};

        my $Recipient = '-';

        if ( IsArrayRefWithData( $Item->{Recipient} ) && scalar @{ $Item->{Recipient} } > 1 ) {
            my $RecipientRest = int( scalar @{ $Item->{Recipient} } - 1 );
            $Recipient = $Item->{Recipient}->[0] . " (+$RecipientRest more)";
        }
        elsif ( IsArrayRefWithData( $Item->{Recipient} ) ) {
            $Recipient = $Item->{Recipient}->[0];
        }

        my $FormatDueTime = $Item->{DueTime} ? $Item->{DueTime}->Format( Format => '%Y-%m-%d %H:%M:%S' ) : 0;

        my $DueTime     = $FormatDueTime           ? "<yellow>$FormatDueTime</yellow>"        : '-';
        my $SMTPCode    = $Item->{LastSMTPCode}    ? "<yellow>$Item->{LastSMTPCode}</yellow>" : '-';
        my $SMTPMessage = $Item->{LastSMTPMessage} ? $Item->{LastSMTPMessage}                 : '-';

        push @TableBody, [
            $Item->{ID},
            $ArticleID,
            $Attempts,
            $Item->{Sender},
            $Recipient,
            $DueTime,
            $SMTPCode,
            $SMTPMessage
        ];
    }

    my $TableOutput = $Self->TableOutput(
        TableData => {
            Header => \@TableHeaders,
            Body   => \@TableBody,
        },
        Indention => 2,
    );

    $Self->Print("\n$TableOutput\n");

    my $ListCount = scalar @{$List};

    $Self->Print("  <yellow>Mail queue contains $ListCount message(s)</yellow>\n\n");

    return 1;
}

sub Delete {
    my ( $Self, %Param ) = @_;

    my %FilterOptions = $Self->_ValidateParams(%Param);

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

    my $List = $MailQueueObject->List(%FilterOptions);

    if ( !IsArrayRefWithData($List) ) {
        $Self->Print("\n<yellow>No matching messages for deletion.</yellow>\n");
        return 1;
    }

    $FilterOptions{SetTransmissionArticleError} = "Sending of this email was cancelled.";

    if ( !$MailQueueObject->Delete(%FilterOptions) ) {
        $Self->PrintError("\nCould not delete messages from mail queue! Please refer to the log.\n");
        return;
    }

    $Self->Print("\n<green>Deleted messages from mail queue.</green>\n");
    return 1;
}

sub _ValidateParams {
    my ( $Self, %Param ) = @_;

    my %Options;

    PARAM:
    for my $FilterParam ( @{ $Param{Filter} } ) {

        my ( $Key, $Value ) = split '::', $FilterParam;

        next PARAM if $Key !~ m{^(ID|ArticleID|CommunicationID|Sender|Recipient|Attempts)$}xms;

        $Options{$Key} = $Value;
    }

    return %Options;
}

sub PostRun {
    my ($Self) = @_;

    my $PIDObject = $Kernel::OM->Get('Kernel::System::PID');

    my %PID = $PIDObject->PIDGet(
        Name => 'MaintMailQueueSending',
    );

    if (%PID) {
        return $PIDObject->PIDDelete( Name => 'MaintMailQueueSending' );
    }

    return 1;
}

1;
