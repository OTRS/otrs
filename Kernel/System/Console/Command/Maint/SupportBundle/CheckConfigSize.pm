# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::SupportBundle::CheckConfigSize;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::SupportBundleGenerator',
    'Kernel::System::JSON',
    'Kernel::System::YAML',
    'Kernel::System::SysConfig::DB',
    'Kernel::System::User',
    'Kernel::System::SysConfig',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Generate a support bundle for this system.');
    $Self->AddOption(
        Name        => 'target-directory',
        Description => "Specify a custom output directory.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'test',
        Description => "Specify a custom output directory.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'run',
        Description => "Specify a custom output directory.",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $TargetDirectory = $Self->GetOption('target-directory');
    if ( $TargetDirectory && !-d $TargetDirectory ) {
        die "Directory $TargetDirectory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Generating SysConfigExport...</yellow>\n");

    my $JSONResult = '';
    my $YAMLResult = '';

    if ( $Self->GetOption('run') ) {

        my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');
        my $UserObject        = $Kernel::OM->Get('Kernel::System::User');

        # lists
        my @List = $SysConfigDBObject->DefaultSettingListGet();

        my %UserList = $UserObject->UserList(
            Valid => 1,
        );

        # CheckItems
        my $Count      = 0;
        my $ByteLength = 0;

        my $ModifiedSetting       = 0;
        my $UserModifiedSetting   = 0;
        my $SaveSettingsAndValues = {};

        CONFIGS:
        for my $ItemHash (@List) {
            next CONFIGS if !$ItemHash;
            next CONFIGS if ref $ItemHash ne 'HASH';

            $ByteLength += length( $ItemHash->{Name} );

            # Default Value
            my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
                Name => $ItemHash->{Name},
            );
            next CONFIGS if !%DefaultSetting;
            if ( defined $DefaultSetting{EffectiveValue} ) {
                $ByteLength += length( $DefaultSetting{EffectiveValue} );
                $SaveSettingsAndValues->{'-'}->{ $ItemHash->{Name} } = $DefaultSetting{EffectiveValue};
            }

            # Modified Value
            my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
                Name     => $ItemHash->{Name},
                IsGlobal => 1,
            );
            if ( defined $ModifiedSetting{EffectiveValue} ) {
                $ByteLength += length( $ModifiedSetting{EffectiveValue} );
                $SaveSettingsAndValues->{'-mod-'}->{ $ItemHash->{Name} } = $ModifiedSetting{EffectiveValue};
                $ModifiedSetting++;
            }

            # User specific Values
            for my $Username ( sort keys %UserList ) {
                my %User = $UserObject->GetUserData(
                    User => $Username,
                );
                my %ModifiedUserSetting = $SysConfigDBObject->ModifiedSettingGet(
                    Name         => $ItemHash->{Name},
                    TargetUserID => $User{UserID},
                    IsGlobal     => 1,
                );
                if ( defined $ModifiedUserSetting{EffectiveValue} ) {
                    $ByteLength += length( $ModifiedUserSetting{EffectiveValue} );
                    $SaveSettingsAndValues->{$Username}->{ $ItemHash->{Name} } = $ModifiedUserSetting{EffectiveValue};
                    $UserModifiedSetting++;
                }
            }

            $Count++;
            if ( $Self->GetOption('test') ) {
                last CONFIGS;
            }
        }

        $JSONResult = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
            Data => $SaveSettingsAndValues,
        );

        $YAMLResult = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
            Data => $SaveSettingsAndValues,
        );

        my $KByte = $ByteLength / 1024;
        my $MByte = $KByte / 1024;

        $Self->Print( "<yellow>" . scalar @List . " - DefaultSettings ListSize </yellow>\n" );
        $Self->Print("<yellow>$ModifiedSetting - Modified</yellow>\n");
        my $Users = keys %UserList;
        $Self->Print("<yellow>$Users - Agentcount</yellow>\n");

        #$Self->Print("<yellow>$UserModifiedSetting - Modified by Users</yellow>\n");
        $Self->Print("<green>'$ByteLength' Byte -> $MByte MB</green>\n");
        $Self->Print( "<green>" . length($JSONResult) . "Byte - JSON-String-Length</green>\n" );
        $Self->Print( "<green>" . length($YAMLResult) . "Byte - YAML-String-Length(1)</green>\n" );
    }
    else {
        my $Export = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationDump(
            OnlyValues => 1,
        );
        $Self->Print( "<green>" . length($Export) . "Byte - YAML-String-Length (2)</green>\n" );
    }

    if ( $Self->GetOption('test') ) {
        $Self->Print("\nJSON\n$JSONResult\n");
        $Self->Print("\nYAML\n$YAMLResult\n");
    }

    my $OutputDir = $Self->GetOption('target-directory') || $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # my $FileLocation = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
    #     Location   => $OutputDir . '/' . $FileData->{Filename},
    #     Content    => $FileData->{Filecontent},
    #     Mode       => 'binmode',
    #     Permission => '644',
    # );

    # if ( !$FileLocation ) {
    #     $Self->PrintError("Support bundle could not be saved.");
    #     return $Self->ExitCodeError();
    # }

    #$Self->Print("<green>SysConfigExport saved to:</green> <yellow>$FileLocation</yellow>\n");

    return $Self->ExitCodeOk();
}

# sub PostRun {
#     my ( $Self, %Param ) = @_;
#
#     # This will be called after Run() (even in case of exceptions). Perform any cleanups here.
#
#     return;
# }

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
