# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return Translatable('Webserver') . '/' . Translatable('Environment Variables');
}

sub Run {
    my $Self = shift;

    my %Environment = %ENV;

    # Skip the plugin, if the support data collection isn't running in a web request.
    return $Self->GetResults() if !$ENV{GATEWAY_INTERFACE};

    for my $NotNeededString (
        qw(
        HTTP_REFERER HTTP_CACHE_CONTROL HTTP_COOKIE HTTP_USER_AGENT
        HTTP_ACCEPT_LANGUAGE HTTP_ACCEPT_ENCODING HTTP_ACCEPT
        QUERY_STRING REQUEST_METHOD REQUEST_URI SCRIPT_NAME
        ALLUSERSPROFILE      APPDATA              LOCALAPPDATA   COMMONPROGRAMFILES
        PROGRAMDATA          PROGRAMFILES         PSMODULEPATH   PUBLIC
        SYSTEMDRIVE          SYSTEMROOT           TEMP           WINDIR
        USERPROFILE          REMOTE_PORT
        )
        )
    {
        delete $Environment{$NotNeededString};
    }

    my @Result;

    for my $Variable ( sort { $a cmp $b } keys %Environment ) {
        $Self->AddResultInformation(
            Identifier => $Variable,
            Label      => $Variable,
            Value      => $Environment{$Variable},
        );
    }

    return $Self->GetResults();
}

1;
