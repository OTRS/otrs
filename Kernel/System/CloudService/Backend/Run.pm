# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CloudService::Backend::Run;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::Encode',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::SystemData',
    'Kernel::System::WebUserAgent',
);

=head1 NAME

Kernel::System::CloudService::Backend::Run - cloud service lib

=head1 SYNOPSIS

All functions for cloud service communication.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a CloudService object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService::Backend::Run');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # set system registration data
    %{ $Self->{RegistrationData} } =
        $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGroupGet(
        Group  => 'Registration',
        UserID => 1,
        );

    # set URL for calling cloud services
    $Self->{CloudServiceURL} = 'https://cloud.otrs.com/otrs/public.pl';

    return $Self;
}

=item Request()

perform a cloud service communication and return result data

    my $RequestResult = $CloudServiceObject->Request(
        OTRSIDAuth => { #  will be send encoded as JSON
            OTRSID => '',
            Password => '',
        },
        UniqueIDAuth => { #  will send encoded as JSON
            UniqueID => '',
            APIKey => '',
        },
        RequestData => { # this complex structure will be send encoded as JSON
            CloudServiceTest => [
                {
                    InstanceName = 'AnyName', # optional
                    Operation    => "ConfigurationSet",
                    Data         => {
                        # ... request operation data ...
                    },
                },
                {
                    Operation    => "SomeOperation",
                    Data         => {
                        # ... request operation data ...
                    },
                },
                # ... other entries may follow ...
            ],
            FeatureAddonManagement => [
                {
                    Operation    => "FAOListAssigned",
                    Data         => {
                        # ... request operation data ...
                    },
                },
                {
                    InstanceName = 'InstanceNameOne', # optional
                    Operation    => "FAOGet",
                    Data         => {
                        # ... request operation data ...
                    },
                },
                {
                    InstanceName = 'InstanceNameTwo', # optional
                    Operation    => "FAOGet",
                    Data         => {
                        # ... request operation data ...
                    },
                },
                # ... other entries may follow ...
            ],
            # ... other entries may follow ...
        },
        Timeout => 15,                  # optional, timeout
        Proxy   => 'proxy.example.com', # optional, proxy
    );


Returns:
    $RequestResult {
        Success      => 1,
        ErrorMessage => '...', # optional
        Results      => {
            CloudServiceTest => [
                {
                    Success      => 1, # 1 or 0
                    ErrorMessage => '...', # optional
                    InstanceName = 'AnyName', # optional
                    Operation    => "ConfigurationSet",
                    Data         => {
                        # ... response operation data ..
                    },
                },
                {
                    Success      => 0, # 1 or 0
                    ErrorMessage => '...', # optional
                    Operation    => "SomeOperation",
                    Data         => {
                        # ... response operation data ...
                    },
                },
            ],

            FeatureAddonManagement => [
                {
                    Success      => 1, # 1 or 0
                    ErrorMessage => '...', # optional
                    Operation    => "FAOListAssigned",
                    Data         => {
                        # ... response operation data ..
                    },
                },
                {
                    Success      => 1, # 1 or 0
                    ErrorMessage => '...', # optional
                    InstanceName = 'InstanceNameOne', # optional
                    Operation    => "FaoGet",
                    Data         => {
                        # ... response operation data ...
                    },
                },
                {
                    Success      => 0, # 1 or 0
                    ErrorMessage => '...', # optional
                    InstanceName = 'InstanceNameTwo', # optional
                    Operation    => "FaoGet",
                    Data         => {
                        # ... response operation data ...
                    },
                },
            ],
        },
    };

=cut

