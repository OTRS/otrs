# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Dev::Tools::Database::XML2SQL;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

## nofilter(TidyAll::Plugin::OTRS::Perl::ObjectManagerCreation)

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Main',
    'Kernel::System::XML',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Convert OTRS database XML to SQL.');
    $Self->AddOption(
        Name        => 'database-type',
        Description => "Specify the database to generate SQL for (mysql|postgresql|oracle|all).",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/^(mysql|postgresql|oracle|all)$/smx,
    );
    $Self->AddOption(
        Name        => 'source-path',
        Description => "Read XML from the specified file (otherwise STDIN will be used).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'target-directory',
        Description => "Specify the output directory (otherwise the result will be printed on the console).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'target-filename',
        Description => "Specify the output filename.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'split-files',
        Description => "Split foreign key creation into a separate (post) SQL file.",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $TargetDirectory = $Self->GetOption('target-directory');
    if ($TargetDirectory) {
        if ( !-d $TargetDirectory ) {
            die "Directory $TargetDirectory does not exist.\n";
        }
        my $TargetFilename = $Self->GetOption('target-filename');
        if ( !$TargetFilename ) {
            die "Please provide the option 'target-filename'.\n";
        }
    }
    my $SourceFilename = $Self->GetOption('source-path');
    if ( $SourceFilename && !-r $SourceFilename ) {
        die "Source file $SourceFilename does not exist / cannot be read.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my @DatabaseType = ( $Self->GetOption('database-type') );
    if ( $Self->GetOption('database-type') eq 'all' ) {
        @DatabaseType = qw(mysql postgresql oracle)
    }

    my $SourceFilename = $Self->GetOption('source-path');
    my $SourceXML;
    if ($SourceFilename) {
        my $FileStringRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location        => $SourceFilename,
            Mode            => 'utf8',
            Type            => 'Local',
            Result          => 'SCALAR',
            DisableWarnings => 1,
        );

        $SourceXML = ${$FileStringRef};
    }
    else {
        # read xml data from STDIN
        $SourceXML = do { local $/; <STDIN> };
    }

    for my $DatabaseType (@DatabaseType) {

        local $Kernel::OM = Kernel::System::ObjectManager->new();

        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'Database::Type',
            Value => $DatabaseType,
        );
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'Database::ShellOutput',
            Value => 1,
        );

        # parse xml package
        my @XMLARRAY = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $SourceXML );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        my $Head = $DBObject->{Backend}->{'DB::Comment'}
            . "----------------------------------------------------------\n";
        $Head .= $DBObject->{Backend}->{'DB::Comment'}
            . " driver: $DatabaseType\n";
        $Head .= $DBObject->{Backend}->{'DB::Comment'}
            . "----------------------------------------------------------\n";

        # get sql from parsed xml
        my @SQL;
        if ( $DBObject->{Backend}->{'DB::ShellConnect'} ) {
            push @SQL, $DBObject->{Backend}->{'DB::ShellConnect'};
        }
        push @SQL, $DBObject->SQLProcessor( Database => \@XMLARRAY );

        # get port sql from parsed xml
        my @SQLPost;
        if ( $DBObject->{Backend}->{'DB::ShellConnect'} ) {
            push @SQLPost, $DBObject->{Backend}->{'DB::ShellConnect'};
        }
        push @SQLPost, $DBObject->SQLProcessorPost();

        my $TargetFilename     = $Self->GetOption('target-filename');
        my $TargetFilenamePost = $Self->GetOption('target-filename');
        if ($TargetFilename) {
            $TargetFilename     = $Self->GetOption('target-directory') . "/$TargetFilename.$DatabaseType.sql";
            $TargetFilenamePost = $Self->GetOption('target-directory') . "/$TargetFilenamePost-post.$DatabaseType.sql";
        }

        if ( $Self->GetOption('split-files') ) {

            # write create script
            $Self->Dump(
                $TargetFilename,
                \@SQL,
                $Head,
                $DBObject->{Backend}->{'DB::ShellCommit'},
            );

            # write post script
            $Self->Dump(
                $TargetFilenamePost,
                \@SQLPost,
                $Head,
                $DBObject->{Backend}->{'DB::ShellCommit'},
            );
        }
        else {
            $Self->Dump(
                $TargetFilename,
                [ @SQL, @SQLPost ],
                $Head,
                $DBObject->{Backend}->{'DB::ShellCommit'},
            );
        }
    }
    return $Self->ExitCodeOk();
}

sub Dump {
    my ( $Self, $Filename, $SQL, $Head, $Commit ) = @_;

    if ($Filename) {

        my $Content = $Head;
        for my $Item ( @{$SQL} ) {
            $Content .= $Item . $Commit . "\n";
        }

        $Self->Print("Writing: <yellow>$Filename</yellow>\n");

        my $Written = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Location => $Filename,
            Content  => \$Content,
            Mode     => 'utf8',
            Type     => 'Local',
        );

        if ( !$Written ) {
            $Self->PrintError("Could not write $Filename.");
        }
    }
    else {
        print $Head;
        for my $Item ( @{$SQL} ) {
            print $Item . $Commit . "\n";
        }
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
