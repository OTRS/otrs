# --
# VirtualFS.t - VirtualFS tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::VirtualFS;
use Kernel::Config;

# create local object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my @Tests = (
    {
        Name        => '.txt',
        Location    => 'scripts/test/sample/VirtualFS/VirtualFS-Test1.txt',
        Filename    => 'TEST/File.txt',
        Mode        => 'utf8',
        MD5         => '26ea4a608d77c62ed0e4b0f8952c9df2',
        Find        => '*txt',
        FindNot     => '*.txt_*',
        Preferences => {
            ContentType => 'text/plain',
            ContentID   => '<some_id_xls@example.com>',
        },
        FindPreferences => {
            ContentType => 'text/plain',
            ContentID   => '<some_id_xls@example.com>',
        },
        FindNotPreferences => {
            ContentType => 'text/xml',
            ContentID   => '<some_id_xls@example.net>',
        },
        FindFilenameAndPreferences => {
            Filename    => 'TEST/File.txt',
            Preferences => {
                ContentType => 'text/plain',
            },
        },
    },
    {
        Name        => '.pdf',
        Location    => 'scripts/test/sample/VirtualFS/VirtualFS-Test2.pdf',
        Filename    => 'me_t o_alal.pdf',
        Mode        => 'binmode',
        MD5         => '5ee767f3b68f24a9213e0bef82dc53e5',
        Find        => '*.pdf',
        FindNot     => '*.pdf_*',
        Preferences => {
            ContentType => 'text/plain',
            ContentID   => '<some_id@example.com>',
        },
        FindPreferences => {
            ContentType => 'text/plain',
            ContentID   => '<some_id@example.com>',
        },
        FindNotPreferences => {
            ContentType => 'text/rfc-822',
            ContentID   => '<some_id@example.net>',
        },
        FindFilenameAndPreferences => {
            Filename    => 'me_t o_alal.pdf',
            Preferences => {
                ContentType => 'text/plain',
                ContentID   => '<some_id@example.com>',
            },
        },
    },
    {
        Name        => '.xls',
        Location    => 'scripts/test/sample/VirtualFS/VirtualFS-Test3.xls',
        Filename    => 'me_t o_alal.xls',
        Mode        => 'binmode',
        MD5         => '39fae660239f62bb0e4a29fe14ff5663',
        Find        => '*xls',
        FindNot     => '*.xls_*',
        Preferences => {
            ContentType => 'text/xls',
            ContentID   => '<some_id_xls@example.com>',
        },
        FindPreferences => {
            ContentType => 'text/*',
        },
        FindNotPreferences => {
            ContentType => 'image/png',
            ContentID   => '<some_id_xls@example.com>',
        },
        FindFilenameAndPreferences => {
            Filename    => 'me_t o_alal.xls',
            Preferences => {
                ContentType => 'text/xls',
                ContentID   => '<some_id_xls@example.com>',
            },
        },
    },
);

for my $Backend (qw( FS DB )) {

    $ConfigObject->Set(
        Key   => 'VirtualFS::Backend',
        Value => 'Kernel::System::VirtualFS::' . $Backend,
    );

    my $VirtualFSObject = Kernel::System::VirtualFS->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );

    for my $Test (@Tests) {
        my $Content = $Self->{MainObject}->FileRead(
            Location => $ConfigObject->Get('Home') . '/' . $Test->{Location},
            Mode     => $Test->{Mode},
        );
        my $MD5Sum = $Self->{MainObject}->MD5sum( String => ${$Content} );
        $Self->Is(
            $MD5Sum || '',
            $Test->{MD5},
            "$Backend MD5sum() - pre - $Test->{Name}",
        );

        # write
        my %Preferences = %{ $Test->{Preferences} };
        my $Success     = $VirtualFSObject->Write(
            Filename    => $Test->{Filename},
            Mode        => $Test->{Mode},
            Content     => $Content,
            Preferences => \%Preferences,
        );
        $Self->True(
            $Success,
            "$Backend Write - $Test->{Name}",
        );

        # read
        my %File = $VirtualFSObject->Read(
            Filename => $Test->{Filename},
            Mode     => $Test->{Mode},
        );
        $Self->True(
            $File{Content},
            "$Backend Read() - $Test->{Name}",
        );
        $MD5Sum = $Self->{MainObject}->MD5sum( String => $File{Content} );
        $Self->Is(
            $MD5Sum || '',
            $Test->{MD5},
            "$Backend MD5sum() - post - $Test->{Name}",
        );

        # preferences
        for my $Key ( sort keys %{ $Test->{Preferences} } ) {
            $Self->Is(
                $File{Preferences}->{$Key},
                $Test->{Preferences}->{$Key},
                "$Backend Read() - preferences - $Key - $Test->{Name}",
            );
        }

        # find
        my @List = $VirtualFSObject->Find( Filename => $Test->{Find} );
        my $Hit = 0;
        for (@List) {
            if ( $_ eq $Test->{Filename} ) {
                $Hit = 1;
            }
        }
        $Self->True(
            $Hit,
            "$Backend Find() - $Test->{Find}",
        );

        # find not
        @List = $VirtualFSObject->Find( Filename => $Test->{FindNot} );
        $Hit = 0;
        for (@List) {
            if ( $_ eq $Test->{Filename} ) {
                $Hit = 1;
            }
        }
        $Self->False(
            $Hit,
            "$Backend Find() - $Test->{FindNot}",
        );

        # find preferences
        @List = $VirtualFSObject->Find( Preferences => $Test->{FindPreferences} );
        $Hit = 0;
        for (@List) {
            if ( $_ eq $Test->{Filename} ) {
                $Hit = 1;
            }
        }
        $Self->True(
            $Hit,
            "$Backend Find() - Preferences",
        );

        # find not preferences
        @List = $VirtualFSObject->Find( Preferences => $Test->{FindNotPreferences} );
        $Hit = 0;
        for (@List) {
            if ( $_ eq $Test->{Filename} ) {
                $Hit = 1;
            }
        }
        $Self->False(
            $Hit,
            "$Backend Find() - Preferences Not",
        );

        # find filename AND preferences
        @List = $VirtualFSObject->Find( %{ $Test->{FindFilenameAndPreferences} } );
        $Hit  = 0;
        for (@List) {
            if ( $_ eq $Test->{Filename} ) {
                $Hit = 1;
            }
        }
        $Self->True(
            $Hit,
            "$Backend Find() - Filename AND Preferences",
        );
    }

    # delete
    for my $Test (@Tests) {
        my $Delete = $VirtualFSObject->Delete( Filename => $Test->{Filename} );
        $Self->True(
            $Delete,
            "$Backend Delete() - $Test->{Name}",
        );
    }
}

1;
