# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Type',
            Value => 1,
            Valid => 1,
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test Priority for ACL.
        my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');
        my $PriorityName   = "Test$RandomID";
        my $PriorityID     = $PriorityObject->PriorityAdd(
            Name    => $PriorityName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $PriorityID,
            "Priority $PriorityName is Created",
        );

        # Create test Type for ACL.
        my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');
        my $TypeName   = "TestType$RandomID";
        my $TypeID     = $TypeObject->TypeAdd(
            Name    => $TypeName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $TypeID,
            "Type $TypeName is Created",
        );

        # Set ACL not to show specific Type and Priority in AgentTicketSearch.
        my $ACLObject = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $AclName   = "TicketSearch$RandomID";
        $ACLObject->ACLImport(
            Content => <<"EOF",
- ChangeBy: root\@localhost
  ChangeTime: 2018-10-18 10:45:35
  Comment: ''
  ConfigChange:
    PossibleNot:
      Ticket:
        Priority:
        - $PriorityName
        Type:
        - $TypeName
  ConfigMatch:
    Properties:
      Frontend:
        Action:
        - AgentTicketSearch
  CreateBy: root\@localhost
  CreateTime: 2018-10-14 07:38:07
  Description: ''
  ID: '1'
  Name: $AclName
  StopAfterMatch: 0
  ValidID: '1'
EOF
            OverwriteExistingEntities => 1,
            UserID                    => 1,
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # After login, we need to navigate to the ACL deployment to make the imported ACL work.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLDeploy");
        $Self->False(
            index(
                $Selenium->get_page_source(),
                'ACL information from database is not in sync with the system configuration, please deploy all ACLs.'
                )
                > -1,
            "ACL deployment successful."
        );

        # Go to ticket search screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        $Selenium->InputFieldValueSet(
            Element => '#Attribute',
            Value   => 'TypeIDs',
        );

        $Selenium->InputFieldValueSet(
            Element => '#Attribute',
            Value   => 'PriorityIDs',
        );

        # Check if restricted Type is not shown in dropdown.
        $Self->True(
            $Selenium->execute_script("return !\$('#TypeIDs option[value=\"$TypeID\"]').length;"),
            "Type ID $TypeID is not found in Type dropdown"
        );

        # Check if restricted Priority is not shown in dropdown.
        $Self->True(
            $Selenium->execute_script("return !\$('#PriorityIDs option[value=\"$PriorityID\"]').length;"),
            "Priority ID $PriorityID is not found in Priority dropdown"
        );

        # Delete created test ACL.
        my $ACLData = $ACLObject->ACLGet(
            Name   => $AclName,
            UserID => 1,
        );

        my $Success = $ACLObject->ACLDelete(
            ID     => $ACLData->{ID},
            UserID => 1,
        );
        $Self->True(
            $Success,
            "ACL with ID $ACLData->{ID} is deleted"
        );

        # Delete type.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM ticket_type WHERE id = ?",
            Bind => [ \$TypeID ],
        );
        $Self->True(
            $Success,
            "Deleted Type with ID $TypeID",
        );

        # Delete priority.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM ticket_priority WHERE id = $PriorityID",
        );
        $Self->True(
            $Success,
            "Priority with ID $PriorityID is deleted!"
        );

    },
);

1;
