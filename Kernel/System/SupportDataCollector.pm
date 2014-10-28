# --
# Kernel/System/SupportDataCollector.pm - system data collector
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector;

use strict;
use warnings;

use File::Basename;

use Kernel::System::Cache;
use Kernel::System::Environment;
use Kernel::System::JSON;
use Kernel::System::SystemData;
use Kernel::System::Ticket;
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::WebUserAgent;
use Kernel::System::XML;

=head1 NAME

Kernel::System::SupportDataCollector - system data collector

=head1 SYNOPSIS

All stats functions.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::SupportDataCollector;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $StatsObject = Kernel::System::SupportDataCollector->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash ref to object
    my $Self = {};
    bless( $Self, $Type );

    # check object list for completeness
    for my $Object (
        qw( ConfigObject LogObject MainObject DBObject EncodeObject TimeObject )
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{CacheObject}       = Kernel::System::Cache->new( %{$Self} );
    $Self->{EnvironmentObject} = Kernel::System::Environment->new( %{$Self} );
    $Self->{JSONObject}        = Kernel::System::JSON->new( %{$Self} );
    $Self->{SystemDataObject}  = Kernel::System::SystemData->new( %{$Self} );
    $Self->{TicketObject}      = Kernel::System::Ticket->new( %{$Self} );
    $Self->{XMLObject}         = Kernel::System::XML->new( %{$Self} );

    return $Self;
}

=item Collect()

collect system data

    my %Result = $SupportDataCollectorObject->Collect(
        UseCache => 1,      # optional, (to get data from cache if any)
    );

    returns in case of error

    (
        Success      => 0,
        ErrorMessage => '...',
    )

    otherwise

    (
        Success => 1,
        Result  => [
            {
                Identifier  => 'Kernel::System::SupportDataCollector::OTRS::Version',
                DisplayPath => 'OTRS',
                Status      => $StatusOK,
                Label       => 'OTRS Version'
                Value       => '3.3.2',
                Message     => '',
            },
            {
                Identifier  => 'Kernel::System::SupportDataCollector::Apache::mod_perl',
                DisplayPath => 'OTRS',
                Status      => $StatusProblem,
                Label       => 'mod_perl usage'
                Value       => '0',
                Message     => 'Please enable mod_perl to speed up OTRS.',
            },
        ],
    )

=cut

sub Collect {
    my ( $Self, %Param ) = @_;

    # check cache
    my $CacheKey = 'DataCollect';

    if ( $Param{UseCache} ) {
        my $Cache = $Self->{CacheObject}->Get(
            Type => 'SupportDataCollector',
            Key  => $CacheKey,
        );
        return %{$Cache} if ref $Cache eq 'HASH';
    }

    # Data must be collected in a web request context to be able to collect webserver data.
    #   If called from CLI, make a web request to collect the data.
    if ( !$ENV{GATEWAY_INTERFACE} ) {
        return $Self->CollectByWebRequest();
    }

    # Look for all plugins in the FS
    my @PluginFiles = $Self->{MainObject}->DirectoryRead(
        Directory => dirname(__FILE__) . "/SupportDataCollector/Plugin",
        Filter    => "*.pm",
        Recursive => 1,
    );

    my @Result;

    # Execute all Plugins
    for my $PluginFile (@PluginFiles) {

        # Convert file name => package name
        $PluginFile =~ s{^.*(Kernel/System.*)[.]pm$}{$1}xmsg;
        $PluginFile =~ s{/+}{::}xmsg;
        if ( !$Self->{MainObject}->Require($PluginFile) ) {
            return (
                Success      => 0,
                ErrorMessage => "Could not load $PluginFile!",
            );
        }
        my $PluginObject = $PluginFile->new( %{$Self} );

        my %PluginResult = $PluginObject->Run();

        if ( !%PluginResult || !$PluginResult{Success} ) {
            return (
                Success => 0,
                ErrorMessage =>
                    "Error during execution of $PluginFile: $PluginResult{ErrorMessage}",
            );
        }

        push @Result, @{ $PluginResult{Result} // [] };
    }

    my %ReturnData = (
        Success => 1,
        Result  => \@Result,
    );

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'SupportDataCollector',
        Key   => $CacheKey,
        Value => \%ReturnData,
        TTL   => 60 * 10,
    );

    return %ReturnData;
}