sub Request {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{RequestData} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need RequestData!"
        );
        return;
    }

    # RequestData might be a hash
    if ( !IsHashRefWithData( $Param{RequestData} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Wrong structure for RequestData, it might be an hash with data!",
        );
        return;
    }

    # check in detail each request data
    for my $CloudService ( sort keys %{ $Param{RequestData} } ) {

        # check if CloudService is defined and not empty
        if ( !$CloudService ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "A CloudService name is needed!",
            );
            return;
        }

        # check if CloudService is defined and not empty
        if ( !IsArrayRefWithData( $Param{RequestData}->{$CloudService} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "CloudService::$CloudService data structure is not valid!",
            );
            return;
        }

        for my $Instance ( @{ $Param{RequestData}->{$CloudService} } ) {

            # check if Operation is present
            if ( !$Instance->{Operation} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Each operation request needs a Operation name!",
                );
                return;
            }

            # if Data is present it might be a hash
            if ( $Instance->{Data} && ref $Instance->{Data} ne 'HASH' ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Request Data needs to be a hash structure!",
                );
                return;
            }
        }
    }

    # create json object
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    # get UniqueIDAut structure if needed
    my $UniqueIDAuth;
    if (
        defined $Self->{RegistrationData}->{State}
        && $Self->{RegistrationData}->{State} eq 'registered'
        )
    {

        # create cache object
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # check cache
        my $CacheKey = "APIKey::" . $Self->{RegistrationData}->{APIKey} || ''
            . "::UniqueID::" . $Self->{RegistrationData}->{UniqueID} || '';
        my $CacheContent = $CacheObject->Get(
            Type => 'RequestUniqueIDAuth',
            Key  => $CacheKey,
        );

        if ( defined $CacheContent ) {
            $UniqueIDAuth = $CacheContent;
        }
        else {
            # create JSON string
            $UniqueIDAuth = $JSONObject->Encode(
                Data => {
                    APIKey   => $Self->{RegistrationData}->{APIKey}   || '',
                    UniqueID => $Self->{RegistrationData}->{UniqueID} || '',
                },
            );
            $CacheObject->Set(
                Type  => 'RequestUniqueIDAuth',
                Key   => $CacheKey,
                Value => $UniqueIDAuth || '',
                TTL   => 3 * 24 * 60 * 60,
            );
        }
    }

    # get OTRSIDAuth structure if needed
    my $OTRSIDAuth = '';
    if ( $Param{OTRSID} && $Param{Password} ) {

        $OTRSIDAuth = $JSONObject->Encode(
            Data => {
                OTRSID   => $Param{OTRSID},
                Password => $Param{Password},
            },
        );
    }

    # create config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $RequestTimeout = $Param{Timeout} || $ConfigObject->Get('WebUserAgent::Timeout') || 15;
    my $RequestProxy   = $Param{Proxy}   || $ConfigObject->Get('WebUserAgent::Proxy')   || '';

    # set timeout setting for packages
    if ( grep {/^Package/i} sort keys %{ $Param{RequestData} } ) {
        $RequestTimeout = $ConfigObject->Get('Package::Timeout') || 120;
    }

    # create JSON string
    my $RequestData = $JSONObject->Encode(
        Data => $Param{RequestData},
    );

    # add params to webuseragent object
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::WebUserAgent' => {
            Timeout => $RequestTimeout,
            Proxy   => $RequestProxy,
        },
    );

    # perform webservice request
    my %Response = $Kernel::OM->Get('Kernel::System::WebUserAgent')->Request(
        Type => 'POST',
        URL  => $Self->{CloudServiceURL},
        Data => {
            Action       => 'PublicCloudService',
            RequestData  => $RequestData,
            UniqueIDAuth => $UniqueIDAuth,
            OTRSIDAuth   => $OTRSIDAuth,
        },
    );

    # test if the web response was successful
    if ( $Response{Status} ne '200 OK' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "PublicCloudService - Can't connect to server - $Response{Status}",
        );
        return;
    }

    # check if we have content as a scalar ref
    if ( !$Response{Content} || ref $Response{Content} ne 'SCALAR' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message =>
                "PublicCloudService - No content received from public cloud service. Please try again later.'",
        );
        return;
    }

    # convert internal used charset
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput(
        $Response{Content},
    );

    # decode JSON data
    my $ResponseData = $JSONObject->Decode(
        Data => ${ $Response{Content} },
    );

    # check response structure
    if ( !IsHashRefWithData($ResponseData) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't decode JSON data: 'PublicCloudService'!",
        );
        return;
    }

    # check if we have an error
    if ( !$ResponseData->{Success} ) {
        my $ResponseErrorMessage = $ResponseData->{ErrorMessage} || 'No error message available.';
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "PublicCloudService - Error from server: $ResponseErrorMessage !",
        );
        return;
    }
    else {

        # return data from server if defined
        return $ResponseData->{Results} if defined $ResponseData->{Results};
    }

    return;
}

=item OperationResultGet()

    my $OperationResult = $CloudServiceObject->OperationResultGet(
        CloudService => 'Test',
        Operation    => 'test',
        InstanceName => 'AnyName',      # optional
        RequestResult =>  {
            Success      => 1,
            Results      => {
                Test => [
                    {
                        Success      => 1,
                        InstanceName => 'AnyName',
                        Operation    => 'Test',
                        Data         => {
                            # ... response operation data ..
                        },
                    },
                    {
                        Success      => 0,
                        ErrorMessage => 'some message',
                        Operation    => 'SomeOperation',
                        Data         => {
                            # ... response operation data ...
                        },
                    },
                ],
            },
        };
    );

Returns:

    $OperationResult {
        Success      => 1,
        ErrorMessage => 'a message'         # optional
        InstanceName => 'AnyName',
        Operation    => "Test",
        Data         => {
            # ... response operation data ..
        },
    },

=cut

sub OperationResultGet {
    my ( $Self, %Param ) = @_;

    # check needed
    for my $Needed (qw(RequestResult CloudService Operation)) {

        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return {
                Success => 0,
            };
        }
    }

    # check RequestResult internals
    if ( !IsHashRefWithData( $Param{RequestResult} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The format of the request result is invalid!",
        );

        return {
            Success => 0,
        };
    }

    if ( !$Param{RequestResult}->{ $Param{CloudService} } ) {
        my $Message = "No CloudService:'$Param{CloudService}' found in the request result!";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$Message",
        );

        return {
            Success      => 0,
            ErrorMessage => $Message,
        };
    }

    if ( !IsArrayRefWithData( $Param{RequestResult}->{ $Param{CloudService} } ) ) {
        my $Message = "Results from CloudService:'$Param{CloudService}' are invalid!";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$Message",
        );

        return {
            Success      => 0,
            ErrorMessage => $Message,
        };
    }

    # create a shortcut for actual cloud-service results
    my @CloudServiceResults = @{ $Param{RequestResult}->{ $Param{CloudService} } };

    RESULT:
    for my $OperationResult (@CloudServiceResults) {

        next RESULT if $OperationResult->{Operation} ne $Param{Operation};

        if ( !$Param{InstanceName} ) {

            next RESULT if defined $OperationResult->{InstanceName};
        }
        else {

            next RESULT if $OperationResult->{InstanceName} ne $Param{InstanceName};
        }

        return $OperationResult;
    }

    # if not found return an error
    my $Message = "No Results from CloudService:'$Param{CloudService}' Operation:'$Param{Operation}'";
    if ( $Param{InstanceName} ) {
        $Message .= " InstanceName:'$Param{InstanceName}'!";
    }
    else {
        $Message .= " Without InstanceName!";
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => $Message,
    );

    return {
        Success => 0,
        Message => "No results found!",
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
