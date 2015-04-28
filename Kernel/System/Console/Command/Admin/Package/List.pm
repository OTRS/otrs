# --
# Kernel/System/Console/Command/Admin/Package/List.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Admin::Package::List;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::Package',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('List all installed OTRS packages.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Listing all installed packages...</yellow>\n");

    my @Packages = $Kernel::OM->Get('Kernel::System::Package')->RepositoryList();

    if ( !@Packages ) {
        $Self->Print("<green>There are no packages installed.</green>\n");
        return $Self->ExitCodeOk();
    }

    PACKAGE:
    for my $Package (@Packages) {

        # Just show if PackageIsVisible flag is enabled.
        if (
            defined $Package->{PackageIsVisible}
            && !$Package->{PackageIsVisible}->{Content}
            )
        {
            next PACKAGE;
        }

        my %Data = $Self->_PackageMetadataGet(
            Tag       => $Package->{Description},
            StripHTML => 0,
        );
        $Self->Print("+----------------------------------------------------------------------------+\n");
        $Self->Print("| <yellow>Name:</yellow>        $Package->{Name}->{Content}\n");
        $Self->Print("| <yellow>Version:</yellow>     $Package->{Version}->{Content}\n");
        $Self->Print("| <yellow>Vendor:</yellow>      $Package->{Vendor}->{Content}\n");
        $Self->Print("| <yellow>URL:</yellow>         $Package->{URL}->{Content}\n");
        $Self->Print("| <yellow>License:</yellow>     $Package->{License}->{Content}\n");
        $Self->Print("| <yellow>Description:</yellow> $Data{Description}\n");
    }
    $Self->Print("+----------------------------------------------------------------------------+\n");

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

=item _PackageMetadataGet()

locates information in tags that are language specific.
First, 'en' is looked for, if that is not present, the first found language will be used.

    my %Data = $CommandObject->_PackageMetadataGet(
        Tag       => $Package->{Description},
        StripHTML => 1,         # optional, perform HTML->ASCII conversion (default 1)
    );

    my %Data = $Self->_PackageMetadataGet(
        Tag => $Structure{IntroInstallPost},
        AttributeFilterKey   => 'Type',
        AttributeFilterValue =>  'pre',
    );

Returns the content and the title of the tag in a hash:

    my %Result = (
        Description => '...',   # tag content
        Title       => '...',   # tag title
    );

=cut

sub _PackageMetadataGet {
    my ( $Self, %Param ) = @_;

    return if !ref $Param{Tag};

    my $AttributeFilterKey   = $Param{AttributeFilterKey};
    my $AttributeFilterValue = $Param{AttributeFilterValue};

    my $Title       = '';
    my $Description = '';

    TAG:
    for my $Tag ( @{ $Param{Tag} } ) {
        if ($AttributeFilterKey) {
            if ( lc $Tag->{$AttributeFilterKey} ne lc $AttributeFilterValue ) {
                next TAG;
            }
        }
        if ( !$Description && $Tag->{Lang} eq 'en' ) {
            $Description = $Tag->{Content} || '';
            $Title       = $Tag->{Title}   || '';
        }
    }
    if ( !$Description ) {
        TAG:
        for my $Tag ( @{ $Param{Tag} } ) {
            if ($AttributeFilterKey) {
                if ( lc $Tag->{$AttributeFilterKey} ne lc $AttributeFilterValue ) {
                    next TAG;
                }
            }
            if ( !$Description ) {
                $Description = $Tag->{Content} || '';
                $Title       = $Tag->{Title}   || '';
            }
        }
    }

    if ( !defined $Param{StripHTML} || $Param{StripHTML} ) {
        $Title =~ s/(.{4,78})(?:\s|\z)/| $1\n/gm;
        $Description =~ s/^\s*//mg;
        $Description =~ s/\n/ /gs;
        $Description =~ s/\r/ /gs;
        $Description =~ s/\<style.+?\>.*\<\/style\>//gsi;
        $Description =~ s/\<br(\/|)\>/\n/gsi;
        $Description =~ s/\<(hr|hr.+?)\>/\n\n/gsi;
        $Description =~ s/\<(\/|)(pre|pre.+?|p|p.+?|table|table.+?|code|code.+?)\>/\n\n/gsi;
        $Description =~ s/\<(tr|tr.+?|th|th.+?)\>/\n\n/gsi;
        $Description =~ s/\.+?<\/(td|td.+?)\>/ /gsi;
        $Description =~ s/\<.+?\>//gs;
        $Description =~ s/  / /mg;
        $Description =~ s/&amp;/&/g;
        $Description =~ s/&lt;/</g;
        $Description =~ s/&gt;/>/g;
        $Description =~ s/&quot;/"/g;
        $Description =~ s/&nbsp;/ /g;
        $Description =~ s/^\s*\n\s*\n/\n/mg;
        $Description =~ s/(.{4,78})(?:\s|\z)/| $1\n/gm;
    }
    return (
        Description => $Description,
        Title       => $Title,
    );
}

