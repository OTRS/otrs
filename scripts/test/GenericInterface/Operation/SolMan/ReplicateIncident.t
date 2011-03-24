# --
# ReplicateIncident.t - RequestSystemGuid Operation tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ReplicateIncident.t,v 1.2 2011-03-24 11:57:02 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

my @Tests = (
    {
        Name    => 'No data',
        Success => 0,
    },
    {
        Name    => 'Wrong data (arrayref)',
        Success => 0,
        Data    => [],
    },
    {
        Name    => 'Correct structure, no data',
        Success => 0,
        Data    => {
            IctAdditionalInfos => {},
            IctAttachments     => {},
            IctHead            => {},
            IctId              => '',
            IctPersons         => {},
            IctSapNotes        => {},
            IctSolutions       => {},
            IctStatements      => {},
            IctTimestamp       => '',
            IctUrls            => {},
        },
    },
    {
        Name    => 'Correct structure',
        Success => 1,
        Data    => {
            IctAdditionalInfos => {},
            IctAttachments     => {},
            IctHead            => {

                # required: OTRS ticket number
                IncidentGuid => '',

                # required: OTRS-system GUID-->
                RequesterGuid => 'D3D9446802A44259755D38E6D163E820',

                # required: SolMan-system GUID
                ProviderGuid => 'DE86768CD3D015F181D0001438BF50C6',

                # optional: id of OTRS ticket owner
                AgentId => 1,

                # optional: id of OTRS ticket customer, max. 32 characters
                ReporterId => 'stefan.bedorf@otrs.com',

                # optional: OTRS ticket title, max. 40 characters
                ShortDescription => 'title',

                # optional: SolMan priority id - available id's:
                # 1, 2, 3, 4 (representing '1: very high', '2: high', '3: normal', '4: low')
                Priority => 3,

            # required: communication language of ticket - Format 2 character string e.g. 'de', 'en'
                Language => 'de',

                # required: FIXME - Format YYYYMMDDhhmmss
                RequestedBegin => '20000101000000',

                # required: FIXME - Format YYYYMMDDhhmmss
                RequestedEnd => 20111231235959,
            },
            IctId      => '',
            IctPersons => {
                Item => [

                    # required: id of OTRS agent/customer, max. 32 characters
                    PersonId => 'stefan.bedorf@otrs.com',

         # optional: id of SolMan agent/customer
         # If no SolMan id is provided and the PersonId has not been used in the interface
         # before, a new contact is automatically added in SolMan, using the provided details below.
         # The SolMan id of the new contact will be returned for reference.
         # If the OTRS id has been used, the same SolMan contact will be used,
         # but no further changes of the contact are possible.-->
                    PersonIdExt => 292,

# optional: gender of OTRS agent/custome, consisting of 1 character, maybe 'm', 'f' - appears to be unused
                    Sex => 'M',

                    # optional: first name of OTRS agent/customer, max. 40 characters
                    FirstName => 'Stefan',

                    # optional: last name of OTRS agent/customer, max. 40 characters
                    LastName => 'Bedorf',

                    # optional: phone number of OTRS agent/customer
                    Telephone => {

                        # optional: phone number of OTRS agent/customer, max. 30 characters
                        PhoneNo => '+49 9421 56818',

                       # optional: phone number extension of OTRS agent/customer, max. 10 characters
                        PhoneNoExtension => '0',
                    },

                    # optional: mobile phone number of OTRS agent/customer, max. 30 characters
                    MobilePhone => '-',

                    # optional: fax number of OTRS agent/customer
                    Fax => {

                        # optional: fax number of OTRS agent/customer, max. 30 characters
                        FaxNo => '+49 9421 56818',

                        # optional: fax number extension of OTRS agent/customer, max. 10 characters
                        FaxNoExtension => '18',
                    },

                    # optional: email address of OTRS agent/customer, max. 240 characters
                    Email => 'stefan.bedorf@otrs.com',
                ],
            },
            IctSapNotes   => {},
            IctSolutions  => {},
            IctStatements => {},

            # required: FIXME - Format YYYYMMDDhhmmss
            IctTimestamp => '20010101000000',
            IctUrls      => {},
        },
    },
);

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Operation;
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Provider',
);

# create object
my $OperationObject = Kernel::GenericInterface::Operation->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    OperationType  => 'SolMan::ReplicateIncident',
);

$Self->Is(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'Operation::new() success',
);

TEST:
for my $Test (@Tests) {
    my $Result = $OperationObject->Run(
        Data => $Test->{Data},
    );

    $Self->Is(
        $Result->{Success},
        $Test->{Success},
        "$Test->{Name} success status",
    );

    if ( $Test->{Success} ) {

        # TODO clarify return value correctness
        $Self->True(
            $Result->{PrdIctId},
            "$Test->{Name} returned a ProviderIncidentID",
        );

        $Self->False(
            $Result->{Errors},
            "$Test->{Name} did not yield errors",
        );
    }
}
1;
