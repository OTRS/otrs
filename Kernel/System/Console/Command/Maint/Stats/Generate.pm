# --
# Kernel/System/Console/Command/Maint/Stats/Generate.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Stats::Generate;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::CSV',
    'Kernel::System::CheckItem',
    'Kernel::System::Email',
    'Kernel::System::PDF',
    'Kernel::System::Stats',
    'Kernel::System::Time',
    'Kernel::System::User',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description(
        'Generate (and send, optional) statistics which have been configured previously in the OTRS statistics module.'
    );
    $Self->AddOption(
        Name        => 'number',
        Description => "Statistic number as shown in the overview of AgentStats.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/\d+/smx,
    );
    $Self->AddOption(
        Name => 'params',
        Description =>
            "Parameters which should be passed to the statistic (e.g. Year=1977&Month=10, not for dynamic statistics).",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'target-filename',
        Description => "Filename for the generated file.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name => 'target-directory',
        Description =>
            "Directory to which the generated file should be written (e.g. /output/dir/). If a target directory is provided, no email will be sent.",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'format',
        Description => "Target format (CSV|Excel|PDF) for which the file should be generated (defaults to CSV).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/(CSV|Excel|PDF)/smx,
    );
    $Self->AddOption(
        Name        => 'separator',
        Description => "Defines the separator in case of CSV as target format (defaults to ';').",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name => 'with-header',
        Description =>
            "Adds a heading line consisting of statistics title and creation date in case of Excel or CSV as output format.",
        Required   => 0,
        HasValue   => 0,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name => 'language',
        Description =>
            "Target language (e.g. de) for which the file should be generated (will be OTRS default language or english as fallback if left empty).",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'mail-sender',
        Description => "Email address which should appear as sender for the generated file.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'mail-recipient',
        Description => "Recipient email address to which the generated file should be send.",
        Required    => 0,
        HasValue    => 1,
        Multiple    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'mail-body',
        Description => "Body content for the email which has the generated statistics file attached.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # create object manager
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Stats' => {
            UserID => 1,
        },
    );

    # check if the passed stat number exists
    $Self->{StatNumber} = $Self->GetOption('number');
    $Self->{StatID} = $Kernel::OM->Get('Kernel::System::Stats')->StatNumber2StatID( StatNumber => $Self->{StatNumber} );
    if ( !$Self->{StatID} ) {
        die "There is no statistic with number '$Self->{StatNumber}'.\n";
    }

    # either target directory or mail recipient needs to be defined
    if ( !$Self->GetOption('target-directory') && !$Self->GetOption('mail-recipient') ) {
        die "Need either --target-directory or at least one --mail-recipient.\n";
    }

    # if params have been passed, we build up a body containing the configured params
    # which is then used as default
    $Self->{Params} = $Self->GetOption('params');
    $Self->{MailBody} = $Self->GetOption('mail-body') || '';
    if ( !$Self->{MailBody} && $Self->{Params} ) {
        $Self->{MailBody} .= "Stats with following options:\n\n";
        $Self->{MailBody} .= "StatNumber: " . $Self->GetOption('number') . "\n";
        my @P = split( /&/, $Self->{Params} );
        for (@P) {
            my ( $Key, $Value ) = split( /=/, $_, 2 );
            $Self->{MailBody} .= "$Key: $Value\n";
        }
    }

    # if there is a recipient, we also need a mail body
    if ( $Self->GetOption('mail-recipient') && !$Self->{MailBody} ) {
        die
            "You defined at least one --mail-recipient which means that you also need to define a mail body using --mail-body.'\n";
    }

    # if a target directory has been passed, check if it exists
    $Self->{TargetDirectory} = $Self->GetOption('target-directory');
    if ( $Self->{TargetDirectory} && !-e $Self->{TargetDirectory} ) {
        die "The target directory '$Self->{TargetDirectory}' does not exist.\n";
    }

    # set up used language
    $Self->{Language} = $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage') || 'en';
    if ( $Self->GetOption('language') ) {
        $Self->{Language} = $Self->GetOption('language');
    }

    # set up used format & separator
    $Self->{Format}    = $Self->GetOption('format')    || 'CSV';
    $Self->{Separator} = $Self->GetOption('separator') || ';';

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # create object manager
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Stats' => {
            UserID => 1,
        },
    );

    $Self->Print("<yellow>Generating statistic number $Self->{StatNumber}...</yellow>\n");

    my ( $s, $m, $h, $D, $M, $Y ) =
        $Kernel::OM->Get('Kernel::System::Time')->SystemTime2Date(
        SystemTime => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
        );

    my %GetParam;
    my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet( StatID => $Self->{StatID} );

    if ( $Stat->{StatType} eq 'static' ) {
        $GetParam{Year}  = $Y;
        $GetParam{Month} = $M;
        $GetParam{Day}   = $D;

        # get params from -p
        # only for static files
        my $Params = $Kernel::OM->Get('Kernel::System::Stats')->GetParams( StatID => $Self->{StatID} );
        for my $ParamItem ( @{$Params} ) {
            if ( !$ParamItem->{Multiple} ) {
                my $Value = GetParam(
                    Param  => $ParamItem->{Name},
                    Params => $Self->{Params}
                );
                if ( defined $Value ) {
                    $GetParam{ $ParamItem->{Name} } =
                        GetParam(
                        Param  => $ParamItem->{Name},
                        Params => $Self->{Params},
                        );
                }
                elsif ( defined $ParamItem->{SelectedID} ) {
                    $GetParam{ $ParamItem->{Name} } = $ParamItem->{SelectedID};
                }
            }
            else {
                my @Value = GetArray(
                    Param  => $ParamItem->{Name},
                    Params => $Self->{Params},
                );
                if (@Value) {
                    $GetParam{ $ParamItem->{Name} } = \@Value;
                }
                elsif ( defined $ParamItem->{SelectedID} ) {
                    $GetParam{ $ParamItem->{Name} } = [ $ParamItem->{SelectedID} ];
                }
            }
        }
    }
    elsif ( $Stat->{StatType} eq 'dynamic' ) {
        %GetParam = %{$Stat};
    }

    # run stat...
    my @StatArray = @{
        $Kernel::OM->Get('Kernel::System::Stats')->StatsRun(
            StatID   => $Self->{StatID},
            GetParam => \%GetParam,
            )
    };

    # generate output
    my $TitleArrayRef  = shift(@StatArray);
    my $Title          = $TitleArrayRef->[0];
    my $HeadArrayRef   = shift(@StatArray);
    my $CountStatArray = @StatArray;
    my $Time           = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, $h, $m, $s );
    if ( !@StatArray ) {
        push( @StatArray, [ ' ', 0 ] );
    }
    my %Attachment;

    if ( $Self->{Format} eq 'PDF' && $Kernel::OM->Get('Kernel::System::PDF') ) {

        $Self->Print("<yellow>Chosen format: PDF.</yellow>\n");

        # Create the PDF
        my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData( UserID => 1 );

        my $PrintedBy  = $Kernel::OM->Get('Kernel::Language')->Translate('printed by');
        my $Page       = $Kernel::OM->Get('Kernel::Language')->Translate('Page');
        my $SystemTime = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();
        my $TimeStamp =
            $Kernel::OM->Get('Kernel::System::Time')->SystemTime2TimeStamp(
            SystemTime => $SystemTime,
            );
        my $Time =
            $Kernel::OM->Get('Kernel::Language')->FormatTimeString(
            $TimeStamp, 'DateFormat'
            );

        # create the content array
        my $CellData;
        my $CounterRow  = 0;
        my $CounterHead = 0;
        for my $Content ( @{$HeadArrayRef} ) {
            $CellData->[$CounterRow]->[$CounterHead]->{Content} = $Content;
            $CellData->[$CounterRow]->[$CounterHead]->{Font}    = 'ProportionalBold';
            $CounterHead++;
        }
        if ( $CounterHead > 0 ) {
            $CounterRow++;
        }
        for my $Row (@StatArray) {
            my $CounterColumn = 0;
            for my $Content ( @{$Row} ) {
                $CellData->[$CounterRow]->[$CounterColumn]->{Content} = $Content;
                $CounterColumn++;
            }
            $CounterRow++;
        }
        if ( !$CellData->[0]->[0] ) {
            $CellData->[0]->[0]->{Content} =
                $Kernel::OM->Get('Kernel::Language')->Translate('No Result!');
        }

        # page params
        my %PageParam;
        $PageParam{PageOrientation} = 'landscape';
        $PageParam{MarginTop}       = 30;
        $PageParam{MarginRight}     = 40;
        $PageParam{MarginBottom}    = 40;
        $PageParam{MarginLeft}      = 40;
        $PageParam{HeaderRight} =
            $Kernel::OM->Get('Kernel::Config')->Get('Stats::StatsHook')
            . $Stat->{StatNumber};
        $PageParam{FooterLeft}   = 'otrs.GenerateStats.pl';
        $PageParam{HeadlineLeft} = $Title;
        $PageParam{HeadlineRight} =
            $PrintedBy . ' '
            . $User{UserFirstname} . ' '
            . $User{UserLastname} . ' ('
            . $User{UserEmail} . ') '
            . $Time;

        # table params
        my %TableParam;
        $TableParam{CellData}            = $CellData;
        $TableParam{Type}                = 'Cut';
        $TableParam{FontSize}            = 6;
        $TableParam{Border}              = 0;
        $TableParam{BackgroundColorEven} = '#AAAAAA';
        $TableParam{BackgroundColorOdd}  = '#DDDDDD';
        $TableParam{Padding}             = 1;
        $TableParam{PaddingTop}          = 3;
        $TableParam{PaddingBottom}       = 3;

        # get maximum number of pages
        my $MaxPages = $Kernel::OM->Get('Kernel::Config')->Get('PDF::MaxPages');
        if ( !$MaxPages || $MaxPages < 1 || $MaxPages > 1000 ) {
            $MaxPages = 100;
        }

        # create new pdf document
        $Kernel::OM->Get('Kernel::System::PDF')->DocumentNew(
            Title  => $Kernel::OM->Get('Kernel::Config')->Get('Product') . ': ' . $Title,
            Encode => 'utf-8',
        );

        # start table output
        my $Loop    = 1;
        my $Counter = 1;
        while ($Loop) {

            # if first page
            if ( $Counter == 1 ) {
                $Kernel::OM->Get('Kernel::System::PDF')->PageNew(
                    %PageParam,
                    FooterRight => $Page . ' ' . $Counter,
                );
            }

            # output table (or a fragment of it)
            %TableParam = $Kernel::OM->Get('Kernel::System::PDF')->Table( %TableParam, );

            # stop output or another page
            if ( $TableParam{State} ) {
                $Loop = 0;
            }
            else {
                $Kernel::OM->Get('Kernel::System::PDF')->PageNew(
                    %PageParam,
                    FooterRight => $Page . ' ' . ( $Counter + 1 ),
                );
            }
            $Counter++;

            # check max pages
            if ( $Counter >= $MaxPages ) {
                $Loop = 0;
            }
        }

        # return the document
        my $PDFString = $Kernel::OM->Get('Kernel::System::PDF')->DocumentOutput();

        # save the pdf with the title and timestamp as filename, or read it from param
        my $Filename;
        if ( $Self->GetOption('target-filename') ) {
            $Filename = $Self->GetOption('target-filename');
        }
        else {
            $Filename = $Kernel::OM->Get('Kernel::System::Stats')->StringAndTimestamp2Filename(
                String => $Stat->{Title} . " Created",
            );
        }
        %Attachment = (
            Filename    => $Filename . ".pdf",
            ContentType => "application/pdf",
            Content     => $PDFString,
            Encoding    => "base64",
            Disposition => "attachment",
        );
    }
    elsif ( $Self->{Format} eq 'Excel' ) {

        # Create the Excel data
        my $Output;

        $Self->Print("<yellow>Chosen format: Excel.</yellow>\n");

        # Only add the name if parameter is set
        if ( $Self->GetOption('with-header') ) {
            $Output .= "Name: $Title; Created: $Time\n";
        }
        $Output .= $Kernel::OM->Get('Kernel::System::CSV')->Array2CSV(
            Head   => $HeadArrayRef,
            Data   => \@StatArray,
            Format => 'Excel',
        );

        # save the Excel with the title and timestamp as filename, or read it from param
        my $Filename;
        if ( $Self->GetOption('target-filename') ) {
            $Filename = $Self->GetOption('target-filename');
        }
        else {
            $Filename = $Kernel::OM->Get('Kernel::System::Stats')->StringAndTimestamp2Filename(
                String => $Stat->{Title} . " Created",
            );
        }

        %Attachment = (
            Filename    => $Filename . ".xlsx",
            ContentType => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            Content     => $Output,
            Encoding    => "base64",
            Disposition => "attachment",
        );
    }
    else {

        # Create the CSV data
        my $Output;

        $Self->Print("<yellow>Chosen format: CSV.</yellow>\n");

        # Only add the name if parameter is set
        if ( $Self->GetOption('with-header') ) {
            $Output .= "Name: $Title; Created: $Time\n";
        }
        $Output .= $Kernel::OM->Get('Kernel::System::CSV')->Array2CSV(
            Head      => $HeadArrayRef,
            Data      => \@StatArray,
            Separator => $Self->{Separator},
        );

        # save the csv with the title and timestamp as filename, or read it from param
        my $Filename;
        if ( $Self->GetOption('target-filename') ) {
            $Filename = $Self->GetOption('target-filename');
        }
        else {
            $Filename = $Kernel::OM->Get('Kernel::System::Stats')->StringAndTimestamp2Filename(
                String => $Stat->{Title} . " Created",
            );
        }

        %Attachment = (
            Filename    => $Filename . ".csv",
            ContentType => "text/csv",
            Content     => $Output,
            Encoding    => "base64",
            Disposition => "attachment",
        );
    }

    # write output
    if ( $Self->{TargetDirectory} ) {
        if ( open my $Filehandle, '>', "$Self->{TargetDirectory}/$Attachment{Filename}" ) {    ## no critic
            print $Filehandle $Attachment{Content};
            close $Filehandle;
            $Self->Print("<yellow>Writing file $Self->{TargetDirectory}/$Attachment{Filename}.</yellow>\n");
            $Self->Print("<green>Done.</green>\n");
            return $Self->ExitCodeOk();
        }
        else {
            $Self->PrintError("Can't write $Self->{TargetDirectory}/$Attachment{Filename}: $!");
            return $Self->ExitCodeError();
        }
    }

    # send email
    RECIPIENT:
    for my $Recipient ( @{ $Self->GetOption('mail-recipient') // [] } ) {

        # recipient check
        if ( !$Kernel::OM->Get('Kernel::System::CheckItem')->CheckEmail( Address => $Recipient ) ) {

            $Self->PrintError(
                "Warning: email address $Recipient invalid, skipping address."
                    . $Kernel::OM->Get('Kernel::System::CheckItem')->CheckError()
            );
            next RECIPIENT;
        }

        $Kernel::OM->Get('Kernel::System::Email')->Send(
            From       => $Self->GetOption('mail-sender'),
            To         => $Recipient,
            Subject    => "[Stats - $CountStatArray Records] $Title; Created: $Time",
            Body       => $Kernel::OM->Get('Kernel::Language')->Translate( $Self->{MailBody} ),
            Charset    => 'utf-8',
            Attachment => [ {%Attachment}, ],
        );
        $Self->Print("<yellow>Email sent to '$Recipient'.</yellow>\n");
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub GetParam {
    my (%Param) = @_;

    if ( !$Param{Param} ) {
        print STDERR "ERROR: Need 'Param' in GetParam()\n";
    }
    my @P = split( /&/, $Param{Params} || '' );
    for (@P) {
        my ( $Key, $Value ) = split( /=/, $_, 2 );
        if ( $Key eq $Param{Param} ) {
            return $Value;
        }
    }
    return;
}

sub GetArray {
    my (%Param) = @_;

    if ( !$Param{Param} ) {
        print STDERR "ERROR: Need 'Param' in GetArray()\n";
    }
    my @P = split( /&/, $Param{Params} || '' );
    my @Array;
    for (@P) {
        my ( $Key, $Value ) = split( /=/, $_, 2 );
        if ( $Key eq $Param{Param} ) {
            push( @Array, $Value );
        }
    }
    return @Array;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