sub _PackageContentGet {
    my ( $Self, %Param ) = @_;

    my $FileString;

    if ( -e $Param{Location} ) {
        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Param{Location},
            Mode     => 'utf8',             # optional - binmode|utf8
            Result   => 'SCALAR',           # optional - SCALAR|ARRAY
        );
        if ($ContentRef) {
            $FileString = ${$ContentRef};
        }
        else {
            $Self->PrintError("Can't open: $Param{Location}: $!");
            return;
        }
    }
    elsif ( $Param{Location} =~ /^(online|.*):(.+?)$/ ) {
        my $URL         = $1;
        my $PackageName = $2;
        if ( $URL eq 'online' ) {
            my %List = %{ $Kernel::OM->Get('Kernel::Config')->Get('Package::RepositoryList') };
            %List = (
                %List,
                $Kernel::OM->Get('Kernel::System::Package')->PackageOnlineRepositories()
            );
            for ( sort keys %List ) {
                if ( $List{$_} =~ /^\[-Master-\]/ ) {
                    $URL = $_;
                }
            }
        }
        if ( $PackageName !~ /^.+?.opm$/ ) {
            my @Packages = $Kernel::OM->Get('Kernel::System::Package')->PackageOnlineList(
                URL  => $URL,
                Lang => $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage'),
            );
            PACKAGE:
            for my $Package (@Packages) {
                if ( $Package->{Name} eq $PackageName ) {
                    $PackageName = $Package->{File};
                    last PACKAGE;
                }
            }
        }
        $FileString = $Kernel::OM->Get('Kernel::System::Package')->PackageOnlineGet(
            Source => $URL,
            File   => $PackageName,
        );
        if ( !$FileString ) {
            $Self->PrintError("No such file '$Param{Location}' in $URL!");
            return;
        }
    }
    else {
        if ( $Param{Location} =~ /^(.*)\-(\d{1,4}\.\d{1,4}\.\d{1,4})$/ ) {
            $FileString = $Kernel::OM->Get('Kernel::System::Package')->RepositoryGet(
                Name    => $1,
                Version => $2,
            );
        }
        else {
            PACKAGE:
            for my $Package ( $Kernel::OM->Get('Kernel::System::Package')->RepositoryList() ) {
                if ( $Param{Location} eq $Package->{Name}->{Content} ) {
                    $FileString = $Kernel::OM->Get('Kernel::System::Package')->RepositoryGet(
                        Name    => $Package->{Name}->{Content},
                        Version => $Package->{Version}->{Content},
                    );
                    last PACKAGE;
                }
            }
        }
        if ( !$FileString ) {
            $Self->PrintError("No such file '$Param{Location}' or invalid 'package-version'!");
            return;
        }
    }

    return $FileString;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
