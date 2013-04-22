#3.3.0.beta1 2013-??-??
 - 2013-04-08 Fixed bug#[8490](http://bugs.otrs.org/show_bug.cgi?id=8490) - No History record added when changing ticket title.
 - 2013-04-08 Removed File::Temp as it is core in perl 5.6.1 and up.
 - 2013-04-03 Removed Digest::SHA::PurePerl as Digest::SHA is core in perl 5.10.
 - 2013-04-02 Changed required perl version to 5.10.0.
 - 2013-03-29 Fixed bug#[8967](http://bugs.otrs.org/show_bug.cgi?id=8967) - Can't use Date or Timestamps in LinkObject.
 - 2013-03-29 Fixed bug#[9058](http://bugs.otrs.org/show_bug.cgi?id=9058) - AgentLinkObject.pm refers to non-existing dtl blocks.
 - 2013-03-29 Fixed bug#[7716](http://bugs.otrs.org/show_bug.cgi?id=7716) - Improve permissions on OTRS files.
 - 2013-03-27 Fixed bug#[8962](http://bugs.otrs.org/show_bug.cgi?id=8962) - RequestObject GetUploadAll Source 'File' option is unused
    and hard-coded to use /tmp.

#3.2.7 2013-??.??
 - 2013-04-22 Fixed bug#[9349](http://bugs.otrs.org/show_bug.cgi?id=9349) - SQL warnings on Oracle DB if more than 4k characters are sent to the database.
 - 2013-04-22 Fixed bug#[9353](http://bugs.otrs.org/show_bug.cgi?id=9353) - Customer Ticket Zoom shows owner login name instead of full name.
 - 2013-04-18 Fixed bug#[8599](http://bugs.otrs.org/show_bug.cgi?id=8599) - Problem with "[]" characters in name of attachment file.

#3.2.6 2013-04-23
 - 2013-04-18 Fixed bug#[9310](http://bugs.otrs.org/show_bug.cgi?id=9310) - AgentTicketProcess has the same shortkey "o" as AgentTicketQueue.
 - 2013-04-18 Fixed bug#[9280](http://bugs.otrs.org/show_bug.cgi?id=9280) - Database upgrade procedure problems when upgrading database to 3.2 that
    has been upgraded from 2.4 previously.
 - 2013-04-16 Updated Hungarian translation, thanks to Csaba Németh!
 - 2013-04-15 Added Malay translation.
 - 2013-04-12 Fixed bug#[9264](http://bugs.otrs.org/show_bug.cgi?id=9264) - Dynamic ticket text fields are displayed with value "1" if enabled
    and displayed by default in ticket search screen.
 - 2013-04-12 Fixed bug#[8960](http://bugs.otrs.org/show_bug.cgi?id=8960) - AgentTicketSearch.pm SearchProfile problem.
 - 2013-04-12 Fixed bug#[9328](http://bugs.otrs.org/show_bug.cgi?id=9328) - Notification event does not work on process ticket.
 - 2013-04-11 Fixed broken process import.
 - 2013-04-11 Follow-up for bug#[9215](http://bugs.otrs.org/show_bug.cgi?id=9215) - Process import always creates new process.
    The overwrite optionwas removed again because of logical problems.
 - 2013-04-09 Added parameter "-t dbonly" to backup.pl to only backup the database
    (if files are backed up otherwise).
 - 2013-04-09 Fixed bug#[9302](http://bugs.otrs.org/show_bug.cgi?id=9302) - Process Management: Misleading description for activities without dialogs.
 - 2013-04-08 Fixed bug#[9182](http://bugs.otrs.org/show_bug.cgi?id=9182) - Customer Search Function -\> If you go into a ticket and go back you got not the search results
 - 2013-04-08 Fixed bug#[9297](http://bugs.otrs.org/show_bug.cgi?id=9297) - customer information widget losing data
 - 2013-04-08 Fixed bug#[9244](http://bugs.otrs.org/show_bug.cgi?id=9244) - Process Management: Transitions on Activities does not scale well
 - 2013-04-08 Fixed bug#[9287](http://bugs.otrs.org/show_bug.cgi?id=9287) - Process Management: strange placement of target point for new transitions.
 - 2013-04-08 Fixed bug#[9294](http://bugs.otrs.org/show_bug.cgi?id=9294) - Process Management: Activity hover window not displayed properly if
    activity is very close to bottom canvas border.
 - 2013-04-08 Fixed bug#[9314](http://bugs.otrs.org/show_bug.cgi?id=9314) - Process Management: Unexpected redirection after creating a new process.
 - 2013-04-08 Fixed bug#[9312](http://bugs.otrs.org/show_bug.cgi?id=9312) - LinkObject permission check problem.

#3.2.5 2013-04-09
 - 2013-04-04 Fixed bug#[9313](http://bugs.otrs.org/show_bug.cgi?id=9313) - No such file or directory in otrs.SetPermission.pl.
 - 2013-04-04 Updated Brazilian Portugese translation, thanks to Alexandre!
 - 2013-04-04 Fixed bug#[9306](http://bugs.otrs.org/show_bug.cgi?id=9306) - Auto Response fails when ticket is created from Customer Interface and
    last name contains a comma.
 - 2013-04-04 Fixed bug#[9308](http://bugs.otrs.org/show_bug.cgi?id=9308) - Impossible to create a new stats report with absolute period.
 - 2013-04-03 Fixed bug#[9307](http://bugs.otrs.org/show_bug.cgi?id=9307) - Packages not compatible with 3.2.4 listed as available in Package Manager.
 - 2013-04-02 Fixed bug#[9198](http://bugs.otrs.org/show_bug.cgi?id=9198) - Linked search with fulltext AND additional attributes.
 - 2013-03-28 Fixed bug#[9298](http://bugs.otrs.org/show_bug.cgi?id=9298) - version.pm not found on perl 5.8.x.
 - 2013-03-27 Fixed bug#[9295](http://bugs.otrs.org/show_bug.cgi?id=9295) - Article dynamic field is not searchable.
 - 2013-03-27 Fixed bug#[9288](http://bugs.otrs.org/show_bug.cgi?id=9288) - DynamicField Content overwrites TicketTitle for Links from Dynamic Fields.

#3.2.4 2013-04-02
 - 2013-03-21 Fixed bug#[9279](http://bugs.otrs.org/show_bug.cgi?id=9279) - Inaccurate German translation of ,,Priority Update''.
 - 2013-03-21 Fixed bug#[9257](http://bugs.otrs.org/show_bug.cgi?id=9257) - No notifications to agents with out-of-office set but period not reached.
 - 2013-03-21 Fixed bug#[1689](http://bugs.otrs.org/show_bug.cgi?id=1689) - Allow bin/SetPermissions.sh to follow symlink for OTRS_HOME.
 - 2013-03-21 Fixed bug#[8981](http://bugs.otrs.org/show_bug.cgi?id=8981) - Tickets reopened via customer interface are locked to invalid agents.
 - 2013-03-19 Fixed bug#[9242](http://bugs.otrs.org/show_bug.cgi?id=9242) - ProcessManagement: TransitionAction TicketStateSet does not allow to set a pending time.
 - 2013-03-19 Fixed bug#[9247](http://bugs.otrs.org/show_bug.cgi?id=9247) - ProcessManagement: Transitions Actions always use actual user permissions.
 - 2013-03-18 Fixed bug#[9254](http://bugs.otrs.org/show_bug.cgi?id=9254) - No Sorting in Accordion for Activties, Activity Dialog, Transitions and Transition Actions.
 - 2013-03-18 Improved permission checks in LinkObject.
 - 2013-03-18 Fixed bug#[9252](http://bugs.otrs.org/show_bug.cgi?id=9252) - Type of linking displayed wrong and also updated wrong in transitions.
 - 2013-03-18 Fixed bug#[9255](http://bugs.otrs.org/show_bug.cgi?id=9255) - Email is sent to customer, when agents email address is similar
    but not identical.
 - 2013-03-18 Updated Norwegian translation, thanks to Espen Stefansen.
 - 2013-03-18 Updated Czech translation, thanks to Peter Pruchnerovic.
 - 2013-03-18 Fixed bug#[9215](http://bugs.otrs.org/show_bug.cgi?id=9215) - Process import always creates new process. Now there is a new option
    "overwrite existing entities" for the process import.
 - 2013-03-15 Fixed bug#[4716](http://bugs.otrs.org/show_bug.cgi?id=4716) - Logout page should use ProductName instead of 'OTRS'.
 - 2013-03-15 Fixed bug#[9249](http://bugs.otrs.org/show_bug.cgi?id=9249) - Warning not to use internal articles in customer frontend
    shown on agent interface also.
 - 2013-03-14 Fixed bug#[9191](http://bugs.otrs.org/show_bug.cgi?id=9191) - When ticket types are restricted, first available type is selected
    in AgentTicketActionCommon-based screens.
 - 2013-03-12 Updated Chinese translation, thanks to Never Min!
 - 2013-03-12 Updated Turkish translation, thanks to Sefer Simsek / Network Group!

#3.2.3 2013-03-12
 - 2013-03-05 Fixed bug#[9221](http://bugs.otrs.org/show_bug.cgi?id=9221) - Got error log message when customer user take activity dialog operation in customer interface.
 - 2013-03-04 Fixed bug#[8727](http://bugs.otrs.org/show_bug.cgi?id=8727) - Webservices can be created with an invalid/incomplete configuration.
 - 2013-03-02 Fixed bug#[9214](http://bugs.otrs.org/show_bug.cgi?id=9214) - IE10: impossible to open links from rich text articles.
 - 2013-03-01 Fixed bug#[9218](http://bugs.otrs.org/show_bug.cgi?id=9218) - Cannot use special characters in TicketHook.
 - 2013-02-28 Fixed bug#[9056](http://bugs.otrs.org/show_bug.cgi?id=9056) - Unused SysConfig option Ticket::Frontend::CustomerInfoQueueMaxSize.
 - 2013-02-28 Added the possibility to use ticket data in dynamic fields links.
 - 2013-02-28 Fixed bug#[8764](http://bugs.otrs.org/show_bug.cgi?id=8764) - Added @ARGV encoding to command line scripts.
 - 2013-02-28 Fixed bug#[9189](http://bugs.otrs.org/show_bug.cgi?id=9189) - Executing DBUpdate-to-3.2.pl as root user leaves file permissions on ZZZAuto.pm in incorrect state.
 - 2013-02-27 Fixed bug#[9196](http://bugs.otrs.org/show_bug.cgi?id=9196) - ProcessManagement: Internal Server Error for "Ended" process zoom in Customer Interface.
 - 2013-02-26 Fixed bug#[9202](http://bugs.otrs.org/show_bug.cgi?id=9202) - ProcessManagement: ActivityDialog Admin GUI should not let internal article types for Customer Interface.
 - 2013-02-26 Fixed bug#[9193](http://bugs.otrs.org/show_bug.cgi?id=9193) - Process Management: (First) article filled in in customer frontend causes "Need ArticleTypeID!" error.
 - 2013-02-26 Follow-up fix for bug#[8533](http://bugs.otrs.org/show_bug.cgi?id=8533) apache will not start on Fedora.
 - 2013-02-26 Fixed bug#[9172](http://bugs.otrs.org/show_bug.cgi?id=9172) - Generic Interface does not work on IIS 7.0.
 - 2013-02-25 Updated French language translation, thanks to Raphaël Doursenaud!
 - 2013-02-23 Updated Hungarian language translation, thanks to Németh Csaba!
 - 2013-02-21 Updated Czech language translation, thanks to Katerina Bubenickova!
 - 2013-02-20 Fixed bug#[8865](http://bugs.otrs.org/show_bug.cgi?id=8865) - Additional empty data column in statistics CSV-Output.
 - 2013-02-19 Fixed bug#[4056](http://bugs.otrs.org/show_bug.cgi?id=4056) - Delete S/MIME Certificate via AdminSMIME does not update CustomerUserPreferences.
 - 2013-02-18 Fixed bug#[9128](http://bugs.otrs.org/show_bug.cgi?id=9128) - OTRS uses internal sub of Locale::Codes::Country which causes trouble for
    Debian.
 - 2013-02-18 Fixed bug#[9173](http://bugs.otrs.org/show_bug.cgi?id=9173) - ProcessManagement: Very right aligned activities can't display assigned dialogs.
 - 2013-02-18 Fixed bug#[9174](http://bugs.otrs.org/show_bug.cgi?id=9174) - Process Management: Save / Save and finish / Cancel inside process diagram canvas.
 - 2013-02-15 Fixed bug#[9155](http://bugs.otrs.org/show_bug.cgi?id=9155) - SMIME: DefaultSignKey not selected in AJAX refreshes.
 - 2013-02-15 Fixed bug#[9164](http://bugs.otrs.org/show_bug.cgi?id=9164) - ProcessManagement: Default values of assigned hidden activity dialogs not considered.
 - 2013-02-15 Fixed bug#[7312](http://bugs.otrs.org/show_bug.cgi?id=7312) - otrs.SetPermissions.pl does not take scripts in $OTRSHOME/Custom into account.
 - 2013-02-15 Fixed bug#[7237](http://bugs.otrs.org/show_bug.cgi?id=7237) - Better Shortening Logic in Ascii2Html.
 - 2013-02-15 Fixed bug#[9139](http://bugs.otrs.org/show_bug.cgi?id=9139) - Context sensitive search in CIC doesn't open CIC search.
 - 2013-02-14 Fixed bug#[9087](http://bugs.otrs.org/show_bug.cgi?id=9087) - ProcessManagement: AgentTicketProcess doesn't show multi level queue structure.
 - 2013-02-14 Follow-up fix for bug#[9158](http://bugs.otrs.org/show_bug.cgi?id=9158) - ProcessManagement: Priority field error message: Need Priority or PriorityID!.

#3.2.2 2013-02-19
 - 2013-02-14 Fixed bug#[9171](http://bugs.otrs.org/show_bug.cgi?id=9171) - ProcessManagement: AgentTicketProcess lists all state types.
 - 2013-02-14 Follow-up fix for bug#[4513](http://bugs.otrs.org/show_bug.cgi?id=4513) - Password and Username are added
    automatically by the browser in AdminUser dialog.
 - 2013-02-14 Updated Spanish translation, thanks to Enrique Matías Sánchez!
 - 2013-02-14 Fixed bug#[9157](http://bugs.otrs.org/show_bug.cgi?id=9157) - ProcessManagement: Activity labels not aligned well.
 - 2013-02-14 Fixed bug#[9156](http://bugs.otrs.org/show_bug.cgi?id=9156) - ProcessManagement: Transition Condition Fields cannot be removed correctly.
 - 2013-02-14 Fixed bug#[9160](http://bugs.otrs.org/show_bug.cgi?id=9160) - ProcessManagement: Path dialog looses data after editing transition actions.
 - 2013-02-13 Fixed bug#[9159](http://bugs.otrs.org/show_bug.cgi?id=9159) - ProcessManagement: Date fields are activated by default.
 - 2013-02-13 Added display restriction for field "CustomerID" in Process Management Activity
    Dialogs to only be shown as mandatory or not shown.
 - 2013-02-13 Fixed bug#[9150](http://bugs.otrs.org/show_bug.cgi?id=9150) - Process Management: CustomerUser field not indicated as required field.
 - 2013-02-13 Fixed bug#[9158](http://bugs.otrs.org/show_bug.cgi?id=9158) - ProcessManagement: Priority field error message: Need Priority or PriorityID!
 - 2013-02-13 Fixed bug#[9162](http://bugs.otrs.org/show_bug.cgi?id=9162) - Setting the start day of the week for the datepicker to Sunday does not work.
 - 2013-02-13 Fixed bug#[9127](http://bugs.otrs.org/show_bug.cgi?id=9127) - Problem with CustomerPanelOwnSelection.
 - 2013-02-12 Added new Canadian French translation, thanks to Evans Bernier / CDE Solutions Informatique!
 - 2013-02-12 Fixed bug#[5492](http://bugs.otrs.org/show_bug.cgi?id=5492) - Need Template or TemplateFile Param error message after activating AgentInfo.
 - 2013-02-12 Fixed bug#[9138](http://bugs.otrs.org/show_bug.cgi?id=9138) - Unused X-OTRS-Info header in SysConfig.
 - 2013-02-11 Fixed bug#[9117](http://bugs.otrs.org/show_bug.cgi?id=9117) - CustomerUpdate history entry added even if customer user has not
    been updated.
 - 2013-02-11 Fixed bug#[9006](http://bugs.otrs.org/show_bug.cgi?id=9006) - Labels and values are misaligned.
 - 2013-02-11 Fixed bug#[9132](http://bugs.otrs.org/show_bug.cgi?id=9132) - Button to create new ticket appears in Customer Interface although
    ticket creation is disabled.
 - 2013-02-08 Added Patch/Workaround for CPAN MIME::Parser v5.503 that prevent the trimming of empty
    lines that lead to inconsistencies between signed and actual email contents
 - 2013-02-08 Fixed bug#[9146](http://bugs.otrs.org/show_bug.cgi?id=9146) - Signed SMIME mails with altered content shows a not clear message.
 - 2013-02-08 Fixed bug#[9145](http://bugs.otrs.org/show_bug.cgi?id=9145) - SMIME sign verification errors are not displayed in TicketZoom.
 - 2013-02-07 Fixed bug#[9140](http://bugs.otrs.org/show_bug.cgi?id=9140) - Postmaster Filter for empty subjects does not work.
 - 2013-02-07 Fixed bug#[8024](http://bugs.otrs.org/show_bug.cgi?id=8024) - WYSIWYG editor does not get correct language information.
 - 2013-02-07 Fixed bug#[9135](http://bugs.otrs.org/show_bug.cgi?id=9135) - Can't upgrade databases that have been changed from MyISAM \> InnoDB.
 - 2013-02-07 Fixed bug#[9125](http://bugs.otrs.org/show_bug.cgi?id=9125) - AgentTicketSearch dialog does not expand when choosing more search criteria.
 - 2013-02-06 Fixed bug#[9118](http://bugs.otrs.org/show_bug.cgi?id=9118) - TicketDynamicFieldUpdate history entry added even if value has not
    been updated.
 - 2013-02-06 Fixed bug#[9134](http://bugs.otrs.org/show_bug.cgi?id=9134) - Sidebar columns on some screens don't support more than one widget.
 - 2013-02-06 Fixed bug#[4662](http://bugs.otrs.org/show_bug.cgi?id=4662) - Unable to save article with '0' as only content.
 - 2013-02-05 Fixed bug#[9068](http://bugs.otrs.org/show_bug.cgi?id=9068) - ProcessManagement: Entity Names not shown in Deletion Dialogs.
 - 2013-02-05 Fixed bug#[9121](http://bugs.otrs.org/show_bug.cgi?id=9121) - Filenames with Unicode NFD are incorrectly reported as NFC by Main::DirectoryRead().
 - 2013-02-05 Fixed bug#[9126](http://bugs.otrs.org/show_bug.cgi?id=9126) - ProcessManagement: both article fields must be filled.
 - 2013-02-05 Added bug#[1197](http://bugs.otrs.org/show_bug.cgi?id=1197) - Feature enhancement: Link tickets at "Follow up".
 - 2013-02-05 Fixed bug#[9108](http://bugs.otrs.org/show_bug.cgi?id=9108) - Check for opened/closed tickets not working with Ticket::SubjectFormat = Right.
 - 2013-02-02 Made Web Installer reload after writing Config.pm under PerlEx.
 - 2013-02-01 Added restriction to TransitionAction TicketArticleCrete to do not allow the creation
    email article types.
 - 2013-02-01 Fixed bug#[9112](http://bugs.otrs.org/show_bug.cgi?id=9112) - ProcessManagment: TransitionAction TicketActicleCreate should not
    accept email type articles.
 - 2013-02-01 Fixed bug#[8839](http://bugs.otrs.org/show_bug.cgi?id=8839) - DateChecksum followup doesn't get correctly SystemID.
 - 2013-01-31 Fixed bug#[9111](http://bugs.otrs.org/show_bug.cgi?id=9111) - ProcessManagement: Empty Service or SLA causes an error.
 - 2013-01-31 Fixed bug#[9077](http://bugs.otrs.org/show_bug.cgi?id=9077) - Process Management: TicketType not available as field for activity.
    dialogs.
 - 2013-01-31 Updated Finnish translation, thanks to Niklas Lampén!
 - 2013-01-31 Updated Italian translation, thanks to Massimo Bianchi!
 - 2013-01-31 Updated Portugese (Brazilian) translation, thanks to Alexandre!
 - 2013-01-31 Updated Russian translation, thanks to Vadim Goncharov!
 - 2013-01-31 Added script otrs.MySQLInnoDBSwitch.pl to switch all database tables from MyISAM
    to InnoDB on the fly.
 - 2013-01-31 Added bin/otrs.ExecuteDatabaseXML.pl to directly execute Database DDL XML files on
    the OTRS database.
 - 2013-01-30 Fixed bug#[9097](http://bugs.otrs.org/show_bug.cgi?id=9097) - ProcessManagement: Uninitialized value after Ticket is created if
    notification event is triggered.
 - 2013-01-30 Fixed bug#[9101](http://bugs.otrs.org/show_bug.cgi?id=9101) - Not possible to create dropdown with autocomplete attribute.
 - 2013-01-29 Fixed bug#[9095](http://bugs.otrs.org/show_bug.cgi?id=9095) - ProcessManagement: Service field does not show default services.
 - 2013-01-29 Fixed bug#[9096](http://bugs.otrs.org/show_bug.cgi?id=9096) - All services list is shown instead of only default services.
 - 2013-01-29 Fixed bug#[9088](http://bugs.otrs.org/show_bug.cgi?id=9088) - ProcessManagement: Service field is not displayed in
    AgentTicketProcess.
 - 2013-01-29 Updated CPAN module MIME::Tools to version 5.503, keeping an OTRS patch in MIME::Words.
 - 2013-01-29 Fixed bug#[9092](http://bugs.otrs.org/show_bug.cgi?id=9092) - Problem running DBUpdate-to-3.2.mysql.sql on InnoDB.
 - 2013-01-28 Fixed bug#[9078](http://bugs.otrs.org/show_bug.cgi?id=9078) - Fields of type "email" loosing style format.
 - 2013-01-28 Fixed bug#[9090](http://bugs.otrs.org/show_bug.cgi?id=9090) - ProcessManagement popup dialogs cannot be saved by pressing Enter.
 - 2013-01-28 Fixed bug#[8470](http://bugs.otrs.org/show_bug.cgi?id=8470) - otrs.GenericAgent.pl reports: Can't open
    '/opt/otrs/otrs\_vemco/var/tmp/CacheFileStorable/DynamicField/f3b7e10730fb6c9cab5ae0e7f7e034f3'.
 - 2013-01-28 Fixed bug#[7678](http://bugs.otrs.org/show_bug.cgi?id=7678) - SecureMode does not do what it should.
 - 2013-01-28 Fixed bug#[5158](http://bugs.otrs.org/show_bug.cgi?id=5158) - Unsafe UTF8 handling in Encode module.
 - 2013-01-28 Fixed bug#[8959](http://bugs.otrs.org/show_bug.cgi?id=8959) - AgentTicketResponsible Responsible Changed not checked/forced.
 - 2013-01-28 Fixed bug#[9089](http://bugs.otrs.org/show_bug.cgi?id=9089) - Activities and transitions with HTML special characters are
    not displayed correctly.
 - 2013-01-28 Added new translation for Spanish (Colombia), thanks to John Edisson Ortiz Roman!
 - 2013-01-28 Updated Finnish translation, thanks to Niklas Lampén!

#3.2.1 2013-01-29
 - 2013-01-24 Updated Dutch translation.
 - 2013-01-24 Added test to check if there are problems with the MySQL storage engine used
    in OTRS tables to bin/otrs.CheckModules.pl.
 - 2013-01-23 Fixed bug#[9082](http://bugs.otrs.org/show_bug.cgi?id=9082) - Process Management: Wrong popup redirect handling to Process Path
    from TransitionAction.
 - 2013-01-22 Fixed bug#[9065](http://bugs.otrs.org/show_bug.cgi?id=9065) - Process Management: Service and SLA fields are always shown in ActivityDialogs.
 - 2013-01-21 Fixed bug#[9054](http://bugs.otrs.org/show_bug.cgi?id=9054) - Link Object deletes all links under certain conditions.
 - 2013-01-21 Fixed bug#[9059](http://bugs.otrs.org/show_bug.cgi?id=9059) - Process Management: transition actions module field too short.
 - 2013-01-21 Fixed bug#[9066](http://bugs.otrs.org/show_bug.cgi?id=9066) - ProcessManagement: edit links not displayed in popups.
 - 2013-01-21 Fixed an issue where default values would be used erroneously for ActivityDialog
    fields where a value was already present.
 - 2013-01-21 Fixed bug#[9052](http://bugs.otrs.org/show_bug.cgi?id=9052) - Accordion is reset after submitting a popup.
 - 2013-01-21 Fixed bug#[9067](http://bugs.otrs.org/show_bug.cgi?id=9067) - New process ticket: state selection empty after AJAX reload.

#3.2.0.rc1 2013-01-22
 - 2013-01-18 Fixed bug#[8944](http://bugs.otrs.org/show_bug.cgi?id=8944) - do not backup the cache.
 - 2013-01-17 Updated Finnish translation, thanks to Niklas Lampén!
 - 2013-01-16 Fixed bug#[8929](http://bugs.otrs.org/show_bug.cgi?id=8929) - Fix problems with empty ticket search results while
    Ticket::Frontend::AgentTicketSearch###ExtendedSearchCondition is inactive.
 - 2013-01-16 Fixed bug#[9057](http://bugs.otrs.org/show_bug.cgi?id=9057) - Generating a PDF with bin/otrs.GenerateStats.pl produces lots
    of warnings.
 - 2013-01-15 Fixed bug#[9050](http://bugs.otrs.org/show_bug.cgi?id=9050) - Process Management: ticket title disappears.
 - 2013-01-15 Fixed bug#[9049](http://bugs.otrs.org/show_bug.cgi?id=9049) - Process Management: process with a starting AD for CustomerInterface
    only breaks in AgentInterface.
 - 2013-01-15 Fixed problems with YAML parsing long lines. Added new module dependency YAML::XS.
 - 2013-01-15 Updated CPAN module Mozilla::CA to version 20130114.
 - 2013-01-15 Updated CPAN module MailTools to version 2.12.
 - 2013-01-15 Updated CPAN module Locale::Codes to version 3.24.
 - 2013-01-15 Updated CPAN module Digest::SHA::PurePerl to version 5.81.
 - 2013-01-15 Updated CPAN module Authen::SASL to version 2.16.
 - 2013-01-14 Fixed bug#[9044](http://bugs.otrs.org/show_bug.cgi?id=9044) - ProcessManagement: Transition is duplicated on redraw.
 - 2013-01-14 Fixed bug#[9035](http://bugs.otrs.org/show_bug.cgi?id=9035) - Event Based mails, triggered by a process ticket, have no sender.
 - 2013-01-14 Fixed bug#[9043](http://bugs.otrs.org/show_bug.cgi?id=9043) - ProcessManagement: Transitions without EndActivity are not correctly removed.
 - 2013-01-14 Fixed bug#[9045](http://bugs.otrs.org/show_bug.cgi?id=9045) - Process Management: Activity Dialog field order lost.
 - 2013-01-14 Fixed bug#[9042](http://bugs.otrs.org/show_bug.cgi?id=9042) - Add X-Spam-Score to Ticket.xml.
 - 2013-01-14 Fixed bug#[9047](http://bugs.otrs.org/show_bug.cgi?id=9047) - HistoryTicketGet caches info on disk directly.
 - 2013-01-11 The Phone Call Outbound and Inbound buttons where moved from the Article menu to
    the Ticket menu in the TicketZoom screen for the agent interface, in order to be able to
    register phone calls on tickets without articles.
 - 2013-01-11 Fixed bug#[9036](http://bugs.otrs.org/show_bug.cgi?id=9036) - Process# hook does not register an incoming email to the process.
 - 2013-01-11 The names of the TransitionActions were changed to make them more consistent.
    Please check your processes if you have already defined some which use TransitionActions.
    Also, the parameter names of the TransitionAction TicketQueueSet and TicketTypeSet were changed.
 - 2013-01-11 Fixed bug#[4513](http://bugs.otrs.org/show_bug.cgi?id=4513) - Password and Username are added automatically by the browser
    in AdminUser dialog.
 - 2013-01-11 Fixed bug#[8923](http://bugs.otrs.org/show_bug.cgi?id=8923) - Alert message shown, if parent window is reloaded while
     bulk action popup is open.
 - 2013-01-11 Fixed bug#[9037](http://bugs.otrs.org/show_bug.cgi?id=9037) - TransitionAction TicketQueueSet parameters does not follow same name
    convention as others.
 - 2013-01-11 Fixed bug#[9032](http://bugs.otrs.org/show_bug.cgi?id=9032) - TransitionAction module name notation.
 - 2013-01-10 Fixed bug#[9029](http://bugs.otrs.org/show_bug.cgi?id=9029) - Switching on Queue in AgentTicketActionCommon will always result in
    a move.
 - 2013-01-09 Fixed bug#[9031](http://bugs.otrs.org/show_bug.cgi?id=9031) - ProcessManagement Transition condition with regexp fails.
 - 2013-01-09 Fixed bug#[9030](http://bugs.otrs.org/show_bug.cgi?id=9030) - Wrong handling of Invalid YAML in Scheduler Tasks.
 - 2013-01-07 Fixed bug#[8966](http://bugs.otrs.org/show_bug.cgi?id=8966) - Cc and Bcc lists are hidden if one entry is deleted.
 - 2013-01-07 Fixed bug#[8993](http://bugs.otrs.org/show_bug.cgi?id=8993) - OTRS JavaScript does not handle session timeouts gracefully.
 - 2013-01-07 Updated Polish translation, thanks to Pawel @ ib.pl!
 - 2013-01-04 Fixed bug#[9015](http://bugs.otrs.org/show_bug.cgi?id=9015) - otrs.CheckModules.pl reports module as not installed
    if prerequisite is missing.
 - 2013-01-04 Follow-up fix for bug#[8805](http://bugs.otrs.org/show_bug.cgi?id=8805) - Cron missing as RPM dependency on Red Hat Enterprise Linux.
    Changed dependency on 'anacron' to 'vixie-cron' on RHEL5.
 - 2013-01-04 Removed CPAN module Net::IMAP::Simple::SSL, this can be handled by
    Net::IMAP::Simple now.
 - 2013-01-04 Updated CPAN module Net::IMAP::Simple to version 1.2034.
 - 2013-01-04 Configured mod\_deflate in bundled Apache configuration file.

#3.2.0.beta5 2013-01-08
 - 2013-01-02 Fixed bug#[9020](http://bugs.otrs.org/show_bug.cgi?id=9020) - Generic Ticket Connector does not support attachments with
    ContentType without charset.
 - 2013-01-02 Fixed bug#[8545](http://bugs.otrs.org/show_bug.cgi?id=8545) - Attachment download not possible if pop up of another action is open.
 - 2012-12-27 Fixed bug#[8990](http://bugs.otrs.org/show_bug.cgi?id=8990) - Autocompletion returns stale requests.
 - 2012-12-20 Fixed bug#[9009](http://bugs.otrs.org/show_bug.cgi?id=9009) - Empty Multiselect Dynamic Fields provokes an error.
 - 2012-12-19 Fixed bug#[8999](http://bugs.otrs.org/show_bug.cgi?id=8999) - Upcoming event with duplicate dates not displayed in Dashboard.
 - 2012-12-17 Fixed bug#[8457](http://bugs.otrs.org/show_bug.cgi?id=8457) - Error if accessing AgentTicketSearch from AgentTicketPhone in IE8.
 - 2012-12-17 Fixed bug#[8589](http://bugs.otrs.org/show_bug.cgi?id=8589) - Bulk-Action not possible for single ticket.
 - 2012-12-17 Fixed bug#[8695](http://bugs.otrs.org/show_bug.cgi?id=8695) - Table head of Customer Ticket History does not resize on window resize.
 - 2012-12-13 Fixed bug#[8533](http://bugs.otrs.org/show_bug.cgi?id=8533) - Apache will not start if you use mod\_perl on Fedora 16 or 17.
 - 2012-12-12 Fixed bug#[8950](http://bugs.otrs.org/show_bug.cgi?id=8950) - "Sign" and "crypt" are displayed two times in AgentTicketCompose.
 - 2012-12-12 Added RPM specfiles for RHEL5 and RHEL6.
 - 2012-12-12 Fixed bug#[8977](http://bugs.otrs.org/show_bug.cgi?id=8977) - ArticleStorageFS fails after upgrade beta3 \>\> beta4.
 - 2012-12-11 Fixed bug#[5644](http://bugs.otrs.org/show_bug.cgi?id=5644) - In Article Zoom, Article Filter: Reset Icon is not showing "reset" action. Search for better icon.
 - 2012-12-11 Updated json2.js.
 - 2012-12-11 Added TicketList statistic option for historic states and historic state types.
 - 2012-12-11 Updated QUnit to version 1.10.0.
 - 2012-12-11 Updated StacktraceJS to version 0.4.
 - 2012-12-11 Updated jQuery Validate to version 1.10.
 - 2012-12-11 Added support for limiting result sets in the SQL Server DB Driver.
 - 2012-12-10 Fixed bug#[8974](http://bugs.otrs.org/show_bug.cgi?id=8974) - Event Based Notification does not populate REALNAME with
    Customer User data.
 - 2012-12-10 Fixed bug#[8928](http://bugs.otrs.org/show_bug.cgi?id=8928) - Link in Groups and Roles screens shows agent login, not name.
 - 2012-12-10 Upgraded CKEditor to version 4.0.

#3.2.0.beta4 2012-12-11
 - 2012-12-05 Fixed bug#[7697](http://bugs.otrs.org/show_bug.cgi?id=7697) - Creating queues: sub-queues after level 4 not shown in dropdown box.
 - 2012-12-03 Fixed bug#[8933](http://bugs.otrs.org/show_bug.cgi?id=8933) - ArticleStorageInit permission check problem.
 - 2012-12-03 Various improvements in CustomerInformationCenter and ProcessManagement.
 - 2012-12-03 Fixed bug#[8963](http://bugs.otrs.org/show_bug.cgi?id=8963) - CIC Company attributes not marked as visible are displayed in
    Company Dashlet.
 - 2012-11-30 Updated Estonian language translation, thanks to Margus Värton!
 - 2012-11-29 Fixed bug#[8949](http://bugs.otrs.org/show_bug.cgi?id=8949) - CIC can't open in a new tab in Firefox 17.
 - 2012-11-29 Fixed bug#[8948](http://bugs.otrs.org/show_bug.cgi?id=8948) - CIC Dashboard Filters shows error, customer\_id will be lost.
 - 2012-11-29 Fixed bug#[8763](http://bugs.otrs.org/show_bug.cgi?id=8763) - Added charset conversion for customer companies.
 - 2012-11-29 Fixed bug#[1970](http://bugs.otrs.org/show_bug.cgi?id=1970) - Email attachments of type .msg (Outlook-Message) are converted.
 - 2012-11-28 Fixed bug#[8955](http://bugs.otrs.org/show_bug.cgi?id=8955) - Init script might fail on SUSE.
 - 2012-11-24 Fixed bug#[8936](http://bugs.otrs.org/show_bug.cgi?id=8936) - Ticket close date is empty when ticket is created in closed state.
 - 2012-11-24 Fixed bug#[8942](http://bugs.otrs.org/show_bug.cgi?id=8942) - Dates show UTC offset on systems with Timezone support activated.
 - 2012-11-23 Fixed problem with out of office feature in dashboard module DashboardUserOnline.

#3.2.0.beta3 2012-11-27
 - 2012-11-22 Fixed bug#[8937](http://bugs.otrs.org/show_bug.cgi?id=8937) - "$" should be escaped in interpolated strings when javascript is meant.
 - 2012-11-20 Fixed bug#[8932](http://bugs.otrs.org/show_bug.cgi?id=8932) - DB backend CustomerName function is prefixed with login.
 - 2012-11-20 Fixed bug#[8896](http://bugs.otrs.org/show_bug.cgi?id=8896) - ProcessManagement GUI Transition arrows overlaps.
    To achieve this, the rendering engine of the ProcessManagement admin GUI was replaced
    by jsplumb.
 - 2012-11-19 Fixed bug#[8919](http://bugs.otrs.org/show_bug.cgi?id=8919) - Customer interface search results: ticket can only be accessed
    via ticket number and subject.
 - 2012-11-19 Fixed bug#[8809](http://bugs.otrs.org/show_bug.cgi?id=8809) - CustomerTicketOverview shows Queue and Owner fields hardcoded.
 - 2012-11-19 Fixed another possible race condition in the new DB session backend.
 - 2012-11-19 Fixed bug#[8850](http://bugs.otrs.org/show_bug.cgi?id=8850) - CustomerTicketOverview - MouseOver Age isn't always correct.
 - 2012-11-17 Follow up fix for added feature Ideascale#934 / bug#[1682](http://bugs.otrs.org/show_bug.cgi?id=1682) - Add
    timescale for Week in Stats.
 - 2012-11-18 Fixed bug#[8927](http://bugs.otrs.org/show_bug.cgi?id=8927) - OTRS under mod\_perl generates core dumps when
    used on SysLog log backend.
 - 2012-11-17 Fixed bug#[8926](http://bugs.otrs.org/show_bug.cgi?id=8926) - RoleList and GroupList cache is not reset when groups or
    roles are added or updated.
 - 2012-11-17 Updated Dutch translation.
 - 2012-11-16 Fixed a bug where addresses were lost in AgentTicketCompose after adding
    or removing an attachment.
 - 2012-11-15 Added feature to edit Dynamic Fields in customer follow ups.
 - 2012-11-15 Updated CPAN module CGI to version 3.63.
 - 2012-11-15 Fixed a bug where articles would display an incorrect creation date.
 - 2012-11-15 Added feature to search on Company Name in CustomerID field in Customer
    Information Center.
 - 2012-11-15 Fixed bug#[8921](http://bugs.otrs.org/show_bug.cgi?id=8921) - Responsible selection has empty option after a selection is
    made in AgentTicketActionCommon based screens.
 - 2012-11-15 Fixed bug#[8920](http://bugs.otrs.org/show_bug.cgi?id=8920) - Owner selection is set to empty list after a selection is made
    in AgentTicketActionCommon based screens.
 - 2012-11-14 Fixed bug#[8868](http://bugs.otrs.org/show_bug.cgi?id=8868) - Event Based Notification problem saving 'text' Dynamic Fields.
 - 2012-11-13 Fixed bug#[8910](http://bugs.otrs.org/show_bug.cgi?id=8910) - AjaxUpdate of DynamicFields in CustomerFrontend.
 - 2012-11-12 Fixed bug#[8915](http://bugs.otrs.org/show_bug.cgi?id=8915) - CustomerCompany List returns extra spaces.
 - 2012-11-12 Added feature to hide archived tickets in the customer interface.
 - 2012-11-12 Updated CPAN module CGI to version 3.62.
 - 2012-11-09 Fixed bug#[8914](http://bugs.otrs.org/show_bug.cgi?id=8914) - Syntax error in hash loop in TicketGet operation.

#3.2.0.beta2 2012-11-13
 - 2012-11-07 Fixed bug#[8749](http://bugs.otrs.org/show_bug.cgi?id=8749) - CustomerFrontend: missing dynamicfield in  search results.
 - 2012-11-07 Fixed bug#[8908](http://bugs.otrs.org/show_bug.cgi?id=8908) - ProcessManagement import config feature doesn't works if
    dynamic fields are included.
 - 2012-11-07 Fixed bug#[8907](http://bugs.otrs.org/show_bug.cgi?id=8907) - ProcessManagement StartActivityDialog Owner and Responsible fields
    produces an error.
 - 2012-11-07 Fixed bug#[8906](http://bugs.otrs.org/show_bug.cgi?id=8906) - ProcessManagement Activities without AtivityDialogs leads to a
    internal error in TicketZoom.
 - 2012-11-07 Fixed handling of scalar refs in the new DB based session backend.
 - 2012-11-07 Fixed race condition in new DB based session backend.
 - 2012-11-07 Changed default setting for 'Ticket::Frontend::ZoomRichTextForce'.
    Now OTRS will display HTML emails as HTML by default, even if RichText is not
    activated for composing new messages. This helps for devices which cannot
    use RichText for editing, but are able to display HTML content, such as certain
    iPads.
 - 2012-11-07 Fixed bug#[8897](http://bugs.otrs.org/show_bug.cgi?id=8897) - Wrong ProcessManagement Transition config format.
 - 2012-11-06 Fixed bug#[8873](http://bugs.otrs.org/show_bug.cgi?id=8873) - Bad example of customization of "static" dynamic fields in
    AgentTicketOverviewSmall.
 - 2012-11-06 Fixed bug#[8901](http://bugs.otrs.org/show_bug.cgi?id=8901) - ProcessManagement No article created on StartActivityDialog.
 - 2012-11-06 Fixed bug#[8890](http://bugs.otrs.org/show_bug.cgi?id=8890) - ProcessManagement Undefined EntityID error on
    AdminProcessManagementTransition edit.
 - 2012-11-06 Fixed bug#[8899](http://bugs.otrs.org/show_bug.cgi?id=8899) - ProcessManagement Articles should not have ArticleType email.
 - 2012-11-06 Fixed bug#[8898](http://bugs.otrs.org/show_bug.cgi?id=8898) - ProcessManagement GUI error on popup close (without change).
 - 2012-11-06 Fixed bug#[8895](http://bugs.otrs.org/show_bug.cgi?id=8895) - ProcessManagement Transition Path JS error on Transition Dbl Click.
 - 2012-11-06 Fixed bug#[3419](http://bugs.otrs.org/show_bug.cgi?id=3419) - Kernel/Config/GenericAgent.pm and utf8.
 - 2012-11-06 Fixed a typo in the auto-generated process configuration cache.
 - 2012-11-05 Updated Swedish translation, thanks to Andreas Berger!
 - 2012-11-02 Fixed bug#[8791](http://bugs.otrs.org/show_bug.cgi?id=8791) - IMAPTLS fails with some Microsoft Exchange servers.
 - 2012-10-31 Fixed bug#[8430](http://bugs.otrs.org/show_bug.cgi?id=8430) - Dynamic field management: selection dropdowns
    aren't translated.
 - 2012-10-30 Fixed bug#[8872](http://bugs.otrs.org/show_bug.cgi?id=8872) - Need a scalar reference! error on File uploads.
 - 2012-10-30 Updated CPAN module MailTools to version 2.11.
 - 2012-10-30 Updated CPAN module Mozilla::CA to version 20120823.
 - 2012-10-30 Updated CPAN module Locale::Codes to version 3.23.
 - 2012-10-30 Updated CPAN module HTTP::Message to version 6.06.
 - 2012-10-30 Updated CPAN module Digest::SHA::PurePerl to version 5.72.
 - 2012-10-30 Updated CPAN module Class::Inspector to version 1.28.
 - 2012-10-30 Updated CPAN module CGI to version 3.60.
 - 2012-10-30 Updated CPAN module Authen::SASL to version 2.16.

#3.2.0.beta1 2012-10-30
 - 2012-11-19 Fixed bug#[8919](http://bugs.otrs.org/show_bug.cgi?id=8919) - Customer interface search results: ticket can only be accessed
    via ticket number and subject.
 - 2012-10-25 Fixed bug#[8864](http://bugs.otrs.org/show_bug.cgi?id=8864) - Increasing the column size of a varchar column does not work on oracle
    under certain conditions.
 - 2012-10-24 Fixed bug#[8062](http://bugs.otrs.org/show_bug.cgi?id=8062) - Optimize images in all defualt skins.
 - 2012-10-24 Fixed bug#[8861](http://bugs.otrs.org/show_bug.cgi?id=8861) - Ticket History overlaid calender choice function.
 - 2012-10-24 Fixed bug#[8818](http://bugs.otrs.org/show_bug.cgi?id=8818) - Slash in attachment filename breaks webinterface.
 - 2012-10-24 Added feature to limit the numbers of cuncurrent working agents and customers.
 - 2012-10-24 Refactored session management to improve performance and scalability.
 - 2012-10-23 Fixed bug#[8566](http://bugs.otrs.org/show_bug.cgi?id=8566) - Cannot download attachment if filename has character #.
 - 2012-10-23 Fixed bug#[8541](http://bugs.otrs.org/show_bug.cgi?id=8541) - Tooltip hides customer field in AgentTicketPhoneNew.
 - 2012-10-23 Fixed bug#[8833](http://bugs.otrs.org/show_bug.cgi?id=8833) - Article table in TicketZoom does not scroll correctly.
 - 2012-10-23 Fixed bug#[8685](http://bugs.otrs.org/show_bug.cgi?id=8685) - Cannot use address book / customer / spell check in phone / email if cookies are disabled.
 - 2012-10-23 Fixed bug#[8861](http://bugs.otrs.org/show_bug.cgi?id=8861) - Placeholder container for multiple customer fields are being displayed though being empty.
 - 2012-10-23 Fixed bug#[8673](http://bugs.otrs.org/show_bug.cgi?id=8673) - Richtext-Editor popups broken on Customer-Interface.
 - 2012-10-23 Upgraded CKEditor to version 3.6.5.
 - 2012-10-22 Fixed bug#[8840](http://bugs.otrs.org/show_bug.cgi?id=8840) - Verifying signature of inline-pgp-signed email with utf8 characters
    fails even though signatures without such characters get verified.
 - 2012-10-22 Fixed bug#[8746](http://bugs.otrs.org/show_bug.cgi?id=8746) - Unequal usage for ticket ACL match and limitation settings for
    dynamic fields.
 - 2012-10-22 Fixed bug#[7121](http://bugs.otrs.org/show_bug.cgi?id=7121) - Upgrading OTRS using RPM will not upgrade changed ITSM files.
 - 2012-10-22 Removed obsolete and slow cache backend FileRaw in favor of the better FileStorable.
    Config setting is updated automatically if needed.
 - 2012-10-22 Fixed bug#[1423](http://bugs.otrs.org/show_bug.cgi?id=1423) - Trim OTRS fields before processing.
    Kernel::System::Web::Request::GetParam()/GetArray() now always perform whitespace trimming
    by default. Use Raw =\> 1 to get the unchanged data if you need it.
 - 2012-10-20 Fixed bug#[8678](http://bugs.otrs.org/show_bug.cgi?id=8678) - 'WidgetAction Toggle' is always shown as 'Expanded' when nesting elements
 - 2012-10-20 Fixed bug#[8378](http://bugs.otrs.org/show_bug.cgi?id=8378) - Validation fails if the ID of the element contains a dot (.) or a
    colon (:)
 - 2012-10-17 Added possibility to select the queue in AgentTicketActionCommon based
    screens.
 - 2012-10-17 Fixed bug#[8842](http://bugs.otrs.org/show_bug.cgi?id=8842) - Stats outputs DynamicField keys, not values.
 - 2012-10-16 Added unit test for SOAP::Lite "Incorrect parameter" error.
 - 2012-10-16 Fixed "Incorrect parameter" error in SOAP::Lite 0.715 on any RPC with more than 2
    parameters.
 - 2012-10-15 Added bug#[8815](http://bugs.otrs.org/show_bug.cgi?id=8815) - List each SQL column at most once in INSERT statement in
    CustomerUser Backend, thanks to Michael Kromer!
 - 2012-10-15 Removed insecure storage of the last password of the user as unsalted plain md5. OTRS no
    longer checks if a user enters a different password than the previous one.
 - 2012-10-12 Fixed bug#[8807](http://bugs.otrs.org/show_bug.cgi?id=8807) - Company database with ForeignDB settings show empty columns.
 - 2012-10-10 Implemented redirect to the TicketZoom if Search result returns only one ticket.
 - 2012-10-08 Fixed bug#[7274](http://bugs.otrs.org/show_bug.cgi?id=7274) - Ticket QueueView sorts by priority on first page but subsequent
    pages sort incorrectly by Age.
 - 2012-10-08 Fixed bug#[8802](http://bugs.otrs.org/show_bug.cgi?id=8802) - Update to 3.1 leaves freetext columns in article\_search.
 - 2012-09-28 Fixed bug#[8794](http://bugs.otrs.org/show_bug.cgi?id=8794) - Depreciation warnings in web server error log for
    AdminEmail.pm when using perl \>= 5.16.
 - 2012-09-27 Fixed bug#[8551](http://bugs.otrs.org/show_bug.cgi?id=8551) - Missing DynamicFields values in TemplateGenerator and
    NotificationEvent (only show keys).
 - 2012-09-26 Added support for new SysConfig settings type "DateTime" (Date and DateTime).
 - 2012-09-24 Fixed bug#[5098](http://bugs.otrs.org/show_bug.cgi?id=5098) - OTRS does not verify that SMIME signatures match email senders.
 - 2012-09-21 Added new feature "SwitchToCustomer". The feature can be enabled
    with the new sysconfig setting "SwitchToCustomer".
 - 2012-09-13 Added possibility to search for tickets based on escalation time.
 - 2012-08-10 Added bug#[7183](http://bugs.otrs.org/show_bug.cgi?id=7183) - Usage of HTML5 Form field 'email'.
 - 2012-09-10 Added caching to Kernel::System::CustomerCompany.
 - 2012-09-07 Updated FSF address.
 - 2012-08-20 Fixed bug#[3463](http://bugs.otrs.org/show_bug.cgi?id=3463) - \<OTRS\_TICKET\_EscalationDestinationIn\> incorrect.
 - 2012-08-20 Fixed bug#[5954](http://bugs.otrs.org/show_bug.cgi?id=5954) - Ticket::Frontend::OverviewSmall###ColumnHeader has
    no effect on customer frontend.
 - 2012-08-17 HTML mails will now be displayed in the restricted zone in IE.
    This means that more restrictive security settings will apply, such as blocking of
    JavaScript content by default.
 - 2012-08-16 Added possibility to expand DynamicFields by default in ticket search
    via config option Ticket::Frontend::AgentTicketSearch###DynamicField.
 - 2012-08-14 Fixed bug#[8679](http://bugs.otrs.org/show_bug.cgi?id=8679) - OTRS changes "UTF-8" to "utf-8" in displayed emails.
 - 2012-08-10 Fixed bug#[5240](http://bugs.otrs.org/show_bug.cgi?id=5240) - Don't update read only fields in the CustomerUser DB.
 - 2012-08-03 Improved HTML mail display filtering. SVG content is now filtered out because
    it is potentially dangerous.
 - 2012-08-03 Generated HTML mails now always have the HTML5 doctype.
    HTML mail content to be displayed in OTRS now always gets the HTML5 doctype
    if it does not have a doctype yet. The HTML5 doctype is compatible to HTML4 and
    causes the browsers to render the content in standards mode, which is safer.
 - 2012-08-02 Improved HTML mail display filtering.
    Simple Microsoft CSS expressions are now filtered out.
 - 2012-07-31 Removed unused script otrs.XMLMaster.pl.
 - 2012-07-31 Changed the behaviour of HTML mail display filtering.
    By default, all inline/active content (such as script, object, applet or embed tags)
    will be stripped. If there are external images in mails from the customer, they will be stripped too,
    but a message will be shown allowing the user to reload the page showing the external images.
 - 2012-07-31 HTML mails will now be displayed in an HTML5 sandbox iframe.
    This means that modern browsers will not execute plugins or JavaScript on the content
    any more. Currently, this is supported by Chrome and Safari, but IE10 and FF16 are also
    planned to support this.
 - 2012-07-30 Switched the OTRS frontend to use the HTML5 doctype.
 - 2012-07-23 Added object check in the event handler mechanism.
 - 2012-07-16 Updated CPAN module Apache2::Reload to version 0.12.
 - 2012-07-16 Updated CPAN module LWP::UserAgent to version 6.04.
 - 2012-07-16 Updated CPAN module YAML to version 0.84.
 - 2012-07-16 Updated CPAN module URI to version 1.60.
 - 2012-07-16 Updated CPAN module Mail::Address to version 2.09.
 - 2012-07-16 Updated CPAN module SOAP::Lite to version 0.715.
 - 2012-07-16 Updated CPAN module Mozilla::CA to version 20120309.
 - 2012-07-16 Updated CPAN module Local::Codes to version 3.22.
 - 2012-07-16 Updated CPAN module Encode::Locale to version 1.03.
 - 2012-07-16 Updated CPAN module Digest::SHA::PurePerl to version 5.71.
 - 2012-07-16 Updated CPAN module Class::Inspector to version 1.27.
 - 2012-07-16 Fixed bug#[8616](http://bugs.otrs.org/show_bug.cgi?id=8616) - Spell Checker does not work using IE9.
 - 2012-07-05 Added the ability to hide the Article Type from TicketActionCommon-based screens
    which can be helpful to fit more data in the browser window.
 - 2012-07-04 The customer web interface now fully supports AJAX and ACLs.
    It now requires JavaScript and can no longer be used with Internet Explorer 6 or earlier versions.
 - 2012-07-03 Added new feature to remove seen flags and ticket watcher information of
    archived tickets. Use the config settings Ticket::ArchiveSystem::RemoveSeenFlags and
    Ticket::ArchiveSystem::RemoveTicketWatchers to control if this data is removed when
    a ticket is being archived (active by default).
    Archived tickets will now always be shown as 'seen' by the agent.
 - 2012-06-26 Improved cache performance with many cache files.
 - 2012-06-26 Removed unneeded columns from the ticket table.
 - 2012-06-21 Added bin/otrs.TicketDelete.pl script to delete tickets.
 - 2012-06-21 Fixed bug#[8596](http://bugs.otrs.org/show_bug.cgi?id=8596) - user/group/role data updated unnecessarily on LDAP agent sync.
 - 2012-06-19 Reduced the number of database calls for the article flags in AgentTicketZoom.
 - 2012-06-18 Removed unneeded indices from the article\_flags table.
 - 2012-06-08 Added feature SMIME certificate read.
 - 2012-05-25 Fixed bug#[8522](http://bugs.otrs.org/show_bug.cgi?id=8522) - Multiple recipient feature is missing in AgentTicketForward.
 - 2012-05-25 Added template list to all output filter config to improve performance.
 - 2012-05-24 Added feature IdeaScale#925 - possibility to place customized DTL files in
    Custom/Kernel/Output/HTML, so that they override the system's default DTL files just like
    it already works for Perl files.
 - 2012-05-22 Fixed bug#[8442](http://bugs.otrs.org/show_bug.cgi?id=8442) - Can not submit tickets in customer interface if Queue selection is
    disabled and no Default queue is specified.
 - 2012-05-21 Added feature Ideascale#72 / bug#[5471](http://bugs.otrs.org/show_bug.cgi?id=5471) - Out-of-Office dashboard widget.
 - 2012-05-14 Added feature Ideascale#934 / bug#[1682](http://bugs.otrs.org/show_bug.cgi?id=1682) - Add timescale for Week in Stats.
 - 2012-05-14 Added feature Ideascale#896 - Have the ability to set the default ticket type
    or hide the ticket type in the Customer Interface for new tickets.
 - 2012-05-07 Fixed bug#[8196](http://bugs.otrs.org/show_bug.cgi?id=8196) - Wrong article sender type for web service tickets.
 - 2012-04-27 Added bug#[8075](http://bugs.otrs.org/show_bug.cgi?id=8075) - Article Sender Type to be added to
    NotificationEvent definitions.

#3.1.14 2013-??-??
 - 2013-03-02 Fixed bug#[9214](http://bugs.otrs.org/show_bug.cgi?id=9214) - IE10: impossible to open links from rich text articles.
 - 2013-03-01 Fixed bug#[9218](http://bugs.otrs.org/show_bug.cgi?id=9218) - Cannot use special characters in TicketHook.
 - 2013-02-28 Fixed bug#[9056](http://bugs.otrs.org/show_bug.cgi?id=9056) - Unused SysConfig option Ticket::Frontend::CustomerInfoQueueMaxSize.
 - 2013-02-26 Follow-up fix for bug#[8533](http://bugs.otrs.org/show_bug.cgi?id=8533) apache will not start on Fedora.
 - 2013-02-26 Fixed bug#[9172](http://bugs.otrs.org/show_bug.cgi?id=9172) - Generic Interface does not work on IIS 7.0.
 - 2013-02-21 Updated Czech language translation, thanks to Katerina Bubenickova!
 - 2013-02-20 Fixed bug#[8865](http://bugs.otrs.org/show_bug.cgi?id=8865) - Additional empty data column in statistics CSV-Output.

#3.1.13 2013-02-19
 - 2013-02-19 Fixed bug#[9128](http://bugs.otrs.org/show_bug.cgi?id=9128) - OTRS uses internal sub of Locale::Codes::Country which causes trouble for
    Debian.
 - 2013-02-13 Fixed bug#[9162](http://bugs.otrs.org/show_bug.cgi?id=9162) - Setting the start day of the week for the datepicker to Sunday does not work.
 - 2013-02-13 Fixed bug#[9141](http://bugs.otrs.org/show_bug.cgi?id=9141) - Confused Columns in CustomerTicketSearch (ResultShort).
 - 2013-02-08 Fixed bug#[9146](http://bugs.otrs.org/show_bug.cgi?id=9146) - Signed SMIME mails with altered content shows a not clear message.
 - 2013-02-08 Fixed bug#[9145](http://bugs.otrs.org/show_bug.cgi?id=9145) - SMIME sign verification errors are not displayed in TicketZoom.
 - 2013-02-07 Fixed bug#[9140](http://bugs.otrs.org/show_bug.cgi?id=9140) - Postmaster Filter for empty subjects does not work.
 - 2013-02-05 Fixed bug#[9121](http://bugs.otrs.org/show_bug.cgi?id=9121) - Filenames with Unicode NFD are incorrectly reported as NFC by Main::DirectoryRead().
 - 2013-02-05 Fixed bug#[9108](http://bugs.otrs.org/show_bug.cgi?id=9108) - Check for opened/closed tickets not working with Ticket::SubjectFormat = Right.
 - 2013-02-01 Fixed bug#[8839](http://bugs.otrs.org/show_bug.cgi?id=8839) - DateChecksum followup doesn't get correctly SystemID.
 - 2013-01-31 Updated Russian translation, thanks to Vadim Goncharov!
 - 2013-01-30 Fixed bug#[9101](http://bugs.otrs.org/show_bug.cgi?id=9101) - Not possible to create dropdown with autocomplete attribute.
 - 2013-01-29 Fixed bug#[9096](http://bugs.otrs.org/show_bug.cgi?id=9096) - All services list is shown instead of only default services.
 - 2013-01-28 Fixed bug#[8470](http://bugs.otrs.org/show_bug.cgi?id=8470) - otrs.GenericAgent.pl reports: Can't open
    '/opt/otrs/otrs\_vemco/var/tmp/CacheFileStorable/DynamicField/f3b7e10730fb6c9cab5ae0e7f7e034f3'.
 - 2013-01-28 Added new translation for Spanish (Colombia), thanks to John Edisson Ortiz Roman!
 - 2013-01-21 Fixed bug#[9054](http://bugs.otrs.org/show_bug.cgi?id=9054) - Link Object deletes all links under certain conditions.
 - 2013-01-18 Fixed bug#[8944](http://bugs.otrs.org/show_bug.cgi?id=8944) - do not backup the cache.
 - 2013-01-16 Fixed bug#[9057](http://bugs.otrs.org/show_bug.cgi?id=9057) - Generating a PDF with bin/otrs.GenerateStats.pl produces lots
    of warnings.
 - 2013-01-15 Fixed bug#[8929](http://bugs.otrs.org/show_bug.cgi?id=8929) - Fix problems with empty ticket search results while
    Ticket::Frontend::AgentTicketSearch###ExtendedSearchCondition is inactive.
 - 2013-01-14 Fixed bug#[9042](http://bugs.otrs.org/show_bug.cgi?id=9042) - Add X-Spam-Score to Ticket.xml.
 - 2013-01-14 Fixed bug#[9047](http://bugs.otrs.org/show_bug.cgi?id=9047) - HistoryTicketGet caches info on disk directly.
 - 2013-01-11 Fixed bug#[8923](http://bugs.otrs.org/show_bug.cgi?id=8923) - Alert message shown, if parent window is reloaded while
    bulk action popup is open.
 - 2013-01-09 Fixed bug#[9030](http://bugs.otrs.org/show_bug.cgi?id=9030) - Wrong handling of Invalid YAML in Scheduler Tasks.
 - 2013-01-07 Updated CKEditor to version 3.6.6.
 - 2013-01-07 Updated Polish translation, thanks to Pawel @ ib.pl!
 - 2013-01-04 Follow-up fix for bug#[8805](http://bugs.otrs.org/show_bug.cgi?id=8805) - Cron missing as RPM dependency on Red Hat Enterprise Linux.
    Changed dependency on 'anacron' to 'vixie-cron' on RHEL5.
 - 2013-01-02 Fixed bug#[9020](http://bugs.otrs.org/show_bug.cgi?id=9020) - Generic Ticket Connector does not support attachments with
    ContentType without charset.
 - 2013-01-02 Fixed bug#[8545](http://bugs.otrs.org/show_bug.cgi?id=8545) - Attachment download not possible if pop up of another action is open.
 - 2012-12-20 Fixed bug#[9009](http://bugs.otrs.org/show_bug.cgi?id=9009) - Empty Multiselect Dynamic Fields provokes an error.
 - 2012-12-17 Fixed bug#[8589](http://bugs.otrs.org/show_bug.cgi?id=8589) - Bulk-Action not possible for single ticket.
 - 2012-12-17 Fixed bug#[7198](http://bugs.otrs.org/show_bug.cgi?id=7198) - Broken repository selection width in Package Manager.
 - 2012-12-17 Fixed bug#[8457](http://bugs.otrs.org/show_bug.cgi?id=8457) - Error if accessing AgentTicketSearch from AgentTicketPhone in IE8.
 - 2012-12-17 Fixed bug#[8695](http://bugs.otrs.org/show_bug.cgi?id=8695) - Table head of Customer Ticket History does not resize on window resize.
 - 2012-12-13 Fixed bug#[8533](http://bugs.otrs.org/show_bug.cgi?id=8533) - Apache will not start if you use mod\_perl on Fedora 16 or 17.
 - 2012-12-10 Fixed bug#[8974](http://bugs.otrs.org/show_bug.cgi?id=8974) - Event Based Notification does not populate REALNAME with
    Customer User data.

#3.1.12 2012-12-11
 - 2012-12-03 Fixed bug#[8933](http://bugs.otrs.org/show_bug.cgi?id=8933) - ArticleStorageInit permission check problem.
 - 2012-11-29 Fixed bug#[8763](http://bugs.otrs.org/show_bug.cgi?id=8763) - Please add charset conversion for customer companies.
 - 2012-11-29 Fixed bug#[1970](http://bugs.otrs.org/show_bug.cgi?id=1970) - Email attachments of type .msg (Outlook-Message) are converted.
 - 2012-11-28 Fixed bug#[8955](http://bugs.otrs.org/show_bug.cgi?id=8955) - Init script might fail on SUSE.
 - 2012-11-24 Fixed bug#[8936](http://bugs.otrs.org/show_bug.cgi?id=8936) - Ticket close date is empty when ticket is created in closed state.
 - 2012-11-19 Fixed bug#[8850](http://bugs.otrs.org/show_bug.cgi?id=8850) - CustomerTicketOverview - MouseOver Age isn't always correct.
 - 2012-11-14 Fixed bug#[8868](http://bugs.otrs.org/show_bug.cgi?id=8868) - Event Based Notification problem saving 'text' Dynamic Fields.
 - 2012-11-09 Fixed bug#[8914](http://bugs.otrs.org/show_bug.cgi?id=8914) - Syntax error in hash loop in TicketGet operation.
 - 2012-11-07 Fixed bug#[8749](http://bugs.otrs.org/show_bug.cgi?id=8749) - CustomerFrontend: missing dynamicfield in  search results.
 - 2012-11-06 Fixed bug#[8873](http://bugs.otrs.org/show_bug.cgi?id=8873) - Bad example of customization of "static" dynamic fields in
    AgentTicketOverviewSmall.
 - 2012-11-02 Fixed bug#[8791](http://bugs.otrs.org/show_bug.cgi?id=8791) - IMAPTLS fails with some Microsoft Exchange servers.
 - 2012-10-24 Fixed bug#[8841](http://bugs.otrs.org/show_bug.cgi?id=8841) - Search for Dynamic Fields shows all tickets (on "enter" key pressed).
 - 2012-10-23 Fixed bug#[8862](http://bugs.otrs.org/show_bug.cgi?id=8862) - GI debugger GUI does not show SOAP XML tags correctly.
 - 2012-10-22 Fixed bug#[8859](http://bugs.otrs.org/show_bug.cgi?id=8859) - Package upgrade does not work if an installed testpackage
    should be upgraded with a newer regular package.
 - 2012-10-20 Fixed bug#[8678](http://bugs.otrs.org/show_bug.cgi?id=8678) - 'WidgetAction Toggle' is always shown as 'Expanded' when nesting elements
 - 2012-10-20 Fixed bug#[8378](http://bugs.otrs.org/show_bug.cgi?id=8378) - Validation fails if the ID of the element contains a dot (.) or a
    colon (:)
 - 2012-10-17 Fixed bug#[8847](http://bugs.otrs.org/show_bug.cgi?id=8847) - Inline PGP message description routine does not add any info, thanks
    to IB Development Team.
 - 2012-10-17 Fixed bug#[8848](http://bugs.otrs.org/show_bug.cgi?id=8848) - AgentTicketEmail does not preserve PGP Signatures set if attachment
    is added.
 - 2012-10-16 Fixed bug#[8149](http://bugs.otrs.org/show_bug.cgi?id=8149) - Wrong handling of subject when SubjectFormat=right.
 - 2012-10-12 Updated Polish translation, thanks to Pawel!
 - 2012-10-13 Fixed bug#[8820](http://bugs.otrs.org/show_bug.cgi?id=8820) - Service rcotrs restart fails because a race condition happens.
 - 2012-10-12 Fixed bug#[8819](http://bugs.otrs.org/show_bug.cgi?id=8819) - Syntax error (stop crontab command) in SuSE rc script.
 - 2012-10-12 Removed auto cleanup of expired sessions in CreateSessionID() to improve the scalability
    of the hole system.
 - 2012-10-11 Fixed bug#[8667](http://bugs.otrs.org/show_bug.cgi?id=8667) - TicketSplit does not use QueueID of old Ticket for ACL Checking.
 - 2012-10-08 Fixed bug#[8780](http://bugs.otrs.org/show_bug.cgi?id=8780) - 508 Compliance: Text descriptions of "Responsible Tickets"
    and "Locked Tickets" links are insufficient for screen reader users.
 - 2012-10-05 Fixed bug#[8812](http://bugs.otrs.org/show_bug.cgi?id=8812) - Encrypted email doesn't see properly in Outlook.
 - 2012-10-03 Fixed bug#[8214](http://bugs.otrs.org/show_bug.cgi?id=8214) - OTRS Init script on Red Hat fails to check scheduler.
 - 2012-10-03 Fixed bug#[8805](http://bugs.otrs.org/show_bug.cgi?id=8805) - Cron missing as RPM dependency on Red Hat Enterprise Linux.
 - 2012-09-28 Fixed bug#[7274](http://bugs.otrs.org/show_bug.cgi?id=7274) - Ticket QueueView sorts by priority on first page but subsequent
    pages sort incorrectly by Age.
 - 2012-09-27 Fixed bug#[8792](http://bugs.otrs.org/show_bug.cgi?id=8792) - TriggerEscalationStopEvents logs as loglevel 'error'.
 - 2012-09-26 Fixed bug#[8743](http://bugs.otrs.org/show_bug.cgi?id=8743) - AgentTicketCompose.pm creates To, CC, BCC filelds without spaces after comma.
 - 2012-09-25 Fixed bug#[8606](http://bugs.otrs.org/show_bug.cgi?id=8606) - Escalation notifications should not be sent to agents who are set out-of-office.
 - 2012-09-25 Fixed bug#[8740](http://bugs.otrs.org/show_bug.cgi?id=8740) - backup.pl: insufficient handling of system() return values.
 - 2012-09-24 Fixed bug#[8622](http://bugs.otrs.org/show_bug.cgi?id=8622) - Storing a new GI Invoker or Operation with an existing name doesn't
    complain anything.
 - 2012-09-24 Fixed bug#[8770](http://bugs.otrs.org/show_bug.cgi?id=8770) - AJAX Removes Default Options (follow-up fix).
 - 2012-09-21 Improved caching for Services and Service Lists.

#3.1.11 2012-10-16
 - 2012-09-18 Fixed bug#[8770](http://bugs.otrs.org/show_bug.cgi?id=8770) - AJAX Removes Default Options.
 - 2012-09-17 Fixed bug#[7135](http://bugs.otrs.org/show_bug.cgi?id=7135) - Queueview, Ticketwindow closing on Refresh.
 - 2012-09-17 Fixed bug#[7294](http://bugs.otrs.org/show_bug.cgi?id=7294) - Ticket search window closes on background refresh of ticket queue.
 - 2012-09-13 Fixed bug#[8765](http://bugs.otrs.org/show_bug.cgi?id=8765) - Package Manager OS detection does not work.
 - 2012-09-13 Improved HTML security filter to better find javascript source URLs.
 - 2012-09-11 Fixed bug#[8575](http://bugs.otrs.org/show_bug.cgi?id=8575) - SSL protocol negotiation fails using SMTPTLS with recent
    IO::Socket::SSL versions by upgrading TLS module to 0.20.
 - 2012-09-10 Fixed bug#[4475](http://bugs.otrs.org/show_bug.cgi?id=4475) - Extra double quote added to HTML links when using http-link field.
 - 2012-09-07 Improved caching of search results when the result set is empty.

#3.1.10 2012-08-30
 - 2012-08-28 Improved HTML security filter to detect tag nesting.
 - 2012-08-24 Fixed bug#[8611](http://bugs.otrs.org/show_bug.cgi?id=8611) - Ticket count is wrong in QueueView.
 - 2012-08-21 Fixed bug#[8698](http://bugs.otrs.org/show_bug.cgi?id=8698) - Layout.pm only looks at first entry from
    HTTP\_ACCEPT\_LANGUAGE to determine language.
 - 2012-08-21 Fixed bug#[8731](http://bugs.otrs.org/show_bug.cgi?id=8731) - LDAP group check returns wrong error.

#3.1.9 2012-08-21
 - 2012-08-20 Fixed bug#[3463](http://bugs.otrs.org/show_bug.cgi?id=3463) - \<OTRS\_TICKET\_EscalationDestinationIn\> incorrect.
 - 2012-08-20 Fixed bug#[5954](http://bugs.otrs.org/show_bug.cgi?id=5954) - Ticket::Frontend::OverviewSmall###ColumnHeader has
    no effect on customer frontend.
 - 2012-08-19 Fixed bug#[8584](http://bugs.otrs.org/show_bug.cgi?id=8584) Email address not added to recipients after collision/duplicate occurred.
 - 2012-08-17 HTML mails will now be displayed in an HTML5 sandbox iframe.
    This means that modern browsers will not execute plugins or JavaScript on the content
    any more. Currently, this is supported by Chrome and Safari, but IE10 and FF16 are also
 - 2012-08-17 HTML mails will now be displayed in the restricted zone in IE.
    This means that more restrictive security settings will apply, such as blocking of
    JavaScript content by default.
 - 2012-08-14 Fixed bug#[8360](http://bugs.otrs.org/show_bug.cgi?id=8360) Cannot search for tickets by dynamic fields via SOAP.
 - 2012-08-14 Fixed bug#[8697](http://bugs.otrs.org/show_bug.cgi?id=8697) Time related restrictions in TicketSearch operator (GenericInterface) not working.
 - 2012-08-14 Fixed bug#[8685](http://bugs.otrs.org/show_bug.cgi?id=8685) - Cannot use address book / customer / spell check in phone /
    email if cookies are disabled. (partly fixed)
 - 2012-08-06 Fixed bug#[8682](http://bugs.otrs.org/show_bug.cgi?id=8682) - linking search conditions with && in
    Customersearch is not working since Update from 3.1.1 to 3.1.7.
 - 2012-08-06 Fixed bug#[8683](http://bugs.otrs.org/show_bug.cgi?id=8683) - Cannot create dynamic field if cookies are disabled.
 - 2012-08-06 Fixed bug#[8672](http://bugs.otrs.org/show_bug.cgi?id=8672) - Search Profile can't have an ampersand in the name via
    Toolbar module.
 - 2012-08-06 Fixed bug#[8619](http://bugs.otrs.org/show_bug.cgi?id=8619) - The UPGRADING file has incorrect patchlevel upgrade description.
 - 2012-08-03 Fixed bug#[6882](http://bugs.otrs.org/show_bug.cgi?id=6882) - Dummy field set first child to the very right in edit screen.
 - 2012-08-03 Fixed bug#[8680](http://bugs.otrs.org/show_bug.cgi?id=8680) - Bulk action fails if cookies are disabled.

#3.1.8 2012-08-07
 - 2012-08-02 Updated Greek translation file, thanks to Maistros Stelios!
 - 2012-07-31 Improved robustness of HTML security filter: Detect masked UTF-7 \< and \> signs.
 - 2012-07-31 Added config option for ticket permission in the escalation view.
 - 2012-07-31 Fixed bug#[8675](http://bugs.otrs.org/show_bug.cgi?id=8675) - Kernel::GenericInterface::Mapping doesn't provide a ConfigObject.
 - 2012-07-20 Fixed bug#[8660](http://bugs.otrs.org/show_bug.cgi?id=8660) - Duplicate DF X-Headers in PostMaster module.
 - 2012-07-17 Fixed bug#[8647](http://bugs.otrs.org/show_bug.cgi?id=8647) - otrs.GenerateStats.pl "-S" option does not function.
 - 2012-07-16 Fixed bug#[8616](http://bugs.otrs.org/show_bug.cgi?id=8616) - Spell Checker does not work using IE9.
 - 2012-07-11 Fixed bug#[8568](http://bugs.otrs.org/show_bug.cgi?id=8568) - IMAPTLS - More than one email at one cron run will not work.
 - 2012-07-05 Added bug#[8627](http://bugs.otrs.org/show_bug.cgi?id=8627) - bin/otrs.AddQueue2StdResponse.pl Script to add standard responses
    to queues, thanks to Oliver Skibbe @ CIPHRON GmbH.
 - 2012-07-04 Fixed bug#[8607](http://bugs.otrs.org/show_bug.cgi?id=8607) - otrs service fails in 3.1.7 on SUSE linux.
 - 2012-07-02 Increased cache TTL of some core modules to improve performance.
 - 2012-07-01 Fixed bug#[8620](http://bugs.otrs.org/show_bug.cgi?id=8620) - Using a default queue in the customer interface causes database
    error on PostgresSQL if ACLs are used.
 - 2012-06-29 Fixed bug#[8618](http://bugs.otrs.org/show_bug.cgi?id=8618) - Inform and Involved Agents select boxes can not be resizable.
 - 2012-06-27 Fixed bug#[8558](http://bugs.otrs.org/show_bug.cgi?id=8558) - GenericInterface: response isn't valid UTF-8 content.
 - 2012-06-27 Added bug#[7039](http://bugs.otrs.org/show_bug.cgi?id=7039) - bin/otrs.AddService.pl script to add services from the command
    line.
 - 2012-06-26 Made display of pending time consistent with escalation time display.
 - 2012-06-22 Fixed bug#[8230](http://bugs.otrs.org/show_bug.cgi?id=8230) - Invalid Challenge Token when creating ticket out of hyperlinks.

#3.1.7 2012-06-26
 - 2012-06-18 Fixed bug#[8593](http://bugs.otrs.org/show_bug.cgi?id=8593) - Wrong description for 'Agent Notifications' on Admin interface.
 - 2012-06-18 Fixed bug#[8587](http://bugs.otrs.org/show_bug.cgi?id=8587) - Typo in French translation.
 - 2012-06-15 Fixed bug#[7879](http://bugs.otrs.org/show_bug.cgi?id=7879) - Broken Content-Type in forwarded attachments.
 - 2012-06-15 Fixed bug#[8583](http://bugs.otrs.org/show_bug.cgi?id=8583) - Unneeded complexity and performance degradation creating Service
    Lists (Replacement for bug fix 7947).
 - 2012-06-15 Fixed bug#[8580](http://bugs.otrs.org/show_bug.cgi?id=8580) - SQL warnings for CustomerCompanyGet on some database backends.
 - 2012-06-14 Fixed bug#[8251](http://bugs.otrs.org/show_bug.cgi?id=8251) - Defect handling of invalid Queues in AJAX refresh.
 - 2012-06-14 Fixed bug#[8574](http://bugs.otrs.org/show_bug.cgi?id=8574) - Perl special variable $/ is changed and never restored.
 - 2012-06-14 Fixed bug#[8337](http://bugs.otrs.org/show_bug.cgi?id=8337) - Parentheses in user last\_name / first\_name are not sanitized (follow-up fix).
 - 2012-06-12 Fixed bug#[8575](http://bugs.otrs.org/show_bug.cgi?id=8575) - Assignment of users does not work for responsible or owner permission
    in AgentTicketPhone.
 - 2012-06-12 Updated Hungarian translation, thanks to Németh Csaba!
 - 2012-06-12 Updated Danish translation, thanks to Lars Jørgensen!
 - 2012-06-12 Fixed bug#[7872](http://bugs.otrs.org/show_bug.cgi?id=7872) - "Created" date in Large view is actually Last Updated date.
 - 2012-06-12 Fixed bug#[8457](http://bugs.otrs.org/show_bug.cgi?id=8457) -  Paste on a newly created ckeditor instance does not work on webkit based browsers.
 - 2012-06-11 Fixed bug#[8565](http://bugs.otrs.org/show_bug.cgi?id=8565) - Exportfile action from otrs.PackageManaget.pl is broken.
 - 2012-06-11 Fixed bug#[8458](http://bugs.otrs.org/show_bug.cgi?id=8458) - $OTRS\_SCHEDULER -a start missing from /etc/init.d/otrs after update.
 - 2012-06-11 Fixed bug#[8139](http://bugs.otrs.org/show_bug.cgi?id=8139) - SUSE RPM has no dependency on Date::Format perl
    module.
 - 2012-06-11 Fixed bug#[8544](http://bugs.otrs.org/show_bug.cgi?id=8544) - Hovering ticket title is still shortened.
 - 2012-06-07 Fixed bug#[8553](http://bugs.otrs.org/show_bug.cgi?id=8553) - Agent notifications can't be loaded from the database in some
    scenarios.
 - 2012-06-05 Fixed bug#[8383](http://bugs.otrs.org/show_bug.cgi?id=8383) - Email address in 'To' field is lost after second reload if address is not in customer database.
 - 2012-06-06 Fixed bug#[8549](http://bugs.otrs.org/show_bug.cgi?id=8549) - "Need User" warning in error log when creating a ticket for a
    customer not in DB.
 - 2012-06-05 Fixed bug#[8546](http://bugs.otrs.org/show_bug.cgi?id=8546) - LinkObject Type is not translated in ticket zoom.
 - 2012-06-04 Fixed bug#[7533](http://bugs.otrs.org/show_bug.cgi?id=7533) - SQL error if body contains only a picture.
 - 2012-06-04 Fixed bug#[2626](http://bugs.otrs.org/show_bug.cgi?id=2626) - Default Service does not work for "unknown" customers.
    You can use the new setting "Ticket::Service::Default::UnknownCustomer" to specify if unknown customers
    should also receive the default services.
 - 2012-06-04 Improved performance of TemplateGenerator.pm, thanks to Stelios Gikas!
 - 2012-05-31 Fixed bug#[8481](http://bugs.otrs.org/show_bug.cgi?id=8481) - Dynamic Fields lost after ticket move to another queue (using quick
    move Dropdown).
 - 2012-05-31 Fixed bug#[8533](http://bugs.otrs.org/show_bug.cgi?id=8533) - Apache will not start using mod\_perl on Fedora 16.

#3.1.6 2012-06-05
 - 2012-05-30 Fixed bug#[8495](http://bugs.otrs.org/show_bug.cgi?id=8495) - Generic Agent TicketAction single value attributes should not let
    multiple selection.
 - 2012-05-30 Fixed bug#[8378](http://bugs.otrs.org/show_bug.cgi?id=8378) - Validation fails if the ID of the element contains a dot (.) or a colon (:).
 - 2012-05-30 Fixed bug#[7532](http://bugs.otrs.org/show_bug.cgi?id=7532) - 'Field is required' message should be removed in RTE if content is added.
 - 2012-05-30 Fixed bug#[8514](http://bugs.otrs.org/show_bug.cgi?id=8514) - Long words in description break rendering of SysConfig items.
 - 2012-05-30 Fixed bug#[8537](http://bugs.otrs.org/show_bug.cgi?id=8537) - DynamicField caching issue.
 - 2012-05-29 Fixed bug#[8482](http://bugs.otrs.org/show_bug.cgi?id=8482) - Responsible of a ticket without responsible permission.
 - 2012-05-29 Fixed bug#[8485](http://bugs.otrs.org/show_bug.cgi?id=8485) - CustomerUser validation fails in GI Ticket Operations if there is no
    ValidID in the mapping.
 - 2012-05-29 Fixed bug#[8529](http://bugs.otrs.org/show_bug.cgi?id=8529) - Fixed print to STDERR in ReferenceData.pm.
 - 2012-05-28 Fixed bug#[8427](http://bugs.otrs.org/show_bug.cgi?id=8427) - Dynamic Field Type Multiselect not shown in Notification (event).
 - 2012-05-27 Updated Norwegian translation, thanks to Lars Magnus Herland!
 - 2012-05-25 Fixed bug#[8189](http://bugs.otrs.org/show_bug.cgi?id=8189) - AgentTicketCompose: Pressing "Enter" will delete Attachment.
 - 2012-05-25 Fixed bug#[7844](http://bugs.otrs.org/show_bug.cgi?id=7844) - Escalation Event does not respect service calendar of ticket/queue.
 - 2012-05-25 Fixed bug#[8228](http://bugs.otrs.org/show_bug.cgi?id=8228) - Ticket::Frontend::AgentTicketNote###StateDefault doesn't work.
 - 2012-05-25 Added template list to all output filter config to improve performance.
 - 2012-05-25 Fixed bug#[8519](http://bugs.otrs.org/show_bug.cgi?id=8519) - Kernel::System::TicketSearch-\>TicketSearch() doesn't properly handle
     array references in SortBy parameter
 - 2012-05-24 Fixed bug#[7512](http://bugs.otrs.org/show_bug.cgi?id=7512) - AJAX-reload of SMIME-fields did not work properly.
 - 2012-05-24 Fixed bug#[8518](http://bugs.otrs.org/show_bug.cgi?id=8518) - Crypt on multiple recipients error replaces Crypt selection.
 - 2012-05-22 Fixed bug#[8164](http://bugs.otrs.org/show_bug.cgi?id=8164) - Internal articles are visible within customer ticket overview.
 - 2012-05-22 Fixed bug#[8506](http://bugs.otrs.org/show_bug.cgi?id=8506) - Customer email link won't open in popup as expected.
 - 2012-05-20 Fixed bug#[7844](http://bugs.otrs.org/show_bug.cgi?id=7844) - Escalation Event does not respect service calendar of ticket/queue.
 - 2012-05-18 Added otrs.RefreshSMIMEKeys.pl to refresh SMIME certificate filenames according to the
    system's current OpenSSL version.
 - 2012-05-17 Fixed bug#[8498](http://bugs.otrs.org/show_bug.cgi?id=8498) - OpenSSL 1.0.0 does not get the stored SMIME certificates when
    -CApath is used in the command.
 - 2012-05-16 Fixed bug#[8337](http://bugs.otrs.org/show_bug.cgi?id=8337) - Parentheses in user last\_name / first\_name are not sanitized.
 - 2012-05-15 Updated French translation, thanks to Romain Monnier!
 - 2012-05-11 Fixed bug#[8467](http://bugs.otrs.org/show_bug.cgi?id=8467) - Reply to an e-mail address with ' not possible.
 - 2012-05-11 Fixed bug#[8352](http://bugs.otrs.org/show_bug.cgi?id=8352) - Wrong substitution regex in HTMLUtils.pm-\>ToAscii.
 - 2012-05-11 Fixed bug#[8401](http://bugs.otrs.org/show_bug.cgi?id=8401) - DynamicField Update doesn't update the X-OTRS-DynamicField-XXX
    Fields in Postmaster Filters.
 - 2012-05-11 Fixed bug#[5746](http://bugs.otrs.org/show_bug.cgi?id=5746) - Using PerlEx you have to restart IIS each time a setting is
    changed in SysConfig.
 - 2012-05-10 Fixed bug#[8452](http://bugs.otrs.org/show_bug.cgi?id=8452) - Dynamic Field Date/Time not working when server runs on UTC.

#3.1.5 2012-05-15
 - 2012-05-09 Fixed bug#[8466](http://bugs.otrs.org/show_bug.cgi?id=8466) - On Win32 GenericInterface does not return results properly.
 - 2012-05-08 Fixed bug#[8465](http://bugs.otrs.org/show_bug.cgi?id=8465) - Can't create cache for web service debug log on win32 platforms.
 - 2012-05-08 Fixed bug#[7919](http://bugs.otrs.org/show_bug.cgi?id=7919) - Translation of ticket states in CSV Export of CustomerTicketSearch.
 - 2012-05-08 Fixed bug#[8461](http://bugs.otrs.org/show_bug.cgi?id=8461) - CustomerTicketSearch doesn't use ticket ACL rules.
 - 2012-05-04 Fixed bug#[7877](http://bugs.otrs.org/show_bug.cgi?id=7877) - SMIME emails don't get parsed properly (follow-up fix).
 - 2012-05-04 Fixed bug#[2452](http://bugs.otrs.org/show_bug.cgi?id=2452) - SMIME encoded E-Mails are not decrypted properly by OTRS (follow-up fix).
 - 2012-05-03 Fixed bug#[8446](http://bugs.otrs.org/show_bug.cgi?id=8446) - Dynamic Field type TextArea missing \> 3800 characters validation.
 - 2012-05-02 Fixed bug#[8447](http://bugs.otrs.org/show_bug.cgi?id=8447) - Checkbox Dynamic Field is wrong calculated in statistics.
 - 2012-05-02 Fixed bug#[8328](http://bugs.otrs.org/show_bug.cgi?id=8328) - Statistic containing restriction on dynamic field ignores the
    restriction.
 - 2012-05-01 Fixed bug#[8439](http://bugs.otrs.org/show_bug.cgi?id=8439) - AgentTicketForward: ticket not unlocked after
    selecting a close state.
 - 2012-04-27 Fixed bug#[7168](http://bugs.otrs.org/show_bug.cgi?id=7168) - Ticket Overview Control Row can only be one line high.
 - 2012-04-26 Fixed bug#[8437](http://bugs.otrs.org/show_bug.cgi?id=8437) - Dynamic Field order duplicated when change the order of a field.
 - 2012-04-26 Fixed bug#[8409](http://bugs.otrs.org/show_bug.cgi?id=8409) - Deselecting 'select all' in queue view does not work.
 - 2012-04-26 Updated Hungarian translation, thanks to Csaba Nemeth!
 - 2012-04-26 Fixed bug#[8424](http://bugs.otrs.org/show_bug.cgi?id=8424) - Ticket articles of large tickets cannot be opened.
 - 2012-04-25 Added possibility to specify a cache type for selective cache cleaning
    in bin/otrs.DeleteCache.
 - 2012-04-24 Added possibility to define ACL rules by user role.
 - 2012-04-24 Fixed bug#[8415](http://bugs.otrs.org/show_bug.cgi?id=8415) - Setting Ticket::Responsible ignored by AgentTicketActionCommon.
 - 2012-04-24 Fixed bug#[8288](http://bugs.otrs.org/show_bug.cgi?id=8288) - Autocomplete search results show up in Times font when using Internet Explorer.
 - 2012-04-24 Fixed bug#[8414](http://bugs.otrs.org/show_bug.cgi?id=8414) - ACL for AgentTicketCustomer in AgentTicketZoom doesn't affect
    CustomerID link in ticket information.
 - 2012-04-24 Updated CKEditor to version 3.6.3.
 - 2012-04-23 Fixed bug#[8369](http://bugs.otrs.org/show_bug.cgi?id=8369) - Wrong handling of Ticket ACL in AJAX Updates.

#3.1.4 2012-04-24
 - 2012-04-15 Fixed bug#[8284](http://bugs.otrs.org/show_bug.cgi?id=8284) - The text "Cc: (xx@mail.com) added database email!" is confusing.
 - 2012-04-16 Fixed bug#[8392](http://bugs.otrs.org/show_bug.cgi?id=8392) - DynamicFieldAdd returns wrong value.
 - 2012-04-16 Fixed bug#[8387](http://bugs.otrs.org/show_bug.cgi?id=8387) - UseSyncBackend configuration does not conform to OTRS style.
 - 2012-04-16 Fixed bug#[8367](http://bugs.otrs.org/show_bug.cgi?id=8367) - Customer entry not marked as mandatory.
 - 2012-04-13 Fixed uninitialized value problem in Kernel/Output/HTML/Layout.pm.
 - 2012-04-06 Fixed bug#[8348](http://bugs.otrs.org/show_bug.cgi?id=8348) - Wrong pop-up close behavior when no URL is given
    and SessionUseCookie is set to No.
 - 2012-04-06 Fixed bug#[8346](http://bugs.otrs.org/show_bug.cgi?id=8346) - Incoming phone calls trigger NewTicket
    notification, even for existing tickets.
 - 2012-04-06 Fixed bug#[8353](http://bugs.otrs.org/show_bug.cgi?id=8353) - Small typo in print CSS.
 - 2012-04-06 Fixed bug#[8370](http://bugs.otrs.org/show_bug.cgi?id=8370) - AgentTicketForward does not set pending date for pending states.
 - 2012-04-05 Fixed bug#[8368](http://bugs.otrs.org/show_bug.cgi?id=8368) - Personal queues update is not reflected in UI.
 - 2012-04-03 Fixed bug#[8363](http://bugs.otrs.org/show_bug.cgi?id=8363) - SOAP Transport can't send a value '0'.
 - 2012-04-02 Added new Slovenian translation, thanks to Gorazd Zagar and Andrej Cimerlajt!
 - 2012-04-02 Updated Italian translation, thanks to Massimo Bianchi!
 - 2012-03-30 Fixed bug#[8356](http://bugs.otrs.org/show_bug.cgi?id=8356) - ACLs for DynamicFields does not work on AgentTicketSearch.
 - 2012-03-30 Added new config feature to limit the number of 'From' entries in
    AgentTicketPhone to 1 (optional). Use the setting
    'Ticket::Frontend::AgentTicketPhone::AllowMultipleFrom' if you want this.
 - 2012-03-29 Fixed uninitialized value error in Kernel/System/Log.pm.
 - 2012-03-29 Added caching for DynamicFieldValue entries to improve system performance.
 - 2012-03-29 Fixed bug#[8336](http://bugs.otrs.org/show_bug.cgi?id=8336) - otrs.ExportStatsToOPM.pl  broken.
 - 2012-03-29 Fixed bug#[8349](http://bugs.otrs.org/show_bug.cgi?id=8349) - Caching breaks Admin frontend.
 - 2012-03-26 Improved performance on MySQL databases by removing useless LOWER statements.
 - 2012-03-26 Fixed bug#[7877](http://bugs.otrs.org/show_bug.cgi?id=7877) - SMIME emails don't get parsed properly.
 - 2012-03-23 Disabled error message in RemoveSessionID().
 - 2012-03-23 Repaired broken cache handling in DynamicFieldList().

#3.1.3 2012-03-29
 - 2012-03-27 Fixed bug#[8343](http://bugs.otrs.org/show_bug.cgi?id=8343) - Configuration of additional modules can be lost during upgrade.
 - 2012-03-22 Renamed form id in AgentLinkObject.dtl to make sure it doesn't interfere with wrong CSS
 - 2012-03-22 Updated Portugese translation, thanks to Rui Francisco!
 - 2012-03-21 Fixed bug#[8333](http://bugs.otrs.org/show_bug.cgi?id=8333) - Type option '-' should not be available in
    ActionTicketCommon screens.
 - 2012-03-20 Fixed bug#[8331](http://bugs.otrs.org/show_bug.cgi?id=8331) - Unable to delete ticket with \> 1000 articles
    on Oracle database.
 - 2012-03-20 Fixed bug#[8335](http://bugs.otrs.org/show_bug.cgi?id=8335) - Cache keys are not always properly constructed.
 - 2012-03-20 Dynamic fields and associated values can now be deleted in the admin area.
 - 2012-03-20 Do not show the empty item in dynamic field search fields.
 - 2012-03-19 Fixed an issue where DBUpdate-to-3.1.pl would die because
    of certain free text or free time configuration settings.
 - 2012-03-19 Fixed bug#[8334](http://bugs.otrs.org/show_bug.cgi?id=8334) migration fails if FreeTime fields are not in use.
 - 2012-03-18 Added internal cache to Kernel/System/Lock.pm to improve performance.
 - 2012-03-18 Added internal cache to Kernel/System/Salutation.pm to improve performance.
 - 2012-03-18 Added internal cache to Kernel/System/Type.pm to improve performance.
 - 2012-03-18 Added internal cache to Kernel/System/Valid.pm to improve performance.
 - 2012-03-18 Added internal cache to Kernel/System/Queue.pm to improve performance.
 - 2012-03-18 Added internal cache to Kernel/System/State.pm to improve performance.
 - 2012-03-18 Added internal cache to Kernel/System/Priority.pm to improve performance.
 - 2012-03-18 Improved performance of Kernel/Modules/AdminPackageManager.
 - 2012-03-18 Improved performance of Kernel/System/Package.pm.
 - 2012-03-17 Improved performance by using SlaveDB in Dashboard if it is configured.
 - 2012-03-17 Improved performance by using Digest::SHA if it is available.
 - 2012-03-16 Added cache to Kernel/System/XML.pm to improve performance.
 - 2012-03-16 Added cache to Kernel/System/Package.pm to improve performance.
 - 2012-03-15 Fixed bug#[8320](http://bugs.otrs.org/show_bug.cgi?id=8320) - IMAP FLAGS (\Seen \Recent) are appended to article body
    by upgrading bundled Net::IMAP::Simple to version 1.2030.
 - 2012-03-14 Added internal cache to user preferences backend to improve performance.
 - 2012-03-14 Added internal cache to customer user preferences backend to improve performance.
 - 2012-03-14 Added internal cache to queue preferences backend to improve performance.
 - 2012-03-14 Added internal cache to service preferences backend to improve performance.
 - 2012-03-14 Added internal cache to sla preferences backend to improve performance.
 - 2012-03-09 Fixed bug#[8286](http://bugs.otrs.org/show_bug.cgi?id=8286) - Adressbook forgets selected entries.
 - 2012-03-07 Fixed bug#[8297](http://bugs.otrs.org/show_bug.cgi?id=8297) - Selectbox for new owner causes ajax update
    on every change made via keyboard.
 - 2012-03-07 Updated Catalan translation, thanks to Antionio Linde!
 - 2012-03-05 Fixed bug#[7545](http://bugs.otrs.org/show_bug.cgi?id=7545) - AgentTicketBounce lacks permission checks.

#3.1.2 2012-03-06
 - 2012-03-01 Fixed bug#[8282](http://bugs.otrs.org/show_bug.cgi?id=8282) - Dropdown and Multiselect Dynamic Fields without Possible values
    causes errors with LayoutObject BuildSelection function.
 - 2012-03-01 Fixed bug#[8277](http://bugs.otrs.org/show_bug.cgi?id=8277) - DynamicField Values not deleted when ticket is deleted.
 - 2012-02-28 Fixed bug#[8274](http://bugs.otrs.org/show_bug.cgi?id=8274) - Dynamic Fields ACLs does not work correctly at Ticket Split.
 - 2012-02-28 Improved #7526 - Fixed handling of special characters (, ), &, - within statistics.
 - 2012-02-27 Fixed bug#[8255](http://bugs.otrs.org/show_bug.cgi?id=8255) - TicketSearch in DynamicFields doesn't support ExtendedSearchCondition.
 - 2012-02-25 Fixed bug#[8258](http://bugs.otrs.org/show_bug.cgi?id=8258) - DynamicField date value is reset to NULL.
 - 2012-02-23 Fixed bug#[8214](http://bugs.otrs.org/show_bug.cgi?id=8214) - OTRS Init script on Red Hat / SUSE fails to check scheduler.
 - 2012-02-23 Fixed bug#[8227](http://bugs.otrs.org/show_bug.cgi?id=8227) - LDAP user syncronisation doesn't work.
 - 2012-02-23 Fixed bug#[8235](http://bugs.otrs.org/show_bug.cgi?id=8235) - Searching on DynamicFields, results are lost on next page.
 - 2012-02-21 Fixed bug#[8252](http://bugs.otrs.org/show_bug.cgi?id=8252) - Small typo in German translation of AgentTicketZoom.
 - 2012-02-16 Fixed bug#[8226](http://bugs.otrs.org/show_bug.cgi?id=8226) - Problem with Customized DynamicFields in TicketOverviewSmall.
 - 2012-02-16 Fixed bug#[8233](http://bugs.otrs.org/show_bug.cgi?id=8233) - DB error migrating stats on Oracle.
 - 2012-02-14 Fixed bug#[8224](http://bugs.otrs.org/show_bug.cgi?id=8224) - Admin Responses screen does not allow to filter responses.
 - 2012-02-14 Fixed bug#[7652](http://bugs.otrs.org/show_bug.cgi?id=7652) - OpenSearch providers are served with wrong mime type.
    Follow-up fix.
 - 2012-02-14 Fixed bug#[8140](http://bugs.otrs.org/show_bug.cgi?id=8140) - Shortcut for creating new e-mail ticket doesn't work.
    The hotkey for "new email ticket" was changed from e to m to avoid a collision.
 - 2012-02-14 Fixed bug#[8144](http://bugs.otrs.org/show_bug.cgi?id=8144) - Typo and improved logging in GenericAgent.pm.
 - 2012-02-14 Fixed bug#[8183](http://bugs.otrs.org/show_bug.cgi?id=8183) - Canceling AgentTicketCompose on an unlocked ticket generates
    ChallengeToken error.
 - 2012-02-13 Fixed bug#[8219](http://bugs.otrs.org/show_bug.cgi?id=8219) - TicketCreate and TicketUpdate GI ticket operations requires a valid
    CustomerUser.
 - 2012-02-13 Fixed bug#[8201](http://bugs.otrs.org/show_bug.cgi?id=8201) - Popup in browser always open on leftmost display when using
    dual monitor setup.
 - 2012-02-13 Fixed bug#[8202](http://bugs.otrs.org/show_bug.cgi?id=8202) - Kernel::System::JSON-\>Decode() dies when providing malformed JSON.
 - 2012-02-13 Fixed bug#[8211](http://bugs.otrs.org/show_bug.cgi?id=8211) - Typos in Labels: DYNAMICFILED.
 - 2012-02-09 Fixed bug#[7109](http://bugs.otrs.org/show_bug.cgi?id=7109) - Statistics error when PDF support is not active.

#3.1.1 2012-02-14
 - 2012-02-09 Fixed bug#[8184](http://bugs.otrs.org/show_bug.cgi?id=8184) - Uninstall and upgrade fails if file in package can't be removed.
 - 2012-02-09 Fixed bug#[8199](http://bugs.otrs.org/show_bug.cgi?id=8199) - Linked tickets open only in tabs.
 - 2012-02-03 Fixed bug#[8148](http://bugs.otrs.org/show_bug.cgi?id=8148) - Wrong presentation of queue structure in CustomerTicketMessage.
 - 2012-02-03 Fixed bug#[8137](http://bugs.otrs.org/show_bug.cgi?id=8137) - Issues with Owner list refresh when selecting a new Owner.
 - 2012-02-03 Fixed bug#[8180](http://bugs.otrs.org/show_bug.cgi?id=8180) - bin/otrs.LoaderCache.pl exit code is wrong.

#3.1.0.rc1 2012-02-07
 - 2012-02-03 Fixed bug#[8171](http://bugs.otrs.org/show_bug.cgi?id=8171) - Table rows have different heights.
 - 2012-02-02 Fixed bug#[7937](http://bugs.otrs.org/show_bug.cgi?id=7937) - HTMLUtils.pm ignore to much of e-mail source code.
 - 2012-02-02 Fixed bug#[7972](http://bugs.otrs.org/show_bug.cgi?id=7972) - Some mails may not present HTML part when using rich viewing.
 - 2012-02-02 Fixed bug#[8179](http://bugs.otrs.org/show_bug.cgi?id=8179) - DynamicField backend DateTime renders timestamps with seconds.
 - 2012-01-31 Fixed bug#[8163](http://bugs.otrs.org/show_bug.cgi?id=8163) - Ticket / Article title can't be copied if value is too long.
 - 2012-01-31 Fixed bug#[8161](http://bugs.otrs.org/show_bug.cgi?id=8161) - History hover broken - missing title attribute.
 - 2012-01-30 Fixed bug#[8147](http://bugs.otrs.org/show_bug.cgi?id=8147) - Possible values for queues not being considered in ACLs.
 - 2012-01-30 Fixed bug#[8021](http://bugs.otrs.org/show_bug.cgi?id=8021) - Creating new Dynamic Field is not adding the field name
    to the X-OTRS header lists configuration for the PostMaster filters.
 - 2012-01-27 Fixed bug#[8145](http://bugs.otrs.org/show_bug.cgi?id=8145) - TicketFreeTime entries in search profiles don't get updated.
 - 2012-01-27 Fixed bug#[2820](http://bugs.otrs.org/show_bug.cgi?id=2820) - Wide character in Syslog message causes Perl crash on utf8 systems.

#3.1.0.beta5 2012-01-31
 - 2012-01-25 Fixed bug#[7890](http://bugs.otrs.org/show_bug.cgi?id=7890) - Changed wording of config setting for RFC 5321 compliance.
 - 2012-01-24 Fixed bug#[8068](http://bugs.otrs.org/show_bug.cgi?id=8068) - Corrected field & DynamicField preselection on TicketSplit.
 - 2012-01-24 Fixed bug#[8115](http://bugs.otrs.org/show_bug.cgi?id=8115) - Richtext editor not show in customer interface after switching
    to Catalan frontend language.
 - 2012-01-23 Fixed bug#[7994](http://bugs.otrs.org/show_bug.cgi?id=7994) - ACL: action-restrictions not possible for all ticket actions.
 - 2012-01-23 Fixed bug#[7984](http://bugs.otrs.org/show_bug.cgi?id=7984) - Unable to select the output format of statistics.
 - 2012-01-23 Fixed bug#[8136](http://bugs.otrs.org/show_bug.cgi?id=8136) - Browser Time Detection and time zone UTC generates warning in
    web server error log.
 - 2012-01-23 Fixed bug#[8132](http://bugs.otrs.org/show_bug.cgi?id=8132) - Browser version message misleading when 'compatibility mode'
    is enabled in Internet Explorer.
 - 2012-01-23 Fixed bug#[7916](http://bugs.otrs.org/show_bug.cgi?id=7916) - Address Book doesn't work correctly.
 - 2012-01-23 Fixed bug#[8019](http://bugs.otrs.org/show_bug.cgi?id=8019) - Ticket customer info widget has unneeded scroll bars.
 - 2012-01-23 Fixed bug#[8066](http://bugs.otrs.org/show_bug.cgi?id=8066) - TicketAcl with empy possible List for DynamicFields crashes.
 - 2012-01-20 Fixed bug#[7495](http://bugs.otrs.org/show_bug.cgi?id=7495) - Cursor stands still in editor in IE 9.
 - 2012-01-20 Fixed bug#[8129](http://bugs.otrs.org/show_bug.cgi?id=8129) - Ticket Unwatch may lead to errorscreen.
 - 2012-01-20 Updated Finnish translation file, thanks to Mikko Hynninen!
 - 2012-01-17 Fixed bug#[8117](http://bugs.otrs.org/show_bug.cgi?id=8117) - Can't create ticket for newly created customer user.
 - 2012-01-16 Fixed bug#[8094](http://bugs.otrs.org/show_bug.cgi?id=8094) - Typo In Ticket.pm.
 - 2012-01-16 Creation of QueueObject was not possible because of missing EncodeObject in CustomerUserGenericTicket.pm.

#3.1.0.beta4 2012-01-17
 - 2012-01-12 Fixed bug#[8107](http://bugs.otrs.org/show_bug.cgi?id=8107) - Ticket state is not set as default on ticket edit screens.
 - 2012-01-12 Fixed bug#[8105](http://bugs.otrs.org/show_bug.cgi?id=8105) - Changing Priority does not update all relevant SysConfig fields.
 - 2012-01-11 Dramatically improved HTML rendering performance for pages with a large
    amount of data, thanks to Stefan Bedorf!
 - 2012-01-11 Fixed bug#[8103](http://bugs.otrs.org/show_bug.cgi?id=8103) - Edit screens does not get Dynamic Field values from selected ticket.
 - 2012-01-11 Fixed bug#[8070](http://bugs.otrs.org/show_bug.cgi?id=8070) - Configured year ranges do not apply for date DynamicFields.
 - 2012-01-11 Updated CPAN module YAML to version 0.78.
 - 2012-01-11 Updated CPAN module Net::IMAP::Simple to version 1.20271.
 - 2012-01-11 Updated CPAN module LWP::UserAgent to version 6.03.
 - 2012-01-11 Updated CPAN module Digest::SHA::PurePerl to version 5.70.
 - 2012-01-11 Updated CPAN module CGI to version 3.59.
 - 2012-01-10 Fixed bug#[8095](http://bugs.otrs.org/show_bug.cgi?id=8095) - Dashboard ticket list does not support DynamicFields.
 - 2012-01-10 Ticket search and ticket link should require at least one search parameter.
 - 2012-01-09 Improved consistency of ChallengeToken checks in the agent and admin interface.
 - 2012-01-03 Updated Serbian translation, thanks to Milorad Jovanovic!
 - 2011-12-23 Fixed bug#[8052](http://bugs.otrs.org/show_bug.cgi?id=8052) - ACLs code is called even when there is no defined ACL or ACL module.
 - 2011-12-23 Fixed bug#[8037](http://bugs.otrs.org/show_bug.cgi?id=8037) - Registration screen in web installer produces HTTP 500 error.
 - 2011-12-22 Fixed bug#[7947](http://bugs.otrs.org/show_bug.cgi?id=7947) - Service list can be made useless with simple ACL and/or disabling
    services.
 - 2011-12-22 Fixed bug#[8049](http://bugs.otrs.org/show_bug.cgi?id=8049) - TicketFreeText X-headers should not exist on new installations.
 - 2011-12-22 Fixed bug#[8043](http://bugs.otrs.org/show_bug.cgi?id=8043) - TicketSplit does not use default ACLs from parent.
 - 2011-12-21 Fixed bug#[8044](http://bugs.otrs.org/show_bug.cgi?id=8044) - TicketACL does not get dynamic fields as ticket attributes always.
 - 2011-12-21 Fixed bug#[8039](http://bugs.otrs.org/show_bug.cgi?id=8039) - SysConfig writes files in a non-atomic way.
 - 2011-12-20 Fixed bug#[4239](http://bugs.otrs.org/show_bug.cgi?id=4239) - Include ticket number in toolbar fulltext search.
 - 2011-12-20 Fixed bug#[7955](http://bugs.otrs.org/show_bug.cgi?id=7955) - Customer identity is not displayed on Customer Interface.
 - 2011-12-20 Fixed bug#[8035](http://bugs.otrs.org/show_bug.cgi?id=8035) - SOAP interface does not allow to create/update
    CustomerCompany records.
 - 2011-12-20 Fixed bug#[8027](http://bugs.otrs.org/show_bug.cgi?id=8027) - Duplicated slash in cache subdirectory names.
 - 2011-12-20 Make sure the customer is being returned to ticket search result after using
    'back' link from a ticket he has reached from the search result page.
 - 2011-12-19 Fixed bug#[7666](http://bugs.otrs.org/show_bug.cgi?id=7666) - Queue Preferences potentially slow.
 - 2011-12-19 Updated Polish translation file, thanks to Pawel!
 - 2011-12-16 Fixed Lithuanian language file encoding.
 - 2011-12-16 Added OTRS 2.4-style article colors to the article list in AgentTicketZoom.
    This is disabled by default, enable 'Ticket::UseArticleColors' in SysConfig to use it.

#3.1.0.beta3 2011-12-20
 - 2011-12-15 Fixed bug#[8012](http://bugs.otrs.org/show_bug.cgi?id=8012) - Confusing dashboard filter names.
 - 2011-12-14 Fixed bug#[8000](http://bugs.otrs.org/show_bug.cgi?id=8000) - Queues are translated if are displayed in list-style.
 - 2011-12-13 Added feature bug#[7893](http://bugs.otrs.org/show_bug.cgi?id=7893) - Customer Info in TicketZoom can now also list open tickets
    based on CustomerUserLogin rather than CustomerID, and can list closed tickets as well.
 - 2011-12-13 Fixed bug#[8020](http://bugs.otrs.org/show_bug.cgi?id=8020) - Queue list in new move window has the current queue enabled.
 - 2011-12-13 Fixed bug#[8017](http://bugs.otrs.org/show_bug.cgi?id=8017) - After first AJAXUpdate call, MultiSelect DynamicFields gets empty.
 - 2011-12-13 Fixed bug#[7999](http://bugs.otrs.org/show_bug.cgi?id=7999) - Uncheck all services for a customer doesn't work.
 - 2011-12-13 Fixed bug#[7005](http://bugs.otrs.org/show_bug.cgi?id=7005) - JavaScript Init function is executed more than once in TicketZoom.
 - 2011-12-13 Fixed bug#[7020](http://bugs.otrs.org/show_bug.cgi?id=7020) - Error in MySQL Syntax when CustomerID contains special characters.
 - 2011-12-12 Improved #7526 - Automatic TicketSearch for special characters (, ), &, - fails.
 - 2011-12-12 Fixed bug#[8009](http://bugs.otrs.org/show_bug.cgi?id=8009) - Statistic overview does not show the statistic object name
    for static statistics.
 - 2011-12-12 Changed the default behaviour of TicketGet() and ArticleGet() to NOT return the
    dynamic field values for performance reasons. If you need them, pass DynamicFields =\> 1.
 - 2011-12-09 Fixed bug#[7014](http://bugs.otrs.org/show_bug.cgi?id=7014) - Inline article gets bigger than Ticket::Frontend::HTMLArticleHeightMax.
 - 2011-12-09 Removed compatibility modules AgentTicketMailbox and CustomerZoom
    (these only performed redirects to newer screens).
 - 2011-12-09 Fixed bug#[7997](http://bugs.otrs.org/show_bug.cgi?id=7997) - Fetching mail via AdminMailAccount does not work.
 - 2011-12-09 Fixed bug#[7991](http://bugs.otrs.org/show_bug.cgi?id=7991) - Locale::Codes is not bundled in 3.1.0beta2 tarball, breaking Customer Cumpany
    screen.
 - 2011-12-09 Fixed bug#[7995](http://bugs.otrs.org/show_bug.cgi?id=7995) - Previous owner is missing in AgentTicketMove.
 - 2011-12-09 Updated Japanese Translation, thanks to Kaoru Hayama!
 - 2011-12-08 A bug related to oracle made database updates necessary ON ALL PLATFORMS when upgrading from beta1 or beta2.
    Please see the UPGRADING file for details.
 - 2011-12-07 Fixed bug#[7959](http://bugs.otrs.org/show_bug.cgi?id=7959) - Problem when entering a customer in the autocomplete field in AgentTicketPhone.
 - 2011-12-07 Fixed bug#[7976](http://bugs.otrs.org/show_bug.cgi?id=7976) - Add Event Trigger Asynchronous not correctly displayed in Event Triggers Table.
 - 2011-12-06 Fixed bug#[7981](http://bugs.otrs.org/show_bug.cgi?id=7981) - Stats sum on X axis does not display total if the total is zero.
 - 2011-12-06 Fixed bug#[4740](http://bugs.otrs.org/show_bug.cgi?id=4740) - HTTP header in Redirect is not syntactically correct.
 - 2011-12-06 Fixed bug#[5253](http://bugs.otrs.org/show_bug.cgi?id=5253) - User preferences are updated when displaying an overview.
 - 2011-12-05 Fixed bug#[5356](http://bugs.otrs.org/show_bug.cgi?id=5356) - TicketFreeText (now Dynamic Fields) containing domain name - causes
    Agent interface issues
 - 2011-12-05 Fixed bug#[3334](http://bugs.otrs.org/show_bug.cgi?id=3334) - FreeFields (now Dynamic Fields) with content "0" aren't displayed
    within TicketZoom view
 - 2011-12-05 Fixed bug#[4032](http://bugs.otrs.org/show_bug.cgi?id=4032) - TicketFreeText (now Dynamic Fields)- DefaultSelection does not work
    for AgentTicketForward
 - 2011-12-05 Fixed bug#[7923](http://bugs.otrs.org/show_bug.cgi?id=7923) - Free field value not correctly migrated error on DBUpdate-to-3.1.pl.
 - 2011-12-05 Fixed bug#[7975](http://bugs.otrs.org/show_bug.cgi?id=7975) - Wrong Type parameter is sent on Dynamic Fields ACLs.
 - 2011-12-05 Fixed bug#[7968](http://bugs.otrs.org/show_bug.cgi?id=7968) - DynamicField empty value "-" disappears on AJAX reload.
 - 2011-12-05 Fixed bug#[3544](http://bugs.otrs.org/show_bug.cgi?id=3544) - Don't show link to AgentTicketCustomer if agent does not have
    permissions.
 - 2011-12-05 Fixed bug#[7900](http://bugs.otrs.org/show_bug.cgi?id=7900) - DefaultQueue does not preselect queue in CustomerTicketMessage.
 - 2011-12-05 Fixed bug#[7184](http://bugs.otrs.org/show_bug.cgi?id=7184) - Service catalog is not useable with sophisticated amount of entries.
 - 2011-12-05 Fixed bug#[7864](http://bugs.otrs.org/show_bug.cgi?id=7864) - Inconsequent wrapping of text causes ugly notifications.
 - 2011-12-05 Fixed bug#[7967](http://bugs.otrs.org/show_bug.cgi?id=7967) - Misleading comment on DF Dropdown setup.
 - 2011-12-05 Fixed bug#[7966](http://bugs.otrs.org/show_bug.cgi?id=7966) - Little german translation enhancement.
 - 2011-12-02 Fixed bug#[5437](http://bugs.otrs.org/show_bug.cgi?id=5437) - Reload of TicketFreeTexFields (now DynamicFields) (for ACL).
 - 2011-12-02 Fixed bug#[7056](http://bugs.otrs.org/show_bug.cgi?id=7056) - AgentTicketMove.pm does not handle TicketFreeText
    (now DynamicFields) correctly.
 - 2011-12-02 Fixed bug#[7442](http://bugs.otrs.org/show_bug.cgi?id=7442) - Dashboard permission check for multiple Groups only
    tests first group.
 - 2011-12-02 Fixed bug#[4548](http://bugs.otrs.org/show_bug.cgi?id=4548) - 'Ajax overwrites OnChange' in BuildSelection().

#3.1.0.beta2 2011-12-06
 - 2011-11-30 Fixed bug#[6715](http://bugs.otrs.org/show_bug.cgi?id=6715) - Setting CustomerID with otrs.AddCustomerUser.pl.
 - 2011-11-29 Fixed bug#[7719](http://bugs.otrs.org/show_bug.cgi?id=7719) - Agent login page does not offer user to save password
    with Firefox browser.
 - 2011-11-29 Fixed bug#[4957](http://bugs.otrs.org/show_bug.cgi?id=4957) - Password Change dialog misses "Current Password" option.
 - 2011-11-29 Show Article Creator in article view, similar to Idea#378.
 - 2011-11-28 Updated CPAN module Apache::DBI to version 1.11.
 - 2011-11-28 Updated CPAN module Mozilla::CA to version 20111025.
 - 2011-11-26 Added ReferenceData object that provides ISO-3166 country codes.
    Could be extend to contain other data later.
 - 2011-11-23 Fixed bug#[7926](http://bugs.otrs.org/show_bug.cgi?id=7926) - AJAX refresh does not work on some fields.
 - 2011-11-24 Fixed bug#[7931](http://bugs.otrs.org/show_bug.cgi?id=7931) - Operations and Invokers can't be deleted from web service if the
    Controller is not present or not  registered.
 - 2011-11-23 Fixed bug#[7921](http://bugs.otrs.org/show_bug.cgi?id=7921) - Running DBUpdate-to-3.1-post.mssql.sql on Microsoft SQL Server
    generates errors.
 - 2011-11-23 Added Idea#378 - Show ticket creator in zoom view.
 - 2011-11-23 Fixed bug#[6139](http://bugs.otrs.org/show_bug.cgi?id=6139) - Hide current queue in queue move dialog in AgentTicketZoom.
 - 2011-11-23 Fixed bug#[6365](http://bugs.otrs.org/show_bug.cgi?id=6365) - AdminMailAccount Queue field should be hidden or disabled if Dispatching
    is set to 'By Mail'.
 - 2011-11-23 Fixed bug#[7930](http://bugs.otrs.org/show_bug.cgi?id=7930) - Depreciation warnings in error log when running OTRS on
    Perl 5.14.
 - 2011-11-21 Fixed bug#[7914](http://bugs.otrs.org/show_bug.cgi?id=7914) - DynamicField value Storage on AgentTicketActionCommon.pm and
    AgentTicketPhoneCommon.pm.
 - 2011-11-21 Fixed bug#[7923](http://bugs.otrs.org/show_bug.cgi?id=7923) - Free field value not correctly migrated error on DBUpdate-to-3.1.pl.
 - 2011-11-21 Fixed bug#[3804](http://bugs.otrs.org/show_bug.cgi?id=3804) - Stats in Bar or Pie chart formats don't display non-
    ascii characters correctly.
 - 2011-11-21 Fixed bug#[7920](http://bugs.otrs.org/show_bug.cgi?id=7920) - New ACL mechanism does not update Ticket{StateType} when a State
    or StateID is given.
 - 2011-11-21 Use the secure attribute to restrict cookies to HTTPS if it is used.
 - 2011-11-21 Fixed bug#[7909](http://bugs.otrs.org/show_bug.cgi?id=7909) - Errors should be logged in web server error log only.
 - 2011-11-21 Added feature to drag and drop/copy and paste images to richtext editor in firefox (base64 encoded).
 - 2011-11-19 Fixed bug#[7917](http://bugs.otrs.org/show_bug.cgi?id=7917) - New ACL mechanism does not generate DynamicField hash check when
    only TicketID is given.

#3.1.0.beta1 2011-11-22
 - 2011-11-15 Added IE7 to browser blacklist.
 - 2011-11-15 Updated German translation.
 - 2011-11-14 Fixed bug#[7526](http://bugs.otrs.org/show_bug.cgi?id=7526) - OTRS Ticket Search not working with ( or ).
 - 2011-11-14 Added Idea#724 - Connect to IMAP servers using TLS encryption.
 - 2011-11-14 Fixed bug#[7879](http://bugs.otrs.org/show_bug.cgi?id=7879) - Add the option to get mail from a specified IMAP folder.
 - 2011-11-14 Added new 'registration' mask to install process.
 - 2011-11-10 Fixed bug#[5863](http://bugs.otrs.org/show_bug.cgi?id=5863) - Added autocomplete for Cc and Bcc in AgentTicketCompose
 - 2011-11-10 Fixed AgentBook (addressbook) to cooperate with the new autocomplete handling
    in the ticket screens.
 - 2011-11-08 Fixed correct validation handling of RTE.
 - 2011-11-07 Fixed spelling mistake in README.
 - 2011-11-04 Removed 'address' and 'div' style formats from CKEditor.
 - 2011-11-04 Added support for CKEditor on iPhone and iPad with iOS5.
 - 2011-11-04 Added config option Frontend::AgentLinkObject::WildcardSearch to enable
    wildcard search if the AgentLinkObject mask is started.
 - 2011-11-01 Added functionality to allow to use auto-complete feature for more
    than one entry in To, From, Cc and Bcc fields into TicketPhone and EmailTicket screens.
 - 2011-10-31 Fixed bug#[7454](http://bugs.otrs.org/show_bug.cgi?id=7454) - MSSQL should use NVARCHAR to store text strings rather than VARCHAR.
 - 2011-10-31 Fixed bug#[7858](http://bugs.otrs.org/show_bug.cgi?id=7858) - Make "Apache::DBI" option not being overwritten with each update.
    Apache::DBI is now loaded in web server configuration file.
 - 2011-10-28 Updated CKEditor to 3.6.2.
 - 2011-10-28 Updated json2.js to current version 2011-10-19.
 - 2011-10-28 Updated stacktrace.js to 0.3.
 - 2011-10-28 Updated jQuery Validate plugin to 1.9.
 - 2011-10-28 Updated jQuery UI to 1.8.16.
 - 2011-10-28 Updated jQuery to 1.6.4.
 - 2011-10-24 Fixed bug#[7824](http://bugs.otrs.org/show_bug.cgi?id=7824) - Tickets locked through 'tmp\_lock' lock type aren't shown as locked
    tickets
 - 2011-10-20 Fixed bug#[7168](http://bugs.otrs.org/show_bug.cgi?id=7168) - Ticket Overview Control Row can only be one line high.
 - 2011-09-28 Fixed Ticket#2011080542009673 - Improved location check for _FileInstall().
 - 2011-09-26 Added missing cpan module Encode::Locale which is now required
    for HTTP::Response and LWP::UserAgent.
 - 2011-09-16 Added new legacy driver for PostgreSQL 8.1 or earlier. This
    needs to be activated for such older installations in Kernel/Config.pm
    as follows:
```
    $Self->{DatabasePostgresqlBefore82} = 1;
```
 - 2011-09-09 Updated CPAN module Mozilla::CA to version 20110904.
 - 2011-09-06 Converted all translation files to utf-8.
 - 2011-09-01 Changed Postgresql driver to also use standard\_conforming\_strings
    in regular database connections.
 - 2011-09-01 Fixed bug#[7684](http://bugs.otrs.org/show_bug.cgi?id=7684) - PostMaster Filter Module fails to create ticket
    if state set in filter is invalid.
 - 2011-08-30 Updated CPAN module SOAP::Lite to version 0.714.
 - 2011-08-30 Updated CPAN module libwww-perl to version 6.02.
 - 2011-08-30 Updated CPAN module YAML to version 0.73.
 - 2011-08-30 Updated CPAN module URI to version 1.59.
 - 2011-08-30 Updated CPAN module Text::Diff to version 1.41.
 - 2011-08-30 Updated CPAN module Proc::Daemon to version 0.14.
 - 2011-08-30 Updated CPAN module Net::SMTP::TLS::ButMaintained to version 0.18.
 - 2011-08-30 Updated CPAN module Net::IMAP::Simple to version 1.2024.
 - 2011-08-30 Updated CPAN module Mozilla::CA to version 20110409.
 - 2011-08-30 Updated CPAN module MailTools to version 2.08.
 - 2011-08-30 Updated CPAN module JSON to version 2.53.
 - 2011-08-30 Updated CPAN module JSON::PP to version 2.27200.
 - 2011-08-30 Updated CPAN module HTTP::Message to version 6.02.
 - 2011-08-30 Updated CPAN module Digest::SHA::PurePerl to version 5.62.
 - 2011-08-30 Updated CPAN module CGI to version 3.55.
 - 2011-08-24 Fixed bug#[6718](http://bugs.otrs.org/show_bug.cgi?id=6718) - error when running otrs-initial-insert.postgresql.sql by making
    otrs.xml2sql.pl write out utf8 files and by adding 'SET standard\_conforming\_strings TO ON'.
 - 2011-08-22 Fixed bug#[7635](http://bugs.otrs.org/show_bug.cgi?id=7635) - Remove support for Suse 9.
 - 2011-08-22 Fixed bug#[6444](http://bugs.otrs.org/show_bug.cgi?id=6444) - OTRS rc scripts checks and stops local mysql database
    and complains about having no database if you use a remote one.
 - 2011-08-22 Fixed bug#[7638](http://bugs.otrs.org/show_bug.cgi?id=7638) - OTRS rc scripts installation/check/stop of Scheduler service.
 - 2011-08-22 Fixed bug#[2365](http://bugs.otrs.org/show_bug.cgi?id=2365) - Removed dependency on MySQL in RPMs.
 - 2011-08-12 Removed support for non-utf-8 internal encodings.
 - 2011-07-29 Fixed bug#[7538](http://bugs.otrs.org/show_bug.cgi?id=7538) - CustomerSearchAutoComplete###QueryDelay has incorrect pattern match.
 - 2011-07-20 Added feature bug#[976](http://bugs.otrs.org/show_bug.cgi?id=976) - Send emails via bulk action.
 - 2011-07-18 Added feature bug#[7479](http://bugs.otrs.org/show_bug.cgi?id=7479) - Add "TicketChangeTime" as filter parameter
    in Generic agent.
 - 2011-07-01 Now stores binary data in VARBINARY rather than deprecated type
    TEXT on MS SQL Server.
 - 2011-07-01 Fixed bug#[7454](http://bugs.otrs.org/show_bug.cgi?id=7454) - MS SQL should use NVARCHAR to store text strings
    rather than VARCHAR.
 - 2011-06-21 TicketGet() now also returns ChangeBy and CreateBy.
 - 2011-06-06 Fixed bug#[4946](http://bugs.otrs.org/show_bug.cgi?id=4946) - Notification mails lack "Precedence: bulk" or similar headers.
 - 2011-05-20 Added feature bug#[7340](http://bugs.otrs.org/show_bug.cgi?id=7340) - It's not possible to sort tickets on last changed date.
 - 2011-05-18 Added feature bug#[7207](http://bugs.otrs.org/show_bug.cgi?id=7207) - Display warning if user is logged in and out-of-office
    is activated.
 - 2011-05-16 Added feature bug#[7316](http://bugs.otrs.org/show_bug.cgi?id=7316) - Possibility to exclude articles of certain sender types from
    being displayed in OverviewPreview mode and to display a certain article type as expanded when
    entering the view.
 - 2011-05-03 Added feature Ideascale#488 - Use ticket number in the URL to access to
    its zoom view.
 - 2011-05-02 Added feature bug#[6108](http://bugs.otrs.org/show_bug.cgi?id=6108) / Ideascale#87 - add the possibility to
    register inbound phone conversations.
 - 2011-04-29 Added enhancement bug#[7267](http://bugs.otrs.org/show_bug.cgi?id=7267) 0 Performance issue in dtl with large
    pages. Thanks to Stelios Gikas \<stelios.gikas@noris.net\>!
 - 2011-04-29 Added enhancement bug#[7266](http://bugs.otrs.org/show_bug.cgi?id=7266) - Performance issue in ticket zoom -
    article seen with many article. Thanks to Stelios Gikas \<stelios.gikas@noris.net\>!
 - 2011-04-27 Added feature bug#[5484](http://bugs.otrs.org/show_bug.cgi?id=5484) / IdeaScale#497 - Bulk action to set/change Ticket Type.
 - 2011-04-27 Added feature bug#[7258](http://bugs.otrs.org/show_bug.cgi?id=7258) - Stats output always has a timestamp and report name in
    the filename.
 - 2011-04-27 Fixed bug#[7257](http://bugs.otrs.org/show_bug.cgi?id=7257) - Stats CSV outputs report name and timestamp as first line.
 - 2011-04-27 Added feature bug#[5607](http://bugs.otrs.org/show_bug.cgi?id=5607) - otrs.GenerateStats.pl report only can be sent to one
    recipient at a time.
 - 2011-04-27 Fixed bug#[7211](http://bugs.otrs.org/show_bug.cgi?id=7211) - 'Valid' used in labels is now replaced with 'Validity'.
 - 2011-04-25 Fixed bug#[7236](http://bugs.otrs.org/show_bug.cgi?id=7236) - Ticket::TicketTitleUpdate() does not update change\_time of ticket.
 - 2011-04-20 Fixed ticket#2011041942007629 - Uninitialized value problem in AgentPreferences.pm.
 - 2011-04-20 Fixed bug#[7243](http://bugs.otrs.org/show_bug.cgi?id=7243) - Problem if current\_timestamp of database system is
    different to system time (e. g. time()).
 - 2011-04-19 Fixed bug#[3549](http://bugs.otrs.org/show_bug.cgi?id=3549) - ACLs don't work against queues with nonlatin characters.
 - 2011-04-18 Fixed bug#[7216](http://bugs.otrs.org/show_bug.cgi?id=7216) - Company names containing "&" pulled from Active Directory cause
    errors in error.log when using Company Tickets.
 - 2011-04-06 Added generic notification module to show messages in the agent interface.
 - 2011-04-05 Fixed bug#[7182](http://bugs.otrs.org/show_bug.cgi?id=7182) - AgentDashboard preferences are always translated.
 - 2011-03-29 Fixed bug#[6994](http://bugs.otrs.org/show_bug.cgi?id=6994) - AgentSelfNotifyOnAction is ignored for event based
    notifications.
 - 2011-03-24 Fixed bug#[6981](http://bugs.otrs.org/show_bug.cgi?id=6981) - ReadOnly CustomerUser sources should not be selectable for
    creating new customers.
 - 2011-03-15 Fixed bug#[7057](http://bugs.otrs.org/show_bug.cgi?id=7057) - Kernel::System::StandardResponse-\>StandardResponseLookup() is broken.
 - 2011-03-15 Fixed bug#[7053](http://bugs.otrs.org/show_bug.cgi?id=7053) - Installer page titles are not localized.
 - 2011-03-07 Added feature bug#[6992](http://bugs.otrs.org/show_bug.cgi?id=6992) - Ticket Responsible can't be set by GenericAgent.
 - 2011-03-07 Added feature bug#[6140](http://bugs.otrs.org/show_bug.cgi?id=6140) - Make the refresh interval of the dashboard
    configurable.
 - 2011-03-01 Added feature bug#[6977](http://bugs.otrs.org/show_bug.cgi?id=6977) - Next Screen after AgentTicketMove should
    be configurable.
 - 2011-02-28 Added feature bug#[6894](http://bugs.otrs.org/show_bug.cgi?id=6894). Events for escalations.
 - 2011-02-24 Fixed bug#[6867](http://bugs.otrs.org/show_bug.cgi?id=6867). CustomerCompany external source requires
    change\_time and create\_time columns.
 - 2011-02-07 Fixed Bug#2452 - SMIME encoded E-Mails are not decrypted properly by OTRS.
 - 2011-02-02 Fixed bug#[3125](http://bugs.otrs.org/show_bug.cgi?id=3125) - No translation for ticket-state in notifications.
 - 2011-02-02 Fixed bug#[6618](http://bugs.otrs.org/show_bug.cgi?id=6618) - TicketIndex can not be created if queue name
     of \> 70 characters exists.

#3.0.17 2012-10-16
 - 2012-10-05 Fixed bug#[6820](http://bugs.otrs.org/show_bug.cgi?id=6820) - OTRS crash with "division by zero" if escalation set incorrectly.
 - 2012-09-25 Fixed bug#[8606](http://bugs.otrs.org/show_bug.cgi?id=8606) - Escalation notifications should not be sent to agents who are set out-of-office.
 - 2012-09-13 Improved HTML security filter to better find javascript source URLs.

#3.0.16 2012-08-30
 - 2012-08-28 Improved HTML security filter to detect tag nesting.
 - 2012-08-24 Fixed bug#[8611](http://bugs.otrs.org/show_bug.cgi?id=8611) - Ticket count is wrong in QueueView.

#3.0.15 2012-09-04
 - 2012-08-17 HTML mails will now be displayed in an HTML5 sandbox iframe.
    This means that modern browsers will not execute plugins or JavaScript on the content
    any more. Currently, this is supported by Chrome and Safari, but IE10 and FF16 are also
 - 2012-08-17 HTML mails will now be displayed in the restricted zone in IE.
    This means that more restrictive security settings will apply, such as blocking of
    JavaScript content by default.
 - 2012-08-06 Fixed bug#[8672](http://bugs.otrs.org/show_bug.cgi?id=8672) - Search Profile can't have an ampersand in the name via
    Toolbar module.

#3.0.14 2012-08-07
 - 2012-07-31 Improved robustness of HTML security filter: Detect masked UTF-7 \< and \> signs.
 - 2012-07-16 Fixed bug#[8616](http://bugs.otrs.org/show_bug.cgi?id=8616) - Spell Checker does not work using IE9.
 - 2012-07-16 Fixed JavaScript error when no suggestions can be made by the spell checker.
 - 2012-06-29 Fixed bug#[8618](http://bugs.otrs.org/show_bug.cgi?id=8618) - Inform and Involved Agents select boxes can not be resizable.
 - 2012-06-15 Fixed bug#[7879](http://bugs.otrs.org/show_bug.cgi?id=7879) - Broken Content-Type in forwarded attachments.
 - 2012-06-14 Fixed bug#[8574](http://bugs.otrs.org/show_bug.cgi?id=8574) - Perl special variable $/ is changed and never restored.
 - 2012-06-14 Fixed bug#[8337](http://bugs.otrs.org/show_bug.cgi?id=8337) - Parentheses in user last\_name / first\_name are not sanitized (follow-up fix).
 - 2012-06-12 Fixed bug#[7872](http://bugs.otrs.org/show_bug.cgi?id=7872) - "Created" date in Large view is actually Last Updated date.
 - 2012-06-04 Improved performance of TemplateGenerator.pm, thanks to Stelios Gikas!

#3.0.13 2012-06-05
 - 2012-05-30 Fixed bug#[7532](http://bugs.otrs.org/show_bug.cgi?id=7532) - 'Field is required' message should be removed in RTE if content is added.
 - 2012-05-30 Fixed bug#[8514](http://bugs.otrs.org/show_bug.cgi?id=8514) - Long words in description break rendering of SysConfig items.
 - 2012-05-25 Fixed bug#[8189](http://bugs.otrs.org/show_bug.cgi?id=8189) - AgentTicketCompose: Pressing "Enter" will delete Attachment.
 - 2012-05-24 Fixed bug#[7512](http://bugs.otrs.org/show_bug.cgi?id=7512) - AJAX-reload of SMIME-fields did not work properly.
 - 2012-05-24 Fixed bug#[8518](http://bugs.otrs.org/show_bug.cgi?id=8518) - Crypt on multiple recipients error replaces Crypt selection.
 - 2012-05-22 Fixed bug#[8164](http://bugs.otrs.org/show_bug.cgi?id=8164) - Internal articles are visible within customer ticket overview.
 - 2012-05-16 Fixed bug#[8337](http://bugs.otrs.org/show_bug.cgi?id=8337) - Parentheses in user last\_name / first\_name are not sanitized.
 - 2012-05-04 Fixed bug#[7877](http://bugs.otrs.org/show_bug.cgi?id=7877) - SMIME emails don't get parsed properly (follow-up fix).
 - 2012-04-26 Fixed bug#[8424](http://bugs.otrs.org/show_bug.cgi?id=8424) - Ticket articles of large tickets cannot be opened.
 - 2012-04-24 Fixed bug#[8288](http://bugs.otrs.org/show_bug.cgi?id=8288) - Autocomplete search results show up in Times font when using Internet Explorer.
 - 2012-03-26 Fixed bug#[7877](http://bugs.otrs.org/show_bug.cgi?id=7877) - SMIME emails don't get parsed properly.
 - 2012-03-20 Fixed bug#[8331](http://bugs.otrs.org/show_bug.cgi?id=8331) - Unable to delete ticket with \> 1000 articles
    on Oracle database.

#3.0.12 2012-03-13
 - 2012-03-05 Fixed bug#[7545](http://bugs.otrs.org/show_bug.cgi?id=7545) - AgentTicketBounce lacks permission checks.
 - 2012-02-28 Improved #7526 - Fixed handling of special characters (, ), &, - within statistics.
 - 2012-02-23 Fixed bug#[8227](http://bugs.otrs.org/show_bug.cgi?id=8227) - LDAP user syncronisation doesn't work.
 - 2012-02-15 Fixed bug#[8144](http://bugs.otrs.org/show_bug.cgi?id=8144) - Typo and improved logging in GenericAgent.pm.
 - 2012-02-14 Fixed bug#[7652](http://bugs.otrs.org/show_bug.cgi?id=7652) - OpenSearch providers are served with wrong mime type.
    Follow-up fix.
 - 2012-02-09 Fixed bug#[7109](http://bugs.otrs.org/show_bug.cgi?id=7109) - no one statistic is working with your selected.
 - 2012-02-09 Fixed bug#[8199](http://bugs.otrs.org/show_bug.cgi?id=8199) - Linked tickets open only in tabs.
 - 2012-02-03 Fixed bug#[8180](http://bugs.otrs.org/show_bug.cgi?id=8180) - bin/otrs.LoaderCache.pl exit code is wrong.
 - 2012-02-02 Fixed bug#[7937](http://bugs.otrs.org/show_bug.cgi?id=7937) - HTMLUtils.pm ignore to much of e-mail source code.
 - 2012-02-02 Fixed bug#[7972](http://bugs.otrs.org/show_bug.cgi?id=7972) - Some mails may not present HTML part when using rich viewing.
 - 2012-01-27 Fixed bug#[2820](http://bugs.otrs.org/show_bug.cgi?id=2820) - Wide character in Syslog message causes Perl crash on utf8 systems.
 - 2012-01-23 Fixed bug#[8019](http://bugs.otrs.org/show_bug.cgi?id=8019) - Ticket customer info widget has scroll bars
 - 2012-01-20 Fixed bug#[8128](http://bugs.otrs.org/show_bug.cgi?id=8128) - Ticket Unwatch may lead to errorscreen.
 - 2012-01-16 Creation of QueueObject was not possible because of missing EncodeObject in CustomerUserGenericTicket.pm
 - 2011-12-20 Fixed bug#[8035](http://bugs.otrs.org/show_bug.cgi?id=8035) - SOAP interface does not allow to create/update
    CustomerCompany records.
 - 2011-12-19 Fixed bug#[7005](http://bugs.otrs.org/show_bug.cgi?id=7005) - JavaScript Init function is executed more than once in TicketZoom
 - 2011-12-14 Fixed bug#[7014](http://bugs.otrs.org/show_bug.cgi?id=7014) - Inline article gets bigger than Ticket::Frontend::HTMLArticleHeightMax.
 - 2011-12-16 Fixed Lithuanian language file encoding.
 - 2011-12-14 Fixed bug#[8000](http://bugs.otrs.org/show_bug.cgi?id=8000) - Queues are translated if are displayed in list-style.
 - 2011-12-13 Fixed bug#[7020](http://bugs.otrs.org/show_bug.cgi?id=7020) - Error in MYSQL Syntax when CustomerID contains special characters.
 - 2011-12-12 Improved #7526 - Automatic TicketSearch for special characters (, ), &, - fails.
 - 2011-12-09 Fixed bug#[7997](http://bugs.otrs.org/show_bug.cgi?id=7997) - Fetching mail via AdminMailAccount does not work.
 - 2011-12-09 Fixed bug#[7995](http://bugs.otrs.org/show_bug.cgi?id=7995) - Previous owner is missing in AgentTicketMove.
 - 2011-12-06 Fixed bug#[5253](http://bugs.otrs.org/show_bug.cgi?id=5253) - User preferences are updated when displaying an overview.
 - 2011-12-05 Fixed bug#[7971](http://bugs.otrs.org/show_bug.cgi?id=7971) - ACL to restrict Priority based on Service does not work in Customer
    interface
 - 2011-12-05 Fixed bug#[7864](http://bugs.otrs.org/show_bug.cgi?id=7864) - Inconsequent wrapping of text causes ugly notifications.
 - 2011-12-05 Fixed bug#[7338](http://bugs.otrs.org/show_bug.cgi?id=7338) - Upgrade Script DBUpdate-to-3.0.pl fails to create
    virtual\_fs tables on oracle.
 - 2011-12-02 Fixed bug#[7442](http://bugs.otrs.org/show_bug.cgi?id=7442) - Dashboard permission check for multiple Groups only
    tests first group.
 - 2011-11-29 Fixed bug#[7719](http://bugs.otrs.org/show_bug.cgi?id=7719) - Agent login page does not offer user to save password
    with Firefox browser.
 - 2011-11-30 Fixed bug#[6715](http://bugs.otrs.org/show_bug.cgi?id=6715) - Setting CustomerID with otrs.AddCustomerUser.pl.
 - 2011-11-28 Updated CPAN module Apache::DBI to version 1.11.
 - 2011-11-23 Fixed bug#[7930](http://bugs.otrs.org/show_bug.cgi?id=7930) - Depreciation warnings in error log when running OTRS on
    Perl 5.14.
 - 2011-11-21 Fixed bug#[3804](http://bugs.otrs.org/show_bug.cgi?id=3804) - Stats in Bar or Pie chart formats don't display non-
    ascii characters correctly.
 - 2011-11-21 Use the secure attribute to restrict coookies to HTTPS if it is used.
 - 2011-11-21 Fixed bug#[7909](http://bugs.otrs.org/show_bug.cgi?id=7909) - Errors should be logged in web server error log only.
 - 2011-11-17 Fixed bug#[7896](http://bugs.otrs.org/show_bug.cgi?id=7896) - Inline images are broken in ticket answers.
 - 2011-11-17 Fixed bug#[5782](http://bugs.otrs.org/show_bug.cgi?id=5782) - Skipped GenericAgent cron executions because of
    timing issues.
 - 2011-11-17 Fixed bug#[7674](http://bugs.otrs.org/show_bug.cgi?id=7674) - Pagination in dashboard appears even with one page of
    results.
 - 2011-11-16 Fixed bug#[7903](http://bugs.otrs.org/show_bug.cgi?id=7903) - Improve MarkTicketsAsSeen for use with large amounts
    of tickets.
 - 2011-11-15 Fixed bug#[7901](http://bugs.otrs.org/show_bug.cgi?id=7901) - Package Manager does not clear the cache.
 - 2011-11-15 Fixed bug#[7120](http://bugs.otrs.org/show_bug.cgi?id=7120) - Inline images from Lotus Notes do not show in
    AgentTicketCompose interface.
 - 2011-11-14 Fixed bug#[7526](http://bugs.otrs.org/show_bug.cgi?id=7526) - OTRS Ticket Search not working with ( or ).
 - 2011-11-10 Fixed bug#[7879](http://bugs.otrs.org/show_bug.cgi?id=7879) - Ticket forward not working if content-id exists.
 - 2011-11-07 Fixed bug#[7887](http://bugs.otrs.org/show_bug.cgi?id=7887) - Type based ACLs do not match if Type (Name) is sent.
 - 2011-11-05 Fixed bug#[7876](http://bugs.otrs.org/show_bug.cgi?id=7876) - NewTicketReject Postmaster module uses Admin Address
    as 'from' in reject emails.
 - 2011-11-05 Fixed bug#[7884](http://bugs.otrs.org/show_bug.cgi?id=7884) - Error message in web server error log when assigning
    queues to standard responses.
 - 2011-11-03 Fixed bug#[7865](http://bugs.otrs.org/show_bug.cgi?id=7865) - Special characters in group names.
 - 2011-11-01 Fixed bug#[7875](http://bugs.otrs.org/show_bug.cgi?id=7875) - Restricting visibility of SLA in the Customer Ticket zoom does not work.
 - 2011-11-01 Fixed bug#[7823](http://bugs.otrs.org/show_bug.cgi?id=7823) - ACL could remove default state from ticket masks.
 - 2011-10-26 Fixed bug#[7465](http://bugs.otrs.org/show_bug.cgi?id=7465) - Out-of-office unlock does not work upon customer's web reply.
 - 2011-10-25 Fixed bug#[7843](http://bugs.otrs.org/show_bug.cgi?id=7843) - Customer and Agent Ticket Zoom issue with Sessions.
 - 2011-10-24 Improved rpc-example.pl to not use autodispatch any more.
 - 2011-10-21 Fixed bug#[7845](http://bugs.otrs.org/show_bug.cgi?id=7845) - No DispatchMultiple Method in rpc.pl script.

#3.0.11 2011-10-18
 - 2011-10-07 Fixed bug#[7812](http://bugs.otrs.org/show_bug.cgi?id=7812) - Height of search terms doesn't fit on search results page on IE7
 - 2011-10-05 Fixed bug#[7807](http://bugs.otrs.org/show_bug.cgi?id=7807) - Ticket free text misplaced in IE7.
 - 2011-09-22 Fixed bug#[7776](http://bugs.otrs.org/show_bug.cgi?id=7776) - Double encoding for AJAX responses on ActiveState perl.
 - 2011-09-19 Fixed bug#[7756](http://bugs.otrs.org/show_bug.cgi?id=7756) - DefaultViewNewLine Config does not get used.
 - 2011-09-13 Fixed bug#[6902](http://bugs.otrs.org/show_bug.cgi?id=6902) - QueueView: My Queues \> bulk menu duplication.
 - 2011-09-12 Fixed bug#[7708](http://bugs.otrs.org/show_bug.cgi?id=7708) - Only 400 agents available in AdminUser.
 - 2011-09-07 Fixed bug#[7678](http://bugs.otrs.org/show_bug.cgi?id=7678) - ArticleContentIndex: API Documentation disagrees with code.
 - 2011-09-07 Fixed bug#[7633](http://bugs.otrs.org/show_bug.cgi?id=7633) - Status flag in customer interface ticket zoom has wrong colors.
 - 2011-09-07 Fixed bug#[7591](http://bugs.otrs.org/show_bug.cgi?id=7591) - Email address field validation fails if name server does not respond.
 - 2011-09-06 Fixed bug#[7566](http://bugs.otrs.org/show_bug.cgi?id=7566) - Ticket search with article create date not working with StaticDB.
 - 2011-09-05 Fixed ticket#2010111742013515 - import/export of static states with .pm file
    and umlaut in file is not working.
 - 2011-08-30 Improved fix of bug#[7195](http://bugs.otrs.org/show_bug.cgi?id=7195) to log a understandable error message if png, gif and
    jpeg support are not activated in the GD CPAN module.
 - 2011-08-26 Fixed bug#[7525](http://bugs.otrs.org/show_bug.cgi?id=7525) - Move in new window doesn't indicate required fields.
 - 2011-08-26 Fixed bug#[7507](http://bugs.otrs.org/show_bug.cgi?id=7507) - AgentTicketActionCommon.dtl don't know about selected Priority.
 - 2011-08-26 Fixed bug#[7504](http://bugs.otrs.org/show_bug.cgi?id=7504) - 7 Day Stats graph doesn't fit into alloted width.
 - 2011-08-25 Fixed bug#[7393](http://bugs.otrs.org/show_bug.cgi?id=7393) - Error when bouncing a ticket with a new state of open or new.
 - 2011-08-23 Fixed bug#[5621](http://bugs.otrs.org/show_bug.cgi?id=5621) - OpenSearch not working for Internet Explorer 8.
 - 2011-08-23 Fixed bug#[7652](http://bugs.otrs.org/show_bug.cgi?id=7652) - OpenSearch providers are served with wrong mime type.
 - 2011-08-17 Fixed bug#[7599](http://bugs.otrs.org/show_bug.cgi?id=7599) - Back-Link does not work in permission denied screen if
    this screen is a popup window.
 - 2011-08-16 Fixed bug#[7407](http://bugs.otrs.org/show_bug.cgi?id=7407) - Event based notifications with roles as recipients can
    produce multiple notifications.
 - 2011-08-16 Fixed bug#[7589](http://bugs.otrs.org/show_bug.cgi?id=7589) - Ticket Search - TicketWatcher doesn't expand.
 - 2011-08-15 Fixed bug#[7343](http://bugs.otrs.org/show_bug.cgi?id=7343) - Typos in Customer Company Countries list.
 - 2011-08-15 Fixed bug#[7081](http://bugs.otrs.org/show_bug.cgi?id=7081) - Kernel::System::Log fails when module does not return
    VERSION.
 - 2011-08-15 Fixed bug#[6263](http://bugs.otrs.org/show_bug.cgi?id=6263) - RPM upgrade should run otrs.RebuildConfig.pl and
    otrs.DeleteCache.pl.
 - 2011-08-12 Updated Simplified Chinese Translation, thanks to Martin Liu!
 - 2011-08-12 Updated Danish translation, thanks to Lars JÃ¸rgensen!
 - 2011-08-10 Fixed bug#[7550](http://bugs.otrs.org/show_bug.cgi?id=7550) - SLA and Service is not written to history.
 - 2011-08-10 Fixed bug#[7549](http://bugs.otrs.org/show_bug.cgi?id=7549) - Missing mandatory class and \* identifier in AgentTicketMove.

#3.0.10 2011-08-16
 - 2011-07-28 Fixed bug#[7518](http://bugs.otrs.org/show_bug.cgi?id=7518) - Escalation Notify by not working properly.
 - 2011-07-22 Fixed bug#[6978](http://bugs.otrs.org/show_bug.cgi?id=6978) - UTF characters got broken.
 - 2011-07-22 Fixed bug#[6259](http://bugs.otrs.org/show_bug.cgi?id=6259) - Search matching no results to Print opens extra tab.
 - 2011-07-22 Fixed bug#[7527](http://bugs.otrs.org/show_bug.cgi?id=7527) - Calling AgentTicketPhone with pre-selected values fails on
    ticket status of type "pending XYZ".
 - 2011-07-20 Fixed bug#[7097](http://bugs.otrs.org/show_bug.cgi?id=7097) - Length of name of event based notifications limited in the
    admin interface.
 - 2011-07-18 Fixed bug#[7477](http://bugs.otrs.org/show_bug.cgi?id=7477) - Dashboard shows "My Queues" even if a queue is preselected
    in the configuration.
 - 2011-07-18 Fixed bug#[6348](http://bugs.otrs.org/show_bug.cgi?id=6348) - GenericAgent cron job concurrency issues.
 - 2011-07-18 Fixed bug#[7502](http://bugs.otrs.org/show_bug.cgi?id=7502) - crontab.txt empty on Win32.
 - 2011-07-12 Fixed bug#[7015](http://bugs.otrs.org/show_bug.cgi?id=7015) - Closing split ticked assigned to different agents
    causes "Locked Tickets Total" to be negative (or off by one).
 - 2011-07-11 Fixed bug#[7362](http://bugs.otrs.org/show_bug.cgi?id=7362) - AuthSyncModule::LDAP::UserSyncMap with multiple auth backends.
 - 2011-07-08 Fixed bug#[7472](http://bugs.otrs.org/show_bug.cgi?id=7472) - TicketSearch for FreeTexts with _ in string not working on Oracle.
 - 2011-07-07 Fixed bug#[7484](http://bugs.otrs.org/show_bug.cgi?id=7484) - Customer items too much right-aligned in customer information box.
 - 2011-07-01 Fixed bug#[7434](http://bugs.otrs.org/show_bug.cgi?id=7434) - CustomerTicketOverview.dtl - closing listitems missing in HTML.

#3.0.9 2011-07-05
 - 2011-07-01 Fixed bug#[7419](http://bugs.otrs.org/show_bug.cgi?id=7419) - 3.0.8 RPM does not include var/fonts directory.
 - 2011-06-30 Fixed bug#[7380](http://bugs.otrs.org/show_bug.cgi?id=7380) - Undo & close window or Cancel & close window NOT working IE9.
 - 2011-06-29 Fixed bug#[7435](http://bugs.otrs.org/show_bug.cgi?id=7435) - Ticket::Frontend::CustomerTicketZoom###AttributesView settings not used for pdf output.
 - 2011-06-29 Fixed bug#[7459](http://bugs.otrs.org/show_bug.cgi?id=7459) - Files partly in database after executing bin/otrs.ArticleStorageSwitch.pl.
 - 2011-06-27 Fixed bug#[7367](http://bugs.otrs.org/show_bug.cgi?id=7367) - No notification of notes when ticket is closed.
 - 2011-06-24 Fixed bug#[7335](http://bugs.otrs.org/show_bug.cgi?id=7335) - No empty state selection in AgentTicketForward.
 - 2011-06-22 Fixed bug#[7433](http://bugs.otrs.org/show_bug.cgi?id=7433) - CustomerTicketZoom is not able to display owner and/or responsible.
 - 2011-06-21 Fixed bug#[4946](http://bugs.otrs.org/show_bug.cgi?id=4946) - Notification mails lack "Precedence: bulk" or similar headers.
 - 2011-06-21 Updated XML::TreePP to 0.41.
 - 2011-06-21 Updated XML::FeedPP to 0.43.
 - 2011-06-20 Fixed bug#[7400](http://bugs.otrs.org/show_bug.cgi?id=7400) - Setting Ticket::Frontend::ShowCustomerTickets not effective.
 - 2011-06-17 Fixed bug#[6469](http://bugs.otrs.org/show_bug.cgi?id=6469) - i18n: "Forwarded message" string is not translatable.
 - 2011-06-17 Fixed bug#[4524](http://bugs.otrs.org/show_bug.cgi?id=4524) - SQL errors when there are no valid states for a given state type.
 - 2011-06-17 Fixed bug#[7368](http://bugs.otrs.org/show_bug.cgi?id=7368) - Error in TicketEscalationDateCalculation.
 - 2011-06-17 Fixed bug#[7420](http://bugs.otrs.org/show_bug.cgi?id=7420) - Cache issue when updating states.
 - 2011-06-15 Fixed bug#[4606](http://bugs.otrs.org/show_bug.cgi?id=4606) - Possible to select invalid dates for Out-of-Office.
 - 2011-06-15 Fixed bug#[7398](http://bugs.otrs.org/show_bug.cgi?id=7398) - FreeTime fields have no validation.
 - 2011-06-14 Fixed bug#[7396](http://bugs.otrs.org/show_bug.cgi?id=7396) - Selectboxes with long entries are cut off in dialogs in IE7.
 - 2011-06-14 Fixed bug#[7350](http://bugs.otrs.org/show_bug.cgi?id=7350) - Permissiontable in Role \<-\> Group is cut.
 - 2011-06-14 Added new Lithuanian translation, thanks to Edgaras Lukoschevidsius!
 - 2011-06-11 Fixed bug#[7161](http://bugs.otrs.org/show_bug.cgi?id=7161) - Single page ticket list does not indicate how much tickets are displayed.
 - 2011-06-11 Updated Net::SMTP::TLS::ButMaintained to 0.17.
 - 2011-06-11 Fixed bug#[7354](http://bugs.otrs.org/show_bug.cgi?id=7354) - bin/otrs.Cron4Win32.pl creates an empty crontab.txt.
 - 2011-06-07 Fixed bug#[7119](http://bugs.otrs.org/show_bug.cgi?id=7119) - Search profile names not visible in URL anymore.
 - 2011-05-30 Fixed bug#[7361](http://bugs.otrs.org/show_bug.cgi?id=7361) - "$HOME/bin/otrs.DeleteCache.pl --expired" causes error message :
    Invalid option --expired
 - 2011-05-27 Fixed bug#[7355](http://bugs.otrs.org/show_bug.cgi?id=7355) - Memory leak in XML.pm.
 - 2011-05-27 Fixed bug#[7356](http://bugs.otrs.org/show_bug.cgi?id=7356) - AgentTicketForward ignores free text fields.
 - 2011-05-26 Fixed bug#[7311](http://bugs.otrs.org/show_bug.cgi?id=7311) - bouncing a ticket to multiple email-addresses is not possible anymore.
 - 2011-05-24 Fixed bug#[7348](http://bugs.otrs.org/show_bug.cgi?id=7348) - otrs.ArticleStorageSwitch.pl gives 'Corrupt file' errors on some attachments.
 - 2011-05-24 Fixed bug#[7329](http://bugs.otrs.org/show_bug.cgi?id=7329) - PendingJobs - auto unlock for closed tickets does not work in all cases.
 - 2011-05-24 Fixed bug#[6896](http://bugs.otrs.org/show_bug.cgi?id=6896) - Small inconcistencies in German translation for AgentTicketBulk screen.
 - 2011-05-24 Fixed bug#[7328](http://bugs.otrs.org/show_bug.cgi?id=7328) - PostMastFollowUp.pm value assignment issue.

#3.0.8 2011-05-24
 - 2011-05-19 Updated Japanese translation, thanks to Kaz Kamimura!
 - 2011-05-19 Fixed bug#[7332](http://bugs.otrs.org/show_bug.cgi?id=7332) - Some buttons are not shown in the AdminSysConfig in IE7.
 - 2011-05-16 Fixed bug#[7300](http://bugs.otrs.org/show_bug.cgi?id=7300) - Wrong dropdown pre-selection in AdminQueue.
 - 2011-05-16 Fixed bug#[7288](http://bugs.otrs.org/show_bug.cgi?id=7288) - hyperlink creationcuts URLs after a closing square bracket.
 - 2011-05-16 Fixed bug#[7287](http://bugs.otrs.org/show_bug.cgi?id=7287) - Ticket Type in Customer Interface is not indicated as a required field.
 - 2011-05-16 Fixed bug#[7310](http://bugs.otrs.org/show_bug.cgi?id=7310) - AdminNotification.dtl restricts subject line to 120 characters.
 - 2011-05-10 Fixed bug#[7280](http://bugs.otrs.org/show_bug.cgi?id=7280) - AgentTicketCompose :: empty state selection causes many log entries.
 - 2011-05-10 Fixed bug#[7111](http://bugs.otrs.org/show_bug.cgi?id=7111) - Customer Password reset mail is sent even if the DB could not be updated.
 - 2011-05-10 Fixed bug#[7271](http://bugs.otrs.org/show_bug.cgi?id=7271) - AJAX issue when clicking 'Submit' while AJAX requests are still running.
 - 2011-05-09 Fixed bug#[7270](http://bugs.otrs.org/show_bug.cgi?id=7270) - Changing the customer from overviews opens the ticket zoom.
 - 2011-05-09 Fixed bug#[7262](http://bugs.otrs.org/show_bug.cgi?id=7262) - Customer Ticket Overview Sorting by \<th\>.
 - 2011-05-09 Fixed bug#[6901](http://bugs.otrs.org/show_bug.cgi?id=6901) - Ticket Search -\> CSV export -\> close date incorrect.
 - 2011-05-09 Fixed bug#[7289](http://bugs.otrs.org/show_bug.cgi?id=7289) - Ticket::Frontend::CustomerSearchAutoComplete###QueryDelay
    should be specified in milliseconds rather than seconds.
 - 2011-05-09 Added new Croatian translation, thanks to Damir Dzeko!
 - 2011-05-09 Fixed bug#[7092](http://bugs.otrs.org/show_bug.cgi?id=7092) - Non-existent theme set in user\_preferences makes login impossible.
 - 2011-05-09 Fixed bug#[7010](http://bugs.otrs.org/show_bug.cgi?id=7010) - Latest version of PDF::API2 no longer includes DejaVu fonts.
    Fixed by including DejaVu fonts in var/fonts.
 - 2011-05-09 Fixed bug#[7245](http://bugs.otrs.org/show_bug.cgi?id=7245) - Event based notifications are not sent to roles.
 - 2011-05-04 Fixed bug#[7277](http://bugs.otrs.org/show_bug.cgi?id=7277) - otrs.cleanup is called in Cron on Win32.
 - 2011-05-04 Fixed bug#[7272](http://bugs.otrs.org/show_bug.cgi?id=7272) - i18n: TicketFreeTime field label is not translated.
 - 2011-05-02 Updated Brasilian Portugese translation, thanks to Murilo Moreira de Oliveira!
 - 2011-05-02 Updated Persian translation, thanks to Masood Ramezani!
 - 2011-04-28 Fixed bug#[7244](http://bugs.otrs.org/show_bug.cgi?id=7244) - Plain Auth with SMTP/TLS does not work.
 - 2011-04-21 Fixed bug#[7212](http://bugs.otrs.org/show_bug.cgi?id=7212) - IE7 Move box alignment issue in AgentTicketZoom.
 - 2011-04-21 Fixed bug#[7188](http://bugs.otrs.org/show_bug.cgi?id=7188) - Resizable handle always in foreground.
 - 2011-04-19 Fixed bug#[7229](http://bugs.otrs.org/show_bug.cgi?id=7229) - Apache configuration file references nonexisting javascript directory.
 - 2011-04-14 Fixed bug#[7230](http://bugs.otrs.org/show_bug.cgi?id=7230) - Password fields in SysConfig GUI are not protected.
 - 2011-04-14 Fixed bug#[7222](http://bugs.otrs.org/show_bug.cgi?id=7222) - Translation strings with more than 3 placeholders are not translated.
 - 2011-04-12 Fixed bug#[7213](http://bugs.otrs.org/show_bug.cgi?id=7213) - TicketSearch() TicketFlags handling broken.
 - 2011-04-11 Fixed bug#[7209](http://bugs.otrs.org/show_bug.cgi?id=7209) - TimeUnits validation not working.
 - 2011-04-11 Updated Italian translation, thanks to Lucia Magnanelli!
 - 2011-04-06 Fixed bug#[7058](http://bugs.otrs.org/show_bug.cgi?id=7058) - AJAX communication error when picking queue during ticket split.
 - 2011-04-05 Fixed bug#[7179](http://bugs.otrs.org/show_bug.cgi?id=7179) - MasterAction causes browser problem.
 - 2011-04-05 Fixed bug#[7169](http://bugs.otrs.org/show_bug.cgi?id=7169) - Archived tickets can not be un-archived.
 - 2011-04-04 Fixed bug#[6801](http://bugs.otrs.org/show_bug.cgi?id=6801) - Bulk Actions are not working.
 - 2011-04-04 Fixed bug#[7156](http://bugs.otrs.org/show_bug.cgi?id=7156) - NewTicketInNewWindow misplaced group.
 - 2011-04-01 Fixed bug#[7096](http://bugs.otrs.org/show_bug.cgi?id=7096) - CSS for navigation bar :: wrong z-index for selected area and hover.
 - 2011-04-01 Fixed bug#[7160](http://bugs.otrs.org/show_bug.cgi?id=7160) - Typo "Anwort" in translation file de.pm.
 - 2011-04-01 Fixed bug#[7158](http://bugs.otrs.org/show_bug.cgi?id=7158) - Customer search can not be started via URL.
 - 2011-04-01 Fixed bug#[7119](http://bugs.otrs.org/show_bug.cgi?id=7119) - Search profile names not visible in URL anymore in customer and agent panel.
 - 2011-04-01 Fixed bug#[7151](http://bugs.otrs.org/show_bug.cgi?id=7151) - Secure::DisableBanner does not disable E-Mail Headers
 - 2011-03-28 Fixed bug#[7115](http://bugs.otrs.org/show_bug.cgi?id=7115) - Search profiles are not working after upgrade to OTRS 3.

#3.0.7 2011-04-12
 - 2011-03-24 Fixed bug#[7106](http://bugs.otrs.org/show_bug.cgi?id=7106) - Customer user login can't be updated nor changed.
 - 2011-03-24 Fixed bug#[6954](http://bugs.otrs.org/show_bug.cgi?id=6954) - Option "NewTicketInNewWindow::Enabled"  is not working.
 - 2011-03-22 Fixed bug#[7052](http://bugs.otrs.org/show_bug.cgi?id=7052) - Clicking on items in Dashboard and Overview causes
    two GET request instead of one.
 - 2011-03-22 Fixed bug#[7077](http://bugs.otrs.org/show_bug.cgi?id=7077) - Customer Interface Article Information not displayed properly in IE7.
 - 2011-03-18 Fixed bug#[7063](http://bugs.otrs.org/show_bug.cgi?id=7063) - TicketZoom Customer information display issue in IE7.
 - 2011-03-16 Fixed bug#[7060](http://bugs.otrs.org/show_bug.cgi?id=7060) - Unexisting value is passed to several subroutines in AgentTicketPhone when there is no subaction.
 - 2011-03-15 Fixed bug#[7057](http://bugs.otrs.org/show_bug.cgi?id=7057) - Kernel::System::StandardResponse-\>StandardResponseLookup() is broken
 - 2011-03-15 Fixed bug#[5604](http://bugs.otrs.org/show_bug.cgi?id=5604) - Show name of static statistic, if there is only one.
 - 2011-03-14 Updated Norwegian translation, thanks to Espen Stefansen!
 - 2011-03-14 Fixed bug#[7040](http://bugs.otrs.org/show_bug.cgi?id=7040) - SQL error when retrieving CustomerCompanyList with Valid =\> 0.
 - 2011-03-14 Updated Chinese translation, thanks to Martin Liu!
 - 2011-03-13 Fixed bug#[7042](http://bugs.otrs.org/show_bug.cgi?id=7042) - Textual and layout issue Archive option in AgentTicketSearch.
 - 2011-03-10 Fixed bug#[6946](http://bugs.otrs.org/show_bug.cgi?id=6946) - SelectAllXXX checkbox is not checked when you first enter to the module.
 - 2011-03-09 Fixed bug#[7007](http://bugs.otrs.org/show_bug.cgi?id=7007) - Loader unit tests fail on MSWin32.
 - 2011-03-08 Fixed bug#[6790](http://bugs.otrs.org/show_bug.cgi?id=6790) - Custom directory not considered when running in CGI.
 - 2011-03-08 Fixed bug#[5354](http://bugs.otrs.org/show_bug.cgi?id=5354) - Gratuitous "use lib '../..';" in Kernel::Output::HTML::Layout
     preventing modules in /Custom to be loaded when deployed as CGI.
 - 2011-03-07 Fixed bug#[6014](http://bugs.otrs.org/show_bug.cgi?id=6014) - Printed pdf tickets are not searchable.
 - 2011-03-07 Fixed bug#[7006](http://bugs.otrs.org/show_bug.cgi?id=7006) - One MainObject unit test fails on Win32.
 - 2011-03-02 Fixed bug#[6936](http://bugs.otrs.org/show_bug.cgi?id=6936) - Click on Customer triggers Wildcard-Search.
 - 2011-02-28 Fixed bug#[6961](http://bugs.otrs.org/show_bug.cgi?id=6961) - TicketActionsPerTicket - Buttons not localized.
 - 2011-02-28 Fixed bug#[5578](http://bugs.otrs.org/show_bug.cgi?id=5578) - TicketSolutionResponseTime.pm fix.
 - 2011-02-28 Fixed bug#[6974](http://bugs.otrs.org/show_bug.cgi?id=6974) - Ticket Search does not find tickets if searching by
    in between 2 dates, and the ticket time is 00:00:00.
 - 2011-02-28 Fixed bug#[6930](http://bugs.otrs.org/show_bug.cgi?id=6930) - en\_GB (united kingdom) notification events blank.
 - 2011-02-25 Fixed bug#[6822](http://bugs.otrs.org/show_bug.cgi?id=6822) -  Underscore in username problem in 3.0.5.
 - 2011-02-25 Added Hindi translation, thanks to Chetan Nagaonkar!

#3.0.6 2011-02-29
 - 2011-02-21 Fixed bug#[6938](http://bugs.otrs.org/show_bug.cgi?id=6938). CustomerUser AutoLoginCreation doesn't work.
 - 2011-02-21 Updated Russian translation, thanks to Eugene Kungurov!
 - 2011-02-18 Fixed bug#[6912](http://bugs.otrs.org/show_bug.cgi?id=6912) - MIME-Viewer (PDF Preview) is not properly displayed in 3.x UI.
 - 2011-02-16 Changed UserID 1 notification
 - 2011-02-16 Updated Brazilian Portugese translation, thanks to Humberto Diogenes!
 - 2011-02-15 Fixed bug#[6861](http://bugs.otrs.org/show_bug.cgi?id=6861) - Navigation should be disabled when linking an object.
 - 2011-02-14 Fixed bug#[6869](http://bugs.otrs.org/show_bug.cgi?id=6869) - ITSM 3 Link Object "close window" refreshes and settings lost
 - 2011-02-09 Fixed bug#[6878](http://bugs.otrs.org/show_bug.cgi?id=6878) - Agent and customer usernames and passwords stored plaintext
    in database and session.
 - 2011-02-09 Updated French translation, thanks to Rï¿½mi Seguy!
 - 2011-02-08 Fixed bug#[6808](http://bugs.otrs.org/show_bug.cgi?id=6808) - change queue with note destroyes rich text in note
    when file is attached.
 - 2011-02-04 Fixed bug#[4350](http://bugs.otrs.org/show_bug.cgi?id=4350) - Time\_accounting not merged when merging ticket.
 - 2011-02-03 Fixed bug#[6831](http://bugs.otrs.org/show_bug.cgi?id=6831) - CustomerLogo not shown if external URL.
 - 2011-02-02 Fixed bug#[2877](http://bugs.otrs.org/show_bug.cgi?id=2877) - Licence is "License" in British English.
 - 2011-02-01 Fixed bug#[6837](http://bugs.otrs.org/show_bug.cgi?id=6837) - Queue cannot be created, just changed
 - 2011-02-01 Fixed bug#[6696](http://bugs.otrs.org/show_bug.cgi?id=6696) - TicketFreeTime options are line breaked in the
    search window.
 - 2011-01-31 Implemented bug#[6824](http://bugs.otrs.org/show_bug.cgi?id=6824) - Adding system addresses from CLI, via new
    script bin/otrs.AddSystemAddress.pl.
 - 2011-01-31 Fixed bug#[6818](http://bugs.otrs.org/show_bug.cgi?id=6818) - PDF Printing does not work with newest PDF::API2
    2.x module.
 - 2011-01-28 Fixed bug#[6506](http://bugs.otrs.org/show_bug.cgi?id=6506) - Ticket::Frontend::ZoomRichTextForce no longer
    available.
 - 2011-01-27 Fixed bug#[6539](http://bugs.otrs.org/show_bug.cgi?id=6539) - CustomerUser LDAP Fetch is requesting all attributes
    instead of configured attributes from map.
 - 2011-01-27 Added database connection information to otrs.CheckDB.pl script.
 - 2011-01-27 Fixed bug#[6729](http://bugs.otrs.org/show_bug.cgi?id=6729) - SMIME-Encryption broken in Interface.
 - 2011-01-27 Fixed bug#[6792](http://bugs.otrs.org/show_bug.cgi?id=6792) - ArticleFreeText default selection is not respected
    by input masks.
 - 2011-01-27 Fixed bug#[6791](http://bugs.otrs.org/show_bug.cgi?id=6791) - In TicketZoom Total Accounted Time is displayed
    when AccountTime is set to "off".
 - 2011-01-26 Fixed bug#[6721](http://bugs.otrs.org/show_bug.cgi?id=6721) - New users with empty password creation is allowed
    but a random password is assigned without notification.
 - 2011-01-26 Fixed bug#[4188](http://bugs.otrs.org/show_bug.cgi?id=4188) - Moving junk mails unnecessarily need subject and
    body (for 3.0 version).
 - 2011-01-25 Fixed bug#[6789](http://bugs.otrs.org/show_bug.cgi?id=6789) - Ticket OpenSearch in Customer Interface is broken.
 - 2011-01-25 Fixed bug#[4764](http://bugs.otrs.org/show_bug.cgi?id=4764) - Public frontend has Customer frontend opensearch
    descriptions.
 - 2011-01-25 Fixed bug#[6600](http://bugs.otrs.org/show_bug.cgi?id=6600) - AgentTicketSearch date selection issues.
 - 2011-01-25 Fixed bug#[5487](http://bugs.otrs.org/show_bug.cgi?id=5487) - Event Based notification - respect "Include
    Attachments to Notification".
 - 2011-01-25 Fixed bug#[6745](http://bugs.otrs.org/show_bug.cgi?id=6745) - Disabling out of office does not work until
    logging out.
 - 2011-01-25 Fixed bug#[6740](http://bugs.otrs.org/show_bug.cgi?id=6740) - Link CI to new phone or mail ticket does not work.
 - 2011-01-25 Fixed bug#[6764](http://bugs.otrs.org/show_bug.cgi?id=6764) - Usage of TicketHook as TicketZoom Subject.
 - 2011-01-24 Fixed bug#[6684](http://bugs.otrs.org/show_bug.cgi?id=6684) - CustomerInfoSize doesn't size the info box.
 - 2011-01-21 Fixed bug#[6728](http://bugs.otrs.org/show_bug.cgi?id=6728) - Notification Management not usable if many
    notifications exist.
 - 2011-01-21 Fixed bug#[6741](http://bugs.otrs.org/show_bug.cgi?id=6741) - Select box does not display helpful error messages.
 - 2011-01-21 Fixed bug#[6530](http://bugs.otrs.org/show_bug.cgi?id=6530) - Problem sending inline PGP answer.
 - 2011-01-21 Fixed bug#[6044](http://bugs.otrs.org/show_bug.cgi?id=6044) - Toolbar - show static buttons first
 - 2011-01-21 Fixed bug#[6654](http://bugs.otrs.org/show_bug.cgi?id=6654) - Can't add a queue with Unlock set to No using a PostgreSQL
    database.
 - 2011-01-20 Fixed bug#[4814](http://bugs.otrs.org/show_bug.cgi?id=4814) - Need UserID or UserLogin error message in some scenarios
    when using BasicAuth.
 - 2011-01-20 Fixed bug#[6725](http://bugs.otrs.org/show_bug.cgi?id=6725) - Typo in description for Stats in SysConfig.
 - 2011-01-20 Fixed bug#[6001](http://bugs.otrs.org/show_bug.cgi?id=6001) - Configuration issues when Apache::DBI is not installed.
    Apache::DBI is now bundled in Kernel/cpan-lib, mainly because it's not part of the
    RHEL5 package repositories.
 - 2011-01-19 Fixed bug#[6704](http://bugs.otrs.org/show_bug.cgi?id=6704) - Core.AJAX throws exceptions which cannot be handled.
 - 2011-01-17 Fixed bug#[6599](http://bugs.otrs.org/show_bug.cgi?id=6599) - Ticket sub-sorting in dashlets isn't working.
 - 2011-01-17 Fixed bug#[6706](http://bugs.otrs.org/show_bug.cgi?id=6706) - Add Google Chrome Frame support.

#3.0.5 2011-01-18
 - 2011-01-13 Fixed bug#[6628](http://bugs.otrs.org/show_bug.cgi?id=6628) - Attachments don't show up in Exchange when using WebUploadCacheModule::FS.
 - 2011-01-12 Fixed bug#[6681](http://bugs.otrs.org/show_bug.cgi?id=6681) - Font of notes is not fixed font (Frontend::RichText is disabled).
 - 2011-01-12 Fixed bug#[6458](http://bugs.otrs.org/show_bug.cgi?id=6458) - "Lock" not indicated on compose (lock/unlock message was not shown).
 - 2011-01-11 Fixed bug#[6653](http://bugs.otrs.org/show_bug.cgi?id=6653) - Time Format Dashboard etc.
 - 2011-01-11 Fixed bug#[6505](http://bugs.otrs.org/show_bug.cgi?id=6505) - Ticket::Frontend::PlainView has no effect.
 - 2011-01-10 Fixed bug#[6668](http://bugs.otrs.org/show_bug.cgi?id=6668) - Upgrade to OTRS 3.0.x fails if OTRS 2.4.x is used with OTRS::ITSM 2.x
 - 2011-01-07 Fixed bug#[6555](http://bugs.otrs.org/show_bug.cgi?id=6555) - no decoder for iso-8859-1 at /opt/otrs/Kernel/cpan-lib/MIME/Parser.pm line 821.
 - 2011-01-07 Fixed bug#[6582](http://bugs.otrs.org/show_bug.cgi?id=6582) - Admin-\>Manage Queues wrong subqueue default.
 - 2011-01-07 Fixed bug#[6658](http://bugs.otrs.org/show_bug.cgi?id=6658) - History contains redundant SetPendingTime entries.
 - 2011-01-06 Fixed bug#[5053](http://bugs.otrs.org/show_bug.cgi?id=5053) - Some inline images (bitmaps) from MS Outlook clients are not displayed in ticket zoom.
 - 2011-01-06 Fixed bug#[6627](http://bugs.otrs.org/show_bug.cgi?id=6627) - Queue names are wrapped badly by the browser.
 - 2011-01-06 Fixed bug#[6591](http://bugs.otrs.org/show_bug.cgi?id=6591) - Date selector calendar does not open on agent out of office.
 - 2011-01-06 Fixed bug#[6563](http://bugs.otrs.org/show_bug.cgi?id=6563) - Article list in AgentTicketZoom scrolls inconveniently.
 - 2011-01-06 Fixed bug#[6629](http://bugs.otrs.org/show_bug.cgi?id=6629) - Opening a link in a new Tab with IE doesn't allow you to navigate away from the SOURCE tab.
 - 2011-01-06 Fixed bug#[6650](http://bugs.otrs.org/show_bug.cgi?id=6650) - AgentTicketPhone loses Responsible selection after reload.
 - 2011-01-06 Fixed bug#[6354](http://bugs.otrs.org/show_bug.cgi?id=6354) - SMTPTLS multiplies attachments.
 - 2011-01-05 Fixed bug#[6624](http://bugs.otrs.org/show_bug.cgi?id=6624) - If ticket is displayed in "Show all articles mode" only the last article can be replied in IE7.
 - 2011-01-04 Fixed bug#[6578](http://bugs.otrs.org/show_bug.cgi?id=6578) - Agent settings 'My Queues' selection not shown.
 - 2011-01-04 Fixed bug#[5175](http://bugs.otrs.org/show_bug.cgi?id=5175) - Documentation of Kernel::System::Main::FileRead.
 - 2011-01-04 Updated Italian translation, thanks to Alessandro Grassi!
 - 2011-01-04 Updated Norwegian translation, thanks to Eirik Wulff!
 - 2011-01-03 Fixed bug#[6604](http://bugs.otrs.org/show_bug.cgi?id=6604) - Some attachments from mails created with OTRS 2.4.6
    are missing from the attachment list after upgrade to 3.0.
 - 2010-12-30 Fixed bug#[6473](http://bugs.otrs.org/show_bug.cgi?id=6473) - Error at Apache log "uninitialized value".
 - 2010-12-30 Fixed bug#[4886](http://bugs.otrs.org/show_bug.cgi?id=4886) - FollowUp-notification send not to owner.
 - 2010-12-30 Updated CPAN module JSON to version 2.50.
 - 2010-12-30 Updated CPAN module JSON::PP to version 2.27103.
 - 2010-12-30 Updated CPAN module Text::CSV to version 1.21.
 - 2010-12-28 Fixed bug#[6595](http://bugs.otrs.org/show_bug.cgi?id=6595) - umleiten != Zurï¿½ckweisen an.
 - 2010-12-28 Fixed bug#[6057](http://bugs.otrs.org/show_bug.cgi?id=6057) - Some action buttons don't have tooltips.
 - 2010-12-27 Fixed bug#[6606](http://bugs.otrs.org/show_bug.cgi?id=6606) - Login screen in area of ticket details.
 - 2010-12-27 Fixed bug#[6609](http://bugs.otrs.org/show_bug.cgi?id=6609) - Created date in article is overlapping the Loader icon.
 - 2010-12-27 Added extra documentation for bug#[6610](http://bugs.otrs.org/show_bug.cgi?id=6610) -
    OTRS\_CURRENT\_UserSalutation is always "-".
 - 2010-12-27 Fixed bug#[6605](http://bugs.otrs.org/show_bug.cgi?id=6605) - Error in url on admin package manager screen because wrong use of LQData.
 - 2010-12-23 Fixed bug#[6579](http://bugs.otrs.org/show_bug.cgi?id=6579) - ArticleTypeDefault is not selected in 'Note'
    on Bulk Action
 - 2010-12-23 Fixed bug#[6570](http://bugs.otrs.org/show_bug.cgi?id=6570) - Services/SLAs are not loaded if
    Ticket::Frontend::CustomerTicketMessage###Queue is set to "No"
 - 2010-12-23 Fixed bug#[6553](http://bugs.otrs.org/show_bug.cgi?id=6553) - Add CC for ticket customer function is no longer working.
 - 2010-12-22 Fixed bug#[4502](http://bugs.otrs.org/show_bug.cgi?id=4502) - Event Based Notification ignores SendNoNotification flag.
 - 2010-12-22 Fixed bug#[6596](http://bugs.otrs.org/show_bug.cgi?id=6596) - Ticket::Frontend::AgentTicketBounce###StateDefault doesn't work.
 - 2010-12-21 Fixed bug#[6576](http://bugs.otrs.org/show_bug.cgi?id=6576) - Unneeded entries in @INC.
 - 2010-12-21 Fixed bug#[6573](http://bugs.otrs.org/show_bug.cgi?id=6573) - Dutch notification texts don't display the ticket data.
 - 2010-12-20 Fixed bug#[6580](http://bugs.otrs.org/show_bug.cgi?id=6580) - Troubles modifying AgentTicketPhone in OTRS 3.0.3
    - using FreeText... failed.
 - 2010-12-20 Fixed bug#[6577](http://bugs.otrs.org/show_bug.cgi?id=6577) - AdminNotification screen does not work in IE7 on Windows XP.
 - 2010-12-17 Fixed bug#[6559](http://bugs.otrs.org/show_bug.cgi?id=6559) - the CK EDITOR for entering comments does not starts
    if you use CZ localization.
 - 2010-12-17 Fixed bug#[6560](http://bugs.otrs.org/show_bug.cgi?id=6560) - Link to "AgentPreferences" is shown even when the module is disabled.
 - 2010-12-17 Fixed bug#[6561](http://bugs.otrs.org/show_bug.cgi?id=6561) - Text sometimes too long for button.
 - 2010-12-17 Fixed bug#[6543](http://bugs.otrs.org/show_bug.cgi?id=6543) - UPGRADING should clearly state changed parameters
    of SetPermissions script.
 - 2010-12-16 Fixed bug#[6554](http://bugs.otrs.org/show_bug.cgi?id=6554) - SysConfig Group Handling.
 - 2010-12-15 Fixed bug#[6380](http://bugs.otrs.org/show_bug.cgi?id=6380) - Change Search Options does not list default fields.
 - 2010-12-14 Fixed bug#[6476](http://bugs.otrs.org/show_bug.cgi?id=6476) - Stats overview table has display error in table header.
 - 2010-12-14 Fixed bug#[6540](http://bugs.otrs.org/show_bug.cgi?id=6540) - System Log Hint could make room for more log information.
 - 2010-12-14 Fixed bug#[6541](http://bugs.otrs.org/show_bug.cgi?id=6541) - Left pane in AdminNotification is empty.
 - 2010-12-14 Fixed bug#[6542](http://bugs.otrs.org/show_bug.cgi?id=6542) - Typo in file UPGRADING.
 - 2010-12-14 Fixed bug#[6535](http://bugs.otrs.org/show_bug.cgi?id=6535) - Stats CSV output is not CSV, despite preference change.
 - 2010-12-14 Fixed bug#[6532](http://bugs.otrs.org/show_bug.cgi?id=6532) - With multiple inline images, only first one is
    preserved when replying.
 - 2010-12-14 Fixed bug#[6533](http://bugs.otrs.org/show_bug.cgi?id=6533) - Not possible to search tickets by responsible agent.
 - 2010-12-13 Fixed bug#[6520](http://bugs.otrs.org/show_bug.cgi?id=6520) - backup.pl doesn't backup with strong password.

#3.0.4 2010-12-15
 - 2010-12-10 Improved handling of JavaScript code. Now post output filters
    are able to inject and modify JavaScript code.
 - 2010-12-09 Fixed bug#[6498](http://bugs.otrs.org/show_bug.cgi?id=6498) - Creating module translations with
    otrs.CreateTranslationFile.pl -l all creates new files.
 - 2010-11-09 Upgraded jQuery UI to 1.8.6 (to fix some IE9 bugs).
 - 2010-12-09 Fixed bug#[6515](http://bugs.otrs.org/show_bug.cgi?id=6515) - CSV export of SQL statement isn't working.
 - 2010-12-09 Updated Danish Translation, thanks to Lars Jorgensen!
 - 2010-12-09 Fixed bug#[6496](http://bugs.otrs.org/show_bug.cgi?id=6496) - Article Filter only displays one article.
 - 2010-12-08 Fixed bug#[6421](http://bugs.otrs.org/show_bug.cgi?id=6421) - AdminCustomerUser does not show customers without searching
 - 2010-12-08 Fixed bug#[6470](http://bugs.otrs.org/show_bug.cgi?id=6470) - AgentTicketForward does not support ArticleFreeText
 - 2010-12-08 Fixed bug#[6436](http://bugs.otrs.org/show_bug.cgi?id=6436) - Content validation with javascript does not
    consider "CheckEmailAddresses".
 - 2010-12-07 Fixed bug#[6200](http://bugs.otrs.org/show_bug.cgi?id=6200) - OTRS 3.0 customer navigation not configurable.
 - 2010-12-07 Fixed bug#[6012](http://bugs.otrs.org/show_bug.cgi?id=6012) - DashboardTicketGeneric.pm fails handing over
    "Attributes" to AgentTicketSearch().
 - 2010-12-07 Fixed bug#[6459](http://bugs.otrs.org/show_bug.cgi?id=6459) - Unwanted and unconfigurable text when customer has no ticket created yet.
    This text was adapted and can now optionally be configured with the SysConfig setting
    'Ticket::Frontend::CustomerTicketOverviewCustomEmptyText'.
 - 2010-12-06 Fixed bug#[6477](http://bugs.otrs.org/show_bug.cgi?id=6477) - There are no hooks for Output filters on ticket composing screens.
 - 2010-12-06 Fixed bug#[6414](http://bugs.otrs.org/show_bug.cgi?id=6414) - Ticket overview small: resizing problems.
 - 2010-12-06 Fixed bug#[6451](http://bugs.otrs.org/show_bug.cgi?id=6451) - Article Tree doesn't expand.
 - 2010-12-06 Fixed bug#[6427](http://bugs.otrs.org/show_bug.cgi?id=6427) - Building large number of CacheFileStorable/
    CacheInternalTicket Files will cause Software error.
 - 2010-12-06 Fixed bug#[6408](http://bugs.otrs.org/show_bug.cgi?id=6408) - Uploading an attachment removed previously uploaded inline images.
 - 2010-12-06 Fixed bug#[6234](http://bugs.otrs.org/show_bug.cgi?id=6234) - Field validation in the AgentTicketPhone mask kicks in after uploading a picture.
 - 2010-12-06 Fixed bug#[6425](http://bugs.otrs.org/show_bug.cgi?id=6425) - Ticket::Frontend::MenuModule###460-Delete and
    Ticket::Frontend::PreMenuModule###450-Delete resulting in white page.
 - 2010-12-03 Added possibility to see ticket actions on hover on every single ticket in medium and large
    ticket overviews (enable with TicketActionsPerTicket item on Ticket::Frontend::Overview###Medium or
    Ticket::Frontend::Overview###Preview setting).
 - 2010-12-03 Fixed bug#[6458](http://bugs.otrs.org/show_bug.cgi?id=6458) - "Lock" not indicated on compose.
 - 2010-12-03 Fixed bug#[6471](http://bugs.otrs.org/show_bug.cgi?id=6471) - Public interface handler is not able to load module
    specific JavaScript and CSS.
 - 2010-12-03 Fixed bug#[6262](http://bugs.otrs.org/show_bug.cgi?id=6262) - Results list can expand behind ticket history table.
 - 2010-12-03 Fixed bug#[6456](http://bugs.otrs.org/show_bug.cgi?id=6456) - Searches won't save selected queues.
 - 2010-12-03 Fixed bug#[6431](http://bugs.otrs.org/show_bug.cgi?id=6431) - TicketSearch Window broken in IE8.
 - 2010-12-03 Fixed bug#[6468](http://bugs.otrs.org/show_bug.cgi?id=6468) - Can't add "To" field to TicketSearch.
 - 2010-12-03 Fixed bug#[6289](http://bugs.otrs.org/show_bug.cgi?id=6289) - i18n: Creating a new stat shows hardcoded value 'New'.
 - 2010-12-03 Fixed bug#[6304](http://bugs.otrs.org/show_bug.cgi?id=6304) - Not sure about the meaning of "3".
 - 2010-12-03 Updated Russian translation, thanks to Sergey Romanov!
 - 2010-12-02 Fixed bug#[6366](http://bugs.otrs.org/show_bug.cgi?id=6366) - gnupg signatures not working correct for partly signed messages.
 - 2010-12-01 Fixed bug#[6303](http://bugs.otrs.org/show_bug.cgi?id=6303) - Article display height in ticket zoom of customer interface can be too high.
 - 2010-12-01 Updated Danish translation, thanks to Lars Jorgensen!
 - 2010-12-01 Fixed bug#[6440](http://bugs.otrs.org/show_bug.cgi?id=6440) - Incomplete Action parameter after logging in to the
    customer interface.
 - 2010-12-01 Fixed bug#[6455](http://bugs.otrs.org/show_bug.cgi?id=6455) - Ticket actions in Ticket Overview are not usable if
    session id is not in cookie.
 - 2010-12-01 Fixed bug#[6453](http://bugs.otrs.org/show_bug.cgi?id=6453) - Moving Tickets via AgentTicketMove empties set Free Fields.
 - 2010-11-30 Updated Serbian translation, thanks to Milorad Jovanovic!
 - 2010-11-30 Fixed bug#[6401](http://bugs.otrs.org/show_bug.cgi?id=6401) - Invalid agents are partially ignored/shown in ticket masks.
 - 2010-11-30 Fixed bug#[6040](http://bugs.otrs.org/show_bug.cgi?id=6040) - Remove ReplyAll option if possible in agent interface.
 - 2010-11-29 Fixed bug#[4856](http://bugs.otrs.org/show_bug.cgi?id=4856) - Notifications are sent even if ticket is created with closed state.
 - 2010-11-29 Fixed bug#[6420](http://bugs.otrs.org/show_bug.cgi?id=6420) - Customer Search with No Results does not display appropriate message.
 - 2010-11-29 Fixed bug#[6428](http://bugs.otrs.org/show_bug.cgi?id=6428) - FreeText field alignment is wrong in AdminGenericAgent.
 - 2010-11-29 Updated Japanese translation, thanks to Kaz Kamimura!
 - 2010-11-29 Fixed bug#[2950](http://bugs.otrs.org/show_bug.cgi?id=2950) - Field labels for ArticleFreeTime are not translated in PDF print.
 - 2010-11-29 Fixed bug#[6401](http://bugs.otrs.org/show_bug.cgi?id=6401) - Field label for Content not aligned in SysConfig.
 - 2010-11-26 Fixed bug#[6390](http://bugs.otrs.org/show_bug.cgi?id=6390) - Customer Interface - Latest article hover text is always 'Loading'.

#3.0.3 2010-11-29
 - 2010-11-26 Fixed bug#[6393](http://bugs.otrs.org/show_bug.cgi?id=6393) - ArticleFreeText is missing in Customer Interface TicketZoom.
 - 2010-11-26 Fixed bug#[6396](http://bugs.otrs.org/show_bug.cgi?id=6396) - Freetext fields can't be added to ticket search.
 - 2010-11-25 Fixed bug#[6131](http://bugs.otrs.org/show_bug.cgi?id=6131) - Lack of warning for revoked and expired keys for PGP signs on emails.
 - 2010-11-25 Fixed bug#[6361](http://bugs.otrs.org/show_bug.cgi?id=6361) - Upgrade v2.4-\>v3.0 on MySQL with InnoDB as storage
    engine generates an error.
 - 2010-11-25 Fixed bug#[6199](http://bugs.otrs.org/show_bug.cgi?id=6199) - OTRS 3.0 ToolBarSearchFulltext has no product design.
 - 2010-11-25 Fixed bug#[2638](http://bugs.otrs.org/show_bug.cgi?id=2638) - Broken email syntax detection.
 - 2010-11-25 Fixed bug#[6392](http://bugs.otrs.org/show_bug.cgi?id=6392) - Email addresses containing special but allowed
    characters are not accepted in customer administration.
 - 2010-11-25 Fixed bug#[6367](http://bugs.otrs.org/show_bug.cgi?id=6367) - My Queues Selection Box doesn't display well on lower resolutions.
 - 2010-11-24 Fixed bug#[6379](http://bugs.otrs.org/show_bug.cgi?id=6379) - No Ajax Update fro Crypt and Sign fields when you set the customer on Email Compose.
 - 2010-11-24 Fixed bug#[6395](http://bugs.otrs.org/show_bug.cgi?id=6395) - Broken use of PGP Sign on AgentTicketEmail screen.
 - 2010-11-24 Fixed bug#[6388](http://bugs.otrs.org/show_bug.cgi?id=6388) - In the Medium view, the title of the ticket is truncated after 25 characters.
 - 2010-11-24 Fixed bug#[6389](http://bugs.otrs.org/show_bug.cgi?id=6389) - Customer TicketZoom - Ticket Title is truncated after 25 characters.
 - 2010-11-24 Fixed bug#[6370](http://bugs.otrs.org/show_bug.cgi?id=6370) - New customer form submission - errors are silently dropped.
 - 2010-11-24 Fixed bug#[6264](http://bugs.otrs.org/show_bug.cgi?id=6264) - CKEditor Image upload does not show a correct behavior in case a FormID is missing.
 - 2010-11-24 Fixed bug#[6353](http://bugs.otrs.org/show_bug.cgi?id=6353) - GenericAgent throws error when ArticleFS storage used.
 - 2010-11-24 Added new Japanese translation, thanks to Kaz Kamimura Thomas!
 - 2010-11-24 Fixed bug#[6187](http://bugs.otrs.org/show_bug.cgi?id=6187) - IE9: article height incorrectly calculated.
 - 2010-11-24 Fixed bug#[6188](http://bugs.otrs.org/show_bug.cgi?id=6188) - IE9: article table resize handle has no effect.
 - 2010-11-24 Fixed bug#[6189](http://bugs.otrs.org/show_bug.cgi?id=6189) - IE9: ticket overview table headers behave incorrectly.
 - 2010-11-24 Fixed bug#[6382](http://bugs.otrs.org/show_bug.cgi?id=6382) - otrs.ArticleStorageSwitch.pl script not working.
 - 2010-11-24 Fixed bug#[6378](http://bugs.otrs.org/show_bug.cgi?id=6378) - The error messages are displayed incorrectly in the action list.
 - 2010-11-23 Fixed Bug#6314 - Upgrade 2.4.x -\> 3.0.x - older tickets in database
    are marked as unread.
 - 2010-11-23 Fixed bug#[6360](http://bugs.otrs.org/show_bug.cgi?id=6360) - Bulk Action link all to ticket number doesn't link anything.
 - 2010-11-23 Fixed bug#[6286](http://bugs.otrs.org/show_bug.cgi?id=6286) - Adding a phone call outbound does indicate an unread article.
 - 2010-11-23 Fixed bug#[6283](http://bugs.otrs.org/show_bug.cgi?id=6283) - FreeText field search is not possible in Customer Interface.
 - 2010-11-23 Fixed bug#[6362](http://bugs.otrs.org/show_bug.cgi?id=6362) - Software error adding new PGP key.
 - 2010-11-23 Fixed bug#[6273](http://bugs.otrs.org/show_bug.cgi?id=6273) - IE7: Alert dialog display problems.
 - 2010-11-23 Fixed bug#[6260](http://bugs.otrs.org/show_bug.cgi?id=6260) - RichTextEditor Action for Inline-Image Upload is hard coded.
 - 2010-11-23 Fixed bug#[6371](http://bugs.otrs.org/show_bug.cgi?id=6371) - Opening the customer ticket zoom shows a browser error message.
 - 2010-11-23 Fixed Bug#6308 - Ticket search templates are not saved in agent interface.
 - 2010-11-23 Fixed Bug#6359 - Documentation fixes.
 - 2010-11-23 Fixed Bug#6368 - Change search options does not work in customer interface.
 - 2010-11-23 Fixed Bug#6346 - Upgrading script 2.4 -\> 3.0 may cause corruption of
    the configuration files (ZZZAuto.pm and ZZZAAuto.pm).
 - 2010-11-23 Fixed Bug#6357 - Customer search URL contains ampersands (&) instead of semicolons (;).
 - 2010-11-22 Fixed Bug#6358 - No custom CSS or JS is loaded from public module registration settings.
 - 2010-11-22 Fixed bug#[6355](http://bugs.otrs.org/show_bug.cgi?id=6355) - $HOME/bin/otrs.LoaderCache.pl cron job unhappy with
    files in var/httpd/htdocs/skins/Customer/.
 - 2010-11-22 Fixed bug#[6352](http://bugs.otrs.org/show_bug.cgi?id=6352) - var/cron/cache schedules nonexistent $HOME/bin/otrs.CacheDelete.pl.
 - 2010-11-22 Fixed bug#[6350](http://bugs.otrs.org/show_bug.cgi?id=6350) - Sort order in "Auto Responses \<-\> Queues".
 - 2010-11-19 Fixed bug#[6288](http://bugs.otrs.org/show_bug.cgi?id=6288) - Generating a stat that outputs to PDF or CSV opens an empty pop-up.
 - 2010-11-19 Fixed bug#[6300](http://bugs.otrs.org/show_bug.cgi?id=6300) - Revoked GPG-Keys are not shown as revoked.
 - 2010-11-19 Fixed bug#[6343](http://bugs.otrs.org/show_bug.cgi?id=6343) - CSS problem in the result list of ticket customer search.
 - 2010-11-19 Fixed bug#[6327](http://bugs.otrs.org/show_bug.cgi?id=6327) - More problems when using Session instead of Cookie.
 - 2010-11-19 Fixed bug#[6337](http://bugs.otrs.org/show_bug.cgi?id=6337) - Generic Agent has "Delete Ticket" as Default set -\> risk of ticket loss!
 - 2010-11-18 Fixed bug#[6330](http://bugs.otrs.org/show_bug.cgi?id=6330) - Bad character in Polish translation.
 - 2010-11-18 Fixed bug#[6324](http://bugs.otrs.org/show_bug.cgi?id=6324) - If you use Sessions in URLs and not in cookies,
    responding to tickets logs you out.
 - 2010-11-17 Upgraded jQuery to 1.4.4 because of a number of regressions in 1.4.3.
 - 2010-11-17 Fixed bug#[6232](http://bugs.otrs.org/show_bug.cgi?id=6232) - FreeText fields requiredness is not indicated.
 - 2010-11-17 Fixed bug#[6318](http://bugs.otrs.org/show_bug.cgi?id=6318) - Error in error log due to comparison with a value that sometimes does not exist on Customer Search.
 - 2010-11-17 Fixed bug#[6317](http://bugs.otrs.org/show_bug.cgi?id=6317) - No Pagination String in Customer Search Results.
 - 2010-11-17 Fixed bug#[6309](http://bugs.otrs.org/show_bug.cgi?id=6309) - SortBy columns performs a full ticket search on customer ticket search results.
 - 2010-11-16 Fixed bug#[6316](http://bugs.otrs.org/show_bug.cgi?id=6316) - CustomerLogo not working.
 - 2010-11-16 Fixed bug#[5797](http://bugs.otrs.org/show_bug.cgi?id=5797) - SMIME functionality does not work with OpenSSL 1.0.0.
 - 2010-11-16 Fixed bug#[6302](http://bugs.otrs.org/show_bug.cgi?id=6302) - Inbound mail password displayed in clear text during install.
 - 2010-11-16 Fixed bug#[6261](http://bugs.otrs.org/show_bug.cgi?id=6261) - Remove drop down from SysConfig start screen.
 - 2010-11-16 Fixed bug#[6294](http://bugs.otrs.org/show_bug.cgi?id=6294) - GenericAgent - Time Selection is not in columns.

#3.0.2 2010-11-17
 - 2010-11-16 Fixed bug#[6278](http://bugs.otrs.org/show_bug.cgi?id=6278) - Public and Customer frontends disclose version information.
 - 2010-11-16 Fixed bug#[6297](http://bugs.otrs.org/show_bug.cgi?id=6297) - [IE8] can't open popups.
 - 2010-11-15 Fixed bug#[6290](http://bugs.otrs.org/show_bug.cgi?id=6290) - Generic Agent Weekdays are not correctly sorted.

#3.0.1 2010-11-15
 - 2010-11-12 Fixed bug#[6268](http://bugs.otrs.org/show_bug.cgi?id=6268) - Error in web installer when setting up RPM on CentOS.
 - 2010-11-12 Fixed bug#[6271](http://bugs.otrs.org/show_bug.cgi?id=6271) - In IE8 customer name does not come up when
    you create new Tickets and enter customer name.
 - 2010-11-12 Fixed bug#[6225](http://bugs.otrs.org/show_bug.cgi?id=6225) - User creation gives confusing error message when
    email address is incorrect.
 - 2010-11-12 Fixed bug#[6266](http://bugs.otrs.org/show_bug.cgi?id=6266) - Order of TicketOverview columns in CPanel.
 - 2010-11-11 Fixed bug#[5984](http://bugs.otrs.org/show_bug.cgi?id=5984) - Attachment is lost when replying / forwarding /
    splitting articles.
 - 2010-11-11 Fixed bug#[6222](http://bugs.otrs.org/show_bug.cgi?id=6222) - Links are not displayed completely in HTML articles.
 - 2010-11-10 Fixed bug#[6257](http://bugs.otrs.org/show_bug.cgi?id=6257) - Watched Tickets ToolBarModule does not have a shortcut defined
    - leads to display issues.
 - 2010-11-10 Fixed bug#[6254](http://bugs.otrs.org/show_bug.cgi?id=6254) - Reloading article in ticket zoom corrupts encoding.
 - 2010-11-10 Fixed bug#[6111](http://bugs.otrs.org/show_bug.cgi?id=6111): i18n - Admin Link relation edit screens translation issues.
 - 2010-11-10 Fixed bug#[6061](http://bugs.otrs.org/show_bug.cgi?id=6061): Field size harmonization.
 - 2010-11-10 Updated zh\_CN translation, thanks to Never Min!
 - 2010-11-09 Updated CPAN module CGI to version 3.50.
 - 2010-11-09 Fixed bug#[6251](http://bugs.otrs.org/show_bug.cgi?id=6251) - Admin Group Interface produces an error log entry.
 - 2010-11-09 Fixed bug#[5043](http://bugs.otrs.org/show_bug.cgi?id=5043) - All Tickets / Locked Tickets View in QueueView missing.
 - 2010-11-09 Fixed bug#[6238](http://bugs.otrs.org/show_bug.cgi?id=6238) - Global Overview settings are centered on the results, not on the page.
 - 2010-11-09 Fixed bug#[6071](http://bugs.otrs.org/show_bug.cgi?id=6071) - Ticket Zoom - back button does not work as expected.
 - 2010-11-09 Fixed bug#[5788](http://bugs.otrs.org/show_bug.cgi?id=5788) - IE Browser Error "Out of memory at line: 35".
 - 2010-11-08 Fixed bug#[6225](http://bugs.otrs.org/show_bug.cgi?id=6225) - User creation gives confusing error message when email address is incorrect.
 - 2010-11-08 Fixed bug#[6227](http://bugs.otrs.org/show_bug.cgi?id=6227) - Customer User creation gives confusing error message when email address is
     not validated.
 - 2010-11-08 Fixed bug#[6241](http://bugs.otrs.org/show_bug.cgi?id=6241) - Need Ticket::ViewableStateType in Kernel/Config.pm.
 - 2010-11-08 Fixed bug#[6240](http://bugs.otrs.org/show_bug.cgi?id=6240) - Agent Dashboard - ticket opens only when clicking on the number.
 - 2010-11-08 Fixed bug#[5935](http://bugs.otrs.org/show_bug.cgi?id=5935) - TicketSearch Button - various improvements.
 - 2010-11-05 Fixed bug#[6113](http://bugs.otrs.org/show_bug.cgi?id=6113) - SysConfig - add a shortcut to "Change" button.
 - 2010-11-05 Fixed bug#[5930](http://bugs.otrs.org/show_bug.cgi?id=5930) - Optimisation in
    Kernel::Modules::CustomerTicketOverView-\>ShowTicketStatus.

#3.0.0 beta7 2010-11-08
 - 2010-11-05 Fixed bug#[6151](http://bugs.otrs.org/show_bug.cgi?id=6151) - No visual notification when generated article in ticket views.
 - 2010-11-05 Upgraded CKEditor to 3.4.2.
 - 2010-11-05 Fixed bug#[6237](http://bugs.otrs.org/show_bug.cgi?id=6237) - Datepicker starts weeks always on Sunday.
 - 2010-11-04 Skins can now be selected based on hostname with the configuration
    settings "Loader::Agent::DefaultSelectedSkin::HostBased" and
    "Loader::Customer::SelectedSkin::HostBased".
 - 2010-11-04 Fixed bug#[6216](http://bugs.otrs.org/show_bug.cgi?id=6216) - Queue names with spaces not displayed correctly in ticket view.
 - 2010-11-04 Fixed bug#[6186](http://bugs.otrs.org/show_bug.cgi?id=6186) - IE9: Dashboard widget functions broken.
 - 2010-11-04 Fixed bug#[6185](http://bugs.otrs.org/show_bug.cgi?id=6185) - IE9: JS error in the Dashboard.
 - 2010-11-04 Fixed bug#[6231](http://bugs.otrs.org/show_bug.cgi?id=6231) - Link delete screen redirects to itself if the bulk checkbox is used.
 - 2010-11-04 Fixed bug#[6215](http://bugs.otrs.org/show_bug.cgi?id=6215) - Agents can't have two popups open at the same time.
 - 2010-11-04 Fixed bug#[6228](http://bugs.otrs.org/show_bug.cgi?id=6228) - No difference between prio 1, 2 and 3 in overviews.
 - 2010-11-04 Fixed bug#[5757](http://bugs.otrs.org/show_bug.cgi?id=5757) - Article table resizing does not work correctly in IE7.
 - 2010-11-04 Fixed bug#[6229](http://bugs.otrs.org/show_bug.cgi?id=6229) - Submit button for Change Customer is below the fold with large amount of history.
 - 2010-11-04 Fixed bug#[6191](http://bugs.otrs.org/show_bug.cgi?id=6191) - Dashboard filter loses context after moving to next "bundle".
 - 2010-11-04 Fixed bug#[6207](http://bugs.otrs.org/show_bug.cgi?id=6207) - Pagination does not work in dashboard.
 - 2010-11-04 Fixed bug#[5937](http://bugs.otrs.org/show_bug.cgi?id=5937) - Large overview data presentation issues.
 - 2010-11-04 Fixed bug#[6203](http://bugs.otrs.org/show_bug.cgi?id=6203) - Rich Text Editor - right click on misspelled words in Firefox does not work as expected.
 - 2010-11-03 Fixed bug#[4273](http://bugs.otrs.org/show_bug.cgi?id=4273) - No required fields indication in AdminUser screen.
 - 2010-11-03 Added Serbian translation, thanks to Milorad JovanoviÄ‡!
 - 2010-11-03 Fixed bug#[6073](http://bugs.otrs.org/show_bug.cgi?id=6073) - Search window does not resize to selected content.
 - 2010-11-03 Fixed bug#[6122](http://bugs.otrs.org/show_bug.cgi?id=6122) - TicketZoom Scroller Height is calculation is broken.
 - 2010-11-03 Fixed bug#[5649](http://bugs.otrs.org/show_bug.cgi?id=5649) - Changing owner in M and S views opens in same tab instead of popup.
 - 2010-11-03 Fixed bug#[6181](http://bugs.otrs.org/show_bug.cgi?id=6181) - Customer Login box does not work if password is in browser cache.
 - 2010-11-03 Fixed bug#[6206](http://bugs.otrs.org/show_bug.cgi?id=6206) - DefineEmailFrom is not used when creating an email-ticket.
 - 2010-11-03 Fixed bug#[6156](http://bugs.otrs.org/show_bug.cgi?id=6156) - No FreeText Fields in Search.
 - 2010-11-02 Fixed bug#[6092](http://bugs.otrs.org/show_bug.cgi?id=6092) - Skins cannot be selected based on hostname.
 - 2010-11-02 Fixed bug#[5054](http://bugs.otrs.org/show_bug.cgi?id=5054) - Page titles could be more compact and informative.
 - 2010-11-02 Fixed bug#[6213](http://bugs.otrs.org/show_bug.cgi?id=6213) - If you use AgentTicketMove in a separate screen,
    it does not open in a popup.
 - 2010-11-02 Fixed bug#[6208](http://bugs.otrs.org/show_bug.cgi?id=6208) - If ticket zoom is not fully loaded actions will
    open in same window instead of popup.
 - 2010-11-02 Fixed bug#[6210](http://bugs.otrs.org/show_bug.cgi?id=6210) - GetUserData() function caching does not work correctly in all scenarios.
 - 2010-11-02 Fixed bug#[4565](http://bugs.otrs.org/show_bug.cgi?id=4565) - OutOfOffice information is displayed in responses and signatures.
 - 2010-11-02 Fixed bug#[6055](http://bugs.otrs.org/show_bug.cgi?id=6055) - 500 Error when closing ticket with non-original/changed customer.
 - 2010-11-02 Fixed bug#[5830](http://bugs.otrs.org/show_bug.cgi?id=5830) - Sometimes when replying on ticket getting error
    "Can't use an undefined value as a SCALAR reference".
 - 2010-11-02 Fixed bug#[5296](http://bugs.otrs.org/show_bug.cgi?id=5296) - Event based notifications do not check for local mail address.
 - 2010-11-02 Fixed bug#[1639](http://bugs.otrs.org/show_bug.cgi?id=1639) - Limit search time to certain amount by default.
 - 2010-11-02 Updated CPAN module JSON to version 2.27.
 - 2010-11-02 Fixed bug#[6205](http://bugs.otrs.org/show_bug.cgi?id=6205) - DefineEmailFrom does not use SystemAddress when set to
    Agent Name + FromSeparator + System Address Display Name.
 - 2010-11-02 Fixed bug#[6162](http://bugs.otrs.org/show_bug.cgi?id=6162) - When you close a search before complete load,
    it will be reopened automatically.
 - 2010-11-02 Fixed bug#[6060](http://bugs.otrs.org/show_bug.cgi?id=6060) - IE7 customer management in a popup breaks ticket creation page.
 - 2010-11-02 Fixed bug#[6204](http://bugs.otrs.org/show_bug.cgi?id=6204) - Autocomplete of customer users shows encoding characters.
 - 2010-11-02 Fixed bug#[6201](http://bugs.otrs.org/show_bug.cgi?id=6201) - Not able to save FreeText fields if TimeInput it set to required.
 - 2010-11-01 Fixed bug#[6137](http://bugs.otrs.org/show_bug.cgi?id=6137) - Split action does not create a link to the original ticket.
 - 2010-10-29 Fixed bug#[6163](http://bugs.otrs.org/show_bug.cgi?id=6163) - In Phone Ticket you can't attach files automatically after choosing a customer.
 - 2010-10-29 Fixed bug#[5917](http://bugs.otrs.org/show_bug.cgi?id=5917) - Thirdparty [Firefox]: Search freezes after deleting one field from profile.
 - 2010-10-29 Fixed bug#[5989](http://bugs.otrs.org/show_bug.cgi?id=5989) - Thirdparty [ckeditor?]: Using address book in reply window breaks the message body text box.
 - 2010-10-29 Updated Russian translation, thanks to Eugene Kungurov!
 - 2010-10-29 Fixed bug#[6184](http://bugs.otrs.org/show_bug.cgi?id=6184) - Streamline required field error messages.
 - 2010-10-28 Fixed bug#[5657](http://bugs.otrs.org/show_bug.cgi?id=5657) - In Global Ticket Overview, sorting for Prio is missing.
 - 2010-10-28 Fixed bug#[6141](http://bugs.otrs.org/show_bug.cgi?id=6141) - Sysconfig Address Book disable.
 - 2010-10-28 Upgraded CKEditor to 3.4.1.
 - 2010-10-27 Fixed bug#[6082](http://bugs.otrs.org/show_bug.cgi?id=6082) - Graph selections appear even if GD is not installed.
 - 2010-10-27 Fixed bug#[6059](http://bugs.otrs.org/show_bug.cgi?id=6059) - Customer name with quotes is truncated.
 - 2010-10-27 Fixed bug#[6094](http://bugs.otrs.org/show_bug.cgi?id=6094) - Responses in ticket view don't match.
 - 2010-10-27 Fixed bug#[6116](http://bugs.otrs.org/show_bug.cgi?id=6116) - ZoomExpand preference works inverted for articles.
 - 2010-10-27 Fixed bug#[6125](http://bugs.otrs.org/show_bug.cgi?id=6125) - Customer IDs with underscores do not work properly.
 - 2010-10-27 Fixed bug#[5637](http://bugs.otrs.org/show_bug.cgi?id=5637) - In Phone Ticket -\> Create a new customer via Popup,
    it's not possible to take over the recent created customer.
    Only a link to create a new ticket appears.
 - 2010-10-26 Fixed bug#[6076](http://bugs.otrs.org/show_bug.cgi?id=6076) - Bulk unlock does not work correctly.
 - 2010-10-26 Fixed bug#[6163](http://bugs.otrs.org/show_bug.cgi?id=6163) - In Phone Ticket you can't attach files automatically after choosing a customer.
 - 2010-10-26 Fixed bug#[6114](http://bugs.otrs.org/show_bug.cgi?id=6114) - Percentage sign in Customers \<-\> Services interface when using
    Dutch translation.
 - 2010-10-25 Fixed bug#[6160](http://bugs.otrs.org/show_bug.cgi?id=6160) - ServiceList function breaks if you have service names with
    special characters like ? ? ? or + + +.
 - 2010-10-25 Fixed bug#[6118](http://bugs.otrs.org/show_bug.cgi?id=6118) - The "Small", "Medium" and "Large" Queue views are broken if no
    data is found.

#3.0.0 beta6 2010-10-25
 - 2010-10-22 Fixed bug#[6150](http://bugs.otrs.org/show_bug.cgi?id=6150) - Spell checker should not be enabled by default.
 - 2010-10-22 Fixed bug#[6149](http://bugs.otrs.org/show_bug.cgi?id=6149) - New users get Ivory skin when created by admin using non-english language.
 - 2010-10-22 Updated CPAN module Text::CSV to version 1.20.
 - 2010-10-21 Fixed bug#[6089](http://bugs.otrs.org/show_bug.cgi?id=6089) - Close Window in Statistics doesn't work.
 - 2010-10-20 Fixed bug#[6132](http://bugs.otrs.org/show_bug.cgi?id=6132) - Wrong caching in RoleLookup function in Kernel/System/Group.pm.
 - 2010-10-19 Fixed bug#[6124](http://bugs.otrs.org/show_bug.cgi?id=6124) - Wrong caching in GroupLookup function in Kernel/System/Group.pm.
 - 2010-10-19 Fixed bug#[6127](http://bugs.otrs.org/show_bug.cgi?id=6127) - External function to create validation rules fails in Firefox on Ubuntu Linux.
 - 2010-10-19 Updated CPAN module Net::POP3::SSLWrapper to version 0.05.
 - 2010-10-19 Updated CPAN module Net::IMAP::Simple to version 1.2017.
 - 2010-10-19 Updated CPAN module MailTools to version 2.07.
 - 2010-10-19 Updated CPAN module JSON to version 2.26.
 - 2010-10-19 Updated CPAN module Apache::Reload to version 0.11.
 - 2010-10-18 Fixed bug#[6117](http://bugs.otrs.org/show_bug.cgi?id=6117) - Find method in VirtualFS is not able to find a file
    by Filename and Preferences
 - 2010-10-17 Fixed bug#[6090](http://bugs.otrs.org/show_bug.cgi?id=6090) - Accounted Time is not displayed in articles if
    Ticket::ZoomTimeDisplay is set to 'yes'.
 - 2010-10-17 Fixed bug#[6112](http://bugs.otrs.org/show_bug.cgi?id=6112) - Database IDs displayed in Admin GUI.
 - 2010-10-17 Fixed bug#[6110](http://bugs.otrs.org/show_bug.cgi?id=6110) - AdminCustomerUserGroup lists non-existing group 'info'.
 - 2010-10-17 Fixed bug#[6109](http://bugs.otrs.org/show_bug.cgi?id=6109) - '0' is not recognized as a valid input for TimeUnits.
 - 2010-10-12 Fixed bug#[6058](http://bugs.otrs.org/show_bug.cgi?id=6058) - Keyboard shortcuts should be shown via tooltip.
 - 2010-10-12 Added ability to open ticket history and other ticket actions
    in parallel.
 - 2010-10-12 Fixed bug#[6047](http://bugs.otrs.org/show_bug.cgi?id=6047) - Secure::DisableBanner does not work.
 - 2010-10-11 Fixed bug#[6079](http://bugs.otrs.org/show_bug.cgi?id=6079) - Unread tickets does mark as readed only second time.
 - 2010-10-11 Fixed bug#[5921](http://bugs.otrs.org/show_bug.cgi?id=5921) - RedHat rc script does not ignore ".save" files
    when rebuilding the cron jobs.
 - 2010-10-11 Fixed bug#[6040](http://bugs.otrs.org/show_bug.cgi?id=6040) - Remove ReplyAll option if possible.
 - 2010-10-07 Fixed bug#[5994](http://bugs.otrs.org/show_bug.cgi?id=5994) - Creating new statistic, field validation kicks in immediately.
 - 2010-10-07 Fixed bug#[5975](http://bugs.otrs.org/show_bug.cgi?id=5975) - Notifications (event-based) to external email
    address are visible to customers.

#3.0.0 beta5 2010-10-11
 - 2010-10-04 Fixed bug#[6064](http://bugs.otrs.org/show_bug.cgi?id=6064) - Predefined responses does not work.
 - 2010-10-01 Big improvements to TicketZoom rendering performance.
 - 2010-09-30 Fixed bug#[6054](http://bugs.otrs.org/show_bug.cgi?id=6054) - The default services are not loaded when creating a new ticket.
 - 2010-09-30 Fixed bug#[5911](http://bugs.otrs.org/show_bug.cgi?id=5911) - Enhance menu behavior.
    The submenus in the agent main menu open on click by default. With the new
    config "OpenMainMenuOnHover" setting it can be specified that they should
    also open on mouse hover.
 - 2010-09-30 Updated Ukrainian translation file, thanks to Ð‘ÐµÐ»ÑŒÑ?ÐºÐ¸Ð¹ Ð?Ñ€Ñ‚ÐµÐ¼!
 - 2010-09-30 Fixed bug#[5979](http://bugs.otrs.org/show_bug.cgi?id=5979) - IE8 - articles for a ticket doesn't switch
 - 2010-09-29 Fixed bug#[6017](http://bugs.otrs.org/show_bug.cgi?id=6017) - QueueLookup function returns wrong QueueID if a
    queue name was updated.
 - 2010-09-29 Fixed bug#[6019](http://bugs.otrs.org/show_bug.cgi?id=6019) - Choosing a search template does nothing.
 - 2010-09-29 Fixed bug#[6033](http://bugs.otrs.org/show_bug.cgi?id=6033) - Too many toolbar icons shown by default.
    Toolbar shortcuts are not shown by default.
    Toolbar items for tickets (such as locked tickets) are only shown if
    they have active tickets.
 - 2010-09-29 Fixed bug#[6032](http://bugs.otrs.org/show_bug.cgi?id=6032) - Customer History context settings not working.
 - 2010-09-28 Fixed bug#[6021](http://bugs.otrs.org/show_bug.cgi?id=6021) - Ticket Types are still displayed if they're invalid.
 - 2010-09-28 Fixed bug#[4732](http://bugs.otrs.org/show_bug.cgi?id=4732) - Mysql table index not used when LOWER()
    is used in queries for customer\_user.login. There is now a new flag CaseSensitive
    in the customer DB settings. Setting this to 1 will improve performance
    dramatically on large databases.
 - 2010-09-24 Fixed bug#[6007](http://bugs.otrs.org/show_bug.cgi?id=6007) - Free field content not saved.

#3.0.0 beta4 2010-09-27
 - 2010-09-24 Updated Russian translation file, thanks to Eugene Kungurov!
 - 2010-09-24 Fixed bug#[5655](http://bugs.otrs.org/show_bug.cgi?id=5655) - In Article Zoom, after a new article got created
    and page reloads, new article is shown as new. It's confusing.
 - 2010-09-24 Fixed bug#[5848](http://bugs.otrs.org/show_bug.cgi?id=5848) - Wrong characters in Czech language.
 - 2010-09-24 Updated Czech translation file, thanks to Pavel!
 - 2010-09-24 Fixed bug#[5962](http://bugs.otrs.org/show_bug.cgi?id=5962) - ToolBarModule and TicketSearchProfile, management
    of search profiles is not working correctly.
 - 2010-09-23 Fixed bug#[5950](http://bugs.otrs.org/show_bug.cgi?id=5950) - Customer History not shown in Change Customer View.
 - 2010-09-23 Changed ResponseFormat to TOFU (what people expect).
 - 2010-09-23 Fixed bug#[3515](http://bugs.otrs.org/show_bug.cgi?id=3515) - AgentTicketMove standard "Note" and "Subject" cannot be configured.
 - 2010-09-23 Fixed bug#[5965](http://bugs.otrs.org/show_bug.cgi?id=5965) - AgentTicketMove does not support setting of "Note" and "Subject".
 - 2010-09-23 Fixed bug#[5999](http://bugs.otrs.org/show_bug.cgi?id=5999) - Undefined variables generate warning in CustomerTicketMessage.
 - 2010-09-23 Fixed bug#[5980](http://bugs.otrs.org/show_bug.cgi?id=5980) - Free fields are not properly aligned.
 - 2010-09-23 Fixed bug#[5983](http://bugs.otrs.org/show_bug.cgi?id=5983) - Outlook inline image is displayed in attachment list.
 - 2010-09-23 Fixed bug#[5849](http://bugs.otrs.org/show_bug.cgi?id=5849) - Headline / Company Name is hardcoded in the DTL of the customer interface.
 - 2010-09-23 Fixed bug#[5988](http://bugs.otrs.org/show_bug.cgi?id=5988) - ActionRow in customer interface displays incorrectly
    when zoomed, in Firefox/Webkit browser
 - 2010-09-23 Fixed bug#[5995](http://bugs.otrs.org/show_bug.cgi?id=5995) - Pagination in Customer Interface does not work.
 - 2010-09-23 Fixed bug#[5982](http://bugs.otrs.org/show_bug.cgi?id=5982) - Email address does not render properly if it
    contains braces.
 - 2010-09-23 Fixed bug#[5987](http://bugs.otrs.org/show_bug.cgi?id=5987) - No column titles for ticket list in customer interface.
    This can now be configured with the config setting
    "Ticket::Frontend::CustomerTicketOverviewSortable".
 - 2010-09-22 Fixed bug#[5964](http://bugs.otrs.org/show_bug.cgi?id=5964) - The given param 'klant@ykoon.xx' in 'WatchUserIDs' is
    invalid in customer panel!
 - 2010-09-22 Fixed bug#[5956](http://bugs.otrs.org/show_bug.cgi?id=5956) - Arrows to expand/collapse Support Module details point
    in the wrong direction.
 - 2010-09-22 Fixed bug#[5976](http://bugs.otrs.org/show_bug.cgi?id=5976) - Admin Notification (event) text box runs outside the screen.
 - 2010-09-22 Fixed bug#[5959](http://bugs.otrs.org/show_bug.cgi?id=5959) - Agent gets "Invalid argument" JavaScript Error in Ticket Zoom.
 - 2010-09-21 Fixed bug#[5970](http://bugs.otrs.org/show_bug.cgi?id=5970) - Wrong orientation of expand / collapse arrows.
 - 2010-09-20 Fixed bug#[5707](http://bugs.otrs.org/show_bug.cgi?id=5707) - Web Installer Mail Configuration does not list all SMTP backends/options.
 - 2010-09-15 Fixed bug#[5948](http://bugs.otrs.org/show_bug.cgi?id=5948) - Address Book will not open for ticket forwarding.
 - 2010-09-15 Fixed bug#[5943](http://bugs.otrs.org/show_bug.cgi?id=5943) - Customer Link behaviour in ZoomView.
 - 2010-09-13 Fixed bug#[5649](http://bugs.otrs.org/show_bug.cgi?id=5649) - Changing owner from L view opens in same tab instead of popup.
 - 2010-09-13 Fixed bug#[5929](http://bugs.otrs.org/show_bug.cgi?id=5929) - CheckURLHash();get's called every 500ms - generates
    not needed load.

#3.0.0 beta3 2010-09-13
 - 2010-09-10 Fixed bug#[5525](http://bugs.otrs.org/show_bug.cgi?id=5525) - If submit button is clicked repeatedly two or more tickets
    can be created instead of one.
 - 2010-09-10 Fixed bug#[5923](http://bugs.otrs.org/show_bug.cgi?id=5923) - Can't set pending date to today but few hours later.
 - 2010-09-10 Fixed bug#[5913](http://bugs.otrs.org/show_bug.cgi?id=5913) - Time field of adminlog has to be bigger.
 - 2010-09-09 Fixed bug#[5916](http://bugs.otrs.org/show_bug.cgi?id=5916) - Used search fields are not removed from the
    available search fields list.
 - 2010-09-09 Fixed bug#[5866](http://bugs.otrs.org/show_bug.cgi?id=5866) - AutoLoginCreation does not work.
 - 2010-09-09 Fixed bug#[5674](http://bugs.otrs.org/show_bug.cgi?id=5674) - Attachment name and size are not displayed in
    attachment column in ticket zoom article table.
 - 2010-09-09 Fixed bug#[5902](http://bugs.otrs.org/show_bug.cgi?id=5902) - Long text overflow in infobox is not cut or wrapped.
 - 2010-09-09 Fixed bug#[5900](http://bugs.otrs.org/show_bug.cgi?id=5900) - ~otrs/bin/otrs.DeleteCache.pl should also delete the
    minified JS cache.
 - 2010-09-08 Fixed bug#[5665](http://bugs.otrs.org/show_bug.cgi?id=5665) - In Admin-Customer Management, required fields are not shown but
    validation is working.
 - 2010-09-08 Fixed bug#[5881](http://bugs.otrs.org/show_bug.cgi?id=5881) - ArticleDialog does not show last article description
    fully.
 - 2010-09-08 Fixed bug#[5846](http://bugs.otrs.org/show_bug.cgi?id=5846) - Missing error message if tickets pending time gets
    set to an invalid time.
 - 2010-09-08 Fixed bug#[5651](http://bugs.otrs.org/show_bug.cgi?id=5651) - Spellcheck can't be disabled.
 - 2010-09-08 Updated Danish translation file, thanks to Mads Nï¿½shauge Vestergaard!
 - 2010-09-08 Fixed bug#[5668](http://bugs.otrs.org/show_bug.cgi?id=5668) - Dashboard Widgets "Agents Online" shows pagination
   links even if no pagination is needed.
 - 2010-09-08 Fixed bug#[5882](http://bugs.otrs.org/show_bug.cgi?id=5882) - ArticleBox 'Direction' is not implemented.
 - 2010-09-03 Fixed bug#[5779](http://bugs.otrs.org/show_bug.cgi?id=5779) - Mandatory FreeTime fields are not validated.
 - 2010-09-03 Fixed bug#[5811](http://bugs.otrs.org/show_bug.cgi?id=5811) - Customer Interface account creation error handling
    does not work correctly.
 - 2010-09-07 Fixed bug#[5861](http://bugs.otrs.org/show_bug.cgi?id=5861) - Dashboard: CacheTTL for Stats breaks the generation of the chart.
 - 2010-09-07 Fixed bug#[5886](http://bugs.otrs.org/show_bug.cgi?id=5886) - Forwarding rich text tickets adds extra attachment.
 - 2010-09-07 Fixed bug#[5885](http://bugs.otrs.org/show_bug.cgi?id=5885) - Forwarding an article adds string to subject.
 - 2010-09-07 Fixed bug#[5024](http://bugs.otrs.org/show_bug.cgi?id=5024) - Adding a new ticket-priority results in a PriorityID-\<new ID\> tag
    from the layout engine in the generated HTML wo/ matching CSS class.
 - 2010-09-07 Fixed bug#[5884](http://bugs.otrs.org/show_bug.cgi?id=5884) - For CSV and Print (PDF) search results the search window does not auto close.
 - 2010-09-06 Fixed bug#[5887](http://bugs.otrs.org/show_bug.cgi?id=5887) - The size of the widget in the import statistic is too small for the input file.
 - 2010-09-06 Fixed bug#[5877](http://bugs.otrs.org/show_bug.cgi?id=5877) - No screen refresh when linking tickets.
 - 2010-09-06 Fixed bug#[4411](http://bugs.otrs.org/show_bug.cgi?id=4411) - CustomerTicket plain print (PDF=off) shows wrong URLs.
 - 2010-09-06 Fixed bug#[3521](http://bugs.otrs.org/show_bug.cgi?id=3521) - Error messages from password regex rules are
    truncated at comma which should't be there.
 - 2010-09-06 Fixed bug#[5875](http://bugs.otrs.org/show_bug.cgi?id=5875) - Customer ticket print view has too much information.
 - 2010-09-06 Fixed bug#[5867](http://bugs.otrs.org/show_bug.cgi?id=5867) - Navigation bar does not obey click path.
 - 2010-09-06 Fixed bug#[5871](http://bugs.otrs.org/show_bug.cgi?id=5871) - Ticket information in dashboard is not properly aligned.
 - 2010-09-06 Fixed bug#[5876](http://bugs.otrs.org/show_bug.cgi?id=5876) - Chinese UI issue.
 - 2010-09-03 Fixed bug#[5873](http://bugs.otrs.org/show_bug.cgi?id=5873) - Permissions fields are displaced in the EditSpecification of a Stat.
 - 2010-09-03 Fixed bug#[5812](http://bugs.otrs.org/show_bug.cgi?id=5812) - Customer Interface Password Sent dialog could be less confusing.
 - 2010-09-03 Fixed bug#[5870](http://bugs.otrs.org/show_bug.cgi?id=5870) - Login boxes in Customer Interface are too small.
 - 2010-09-03 Fixed bug#[5811](http://bugs.otrs.org/show_bug.cgi?id=5811) - Customer Interface account creation error handling
    does not work correctly.
 - 2010-09-03 Fixed bug#[5632](http://bugs.otrs.org/show_bug.cgi?id=5632) - New Ticket Search Dialog takes about 3 Seconds to load, 3 seconds
    with no feedback. User Experience need to get improved. Faster load of the dialog.
 - 2010-09-03 Fixed bug#[5789](http://bugs.otrs.org/show_bug.cgi?id=5789) - Use of uninitialized value $\_ in Kernel/System/CustomerUser/LDAP.pm.
 - 2010-09-03 Fixed bug#[5691](http://bugs.otrs.org/show_bug.cgi?id=5691) - Not possbible for a package to modify a file
    that belongs to another package.
 - 2010-09-02 Fixed bug#[5860](http://bugs.otrs.org/show_bug.cgi?id=5860) - Tooltips are not displayed correct in Customer
    interface.
 - 2010-09-02 Fixed bug#[5811](http://bugs.otrs.org/show_bug.cgi?id=5811) - Customer Interface account creation error
    handling does not work correctly.
 - 2010-09-02 Fixed bug#[5818](http://bugs.otrs.org/show_bug.cgi?id=5818) - Standard height of the article list.
 - 2010-09-02 Fixed bug#[5693](http://bugs.otrs.org/show_bug.cgi?id=5693) - Error messages appearing during mysql tables
    migration.
 - 2010-09-02 Fixed bug#[5802](http://bugs.otrs.org/show_bug.cgi?id=5802) - OTRS 3.0.0 beta 2 doesn't install default packages
    on login.
 - 2010-09-02 Fixed bug#[5780](http://bugs.otrs.org/show_bug.cgi?id=5780) - Have to resize window when replying on ticket.
 - 2010-09-02 Fixed bug#[5638](http://bugs.otrs.org/show_bug.cgi?id=5638) - Strange labels/buttons in TicketSearch "Create New  Delete".
 - 2010-09-02 Fixed bug#[5629](http://bugs.otrs.org/show_bug.cgi?id=5629) - Search Dialog of new Ticket Search Feature is not working with IE7.
 - 2010-09-02 Fixed bug#[5582](http://bugs.otrs.org/show_bug.cgi?id=5582) - Ticket::Frontend::MergeText and special carachters.
 - 2010-09-01 Fixed bug#[5851](http://bugs.otrs.org/show_bug.cgi?id=5851) - 3 AJAX refresh indicators are shown at the top of the AgentTicketPhone page.
 - 2010-09-01 Fixed bug#[5835](http://bugs.otrs.org/show_bug.cgi?id=5835) - Client side validation without JavaScript broken in
    customer interface.
 - 2010-09-01 Fixed bug#[5816](http://bugs.otrs.org/show_bug.cgi?id=5816) - SysConfig HighlightAge, wrong limits and handling.
 - 2010-09-01 Fixed bug#[5747](http://bugs.otrs.org/show_bug.cgi?id=5747) - Too much whitespace in popups.
 - 2010-09-01 Fixed bug#[5801](http://bugs.otrs.org/show_bug.cgi?id=5801) - Article action "Bounce article" gives error message.
 - 2010-09-01 Fixed bug#[5813](http://bugs.otrs.org/show_bug.cgi?id=5813) - Attachments of Tickets could not be loaded,
    caused by an (for IIS) invalid URL.
 - 2010-09-01 Fixed bug#[4423](http://bugs.otrs.org/show_bug.cgi?id=4423) - Hard coded CSS-Path in DTL templates.
 - 2010-09-01 Fixed bug#[5844](http://bugs.otrs.org/show_bug.cgi?id=5844) - Missing AJAX refresh indicator in the selection lists.
 - 2010-08-31 Fixed bug#[5729](http://bugs.otrs.org/show_bug.cgi?id=5729) - In Database creation or delete from Installer.pl the green colored word
    "Done" higher that the rest of the line.
 - 2010-08-31 Fixed bug#[5751](http://bugs.otrs.org/show_bug.cgi?id=5751) - TicketZoom Scroller Height is incorrectly calculated in Opera 10.61 Browser.
 - 2010-08-31 Fixed bug#[5809](http://bugs.otrs.org/show_bug.cgi?id=5809) - SLA should be Service Level Agreement.
 - 2010-08-31 Fixed bug#[2671](http://bugs.otrs.org/show_bug.cgi?id=2671) - Postmaster filter creation does not require a name.
 - 2010-08-31 Fixed bug#[5838](http://bugs.otrs.org/show_bug.cgi?id=5838) - Dialogs are not shown correctly in IE7.
 - 2010-08-31 Fixed bug#[5837](http://bugs.otrs.org/show_bug.cgi?id=5837) - Tooltips have transparent background in IE7.
 - 2010-08-31 Fixed bug#[5714](http://bugs.otrs.org/show_bug.cgi?id=5714) - Selecting a customer in AgentTicketEmail/Phone
    changes "Priority" and "Next ticket state" selections.
 - 2010-08-31 Fixed bug#[5791](http://bugs.otrs.org/show_bug.cgi?id=5791) - When creating a new ticket,
    changing the queue will change the priority and state.
 - 2010-08-30 Fixed bug#[5794](http://bugs.otrs.org/show_bug.cgi?id=5794) - Error when using Customer link when creating new ticket.
 - 2010-08-30 Fixed bug#[5807](http://bugs.otrs.org/show_bug.cgi?id=5807) - New mail account default state is "Invalid".
 - 2010-08-30 Fixed bug#[5824](http://bugs.otrs.org/show_bug.cgi?id=5824) - "Cancel & close window" link do nothing on Bulk operation at Tickets Status.
 - 2010-08-30 Fixed bug#[5829](http://bugs.otrs.org/show_bug.cgi?id=5829) - The body of the most recent article is not shown in the CustomerTicketZoom.
 - 2010-08-30 Fixed bug#[5800](http://bugs.otrs.org/show_bug.cgi?id=5800) - Ticket response drop down.
 - 2010-08-30 Fixed bug#[5765](http://bugs.otrs.org/show_bug.cgi?id=5765) - reply buttons in queue view produce perl error.
 - 2010-08-30 Updated Chinese translation file, thanks to Never Min!
 - 2010-08-30 Fixed bug#[5743](http://bugs.otrs.org/show_bug.cgi?id=5743) - Popup blocker should be detected.
 - 2010-08-30 Fixed bug#[5786](http://bugs.otrs.org/show_bug.cgi?id=5786) - -Reply- dropdown menu not reverting to initial state then closing reply
    window.
 - 2010-08-27 Fixed bug#[5833](http://bugs.otrs.org/show_bug.cgi?id=5833) - The text "Attachment" is above the paper-clip icon in the CustomerTicketZoom.
 - 2010-08-27 Fixed bug#[5831](http://bugs.otrs.org/show_bug.cgi?id=5831) - English language typo: "doesn't exists" should
    be "doesn't exist".
 - 2010-08-27 Updated Polish translation file, thanks to Janek Rumianek!
 - 2010-08-25 Fixed bug#[5805](http://bugs.otrs.org/show_bug.cgi?id=5805) - Customer interface: creation of a new ticket
    requires two clicks on the submit button.
 - 2010-08-26 Fixed bug#[5819](http://bugs.otrs.org/show_bug.cgi?id=5819) - Queue-View on size "S" is missing  the link to size "L".
 - 2010-08-26 Fixed bug#[5821](http://bugs.otrs.org/show_bug.cgi?id=5821) - SysConfig CSSLoader description is displayed incorrectly.
 - 2010-08-25 Fixed bug#[5795](http://bugs.otrs.org/show_bug.cgi?id=5795) - Some .pl files in bin directory fails to load
    modules from  Kernel/cpan-lib.
 - 2010-08-25 Fixed bug#[5817](http://bugs.otrs.org/show_bug.cgi?id=5817) Button to adjust the article-list-size contains a link on IE 8.0.
 - 2010-08-25 Fixed bug#[5805](http://bugs.otrs.org/show_bug.cgi?id=5805) - Customer interface: creation of a new ticket
    requires two clicks on the submit button.
 - 2010-08-25 Fixed bug#[5820](http://bugs.otrs.org/show_bug.cgi?id=5820) - Ticket owner get no email reminder reached
    notification if ticket is unlocked and owner is not subscribed to queue.
 - 2010-08-25 Fixed bug#[5815](http://bugs.otrs.org/show_bug.cgi?id=5815) - Customer interface field validation takes place before submitting.
 - 2010-08-25 Fixed bug#[5808](http://bugs.otrs.org/show_bug.cgi?id=5808) - Generic Agent does not display job info.
 - 2010-08-24 Applied change suggested in bug#[5733](http://bugs.otrs.org/show_bug.cgi?id=5733). $Text should be dereferenced while counting its length.
 - 2010-08-24 Fixed bug#[5806](http://bugs.otrs.org/show_bug.cgi?id=5806) - Default services aren't checked in AdminCustomerUserService.
 - 2010-08-24 Fixed bug#[5803](http://bugs.otrs.org/show_bug.cgi?id=5803) - TimeInputFormat "Input" generates CSS errors.

#3.0.0 beta2 2010-08-23
 - 2010-08-21 Fixed bug#[5697](http://bugs.otrs.org/show_bug.cgi?id=5697) - IMAP Connector Failing in IMAP mode, IMAPS is working.
 - 2010-08-21 Fixed bug#[5766](http://bugs.otrs.org/show_bug.cgi?id=5766) - Complex LinkObject Table is broken when more
    than one kind of object is linked.
 - 2010-08-20 Fixed bug#[5784](http://bugs.otrs.org/show_bug.cgi?id=5784) - Core.AJAX.js fails if if called without callback
    parameter and also exception handler breaks.
 - 2010-08-20 Fixed bug#[5783](http://bugs.otrs.org/show_bug.cgi?id=5783) - Warning: Ticket locked! message when replying to
    unlocked ticket.
 - 2010-08-20 Updated database diagram to reflect changes in OTRS 3.
 - 2010-08-19 Fixed bug#[5768](http://bugs.otrs.org/show_bug.cgi?id=5768) - No tickets shown at customer interface if no open
    tickets exist.
 - 2010-08-19 Fixed bug#[5639](http://bugs.otrs.org/show_bug.cgi?id=5639) - Global Overview: No action when clicking a row in
    S/M/L view mode.
 - 2010-08-19 Fixed bug#[5728](http://bugs.otrs.org/show_bug.cgi?id=5728) - Ticket history shows wrong date and time for agent
    actions "createtime" (actually shows user creation date).
 - 2010-08-19 Fixed bug#[5727](http://bugs.otrs.org/show_bug.cgi?id=5727) - Ticket search results are not sortable.
 - 2010-08-19 Fixed bug#[5611](http://bugs.otrs.org/show_bug.cgi?id=5611) - Company Button has the same function as Tickets Button.
 - 2010-08-19 Fixed bug#[5760](http://bugs.otrs.org/show_bug.cgi?id=5760) - Adding a new ticket in the customer interface
    can result in 2 tickets.
 - 2010-08-19 Fixed bug#[5722](http://bugs.otrs.org/show_bug.cgi?id=5722) - Customer interface does not display error messages
    when creating a ticket.
 - 2010-08-18 Fixed bug#[5662](http://bugs.otrs.org/show_bug.cgi?id=5662) - In Global Ticket Overview, in L-Mode, template
    support is missing in "Reply" feature.
 - 2010-08-18 Fixed bug#[5764](http://bugs.otrs.org/show_bug.cgi?id=5764) - No move option in S/M/L mode available.
 - 2010-08-18 Fixed bug#[5725](http://bugs.otrs.org/show_bug.cgi?id=5725) - Missing labels for search-terms in customer interface.
 - 2010-08-17 Fixed bug#[5598](http://bugs.otrs.org/show_bug.cgi?id=5598) - Address Book To: field does is not populated.
 - 2010-08-17 Fixed bug#[5679](http://bugs.otrs.org/show_bug.cgi?id=5679) - In "New Ticket" in customer interface,
    selecting the queue automatically submits the ticket.
 - 2010-08-17 Fixed bug#[5724](http://bugs.otrs.org/show_bug.cgi?id=5724) - Security leak: Edit HTML source code as customer.
 - 2010-08-17 Fixed bug#[5682](http://bugs.otrs.org/show_bug.cgi?id=5682) - Collapse / expand for GenericAgent.
 - 2010-08-17 Fixed bug#[5370](http://bugs.otrs.org/show_bug.cgi?id=5370) - The word "subscribe" should be changed to "watch".
 - 2010-08-17 Fixed bug#[5742](http://bugs.otrs.org/show_bug.cgi?id=5742) - Outgoing email link detection does not work properly.
 - 2010-08-13 Fixed bug#[5660](http://bugs.otrs.org/show_bug.cgi?id=5660) - In Global Ticket Overview, with IE7: S/M/L, character
    is not clickable, only hover area is clickable, fixed changing images for S/M/L letters.
 - 2010-08-12 Fixed bug#[5648](http://bugs.otrs.org/show_bug.cgi?id=5648) - Submitting a note does not work as expected in all scenarios.
 - 2010-08-12 Fixed bug#[5654](http://bugs.otrs.org/show_bug.cgi?id=5654) - Missing shortcut icon (product.ico).
 - 2010-08-12 Fixed bug#[5643](http://bugs.otrs.org/show_bug.cgi?id=5643) - Articles are sorted alphabetically in TicketZoom.
 - 2010-08-12 Fixed bug#[5613](http://bugs.otrs.org/show_bug.cgi?id=5613) - WYSIWYG Editor not in center position.
 - 2010-08-12 Fixed bug#[5612](http://bugs.otrs.org/show_bug.cgi?id=5612) - Change free text fields not working correct in Firefox.
 - 2010-08-11 Fixed bug#[5652](http://bugs.otrs.org/show_bug.cgi?id=5652) - Can't select Service and SLA when creating new
     tickets.
 - 2010-08-11 Fixed bug#[5669](http://bugs.otrs.org/show_bug.cgi?id=5669) - The customer panel login shows "Request new password"
     on FF 3.5.
 - 2010-08-11 Fixed bug#[5689](http://bugs.otrs.org/show_bug.cgi?id=5689) - The body of the response message is incomplete.
 - 2010-08-11 Fixed bug#[5650](http://bugs.otrs.org/show_bug.cgi?id=5650) - Height of the article list is not retained.
 - 2010-08-11 Fixed bug#[5684](http://bugs.otrs.org/show_bug.cgi?id=5684) - Drag&Drop in agent dashboard is not working
    with IE7.
 - 2010-08-10 Fixed bug#[5579](http://bugs.otrs.org/show_bug.cgi?id=5579) - Spaces in filenames are converted to + characters
    when downloading in IE.
 - 2010-08-10 Fixed bug#[5701](http://bugs.otrs.org/show_bug.cgi?id=5701) - Tarball includes empty directories.
 - 2010-08-10 Fixed bug#[5255](http://bugs.otrs.org/show_bug.cgi?id=5255) - Accessibility: "ALL" link when selecting an owner
 - 2010-08-10 Fixed bug#[5694](http://bugs.otrs.org/show_bug.cgi?id=5694) - Images in web based installer are not displayed
    when performing installation from source.
 - 2010-08-09 Fixed bug#[5661](http://bugs.otrs.org/show_bug.cgi?id=5661) - In Global Ticket Overview, with IE7 and L-Mode,
    Hover of first Ticket overlaps Action Row Area.
 - 2010-08-09 Fixed bug#[5633](http://bugs.otrs.org/show_bug.cgi?id=5633) - Customer user information is not shown in
    ticket zoom if it was set by AgentTicketCustomer.
 - 2010-08-06 Fixed bug#[5676](http://bugs.otrs.org/show_bug.cgi?id=5676) - Ticket Free Time selection in customer panel is
    broken, because wrong "for" statement inside Label.
 - 2010-08-06 Fixed bug#[5691](http://bugs.otrs.org/show_bug.cgi?id=5691) - Not possbible for a package to modify a file
    that belongs to another package.
 - 2010-08-06 Fixed bug#[5690](http://bugs.otrs.org/show_bug.cgi?id=5690) - In AgentTicketZoom, "reset filter" is not
    taken over for next login.
 - 2010-08-06 Fixed bug#[5659](http://bugs.otrs.org/show_bug.cgi?id=5659) - In Global Ticket Overview, Small View,
    "FROM/SUBJECT" is problematically to read. now it reads "FROM / SUBJECT".
 - 2010-08-06 Fixed bug#[5628](http://bugs.otrs.org/show_bug.cgi?id=5628) - In new Ticket Search, the attribute
    TicketCreateTime, wording is wrong + Checkbox is not longer needed.
 - 2010-08-06 Fixed bug#[5645](http://bugs.otrs.org/show_bug.cgi?id=5645) - Changing the ticket search options does not
    work.
 - 2010-08-06 Fixed bug#[5627](http://bugs.otrs.org/show_bug.cgi?id=5627) - "Fulltext" attribute in new ticket search
    feature is missing for initial use.
 - 2010-08-06 Fixed bug#[5663](http://bugs.otrs.org/show_bug.cgi?id=5663) - In Global Ticket Overview, in M+L Mode, orange
    hyper links are not shown on hover a record.
 - 2010-08-05 Fixed bug#[5670](http://bugs.otrs.org/show_bug.cgi?id=5670) - In Agent Interface, e. g. note action, you can
    select a file, which is uploaded automatically. This is not working in
    customer panel.
 - 2010-08-05 Fixed bug#[5625](http://bugs.otrs.org/show_bug.cgi?id=5625) - Article Zoom Screen -\> New Message Indicator
    is not removed after clicking on an article item.
 - 2010-08-05 Fixed bug#[5671](http://bugs.otrs.org/show_bug.cgi?id=5671) - In Customer Panel, there are not used links in
    footer (FAQ, Help, ...).
 - 2010-08-05 Fixed bug#[5635](http://bugs.otrs.org/show_bug.cgi?id=5635) - It's not possible to open Ticket Search feature
    in own browser tab.
 - 2010-08-02 Fixed bug#[2774](http://bugs.otrs.org/show_bug.cgi?id=2774) - Added sha1 and sha2 for additional auth method.
    Now otrs is able to crypt passwords using sha-1 and sha-256 for users and
    customer using DB backend.

#3.0.0 beta1 2010-08-02
 - 2010-07-30 Fixed bug#[5361](http://bugs.otrs.org/show_bug.cgi?id=5361) - Wrong link detection, because regexp looking for url
   like "www.exam.com" and needed "xwww.exam.com", added unit test.
 - 2010-07-28 Added new sysconfig validation module layer to verify and auto-correct
    some sysconfig settings.
 - 2010-07-21 Fixed bug#[5566](http://bugs.otrs.org/show_bug.cgi?id=5566) - StateDefault, PriorityDefault and ArticleTypeDefault
    not working in AgentTicketNote and other frontend modules.
 - 2010-07-20 Fixed bug#[4483](http://bugs.otrs.org/show_bug.cgi?id=4483) - AgentTicketActionCommon, set radio button when select
    old/ new owner are selected.
 - 2010-07-19 Fixed bug#[5563](http://bugs.otrs.org/show_bug.cgi?id=5563) - Static statistic file StateAction is overwritten
    by an older version.
 - 2010-07-16 Removed support for the deprecated DTL commands \<dtl if\>, \<dtl set\>
    and \<dtl system-call\>. They were deprecated since OTRS 2.2.
 - 2010-07-15 Fixed bug#[5416](http://bugs.otrs.org/show_bug.cgi?id=5416) - AgentTicketMove does not support Pending Date.
 - 2010-07-15 Fixed bug#[5556](http://bugs.otrs.org/show_bug.cgi?id=5556) - Broken unicode chars in CustomerUser selections.
 - 2010-07-14 Fixed bug#[5132](http://bugs.otrs.org/show_bug.cgi?id=5132) - New owner validation always ask to set a owner.
 - 2010-07-14 Fixed bug#[5343](http://bugs.otrs.org/show_bug.cgi?id=5343) - Widespread typo in Agent-/CustomerPreferences - replaced "Activ"
                for "Active".
 - 2010-07-13 Fixed bug#[5550](http://bugs.otrs.org/show_bug.cgi?id=5550) - Broken linebreaks in textareas of Google Chrome.
 - 2010-07-09 Fixed bug#[5545](http://bugs.otrs.org/show_bug.cgi?id=5545) - LIKE pattern must not end with escape character.
 - 2010-07-09 Fixed bug#[5494](http://bugs.otrs.org/show_bug.cgi?id=5494) - Handle attachments with java script.
 - 2010-07-09 Fixed bug#[5544](http://bugs.otrs.org/show_bug.cgi?id=5544) - Wrong handling of underscore in LIKE
    search with oracle.
 - 2010-07-06 Removed AgentLookup (was not used in OTRS framework itself
     and is not state of the art of dealing with dynamic data any more).
 - 2010-07-01 Streamlined messages in AgentTicketBulk.
 - 2010-07-01 Added option to ticket bulk action to define if tickets for bulk
    action need to get locked for current agent or not.
     o Config Name: Ticket::Frontend::AgentTicketBulk###RequiredLock
    Thanks to Jeroen van Meeuwen!
 - 2010-06-22 Improved otrs.CheckModules.pl script.
 - 2010-06-22 Updated CPAN module Authen::SASL to version 2.15.
 - 2010-06-22 Updated CPAN module Net::IMAP::Simple to version 1.1916.
 - 2010-06-22 Updated CPAN module MIME::Tools to version 5.428.
 - 2010-06-22 Updated CPAN module Net::POP3::SSLWrapper to version 0.04.
 - 2010-06-22 Updated CPAN module XML::Parser to version 0.712.
 - 2010-06-22 Updated CPAN module Text::CSV to version 1.18.
 - 2010-06-18 Updated CPAN module JSON::PP to version 2.21
 - 2010-06-14 New DirectoryRead Function to read filenames with Unicode::Normalize
 - 2010-06-09 Fixed bug#[5447](http://bugs.otrs.org/show_bug.cgi?id=5447) - Added SMTP TLS support, to send out emails via
    mail servers (MS Exchange!) that require this.
 - 2010-06-02 Fixed bug#[5426](http://bugs.otrs.org/show_bug.cgi?id=5426) - Can't set timezone for customer users.
 - 2010-05-28 Fixed bug#[5262](http://bugs.otrs.org/show_bug.cgi?id=5262) - Sort by "pending time" includes ticket with no
    pending state.
 - 2010-05-28 Added option to use TicketPendingTimeSet() to null out the
    Pending Time, similar to the implementation for TicketFreeTimeSet().
 - 2010-05-21 Fixed bug#[4459](http://bugs.otrs.org/show_bug.cgi?id=4459) - Two related error messages in S/MIME if you
    call it and it's disabled, and one message is enough.
 - 2010-05-21 Fixed bug#[5377](http://bugs.otrs.org/show_bug.cgi?id=5377) - Show all users in AdminUser as a default.
 - 2010-05-20 Fixed bug#[1846](http://bugs.otrs.org/show_bug.cgi?id=1846) - AdminCustomerUserGroup shows all CustomerUsers,
    even if you have thousands of them.
 - 2010-05-20 Fixed bug#[5103](http://bugs.otrs.org/show_bug.cgi?id=5103) - Searching for non-existing company does not
    return "no results found".
 - 2010-05-20 Implemented bug#[1701](http://bugs.otrs.org/show_bug.cgi?id=1701) - In customer's ticket overview, subject
    should come from the first article.
 - 2010-05-20 Fixed bug#[5186](http://bugs.otrs.org/show_bug.cgi?id=5186) - Prepend fwd: instead of re: to the subject of
    forwarded mails.
 - 2010-05-19 Added Groups and Roles support to Event Based Notifications.
    You can now also send a notification to agens in a certain group or role.
 - 2010-05-19 Implemented bug#[4337](http://bugs.otrs.org/show_bug.cgi?id=4337) - Added lock state to ticket search.
 - 2010-05-19 Reworked Kernel::System::Ticket API to have more intuitive
    wording (is still compat. to OTRS 1.x and 2.x).
    CustomerPermission()  -\> TicketCustomerPermission()
    InvolvedAgents()      -\> TicketInvolvedAgentsList()
    LockIsTicketLocked()  -\> TicketLockGet()
    LockSet()             -\> TicketLockSet()
    MoveList()            -\> TicketMoveList()
    MoveTicket()          -\> TicketQueueSet()
    MoveQueueList()       -\> TicketMoveQueueList()
    OwnerList()           -\> TicketOwnerList()
    OwnerSet()            -\> TicketOwnerSet()
    Permission()          -\> TicketPermission()
    PriorityList()        -\> TicketPriorityList()
    PrioritySet()         -\> TicketPrioritySet()
    ResponsibleList()     -\> TicketResponsibleList()
    ResponsibleSet()      -\> TicketResponsibleSet()
    SetCustomerData()     -\> TicketCustomerSet()
    StateList()           -\> TicketStateList()
    StateSet()            -\> TicketStateSet()
 - 2010-05-14 Fixed bug#[4199](http://bugs.otrs.org/show_bug.cgi?id=4199) - Hard limit of 200 services defined in front-end files.
 - 2010-05-12 Renamed core module 'Kernel/System/StdResponse.pm' to 'Kernel/System/StandardResponse.pm'.
 - 2010-05-12 Fixed bug#[4940](http://bugs.otrs.org/show_bug.cgi?id=4940) - SQL Improvement, deleted not needed GROUP BY statement.
 - 2010-05-07 Fixed bug#[5005](http://bugs.otrs.org/show_bug.cgi?id=5005) - 'Statuses' is not correct in British English.
 - 2010-05-06 Implemented bug#[3516](http://bugs.otrs.org/show_bug.cgi?id=3516) - added CustomerGroupSupport feature for
    customer navigation bar. Kudos Martin Balzarek.
 - 2010-05-04 Fixed bug#[5249](http://bugs.otrs.org/show_bug.cgi?id=5249) - ArticleStorageFS should not die on failed rm.
    Kudos Dominik Schulz.
 - 2010-04-30 Make it possible to use a version argument with bin/otrs.PackageManager.pl.
 - 2010-04-19 Improved bin/otrs.CreateTranslationFile.pl to get also
    translatable strings from sys config settings for translation catalog.
 - 2010-04-09 Added the feature to save searches in the Customer Frontend
 - 2010-04-08 Implemented fix for bug#[2673](http://bugs.otrs.org/show_bug.cgi?id=2673) -  Ticket subject lines in customer
    frontend can be confusing.
 - 2010-04-07 Fixed bug#[5118](http://bugs.otrs.org/show_bug.cgi?id=5118) - Printing an article should indicate that
    only 1 article is printed not the whole ticket.
 - 2010-04-06 made command line scripts consistent. They now all
     have the format 'otrs.DoThis.pl'. Also, SetPermissions.sh is removed
     because we already have otrs.SetPermissions.pl.
    otrs.mkStats.pl                 -\>  otrs.GenerateStats.pl
    otrs.addGroup.pl                -\>  otrs.AddGroup.pl
    otrs.addQueue.pl                -\>  otrs.AddQueue.pl
    otrs.addRole.pl                 -\>  otrs.AddRole.pl
    otrs.addRole2Group.pl           -\>  otrs.AddRole2Group.pl
    otrs.addUser.pl                 -\>  otrs.AddUser.pl
    otrs.addUser2Group.pl           -\>  otrs.AddUser2Group.pl
    otrs.addUser2Role.pl            -\>  otrs.AddUser2Role.pl
    otrs.checkModules.pl            -\>  otrs.CheckModules.pl
    otrs.CreateNewTranslationFile.pl-\>  otrs.CreateTranslationFile.pl
    otrs.getConfig.pl               -\>  otrs.GetConfig.pl
    otrs.getTicketThread.pl         -\>  otrs.GetTicketThread.pl
    otrs.setPassword.pl             -\>  otrs.SetPassword.pl
    otrs.StatsExportToOPM.pl        -\>  otrs.ExportStatsToOPM.pl
    opm.pl                          -\>  otrs.PackageManager.pl
 - 2010-03-24 Reworked Kernel::System::Encode API to have more intuitive
    wording (is still compat. to OTRS 1.x and 2.x).
    EncodeInternalUsed() -\> CharsetInternal()
    Encode()             -\> EncodeInput()
    Decode()             -\> Convert2CharsetInternal()
 - 2010-03-24 Fixed bug#[5130](http://bugs.otrs.org/show_bug.cgi?id=5130) - Incorrect check for 'NoOutOfOffice' in
    GetUserData().
 - 2010-03-22 Fixed bug#[5161](http://bugs.otrs.org/show_bug.cgi?id=5161) - Envelope-To Header gets ignored for email
    dispatching.
 - 2010-03-18 Fixed bug#[5060](http://bugs.otrs.org/show_bug.cgi?id=5060) - Get email notification for tickets created by
    myself (new feature).
 - 2010-03-18 Updated CPAN module Text::CSV to version 1.17.
 - 2010-03-18 Updated CPAN module MailTools to version 2.06.
 - 2010-03-18 Updated CPAN module CGI to version 3.49.
 - 2010-03-18 Updated CPAN module Net::IMAP::Simple to version 1.1911.
 - 2010-03-11 Upgraded CKEditor from version 3.1 to version 3.2.
 - 2010-03-09 Fixed bug#[4996](http://bugs.otrs.org/show_bug.cgi?id=4996) - Rich Text Editor does not display in the Customer
    Frontend in IE8.
 - 2010-03-08 Fixed bug#[5085](http://bugs.otrs.org/show_bug.cgi?id=5085) - Wrong colours codes in Stats::Graph::dclrs.
 - 2010-03-08 Fixed bug#[5097](http://bugs.otrs.org/show_bug.cgi?id=5097) - AdminNotificationEvent does not display values
    on Change.
 - 2010-02-26 Fixed bug#[4874](http://bugs.otrs.org/show_bug.cgi?id=4874) - LDAP connection even if it is not needed.
    Moved to "Die =\> 0" as default value if no connection to customer ldap
    source was possible.
 - 2010-02-23 Fixed bug#[4957](http://bugs.otrs.org/show_bug.cgi?id=4957) - Password Change dialog misses "Current Password"
    option.
 - 2010-02-22 Fixed bug#[5020](http://bugs.otrs.org/show_bug.cgi?id=5020) - Framework version for stats export is outdated.
 - 2010-02-21 Extended QueryCondition() of Kernel::System::DB to allow
    also "some praise" expression as "some&&praise", to be compat. just add
    "Extended =\> 1" to QueryCondition(). Short summary:
        some praise   -\> search for "some" and "praise" in a text (order of words
                         is not importand)
        "some praise" -\> search for "some praise" in a text as one string
 - 2010-02-16 Extended QueryCondition() of Kernel::System::DB to allow
    also "some praise" expression for search conditions to search this string
    1:1 in database.
 - 2010-02-15 Added "New Article" feature. Shows any agent in dashboard and
    global ticket overviews if there is a new article in a ticket which is not
    seen (like unread feature in email clients).
    Notice: Use scripts/DBUpdate-to-2.5.\*.sql for upgrading!
 - 2010-02-15 Removed example config files for Apache1, switched to only
    one config file for Apache2 instead of two.
 - 2010-02-15 Fixed bug#[4924](http://bugs.otrs.org/show_bug.cgi?id=4924) - Incorrect email address syntax check.
 - 2010-02-10 Fixed bug#[2376](http://bugs.otrs.org/show_bug.cgi?id=2376) - Customer preferences are lost after update
    of customer login.
 - 2010-02-10 Fixed bug#[4828](http://bugs.otrs.org/show_bug.cgi?id=4828) - In SysConfig, changed "Registration" to
    "Registrierung" in German description.
 - 2010-02-07 Fixed bug#[4918](http://bugs.otrs.org/show_bug.cgi?id=4918) - Delete only expired cache items by using
    e. g. "bin/otrs.CacheDelete.pl --expired".
 - 2010-02-01 Added Kernel::System::Cache::FileStorable backend module for
    Kernel::System::Cache which is working with binary for dump and eval of
    perl data structures (a little bit faster the dump/eval in pure perl).
    Perl's Storable module is included in perl distibution it self.
 - 2010-01-26 IPC session backend (Kernel::System::AuthSession::IPC) is not
    longer supported. Increased performance of DB and FS backend (only sync
    session data to storage at end of a session).
 - 2010-01-25 Added agent preferences for max. shown tickets a page in
    ticket overviews.
 - 2010-01-19 Added security feature enhancement to block active elements
    and external images as auto load of html articles in zoom view (agent
    and customer interface).
 - 2010-01-15 Fixed bug#[4651](http://bugs.otrs.org/show_bug.cgi?id=4651) - Dashboard upcoming events does not look up
    statetypes for Pending Reminder.
 - 2010-01-14 Removed not needed tool scripts/sync\_node.sh.
 - 2010-01-13 Added ticket fulltext search to dashboard.
 - 2010-01-06 Added dashboard widget for displaying external content via iframe.
 - 2009-12-31 Added cpan module for JSON support (version 2.16), removed JSON
    function from LayoutAJAX and changed all function calls to the new JSON
    wrapper.
 - 2009-12-24 Themes are now stored in SysConfig under Frontend::Themes rather
    than in the database. This to enable administrators to add a new theme by
    just modifying SysConfig instead of having to use mysql or isql or so.
 - 2009-12-23 Renamed inconsistent module name Kernel::System::Config to
    Kernel::System::SysConfig.
 - 2009-12-23 Added support for multiple Kernel::System::Ticket::Custom
    backends. Can now be defined via config key 'Ticket::CustomModule', e. g.
```
<ConfigItem Name="Ticket::CustomModule###001-CustomModule" Required="0" Valid="0">
   <Description Lang="en">A module with custom functions to redefine ....</Description>
   <Description Lang="de">Ein Modul mit angepassten Funktionen das ...</Description>
   <Group>Ticket</Group>
   <SubGroup>Core::Ticket</SubGroup>
   <Setting>
      <String Regex="">Kernel::System::Ticket::Custom</String>
   </Setting>
</ConfigItem>
```
 - 2009-12-21 Added the ability to hide the Queue, SLA and/or Service in
    the Customer interface.
 - 2009-12-15 Changed rich text editor from FCKEditor 2.6.4.1 to CKEditor 3.0.1
 - 2009-12-14 Fixed bug#[4660](http://bugs.otrs.org/show_bug.cgi?id=4660) - Admin Notification module does not send mail
    to customer users in groups.
 - 2009-12-14 Added the ability to use AdminEmail to send notifications based
    on roles.
 - 2009-12-14 Updated SysConfig to make sure OTRS toolbars and Admin section uses
    plural in interface where appropriate.
 - 2009-12-11 Replaced all OptionStrgHashRef() with the newer BuildSelection().
 - 2009-12-09 Added archive feature to improve performance.
 - 2009-12-09 Updated CPAN module Text::CSV to version 1.16.
 - 2009-12-08 Fixed bug#[4570](http://bugs.otrs.org/show_bug.cgi?id=4570) - Not processed attachment on incoming email
    (value too long for type).
    Increased varchar of article\_attachment.content\_type from 250 to 450.
 - 2009-12-08 Fixed bug#[1698](http://bugs.otrs.org/show_bug.cgi?id=1698) - Send emails with the real name from the agent.
 - 2009-12-08 Fixed bug#[2153](http://bugs.otrs.org/show_bug.cgi?id=2153) - Recognize domain names only if they are words.
 - 2009-12-08 Fixed bug#[4399](http://bugs.otrs.org/show_bug.cgi?id=4399) - Phone- / Email-Ticket AJAX reload does not
    consider ACL in Kernel/Config.pm.
 - 2009-12-08 Fixed bug#[4330](http://bugs.otrs.org/show_bug.cgi?id=4330) - Added new history-get results.
 - 2009-12-07 Fixed bug#[3887](http://bugs.otrs.org/show_bug.cgi?id=3887) - Processing headers with faulty charset definitions.
 - 2009-12-04 Removed OptionElement() from Layout.pm. Use BuildSelection()
    instead.
 - 2009-12-04 Changed line chart library again: from OFC to Flot.
 - 2009-12-02 Completely removed YUI from the OTRS code.
 - 2009-12-02 Switched line chart on the dashboard from YUI to OFC.
 - 2009-11-27 Updated CPAN module XML::Parser::Lite to version 0.710.10.
 - 2009-11-27 Updated CPAN module XML::TreePP to version 0.39.
 - 2009-11-27 Updated CPAN module XML::FeedPP to version 0.41.
 - 2009-11-27 Updated CPAN module Text::Diff to version 1.37.
 - 2009-11-27 Updated CPAN module Text::CSV to version 1.15.
 - 2009-11-27 Updated CPAN module Authen::SASL to version 2.13.
 - 2009-11-27 Changed directory structure for thirdparty javascript modules.
 - 2009-11-27 Switched AutoCompletion and Dialog from YUI to jQuery.
 - 2009-11-25 Switched to XHTML doctype
    - not all of the generated HTML is valid yet, but much
    - from now on, ";" will be used as a query parameter separator in URLs
        (old: index.pl?Action=AgentExample&Subaction=Test,
        new: index.pl?Action=AgentExample;Subaction=Test)
    - made some self-closing tags actually close themselves (e.g. \<img .../\>)
    - made some tags and attributes used lowercase
 - 2009-11-25 Updated CPAN module CGI to version 3.48.
 - 2009-11-23 Only database configuration is now saved in Config.pm.
 - 2009-11-18 Added database check and mail configuration steps
    to the web installer.
 - 2009-11-12 Fixed bug#[4509](http://bugs.otrs.org/show_bug.cgi?id=4509) - Notification (event based) comments are not
    saved.
 - 2009-11-11 Added feature/config option (Ticket::SubjectFormat) for subject
    format.
     o 'Left'  means '[TicketHook#:12345] Some Subject',
     o 'Right' means 'Some Subject [TicketHook#:12345]',
     o 'None'  means 'Some Subject' (without any ticket number ins subject).

    In the last case you should enable PostmasterFollowupSearchInRaw or
    PostmasterFollowUpSearchInReferences to recognize followups based on email
    headers and/or body.
    Wrote also unit tests to take care of functionality.
 - 2009-11-11 Moved from prototype js to jQuery
    (removed var/httpd/htdocs/js/prototype.js added
    var/httpd/htdocs/js/jquery-1.3.2.min.js).
 - 2009-11-03 Renamed some files in the bin/ directory
    CheckSum.pl                     -\>  otrs.CheckSum.pl
    CleanUp.pl                      -\>  otrs.CleanUp.pl
    Cron4Win32.pl                   -\>  otrs.Cron4Win32.pl
    CryptPassword.pl                -\>  otrs.CryptPassword.pl
    DeleteSessionIDs.pl             -\>  otrs.DeleteSessionIDs.pl
    GenericAgent.pl                 -\>  otrs.GenericAgent.pl
    mkStats.pl                      -\>  otrs.mkStats.pl
    otrs.addGroup                   -\>  otrs.addGroup.pl
    otrs.addQueue                   -\>  otrs.addQueue.pl
    otrs.addRole                    -\>  otrs.addRole.pl
    otrs.addRole2Group              -\>  otrs.addRole2Group.pl
    otrs.addUser                    -\>  otrs.addUser.pl
    otrs.addUser2Group              -\>  otrs.addUser2Group.pl
    otrs.addUser2Role               -\>  otrs.addUser2Role.pl
    otrs.checkModules               -\>  otrs.checkModules.pl
    otrs.CreateNewTranslationFile   -\>  otrs.CreateNewTranslationFile.pl
    otrs.getConfig                  -\>  otrs.getConfig.pl
    otrs.getTicketThread            -\>  otrs.getTicketThread.pl
    otrs.setPassword                -\>  otrs.setPassword.pl
    PendingJobs.pl                  -\>  otrs.PendingJobs.pl
    PostMaster.pl                   -\>  otrs.PostMaster.pl
    PostMasterClient.pl             -\>  otrs.PostMasterClient.pl
    PostMasterDaemon.pl             -\>  otrs.PostMasterDaemon.pl
    PostMasterMailbox.pl            -\>  otrs.PostMasterMailbox.pl
    PostMasterPOP3.pl               -\>  otrs.PostMasterPOP3.pl
    RebuildTicketIndex.pl           -\>  otrs.RebuildTicketIndex.pl
    SetPermissions.pl               -\>  otrs.SetPermissions.pl
    StatsExportToOPM.pl             -\>  otrs.StatsExportToOPM.pl
    UnitTest.pl                     -\>  otrs.UnitTest.pl
    UnlockTickets.pl                -\>  otrs.UnlockTickets.pl
    xml2sql.pl                      -\>  otrs.xml2sql.pl
    XMLMaster.pl                    -\>  otrs.XMLMaster.pl
 - 2009-10-26 Added CGI.pm back to packaged versions (auto\_build.sh).
 - 2009-10-14 Pending Date of tickets can be max. 1 year in the future.
 - 2009-10-14 Fixed bug#[1731](http://bugs.otrs.org/show_bug.cgi?id=1731) - Show last login time of agent and customer
    management.
 - 2009-10-12 TTL in Kernel::System::Cache::Set required but not checked.
 - 2009-10-12 Removed check on AttachmentDelete1 in function in
    AgentTicketMove.dtl.
 - 2009-10-12 AgentTicketOverviewPreview.dtl: superfluous hidden parameter
    'QueueID'.
 - 2009-10-07 Added global Search-Condition-Feature (AND/OR/()/!/+) for
    TicketNumber, From, To, Cc, Subject and Body also to generic agent.
 - 2009-10-05 Fixed bug#[939](http://bugs.otrs.org/show_bug.cgi?id=939) - "Salutation" should be renamed to "Title" for
    users and customer users.
    Notice: Use scripts/DBUpdate-to-2.5.\*.sql for upgrading!
 - 2009-10-02 Fixed bug#[4379](http://bugs.otrs.org/show_bug.cgi?id=4379) - Array parameters not working in mkStats.pl
 - 2009-09-23 Added virtual file system object for global file storage as
    Kernel::System::VirtualFS with FS and DB backends.
    Notice: Use scripts/DBUpdate-to-2.5.\*.sql for upgrading!
 - 2009-09-22 Fixed bug#[1774](http://bugs.otrs.org/show_bug.cgi?id=1774) - Updated documentation in AdminQueue.dtl.
 - 2009-09-22 Fixed bug#[4100](http://bugs.otrs.org/show_bug.cgi?id=4100) - ArticleFreeText Default Value not working.
 - 2009-09-22 Fixed bug#[1027](http://bugs.otrs.org/show_bug.cgi?id=1027) - Ticket csv export in customer interface incomplete.
 - 2009-09-21 Fixed bug#[4218](http://bugs.otrs.org/show_bug.cgi?id=4218) - No error message when sending mail through not
    installed sendmail.
 - 2009-09-21 Fixed bug#[4312](http://bugs.otrs.org/show_bug.cgi?id=4312) - MOTD module for Agent Dashboard, thanks to
    Alexander Scholler!
 - 2009-09-21 Fixed bug#[3978](http://bugs.otrs.org/show_bug.cgi?id=3978) - Better description for PGP passphrases.
 - 2009-09-16 Fixed bug#[3932](http://bugs.otrs.org/show_bug.cgi?id=3932) - Translation enhancements for AdminSession.dtl.
 - 2009-09-16 Fixed bug#[2786](http://bugs.otrs.org/show_bug.cgi?id=2786) - Wrong text labels
    AdminSystemAddressForm.dtl.
 - 2009-09-16 Fixed bug#[4288](http://bugs.otrs.org/show_bug.cgi?id=4288) - Use of uninitialized value in
    AdminGenericAgent.pm.
 - 2009-09-16 Moved to global event handler Kernel/System/EventHander.pm
    for ticket events (config is compatble with old one).
 - 2009-09-15 Improved performance of the PDF backend.

#2.4.11 (????/??/??)
 - 2011-04-07 Fixed bug#[7195](http://bugs.otrs.org/show_bug.cgi?id=7195) - Graphs doesn't use GIF as fallback if PNG is not available.

#2.4.10 (2011/04/12)
 - 2011-04-04 Fixed bug#[7140](http://bugs.otrs.org/show_bug.cgi?id=7140) - Attachments with percent symbol not working.
 - 2011-03-23 Updated Brazilian Portugese translation, thanks to Murilo Moreira de Oliveira!
 - 2011-03-18 Added required settings for oracle databases in apache2-httpd-new.include.conf.
 - 2011-03-07 Fixed bug#[6014](http://bugs.otrs.org/show_bug.cgi?id=6014) - Printed pdf tickets are not searchable.
 - 2011-02-17 Fixed bug#[6906](http://bugs.otrs.org/show_bug.cgi?id=6906) - Vendor URL points to Basename+URL instead of URL.
 - 2011-01-25 Event Based notification - respect "Include Attachments
    to Notification".
 - 2010-12-17 Fixed bug#[6510](http://bugs.otrs.org/show_bug.cgi?id=6510) - Signature ID missing.
 - 2010-12-14 Fixed bug#[6532](http://bugs.otrs.org/show_bug.cgi?id=6532) - With multiple inline images, only first one is
    preserved when replying.
 - 2010-12-13 Fixed bug#[6520](http://bugs.otrs.org/show_bug.cgi?id=6520) - backup.pl doesn't backup with strong password.
 - 2010-12-09 Fixed bug#[6488](http://bugs.otrs.org/show_bug.cgi?id=6488) - otrs.ArticleStorageSwitch.pl creating wrong files.
 - 2010-12-09 Fixed bug#[3984](http://bugs.otrs.org/show_bug.cgi?id=3984) - HTML Notifications - Links to ticketsystem are not clickable.
 - 2010-12-02 Fixed bug#[6366](http://bugs.otrs.org/show_bug.cgi?id=6366) - gnupg signatures not working correct for partly signed messages.
 - 2010-11-29 Fixed bug#[5981](http://bugs.otrs.org/show_bug.cgi?id=5981) - Warnings from TransfromDateSelection() in AgentTicketMove.
 - 2010-11-23 Fixed bug#[6131](http://bugs.otrs.org/show_bug.cgi?id=6131) - Lack of warning for revoked and expired PGP keys in email compose screens.
 - 2010-11-04 Fixed bug#[6211](http://bugs.otrs.org/show_bug.cgi?id=6211) - Wrong TicketFreeText-value in ticket creation by
    using event notifications.
 - 2010-11-02 Email.ticket: wrong signature is shown.
 - 2010-10-26 Improved German translation, thanks to Stelios Gikas!
 - 2010-10-13 Fixed some Perl "uninitialized value" warnings.
 - 2010-10-12 Fixed bug#[6087](http://bugs.otrs.org/show_bug.cgi?id=6087) - Search template name is broken if & or ; is used.

#2.4.9 (2010/10/25)
 - 2010-09-30 Fixed bug#[6016](http://bugs.otrs.org/show_bug.cgi?id=6016) - AgentTicketZoom is vunerable to XSS attacks from HTML e-mails.
 - 2010-09-22 Fixed bug#[5903](http://bugs.otrs.org/show_bug.cgi?id=5903) - E-mail notification links don't contain \<a href... tags.
 - 2010-09-29 Fixed bug#[6030](http://bugs.otrs.org/show_bug.cgi?id=6030) - Event notifications are fired several times on
    event "TicketFreeTextUpdate".
 - 2010-09-14 Fixed bug#[5541](http://bugs.otrs.org/show_bug.cgi?id=5541) - Dashboard Chart generates error in webserver log.
 - 2010-09-09 Fixed bug#[5462](http://bugs.otrs.org/show_bug.cgi?id=5462) - Kernel::System::Ticket::TicketEscalationIndexBuild()
    does not invalidate the cache.
 - 2010-08-27 Fixed bug#[5667](http://bugs.otrs.org/show_bug.cgi?id=5667) - Rich Text is not working in ipad. It's not
    possible to add a note or close a ticket.
 - 2010-08-25 Fixed bug#[5266](http://bugs.otrs.org/show_bug.cgi?id=5266) - Ticket Zoom shows wrong html content if there
    is no text but two html attachments in there.

#2.4.8 (2010/09/15)
 - 2010-08-24 Applied change suggested in bug#[5733](http://bugs.otrs.org/show_bug.cgi?id=5733). $Text should be dereferenced while counting its length.
 - 2010-08-18 Fixed bug#[5444](http://bugs.otrs.org/show_bug.cgi?id=5444) - TicketZoom mask vulnerable to XSS.
 - 2010-08-09 Fixed bug#[5698](http://bugs.otrs.org/show_bug.cgi?id=5698) - Ticket Assignment includes '(' character.
 - 2010-07-20 Fixed bug#[4483](http://bugs.otrs.org/show_bug.cgi?id=4483) - AgentTicketActions, set radio button when select
    old/ new owner are selected, fix wrong javascript behavior.
 - 2010-07-15 Fixed bug#[5416](http://bugs.otrs.org/show_bug.cgi?id=5416) - AgentTicketMove does not support Pending Date.
 - 2010-07-15 Fixed bug#[5556](http://bugs.otrs.org/show_bug.cgi?id=5556) - Broken unicode chars in CustomerUser selections.
 - 2010-07-14 Fixed bug#[5132](http://bugs.otrs.org/show_bug.cgi?id=5132) - New owner validation always ask to set a owner.
 - 2010-07-13 Fixed bug#[5210](http://bugs.otrs.org/show_bug.cgi?id=5210) - LinkQuote consumes all CPU memory when processing a
    large amount of data.
 - 2010-07-13 Fixed bug#[5550](http://bugs.otrs.org/show_bug.cgi?id=5550) - Broken linebreaks in textareas of Google Chrome.
 - 2010-07-07 Fixed bug#[5541](http://bugs.otrs.org/show_bug.cgi?id=5541) - Dashboard Chart generates error in webserver log.
 - 2010-07-01 Fixed bug#[5512](http://bugs.otrs.org/show_bug.cgi?id=5512) - Bulk Action No Access is displayed incorrectly.
 - 2010-06-25 Updated Danish translation, thanks to Jesper Rï¿½nnov,
    Faaborg-Midtfyn Kommune!
 - 2010-06-24 Fixed bug#[5445](http://bugs.otrs.org/show_bug.cgi?id=5445) - Reflected XSS vulnerability.
 - 2010-06-16 Fixed bug#[5488](http://bugs.otrs.org/show_bug.cgi?id=5488) - AutoPriorityIncrease runs into failures.
 - 2010-06-16 Fixed bug#[5478](http://bugs.otrs.org/show_bug.cgi?id=5478) - Web Installer has 'editable' license text.
 - 2010-05-31 Fixed bug#[5385](http://bugs.otrs.org/show_bug.cgi?id=5385) - Queue name is not used in signature on ticket
    creation.
 - 2010-05-28 Fixed bug#[5235](http://bugs.otrs.org/show_bug.cgi?id=5235) - Link in response not shown as link.
 - 2010-05-28 Added PNG version of data model in doc directory.
 - 2010-05-28 Fixed bug#[5395](http://bugs.otrs.org/show_bug.cgi?id=5395) - Function $LanguageObject-\>Time() can't process
    seconds.
 - 2010-05-07 Fixed bug#[5336](http://bugs.otrs.org/show_bug.cgi?id=5336) - Also set execute bit on scripts/tools.
 - 2010-04-30 Make it possible to use a version argument with bin/opm.pl.
 - 2010-04-21 Fixed bug#[5266](http://bugs.otrs.org/show_bug.cgi?id=5266) - Ticket Zoom shows wrong html content if there
    is no text but two html attachments in there.
 - 2010-04-15 Fixed bug#[5242](http://bugs.otrs.org/show_bug.cgi?id=5242) - Newlines are not displayed in html notification
    mails on Lotus Notes
 - 2010-04-14 Fixed bug#[4999](http://bugs.otrs.org/show_bug.cgi?id=4999) - Cache of customer user is not refreshed after
    a preference is updated.
 - 2010-04-13 Fixed bug#[5152](http://bugs.otrs.org/show_bug.cgi?id=5152) - responsible\_user\_id in ticket table is wrong in
    otrs-database.dia.
 - 2010-04-12 Fixed bug#[5108](http://bugs.otrs.org/show_bug.cgi?id=5108) - The RSS date was not displayed correctly.
 - 2010-04-12 Fixed bug#[5112](http://bugs.otrs.org/show_bug.cgi?id=5112) - Redirecting to a valid screen after unsubscribing a ticket
    that is on a queue in which the agent has no permissions.
 - 2010-04-06 Fixed bug#[4986](http://bugs.otrs.org/show_bug.cgi?id=4986) - There is no activate/deactivate check for Graphsize menu,
    when page loads in Stats Definition
 - 2010-04-01 Fixed bug#[4786](http://bugs.otrs.org/show_bug.cgi?id=4786) - AgentTicketCompose ONLY: Defining a next state,
    then adding and attachment, resets the next state upon screen refresh.
 - 2010-03-29 Improved handling of the StateType attribute of
    StateGetStatesByType() in Kernel/System/State.pm.
 - 2010-03-24 Fixed bug#[5164](http://bugs.otrs.org/show_bug.cgi?id=5164) - Pending time not working if agent as an other
    timezone.
 - 2010-03-19 Fixed bug#[5094](http://bugs.otrs.org/show_bug.cgi?id=5094) - Bulk pending date/time do not get applied to
    tickets.
 - 2010-03-18 Updated Ukrainian language translation, thanks to Belskii Artem!
 - 2010-03-10 Fixed bug#[4416](http://bugs.otrs.org/show_bug.cgi?id=4416) - Merge: whitespace before ticketnumber not removed.
 - 2010-03-09 Fixed bug#[5102](http://bugs.otrs.org/show_bug.cgi?id=5102) - Notification sent to OTRS instead of Customer.
 - 2010-03-08 Fixed bug#[5085](http://bugs.otrs.org/show_bug.cgi?id=5085) - Wrong colours codes in Stats::Graph::dclrs.
 - 2010-03-02 Updated Czech translation, thanks to O2BS.com, s r.o. Jakub Hanus!
 - 2010-02-26 Fixed bug#[4137](http://bugs.otrs.org/show_bug.cgi?id=4137) - Follow ups to internal forwarded message marked
    as customer reply.
 - 2010-02-23 Updated pt\_BR translation file, thanks to Fabricio Luiz Machado!
 - 2010-02-22 Fixed bug#[5020](http://bugs.otrs.org/show_bug.cgi?id=5020) - Framework version for stats export is outdated.
 - 2010-02-18 Fixed bug#[4969](http://bugs.otrs.org/show_bug.cgi?id=4969) - Event Based Notification: Body Match field displays
    Subject Match value.
 - 2010-02-16 Fixed bug#[4967](http://bugs.otrs.org/show_bug.cgi?id=4967) - Can't locate object method "new" via package
    error when using Perl 5.10.1.
 - 2010-02-15 Fixed bug#[4977](http://bugs.otrs.org/show_bug.cgi?id=4977) - mod\_perl is not used in fedora with RPM.
 - 2010-02-12 Fixed bug#[4936](http://bugs.otrs.org/show_bug.cgi?id=4936) - Kernel::System::Main::FileWrite has race condition.
 - 2010-02-11 Fixed bug#[4442](http://bugs.otrs.org/show_bug.cgi?id=4442) - Customer search fails when there is a space
    in the name.
 - 2010-02-11 Fixed bug#[4822](http://bugs.otrs.org/show_bug.cgi?id=4822) - No fulltext search with more then one word
    for FAQ.
 - 2010-02-10 Fixed bug#[4889](http://bugs.otrs.org/show_bug.cgi?id=4889) - Inline images from Lotus Notes are not
    displayed in ticket zoom.
 - 2010-02-09 Fixed bug#[4658](http://bugs.otrs.org/show_bug.cgi?id=4658) - Cannot delete attachment from AdminAttachment
    interface.

#2.4.7 2010-02-08
 - 2010-02-03 Fixed bug#[4937](http://bugs.otrs.org/show_bug.cgi?id=4937) - Accounted time per article is not displayed
    in PDF print.
 - 2010-02-03 Fixed bug#[4848](http://bugs.otrs.org/show_bug.cgi?id=4848) - Issue with TicketOverView object - does not
    show all tickets when moving through list.
 - 2010-02-02 Fixed issue with migrating Customer Queue notifications to
    Event Based when upgrading OTRS 2.3 \> 2.4.
 - 2010-02-01 Fixed bug#[4393](http://bugs.otrs.org/show_bug.cgi?id=4393) - AgentTicketQueue - Small view takes long to
    load. -\> New solution with own config option for each view mode (S/M/L)
    Admin -\> SysConfig -\> Ticket -\> Frontend::Agent::TicketOverview.
 - 2010-01-25 Fixed bug#[4818](http://bugs.otrs.org/show_bug.cgi?id=4818) - Removed inline image of forwarded message gets
    still included.
 - 2010-01-20 Fixed bug#[4780](http://bugs.otrs.org/show_bug.cgi?id=4780) - Adding groups to a CustomerUser fails,
    adding CustomerUsers to a group works.
 - 2010-01-20 Fixed bug#[4486](http://bugs.otrs.org/show_bug.cgi?id=4486) - Some preferences displayed in AdminUser are not
    correct.
 - 2010-01-18 Fixed bug#[4770](http://bugs.otrs.org/show_bug.cgi?id=4770) - Attachments are stripped/not shown from
    outgoing emails in some scenarios with ms exchange.
 - 2010-01-15 Fixed bug#[4735](http://bugs.otrs.org/show_bug.cgi?id=4735) - TicketFreeTime search in Customer frontend
    does not work as expected
 - 2010-01-15 Fixed bug#[4758](http://bugs.otrs.org/show_bug.cgi?id=4758) - Dashboard RSS feeds doesn't display XML
    encoded entities correctly.
 - 2010-01-13 Fixed bug#[4754](http://bugs.otrs.org/show_bug.cgi?id=4754) - Multiple tickets with a huge POP3 Mailbox
    - more then 2000 email in the box ("Deep recursion on subroutine").
 - 2010-01-13 Fixed bug#[4713](http://bugs.otrs.org/show_bug.cgi?id=4713) - In ticket overview, after adding view=30 - no
    tickets are visible.
 - 2010-01-12 Upgrade of cpan Net::IMAP::Simple from 1.17 to 1.1910.

#2.4.6 2010-01-12
 - 2010-01-11 Fixed bug#[4737](http://bugs.otrs.org/show_bug.cgi?id=4737) - Customer User update fails in 2.4.6 RC.
 - 2010-01-08 Fixed bug#[4730](http://bugs.otrs.org/show_bug.cgi?id=4730) - Unable to open Admin \> Attachments in IE8.
 - 2010-01-07 Fixed bug#[4731](http://bugs.otrs.org/show_bug.cgi?id=4731) - Service and SLA gets translated after AJAX
    reload in Phone an Email Ticket.
 - 2010-01-05 Fixed bug#[4718](http://bugs.otrs.org/show_bug.cgi?id=4718) - LDAP auth not possible with OTRS in iso-8859-1
    and utf-8 ldap directory.
 - 2010-01-05 Fixed bug#[4708](http://bugs.otrs.org/show_bug.cgi?id=4708) - Added ArticleID to output of
    bin/otrs.getTicketThread.
 - 2010-01-04 Fixed bug#[4704](http://bugs.otrs.org/show_bug.cgi?id=4704) - Package Manager: upload install fails with
    "Message: Need ContentType!" with Google Chrome browser.
 - 2009-12-30 Added Ukrainian language translation, thanks to Belskii Artem!
 - 2009-12-30 Fixed bug#[4727](http://bugs.otrs.org/show_bug.cgi?id=4727) - Added proper removal of FormID in
    AgentTicketPhoneOutbound.
 - 2009-12-23 Fixed bug#[3526](http://bugs.otrs.org/show_bug.cgi?id=3526) - Escalation emails are resent over and over again.
 - 2009-12-23 Fixed bug#[4428](http://bugs.otrs.org/show_bug.cgi?id=4428) - PGP-inline signed messages can't be encoded
    correctly with rich text editor.
 - 2009-12-22 Fixed bug#[4690](http://bugs.otrs.org/show_bug.cgi?id=4690) - AdminMailAccount - only 50 characters can be
    entered in username, password and host fields while database can store 200.
 - 2009-12-16 Fixed bug#[4503](http://bugs.otrs.org/show_bug.cgi?id=4503) - Border around image does not display well
    in some email clients.
 - 2009-12-13 Fixed bug#[4393](http://bugs.otrs.org/show_bug.cgi?id=4393) - AgentTicketQueue - Small view takes long to load.
 - 2009-12-09 Fixed crash in Ascii2Html() if no scalar reference is given.
 - 2009-12-09 Fixed bug#[4551](http://bugs.otrs.org/show_bug.cgi?id=4551) - GenericAgent appends leading zeros to dates
    if TimeInputFormat is "Input".
 - 2009-12-09 Fixed bug#[4584](http://bugs.otrs.org/show_bug.cgi?id=4584) - Auto response does not use selected from e-mail
    address.
 - 2009-12-09 Fixed bug#[4556](http://bugs.otrs.org/show_bug.cgi?id=4556) - Translation "Accounted Time" to german "Zugewiesene Zeit".
 - 2009-12-09 Fixed bug#[4184](http://bugs.otrs.org/show_bug.cgi?id=4184) - Can't call method "NotificationGet" on
    an undefined value.
 - 2009-12-09 Fixed bug#[4371](http://bugs.otrs.org/show_bug.cgi?id=4371) - DataSelected value for config option
    PreferencesGroups###WatcherNotify doesn't work.
 - 2009-12-09 Fixed bug#[4486](http://bugs.otrs.org/show_bug.cgi?id=4486) - Some preferences displayed in AdminUser are not correct.
 - 2009-12-09 Fixed bug#[4363](http://bugs.otrs.org/show_bug.cgi?id=4363) - Kernel/Output/HTML/Layout.pm -\> PageNavBar()
    mistakes because of missing checks and descriptions.
 - 2009-12-08 Fixed bug#[4361](http://bugs.otrs.org/show_bug.cgi?id=4361) - Umlauts in Dashboard are not displayed correcty
    after refresh on non-unicode databases.
 - 2009-12-08 Fixed bug#[4323](http://bugs.otrs.org/show_bug.cgi?id=4323) - Customer Interface shows last customer article
    instead of last article.
 - 2009-12-08 Fixed bug#[4435](http://bugs.otrs.org/show_bug.cgi?id=4435) - Inline attachments break in some scenarios like
    AgentTicketCompose and AgentTicketForward.
 - 2009-12-08 Fixed bug#[4384](http://bugs.otrs.org/show_bug.cgi?id=4384) - Customer User Info not deleted when From in
    AgentTicketPhone is changed.
 - 2009-12-08 Fixed bug#[4482](http://bugs.otrs.org/show_bug.cgi?id=4482) - Owner update possible with no new owner set.
 - 2009-12-07 Fixed bug#[4246](http://bugs.otrs.org/show_bug.cgi?id=4246) - Response Templates fail to populate for certain
    email tickets.
 - 2009-12-07 Fixed bug#[4381](http://bugs.otrs.org/show_bug.cgi?id=4381) - Function change\_selection in AgentTicketMove.
 - 2009-12-07 Fixed bug#[4400](http://bugs.otrs.org/show_bug.cgi?id=4400) - OTRS switches back to phone view when closing
    ticket after split.
 - 2009-12-07 Fixed bug#[4597](http://bugs.otrs.org/show_bug.cgi?id=4597) - Unnecessary slash in download links.
 - 2009-12-07 Fixed bug#[2768](http://bugs.otrs.org/show_bug.cgi?id=2768) - AttachmentsContent-Disposition header downloading
    a non-ASCII filename.
 - 2009-12-07 Fixed bug#[4282](http://bugs.otrs.org/show_bug.cgi?id=4282) - Fixed problems with CustomerInfo for Usernames
    with a '+'.
 - 2009-12-07 Fixed bug#[4477](http://bugs.otrs.org/show_bug.cgi?id=4477) - Uninitialized Value issue with Redirect()
    function in Layout.pm.
 - 2009-12-07 Fixed bug#[3907](http://bugs.otrs.org/show_bug.cgi?id=3907) - Caching function not working due to wrong
     hardcoded umask.
 - 2009-12-02 Fixed bug#[4613](http://bugs.otrs.org/show_bug.cgi?id=4613) - Umlauts in \<OTRS\_\*\> variable and also on whole
    message are not show right with ArticleStorageFS.
 - 2009-12-02 Fixed bug#[3667](http://bugs.otrs.org/show_bug.cgi?id=3667) - E-mail notification link is wrong when using
    FastCGI.
 - 2009-11-25 Fixed bug#[4498](http://bugs.otrs.org/show_bug.cgi?id=4498) - Rich text editor places whitespace in front of
    lines in plain text mail body.
 - 2009-11-23 Fixed bug#[4128](http://bugs.otrs.org/show_bug.cgi?id=4128) - Signature line breaks are stripped in
    E-Mail-Ticket.
 - 2009-11-18 Fixed bug#[4319](http://bugs.otrs.org/show_bug.cgi?id=4319) - 'no quotable message' error for old messages
    after upgrade.
 - 2009-11-18 Added FastCGI handle for web installer.
 - 2009-11-16 Fixed bug#[4464](http://bugs.otrs.org/show_bug.cgi?id=4464) - Spell checker (WYSIWIG + ispell) causes
    exceptions sometimes.
 - 2009-11-16 Fixed bug#[4507](http://bugs.otrs.org/show_bug.cgi?id=4507) - Add Ticket Events for SLAUpdate, ServiceUpdate,
    and TicketTypeUpdate in AdminNotificationEvent UI.
 - 2009-11-16 Fixed bug#[4509](http://bugs.otrs.org/show_bug.cgi?id=4509) - Notification (event based) comments are not
    saved.
 - 2009-11-06 Fixed bug#[2069](http://bugs.otrs.org/show_bug.cgi?id=2069) - Update of CustomerCompany company\_id is not
    working.
 - 2009-11-06 Fixed bug#[2948](http://bugs.otrs.org/show_bug.cgi?id=2948) - Renamed crypt config option "md5" to "md5-crypt"
    to avoid missunderstanding.
 - 2009-10-30 Fixed JS check for months, thanks to bes.
 - 2009-10-26 Fixed bug#[4455](http://bugs.otrs.org/show_bug.cgi?id=4455) - Input field in Preferences of a Dashboard
    module doesn't save settings.
 - 2009-10-26 Fixed bug#[4454](http://bugs.otrs.org/show_bug.cgi?id=4454) - scripts/restore.pl is not working.
 - 2009-10-26 Fixed bug#[4447](http://bugs.otrs.org/show_bug.cgi?id=4447) - TimeUnits not saved in AgentTicketMove.pm when
    omitting a note.
 - 2009-10-22 Fixed bug#[4188](http://bugs.otrs.org/show_bug.cgi?id=4188) - Restore original subject check in AgentTicketMerge.
 - 2009-10-21 Fixed bug#[4232](http://bugs.otrs.org/show_bug.cgi?id=4232) - SpellChecker Customer-Interface is not
    working.
 - 2009-10-19 Fixed bug#[4433](http://bugs.otrs.org/show_bug.cgi?id=4433) - StateDefault is being ignored in when composing
    an email answer, current ticket state or first one in list gets selected.

#2.4.5 2009-10-15
 - 2009-10-12 Fixed bug#[3541](http://bugs.otrs.org/show_bug.cgi?id=3541) - Deleting tickets is not possible when using
    Full Text Search Index on MS-SQL or PostgreSQL.
 - 2009-10-12 Fixed bug#[4392](http://bugs.otrs.org/show_bug.cgi?id=4392) - TicketCounter.log is created after permissions
    are set.
 - 2009-10-07 Updated cpan module TEXT::CSV to version 1.14 to
    fix bug#[4195](http://bugs.otrs.org/show_bug.cgi?id=4195) - Import with leading 0 in a field not possible.
 - 2009-10-07 Fixed bug#[3581](http://bugs.otrs.org/show_bug.cgi?id=3581) - Wrong German translation of "no".
 - 2009-10-07 Fixed bug#[4397](http://bugs.otrs.org/show_bug.cgi?id=4397) - QueueView shows wrong filter name.
 - 2009-10-07 Fixed bug#[4395](http://bugs.otrs.org/show_bug.cgi?id=4395) - Can't delete locked tickets via GenericAgent
    on PostgreSQL and MS-SQL databases.
 - 2009-10-07 Fixed bug#[4367](http://bugs.otrs.org/show_bug.cgi?id=4367) - Generic agent produces TicketNumberLookup error
    messages.
 - 2009-10-05 Fixed bug#[3793](http://bugs.otrs.org/show_bug.cgi?id=3793) - UTF-8 PostgreSQL database encode issues on
    incoming emails.
 - 2009-10-05 Updated Spanish translation, thanks to Emiliano Augusto!
 - 2009-10-02 Fixed bug#[4379](http://bugs.otrs.org/show_bug.cgi?id=4379) - Array parameters not working in mkStats.pl
 - 2009-09-30 Fixed bug#[4348](http://bugs.otrs.org/show_bug.cgi?id=4348) - Dashboard: Upcoming Events Caching on a
    per-user basis.
 - 2009-09-30 Fixed bug#[4338](http://bugs.otrs.org/show_bug.cgi?id=4338) - Enhancement: Be able to disable customer
    feature of customer\_id to have access to all ticket with same customer id.
 - 2009-09-30 Fixed bug#[4358](http://bugs.otrs.org/show_bug.cgi?id=4358) - Unable to insert inline images in customer
    frontend if WebUploadCacheModule is set to "FS".
 - 2009-09-30 Fixed bug#[4355](http://bugs.otrs.org/show_bug.cgi?id=4355) - SLA dropdown does not populate in
    AgentTicketEmail.
 - 2009-09-29 Fixed bug#[3248](http://bugs.otrs.org/show_bug.cgi?id=3248) - TicketSearch with ExtendedSearchCondition not
    working correct.
 - 2009-09-29 Fixed bug#[4341](http://bugs.otrs.org/show_bug.cgi?id=4341) - RTE is not coupled with RichTextViewing. Rich
    text is being shown, even if the text/plain MIME part is available.
    Added new config option to force rich text viewing in ticket zoom.

     SysConfig -\> Ticket -\> Frontend::Agent::Ticket::ViewZoom -\>
      -=\> Ticket::Frontend::ZoomRichTextForce

 - 2009-09-28 Fixed bug#[4269](http://bugs.otrs.org/show_bug.cgi?id=4269) - Softwareerror in stats module after uninstall
    ITSMIncidentProblemManagement
 - 2009-09-28 Fixed bug#[4341](http://bugs.otrs.org/show_bug.cgi?id=4341) - No HighlightColors configured fills up OTRS log
    file with warnings.
 - 2009-09-28 Fixed bug#[4328](http://bugs.otrs.org/show_bug.cgi?id=4328) - Incorrect charset in AgentTicketAttachment.
 - 2009-09-28 Fixed bug#[4333](http://bugs.otrs.org/show_bug.cgi?id=4333) - StateGet() gives wrong error message.
 - 2009-09-26 Fixed bug#[4302](http://bugs.otrs.org/show_bug.cgi?id=4302) - Dashboard: Tickets Stats graph incorrect
   (permission related).
 - 2009-09-24 Fixed bug#[3909](http://bugs.otrs.org/show_bug.cgi?id=3909) - Optional TicketFreeTimes with AgentTicketCompose
    break when attaching a file
 - 2009-09-23 Fixed bug#[4326](http://bugs.otrs.org/show_bug.cgi?id=4326) - Notification emails have empty lines by using
    opera at creation time.
 - 2009-09-23 Fixed bug#[3001](http://bugs.otrs.org/show_bug.cgi?id=3001) - Agent ticket queue ordering by priority causes
    SQL error.
 - 2009-09-23 Fixed bug#[3969](http://bugs.otrs.org/show_bug.cgi?id=3969) - Role \<-\> User Admin Screen Refresh Error.
 - 2009-09-23 Fixed bug#[3787](http://bugs.otrs.org/show_bug.cgi?id=3787) - Generic Agent: Send no notifications is not
    working.
 - 2009-09-23 Fixed bug#[4222](http://bugs.otrs.org/show_bug.cgi?id=4222) - Changed Italian translation of "Login As".
 - 2009-09-23 Fixed bug#[3923](http://bugs.otrs.org/show_bug.cgi?id=3923) - Frontend::Output::FilterText###OutputFilterTextAutoLink
    does not work.
 - 2009-09-23 Fixed bug#[4226](http://bugs.otrs.org/show_bug.cgi?id=4226) - "Previous owner" alway empty when a new owner
    must be defined.
 - 2009-09-23 Fixed bug#[4322](http://bugs.otrs.org/show_bug.cgi?id=4322) - Bulk-Action checkboxes are refilled wrongly by
    Firefox-Autocomplete feature.
 - 2009-09-23 Fixed bug#[4320](http://bugs.otrs.org/show_bug.cgi?id=4320) - Javascript-check on empty body not working
    with RichText-Editor (RTE).
 - 2009-09-23 Fixed bug#[2936](http://bugs.otrs.org/show_bug.cgi?id=2936) - $QData{""} and $Quote{""} crashes if a space
    is set between the arguments.
 - 2009-09-22 Fixed bug#[4262](http://bugs.otrs.org/show_bug.cgi?id=4262) - Encoding issue with Event-based notifications.
 - 2009-09-22 Fixed bug#[1420](http://bugs.otrs.org/show_bug.cgi?id=1420) - $Text{"User"} instead of $Text{"Username"} in
    AdminUserForm.dtl
 - 2009-09-22 Ensured that plain article body is used for ArticleViewModules
    in AgentTicketZoom.
 - 2009-09-21 Fixed bug#[2087](http://bugs.otrs.org/show_bug.cgi?id=2087) - AgentTicketMove does not consider responsible
    feature.
 - 2009-09-21 Fixed bug#[4029](http://bugs.otrs.org/show_bug.cgi?id=4029) - S/MIME activation with unclear message
    message/incomplete documentation.
 - 2009-09-21 Fixed bug#[3408](http://bugs.otrs.org/show_bug.cgi?id=3408) - Richtext editor - editor windows is way to small.
 - 2009-09-21 Fixed bug#[4188](http://bugs.otrs.org/show_bug.cgi?id=4188) - Moving junk mails unnecessarily need subject and
    body.
 - 2009-09-21 Fixed bug#[4189](http://bugs.otrs.org/show_bug.cgi?id=4189) - RTE off inserts a blank line in the text editor
    field.
 - 2009-09-21 Fixed bug#[4080](http://bugs.otrs.org/show_bug.cgi?id=4080) - Rich editors javascript overrides onload function.
 - 2009-09-21 Fixed bug#[3818](http://bugs.otrs.org/show_bug.cgi?id=3818) - Customer History - Small/Medium/Preview does
    not work.
 - 2009-09-21 Fixed bug#[2532](http://bugs.otrs.org/show_bug.cgi?id=2532) - Problem when setting queues and subqueues to
    invalid.
 - 2009-09-18 Updated Spanish translation, thanks to Gustavo Azambuja!
 - 2009-09-16 Fixed bug#[4288](http://bugs.otrs.org/show_bug.cgi?id=4288) - 4288: Use of uninitialized value in
    AdminGenericAgent.pm.
 - 2009-09-16 Fixed bug#[4292](http://bugs.otrs.org/show_bug.cgi?id=4292) - "\<some@example.com\>" in body breaks body on
    ticket split.
 - 2009-09-08 Fixed bug#[4255](http://bugs.otrs.org/show_bug.cgi?id=4255) - RichText is not coupled with RichTextViewing.
    Rich Text is being shown, even if the text/plain MIME part is available.
 - 2009-09-08 Fixed bug#[4243](http://bugs.otrs.org/show_bug.cgi?id=4243) - Adding a key to DefaultTheme HostBased via
    Sysconfig breaks OTRS.
 - 2009-09-08 Fixed bug#[4257](http://bugs.otrs.org/show_bug.cgi?id=4257) - No event based notification is sent on queue
    or state update.
 - 2009-09-08 Fixed bug#[4233](http://bugs.otrs.org/show_bug.cgi?id=4233) - AgentTicketCompose doesn't remember next state
    while attaching a file.
 - 2009-09-08 Fixed bug#[4228](http://bugs.otrs.org/show_bug.cgi?id=4228) - scripts/DBUpdate-to-2.4.pl -
    MigrateCustomerNotification() fails.
 - 2009-09-08 Fixed bug#[4232](http://bugs.otrs.org/show_bug.cgi?id=4232) - SpellChecker Customer-Interface is not
    working.
 - 2009-09-08 Fixed bug#[4248](http://bugs.otrs.org/show_bug.cgi?id=4248) - follow up email contains the ticket number two
    times.
 - 2009-09-07 Fixed bug#[4253](http://bugs.otrs.org/show_bug.cgi?id=4253) - No customer get found by using german umlaut
    "e. g. mï¿½ller".
 - 2009-09-02 Fixed bug#[4186](http://bugs.otrs.org/show_bug.cgi?id=4186) - Customer search autocomplete result field is
    sometimes too small to show complete customer entry.
 - 2009-09-02 Fixed bug#[4234](http://bugs.otrs.org/show_bug.cgi?id=4234) - Typo in german update message.
 - 2009-09-01 Fixed bug#[4139](http://bugs.otrs.org/show_bug.cgi?id=4139) - Missing config option to show or hide customer
    history tickets.
 - 2009-09-01 Fixed bug#[4160](http://bugs.otrs.org/show_bug.cgi?id=4160) - Toolbar icons not correct in AdminCustomerUser.
 - 2009-09-01 Updated French translation, thanks to Remi Seguy.
 - 2009-09-01 Added Options for FirstResponseTime,UpdateTime,SolutionTime and
    CalendarID to bin/otrs.addQueue.
 - 2009-09-01 Fixed bug#[4214](http://bugs.otrs.org/show_bug.cgi?id=4214) - TicketSearch on TicketID with ArrayRef doesn't
    give results.

#2.4.4 2009-08-31
 - 2009-08-31 Fixed bug#[4105](http://bugs.otrs.org/show_bug.cgi?id=4105) - CustomerUser has access to other Customers
    tickets than defined in CustomerIDs.
 - 2009-08-31 Fixed Android browser support.
 - 2009-08-31 Added SOAP::Lite, which is needed for the XML-RPC Interface,
    to bin/otrs.checkModules.
 - 2009-08-29 Fixed bug#[4018](http://bugs.otrs.org/show_bug.cgi?id=4018) - CustomerCompany in ModuleAction section while
    CustomerUser in Module section.
 - 2009-08-28 Fixed bug#[4159](http://bugs.otrs.org/show_bug.cgi?id=4159) - Text Editor does not work with Konqueror.
 - 2009-08-28 Fixed bug#[4117](http://bugs.otrs.org/show_bug.cgi?id=4117) - UPGRADING: SetPermission.sh has to be run
    before the update script is started.
 - 2009-08-28 Fixed bug#[1917](http://bugs.otrs.org/show_bug.cgi?id=1917) - Wrong Content-Type in downloaded message
    from ArticlePlain.
 - 2009-08-28 Fixed wrong quoting in links in AgentTicketZoom.dtl and
    CustomerTicketZoom.dtl.
 - 2009-08-28 Fixed bug#[4203](http://bugs.otrs.org/show_bug.cgi?id=4203) - No German translation for "My Locked Tickets".
 - 2009-08-28 Fixed bug#[1245](http://bugs.otrs.org/show_bug.cgi?id=1245) - Queues and responses are sorted descending
    instead of ascending in AdminQueueResponses.
 - 2009-08-27 Fixed bug#[4198](http://bugs.otrs.org/show_bug.cgi?id=4198) - Error with services with one bracket in the
    name.
 - 2009-08-27 Fixed bug#[4085](http://bugs.otrs.org/show_bug.cgi?id=4085) - The UPGRADING document is incorrect and
    misleading.
 - 2009-08-27 Fixed bug#[2768](http://bugs.otrs.org/show_bug.cgi?id=2768) - AttachmentsContent-Disposition header
    downloading a with non-ASCII filename.
 - 2009-08-27 Fixed bug#[3974](http://bugs.otrs.org/show_bug.cgi?id=3974) - Missing template stats in the 2.4.0 beta 5.
 - 2009-08-27 Fixed bug#[3297](http://bugs.otrs.org/show_bug.cgi?id=3297) - Disabling of AgentTicketMerge does not remove
    merge link.
 - 2009-08-26 Fixed bug#[3746](http://bugs.otrs.org/show_bug.cgi?id=3746) - Show expiration date for PGP or S/MIME keys.
 - 2009-08-25 Fixed bug#[2676](http://bugs.otrs.org/show_bug.cgi?id=2676) - Translation issue for May.
 - 2009-08-26 Fixed bug#[4122](http://bugs.otrs.org/show_bug.cgi?id=4122) - META: spell checker issues with Rich Text
    Editor.
 - 2009-08-25 Added prio color in dashboard ticket overview like in ticket
    overview "s" mode.
 - 2009-08-24 Fixed bug#[4090](http://bugs.otrs.org/show_bug.cgi?id=4090) - RSS feeds have broken umlauts.
 - 2009-08-24 Fixed bug#[4177](http://bugs.otrs.org/show_bug.cgi?id=4177) - ArticleFilterDialog does not work in IE
    Javascript.
 - 2009-08-24 Added COPYING-Third-Party - a list of all included party
    libraries.
 - 2009-08-21 Fixed bug#[4178](http://bugs.otrs.org/show_bug.cgi?id=4178) - Added bundle of Apache2::Reload in
    Kernel/cpan-lib/, because it's no longer distributed with mod\_perl.
 - 2009-08-21 Fixed bug#[4170](http://bugs.otrs.org/show_bug.cgi?id=4170) - Typos in AgentTicketQueue and Sysconfig:MOTD.
 - 2009-08-19 Fixed bug#[4070](http://bugs.otrs.org/show_bug.cgi?id=4070) - No refresh in CPanel activated by default /
    default values of preferences sys config not taken over.
 - 2009-08-18 Fixed bug#[4161](http://bugs.otrs.org/show_bug.cgi?id=4161) - System takes about 20sec to get edit screen
    like note or compose answer.
 - 2009-08-18 Fixed bug#[4073](http://bugs.otrs.org/show_bug.cgi?id=4073) - Forward form does not add attachment.
 - 2009-08-18 Fixed bug#[4102](http://bugs.otrs.org/show_bug.cgi?id=4102) - otrs.addUser2Group: "Use of uninitialized
    value" message.
 - 2009-08-18 Replaced a Die() call in Kernel/System/Package.pm with an normal
    return for a better error handling.
 - 2009-08-18 Fixed bug#[4049](http://bugs.otrs.org/show_bug.cgi?id=4049) - SetPermissions.sh fails if .fetchmailrc does
    not exist.
 - 2009-08-18 Added attachment support of ArticleCreate event in event based
    notification feature.
 - 2009-08-18 Fixed bug#[4149](http://bugs.otrs.org/show_bug.cgi?id=4149) - TicketCreate event does not have access to
    Article attributes.
 - 2009-08-18 Fixed bug#[4155](http://bugs.otrs.org/show_bug.cgi?id=4155) - Typo in German translation of
    AdminSystemAddressForm.dtl.
 - 2009-08-17 Fixed bug#[3872](http://bugs.otrs.org/show_bug.cgi?id=3872) - Typo in CustomerFrontend::CommonParam###Action
    issue.
 - 2009-08-17 Fixed bug#[4154](http://bugs.otrs.org/show_bug.cgi?id=4154) - Signature seperator is wrong.
 - 2009-08-16 Fixed bug#[4011](http://bugs.otrs.org/show_bug.cgi?id=4011) - Kernel/System/PostMaster/Filter/Match.pm
    global symbol $Prefix not declared.
 - 2009-08-14 Fixed bug#[4150](http://bugs.otrs.org/show_bug.cgi?id=4150) - US/English Date Format not available.
 - 2009-08-13 Fixed bug#[4092](http://bugs.otrs.org/show_bug.cgi?id=4092) - Junk tickets shown as New tickets in Dashboard.
 - 2009-08-13 Fixed bug#[4129](http://bugs.otrs.org/show_bug.cgi?id=4129) - Watched Tickets in Dashboard.
 - 2009-08-13 Fixed bug#[4072](http://bugs.otrs.org/show_bug.cgi?id=4072) - Inline images broken in reply with
    ArticleStorageFS as attachment backend.

#2.4.3 2009-08-12
 - 2009-08-10 Fixed bug#[4123](http://bugs.otrs.org/show_bug.cgi?id=4123) - Reinstall of OPM packages with incorrect
    framework or OS possible.
 - 2009-08-10 Fixed bug#[4116](http://bugs.otrs.org/show_bug.cgi?id=4116) - Error when bouncing welcome ticket.
 - 2009-08-10 Fixed bug#[3870](http://bugs.otrs.org/show_bug.cgi?id=3870) - OTRS utf-8 to iso-8859-1 conversion error
    messages on every incoming mail.
 - 2009-08-05 Fixed bug#[4089](http://bugs.otrs.org/show_bug.cgi?id=4089) - root on OTRS Server gets an e-mail every 10
    minutes (Can't call method "FETCH" on an undefined value at ...Net/LDAP.pm
    line 274)
 - 2009-08-05 Fixed bug#[4107](http://bugs.otrs.org/show_bug.cgi?id=4107) - OpenSearch URL incorrect in Customer
    Interface.
 - 2009-08-03 Improved ChallengeTokenCheck to check all token of own
    sessions (not only of current session).
 - 2009-08-01 Fixed bug#[4086](http://bugs.otrs.org/show_bug.cgi?id=4086) - Kernel/System/Ticket.pm - next not in loop.
 - 2009-08-01 Fixed bug#[2795](http://bugs.otrs.org/show_bug.cgi?id=2795) - Modification on SubjectRe (possible use of
    "" in Ticket::SubjectRe).
 - 2009-07-31 Fixed bug#[4044](http://bugs.otrs.org/show_bug.cgi?id=4044) - WYSIWYG DefaultPreViewLines in ExpandMode.
 - 2009-07-30 Fixed bug#[4082](http://bugs.otrs.org/show_bug.cgi?id=4082) - Queue customer notification moved to new
    event based notification feature, but it's still in admin interface and
    initial insert file.
 - 2009-07-30 Fixed bug#[4081](http://bugs.otrs.org/show_bug.cgi?id=4081) - In Dashboard ticket overviews it is not
    possible to go to page 2,3,... and so on.
 - 2009-07-30 Fixed bug#[4039](http://bugs.otrs.org/show_bug.cgi?id=4039) - Use of uninitialized value -\>
    Kernel/Modules/AdminPackageManager.pm line.
 - 2009-07-30 Fixed bug#[4052](http://bugs.otrs.org/show_bug.cgi?id=4052) - Error composing a message in a Ticket with
    "empty answer" if $QData{"OrigFrom"} is used in config option
    Ticket::Frontend::ResponseFormat.
 - 2009-07-30 Fixed bug#[4048](http://bugs.otrs.org/show_bug.cgi?id=4048) - Subject starts with "Re:" when creating new
    ticket via EmailTicket.
 - 2009-07-30 Fixed bug#[4031](http://bugs.otrs.org/show_bug.cgi?id=4031) - Generic Agent does not handle ticket create
    time settings.

#2.4.2 2009-07-29
 - 2009-07-28 Added "bin/otrs.CacheDelete.pl" to remove all cached items.
 - 2009-07-28 Updated Chinese Simple translation, thanks to Never Min!
 - 2009-07-28 Updated Swedish translation, thanks to Mikael Mattsson!
 - 2009-07-27 Fixed bug#[3962](http://bugs.otrs.org/show_bug.cgi?id=3962) - Page displayed with errors when filename
    in attachment has simple quotes in it.
 - 2009-07-27 Fixed bug#[4054](http://bugs.otrs.org/show_bug.cgi?id=4054) - Bulk-action don't change ticket state.
 - 2009-07-27 Fixed bug#[3944](http://bugs.otrs.org/show_bug.cgi?id=3944) - Obligated TicketFreeText in composer breaks
    WYSIWYG Editor when replying.
 - 2009-07-26 Fixed bug#[4009](http://bugs.otrs.org/show_bug.cgi?id=4009) - Improved sql statement in GenericAgent (
    SELECT distinct(job\_name) FROM generic\_agent\_jobs).
 - 2009-07-26 Fixed bug#[3987](http://bugs.otrs.org/show_bug.cgi?id=3987) - When executing upgrade script (
    scripts/DBUpdate-to-2.4.pl), get an error "Need Ticket::ViewableStateType
    in Kernel/Config.pm!".
 - 2009-07-26 Fixed bug#[3984](http://bugs.otrs.org/show_bug.cgi?id=3984) - HTML Notifications - Links to ticketsystem not
    "clickable" in email client thunderbird.
 - 2009-07-25 Fixed bug#[4038](http://bugs.otrs.org/show_bug.cgi?id=4038) - Entering text for RTL languages is impossible
    in rich text mode!
 - 2009-07-25 Fixed bug#[4046](http://bugs.otrs.org/show_bug.cgi?id=4046) - Dashboard New/Open do not show anything in
   "New Tickets" and "Open Tickets" section.
 - 2009-07-24 Fixed bug#[4043](http://bugs.otrs.org/show_bug.cgi?id=4043) - French translation is corrupted.
 - 2009-07-24 Fixed bug#[3904](http://bugs.otrs.org/show_bug.cgi?id=3904) - Signing Mails with PGP or S/MIME not possible
   in AgentTicketEmail.
 - 2009-07-23 Fixed bug#[4020](http://bugs.otrs.org/show_bug.cgi?id=4020) - OTRS crashes when signing with PGP/GnuPG
    - Got no EncodeObject!
 - 2009-07-23 Fixed bug#[2304](http://bugs.otrs.org/show_bug.cgi?id=2304) - Two notification when a owner is changed.
 - 2009-07-23 Fixed bug#[2495](http://bugs.otrs.org/show_bug.cgi?id=2495) - Annoying Responsible Update Notifications.
 - 2009-07-23 Fixed bug#[4036](http://bugs.otrs.org/show_bug.cgi?id=4036) - Dashboard Plugin Upcoming Events shows also
    "pending auto close" tickets as "pending reminder reached in".
 - 2009-07-22 Fixed bug#[4035](http://bugs.otrs.org/show_bug.cgi?id=4035) - Dashboard Product Notify get's shown always,
    also if no new release info is available.
 - 2009-07-22 Fixed bug#[4027](http://bugs.otrs.org/show_bug.cgi?id=4027) - RichText: Incoming emails written with MS
    Word 12 seems to be empty.
 - 2009-07-22 Fixed bug#[4026](http://bugs.otrs.org/show_bug.cgi?id=4026) - Quote in Auto-Responses of new tickets which
    are created over the web interface are not plain text. Quote in
    Auto-Responses based on emails are working fine.
 - 2009-07-22 Fixed bug#[4024](http://bugs.otrs.org/show_bug.cgi?id=4024) - Use of Sessions per URL (not cookie) breaks
    Dashboard.

#2.4.1 2009-07-22
 - 2009-07-21 Updated Hungarian translation, thanks to Arnold Matyasi!
 - 2009-07-21 Updated Turkish translation, thanks to Meric Iktu!
 - 2009-07-21 Moved to default font "Geneva,Helvetica,Arial" of rich text
    feature.
 - 2009-07-21 Fixed bug#[4005](http://bugs.otrs.org/show_bug.cgi?id=4005) - Spellcheck with FCKEditor Plugin for WYSIWYG.
 - 2009-07-21 Fixed bug#[4022](http://bugs.otrs.org/show_bug.cgi?id=4022) - In AgentTicketZoom I get the following error
    message in log index.pl: Malformed UTF-8 character (unexpected
    non-continuation byte 0x74, immediately after start byte 0xe9) in
    substitution iterator at ../..//Kernel/Modules/AgentTicketAttachment.pm
    line 192.
 - 2009-07-21 Added/Updated new Chinese Traditional translation, thanks to
    Bin Du, Yiye Huang and Qingjiu Jia!

#2.4.0 beta6 2009-07-19
 - 2009-07-19 Moved to fckeditor (http://www.fckeditor.net/) as rich text
    editor because of several problems regaring text formating with YUI rich
    text editor.
 - 2009-07-19 Updated CPAN File::Temp to verion 0.22.
 - 2009-07-19 Updated Chinese Simple translation, thanks to Never Min!
 - 2009-07-19 Added new Chinese Traditional translation, thanks to Bin Du,
    Yiye Huang and Qingjiu Jia!
 - 2009-07-19 Updated Chinese Simple translation, thanks to Bin Du,
    Yiye Huang and Qingjiu Jia!
 - 2009-07-18 Fixed bug#[4004](http://bugs.otrs.org/show_bug.cgi?id=4004) - Can not search for customer strings like
    "St. Peters", I always get the result of "St.+Peters" which is much
     more then I want. Please make it working like in OTRS 2.3.
 - 2009-07-18 Fixed bug#[3991](http://bugs.otrs.org/show_bug.cgi?id=3991) - Link in HTML Article opens in iframe.
 - 2009-07-18 Renamed Kernel/System/HTML2Ascii.pm to
    Kernel/System/HTMLUtils.pm, because of better naming.
 - 2009-07-17 Updated Russian translation, thanks to Andrey Cherepanov!
 - 2009-07-16 Fixed bug#[4001](http://bugs.otrs.org/show_bug.cgi?id=4001) - proxy usage - rss get's not loaded via
    proxy settings.
 - 2009-07-16 Updated Russian translation, thanks to Egor Tsilenko!
 - 2009-07-16 Fixed bug#[3994](http://bugs.otrs.org/show_bug.cgi?id=3994) - It's possible to create an email ticket
 - 2009-07-16 Fixed bug#[3997](http://bugs.otrs.org/show_bug.cgi?id=3997) - Wrong named variable in AgentTicketZoom.
 - 2009-07-16 Fixed bug#[3993](http://bugs.otrs.org/show_bug.cgi?id=3993) - Error message about wrong email adress
    not visible in AgentTicketPhone and AgentTicketEmail if AutoComplete
    is enabled.
 - 2009-07-16 Fixed bug#[3994](http://bugs.otrs.org/show_bug.cgi?id=3994) - It's possible to create an email ticket
    for internal queues.
 - 2009-07-15 Fixed bug#[3663](http://bugs.otrs.org/show_bug.cgi?id=3663) - Responsible Notification does not happen
    for pending reached.
    Added config optio to be compat. to old OTRS versions.

    --\>\> SysConfig -\> Ticket -\> Core::Ticket -\>
             Ticket::PendingNotificationNotToResponsible \<\<--

 - 2009-07-15 Updated Italian translation, thanks to Giordano Bianchi,
    Emiliano Coletti and Alessandro Faraldi!
 - 2009-07-14 Fixed bug#[3983](http://bugs.otrs.org/show_bug.cgi?id=3983) - bin/PendingJobs.pl is not sendign reminder
    email (Error Message: Message: Need RecipientID!).
 - 2009-07-14 Fixed bug#[3977](http://bugs.otrs.org/show_bug.cgi?id=3977) - Tags of auto responses get not replaced.
 - 2009-07-14 Fixed bug#[3960](http://bugs.otrs.org/show_bug.cgi?id=3960) - Split function does not use RichText content
    from original article for new article.
 - 2009-07-14 Fixed bug#[3976](http://bugs.otrs.org/show_bug.cgi?id=3976) - AgentTicketBounce does not work when
    Frontend::RichText is disabled.
 - 2009-07-13 Updated Russian translation, thanks to Mike Lykov!
 - 2009-07-13 Updated Italian translation, thanks to Remo Catelotti!
 - 2009-07-13 Fixed bug#[3975](http://bugs.otrs.org/show_bug.cgi?id=3975) - New Dashboard Featrue: SQL of Upcoming Events
    (for pending remidner time) is not using database index, index on
    until\_time is missing. Use scripts/DBUpdate-to-2.4.\*.sql for upgrading.
 - 2009-07-13 Fixed bug#[3972](http://bugs.otrs.org/show_bug.cgi?id=3972) - Sub Kernel::System::TicketOwnerCheck() gives
    wrong result if asked for different TicketIDs in one TicketObject.
 - 2009-07-13 Updated Persian translation, thanks to Amir Shams Parsa!
 - 2009-07-13 Updated Dutch translation, thanks to Michiel Beijen!
 - 2009-07-13 Fixed bug#[3790](http://bugs.otrs.org/show_bug.cgi?id=3790) - POP3S doesn't fail when IO::Socket::SSL is not
    installed or mail server address is wrong.
 - 2009-07-13 Improved dashboard api / module layer to load content changes
    via AJAX / no compiled dashboard reload is needed.
 - 2009-07-11 Added new dashboard backend to show online agent and customers.
 - 2009-07-11 Improved dashboard api / module layer (added Preferences() to
    API to get/modify config settings of backend at runtime).
 - 2009-07-11 Fixed bug#[3967](http://bugs.otrs.org/show_bug.cgi?id=3967) - Unable to create notes by using GenericAgent
    (Error: Need Charset!).
 - 2009-07-11 Fixed bug#[3965](http://bugs.otrs.org/show_bug.cgi?id=3965) - New TicketOverview S/M/L feature: Last used
    ticket view mode get't only stored in current session but get lost after
    new relogin.
 - 2009-07-11 Fixed bug#[3964](http://bugs.otrs.org/show_bug.cgi?id=3964) - Update script is not working correctly (Can't
    call method "NotificationAdd" on an undefined value at
    scripts/DBUpdate-to-2.4.pl line 218).
 - 2009-07-11 Fixed bug#[3963](http://bugs.otrs.org/show_bug.cgi?id=3963) - Upgrade script is not executable
    scripts/DBUpdate-to-2.4.pl.

#2.4.0 beta5 2009-07-09
 - 2009-07-09 Fixed bug#[3938](http://bugs.otrs.org/show_bug.cgi?id=3938) - GenericAgent.pl - send agent escalation
    notification escalation ERROR (Got no EncodeObject).
 - 2009-07-09 Updated Polish translation, thanks to Artur Skalski!
 - 2009-07-09 Updated French translation, thanks to Olivier Sallou!
 - 2009-07-09 Updated Persian translation, thanks to Afshar Mohebbi!
    See also at
    http://afsharm.blogspot.com/2009/06/localizing-otrs-into-persian-farsi.html
 - 2009-07-09 Added CSV/HTML export for Admin-SQL-Box feature.
 - 2009-07-09 Fixed bug#[3956](http://bugs.otrs.org/show_bug.cgi?id=3956) - New OpenSearch feature for fulltext search
    is not working.
 - 2009-07-08 Fixed bug#[3954](http://bugs.otrs.org/show_bug.cgi?id=3954) - Lite Theme is not working.
 - 2009-07-07 Updated Italian translation, thanks to Remo Catelotti!
 - 2009-07-06 Fixed bug#[3948](http://bugs.otrs.org/show_bug.cgi?id=3948) - Some \<OTRS\> variables are not replaced in
    responses and auto responses.
 - 2009-07-06 Fixed bug#[3946](http://bugs.otrs.org/show_bug.cgi?id=3946) - Incomplete substitution of tag
    \<OTRS\_FIRST\_NAME\> in templates.
 - 2009-07-01 Added Kernel/Language/en\_CA.pm and Kernel/Language/en\_GB.pm
    to have different date formats for US, CA and GB.
 - 2009-07-01 Fixed bug#[3939](http://bugs.otrs.org/show_bug.cgi?id=3939) - Not able to configure an external
    customer dastabase source // Got no EncodeObject! at Kernel/System/DB.pm
    line 96.
 - 2009-07-01 Fixed bug#[3935](http://bugs.otrs.org/show_bug.cgi?id=3935) - Frontend::CustomerUser::Item###9-OpenTickets
    does not work anymore.
 - 2009-07-01 Fixed bug#[3936](http://bugs.otrs.org/show_bug.cgi?id=3936) - "select all" in bulk action is not working
    on only one ticket in overview.
 - 2009-06-30 Updated Italian translation, thanks to Remo Catelotti!
 - 2009-06-30 Fixed bug#[3934](http://bugs.otrs.org/show_bug.cgi?id=3934) - Error message on email processing - without
    any effect.

#2.4.0 beta4 2009-06-30
 - 2009-06-25 Fixed bug#[3774](http://bugs.otrs.org/show_bug.cgi?id=3774) - Wrong processing of email address containing
    www.com.
 - 2009-06-25 Fixed bug#[3892](http://bugs.otrs.org/show_bug.cgi?id=3892) - Wrong error message on agents changing his
    password.
 - 2009-06-29 Fixed bug#[3933](http://bugs.otrs.org/show_bug.cgi?id=3933) - Kernel::System::LinkObject should be usable
    in rpc.pl.
 - 2009-06-20 Updated Norwegian translation, thanks to Fredrik Andersen!
 - 2009-06-29 Added Latvian translation, thanks to Ivars Strazdins!
 - 2009-06-25 Fixed bug#[3911](http://bugs.otrs.org/show_bug.cgi?id=3911) - Not all Dashboard Functions e. g. charts
    available in Internet Explorer 6.
 - 2009-06-25 Fixed bug#[3925](http://bugs.otrs.org/show_bug.cgi?id=3925) - Frontend::NavBarModule in agent navigation
    bar "Ticket::TicketSearchFulltext" and "Ticket::TicketSearchProfile" not
    working together.
 - 2009-06-25 Fixed bug#[3924](http://bugs.otrs.org/show_bug.cgi?id=3924) - Upcoming Events -\> wrong displayed Escalation
    time.
 - 2009-06-25 Fixed bug#[3917](http://bugs.otrs.org/show_bug.cgi?id=3917) - Dashboard will crash when no Internet
    connection available - Module: ProductNotify.
 - 2009-06-25 Fixed bug#[3913](http://bugs.otrs.org/show_bug.cgi?id=3913) - Missing Modules in 2.4.0 beta1-beta3:
    Kernel/Output/HTML/ServicePreferencesGeneric.pm and
    Kernel/Output/HTML/SLAPreferencesGeneric.pm.
 - 2009-06-24 Fixed bug#[3826](http://bugs.otrs.org/show_bug.cgi?id=3826) - In auto responses and agent notifications,
    WYSIWYG is not working.
 - 2009-06-24 Fixed bug#[3796](http://bugs.otrs.org/show_bug.cgi?id=3796) - Admin notification edit screen is not coming
    proper in WYSIWYG editor.
 - 2009-06-22 Added PasswordMaxLoginFailed as password preferences to define
    max login till user get gets disabled (invalid-temporarily). Feature
    provided by Torsten Thau.
 - 2009-06-22 Fixed bug#[3775](http://bugs.otrs.org/show_bug.cgi?id=3775) - Translation error in Kernel/Language/de.pm.
 - 2009-06-22 Fixed bug#[3879](http://bugs.otrs.org/show_bug.cgi?id=3879) - Typing mistakes in the notification texts
    (scripts/database/otrs-initial\_insert.xml).
 - 2009-06-22 Fixed bug#[3907](http://bugs.otrs.org/show_bug.cgi?id=3907) - Sum rows/columns in stats only adds integers.
 - 2009-06-16 Fixed bug#[3881](http://bugs.otrs.org/show_bug.cgi?id=3881) - Dashboard - Error message when
    http://otrs.org/rss/ is not reachable.
 - 2009-06-13 Fixed bug#[3791](http://bugs.otrs.org/show_bug.cgi?id=3791) - Safari v3+4 cannot work with WYSIWYG Editor.
 - 2009-06-10 Fixed bug#[3882](http://bugs.otrs.org/show_bug.cgi?id=3882) - Dashboard does not set LastScreenOverview.
 - 2009-06-10 Added own web user agent, Kernel::System::WebUserAgent. Removed
    http/ftp access from Kernel::System::Package, moved to new core module.
 - 2009-06-10 Moved default menu type form "Classic" to "Modern".

#2.4.0 beta3 2009-06-08
 - 2009-06-08 Fixed bug#[3852](http://bugs.otrs.org/show_bug.cgi?id=3852) - installer.pl throws Got no EncodeObject.
 - 2009-06-08 Fixed bug#[3842](http://bugs.otrs.org/show_bug.cgi?id=3842) - DBUpdate-to-2.4.pl - Error when updating from
    beta1 to beta 2.
 - 2009-05-28 Added new management dashboard feature.
 - 2009-05-28 Added new event based notication management feature (notification
    can get easy managed via the admin interface).
 - 2009-05-28 Fixed bug#[3868](http://bugs.otrs.org/show_bug.cgi?id=3868) - the replacement of %s in $Text{} content
    doesn't work if the content is 0.
 - 2009-05-28 Fixed bug#[3846](http://bugs.otrs.org/show_bug.cgi?id=3846) - Generic Agents - cant set "Create Times"
    settings.
 - 2009-05-27 Fixed bug#[3862](http://bugs.otrs.org/show_bug.cgi?id=3862) - typos in english warning message of
    GenericAgent setup.
 - 2009-05-18 Updated CPAN module Text::CSV to version 1.12.

#2.4.0 beta2 2009-05-15
 - 2009-05-15 Fixed bug#[3618](http://bugs.otrs.org/show_bug.cgi?id=3618) - Ticket history info (ticket\_history.queue\_id)
    on TicketMove-Event is saving the old queue\_id instead of the new queue\_id.
 - 2009-05-15 Fixed bug#[3598](http://bugs.otrs.org/show_bug.cgi?id=3598) - Attachments are incorrectly displayed in
    ticket zoom view when attachments are located in file system (done by
    AttachmentFS) and now AttachmentDB backned is used.
 - 2009-05-15 Fixed bug#[3583](http://bugs.otrs.org/show_bug.cgi?id=3583) - Watched tickets do not follow queue rights.
    Can't read watched tickets with no permissions in new queue.
 - 2009-05-15 Fixed bug#[3816](http://bugs.otrs.org/show_bug.cgi?id=3816) - Typo in some bin/\*.pl files like
    bin/PostMasterMailbox.pl.
 - 2009-05-15 Added escalation time selection in admin generic agent
    interface.
 - 2009-05-15 Added notification event feature (be able to create custom
    notifications based on ticket events). Old notifications get migrated
    by scripts/DBUpdate-to-2.4.pl. Removed queue attributes for customer
    notification options.
 - 2009-04-27 Fixed bug#[3805](http://bugs.otrs.org/show_bug.cgi?id=3805) - Error: Module
    Kernel/Output/HTML/NavBarTicketBulkAction.pm not found!'
 - 2009-04-27 Fixed bug#[3802](http://bugs.otrs.org/show_bug.cgi?id=3802) - Errormessage: "Got no EncodeObject!" if
    using rpc.pl (SOAP).
 - 2009-04-24 Fixed bug#[3691](http://bugs.otrs.org/show_bug.cgi?id=3691) - CustomerUser::LDAP does support GroupDN now.
 - 2009-04-23 Fixed bug#[3799](http://bugs.otrs.org/show_bug.cgi?id=3799) - The UPGRADING refrences a file not included
    in the source code.
 - 2009-04-20 Updated nb\_NO translation, thanks to Fredrik Andersen!
 - 2009-04-20 Fixed bug#[3786](http://bugs.otrs.org/show_bug.cgi?id=3786) - No CSS get found at installation time (no
    colors are visable).

#2.4.0 beta1 2009-04-20
 - 2009-04-20 Changed default config size of IPC-Log (LogSystemCacheSize)
    to 32k (64k is not working on darwin).
 - 2009-04-20 Moved from bin/SetPermissions.sh to bin/SetPermissions.pl
    for a better maintanance.
 - 2009-04-20 Added warning screen to AdminSysConfig, AdminPackageManager,
    AdminGenericAgent to block to use it till SecureMode is activated.
 - 2009-04-18 Added SysConfig setting to (not) include custmers email address
    on composing an answer "Ticket::Frontend::ComposeAddCustomerAddress".
    Default is set to true.
 - 2009-04-17 Added own SysConfig settings for bulk action (
    Ticket // Frontend::Agent::Ticket::ViewBulk).
 - 2009-04-15 Removed AgentCanBeCustomer option from agent frontend.
    Customer followup messages can only be created from the customer frontend.
 - 2009-04-09 Added search for article create times in ticket search.
 - 2009-04-09 Improved email send functionality to properly format emails
    with alternative parts and inline images.
 - 2009-04-09 Added enhancement bug#[3514](http://bugs.otrs.org/show_bug.cgi?id=3514) - RegExp support in ACLs. Now you
    can use RegExp in ACLs like the followin example:
```
    $Self->{TicketAcl}->{'ACL-Name-1'} = {
       # match properties
       Properties => {
           Queue => {
               Name => ['[RegExp]^Misc'],
           },
       },
       # return possible options (white list)
       Possible => {
           # possible ticket options (white list)
           Ticket => {
               Service  => ['[RegExp]^t1', '[RegExp]^t2'],
               Priority => [ '4 high' ],
           },
       },
    };
```
    Starting with "[RegExp]" in value area means the following will be a regexp
    content.

    This ACL will match all Queues with starting "Misc" and all services with
    starting "t1" and "t2". So you do not longer need to write every full queue
    names to the array list.

    o Usage of [RegExp] results in case-sensitive matching.
    o Usage of [regexp] results in case-insensitive matching.

 - 2009-04-08 Updated CPAN module CGI to version 3.43.
 - 2009-04-07 Changed default config size of IPC-Log (LogSystemCacheSize)
    to 64k (160k is not working on darwin).
 - 2009-04-07 Added SMTPS support for outgoing emails (e. g. for sending
    via gmail smtp server).
 - 2009-04-06 Added fulltext search feature for quick search (OpenSearch
    format and input field in nav bar - disabled per default).
 - 2009-04-03 Added check for required perl version 5.8.6.
 - 2009-04-02 Added possibility to search tickets with params like
    *OlderMinutes and \*NewerMinutes with 0 minutes.
 - 2009-04-02 Fixed bug#[3732](http://bugs.otrs.org/show_bug.cgi?id=3732) - Improved russion translation.
 - 2009-04-02 Dropped MaxDB/SAPDB support due to some limitations.
 - 2009-04-01 Fixed bug#[3295](http://bugs.otrs.org/show_bug.cgi?id=3295) - SQL error when you have no state of type
    "pending reminder".
 - 2009-04-01 Fixed bug#[2296](http://bugs.otrs.org/show_bug.cgi?id=2296) - Enable/disable "blinking queue" in QueueView
    via SysConfig.
 - 2009-04-01 Fixed bug#[3641](http://bugs.otrs.org/show_bug.cgi?id=3641) - AgentTicketCustomer totally broken in CVS.
 - 2009-04-01 When merging tickets, assign article based ticket history
    entries to the merged ticket as well.
 - 2009-04-01 Implemented enhancement/bug#[3333](http://bugs.otrs.org/show_bug.cgi?id=3333) - Increased the memory of
    the shared memory used for SystemLog.
 - 2009-04-01 Fixed bug#[3737](http://bugs.otrs.org/show_bug.cgi?id=3737) - Non-ascii characters in filenames of outbound
    email attachments are not quoted.
 - 2009-04-01 Implement enhancement/bug#[3527](http://bugs.otrs.org/show_bug.cgi?id=3527) - the input fields at the
    restrictions of the stats module now allow the use of wildcards at the
    beginning and end of a word (e.g. 'huber\*'). This is now the same behavior
    as in GenericAgent. But not the behavior of the TicketSearch.
 - 2009-03-30 Updated CPAN module Authen::SASL to version 2.12.
 - 2009-03-30 Updated CPAN module Text::CSV to version 1.11.
 - 2009-03-30 Updated CPAN module File::Temp to version 0.21.
 - 2009-03-17 Fixed bug#[3729](http://bugs.otrs.org/show_bug.cgi?id=3729) - Missing translation of "Customer history"
    in AgentTicketCustomer.
 - 2009-03-17 Fixed bug#[3713](http://bugs.otrs.org/show_bug.cgi?id=3713) - Apache-error if ticket has only internal
    articles.
 - 2009-03-06 Added article filter feature in TicketZoom.
 - 2009-03-01 Replaced dtl variable for image location "$Env{"Images"}" by
    using config option "$Config{"Frontend::ImagePath"}" to remove not needed
    $Env{} "alias". Added "$Config{"Frontend::JavaScriptPath"}" for java script
    and "$Config{"Frontend::CSSPath"}" for css directory.
 - 2009-02-27 Added feature to show the ticket title or the last
    customer subject in TicketOverviewSmall.
 - 2009-02-27 Added enhancement bug#[3271](http://bugs.otrs.org/show_bug.cgi?id=3271) Added accessibility of
    Kernel::System::CustomerUser (CustomerUserObject) to bin/cgi-bin/rpc.pl
    (SOAP handle).
 - 2009-02-17 Added group permission support for bulk feature (config via
    SysConfig -\> Ticket -\> Core::TicketBulkAction).
 - 2009-02-17 Added read only permission support for watched tickets.
 - 2009-02-17 Added agent notification support for watched tickets (config
    via perferences setting for each agent).
 - 2009-02-11 Fixed ticket# 2009020942001554 - generic agent is logging many
    debug infos into log file.
 - 2009-02-09 Fixed bug#[3075](http://bugs.otrs.org/show_bug.cgi?id=3075) - IntroUpgrade Text is not shown during package
    upgrade in admin interface of package manager.
 - 2009-02-09 Implement the same identifier handling for customer as for
    user. This effects the files Kernel/Ouptut/HTML/\*/CustomerNavigationBar.dtl
    and Kernel/Ouptut/HTML/Layout.pm.
 - 2009-02-05 Removed the dtl-if from Header.dtl. And implement a new
    handling to set a indentifier for the user information (usually visible
    on the top of the right side of a page).
 - 2009-02-04 Implement a config option to remove OTRS version tags
    from the http headers.
 - 2009-02-04 Removed a useless slogan from the HTML/DTL-Headers (
    Kernel/Ouptut/HTML/\*/Header.dtl, Kernel/Ouptut/HTML/\*/Footer.dtl, ...).
 - 2009-01-28 Fixed bug#[3233](http://bugs.otrs.org/show_bug.cgi?id=3233) - Better error message when adding auto
    responses with same name.
 - 2009-01-26 Removed outdated function FetchrowHashref() from core module
    Kernel/System/DB.pm.
 - 2009-01-08 Fixed bug#[3571](http://bugs.otrs.org/show_bug.cgi?id=3571) - Output Filter Pre+Post of layout object will
    be use on any block, not on any template file like it was in 2.1-2.2. Moved
    back to old behavior.
 - 2009-01-05 Moved to new auth sync layer. Splited auth and agent
    sync into two module layers. For example:
```
    [Kernel/Config.pm]

    # agent authentication against http basic auth
    $Self->{'AuthModule'} = 'Kernel::System::Auth::HTTPBasic';

    # agent data sync against ldap
    $Self->{'AuthSyncModule'} = 'Kernel::System::Auth::Sync::LDAP';
    $Self->{'AuthSyncModule::LDAP::Host'} = 'ldap://ldap.example.com/';
    $Self->{'AuthSyncModule::LDAP::BaseDN'} = 'dc=otrs, dc=org';
    $Self->{'AuthSyncModule::LDAP::UID'} = 'uid';
    $Self->{'AuthSyncModule::LDAP::SearchUserDN'} = 'uid=sys, ou=user, dc=otrs, dc=org';
    $Self->{'AuthSyncModule::LDAP::SearchUserPw'} = 'some\_pass';
    $Self->{'AuthSyncModule::LDAP::UserSyncMap'} = {
        # DB -> LDAP
        UserFirstname => 'givenName',
        UserLastname  => 'sn',
        UserEmail     => 'mail',
    };
    [...]
```
 - 2008-12-28 Added daemon support to bin/PostMasterMailbox.pl and
    bin/GenericAgent.pl by using "-b \<BACKGROUND\_INTERVAL\_IN\_MIN\>".
 - 2008-12-22 Improved ticket escalation notification, moved to .dtl support
    (Kernel/Output/HTML/Standard/AgentTicketEscalation.dtl) and added ticket
    title as mouse on over note.
 - 2008-12-19 Added out of office feature for agent users.
 - 2008-12-15 Added new ticket attributes to CSV export of ticket in ticket
    search. New attributes are 'Closed', 'FirstLock' and 'FirstResponse'.
 - 2008-12-10 Added the text auto link feature to add http links for text body
    to add icons after conigured expressions the standard.
 - 2008-12-08 Added new postmaster filter to check if new arrived email is
    based on follow up of forwarded email. Then Followup should not be shown
    as "email-external", it should be shown as "email-internal".
 - 2008-11-12 Removed not supported PostMaster module
    Kernel/System/PostMaster/Filter/AgentInterface.pm.
 - 2008-11-10 Added autocomplete feature for customer search.
 - 2008-10-30 Fixed bug#[2371](http://bugs.otrs.org/show_bug.cgi?id=2371) - "Panic, no user data!" message should be more
    verbose.
 - 2008-10-29 Added additional default attributes of customer attributes like
    (phone, fax, mobile, street, zip, city). Use scripts/DBUpdate-to-2.4.\*.sql
    for upgrading.
 - 2008-10-28 Fixed bug#[1722](http://bugs.otrs.org/show_bug.cgi?id=1722) - weekday sorting in TimeWorkingHours corrected.
 - 2008-10-28 Fixed bug#[1491](http://bugs.otrs.org/show_bug.cgi?id=1491) - text in the file "UPGRADING" is misleading.
 - 2008-10-28 Implemented RFE (bug#[1006](http://bugs.otrs.org/show_bug.cgi?id=1006)): Added ticket change time to
    TicketGet and ArticleGet output. As a result, parameter 'Changed' is now
    usable as field in CSV search output as ticket change time.
 - 2008-10-24 Added StopAfterMatch attribute on postmaster filter (DB and
    config backend).
 - 2008-10-23 First version of improved ticket overview modus, added S/M/L
    options.
 - 2008-10-23 Added ticket change time option to agent ticket search.
 - 2008-10-14 Added COUNT as result option in TicketSearch() of
    Kernel::System::Ticket to increase performance of count lookups.
 - 2008-10-14 Added new tables for "RFC 2822 conform" and Service/SLA
    preferences feature (use scripts/DBUpdate-to-2.4.\*.sql for upgrading).
 - 2008-10-14 Added RFC 2822 conform In-Reply-To and References header
    support for outgoing emails (Threading).
 - 2008-10-02 Added script to move stored attachments from one backend to
    other backend, e. g. DB -\> FS (bin/otrs.ArticleStorageSwitch.pl).
 - 2008-10-02 Added service and sla preferences feature, like already exising
    user, customer and queue preferences. Can be extended by config settings.
 - 2008-10-02 Improved package manager to get info about documentation
    availabe in online repository packages.
 - 2008-10-02 Added password reset option based on auth backend for multi
    auth support.

#2.3.6 (2010/09/15)
 - 2010-07-23 Fixed bug#[3426](http://bugs.otrs.org/show_bug.cgi?id=3426) - Abort while processing mails with invalid
    charset messes up POP3 mailbox handling.

#2.3.5 2010-02-08
 - 2010-02-04 Fixed SQL quoting issue (see also
    http://otrs.org/advisory/OSA-2010-01-en/).
 - 2009-05-19 Fixed bug#[3844](http://bugs.otrs.org/show_bug.cgi?id=3844) - SLA get's not removed on reload if servics was
    selected before (in agent interface).
 - 2009-04-23 Fixed bug#[3495](http://bugs.otrs.org/show_bug.cgi?id=3495) - Missing ldap disconnects leaves CLOSE\_WAIT tcp
    sessions.
 - 2009-04-23 Fixed bug#[3674](http://bugs.otrs.org/show_bug.cgi?id=3674) - CustomerSearch() doesn't match non-single
    words if they are in the same DB field.
 - 2009-04-23 Fixed bug#[3684](http://bugs.otrs.org/show_bug.cgi?id=3684) - No search for \* in LDAP-CustomerBackend.
 - 2009-04-02 Fixed bug#[3732](http://bugs.otrs.org/show_bug.cgi?id=3732) - Improved russion translation.
 - 2009-04-01 Fixed bug#[3573](http://bugs.otrs.org/show_bug.cgi?id=3573) - Deleting tickets on PostgreSQL 8.3.0 failes.
 - 2009-04-01 Fixed bug#[3719](http://bugs.otrs.org/show_bug.cgi?id=3719) - otrs.checkModules incorrectly parses PDF::API2
    version.
 - 2009-04-01 Fixed bug#[3257](http://bugs.otrs.org/show_bug.cgi?id=3257) - otrs.checkModules incorrectly states DBD:mysql
    is required.
 - 2009-04-01 Fixed bug#[3739](http://bugs.otrs.org/show_bug.cgi?id=3739) - Customer can not logon to the Customer
    Interface if ShowAgentOnline is used.
 - 2009-04-01 Fixed bug#[3404](http://bugs.otrs.org/show_bug.cgi?id=3404) - PendingJobs.pl doesn't unlock the closed
    tickets.
 - 2009-04-01 Fixed bug#[3745](http://bugs.otrs.org/show_bug.cgi?id=3745) - German umlaut in customer login\_id breaks
    login.
 - 2009-03-24 Fixed bug#[3735](http://bugs.otrs.org/show_bug.cgi?id=3735) - Queue names should be quoted when editing
    queues (In this case if you use them in regular expressions).
 - 2009-02-19 Fixed bug#[3636](http://bugs.otrs.org/show_bug.cgi?id=3636) - Phone call link can be used without adding
    a body the ticket mask.
 - 2009-02-19 Fixed bug#[3671](http://bugs.otrs.org/show_bug.cgi?id=3671) - Priority in CustomerTicketZoom resets to
    pre-configured or 3.
 - 2009-02-13 Fixed bug#[3657](http://bugs.otrs.org/show_bug.cgi?id=3657) - Stats module: The locking attribute doesn't
    work.
 - 2009-02-11 Fixed ticket# 2009020942001554 - generic agent is logging many
    debug infos into log file.
 - 2009-02-09 Fixed bug#[3656](http://bugs.otrs.org/show_bug.cgi?id=3656) - The package manager testscript doesn't work
    on developer installations.
 - 2009-01-30 Fixed bug#[3635](http://bugs.otrs.org/show_bug.cgi?id=3635) - Was not able to install .opm packages bigger
    then 1MB (because of missing MySQL config) but OTRS error message was
    miss leading.
 - 2009-01-28 Fixed bug#[3242](http://bugs.otrs.org/show_bug.cgi?id=3242) - AdminGenericAgent produces apache-error-log
    entry.
 - 2009-01-26 Fixed bug#[3528](http://bugs.otrs.org/show_bug.cgi?id=3528) - Stats-cache-mechanism does not take unfixed
    restrictions in consideration.
 - 2009-01-23 Fixed bug#[3615](http://bugs.otrs.org/show_bug.cgi?id=3615) - The links to the related Customer User and
    related Group in [ Customer Users \<-\> Groups ] frontend were broken.
 - 2009-01-23 Fixed bug#[3499](http://bugs.otrs.org/show_bug.cgi?id=3499) - Permission problems if you change the
    configuration of the System::Permissions. Now it doesn't matter if you
    active or deactive one of the additional permissions.
 - 2009-01-22 Fixed bug#[3137](http://bugs.otrs.org/show_bug.cgi?id=3137) - Ticket search does not work with words like
    "BPX" and "new".
 - 2009-01-22 Fixed bug#[3596](http://bugs.otrs.org/show_bug.cgi?id=3596) - Show a warning, if some tries to renaming
    the admin group in admin frontend.

#2.3.4 2009-01-21
 - 2009-02-09 Fixed bug#[3458](http://bugs.otrs.org/show_bug.cgi?id=3458) - Length of E-mail adress form in
    AdminSystemAddressForm is way too short.
 - 2009-01-20 Fixed bug#[3447](http://bugs.otrs.org/show_bug.cgi?id=3447) - CustomerUser-Renaming to existing UserLogin
    was possible.
 - 2009-01-20 Fixed bug#[3603](http://bugs.otrs.org/show_bug.cgi?id=3603) - Different Max-Attribute handling in Layout.pm
    BuildSelection and OptionStrgHashRef.
 - 2009-01-20 Fixed bug#[3601](http://bugs.otrs.org/show_bug.cgi?id=3601) - Problems in function BuildSelection with
   ''-Strings and 0.
 - 2009-01-15 Fixed bug#[3595](http://bugs.otrs.org/show_bug.cgi?id=3595) - VacationCheck() of Kernel::System::Time is
    ignoring different OTRS calendar.
 - 2009-01-13 Fixed bug#[3542](http://bugs.otrs.org/show_bug.cgi?id=3542) - Static Stats lose associated perlmodule after
    editing.
 - 2009-01-10 Fixed bug#[3575](http://bugs.otrs.org/show_bug.cgi?id=3575) - Framework file get lost after upgrading OTRS
    and reinstalling or uninstalling e. g. ITSM pakages then.
 - 2008-12-08 Added feature to install included packages located under
    var/packages/\*.opm on first/initial setup.
 - 2008-12-08 Fixed bug#[3462](http://bugs.otrs.org/show_bug.cgi?id=3462) - SMIME crypt and sign functions bail out -
     unable to save random state.
 - 2008-12-04 Fixed bug#[3360](http://bugs.otrs.org/show_bug.cgi?id=3360) - Service list formating broken after AJAX reload.
 - 2008-12-02 Fixed bug#[3495](http://bugs.otrs.org/show_bug.cgi?id=3495) - No unbind in LDAP-CustomerDataBackend.
 - 2008-12-01 Fixed bug#[3493](http://bugs.otrs.org/show_bug.cgi?id=3493) - CloseParentAfterClosedChilds.pm does not work.
 - 2008-11-26 Fixed bug#[2582](http://bugs.otrs.org/show_bug.cgi?id=2582) - Ticket print and config option
     Ticket::Frontend::ZoomExpandSort gets not recognized.
 - 2008-11-16 Fixed bug#[3452](http://bugs.otrs.org/show_bug.cgi?id=3452) - "permission denied" after moving tickets into
    a queue with no permissions.
 - 2008-11-16 Fixed bug#[3461](http://bugs.otrs.org/show_bug.cgi?id=3461) - It's not possible to past an email into a
    note screen, only 70 signs are possible for each line, it should be
    increased to 78.
 - 2008-11-14 Fixed bug#[3459](http://bugs.otrs.org/show_bug.cgi?id=3459) - Ticket in state "pending" are not escalating
    but shown in escalation overview with incorect timestamp calculation
    (34512 days).
 - 2008-11-10 Fixed bug#[3213](http://bugs.otrs.org/show_bug.cgi?id=3213) - Make rpc.pl work when using ModPerl.
 - 2008-11-10 Fixed bug#[3442](http://bugs.otrs.org/show_bug.cgi?id=3442) - HTML2Ascii is ignoring spaces on email
    processing.
 - 2008-11-07 Fixed bug#[2730](http://bugs.otrs.org/show_bug.cgi?id=2730) - Sending mails to MS Exchange Server 2007
    fails sometimes with "Bad file descriptor!".
 - 2008-11-01 Fixed bug#[3207](http://bugs.otrs.org/show_bug.cgi?id=3207) - Expanded articles in wrong order.
 - 2008-10-30 Fixed bug#[2071](http://bugs.otrs.org/show_bug.cgi?id=2071) - Dead link to online documentation in admin
    interface (AdminState).
 - 2008-10-29 Fixed bug#[3244](http://bugs.otrs.org/show_bug.cgi?id=3244) - "Defination"-Typo in Defaults.pm.
 - 2008-10-29 Fixed bug#[2736](http://bugs.otrs.org/show_bug.cgi?id=2736) - AdminUser&Subaction=Change - Valid is
    automatically changed
 - 2008-10-29 Fixed bug#[2710](http://bugs.otrs.org/show_bug.cgi?id=2710) - Error: Module 'Kernel::Modules::' not found!
 - 2008-10-28 Fixed bug#[3402](http://bugs.otrs.org/show_bug.cgi?id=3402) - AgentLinkObject crashes with "Got no
    UserLanguage" if browser sends exotic language.
 - 2008-10-28 Fixed bug#[3405](http://bugs.otrs.org/show_bug.cgi?id=3405) - Input field agent-email-address too short.
 - 2008-10-28 Fixed bug#[1719](http://bugs.otrs.org/show_bug.cgi?id=1719) - psql -u deprecated.
 - 2008-10-28 Fixed bug#[3366](http://bugs.otrs.org/show_bug.cgi?id=3366) - TicketEvent ArticleFreeTextSet does not know
    ArticleID.
 - 2008-10-28 Fixed bug#[3346](http://bugs.otrs.org/show_bug.cgi?id=3346) - improved error logging of new postmaster
    tickets for invalid priority names.
 - 2008-10-28 Fixed bug#[3376](http://bugs.otrs.org/show_bug.cgi?id=3376) - GenericAgent: A warning like "you have to set
    schedule times" would be helpful.
 - 2008-10-20 Fixed bug#[3391](http://bugs.otrs.org/show_bug.cgi?id=3391) - Filter out hazardous characters from redirects.
 - 2008-10-16 Fixed bug#[2415](http://bugs.otrs.org/show_bug.cgi?id=2415) - Wrong info after editing salutation.
 - 2008-10-15 Fixed bug#[3379](http://bugs.otrs.org/show_bug.cgi?id=3379) - Documentation of packages got not shown in
    admin package manager.
 - 2008-10-15 Updated Chinese translation, thanks to Never Min!
 - 2008-10-13 Fixed bug#[3373](http://bugs.otrs.org/show_bug.cgi?id=3373) - Postmaster match filter is losing [\*\*\*] on
    second time.
 - 2008-10-13 Fixed bug#[3367](http://bugs.otrs.org/show_bug.cgi?id=3367) - Escalation of first response gets not changed
    on note-external (which was working in OTRS 2.2.x).
 - 2008-10-09 Fixed bug#[3358](http://bugs.otrs.org/show_bug.cgi?id=3358) - Removed useless error warning in stats module.

#2.3.3 2008-10-02
 - 2009-01-13 Fixed bug#[3542](http://bugs.otrs.org/show_bug.cgi?id=3542) - Static Stats lose associated perlmodule after
    editing.
 - 2008-09-30 Fixed bug#[3335](http://bugs.otrs.org/show_bug.cgi?id=3335) - No user name in pdf - print of stats-report
 - 2008-09-29 Updated Italian translation, thanks to Remo Catelotti!
 - 2008-09-29 Fixed bug#[3315](http://bugs.otrs.org/show_bug.cgi?id=3315) - GenericAgent does not work with pending time
    reached for x units.
 - 2008-09-29 Fixed bug#[3314](http://bugs.otrs.org/show_bug.cgi?id=3314) - Escalation time not updated correctly, e. g.
    ticket get's not escalated if one escalation time got solved.
 - 2008-09-25 Updated Chinese translation, thanks to Never Min!
 - 2008-09-24 Fixed bug#[3322](http://bugs.otrs.org/show_bug.cgi?id=3322) - After updating SysConfig I get: Can't use
    string ("0") as a HASH ref while "strict refs" in use at
    Kernel/System/Config.pm line 716.
 - 2008-09-24 Fixed bug#[3321](http://bugs.otrs.org/show_bug.cgi?id=3321) - "(" or ")" in user name is breaking ldap query
    for agent and customer auth.
 - 2008-09-13 Fixed bug#[3289](http://bugs.otrs.org/show_bug.cgi?id=3289) - Error when trying to delete an answer (with
    std attachment) in admin interface.
 - 2008-09-12 Fixed bug#[3292](http://bugs.otrs.org/show_bug.cgi?id=3292) - Missing entries in the generic agent mask if
    a freetext field is configured as pull down menu.
 - 2008-09-11 Fixed bug#[3275](http://bugs.otrs.org/show_bug.cgi?id=3275) - Kernel::System::EmailParser::CheckMessageBody
    uses undefined $Param{URL}.
 - 2008-09-11 Fixed bug#[3284](http://bugs.otrs.org/show_bug.cgi?id=3284) - Missing entries in the stats mask if a
    freetext field is configured as pull down menu.
 - 2008-09-10 Fixed bug#[3287](http://bugs.otrs.org/show_bug.cgi?id=3287) - Possible CSS on login page, in
    AgentTicketMailbox and CustomerTicketOverView.
 - 2008-09-08 Fixed bug#[3158](http://bugs.otrs.org/show_bug.cgi?id=3158) - Ticket has a "pending" state --\> the
    escalation time is not set out.
 - 2008-09-08 Fixed bug#[3266](http://bugs.otrs.org/show_bug.cgi?id=3266) - backup.pl calls "mysqldump5" not "mysqldump".
 - 2008-09-08 Fixed bug#[3251](http://bugs.otrs.org/show_bug.cgi?id=3251) - Error retrieving pop3s email from gmail
    or MS Exchange.
 - 2008-09-08 Fixed bug#[3247](http://bugs.otrs.org/show_bug.cgi?id=3247) - GenericAgent is running also without time
    settings.
 - 2008-09-08 Fixed bug#[3261](http://bugs.otrs.org/show_bug.cgi?id=3261) - Escalation also for ro tickets (normally just
    rw tickets).
 - 2008-08-30 Fixed bug#[2862](http://bugs.otrs.org/show_bug.cgi?id=2862) - Wrong summary in GenericAgent webinterface
    after adding a new job. Max. shown 10,000 affected tickets.
 - 2008-08-30 Fixed bug#[3053](http://bugs.otrs.org/show_bug.cgi?id=3053) - AJAX functionality without cookies is not
    working.
 - 2008-08-29 Fixed bug#[3152](http://bugs.otrs.org/show_bug.cgi?id=3152) - German wording in link tables within english
    environment.
 - 2008-08-21 Fixed bug#[3227](http://bugs.otrs.org/show_bug.cgi?id=3227) - Link delete doesn't work if the key includes
    double colons.

#2.3.2 2008-08-25
 - 2008-08-21 Fixed bug#[3076](http://bugs.otrs.org/show_bug.cgi?id=3076) - Ticket Eskalation of update time is not
    working correctly.
 - 2008-08-21 Fixed bug#[3064](http://bugs.otrs.org/show_bug.cgi?id=3064) - Java Script Error if I use
    "Internet Explorer 7".
 - 2008-08-21 Fixed bug#[3198](http://bugs.otrs.org/show_bug.cgi?id=3198) - ACL is not working for services in Customer
    Panel for creating new tickets.
 - 2008-08-21 Fixed bug#[3214](http://bugs.otrs.org/show_bug.cgi?id=3214) - PostMasterFilter - Its not possible to
    filter for "Return-Path".
 - 2008-08-21 Fixed bug#[3216](http://bugs.otrs.org/show_bug.cgi?id=3216) - CustomerTicketSearch returns links to
    internal articles.
 - 2008-08-21 Fixed bug#[3219](http://bugs.otrs.org/show_bug.cgi?id=3219) - Bogus 7bit check in the file cache backend.
 - 2008-08-21 Implemented display of ticket search profiles in Agent
    Interface for immediate access (disabled by default).
 - 2008-08-18 Fixed bug#[3199](http://bugs.otrs.org/show_bug.cgi?id=3199) - Queue lists - The queue tree has problems
    with disabled queues.
 - 2008-08-18 Fixed bug#[3139](http://bugs.otrs.org/show_bug.cgi?id=3139) - QueueUpdate-Bug on oracle and postgres dbs.
 - 2008-08-14 Fixed bug#[3191](http://bugs.otrs.org/show_bug.cgi?id=3191) - It is hard to identify the selected page of
    a list of elements.
 - 2008-08-13 Fixed bug#[3133](http://bugs.otrs.org/show_bug.cgi?id=3133) - OTRS creates temp dirs with wrong access
    permissions.

#2.3.1 2008-08-04
 - 2008-08-03 Fixed bug#[3096](http://bugs.otrs.org/show_bug.cgi?id=3096) - Errorlog messages from NET::DNS (Subroutine
    nxrrset redefined at ...).
 - 2008-08-03 Added http target for customer user map config options in
    position 9 (see Kernel/Config/Defaults.pm for examples).
 - 2008-08-02 Fixed bug#[3121](http://bugs.otrs.org/show_bug.cgi?id=3121) - OTRS corrupts email headers (Subject, From etc.)
    while encoding with utf-8.
 - 2008-08-01 Fixed bug#[3142](http://bugs.otrs.org/show_bug.cgi?id=3142) - The Ticket-ACL module
    CloseParentAfterClosedChilds produces errors.
 - 2008-07-31 Fixed bug#[3141](http://bugs.otrs.org/show_bug.cgi?id=3141) - The TicketSearch() function produces error on
    a DB2 database, if the argument TicketCreateTimeOlderDate is given.
 - 2008-07-31 Added function LinkCleanup() to delete forgotten temporary
    links that are older than one day. The function is called only when deleting
    a link.
 - 2008-07-30 Updated dansk language translation, thanks to Mads N. Vestergaard!
 - 2008-07-30 Updated spanish translation, thanks to Pelayo Romero Martin!
 - 2008-07-30 Updated CPAN module CGI to version 3.39.
 - 2008-07-30 Updated CPAN module MailTools to version 2.04.
 - 2008-07-27 Updated russian translation, thanks to Egor Tsilenko!
 - 2008-07-25 Fixed bug#[3122](http://bugs.otrs.org/show_bug.cgi?id=3122) - Ticket attributes in agent ticket search
    CSV export gets not translated.
 - 2008-07-25 Fixed bug#[2300](http://bugs.otrs.org/show_bug.cgi?id=2300) - Not all Notification Tags are working in
    Notifications.
 - 2008-07-21 Fixed bug#[3117](http://bugs.otrs.org/show_bug.cgi?id=3117) - Auto increment of "id" in article\_search
    table is not needed.
 - 2008-07-21 Fixed bug#[3104](http://bugs.otrs.org/show_bug.cgi?id=3104) - If new config can't get created by
    scripts/DBUpdate-to-2.3.pl, the script need to stop.

#2.3.0 rc1 2008-07-21
 - 2008-07-20 Update persian translation, thanks to Amir Shams Parsa and
    Hooman Mesgary!
 - 2008-07-20 Fixed bug#[2712](http://bugs.otrs.org/show_bug.cgi?id=2712) - Email in POP3 or IMAP box gets deleted/lost
    also if it got not processed.
 - 2008-07-20 Added Ingres database files for Ingres 2006 R3 experimental
    support.
 - 2008-07-20 Fixed bug#[3102](http://bugs.otrs.org/show_bug.cgi?id=3102) - (Optional) group-Permissions for
    Frontend::Agent::Ticket::MenuModule(Pre).
 - 2008-07-19 Fixed bug#[3098](http://bugs.otrs.org/show_bug.cgi?id=3098) - Ticket number search in the new link mask does
    not work correctly.
 - 2008-07-19 Fixed bug#[3093](http://bugs.otrs.org/show_bug.cgi?id=3093) - Foreign Key drop does not work.
 - 2008-07-19 Fixed bug#[2826](http://bugs.otrs.org/show_bug.cgi?id=2826) - Impossible to use DEFAULT values in SOPM
    files.
 - 2008-07-18 Fixed bug#[2893](http://bugs.otrs.org/show_bug.cgi?id=2893) - Allow translation texts with new lines.
 - 2008-07-17 Integrate function StatsCleanUp().
 - 2008-07-16 Fixed bug#[3089](http://bugs.otrs.org/show_bug.cgi?id=3089) - Stats module creates an error log entry with
    message "Got no SessionID" .
 - 2008-07-16 Fixed bug#[3088](http://bugs.otrs.org/show_bug.cgi?id=3088) - Statistics module fails with
    message "Got no AccessRw" if you work with ro permissions
 - 2008-07-16 Fixed bug#[3012](http://bugs.otrs.org/show_bug.cgi?id=3012) - Statistics module fails with
    message "Got no UserLanguage"
 - 2008-07-15 Moved config option PostMasterMaxEmailSize default 12 MB
    to 16 MB.
 - 2008-07-15 Fixed bug#[3082](http://bugs.otrs.org/show_bug.cgi?id=3082) - Wrong requirement checks and false default
    handling in function QueueAdd and QueueUpdate.
 - 2008-07-15 Updated french translation, thanks to Yann Richard!
 - 2008-07-14 Only show Company-NavBar item if CustomerCompanySupport is
    enabled for min. one CustomerUser source.
 - 2008-07-10 Fixed bug#[3066](http://bugs.otrs.org/show_bug.cgi?id=3066) - The CPAN module XML::Parser::Lite crashs after
    login if the CPAN module version is not installed.
 - 2008-07-09 Updated catalonian translation, thanks to Antonio Linde!
 - 2008-07-09 Updated finnish translation, thanks to Mikko Hynninen!
 - 2008-07-09 Fixed problem in CodeUpgrade functionallity.
    Code did not react correctly to version number in CodeUpgrade sections.
 - 2008-07-08 Updated norwegian translation, thanks to Fredrik Andersen!

#2.3.0 beta4 2008-07-07
 - 2008-07-07 Fixed bug#[2158](http://bugs.otrs.org/show_bug.cgi?id=2158) - Trigger Definitions not allow export / import
    through oracle exp/imp tool.
 - 2008-07-06 Fixed bug#[3058](http://bugs.otrs.org/show_bug.cgi?id=3058) - Unconsistent usage of id's in
    otrs-initial\_insert.\*.sql. E. g. in case of Dual-Master MySQL 5 Replication
    is used.
 - 2008-07-06 Fixed bug#[3059](http://bugs.otrs.org/show_bug.cgi?id=3059) - article\_search table is missing in
    scripts/database/otrs-schema.\*.sql and scripts/DBUpdate-to-2.3.\*.sql.
 - 2008-07-04 Fixed bug#[3055](http://bugs.otrs.org/show_bug.cgi?id=3055) - Link migration from 2.2 -\> 2.3 is no working
    (missing TypeGet(), not shown because of disabled STDERR).
 - 2008-07-03 Fixed bug#[3053](http://bugs.otrs.org/show_bug.cgi?id=3053) - AJAX functionality without cookies is not
    working.
 - 2008-07-03 Improved OPM package CodeUpgrade by using Version attribute
    for code execurtion (like already exisitng DatabaseUpgrade). If no Version
    is used, CodeUpgrade will performed on every upgrade. For more info see
    developer manual.
 - 2008-07-02 Fixed bug#[3042](http://bugs.otrs.org/show_bug.cgi?id=3042) - QueueView Sort by Escalation unfunctional.
 - 2008-07-02 Fixed bug#[3045](http://bugs.otrs.org/show_bug.cgi?id=3045) - Hard coded permission check on merging
    tickets.
 - 2008-07-02 Fixed bug#[3048](http://bugs.otrs.org/show_bug.cgi?id=3048) - AgentLinkObject shows a wrong search result
    list, if a object cannot link with itself.
 - 2008-07-02 Added AJAX support to ticket move screen.
 - 2008-07-01 Added priority management mask to the admin interface.
 - 2008-07-01 Fixed bug#[3046](http://bugs.otrs.org/show_bug.cgi?id=3046) - Phone and Email-Ticket needs to get clicked
    twice on "create" to get created.
 - 2008-07-01 Fixed bug#[3047](http://bugs.otrs.org/show_bug.cgi?id=3047) - Not possible to reset service or sla in
    AgentTicketNote.
 - 2008-07-01 Updated CPAN module Net::POP3::SSLWrapper to version 0.02.
 - 2008-07-01 Updated CPAN module XML::Parser::Lite to version 0.710.05.
 - 2008-07-01 Updated CPAN module Authen::SASL to version 2.11.
 - 2008-07-01 Updated CPAN module MIME::Tools to version 5.427.
 - 2008-07-01 Updated CPAN module File::Temp to version 0.20.
 - 2008-06-30 Implemented options to search update-, response- and solution
    escalation time in TicketSearch().
 - 2008-06-27 Fixed bug#[2960](http://bugs.otrs.org/show_bug.cgi?id=2960) - DBUpdate-to-2.3.pl script fails.
 - 2008-06-26 Fixed bug#[3036](http://bugs.otrs.org/show_bug.cgi?id=3036) - Missing link delete checkboxes.
 - 2008-06-26 Fixed bug#[3029](http://bugs.otrs.org/show_bug.cgi?id=3029) - Search result of linkable objects is not
    sorted correctly.
 - 2008-06-26 Fixed bug#[3035](http://bugs.otrs.org/show_bug.cgi?id=3035) - Missing check to prevent creation of the same
    link with opposite direction.
 - 2008-06-26 Fixed bug#[3030](http://bugs.otrs.org/show_bug.cgi?id=3030) - Getting no error message if I link an already
    linked ticket again.
 - 2008-06-26 Fixed bug#[3034](http://bugs.otrs.org/show_bug.cgi?id=3034) - Ticket::Frontend::ZoomExpandSort is
    conflicting with new ticket Expand/Collapse feature in AgentTicketZoom, it
    get lost after clicking on Collapse.
 - 2008-06-26 Moved required permissions for ticket owner-selections to
    owner and for ticket responsible-selection to responsible (instead rw
    permissions).
 - 2008-06-23 Fixed bug#[3020](http://bugs.otrs.org/show_bug.cgi?id=3020) - New complex link table blocks output of the
    free text fields.
 - 2008-06-23 Fixed bug#[3019](http://bugs.otrs.org/show_bug.cgi?id=3019) - Wrong location of the new complex link table.

#2.3.0 beta3 2008-06-24
 - 2008-06-23 Fixed bug#[3015](http://bugs.otrs.org/show_bug.cgi?id=3015) - Performace problem in AgentLinkObject.
 - 2008-06-23 Added CustomerUser attribute support for Ticket-ACLs. For
    Example you can use customer user attributes in ACL properties in
    this case to create an list of possible queues in the customer
    interface for creating or moving tickets.
```
    $Self->{TicketAcl}->{'ACL-Name-Test'} = {
        # match properties
        Properties => {
            CustomerUser => {
                UserCustomerID => ['some\_customer\_id'],
            },
        }
        # possible properties
        Possible => {
            Ticket => {
                Queue => ['Hotline', 'Junk'],
            },
        },
    };
```
 - 2008-06-23 Fixed bug#[3013](http://bugs.otrs.org/show_bug.cgi?id=3013) - Freetext fields show wrong on AJAX update
    in phone and email ticket when queue is changed.
 - 2008-06-23 Updated cpan module TEXT::CSV to version 1.06.
 - 2008-06-23 Moved Ticket::ResponsibleAutoSet feature to external ticket
    event module (Kernel::System::Ticket::Event::ResponsibleAutoSet).
 - 2008-06-23 Fixed bug#[2959](http://bugs.otrs.org/show_bug.cgi?id=2959) - Linking and Unlinking Tickets is not addin
    ticket history and not executing TicketEventHandlerPost() by ticket link
    backend anymore.
 - 2008-06-20 Fixed bug#[1565](http://bugs.otrs.org/show_bug.cgi?id=1565) - Responsible Agent not updated when creating
    new ticket in phone or email ticket.
 - 2008-06-20 Removed output of linked objects in customer ticket print
    (because it's not needed in the customer panel).
 - 2008-06-19 Fixed bug#[2998](http://bugs.otrs.org/show_bug.cgi?id=2998) - Highlighted selection for notification
    listbox in admin interface.
 - 2008-06-19 Fixed bug#[3005](http://bugs.otrs.org/show_bug.cgi?id=3005) - AJAX functionality is not working in phone
    and email ticket for Service and SLA.
 - 2008-06-19 Added article TimeUnit support to automatically add time
    units to ticket by using generic agent (also usable over admin
    interface).
 - 2008-06-19 Added CleanUp() to Kernel::System::Cache to clean up/remove
    all cache files.
 - 2008-06-19 Fixed bug#[2957](http://bugs.otrs.org/show_bug.cgi?id=2957) - Merged ticket not shown "canceled" in linked
    objects table.
 - 2008-06-19 Simplifed the new link mechanism.
 - 2008-06-19 Added cleanup of old cache files and cleanup of non existing
    TicketIDs in ticket\_watcher and ArticleIDs in article\_flag table (there
    was a bug, this reference entries got not deleted by deleting a ticket
    or article, e. g. by GenericAgent) to scripts/DBUpgrade-to-2.3.pl.
 - 2008-06-13 Added extra config option for "CheckMXRecord" config option
    to configure extra name servers for MX lookups.
 - 2008-06-11 Fixed bug#[2980](http://bugs.otrs.org/show_bug.cgi?id=2980) - Getting cron emails (Use of uninitialized
    value in numeric gt (\>) at) every time if IMAP and IMAPs gets executed.
 - 2008-06-11 Fixed bug#[2979](http://bugs.otrs.org/show_bug.cgi?id=2979) - Unable to work on ticket, get error message
    "no permission" even with rw permissions on the ticket. Fixed recoding
    issue.
 - 2008-06-05 Fixed bug#[2969](http://bugs.otrs.org/show_bug.cgi?id=2969) - Unable to get past login screen - undefined
    value as a HASH reference at
    Kernel/System/Ticket/IndexAccelerator/RuntimeDB.pm line 57.
 - 2008-06-05 Fixed bug#[2960](http://bugs.otrs.org/show_bug.cgi?id=2960) - DBUpdate-to-2.3.pl script possibly fails.
 - 2008-06-05 Added enhancement bug#[2964](http://bugs.otrs.org/show_bug.cgi?id=2964) - Add hash sort to data dumper
    of Kernel::System::Main::Dump to get it better readable and comparable
    (also for diff's).
 - 2008-06-05 Improved Kernel::System::Cache::File, moved cache type files
    to sub directory of tmp/ to tmp/Cache/to have it clear where the cache
    files are.

#2.3.0 beta2 2008-06-02
 - 2008-06-02 Moved to new link mechanism.
 - 2008-06-02 Fixed bug#[2902](http://bugs.otrs.org/show_bug.cgi?id=2902) - Salutation and Signature examples in the
    admin interface are same.
 - 2008-06-02 Fixed bug#[2940](http://bugs.otrs.org/show_bug.cgi?id=2940) - Error/typo in DBUpdate-to-2.3.\*.sql,
    'escalation\_start\_time' instead of 'escalation\_update\_time' is used.
 - 2008-06-01 Fixed bug#[2956](http://bugs.otrs.org/show_bug.cgi?id=2956) - Not working ticket escalation by using SLAs.
 - 2008-06-01 Added sub sorting to Kernel::System::Ticket::TicketSearch()
    and improved unit test. Example:
```
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        Result  => 'ARRAY',
        Title   => '%sort/order by test%',
        Queues  => ['Raw'],
        OrderBy => ['Down', 'Down'],
        SortBy  => ['Priority', 'Age'],
        UserID  => 1,
    );
```
 - 2008-05-28 Fixed bug#[2891](http://bugs.otrs.org/show_bug.cgi?id=2891) - Typo in Bounce Customer notification
    'information'.
 - 2008-05-22 Upgraded Mail::Tools from version 2.02 to 2.03 from CPAN.

#2.3.0 beta1 2008-05-19
 - 2008-05-16 Updated cpan module Text::CSV to the version 1.05.
 - 2008-05-15 Added ticket search close time support to agent ticket search
    and generic agent.
 - 2008-05-15 Reimplmeented "bin/xml2sql.pl", works now with new cmd params.
    Now "-t $DatabaseType", "-n $Name", "-s $SplitInPrePostFiles" and
    "-o $OutputDir".
 - 2008-05-15 Renamed mssql reserved database table word "system\_user" to
    "users". Use scripts/DBUpdate-to-2.3.\*.sql for database upgrade.
 - 2008-05-15 If signing via SMIME fails, we now fall back to the original
     unsigned mailtext instead of sending an empty mail.
 - 2008-05-15 Fixed bug#[2844](http://bugs.otrs.org/show_bug.cgi?id=2844) - Improved robustness of RANDFILE setting for
     openssl (SMIME).
 - 2008-05-15 Refactored SMIME to work on Windows, too.
 - 2008-05-09 Added service \<-\> sla multi relation support.
 - 2008-05-09 Fixed bug#[2448](http://bugs.otrs.org/show_bug.cgi?id=2448) - Not necessary unique check of SLA name.
 - 2008-05-07 Renamed/cleanup of all config setting names for QueueView,
    StatusView and LockedTickets.
 - 2008-05-07 Improved use of existing unique-names in xml definition of
    scripts/database/otrs-schema.xml (not longer auto generated).
 - 2008-05-07 Improved oracle database backend, generation of long
    index/koreign key names, moved from NUMBER to NUMBER(12,0).
 - 2008-05-07 Added some new database indexes to increase the database
    speed (for more info see scripts/DBUpdate\*.sql).
 - 2008-05-07 Added article index support to increase speed of full text
    search up to 50% (need to be configured via SysConfig and
    bin/otrs.RebuildFulltextIndex.pl need to be executed after backend change).
 - 2008-05-07 Added ticket event support for TicketWatch\*() in
    Kernel::System::Ticket. Fixed not removed ticket watch infos after deleting
    a ticket.
 - 2008-05-07 Improved speed of ticket search screen on large installation,
    added cache for database lookup to get all unique ticket free text fields
    (tooks up to 10 sek, on lage installations).
 - 2008-05-02 Deleted textarea wrap in perl code and set browser wrap in dtl files.
 - 2007-04-29 Added X-OTRS-TicketTime and X-OTRS-FollowUp-TicketTime email
    header support as additional attributes like already existing X-OTRS-Header
    (for more info see doc/X-OTRS-Headers.txt).
 - 2007-04-29 Added Format attribute (default html, optional plain) for "Intro\*"
    tags in .sopm files. Format="html" will work as default and it's possible to
    put every html into the intro message. Format="plain" will add automatically
    \<pre\>\</pre\> to intro messages, so new lines and spaces are shown 1:1 in intro
    messages (for more info see developer manual).
 - 2007-04-29 TicketFreeTime, TicketFreeFields and Article Attachments now are
    taken over on ticket split.
 - 2007-04-29 Updated cpan module CGI to version 3.37.
 - 2007-04-25 Added create and drop of index and unique in xml TableAlter tag
    (for more info see developer manual).
 - 2008-04-20 Changed GenericAgent default limit of matching ticket for each
    run of a job from 2000 to 4000.
 - 2008-04-18 Let FrontendOutputFilters have access to LayoutObject and TemplateFile.
 - 2008-04-18 Added Title-Attribute (for Tooltips) to BuildSelection.
 - 2008-04-14 Increased db2 BLOB size from 20M to 30M in
    scripts/database/otrs-schema.db2.sql.
 - 2008-04-14 Improved admin interface, show only links with own permissions.
    So it's possible/easy to create sub admins for part administration
    (Fixed bug#[2535](http://bugs.otrs.org/show_bug.cgi?id=2535) - User is able to access admin menu).
 - 2008-04-14 Improved .opm packages to definde pre and post Code\* and
    Database\* tags to define time point of execution. For more info how to use
    it see developer manual.
 - 2008-04-14 Renamed .opm package tags for intro messages
    Intro(Install|Upgrade|Unintall)(Pre|Post) from \<IntroInstallPost\> to new
    format like \<IntroInstall Type="post"\>. For more info see developer manual.
    Note: Old tags still usable, will be converted by OTRS automatically.
 - 2008-04-10 Added global Search-Condition-Feature (AND/OR/()/!/+) to ticket
    search backend, customer search backend and faq.
 - 2008-04-10 Added support to ticket print to print selected article only.
 - 2008-04-10 Fixed bug#[2159](http://bugs.otrs.org/show_bug.cgi?id=2159) - added ticket close time search option (works
    like ticket create time search option) to agent ticket search screen.
 - 2008-04-10 Updated cpan module CGI to version 3.35.
 - 2008-04-02 Moved from default password 'crypt' method to 'md5'. All new
    changed passwords are stored with md5-password method. Old stored passwords
    still usable.
 - 2008-04-02 Fixed bug#[1952](http://bugs.otrs.org/show_bug.cgi?id=1952) - Superfluous error messages by
   Kernel/Config/Defaults.pm in Debug mode.
 - 2008-04-02 Fixed bug#[2496](http://bugs.otrs.org/show_bug.cgi?id=2496) - HTML formatting in the customer ticket zoom is
    wrong.
 - 2008-04-02 Fixed bug#[1116](http://bugs.otrs.org/show_bug.cgi?id=1116) - Made uses of \<br\\\> and \<input\\\> comply with XHTML.
 - 2008-04-01 Fixed bug#[2575](http://bugs.otrs.org/show_bug.cgi?id=2575) - Trying to Kernel::System::PGP::Crypt()
    utf8-character-strings no longer bails, but simply auto-converts the string
    into an utf8-byte-string, such that the correct data is written into the temp
    file.
 - 2008-04-01 Added new SysLog backend config for log sock. Defaulte use is
    'unix'. On Solaris you may need to use 'stream'.
 - 2008-03-31 Added ticket free time as required field support (works like
    for already existing ticket free text fields).
 - 2008-03-31 Added missing ticket type as required check if ticket type
    feature is enabled.
 - 2008-03-31 Fixed MD5/SHA1 mixups in SMIME handling on older systems (that have
    MD5 as default, not SHA1).
 - 2008-03-27 Added OpenSearchDescription to support "quick" search for
    ticket numbers for browsers like firefox2.
 - 2008-03-26 Added POP3/POP3S/IMAP/IMAPS support for PostMaster sub system
    (new bin/PostMasterMailbox.pl is replacing old bin/PostMasterPOP3.pl).
    Thanks to Igor Stradwo for this patch!
    NOTE: table pop3\_account need to be modified - use scripts/DBUpdate-to-2.3.\*.sql
 - 2008-03-26 Added support of renaming of database tables in XML backend and
    database drivers (Kernel/System/DB/\*.pm).
    Example:

    \<TableAlter NameOld="calendar\_event" NameNew="calendar\_event\_new"/\>

 - 2008-03-25 Added enhancement for agent and customer HTTPBasicAuth to strip
    parts of REMOTE\_USER or HTTP\_REMOTE\_USER by using a regexp. Example to
    strip @example.com of login.
```
    [Kernel/Config.pm]

    # In case you need to replace some part of the REMOTE\_USER, you can
    # use the following RegExp ($1 will be new login).
    $Self->{'AuthModule::HTTPBasicAuth::ReplaceRegExp'} = '^(.+?)@.+?$';
```
 - 2008-03-21 Added enhancement bug#[2773](http://bugs.otrs.org/show_bug.cgi?id=2773) - HTTPBasicAuth fails when only
    HTTP\_REMOTE\_USER is populated (not REMOTE\_USER).
 - 2008-03-18 Fixed mssql/sybase/freetds database problem
    "Setting of CS\_OPT\_TEXTSIZE failed. at" if a mssql customer backend
    is used. The problem is, that LongReadLen is not supported by
    dbd::sybase (this is the reason of this error message).
    So the database customer is now improved to set all database attributes
    in CustomerUser config. For example this is the solution to prevent
    the sybase error message:
```
    $Self->{CustomerUser} = {
        Name   => 'Database Backend',
        Module => 'Kernel::System::CustomerUser::DB',
        Params => {
            DSN       => 'DBI:sybase:yourdsn',
            User      => 'some\_user',
            Password  => 'some\_password',
            Table     => 'customer\_user',
            Attribute => {},
        },
    [...]
```
    For more info see: http://www.perlmonks.org/index.pl?node\_id=663835
 - 2008-03-17 Fixed bug#[2197](http://bugs.otrs.org/show_bug.cgi?id=2197) - utf8 problems with auto generated
    Kernel/Config/Files/ZZZAuto.pm and Kernel/Config/Files/ZZZAAuto.pm
    (non ascii signs and utf8 stamps).
 - 2008-03-17 Added ACL example module "CloseParentAfterClosedChilds" which
    allows you to not close parent tickets till all childs are closed (
    configuable via SysConfig -\> Ticket -\> Core::TicketACL).
 - 2008-03-17 Improved ticket zoom view, shown linked objects (only show link
    types (Normal/Child/Parent) if links are available).
 - 2008-03-16 Improved ticket zoom view, shown plain link to emails (per
    default, can be enabled via sys config) and improved shown linked/merged
    tickets.
 - 2008-03-09 Improved API of Cache core module (Kernel::System::Cache), added
    type param to define the type of cached object/data (so also a better
    storage is possible because you can manage each cache type object/data it
    self, e. g. if file system backend is used in differend sub directories).

    API Example (old):
        $CacheObject-\>Set(
            Key   =\> 'SomeKey',
            Value =\> 'Some Value',
            TTL   =\> 24\*60\*60,     # in sec. in this case 24h
        );

    API Example (new):
        $CacheObject-\>Set(
            Type  =\> 'ObjectName', # only A-z chars usable
            Key   =\> 'SomeKey',
            Value =\> 'Some Value',
            TTL   =\> 24\*60\*60,     # in sec. in this case 24h
        );

 - 2008-03-06 Fixed use of uninitialized value in Log.pm (visible when
    executed in ModPerl environment).
 - 2008-03-02 Added title of object to div tag of linked objects to have an
    preview to the content of a linked object.
 - 2008-03-01 Added missing ticket title to ticket search mask in agent
    and generic agent interface.
 - 2008-02-17 Removed not needed Encode::decode\_utf8() in core module
    Kernel::System::Encode (only set if utf-8 stamp is needed).
 - 2008-02-17 Upgraded Mail::Tools from version 1.77 to 2.02 from CPAN.
 - 2008-02-12 Fixed bug#[2670](http://bugs.otrs.org/show_bug.cgi?id=2670) - "wide character" error when login with
    russian password.
    Note: It could be on older systems, that existing passwords are not
    longer valid. Just reset the password and everything will work fine.
 - 2008-02-12 Fixed bug#[1996](http://bugs.otrs.org/show_bug.cgi?id=1996) - Replaced 'U' & 'D' with respective arrow
    icons.
 - 2008-02-12 Improved Fix for bug#[1608](http://bugs.otrs.org/show_bug.cgi?id=1608) - Badly formatted calendar popup.
    Now the table width is explicity passed into DTL from the perl module
    and the customer calendar view has been fixed, too.
 - 2008-02-11 Added queue preferences - module support like for agents and
    customer to create easier extentions/addons for queues.
    See Developer-Manual for more information.
    NOTE: table sla need to be modified - use scripts/DBUpdate-to-2.3.\*.sql
 - 2008-02-11 Added escalation warning feature. So agents will be notified
    before a ticket will escalate. This time point can be configured in the
    admin interface for queue and sla settings.
    NOTE: table queue need to be modified - use scripts/DBUpdate-to-2.3.\*.sql
 - 2008-02-04 Fixed bug#[1608](http://bugs.otrs.org/show_bug.cgi?id=1608) - Badly formatted calendar popup.
 - 2008-02-04 Fixed bug#[2657](http://bugs.otrs.org/show_bug.cgi?id=2657) - Improved regexp in RPM spec files to detect
    already existing "otrs" user (it was also matching on xxxotrsxxx names).
 - 2008-01-28 Added note permission "note" to default ticket permissions to
    manage list of inform involved agents out of the box.
 - 2008-01-24 Fixed bug#[2611](http://bugs.otrs.org/show_bug.cgi?id=2611) - PGP module not working on Windows platform.
 - 2008-01-15 Fixed bug#[2227](http://bugs.otrs.org/show_bug.cgi?id=2227) - XMLHashSearch returns no values on MS SQL in
    certain cases.
 - 2008-01-08 Added expand/collapse option to ticket zoom.
 - 2008-01-08 Added multi attachment support to ticket move screen.
 - 2008-01-08 Added AJAX support in email ticket.
 - 2008-01-03 Changed default session settings SessionMaxTime from 14h to
    16h and SessionMaxIdleTime from 5h to 6h.
 - 2008-01-02 Improved ticket zoom view, removed plain-text attachments
    of html with plain attachment emails.
 - 2008-01-02 Fixed bug#[2600](http://bugs.otrs.org/show_bug.cgi?id=2600) - MS SQL: Fulltext search in ticket body with
    mssql backend not possible (improved Kernel::System::DB API with database
    preferences option "NoLikeInLargeText").
 - 2007-12-28 Improved config file mechanism generated by SysConfig to improve
    speed in mod\_perl is used (about 0.2%-4% speed improvement, depends
    on which shown site).
    Note: Kernel/Config/Files/ZZZAuto.pm and Kernel/Config/Files/ZZZAAuto.pm
    generated by OTRS 2.3 or higher is not longer compat. to OTRS 2.2 and
    lower. But OTRS 2.3 or higher can read config files from OTRS 2.2 and
    lower.
 - 2007-12-27 Fixed bug#[2596](http://bugs.otrs.org/show_bug.cgi?id=2596) - Problems to download file from
    Action=AdminPackageManager with IE and Safari.
 - 2007-12-27 Improved way how to reset a password. Added password reset
    via token (email which needs to be accepted by new password requester
    first).
 - 2007-12-21 Added possiblity to use options of StringClean() in GetParam()
    and GetArray() functions.
 - 2007-12-21 Add StringClean() function to improve quality of strings.
 - 2007-12-19 Improved installer description to prevent bugs like bug#[2492](http://bugs.otrs.org/show_bug.cgi?id=2492).
 - 2007-12-17 Fixed bug#[2586](http://bugs.otrs.org/show_bug.cgi?id=2586) - File download of package in
    AdminPackageManager is not delivering the whole file name anymore.
 - 2007-12-17 Fixed bug#[2539](http://bugs.otrs.org/show_bug.cgi?id=2539) - SMIME signing was broken for private keys that
    have no passphrase and when openssl is unable to write to random state file.
 - 2007-12-11 Fixed bug#[2479](http://bugs.otrs.org/show_bug.cgi?id=2479) - Unable to retrieve attachments bigger than
    3Mb (on Oracle DB). Changed default read size from 4 MB to 40 MB in
    Kernel/System/DB/oracle.pm:
```
    $Self->{'DB::Attribute'}      = {
        LongTruncOk => 1,
        LongReadLen => 40 \* 1024 \* 1024,
    };
```
 - 2007-12-10 Updated MIME::Tools to current CPAN version 5.425.
 - 2007-12-06 Fixed bug#[2568](http://bugs.otrs.org/show_bug.cgi?id=2568) - Problems with attachment downloads if the
    active element filter is enabled.
 - 2007-12-05 Fixed bug#[1399](http://bugs.otrs.org/show_bug.cgi?id=1399) - Missing Translation. Added some translation to
    customer interface.
 - 2007-12-04 Fixed bug#[2257](http://bugs.otrs.org/show_bug.cgi?id=2257) - Silent ignorance of SMTP / Sendmail errors,
    now we collect the error and log it (which in turn displays it to the user).
 - 2007-11-20 Rewrite of Kernel::System::CSV by using cpan module Text::CSV
    for parsing and generating CSV files (added Text::CSV to
    bin/otrs.checkModules to check it).
 - 2007-11-07 Changed default config of WebMaxFileUpload from 10 MB to
    16 MB.
 - 2007-11-07 Changed Kernel::System::Crypt::PGP to reject any UTF8-strings,
    as these would get autoconverted into ISO - thus garbling the result.
    Currently, only binary octets and ISO-strings are supported as input.
 - 2007-10-25 Improved Kernel::System::Crypt::PGP to return information about
    the PGP-keys that were actually used in Decrypt() and Verify().
 - 2007-10-25 Updated all cpan modules.
 - 2007-10-17 Added GroupLookup() and RoleLookup() to Group.pm and removed the
    two methods GetGroupIdByName() and GetRoleIdByName() which were already marked
    as deprecated.
 - 2007-10-08 Added support of ticket free text links in ticket view,
    configurable via SysConfig.
 - 2007-10-05 Added fist version of AJAX framework support in phone ticket.
 - 2007-10-01 Added \<ModuleRequired Version="0.01"\>SomeModule\</ModuleRequired\>
    feature to .opm format for enforcing installed CPAN modules.
 - 2007-09-25 Fixed bug#[2312](http://bugs.otrs.org/show_bug.cgi?id=2312) - Wide character error in Layout.pm if system
    runs in utf-8 mode.
 - 2007-09-18 Did some improvments in Kernel/Output/HTML/Layout.pm to
    get an better performance if the block function is used many times
    (e. g. \> 1000 times, 30% faster).
 - 2007-09-13 Fixed bug#[1186](http://bugs.otrs.org/show_bug.cgi?id=1186) - Convertion from HTML to text incomplete
    if html encoded chars like &Egrave; or &eacute; is used. Added full
    HTML to text convertion to email parser.
 - 2007-09-13 Improved report overview of perfornance log.

#2.2.9 2010-02-08
 - 2010-06-24 Fixed bug#[5497](http://bugs.otrs.org/show_bug.cgi?id=5497) - Missing HTML quoting in stats module.
 - 2010-02-04 Fixed SQL quoting issue (see also
    http://otrs.org/advisory/OSA-2010-01-en/).

#2.2.8 2008-08-25
 - 2008-08-12 Fixed bug#[3156](http://bugs.otrs.org/show_bug.cgi?id=3156) - When the "EMAILADDRESS:" attribute is used to
    define a specific email address, then secodary match attributes are applied
    to all mails.
 - 2008-07-20 Fixed bug#[3155](http://bugs.otrs.org/show_bug.cgi?id=3155) - Wrong header charset in lost password
    notification.
 - 2008-07-20 Fixed bug#[3103](http://bugs.otrs.org/show_bug.cgi?id=3103) - CustomerInterface: Ticket of other customers
    accessible for other customers.
 - 2008-07-18 Fixed bug#[3101](http://bugs.otrs.org/show_bug.cgi?id=3101) - Getting Queue view after adding a note with
    state "open".
 - 2008-07-18 Fixed reopend bug#[2330](http://bugs.otrs.org/show_bug.cgi?id=2330) - Cron.sh restart \<OTRS\_USER\> doesn't
    work.
 - 2008-07-16 Fixed bug#[2967](http://bugs.otrs.org/show_bug.cgi?id=2967) - Stats module, illegal division by zero at
    ../..//Kernel/System/Stats.pm line 1581
 - 2008-07-16 Fixed bug#[3079](http://bugs.otrs.org/show_bug.cgi?id=3079) - Default CheckEmailInvalidAddress regexp
    rejects mail to MobileMe (me.com) accounts.
 - 2008-07-08 Fixed bug#[3062](http://bugs.otrs.org/show_bug.cgi?id=3062) - Not possible to search for Customer Company
 - 2008-06-25 Increaded max size of reformated text (reformating new lines)
    from 20,000 to 60,000 signs (this size is just a safety performance
    setting in Kernel::Output::HTML::Layout::Ascii2Html()).
 - 2008-06-20 Fixed bug#[3000](http://bugs.otrs.org/show_bug.cgi?id=3000) - Configured sender address for auto response
    get's ignored.
 - 2008-06-05 Fixed bug#[2962](http://bugs.otrs.org/show_bug.cgi?id=2962) - Freetext cache problem, old used ticket
    free text values get not added to pull down list in agent ticket search.
 - 2008-06-04 Removed not wanted email rfc check in AgentTicketPhone and
    AgentTicketEmail, it's already done by OTRS via config settings.

#2.2.7 2008-06-04
 - 2008-05-28 Fixed bug#[2891](http://bugs.otrs.org/show_bug.cgi?id=2891) - Typo in Bounce Customer notification
    'information'.
 - 2008-05-25 Fixed bug#[2934](http://bugs.otrs.org/show_bug.cgi?id=2934) - PostmasterPOP3.pl - craches on malformed UTF-8
    character (fatal)... on incoming emails.
 - 2008-05-22 Fixed bug#[2829](http://bugs.otrs.org/show_bug.cgi?id=2829) - Added config option if Cc should be taken over
    to Cc recipients list in compose email answer screen.
    SysConfig -\> Ticket -\> Frontend::Agent::Ticket::ViewCompose -\>
    Ticket::Frontend::ComposeExcludeCcRecipients
 - 2008-05-15 Fixed bug#[2870](http://bugs.otrs.org/show_bug.cgi?id=2870) - Customer-Frontend: No Access to Company Tickets
    (CustomerIDCheck fails).
 - 2008-05-09 Added new catalonian language translation, thanks to Antonio Linde!
 - 2008-05-08 Fixed bug#[2683](http://bugs.otrs.org/show_bug.cgi?id=2683) - $QData{"OrigFrom"} in Reply leads to wrong
    quote in email answer if sender is agent (To of origin email is used).
 - 2008-05-08 Fixed bug#[2604](http://bugs.otrs.org/show_bug.cgi?id=2604) - Response Format - Date of Original Mail is
    missing.
 - 2008-05-07 Fixed bug#[2882](http://bugs.otrs.org/show_bug.cgi?id=2882) - The foreign key syntax in
    otrs-schema-post.mysql.sql is incorrect.
 - 2008-04-23 Fixed bug#[2907](http://bugs.otrs.org/show_bug.cgi?id=2907) - Typo in the german translation:
    "aktuallisiert".
 - 2008-04-19 Fixed not removable ticket by acl watcher link in ticket menu
    (added missing config param to Ticket.xml config file).
 - 2008-04-14 Improved speed of phone and email ticket if many queues and
    groups (150+) are used.
 - 2008-04-14 Improved load speed of ticket search screen (if free text fields
    are used).
 - 2008-04-14 Fixed bug#[2860](http://bugs.otrs.org/show_bug.cgi?id=2860) - ColumnAdd doesn't work on a DB2 database if
    Required is true.
 - 2008-04-10 Added new estonian translation, thanks to Lauri Jesmin!
 - 2008-04-07 Fixed bug#[2814](http://bugs.otrs.org/show_bug.cgi?id=2814) - BCC emails are visible to all receipiants in
    email header.
 - 2008-04-07 Fixed bug#[2829](http://bugs.otrs.org/show_bug.cgi?id=2829) - Local system email address is always set to CC
    option in compose email answer screen.
 - 2008-04-07 Fixed bug#[2833](http://bugs.otrs.org/show_bug.cgi?id=2833) - Broken email attachments if only attachment is
    in email (no mime attachments).
 - 2008-04-03 Fixed bug#[2828](http://bugs.otrs.org/show_bug.cgi?id=2828) - Strings like ftp.invalid.org are shown as http
    link in TicketZoom.
 - 2008-04-02 Fixed bug#[2756](http://bugs.otrs.org/show_bug.cgi?id=2756) - "http." in article body is displayed as
    "http://http.".
 - 2008-04-01 Fixed bug#[2822](http://bugs.otrs.org/show_bug.cgi?id=2822) - Ticket Number in subject of Bounce Notification
    to customer/sender is not shown.
 - 2008-04-01 Fixed bug#[2453](http://bugs.otrs.org/show_bug.cgi?id=2453) - syntax errors on customer search; name@host
    problems the mail address parser does not recognize the email address if it
    is not fully 2822 compilant.

#2.2.6 2008-03-31
 - 2008-03-25 Fixed bug#[2732](http://bugs.otrs.org/show_bug.cgi?id=2732) - Service name is truncated in dropdown lists
 - 2008-03-21 Fixed bug#[2758](http://bugs.otrs.org/show_bug.cgi?id=2758) - non-latin filenames in emails get not converted
    to utf8 (e. g. koi8-r, utf8, cp1251).
 - 2008-03-21 Fixed bug#[2781](http://bugs.otrs.org/show_bug.cgi?id=2781) - Typo in Kernel::System::Ticket::MoveTicket()
   "&" instead of "&&".
 - 2008-03-20 Fixed bug#[2772](http://bugs.otrs.org/show_bug.cgi?id=2772) - Dangling links to deleted tickets (ticket
    links get not deleted after a ticket got deleted).
 - 2008-03-14 Fixed bug#[2770](http://bugs.otrs.org/show_bug.cgi?id=2770) - Internal cache mechanism of SLAs delivers
    wrong content.
 - 2008-03-14 Fixed bug#[2769](http://bugs.otrs.org/show_bug.cgi?id=2769) - Trimming of sla name input field produce
    errors.
 - 2008-03-14 Fixed bug#[954](http://bugs.otrs.org/show_bug.cgi?id=954) - ticket split should linking tickets (origin to
    new one).
 - 2008-03-13 Added new turkish translation, thanks to Necmettin Begiter!
 - 2008-03-11 Fixed bug#[2763](http://bugs.otrs.org/show_bug.cgi?id=2763) - Trimming of service name input field produce
    errors.
 - 2008-03-10 Updated vietnam translation, thanks to Nguyen Nguyet. Phuong!
 - 2008-03-10 Fixed bug#[2757](http://bugs.otrs.org/show_bug.cgi?id=2757) - Can't download statistic graph if I use
    a diagram as output format.
 - 2008-03-10 Fixed bug#[2717](http://bugs.otrs.org/show_bug.cgi?id=2717) - All column and row names will be translated
    statistics. Additional fixes for special situations.
 - 2008-03-06 Fixed bug#[2737](http://bugs.otrs.org/show_bug.cgi?id=2737) - Wrong order of the xaxis in stats output.
 - 2008-03-06 Fixed bug#[2717](http://bugs.otrs.org/show_bug.cgi?id=2717) - All column and row names will be translated.
 - 2008-03-05 Fixed bug#[2715](http://bugs.otrs.org/show_bug.cgi?id=2715) - Ascii2Html() is not quoting all links
    correctly.
 - 2008-03-03 Fixed bug#[2742](http://bugs.otrs.org/show_bug.cgi?id=2742) - Wrong content type in admin package manager
    mask.
 - 2008-02-25 Added missing german translation for required free-text fields.
 - 2008-02-25 Fixed bug#[2451](http://bugs.otrs.org/show_bug.cgi?id=2451) - Typo in openssl invocation when decrypting.
 - 2008-02-23 Fixed bug#[2275](http://bugs.otrs.org/show_bug.cgi?id=2275) - Need User or UserID! by using UnlockTickets.pl
    and PendingJobs.pl.
 - 2008-02-23 Fixed bug#[2696](http://bugs.otrs.org/show_bug.cgi?id=2696) - CustomerPanelOwnSelection and
    CustomerGroupSupport does not work together (show also queues without
    create permissions).
 - 2008-02-23 Fixed bug#[2544](http://bugs.otrs.org/show_bug.cgi?id=2544) - Customer with RO can update ticket in
    customer panel (wrong SysConfig setting).
 - 2008-02-22 Fixed bug#[2650](http://bugs.otrs.org/show_bug.cgi?id=2650) - Mails not full imported by PostmasterPOP3.pl
    (mail body is cutted off, if no content type is availabe but 8bit chars are
    used).
 - 2008-02-22 Fixed bug#[2462](http://bugs.otrs.org/show_bug.cgi?id=2462) - Permission denied when trying to print ticket
    details from customer panel (customer.pl).
 - 2008-02-21 Added sendmail dummy backend module to deactivate sending
    emails, useful for test system (Kernel::System::Email::DoNotSendEmail).
 - 2008-02-20 Fixed bug#[2644](http://bugs.otrs.org/show_bug.cgi?id=2644) - Added unit tests to find easier wrong
    configured GD-CPAN modules.
 - 2008-02-20 Fixed bug#[2706](http://bugs.otrs.org/show_bug.cgi?id=2706) - SysConfig setting LogSystemCacheSize causes
    error messages.
 - 2008-02-19 Fixed bug#[2450](http://bugs.otrs.org/show_bug.cgi?id=2450) - Auto-conversion of URLs to links fail when
    a ')' is encountered.
 - 2008-02-18 Fixed bug#[2541](http://bugs.otrs.org/show_bug.cgi?id=2541) - Missing "Ticket unlock" link for ticket the
    actions 'Phone call', 'Merge', 'Move' and 'Forward'.
 - 2008-02-18 Fixed bug#[2145](http://bugs.otrs.org/show_bug.cgi?id=2145) - $Config{"TicketFreeTimeKey22"} instant of
    $Config{"TicketFreeTimeKey2"} in AgentTicketSearchResultShort.dtl.
 - 2008-02-18 Fixed bug#[2674](http://bugs.otrs.org/show_bug.cgi?id=2674) - Spellchecker always reports 0 errors
    even SpellCheckerBin is not configured correctly.
 - 2008-02-17 Improved bin/otrs.checkModules tool for checking required
    CPAN modules.
 - 2008-02-17 Fixed bug#[2255](http://bugs.otrs.org/show_bug.cgi?id=2255) - SysConfig setting Ticket -\>
    Frontend::Customer::Ticket::ViewZoom -\>
    Ticket::Frontend::CustomerTicketZoom###State has no effect (only
    closed is shown any time).
 - 2008-02-15 Fixed non fixed font and wrong new line breaking problem on
    safari in textarea input fields (updated Kernel/Output/HTML/Standard/css.dtl
    and Kernel/Output/HTML/Standard/customer-css.dtl).
 - 2008-02-15 Fixed bug#[2694](http://bugs.otrs.org/show_bug.cgi?id=2694) - URL-to-long-error in
    AdminCustomerUserService mask on changing settings.
 - 2008-02-14 Fixed bug#[2239](http://bugs.otrs.org/show_bug.cgi?id=2239) - CustomerCompanySupport is broken when
    using external backend DB.
 - 2008-02-12 Fixed bug#[2533](http://bugs.otrs.org/show_bug.cgi?id=2533) - Wide character error when searching for a
    customer with umlaut in LDAP backend with cache option (CacheTTL) in
    CustomerUser config option.
 - 2008-02-12 Fixed bug#[2638](http://bugs.otrs.org/show_bug.cgi?id=2638) - Broken email syntax check if
    \_somebody@example.com is used.
 - 2008-02-12 Fixed bug#[1957](http://bugs.otrs.org/show_bug.cgi?id=1957) - Auto reply for new Phone-Tickets goes to
    non-existing addresses (if no email address is given in From field).
 - 2008-02-12 Fixed bug#[2363](http://bugs.otrs.org/show_bug.cgi?id=2363) - AgentTicketPhone###Body is now a text area
    instead of a string.
 - 2008-02-11 Fixed bug#[1975](http://bugs.otrs.org/show_bug.cgi?id=1975) - OTRS cannot forward tickets with .eml file
    attachments.
 - 2008-02-11 Fixed bug#[2413](http://bugs.otrs.org/show_bug.cgi?id=2413) - OTRS cannot write to BLOB column in table
    XML\_STORAGE with DB2.
 - 2008-02-06 Fixed bug#[1716](http://bugs.otrs.org/show_bug.cgi?id=1716) - Wrong escalation time calculation on
    wintertime/summertime switch.
 - 2008-02-01 Fixed ticket# 2008012242000417 - View performance problems
    if more then 1000 customer companies are in the database available.

#2.2.5 2008-01-28
 - 2008-01-25 Fixed bug#[2645](http://bugs.otrs.org/show_bug.cgi?id=2645) - SLA selection doesn't change when customer is
    changed.
 - 2008-01-16 Fixed bug#[2157](http://bugs.otrs.org/show_bug.cgi?id=2157) - Ticket merged note not translated.
 - 2008-01-15 Fixed bug#[2392](http://bugs.otrs.org/show_bug.cgi?id=2392) - Charset problems with iso8859 and the
    xml-caching mechanism.
 - 2008-01-15 Implemented workaround for bug#[2227](http://bugs.otrs.org/show_bug.cgi?id=2227) - XMLHashSearch returns
    no values on MS SQL in certain cases.
 - 2008-01-14 Fixed bug#[2330](http://bugs.otrs.org/show_bug.cgi?id=2330) - Cron.sh start \<OTRS\_USER\> does not work.
    Thanks to Felix J. Ogris.
 - 2008-01-14 Fixed bug#[977](http://bugs.otrs.org/show_bug.cgi?id=977) - No agent notification for new ticket from
    webinterface if CustomerGroupSupport is enabled.
 - 2008-01-13 Added new vietnam translation, thanks to Nguyen Nguyet. Phuong!
 - 2008-01-13 Fixed bug#[2621](http://bugs.otrs.org/show_bug.cgi?id=2621) - Wrong order of items (Subject,Service,SLA,Body
    -\> Service,SLA,Subject,Body) in Frontend AgentTicketPhone, AgentTicketEmail
    and CustomerTicketMessage.
 - 2008-01-12 Fixed bug#[1687](http://bugs.otrs.org/show_bug.cgi?id=1687) - Wrong "New message!" hint on queue with
    "Customer State Notify" activated.
 - 2008-01-09 Fixed bug#[2613](http://bugs.otrs.org/show_bug.cgi?id=2613) - Images are broken in Lite-Theme if OTRS do
    not use the default Alias /otrs-web/.
 - 2008-01-08 Improved Kernel::System::XML::XMLParse() to prevent bugs
    like# 2612.
 - 2008-01-08 Fixed bug#[2609](http://bugs.otrs.org/show_bug.cgi?id=2609) - Temp files are not removed after process was
    finished under windows.
 - 2008-01-07 Fixed bug#[1893](http://bugs.otrs.org/show_bug.cgi?id=1893) - Attachment Storage fails with
    ArticleStorageFS in win32 with ? in filenames.
 - 2008-01-03 Fixed bug#[2491](http://bugs.otrs.org/show_bug.cgi?id=2491) - OTRS crash's after initial login on fresh
    installation on fedora 7, fedora 8, altlinux and ActiveState Perl on win32.
 - 2008-01-02 Fixed bug#[2601](http://bugs.otrs.org/show_bug.cgi?id=2601) - Only agents with rw permissions are shown in
    inform agent selection of a note screen (note permission need to be
    activated via SysConfig first). Now all agents with \_note\_ permissions are
    displayed.
 - 2008-01-02 Fixed bug#[2600](http://bugs.otrs.org/show_bug.cgi?id=2600) - MS SQL: Fulltext search in ticket body with
    mssql backend not possible (workaround, improved API for 2.3.x).
 - 2008-01-01 Fixed bug#[1120](http://bugs.otrs.org/show_bug.cgi?id=1120) - TO recipients which were sometimes dropped
    in a ticket reply.
 - 2008-01-01 Fixed bug#[2589](http://bugs.otrs.org/show_bug.cgi?id=2589) - Ticket-title not shown in ticket list of
    change customer, phone- and email ticket.
 - 2007-12-27 Fixed bug#[1148](http://bugs.otrs.org/show_bug.cgi?id=1148) - Lost of attachments when spliting ticket.
 - 2007-12-18 Fixed bug#[2295](http://bugs.otrs.org/show_bug.cgi?id=2295) - Added workaround for IE7. Tries to download
    [ Attachments ] or [ Attachments \<-\> Responses ].
 - 2007-12-17 Fixed bug#[2580](http://bugs.otrs.org/show_bug.cgi?id=2580) - Wrong quoating of semicolon if mssql is used.
 - 2007-12-17 Fixed bug#[2539](http://bugs.otrs.org/show_bug.cgi?id=2539) - SMIME signing was broken for private keys that
   have no passphrase and when openssl is unable to write to random state file.
 - 2007-12-12 Fixed bug#[2581](http://bugs.otrs.org/show_bug.cgi?id=2581) - Follow up not possible if "ticket#: xxxxxxx"
    is copied from webinterface into new email subject.
 - 2007-12-11 Fixed bug#[2479](http://bugs.otrs.org/show_bug.cgi?id=2479) - Unable to retrieve attachments bigger than
    3 MB (on Oracle DB). Changed default read size from 4 MB to 15 MB in
    Kernel/System/DB/oracle.pm:

```
      $Self->{'DB::Attribute'}      = {
        LongTruncOk => 1,
        LongReadLen => 15 * 1024 * 1024,
    };
```
 - 2007-12-10 Fixed bug#[1428](http://bugs.otrs.org/show_bug.cgi?id=1428) - Whitespaces remove from email subject
    (notification and new tickets creation) if utf-8 is used (specifically
    in Russian, Chinese  and Japanese).
    The problem is a bug in MIME::Tools/MIME::Words, for more info see
    CPAN-Bug# 5462: http://rt.cpan.org/Public/Bug/Display.html?id=5462
    As solution Kernel/cpan-lib/MIME/Words.pm got patched. Note: Everybody
    who is not using Kernel/cpan-lib/ need to wait till this bug is fixed
    in official MIME::Tools/MIME::Words releases.
 - 2007-12-10 Fixed bug#[2166](http://bugs.otrs.org/show_bug.cgi?id=2166) - Probem with HTML-mails sent by MS Outlook
    2003 - "&#8211;" / long dash gets not decoded.
 - 2007-12-10 Fixed bug#[2377](http://bugs.otrs.org/show_bug.cgi?id=2377) - Missing translation in
    AdminCustomerUserService mask.
 - 2007-12-03 Fixed bug#[2537](http://bugs.otrs.org/show_bug.cgi?id=2537) - Unable to set free time fields.
 - 2007-11-13 Fixed bug#[2498](http://bugs.otrs.org/show_bug.cgi?id=2498) - A wrong sum of requests was shown in the
    performance log.
 - 2007-11-07 Fixed bug#[2482](http://bugs.otrs.org/show_bug.cgi?id=2482) - IntroUpgradePre in .opm files is not working
    on upgradinging via online repository.

#2.2.4 2007-11-06
 - 2007-11-06 Fixed bug#[2477](http://bugs.otrs.org/show_bug.cgi?id=2477) - Escalation time calculation (destination time of
    escalation) is not working if host system is running in summertime/wintertime
    mode (loops because system is changing system time from 3:00 am to 2:00 am).
 - 2007-11-05 Fixed bug#[2474](http://bugs.otrs.org/show_bug.cgi?id=2474) - Config option UserSyncLDAPAttibuteGroupsDefination
    and UserSyncLDAPAttibuteRolesDefination is not working.
 - 2007-11-05 Fixed small typo in scripts/database/otrs-initial\_insert.xml, for
    escalation notification text.
 - 2007-11-05 Fixed bug#[2473](http://bugs.otrs.org/show_bug.cgi?id=2473) - Not able to update existing cache files of
    customer user backend because of file permission problems (cache files are
    created with 644). From now on cache files are created with 664 permissions.
 - 2007-11-05 Fixed bug#[2472](http://bugs.otrs.org/show_bug.cgi?id=2472) - Emails in utf8 are not sent correctly (problem
    after upgrading Kernel/cpan-lib/MIME/\*.pm).
 - 2007-10-26 Fixed bug#[2446](http://bugs.otrs.org/show_bug.cgi?id=2446) - Subject is not quoted.
 - 2007-10-26 Fixed bug#[2442](http://bugs.otrs.org/show_bug.cgi?id=2442) - Disappearing ticket free time checkboxes in
    some ticket masks after mask reloads.
 - 2007-10-26 Fixed bug#[2436](http://bugs.otrs.org/show_bug.cgi?id=2436) - Translation bug in the frontend function
    BuildSelection().
 - 2007-10-24 Fixed bug#[2289](http://bugs.otrs.org/show_bug.cgi?id=2289) - Compress with bzip2 dont works in backup.pl.
 - 2007-10-22 Fixed bug#[2421](http://bugs.otrs.org/show_bug.cgi?id=2421) - If customer cache backend is used, sometimes
    "Need Value" appears in the log file.
 - 2007-10-19 Fixed bug#[1203](http://bugs.otrs.org/show_bug.cgi?id=1203) - Changed Redhat shm workaround to use a fixed
    IPCKey per instance, but prevent clash with IPCKey of other instances.
 - 2007-10-19 Fixed bug#[2263](http://bugs.otrs.org/show_bug.cgi?id=2263) - Problems with array refs and escaping
 - 2007-10-18 Fixed bug#[2410](http://bugs.otrs.org/show_bug.cgi?id=2410) - $/ as given is currently unsupported at
    Kernel/cpan-lib/MIME/Decoder/NBit.pm line 140. We updated the CPAN module
    MIME-tools to version 5.423 to solve the problem.
 - 2007-10-17 Fixed bug#[2404](http://bugs.otrs.org/show_bug.cgi?id=2404) - Wrong results if you use StatsTypeID as
    TicketSearch attribute.
 - 2007-10-17 Fixed bug#[2407](http://bugs.otrs.org/show_bug.cgi?id=2407) - Performance handicap because of a missing
    'if'-attribute.
 - 2007-10-16 Improved performance of module by reduce calls of
    $Self-\>{ConfigObject}-\>Get() in Kernel/Output/HTML/Layout.pm and
    Kernel/System/Encode.pm.
 - 2007-10-16 Fixed bug#[2404](http://bugs.otrs.org/show_bug.cgi?id=2404) - Problems with the time extended feature in
    stats module.
 - 2007-10-15 Fixed bug#[2398](http://bugs.otrs.org/show_bug.cgi?id=2398) - Translate the stats output.
 - 2007-10-12 Fixed bug#[2388](http://bugs.otrs.org/show_bug.cgi?id=2388) - Show the radio button of static stats files.
 - 2007-10-10 Fixed bug#[2383](http://bugs.otrs.org/show_bug.cgi?id=2383) - IntroInstallPre in .opm files is not working
    on installing via online repository.
 - 2007-10-10 Fixed bug#[2380](http://bugs.otrs.org/show_bug.cgi?id=2380) - Ignore HTMLQuote param in Layout object
    function \_BuildSelectionOptionRefCreate.
 - 2007-10-09 Fixed bug#[2375](http://bugs.otrs.org/show_bug.cgi?id=2375) - Possible race condition in generic agent
    jobs (during processing jobs). Generic agent job attributes can get
    lost.
 - 2007-10-09 Fixed bug#[2276](http://bugs.otrs.org/show_bug.cgi?id=2276) - GenericAgent with SLA-Search fails, Service
    and SLA options are missing.
 - 2007-10-05 Fixed bug#[2360](http://bugs.otrs.org/show_bug.cgi?id=2360) - No Permission in customer panel after
    selecting ticket. Reason is, sender type is customer and article
    type is email-internal which is set via a postmaster filter.
 - 2007-10-02 Fixed bug#[2346](http://bugs.otrs.org/show_bug.cgi?id=2346) - Emty entries are shown in the responsible
    option list in TicketSearch mask.
 - 2007-09-24 Fixed bug#[2321](http://bugs.otrs.org/show_bug.cgi?id=2321) - It's not possible to use ï¿½ or ï¿½ in
    description tag of .sopm file -\> leading to perl syntax error!
 - 2007-09-17 Fixed bug#[2291](http://bugs.otrs.org/show_bug.cgi?id=2291) - Only include/use PDF::API2 in
    Kernel/Modules/AgentTicketSearch.pm and Kernel/Modules/AgentStats.pm
    if needed, to increase performance.

#2.2.3 2007-09-13
 - 2007-09-13 Fixed bug#[2285](http://bugs.otrs.org/show_bug.cgi?id=2285) - Typo in german translation
    "Aktualisierungszeit".
 - 2007-09-12 Fixed bug#[1203](http://bugs.otrs.org/show_bug.cgi?id=1203) - Redhat shm workaround should not relate to
    real shm request.
 - 2007-09-07 Fixed bug#[2265](http://bugs.otrs.org/show_bug.cgi?id=2265) - On IIS6, Package Manager is displaying a
    error after installing a package (header not complete). But package got
    installed corectly.
 - 2007-09-06 Fixed bug#[2261](http://bugs.otrs.org/show_bug.cgi?id=2261) - False params in call of ServiceLookup() and
    SLALookup() functions.
 - 2007-09-06 Fixed reopened bug#[2142](http://bugs.otrs.org/show_bug.cgi?id=2142) - Ticket history entry was wrong if
    service, sla or ticket type was changed.
 - 2007-09-03 Fixed bug#[2193](http://bugs.otrs.org/show_bug.cgi?id=2193) - Postmaster module
    Kernel::System::PostMaster::Filter::NewTicketReject is not working - need
    Charset!
 - 2007-09-03 Fixed bug#[2245](http://bugs.otrs.org/show_bug.cgi?id=2245) - Responsible / Owner Field not working for
    all users in the Email-Ticket form.
 - 2007-09-03 Improved system speed of escalation calculation if many open
    ticket (\> 2000) are there.
 - 2007-08-28 Fixed Ticket# 2007082842000477 - Problem with different customer
    sources and use CacheTTL option (namespace of cache is not uniq).
 - 2007-08-28 Fixed Ticket# 2007082842000413 - Ticket created over phone
    ticket with state closed is shown in queue view like "My Queues (1)" but
    no ticket is shown if I click on "My Queues (1)" (if
    Kernel::System::Ticket::IndexAccelerator::StaticDB is used as
    Ticket::IndexModule).
 - 2007-08-27 Fixed bug#[2230](http://bugs.otrs.org/show_bug.cgi?id=2230) - OTRS on IIS - redirect/loop problem after
    login.
 - 2007-08-27 Fixed bug#[2229](http://bugs.otrs.org/show_bug.cgi?id=2229) - Return value of "ServiceLookup" is used
    without quoting in SQL statements.
 - 2007-08-24 Fixed bug#[2207](http://bugs.otrs.org/show_bug.cgi?id=2207) - translation failure in customer preferences
    (QueueView refresh time).
 - 2007-08-24 Fixed bug#[2214](http://bugs.otrs.org/show_bug.cgi?id=2214) - .opm Package can not handle &lt;, &gt; and
    &amp; in .sopm files.
 - 2007-08-22 Improved Agent Notifications. Salutation of notfication
    recipient is now using \<OTRS\_UserFirstname\> and \<OTRS\_UserLastname\> instead
    of \<OTRS\_OWNER\_UserFirstname\> or \<OTRS\_OWNER\_UserLastname\>.
 - 2007-08-22 Fixed bug#[2203](http://bugs.otrs.org/show_bug.cgi?id=2203) - OTRS will not create/verify correct pgp
    signs if utf8 is used.
 - 2007-08-22 Fixed bug#[2202](http://bugs.otrs.org/show_bug.cgi?id=2202) - Kernel::System::Email::SMTP is sending
    "localhost.localdomain" in smtp hello, some server rejecting this ("Host
    not found").
 - 2007-08-21 Fixed bug#[2024](http://bugs.otrs.org/show_bug.cgi?id=2024) - Problem with agent authentication via LDAP
    with ADS-Groups and content of DN like "Some\, Name".
 - 2007-08-20 Fixed bug#[2094](http://bugs.otrs.org/show_bug.cgi?id=2094) and 2143 - 'Got no MainObject' warning in
    Kernel/System/Crypt.pm
 - 2007-08-20 Fixed bug#[2192](http://bugs.otrs.org/show_bug.cgi?id=2192) - Useless fragments of old escalation mechanism
    produces errors.
 - 2007-08-17 Fixed bug#[1908](http://bugs.otrs.org/show_bug.cgi?id=1908) - Removed duplicate history entry for ticket
    subscribe action.
 - 2007-08-16 Fixed bug#[1492](http://bugs.otrs.org/show_bug.cgi?id=1492) - Fixed typo in Kernel/Language.pm.
 - 2007-08-10 Fixed bug#[2160](http://bugs.otrs.org/show_bug.cgi?id=2160) - 0 was ignored in database insert by package
    building.
 - 2007-08-10 Fixed bug#[2156](http://bugs.otrs.org/show_bug.cgi?id=2156) - External customer database is not working,
    if it's configured the following error message appears
    ("Got no MainObject in Kernel/System/DB.pm line 85").
 - 2007-08-10 Fixed bug#[2155](http://bugs.otrs.org/show_bug.cgi?id=2155) - Std-Attachments are not usable in agent
    ticket compose screen (no std attachments are shown in compose screen).
 - 2007-08-07 Fixed bug#[2118](http://bugs.otrs.org/show_bug.cgi?id=2118) - Fixed typo in german translation file (
    Kernel/Language/de.pm).
 - 2007-08-07 Fixed bug#[2117](http://bugs.otrs.org/show_bug.cgi?id=2117) - Fixed small typo in initial insert files.
 - 2007-08-06 Fixed bug#[1999](http://bugs.otrs.org/show_bug.cgi?id=1999) - Service and SLA can not changed on an
    existing ticket.
 - 2007-08-06 Fixed bug#[2142](http://bugs.otrs.org/show_bug.cgi?id=2142) - If a service or a sla of a ticket was changed,
    no ticket history entry was added.
 - 2007-08-06 Fixed bug#[2135](http://bugs.otrs.org/show_bug.cgi?id=2135) - scripts/DBUpdate-to-2.2.2.sql contains wrong
    SQL. Not the queue table needs to be changed, the ticket table would be the
    right one.
 - 2007-08-03 Fixed bug#[2134](http://bugs.otrs.org/show_bug.cgi?id=2134) - PDF print is creating damaged pdf files with
    PDF::API2 0.56 or smaller.
 - 2007-08-02 Fixed bug#[940](http://bugs.otrs.org/show_bug.cgi?id=940) - After owners unlock ticket and a follow-up
    arrives the system, all agents which selected the queue of this ticket get
    and follow up message. In this follow up message the name was always the
    current owner and not the recipient of the email (which should be).
 - 2007-07-31 Fixed bug#[2001](http://bugs.otrs.org/show_bug.cgi?id=2001) - New escalation times and the responsible are
    not shown in any print views.

#2.2.2 2007-07-31
 - 2007-07-31 Fixed bug#[2114](http://bugs.otrs.org/show_bug.cgi?id=2114) - Fixed the problems with the email object.
 - 2007-07-30 Fixed bug#[2015](http://bugs.otrs.org/show_bug.cgi?id=2015) - Improved handling to allocate customerusers
    and services. Now it's possible to define default services.
 - 2007-07-27 Fixed bug#[2053](http://bugs.otrs.org/show_bug.cgi?id=2053) - If core "System::Permission" note is used,
    not effect to the ticket note mask appears.
 - 2007-07-27 Fixed bug#[2059](http://bugs.otrs.org/show_bug.cgi?id=2059) - config setting $Self-\>{'Database::Connect'}
    is not overwriting default option used by driver.
 - 2007-07-26 Fixed bug#[2105](http://bugs.otrs.org/show_bug.cgi?id=2105) - Notification after moving a ticket to my
    queues is wrong -\> "\> OTRS\_CUSTOMER\_QUEUE\<" got not replaced in subject.
    SQL files scripts/database/otrs-initial\_insert.\*.sql got fixed.
 - 2007-07-26 Fixed bug#[2029](http://bugs.otrs.org/show_bug.cgi?id=2029) - Selected responsible agent was not taken
    over after creating a phone ticket.
 - 2007-07-26 Fixed bug#[1946](http://bugs.otrs.org/show_bug.cgi?id=1946) - Setting of service, sla or type via email
     X-OTRS-Service, X-OTRS-SLA or X-OTRS-Type header not possible.
 - 2007-07-26 Fixed bug#[2097](http://bugs.otrs.org/show_bug.cgi?id=2097) - Sometimes problems with SMTP module and utf8
    to send emails.
 - 2007-07-26 Improved system performance of escalation (bug#[2020](http://bugs.otrs.org/show_bug.cgi?id=2020) Performance
    problem after updating to 2.2.0).
    --\>Because of this fact you need to add to new column to the ticket table.\<--

    ALTER TABLE ticket ADD escalation\_response\_time INTEGER;
    ALTER TABLE ticket ADD escalation\_solution\_time INTEGER;

 - 2007-07-26 Fixed bug#[2061](http://bugs.otrs.org/show_bug.cgi?id=2061) - UserSyncLDAPMap does not work properly after
    upgrade to 2.2. The reason is, that we cleaned up this config option and
    the new one from Kernel/Config/Defaults.pm need to be used. We also added
    an check which log that an old config setting is used (also an compat.
    feature to still use the old option has been added).

    If you use UserSyncLDAPMap you need to reconfigure it!

    Old style (till 2.1):
```
    $Self-\>{UserSyncLDAPMap} = {
        # DB -\> LDAP
        Firstname =\> 'givenName',
        Lastname =\> 'sn',
        Email =\> 'mail',
    };
```
    New style (beginning with 2.2):
```
    $Self-\>{UserSyncLDAPMap} = {
        # DB -\> LDAP
        UserFirstname =\> 'givenName',
        UserLastname =\> 'sn',
        UserEmail =\> 'mail',
    };
```
 - 2007-07-25 Added missing OTRS 2.2 sql update scripts for mssql and maxdb
    (scripts/DBUpdate-to-2.2.maxdb.sql and scripts/DBUpdate-to-2.2.mssql.sql).
 - 2007-07-23 Fixed bug#[2068](http://bugs.otrs.org/show_bug.cgi?id=2068) - Date problem with non en installations of
    MSSQL server. Some date inserts or package installations failed. Added
    database init connect option to mssql driver ("SET DATEFORMAT ymd" /
    Kernel/System/DB/mssql.pm).
 - 2007-07-23 Because of safety reason, generic agent jobs will not longer run
    without min. one search attribute (admin interface and cmd). So if you want to
    match all ticket, you need to add an \* in the ticket number.
 - 2007-07-23 Fixed bug#[2021](http://bugs.otrs.org/show_bug.cgi?id=2021) - Errors in MSSQL post schema files.
 - 2007-07-23 Fixed bug#[2025](http://bugs.otrs.org/show_bug.cgi?id=2025) - No upgrade PostgreSQL possible, added missing
    lines in DBUpdate-to-2.2.postgresql.sql.
 - 2007-07-22 Fixed Ticket#2007072342000148 - Old OTRS (\< OTRS 2.2)
    attachments are corrupt after upgrade if file backend is used.
 - 2007-07-16 Updated portuguese translation, thanks Filipe Henriques and
    Rui Pires!
 - 2007-07-16 Updated norwegian translation, thanks to Fredrik Andersen!
 - 2007-07-16 Updated hungarian translation, thanks to Aron Ujvari!
 - 2007-07-16 Updated spanish translation, thanks to Carlos Oyarzabal!
 - 2007-07-12 Fixed bug#[2016](http://bugs.otrs.org/show_bug.cgi?id=2016) - CustomerUserUpdate: Add a function to handle
    empty values.
 - 2007-07-11 Fixed bug#[2047](http://bugs.otrs.org/show_bug.cgi?id=2047) - Add MainObject to the needed object check.
 - 2007-07-10 Fixed bug#[2045](http://bugs.otrs.org/show_bug.cgi?id=2045) - Notifications on reopen are not sent to
    owner/responsible.
 - 2007-07-03 Fixed bug#[2011](http://bugs.otrs.org/show_bug.cgi?id=2011) - Translation problems in stats module.

#2.2.1 2007-07-01
 - 2007-06-29 Updated finnish translation, thanks to Mikko Hynninen!
 - 2007-06-29 Added some build in caches to Service, SQL, Queue and Valid
    core modules to reduce the amount of sql queries (saves ~ 10% of queries
    in the queue view).
 - 2007-06-29 Fixed bug#[1998](http://bugs.otrs.org/show_bug.cgi?id=1998) - Error with the web installer if no utf8
    database is selected.
 - 2007-06-28 Disabled only show escalated tickets in queue view because
    of already show escalation notifications.
 - 2007-06-28 Updated portuguese translation, thanks Filipe Henriques!
 - 2007-06-28 Fixed bug#[2000](http://bugs.otrs.org/show_bug.cgi?id=2000) - Typo in database update script
    DBUpdate-to-2.1.mysql.sql.
 - 2007-06-28 Reworked AdminCustomerUserService mask.
 - 2007-06-28 Fixed wildcard handling in ServiceSerarch().
 - 2007-06-27 Added option to log sql queries which take longer the 4 sek.
    and can be enabled via Kernel/Config.pm (Database::SlowLog). For more
    info see Kernel/Config/Defaults.pm.
 - 2007-06-26 Fixed not working alter table to SET or DROP NULL and NOT
    NULL via xml interface (Kernel/System/DB/postgresql.pm).
 - 2007-06-26 Updated french translation, thanks to Yann Richard and Remi Seguy!
 - 2007-06-26 Updated netherlands translation, thanks to Richard Hinkamp!
 - 2007-06-26 Updated hungarian translation, thanks to Aron Ujvari!
 - 2007-06-20 Updated russian translation, thanks to Andrey Feldman!
 - 2007-06-20 Updated greek translation, thanks to Stelios Maistros!

#2.2.0 rc1 2007-07-19
 - 2007-06-19 Fixed bug#[1941](http://bugs.otrs.org/show_bug.cgi?id=1941) - Ticket Escalation blocks QueueView even if
    Agent has only read access.
 - 2007-06-18 Improved TicketSubjectClean() that it is also working with
    longer Ticket::SubjectRe options like "Antwort: [Ticket#: 1234] Antwort: .."
    (which was not removed on email answers).
 - 2007-06-13 Fixed bug#[1951](http://bugs.otrs.org/show_bug.cgi?id=1951) - Changed default selection of 'valid' field in
    AdminService and AdminSLA mask.
 - 2007-06-12 Added feature (bug#[1949](http://bugs.otrs.org/show_bug.cgi?id=1949) an 1950) for customer ldap backend
    for soft or hard die.
 - 2007-06-12 Added customeruser to service relation feature.
 - 2007-05-31 Improved XMLHashAdd() and XMLHashUpdate() in
    Kernel/System/XML.pm to prevent caching errors.
 - 2007-05-31 Fixed bug#[1927](http://bugs.otrs.org/show_bug.cgi?id=1927) - It is possible to uninstall a required
    package.

#2.2.0 beta4 2007-05-29
 - 2007-05-26 Fixed bug in service and sla tables. Column comment was wrongly
    defined as required field.
 - 2007-05-24 Fixed bug#[1894](http://bugs.otrs.org/show_bug.cgi?id=1894) - otrs.addUser does not work
 - 2007-05-24 Fixed bug#[1913](http://bugs.otrs.org/show_bug.cgi?id=1913) - Added missing columns first\_response\_time,
    solution\_time and rename column escalation\_time to update\_time for table
    queue in DBUpdate-to-2.2.oracle.sql.
 - 2007-05-23 Add the ticket options Type, Service and SLA to the ticket
    print.
 - 2007-05-22 Add TicketType, Service and SLA option to stats module
    to improve flexibility of dynamic stats.
 - 2007-05-22 Remove wrong item in check needed stuff section of SLAList()
    function.
 - 2007-05-21 Update german translation.
 - 2007-05-21 Improved check of needed stuff in SLAAdd() function in
    Kernel/System/SLA.pm.
 - 2007-05-21 Sync HTML style of admin masks. No functionality changed.
    Kernel/Output/HTML/Standard/AdminAttachmentForm.dtl
    Kernel/Output/HTML/Standard/AdminAutoResponseForm.dtl
    Kernel/Output/HTML/Standard/AdminCustomerCompanyForm.dtl
    Kernel/Output/HTML/Standard/AdminCustomerUserForm.dtl
    Kernel/Output/HTML/Standard/AdminGenericAgent.dtl
    Kernel/Output/HTML/Standard/AdminGroupForm.dtl
    Kernel/Output/HTML/Standard/AdminLog.dtl
    Kernel/Output/HTML/Standard/AdminNotificationForm.dtl
    Kernel/Output/HTML/Standard/AdminPGPForm.dtl
    Kernel/Output/HTML/Standard/AdminPOP3.dtl
    Kernel/Output/HTML/Standard/AdminPackageManager.dtl
    Kernel/Output/HTML/Standard/AdminPerformanceLog.dtl
    Kernel/Output/HTML/Standard/AdminPostMasterFilter.dtl
    Kernel/Output/HTML/Standard/AdminQueueForm.dtl
    Kernel/Output/HTML/Standard/AdminResponseForm.dtl
    Kernel/Output/HTML/Standard/AdminRoleForm.dtl
    Kernel/Output/HTML/Standard/AdminSLA.dtl
    Kernel/Output/HTML/Standard/AdminSMIMEForm.dtl
    Kernel/Output/HTML/Standard/AdminSalutationForm.dtl
    Kernel/Output/HTML/Standard/AdminService.dtl
    Kernel/Output/HTML/Standard/AdminSession.dtl
    Kernel/Output/HTML/Standard/AdminSignatureForm.dtl
    Kernel/Output/HTML/Standard/AdminStateForm.dtl
    Kernel/Output/HTML/Standard/AdminSysConfig.dtl
    Kernel/Output/HTML/Standard/AdminSystemAddressForm.dtl
    Kernel/Output/HTML/Standard/AdminTypeForm.dtl
    Kernel/Output/HTML/Standard/AdminUserForm.dtl
 - 2007-05-21 Changes max shown escalated tickets in queue view to 30
    (to improved spped of escalation view in queue view).
 - 2007-05-21 Fixed double ContentType in ArticleAttachment() of attachment
    backends (Kernel/System/Ticket/ArticleStorage(DB|FS).pm).
 - 2007-05-21 Sync of all configurable frontend modules. No functionality
    changed.
    Kernel/Modules/AgentTicketClose.pm
    Kernel/Modules/AgentTicketFreeText.pm
    Kernel/Modules/AgentTicketNote.pm
    Kernel/Modules/AgentTicketOwner.pm
    Kernel/Modules/AgentTicketPending.pm
    Kernel/Modules/AgentTicketPriority.pm
    Kernel/Modules/AgentTicketResponsible.pm
    Kernel/Output/HTML/Standard/AgentTicketClose.dtl
    Kernel/Output/HTML/Standard/AgentTicketFreeText.dtl
    Kernel/Output/HTML/Standard/AgentTicketNote.dtl
    Kernel/Output/HTML/Standard/AgentTicketOwner.dtl
    Kernel/Output/HTML/Standard/AgentTicketPending.dtl
    Kernel/Output/HTML/Standard/AgentTicketPriority.dtl
    Kernel/Output/HTML/Standard/AgentTicketResponsible.dtl
 - 2007-05-21 Fixed bug#[1898](http://bugs.otrs.org/show_bug.cgi?id=1898) - Invalid services and slas was shown in agent
    masks.
 - 2007-05-16 Improved check of needed Charset param in Send() function to
    prevent problems like in bug#[1887](http://bugs.otrs.org/show_bug.cgi?id=1887).
 - 2007-05-14 Fixed bug#[1866](http://bugs.otrs.org/show_bug.cgi?id=1866) - Error while DB upgrade from 2.1.5 to 2.2.0
    beta3.
 - 2007-05-12 Ingresed width of html login tables from 270 to 280 because
    of new language selection.
 - 2007-05-11 Added script to convert a non utf-8 database to an utf-8
    database.
 - 2007-05-09 Fixed bug#[1825](http://bugs.otrs.org/show_bug.cgi?id=1825) - SQL ticket\_history INSERT syntax error in
    HistoryAdd().
 - 2007-05-08 Fixed bug#[1840](http://bugs.otrs.org/show_bug.cgi?id=1840) - Repeat escalation message when queue, SLA
    Solution time is shown.
 - 2007-05-07 Added DB::Encode database driver config (Kernel/System/DB/\*.pm)
    to set encoding of selected data to utf8 if needed.
 - 2007-05-07 Added cmd bin/otrs.RebuildConfig.pl to rebuild/build default
    Kernel/Config/Files/ZZZAAuto.pm based on Kernel/Config/Files/\*.xml config
    files.
 - 2007-05-07 Fixed bug#[1787](http://bugs.otrs.org/show_bug.cgi?id=1787) - Problem with cachefilenames of the stats
    module in win32.

#2.2.0 beta3 2007-05-07
 - 2007-05-04 Fixed bug#[1788](http://bugs.otrs.org/show_bug.cgi?id=1788) - Problem with cachefile in win32.
 - 2007-05-04 Fixed bug#[1773](http://bugs.otrs.org/show_bug.cgi?id=1773) - DB-error in phone ticket if sla but no
    service is selected.
 - 2007-05-04 Fixed bug#[1035](http://bugs.otrs.org/show_bug.cgi?id=1035) - OTRS does not set encoding for the mysql
    database connection (i.e. UTF-8).
 - 2007-05-04 Fixed bug#[1778](http://bugs.otrs.org/show_bug.cgi?id=1778) - Config option Database::Connect should be
    possible.
 - 2007-05-04 Fixed bug#[1611](http://bugs.otrs.org/show_bug.cgi?id=1611) - Now the Statsmodule use the mirror db if
    configured.
 - 2007-05-02 Fixed bug#[1809](http://bugs.otrs.org/show_bug.cgi?id=1809) - Fixed typo in variable name (PrioritiesStrg -\>
    PriotitiesStrg).
 - 2007-04-27 Fixed bug#[1670](http://bugs.otrs.org/show_bug.cgi?id=1670) - If no result the generation of pie graph throws
    error.
 - 2007-04-26 Added feature to use no BaseDN (or '') for agent and customer
    authentification (see ticket# 2007030642000446).
 - 2007-04-24 Fixed bug#[1769](http://bugs.otrs.org/show_bug.cgi?id=1769) - If I change the ticket SLA, the history is
    not relfecting this change.
 - 2007-04-24 Fixed bug#[1768](http://bugs.otrs.org/show_bug.cgi?id=1768) - If I change the ticket service, the history
    is not relfecting this change.

#2.2.0 beta2 2007-04-16
 - 2007-04-16 Fixed bug#[1448](http://bugs.otrs.org/show_bug.cgi?id=1448) - Apache::Registry in README.webserver wrong,
    mod\_perl2 is missing.
 - 2007-04-16 Fixed bug#[1286](http://bugs.otrs.org/show_bug.cgi?id=1286) - apache configuration should use
    \<IfModule mod\_perl.c\>.
 - 2007-04-16 Fixed bug#[1755](http://bugs.otrs.org/show_bug.cgi?id=1755) - Wrong permissions for some files.
 - 2007-04-16 Fixed bug#[1757](http://bugs.otrs.org/show_bug.cgi?id=1757) - Cannot install postgres db - null value in
    column "escalation\_start\_time" violates not-null constraint.
 - 2007-04-16 Fixed bug#[1745](http://bugs.otrs.org/show_bug.cgi?id=1745) - Invalid SQL-statements in AgentTicketQueue
    view.
 - 2007-04-13 Fixed bug#[1741](http://bugs.otrs.org/show_bug.cgi?id=1741) - "PostmasterFollowUpStateClosed" buggy on
    follow up actions.
 - 2007-04-12 Updated bulgarian translation, thanks to Alex Kantchev!
 - 2007-04-12 Fixed bug#[1748](http://bugs.otrs.org/show_bug.cgi?id=1748) - Session not allowed to be larger than 358400
    Bytes using IPC. Change max session size from 350k to 2 MB.
 - 2007-04-12 Fixed bug#[1744](http://bugs.otrs.org/show_bug.cgi?id=1744) - Unable to create xml\_storage table in utf8
    charset on mysql database.
 - 2007-04-12 Fixed bug#[1739](http://bugs.otrs.org/show_bug.cgi?id=1739) - Unable to insert new SLA via admin-web after
    upgrade to 2.2.0 beta1.
 - 2007-04-11 Added new Arabic (Saudi Arabia) translation, thanks to
    Mohammad Saleh!

#2.2.0 beta1 2007-04-02
 - 2007-04-02 Added customer company feature (split of contact and company
    infos). Need to be activated in CustomerUser config (see
    Kernel/Config/Defaults.pm).
 - 2007-03-27 Added enhancement #1688 - Backreference in postmaster filter
    replaces everything, not just the matched backreferenced token.
 - 2007-03-27 Added enhancement #1600 - Adjustable encoding for mails.
 - 2007-03-21 Updated cpan module CGI to version 3.27.
 - 2007-03-20 Added support of new set ticket pending time over X-OTRS-Header
    X-OTRS-State-PendingTime and X-OTRS-FollowUp-State-PendingTime.
 - 2007-03-20 Rewrite of Kernel::System::User module (cleanup of used params
    for UserAdd() and UserUpdate()).

    If you use this API, you need to change your custom implemention!

    Note If you use UserSyncLDAPMap you need to reconfigure it!

    Old:
```
    $Self->{UserSyncLDAPMap} = {
        # DB -> LDAP
        Firstname => 'givenName',
        Lastname => 'sn',
        Email => 'mail',
    };
```
    New:
```
    $Self->{UserSyncLDAPMap} = {
        # DB -> LDAP
        UserFirstname => 'givenName',
        UserLastname => 'sn',
        UserEmail => 'mail',
    };
```
 - 2007-03-14 Fixed not shown optional ticket free time option fields in
    customer panel.
 - 2007-03-11 Added enhancement bug#[1102](http://bugs.otrs.org/show_bug.cgi?id=1102) - restore.pl should check for
    existing tables and stop if already one exists.
 - 2007-03-11 Added enhancement bug#[1664](http://bugs.otrs.org/show_bug.cgi?id=1664) - increase max. WebMaxFileUpload
    size.
 - 2007-03-08 Improved Prepare() of Kernel::System::DB to fetch also rows
   between 10 and 30 (with start option of result). For example:
```
   $DBObject-\>Prepare(
       SQL =\> "SELECT id, name FROM table",
       Start =\> 10,
       Limit =\> 20,
   );
```
 - 2007-03-08 Improved XML database database backend for \<Insert\>. Content
    in xml attribut is not longer allowed, use the content instead. Now it's
    also possible to use new lines (\n) or more lines as content.

    Old style:
```
    <Insert Table="table_name">
        <Data Key="name_a" Value="Some Message A." Type="Quote"/>
        <Data Key="name_b" Value="Some Message B." Type="Quote"/>
    </Insert>
```
    New style:
```
    <Insert Table="table_name">
        <Data Key="name_a" Type="Quote">Some Message A.</Data>
        <Data Key="name_b" Type="Quote">Some Message B.</Data>
    </Insert>
```
 - 2007-03-08 Moved from scripts/database/initial\_insert.sql to database depend
    initial insert files located under scripts/database/otrs-initial\_insert.\*.sql.
    This files are generated from scripts/database/otrs-initial\_insert.xml.

    Note: The scripts/database/initial\_insert.sql exists not longer, use
    scripts/database/otrs-initial\_insert.\*.sql from now on for installations.

 - 2007-03-08 Fixed bug#[1017](http://bugs.otrs.org/show_bug.cgi?id=1017) - script initial\_insert.sql, ampersand and oracle.
 - 2007-03-08 Fixed enhacement bug#[1668](http://bugs.otrs.org/show_bug.cgi?id=1668) - removed unnecessary dependency for
    fetchmail from .srpms.
 - 2007-03-07 Added Intro support for .opm format to add intros for packages.
    For example to add infos where the module can be found, if you need to add
    some groups to access the module or some other useful stuff.
    Intro(Install|Reinstall|Upgrade|Uninstall)(Pre|Post) can be used. For more
    infos see the developer manual in section "Package Spec File".
 - 2007-03-07 Fixed bug#[1398](http://bugs.otrs.org/show_bug.cgi?id=1398) - Malformed UTF-8 charaters in Admin Backend -
    System Log.
 - 2007-03-05 Added Type, Service, SLA as ticket default attribute.
    Each an be activated by a config setting over SysConfig under
    Ticket :: Core :: Ticket.
 - 2007-02-15 Improved PGP decryption of files if more the one possible
    private key exists in the system and one of it is invalid (e. g. no
    configured password).
 - 2007-02-15 Fixed bug-ticket# 2007020542000593 - Queue refresh "off"
    can't be used on oracle database.
 - 2007-02-15 Add BuildSelection(). This function replaced OptionStrgHashRef(),
    OptionElement() AgentQueueListOption().
 - 2007-02-12 Added pending time selection feature for generic agent.
 - 2007-02-07 Moved to dtl block in customer ticket zoom view.
 - 2007-02-07 Moved default WebMaxFileUpload config option from 5 MB
    to 10 MB.
 - 2007-01-31 Fixed Free Field output in AgentTicketForward and
    AgentTicketPhoneOutbound.
 - 2007-01-30 Added 4 ticket freetime fields and improved freetime function.
 - 2007-01-30 Relocated valid functionality to new Valid.pm to move it
   out from Kernel/System/DB.pm.
 - 2007-01-18 Added X-OTRS-Lock and X-OTRS-FollowUp-Lock header for
    PostMaster.
 - 2007-01-17 Relocated agent preferences button.
 - 2007-01-17 Improved freetime feature, unset freetime is now possible by
    agent and customer GUI.
 - 2007-01-03 Heavy improvement of PerformanceLog feature, show detail
    view of each frontend module now.
 - 2007-01-03 Added config option for die or log is ldap/radius auth server
    is not available.
 - 2006-12-21 Improved description of Email- and Phone-Ticket in navigation.
 - 2006-12-21 Added config option to use SystemID in follow up detection or
    not (Ticket::NumberGenerator::CheckSystemID).
 - 2006-12-21 Added config option for follow-up state of tickets which
    was was already closed (Ticket::Core::PostMaster::PostmasterFollowUpStateClosed).
 - 2006-12-19 Added config option Ticket::NumberGenerator::CheckSystemID
    to configure if SystemID is used in follow up detection.
 - 2006-12-14 Removed old compat. CreateTicketNr()/CheckTicketNr() in
    Kernel/System/Ticket.pm and Kernel/System/Ticket/Number/\*.pm - so
    old ticket number generator not longer compat. to OTRS 2.1.
 - 2006-12-13 Moved config option setting SessionMaxTime from 10h to 14h.
 - 2006-12-13 Added auth and customer password crypt backend for crypt(),
    md5() and plain().
 - 2006-12-13 Added multi auth feature of agent and customer backend.
 - 2006-12-13 Added feature to configure password crypt type of agent and
    customer auth backend modules.
 - 2006-12-13 Added feature to match only exact email addresses of incoming
    emails in PostMaster filter like "From: EMAILADDRESS:someone@example.com".
    This only will match for email addresses like 'someone@example.com',
    'aaa.someone@example.com' will not match! This was a problem if you use
    normal "From: someone@example.com" match.
 - 2006-12-13 Added config option for online agent and customer module to
    show/not show email addresses of people (SysConfig: Framework
    Frontend::Agent::ModuleNotify and Frontend::Customer::ModuleNotify).
 - 2006-12-13 Moved config option PostMasterPOP3MaxEmailSize default 6 MB
    to 12 MB.

#2.1.9 2010-02-08
 - 2010-02-04 Fixed SQL quoting issue (see also
    http://otrs.org/advisory/OSA-2010-01-en/).
 - 2008-02-06 Fixed bug#[2491](http://bugs.otrs.org/show_bug.cgi?id=2491) - OTRS crash's after initial login on fresh
    installation on fedora 7, fedora 8, altlinux and ActiveState Perl on win32.

#2.1.8 2008-03-31
 - 2007-08-03 Fixed bug#[2134](http://bugs.otrs.org/show_bug.cgi?id=2134) - PDF print is creating damaged pdf files with
    PDF::API2 0.56 or smaller.
 - 2007-07-26 fixed bug#[2046](http://bugs.otrs.org/show_bug.cgi?id=2046) - german Umlauts not printed in PDFs if system
    runs in utf-8 mode. The PDF::API2 corefonts (which are used as default)
    doesn't support UTF-8. Changed the used fonts from PDF::API2 corefonts to
    the DejaVu true type fonts. Add config options to use other true type fonts.
 - 2007-05-31 fixed bug#[1926](http://bugs.otrs.org/show_bug.cgi?id=1926) - package manager ignore PackageRequired tags
    in OPM files.

#2.1.7 2007-04-05
 - 2007-04-05 fixed bug#[1551](http://bugs.otrs.org/show_bug.cgi?id=1551) - decode\_mimewords() in ArticleWriteAttachment()
    dies due to utf-8
 - 2007-03-27 updated Kernel/Language/pt\_BR.pm translation file - Thanks
    to Fabricio Luiz Machado!
 - 2007-03-14 fixed bug#[1650](http://bugs.otrs.org/show_bug.cgi?id=1650) - crypt/sign bug in AgentTicketCompose screen
 - 2007-03-14 fixed bug#[1659](http://bugs.otrs.org/show_bug.cgi?id=1659) - Uploading and Saving Pictures in MSSQL won't
    work with bigger Files (~700KB)

```
    ->MSSQL ONLY<- You also need to change some tables by using: ->MSSQL ONLY<-
        ALTER TABLE web_upload_cache ALTER COLUMN content TEXT NOT NULL;
        ALTER TABLE article_plain ALTER COLUMN body TEXT NOT NULL;
        ALTER TABLE article_attachment ALTER COLUMN content TEXT NOT NULL;
        ALTER TABLE article ALTER COLUMN a_body TEXT NOT NULL;
        ALTER TABLE standard_response ALTER COLUMN text TEXT NOT NULL;
        ALTER TABLE standard_attachment ALTER COLUMN content TEXT;
        ALTER TABLE sessions ALTER COLUMN session_value TEXT;
        ALTER TABLE xml_storage ALTER COLUMN xml_content_value TEXT;
        ALTER TABLE package_repository ALTER COLUMN content TEXT NOT NULL;
```
 - 2007-03-12 fixed upload cache problem in win32 .pdf files
 - 2007-03-12 fixed bug#[1228](http://bugs.otrs.org/show_bug.cgi?id=1228) - Apostrophe not valid in email address.
 - 2007-03-12 fixed bug#[1442](http://bugs.otrs.org/show_bug.cgi?id=1442) and 1559 - ArticleFreeKey and ArticleFreeText
    default selection does not work.
 - 2007-03-12 fixed ticket# 2007031242000149 - session backend fails to insert
    sessions bigger the 4k on oracle database backend
 - 2007-03-11 fixed bug#[1671](http://bugs.otrs.org/show_bug.cgi?id=1671) - restore.pl fails with "Got no LogObject"
 - 2007-03-11 fixed bug#[1115](http://bugs.otrs.org/show_bug.cgi?id=1115) - HTML error in NewTicket Customer's interface.
 - 2007-03-08 fixed bug#[1658](http://bugs.otrs.org/show_bug.cgi?id=1658) - Subqueues of Queues with brackets are not
    shown in the QueueView
 - 2007-03-08 added rpm packages for Fedora Core 4, 5 and 6 to auto build
    service
 - 2007-03-05 fixed ticket# 2007022342000586 - attachment problem with oracle
    backend if utf-8 is used
 - 2007-03-05 fixed database driver if 0 is used in begining of an xml insert

#2.1.6 2007-03-02
 - 2007-03-02 fixed bug#[1504](http://bugs.otrs.org/show_bug.cgi?id=1504) - Ticket Creation fails with DB2 due to
    character quoting issues
 - 2007-03-02 fixed bug#[1506](http://bugs.otrs.org/show_bug.cgi?id=1506) - Error creating Tickets in DB2 due to conflict
    in string/numerical comparison
 - 2007-03-02 fixed bug#[1445](http://bugs.otrs.org/show_bug.cgi?id=1445) - OTRS is not encoding Umlauts correctly in
    Organization email header
 - 2007-03-02 fixed bug#[1548](http://bugs.otrs.org/show_bug.cgi?id=1548) - submitting AgentTicketPhone or
    AgentTicketEmail form without queueid leads to broken fields
 - 2007-02-27 fixed bug#[1581](http://bugs.otrs.org/show_bug.cgi?id=1581) - Garbled paths containing domain names
 - 2007-02-27 updated Mail::Tools from 1.60 to 1.74 - fixed bug#[1642](http://bugs.otrs.org/show_bug.cgi?id=1642) -
    Cant get mails via PostmasterPop3.pl - Unrecognised line
 - 2007-02-27 fixed bug#[1545](http://bugs.otrs.org/show_bug.cgi?id=1545) - Wrong Variableusage in $Self-\>{PageShown}
    (Kernel/Modules/AgentTicketMailbox.pm)
 - 2007-02-26 fixed bug#[1291](http://bugs.otrs.org/show_bug.cgi?id=1291) - Download link in SysConfig skips config
    options -\> now download link will be shown if no changes are done
 - 2007-02-26 fixed bug#[1097](http://bugs.otrs.org/show_bug.cgi?id=1097) - Disabling Bounce Feature via SysConfig does
    not work properly
 - 2007-02-26 fixed ticket #2007022242000293 hard line rewrap of body content
    in frontend modules
 - 2007-02-26 improved speed of SysConfig core module, added cache mechanism
    (it's about 2 times faster)
 - 2007-02-22 fixed ticket #2007022042000288 - error on creating postmaster
    filter on oracle database
 - 2007-02-20 fixed not working crypt/sign option in AgentTicketCompose mask
 - 2007-02-20 fixed bug#[980](http://bugs.otrs.org/show_bug.cgi?id=980) - Use of uninitialized value in
    Kernel/System/AuthSession/FS.pm
 - 2007-02-15 changed unlock time reset mechanism, added unlock time reset
    if a agent sends an external message to the customer (like escalation
    reset mechanism)
 - 2007-02-09 fixed bug in \_XMLHashAddAutoIncrement() - function could not
    return keys greater than '9'.
 - 2007-02-02 fixed bug#[1056](http://bugs.otrs.org/show_bug.cgi?id=1056) - UTF-8 mode of OTRS and German Umlaute within
    agent's name
 - 2007-02-02 fixed bug#[1505](http://bugs.otrs.org/show_bug.cgi?id=1505) - UserSyncLDAPMap fails with LDAP.pm version
    1.26 and up
 - 2007-01-30 fixed ticket\_watcher.user\_id datatype, moved from BIGINT to
    INTEGER
 - 2007-01-30 fixed oracle driver for xml alter table actions
 - 2007-01-30 improved \_CryptedWithKey() - private key detection of
    Kernel/System/Crypt/PGP.pm if more keys are used for crypted messages
 - 2007-01-26 fixed ArticleFreeText output in CustomerTicketZoom mask
 - 2007-01-26 fixed bug in agent- and customer-ticket print feature

#2.1.5 2006-01-25
 - 2007-01-25 fixed ignored ticket responible in phone ticket
 - 2007-01-18 fixed DestinationTime() if calendar feature is used
 - 2007-01-17 fixed not working freetime fields
 - 2007-01-11 fixed not working time selection if time zone feature is used
 - 2007-01-08 fixed not working email notification tags in auto response,
    agent and customer email notifications
 - 2007-01-08 fixed case sensitive of customer user login and agent user
    login in Kernel/System/User.pm and Kernel/System/CustomerUser/DB.pm if
    oracle or postgresql is used
 - 2007-01-08 fixed quoting in user selection if + is used in UserLogin in
    Kernel/Output/HTML/Standard/AdminCustomerUserForm.dtl
 - 2006-12-17 fixed bug#[1532](http://bugs.otrs.org/show_bug.cgi?id=1532) - utf-8 charsetproblems in stats
 - 2006-12-15 fixed bug#[1446](http://bugs.otrs.org/show_bug.cgi?id=1446) - No "(Ticket unlock!)" link in
    AgentTicketCompose
 - 2006-12-14 fixed customer ldap auth if system is iso-8859 and ldap server
    is running in utf-8
 - 2006-12-14 fixed not working Kernel/System/DB/db2.pm (syntax error)

#2.1.4 2006-12-13
 - 2006-12-13 fixed not working free time selection in AgentTicketClose,
    AgentTicketNote, AgentTicketOwner, AgentTicketPending, AgentTicketPriority
    and AgentTicketResponsible
 - 2006-12-11 added config param for shown my queues/custom queues
    in preferences, default are shown all ro queues, see also
    PreferencesGroups###CustomQueue under Frontend::Agent::Preferences
 - 2006-12-11 fixed ldap sync of agents attributes - invalid agents
    are not longer synced to valid if ldap auth was successfully, the
    invalid agent will still be invalid
 - 2006-12-11 fixed bug#[1187](http://bugs.otrs.org/show_bug.cgi?id=1187) - Escalation Notifications sent to invalid agent
 - 2006-12-11 improved link quote of long links in web interface
 - 2006-12-11 fixed bug#[962](http://bugs.otrs.org/show_bug.cgi?id=962) - Broken attachments with cyrillic filenames
 - 2006-12-08 fixed bug#[1521](http://bugs.otrs.org/show_bug.cgi?id=1521) - Merge Feature
 - 2006-12-08 fixed bug#[1523](http://bugs.otrs.org/show_bug.cgi?id=1523) - update of FreetextValues 9-16 not working
 - 2006-12-08 fixed bug#[1524](http://bugs.otrs.org/show_bug.cgi?id=1524) - ticketFreeText Fields 9-16 not displayed
    at CustomerTicketPrint and CustomerTicketZoom
 - 2006-12-07 fixed bug#[1359](http://bugs.otrs.org/show_bug.cgi?id=1359) - acl problem if '' is used in properties to match
 - 2006-12-07 fixed bug#[1031](http://bugs.otrs.org/show_bug.cgi?id=1031) - scripts/backup.pl fails in mysqldump with
    encrypted database password
 - 2006-12-07 fixed bug#[1378](http://bugs.otrs.org/show_bug.cgi?id=1378) - Got no MainObject! in bin/otrs.getTicketThread
 - 2006-12-07 fixed bug#[1200](http://bugs.otrs.org/show_bug.cgi?id=1200) - not working TicketACL actions AgentTicketCompose,
    AgentTicketBounce, AgentTicketForward and AgentTicketPhoneOutbound
 - 2006-12-07 added log notice for switch to user admin feature
 - 2006-12-07 fixed bug#[1210](http://bugs.otrs.org/show_bug.cgi?id=1210) - wrong calculation of Kernel::System::Time
    WorkingTime()
 - 2006-12-06 added changes notice of generic agent jobs to log sub
    system (to keep clear who changed the job)
 - 2006-12-05 moved ticket number generator loop check from 1000 to 6000
    (Kernel/System/Ticket/Number/\*.pm)
 - 2006-11-30 fixed not working faq lookup in compose answer and forward
    screen
 - 2006-11-30 fixed double quoted "$Quote{"Cc: (%s) added database email!""}
    in compose answer screen (Kernel/Modules/AgentTicketCompose.pm)
 - 2006-11-30 fixed bug#[1498](http://bugs.otrs.org/show_bug.cgi?id=1498) - Typo in QuoteSingle, Kernel/System/DB/mssql.pm
 - 2006-11-30 moved Quote() from Kernel/System/DB.pm to db backend modules
    Kernel/System/DB/\*.pm because of needed Quote() in xml processing
 - 2006-11-23 improved handling if there are double customer users in
    the database used by search result
 - 2006-11-22 fixed PGP/SMIME bug - Can't call method "body" on an undefined
    value at Kernel/System/EmailParser.pm line 382
 - 2006-11-22 fixed bug#[1395](http://bugs.otrs.org/show_bug.cgi?id=1395) - utf-8 - ArticleStorage FS - Attachments with
    German Umlauts cant be downloaded
 - 2006-11-17 added config option Ticket::PendingNotificationOnlyToOwner
    to send reached reminder notifications of unlocked tickets only to ticket
    owner
 - 2006-11-17 fixed database driver detection/problem if a second database
    connect with different driver is used (wrong sql will not longer be
    generated) Note: old database driver files Kernel/System/DB/\*.pm
    not longer compatible
 - 2006-11-17 added config option Ticket::ResponsibleAutoSet to set owner
    automatically as responsible if no responsible is set (default is 1)

#2.1.3 2006-11-15
 - 2006-11-15 removed not needed Reply-To of agent notifications
 - 2006-11-15 fixed missing \n on csv output of customer ticket search
 - 2006-11-15 fixed not working ticket free time option in phone ticket
 - 2006-11-15 added missing access permission pre check to show ticket menu
    items or not
 - 2006-11-15 fixed bug - not shown empty "-" selection of new onwer if on
    move if Ticket::ChangeOwnerToEveryone is set
 - 2006-11-10 update of Dansk language file, thanks to Mads N. Vestergaard
 - 2006-11-10 update of Spanish language file, thanks to Jorge Becerra
 - 2006-11-09 added AuthModule::HTTPBasicAuth::Replace and
    Customer::AuthModule::HTTPBasicAuth::Replace config option to HTTPBasicAuth
    modules to strip e. g. domains like example\_domain\user from login down to user
 - 2006-11-09 added AuthModule::LDAP::UserLowerCase to allways convert
     usernames into lower case letters
 - 2006-11-07 added set auto time zone of agent/customer based on java script
    offset feature on every login
 - 2006-11-07 fixed not working all owner/responsible selection in phone view
 - 2006-11-07 read out CustomerUserSearchListLimit correctly if LDAP customer
    backend is in use
 - 2006-10-27 fixed always shown responsible selection
 - 2006-10-27 removed not needed default free text fields from phone outbound
 - 2006-10-26 fixed agent can be customer follow up feature
 - 2006-10-26 added possible - selection for next state in phone view outbount
 - 2006-10-20 fixed LDAP problems "First bind failed! No password, did you
    mean noauth or anonymous ?"
 - 2006-10-19 fixed double agent notifications on ticket move to queue
    and also selected owner

#2.1.2 2006-10-18
 - 2006-10-13 switched to md5 check sum for password in user\_preference table
 - 2006-10-12 fixed #1373 - RH RPM requires sendmail, but works with other MTAs
 - 2006-10-12 fixed double agent notifications on follow up if agent is
    owner and responible
 - 2006-10-12 fixed bug#[1311](http://bugs.otrs.org/show_bug.cgi?id=1311) - Apostrophes are incorrectly displayed under
    IE 6 & IE7 but correctly displayed under Firefox 1.5.0.6  -=\>
    moved from $Text{} to $JSText{} for text translations in Java Script parts
    to have a correct quoting
 - 2006-10-11 fixed not shown follow up feature in customer panel if ticket
     is closed
 - 2006-10-09 added missing customer print feature
 - 2006-10-05 fixed bug#[1361](http://bugs.otrs.org/show_bug.cgi?id=1361) - Can't locate object method "ModGet" via
    package "Kernel::System::Config"

#2.1.1 2006-10-05
 - 2006-10-05 fixed bug#[1213](http://bugs.otrs.org/show_bug.cgi?id=1213) - some errors not logger by LDAP backends
 - 2006-10-05 fixed bug#[1248](http://bugs.otrs.org/show_bug.cgi?id=1248) - Ticket Zoom - Article Thread - Color of auto
    responses should be yellow
 - 2006-10-05 fixed bug#[1323](http://bugs.otrs.org/show_bug.cgi?id=1323) - 2.1 DBUpgrade issue with PostgreSQL - patch
 - 2006-10-05 fixed bug#[1333](http://bugs.otrs.org/show_bug.cgi?id=1333) - No reset of escalation time after follow-up
 - 2006-10-05 fixed bug#[1345](http://bugs.otrs.org/show_bug.cgi?id=1345) - Attached binary files uploaded and saved to
    the FS are corrupted.
 - 2006-09-30 add ticketfreetext-, ticketfreetime- and articlefreetext support
    to pdf output
 - 2006-09-28 improved stats export/import with an id-name wrapper
 - 2006-09-28 fixed bug#[1353](http://bugs.otrs.org/show_bug.cgi?id=1353)/1354 changed autoreponse text
 - 2006-09-27 add transparency to some images
 - 2006-09-27 fixed bug#[1358](http://bugs.otrs.org/show_bug.cgi?id=1358) - Customer History \> All customer tickets.
    returns an incorrect number of tickets
 - 2006-09-27 fixed bug#[1293](http://bugs.otrs.org/show_bug.cgi?id=1293) - Can't use an undefined value as a HASH
    reference at /opt/otrs/bin/cgi-bin//../../Kernel/Modules/AgentTicketBulk.pm
    line 194
 - 2006-09-27 fixed bug#[1356](http://bugs.otrs.org/show_bug.cgi?id=1356) - mssql driver bug - Stats module of OTRS 2.1
    beta 2 - "Cant use string ("0")".
 - 2006-09-27 fixed bug#[1335](http://bugs.otrs.org/show_bug.cgi?id=1335) - removed "uninitialized value" warning in
    NavBarTicketWatcher.pm
 - 2006-09-22 fixed opm check do not install/upgrade packages if one file to
    install already exists in an other package
 - 2006-09-22 added "-a exportfile" feature to bin/opm.pl to export files
    of a package into a defined directory e. g. "-d /path/to/"
 - 2006-09-21 removed Re: from agent notification emails
 - 2006-09-14 added change to remove 4 not needed empty spaces after folding
    of email headers (sometimes 4 empty spaces in subject appear)
 - 2006-09-09 updated pdf-logo to ((otrs))
 - 2006-09-09 added DBUpdate-to-2.1.oracle.sql to get oracle databases up to
    date
 - 2006-09-05 fixed double sending of note notifications
 - 2006-09-05 fixed link to email and phone after adding a new customer user
 - 2006-09-01 added fix to removed leading and trailing spaces in search
    fields of object linking

#2.1.0 beta2 2006-08-29
 - 2006-08-29 moved Frontend::ImagePath variable
   (/otrs-web/images/Standard/) from .dtl files to config option
 - 2006-08-28 added examples how to use SOAP (bin/cgi-bin/rpc.pl and
    scripts/rpc-example.pl)
 - 2006-08-27 added mulit calendar / queue support - you can use different
    time zones in different queues and each agent can select the own time zone
    NOTE: table queue need to be modified - see scripts/DBUpdate-to-2.1.\*.sql
 - 2006-08-27 fixed bug#[739](http://bugs.otrs.org/show_bug.cgi?id=739) - in the login you can type something behind the
    pass and it works / added password md5 support (required Crypt::PasswdMD5
    from CPAN or from Kernel/cpan-lib/ - via "cvs update -d")
 - 2006-08-26 fixed $Quote{""} bug in login page
 - 2006-08-25 fixed bug#[1284](http://bugs.otrs.org/show_bug.cgi?id=1284) - removed mysql dependence in
    scripts/apache-perl-startup.pl and scripts/apache2-perl-startup.sql
 - 2006-08-25 fixed bug#[1282](http://bugs.otrs.org/show_bug.cgi?id=1282) - setting up a postgresql database fails
 - 2006-08-24 added performance log feature in admin interface to monitor
    your system page load performance over different times (1h, 3h, 9h, 1d, 2d,
    3d) - its disabled per default
 - 2006-08-24 removed Re: in subject auto response emails
 - 2006-08-22 added PDF output support to AgentTicketPrint module
 - 2006-08-21 fixed bug in pdf module - redesiged Table() to fix a lot of
    infinite loops
 - 2006-08-08 fixed bug in pdf module - special control characters produces
    infinite loops
 - 2006-08-02 added ldap attribute to groups/roles sync feature, so its
    possible to use user attributes for permission handling
 - 2006-08-02 fixed bug#[1283](http://bugs.otrs.org/show_bug.cgi?id=1283) - test for modules executed in cronjobs

#2.1.0 beta1 2006-08-02
 - 2006-07-31 added cmd option for bin/opm.pl to find package of file
    e. g. bin/opm.pl -a file -p Kernel/System/FileA.pm
 - 2006-07-31 added sleep in bin/PostMasterPOP3.pl after 10 (2 sec) and
    25 (3 sec) emails on one stream (protect server against overload)
 - 2006-07-31 added PDF output feature for stats module and ticket search results
 - 2006-07-26 updated to cpan MIME::Tools 5.420
 - 2006-07-26 changed ticket escalation method, escalation start will
    be reseted after every "new" customer message and after agent
    communication to customer
 - 2006-07-25 added new link object functions and db table link\_object changes
 - 2006-07-23 added \<OTRS\_CUSTOMER\_DATA\_\*\> tags to auto responses
 - 2006-07-23 added support of mssql database server (experimental)
 - 2006-07-18 added new feature to sync ldap groups into otrs roles
    (see more in Kernel/Config/Defaults.pm under UserSyncLDAPGroupsDefination
    and UserSyncLDAPRolesDefination)
 - 2006-07-14 new stats framework implemented :-)
 - 2006-07-14 fixed bug#[1258](http://bugs.otrs.org/show_bug.cgi?id=1258) - changed language description from Traditional Chinese
    to Simplified Chinese
 - 2006-07-04 fixed bug#[1151](http://bugs.otrs.org/show_bug.cgi?id=1151) - Error when changing customer on ticket in
 - 2006-07-11 improved performance of ticket search mask (in cases with
    over 500 Agents and over 50 Groups) by adding GroupMemberInvolvedList()
    and modify GroupMemberList(), GroupGroupMemberList(), GroupRoleMemberList()
    and GroupUserRoleMemberList() at Kernel/System/Group.pm
 - 2006-07-11 fixed bug#[1132](http://bugs.otrs.org/show_bug.cgi?id=1132) - Wrong display of escalation time
 - 2006-07-04 fixed bug#[1151](http://bugs.otrs.org/show_bug.cgi?id=1151) - Error when changing customer on ticket in
    TicketStatusView
 - 2006-06-26 added ticket watcher feature, per default it's disabled
 - 2006-06-22 fixed bug#[1240](http://bugs.otrs.org/show_bug.cgi?id=1240) - Tickets not shown in "New messages" if
    Auto Response "Reply" is active
 - 2006-06-14 fixed bug#[1206](http://bugs.otrs.org/show_bug.cgi?id=1206) - When no RELEASE file is available, no
    product and version is displaied and strange messages apear in the
    apache error log;  using standard values in this case now
 - 2006-06-13 added public frontend module to serve local repository as
    remote repository (accessable via IP authentication)
 - 2006-06-13 fixed bug#[1154](http://bugs.otrs.org/show_bug.cgi?id=1154) - Problem in displaying pending tickets
    in agent mailbox
 - 2006-06-07 improved postmaster follow up detection by scanning email
    body, attachment and/or raw email (all is disabled by default)
 - 2006-06-02 fixed bug#[1023](http://bugs.otrs.org/show_bug.cgi?id=1023) - Comma in From field creates multiple emails
    in webform.pl
 - 2006-04-27 fixed IE problem with image-buttons
    involved files: AdminSysConfigEdit.dtl and AdminSysConfig.pm
 - 2006-04-26 fixed format bug in Package Manager - PackageView
 - 2006-04-06 moved to read any language files located under
    Kernel/Language/xx\_\*.pm at each request to have any translated words
    e. g. for navigation bar available (Kernel/Language/xx\_Custom.pm is
    still used as latest source file)
 - 2006-03-28 added config option to show ticket title in main header
    of frontend (e. g. QueueView, ZoomView and Mailbox)
 - 2006-03-24 moved from "otrs" to "otrs-x.x.x" directory in
    tar.gz / tar.bz download format
 - 2006-03-22 added article free text attrubutes
 - 2006-03-21 moved from Kernel::Output::HTML::Generic to
    Kernel::Output::HTML::Layout - all sub modules localted under
    Kernel/Output/HTML/Layout\*.pm will ne loaded automatically
    at runtime
 - 2006-03-20 improved ticket zoom to shown attachments with
    html title about attachment info (name, size, ...)
 - 2006-03-20 added use of current config values in admin sysconfig
    fulltext search
 - 2006-03-11 fixed some spelling mistakes for the English original in
    language templates and language files
 - 2006-03-10 added admin init (Kernel/Modules/AdminInit.pm) to init
    config files .xml-\>.pm after a new setup (after initial root login)
 - 2006-03-04 splited Kernel::Modules::AgentTicketPhone into
    two modules Kernel::Modules::AgentTicketPhone and
    Kernel::Modules::AgentTicketPhoneOutbound (phone calls for existing
    tickets) also templates are renamed!
 - 2006-03-04 cleanup for ticket event names (added compat mode):
    TicketCreate, TicketDelete, TicketTitleUpdate, TicketUnlockTimeoutUpdate,
    TicketEscalationStartUpdate, TicketQueueUpdate (MoveTicket),
    TicketCustomerUpdate (SetCustomerData), TicketFreeTextUpdate
    (TicketFreeTextSet), TicketFreeTimeUpdate (TicketFreeTimeSet),
    TicketPendingTimeUpdate (TicketPendingTimeSet), TicketLockUpdate (LockSet),
    TicketStateUpdate (StateSet), TicketOwnerUpdate (OwnerSet),
    TicketResponsibleUpdate, TicketPriorityUpdate (PrioritySet), HistoryAdd,
    HistoryDelete, TicketAccountTime, TicketMerge, ArticleCreate,
    ArticleFreeTextUpdate (ArticleFreeTextSet), ArticleUpdate, ArticleSend,
    ArticleBounce, ArticleAgentNotification, (SendAgentNotification),
    ArticleCustomerNotification (SendCustomerNotification), ArticleAutoResponse
    (SendAutoResponse), ArticleFlagSet
 - 2006-03-04 added own X-OTRS-FollowUp-\* header if Queue, State, Priority,
    ...  should be changed with follow up emails (see: doc/X-OTRS-Headers.txt)
 - 2006-03-04 reworked "config options" and "interface" of \_all\_ agent
    ticket interfaces to get is clear
 - 2006-03-03 replaced ticket config option "Ticket::ForceUnlockAfterMove"
    with ticket event module "Ticket::EventModulePost###99-ForceUnlockOnMove"
 - 2006-03-03 replaced ticket config option "Ticket::ForceNewStateAfterLock"
    with ticket event module "Ticket::EventModulePost###99-ForceStateChangeOnLock"
 - 2006-03-03 added "responsible" ticket feature!
    (db update with scripts/DBUpdate-to-2.1.(mysql|postgres).sql)
 - 2006-03-03 added persian translation (incl. TextDirection support)
    - Thanks to Amir Shams Parsa!
 - 2006-02-16 added default ticket event module to reset ticket owner
    after move action (it's disable per default)
 - 2006-02-10 added default next state in ticket forward
 - 2006-02-10 added OTRS\_Agent\_\* tags like OTRS\_Agent\_UserFirstname and
    OTRS\_Agent\_UserLastname for salutation and signature templates
 - 2006-02-05 added update and insert via admin sql box
 - 2006-02-05 'removed old compat files' Kernel/Config/Files/Ticket.pm
    and Kernel/Config/Files/TicketPostMaster.pm
 - 2006-02-05 added 8 more ticket free text fields
    (db update with scripts/DBUpdate-to-2.1.(mysql|postgres).sql)
 - 2006-01-07 added SendNoNotification option for MoveTicket(),
    LockSet() and OwnerSet() in Kernel/System/Ticket.pm (used in
    GenericAgent to do some admin stuff).
 - 2005-12-29 added online repository access for bin/opm.pl
 - 2005-12-29 added Delete and Spam config option to
    Kernel/Config/Files/Ticket.xml for Ticket::Frontend::MenuModule
 - 2005-12-21 added column type check in xml database defination
 - 2005-12-20 added unit test system
 - 2005-12-17 improved admin view of session management
 - 2005-12-04 moved FAQ from framework to own application module
    (can be installed over opm online repository now)
 - 2005-11-27 moved otrs archive directory for download and in RPMs
    from otrs to otrs-x.x.x
 - 2005-11-20 added multi pre application module support, just
    define it like:
```
    $Self->{PreApplicationModule}->{AgentInfo} = 'Kernel::Modules::AgentInfo';
```

#2.0.5 2007-05-22
 - 2007-05-22 fixed bug#[1842](http://bugs.otrs.org/show_bug.cgi?id=1842) - Cross-Site Scripting Vulnerability
 - 2007-01-11 fixed bug#[1515](http://bugs.otrs.org/show_bug.cgi?id=1515) - Some GenericAgent names don't work
    (e. g. names with +)
 - 2007-01-11 fixed bug#[1496](http://bugs.otrs.org/show_bug.cgi?id=1496) - GenericAgent: "Ticket created last..."
    does not work
 - 2006-07-11 fixed bug#[1132](http://bugs.otrs.org/show_bug.cgi?id=1132) - Wrong display of escalation time
 - 2006-07-11 added missing utf-8 encoding in agent and customer auth
 - 2006-07-11 added missing utf-8 encoding customer user backend
 - 2006-07-04 changed language description from Traditional Chinese to
    Simplified Chinese (bug#[1258](http://bugs.otrs.org/show_bug.cgi?id=1258))
 - 2006-07-04 fixed bug#[1151](http://bugs.otrs.org/show_bug.cgi?id=1151) - Error when changing customer on ticket in
    TicketStatusView
 - 2006-06-17 fixed bug#[1240](http://bugs.otrs.org/show_bug.cgi?id=1240) - Tickets not shown in "New messages" if
    Auto Response "Reply" is active
 - 2006-06-14 fixed bug#[1206](http://bugs.otrs.org/show_bug.cgi?id=1206) - When no RELEASE file is available, no
    product and version is displaied and strange messages apear in the
    apache error log;  using standard values in this case now
 - 2006-06-13 fixed bug#[1154](http://bugs.otrs.org/show_bug.cgi?id=1154) - Problem in displaying pending tickets
    in agent mailbox
 - 2006-06-02 fixed bug#[1023](http://bugs.otrs.org/show_bug.cgi?id=1023) - Comma in From field creates multiple emails
    in webform.pl
 - 2006-03-24 added SUSE 10.x RPM support
 - 2006-03-24 fixed bug#[925](http://bugs.otrs.org/show_bug.cgi?id=925) - Binary Attachments incorrectly utf-8
    encoded in ticket replies
 - 2006-03-23 fixed links to new phone/email ticket after a new
    customer is created via Kernel/Modules/AdminCustomerUser.pm
 - 2006-03-21 update of Portuguese language file  - Thanks to
    Manuel Menezes de Sequeira)
 - 2006-03-18 added Greek translation - Thanks to Stelios Maistros!
 - 2006-03-16 fixed bug#[991](http://bugs.otrs.org/show_bug.cgi?id=991) - changed $Data{} to $QData{} in Ticket.xml
    and Ticket.pm config files to solve problem when answering requests
    that contain HTML tags
 - 2006-03-16 updated Dutch language file - Thanks to Richard Hinkamp!
 - 2006-03-16 added Slovak translation
 - 2006-03-10 fixed/removed die in Kernel/System/AuthSession/FS.pm
    -=\> GetSessionIDData() - not wanted to die if nn SessionID is given
 - 2006-03-08 added Danish translation - Thanks to Thorsten Rossner!
 - 2006-03-08 updated Norwegian translation - Thanks to Knut Haugen
 - 2006-03-08 fixed some spelling mistakes for the English original in
    language templates and language files
 - 2006-02-12 updated Brazilian Portuguese translation -Thanks to
    Fabricio Luiz Machado!
 - 2006-02-01 fixed missing translation after new ticket was created
 - 2006-02-01 added long month translation for calendar popup
 - 2006-02-01 changed Kernel/System/Spelling.pm to work with (a|i)spell
    on Windows systems
 - 2006-01-30 added \<OTRS\_TICKET\_\*\> and \<OTRS\_CONFIG\_\*\> support to
    auto respons templates
 - 2006-01-29 fixed/removed wrong config option
    "Ticket::Frontend::QueueSortDefault", added own config option for
    StatusView of tickets
 - 2006-01-29 fixed bug#[1047](http://bugs.otrs.org/show_bug.cgi?id=1047) forward fails if " is in From
 - 2006-01-29 fixed ldap authentication if application charset is
    e. g. iso-8859-1 and not utf-8
 - 2006-01-26 fixed some spelling mistakes in
    Kernel/Config/Files/Ticket.xml and Kernel/Config/Files/Framework.xml
 - 2006-01-24 Added X-Spam-Level to config files to have the possibility
     to filter for this header with PostMasterFilter
 - 2006-01-23 fixed bug#[1069](http://bugs.otrs.org/show_bug.cgi?id=1069) - Problem when the name of a GenericAgent
    job was updated
 - 2006-01-08 fixed PostMaster filter admin interface if wrong syntax
    regexp is used (don't save invalid regexp because no email can be
    received)
 - 2006-01-07 added bin/CheckSum.pl and also ARCHIVE file to include
    md5 sum archive of current distribution
 - 2006-01-07 improved PostMaster if no article can be created
 - 2005-12-29 fixed internal server error if in sysconfig search
     is used
 - 2005-12-29 fixed "enter" submit bug in sysconfig (e. g. reset first
    item in the edit site)
 - 2005-12-29 fixed ArticleAttachmentIndex() - wrong index count in
    fs lookup - attachment icons sometimes not shown
 - 2005-12-29 added added missing class="button" in submit type="submit"
    of .dtl templates
 - 2005-12-27 fixed default note-type and default state-type in ticket
    pending mask
 - 2005-12-23 fixed stats/graph error message 'Can't call method "png"
    on an undefined value at ...'
 - 2005-12-21 fixed missing delete on time\_accounting in
    Kernel/System/Ticket/Article.pm if article got deleted
 - 2005-12-20 improved die if xml is invalid in Kernel/System/XML.pm
 - 2005-12-12 added compat config option for compose answer to
    replace original sender with current customers email address
 - 2005-11-19 updated French language file, thanks to Yann Richard
 - 2005-12-04 fixed bug#[1025](http://bugs.otrs.org/show_bug.cgi?id=1025) - ORA-01400: cannot insert NULL into ("OTRS"
    ."CUSTOMER\_USER"."COMMENTS"
 - 2005-12-04 fixed bug#[1018](http://bugs.otrs.org/show_bug.cgi?id=1018) - initial\_insert.sql, oracle error ORA-01400:
    cannot insert NULL into
 - 2005-12-03 fixed std attachment feature (no attachment after
    additional fiel upload) in agent ticket compose
 - 2005-12-01 improved database Quote() for integer, also allow +|-
    in integer
 - 2005-11-30 fixed order of create attributes (TicketCreate(), TicketFreeTime(),
    TicketFreeTime(), ArticleCreate(), ...) on customer ticket creation
 - 2005-11-29 fixed bug#[1010](http://bugs.otrs.org/show_bug.cgi?id=1010) - ORA-00972 Identifier is too long for oracle
 - 2005-11-29 fixed bug#[1011](http://bugs.otrs.org/show_bug.cgi?id=1011) - ORA-01408: such column list already indexed,
    Oracle error
 - 2005-11-24 fixed wrong follow up notification (to all agents)
    via customer panel if ticket is already closed
 - 2005-11-19 updated Dutch language file, thanks to Richard Hinkamp
 - 2005-11-15 fixed not working -r option in scripts/backup.pl
    (-r == removed backups older then -r days)
 - 2005-11-13 remove leading and trailing spaces in ldap filter for
    agent and customer authentication

#2.0.4 2005-11-12
 - 2005-11-11 fixed bug#[695](http://bugs.otrs.org/show_bug.cgi?id=695) - From-Header missing quoting if : is used
 - 2005-11-11 fixed bug#[863](http://bugs.otrs.org/show_bug.cgi?id=863) - error after using faq in tickets
 - 2005-11-11 fixed bug#[906](http://bugs.otrs.org/show_bug.cgi?id=906) - group names are translated in admin interface
 - 2005-11-08 added missing default pending note type
 - 2005-11-05 fixed bug#[922](http://bugs.otrs.org/show_bug.cgi?id=922) - rfc quoteing for emails with sender
    like info@example.com \<info@example.com\> is now
    "info@example.com" \<info@example.com\>
 - 2005-11-05 fixed bug#[639](http://bugs.otrs.org/show_bug.cgi?id=639) - problems with german "umlaute" and
    "," in realname if OE is the sender system
 - 2005-10-31 moved to default download type as attachment (not inline)
    for a better security default setting
 - 2005-10-31 fixed bug in html mime online viewer module
    (Kernel/Modules/AgentTicketAttachment.pm)
 - 2005-10-31 added missing ContentType in ArticleAttachmentIndex() if
    fs lookup is used (Kernel/System/Ticket/ArticleStorage\*.pm)
 - 2005-10-31 improved sql quote with type (String, Integer and Number)
    to have a better security
 - 2005-10-30 removed not needed german default salutation and signature
    from scripts/database/initial\_insert.sql
 - 2005-10-30 improved oracle backend with max length of index and foreign
    key ident, fixed triger creation - removed not needed / if DBI is used.
 - 2005-10-25 improved bin/opm.pl to uninstall packages via
   -p package-verions of installed package
 - 2005-10-25 moved to default selected priority and state in
    first mask of phone and email mask
 - 2005-10-25 fixed lost of original .backup and .save files if
    packages are reinstalled
 - 2005-10-25 added html access keys for customer panel
 - 2005-10-24 moved oracle database param LongReadLen to 4\*1024\*1024 to
   store biger attachments
 - 2005-10-23 fixed small bug for WorkingTime calculation
 - 2005-10-22 fixed bug#[971](http://bugs.otrs.org/show_bug.cgi?id=971) - Invalid agents get LockTimeOut notification
 - 2005-10-21 fixed bug#[948](http://bugs.otrs.org/show_bug.cgi?id=948) - Invalid agents should not longer get follow-ups
 - 2005-10-21 fixed bug#[957](http://bugs.otrs.org/show_bug.cgi?id=957) - Got "no ArticleID" error when viewing queues
 - 2005-10-20 improved html of admin auto responses \<-\> queue relation
 - 2005-10-20 fixed unlock of closed bulk-action tickets
 - 2005-10-20 fixed calendar lookup in admin generic agent time
    selection
 - 2005-10-18 added sortfunction for hashes and array in admin interface
    -\> SysConfig
 - 2005-10-17 fixed bug#[792](http://bugs.otrs.org/show_bug.cgi?id=792) - GPG 1.4.1 is no handled correct
 - 2005-10-17 fixed missing db quoting in Kernel/System/Auth/DB.pm
 - 2005-10-15 small rework of Kernel/Language/de.pm with improved wording
 - 2005-10-15 fixed bug#[889](http://bugs.otrs.org/show_bug.cgi?id=889) - fixed QuoteSignle typo and added changed
    QuoteSingle for PostgreSQL
 - 2005-10-15 Added correct quoting in Filter.pm when deleting a
    PostMasterFilter rule
 - 2005-10-13 changed merge article type to note-external to be shown
    in the customer interface, other way the customer will get an no
    permission screen for this ticket
 - 2005-10-13 improved bin/PendingJobs.pl to send reminder notifications
    to queue subscriber if ticket is unlocked (not longer to the ticket
    owner).
 - 2005-10-13 improved html style of package view in admin interface
 - 2005-10-11 added missing SessionUseCookie config setting to SysConfig
 - 2005-10-10 fixed time (hour and minute) selection on 0x default selections
    in framework (00 selection if 0x was selected)
 - 2005-10-08 removed not longer needed uniq customer id search in
    agent interface
 - 2005-10-06 fixed input check of TimeVacationDays and
    TimeVacationDaysOneTime in admin interface (just integer values allowed)
 - 2005-10-05 fixed bug#[947](http://bugs.otrs.org/show_bug.cgi?id=947) - Admin -\> SelectBox: Insert, Delete, Update
    etc. possible
 - 2005-10-04 added MainObject as required for Kernel/Output/HTML/Generic.pm
 - 2005-10-01 fixed time (minute and hour) default selection if 01 minues
    or 01 hours are used

#2.0.3 2005-09-28
 - 2005-09-28 fixed typo in config option name for csv search output,
    so configable csv search output is now possible
 - 2005-09-28 improved speed of Kernel::System::AgentTicketMailbox
    (added page jumper)
 - 2005-09-28 fixed not deleting var/tmp/XXXXXX.tmp files
 - 2005-09-26 fixed not working cache in Kernel::System::User-\>UserGetData()
 - 2005-09-24 fixed small oracle database driver bugs
 - 2005-09-24 added initial user groups add (UserSyncLDAPGroups) after
    initial login
 - 2005-09-19 moved ldap user sync after login from Kernel/System/User.pm
    to Kernel/System/Auth/LDAP.pm (already an existing ldap module)
 - 2005-09-19 fixed ticket search create day and month selection
    (e. g. 009) if input fields (no pull downs) are used
 - 2005-09-19 removed js from change ticket customer
 - 2005-09-19 fixed bin/mkStats.pl - no attachments are sent
 - 2005-09-18 removed auto result in object link mask (search submit
    required first!) and improved html design
 - 2005-09-17 added DefaultTheme::HostBased config option for host
    name based theme selection
 - 2005-09-14 fixed move action module in
    Kernel/Output/HTML/Standard/AgentTicketQueueTicketViewLite.dtl
 - 2005-09-13 fixed ticket search with IE if many options are selected
 - 2005-09-11 improved html style in customer panel
 - 2005-09-09 added Chinese translation, thanks to zuowei
 - 2005-09-07 added admin "su" (Switch To User) feature (it's disabled
    per default)
 - 2005-09-05 moved to german "Ihr OTRS Benachrichtigungs-Master" wording
    in default notifications
 - 2005-09-05 added missing default state and article type option to
    Kernel/Modules/AgentTicketClose.pm
 - 2005-09-04 changed max. session time from 9h to 10h
 - 2005-09-04 added missing config options in
    Kernel/Modules/AgentTicketEmail.pm and Kernel/Modules/AgentTicketPhone.pm
    for show count of customer ticket history
 - 2005-09-04 added missing Kernel::Modules::AgentLookup module registration
 - 2005-09-04 fixed ArticleGetContentPath() in Kernel/System/Ticket/Article.pm,
    removed "uninitialized value" warning if no content path is set in db'
 - 2005-09-04 fixed ArticleWriteAttachment() in
    Kernel/System/Ticket/ArticleStorageFS.pm, added ContentPath lookup
 - 2005-09-04 fixed SubGroup of Ticket::Frontend::CustomerInfo(Queue|Zoom|
    Compose), Frontend::Agent is the correct one
 - 2005-09-04 added possibe state selection in owner update screen
 - 2005-08-29 fixed bug#[905](http://bugs.otrs.org/show_bug.cgi?id=905) - fixed SuSE meta header info, try-restart
    arg, and some smaller fixes
 - 2005-08-26 added package manager deploy check in admin interface, if
    package is really deployed (compare files in filesystem and package)
 - 2005-08-26 added time accounting option to ticket move mask
 - 2005-08-26 replaced localtime(time) with Kernel::System::Time core
    module in several files
 - 2005-08-26 removed empty thai translation file
 - 2005-08-24 replaced scripts/restore.sh and scripts/backup.sh with improved
    scripts/backup.pl and scripts/restore.pl scripts
 - 2005-08-24 added SMIME and PGP environment check in admin
    interface
 - 2005-08-23 fixed bug#[891](http://bugs.otrs.org/show_bug.cgi?id=891) - typo in Login.dtl

#2.0.2 2005-08-22
 - 2005-08-19 fixed bug#[811](http://bugs.otrs.org/show_bug.cgi?id=811) - 404 Error for role link OTRS::Admin::Role
    \<-\> User
 - 2005-08-19 Added new config parameter to include a envelope from
    header in outgoing notifications for customer and agents:
```
   $Self->{"SendmailNotificationEnvelopeFrom"} = '';
```
 - 2005-08-19 fixed bug#[846](http://bugs.otrs.org/show_bug.cgi?id=846) - empty envelope from on notifications
 - 2005-08-19 fixed bug#[879](http://bugs.otrs.org/show_bug.cgi?id=879) - "Wide character in subroutine" - mails with
    attachments in utf-8 mode
 - 2005-08-19 fixed bug#[871](http://bugs.otrs.org/show_bug.cgi?id=871) - Erroneous Content-Length fields are sent
    when downloading attachments
 - 2005-08-19 fixed bug#[861](http://bugs.otrs.org/show_bug.cgi?id=861) - Problems in faq attachments and postgresql
    backend
 - 2005-08-19 updated nb\_NO translation again - thanks to Espen Stefansen!
 - 2005-08-18 enabled customer PGP and SMIME preferences if PGP or
    SMIME is enabeled
 - 2005-08-18 fixed broken download of public SMIME certs
 - 2005-08-18 fixed bug#[874](http://bugs.otrs.org/show_bug.cgi?id=874) - password plaintext in UserLastPw
 - 2005-08-17 fixed bug#[872](http://bugs.otrs.org/show_bug.cgi?id=872) - CustomerCalendarSmall not working, module
    not registered
 - 2005-08-16 fixed bug#[847](http://bugs.otrs.org/show_bug.cgi?id=847) - Broken download of public PGP keys via
    customer preferences pannel
 - 2005-08-16 fixed bug#[862](http://bugs.otrs.org/show_bug.cgi?id=862) - wrong sum for time acounting
 - 2005-08-12 fixed bug#[870](http://bugs.otrs.org/show_bug.cgi?id=870) - wrong parameter order in
    Kernel::System::Ticket::Article::SendCustomerNotification routine
 - 2005-08-12 removed default selections (UserSalutation) from CustomerUser
    config
 - 2005-08-12 updated nb\_NO translation - thanks to Espen Stefansen!
 - 2005-08-10 updated pt\_BR translation - thanks to Glau Messina!
 - 2005-08-09 added config option for defaul sortby and order in ticket
    search result in customer and agent interface
 - 2005-08-09 fixed bug#[822](http://bugs.otrs.org/show_bug.cgi?id=822) - Missing FAQID in TicketZoom for linked
    FAQ article
 - 2005-08-08 fixed bug#[815](http://bugs.otrs.org/show_bug.cgi?id=815) - strange line in history
 - 2005-08-08 added add/delete option in SysConfig for NavBar
 - 2005-08-07 fixed bug#[658](http://bugs.otrs.org/show_bug.cgi?id=658) - Typo in installer.pl
 - 2005-08-06 fixed bug#[836](http://bugs.otrs.org/show_bug.cgi?id=836) - GenericAgent (GUI based) seem to ignore
    priority - added some db quote
 - 2005-08-06 changed description text of Ticket::Frontend::PendingDiffTime
    config setting
 - 2005-08-06 fixed not shown linked objects in faq zoom and print view
 - 2005-08-06 removed not needed Kernel/Modules/FAQState.pm and not
    needed config setting
 - 2005-08-06 added warning message in customer panel on account create
    if invalid email address is given
 - 2005-08-05 fixed bug#[850](http://bugs.otrs.org/show_bug.cgi?id=850) - Can't locate object method "KeySearch"
    error"
 - 2005-08-05 fixed bug#[860](http://bugs.otrs.org/show_bug.cgi?id=860) - Error in AgentTicketForward.pm, missing
    title in the warning for the owner check
 - 2005-08-04 updated it translation - thanks to Giordano Bianchi!
 - 2005-08-04 changed default state of new faq articles to 'internal (agent)'
 - 2005-08-04 fixed bug#[877](http://bugs.otrs.org/show_bug.cgi?id=877) - Error when merging tickets - Can't call
    method "LockSet" on an undefined value at Kernel/System/Ticket.pm line 3720
 - 2005-08-04 added missing merge params to Kernel/Config/Files/Ticket.xml

#2.0.1 2005-08-01
 - 2005-07-31 fixed bug#[602](http://bugs.otrs.org/show_bug.cgi?id=602) - CustomerIDs and CustomerUserIDs are lowercased
    before being assigned to a ticket
 - 2005-07-31 fixed bug#[600](http://bugs.otrs.org/show_bug.cgi?id=600) - Wide character death in IPC.pl
 - 2005-07-31 fixed bug#[593](http://bugs.otrs.org/show_bug.cgi?id=593) - Need ID or Name in log file
 - 2005-07-31 fixed missing recover of .save files on uninstall of
    .opm packages
 - 2005-07-31 fixed DBUpdate-to-2.0.postgresql.sql - alter table
    time\_accounting - DECIMAL(10,2), fixed UPDATE ticket SET
    escalation\_start\_time
 - 2005-07-31 fixed bug#[566](http://bugs.otrs.org/show_bug.cgi?id=566) - Wide character in print, ArticleStorageFS.pm
 - 2005-07-29 fixed required time accounting option in js of phone
    and email ticket
 - 2005-07-29 fixed bug#[817](http://bugs.otrs.org/show_bug.cgi?id=817) - added missing freetime1, freetime2 in
    otrs-schema.postgresql.sql and scripts/DBUpdate-to-2.0.postgresql.sql
 - 2005-07-29 added hour and minutes in time selection in ticket search
    in admin, agent and customer interface - bug#[843](http://bugs.otrs.org/show_bug.cgi?id=817)
 - 2005-07-28 updated es tranlsation file by Jorge Becerra - Thanks!
 - 2005-07-28 updated translation files
 - 2005-07-28 fixed bug in ticket expand view
 - 2005-07-28 just framework options for web installer, removed
    ticket options
 - 2005-07-28 moved to global GetExpiredSessionIDs() for
    bin/DeleteSessionIDs.pl and Kernel/System/AuthSession.pm
 - 2005-07-24 added missing from realname on phone follow up in
    Kernel::Modules::AgentTicketPhone
 - 2005-07-24 improved scripts/tools/charset-convert.pl tool with
    get opt params and with file option
 - 2005-07-24 added block feature for system stats
 - 2005-07-24 added auto removed of expired sessions on CreateSessionID()
 - 2005-07-23 removed access of admin group to stats module (because
    of existing own stats group)
 - 2005-07-23 improved page title with ticket number of
    Kernel::Modules::AgentTicketPlain frontend module
 - 2005-07-23 moved ticket unlock after merge from frontend module to
    Kernel::System::Ticket (because it's a core function)
 - 2005-07-23 disabled PGP and SMIME in default setup (because if it's
    not configured there are many warnings in error log)

#2.0.0 beta6 2005-07-19
 - 2005-07-18 added ticket search option for ticket free time
 - 2005-07-18 fixed not shown calendar lookup icons
 - 2005-07-18 added date-check (JavaScript)
 - 2005-07-18 added number-check for TimeUnits (JavaScript)
 - 2005-07-17 improved speed of xml parsing - also speed of SysConfig
 - 2005-07-16 fixed module permission check bug in agent handle
 - 2005-07-15 fixed bug#[821](http://bugs.otrs.org/show_bug.cgi?id=821) - Admin SysConfig (Values cannot be activated)

#2.0.0 beta5 2005-07-14
 - 2005-07-14 removed not needed admin dtls from lite theme, because this
    standard is used as default
 - 2005-07-14 removed not needed customer dtls from lite theme, because this
    standard is used as default
 - 2005-07-13 web installer rewritten - moved to block feature
 - 2005-07-13 added check in bin/SetPermissions.sh if . files exists
 - 2005-07-09 splited big sub groups Frontend::Agent in smaller groups in
    Kernel/Config/Files/Ticket.xml
 - 2005-07-08 fixed bug with double session id bug after login
 - 2005-07-08 improved notify layer with error or notice icon
 - 2005-07-08 fixed bug in Kernel/System/Group.pm GroupMemberList() if GroupID
    is given (possible in AgentTicketOwner.pm if roles are used)
 - 2005-07-08 added postmaster follow up with X-OTRS-Header update function
 - 2005-07-08 fixed win32 binmode problem in Kernel/System/Web/UploadCache/FS.pm
 - 2005-07-08 fixed wrong named templates for customer ticket history
    in Kernel/Modules/AgentTicketEmail.pm and Kernel/Modules/AgentTicketPhone.pm
 - 2005-07-04 improved bin/otrs.addQueue with -s \<SYSTEMADDRESSID\>
    and -c \<COMMENT\> params.

#2.0.0 beta4 2005-07-03
 - 2005-07-03 added ticket free time feature - take care, you need to
    alter the ticket table:

```
    ALTER TABLE ticket ADD freetime1 DATETIME;
    ALTER TABLE ticket ADD freetime2 DATETIME;
```

new config options are:

```
    $Self->{"TicketFreeTimeKey1"} = 'Termin1';
    $Self->{"TicketFreeTimeDiff1"} = 0;
    $Self->{"TicketFreeTimeKey2"} = 'Termin2';
    $Self->{"TicketFreeTimeDiff2"} = 0;
```
 - 2005-07-03 fixed bug#[797](http://bugs.otrs.org/show_bug.cgi?id=797) - renamed AdminEmail to Admin Notification
    in admin interface.
 - 2005-07-03 rewritten faq customer and public area
 - 2005-07-03 fixed bug#[799](http://bugs.otrs.org/show_bug.cgi?id=799) - improved FAQ article for utf8 support
    http://faq.otrs.org/otrs/public.pl?Action=PublicFAQ&ID=3
 - 2005-07-03 added fixed/auto update for faq articles with no number
 - 2005-07-03 fixed bug#[800](http://bugs.otrs.org/show_bug.cgi?id=800) - FAQ insert overwrites response by default
 - 2005-07-03 removed CGI cpan module from dist because of incomapt.
   for mod\_perl 1.99 and mod\_perl 2.00
 - 2005-07-01 added datatype DECIMAL support for time\_accounting table
    (changed datatype of time\_unit in time\_accounting table)
 - 2005-06-29 fixed user language selection in customer panel
 - 2005-06-28 fixed default customer valid selection in admin interface
 - 2005-06-27 fixed XML::Parser::Lite backend with xml decode
 - 2005-06-27 updated to cpan CGI v3.10

#2.0.0 beta3 2005-06-21
 - 2005-06-13 fixed bug#[759](http://bugs.otrs.org/show_bug.cgi?id=759) - error when changing default dictionary
 - 2005-06-13 fixed bug#[773](http://bugs.otrs.org/show_bug.cgi?id=773) - NotificationAgentOnline needs TimeObject
 - 2005-06-12 fixed bug#[776](http://bugs.otrs.org/show_bug.cgi?id=776) - when adding a new user I got error message
 - 2005-06-11 added XML::Parser support for Kernel::System::XML
 - 2005-06-07 fixed bug#[771](http://bugs.otrs.org/show_bug.cgi?id=771) - Customer Web Interface - Attachment
    View Error' Kernel/Modules/CustomerTicketZoom.pm
 - 2005-06-06 added experimental db2 support - thanks to Friedmar Moch!
 - 2005-06-06 removed foreign key for queue\_id in pop3\_account, fixed
    indexes for article\_flag

#2.0.0 beta2 2005-05-16
 - 2005-05-16 fixed bug#[644](http://bugs.otrs.org/show_bug.cgi?id=644) - GenericAgent module calls should not keep
    the error msg secret :-), moved to Kernel::System::Main
 - 2005-05-16 fixed bug#[733](http://bugs.otrs.org/show_bug.cgi?id=733) - Postgres: TicketOverview doesn't work in April
 - 2005-05-14 fixed bug#[737](http://bugs.otrs.org/show_bug.cgi?id=737) - cannot add FAQ categories in 2.0 beta1
 - 2005-05-08 fr translation updated by Yann Richard - thanks!
 - 2005-05-08 fixed bug#[729](http://bugs.otrs.org/show_bug.cgi?id=729) - Problem removing example FAQ-entry from FAQ
 - 2005-05-08 fixed bug#[730](http://bugs.otrs.org/show_bug.cgi?id=730) - Problem with FAQ nav bar
 - 2005-05-08 fixed bug#[734](http://bugs.otrs.org/show_bug.cgi?id=734) - Timezone not reflected in DB Tables (ticket
    create time, etc.)
 - 2005-05-07 fixed language translation files
 - 2005-05-07 fixed bug#[647](http://bugs.otrs.org/show_bug.cgi?id=647) - Allow setting of default language for FAQs
 - 2005-05-07 fixed bug#[686](http://bugs.otrs.org/show_bug.cgi?id=686) - defect attachments on download with firefox
 - 2005-05-07 added html access keys for nav bar

```
    general:
    h = home
    l = logout
    o = overview
    n = new
    s = search
    p = preferences
    a = admin interface
    t = ticket interface
    f = faq interface
    g = formular submit

    ticket:
    o = queue view
    n = phone ticket
    e = email ticket
    k = locked ticket list
    m = new messages in locked ticket list
```
 - 2005-05-07 fixed bug#[719](http://bugs.otrs.org/show_bug.cgi?id=719) - Timezone setting (US EDT -4) causes
    "Session Timeout"
 - 2005-05-04 removed html wrap from ticket text areas
 - 2005-05-04 added ticket event module layer
 - 2006-05-04 fixed priority default selection in priority screen

#2.0.0 beta1 2005-05-02
 - 2005-04-30 fixxed bug#[712](http://bugs.otrs.org/show_bug.cgi?id=712) - Reports ignore setting for http-type
 - 2005-04-22 added ticket merge feature
 - 2005-04-14 fixed From in article of AgentTicketPending and
    AgentTicketMove frontend module
 - 2005-04-10 added check to ticket core function Move(), send no
    ticket move info for closed tickets
 - 2005-04-08 updated CGI module to 3.07
 - 2005-02-17 Kernel/Config/Modules\*.pm not longer needed, moved
    to config filer
 - 2005-02-17 renamed \_all\_ ticket frontend modules and templates
    to AgentTicket\* (cleanup)
 - 2005-02-15 renamed \_all\_ ticket config options! and moved to
    own config files:
      o Kernel/Config/Files/Ticket.pm
      o Kernel/Config/Files/TicketPostMaster.pm
    --\>\> old ticket config setting will not longer work \<\<--
 - 2005-02-11 imporved agent ticket search with created options
    (berated by user, created in queue)
 - 2004-12-04 moved PGP and SMIME stuff to Kernel/System/Email.pm
    to be more generic
 - 2004-11-27 added config option TicketHookDivider

```
    [Kernel/Config.pm]
    # (the divider between TicketHook# and number)
    $Self->{TicketHookDivider} = ': ';
#    $Self->{TicketHookDivider} = '';
    [...]
```
 - 2004-11-24 renamed from bin/SendStats.pl to bin/mkStats.pl and added
    fs output e. g.

```
    shell\> bin/mkStats.pl -m NewTickets -p 'Month=1&Year=2003' -r me@host.com -b text
    NOTICE: Email sent to 'me@host.com'
    shell\> bin/mkStats.pl -m NewTickets -p 'Month=1&Year=2003'  -o /data/dir
    NOTICE: Writing file /data/dir/NewTickets_2004-11-24_14-38.csv
    shell\>
```
 - 2004-11-24 added postmaster filter to
 - 2004-11-16 a xml 2 sql processor which is using Kernel/System/DB.pm
    and Kernel/System/DB/\*.pm' bin/xml2sql.pl to generate database based
    sql syntax
 - 2004-11-16 moved database settings from Kernel/System/DB.pm to
    Kernel/System/DB/\*.pm (mysql|postgresql|maxdb|oracle|db2)
 - 2004-11-16 added fast cgi (fcgi) handle to (bin/fcgi-bin/\*.pl)
 - 2004-11-16 splited cgi-handle to handle (bin/cgi-bin/\*.pl) and
    modules (Kernel/System/Web/Interface\*.pm)
 - 2004-11-16 renamed Kernel/System/WebUploadCache.pm to
    Kernel/System/Web/UploadCache.pm
 - 2004-11-16 renamed Kernel/System/WebRequest.pm to
    Kernel/System/Web/Request.pm
 - 2004-11-07 added LOWER() in sql like queries to search, now searches
    are case insensitive in postgresql and maxdb
 - 2004-11-04 added new feature so show ticket history reverse

```
    [Kernel/Config.pm]
    # Agent::HistoryOrder
    # (show history order reverse) [normal|reverse]
    $Self->{'Agent::HistoryOrder'} = 'normal';
#    $Self->{'Agent::HistoryOrder'} = 'reverse';
    [...]
```
 - 2004-11-04 added "show no escalation" group feature

```
    [Kernel/Config.pm]
    # AgentNoEscalationGroup
    # (don't show escalated tickets in frontend for agents who are writable
    # in this group)
    $Self->{AgentNoEscalationGroup} = 'some_group';
    [...]
```
 - 2004-11-04 renamed session to sessions table (oracle compat.)
 - 2004-11-04 updated to CGI 3.05
 - 2004-11-04 switched to session db module as default because
   of compat. of operating systems
 - 2004-11-04 added new dtl tag $LQData{} to quote html links
 - 2004-11-02 added ticket free text feature to agent compose
 - 2004-11-02 added ticket free text feature to agent close
 - 2004-11-01 added auto generated table-sql scripts for mysql, postgresql,
    sapdb and oracle based on scripts/database/otrs-schema.xml
 - 2004-10-31 added database foreign-keys
 - 2004-10-08 fixed 544 - Email address check with query timeout causes
     Premature end of script headers
 - 2004-10-06 reworked all agent and customer notifications in database
    (use scripts/DBUpdate-to-2.0.\*.sql)
 - 2004-10-06 added new config options for email address check
```
    # CheckEmailValidAddress
    # (regexp of valid email addresses)
    $Self->{CheckEmailValidAddress} = '^(root@localhost|admin@localhost)$';

    # CheckEmailInvalidAddress
    # (regexp of invalid email addresses)
    $Self->{CheckEmailInvalidAddress} = '@(anywhere|demo|example|foo)\.(..|...)$';
```
 - 2004-10-01 added global working time configuration for escalation
    and unlock calculation:
```
    [Kernel/Config.pm]
    # TimeWorkingHours
    # (counted hours for working time used)
    $Self->{TimeWorkingHours} = {
        Mon => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Tue => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Wed => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Thu => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Fri => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Sat => [  ],
        Sun => [  ],
    };
    # TimeVacationDays
    # adde new days with:
    # "$Self->{TimeVacationDays}->{10}->{27} = 'Some Info';"
    $Self->{TimeVacationDays} = {
        1 => {
            01 => 'New Year's Eve!',
        },
        5 => {
            1 => '1 St. May',
        },
        12 => {
            24 => 'Christmas',
            25 => 'First Christmas Day',
            26 => 'Second Christmas Day',
            31 => 'Silvester',
        },
    };
    # TimeVacationDaysOneTime
    # adde new own days with:
    # "$Self->{TimeVacationDaysOneTime}->{1977}-{10}->{27} = 'Some Info';"
    $Self->{TimeVacationDaysOneTime} = {
        2004 => {
          6 => {
              07 => 'Some Day',
          },
          12 => {
              24 => 'Some A Day',
              31 => 'Some B Day',
          },
        },
    };
    [...]
```
 - 2004-10-01 improved ticket escalation, added new ticket table col.
    use scripts/DBUpdate-to-2.0.\*.sql
 - 2004-09-29 fixed bug#[310](http://bugs.otrs.org/show_bug.cgi?id=310) - System-ID "09" is not working
 - 2004-09-27 replaced dtl env LastScreenQueue with LastScreenOverview
    and LastScreen with LastScreenView.
 - 2004-09-16 added frontend module registry, so no frontend module
    will be longer accessable till the module is registry. For example
    a registered frontend module with navigation icon in Agent nav bar
    (navigation bar will be build automatically, based on permissions):

```
    [Kernel/Config.pm]
    $Self->{'Frontend::Module'}->{'AgentPhone'} = {
        Group => ['users', 'admin'],
        Description => 'Create new Phone Ticket',
        NavBar => [{
            Description => 'Create new Phone Ticket',
            Name => 'Phone-Ticket',
            Image => 'new.png',
            Link => 'Action=AgentPhone',
            NavBar => 'Agent',
            Prio => 20,
         },
       ],
    };
```
 - 2004-09-16 added Kernel::System::PID to start bin/PostMaster.pl just
    once (new table, process\_id is needed)
 - 2004-09-15 added date check on set pending time, don't set pending
    time to past!
 - 2004-09-11 added support of object link
 - 2004-09-10 changed the agent notification to all subscriped agents
    if there is an follow up from the customer and the ticket is unlocked.
    This is different to OTRS \<= 1.3. So if you don't want this, you can
    use the following config option to disable this (link in OTRS 1.3)

```
    [Kernel/Config.pm]
     $Self->{PostmasterFollowUpOnUnlockAgentNotifyOnlyToOwner} = 1;
    [...]
```
 - 2004-09-10 added Kernel::System::SearchProfile to manage object
    search profiles
 - 2004-09-09 added role/profile feature
 - 2004-09-09 added ticket title support

#1.3.3 2005-10-20
 - 2005-10-20 moved to default download type as attachment (not inline)
    for a better security default setting
 - 2005-10-17 added security bugfix for missing SQL quote
 - 2005-07-08 fixed win32 binmode problem in Kernel/System/WebUploadCache.pm
 - 2005-07-01 fixed missing date in TicketForward.dtl
 - 2005-07-01 fixed bug#[808](http://bugs.otrs.org/show_bug.cgi?id=808) - Stats: StopMonth in Ticket.pm
 - 2005-07-01 fixed bug#[810](http://bugs.otrs.org/show_bug.cgi?id=810) - single quote in comment field generates errors
 - 2005-02-15 updated to cpan MIME::Tools 5.417
 - 2005-02-10 fixed generic agent - was not able to set new owner
 - 2005-01-19 fixed bug#[666](http://bugs.otrs.org/show_bug.cgi?id=666) - INSERTs into 'ticket\_history' fail sometimes
 - 2005-01-07 fixed bug#[659](http://bugs.otrs.org/show_bug.cgi?id=659) - Escalation Notification Sent to Wrong Users
 - 2004-11-26 fixed remove of ticket link if just one exists
 - 2004-11-24 fixed new owner list in Kernel/Modules/AgentMove.pm
    (show just user with rw permission to selected queue)
 - 2004-11-07 fixed utf8-problem with postgres and non utf-8 emails in
    article\_plain
 - 2004-11-05 updated Kernel/Language/hu.pm Thanks to Czakï¿½ Krisztiï¿½n!
 - 2004-11-04 fixed loop if now theme directory is found
 - 2004-11-04 fixed upper queue rename with () or + chars
 - 2004-11-04 fixed bug#[604](http://bugs.otrs.org/show_bug.cgi?id=604) - Typo in AgentStatusView.pm
 - 2004-10-29 spell check rewritten
 - 2004-10-26 added unlock option to bulk feature
 - 2004-10-18 fixed bug#[551](http://bugs.otrs.org/show_bug.cgi?id=551) - FAQ on Email new only takes over the
    subject and not the text

#1.3.2 2004-10-15
 - 2004-10-14 fixed bug#[570](http://bugs.otrs.org/show_bug.cgi?id=570) - Stat generation script fails under postgres
 - 2004-10-14 fixed bug#[573](http://bugs.otrs.org/show_bug.cgi?id=573) - Clicked link to check ticket status and here's
    what I got
 - 2004-10-12 replaced COUNTER with DATA in Kernel/System/Ticket/Number/\*.pm
    (because of win32 systems and use strict mode)
 - 2004-10-12 fixed agent can be customer modus
 - 2004-10-10 fixed wrong lable attachments in db backend
 - 2004-10-07 fixed bug#[562](http://bugs.otrs.org/show_bug.cgi?id=562) Content-Transfer-Encoding: 7bit and german umlaut
 - 2004-10-07 fixed bug#[565](http://bugs.otrs.org/show_bug.cgi?id=565) HighlightColor\* in AgentMailbox
 - 2004-10-06 fixed link quote of https links
 - 2004-10-06 added application log error message if bin/PostMaster.pl fails
 - 2004-10-01 fixed bug#[547](http://bugs.otrs.org/show_bug.cgi?id=547) - uninitialized value in string eq at
    Kernel/System/Ticket/Article.pm line 1387
 - 2004-09-29 fixed english "New ticket notification!", replaced
    OTRS\_CURRENT\_USERFIRSTNAME with OTRS\_USERFIRSTNAME
 - 2004-09-29 removed not existing jp language translation
 - 2004-09-29 fixed bug#[554](http://bugs.otrs.org/show_bug.cgi?id=554) - "Thursday" twice in AdminGenericAgent.pm
 - 2004-09-27 fixed bug#[548](http://bugs.otrs.org/show_bug.cgi?id=548) - german spelling mistakes in agent
    notifications
 - 2004-09-23 fixed ticket free text selection in Kernel/Modules/CustomerMessag.pm
 - 2004-09-23 fixed not sended agent notification after created Email-Ticket
 - 2004-09-23 fixed ticket zoom in customer panel if no customer article
   exists

#1.3.1 2004-09-20
 - 2004-09-16 fixed bug#[513](http://bugs.otrs.org/show_bug.cgi?id=513) - distinct customers must have distinct email
 - 2004-09-16 fixed bug#[519](http://bugs.otrs.org/show_bug.cgi?id=519) - PostMaster.pl bounces mail if database
    is down
 - 2004-09-16 fixed bug#[521](http://bugs.otrs.org/show_bug.cgi?id=521) - buggy utf8 content transfer encoding
 - 2004-09-11 fixed bug if somebody clicks on customer management
 - 2004-09-09 added address book and spell checker to agent forward
 - 2004-09-08 updated spanish translation - Thanks to Jorge Becerra!
 - 2004-09-08 fixed bug#[500](http://bugs.otrs.org/show_bug.cgi?id=500) - js error

#1.3.0 beta4 2004-09-08
 - 2004-09-08 fixed bug#[514](http://bugs.otrs.org/show_bug.cgi?id=514) - Use of uninitialized value in addition (+) at
    bin/DeleteSessionIDs.pl line 93.
 - 2004-09-08 fixed bug#[517](http://bugs.otrs.org/show_bug.cgi?id=517) - fixed bug 517 - DBUpdate-to-1.3 scripts
    don't correctly rename system\_queue\_id
 - 2004-09-08 fixed bug#[516](http://bugs.otrs.org/show_bug.cgi?id=516) - initial\_insert.sql violates ticket\_history
    "NOT NULL" contraints
 - 2004-09-05 fixed bug#[380](http://bugs.otrs.org/show_bug.cgi?id=380) - Does not allow change of customer login
 - 2004-09-04 fixed bug#[502](http://bugs.otrs.org/show_bug.cgi?id=502) - Email bouncing does not work
 - 2004-09-04 fixed bug#[503](http://bugs.otrs.org/show_bug.cgi?id=503) - Move Ticket into queue not possible
 - 2004-09-04 fixed bug#[504](http://bugs.otrs.org/show_bug.cgi?id=504) - $Text{"0"} in DTLs does not produce any output
 - 2004-09-04 added delete option for pop3 accounts in admin interface
 - 2004-09-04 improved generic agent web interface
 - 2004-08-30 fixed '' selection on ticket free text search
 - 2004-08-30 support of sub dtl blocks
 - 2004-08-28 fixed call customer via phone (set state was ignored)
 - 2004-08-26 fixed multi customer id support and added docu

#1.3.0 beta3 2004-08-25
 - 2004-08-25 fixed german translation (replaced wrong words)
 - 2004-08-24 fixed time schedule for generic agent

#1.3.0 beta2 2004-08-24
 - 2004-08-24 fixed ticket\_history table update script

#1.3.0 beta1 2004-08-18
 - 2004-08-11 added feature to send fulltext reqests to a
    mirror database

```
    [Kernel/Config.pm]
    # AgentUtil::DB::*
    # (if you want to use a mirror database for agent ticket fulltext search)
    $Self->{'AgentUtil::DB::DSN'} = "DBI:mysql:database=mirrordb;host=mirrordbhost";
    $Self->{'AgentUtil::DB::User'} = "some_user";
    $Self->{'AgentUtil::DB::Password'} = "some_password";
    [...]
```
 - 2004-08-10 added Radius auth modules for agent and customer
    interface
 - 2004-08-10 improved Kernel::System::CustomerAuth::DB to use
    an external database
 - 2004-08-10 added email 1:1 download option in AgentPlain
 - 2004-08-08 added owner\_id, priority\_id and state\_id to
    ticket\_history table.
 - 2004-08-04 moved customer notifications from Kernel/Config.pm to
    database and added multi language support
 - 2004-08-02 fixed bug#[466](http://bugs.otrs.org/show_bug.cgi?id=466) - Error in managing very long Message-IDs
 - 2004-08-01 improved Kernel::System::Log::SysLog with log charset
    config option in case syslog can't work with utf-8
 - 2004-08-01 improved Kernel::System::Email backends
 - 2004-08-01 fixed bug#[429](http://bugs.otrs.org/show_bug.cgi?id=429) - Attachment file names with spaces do
    not save properly
 - 2004-08-01 fixed bug#[450](http://bugs.otrs.org/show_bug.cgi?id=450) - Spelling mistake in default FAQ entry
 - 2004-08-01 fixed bug#[460](http://bugs.otrs.org/show_bug.cgi?id=460) - Patch to add params hash to LDAP bind
    in Kernel/System/User.pm.
 - 2004-07-30 added references, in-reply-to follow up check

```
    [Kernel/Config.pm]
    # PostmasterFollowUpSearchInReferences
    # (If no ticket number in subject, otrs also looks in In-Reply-To
    # and References for follow up checks)
    $Self->{PostmasterFollowUpSearchInReferences} = 0;
```
 - 2004-07-17 fixed generic agent Schedule web interface
 - 2004-07-16 added multi attachment support for attachments
 - 2004-06-28 improved Kernel/Modules/AdminSelectBox.pm module
 - 2004-06-27 added Block() feature to dtl files (removed a lot
    of no longer needed templates)
 - 2004-06-27 improved web handle (bin/cgi-bin/index.pl and
    bin/cgi-bin/customer.pl) to show module syntax errors.
 - 2004-06-22 improved postmaster filter to use matched value as [\*\*\*]
    in "Set =\>" option.
 - 2004-06-22 added support for crypted database passwords (use
    bin/CryptPassword.pl to crypt passwords).
 - 2004-06-10 added generic agent web interface
 - 2004-06-03 improved language translation with custom translation
    files:
    Kernel/Language/$Locale.pm (default)
    Kernel/Language/$Locale\_$Action.pm (translation for otrs modules like
     file manager, calendar, ...)
    Kernel/Language/$Locale\_Custom.pm (own changes,updates)
 - 2004-05-18 added html application output filter option, e. g. to
    filter java script of the application or to manipulate the html
    output of the application.
    (see alos Kernel/Config/Defaults.pm -\> Frontend::Output::PostFilter)
 - 2004-05-04 added ticket history log on ticket link update and
    notification info if link ticket number doesn't exists.
 - 2004-05-03 added PreApplicationModule examples to Kernel/Config.pm
 - 2004-04-30 added multi customer id support to Kernel/System/CustomerUser.pm,
    Kernel/System/CustomerUser/DB.pm and Kernel/System/CustomerUser/LDAP.pm.
    So one customer can have more then one customer id.
 - 2004-04-22 added notification module for customer panel
    (customer.pl) like for existing agent (index.pl)
 - 2004-04-20 added PreApplicationModule (index.pl) and
    CustomerPanelPreApplicationModule (customer.pl) This interface
    use useful to check some user options or to redirect not accept
    new application news.
 - 2004-04-19 added MaxSessionIdleTime for session managment
    to check/delete idle sessions
 - 2004-04-15 added file size info to article attachments
    (DBUpdate-to-1.3.\*.sql is required!).
 - 2004-04-14 ticket history rewritten and added i18n feature
 - 2004-04-14 reworked/renamed Kernel::System::Ticket::Article
    and sub module functions and added added pod docu, see
    http://dev.otrs.org/
    Note: Kernel::System::Ticket are not longer compat. to OTRS 1.2
     or lower!
 - 2004-04-07 added config option SessionUseCookieAfterBrowserClose
    for session config stuff to keep cookies in browser (after closing
    the browser) till expiration of session (default is 0).
 - 2004-04-06 added missing priority options in TicketSeatch()
    of Kernel::System::Ticket.
 - 2004-04-05 reworked/renamed Kernel::System::Ticket functions and
    added added pod docu, see http://dev.otrs.org/
 - 2004-04-04 added auto convert of html only emails to text/plain,
    text/html will be attached as attachment (Kernel/System/EmailParser.pm)
 - 2004-04-01 fixed some html quote bugs
 - 2004-03-30 added ability to reverse the Queue sorting (added
    AgentQueueSort setting)
 - 2004-03-12 added customer panel MyTickets and CompanyTickets
    feature.
 - 2004-03-11 added mulit serach options to customer serach e. g.
    "name+phone" in customer search
 - 2004-03-11 added customer search prefix (default '') and suffix
    (default '\*') to CustomerUser as config options.
 - 2004-03-11 added \<OTRS\_CUSTOMER\_\*\> tags for salutatuion, signateure
    and std. responses
 - 2004-03-08 added TimeZone feature - e. g. config option
    "$Self-\>{TimeZone} = +5;" in Kernel/Config.pm
 - 2004-03-05 added Include funtion to dtl tags - Thanks to Bozhin Zafirov!
    - moved to central css dtl file (Kernel/Output/HTML/\*/css.dtl and
      Kernel/Output/HTML/\*/customer-css.dtl)
 - 2004-02-29 improved database handling of large objects (use DBI
    bind values now / saves memory)
 - 2004-02-27 replaced "CustomQueue" with "My Queues" in agent frontend
 - 2004-02-27 fixed possible owner selection in AgentPhone/AgentEmail
 - 2004-02-23 improved FreeText feature look if just one key is
    defined.
 - 2004-02-23 improved otrs LDAP modules with AlwaysFilter and
    Charset options (see online documentation)
 - 2004-02-23 updated to CGI 3.04

#1.2.4 2004-07-07
 - 2004-06-29 fixed bug#[456](http://bugs.otrs.org/show_bug.cgi?id=456) not existing queue\_auto\_response
    references in scripts/database/initial\_insert.sql
 - 2004-06-11 added Hungarian translation. Thanks to Gï¿½ncs Gï¿½bor!
 - 2004-04-10 fixed not shown "this message is written in an
    other charset as your own" link in agent zoom
 - 2004-04-08 fixed performance problem in Kernel::Language
    module (get ~5% more performance of the webinterface)
 - 2004-04-06 added missing priority options in SearchTicket()
    of Kernel::System::Ticket.

#1.2.3 2004-04-02
 - 2004-03-29 fixed some html quote bugs
 - 2004-03-28 fixed bug#[365](http://bugs.otrs.org/show_bug.cgi?id=365) - null attachment kills pop import script
 - 2005-03-25 updated pl language translation, Thanks to Tomasz Melissa!
 - 2004-03-25 fixed quote bug in AgentPhoneView, AgentEmail and
    AgentCompose.
 - 2004-03-08 fixed bug#[341](http://bugs.otrs.org/show_bug.cgi?id=341) Wrong results searching for time ranges
    http://bugs.otrs.org/show_bug.cgi?id=341
 - 2004-02-29 fixed language quoting in customer login screen
 - 2004-02-27 fixed missing "internal (agent)" agent search faq
 - 2004-02-27 fixed possible owner selection in AgentPhone/AgentEmaill

#1.2.2 2004-02-23
 - 2004-02-17 changed screen after moved ticket (like OTRS 1.1)
 - 2004-02-17 added null option to search options
    http://bugs.otrs.org/show_bug.cgi?id=321
 - 2004-02-17 fixed double quote bug in GetIdOfArticle()/CreateArticle()
    http://bugs.otrs.org/show_bug.cgi?id=319
 - 2004-02-17 fixed bug#[317](http://bugs.otrs.org/show_bug.cgi?id=317) - Return Path set to invalid email
    http://bugs.otrs.org/show_bug.cgi?id=317

#1.2.1 2004-02-14
 - 2004-02-14 fixed escalation bug#[290](http://bugs.otrs.org/show_bug.cgi?id=290) -
    http://bugs.otrs.org/show_bug.cgi?id=290
 - 2004-02-14 updated spanish translation. Thanks to Jorge Becerra!
 - 2004-02-14 updated czech translation. Thanks to Petr Ocasek
    (BENETA.cz, s.r.o.)!
 - 2004-02-14 added Norwegian language translation (bokmï¿½l)
    Thanks to Arne Georg Gleditsch!
 - 2004-02-12 fixed security bugs ins SQL quote()
 - 2004-02-12 fixed bin/PendingJobs.pl bug (Need User)
 - 2004-02-10 fixed CustomerUserAdd, added Source default map if
    no Source name is given
 - 2004-02-10 fixed missing translation in agent and customer
    preferences option selections.

#1.2.0 beta3 2004-02-09
 - 2004-02-09 fixed bug#[249](http://bugs.otrs.org/show_bug.cgi?id=249) Editing system email addresses with
    quotations in name field - http://bugs.otrs.org/show_bug.cgi?id=249
 - 2004-02-09 added contact customer (create ticket) feature
 - 2004-02-08 added multi customer map/source support
 - 2004-02-08 added GenericAgent module support
 - 2004-02-05 fixed bug in X-OTRS-Queue option if bin/PostMasterPOP3.pl
    is used.
 - 2004-02-04 fixed bug in customer interface (empty To selection)
 - 2004-02-03 fixed typo in template (wrong $Data{} for Field6)
    Kernel/Output/HTML/Standard/FAQArticleForm.dtl

#1.2.0 beta2 2004-02-02
 - 2004-02-02 replaced column "comment" to "comments" of each table to
    be oracle compat.
 - 2004-02-02 added ticket link feature
 - 2004-02-01 fixed uncounted unlocktime calcualtion in bin/UnlockTickets.pl
 - 2004-01-27 added Bcc field for agent address book and agent compose
 - 2004-01-24 fixed bug#[280](http://bugs.otrs.org/show_bug.cgi?id=280) - group\_customer\_user table
    (http://bugs.otrs.org/show_bug.cgi?id=280)
 - 2004-01-23 fixed bug#[219](http://bugs.otrs.org/show_bug.cgi?id=219) - GenericAgent and adding notes
    (http://bugs.otrs.org/show_bug.cgi?id=219)
 - 2004-01-23 fixed bug#[215](http://bugs.otrs.org/show_bug.cgi?id=215) - Bug in search URL - wrong link to next page
    (http://bugs.otrs.org/show_bug.cgi?id=215)
 - 2004-01-23 fixed bug#[213](http://bugs.otrs.org/show_bug.cgi?id=213) - Does not update replies with the correct name
    (http://bugs.otrs.org/show_bug.cgi?id=213)
 - 2004-01-23 fixed bug#[192](http://bugs.otrs.org/show_bug.cgi?id=192) - rename queue with Sub-queue
    (http://bugs.otrs.org/show_bug.cgi?id=192)
 - 2004-01-23 fixed customer-user \<-\> group problem added the following
    to Kernel/Config.pm

```
    # CustomerGroupSupport (0 = compat. to OTRS 1.1 or lower)
    # (if this is 1, the you need to set the group \<-\> customer user
    # relations! http://host/otrs/index.pl?Action=AdminCustomerUserGroup
    # otherway, each user is ro/rw in each group!)
    $Self->{CustomerGroupSupport} = 0;

    # CustomerGroupAlwaysGroups
    # (if CustomerGroupSupport is true and you don't want to manage
    # each customer user for this groups, then put the groups
    # for all customer user in there)
    $Self->{CustomerGroupAlwaysGroups} = ['users', 'info'];
```
 - 2004-01-23 changed Kernel::System::Ticket-\>SearchTicket() to
    return false if on param (e. g. Queue or State) doesn't exist
    (problem was, that if a queue name dosn't exist, then the
    GenericAgent gets tickets from all queues!).
#1.2.0 beta1 2004-01-22
 - 2004-01-22 internationalization of agent notification messages
    configurable over admin interface (attention, agent notificatins
    are not be longer stored as article, now just a history entry will
    be created, old articles will be removed/delete by update script!)
 - 2004-01-19 improve ticket search with date/time options
 - 2004-01-14 added X-OTRS-SenderType and X-OTRS-ArticleType to
    possible email headers (see doc/X-OTRS-Headers.txt).
 - 2004-01-14 Updated Mail::Tools from 1.51 to 1.60.
 - 2004-01-12 added config option to send no pending notification in
    defined hours (SendNoPendingNotificationTime).
 - 2004-01-10 improved TicketStorageModule, now it's possible to
    switch from one to the other backend on the fly.
 - 2004-01-09 improved GenericAgent.pl to work also with more ticket
    properties see also for all options:
    http://doc.otrs.org/cvs/en/html/generic-agent-example.html
 - 2004-01-09 removed charset selection from perferences (agent and
    customer interface). Take the charset form translation file.
 - 2004-01-09 added utf-8 support for mail frontend (min. Perl 5.8.0
    required)
 - 2004-01-08 added address book feature on compose answer
    screen.
 - 2004-01-07 added OTRS\_CUSTOMER\_DATA\_\* tags for info of
    existing customer in CustomerMap in Kernel/Config.pm in
    Agent notification config options.
 - 2003-12-23 added lock/unlock option to phone view / create
    ticket.
 - 2003-12-15 changed recipients of customer notifications
    (change queue, update owner, update state, ...) to current
    customer user, based on customer user source.
 - 2003-12-15 added customer user cc by creating a new ticket
    with different sender email addresses.
 - 2003-12-11 added more ticket free text options for tickets
    now we have 8 (not only 2) - improved also GenericAgent and
    Web-Frontend!
 - 2003-12-07 added SUSE 9.0 support and added RPM spec file
    for SUSE 9.0.
 - 2003-12-07 moved Kernel/Output/HTML/Agent|Admin|Customer.pm
    stuff to Kernel/Modules/\*.pm modules.
 - 2003-12-07 removed config option CustomerViewableTickets and
    added customer preferences option (15|20|25|30).
 - 2003-12-07 removed config option ViewableTickets and added
    agent preferences option (5|10|15|20|25).
 - 2003-12-03 added QueueListType config option [tree|list] to
    show the QueueSelection in a tree (default) or just in a list

```
 Example:  Tree:        List:
              QueueA       QueueA
                Queue1     QueueA::Queue1
                Queue2     QueueA::Queue2
                Queue3     QueueA::Queue3
              QueueB       QueueB
                Queue1     QueueB::Queue1
                Queue2     QueueB::Queue2
```
 - 2003-12-02 added remove of session cookie after closing the
    browser in agent interface
 - 2003-11-27 added modules for agent notifications
    Kernel/Output/HTML/NotificationCharsetCheck.pm
    Kernel/Output/HTML/NotificationUIDCheck.pm
    are default modules to configure over Kernel/Config.pm

```
    $Self->{'Frontend::NotifyModule'}->{'1-CharsetCheck'} = {
        Module => 'Kernel::Output::HTML::NotificationCharsetCheck',
    };
    $Self->{'Frontend::NotifyModule'}->{'2-UID-Check'} = {
        Module => 'Kernel::Output::HTML::NotificationUIDCheck',
    };
```
    So it's alos possible to create your own agent notifications
    like motd od escalation infos.
 - 2003-11-26 added group \<-\> customer user support - so it's
    possible that you can define the customer queues for new tickets
 - 2003-11-26 added modules for ticket permission checks
    Kernel/System/Ticket/Permission/OwnerCheck.pm
    Kernel/System/Ticket/Permission/GroupCheck.pm
    Kernel/System/Ticket/CustomerPermission/CustomerIDCheck.pm
    Kernel/System/Ticket/CustomerPermission/GroupCheck.pm
    So it's possible to write own perission check modules!
    Example: Don't allow agents to change the priority if the state
    of the ticket is 'open' and in a specific queue.
    Example ofKernel/Config.pm:

```
    # Module Name: 1-OwnerCheck
    # (if the current owner is already the user, grant access)
    $Self->{'Ticket::Permission'}->{'1-OwnerCheck'} = {
        Module => 'Kernel::System::Ticket::Permission::OwnerCheck',
        Required => 0,
    };
    # Module Name: 2-GroupCheck
    # (if the user is in this group with type ro|rw|..., grant access)
    $Self->{'Ticket::Permission'}->{'2-GroupCheck'} = {
        Module => 'Kernel::System::Ticket::Permission::GroupCheck',
        Required => 0,
    };
```
 - 2003-11-19 improved group sub system, added create, move\_into, owner
    and priority permissions to groups (DBUpdate-to-1.2.\*.sql is required!).
 - 2003-11-05 added agent preferences option "Screen after new phone
    ticket". So you can select the next screen after creating a new
    phone ticket.
 - 2003-11-02 improved GenericAgent.pl to work also with ticket
    priorities (search and change).
    Example for Kernel/Config/GenericAgent.pm:

```
    # ---
    # [name of job] -\> move all tickets from abc to experts and change priority
    # ---
    'move all abc priority "3 normal" tickets to experts and change priority'=\> {
      # get all tickets with these properties
      Queue => 'abc',
      Priorities => ['3 normal'],
      # new ticket properties
      New => {
        Queue => 'experts',
        Priority => '4 high',
      },
    },
```
 - 2003-11-02 added delete option to Admin-\>StdAttachment menu
 - 2003-11-01 added PostMaster(POP3).pl filter options like procmail.
    Example for Kernel/Config.pm:

```
    # Job Name: 1-Match
    # (block/ignore all spam email with From: noreply@)
    $Self->{'PostMaster::PreFilterModule'}->{'1-Match'} = {
        Module => 'Kernel::System::PostMaster::Filter::Match',
        Match => {
            From => 'noreply@',
        },
        Set => {
            'X-OTRS-Ignore' => 'yes',
        },
    };
```
    Available modules are Kernel::System::PostMaster::Filter::Match
    and Kernel::System::PostMaster::Filter::CMD. See more to use it
    on http://doc.otrs.org/.
 - 2003-10-29 added bin/CleanUp.pl to clean up of all tmp data
    like ipc, database or fs session and log stuff (added CleanUp()
    to Kernel::System::AuthSession::\* and Kernel::System::Log).
 - 2003-10-27 added "-c Kernel::Config::GenericAgentJobModule"
    option to GenericAgent.pl to use it with more then one
    (Kernel::Config::GenericAgent) job file. For example you will be
    able to have Kernel::Config::Delete and Kernel::Config::Move or
    other job files to execute it on different times.
 - 2003-10-14 changed phone default settings:
    * new tickets are unlocked (not locked)
    * subject and body is empty as default
 - 2003-09-28 improved next screen management after closing tickts
 - 2003-09-28 added \<OTRS\_TICKET\_STATE\> to agent compose answer screen
    as variable for new ticket state in composed message.
 - 2003-08-28 improved GenericAgent to use From, To, Cc, Subject and
    Body for ticket selection - example:

```
    [...]
   'delete all tickets with subject "VIRUS 32" in queue abc' => {
      # get all tickets with this properties
      Queue => 'abc',
      Subject => '%VIRUS%',
      # new ticket properties
      New => {
        # DELETE!
        Delete => 1,
      },
   },
   [...]
```
 - 2003-07-31 added "Show closed Ticket/Don't show closed Ticket" link
    to customer panel show my tickets overview
 - 2003-07-14 added last owner selection to Kernel/Modules/AgentOwner.pm
 - 2003-07-13 add "single sign on" (pre-authentication) option for
    http-basic-auth (Kernel::System::Auth::HTTPBasicAuth and
    Kernel::System::CustomerAuth::HTTPBasicAuth). Thanks to Phil Davis!
 - 2003-07-12 fixed bug#[155](http://bugs.otrs.org/show_bug.cgi?id=155) - in multiple page ticket view, start value
    might be too high
 - 2003-07-12 improved ticket search, added also search profile option
 - 2003-07-05 improved module permission options, now it's possible
    to add more the one group
 - 2003-06-26 improved ticket search and added new search preferences
    table (db update with scripts/DBUpdate-to-1.2.(mysql|postgres).sql)
    required!
 - 2003-05-29 added utf-8 support for webfrontends (min. Perl 5.8.0
    required)
 - 2003-05-20 added array for source queue selection to bin/GenericAgent.pl
    for example, use this job for more queues:

```
    [...]
    'move tickets from tricky to experts' => {
      # get all tickets with this properties
      Queue => ['tricky', 'tricky1'],
      States => ['new', 'open'],
      Locks => ['unlock'],
    [...]
```
 - 2003-05-13 removed UNIQUE (not needed!) in pop3\_account table

#1.1.4 (2003/??/??)
 - 2003-10-27 fixed (removed) not needed database connects in
    PostMaster(POP3).pl stuff (now just 1 database connect, not 3
    connects)! Thanks to Jens Wilke!
 - 2003-09-39 added Czech translation file - Tomas Krmela!
 - 2003-09-29 added Polish translation file - Tomasz Melissa!
 - 2003-09-16 fixed order of user checking/adding in rpm spec files
 - 2003-08-22 fixed ascii2html convert fucktion for "\n" -\> "\<br\>\n" and
    "  " -\> " &nbsp;".
 - 2003-08-22 fixed customer user lookup for PostMaster\*.pl based on
    senders email address (set customer id and customer user)

#1.1.3 2003-07-12
 - 2003-07-12 fixed bug#[182](http://bugs.otrs.org/show_bug.cgi?id=182) - Error when modify an queue without a queue-name
 - 2003-07-12 removed "PerlInitHandler Apache::StatINC" (Reload %INC files
     perl modules) from scripts/apache-httpd.include.conf because of many error
      message in apache error log
    -=\> apache reload is still needed when perl modules changed on disk \<=-
 - 2003-07-12 improved performance of Kernel/System/Ticket/ArticleStorageDB.pm
    with large objects
 - 2003-07-10 fixed bug#[171](http://bugs.otrs.org/show_bug.cgi?id=171) - No lock check if two Agents try to lock
    ticket at same time (or later)
 - 2003-07-06 fixed bug#[168](http://bugs.otrs.org/show_bug.cgi?id=168) - The install script for POSTGRES contains wrong
    datatypes (DATETIME instead of TIMESTAMP)
 - 2003-07-06 fixed bug#[165](http://bugs.otrs.org/show_bug.cgi?id=165) - Pop3 change - does not show the queue
 - 2003-07-03 fixed bug#[178](http://bugs.otrs.org/show_bug.cgi?id=178) - Authenticated customer LDAP requests don't work
 - 2003-07-02 updated Finnish translation, thanks to Antti Kï¿½mï¿½rï¿½inen
 - 2003-07-01 added SMTP module port patch of Jeroen Boomgaardt
 - 2003-06-22 fixed bug#[144](http://bugs.otrs.org/show_bug.cgi?id=144) - PostMasterPOP3.pl is exiting
    "Attached .eml file causes bug in EmailParser.pm"
    http://bugs.otrs.org/show_bug.cgi?id=144
 - 2003-06-04 fixed legend colors of stats pics

#1.1.2 2003-05-31
 - 2003-06-01 improved Kernel/System/Ticket/Number/\*.pm (ticket number
    generator modules) to work with non existing var/log/TicketCounter.log.
     -=\> So var/log/TicketCounter.log will be removed from the CVS and
     tar.gz updates will be much easier! (TicketCounter.log will not be
     reseted on tar-update of OTRS update)
 - 2003-06-01 added Resent-To email header check for queue sorting of
    new ticket - http://lists.otrs.org/pipermail/otrs/2003-May/001845.html
 - 2003-05-30 added "PerlInitHandler Apache::Reload" (Reload %INC files
     perl modules) to scripts/apache2-httpd.include.conf
    -=\> no apache reload is needed when perl modules is updated on disk \<=-
 - 2003-05-30 added "PerlInitHandler Apache::StatINC" (Reload %INC files
     perl modules) to scripts/apache-httpd.include.conf
    -=\> no apache reload is needed when perl modules is updated on disk \<=-
 - 2003-05-29 fixed create ticket (without priority selection) via
    customer panel and changed priority names.
 - 2003-05-26 fixed pic.pl bug - http://bugs.otrs.org/show_bug.cgi?id=149
 - 2003-05-19 improved text formatting of "long" messages in QueueView
    TicketZoom, TicketPlain and TicketSearch
 - 2003-05-18 fixed small logic bugs in Kernel/System/PostMaster\*
    improved debug options for bin/PostMaster.pl and bin/PostMasterPOP3.pl
     -=\> just used -d1 (1-3) for debug level of Kernel/System/PostMaster\*
 - 2003-05-18 added customer data lookup for PostMaster\*.pl based on
    senders email address (set customer id and customer user)
 - 2003-05-13 fixed unwanted ticket unlock on move
 - 2003-05-13 added russian translation! Thanks to Serg V Kravchenko!
 - 2003-05-13 added config options for shown customer info size

```
    $Self-\>{ShowCustomerInfo(Zoom|Queue|Phone)MaxSize}
```
 - 2003-05-08 fixed ignored user comment in admin area
 - 2003-05-04 added missing StateUpdate (table ticket\_history\_type)
    to scripts/DBUpdate-to-1.1.postgresql.sql
 - 2003-05-02 removed unique option for the pop3\_account column
    login! To be able to have more pop3 accounts with the same
    login name.
 - 2003-05-01 fixed bug#[134](http://bugs.otrs.org/show_bug.cgi?id=134) - Title shows "Select box" instead
    of "Admin Log" - http://bugs.otrs.org/show_bug.cgi?id=134
 - 2003-05-01 fixed Kernel/System/AuthSession/\*.pm to be able
    to store 0 values

#1.1.1 2003-05-01
 - 2003-04-30 removed agent notify about new note because new
    owner got ticket assigned to you notify!
 - 2003-04-29 fixed bug#[131](http://bugs.otrs.org/show_bug.cgi?id=131) - QueueView shows wrong queue in
    drop-downs - http://bugs.otrs.org/show_bug.cgi?id=131
 - 2003-04-29 added min. counter size option (default 5) for
    Kernel::System::Ticket::Number::AutoIncrement module.
 - 2003-04-25 removed shown customer id in 'MyTickets' from
    customer interface - added customer id to user name line

#1.1 RC1 2003-04-24
 - 2003-04-24 added refresh time to AgentMailbox screen (refresh
    time still exists for QueueView)
 - 2003-04-24 fixed "show closed tickets" in customer interface
    (http://lists.otrs.org/pipermail/otrs/2003-April/001508.html)
 - 2003-04-24 fixed max shown tickets in QueueView (default now 1200)
    (http://lists.otrs.org/pipermail/otrs/2003-April/001505.html)
 - 2003-04-23 fixed missing filename (default index.pl) for download
    of attachments using Kernel/System/Ticket/ArticleStorageFS.pm
    (http://lists.otrs.org/pipermail/otrs/2003-April/001491.html)
 - 2003-04-22 fixed bug#[123](http://bugs.otrs.org/show_bug.cgi?id=123) - Email address with simple quote
    http://bugs.otrs.org/show_bug.cgi?id=123
 - 2003-04-18 added RH8 IPC (shm id 0) workaround (create dummy shm)
 - 2003-04-17 fixed AgentStatusView (1st ticket is actually the 2nd)
 - 2003-04-17 added Firstname/Lastname of agents to ticket history

#1.1 RC1 2003-04-15
 - 2003-04-15 added Italian translation - Thanks to Remo Catelotti
 - 2003-04-14 improved performance of MIME parser (PostMaster)
 - 2003-04-13 added config option DefaultNoteTypes (used note
    types) default is just note-internal because note-external and
    note-report is confusing.
 - 2003-04-11 added check if ticket state type is closed or
    removed then send not 'auto reply' to customer.
    http://lists.otrs.org/pipermail/otrs/2003-April/001401.html
 - 2003-04-11 added check for quotable messages in auto response
 - 2003-04-11 added check and html2ascii convert for html only
    emails on std. responses, forwards or splits
 - 2003-04-11 added Page Navigator for AgentQueueView -
    http://lists.otrs.org/pipermail/otrs/2003-February/000881.html
 - 2003-04-09 improved AdminEmail feature with group recipient
 - 2003-04-08 added ticket split option in article zoom.
 - 2003-04-08 fixed bug#[109](http://bugs.otrs.org/show_bug.cgi?id=109) - Attachments not being forwarded on
    http://bugs.otrs.org/show_bug.cgi?id=109
 - 2003-04-08 fixed bug#[111](http://bugs.otrs.org/show_bug.cgi?id=111) - Inability to forward on anything from:
    'agent email(external)' - http://bugs.otrs.org/show_bug.cgi?id=110
 - 2003-03-24 improved user-auth and customer-auth ldap interface
    with 'UserAttr' (UID for posixGroups objectclass and DN for non
    posixGroups objectclass) on group access check. Config options now:

```
    [...]
    $Self->{'AuthModule::LDAP::GroupDN'} = 'cn=otrsallow,ou=posixGroups,dc=example,dc=com';
    $Self->{'AuthModule::LDAP::AccessAttr'} = 'memberUid';
    # for ldap posixGroups objectclass (just uid)
    $Self->{'AuthModule::LDAP::UserAttr'} = 'UID';
    # for non ldap posixGroups objectclass (with full user dn)
    $Self->{'AuthModule::LDAP::UserAttr'} = 'DN';
    [...]
```
 - 2003-03-24 added agent feature to be also customer of one ticket
 - 2003-03-24 added UncountedUnlockTime config options - e.g. don't
    count Fri 16:00 - Mon 8:00 as unlock time.
 - 2003-03-23 added generic module/group permission concept for
    Kernel/Modules/\*.pm modules.
    -=\> add "$Self-\>{'Module::Permission'}-\>{'module'} = 'group';"
    to Kernel/Config.pm like
     "$Self-\>{'Module::Permission'}-\>{'AdminAutoResponse'} = 'users';"
    to let the users groups able to change the auto responses.
 - 2003-03-13 improved create customer account - send account login
    via email to requester (added config text for email)
 - 2003-03-13 added SendNoAutoResponseRegExp config option to send no
    auto responses if regexp is matching. (Default is
    '(MAILER-DAEMON|postmaster|abuse)@.+?\..+?')
 - 2003-02-11 improved ticket search (merged fulltext and ticket number
    rearch)
 - 2003-03-10 added customer email notification on move, state update
    or owner update (config option for each queue). Use
    "scripts/DBUpdate-to-1.1.(mysql|postgresql).sql".
    http://lists.otrs.org/pipermail/dev/2002-June/000005.html
 - 2003-03-06 added ro/rw to group object. So the agent is able to search,
    zoom, ... in tickets but can't edit the tickets - added also new config
    option 'QueueViewAllPossibleTickets' to show the ro queues in the queue
    (default 0 -=\> not shown).
    Use "scripts/DBUpdate-to-1.1.(mysql|postgresql).sql".
 - 2003-03-05 added sendmail backends (Kernel::System::Email::Sendmail
    and Kernel::System::Email::SMTP) - for win32 user. New config options:

```
    [...]
      $Self->{'SendmailModule'} = 'Kernel::System::Email::Sendmail';
      $Self->{'SendmailModule::CMD'} = '/usr/sbin/sendmail -t -i -f ';

      $Self->{'SendmailModule'} = 'Kernel::System::Email::SMTP';
      $Self->{'SendmailModule::Host'} = 'mail.example.com';
      $Self->{'SendmailModule::AuthUser'} = '';
      $Self->{'SendmailModule::AuthPassword'} = '';
    [...]
```
 - 2003-03-05 added "view all articles" config option for ticket zoom
    view (TicketZoomExpand default is 0) - new dtl templates for ticket
    zoom Kernel/Output/HTML/\*/AgentZoom\*.dtl (removed TicketZoom\*.dtl)
    http://lists.otrs.org/pipermail/otrs/2003-January/000784.html
 - 2003-03-03 new ticket state implementation (added ticket\_state\_type
    table). Use "scripts/DBUpdate-to-1.1.(mysql|postgresql).sql".
    State name is now free settable (because of the ticket state name).
    Added ticket state documentation.
 - 2003-02-25 rewrote scripts/backup.sh, update your cronjobs!
    http://lists.otrs.org/pipermail/dev/2003-February/000112.html
 - 2003-02-23 added sub-queue support
    http://lists.otrs.org/pipermail/otrs/2002-June/000065.html
 - 2003-02-17 added allowing the client to close a ticket via customer
    panel - http://lists.otrs.org/pipermail/otrs/2003-February/000891.html
 - 2003-02-15 fixed hanging login problem with mod\_perl2
 - 2003-02-15 added mod\_perl2 support for web installer
 - 2003-02-15 unfortunately there is a mod\_perl2 bug on RH8 - added
    check if crypt() is working correctly
 - 2003-02-14 fixed default Spelling Dictionary selection and added
    a preferences option
 - 2003-02-13 added PendingDiffTime config option (add this time to
    shown (selected) pending time) -
    http://lists.otrs.org/pipermail/otrs/2003-February/000899.html
 - 2003-02-09 updated priotity options with number prefix for sort of
    html select fields - e. g. "normal" is "3 normal" and "high" is
    "4 high" - use "scripts/DBUpdate-to-1.1.(mysql|postgresql).sql"
 - 2003-02-09 added ShowCustomerInfo(Queue|Zoom|Phone) config options
    for shown CustomerInfo (e. g. company-name, phone, ...) on
    AgentQueueView, AgentZoom and AgentPhone.
 - 2003-02-08 improved fulltext search with queue and priority option
 - 2003-02-08 added html color highlighting for ticket article type
    e. g. to highlight internal and external notes in TicketZoom -=\>
    article tree.
 - 2003-02-08 added html color highlighting for ticket priority
 - 2003-02-08 moved to 100% CSS support for Standard and Lite theme
 - 2003-02-08 improved VERSION regex for 1.x.x.x cvs revision
 - 2003-02-08 changed database script location from install/database
    to scripts/database

#1.0 RC3 2003-02-03
 - 2003-02-03 added customer user info on TicketView, TicketZoom and PhoneView
     dtl template (if wanted, uncomment it).
 - 2003-02-03 fixed java script stuff for Spell Check
 - 2003-02-03 added customer user serach to PhoneView
 - 2003-02-02 added pending ticket notification - Thanks to Andreas Haase!
     http://lists.otrs.org/pipermail/otrs/2003-January/000839.html
 - 2003-01-27 fixed some doc typos - Thanks to Eddie Urenda!
 - 2003-01-27 added die string -=\> better to find webserver user file
    write permission problems (var/log/TicketCounter.log)!
    Kernel/System/Ticket/Number/\*.pm
 - 2003-01-23 added Brazilian Portuguese translation! Thanks to Gilberto
    Cezar de Almeida!

#1.0 RC2 2003-01-19
 - 2003-01-19 added CustomerUser LDAP backend - Thanks to Wiktor Wodecki!
 - 2003-01-19 fixed CustomerUser backend (config options)
 - 2003-01-18 fixed bug#[61](http://bugs.otrs.org/show_bug.cgi?id=61) (ArticleStorageInit error ) -
    http://bugs.otrs.org/show_bug.cgi?id=61
 - 2003-01-17 fixed bug#[68](http://bugs.otrs.org/show_bug.cgi?id=68) on FreeBSD 4.7 (trying to "compose email" from
    the agent interface) - http://bugs.otrs.org/show_bug.cgi?id=68
 - 2003-01-16 fixed bug#[62](http://bugs.otrs.org/show_bug.cgi?id=62) (not working command line utilitity) -
    http://bugs.otrs.org/show_bug.cgi?id=62
 - 2003-01-16 added bin/otrs.checkModules to check installed and
    required cpan modules
 - 2003-01-15 updated finnish translation! Thanks to Antti Kï¿½mï¿½rï¿½inen!
 - 2003-01-15 added CheckMXRecord option to webinstaller
 - 2003-01-14 fixed typos "preferneces != preferences typo"
    http://lists.otrs.org/pipermail/dev/2003-January/000074.html
    Thanks to Wiktor Wodecki!
 - 2003-01-14 fixed bug#[59](http://bugs.otrs.org/show_bug.cgi?id=59) (Bug in SELECT statement on empty search form) -
    http://bugs.otrs.org/show_bug.cgi?id=59
 - 2003-01-14 updated french translation! Thanks to Nicolas Goralski!
 - 2003-01-12 added spanisch translation! Thanks to Jorge Becerra!
 - 2003-01-11 fixed AgentPhone bug of Time() in subject -
    Time(DateFormatLong) was shown

#1.0 RC1 (2003-01-09)
 - 2003-01-09 added AgentTicketPrint (Ticket Print View)
 - 2003-01-09 improved Kernel::System::Ticket::IndexAccelerator::RuntimeDB
    and StaticDB (for locked tickets).
 - 2003-01-09 removed Kernel::System::Ticket::IndexAccelerator::FS
    because RuntimeDB and StaticDB is enough
 - 2003-01-05 improved fulltext search (added ticket state search option)
 - 2003-01-05 added CMD option to bin/GenericAgent.pl (so you can
    execute own programs on GenericAgent.pl actions - e. g. send
    special admin emails)
 - 2003-01-02 added attachments support for std. responses
 - 2002-12-27 added filters (All, Open, New, Pending, Reminder) to
    AgentMailbox (locked-ticket-view)
 - 2002-12-24 added pending feature for tickets
 - 2002-12-20 added Kernel::System::Ticket::ArticleStorage\* modules
    for attachments in database or fs (needs to update the database
    (scripts/DBUpdate.(mysql|postgesql).sql)! The main reason is a lot
    of people have problems with the file permissions of the local otrs
    and webserver user (often incoming emails are shown some times again).
    TicketStorageModule in Kernel/Config.pm.
     * Kernel::System::Ticket::ArticleStorageDB -\> (default)
     * Kernel::System::Ticket::ArticleStorageFS -\> (faster but webserver
        user should be the otrs user - use it for larger setups!)
 - 2002-12-19 attachment support (send and view) for customer panel!
 - 2002-12-18 added config option CheckEmailAddresses and CheckMXRecord.
    CheckMXRecord is useful for pre checks of valid/invalid senders (
    reduce Postmaster emails). Disable CheckEmailAddresses if you work
    with customers which don't have email addresses or your otrs system is
    in your lan!
 - 2002-12-18 added more error handling to AgentPhone
 - 2002-12-15 added bin/PostMasterPOP3.pl and AdminPOP3 interface for
    fetching emails without procmail, fetchmail and MDA
 - 2002-12-12 added finnish translation - Thanks to Antti Kï¿½mï¿½rï¿½inen!
 - 2002-12-08 added working PostMasterDaemon.pl and PostMasterClient.pl,
    alternative to PostMaster.pl. How it works: If the PostMasterDaemon.pl
    is running, pipe email through PostMasterClient.pl like (PostMaster.pl)
    (e. g. "cat /tmp/some.box | bin/PostMasterClient.pl"). Pro: Speed, Contra
    needs more memory.
 - 2002-12-07 added customer-user-backend Kernel/System/CustomerUser/DB.pm.
 - 2002-12-07 added preferences-backend module for user and customer user
    (Kernel/System/ (User/Preferences/DB.pm and CustomerUser/Preferences/DB.pm)
 - 2002-12-04 moved from Date::Calc (Perl and C) to Date::Pcalc (Perl only)
    and added Date::Pcalc to Kernel/cpan-lib/ (OS independent!).
 - 2002-12-01 moved GenericAgent.pm to GenericAgent.pm.dist to have tarball
    updates easier.
 - 2002-12-01 moved finally to new config file Kernel/Config.pm.dist! Learn
    more -=\> INSTALL -=\> "Demo config files"!
 - 2002-12-01 added "enchant LDAP auth" patch from Wiktor Wodecki for
    Kernel/System/Auth/LDAP.pm and Kernel/System/CustomerAuth/LDAP.pm -
    http://lists.otrs.org/pipermail/dev/2002-November/000043.html.
    Thanks Wiktor!
 - 2002-11-28 fixed bug#[39](http://bugs.otrs.org/show_bug.cgi?id=39) - added mime encode for attachment file names
    http://bugs.otrs.org/show_bug.cgi?id=39 - Thanks to Christoph Kaulich!
 - 2002-11-27 added backend modules for loop protection of PostMaster.pl
    "LoopProtectionModule" in Kernel/Config.pm (default is DB) -
    Kernel::System::PostMaster::LoopProtection::(DB|FS).
 - 2002-11-24 added delete ticket feature for GenericAgent.pl (removes tickets
    from db and fs) - http://lists.otrs.org/pipermail/dev/2002-October/000037.html.
 - 2002-11-23 removed Kernel::Modules::AdminLanguage! Moved used languages
    to config file (Kernel/Config.pm - DefaultUsedLanguages). Moved translation
    files from long language names to short names like en, de, bg, nl, ...
    (e. g. Kernel/Language/bg.pm). Updated docu.
 - 2002-11-21 moved var/cron/\* to var/cron/\*.dist (.dist is not used) to make
    updates easier! Thanks to Bryan Fullerton!
 - 2002-11-15 moved %doc/install/\* to /opt/OpenTRS/install in RPM-specs.
    because the web-installer needs this stuff in this location. %doc isn't
    consistent on different linux distributions!
 - 2002-11-15 fixed bug#[48](http://bugs.otrs.org/show_bug.cgi?id=48) custom modules don't work/load -
    http://bugs.otrs.org/show_bug.cgi?id=48
 - 2002-11-15 added Dutch translation! Thanks to Fred van Dijk!
 - 2002-11-14 added Bulgarian translation! Thanks to Vladimir Gerdjikov!
 - 2002-11-11 added new config file as Kernel/Config.pm.dist (will be used
    for \>= OTRS 5.0 Beta9) if you want to test it with 0.5, use Kernel/Config.pm.dist
    as Kernel/Config.pm (cp Kernel/Config.pm.dist Kernel/Config.pm)!
    Kernel/Config/Defaults.pm is the config file with all defaults. If you want
    to change this settings, add the needed entry to Kernel/Config.pm(.dist)
    and the Kernel/Config/Defaults.pm will be overwrite. Updates will be much
    easier! - http://lists.otrs.org/pipermail/otrs/2002-October/000315.html
 - 2002-11-11 added spell ckecker for agent interface (Kernel::Modules::AgentSpelling).
 - 2002-11-11 added browser window.status info for Standard Theme (Agent
    and Customer frontend).
 - 2002-11-11 added some CPAN modules to Kernel/cpan-lib/ (CGI 2.89,
    MIME-tools-5.411 and MailTools-1.51).
 - 2002-11-09 fixed attachment filename for IE (not the whole path like
    c:\Documents\test.jpg) Kernel/Modules/AgentCompose.pm.
 - 2002-11-09 fixed bug in Kernel/System/EmailParser.pm if email headers
    are longer then 64 characters. Thanks to Phil Davis!
 - 2002-11-01 added file permission check for PostMaster.pl on startup!
    -=\> Will help to get setup faster working!
 - 2002-10-31 added email valid check (incl. mx) on CreateAccount (customer
    panel) -=\> Config option: $Self-\>{CheckMXRecord}!

#0.5 BETA8 2002-10-25
 - 2002-10-24 improved web installer - added system settings
 - 2002-10-22 added notify mail to agent by ticket move - configurable via preferences
 - 2002-10-22 added Lite QueueView - configurable via preferences
 - 2002-10-20 added customer web frontend (bin/cgi-bin/customer.pl,
     Kernel/Modules/Customer\*.pm and Kernel/Output/HTML/\*/Customer.dtl)
 - 2002-10-20 added lost password feature
 - added config support for AgentPreferences module (Kernel/Config/Preferences.pm)
 - added AgentStatusView module (overview of all open tickets) - (Thanks to Phil Davis)!
 - added support of generic session id name (e. g. SessionID, OTRS, ...)
 - added more flexibility for option string in Kernel::Modules::AgentPhone

```
    [Kernel::Config::Phone]
      # PhoneViewASP -> useful for ASP
      # (Possible to create in all queue? Not only queue which
      # the own groups) [0|1]
      $Self->{PhoneViewASP} = 1;
      # PhoneViewSelectionType
      # (To: section type. Queue => show all queues, SystemAddress => show all system
      # addresses;) [Queue|SystemAddress]
       $Self->{PhoneViewSelectionType} = 'SystemAddress';
      # PhoneViewSelectionString
      # (String for To: selection.)
      $Self->{PhoneViewSelectionString} = '<Realname> <<Email>> - Queue: <Queue> - <QueueComment>';
      # PhoneViewOwnSelection
      # (If this is in use, "just this selection is valid" for the PhoneView.)
      $Self->{PhoneViewOwnSelection} = {
        # QueueID => String
        '1' => 'First Queue!',
        '2' => 'Second Queue!',
      };
    [...]
```
 - added attachment support for agent compose answer
 - added Kernel::Modules::AdminEmail feature - a admin can send (via admin
    interface) info to one or more agents.
 - added /etc/sysconfig/otrs file for rcscripts
 - added rpm for Red Hat Linux 7.3
 - added email notify on ownership change feature - see
    http://lists.otrs.org/pipermail/otrs/2002-September/000213.html
 - added ReplyTo patch for PostMaster.pl of Phil Davis - Thanks Phil!
    - http://lists.otrs.org/pipermail/otrs/2002-September/000203.html
 - created config file (Kernel/Config/GenericAgent.pm) for bin/GenericAgent.pl
 - splited Kernel/Config.pm info Kernel/Config.pm, Kernel/Config/Postmaster.pm
    Kernel/Config/Phone.pm and Kernel/Config/Notification.pm and renamed some
    config variables to get a better overview.
 - added new/current french translation - Thanks to Bernard Choppy!
 - added module support for log (Kernel/Config.pm --\> $Self-\>{LogModule})
     * "Kernel::System::Log::SysLog" for syslogd (default)
     * "Kernel::System::Log::File" for log file
 - added alternate login and logout URL feature (Kernel/Config.pm --\>
    $Self-\>{LoginURL}, $Self-\>{LogoutURL}) and added two example alternate
    login pages scripts/login.pl (Perl) and scripts/login.php (PHP)
 - added backup and restore script (scripts/(backup|restore).sh)
 - moved Kernel::System::Article to Kernel::System::Ticket::Article! The
    ArticleObject exists not longer in Kernel::Modules::\*, use TicketObject.
 - fixed bug#[25](http://bugs.otrs.org/show_bug.cgi?id=25) Error on bounce of ticket - http://bugs.otrs.org/show_bug.cgi?id=25
 - fixed bug#[27](http://bugs.otrs.org/show_bug.cgi?id=27) Let the fields "new message" and "Locked tickets" be more visible -
    http://bugs.otrs.org/show_bug.cgi?id=27
 - fixed bug#[23](http://bugs.otrs.org/show_bug.cgi?id=23) little menu logic mistake - http://bugs.otrs.org/show_bug.cgi?id=23
 - fixed bug#[30](http://bugs.otrs.org/show_bug.cgi?id=30) Kernel/System/DB.pm - DB quoting http://bugs.otrs.org/show_bug.cgi?id=30
    Thanks to Marc Scheuffler!
 - fixed bug#[28](http://bugs.otrs.org/show_bug.cgi?id=28) Base64 Encoded mail fails - http://bugs.otrs.org/show_bug.cgi?id=28
    Thanks to Christoph Kaulich!
 - fixed rpm bug for SuSE Linux 7.3 (Installer) - Thanks to Schirott Frank!

#0.5 BETA7 2002-08-06
 - improved screen session management (next screen, last screen) added back
    buttons
 - improved ticket and article lib functions (Kernel::System::Ticket::\* and
    Kernel::System::Article)
 - improved fulltext search
 - added time accounting for tickets (added new database table - time\_accounting!
    use scripts/DBUpdate.(mysql|postgresql).sql for database updates!)
 - added notify feature for ticket lock timeout by system
 - added user preferences item email (so login and email can be different)
 - added "Std. Response on creating a queue" feature
    (http://lists.otrs.org/pipermail/otrs/2002-July/000114.html)
 - added module support for auth. (Kernel/Config.pm --\> $Self-\>{AuthModule})
     * "Kernel::System::Auth::DB" against OTRS DB (default)
     * "Kernel::System::Auth::LDAP" against a LDAP directory
 - added "ChangeOwnerToEveryone" feature fot AgentOwner (useful for ASP)
    Kernel/Config.pm -\> $Self-\>{ChangeOwnerToEveryone} = [0|1]
 - added AgentCustomer module (set a customer id to a ticket and get a customer
    history)
 - added a GenericAgent.pl! This program can do some generic actions on tickets
    (like SetLock, MoveTicket, AddNote, SetOwner and SetState). It was developed
    to close (automatically via cron job) ticket in a specific queue, e. g. all
    tickets in the queue 'spam'. (Thanks to Gay Gilmore for the idea)
 - added a simple webform (scripts/webform.pl) to generate emails with X-OTRS-Header
    to dispatch it with procmail (used for feedback forms)
 - added content\_type col. to article table to handle differen charsets correctly
    (use script/DBUpdate.(mysql|postgresql).sql to upgrate existing databases).
 - added generic session storage management (Kernel/Config.pm --\> $Self-\>{SessionModule})
     * "Kernel::System::AuthSession::DB" (default) --\> db storage
     * "Kernel::System::AuthSession::FS" --\> filesystem storage
     * "Kernel::System::AuthSession::IPC" --\> ram storage
 - added http cookie support for session management - it's more comfortable to
    send links -==\> if you have a valid session, you don't have to login again -
    If the client browser disabled html cookies, otrs will work as usual, append
    SessionID to links! (Kernel/Config.pm --\> $Self-\>{SessionUseCookie})
 - added generic ticket number generator (Kernel/Config.pm --\> $Self-\>{TicketNumberGenerator})
     * "Kernel::System::Ticket::Number::AutoIncrement" (default) --\> auto increment
        ticket numbers "SystemID.Counter" like 1010138 and 1010139.
     * "Kernel::System::Ticket::Number::Date" --\> ticket numbers with date
        "Year.Month.Day.SystemID.Counter" like 200206231010138 and 200206231010139.
     * "Kernel::System::Ticket::Number::DateChecksum" --\> ticket numbers with date and
        check sum and the counter will be rotated daily like 2002070110101520 and 2002070110101535.
     * "Kernel::System::Ticket::Number::Random" --\> random ticket numbers "SystemID.Random"
         like 100057866352 and 103745394596.
 - added UPGRADING file
 - updated redhat init script (Thanks to Pablo Ruiz Garcia)
 - fixed bug#[21](http://bugs.otrs.org/show_bug.cgi?id=21) " in email addresses are missing - http://bugs.otrs.org/show_bug.cgi?id=21
    (Thanks to Christoph Kaulich)
 - fixed bug#[19](http://bugs.otrs.org/show_bug.cgi?id=19) Responses sort randomly - http://bugs.otrs.org/show_bug.cgi?id=19
 - fixed SetPermissions.sh (permission for var/log/TicketCounter.log) (Thanks to
    Pablo Ruiz Garcia)
 - fixed bug#[16](http://bugs.otrs.org/show_bug.cgi?id=16) Attachment download - http://bugs.otrs.org/show_bug.cgi?id=16
    (Thanks to Christoph Kaulich)
 - fixed bug#[15](http://bugs.otrs.org/show_bug.cgi?id=15) typo in suse-rcotrs (redhat-rcotrs is not affected) -
    http://bugs.otrs.org/show_bug.cgi?id=15

#0.5 BETA6 2002-06-17
 - added AgentBounce module
 - moved from Unix::Syslog to Sys::Syslog (Kernel::System::Log) because Sys::Syslog
    comes with Perl (not an additional CPAN module)!
 - added redhat-rcotrs script (thanks to Pablo Ruiz Garcia)
 - added OTRS cronjobs var/cron/[aaa\_base|fetchmail|postmaster|session|unlock]
     * aaa\_base -\> cronjob settings like MAILTO="root@localhost"
     * fetchmail -\> cronjob for fetchmail
     * postmaster -\> cleanup for not processed email
     * session -\> cleanup for old sessions
     * unlock -\> ticket unlock
 - added OTRS cronjobs support (start/stop) to scripts/suse-rcotrs
 - moved all OTRS application required modules to two new files,
     * Kernel/Config/Modules.pm (all used OTRS modules)
     * Kernel/Config/ModulesCustom.pm (all add-on application modules, written by
        someone else, e. g. customer db or accounting system)
    to be release independently with Third Party modules for OTRS.
 - added $Env{"Product"} $Env{"Version"} (e. g. OTRS 0.5 Beta6) as dtl environment
    variable. Source is $OTRS\_HOME/RELEASE.
 - added display support for HTML-only emails
 - added generic database and webserver to scripts/suse-rcotrs script
 - added PostgreSQL (7.2 or higher) support (use OpenTRS-schema.postgresql.sql)
 - fixed bug[12] fetchmail lock problem - http://bugs.otrs.org/show_bug.cgi?id=12
 - fixed bug[11] typos - http://bugs.otrs.org/show_bug.cgi?id=11
 - fixed bug[10] user\_preferences table  - http://bugs.otrs.org/show_bug.cgi?id=10
 - fixed bug[9] LoopProtection!!! Can't open'/opt/OpenTRS/var/log/LoopProtection-xyz.log':
    No such file or directory! - http://bugs.otrs.org/show_bug.cgi?id=9
 - fixed HTML table bug in AdminArea::Queue (just with Netscape)
 - fixed SQL table preferences bug (use script/DBUpdate.mysql.sql)

#0.5 BETA5 2002-05-27
 - added ticket escalation - if a ticket is to old, only this ticket will be shown
    till somebody is working on it
     * added new row (ticket\_answered) to ticket table
     * updated Kernel/Output/HTML/\<THEME\>/AdminQueueForm.dtl
 - added auto ticket unlock for locked old not answered tickets
     * added new row (ticket\_answered) to ticket table
     * modified Kernel::System::Ticket::Lock::SetLock()
     * added bin/UnlockTickets.pl with --timeout and --all options
 - added command line tool (bin/DeleteSessionIDs.pl) to delete expired or all session
    ids via command line or cron - options are --help, --expired and --all
 - fixed bug[7] (http://bugs.otrs.org/show_bug.cgi?id=7 - space in Installer.pm
    lets creating of database otrs in MySQL fail) by Stefan Schmidt.
 - added URL (screen) recovery after session timeout and possibility to send
    links without session id. Example: Shows you the ticket after OTRS
    login - http://host.example.com/otrs/index.pl?AgentZoom&TicketID=9
 - added http://bugs.otrs.org/ link to the Error.dtl template, to get an easier
    bug reporting
 - added NoPermission.dtl screen
 - added phone tool - Kernel::Modules::AgentPhone.pm
 - added french translation (thanks to Martin Scherbaum)
 - added 'Send follow up notification' and 'Send new ticket notification' to agent
    feature
     * added new values to initial\_insert.sql for agent notifications, table:
       ticket\_history\_type, value: SendAgentNotification
     * modified Kernel/Output/HTML/\<THEME\>/AgentPreferencesForm.dtl
     * required "new" options in Kernel::Config.pm!
 - fixed suse-rcotrs script (thanks to Martin Scherbaum)
     * added "INIT INFO"
     * just check httpd and mysqld - no restart
     * added stop-force|start-force option to restart httpd and mysqld
 - added help texts to the admin screens

#0.5 BETA4 2002-05-07
 - changed login screen and added motd feature (Kernel/Output/HTML/Standard/Motd.dtl
   the motd file)
 - added Kernel::Modules::AdminCharsets.pm
 - added Kernel::Modules::AdminStatus.pm
 - added Kernel::Modules::AdminLanguages.pm
 - added mod\_perl stuff to README.webserver and scripts/suse-httpd.include.conf
 - fixed bug#[6](http://bugs.otrs.org/show_bug.cgi?id=6) - user is a reserved word in
    SQL) reported by Charles Wimmer. Added some variables for table names and columns
    to Kernel/Config.pm. Important: For existing installations you have to change the
    Config.pm or to rename the "user" table to "system\_user"!
 - added "kill all sessions" function to Kernel::Modules::AdminSession.pm
 - added old subject ("subject snip") and old email ("body snip") to auto reply
 - added stats support Kernel::Modules::SystemStats and bin/mkStats.pl (with GD)
 - fixed missing html quoting in Kernel::Output::HTML::Agent-\>AgentHistory
 - update of html in AgentTicketView.dtl and AgentZoom.dtl
 - added MoveInToAllQueues [1|0] to Config.pm (allow to choose the move queues for
    ticket view and zoom [all|own])

#0.5 BETA3 2002-04-17
 - added AgentOwner Module
 - added AgentForward Module
 - added auto session delete functions if remote ip or session time is invalid.
 - added mail (show-)attachment function
 - added permission check functions for AgentZoom, AgentPlain and AgentAttachments
 - added README.application-module

#0.5 BETA2 2002-04-11
 - html (\*.dtl) beautified
 - added session driver (sql|fs)

#0.5 BETA1 2002-03-11
 - first official release
