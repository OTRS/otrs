# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector;

use strict;
use warnings;

use File::Basename;

use Kernel::System::WebUserAgent;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::Encode',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::SystemData',
);

=head1 NAME

Kernel::System::SupportDataCollector - system data collector

=head1 SYNOPSIS

All stats functions.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SupportDataCollectorObject = $Kernel::OM->Get('Kernel::System::SupportDataCollector');


=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash ref to object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Collect()

collect system data

    my %Result = $SupportDataCollectorObject->Collect(
        UseCache   => 1,    # (optional) to get data from cache if any
        WebTimeout => 60,   # (optional)
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
        my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => 'SupportDataCollector',
            Key  => $CacheKey,
        );
        return %{$Cache} if ref $Cache eq 'HASH';
    }

    # Data must be collected in a web request context to be able to collect web server data.
    #   If called from CLI, make a web request to collect the data.
    if ( !$ENV{GATEWAY_INTERFACE} ) {
        return $Self->CollectByWebRequest( WebTimeout => $Param{WebTimeout} );
    }

    # Look for all plug-ins in the FS
    my @PluginFiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => dirname(__FILE__) . "/SupportDataCollector/Plugin",
        Filter    => "*.pm",
        Recursive => 1,
    );

    # Look for all asynchronous plug-ins in the FS
    my @PluginAsynchronousFiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => dirname(__FILE__) . "/SupportDataCollector/PluginAsynchronous",
        Filter    => "*.pm",
        Recursive => 1,
    );

    # merge the both plug-ins types together
    my @PluginFilesAll = ( @PluginFiles, @PluginAsynchronousFiles );

    my @Result;

    # Execute all plug-ins
    for my $PluginFile (@PluginFilesAll) {

        # Convert file name => package name
        $PluginFile =~ s{^.*(Kernel/System.*)[.]pm$}{$1}xmsg;
        $PluginFile =~ s{/+}{::}xmsg;

        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($PluginFile) ) {
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

    # sort the results from the plug-ins by the short identifier
    @Result = sort { $a->{ShortIdentifier} cmp $b->{ShortIdentifier} } @Result;

    my %ReturnData = (
        Success => 1,
        Result  => \@Result,
    );

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => 'SupportDataCollector',
        Key   => $CacheKey,
        Value => \%ReturnData,
        TTL   => 60 * 10,
    );

    return %ReturnData;
}

sub CollectByWebRequest {
    my ( $Self, %Param ) = @_;

    # Create a challenge token to authenticate this request without customer/agent login.
    #   PublicSupportDataCollector requires this ChallengeToken.
    my $ChallengeToken = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length     => 32,
        Dictionary => [ 0 .. 9, 'a' .. 'f' ],    # hexadecimal
    );

    if (
        $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGet( Key => 'SupportDataCollector::ChallengeToken' )
        )
    {
        $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataUpdate(
            Key    => 'SupportDataCollector::ChallengeToken',
            Value  => $ChallengeToken,
            UserID => 1,
        );
    }
    else {
        $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataAdd(
            Key    => 'SupportDataCollector::ChallengeToken',
            Value  => $ChallengeToken,
            UserID => 1,
        );
    }

    my $Host;
    my $FQDN = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    if ( $FQDN ne 'yourhost.example.com' && gethostbyname($FQDN) ) {
        $Host = $FQDN;
    }

    if ( !$Host && gethostbyname('localhost') ) {
        $Host = 'localhost';
    }

    $Host ||= '127.0.0.1';

    # prepare web service config
    my $URL =
        $Kernel::OM->Get('Kernel::Config')->Get('HttpType')
        . '://'
        . $Host
        . '/'
        . $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias')
        . 'public.pl';

    # create webuseragent object
    my $WebUserAgentObject = Kernel::System::WebUserAgent->new(
        Timeout => $Param{WebTimeout} || 20,
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "SupportDataCollector - $Result{ErrorMessage}",
        );

        return %Result;
    }

    # check if we have content as a scalar ref
    if ( !$Response{Content} || ref $Response{Content} ne 'SCALAR' ) {
        $Result{ErrorMessage} = 'No content received.';
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "SupportDataCollector - $Result{ErrorMessage}",
        );
        return %Result;
    }

    # convert internal used charset
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( $Response{Content} );

    # Discard HTML responses (error pages etc.).
    if ( substr( ${ $Response{Content} }, 0, 1 ) eq '<' ) {
        $Result{ErrorMessage} = 'Response looks like HTML instead of JSON.';
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "SupportDataCollector - $Result{ErrorMessage}",
        );
        return %Result;
    }

    # decode JSON data
    my $ResponseData = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => ${ $Response{Content} },
    );
    if ( !$ResponseData || ref $ResponseData ne 'HASH' ) {
        $Result{ErrorMessage} = "Can't decode JSON: '" . ${ $Response{Content} } . "'!";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "SupportDataCollector - $Result{ErrorMessage}",
        );
        return %Result;
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => 'SupportDataCollect',
        Key   => 'DataCollect',
        Value => $ResponseData,
        TTL   => 60 * 10,
    );

    return %{$ResponseData};
}

=item CollectAsynchronous()

collect asynchronous data (the asynchronous plug-in decide at which place the data will be saved)

    my %Result = $SupportDataCollectorObject->CollectAsynchronous();

returns:

    %Result = (
        Success      => 1,                  # or 0 in case of an error
        ErrorMessage => 'some message'      # optional (only in case of an error)
    );

return

=cut

sub CollectAsynchronous {
    my ( $Self, %Param ) = @_;

    # Look for all plug-ins in the FS
    my @PluginFiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => dirname(__FILE__) . "/SupportDataCollector/PluginAsynchronous",
        Filter    => "*.pm",
        Recursive => 1,
    );

    # Execute all plug-ins
    for my $PluginFile (@PluginFiles) {

        # Convert file name => package name
        $PluginFile =~ s{^.*(Kernel/System.*)[.]pm$}{$1}xmsg;
        $PluginFile =~ s{/+}{::}xmsg;

        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($PluginFile) ) {
            return (
                Success      => 0,
                ErrorMessage => "Could not load $PluginFile!",
            );
        }
        my $PluginObject = $PluginFile->new( %{$Self} );

        my $Success = $PluginObject->RunAsynchronous();

        if ( !$Success ) {
            return (
                Success      => 0,
                ErrorMessage => "Error during asynchronous execution of $PluginFile.",
            );
        }
    }

    return (
        Success => 1,
    );
}

=item CleanupAsynchronous()

cleanup asynchronous data (the asynchronous plug-in decide for themselves)

    my $Success = $SupportDataCollectorObject->CleanupAsynchronous();

=cut

sub CleanupAsynchronous {
    my ( $Self, %Param ) = @_;

    # Look for all plug-ins in the FS
    my @PluginFiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => dirname(__FILE__) . "/SupportDataCollector/PluginAsynchronous",
        Filter    => "*.pm",
        Recursive => 1,
    );

    # Execute all Plug-ins
    PLUGINFILE:
    for my $PluginFile (@PluginFiles) {

        # Convert file name => package name
        $PluginFile =~ s{^.*(Kernel/System.*)[.]pm$}{$1}xmsg;
        $PluginFile =~ s{/+}{::}xmsg;

        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($PluginFile) ) {
            return (
                Success      => 0,
                ErrorMessage => "Could not load $PluginFile!",
            );
        }
        my $PluginObject = $PluginFile->new( %{$Self} );

        next PLUGINFILE if !$PluginFile->can('CleanupAsynchronous');

        $PluginObject->CleanupAsynchronous();
    }

    return 1;
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