sub CollectByWebRequest {
    my $Self = shift;

    # Create a challenge token to authenticate this request without customer/agent login.
    #   PublicSupportDataCollector requires this ChallengeToken.
    my $ChallengeToken = $Self->{MainObject}->GenerateRandomString(
        Length => 32,
        Dictionary => [ 0 .. 9, 'a' .. 'f' ],    # hexadecimal
    );

    if ( $Self->{SystemDataObject}->SystemDataGet( Key => 'SupportDataCollector::ChallengeToken' ) )
    {
        $Self->{SystemDataObject}->SystemDataUpdate(
            Key    => 'SupportDataCollector::ChallengeToken',
            Value  => $ChallengeToken,
            UserID => 1,
        );
    }
    else {
        $Self->{SystemDataObject}->SystemDataAdd(
            Key    => 'SupportDataCollector::ChallengeToken',
            Value  => $ChallengeToken,
            UserID => 1,
        );
    }

    my $Host;
    my $FQDN = $Self->{ConfigObject}->Get('FQDN');

    if ( $FQDN ne 'yourhost.example.com' && gethostbyname($FQDN) ) {
        $Host = $FQDN;
    }

    if ( !$Host && gethostbyname('localhost') ) {
        $Host = 'localhost';
    }

    $Host ||= '127.0.0.1';

    # prepare webservice config
    my $URL =
        $Self->{ConfigObject}->Get('HttpType')
        . '://'
        . $Host
        . '/'
        . $Self->{ConfigObject}->Get('ScriptAlias')
        . 'public.pl';

    # create webuseragent object
    my $WebUserAgentObject = Kernel::System::WebUserAgent->new(
        %{$Self},
        Timeout => 20,
    );

    # define result
    my %Result = (
        Success => 0,
    );

    my %Response = $WebUserAgentObject->Request(
        Type => 'POST',
        URL  => $URL,
        Data => {
            Action         => 'PublicSupportDataCollector',
            ChallengeToken => $ChallengeToken,
        },
    );

    # test if the web response was successful
    if ( $Response{Status} ne '200 OK' ) {
        $Result{ErrorMessage} = "Can't connect to server - $Response{Status}";
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "SupportDataCollector - $Result{ErrorMessage}",
        );

        return %Result;
    }

    # check if we have content as a scalar ref
    if ( !$Response{Content} || ref $Response{Content} ne 'SCALAR' ) {
        $Result{ErrorMessage} = 'No content received.';
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "SupportDataCollector - $Result{ErrorMessage}",
        );
        return %Result;
    }

    # convert internal used charset
    $Self->{EncodeObject}->EncodeInput( $Response{Content} );

    # Discard HTML responses (error pages etc.).
    if ( substr( ${ $Response{Content} }, 0, 1 ) eq '<' ) {
        $Result{ErrorMessage} = 'Response looks like HTML instead of JSON.';
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "SupportDataCollector - $Result{ErrorMessage}",
        );
        return %Result;
    }

    # decode JSON data
    my $ResponseData = $Self->{JSONObject}->Decode(
        Data => ${ $Response{Content} },
    );
    if ( !$ResponseData || ref $ResponseData ne 'HASH' ) {
        $Result{ErrorMessage} = "Can't decode JSON: '" . ${ $Response{Content} } . "'!";
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "SupportDataCollector - $Result{ErrorMessage}",
        );
        return %Result;
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'SupportDataCollect',
        Key   => 'DataCollect',
        Value => $ResponseData,
        TTL   => 60 * 10,
    );

    return %{$ResponseData};
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
