# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::id;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%T - %D/%M/%Y';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Completeness}        = 0.676430748391466;

    # csv separator
    $Self->{Separator}         = ',';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = '.';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'Manajement ACL',
        'Actions' => 'Tindakan',
        'Create New ACL' => 'Buat ACL baru',
        'Deploy ACLs' => 'Sebarkan ACL',
        'Export ACLs' => 'Eksport ACL',
        'Filter for ACLs' => 'Saringan untuk ACL',
        'Just start typing to filter...' => 'Silahkan mengetik untuk menyaring...',
        'Configuration Import' => 'Impor konfigurasi',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Disini anda dapat mengunggah file konfigurasi untuk mengimpor ACL kepada sistem anda. File tersebut harus dalam format .yml seperti yang di ekspor oleh modul editor ACL ',
        'This field is required.' => 'Bidang ini diwajibkan',
        'Overwrite existing ACLs?' => 'Timpa ACL yang sudah ada?',
        'Upload ACL configuration' => 'Unggah konfigurasi ACL',
        'Import ACL configuration(s)' => 'Impor konfigurasi ACL',
        'Description' => 'Deskripsi',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Untuk membuat ACL baru, anda dapat mengimpor ACL yang telah di ekspor dari sistem lain ataupun membuat baru dari awal.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Pengubahan terhadap ACL disini hanya berpengaruh kepada perilaku sistem ini, Jika anda menyebarkan data ACL setelahnya. Dengan penyebaran data ACL, pengubahan terbaru akan tercatat pada konfigurasinya.',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Harap dicatat: Tabel ini menunjukan urutan eksekusi ACL. Jika anda perlu mengubah urutan eksekusi ACL, Mohon ubah nama-nama dari ACL yang terpengaruh.',
        'ACL name' => 'Nama ACL',
        'Comment' => 'Komentar',
        'Validity' => 'Validitas',
        'Export' => 'Ekspor',
        'Copy' => 'Salin',
        'No data found.' => 'Tidak ada data yang ditemui.',
        'No matches found.' => 'Pencarian yang cocok tidak ditemukan.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Ubah ACL %s',
        'Edit ACL' => '',
        'Go to overview' => 'Pergi ke Ikhtisar',
        'Delete ACL' => 'Hapus ACL',
        'Delete Invalid ACL' => 'Hapus ACL yang tidak valid',
        'Match settings' => 'Cocokan pengaturan',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Tentukan kriteria kecocokan untuk ACL ini. Gunakan \'Properti\' untuk mencocokan  tampilan sekarang atai \'DatabaseProperti\' untuk mencocokan dengan atribut tiket saat ini yang ada di database',
        'Change settings' => 'Ubah pengaturan',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Tentukan apa yang anda ingin ubah jika kriterianya cocok. Mohon di ingat bahwa \'Mungkin\' adalah daftar putih, \'TidakMungkin\' adalah daftar hitam',
        'Check the official %sdocumentation%s.' => '',
        'Show or hide the content' => 'Tunjukan atau Sembunyikan konten',
        'Edit ACL Information' => '',
        'Name' => 'Nama',
        'Stop after match' => 'Berhenti setelah cocok',
        'Edit ACL Structure' => '',
        'Save ACL' => '',
        'Save' => 'Simpan',
        'or' => 'atau',
        'Save and finish' => 'Simpan dan Akhiri',
        'Cancel' => 'Batalkan',
        'Do you really want to delete this ACL?' => 'Apakah anda benar-benar ingin menghapus ACL ini?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Buat ACL baru dengan menyerahkan data formulir. Setelah membuat ACL, anda akan dapat menambahkan item konfigurasi pada mode pengubahan.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => '',
        'Add Calendar' => '',
        'Edit Calendar' => '',
        'Calendar Overview' => '',
        'Add new Calendar' => '',
        'Import Appointments' => '',
        'Calendar Import' => '',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            '',
        'Overwrite existing entities' => 'Menimpa entitas yang ada',
        'Upload calendar configuration' => '',
        'Import Calendar' => '',
        'Filter for Calendars' => '',
        'Filter for calendars' => '',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            '',
        'Read only: users can see and export all appointments in the calendar.' =>
            '',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            '',
        'Create: users can create and delete appointments in the calendar.' =>
            '',
        'Read/write: users can manage the calendar itself.' => '',
        'Group' => 'Grup',
        'Changed' => 'Diubah',
        'Created' => 'Dibuat',
        'Download' => 'Muat turun',
        'URL' => '',
        'Export calendar' => '',
        'Download calendar' => '',
        'Copy public calendar URL' => '',
        'Calendar' => 'Kalender',
        'Calendar name' => '',
        'Calendar with same name already exists.' => '',
        'Color' => '',
        'Permission group' => '',
        'Ticket Appointments' => '',
        'Rule' => 'Peraturan',
        'Remove this entry' => 'Hapus entri ini',
        'Remove' => 'Menghapus',
        'Start date' => 'Tanggal mulai',
        'End date' => '',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '',
        'Queues' => 'Antrian',
        'Please select a valid queue.' => '',
        'Search attributes' => '',
        'Add entry' => 'Tambahkan entri',
        'Add' => 'Tambah',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            '',
        'Add Rule' => '',
        'Submit' => 'Serahkan',

        # Template: AdminAppointmentImport
        'Appointment Import' => '',
        'Go back' => 'Pergi kembali',
        'Uploaded file must be in valid iCal format (.ics).' => '',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            '',
        'Upload' => 'Unggah',
        'Update existing appointments?' => '',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            '',
        'Upload calendar' => '',
        'Import appointments' => '',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '',
        'Add Notification' => 'Tambah pemberitahuan',
        'Edit Notification' => 'Ubah pemberitahuan',
        'Export Notifications' => 'Expor pemberitahuan',
        'Filter for Notifications' => '',
        'Filter for notifications' => '',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '',
        'Overwrite existing notifications?' => 'Timpa pemberitahuan yang ada?',
        'Upload Notification configuration' => 'Pemberitahuan konfigurasi untuk memuat',
        'Import Notification configuration' => 'Impor pemberitahuan konfigurasi',
        'List' => 'Daftar',
        'Delete' => 'Hapus',
        'Delete this notification' => 'Hapuskan pemberitahuan',
        'Show in agent preferences' => 'Tampilkan dalam pilihan agen',
        'Agent preferences tooltip' => 'Preferensi tooltip agen',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Pesan ini akan ditampilkan pada layar preferensi agen sebagai tooltip untuk pemberitahuan.',
        'Toggle this widget' => 'Aktifkan widget ini',
        'Events' => 'Event',
        'Event' => 'Event',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '',
        'Appointment Filter' => '',
        'Type' => 'Tipe',
        'Title' => 'Judul',
        'Location' => 'Lokasi',
        'Team' => '',
        'Resource' => '',
        'Recipients' => 'Penerima',
        'Send to' => 'Kirimkan ke',
        'Send to these agents' => 'Kirimkan ke beberapa agen',
        'Send to all group members (agents only)' => '',
        'Send to all role members' => 'Kirimkan ke semua tugas anggota',
        'Send on out of office' => 'Kirimkan selain ke kantor',
        'Also send if the user is currently out of office.' => 'Tetap kirimkan jika pengguna sedang berada diluar kantor',
        'Once per day' => 'Sekali per hari',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '',
        'Notification Methods' => 'Pemberitahuan metode',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Ini adalah metode yang dapat digunakan untuk mengirim pemberitahuan ke masing-masing penerima. Silakan pilih minimal satu metode di bawah ini.',
        'Enable this notification method' => 'Aktifkan pemberitahuan metode',
        'Transport' => 'Transpor',
        'At least one method is needed per notification.' => 'Setidaknya satu metode yang dibutuhkan setiap pemberitahuan.',
        'Active by default in agent preferences' => 'Akftifkan secara default dalam preferensi agen',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Ini adalah nilai default untuk agen penerima yang tidak membuat pilihan untuk pemberitahuan dalam preferensi mereka. Jika kotak diaktifkan, pemberitahuan akan dikirim ke agen tersebut.',
        'This feature is currently not available.' => 'Fitur untuk saat ini tidak tersedia',
        'Upgrade to %s' => 'Tingkatkan ke %s',
        'Please activate this transport in order to use it.' => '',
        'No data found' => 'Data tidak dapat ditemukan',
        'No notification method found.' => 'Metode pemberitahuan tidak ditemukan',
        'Notification Text' => 'Pemberitahuan teks',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Bahasa tidak ditemukan atau diaktifkan pada sistem. Teks pemberitahuan ini dapat dihapus jika tidak diperlukan lagi.',
        'Remove Notification Language' => 'Hapuskan pemberitahuan bahasa`',
        'Subject' => 'Subyek',
        'Text' => 'Teks',
        'Message body' => 'Badan Pesan',
        'Add new notification language' => 'Tambahkan pemberitahuan bahasa baru',
        'Save Changes' => 'Simpan pengubahan',
        'Tag Reference' => 'Tandakan referensi',
        'Notifications are sent to an agent.' => '',
        'You can use the following tags' => 'Anda dapat menggunakan tag berikut ini',
        'To get the first 20 character of the appointment title.' => '',
        'To get the appointment attribute' => '',
        ' e. g.' => 'Misalnya',
        'To get the calendar attribute' => '',
        'Attributes of the recipient user for the notification' => 'Atribut dari pengguna penerima untuk pemberitahuan',
        'Config options' => 'Pilihan konfigurasi',
        'Example notification' => 'Contoh pemberitahuan',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Penambahan penerima alamat surat',
        'This field must have less then 200 characters.' => '',
        'Article visible for customer' => '',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Sebuah artikel akan dibuat jika pemberitahuan tersebut dikirim ke pelanggan atau alamat email tambahan.',
        'Email template' => 'Template email',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Gunakan template ini untuk menghasilkan email yang lengkap (hanya untuk email HTML).',
        'Enable email security' => 'Jalankan email keamanan',
        'Email security level' => 'Level keamanan Email',
        'If signing key/certificate is missing' => 'Jika kunci masuk/sertifikat telah hilang',
        'If encryption key/certificate is missing' => 'Jika kunci pengacak/sertifikat telah hilang',

        # Template: AdminAttachment
        'Attachment Management' => 'Manajemen lampiran',
        'Add Attachment' => 'Tambahkan lampira',
        'Edit Attachment' => 'Ubah lampiran',
        'Filter for Attachments' => 'Filter untuk lampiran',
        'Filter for attachments' => '',
        'Filename' => 'Nama Berkas',
        'Download file' => 'Unduh file',
        'Delete this attachment' => 'Hapus lampiran ini',
        'Do you really want to delete this attachment?' => 'Apakah Anda akan menghapus lampiran berikut ini?',
        'Attachment' => 'Lampiran',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Manajemen Respon otomatis',
        'Add Auto Response' => 'Tambahkan respon otomatis',
        'Edit Auto Response' => 'Ubah respon otomatis',
        'Filter for Auto Responses' => 'Filter untuk respon otomatis',
        'Filter for auto responses' => '',
        'Response' => 'Respon',
        'Auto response from' => 'Respon otomatis dari',
        'Reference' => 'Referensi',
        'To get the first 20 character of the subject.' => 'Untuk mendapatkan 20 karakter pertama dari subjek',
        'To get the first 5 lines of the email.' => 'untuk mendapatkan 5 baris pertama dari email.',
        'To get the name of the ticket\'s customer user (if given).' => 'Untuk mendapatkan nama dari tiket pengguna pelanggan (jika diberikan).',
        'To get the article attribute' => 'Untuk mendapatkan atribut artikel',
        'Options of the current customer user data' => 'Pilihan dari data pelanggan pengguna saat ini',
        'Ticket owner options' => 'Pilihan pemilik tiket',
        'Ticket responsible options' => 'Pilihan penanggung jawab tiket',
        'Options of the current user who requested this action' => 'Pilihan dari pengguna saat ini yang meminta tindakan ini.',
        'Options of the ticket data' => 'Pilihan dari data tiket',
        'Options of ticket dynamic fields internal key values' => 'Pilihan dari nilai kunci internal bidang tiket dinamis',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Pilihan nilai tampilan dari bidang dinamis tiket, berguna untuk bidang Dropdown dan Multiselect',
        'Example response' => 'Contoh respon',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Manajemen layanan cloud',
        'Support Data Collector' => 'Pengumpul data pendukung',
        'Support data collector' => 'Pengumpul data pendukung',
        'Hint' => 'Petunjuk',
        'Currently support data is only shown in this system.' => 'Saat ini data pendukung hanya ditunjukan pada sistem ini',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'Sangat di rekomendasikan untuk mengirimdata ini kepada Grup OTRS agar mendapatkan bantuan yang lebih baik.',
        'Configuration' => 'konfigurasi',
        'Send support data' => 'Kirimkan data pendukung',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Ini akan mengizinkan system untuk mengirimkan informasi data pendukung tambahan kepada Grup OTRS',
        'Update' => 'Pembaruan',
        'System Registration' => 'Pendaftaran sistem',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Untuk mengaktifkan pengiriman data, mohon untuk mendaftarkan sistem anda dengan Grup OTRS atau perbarui informasi pendaftaran sistem anda (pastikan untuk mengaktifkan  pilihan \'Kirimkan data pendukung\')',
        'Register this System' => 'Daftarkan sistem ini',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Pendaftaran sistem tidak diaktifkan pada sistem anda. Mohon periksa konfigurasi anda.',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'Pendaftaran sistem adalah layanan dari Grup OTRS, yang memberikan banyak keuntungan!',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            'Mohon dicatat bahwa penggunaan Layanan cloud OTRS memerlukan pendaftaran sistem',
        'Register this system' => 'Daftarkan sistem ini',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Disini anda dapat mengkonfigurasi layanan cloud yang tersedia yang berkomunikasi secara aman dengan %s',
        'Available Cloud Services' => 'Layanan cloud yang tersedia',

        # Template: AdminCommunicationLog
        'Communication Log' => '',
        'Time Range' => '',
        'Show only communication logs created in specific time range.' =>
            '',
        'Filter for Communications' => '',
        'Filter for communications' => '',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            '',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            '',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            '',
        'Status for: %s' => '',
        'Failing accounts' => '',
        'Some account problems' => '',
        'No account problems' => '',
        'No account activity' => '',
        'Number of accounts with problems: %s' => '',
        'Number of accounts with warnings: %s' => '',
        'Failing communications' => '',
        'No communication problems' => '',
        'No communication logs' => '',
        'Number of reported problems: %s' => '',
        'Open communications' => '',
        'No active communications' => '',
        'Number of open communications: %s' => '',
        'Average processing time' => '',
        'List of communications (%s)' => '',
        'Settings' => 'Pengaturan',
        'Entries per page' => '',
        'No communications found.' => '',
        '%s s' => '',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => '',
        'Back to overview' => '',
        'Filter for Accounts' => '',
        'Filter for accounts' => '',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            '',
        'Account status for: %s' => '',
        'Status' => 'Status',
        'Account' => '',
        'Edit' => 'Ubah',
        'No accounts found.' => '',
        'Communication Log Details (%s)' => '',
        'Direction' => 'Arahan',
        'Start Time' => '',
        'End Time' => '',
        'No communication log entries found.' => '',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '',

        # Template: AdminCommunicationLogObjectLog
        '#' => '',
        'Priority' => 'Prioritas',
        'Module' => 'Modul',
        'Information' => 'Informasi',
        'No log entries found.' => '',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => '',
        'Filter for Log Entries' => '',
        'Filter for log entries' => '',
        'Show only entries with specific priority and higher:' => '',
        'Communication Log Overview (%s)' => '',
        'No communication objects found.' => '',
        'Communication Log Details' => '',
        'Please select an entry from the list.' => '',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Manajemen Pelanggan',
        'Add Customer' => 'Tambahkan Pelanggan',
        'Edit Customer' => 'Ubah Pelanggan',
        'Search' => 'Cari',
        'Wildcards like \'*\' are allowed.' => 'Karakter bebas seperti \'*\' di bolehkan.',
        'Select' => 'Pilih',
        'List (only %s shown - more available)' => 'Urutan (Tampilkan %s saja - lebih tersedia)',
        'total' => 'Total',
        'Please enter a search term to look for customers.' => 'Mohon masukan kata pencarian untuk mencari pelanggan',
        'Customer ID' => 'ID pelanggan',
        'Please note' => '',
        'This customer backend is read only!' => '',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Kelola Hubungan Pelanggan-Grup',
        'Notice' => 'Pemberitahuan',
        'This feature is disabled!' => 'Feature ini dinonaktifkan!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Pakai fitur ini hanya jika anda ingin mendefinisikan perizinan grup untuk pelanggan',
        'Enable it here!' => 'Aktifkan disini!',
        'Edit Customer Default Groups' => 'Ubah grup default pelanggan',
        'These groups are automatically assigned to all customers.' => 'Grup ini secara otomatis diberikan kepada semua pelanggan',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '',
        'Filter for Groups' => 'Saringan untuk grup',
        'Select the customer:group permissions.' => 'Plih the customer:group permissions.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Jika tidak ada yang dipilih, maka tidak ada izin pada grup ini (Tiket tidak akan tersedia untuk pelanggan).',
        'Search Results' => 'Hasil pencarian',
        'Customers' => 'Pelanggan',
        'Groups' => 'Grup',
        'Change Group Relations for Customer' => 'Ubah hubungan grup dengan pelanggan.',
        'Change Customer Relations for Group' => 'Ubah Hubungan customer untuk grup',
        'Toggle %s Permission for all' => 'Aktifkan izin %s untuk semua',
        'Toggle %s permission for %s' => 'Aktifkan izin %s untuk %s',
        'Customer Default Groups:' => 'Grup default pelanggan:',
        'No changes can be made to these groups.' => 'Tidak ada pengubahan yang dapat di buat kepada grup-grup ini',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Akses Read only kepada tiket yang berada di grup/antrian ini',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Akses penuh untuk membaca dan membuat pengubahan padatiket dalam grup/antrian ini',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Manajemen Pelanggan pengguna',
        'Add Customer User' => 'Tambah Pelanggan pengguna',
        'Edit Customer User' => 'Ubah Pelanggan pengguna',
        'Back to search results' => 'Kembali ke hasilpencarian',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Pelanggan pengguna diperlukan untuk memiliki riwayat pelanggan dan untuk login melalui panel pelanggan',
        'List (%s total)' => 'List (%s total)',
        'Username' => 'Nama Pengguna',
        'Email' => 'Email',
        'Last Login' => 'Login terakhir',
        'Login as' => 'Login sebagai',
        'Switch to customer' => 'Tukar ke pelanggan',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '',
        'This field is required and needs to be a valid email address.' =>
            'Bidang ini diwajibkan dan harus alamat email yang valid',
        'This email address is not allowed due to the system configuration.' =>
            'Alamat email ini tidak diizinkan disebabkan oleh konfigurasi sistem',
        'This email address failed MX check.' => 'Alamat email ini telah gagal dalam pemeriksaan MX',
        'DNS problem, please check your configuration and the error log.' =>
            'Masalah DNS, Mohon periksa kembali konfigurasi dan error log anda',
        'The syntax of this email address is incorrect.' => 'Sintaksis alamat email ini salah',
        'This CustomerID is invalid.' => '',
        'Effective Permissions for Customer User' => '',
        'Group Permissions' => '',
        'This customer user has no group permissions.' => '',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',
        'Customer Access' => '',
        'Customer' => 'Pelanggan',
        'This customer user has no customer access.' => '',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '',
        'Select the customer user:customer relations.' => '',
        'Customer Users' => 'Pengguna pelanggan',
        'Change Customer Relations for Customer User' => '',
        'Change Customer User Relations for Customer' => '',
        'Toggle active state for all' => 'aktifkan keadaan aktif untuk semua',
        'Active' => 'Aktif',
        'Toggle active state for %s' => 'Aktifkan keadaan aktif untuk %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '',
        'Edit Customer User Default Groups' => '',
        'These groups are automatically assigned to all customer users.' =>
            '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Anda dapat mengatur grup-grup ini melalui pengaturan konfigurasi "CustomerGroupAlwaysGroup".',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '',
        'Customer User Default Groups:' => '',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => 'Ubah layanan default',
        'Filter for Services' => 'Saringan untuk layanan',
        'Filter for services' => '',
        'Services' => 'Layanan',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Manajemen Bidang dinamis',
        'Add new field for object' => 'Tambahkan bidang baru untuk objek',
        'Filter for Dynamic Fields' => '',
        'Filter for dynamic fields' => '',
        'More Business Fields' => '',
        'Would you like to benefit from additional dynamic field types for businesses? Upgrade to %s to get access to the following field types:' =>
            '',
        'Database' => 'Database',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '',
        'Web service' => '',
        'External web services can be configured as data sources for this dynamic field.' =>
            '',
        'Contact with data' => 'Kontak dengan data',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Untuk menambahkan bidang baru, pilih satu tipe bidang dari daftar objek, object tersebut mendefinisikan batas dari bidang tersebut dan tidak akan dapat diubah setelah penciptaan bidang tersebut.',
        'Dynamic Fields List' => 'Daftar bidang dinamis',
        'Dynamic fields per page' => 'Bidang dinamis per halaman',
        'Label' => 'Label',
        'Order' => 'Urutan',
        'Object' => 'Objek',
        'Delete this field' => 'Hapus bidang ini',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Bidang-bidang dinamis',
        'Go back to overview' => 'Kembali kepada Gambaran',
        'General' => 'Umum',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Bidang ini di wajibkan, dan isinya harus karakter alphabet dan numeric',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Harus unik dan hanya dapat menerima karakter alphabet dan nomor',
        'Changing this value will require manual changes in the system.' =>
            'Mengubah nilai ini akan memerlukan pengubahan manual terhadap sistem.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Nama ini yang akan ditunjukan pada layar dimana bidang ini aktif',
        'Field order' => 'Urutan bidang',
        'This field is required and must be numeric.' => 'Bidang ini diwajibkan dan harus numerik',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Ini adalah urutan dimana bidang akan ditunjukan pada layar dimana ia aktif.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => 'Tipe bidang',
        'Object type' => 'Tipe objek',
        'Internal field' => 'Bidang internal',
        'This field is protected and can\'t be deleted.' => 'Bidang ini telah dilindungi dan tidak dapat dihapus',
        'This dynamic field is used in the following config settings:' =>
            '',
        'Field Settings' => 'Pengaturan bidang',
        'Default value' => 'Nilai default',
        'This is the default value for this field.' => 'Ini adalah nilai default untuk bidang ini',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Perbedaan tanggal default',
        'This field must be numeric.' => 'Bidang ini harus numerik',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Perbedaan dari SEKARANG(dalam detik) untuk menghitung nilaidefault bidang tersebut (misalnya 3600 atai -60).',
        'Define years period' => 'Definisikan periode tahun',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Aktifkan fitur ini untuk mendefinisikan jarak tetapdari tahun (di masa depan dan dimasa lalu) untuk di tampilkan pada bagian tahun pada bidang tersebut.',
        'Years in the past' => 'Tahun-tahun di masa lalu',
        'Years in the past to display (default: 5 years).' => 'Tahun-tahun dimasa lalu yang ditampilkan (default: 5 tahun).',
        'Years in the future' => 'Tahun-tahun dimasa depan',
        'Years in the future to display (default: 5 years).' => 'Tahun-tahun di masa depan yang ditampilkan (default: 5 tahun)',
        'Show link' => 'Tunjukan tautan',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Disini andadapat mengspesifikasikan Tautan HTTP opsional untuk nilai bidang tersebut pada gambaran dan tampilan zoom.',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Example' => 'Contoh',
        'Link for preview' => 'Hubungkan untuk preview',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'Jika diisi, URL ini akan digunakan untuk preview yang ditampilkan bila link ini melayang di zoom tiket. Harap dicatat bahwa untuk bekerja, bidang URL reguler di atas perlu diisi, juga.',
        'Restrict entering of dates' => 'Batasi pemasukan tanggal',
        'Here you can restrict the entering of dates of tickets.' => 'Disini anda dapat membatasi Pemasukan tanggal dari tiket.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Nilai-nilai yang memungkinkan',
        'Key' => 'Kunci',
        'Value' => 'Nilai',
        'Remove value' => 'Hapus Nilai',
        'Add value' => 'Tambah nilai',
        'Add Value' => 'Tambah nilai',
        'Add empty value' => 'Tambah nilai kosong',
        'Activate this option to create an empty selectable value.' => 'Aktifkan pilihan ini untuk membuat sebuah nilai kosong yang dapat dipilih.',
        'Tree View' => 'Tampilan struktur pohon',
        'Activate this option to display values as a tree.' => 'Aktifkan pilihan ini untuk menampilkan nilai-nilai sebagai struktur pohon.',
        'Translatable values' => 'Nilai-nilai yang dapat di translasi',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Jika anda mengaktifkan pilihan ini, nilai-nilai yang akan translasi menurut bahasa yang telah ditentukan pengguna.',
        'Note' => 'Catatan',
        'You need to add the translations manually into the language translation files.' =>
            'Anda perlu menambahkan translasi secara manual kedalam file translasi bahasa',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Jumlah barisan',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Spesifikasikan tinggi (dalam garis) untuk bidang ini pada mode pengubahan.',
        'Number of cols' => 'Jumlah kolom',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Spesifikasikan lebar (dalam karakter) untuk bidang ini pada mode pengubahan.',
        'Check RegEx' => 'Periksa RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Disini anda dapat mengspesifikasikan pernyataan reguler untuk memeriksa nilai tersebut. Regex akan di eksekusi dengan xms pengubah.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'RegEx tidak valid',
        'Error Message' => 'Pesan error',
        'Add RegEx' => 'Tambah RegEx',

        # Template: AdminEmail
        'Admin Message' => '',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Dengan modul ini, administrator dapat mengirimkan pesan kepada agen-agen, group ataupun member peran.',
        'Create Administrative Message' => 'Buat pesan administrasi',
        'Your message was sent to' => 'Pesan anda dikirimkan kepada',
        'From' => 'Dari',
        'Send message to users' => 'Kirimkan pesan kepada semua pengguna',
        'Send message to group members' => 'Kirimkan pesan ke member group',
        'Group members need to have permission' => 'Member grup perlu memiliki izin',
        'Send message to role members' => 'Kirimkan pesan kepada member peran',
        'Also send to customers in groups' => 'Juga kirimkan kepada pelanggan dalam grup',
        'Body' => 'Isi',
        'Send' => 'Kirim',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => 'Terakhir dijalankan',
        'Run Now!' => 'Jalankan sekarang!`',
        'Delete this task' => 'Hapus tugas ini',
        'Run this task' => 'Jalankan tugas ini',
        'Job Settings' => 'Pengaturan pekerjaan',
        'Job name' => 'Nama pekerjaan',
        'The name you entered already exists.' => 'Nama yang anda masukan sudah terpakai',
        'Automatic Execution (Multiple Tickets)' => '',
        'Execution Schedule' => 'Jadwal eksekusi',
        'Schedule minutes' => 'Jadwal menit',
        'Schedule hours' => 'Jadwal jam',
        'Schedule days' => 'Jadwal hari',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            'Saat ini pekerjaan agen umum ini tidak dijalankan secara otomatis',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Untuk mengaktifkan eksekusi otomatis pilih setidaknya satu nilai dari menit, jam, dan hari!',
        'Event Based Execution (Single Ticket)' => '',
        'Event Triggers' => 'Pemicu event',
        'List of all configured events' => 'Daftar dari semua event yang telah dikonfigurasi',
        'Delete this event' => 'Hapus event ini',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Selain atau alternatif dari eksekusi secara periodik, anda dapat mendefinisikan tiket event yang akan memicu pekerjaan ini.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Jika tiket even diaktifkan, saringan tiket akan di aplikasikan untuk memeriksa jika tiket tersebut sesuai. Setelah itu barulah pekerjaan tersebut dijalankan pada tiket ini.',
        'Do you really want to delete this event trigger?' => 'Apakah anda benar-benar ingin menghapus pemicu event ini?',
        'Add Event Trigger' => 'Tambahkan Pemicu event',
        'To add a new event select the event object and event name' => '',
        'Select Tickets' => 'Pilih Tiket',
        '(e. g. 10*5155 or 105658*)' => '(Misalnya 10*5155 atau 105658*)',
        '(e. g. 234321)' => '(Misalnya 234321)',
        'Customer user ID' => '',
        '(e. g. U5150)' => '(misalnya U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Pencarian-tekslengkap dalam artikel (misalnya "Mar*in" atau"Baue*").',
        'To' => 'KEpada',
        'Cc' => 'Cc',
        'Service' => 'Layanan',
        'Service Level Agreement' => 'Perjanjian Tingkat Layanan',
        'Queue' => 'Antri',
        'State' => 'Kondisi',
        'Agent' => 'Agen',
        'Owner' => 'Pemilik',
        'Responsible' => 'Tanggung Jawab',
        'Ticket lock' => 'Kunci Ticket',
        'Dynamic fields' => 'Dinamis dasar',
        'Add dynamic field' => '',
        'Create times' => 'Waktu pembuatan',
        'No create time settings.' => 'Tidak ada pengaturan waktu pembuatan',
        'Ticket created' => 'Tiket telah terbuat',
        'Ticket created between' => 'Tiket terbuat antara',
        'and' => 'dan',
        'Last changed times' => 'Waktu pengubahan terakhir',
        'No last changed time settings.' => 'Tidak ada waktu pengubahan pengaturan terakhir.',
        'Ticket last changed' => 'Tiket terakhir diubah',
        'Ticket last changed between' => 'tiket terakhir diubah antara',
        'Change times' => 'Waktu pengubahan',
        'No change time settings.' => 'Tidak ada pengaturan waktu pengubahan',
        'Ticket changed' => 'Tiket telah diubah',
        'Ticket changed between' => 'Tiket diubah antara',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => 'Waktu tutup',
        'No close time settings.' => 'Tidak ada pengaturan waktu tutup',
        'Ticket closed' => 'Tiket telah ditutup',
        'Ticket closed between' => 'Tiket ditutup antara',
        'Pending times' => 'Waktu Penundaan',
        'No pending time settings.' => 'Tidak ada pengaturan waktu penundaan',
        'Ticket pending time reached' => 'Waktu penundaan tiket telah tercapai',
        'Ticket pending time reached between' => 'Waktu penundaan tiket tercapai antara',
        'Escalation times' => 'Waktu eskalasi',
        'No escalation time settings.' => 'Tidak ada pengaturan waktu eskalasi',
        'Ticket escalation time reached' => 'Waktu eskalasi tiket telah tercapai',
        'Ticket escalation time reached between' => 'Waktu eskalasi tiket tercapai antara',
        'Escalation - first response time' => 'Eskalasi - waktu respon pertama',
        'Ticket first response time reached' => 'Waktu respon pertama tiket telah tercapai',
        'Ticket first response time reached between' => 'waktu respon pertama tiket tercapai antara',
        'Escalation - update time' => 'Eskalasi - waktu pembaruan',
        'Ticket update time reached' => 'Waktu pembaruan tiket telah tercapai',
        'Ticket update time reached between' => 'waktu pembaruan tiket tercapai antara',
        'Escalation - solution time' => 'Eskalasi -  waktu solusi',
        'Ticket solution time reached' => 'Waktu solusi tiket telah tercapai',
        'Ticket solution time reached between' => 'waktu solusi tiket tercapai antara',
        'Archive search option' => 'Arsipkan pilihan pencarian',
        'Update/Add Ticket Attributes' => 'Perbarui/Tambah atribut tiket.',
        'Set new service' => 'Atur Layanan baru',
        'Set new Service Level Agreement' => 'Atur Persetujuan tingkat layanan (SLA)',
        'Set new priority' => 'Atur prioritas baru',
        'Set new queue' => 'Atur antrian baru',
        'Set new state' => 'atur kondisi baru',
        'Pending date' => 'Tanggal penundaan',
        'Set new agent' => 'Atur agen baru',
        'new owner' => 'Pemilik baru',
        'new responsible' => 'Tanggung Jawab baru',
        'Set new ticket lock' => 'Atur kunci tiket baru',
        'New customer user ID' => '',
        'New customer ID' => 'ID Pelanggan baru',
        'New title' => 'Gelar baru',
        'New type' => 'tipe baru',
        'Archive selected tickets' => 'Arsipkan tiket yang dipilih.',
        'Add Note' => 'Tambahkan catatan',
        'Visible for customer' => '',
        'Time units' => 'Unit waktu',
        'Execute Ticket Commands' => 'Eksekusikan perintah tiket.',
        'Send agent/customer notifications on changes' => 'Kirim notifikasi agen/pelanggan saat pengubahan',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Perintah ini akan di eksekusi. ARG[0] akan menjadi nomor tiket. ARG[1] id tiket.',
        'Delete tickets' => 'Hapus tiket',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Perhatian: Semua tiket yang terkena dampak akan dihapus dari dari database dan tidak dapat dikembalikan.',
        'Execute Custom Module' => 'Eksekusi modul khusus',
        'Param %s key' => 'Param %s kunci',
        'Param %s value' => 'Param %s nilai',
        'Results' => 'Hasil',
        '%s Tickets affected! What do you want to do?' => '%s Tiket terpengaruh! Apa yang anda ingin lakukan?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Perhatian: Anda telah menggunakan plihan hapus. Semua tiket yang dihapus akan hilang!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Perhatian: Beberapa %s tiket yang terpengaruh tetapi hanya %s yang akan diubah selama eksekusi',
        'Affected Tickets' => 'Tiket yang terpengaruh',
        'Age' => 'Usia',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'Manajemen generik antarmuka layanan web',
        'Web Service Management' => '',
        'Debugger' => 'Usaha untuk mencari kesalahan pada sebuah program',
        'Go back to web service' => 'Kembali ke web servis',
        'Clear' => 'Kosong',
        'Do you really want to clear the debug log of this web service?' =>
            'Apakah anda ingin menghilangkan kesalahan logaritma pada web servis',
        'Request List' => 'Daftar permintaan',
        'Time' => 'Waktu',
        'Communication ID' => '',
        'Remote IP' => 'IP terpencil',
        'Loading' => 'Memuat',
        'Select a single request to see its details.' => 'Pilih satu permintaan untuk melihat rincian',
        'Filter by type' => 'Penyaringan menurut jenis',
        'Filter from' => 'Menyaring dari',
        'Filter to' => 'Menyaring untuk',
        'Filter by remote IP' => 'Penyaringan berdasarkan IP',
        'Limit' => 'Batas',
        'Refresh' => 'Menyegarkan',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '',
        'Edit ErrorHandling' => '',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => 'Semua konfigurasi data akan hilang',
        'General options' => '',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => 'Berikan nama yang unik untuk layanan web ini',
        'Error handling module backend' => '',
        'This OTRS error handling backend module will be called internally to process the error handling mechanism.' =>
            '',
        'Processing options' => '',
        'Configure filters to control error handling module execution.' =>
            '',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            '',
        'Operation filter' => '',
        'Only execute error handling module for selected operations.' => '',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            '',
        'Invoker filter' => '',
        'Only execute error handling module for selected invokers.' => '',
        'Error message content filter' => '',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            '',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            '',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            '',
        'Error stage filter' => '',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            '',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            '',
        'Error code' => '',
        'An error identifier for this error handling module.' => '',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Error message' => '',
        'An error explanation for this error handling module.' => '',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            '',
        'Default behavior is to resume, processing the next module.' => '',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            '',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            '',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            '',
        'Request retry options' => '',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            '',
        'Schedule retry' => '',
        'Should requests causing an error be triggered again at a later time?' =>
            '',
        'Initial retry interval' => '',
        'Interval after which to trigger the first retry.' => '',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            '',
        'Factor for further retries' => '',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            '',
        'Maximum retry interval' => '',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            '',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            '',
        'Maximum retry count' => '',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            '',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            '',
        'This field must be empty or contain a positive number.' => '',
        'Maximum retry period' => '',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            '',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            '',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => '',
        'Edit Invoker' => '',
        'Do you really want to delete this invoker?' => 'Apakah anda ingin menghapus permohonan',
        'Invoker Details' => 'Rincian permohonan',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Nama ini biasanya digunakan untuk memanggil operasi dari layanan web jarak jauh ',
        'Invoker backend' => 'Invoker backend',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Modul backend Invoker OTRS ini akan dipanggil untuk menyiapkan data yang akan dikirim ke sistem remote , dan akan diproses data tanggapannya.',
        'Mapping for outgoing request data' => 'Pemetaan untuk permintaan data yang keluar`',
        'Configure' => 'Menkonfigurasi`',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Data dari Invoker dari OTRS akan diproses oleh pemetaan ini , untuk mengubahnya dengan jenis data sistem remote yang diharapkan.',
        'Mapping for incoming response data' => 'Pemetaan untuk data respon yang masuk',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'Data respon akan diproses oleh pemetaan ini , untuk mengubahnya dengan jenis data Invoker dari OTRS sesuai harapan.`',
        'Asynchronous' => 'sinkronis',
        'Condition' => 'Syarat',
        'Edit this event' => '',
        'This invoker will be triggered by the configured events.' => 'Invoker ini akan dipicu oleh konfigurasi ',
        'Add Event' => 'Tambahkan event',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Untuk menambahkan even baru, pilih objek event dan nama event dan klik tombol "+".',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            'Asynchronous ditangani oleh OTRS Scheduler Daemon di latar belakang ( dianjurkan ) .',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Sinkron pemicu akan diproses langsung selama permintaan web.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'Kembali ke',
        'Delete all conditions' => '',
        'Do you really want to delete all the conditions for this event?' =>
            '',
        'General Settings' => '',
        'Event type' => '',
        'Conditions' => 'Persyaratan',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => 'Syarat untuk setiap jenis perhubungan',
        'Remove this Condition' => 'Membuang syarat ',
        'Type of Linking' => 'Jenis penghubung',
        'Fields' => 'Bidang',
        'Add a new Field' => 'Tambahkan bidang baru',
        'Remove this Field' => 'Hapuskan bidang ',
        'And can\'t be repeated on the same condition.' => 'Tidak dapat diulang dalam kondisi yang sama',
        'Add New Condition' => 'Tambahkan kondisi yang baru',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Pemetaan sederhana',
        'Default rule for unmapped keys' => 'Aturan default untuk kunci yang belum dipetakan',
        'This rule will apply for all keys with no mapping rule.' => 'Aturan ini akan berlaku untuk semua kunci tanpa aturan pemetaan.',
        'Default rule for unmapped values' => 'Aturan default untuk nilai yang belum dipetakan',
        'This rule will apply for all values with no mapping rule.' => 'Aturan ini akan berlaku untuk semua nilai tanpa ada aturan pemetaan',
        'New key map' => 'Peta kunci baru',
        'Add key mapping' => 'Tambah kunci pemetaan',
        'Mapping for Key ' => 'Pemetaan kunci',
        'Remove key mapping' => 'Hapus kunci pemetaan',
        'Key mapping' => 'Kunci pemetaan',
        'Map key' => 'Kunci peta',
        'matching the' => 'Sesuaikan',
        'to new key' => 'Untuk kunci baru',
        'Value mapping' => 'Nilai pemetaan',
        'Map value' => 'Nilai peta',
        'to new value' => 'Untuk nilai baru',
        'Remove value mapping' => 'Hapus nilai pemetaan',
        'New value map' => 'Nilai peta baru',
        'Add value mapping' => 'Tambah nilai pemetaan',
        'Do you really want to delete this key mapping?' => 'Apakah anda ingin menghapus kunci pemetaan',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '',
        'MacOS Shortcuts' => '',
        'Comment code' => '',
        'Uncomment code' => '',
        'Auto format code' => '',
        'Expand/Collapse code block' => '',
        'Find' => '',
        'Find next' => '',
        'Find previous' => '',
        'Find and replace' => '',
        'Find and replace all' => '',
        'XSLT Mapping' => '',
        'XSLT stylesheet' => '',
        'The entered data is not a valid XSLT style sheet.' => '',
        'Here you can add or modify your XSLT mapping code.' => '',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '',
        'Data includes' => '',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '',
        'Data key regex filters (before mapping)' => '',
        'Data key regex filters (after mapping)' => '',
        'Regular expressions' => '',
        'Replace' => '',
        'Remove regex' => '',
        'Add regex' => '',
        'These filters can be used to transform keys using regular expressions.' =>
            '',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            '',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            '',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '',
        'For information about regular expressions in Perl please see here:' =>
            '',
        'Perl regular expressions tutorial' => '',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => '',
        'Edit Operation' => '',
        'Do you really want to delete this operation?' => 'Apakah anda ingin menghapus operasi ini?',
        'Operation Details' => 'Rincian operasi',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Nama ini biasanya digunakan untuk memanggil operasi layanan web dari sistem remote',
        'Operation backend' => 'Backend operasi',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Modul backend operasi OTRS ini akan dipanggil secara internal untuk memproses permintaan tersebut, menghasilkan data untuk respon .',
        'Mapping for incoming request data' => 'Pemetaan untuk permintaan data yang masuk',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'Data permintaan akan diproses oleh pemetaan ini , untuk mengubahnya dengan jenis OTRS data tersebut',
        'Mapping for outgoing response data' => 'Pemetaan untuk mengeluarkan data respon',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Data respon akan diproses oleh pemetaan ini , untuk mengubahnya dengan jenis data sistem remote tersebut',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '',
        'Properties' => 'Properti',
        'Route mapping for Operation' => 'Rute pemetaan untuk operasi',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Menentukan rute yang harus dipetakan untuk operasi ini . Variabel ditandai dengan \' : \' akan dipetakan ke dalam nama yang telah dimasukkan dan diluluskan bersama yang lainnya untuk pemetaan . ( contoh / Tiket / : TicketID ) .',
        'Valid request methods for Operation' => 'Metode permintaan yang valid untuk operasi',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Batas operasi ini untuk metode permintaan khusus . Jika tidak ada metode yang dipilih semua permintaan akan diterima .',
        'Maximum message length' => 'Maksimum pesan panjang',
        'This field should be an integer number.' => 'Bidang ini harus bilangan bulat ',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'Di sini Anda dapat menentukan ukuran maksimum ( dalam byte ) dari pesan SISA dimana OTRS akan memproses ',
        'Send Keep-Alive' => 'Kirim keep-alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Konfigurasi ini mendefinisikan jika koneksi masuk harus bisa ditutup atau tetap hidup ',
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => 'Endpoint',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'Contoh https://www.otrs.com:10745/api/v1.0 ( tanpa mengikuti backslash )',
        'Timeout' => '',
        'Timeout value for requests.' => '',
        'Authentication' => 'Otentikasi',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => '',
        'The user name to be used to access the remote system.' => 'Nama pengguna yang digunakan untuk mengakses sistem remote .',
        'BasicAuth Password' => '',
        'The password for the privileged user.' => 'Password untuk pengguna istimewa ',
        'Use Proxy Options' => '',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => 'Server proxi',
        'URI of a proxy server to be used (if needed).' => 'Server proxi URl digunakan (jika diperlukan).',
        'e.g. http://proxy_hostname:8080' => 'Misalnya http://proxy_hostname:8080',
        'Proxy User' => 'Pengguna proxi',
        'The user name to be used to access the proxy server.' => 'Nama pengguna digunakan untuk mengakses server proxi',
        'Proxy Password' => 'Kata sandi proxi',
        'The password for the proxy user.' => 'Kata sandi untuk pengguna proxi',
        'Skip Proxy' => '',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => 'Gunakan pilihan SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Menampilkan atau menyembunyikan opsi SSL untuk terhubung ke sistem remote ',
        'Client Certificate' => '',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.pem' => '',
        'Client Certificate Key' => '',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/key.pem' => '',
        'Client Certificate Key Password' => '',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '',
        'Certification Authority (CA) Certificate' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Path lengkap dan nama berkas otoritas sertifikat yang mengesahkan sertifikat SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'Misalnya  /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Buku alamat otoritas sertifikasi (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Path lengkap direktori otoritas sertifikasi di mana sertifikat CA disimpan dalam berkas sistem ',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'Misalnya /opt/otrs/var/certificates/SOAP/CA',
        'Controller mapping for Invoker' => 'Kontroler pemetaan untuk invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'Kontroler yang Invoker harus mengirim permintaan. Variabel ditandai dengan \' : \' akan diganti dengan nilai data dan diteruskan dengan permintaan . ( contoh /Tiket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Permintaan perintah yang sah untuk invoker',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Perintah HTTP tertentu untuk menggunakan permintaan dengan Invoker ini ( opsional ) ',
        'Default command' => 'Perintah default',
        'The default HTTP command to use for the requests.' => 'Perintah default HTTP digunakan untuk permintaan .',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => '',
        'Set SOAPAction' => '',
        'Set to "Yes" in order to send a filled SOAPAction header.' => '',
        'Set to "No" in order to send an empty SOAPAction header.' => '',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            '',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            '',
        'SOAPAction scheme' => '',
        'Select how SOAPAction should be constructed.' => '',
        'Some web services require a specific construction.' => '',
        'Some web services send a specific construction.' => '',
        'SOAPAction separator' => 'Pemisah SOAPAction',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI memberikan metode SOAP konteks, mengurangi ambiguitas.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => 'Permintaan nama skema',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Pilih bagaimana fungsi permintaan SOAP wrapper harus dibangun.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'Fungsi Nama\' digunakan sebagai contoh untuk nama Invoker/operasi',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'Free Text\' digunakan sebagai contoh untuk nilai konfigurasi yang sebenarnya',
        'Request name free text' => 'Permintaan nama teks bebas',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Teks yang digunakan sebagai nama fungsi akhiran atau penggantian.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Silakan mempertimbangkan pembatasan penamaan elemen XML  (misalnya tidak menggunakan \'<\' dan \'&\').',
        'Response name scheme' => 'Respon skema nama',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Pilih bagaimana fungsi respon sampul SOAP harus dibangun',
        'Response name free text' => 'Nama respon teks bebas',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Di sini anda dapat menentukan ukuran maksimum (dalam byte) dari pesanan SOAP bahwa OTRS akan diproses',
        'Encoding' => 'Menyandi',
        'The character encoding for the SOAP message contents.' => 'Karakter pengkodean untuk isi pesan SOAP',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.',
        'Sort options' => 'Berbagai pilihan',
        'Add new first level element' => 'Tambahkan elemen baru tingkat pertama',
        'Element' => 'Elemen',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Urutan outbound untuk bidang xml (struktur awal di bawah nama fungsi sampul) - lihat dokumentasi untuk transportasi SOAP.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '',
        'Edit Web Service' => '',
        'Clone Web Service' => '',
        'The name must be unique.' => 'Nama harus ditetapkan sebagai unik',
        'Clone' => 'Klon',
        'Export Web Service' => '',
        'Import web service' => 'Layanan web impor',
        'Configuration File' => 'Berkas konfigurasi',
        'The file must be a valid web service configuration YAML file.' =>
            'Berkas harus menjadi konfigurasi sah dalam layanan web YAML ',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'Impor',
        'Configuration History' => '',
        'Delete web service' => 'Menghapus layanan web',
        'Do you really want to delete this web service?' => 'Apakah anda ingin menghapus layanan web ini?',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            'Mohon perhatian bahwa layanan web ini tergantung kepada modul-modul lainnya yang hanya tersedia dengan 1%s level kontrak (akan ada pemberitahuan detail lebih lanjut ketika mengimpor).',
        'Import Ready2Adopt web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Setelah anda menyimpan konfigurasi, anda akan diarahkan kembali ke layar edit',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Jika Anda ingin kembali ke ikhtisar silakan tekan tombol"Pergi ke ikhtisar"',
        'Remote system' => 'Sistem remot',
        'Provider transport' => 'Transpor penyedia',
        'Requester transport' => 'Transpor pemohon',
        'Debug threshold' => 'Permulaan eror',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'Dalam mode penyedia, OTRS menawarkan layanan web yang digunakan oleh sistem remote.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'Dalam mode pemohon, OTRS menggunakan layanan web dari sistem remote.',
        'Network transport' => 'Jaringan transpor',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => '',
        'Add error handling module' => '',
        'Operations are individual system functions which remote systems can request.' =>
            'Operasi adalah fungsi sistem individual dimana sistem jauh dapat meminta.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invokers mempersiapkan data untuk permintaan layanan web jarak jauh, dan memproses data responnya.',
        'Controller' => 'Pengendali',
        'Inbound mapping' => 'Pemetaan dalam batas',
        'Outbound mapping' => 'Pemetaan keluar batas',
        'Delete this action' => 'Hapus tindakan ',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Setidaknya satu %s memiliki kontroler yang tidak aktif ataupun tidak hadir, silakan cek pendaftaran kontroler atau hapus %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Riwayat',
        'Go back to Web Service' => 'Kembali ke layanan web',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Di sini anda dapat melihat versi layanan web konfigurasi saat ini, ekspor atau bahkan mengembalikannya',
        'Configuration History List' => 'Daftar sejarah konfigurasi',
        'Version' => 'Versi',
        'Create time' => 'Membuat waktu',
        'Select a single configuration version to see its details.' => 'Pilih versi konfigurasi tunggal untuk melihat rinciannya.',
        'Export web service configuration' => 'Ekspor konfigurasi layanan web ',
        'Restore web service configuration' => 'Mengembalikan konfigurasi layanan web',
        'Do you really want to restore this version of the web service configuration?' =>
            'Apakah anda benar-benar ingin mengembalikan versi konfigurasi layanan web?',
        'Your current web service configuration will be overwritten.' => 'Konfigurasi layanan web anda saat ini akan ditimpa',

        # Template: AdminGroup
        'Group Management' => 'Kelompok managemen',
        'Add Group' => 'Tambah kelompok',
        'Edit Group' => 'Ubah kelompok',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Kelompok admin adalah untuk mendapatkan di admin area dan kelompok statistik untuk mendapatkan daerah statistik.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Membuat grup baru untuk menangani akses berbagai kelompok agen (misalnya Departemen pembelian, departemen dukungan, departemen penjualan, ...).',
        'It\'s useful for ASP solutions. ' => 'Berguna untuk solusi ASP',

        # Template: AdminLog
        'System Log' => 'Sistem logaritma',
        'Here you will find log information about your system.' => 'Disini anda akan menemukan informasi logaritma tentang sistem anda',
        'Hide this message' => 'Sembunyikan pesan',
        'Recent Log Entries' => 'Pemasukan logaritma baru',
        'Facility' => 'Fasilitas',
        'Message' => 'Pesan',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Akun surat managemen',
        'Add Mail Account' => 'Tambahkan akun surat',
        'Edit Mail Account for host' => '',
        'and user account' => '',
        'Filter for Mail Accounts' => '',
        'Filter for mail accounts' => '',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '',
        'If your account is marked as trusted, the X-OTRS headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '',
        'System Configuration' => '',
        'Host' => 'Host',
        'Delete account' => 'Hapuskan akun',
        'Fetch mail' => 'Menarik surat',
        'Do you really want to delete this mail account?' => '',
        'Password' => 'Kata sandi',
        'Example: mail.example.com' => 'Contoh: surat.contoh.com',
        'IMAP Folder' => 'Berkas IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Hanya mengubah ini jika anda perlu mengambil email dari folder yang berbeda selain darii INBOX.',
        'Trusted' => 'Dipercaya',
        'Dispatching' => 'Mengirimkan',
        'Edit Mail Account' => 'Ubah akun surat',

        # Template: AdminNavigationBar
        'Administration Overview' => '',
        'Filter for Items' => '',
        'Filter' => 'Saringan',
        'Favorites' => '',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '',
        'Links' => '',
        'View the admin manual on Github' => '',
        'No Matches' => '',
        'Sorry, your search didn\'t match any items.' => '',
        'Set as favorite' => '',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Notifikasi manajamen tiket',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Di sini Anda dapat memuat file konfigurasi untuk mengimpor Pemberitahuan Tiket ke sistem anda. File harus dalam format .yml seperti yang diekspor oleh modul Pemberitahuan Tiket.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Di sini anda dapat memilih acara yang akan memicu pemberitahuan. Filter tiket tambahan dapat diterapkan di bawah untuk mengirim tiket dengan kriteria tertentu.',
        'Ticket Filter' => 'Filter tiket',
        'Lock' => 'Kunci',
        'SLA' => 'SLA',
        'Customer User ID' => '',
        'Article Filter' => 'Artikel filter',
        'Only for ArticleCreate and ArticleSend event' => 'Hanya untuk ArticleCreate dan ArticleSend ',
        'Article sender type' => 'Jenis pengirim artikel',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Jika ArticleCreate atau ArticleSend digunakan sebagai peristiwa pemicu, anda juga perlu menentukan filter artikel. Silakan pilih minimal satu bidang artikel filter',
        'Customer visibility' => '',
        'Communication channel' => '',
        'Include attachments to notification' => 'Sertakan lampiran pemberitahuan',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Beritahu pengguna hanya sekali per hari untuk menggunakan satu tiket transportasi yang telah dipilih.',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Notifications are sent to an agent or a customer.' => 'Pemberitahuan telah dikirim ke agen atau pelanggan',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Untuk mendapatkan 20 karakter pertama dari subyek (artikel agen terbaru)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Untuk mendapatkan garis 5 pertama dari isi (Artikel agen terbaru)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Untuk mendapatkan 20 karakter pertama dari subyek (Artikel pelanggan terbaru).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Untuk mendapatkan 5 baris pertama dari isi (Artikel pelanggan terbaru).',
        'Attributes of the current customer user data' => 'Atribut pelanggan pengguna data saat ini',
        'Attributes of the current ticket owner user data' => 'Atribut dari pemilik tiket pengguna data saat ini',
        'Attributes of the current ticket responsible user data' => 'Atribut tiket yang bertanggungjawab untuk pengguna data saat ini',
        'Attributes of the current agent user who requested this action' =>
            'Atribut pengguna agen saat ini yang meminta tindakan ',
        'Attributes of the ticket data' => 'Atribut data tiket',
        'Ticket dynamic fields internal key values' => 'Bidang tiket yang dinamis untuk nilai kunci internal ',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Bidang dinamis tiket yang menampilkan nilai, berguna untuk Dropdown dan Multiselecet',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'Mengatur %s',
        'Downgrade to ((OTRS)) Community Edition' => '',
        'Read documentation' => 'Baca dokumentasi',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s membuat kontak secara teratur dengan cloud.otrs.com untuk memeriksa update yang tersedia dan keabsahan kontrak.',
        'Unauthorized Usage Detected' => 'Penggunaan yang tidak sah telah dideteksi',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            'Sistem ini menggunakan %s tanpa lisensi yang tepat! Silakan melakukan kontak dengan %s untuk memperbaharui atau mengaktifkan kontrak anda!',
        '%s not Correctly Installed' => '%s tidak dipasang dengan benar',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            '%s anda tidak dipasang dengan benar. Silakan instal ulang dengan tombol di bawah.',
        'Reinstall %s' => 'Instal ulang %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            '%s anda tidak terpasang dengan benar, dan ada update yang tersedia.',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            'Anda dapat menginstal ulang versi anda saat ini atau melakukan update dengan tombol di bawah (update dianjurkan).',
        'Update %s' => 'Update %s',
        '%s Not Yet Available' => '%s belum tersedia',
        '%s will be available soon.' => '%s akan segera tersedia',
        '%s Update Available' => '%s update tersedia',
        'An update for your %s is available! Please update at your earliest!' =>
            'Update untuk %s anda tersedia! Silahkan perbarui seperti awal!',
        '%s Correctly Deployed' => '%s Benar Dikerahkan',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'Selamat, %s anda telah terpasang dengan benar dan up-to-date!',

        # Template: AdminOTRSBusinessNotInstalled
        'Go to the OTRS customer portal' => '',
        '%s will be available soon. Please check again in a few days.' =>
            '%s akan segera tersedia. Silahkan periksa lagi dalam beberapa hari.',
        'Please have a look at %s for more information.' => 'Silahkan dilihat di %s untuk informasi selanjutnya.',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'Sebelum anda bisa mendapatkan keuntungan dari %s, silahkan hubungi %s untuk mendapatkan kontrak %s anda.',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'Koneksi ke cloud.otrs.com melalui HTTPS tidak dapat ditentukan. Pastikan bahwa OTRS anda dapat terhubung ke cloud.otrs.com melalui port 443.',
        'Package installation requires patch level update of OTRS.' => '',
        'Please visit our customer portal and file a request.' => '',
        'Everything else will be done as part of your contract.' => '',
        'Your installed OTRS version is %s.' => '',
        'To install this package, you need to update to OTRS %s or higher.' =>
            'Untuk menginstall paket ini, Anda harus memperbarui ke oTRS 1%s atau lebih tinggi.',
        'To install this package, the Maximum OTRS Version is %s.' => '',
        'To install this package, the required Framework version is %s.' =>
            '',
        'Why should I keep OTRS up to date?' => 'Kenapa Saya harus membuat OTRS selalu terbarukan?',
        'You will receive updates about relevant security issues.' => 'Anda akan menerima pembaruan terkait isu keamanan yang relevan.',
        'You will receive updates for all other relevant OTRS issues' => 'Anda akan menerima pembaruan untuk semua isu OTRS yang relevan',
        'With your existing contract you can only use a small part of the %s.' =>
            'Dengan kontrak yang ada, anda hanya dapat menggunakan sebagian kecil dari %s.',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            'Jika anda ingin mengambil keuntungan penuh dari %s dapatkan kontrak upgraded sekarang! Hubungi %s',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'Batalkan downgrade dan kembali',
        'Go to OTRS Package Manager' => 'Pergi ke OTRS paket manajer',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            'Maaf, saat ini Anda tidak bisa downgrade karena paket berikut bergantung pada %s:',
        'Vendor' => 'Vendor',
        'Please uninstall the packages first using the package manager and try again.' =>
            'Silahkan uninstall paket pertama yang menggunakan paket manajer dan coba lagi',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            '',
        'Chat' => 'Obrolan',
        'Report Generator' => 'Laporan generator',
        'Timeline view in ticket zoom' => 'Paparan garis waktu didalam tiket gratis',
        'DynamicField ContactWithData' => 'DynamicField ContactWithData',
        'DynamicField Database' => 'Database DynamicField ',
        'SLA Selection Dialog' => 'Seleksi dialog SLA',
        'Ticket Attachment View' => 'Melihat lampiran tiket',
        'The %s skin' => 'The %s skin',

        # Template: AdminPGP
        'PGP Management' => 'Manajemen PGP',
        'Add PGP Key' => 'Tambahkan kunci PGP',
        'PGP support is disabled' => 'Dukungan PGP dinonaktifkan',
        'To be able to use PGP in OTRS, you have to enable it first.' => 'Untuk dapat menggunakan PGP di OTRS, Anda harus mengaktifkannya terlebih dahulu.',
        'Enable PGP support' => 'Aktifkan dukungan PGP',
        'Faulty PGP configuration' => 'Konfigurasi PGP rusak',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Dukungan PGP diaktifkan, tetapi konfigurasi yang relevan mengandung kesalahan. Silakan periksa konfigurasi menggunakan tombol di bawah.',
        'Configure it here!' => 'Konfigurasi di sini!',
        'Check PGP configuration' => 'Periksa konfigurasi PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Dengan cara ini anda dapat langsung mengedit keyring yang telah dikonfigurasi didalam SysConfig.',
        'Introduction to PGP' => 'Pengenalan kepada PGP',
        'Identifier' => 'Pengenalan',
        'Bit' => 'Sedikit',
        'Fingerprint' => 'Sidik jari',
        'Expires' => 'Berakhir',
        'Delete this key' => 'Hapuskan kunci',
        'PGP key' => 'Kunci PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Paket manajer',
        'Uninstall Package' => '',
        'Uninstall package' => 'Uninstal paket',
        'Do you really want to uninstall this package?' => 'Apakah anda ingin menguninstal paket ini?',
        'Reinstall package' => 'Instal ulang paket',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Apakah anda ingin menginstal ulang paket ini? Semua perubahan manual akan hilang.',
        'Go to updating instructions' => '',
        'package information' => 'informasi paket',
        'Package installation requires a patch level update of OTRS.' => '',
        'Package update requires a patch level update of OTRS.' => '',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            '',
        'Please note that your installed OTRS version is %s.' => '',
        'To install this package, you need to update OTRS to version %s or newer.' =>
            '',
        'This package can only be installed on OTRS version %s or older.' =>
            '',
        'This package can only be installed on OTRS version %s or newer.' =>
            '',
        'You will receive updates for all other relevant OTRS issues.' =>
            '',
        'How can I do a patch level update if I don’t have a contract?' =>
            '',
        'Please find all relevant information within the updating instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            'Dalam hal ini anda akan memiliki pertanyaan lebih lanjut, dan kami akan menjawab mereka dengan senang hati',
        'Install Package' => 'Instal paket',
        'Update Package' => '',
        'Continue' => 'Teruskan',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Pastikan database anda meneri paket melebihi ukuran %s MB (Menerima paket lebih dari %s MB saat ini). Sesuaikan pengaturan max_allowed_packet dari database and untuk mengindari kesalahan',
        'Install' => 'Instal',
        'Update repository information' => 'Memperbarui informasi repositori',
        'Cloud services are currently disabled.' => 'Layanan cloud saat ini di non-aktifkan',
        'OTRS Verify™ can not continue!' => 'Verifikasi™ OTRS tidak bisa dilanjutkan',
        'Enable cloud services' => 'Mengaktifkan layanan cloud',
        'Update all installed packages' => '',
        'Online Repository' => 'Repository secara online',
        'Action' => 'Tindakan',
        'Module documentation' => 'Modul dokumentasi',
        'Local Repository' => 'Lokal repositori',
        'This package is verified by OTRSverify (tm)' => 'Paket ini telah di verifikasi oleh OTRSverify (tm)',
        'Uninstall' => 'Uninstal',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Paket tidak disebarkan dengan benar! Silahkan untuk menginstal ulang paket ini.',
        'Reinstall' => 'Instal ulang',
        'Features for %s customers only' => 'Fitur hanya untuk %s pelanggan',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Dengan %s, anda bisa mendapatkan keuntungan dari fitur opsional berikut. Silakan melakukan kontak dengan %s jika anda memerlukan informasi lebih lanjut.',
        'Package Information' => '',
        'Download package' => 'Download paket',
        'Rebuild package' => 'Membangun paket kembali',
        'Metadata' => 'Metadata',
        'Change Log' => 'Ubah logaritma',
        'Date' => 'Tanggal',
        'List of Files' => 'Daftar arsip',
        'Permission' => 'Izin',
        'Download file from package!' => 'Muat turun arsin dari paket',
        'Required' => 'Diwajibkan',
        'Size' => 'Ukuran',
        'Primary Key' => '',
        'Auto Increment' => '',
        'SQL' => 'SQL',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'Perbedaan arsip %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Penyelenggaraan log',
        'Range' => 'Jarak',
        'last' => 'Akhir',
        'This feature is enabled!' => 'Fitur telah diaktifkan!',
        'Just use this feature if you want to log each request.' => 'Gunakan fitur ini jika anda menginginkan log disetiap permintaan',
        'Activating this feature might affect your system performance!' =>
            'Dengan mengaktifkan fitur ini mungkin dapat mempengaruhi kinerja sistem anda!',
        'Disable it here!' => 'Tidak terdapat disini!',
        'Logfile too large!' => 'Logfile terlalu besar!',
        'The logfile is too large, you need to reset it' => 'Logfile terlalu besar, anda perlu memasang kembali!',
        'Reset' => 'Reset',
        'Overview' => 'Peninjauan luas',
        'Interface' => 'Antarmuka',
        'Requests' => 'Permintaan',
        'Min Response' => 'Minimal respon',
        'Max Response' => 'Maksimal respon',
        'Average Response' => 'Rata-rata respon',
        'Period' => 'Periode',
        'minutes' => 'menit',
        'Min' => 'Minimal',
        'Max' => 'Maksimal',
        'Average' => 'Rata-rata',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Manajemen PostMaster Filter',
        'Add PostMaster Filter' => 'Tambah penyaring PostMaster',
        'Edit PostMaster Filter' => 'Ubah penyaring PostMaster',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Untuk mengirimkan atau menyaring email yang masuk berdasarkan header email. Kemungkinan dapat menyesuaikan dengan menggunakan Regular Expressions ',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Jika anda ingin menyesuaikan alamat surat, gunakan
EMAILADDRESS:info@example.com dari, kepada atau Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Jika anda menggunakan Regular Expressions, anda juga dapat menggunakan nilai yang cocok di () sebagai [***] di tindakan \'Set\' ',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'Hapus penyaring ini',
        'Do you really want to delete this postmaster filter?' => '',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'Keadaan penyaringan',
        'AND Condition' => 'kondisi AND',
        'Search header field' => '',
        'for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'lapangan harus ekspresi reguler yang valid atau kata literal',
        'Negate' => 'Meniadakan',
        'Set Email Headers' => 'Mengatur header surat elektronik',
        'Set email header' => 'Mengatur header surat elektronik',
        'with value' => '',
        'The field needs to be a literal word.' => 'lapangan perlu kata literal.',
        'Header' => 'Header',

        # Template: AdminPriority
        'Priority Management' => 'Prioritas manajemen',
        'Add Priority' => 'Tambah prioritas',
        'Edit Priority' => 'Ubah prioritas',
        'Filter for Priorities' => '',
        'Filter for priorities' => '',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => 'Proses manajemen',
        'Filter for Processes' => 'Menyaring proses',
        'Filter for processes' => '',
        'Create New Process' => 'Membuat proses baru',
        'Deploy All Processes' => 'Menyebarkan semua proses',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Disini anda bisa memuat naik file konfigurasi untuk mengimport sebuah proses kepada sistem anda. File diperlukan didalam format .yml sebagai expor oleh modul proses manajemen',
        'Upload process configuration' => 'Memuat naik proses konfigurasi',
        'Import process configuration' => 'Impor proses konfigurasi',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated Ready2Adopt processes.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Untuk membuat proses yang baru, baik impor proses yang telah diekspor dari sistem lain atau membuat yang telah lengkap',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Perubahan pada proses ini hanya mempengaruhi perilaku sistem, jika anda menyinkronkan proses data. Dengan proses sinkronisasi, perubahan baru yang telah dibuat akan ditulis kedalam Konfigurasi.',
        'Processes' => 'Proses',
        'Process name' => 'Nama proses',
        'Print' => 'Mencetak',
        'Export Process Configuration' => 'Ekspor proses konfigurasi',
        'Copy Process' => 'Menyalin proses',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Batalkan dan tutup',
        'Go Back' => 'Kembali',
        'Please note, that changing this activity will affect the following processes' =>
            'Perhatikan, mengubah aktivitas dapat mempengaruhi proses berikutnya',
        'Activity' => 'Aktivitas',
        'Activity Name' => 'Nama activitas',
        'Activity Dialogs' => 'Dialog activitas',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Anda dapat menetapkan Kegiatan Dialog untuk Kegiatan ini dengan menyeret elemen dengan mouse dari daftar kiri ke daftar yang benar.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Pengurutan elemen dalam daftar ini juga mungkin dengan cara drag \'n\' drop.',
        'Filter available Activity Dialogs' => 'Penyaring menyediakan aktivitas dialog',
        'Available Activity Dialogs' => 'Aktivitas dialog tersedia',
        'Name: %s, EntityID: %s' => 'Nama:%s, EntityID:%s',
        'Create New Activity Dialog' => 'Membuat aktivitas dialog baru',
        'Assigned Activity Dialogs' => 'Aktivitas dialog ditetapkan',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Perlu diingat bahwa mengubah dialog kegiatan ini akan mempengaruhi kegiatan berikutnya',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Perlu diingat bahwa pengguna pelanggan tidak dapat melihat atau menggunakan bidang-bidang berikut: Owner, Responsible, Lock, PendingTime and CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Bidang Antrian hanya dapat digunakan oleh pelanggan saat membuat tiket baru.',
        'Activity Dialog' => 'Aktivitas dialog',
        'Activity dialog Name' => 'Nama aktivitas dialog',
        'Available in' => 'Tersedia dalam',
        'Description (short)' => 'Deskripsi (pendek)',
        'Description (long)' => 'Deskripsi (panjang)',
        'The selected permission does not exist.' => 'Pilihan izin tidak ada',
        'Required Lock' => 'Kunci diperlukan',
        'The selected required lock does not exist.' => 'Kunci yang diperlukan tidak ada.',
        'Submit Advice Text' => 'Menghantar saran teks',
        'Submit Button Text' => 'Menghantar tombol teks',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Anda dapat menetapkan bidang untuk Kegiatan Dialog dengan cara menyeret elemen menggunakan mouse dari daftar yang kiri ke daftar yang kanan',
        'Filter available fields' => 'Penyaringan bidang tersedia',
        'Available Fields' => 'Bidang tersedia',
        'Assigned Fields' => 'Fields ditugaskan',
        'Communication Channel' => '',
        'Is visible for customer' => '',
        'Display' => 'Tampilkan',

        # Template: AdminProcessManagementPath
        'Path' => 'Garis edar',
        'Edit this transition' => 'Ubah transisi',
        'Transition Actions' => 'Tindakan transisi',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Anda dapat menetapkan Aksi Transisi ke Transisi ini dengan menyeret elemen menggunakan mouse dari daftar kiri ke daftar yang kanan.',
        'Filter available Transition Actions' => 'Filter aksi transisi tersedia',
        'Available Transition Actions' => 'Tindakan transisi tersedia',
        'Create New Transition Action' => 'Membuat aksi transisi baru',
        'Assigned Transition Actions' => 'Mengajukan aksi transisi',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Aktivitas',
        'Filter Activities...' => 'Filter aktivitas',
        'Create New Activity' => 'Membuat aktivitas baru',
        'Filter Activity Dialogs...' => 'Filter aktivitas dialog',
        'Transitions' => 'Transisi',
        'Filter Transitions...' => 'Filter transisi',
        'Create New Transition' => 'Menciptakan transisi baru',
        'Filter Transition Actions...' => 'Tindakan penyaringan transisi',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Ubah proses',
        'Print process information' => 'Proses pencetakan informasi',
        'Delete Process' => 'Menghapus proses',
        'Delete Inactive Process' => 'Menghapus proses yang tidak aktif',
        'Available Process Elements' => 'Elemen proses tersedia',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Elemen yang tercantum diatas sidebar tidak dapat dipindahkan ke daerah kanvas disebelah kanan dengan menggunakan drag dan drop',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Anda dapat menempatkan aktivitas dikanvas untuk menetapkan kegiatan ini kedalam proses.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Untuk menetapkan sebuah Kegiatan Dialog, sebuah Kegiatan menjatuhkan elemen Kegiatan Dialog dari sidebar ini lebih tempat kegiatan di daerah kanvas.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Tindakan dapat ditugaskan ke sebuah Transisi dengan menjatuhkan Action Elemen ke label Transisi a.',
        'Edit Process Information' => 'Mengubah proses informasi',
        'Process Name' => 'Nama proses',
        'The selected state does not exist.' => 'Pilihan yang ditetapkan tidak ada',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Tambah dan ubah aktivitas, aktivitas dialog dan transisi',
        'Show EntityIDs' => 'Tampilkan EntityDs',
        'Extend the width of the Canvas' => 'Memperpanjang lebar kanvas',
        'Extend the height of the Canvas' => 'Memperpanjang ketinggian kanvas',
        'Remove the Activity from this Process' => 'Menghapus aktivitas dari proses ini',
        'Edit this Activity' => 'Ubah aktivitas ini',
        'Save Activities, Activity Dialogs and Transitions' => 'Simpan aktivitas, aktivitas dialog dan transisi',
        'Do you really want to delete this Process?' => 'Apakah anda ingin menghapus proses ini?',
        'Do you really want to delete this Activity?' => 'Apakah anda ingin menghapus aktivitas?',
        'Do you really want to delete this Activity Dialog?' => 'Apakah anda ingin menghapus aktivitas dialog?',
        'Do you really want to delete this Transition?' => 'Apakah anda ingin menghapus transisi ini?',
        'Do you really want to delete this Transition Action?' => 'Apakah anda ingin menghapus aksi transisi ini?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Apakah anda benar-benar ingin menghapus kegiatan ini dari kanvas? Ini hanya bisa dibatalkan dengan meninggalkan layar tanpa menyimpan.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Apakah anda benar-benar ingin menghapus transisi ini dari kanvas? Ini hanya bisa dibatalkan dengan meninggalkan layar tanpa menyimpan.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Pada layar ini, Anda dapat membuat proses baru. Dalam rangka untuk membuat proses baru tersedia untuk pengguna, pastikan mengatur pilihan untuk \'Aktif\' dan menyinkronkan setelah menyelesaikan pekerjaan anda.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '',
        'Start Activity' => 'Memulai aktivitas',
        'Contains %s dialog(s)' => 'Contains %s dialog(s)',
        'Assigned dialogs' => 'Dialog yang ditugaskan',
        'Activities are not being used in this process.' => 'Aktivitas tidak bisa digunakan didalam proses ini',
        'Assigned fields' => 'Bidang yang ditugaskan',
        'Activity dialogs are not being used in this process.' => 'Aktivitas dialog tidak digunakan didalam proses ini',
        'Condition linking' => 'Syarat untuk menghubungkan',
        'Transitions are not being used in this process.' => 'Transisi tidak digunakan didalam proses ini',
        'Module name' => 'Nama module',
        'Transition actions are not being used in this process.' => 'Aksi transisi tidak dapat digunakan didalam proses',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Perlu diingat bahwa perubahan transisi ini akan mempengaruhi proses berikut',
        'Transition' => 'Transisi',
        'Transition Name' => 'Nama transisi',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Perlu diingat bahwa merubah aksi transisi akan mempengaruhi proses selanjutnya',
        'Transition Action' => 'Aksi transisi',
        'Transition Action Name' => 'Nama aksi transisi',
        'Transition Action Module' => 'Modul aksi transisi',
        'Config Parameters' => 'Configurasi parameter',
        'Add a new Parameter' => 'Tambahkan parameter baru',
        'Remove this Parameter' => 'Hapuskan parameter',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => 'Tambahkan Queue',
        'Edit Queue' => 'Mengubah Queue',
        'Filter for Queues' => 'Filter untuk Queues',
        'Filter for queues' => '',
        'A queue with this name already exists!' => 'Nama queue berikut sudah ada',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => 'Sub-queue dari',
        'Unlock timeout' => 'Membuka batas waktu',
        '0 = no unlock' => '0 = tidak dibuka',
        'hours' => 'jam',
        'Only business hours are counted.' => 'Hanya jam kerja yang dihitung.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Jika agen mengunci tiket dan tidak menutupnya sebelum batas waktu dibuka berakhir, tiket akan membuka dan akan tersedia untuk agen lainnya.',
        'Notify by' => 'Laporan oleh',
        '0 = no escalation' => '0 = tidak ada eskalasi/peningkatan',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Jika tidak menambahkan kontak pelanggan, baik email-eksternal atau telepon, untuk tiket baru sebelum waktu yang ditetapkan berakhir, tiket akan ditingkatkan',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Jika ada sebuah artikel ditambahkan, seperti tindak lanjut melalui email atau portal pelanggan, waktu update eskalasi dipasang kembali. Jika tidak ada kontak pelanggan, baik email-eksternal atau telepon, ditambahkan ke tiket sebelum waktu yang ditetapkan berakhir, tiket akan meningkat',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Jika tiket tidak diatur tutup sebelum waktu yang ditetapkan berakhir, tiket tersebut ditingkatkan',
        'Follow up Option' => 'Menindaklanjuti pilihan',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Menentukan jika tindak lanjut tiket yang telah ditutup akan membuka tiket kembali, menjadi ditolak atau menyebabkan tiket baru.',
        'Ticket lock after a follow up' => 'Kunci tiket setelah menidaklanjuti',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Jika tiket ditutup dan pelanggan mengirimkan tindakan lanjut tiket akan terkunci untuk pemilik lama.',
        'System address' => 'Alamat sistem',
        'Will be the sender address of this queue for email answers.' => 'Akan menjadi alamat pengirim antrian ini untuk jawaban email.',
        'Default sign key' => 'kunci tanda ',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => 'Salam Pembuka',
        'The salutation for email answers.' => 'Penghargaan untuk penjawab email',
        'Signature' => 'Tanda tangan',
        'The signature for email answers.' => 'Tandatangan untuk penjawab email',
        'This queue is used in the following config settings:' => '',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Mengelola Queue-Auto Response Relations',
        'Change Auto Response Relations for Queue' => 'Merubah hubungan respon otomatis untuk Queue',
        'This filter allow you to show queues without auto responses' => 'Filter ini memungkinkan Anda untuk menunjukkan antrian tanpa tanggapan otomatis',
        'Queues without Auto Responses' => '',
        'This filter allow you to show all queues' => 'Filter ini memungkinkan Anda untuk menampilkan semua antrian',
        'Show All Queues' => '',
        'Auto Responses' => 'Respon otomatis',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Mengelola hubungan Template-Queue',
        'Filter for Templates' => 'Filter untuk sebuah klise',
        'Filter for templates' => '',
        'Templates' => 'Klise',

        # Template: AdminRegistration
        'System Registration Management' => 'Manajemen sistem registrasi',
        'Edit System Registration' => '',
        'System Registration Overview' => '',
        'Register System' => '',
        'Validate OTRS-ID' => '',
        'Deregister System' => 'Sistem deregister',
        'Edit details' => 'Mengubah rincian',
        'Show transmitted data' => 'Tampilkan data dikirimkan',
        'Deregister system' => 'Sistem deregister',
        'Overview of registered systems' => 'Ikhtisar sistem yang terdaftar',
        'This system is registered with OTRS Group.' => 'Sistem ini telah terdaftar oleh grup OTRS',
        'System type' => 'Jenis sistem',
        'Unique ID' => 'Unique ID',
        'Last communication with registration server' => 'Komunikasi terakhir dengan server registrasi',
        'System Registration not Possible' => '',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'Perlu diingat bahwa anda tidak dapat mendaftarkan sistem anda apabila OTRS Daemon tidak berjalan dengan baik',
        'Instructions' => 'Instruksi',
        'System Deregistration not Possible' => '',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'Perlu diingat bahwa anda tidak bisa deregistrer sistem anda apabila anda mengunnakannya %s atau mempunyai sebuah kontrak layanan sah',
        'OTRS-ID Login' => 'OTRS-ID masuk',
        'Read more' => 'Baca lagi',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Anda perlu masuk dengan menggunakan OTRS-ID anda ke dalam sistem pendaftaran anda',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'OTRS-ID anda merupakan alamat email anda yang digunakan saat pendaftaran di layanan web OTRS.com',
        'Data Protection' => 'Perlindungan data',
        'What are the advantages of system registration?' => 'Apa keuntungan dari sistem pendaftaran?',
        'You will receive updates about relevant security releases.' => 'Anda akan menerima update tentang rilis keamanan yang relevan.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Dengan sistem registrasi anda, kita dapat meningkatkan layanan untuk anda, karena kita memiliki semua informasi yang relevan ',
        'This is only the beginning!' => 'Ini hanya permulaan!',
        'We will inform you about our new services and offerings soon.' =>
            'Kami akan memberitahu anda tentang layanan baru kami dan akan mempersembahkannya dengan segera.',
        'Can I use OTRS without being registered?' => 'Apakah saya bisa menggunakan OTRS tanpa melakukan pendaftaran?',
        'System registration is optional.' => 'Sistem pendaftaran adalah pilihan',
        'You can download and use OTRS without being registered.' => 'Anda bisa memuat naik dan menggunakan OTRS tanpa harus daftar',
        'Is it possible to deregister?' => 'Apakah mungkin untuk melakukan deregister?',
        'You can deregister at any time.' => 'Anda bisa melakukan deregister kapan saja',
        'Which data is transfered when registering?' => 'Data manakah yang ditransfer saat mendaftar?',
        'A registered system sends the following data to OTRS Group:' => 'Sebuah sistem yang terdaftar akan mengirimkan data berikut untuk grup OTRS',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Nama Fully Qualified Domain (FQDN), versi OTRS, Database, Sistem Operasi dan versi Perl.',
        'Why do I have to provide a description for my system?' => 'Mengapa saya harus memberikan keterangan untuk sistem saya?',
        'The description of the system is optional.' => 'Deskripsi dari sistem ini adalah opsional.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Deskripsi dan jenis sistem yang anda tentukan untuk membantu anda mengidentifikasi dan mengelola rincian sistem yang terdaftar.',
        'How often does my OTRS system send updates?' => 'Seberapa sering sistem OTRS saya mengirim pembaruan?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Sistem anda akan mengirimkan pembaruan ke server pendaftaran secara berkala.',
        'Typically this would be around once every three days.' => 'Biasanya ini akan menjadi sekitar tiga hari sekali.',
        'If you deregister your system, you will lose these benefits:' =>
            'Jika anda melakukan deregister sistem anda, maka anda akan kehilangan manfaat berikut:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Anda perlu masuk dengan menggunakan ID OTRS anda ke dalam sistem deregister anda',
        'OTRS-ID' => 'ID OTRS',
        'You don\'t have an OTRS-ID yet?' => 'Anda tidak mempunyai ID OTRS?',
        'Sign up now' => 'Daftarkan sekarang',
        'Forgot your password?' => 'Anda lupa password?',
        'Retrieve a new one' => 'Mengambil yang baru',
        'Next' => 'Lanjut',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Data ini akan sering dialihkan ke OTRS Grup saat anda mendaftar sistem ini.',
        'Attribute' => 'Atribut',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'Versi OTRS',
        'Operating System' => 'Sistem operasi',
        'Perl Version' => 'Versi Perl',
        'Optional description of this system.' => 'Deskripsi opsional sistem ini',
        'Register' => 'Daftar',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Melanjutkan dengan langkah berikut akan mempengaruhi deregister dari grup OTRS',
        'Deregister' => 'Tidak terdaftar',
        'You can modify registration settings here.' => 'Anda bisa mengubah pengaturan disini',
        'Overview of Transmitted Data' => '',
        'There is no data regularly sent from your system to %s.' => 'Tidak ada data regular yang dikirim dari sistem ke %s',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Data berikut dikirim dengan minimal 3 hari dari sistem anda ke %s',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Data akan di transfer dalam format JSON melalui koneksi https yang aman ',
        'System Registration Data' => 'Data sistem pendaftaran',
        'Support Data' => 'Data pendukung',

        # Template: AdminRole
        'Role Management' => 'Tugas manajemen',
        'Add Role' => 'Tambahkan peran',
        'Edit Role' => 'Mengubah peran',
        'Filter for Roles' => 'Filter untuk peran',
        'Filter for roles' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Membuat sebuah tugas dan menyimpannya ke dalam grup. Kemudian menambahkan tugas untuk pengguna',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Tidak ada peran didefinisikan. Silahkan gunakan tombol \'Add\' untuk membuat peran baru.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Mengelola hubungan peran didalam grup',
        'Roles' => 'Peran',
        'Select the role:group permissions.' => 'Select the role:group permissions.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Jika tidak ada yang dipilih, maka tidak ada izin di grup ini (tiket tidak akan tersedia untuk peran tersebut).',
        'Toggle %s permission for all' => 'Beralih izin %s untuk semua',
        'move_into' => 'move_into',
        'Permissions to move tickets into this group/queue.' => 'Pengijinan untuk memindahkan tiket ke dalam grup/queue',
        'create' => 'Menciptkan',
        'Permissions to create tickets in this group/queue.' => 'Pengijinan untuk membuat tiket di dalam grup/queue ini',
        'note' => 'Catatan',
        'Permissions to add notes to tickets in this group/queue.' => 'Izin untuk menambahkan catatan ke dalam tiket di grup/queue',
        'owner' => 'Pemilik',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Izin untuk mengubah pemilik tiket di dalam grup/queue ini',
        'priority' => 'Prioritas',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Izin untuk mengubah prioritas tiket di dalam grup/queue',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Mengelola hubungan Agent-Role',
        'Add Agent' => 'Tambahkan agen',
        'Filter for Agents' => 'Filter untuk agen',
        'Filter for agents' => '',
        'Agents' => 'Agen',
        'Manage Role-Agent Relations' => 'Mengelola hubungan Role-Agent',

        # Template: AdminSLA
        'SLA Management' => 'Manajemen SLA',
        'Edit SLA' => 'Mengubah SLA',
        'Add SLA' => 'Tambahkan SLA',
        'Filter for SLAs' => '',
        'Please write only numbers!' => 'Silahkan tulis angka saja',

        # Template: AdminSMIME
        'S/MIME Management' => 'Manajemen S/MIME',
        'Add Certificate' => 'Tambahkan sertifikat',
        'Add Private Key' => 'Tambahkan kunci pribadi',
        'SMIME support is disabled' => 'Dukungan S MIME dinonaktifkan',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            'Untuk dapat menggunakan SMIME di OTRS, Anda harus mengaktifkannya terlebih dahulu.',
        'Enable SMIME support' => 'Aktifkan dukungan SMIME',
        'Faulty SMIME configuration' => 'Konfigurasi SMIME rusak',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Dukungan SMIME diaktifkan, tetapi konfigurasi yang relevan mengandung kesalahan. Silakan periksa konfigurasi menggunakan tombol di bawah.',
        'Check SMIME configuration' => 'Periksa konfigurasi SMIME',
        'Filter for Certificates' => '',
        'Filter for certificates' => 'Filter untuk sertifikat',
        'To show certificate details click on a certificate icon.' => 'Menampilkan rincian sertifikat dengan mengklik tombol sertifikat',
        'To manage private certificate relations click on a private key icon.' =>
            'Mengelola hubungan sertifikat pribadi dengan mengklik tombol kunci pribadi',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Disini anda bisa menambahkan hubungan untuk sertifikat pribadi anda, iini akan tertanam untuk tanda tangan S/MIME setiap kali anda menggunakan sertifikat ini untuk menandatangani email.',
        'See also' => 'Lihat juga',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Dengan cara ini anda dapat langsung mengedit sertifikasi dan kunci pribadi dalam sistem file',
        'Hash' => 'Campuran',
        'Create' => 'Buat',
        'Handle related certificates' => 'Menangani yang berhubungan dengan sertifikat',
        'Read certificate' => 'Baca sertifikat',
        'Delete this certificate' => 'Menghapus sertifikat ini',
        'File' => 'Berkas',
        'Secret' => 'Rahasia',
        'Related Certificates for' => 'Sertifikat terkait untuk',
        'Delete this relation' => 'Hapus hubungan ini',
        'Available Certificates' => 'Sertifikat tersedia',
        'Filter for S/MIME certs' => 'Filter untuk sertifikat S/MIME',
        'Relate this certificate' => 'Sertifikat ini terkait',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'sertifikat S/MIME',
        'Close this dialog' => 'Tutup dialog',
        'Certificate Details' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Manajemen penghargaan',
        'Add Salutation' => 'Tambahkan penghargaan',
        'Edit Salutation' => 'Ubah Salutasi',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'Contoh',
        'Example salutation' => 'Contoh salutasi',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Modul pengamanan (biasanya) akan diatur setelah instalasi berhasil',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Jika modus aman tidak diaktifkan, cara mengaktifkannya melalui sysconfig karena aplikasi anda sudah berjalan.',

        # Template: AdminSelectBox
        'SQL Box' => 'Kotak SQL',
        'Filter for Results' => '',
        'Filter for results' => '',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Disini anda akan memasukan SQL dan langsung mengirimkannya ke dalam aplikasi database. Tidak mungkin untuk mengadakan isi perubahan didalam table, hanya queries yang terlah dipilih diperbolehkan',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Disini anda memasukkan SQL langsung mengirimkan ke aplikasi database',
        'Options' => 'Opsi',
        'Only select queries are allowed.' => 'Hanya queries yang dipilih diperbolehkan',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Sintax SQL query anda terdapat kesalahan. Tolong dicek kembali',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Setidaknya ada 1 parameter yang hilang untuk mengikat. Tolong dilihat kembali',
        'Result format' => 'Hasil format',
        'Run Query' => 'Jalankan Query',
        '%s Results' => '',
        'Query is executed.' => 'Query dijalankan',

        # Template: AdminService
        'Service Management' => 'Manajemen servis',
        'Add Service' => 'Tambahkan Layanan',
        'Edit Service' => 'Ubah layanan',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => 'Sub-layanan dari',

        # Template: AdminSession
        'Session Management' => 'Manajemen sesi',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'Semua sesi',
        'Agent sessions' => 'Sesi agen',
        'Customer sessions' => 'Sesi pelanggan',
        'Unique agents' => 'Agen Unique',
        'Unique customers' => 'Pelanggan Unique',
        'Kill all sessions' => 'Hapuskan sesi',
        'Kill this session' => 'Hapuskan sesi ini',
        'Filter for Sessions' => '',
        'Filter for sessions' => '',
        'Session' => 'Sessi',
        'User' => 'Pengguna',
        'Kill' => 'Hapuskan',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'Tandatangan manajemen',
        'Add Signature' => 'Tambahkan Tandatangan',
        'Edit Signature' => 'Ubah tandatangan',
        'Filter for Signatures' => '',
        'Filter for signatures' => '',
        'Example signature' => 'Contoh tandatangan',

        # Template: AdminState
        'State Management' => 'Manajemen pilihan',
        'Add State' => 'Tambahkan Pilihan',
        'Edit State' => 'Ubah Pilihan',
        'Filter for States' => '',
        'Filter for states' => '',
        'Attention' => 'Perhatian',
        'Please also update the states in SysConfig where needed.' => 'Silahkan perbarui pilihan di dalam SysConfig yang diperlukan',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'Jenis pilihan',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => 'Mengirimkan dukungan data ke dalam grup OTRS tidak didapati',
        'Enable Cloud Services' => 'Mengadakan layanan cloud',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'Data ini dihantar ke grup OTRS dalam basis yang sederhana. Untuk menghentikan data ini, silahkan perbarui system pendaftaran anda',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Anda dapat secara manual memicu Data Dukungan pengiriman dengan menekan tombol:',
        'Send Update' => 'Hantar pembaruan',
        'Currently this data is only shown in this system.' => 'Saat ini data hanya menampilkan sistem ini',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Sebuah bundel dukungan (termasuk: informasi pendaftaran sistem, data pendukung, daftar paket yang diinstal dan semua sumber kode yang diubah secara manual) dapat dihasilkan dengan menekan tombol ini:',
        'Generate Support Bundle' => 'Menghasilkan Dukungan Bundle',
        'The Support Bundle has been Generated' => '',
        'Please choose one of the following options.' => 'Silahkan pilih satu dari pilihan berikut',
        'Send by Email' => 'Hantarkan melalu email',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'Dukungan bundel terlalu besar untuk mengirimkannya melalu email, pilihan ini ditiadakan',
        'The email address for this user is invalid, this option has been disabled.' =>
            'Alamat email untuk pengguna ini tidak sah, pilihan ini ditiadakan',
        'Sending' => 'Menghantar',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'Pendukung bundel akan menghantar ke grup OTRS melalui email dengan otomatis',
        'Download File' => 'Memuat turun file',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'Sebuah file yang berisi dukungan bundel akan di-download ke sistem lokal. Harap menyimpan file dan mengirimkannya ke grup OTRS,  denganmenggunakan metode alternatif.',
        'Error: Support data could not be collected (%s).' => 'Eror: data pendukung tidak dapat dikumpulkan (%s)',
        'Details' => 'Rincian',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Sistem manajemen alamat email',
        'Add System Email Address' => 'Tambahkan sistem alamat email',
        'Edit System Email Address' => 'Ubah sistem alamat email',
        'Add System Address' => '',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Semua email yang masuk dengan alamat ini Untuk atau Cc akan dikirim ke antrian yang dipilih.',
        'Email address' => 'Alamat email',
        'Display name' => 'Paparkan nama',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'Paparkan nama dan alamat email yang akan ditunjukkan di email yang anda kirim',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => '',
        'System configuration' => '',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '',
        'Find out how to use the system configuration by reading the %s.' =>
            '',
        'Search in all settings...' => '',
        'There are currently no settings available. Please make sure to run \'otrs.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '',
        'Help' => '',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            '',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            '',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            '',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            '',
        'Please review the changed settings and deploy afterwards.' => '',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            '',
        'Changes Overview' => '',
        'There are %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '',
        'You have %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            '',
        'There are no settings to be deployed.' => '',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            '',
        'Deploy selected changes' => '',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            '',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => '',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            '',
        'Upload system configuration' => '',
        'Import system configuration' => '',
        'Download current configuration settings of your system in a .yml file.' =>
            '',
        'Include user settings' => '',
        'Export current configuration' => '',

        # Template: AdminSystemConfigurationSearch
        'Search for' => '',
        'Search for category' => '',
        'Settings I\'m currently editing' => '',
        'Your search for "%s" in category "%s" did not return any results.' =>
            '',
        'Your search for "%s" in category "%s" returned one result.' => '',
        'Your search for "%s" in category "%s" returned %s results.' => '',
        'You\'re currently not editing any settings.' => '',
        'You\'re currently editing %s setting(s).' => '',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Kategori',
        'Run search' => 'Menjalankan pencarian',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => '',
        'View single Setting: %s' => '',
        'Go back to Deployment Details' => '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Manajemen sistem pemeliharan',
        'Schedule New System Maintenance' => 'Jadwal sistem pemeliharaan baru',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Jadwal sistem periode pemeliharaan untuk mengumumkan agen dan pelanggan bahwa sistem tidak bisa diakses selama beberapa waktu',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Beberapa waktu sebelum pemeliharaan sistem ini dimulai pengguna akan menerima notifikasi di setiap layar mengumumkan tentang fakta ini.',
        'Stop date' => 'Tanggal berhenti',
        'Delete System Maintenance' => 'Hapuskan sistem pemeliharaan',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'Tanggal tidak sah',
        'Login message' => 'Masukkan surat',
        'This field must have less then 250 characters.' => '',
        'Show login message' => 'Tampilkan surat',
        'Notify message' => 'Beritahu surat',
        'Manage Sessions' => 'Mengatur sesi',
        'All Sessions' => 'Semua sesi',
        'Agent Sessions' => 'Sesi agen',
        'Customer Sessions' => 'Sesi pelanggan',
        'Kill all Sessions, except for your own' => 'Padamkan semua sesi, kecuali untuk anda sendiri',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => 'Tambahkan template',
        'Edit Template' => 'Ubah template',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Template adalah teks default yang membantu agen anda untuk menulis tiket lebih cepat, jawab atau lanjutkan.',
        'Don\'t forget to add new templates to queues.' => 'Jangan lupa untuk menambahkan templat queues',
        'Attachments' => 'Lampiran',
        'Delete this entry' => 'Hapuskan entri ini',
        'Do you really want to delete this template?' => 'Apakah Anda benar-benar ingin menghapus template ini?',
        'A standard template with this name already exists!' => 'Template standar dengan nama ini sudah ada!',
        'Template' => 'Template',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => 'Membuat jenis template hanya mendukung smart tag ini',
        'Example template' => 'Contoh template',
        'The current ticket state is' => 'Pilihan tiket saat ini adalah',
        'Your email address is' => 'Alamat email anda adalah',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'Beralih aktif untuk semua',
        'Link %s to selected %s' => 'Link ke operator %s',

        # Template: AdminType
        'Type Management' => 'Jenis manajemen',
        'Add Type' => 'Tambahkan jenis',
        'Edit Type' => 'Ubah jenis',
        'Filter for Types' => '',
        'Filter for types' => '',
        'A type with this name already exists!' => 'Jenis dengan nama ini sudah ada',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'Agen manajemen',
        'Edit Agent' => 'Ubah agen',
        'Edit personal preferences for this agent' => '',
        'Agents will be needed to handle tickets.' => 'Agen akan diperlukan untuk menangani tiket',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Jangn lupa untu menambahkan agen baru ke dalam grup dan/atau peran!',
        'Please enter a search term to look for agents.' => 'Silahkan masukkan istilah pencarian untuk mencari agen',
        'Last login' => 'Terakhir masuk',
        'Switch to agent' => 'Tukarkan ke agen',
        'Title or salutation' => 'Judul atau salam',
        'Firstname' => 'Nama pertama',
        'Lastname' => 'Nama terakhir',
        'A user with this username already exists!' => 'Pengguna dengan nama ini sudah ada!',
        'Will be auto-generated if left empty.' => 'Akan otomatis dihasilkan jika dibiarkan kosong.',
        'Mobile' => 'Telepon genggam',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => '',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Mengatur hubungan Grup-Agen ',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => '',
        'Manage Calendars' => '',
        'Add Appointment' => '',
        'Today' => 'Hari ini',
        'All-day' => 'Semua hari',
        'Repeat' => '',
        'Notification' => 'Pemberitahuan',
        'Yes' => 'Ya',
        'No' => 'Tidak',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '',
        'Calendars' => '',

        # Template: AgentAppointmentEdit
        'Basic information' => '',
        'Date/Time' => '',
        'Invalid date!' => 'Tanggal tidak sah!',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => '',
        'Click here to see the parent appointment.' => '',
        'Click here to edit the parent appointment.' => '',
        'Frequency' => '',
        'Every' => '',
        'day(s)' => 'hari',
        'week(s)' => 'minggu',
        'month(s)' => 'bulan',
        'year(s)' => 'tahun',
        'On' => 'Aktif',
        'Monday' => 'Senin',
        'Mon' => 'Sen',
        'Tuesday' => 'Selasa',
        'Tue' => 'Sel',
        'Wednesday' => 'Rabu',
        'Wed' => 'Rab',
        'Thursday' => 'Kamis',
        'Thu' => 'Kam',
        'Friday' => 'Jumat ',
        'Fri' => 'Jum',
        'Saturday' => 'Sabtu',
        'Sat' => 'Sab',
        'Sunday' => 'Minggu',
        'Sun' => 'Min',
        'January' => 'Januari',
        'Jan' => 'Jan',
        'February' => 'Februari',
        'Feb' => 'Feb',
        'March' => 'Maret',
        'Mar' => 'Mar',
        'April' => 'April',
        'Apr' => 'Apr',
        'May_long' => 'Mei_panjang',
        'May' => 'Mei',
        'June' => 'Juni',
        'Jun' => 'Jun',
        'July' => 'Juli',
        'Jul' => 'Jul',
        'August' => 'Agustus',
        'Aug' => 'Agu',
        'September' => 'September',
        'Sep' => 'Sep',
        'October' => 'Oktober',
        'Oct' => 'Okt',
        'November' => 'November',
        'Nov' => 'Nov',
        'December' => 'Desember',
        'Dec' => 'Des',
        'Relative point of time' => '',
        'Link' => 'Tautan',
        'Remove entry' => 'Hapuskan entri',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Pusat informasi pelanggan',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Pengguna pelanggan',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Perlu diketahui: Pelanggan tidak sah!',
        'Start chat' => 'Memulai obrolan',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'Pencarian template',
        'Create Template' => 'Membuat template',
        'Create New' => 'Membuat baru',
        'Save changes in template' => 'Simpan pengubahan di dalam template',
        'Filters in use' => 'Filter digunakan',
        'Additional filters' => 'Filter tambahan',
        'Add another attribute' => 'Tambahkan attribute lain',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Pilih semua',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => '',
        'Add selected customer user to' => '',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Mengubah opsi pencarian',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => '',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'The OTRS Daemon adalah proses daemon yang melakukan tugas-tugas asynchronous, misalnya eskalasi tiket trigger, pengiriman email, dll.',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            'Menjalankan Daemon OTRS adalah wajib untuk operasi sistem yang benar.',
        'Starting the OTRS Daemon' => 'Memulai dengan Daemon OTRS',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            'Pastikan fail tersebut %s ada (tanpa .dist tambahan). Tugas cron ini akan memeriksa setiap 5 menit jika OTRS Daemon berjalan dan memulainya jika diperlukan.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            'Mengeksekusi \'%s start\' untuk memastikan pekerjaan cron dari pengguna OTRS \'yang aktif.',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            'Setelah 5 menit, periksa OTRS Daemon menjalankan dengan system (
bin/otrs.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Dasbor',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '',
        'Tomorrow' => 'Besok',
        'Soon' => '',
        '5 days' => '',
        'Start' => 'Mulai',
        'none' => 'Tidak ada',

        # Template: AgentDashboardCalendarOverview
        'in' => 'Masuk',

        # Template: AgentDashboardCommon
        'Save settings' => 'Simpan pengubahan',
        'Close this widget' => 'Tutup widget',
        'more' => 'Lebih',
        'Available Columns' => 'Kolom tersedia',
        'Visible Columns (order by drag & drop)' => 'Kolom yang terlihat (order dengan drag & drop)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '',
        'Open' => 'buka',
        'Closed' => 'tertutup',
        '%s open ticket(s) of %s' => '%s tiket dibuka(s) dari %s',
        '%s closed ticket(s) of %s' => '%s tiket ditutup(s) dari %s',
        'Edit customer ID' => '',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Tiket meningkat',
        'Open tickets' => 'tiket terbuka',
        'Closed tickets' => 'tiket tertutup',
        'All tickets' => 'Semua Tiket',
        'Archived tickets' => 'Tiket yang telah di arsipkan',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '',
        'Phone ticket' => 'Tiket telepon',
        'Email ticket' => 'Tiket email',
        'New phone ticket from %s' => 'Tiket telepon baru dari %S',
        'New email ticket to %s' => 'Tiket email baru untuk %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s telah tersedia',
        'Please update now.' => 'Silahkan lakukan pembaruan sekarang',
        'Release Note' => 'Rilis catatan',
        'Level' => 'Tingkat',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Diposting %s lalu',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'Konfigurasi untuk widget statistik ini mengandung kesalahan, silahkan tinjau pengaturan.',
        'Download as SVG file' => 'Memuat turun sebagain file SVG',
        'Download as PNG file' => 'Memuat turun sebagai file PNG',
        'Download as CSV file' => 'Memuat turun sebagai file CSV',
        'Download as Excel file' => 'Memuat turun sebagai file Excel',
        'Download as PDF file' => 'Memuat turun sebagai file PDF',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Silakan pilih format output grafik yang valid dalam konfigurasi widget ini.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Isi dari statistik ini sedang dipersiapkan untuk anda, harap bersabar.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Statistik saat ini tidak digunakan karena konfigurasinya perlu dikoreksi oleh administrator statistik.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '',
        'Accessible for customer user' => '',
        'My locked tickets' => 'Tiket saya terkunci',
        'My watched tickets' => 'Tiket saya menonton',
        'My responsibilities' => 'Tanggung jawab saya',
        'Tickets in My Queues' => 'Tiket di Antrian saya',
        'Tickets in My Services' => 'Tiket di Layanan Saya',
        'Service Time' => 'Layanan waktu',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '',

        # Template: AgentDashboardUserOnline
        'out of office' => 'Keluar dari kantor',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'Sampai',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Untuk menerima berita, lisensi atau beberapa perubahan.',
        'Yes, accepted.' => '',

        # Template: AgentLinkObject
        'Manage links for %s' => '',
        'Create new links' => '',
        'Manage existing links' => '',
        'Link with' => '',
        'Start search' => '',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => '',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => 'Mengedit preferensi anda',
        'Personal Preferences' => '',
        'Preferences' => 'Pilihan',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '',
        'Go back to editing this agent' => '',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            '',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '',
        'Dynamic Actions' => '',
        'Filter settings...' => '',
        'Filter for settings' => '',
        'Save all settings' => '',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            '',
        'Off' => 'Nonaktifkan',
        'End' => 'Akhir',
        'This setting can currently not be saved.' => '',
        'This setting can currently not be saved' => '',
        'Save this setting' => '',
        'Did you know? You can help translating OTRS at %s.' => 'Tahukah kamu? Anda dapat membantu menerjemahkan OTRS di%s.',

        # Template: SettingsList
        'Reset to default' => '',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '',
        'Did you know?' => '',
        'You can change your avatar by registering with your email address %s on %s' =>
            '',

        # Template: AgentSplitSelection
        'Target' => 'Target',
        'Process' => 'Proses',
        'Split' => 'Pisah',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '',
        'Add Statistics' => '',
        'Read more about statistics in OTRS' => '',
        'Dynamic Matrix' => 'Matrik dinamis',
        'Each cell contains a singular data point.' => '',
        'Dynamic List' => 'Daftar dinamis',
        'Each row contains data of one entity.' => '',
        'Static' => 'Statis',
        'Non-configurable complex statistics.' => '',
        'General Specification' => 'Spesifikasi umum',
        'Create Statistic' => 'Membuat statistik',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '',
        'Run now' => 'Jalankan sekarang',
        'Statistics Preview' => 'Statistik peninjauan',
        'Save Statistic' => '',

        # Template: AgentStatisticsImport
        'Import Statistics' => '',
        'Import Statistics Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Statistik',
        'Run' => 'Jalankan',
        'Edit statistic "%s".' => 'Edit statistik "%s"',
        'Export statistic "%s"' => 'Ekspor statistik "%s"',
        'Export statistic %s' => 'Expor statistik %s',
        'Delete statistic "%s"' => 'Hapuskan statistik "%s"',
        'Delete statistic %s' => 'Hapuskan statistik %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => '',
        'View Statistics' => '',
        'Statistics Information' => '',
        'Created by' => 'Dibuat oleh',
        'Changed by' => 'Diubah oleh',
        'Sum rows' => 'Jumlah baris',
        'Sum columns' => 'Jumlah kolom',
        'Show as dashboard widget' => 'Tampilkan sebagai dashboard widget',
        'Cache' => 'Menyembunyikan',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Statistik ini mengandung kesalahan konfigurasi dan dapat saat ini tidak digunakan.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'Ubah teks bebas dari %s%s%s',
        'Change Owner of %s%s%s' => 'Ubah pemilik dari %s%s%s',
        'Close %s%s%s' => 'Tutup %s%s%s',
        'Add Note to %s%s%s' => 'Tambah catatan untuk %s%s%s',
        'Set Pending Time for %s%s%s' => 'Set Waktu Tertunda untuk %s%s%s',
        'Change Priority of %s%s%s' => 'Tukar prioritas dari %s%s%s',
        'Change Responsible of %s%s%s' => 'Ubah tanggung jawab dari %s%s%s',
        'All fields marked with an asterisk (*) are mandatory.' => 'Semua bidang yang ditandai dengan tanda bintang (*) wajib diisi.',
        'The ticket has been locked' => 'Tiket telah dikunci',
        'Undo & close' => 'Undur & tutup',
        'Ticket Settings' => 'Pengaturan email',
        'Queue invalid.' => '',
        'Service invalid.' => 'Layanan tidak sah',
        'SLA invalid.' => '',
        'New Owner' => 'Pemilik baru',
        'Please set a new owner!' => 'Silahkan set sebagain owner baru!',
        'Owner invalid.' => '',
        'New Responsible' => 'Tanggung jawab baru',
        'Please set a new responsible!' => '',
        'Responsible invalid.' => '',
        'Next state' => 'Pilihan berikutnya',
        'State invalid.' => '',
        'For all pending* states.' => 'Untuk semua yang tertunda',
        'Add Article' => 'Tambahkan artikel',
        'Create an Article' => 'Membuat sebuah artikel',
        'Inform agents' => 'Beritahu agen',
        'Inform involved agents' => 'Beritahu agen yang terlibat',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Di sini anda dapat memilih agen tambahan yang harus menerima pemberitahuan tentang artikel baru.',
        'Text will also be received by' => 'Teks akan diterima oleh',
        'Text Template' => 'Template teks',
        'Setting a template will overwrite any text or attachment.' => 'Pengaturan template akan menimpa teks atau lampiran.',
        'Invalid time!' => 'Waktu tidak sah!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'Bounce %s%s%s',
        'Bounce to' => 'Melompat',
        'You need a email address.' => 'Anda perlu alamat email',
        'Need a valid email address or don\'t use a local email address.' =>
            'Membutuhkan alamat email yang valid atau tidak menggunakan alamat email lokal.',
        'Next ticket state' => 'Pilihan tiket berikutnya',
        'Inform sender' => 'Beritahun penghantar',
        'Send mail' => 'Hantarkan surat',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Aksi Tiket Massal ',
        'Send Email' => 'Hantarkan email',
        'Merge' => 'Gabung',
        'Merge to' => 'Menggabungkan',
        'Invalid ticket identifier!' => 'Identifier tiket tidak valid!',
        'Merge to oldest' => 'Menggabungkan ke yang terlama',
        'Link together' => 'Menyambungkan semua',
        'Link to parent' => 'Menyambungkan ke parent',
        'Unlock tickets' => 'Membuka tiket',
        'Execute Bulk Action' => 'Menghasilkan Dukungan Bundle',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Susunan jawaban untuk %s%s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'Alamat ini terdaftar sebagai alamat sistem dan tidak bisa digunakan: %s',
        'Please include at least one recipient' => 'Harap sertakan minimal satu penerima',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => '',
        'Remove Ticket Customer' => 'Hapus tiket pelanggan',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Tolong hapus entri ini dan masukan yang baru dengan value yang benar',
        'This address already exists on the address list.' => 'Alamat ini sudah ada yang menggunakan',
        'Remove Cc' => 'Hapus Cc',
        'Bcc' => 'Bcc',
        'Remove Bcc' => 'Hapus Bccc',
        'Date Invalid!' => 'Tanggal tidak sah!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Ubah pelanggan dari %s%s%s',
        'Customer Information' => 'Informasi Pelanggan',
        'Customer user' => 'Pengguna pelanggan',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Mencipta tiket email baru',
        'Example Template' => 'Contoh template',
        'From queue' => 'Dari queue',
        'To customer user' => 'Untuk pengguna pelanggan',
        'Please include at least one customer user for the ticket.' => 'Tolong sertakan minimal satu pengguna pelanggan untuk tiket',
        'Select this customer as the main customer.' => 'Pilih pelanggan ini sebagai pelanggan utama',
        'Remove Ticket Customer User' => 'Hapus pengguna pelanggan tiket',
        'Get all' => 'Dapatkan semua',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'Email keluar untuk %s%s%s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Tiket %s: respon pertama berakhir (%s%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Tiket %s: Waktu respon pertama akan berakhir di %s%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Tiket %s: waktu update lebih (%s/%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'Tiket %S: Waktu pembaruan akan berakhir di %s%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Tiket %s: Waktu solusi akan berakhir (%s%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Tiket %s: Waktu solusi akan berakhir di %s%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Mengirimkan %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'Sejarah dari %s%s%s',
        'Filter for history items' => '',
        'Expand/collapse all' => '',
        'CreateTime' => 'WaktuPembuatan',
        'Article' => 'Artikel',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Memisahkan %s%s%s',
        'Merge Settings' => 'Atur penggabungan',
        'You need to use a ticket number!' => 'Anda perlu menggunakan nomor tiket!',
        'A valid ticket number is required.' => 'Diperlukan tiket yang sah',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => '',
        'Need a valid email address.' => 'Diperlukan alamat email yang sah',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Pindah %s%s%s',
        'New Queue' => 'Queue baru',
        'Move' => 'Pindah',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Tidak ada tiket ditemukan',
        'Open / Close ticket action menu' => 'Buka/tutup menu aksi tiket',
        'Select this ticket' => 'Pilih tiket ini',
        'Sender' => 'Pengirim',
        'First Response Time' => 'Waktu respon yang pertama',
        'Update Time' => 'Memperbaru waktu',
        'Solution Time' => 'Solusi waktu',
        'Move ticket to a different queue' => 'Pindahkan tiket ke queue yang berbeda',
        'Change queue' => 'Ubah queue',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Membuang filter yang aktif untuk skrin ini',
        'Tickets per page' => 'Tiket per halaman',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Mengulang keseluruhan',
        'Column Filters Form' => 'Kolom formulir filter',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Membagi ke tiket telepon yang baru',
        'Save Chat Into New Phone Ticket' => 'Simpan obrolan ke dalam tiket telepon yang baru',
        'Create New Phone Ticket' => 'Menciptakan telepon tiket yang baru',
        'Please include at least one customer for the ticket.' => 'Tolong sertakan minimal satu pelanggan untuk tiket',
        'To queue' => 'Untuk queue',
        'Chat protocol' => 'Protokol obrolan',
        'The chat will be appended as a separate article.' => 'Obroloan akan ditambahkan sebagain artikel yang terpisah',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Panggilan telepon untuk %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'Menampilkan plain teks email untuk %s%s%s',
        'Plain' => 'Sederhana',
        'Download this email' => 'Memuat turun email ini',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Membuat proses tiket yang baru',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Daftarkan tiket ke sebuah proses',

        # Template: AgentTicketSearch
        'Profile link' => 'Menghubungkan profil',
        'Output' => 'Pengeluaran',
        'Fulltext' => 'Teks penuh',
        'Customer ID (complex search)' => '',
        '(e. g. 234*)' => '',
        'Customer ID (exact match)' => '',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'Telah dibuat didalam queue',
        'Lock state' => 'Kunci pilihan',
        'Watcher' => 'Pengintai',
        'Article Create Time (before/after)' => 'Waktu mencipta artikel (sebelum/sesudah)',
        'Article Create Time (between)' => 'Waktu mencipta artikel (diantara)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'Waktu mencipta tiket (sebelum/sesudah)',
        'Ticket Create Time (between)' => 'Waktu mencipta tiket (diantara)',
        'Ticket Change Time (before/after)' => 'Waktu mengubah tiket (sebelum/sesudah)',
        'Ticket Change Time (between)' => 'Waktu mengubah tiket (di antara)',
        'Ticket Last Change Time (before/after)' => 'Waktu terakhir mengubah tiket (sebelum/sesudah)',
        'Ticket Last Change Time (between)' => 'Waktu terakhir mengubah tiket (diantara)',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Waktu tutup tiket (sebelum/sesudah)',
        'Ticket Close Time (between)' => 'Waktu tutup tiket (di antara)',
        'Ticket Escalation Time (before/after)' => 'Waktu eskalasi tiket (sebelum/sesudah)',
        'Ticket Escalation Time (between)' => 'Waktu eskalasi tiket (di antara)',
        'Archive Search' => 'Pencarian arsip',

        # Template: AgentTicketZoom
        'Sender Type' => 'Jenis pengirim',
        'Save filter settings as default' => 'Simpan aturan filter sebagai default',
        'Event Type' => 'Jenis event',
        'Save as default' => 'Simpan sebagai default',
        'Drafts' => '',
        'by' => 'Oleh',
        'Change Queue' => 'Ubah queue',
        'There are no dialogs available at this point in the process.' =>
            'Tidak ada dialog yang terseedia di dalam proses ',
        'This item has no articles yet.' => 'Item ini belum mempunyai artikel',
        'Ticket Timeline View' => 'Melihat waktu tiket',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => '',
        'Add Filter' => 'Tambahkan filter',
        'Set' => 'Aturan',
        'Reset Filter' => 'Mengulang filter',
        'No.' => 'Tidak.',
        'Unread articles' => 'Artikel tidak terbaca',
        'Via' => '',
        'Important' => 'Penting',
        'Unread Article!' => 'Artikel belum dibaca!',
        'Incoming message' => 'Pesan yang masuk',
        'Outgoing message' => 'Pesan yang keluar',
        'Internal message' => 'Pesan yang internal',
        'Sending of this message has failed.' => '',
        'Resize' => 'Mengubah ukuran',
        'Mark this article as read' => 'Tandakan artikel ini sebagai telah dibaca',
        'Show Full Text' => 'Tampikan teks penuh',
        'Full Article Text' => 'Teks artikel penuh',
        'No more events found. Please try changing the filter settings.' =>
            'Tidak ada event ditemukan lagi. Silahkan coba ubah pengaturan filter',

        # Template: Chat
        '#%s' => '',
        'via %s' => '',
        'by %s' => '',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Untuk membuka link dalam artikel berikut, Anda mungkin perlu menekan Ctrl atau Cmd atau Shift sambil mengklik link (tergantung pada browser Anda dan OS).',
        'Close this message' => 'Tutup pesan ini',
        'Image' => '',
        'PDF' => '',
        'Unknown' => 'Tidak diketahui',
        'View' => 'Lihat',

        # Template: LinkTable
        'Linked Objects' => 'Menghubungkan obyek',

        # Template: TicketInformation
        'Archive' => 'Arsip',
        'This ticket is archived.' => 'Tiket ini diarsipkan',
        'Note: Type is invalid!' => 'Pemberitahuan: Tiket tidak sah!',
        'Pending till' => 'Ditunda hingga',
        'Locked' => 'Dikunci',
        '%s Ticket(s)' => '',
        'Accounted time' => 'Waktu dicatat',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'This feature is part of the %s. Please contact us at %s for an upgrade.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Untuk melindungi privasi Anda, konten jauh diblokir.',
        'Load blocked content.' => 'Beban diblokir konten.',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '',
        'You can' => 'Anda bisa',
        'go back to the previous page' => 'Kembali ke halaman sebelumnya',

        # Template: CustomerAccept
        'Dear Customer,' => '',
        'thank you for using our services.' => '',
        'Yes, I accept your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            '',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            '',
        'Select a customer ID to assign to this ticket.' => '',
        'From all Customer IDs' => '',
        'From assigned Customer IDs' => '',

        # Template: CustomerError
        'An Error Occurred' => 'Terjadi kesalahan',
        'Error Details' => 'Rincian eror',
        'Traceback' => 'Melacak kembali',

        # Template: CustomerFooter
        '%s powered by %s™' => '',
        'Powered by %s™' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript tidak tersedia',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'Peringatan browser',
        'The browser you are using is too old.' => 'Browser yang anda gunakan terlalu lama',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'Tolong lihat dokumentasi atau tanyakan kepada admin anda untuk informasi selanjutnya',
        'One moment please, you are being redirected...' => 'Tunggu sebentar, anda sedang diarahkan...',
        'Login' => 'Masukkan',
        'User name' => 'Nama pengguna',
        'Your user name' => 'Nama pengguna anda',
        'Your password' => 'Kata sandi anda',
        'Forgot password?' => 'Lupa kata sandi?',
        '2 Factor Token' => '2 faktor bukti',
        'Your 2 Factor Token' => '2 faktor bukti anda',
        'Log In' => 'Masukkan',
        'Not yet registered?' => 'Belum terdaftar?',
        'Back' => 'Kembali',
        'Request New Password' => 'Meminta kata sandi baru',
        'Your User Name' => 'Nama pengguna anda',
        'A new password will be sent to your email address.' => 'Kata sandi baru anda akan dihantar ke email anda',
        'Create Account' => 'Menciptakan akun',
        'Please fill out this form to receive login credentials.' => 'Silahkan isi formulir ini untuk menerima surat kepercayaan',
        'How we should address you' => 'Bagaimana kami mengalamatkan anda',
        'Your First Name' => 'Nama pertama anda',
        'Your Last Name' => 'Nama akhir anda',
        'Your email address (this will become your username)' => 'Alamat email anda (ini akan menjadi nama anda sebagai pengguna)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => 'Permintaan obrolan masuk',
        'Edit personal preferences' => 'Ubah preferensi pribadi',
        'Logout %s' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Persetujuan tingkat layanan',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Selamat datang!',
        'Please click the button below to create your first ticket.' => 'Silahkan tekan tombol dibawah untuk membuat tiket pertama anda.',
        'Create your first ticket' => 'Membuat tiket pertama anda',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'Contoh : 10*5155 atau 105658*',
        'CustomerID' => 'ID Pelanggan',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'Jenis',
        'Time Restrictions' => '',
        'No time settings' => 'Tidak ada pengaturan waktu',
        'All' => 'Semua',
        'Specific date' => 'Tanggal spesifik',
        'Only tickets created' => 'Hanya tiket dibuat',
        'Date range' => 'Rentang tanggal',
        'Only tickets created between' => 'Hanya tiket yang dibuat diantara',
        'Ticket Archive System' => '',
        'Save Search as Template?' => '',
        'Save as Template?' => 'Simpan sebagai template',
        'Save as Template' => 'Simpan sebagai template',
        'Template Name' => 'Nama template',
        'Pick a profile name' => 'Memilih nama profil',
        'Output to' => 'Keluarkan',

        # Template: CustomerTicketSearchResultShort
        'of' => 'dari',
        'Page' => 'Halaman',
        'Search Results for' => 'Hasil pencarian untuk',
        'Remove this Search Term.' => 'Hilangkan istilah pencarian',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'Mulai obrolan dari tiket ini',
        'Next Steps' => 'Langkah selanjutnya',
        'Reply' => 'Balas',

        # Template: Chat
        'Expand article' => 'Memperluas artikel',

        # Template: CustomerWarning
        'Warning' => 'Peringatan',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Informasi acara',
        'Ticket fields' => 'Dasar tiket',

        # Template: Error
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            'Benar-benar bug? 5 dari 10 laporan bug hasil dari instalasi yang salah atau tidak lengkap dari OTRS.',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            'Dengan %s, para ahli kami mengurus instalasi yang benar dan menutupi punggung dengan dukungan dan update keamanan secara berkala. ',
        'Contact our service team now.' => 'Hubungi tim layanan kami sekarang.',
        'Send a bugreport' => 'Hantar laporan kesalahan',
        'Expand' => 'Perluas',

        # Template: AttachmentList
        'Click to delete this attachment.' => '',

        # Template: DraftButtons
        'Update draft' => '',
        'Save as new draft' => '',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => '',
        'You have loaded the draft "%s". You last changed it %s.' => '',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            '',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            '',

        # Template: Header
        'View notifications' => 'Lihat pemberitahuan',
        'Notifications' => '',
        'Notifications (OTRS Business Solution™)' => '',
        'Personal preferences' => '',
        'Logout' => 'logout',
        'You are logged in as' => 'Anda telah masuk sebagai',

        # Template: Installer
        'JavaScript not available' => 'JavaScript tidak tersedia',
        'Step %s' => 'Langkah %s',
        'License' => 'Lisensi',
        'Database Settings' => 'Pengaturan database',
        'General Specifications and Mail Settings' => 'Spesifikasi umum dan Pengaturan Surat',
        'Finish' => 'Selesei',
        'Welcome to %s' => 'Selamat datang di %s',
        'Germany' => '',
        'Phone' => 'Telepon',
        'United States' => '',
        'Mexico' => '',
        'Hungary' => '',
        'Brazil' => '',
        'Singapore' => '',
        'Hong Kong' => '',
        'Web site' => 'Website',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Mengkonfigurasi surat outbound',
        'Outbound mail type' => 'Jenis surat outbound',
        'Select outbound mail type.' => 'Pilih jenis surat outbound',
        'Outbound mail port' => 'Port pengeluaran surat',
        'Select outbound mail port.' => 'Pilih port pengeluaran surat',
        'SMTP host' => 'host SMTP',
        'SMTP host.' => 'host SMTP',
        'SMTP authentication' => 'Otentikasi SMTP',
        'Does your SMTP host need authentication?' => 'Apakah host SMTP memerlukan otentitasi?',
        'SMTP auth user' => 'Pengguna SMTP',
        'Username for SMTP auth.' => 'Nama pengguna untuk SMTP',
        'SMTP auth password' => 'Kata sandi SMTP',
        'Password for SMTP auth.' => 'Kata sandi untuk SMTP',
        'Configure Inbound Mail' => 'Konfigurasi surat keluar',
        'Inbound mail type' => 'Jenis surat yang masuk',
        'Select inbound mail type.' => 'Pilih jenis surat yang masuk',
        'Inbound mail host' => 'Host surat masuk',
        'Inbound mail host.' => 'host surat masuk',
        'Inbound mail user' => 'Pengguna surat masuk',
        'User for inbound mail.' => 'Pengguna untuk surat yang masuk',
        'Inbound mail password' => 'Kata sandi untuk surat yang masuk',
        'Password for inbound mail.' => 'Kata sandi untuk surat yang masuk',
        'Result of mail configuration check' => 'Hasil dari pengintaian konfigurasi surat',
        'Check mail configuration' => 'Pengecekan konfigurasi surat',
        'Skip this step' => 'Lewatkan langkah ini',

        # Template: InstallerDBResult
        'Done' => 'Selesai',
        'Error' => 'Error',
        'Database setup successful!' => 'Berhasil menyediakan database!',

        # Template: InstallerDBStart
        'Install Type' => 'Jenis instal',
        'Create a new database for OTRS' => 'Membuat database baru untuk OTRS',
        'Use an existing database for OTRS' => 'Menggunakan database yang ada untuk OTRS',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Jika anda telah menetapkan kata sandi root pada database anda, anda harus memasukan kata sandi tersebut disini. Jika tidak, biarkan bidang ini kosong.',
        'Database name' => 'Nama database',
        'Check database settings' => 'Ubah pengaturan databse',
        'Result of database check' => 'Hasil dari pemeriksaan database',
        'Database check successful.' => 'Database berhasil diperiksa',
        'Database User' => 'Pengguna database',
        'New' => 'Baru',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Pengguna database baru dengan hak akses yang terbatas akan dibuat untuk sistem OTRS ini.',
        'Repeat Password' => 'Ulang kata sandi',
        'Generated password' => 'Mengeluarkan kata sandi',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Kata sandi tidak sesuai',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Port',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Untuk menggunakan OTRS, anda perlu memasukkan command line berikut (Terminal/Shell) sebagai root',
        'Restart your webserver' => 'Mengulang kembali webserver anda',
        'After doing so your OTRS is up and running.' => 'Setelah itu OTRS anda akan berjalan',
        'Start page' => 'Memulai halaman',
        'Your OTRS Team' => 'Tim OTRS anda',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Dilarang menerima lisensi',
        'Accept license and continue' => 'Menerima lisensi dan melanjutkannya',

        # Template: InstallerSystem
        'SystemID' => 'Sistem ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Pengenal dari sistem. Setiap nomor tiket dan setiap ID sesi HTTP berisi nomor ini.',
        'System FQDN' => 'Sistem FQDN',
        'Fully qualified domain name of your system.' => 'Nama domain berkualifikasi lengkap dari sistem anda.',
        'AdminEmail' => 'AdminEmail',
        'Email address of the system administrator.' => 'Alamat email dari sistem administrator',
        'Organization' => 'Organisasi',
        'Log' => 'Logaritma',
        'LogModule' => 'Modul log',
        'Log backend to use.' => 'Logaritma backend digunakan',
        'LogFile' => 'LogFile',
        'Webfrontend' => 'WebFronted',
        'Default language' => 'Bahasa default',
        'Default language.' => 'Bahasa default',
        'CheckMXRecord' => 'Periksa MX Record',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'alamat email yang dimasukkan secara manual diperiksa terhadap catatan MX yang ditemukan di DNS. Jangan gunakan opsi ini jika DNS Anda lambat atau tidak menyelesaikan alamat publik.',

        # Template: LinkObject
        'Delete link' => '',
        'Delete Link' => '',
        'Object#' => 'Objek#',
        'Add links' => 'Tambahkan penghubung',
        'Delete links' => 'Hapus penghubung',

        # Template: Login
        'Lost your password?' => 'Kehilangan kata sandi anda?',
        'Back to login' => 'Kembali ke dalam login',

        # Template: MetaFloater
        'Scale preview content' => 'konten skala pratinjau ',
        'Open URL in new tab' => 'Buka URL di tab baru',
        'Close preview' => 'Tutup tinjauan',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'Sebuah preview dari situs ini tidak dapat diberikan karena tidak memungkinkan untuk dimasukkan.',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => '',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Maaf, fitur OTRS saat ini tidak tersedia untuk perangkat mobile. Jika Anda ingin menggunakannya, anda dapat beralih ke mode desktop atau menggunakan perangkat desktop biasa anda.',

        # Template: Motd
        'Message of the Day' => 'Pesanan',
        'This is the message of the day. You can edit this in %s.' => 'Ini adalah pesan hari. Anda dapat mengedit ini di %s',

        # Template: NoPermission
        'Insufficient Rights' => 'Hak cukup',
        'Back to the previous page' => 'Kembali ke halaman sebelumnya',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'Dipersembahkan oleh',

        # Template: Pagination
        'Show first page' => 'Tampilkan halaman pertama',
        'Show previous pages' => 'Tampilkan halaman sebelumnya',
        'Show page %s' => 'Tampilkan halaman %s',
        'Show next pages' => 'Tampilkan halaman berikutnya',
        'Show last page' => 'Tampilkan halaman terakhir',

        # Template: PictureUpload
        'Need FormID!' => 'FormID diperlukan!',
        'No file found!' => 'Tidak ada file ditemukan!',
        'The file is not an image that can be shown inline!' => 'File tidak memiliki gambar untuk ditampilkan',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'Tidak ada pemberitahuan dapat dikonfigurasi pengguna ditemukan.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Menerima pesan pemberitahuan \'%s\' dengan metode transportasi \'%s\'.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Proses informasi',
        'Dialog' => 'Dialog',

        # Template: Article
        'Inform Agent' => 'Menginformasikan agen',

        # Template: PublicDefault
        'Welcome' => 'Selamat datang',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            'Ini adalah antarmuka publik default OTRS! Tidak ada parameter tindakan yang diberikan.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'Anda bisa menginstal modul kustom publik (melalui manajer paket), misalnya FAQ modul, yang memiliki antarmuka publik.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Izin',
        'You can select one or more groups to define access for different agents.' =>
            'Anda dapat memilih satu atau lebih kelompok untuk menentukan akses bagi agen yang berbeda.',
        'Result formats' => 'Hasil format',
        'Time Zone' => 'Zona waktu',
        'The selected time periods in the statistic are time zone neutral.' =>
            'Periode waktu yang dipilih dalam statistik adalah zona waktu yang netral.',
        'Create summation row' => 'Buat baris penjumlahan',
        'Generate an additional row containing sums for all data rows.' =>
            'Menghasilkan baris yang mengandung jumlah untuk semua baris data.',
        'Create summation column' => 'Mencipta kolom penjumlahan',
        'Generate an additional column containing sums for all data columns.' =>
            'Menghasilkan kolom yang berisi tambahan jumlah untuk semua kolom data.',
        'Cache results' => 'Hasil cache',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Menyediakan statistik sebagai widget bahwa agen dapat mengaktifkan di dashboard mereka.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Perlu diamati bahwa menyalakan widget dashboard akan mengaktifkan caching untuk statistik ini di dashboard.',
        'If set to invalid end users can not generate the stat.' => 'Jika diatur ke pengguna akhir yang tidak sah maka tidak dapat menghasilkan stat.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Tidak ada masalah dalam mengkonfigurasi statistik ini',
        'You may now configure the X-axis of your statistic.' => 'Anda bisa konfigur X-axls sekarang dari statistic anda',
        'This statistic does not provide preview data.' => 'Statistik ini tidak menyediakan data peninjauan',
        'Preview format' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Perlu diingat bahwa menggunakan peninjauan data yang diacak dan tidak mempertimbangkan filter',
        'Configure X-Axis' => 'Mengkonfigurasi X-Axls',
        'X-axis' => 'X-axls',
        'Configure Y-Axis' => 'Mengkonfigurasi Y-Axls',
        'Y-axis' => 'Y-axls',
        'Configure Filter' => 'Mengkonfigurasi filter',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Silakan pilih satu elemen atau mematikan tombol \'Tetap\'.',
        'Absolute period' => 'Periode mutlak',
        'Between %s and %s' => '',
        'Relative period' => 'Periode yang relatif',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '%s selesai masa lalu dan saat ini + mendatang lengkap %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Dilarang merubah elemen ini ketika setatistik dihasilkan',

        # Template: StatsParamsWidget
        'Format' => 'Format',
        'Exchange Axis' => 'Pertukaran Axls',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => 'Tidak ada unsur yang dipilih',
        'Scale' => 'Skala',
        'show more' => 'Tampilkan lagi',
        'show less' => 'Tampilkan sekali saja',

        # Template: D3
        'Download SVG' => 'Memuat turun SVG',
        'Download PNG' => 'Memuat turun PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'jangka waktu yang dipilih mendefinisikan default kerangka waktu untuk mengumpulkan statistik data',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Mendefinisikan satuan waktu yang akan digunakan untuk membagi jangka waktu yang dipilih dalam pelaporan titik data.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Harap diingat bahwa skala untuk Y-sumbu harus lebih besar dari skala untuk X-axis (i.s. X-axis => Bulan, Y-Axis => Tahun).',

        # Template: SettingsList
        'This setting is disabled.' => '',
        'This setting is fixed but not deployed yet!' => '',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '',
        'Toggle advanced options for this setting' => '',
        'Disable this setting, so it is no longer effective' => '',
        'Disable' => '',
        'Enable this setting, so it becomes effective' => '',
        'Enable' => '',
        'Reset this setting to its default state' => '',
        'Reset setting' => '',
        'Allow users to adapt this setting from within their personal preferences' =>
            '',
        'Allow users to update' => '',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            '',
        'Forbid users to update' => '',
        'Show user specific changes for this setting' => '',
        'Show user settings' => '',
        'Copy a direct link to this setting to your clipboard' => '',
        'Copy direct link' => '',
        'Remove this setting from your favorites setting' => '',
        'Remove from favourites' => '',
        'Add this setting to your favorites' => '',
        'Add to favourites' => '',
        'Cancel editing this setting' => '',
        'Save changes on this setting' => '',
        'Edit this setting' => '',
        'Enable this setting' => '',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '',

        # Template: SettingsListCompare
        'Now' => '',
        'User modification' => '',
        'enabled' => '',
        'disabled' => '',
        'Setting state' => '',

        # Template: Actions
        'Edit search' => '',
        'Go back to admin: ' => '',
        'Deployment' => '',
        'My favourite settings' => '',
        'Invalid settings' => '',

        # Template: DynamicActions
        'Filter visible settings...' => '',
        'Enable edit mode for all settings' => '',
        'Save all edited settings' => '',
        'Cancel editing for all settings' => '',
        'All actions from this widget apply to the visible settings on the right only.' =>
            '',

        # Template: Help
        'Currently edited by me.' => '',
        'Modified but not yet deployed.' => '',
        'Currently edited by another user.' => '',
        'Different from its default value.' => '',
        'Save current setting.' => '',
        'Cancel editing current setting.' => '',

        # Template: Navigation
        'Navigation' => '',

        # Template: OTRSBusinessTeaser
        'With %s, System Configuration supports versioning, rollback and user-specific configuration settings.' =>
            '',

        # Template: Test
        'OTRS Test Page' => 'Halaman uji OTRS',
        'Unlock' => 'Buka kunci',
        'Welcome %s %s' => 'Selamat datang %s %s',
        'Counter' => 'Konter',

        # Template: Warning
        'Go back to the previous page' => 'Kembali ke halaman sebelumnya',

        # JS Template: CalendarSettingsDialog
        'Show' => '',

        # JS Template: FormDraftAddDialog
        'Draft title' => '',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '',
        'Confirm' => 'Pastikan',

        # JS Template: WidgetLoading
        'Loading, please wait...' => '',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => '',
        'Click to select files or just drop them here.' => '',
        'Click to select a file or just drop it here.' => '',
        'Uploading...' => '',

        # JS Template: InformationDialog
        'Process state' => '',
        'Running' => '',
        'Finished' => 'Selesai',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => 'Tambahkan entri baru',

        # JS Template: AddHashKey
        'Add key' => '',

        # JS Template: DialogDeployment
        'Deployment comment...' => '',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => '',
        'Preparing to deploy, please wait...' => '',
        'Deploy now' => '',
        'Try again' => '',

        # JS Template: DialogReset
        'Reset options' => '',
        'Reset setting on global level.' => '',
        'Reset globally' => '',
        'Remove all user changes.' => '',
        'Reset locally' => '',
        'user(s) have modified this setting.' => '',
        'Do you really want to reset this setting to it\'s default value?' =>
            '',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            '',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '',
        'CustomerIDs' => 'ID Pelanggan',
        'Fax' => 'Fax',
        'Street' => 'Jalan',
        'Zip' => 'Zip',
        'City' => 'Kota',
        'Country' => 'Negara',
        'Valid' => 'Valid',
        'Mr.' => 'Tuan.',
        'Mrs.' => 'Nyonya.',
        'Address' => 'Alamat',
        'View system log messages.' => 'Melihat pesan log sistem.',
        'Edit the system configuration settings.' => 'Ubah pengaturan konfigurasi sistem.',
        'Update and extend your system with software packages.' => 'Memperbarui dan memperluas sistem Anda dengan paket perangkat lunak.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'Informasi ACL dari database tidak sinkron dengan konfigurasi sistem, tolong sebarkan semua ACL.',
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'ACL tidak dapat diimpor karena kesalahan yang tidak diketahui, silahkan cek OTRS log untuk informasi lebih lanjut',
        'The following ACLs have been added successfully: %s' => 'ACLs berikutnya telah berhasil ditambah: %s',
        'The following ACLs have been updated successfully: %s' => 'The ACLs berikutnya telah berhasil diperbarui: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Ada kesalahan menambahkan / memperbarui ACL berikut:%s. Silakan periksa file log untuk informasi lebih lanjut.',
        'This field is required' => 'Bagian ini diperlukan',
        'There was an error creating the ACL' => 'Terjadi kesalahan saat membuat ACL',
        'Need ACLID!' => 'Memerlukan ACLID!',
        'Could not get data for ACLID %s' => 'Tidak bisa mendapatkan data ACLID %s',
        'There was an error updating the ACL' => 'Terjadi kesalahan saat pembaruan ACL',
        'There was an error setting the entity sync status.' => 'Terjadi kesalahan pengaturan status sync',
        'There was an error synchronizing the ACLs.' => 'Terjadi kesalahan saat menyamakan ACL',
        'ACL %s could not be deleted' => 'ACL %s tidak bisa dihapus',
        'There was an error getting data for ACL with ID %s' => 'Terjadi kesalahan saat mendapatkan data untuk ACL dengan ID %s',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '',
        'Exact match' => 'Benar-benar cocok',
        'Negated exact match' => 'pencocokan secara tepat',
        'Regular expression' => 'ekspresi reguler',
        'Regular expression (ignore case)' => 'ekspresi reguler (ignorecase)',
        'Negated regular expression' => 'Meniadakan ekspresi reguler',
        'Negated regular expression (ignore case)' => 'Meniadakan ekspresi reguler (ignorecase)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => '',
        'Please contact the administrator.' => 'Silahkan hubungi administrator.',
        'No CalendarID!' => '',
        'You have no access to this calendar!' => '',
        'Error updating the calendar!' => '',
        'Couldn\'t read calendar configuration file.' => '',
        'Please make sure your file is valid.' => '',
        'Could not import the calendar!' => '',
        'Calendar imported!' => '',
        'Need CalendarID!' => '',
        'Could not retrieve data for given CalendarID' => '',
        'Successfully imported %s appointment(s) to calendar %s.' => '',
        '+5 minutes' => '',
        '+15 minutes' => '',
        '+30 minutes' => '',
        '+1 hour' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => '',
        'System was unable to import file!' => '',
        'Please check the log for more information.' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => '',
        'Notification added!' => 'Pemberitahuan ditambahkan!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Ada kesalahan mendapatkan data untuk Pemberitahuan dengan ID:%s!',
        'Unknown Notification %s!' => 'Diketahui Pemberitahuan %s!',
        '%s (copy)' => '',
        'There was an error creating the Notification' => 'Ada kesalahan saat membuat Pemberitahuan tersebut',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'Pemberitahuan tidak dapat diimpor karena kesalahan yang tidak diketahui, silahkan cek OTRS log untuk informasi lebih lanjut',
        'The following Notifications have been added successfully: %s' =>
            'Pemberitahuan berikut telah berhasil ditambahkan: %s',
        'The following Notifications have been updated successfully: %s' =>
            'Pemberitahuan berikut telah diperbarui berhasil: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Terjadi kesalahan pada tambah/update di notifikasi berikut : %s. Tolong periksa log file untuk informasi lebih lanjut',
        'Notification updated!' => 'Pemberitahuan diperbarui!',
        'Agent (resources), who are selected within the appointment' => '',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '',
        'All agents with write permission for the appointment (calendar)' =>
            '',
        'Yes, but require at least one active notification method.' => '',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Lampiran telah ditambahkan!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '',
        'All communications' => '',
        'Last 1 hour' => '',
        'Last 3 hours' => '',
        'Last 6 hours' => '',
        'Last 12 hours' => '',
        'Last 24 hours' => '',
        'Last week' => '',
        'Last month' => '',
        'Invalid StartTime: %s!' => '',
        'Successful' => '',
        'Processing' => '',
        'Failed' => 'Gagal',
        'Invalid Filter: %s!' => 'Filter tidak sah: %s!',
        'Less than a second' => '',
        'sorted descending' => 'Urutan turun',
        'sorted ascending' => 'Urutan naik',
        'Trace' => '',
        'Debug' => 'Debug',
        'Info' => 'Info',
        'Warn' => '',
        'days' => 'hari',
        'day' => 'hari',
        'hour' => 'jam',
        'minute' => 'menit',
        'seconds' => 'detik',
        'second' => 'detik',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => 'Perusahaan telah diperbarui!',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => 'Pelanggan perusahaan %s sudah ada!',
        'Customer company added!' => 'Perusahaan pelanggan telah ditambahkan!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Pelanggan telah ditambahkan!',
        'New phone ticket' => 'Tiket telepon baru',
        'New email ticket' => 'Tiket email baru',
        'Customer %s added' => 'Pelanggan %s telah ditambahkan',
        'Customer user updated!' => '',
        'Same Customer' => '',
        'Direct' => '',
        'Indirect' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '',
        'Change Group Relations for Customer User' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => '',
        'Allocate Services to Customer User' => '',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Konfigurasi field tidak sah',
        'Objects configuration is not valid' => 'Konfigurasi objek tidak sah',
        'Database (%s)' => '',
        'Web service (%s)' => '',
        'Contact with data (%s)' => '',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Tidak dapat mengulang pesan dinamis field secara baik, silahkan cek error log untuk lebih jelasnya.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Subaksi tidak terdefinisi',
        'Need %s' => 'Perlu %s',
        'Add %s field' => '',
        'The field does not contain only ASCII letters and numbers.' => 'Field ini tidak hanya berisi huruf ASCII dan angka ',
        'There is another field with the same name.' => 'Ada field yang lain dengan nama yang sama',
        'The field must be numeric.' => 'Field harus numerik',
        'Need ValidID' => 'Membutuhkan ValidID',
        'Could not create the new field' => 'Tidak dapat membuat bidang yang baru',
        'Need ID' => 'Membutuhkan ID',
        'Could not get data for dynamic field %s' => 'Tidak ada data untuk field yang dinamis %s',
        'Change %s field' => '',
        'The name for this field should not change.' => 'Nama untuk field ini tidak dapat diubah',
        'Could not update the field %s' => 'Tidak dapat memperbarui field %s',
        'Currently' => 'Saat ini',
        'Unchecked' => 'Tidak dicentang',
        'Checked' => 'dicentang',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Mencegah masuknya tanggal di masa depan',
        'Prevent entry of dates in the past' => 'Mencegah masuknya tanggal di masa lalu',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => 'Field ini diduplikasi',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Pilih minimal satu penerima',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'menit',
        'hour(s)' => 'jam',
        'Time unit' => 'Unit waktu',
        'within the last ...' => 'dalam ... terakhir',
        'within the next ...' => 'dalam ... selanjutnya',
        'more than ... ago' => 'lebih dari ... yang lalu',
        'Unarchived tickets' => 'Tiket yang tidak diarsipkan',
        'archive tickets' => 'tiket arsip',
        'restore tickets from archive' => 'mengembalikan tiket dari arsip',
        'Need Profile!' => 'Butuh Profil!',
        'Got no values to check.' => 'Tidak ada value untuk di cek',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Harap hapus kata-kata berikut karena mereka tidak dapat digunakan untuk seleksi tiket:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'Membutuhkan ID Webservice!',
        'Could not get data for WebserviceID %s' => 'Tidak ada data untuk IDWebservice %s',
        'ascending' => 'Menaik',
        'descending' => 'Menurun',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => '',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            '',
        'Invalid Subaction!' => '',
        'Need ErrorHandlingType!' => '',
        'ErrorHandlingType %s is not registered' => '',
        'Could not update web service' => '',
        'Need ErrorHandling' => '',
        'Could not determine config for error handler %s' => '',
        'Invoker processing outgoing request data' => '',
        'Mapping outgoing request data' => '',
        'Transport processing request into response' => '',
        'Mapping incoming response data' => '',
        'Invoker processing incoming response data' => '',
        'Transport receiving incoming request data' => '',
        'Mapping incoming request data' => '',
        'Operation processing incoming request data' => '',
        'Mapping outgoing response data' => '',
        'Transport sending outgoing response data' => '',
        'skip same backend modules only' => '',
        'skip all modules' => '',
        'Operation deleted' => '',
        'Invoker deleted' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '',
        '15 seconds' => '',
        '30 seconds' => '',
        '45 seconds' => '',
        '1 minute' => '',
        '2 minutes' => '',
        '3 minutes' => '',
        '4 minutes' => '',
        '5 minutes' => '',
        '10 minutes' => '10 menit',
        '15 minutes' => '15 menit',
        '30 minutes' => '',
        '1 hour' => '',
        '2 hours' => '',
        '3 hours' => '',
        '4 hours' => '',
        '5 hours' => '',
        '6 hours' => '',
        '12 hours' => '',
        '18 hours' => '',
        '1 day' => '',
        '2 days' => '',
        '3 days' => '',
        '4 days' => '',
        '6 days' => '',
        '1 week' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'tidak dapat menentukan konfigurasi untuk Invoker %s',
        'InvokerType %s is not registered' => 'Invoker jenis %s tidak terdaftar',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '',
        'Need Event!' => '',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => 'Tidak bisa memperbarui data konfigurasi untuk layanan Web',
        'This sub-action is not valid' => '',
        'xor' => 'xor',
        'String' => 'Tali',
        'Regexp' => '',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => 'Tidak bisa mendapatkan konfigurasi terdaftar untuk jenis tindakan %s',
        'Could not get backend for %s %s' => 'Tidak bisa mendapatkan backend untuk %s %s',
        'Keep (leave unchanged)' => 'Jauhkan (tinggalkan yang tidak diubah)',
        'Ignore (drop key/value pair)' => 'Abaikan (key drop/nilai pasangan)',
        'Map to (use provided value as default)' => 'Peta ke (digunakan untuk memberikan nilai sebagai default)',
        'Exact value(s)' => 'nilai(s) yang tepat',
        'Ignore (drop Value/value pair)' => 'Abaikan (drop Nilai/nilai pair)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => 'Tidak dapat menemukan perpustakaan yang diperlukan %s',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            '',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            '',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            '',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            '',
        'Incoming request data before mapping (ProviderRequestInput)' => '',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            '',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => 'Tidak dapat menentukan konfigurasi untuk operasi %s',
        'OperationType %s is not registered' => 'OperationType%s tidak terdaftar',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '',
        'This field should be an integer.' => '',
        'File or Directory not found.' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Ada layanan web lain dengan nama yang sama',
        'There was an error updating the web service.' => 'Terjadi kesalahan dalam memperbarui layanan web.',
        'There was an error creating the web service.' => 'Ada kesalahan saat membuat layanan web.',
        'Web service "%s" created!' => 'layanan web "dibuat!',
        'Need Name!' => 'Butuh Nama!',
        'Need ExampleWebService!' => 'Perlu ExampleWebService!',
        'Could not load %s.' => '',
        'Could not read %s!' => 'Tidak dapat dibaca %s!',
        'Need a file to import!' => 'Butuh sebuah file untuk di impor!',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            'file yang diimpor memiliki konten YAML tidak valid! Silakan periksa rincian log OTRS ',
        'Web service "%s" deleted!' => 'layanan web "menghapus!',
        'OTRS as provider' => 'OTRS sebagai penyedia',
        'Operations' => '',
        'OTRS as requester' => 'OTRS sebagai pemohon',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Tidak dapat WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => 'tidak bisa mendapatkan data sejarah untuk layanan Web History ID %s',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Grup telah di perbarui!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Akun surat telah di tambahkan!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'Pengiriman melalui email Kepada: bidang.',
        'Dispatching by selected Queue.' => 'Pengiriman melalui Antrian yang dipilih.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '',
        'Agent who owns the ticket' => 'Agen yang mempunyai tiket',
        'Agent who is responsible for the ticket' => 'Agen yang bertanggung jawab untuk tiket',
        'All agents watching the ticket' => 'Semua agen memantau tiket',
        'All agents with write permission for the ticket' => 'Semua agen dengan izin menulis untuk tiket',
        'All agents subscribed to the ticket\'s queue' => 'Semua agen berlangganan antrian tiket',
        'All agents subscribed to the ticket\'s service' => 'Semua agen berlangganan layanan tiket',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Semua agen berlangganan di antrian tiket dan layanan',
        'Customer user of the ticket' => '',
        'All recipients of the first article' => '',
        'All recipients of the last article' => '',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminOTRSBusiness.pm
        'Your system was successfully upgraded to %s.' => 'Sistem anda telah berhasil di upgrade ke %s.',
        'There was a problem during the upgrade to %s.' => 'Terdapat masalah saat mengupgrade ke %s.',
        '%s was correctly reinstalled.' => '%s telah di instal ulang dengan benar.',
        'There was a problem reinstalling %s.' => 'Terdapat permasalahan saat menginstal ulang %s.',
        'Your %s was successfully updated.' => '%s anda berhasil diperbarui',
        'There was a problem during the upgrade of %s.' => 'Terdapat permasalahan ketika mengupgrade %s',
        '%s was correctly uninstalled.' => '%s berhasil di hapus.',
        'There was a problem uninstalling %s.' => 'Terdapat permasalahan dalam menghapus %s.',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'Lingkungan PGP tidak bekerja. Silakan periksa log untuk info lebih lanjut!',
        'Need param Key to delete!' => 'Membutuhkan kunci param untuk menghapus!',
        'Key %s deleted!' => 'Kunci %s hapus!',
        'Need param Key to download!' => 'Membutuhkan kunci param untuk memuat turun!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            'Maaf, Apache::Reload diperlukan sebagai Perl Modul dan PerlInitHandler di Apache file konfigurasi. Lihat scripts/apache2-httpd.include.conf. Atau, Anda dapat menggunakan alat baris perintah bin/otrs.Console.pl untuk menginstal paket!',
        'No such package!' => 'Tidak ada paket!',
        'No such file %s in package!' => 'Tidak ada file seperti %s dalam paket',
        'No such file %s in local file system!' => 'Tidak ada jenis file %s di dalam file sistem lokal!',
        'Can\'t read %s!' => 'Tidak bisa dibaca %s!',
        'File is OK' => '',
        'Package has locally modified files.' => 'Paket telah diubah secara lokal',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Paket tidak di verifikasi oleh OTRS grup! Tidak di rekomendasikan untuk menggunakan paket ini.',
        'Not Started' => '',
        'Updated' => '',
        'Already up-to-date' => '',
        'Installed' => '',
        'Not correctly deployed' => '',
        'Package updated correctly' => '',
        'Package was already updated' => '',
        'Dependency installed correctly' => '',
        'The package needs to be reinstalled' => '',
        'The package contains cyclic dependencies' => '',
        'Not found in on-line repositories' => '',
        'Required version is higher than available' => '',
        'Dependencies fail to upgrade or install' => '',
        'Package could not be installed' => '',
        'Package could not be upgraded' => '',
        'Repository List' => '',
        'No packages found in selected repository. Please check log for more info!' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            'Paket tidak diverifikasi karena masalah komunikasi dengan server verifikasi!',
        'Can\'t connect to OTRS Feature Add-on list server!' => 'Tidak dapat terhubung ke Fitur OTRS Add-on list server!',
        'Can\'t get OTRS Feature Add-on list from server!' => 'Tidak mendapatkan fitur OTRS yang ditambah sebagai daftar dari server!',
        'Can\'t get OTRS Feature Add-on from server!' => 'tidak bisa mendapatkan Fitur OTRS tambahan dari server!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Tidak ada filter seperti: %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Prioritas ditambahkan!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Informasi manajemen proses dari database tidak sinkron dengan konfigurasi sistem, Silahkan untuk mengsinkronisasikan semua proses.',
        'Need ExampleProcesses!' => 'Perlu contoh proses!',
        'Need ProcessID!' => 'Perlu Proses ID!',
        'Yes (mandatory)' => 'Ya (wajib)',
        'Unknown Process %s!' => 'Proses tidak diketahui %s!',
        'There was an error generating a new EntityID for this Process' =>
            'Terjadi kesalahan menghasilkan ID Entitas baru untuk Proses ini',
        'The StateEntityID for state Inactive does not exists' => 'State ID Entitas bagi negara aktif tidak ada',
        'There was an error creating the Process' => 'Ada kesalahan saat membuat Proses',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'Terjadi kesalahan pengaturan status badan sinkronisasi untuk Proses entitas: %s',
        'Could not get data for ProcessID %s' => 'Tidak dapat data untuk proses ID: %s',
        'There was an error updating the Process' => 'Terjadi kesalahan memperbarui Proses',
        'Process: %s could not be deleted' => 'Proses: %s tidak bisa dihapus',
        'There was an error synchronizing the processes.' => 'Terjadi kesalahan saat proses sinkronisasi',
        'The %s:%s is still in use' => '%s:%s masih bisa digunakan',
        'The %s:%s has a different EntityID' => '%s:%s terdapat entity ID yang berbeda',
        'Could not delete %s:%s' => 'Tidak dapat dihapus %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'Terjadi kesalahan pada pengaturan entity sinkron status untuk %s entity: %s',
        'Could not get %s' => 'Tidak dapat %s',
        'Need %s!' => 'Membutuhkan %s!',
        'Process: %s is not Inactive' => 'Proses: %s tidak aktif',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'Terjadi kesalahan menghasilkan ID Entitas baru untuk Kegiatan ini',
        'There was an error creating the Activity' => 'Ada kesalahan saat membuat Kegiatan',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Terjadi kesalahan pengaturan status sinkronisasi untuk entitas Kegiatan: %s',
        'Need ActivityID!' => 'Membutuhkan ActivityID!',
        'Could not get data for ActivityID %s' => 'Tidak bisa mendapatkan data untuk ActivityID %s',
        'There was an error updating the Activity' => 'Terjadi kesalahan memperbarui Kegiatan',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Parameter telah kehilangan: Aktivitas Kebutuhan dan Kegiatan Dialog!',
        'Activity not found!' => 'Aktivitas tidak ditemukan!',
        'ActivityDialog not found!' => 'Kegiatan Dialog tidak ditemukan!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'Kegiatan Dialog sudah ditugaskan untuk aktivitas. Anda tidak dapat menambahkan Activity Dialog dua kali!',
        'Error while saving the Activity to the database!' => 'Kesalahan saat menyimpan Aktivitas ke database!',
        'This subaction is not valid' => 'Subaction tidak valid',
        'Edit Activity "%s"' => 'Edit aktivitas "%s"',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'Terjadi kesalahan pada entity ID yang baru untuk Aktivitas dialog',
        'There was an error creating the ActivityDialog' => 'Terjadi kesalahan dalam membuat Aktivitas dialog',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'Terjadi kesalahan pengaturan status sinkronisasi untuk entitas Kegiatan Dialog :%s',
        'Need ActivityDialogID!' => 'Perlu ID aktivitas dialog',
        'Could not get data for ActivityDialogID %s' => 'Tidak bisa mendapatkan data untuk dialog Kegiatan',
        'There was an error updating the ActivityDialog' => 'Terjadi kesalahan dalam memperbarui kegiatan dialog',
        'Edit Activity Dialog "%s"' => 'Mensunting kegiatan dialog',
        'Agent Interface' => 'Antarmuka Agen',
        'Customer Interface' => 'Antarmuka pelanggan',
        'Agent and Customer Interface' => 'Antarmuka Agen dan Pelanggan',
        'Do not show Field' => 'Dilarang menampilkan dasar',
        'Show Field' => 'Tampilkan dasar',
        'Show Field As Mandatory' => 'Tampilkan dasar sebai kewajiban',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Edit Path',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'Terjadi kesalahan menghasilkan ID Entitas baru untuk Transisi ini',
        'There was an error creating the Transition' => 'Ada kesalahan saat membuat Transisi',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'Terjadi kesalahan pengaturan status sinkronisasi untuk entitas Transisi: %s',
        'Need TransitionID!' => 'Membutuhkan TansisiID!',
        'Could not get data for TransitionID %s' => 'Tidak bisa mendapatkan data untuk dialihkan %s',
        'There was an error updating the Transition' => 'Terjadi kesalahan disaat memperbarui Transisi',
        'Edit Transition "%s"' => 'Edit transisi "%s"',
        'Transition validation module' => 'Modul transisi valid',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'Setidaknya satu parameter konfigurasi yang valid diperlukan.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'Terjadi kesalahan menghasilkan ID Entitas baru untuk Action Transisi ini',
        'There was an error creating the TransitionAction' => 'Ada kesalahan saat membuat Aksi Transisi',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'Terjadi kesalahan pengaturan status sinkronisasi untuk Transisi Action entitas: %s',
        'Need TransitionActionID!' => 'Membutuhkan TransisiAksiID!',
        'Could not get data for TransitionActionID %s' => 'Tidak bisa mendapatkan data untuk TransitionActionID%s',
        'There was an error updating the TransitionAction' => 'Terjadi kesalahan saat memutakhirkan Action Transisi',
        'Edit Transition Action "%s"' => 'Menyunting tindakan transisi',
        'Error: Not all keys seem to have values or vice versa.' => 'Kesalahan: Tidak semua kunci tampaknya yang memiliki nilai-nilai atau sebaliknya.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'Antrian telah di perbarui!',
        'Don\'t use :: in queue name!' => 'Jangan menggunakan :: di nama queue!',
        'Click back and change it!' => 'Klik kembali dan ubah!',
        '-none-' => '-Tidak ada-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Antrian (tanpa respon auto)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Ubah hubungan Queue menjadi Template',
        'Change Template Relations for Queue' => 'Ubah hubungan template menjadi Queue',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produksi',
        'Test' => '',
        'Training' => 'Latihan',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Peran telah di perbarui!',
        'Role added!' => 'Peran telah ditambahkan!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Hubungan perubahan grup untuk peran',
        'Change Role Relations for Group' => 'Hubungan perubahan Peran untuk Grup',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '',
        'Change Role Relations for Agent' => 'Mengubah hubungan peran untuk agen',
        'Change Agent Relations for Role' => 'Mengubah hubungan agen untuk peran',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Silahkan untuk mengaktifkan %s terlebih dahulu!',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'lingkungan S / MIME tidak bekerja. Silakan periksa log untuk info lebih lanjut!',
        'Need param Filename to delete!' => 'Membutuhkan param Filename untuk menghapus',
        'Need param Filename to download!' => 'Perlu param Nama file untuk men-download!',
        'Needed CertFingerprint and CAFingerprint!' => 'Dibutuhkan Cert Sidik Jari dan CA Fingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'Sebuah Fingerprint harus berbeda dari Cert Fingerprint',
        'Relation exists!' => 'Hubungan ada!',
        'Relation added!' => 'Hubungan ditambah!',
        'Impossible to add relation!' => 'Tidak bisa menambahkan relasi',
        'Relation doesn\'t exists' => 'Hubungan tidak ada',
        'Relation deleted!' => 'Hubungan dihapus',
        'Impossible to delete relation!' => 'Tidak bisa menghapus relasi',
        'Certificate %s could not be read!' => 'Sertifikat %s tidak dapat dibaca!',
        'Needed Fingerprint' => 'Diperlukan sidik jari',
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Salutation ditambah!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Tanda tangan diperbarui!',
        'Signature added!' => 'Tanda tangan ditambahkan!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Kondisi telah ditambahkan!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'File %s tidak dapat dibaca!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'Alamat e-mail sistem telah ditambahkan!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '',
        'There are no invalid settings active at this time.' => '',
        'You currently don\'t have any favourite settings.' => '',
        'The following settings could not be found: %s' => '',
        'Import not allowed!' => 'Impor tidak diperbolehkan!',
        'System Configuration could not be imported due to an unknown error, please check OTRS logs for more information.' =>
            '',
        'Category Search' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTRS log for more information.' =>
            '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => '',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            '',
        'Missing setting name!' => '',
        'Missing ResetOptions!' => '',
        'Setting is locked by another user!' => '',
        'System was not able to lock the setting!' => '',
        'System was not able to reset the setting!' => '',
        'System was unable to update setting!' => '',
        'Missing setting name.' => '',
        'Setting not found.' => '',
        'Missing Settings!' => '',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => 'Tanggal mulai tidak boleh didefinisikan setelah tanggal Berhenti!',
        'There was an error creating the System Maintenance' => 'Ada kesalahan saat membuat Pemeliharaan Sistem',
        'Need SystemMaintenanceID!' => 'Butuh Pemeliharaan Sistem ID!',
        'Could not get data for SystemMaintenanceID %s' => 'Tidak bisa mendapatkan data untuk Pemeliharaan Sistem %s',
        'System Maintenance was added successfully!' => '',
        'System Maintenance was updated successfully!' => '',
        'Session has been killed!' => 'Sesi telah dihapus!',
        'All sessions have been killed, except for your own.' => 'Semua sesi telah dihapus, kecuali sesi anda.',
        'There was an error updating the System Maintenance' => 'Terjadi kesalahan saat memperbarukan Pemeliharaan Sistem',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Itu tidak mungkin untuk menghapus entri Pemeliharaan Sistem :%s!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Template diperbarui!',
        'Template added!' => 'Template ditambah!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Ubah lampiran hubungan untuk template',
        'Change Template Relations for Attachment' => 'Ubah template relations untuk lampiran',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Perlu diketik!',
        'Type added!' => 'Tipe telah ditambahkan!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Agen di perbarui!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Ubah hubungan grup ke agen',
        'Change Agent Relations for Group' => 'Ubah hubungan agen ke grup',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Bulan',
        'Week' => '',
        'Day' => 'Hari',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => '',
        'Appointments assigned to me' => '',
        'Showing only appointments assigned to you! Change settings' => '',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => '',
        'Never' => '',
        'Every Day' => '',
        'Every Week' => '',
        'Every Month' => '',
        'Every Year' => '',
        'Custom' => '',
        'Daily' => '',
        'Weekly' => '',
        'Monthly' => '',
        'Yearly' => '',
        'every' => '',
        'for %s time(s)' => '',
        'until ...' => '',
        'for ... time(s)' => '',
        'until %s' => '',
        'No notification' => '',
        '%s minute(s) before' => '',
        '%s hour(s) before' => '',
        '%s day(s) before' => '',
        '%s week before' => '',
        'before the appointment starts' => '',
        'after the appointment has been started' => '',
        'before the appointment ends' => '',
        'after the appointment has been ended' => '',
        'No permission!' => '',
        'Cannot delete ticket appointment!' => '',
        'No permissions!' => '',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Riwayat Pelanggan',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'Tidak ada jenis konfigurasi untuk %s',
        'Statistic' => 'Statistik',
        'No preferences for %s!' => 'Tidak ada preferensi untuk %s!',
        'Can\'t get element data of %s!' => 'Tidak bisa mendapatkan data unsur %s!',
        'Can\'t get filter content data of %s!' => 'Tidak bisa mendapatkan data filter konten dari %s!',
        'Customer Name' => '',
        'Customer User Name' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'Perlu sumber objek dan sumber kunci!',
        'You need ro permission!' => 'Anda perlu izin ro!',
        'Can not delete link with %s!' => 'Tidak bisa menghapus tautan dengan %s!',
        '%s Link(s) deleted successfully.' => '',
        'Can not create link with %s! Object already linked as %s.' => 'tidak bisa membuat link dengan %s! Objek yang sudah dikaitkan sebagai %s.',
        'Can not create link with %s!' => 'Tidak bisa membuat link dengan%s!',
        '%s links added successfully.' => '',
        'The object %s cannot link with other object!' => 'objek %s tidak bisa dihubungkan dengan objek yang lain!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Param Grup diperlukan!',
        'Updated user preferences' => '',
        'System was unable to deploy your changes.' => '',
        'Setting not found!' => '',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'Proses tiket',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Parameter %s hilang',
        'Invalid Subaction.' => 'Subaction tidak valid',
        'Statistic could not be imported.' => 'Statistik tidak dapat diimpor.',
        'Please upload a valid statistic file.' => 'Silahkan upload file statistik yang valid.',
        'Export: Need StatID!' => 'Ekspor: Membutuhkan StatID!',
        'Delete: Get no StatID!' => 'Hapus: Tidak ada StatID!',
        'Need StatID!' => 'Membutuhkan StatID!',
        'Could not load stat.' => 'Tidak dapat memuat stat.',
        'Add New Statistic' => 'Tambahkan statistik baru',
        'Could not create statistic.' => 'Tidak dapat membuat statistik.',
        'Run: Get no %s!' => 'Jalankan: Tidak mendapatkan %s!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'Tidak ada TicketID diberikan!',
        'You need %s permissions!' => 'Anda perlu %s izin!',
        'Loading draft failed!' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Maaf, Untuk melakukan tindakan ini anda harus menjadi pemilik tiket.',
        'Please change the owner first.' => 'Mohon Ubah Pemilik terlebih dahulu.',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => '',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => 'Tidak bisa melakukan validasi pada bidang!',
        'No subject' => 'Tidak ada subjek',
        'Could not delete draft!' => '',
        'Previous Owner' => 'Pemilik sebelumnya',
        'wrote' => 'Tertulis',
        'Message from' => 'Pesan dari',
        'End message' => 'Akhiri pesan',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s diperlukan!',
        'Plain article not found for article %s!' => 'Artikel polos tidak ditemukan untuk artikel %s!',
        'Article does not belong to ticket %s!' => 'Artikel bukan milik tiket %s!',
        'Can\'t bounce email!' => 'Tidak bisa membuka email',
        'Can\'t send email!' => 'Tidak bisa menghantar email',
        'Wrong Subaction!' => 'Subaction salah',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Tiket tidak bisa dikunci, tidak ada TicketIDs diberikan!',
        'Ticket (%s) is not unlocked!' => 'Tiket (%s) tidak dibuka',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => '',
        'Bulk feature is not enabled!' => 'Fitur tidak diaktifkan',
        'No selectable TicketID is given!' => 'Tidak ada pilihan TicketID yang diberikan!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => 'Alamat %s ditukar dengan alamat pelanggan yang terdaftar',
        'Customer user automatically added in Cc.' => 'Pelanggan pengguna ditambahkan ke Cc secara otomatis.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Tiket "%s" telah dibuat!',
        'No Subaction!' => 'Tidak ada subaction!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'Tidak ada TicketID!',
        'System Error!' => 'Sistem eror',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Minggu depan',
        'Ticket Escalation View' => 'Tampilan Tiket Eskalasi',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => 'Pesan diteruskan dari',
        'End forwarded message' => 'Akhiri pesan yang diteruskan',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'Tidak bisa menampilkan sejarah, tidak ada TicketID diberikan!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'Tiket tidak bisa dikunci, tidak ada TicketID diberikan!',
        'Sorry, the current owner is %s!' => 'Maaf, pemilik sekarang adalah %s!',
        'Please become the owner first.' => 'Tolong jadikan pemilik utama',
        'Ticket (ID=%s) is locked by %s!' => 'Ticket (ID=%s) dikunci oleh %s!',
        'Change the owner!' => 'Ubah pemilik!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Artikel baru',
        'Pending' => 'Ditunda',
        'Reminder Reached' => 'Pengingat tercapai',
        'My Locked Tickets' => 'Tiket terkunci saya',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Tidak dapat menggabungkan tiket dengan dirinya sendiri!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'Anda perlu memindahkan permissions!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Obrolan tidak diaktifkan',
        'No permission.' => 'Tidak ada permission.',
        '%s has left the chat.' => '%s telah meninggalkan obrolan.',
        'This chat has been closed and will be removed in %s hours.' => 'obrolan ini telah ditutup dan akan dihapus dalam waktu %s jam.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Tiket terkunci',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'Tidak ada ArticleID!',
        'This is not an email article.' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'Tidak bisa membaca artikel polos! Mungkin tidak ada email biasa di backend! Membaca pesan backend.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'Membutuhkan TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Tidak bisa mendapatkan ActivityDialogEntityID "%s"!',
        'No Process configured!' => 'Tidak ada Proses dikonfigurasi!',
        'The selected process is invalid!' => 'Proses yang dipilih tidak sah!',
        'Process %s is invalid!' => 'Proses%s tidak valid!',
        'Subaction is invalid!' => 'Subaction tidak sah',
        'Parameter %s is missing in %s.' => 'Parameter %s telah hilang di %s',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'Tidak ada Kegiatan Dialog dikonfigurasi untuk %s di RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'Tidak dapat memulai ActivityEntityID atau memulai ActivityDialogEntityID untuk proses: %s di _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'Tidak bisa mendapatkan tiket untuk TiketID di _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'Tidak dapat menentukan Kegiatan EntityID. DynamicField atau konfigurasi tidak diatur dengan benar!',
        'Process::Default%s Config Value missing!' => 'Proses :: default%s vs Nilai Konfigurasi hilang!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'Tidak mendapat ProcessEntityID atau TicketID dan ActivityDialogEntityID!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'Tidak bisa mendapatkan StartActivityDialog dan StartActivityDialog untuk ProcessEntityID "%s"!',
        'Can\'t get Ticket "%s"!' => 'Tidak bisa mendapatkan Ticket "%s"!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'Tidak bisa mendapatkan ProcessEntityID atau ActivityEntityID untuk Tiket "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'Tidak dapat mengkonfigurasi aktivitas untuk Aktivitas Entity ID "%s"!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'Tidak bisa mendapatkan konfigurasi ActiviyDialog untuk ActivityDialogEntityID "%s"!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'Tidak bisa mendapatkan data untuk Field "%s" dari ActivityDialog "%s"!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'PendingTime bisa digunakan apabila State atau StateID dikonfigurasi untuk ActivityDialogyang sama. ActivityDialog: %s!',
        'Pending Date' => 'Tanggal yang tertunda',
        'for pending* states' => 'Tertunda untuk states',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID telah hilang!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'Tidak bisa mendapatkan konfigurasi untuk ActivityDialogEntityID "%s"!',
        'Couldn\'t use CustomerID as an invisible field.' => '',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'ProcessEntityID telah hilang, silahkan segera periksa ActivityDialogHeader.tt anda!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'Tidak ada Start StartActivityDialog atau StartActivityDialog for Process "%s" dikonfigurasi!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'Tidak bisa membuat tiket untuk melakukan proses ProcessEntityID "%s"!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'Tidak bisa mendapatkan Proses EntityID "%s" pada TicketID "%s"!',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'Tidak bisa set ActivityEntityID "%s" di TicketID "%s"!',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'Tidak bisa menyimpan ActivityDialog. TicketID tidak sah: %s!',
        'Invalid TicketID: %s!' => 'TicketID tidak sah : %s!',
        'Missing ActivityEntityID in Ticket %s!' => 'ActivityEntityID hilang di Ticket %s!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => 'ProcessEntityID hilang di Tiket %s!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Tidak bisa set SynamicField nilai untuk %s dari Ticket dengan ID "%s" di ActivityDialog "%s"!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Tidak bisa set PendingTime untuk Ticket dengan ID "%s" di ActivityDialog "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'Salah Kegiatan Dialog Lapangan config:%s tidak bisa Tampilkan => 1 / Tampilkan lapangan (Silahkan ubah konfigurasi menjadi Tampilan => 0 / Jangan tampilkan lapangan atau Tampilan => 2 / Tampilkan lapangan sebagai wajib)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Tidak bisa mengatur %s untuk Ticket dengan ID "%s" di Dialog Activity "!',
        'Default Config for Process::Default%s missing!' => 'Default Config untuk Proses :: Default hilang!',
        'Default Config for Process::Default%s invalid!' => 'Default Config untuk Proses :: bawaan% tidak valid!',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Tiket yang tersedia',
        'including subqueues' => 'Termasuk sub-antrian',
        'excluding subqueues' => 'Tidak termasuk sub-antrian',
        'QueueView' => 'TampilanAntrian',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Tiket yang saya pertanggung jawabkan',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'Pencarian-Terakhir',
        'Untitled' => 'Tanpa judul',
        'Ticket Number' => 'Nomor tiket',
        'Ticket' => 'Tiket',
        'printed by' => 'dicetak oleh',
        'CustomerID (complex search)' => '',
        'CustomerID (exact match)' => '',
        'Invalid Users' => 'Pengguna tidak sah',
        'Normal' => 'Normal',
        'CSV' => 'CSV',
        'Excel' => 'Exel',
        'in more than ...' => 'dalam ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'Feature tidak diaktifkan!',
        'Service View' => 'Tampilan layanan',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Tampilan Status',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Tiket yang saya amati',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'Fitur tidak aktif',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Sambungan dihapuskan',
        'Ticket Locked' => 'Tiket dikunci',
        'Pending Time Set' => 'Set Penundaan Waktu',
        'Dynamic Field Updated' => 'DynamicField diperbarukan',
        'Outgoing Email (internal)' => 'Email keluar (internal)',
        'Ticket Created' => 'Membuat tiket',
        'Type Updated' => 'Jenis diperbarui',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => 'Eskalasi Perbarui Waktu Berhenti',
        'Escalation First Response Time Stopped' => 'Eskalasi Pertama Respon Waktu Berhenti',
        'Customer Updated' => 'Pelanggan diperbarui',
        'Internal Chat' => 'Obrolan didalam',
        'Automatic Follow-Up Sent' => 'Auto follow-up dihantar',
        'Note Added' => 'Note ditambah',
        'Note Added (Customer)' => 'Catatan ditambah (Pelanggan)',
        'SMS Added' => '',
        'SMS Added (Customer)' => '',
        'State Updated' => 'State diperbarui',
        'Outgoing Answer' => 'Jawaban keluar',
        'Service Updated' => 'Servis diperbarui',
        'Link Added' => 'Alat sambung ditambahkan',
        'Incoming Customer Email' => 'Email pelanggan yang masuk',
        'Incoming Web Request' => 'Permintaan web yang masuk',
        'Priority Updated' => 'Prioritas diperbarui',
        'Ticket Unlocked' => 'Ticket dibuka',
        'Outgoing Email' => 'Email keluar ',
        'Title Updated' => 'Judul diperbarui',
        'Ticket Merged' => 'Tiket digabungkan',
        'Outgoing Phone Call' => 'Panggilan keluar',
        'Forwarded Message' => '',
        'Removed User Subscription' => '',
        'Time Accounted' => 'Waktu dicatat',
        'Incoming Phone Call' => 'Panggilan masuk',
        'System Request.' => '',
        'Incoming Follow-Up' => 'Follow-Up masuk',
        'Automatic Reply Sent' => 'Penghantaran otomotasi untuk membalas pesan',
        'Automatic Reject Sent' => '',
        'Escalation Solution Time In Effect' => '',
        'Escalation Solution Time Stopped' => 'Eskalasi Perbarui Waktu Berhenti',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => 'Eskalasi Respon Waktu Diberhentikan',
        'SLA Updated' => 'SLA diperbarukan',
        'External Chat' => 'Obrolan diluar',
        'Queue Changed' => '',
        'Notification Was Sent' => '',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => '',
        'Can\'t get for ArticleID %s!' => 'Tidak bisa mendapatkan ArticleID %s!',
        'Article filter settings were saved.' => 'Pengaturan filter artikel telah disimpan',
        'Event type filter settings were saved.' => 'Jenis acara setelan filter diselamatkan.',
        'Need ArticleID!' => 'Perlu ArticleID!',
        'Invalid ArticleID!' => 'AricleID tidak sah!',
        'Forward article via mail' => 'Teruskan artikel melalui surat',
        'Forward' => 'Teruskan',
        'Fields with no group' => 'Fields tanpa ada grup',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Artikel tidak bisa dibuka! Mungkin artikel itu berada dihalaman lain',
        'Show one article' => 'Tampilkan satu artikel',
        'Show all articles' => 'Tampilkan semua artikel',
        'Show Ticket Timeline View' => 'Tampilkan Tiket Timeline View',
        'Show Ticket Timeline View (%s)' => '',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '',
        'No TicketID for ArticleID (%s)!' => 'Tidak ada TicketID untuk ArticleID (%s)!',
        'HTML body attachment is missing!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'FielD dan ArticleID diperlukan!',
        'No such attachment (%s)!' => 'Tidak ada lampiran (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'Periksa SysConfig untuk pengaturan %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'Periksa SysConfig pengaturan untul %s::TicketTypeDefault.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'Perlu CustomerID!',
        'My Tickets' => 'Tiket saya',
        'Company Tickets' => 'Tiket perusahaan',
        'Untitled!' => 'Tanpa judul!',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Namaasli pelanggan',
        'Created within the last' => 'Dibuat dalam terakhir',
        'Created more than ... ago' => 'Dibuat lebih dari .... yang lalu',
        'Please remove the following words because they cannot be used for the search:' =>
            'Tolong hapuskan kalimat berikut karena tidak dapat dicari',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'Tidak bisa membuka tiket kembali. tidak mungkin dalam queue ini!',
        'Create a new ticket!' => 'Mencipta tiket baru!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'Modus aman aktif!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => 'Tidak ada direktori "%s"',
        'Configure "Home" in Kernel/Config.pm first!' => 'Konfigur "Home" di Kernel/Config.pm first!',
        'File "%s/Kernel/Config.pm" not found!' => 'Fail "%s/Kernel/Config.pm" tidak ditemukan',
        'Directory "%s" not found!' => 'Direktori "%s" tidak ditemukan!',
        'Install OTRS' => 'Instal OTRS',
        'Intro' => 'Pendahuluan',
        'Kernel/Config.pm isn\'t writable!' => 'Kernel / Config.pm tidak dapat ditulis!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'Jika Anda ingin menggunakan installer, mengatur ditulis Kernel/Config.pm untuk pengguna webserver!',
        'Database Selection' => 'Pilihan database',
        'Unknown Check!' => 'Periksa yang tidak diketahui!',
        'The check "%s" doesn\'t exist!' => 'Cek "%s" tidak ada!',
        'Enter the password for the database user.' => 'masukan kata sandi untuk pengguna database',
        'Database %s' => 'Database %s',
        'Configure MySQL' => '',
        'Enter the password for the administrative database user.' => 'Masukan kata sandi untuk pengguna database administrasi',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => 'Diketahui tipe database "%s".',
        'Please go back.' => '',
        'Create Database' => 'Buat database',
        'Install OTRS - Error' => 'Menginstal OTRS - Kesalahan',
        'File "%s/%s.xml" not found!' => 'File "%s/%s.xml" tidak ditemukan!',
        'Contact your Admin!' => 'Hubungi Admin Anda!',
        'System Settings' => 'Pengaturan sistem',
        'Syslog' => '',
        'Configure Mail' => 'Konfigurasi surat',
        'Mail Configuration' => 'Konfigurasi surat',
        'Can\'t write Config file!' => 'tidak bisa menulis file Config!',
        'Unknown Subaction %s!' => 'Diketahui Subaction %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Tidak dapat terhubung ke database, Perl modul DBD ::%s tidak terpasang!',
        'Can\'t connect to database, read comment!' => 'Tidak dapat terhubung ke database, membaca komentar!',
        'Database already contains data - it should be empty!' => 'Database telah terisi data - database seharusnya kosong!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Kesalahan: Pastikan database Anda menerima paket lebih dari %s MB (itu saat ini hanya menerima paket sampai %s MB). Silahkan menyesuaikan pengaturan max_allowed_packet dari database Anda untuk menghindari kesalahan.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Kesalahan: Silakan menetapkan nilai untuk innodb_log_file_size pada database Anda untuk setidaknya%s MB (saat ini: %s MB, direkomendasikan: %s MB). Untuk informasi lebih lanjut, silakan lihat di %s.',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => '',
        'No such user!' => '',
        'Invalid calendar!' => '',
        'Invalid URL!' => '',
        'There was an error exporting the calendar!' => '',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'Perlu config Paket::Repository Access regex',
        'Authentication failed from %s!' => 'Otentikasi gagal dari %s!',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Lompatkan artikel kepada alamat surat yang berbeda',
        'Bounce' => 'Lambung',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Balas semua',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Balas ke catatan',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Pisahkan artikel ini',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'Lihat sumber untuk Pasal ini',
        'Plain Format' => 'Format polos',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Cetak artikel ini',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Tandai',
        'Unmark' => 'Hapus tanda',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Upgrade to OTRS Business Solution™' => '',
        'Re-install Package' => '',
        'Upgrade' => 'Meningkatkan',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Kripted',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'Tertanda',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '"PGP DITANDATANGANI PESAN" header ditemukan, tapi tidak valid!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '"S/MIME DITANDATANGANI PESAN" header ditemukan, tapi tidak valid!',
        'Ticket decrypted before' => 'Tiket didekripsi sebelum',
        'Impossible to decrypt: private key for email was not found!' => 'Mustahil untuk mendekripsi: kunci pribadi untuk email tidak ditemukan!',
        'Successful decryption' => 'Dekripsi sukses',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            '',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Encrypt' => '',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => '',
        'PGP sign' => '',
        'PGP sign and encrypt' => '',
        'PGP encrypt' => '',
        'SMIME sign' => '',
        'SMIME sign and encrypt' => '',
        'SMIME encrypt' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => '',
        'Cannot use revoked signing key: \'%s\'. ' => '',
        'There are no signing keys available for the addresses \'%s\'.' =>
            '',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            '',
        'Sign' => 'Tanda tangan',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Tunjukan',
        'Refresh (minutes)' => '',
        'off' => 'nonaktifkan',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Tunjukan kepada pengguna pelanggan',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => '',
        'Away' => '',
        'User was inactive for a while.' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'Waktu dimulai apabila tiket telah ditetapkan setelah waktu berakhir!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => '',
        'Can\'t get OTRS News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '',
        'Can\'t get Product News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'Tiket yang telah ditunjukan',
        'Shown Columns' => 'Tunjukan kolom',
        'filter not active' => 'Filter tidak aktif',
        'filter active' => 'Filter diaktifkan',
        'This ticket has no title or subject' => 'Tiket ini tidak memiliki judul atau subjek',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Statistik 7 hari',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Standar',
        'The following tickets are not updated: %s.' => '',
        'h' => 'j',
        'm' => 'm',
        'd' => 'h',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'Ini adalah',
        'email' => 'email',
        'click here' => 'klik disini',
        'to open it in a new window.' => 'Untuk membukanya di jendela baru',
        'Year' => 'Tahun',
        'Hours' => 'jam',
        'Minutes' => 'menit',
        'Check to activate this date' => 'Centang untuk mengaktifkan tanggal ini',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'Tidak memiliki izin!',
        'No Permission' => 'Tidak ada izin',
        'Show Tree Selection' => 'Tunjukan pilihan keturunan',
        'Split Quote' => 'Membagi kutipan',
        'Remove Quote' => 'Hapus kutipan',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Terkait sebagai',
        'Search Result' => 'Hasil pencarian',
        'Linked' => 'Terhubung',
        'Bulk' => 'Massal',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Ringan',
        'Unread article(s) available' => 'Ubah Artikel(artikel-artikel) yang tersedia menjadi belum terbaca',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentCloudServicesDisabled.pm
        'Enable cloud services to unleash all OTRS features!' => 'Mengaktifkan layanan cloud untuk melepaskan semua fitur OTRS!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%S Upgrade ke %s sekarang! %s',
        'Please verify your license data!' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'Lisensi untuk %s anda akan segera berakhir. Silahkan mengkontak %s untuk memperbarui kontrak anda!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'Pembaruan untuk %s anda telah tersedia, Tetapi ada konflik dengan versi kerangka anda! Silahkan untuk memperbarui Kerangka anda terlebih dahulu!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Agen online: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Tiket yang tereskalasi ada lebih banyak!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Pelanggan inline: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTRS Daemon is not running.' => 'OTRS Daemon tidak berjalan',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Anda telah mengaktifkan Diluar kantor, Apakah anda ingin mengnonaktifkannya?',

        # Perl Module: Kernel/Output/HTML/Notification/PackageManagerCheckNotVerifiedPackages.pm
        'The installation of packages which are not verified by the OTRS Group is activated. These packages could threaten your whole system! It is recommended not to use unverified packages.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => '',
        'There is an error updating the system configuration!' => '',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Pastikan Anda telah memilih setidaknya satu metode transportasi untuk pemberitahuan wajib.',
        'Preferences updated successfully!' => 'Pilihan telah berhasil diperbarui!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => 'Sedang diproses',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Silakan tentukan tanggal akhir yaitu setelah tanggal mulai.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Current password' => 'Kata sandi saat ini',
        'New password' => 'Kata sandi baru',
        'Verify password' => 'verifikasi kata sandi',
        'The current password is not correct. Please try again!' => 'Kata sandi saat ini tidak benar. Silahkan coba lagi!',
        'Please supply your new password!' => 'Harap menyertakan password baru Anda!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Tidak dapat memperbarui kata sandi, Kata sandi baru anda tidak cocok. Silahkan coba lagi!',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Tidak dapat memperbarui kata sandi, kata sandi setidaknya harus sepanjang %s karakter.',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Tidak dapat memperbarui kata sandi, kata sandi harus memiliki setidaknya 1 angka!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'tidak valid',
        'valid' => 'valid',
        'No (not supported)' => 'Tidak (Tidak didukung)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'No past complete or the current+upcoming complete relative time value selected.',
        'The selected time period is larger than the allowed time period.' =>
            'jangka waktu yang dipilih lebih besar dari periode waktu yang diperbolehkan.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'Tidak ada waktu nilai skala tersedia untuk nilai skala saat ini dipilih waktu pada sumbu X.',
        'The selected date is not valid.' => 'Tanggal yang dipilih tidak valid.',
        'The selected end time is before the start time.' => 'Waktu akhir yang dipilih adalah sebelum waktu mulai.',
        'There is something wrong with your time selection.' => 'Ada sesuatu yang salah dengan pilihan waktu Anda.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Silakan pilih hanya satu unsur atau memungkinkan modifikasi pada saat generasi stat.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Silakan pilih minimal satu nilai bidang ini atau mengizinkan modifikasi pada saat generasi stat.',
        'Please select one element for the X-axis.' => 'Silakan pilih salah satu elemen untuk X-axis.',
        'You can only use one time element for the Y axis.' => 'Anda hanya dapat menggunakan satu elemen waktu untuk sumbu Y.',
        'You can only use one or two elements for the Y axis.' => 'Anda hanya dapat menggunakan satu atau dua elemen untuk sumbu Y.',
        'Please select at least one value of this field.' => 'Silakan pilih minimal satu nilai bidang ini.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Berikan nilai atau mengizinkan modifikasi pada saat generasi stat.',
        'Please select a time scale.' => 'Silakan pilih skala waktu.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'Laporan interval waktu anda terlalu kecil, gunakan skala waktu yang lebih besar.',
        'second(s)' => 'detik',
        'quarter(s)' => 'Per empat',
        'half-year(s)' => 'semester',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Harap hapus kata-kata berikut karena mereka tidak dapat digunakan untuk pembatasan tiket : %s.',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => '',
        'Content' => 'Konten',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Buka kuncu untuk mengembalikannya pada antrian',
        'Lock it to work on it' => 'Kunci untuk dikerjakan',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Berhenti amati',
        'Remove from list of watched tickets' => 'Hapus dari daftar tiket yang diamati',
        'Watch' => 'amati',
        'Add to list of watched tickets' => 'Tambahkan kepada daftar tiket yangdi amati',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Dipesan oleh',

        # Perl Module: Kernel/Output/HTML/TicketZoom/TicketInformation.pm
        'Ticket Information' => 'Informasi tiket',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Tiket terkunci baru',
        'Locked Tickets Reminder Reached' => 'Pengingat Tiket Terkunci Tercapai',
        'Locked Tickets Total' => 'Total Tiket Terkunci',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Tiket Penanggung Jawab baru',
        'Responsible Tickets Reminder Reached' => 'Pengingat Tiket Penanggung Jawab tercapai',
        'Responsible Tickets Total' => 'Total tiket Penanggung jawab',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Tiket baru yang diamati',
        'Watched Tickets Reminder Reached' => 'Pengingat Tiket yang diamati tercapai',
        'Watched Tickets Total' => 'Total tiket yang diamati',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Tiket Dinamis Fields',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Saat ini tidak memungkinkan untuk login karena sedang dilaksanakan perawatan sistem yang telah dijadwalkan.',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '',
        'Please note that the session limit is almost reached.' => '',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '',
        'Session limit reached! Please try again later.' => 'Anda telah melebihi batas sesi! Silahkan untuk mencoba lagi nanti.',
        'Session per user limit reached!' => 'Sesi per batas pengguna!',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Sesi tidak sah. Silahkan log in lagi.',
        'Session has timed out. Please log in again.' => 'Waktu sesi ini telah habis. Silahkan log in lagi.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => '',
        'PGP encrypt only' => '',
        'SMIME sign only' => '',
        'SMIME encrypt only' => '',
        'PGP and SMIME not enabled.' => '',
        'Skip notification delivery' => '',
        'Send unsigned notification' => '',
        'Send unencrypted notification' => '',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Referensi pilihan konfigurasi',
        'This setting can not be changed.' => 'Pengaturan ini tidak dapat diubah.',
        'This setting is not active by default.' => 'Pengaturan ini tidak aktif secara default.',
        'This setting can not be deactivated.' => 'Pengaturan ini tidak dapat dinonaktifkan.',
        'This setting is not visible.' => '',
        'This setting can be overridden in the user preferences.' => '',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            '',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'sebelum/sesudah',
        'between' => 'antara',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'Bidang ini dibutuhkan untuk',
        'The field content is too long!' => 'Konten dari bidang ini terlalu panjang!',
        'Maximum size is %s characters.' => 'Ukuran maksimum adalah %s karakter',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'Tidak diinstall',
        'installed' => 'Telah diinstal',
        'Unable to parse repository index document.' => 'Tidak dapat untuk mengurai dokumen indeks repositori .',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Paket untuk versi kerangka anda tidak ditemui pada repositori ini, repository ini hanya memiliki paket untuk kerangka versi lainnya.',
        'File is not installed!' => '',
        'File is different!' => '',
        'Can\'t read file!' => '',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTRS service contracts.</p>' =>
            '',
        '<p>The installation of packages which are not verified by the OTRS Group is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Tidak aktif',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Tidak dapat menghubungi server pendaftaran. Silahkan mencoba lagi nanti',
        'No content received from registration server. Please try again later.' =>
            'Tidak ada konten diterima dari server registrasi. Silahkan mencoba lagi nanti.',
        'Can\'t get Token from sever' => 'Tidak bisa mendapatkan Token dari server',
        'Username and password do not match. Please try again.' => 'Nama pengguna dan Kata sandi tidak cocok. Silahkan coba lagi nanti',
        'Problems processing server result. Please try again later.' => 'Pengolahan hasil server bermasalah. Silahkan mencoba lagi nanti',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => '',
        'week' => 'minggu',
        'quarter' => 'Quarter',
        'half-year' => 'semester',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Jenis stat',
        'Created Priority' => 'dibuat Prioritas',
        'Created State' => 'Menciptakan State',
        'Create Time' => 'Buat Waktu',
        'Pending until time' => '',
        'Close Time' => 'Tutup Waktu',
        'Escalation' => 'Eskalasi',
        'Escalation - First Response Time' => 'Eskalasi - Waktu respon pertama',
        'Escalation - Update Time' => 'Eskalasi - Update Waktu',
        'Escalation - Solution Time' => 'Eskalasi - Waktu Solusi',
        'Agent/Owner' => 'Agen/Pemilik',
        'Created by Agent/Owner' => 'Dibuat oleh Agen/Pemilik',
        'Assigned to Customer User Login' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Evaluasi oleh',
        'Ticket/Article Accounted Time' => 'Tiket/Artikel Waktu dicatat',
        'Ticket Create Time' => 'Tiket Buat Waktu',
        'Ticket Close Time' => 'Tiket Tutup Waktu',
        'Accounted time by Agent' => 'Waktu dipertanggungjawabkan oleh agen',
        'Total Time' => 'Jumlah wakt',
        'Ticket Average' => 'Rata-rata tiket',
        'Ticket Min Time' => 'Minimal tiket waktu',
        'Ticket Max Time' => 'Waktu maksimal tiket',
        'Number of Tickets' => 'Nomor tiket',
        'Article Average' => 'Rata-rata artikel',
        'Article Min Time' => 'Minimal waktu ',
        'Article Max Time' => 'Maksimal waktu artikel',
        'Number of Articles' => 'Nomor artikel',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => 'Tanpa batas',
        'Attributes to be printed' => 'Atribut yang akan dicetak',
        'Sort sequence' => 'Urutan sesuai berikut',
        'State Historic' => 'State Histori',
        'State Type Historic' => 'Jenis sejarah state',
        'Historic Time Range' => 'Sejarah Rentang Waktu',
        'Number' => 'Nomor',
        'Last Changed' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'Rata-rata solusi',
        'Solution Min Time' => 'Solusi waktu',
        'Solution Max Time' => 'Solusi waktu maksimal',
        'Solution Average (affected by escalation configuration)' => 'Solusi rata (dipengaruhi oleh konfigurasi eskalasi)',
        'Solution Min Time (affected by escalation configuration)' => 'Solusi Minimal Waktu (dipengaruhi oleh konfigurasi eskalasi)',
        'Solution Max Time (affected by escalation configuration)' => 'Solusi Maksimal Waktu (dipengaruhi oleh konfigurasi eskalasi)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'Rata-rata solusi waktu bekerja (Dipengaruhi oleh eskalasi konfigurasi)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'Solusi waktu minimal bekerja (dipengaruhi oleh konfigurasi eskalasi)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'Solusi maksimal waktu bekerja (dipengaruhi oleh eskalasi konfigurasi)',
        'First Response Average (affected by escalation configuration)' =>
            '',
        'First Response Min Time (affected by escalation configuration)' =>
            '',
        'First Response Max Time (affected by escalation configuration)' =>
            '',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '',
        'Number of Tickets (affected by escalation configuration)' => 'Jumlah tiket (dipengaruhi eskalasi konfigurasi)',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => 'Hari',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Kehadiran meja',
        'Internal Error: Could not open file.' => 'Kesalahan Internal: Tidak dapat membuka file.',
        'Table Check' => 'Periksa meja',
        'Internal Error: Could not read file.' => 'Kesalahan Internal: Tidak dapat membaca file',
        'Tables found which are not present in the database.' => 'Terdapat beberapa didalam database',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Ukuran database',
        'Could not determine database size.' => 'Tidak dapat menentukan ukuran basis data.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Versi database',
        'Could not determine database version.' => 'Tidak dapat menentukan versi basis data.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Koneksi klien charset',
        'Setting character_set_client needs to be utf8.' => 'Pengaturan character_set_client perlu utf 8.',
        'Server Database Charset' => 'Server database charset',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => 'Tabel charset',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB Log Ukuran File',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'Pengaturan innodb_log_file_size harus minimal 256 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otrs.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Maksimum Ukuran Query',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Ukuran Query Cache',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Pengaturan \'query_cache_size\' harus digunakan (lebih tinggi dari 10 MB tetapi tidak lebih dari 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Mesin Storage default',
        'Table Storage Engine' => 'Tabel penyimpanan mesin',
        'Tables with a different storage engine than the default engine were found.' =>
            'Tabel dengan mesin penyimpanan yang berbeda dari mesin yang ditemukan.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x atau yang lebih tinggi diperlukan.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG Pengaturan',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG harus diatur ke al32utf8 (contoh GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'Pengaturan NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT harus diatur menjadi \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'Pengaturan SQL check NLS_DATE_FORMAT',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Pengaturan client_encoding perlu UNICODE atau UTF 8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Pengaturan encoding server harus UNICODE atau UTF 8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Format tanggal',
        'Setting DateStyle needs to be ISO.' => 'Pengaturan DateStyle perlu ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'OTRS Disk Partisi',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Disk yang digunakan',
        'The partition where OTRS is located is almost full.' => 'Partisi tempat OTRS terletak hampir penuh.',
        'The partition where OTRS is located has no disk space problems.' =>
            'Partisi tempat OTRS terletak tidak memiliki masalah diruang disk.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Distribusi',
        'Could not determine distribution.' => 'Tidak dapat menentukan distribusi.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Versi Kernel',
        'Could not determine kernel version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Sistem dimuat',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'Beban sistem harus maksimal jumlah CPU sistem memiliki (misalnya beban 8 atau kurang pada sistem dengan 8 CPU adalah OK).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl Modul',
        'Not all required Perl modules are correctly installed.' => 'Tidak semua modul Perl yang diperlukan terpasang dengan benar.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Ruang bebas Swap (%)',
        'No swap enabled.' => 'Ada swap diaktifkan.',
        'Used Swap Space (MB)' => 'Ruang Swap digunakan (MB)',
        'There should be more than 60% free swap space.' => 'Harus ada lebih dari 60% ruang swap gratis.',
        'There should be no more than 200 MB swap space used.' => 'Seharusnya tidak ada ruang swap lebih dari 200 MB yang digunakan.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticleSearchIndexStatus.pm
        'OTRS' => 'OTRS',
        'Article Search Index Status' => '',
        'Indexed Articles' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLog.pm
        'Incoming communications' => '',
        'Outgoing communications' => '',
        'Failed communications' => '',
        'Average processing time of communications (s)' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '',
        'No connections found.' => '',
        'ok' => '',
        'permanent connection errors' => '',
        'intermittent connection errors' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'Config Settings' => '',
        'Could not determine value.' => 'Tidak dapat menentukan nilai.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => 'Daemon',
        'Daemon is running.' => '',
        'Daemon is not running.' => 'Daemon tidak berjalan',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => '',
        'Tickets' => 'Tiket',
        'Ticket History Entries' => 'Tiket Sejarah Entries',
        'Articles' => 'Artikel',
        'Attachments (DB, Without HTML)' => 'Lampiran (DB, Tanpa HTML)',
        'Customers With At Least One Ticket' => 'Pelanggan Dengan Sedikitnya Satu Tiket',
        'Dynamic Field Values' => 'Nilai Bidang dinamis',
        'Invalid Dynamic Fields' => 'Dinamis Fields valid',
        'Invalid Dynamic Field Values' => 'Nilai Bidang Dinamis valid',
        'GenericInterface Webservices' => 'Antarmuka generic webservis',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => 'Bulan diantara Pertama Dan Tiket terakhir',
        'Tickets Per Month (avg)' => 'Tiket Per Bulan (avg)',
        'Open Tickets' => 'Buka tiket',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Standar SOAP Username dan Password',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Resiko keamanan: Anda menggunakan pengaturan default untuk SOAP::Pengguna dan SOAP::Password. Silahkan mengubahnya.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => 'Katasandi admin default',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Risiko keamanan: akun agen root@localhost masih memiliki katasandi yang default. Ubah atau membatalkan account.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (domain name)',
        'Please configure your FQDN setting.' => 'Konfigurasikan pengaturan FQDN Anda.',
        'Domain Name' => 'Nama domain',
        'Your FQDN setting is invalid.' => 'Pengaturan FQDN Anda tidak valid.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => 'File System ditulis',
        'The file system on your OTRS partition is not writable.' => 'Sistem file pada partisi OTRS Anda tidak dapat ditulis.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '',
        'No legacy configuration backup files found.' => '',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => 'Status Instalasi paket',
        'Some packages have locally modified files.' => 'Beberapa paket telah lokal memodifikasi file.',
        'Some packages are not correctly installed.' => 'Beberapa paket tidak terpasang dengan benar.',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTRS could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Pengaturan Sistem Anda tidak valid, hanya harus berisi angka.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => 'Jenis Tiket ',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'Jenis tiket default dikonfigurasi tidak valid atau hilang. Silahkan ubah pengaturan Tiket::Jenis::default dan pilih jenis tiket yang sah.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Indeks tiket Modul',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Anda memiliki lebih dari 60.000 tiket dan harus menggunakan backend Static DB. Lihat admin user (Performance Tuning) untuk informasi lebih lanjut.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'Pengguna tidak valid dengan Tiket Terkunci',
        'There are invalid users with locked tickets.' => 'Ada pengguna yang tidak valid dengan tiket terkunci.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Anda tidak harus memiliki lebih dari 8.000 tiket yang terbuka di sistem Anda.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Indeks Cari tiket Modul',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Rekaman yatim Dalam ticket_lock_index Table',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'Tabel ticket_lock_index berisi catatan yatim. Jalankan bin/otrs.Console.pl "Maint::Ticket::AntrianIndeksCleanup" untuk membersihkan indeks StaticDB.',
        'Orphaned Records In ticket_index Table' => 'Rekaman yatim Dalam Indeks tiket Table',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => '',
        'Server time zone' => 'Zona waktu server',
        'OTRS time zone' => '',
        'OTRS time zone is not set.' => '',
        'User default time zone' => '',
        'User default time zone is not set.' => '',
        'Calendar time zone is not set.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/SpecialStats.pm
        'UI - Special Statistics' => '',
        'Agents using custom main menu ordering' => '',
        'Agents using favourites for the admin overview' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Webserver',
        'Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'Model MPM',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS membutuhkan apache dijalankan dengan model \'prefork\' MPM.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI Accelerator Penggunaan',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Anda harus menggunakan FastCGI atau mod_perl untuk meningkatkan kinerja Anda.',
        'mod_deflate Usage' => 'Penggunaan mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Silahkan install mod_deflate untuk meningkatkan kecepatan GUI.',
        'mod_filter Usage' => 'Penggunaan mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'Silahkan install mod_filter jika mod_deflate digunakan.',
        'mod_headers Usage' => 'Penggunaan mod_headers ',
        'Please install mod_headers to improve GUI speed.' => 'Silahkan install mod_headers untuk meningkatkan kecepatan GUI.',
        'Apache::Reload Usage' => 'Penggunaan Apache::Reload ',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload atau Apache2::Reload harus digunakan sebagai Perl Modul dan PerlInitHandler untuk mencegah restart web server ketika menginstal dan upgrade modul.',
        'Apache2::DBI Usage' => 'Penggunaan Apache2::DBI',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Apache2::DBI harus digunakan untuk mendapatkan kinerja yang lebih baik dengan koneksi database pra-didirikan.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Versi Webserver',
        'Could not determine webserver version.' => 'Tidak dapat menentukan versi web server.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => 'Pengguna bersamaan',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'Oke',
        'Problem' => 'Masalah',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '',
        'Setting %s is not locked to this user!' => '',
        'Setting value is not valid!' => '',
        'Could not add modified setting!' => '',
        'Could not update modified setting!' => '',
        'Setting could not be unlocked!' => '',
        'Missing key %s!' => '',
        'Invalid setting: %s' => '',
        'Could not combine settings values into a perl hash.' => '',
        'Can not lock the deployment for UserID \'%s\'!' => '',
        'All Settings' => '',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'Default',
        'Value is not correct! Please, consider updating this field.' => '',
        'Value doesn\'t satisfy regex (%s).' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => 'Diaktifkan',
        'Disabled' => 'Cacat',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTRSTimeZone!' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTRSTimeZone!' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            '',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'Reset atau membuka waktu.',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '',
        'Chat Message Text' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Login gagal! Nama pengguna atau kata sandi yang di masukan salah.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => 'Logout sukses.',
        'Feature not active!' => 'Fitur tidak aktif!',
        'Sent password reset instructions. Please check your email.' => 'Instruksi untuk mereset kode sandi telah dikirimkan. Silahkan untuk memeriksa email anda.',
        'Invalid Token!' => 'Token tidak sah!',
        'Sent new password to %s. Please check your email.' => 'Kode sandi baru telah dikirimkan kepada %s. Silahkan untuk memeriksa email anda.',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => 'Tidak ada Izin untuk menggunakan modul antarmuka ini!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Alamat email ini telah digunakan. Silahkan log in atau atur ulang kata sandi anda',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Alamat email ini tidak diizinkan untuk mendaftar. Silahkan untuk menghubungi staff Pendukung.',
        'Added via Customer Panel (%s)' => 'Ditambahkan melalui Panel Pelanggan (%s)',
        'Customer user can\'t be added!' => 'Pengguna pelanggan tidak dapat ditambahkan!',
        'Can\'t send account info!' => 'Tidak dapat mengirim info akun!',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Akun baru telah dibuat. Kirimkan informasi login kepada %s. Silahkan untuk memeriksa email anda.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => 'Action "%s" tidak ditemukan!',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'invalid-temporarily' => 'tidak valid sementara',
        'Group for default access.' => 'Kelompok untuk akses default.',
        'Group of all administrators.' => 'Grup semua administrator',
        'Group for statistics access.' => 'Grup untuk akses statistik',
        'new' => 'baru',
        'All new state types (default: viewable).' => 'Semua jenis state (default: paparkan).',
        'open' => 'buka',
        'All open state types (default: viewable).' => 'Semua jenis keadaan terbuka (default: dapat dilihat).',
        'closed' => 'tertutup',
        'All closed state types (default: not viewable).' => 'Semua jenis keadaan tertutup (default: tidak dapat dilihat).',
        'pending reminder' => 'Pengingat Ditunda',
        'All \'pending reminder\' state types (default: viewable).' => 'Semua \'pending pengingat\' jenis state (default: dapat dilihat).',
        'pending auto' => 'otomatis ditunda',
        'All \'pending auto *\' state types (default: viewable).' => 'Semua \'tertunda secara auto *\' jenis state (default: dapat dilihat).',
        'removed' => 'dihapus',
        'All \'removed\' state types (default: not viewable).' => 'Semua \'dihapus\' jenis state (default: Tidak bisa Dilihat).',
        'merged' => 'Tergabung',
        'State type for merged tickets (default: not viewable).' => 'Jenis state untuk tiket gabungan (default: tidak dapat dilihat).',
        'New ticket created by customer.' => 'tiket baru dibuat oleh pelanggan',
        'closed successful' => 'Berhasil ditutup',
        'Ticket is closed successful.' => 'Tiket sukses ditutup.',
        'closed unsuccessful' => 'Tidak berhasil ditutup',
        'Ticket is closed unsuccessful.' => 'Tiket tidak berhasil ditutup ',
        'Open tickets.' => 'Buka tiket',
        'Customer removed ticket.' => 'Pelanggan menghapus tiket',
        'Ticket is pending for agent reminder.' => 'Tiket tertunda untuk pengingat agen.',
        'pending auto close+' => 'Tutup tertunda secara otomatis +',
        'Ticket is pending for automatic close.' => 'Tiket tertunda untuk otomatis dekat.',
        'pending auto close-' => 'Tutup tertunda secara otomatis -',
        'State for merged tickets.' => 'State untuk penggabungan tiket',
        'system standard salutation (en)' => 'Sistem standar salutasi',
        'Standard Salutation.' => 'Standar salutasi',
        'system standard signature (en)' => 'Sistem tandatangan standar ',
        'Standard Signature.' => 'Tandatangan standar',
        'Standard Address.' => 'Alamat standar',
        'possible' => 'Memungkinkan',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Kemungkinan Tindak lanjut untuk tiket yang tertutup. Tiket akan dibuka kembali.',
        'reject' => 'Tolak',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'Tindak lanjut untuk tiket tertutup tidak mungkin. Tidak ada tiket baru akan dibuat.',
        'new ticket' => 'Tiket baru',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => 'Antrian Postmaster.',
        'All default incoming tickets.' => 'Semua bawaan tiket masuk.',
        'All junk tickets.' => 'Semua sampah tiket',
        'All misc tickets.' => 'Semua tiket misc.',
        'auto reply' => 'balas secara otomatis',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Balasan otomatis yang akan dikirim setelah tiket baru telah dibuat.',
        'auto reject' => 'Tolak secara otomatis',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'Otomatis menolak yang akan dikirim setelah tindak lanjut telah ditolak (dalam antrian kasus tindak lanjut opsi "menolak").',
        'auto follow up' => 'Lanjutkan secara otomatis',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'Konfirmasi otomatis yang dikirim keluar setelah tindak lanjut telah menerima tiket (dalam antrian kasus opsi tindak lanjut adalah "mungkin").',
        'auto reply/new ticket' => 'balas/baru tiket secara otomatis',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'Respon otomatis yang akan dikirim setelah tindak lanjut telah ditolak dan tiket baru telah dibuat (dalam antrian kasus opsi tindak lanjut adalah "tiket baru").',
        'auto remove' => 'hapus secara otomatis',
        'Auto remove will be sent out after a customer removed the request.' =>
            'Menghapus secara otomatis akan dihantar keluar setelah pelanggan menghapus permintaan',
        'default reply (after new ticket has been created)' => 'balasan default (setelah tiket baru telah dibuat)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'Default menolak (setelah tindak lanjut dan menolak dari tiket tertutup)',
        'default follow-up (after a ticket follow-up has been added)' => 'bawaan tindak lanjut (setelah tiket tindak lanjut telah ditambahkan)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'default menolak/tiket baru dibuat (setelah ditutup tindak lanjut dengan penciptaan tiket baru)',
        'Unclassified' => 'Tidak bisa diklasifikasikan',
        '1 very low' => '1 sangat rendah',
        '2 low' => '2 rendah',
        '3 normal' => '3 normal',
        '4 high' => '4 tinggi',
        '5 very high' => '5 sangat tinggi',
        'unlock' => 'buka kunci',
        'lock' => 'kunci',
        'tmp_lock' => 'tmp_lock',
        'agent' => 'agen',
        'system' => 'sistem',
        'customer' => 'pelanggan',
        'Ticket create notification' => 'Tiket buat pemberitahuan',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Anda akan menerima pemberitahuan setiap kali tiket baru dibuat di salah satu Anda "My Antrian" atau "Layanan Saya".',
        'Ticket follow-up notification (unlocked)' => 'Tindak lanjut pemberitahuan ticket (tidak dikunci)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'Anda akan menerima sebuah pemberitahuan apabila pelanggan menghantarkan tindak lanjutan untuk membuka tiket dimana di "MY Queues" atau "My Services".',
        'Ticket follow-up notification (locked)' => 'Pemberitahuan tiket tindak lanjut (dikunci)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'Anda akan menerima sebuah pemberitahuan apabila pelanggan menghantar tindak lanjutan tiket yang dikunci dimana pemilik tiket atau tanggung jawab',
        'Ticket lock timeout notification' => 'Notifikasi waktu untuk mengunci tiket telah usai',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'Anda akan menerima pemberitahuan segera tiket milik Anda secara otomatis membuka.',
        'Ticket owner update notification' => 'Pemberitahuan pembaruan pemilik tiket',
        'Ticket responsible update notification' => 'Tiket bertanggung jawab memperbarui notifikasi',
        'Ticket new note notification' => 'Notifikasi catatan tiket baru',
        'Ticket queue update notification' => 'Pemberitahuan tiket pembaruan antrian ',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Anda akan menerima pemberitahuan jika tiket dipindahkan ke salah satu dari "My Queues" Anda.',
        'Ticket pending reminder notification (locked)' => 'Pemberitahuan pengingat tiket tertunda (terkunci)',
        'Ticket pending reminder notification (unlocked)' => 'Pemberitahuan tiket tertunda (tidak terkunci)',
        'Ticket escalation notification' => 'Pemberitahuan eskalasi tiket',
        'Ticket escalation warning notification' => 'Pemberitahuan amaran eskalasi tiket',
        'Ticket service update notification' => 'Pemberitahuan tiket layanan diperbarui',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'Anda akan menerima pemberitahuan jika layanan tiket berubah menjadi salah satu dari Anda "My Services".',
        'Appointment reminder notification' => '',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '',
        'Ticket email delivery failure notification' => '',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Tambahkan semua',
        'An item with this name is already present.' => 'Sudah ada item dengan nama ini.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Item ini masih memiliki sub item. Apakah anda yakin anda ingin menghapus item ini termasuk sub itemnya?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => '',
        'Less' => '',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => '',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => '',
        'Deleting attachment...' => '',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '',
        'Attachment was deleted successfully.' => '',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Apakah anda benar-benar ingin menghapus bidang dinamis ini? SEMUA data yang terasosiasi dengan data ini akan HILANG!',
        'Delete field' => 'Hapus bidang',
        'Deleting the field and its data. This may take a while...' => 'Menghapus lapangan dan data. Ini mungkin memerlukan waktu ...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => 'Hapus pilihan',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'Hapus pemicu event ini',
        'Duplicate event.' => 'Event duplikat',
        'This event is already attached to the job, Please use a different one.' =>
            'Event ini telah terlampir pada pekerjaan tersebut, mohon gunakan event yang berbeda',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Kesalahan terjadi selama komunikasi',
        'Request Details' => 'Rincian permintaan',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'Menampilkan atau menyembunyikan konten',
        'Clear debug log' => 'Membersihkan kesalahan logaritma',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'Hapus invoker',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'Hapus kunci pemetaan',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Hapu operasi ini',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Layanan web klon',
        'Delete operation' => 'Hapus operasi',
        'Delete invoker' => 'Hapus peminta',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'PERINGATAN: Bila anda mengubah nama grup \'admin\', sebelum membuat perubahan yang sesuai dalam sysconfig, Anda akan terkunci keluar dari panel administrasi! Jika hal ini terjadi, silakan mengubah nama grup kembali ke admin per pernyataan SQL',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Apakah anda ingin menghapus pemberitahuan bahasa?',
        'Do you really want to delete this notification?' => 'Apakah anda ingin menghapuskan pemberitahuan?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '',
        'No response from get package upgrade result.' => '',
        'Update all packages' => '',
        'Dismiss' => 'Memberhentikan',
        'Update All Packages' => '',
        'No response from package upgrade all.' => '',
        'Currently not possible' => '',
        'This is currently disabled because of an ongoing package upgrade.' =>
            '',
        'This option is currently disabled because the OTRS Daemon is not running.' =>
            '',
        'Are you sure you want to update all installed packages?' => '',
        'No response from get package upgrade run status.' => '',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => '',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'Membuang entiti dari kanvas',
        'No TransitionActions assigned.' => 'Tidak ada TransitionActions ditetapkan.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Tidak ada dialog ditugaskan. Hanya memilih dialog aktivitas dari daftar di sebelah kiri dan tarik di sini.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Aktivitas start ini tidak dapat dihapus dari aktivitas',
        'Remove the Transition from this Process' => 'Membuang transisi dari proses ini',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Gunakan tombol atau link dengan segera, Anda akan meninggalkan layar ini dan kondisi saat ini akan disimpan secara otomatis. Apakah Anda ingin melanjutkan?',
        'Delete Entity' => 'Menghapus entity',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Aktivitas ini telah digunakan dalam proses. Anda tidak bisa menambahkannya lagi',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Transisi terhubung sudah ditempatkan di kanvas. Sambungkan transisi yang ditetapkan terlebih dahulu sebelum menempatkan transisi yang lain.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Transisi ini telah digunakan untuk aktivitas. Anda tidak dapat menggunakannya 2 kali',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'TransitionAction telah digunakan didalam path. Anda tidak bisa menggunakannya 2 kali',
        'Hide EntityIDs' => 'Sembunyikan EntityIDs',
        'Edit Field Details' => 'Ubah rincian fields',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Hantar pembaruan...',
        'Support Data information was successfully sent.' => 'Informasi data dukungan telah berhasil dikirim.',
        'Was not possible to send Support Data information.' => 'Tidak mungkin untuk mengirim informasi data dukungan',
        'Update Result' => 'Pembaruan hasil',
        'Generating...' => 'Menghasilkan',
        'It was not possible to generate the Support Bundle.' => 'Itu tidak mungkin untuk menghasil pendukung berkas',
        'Generate Result' => 'Hasil menghasilkan',
        'Support Bundle' => 'Berkas dukungan',
        'The mail could not be sent' => 'Surat tidak bisa dikirim',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            '',
        'Cannot proceed' => '',
        'Update manually' => '',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            '',
        'Save and update automatically' => '',
        'Don\'t save, update manually' => '',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            '',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Memuat...',
        'Search the System Configuration' => '',
        'Please enter at least one search word to find anything.' => '',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '',
        'Deploy' => '',
        'The deployment is already running.' => '',
        'Deployment successful. You\'re being redirected...' => '',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            '',
        'Reset option is required!' => '',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            '',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            '',
        'Unlock setting.' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'Apakah anda benar-benar ingin menghapus jadwal sistem pemeliharaan?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '',
        'Timeline Month' => '',
        'Timeline Week' => '',
        'Timeline Day' => '',
        'Previous' => 'Sebelumnya',
        'Resources' => '',
        'Su' => 'Minggu',
        'Mo' => 'Senin',
        'Tu' => 'Selasa',
        'We' => 'Rabu',
        'Th' => 'Kamis',
        'Fr' => 'Jumat',
        'Sa' => 'Sabtu',
        'This is a repeating appointment' => '',
        'Would you like to edit just this occurrence or all occurrences?' =>
            '',
        'All occurrences' => '',
        'Just this occurrence' => '',
        'Too many active calendars' => '',
        'Please either turn some off first or increase the limit in configuration.' =>
            '',
        'Restore default settings' => '',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            '',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '',
        'Duplicated entry' => 'Entri duplikat',
        'It is going to be deleted from the field, please try again.' => 'Hal ini akan dihapus dari field, coba lagi.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Tolong masukkan minimal nilai pencarian or * untuk penemuan apapun.',

        # JS File: Core.Agent.Daemon
        'Information about the OTRS Daemon' => 'Informasi yang mengenai Daemon OTRS',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Silahkan periksa bidang yang ditandai sebagai warna merah untuk pemasukkan yang sah',
        'month' => 'bulan',
        'Remove active filters for this widget.' => 'Hapuskan filter yang aktif untuk widget ini',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => '',
        'Searching for linkable objects. This may take a while...' => '',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => '',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            '',
        'Do not show this warning again.' => '',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Maaf, tapi anda tidak bisa menonaktifkan semua metode untuk pemberitahuan yang ditandai sebagai wajib.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Maaf, tapi Anda tidak bisa menonaktifkan semua metode untuk pemberitahuan ini.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            '',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Tukarkan ke metode dekstop',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Silahkan hapus perkataan berikut dari pencarian anda sebagaimana tidak dapat dicari',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Apakah anda benar-benar ingin menghapus statistik?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => 'Apakah anda ingin meneruskannya?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '',
        'Delete draft' => '',
        'There are no more drafts available.' => '',
        'It was not possible to delete this draft.' => '',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Filter artikel',
        'Apply' => 'Terapkan',
        'Event Type Filter' => 'Jenis event filter',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Geserkan navigasi bar',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Silahkan matikan metode Compatibillity di Internet Explorer!',
        'Find out more' => '',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Tukarkan ke metode mobile',

        # JS File: Core.App
        'Error: Browser Check failed!' => '',
        'Reload page' => '',
        'Reload page (%ss)' => '',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            '',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'Satu atau lebih eror terjadi',

        # JS File: Core.Installer
        'Mail check successful.' => 'Pemeriksaan surat berhasil',
        'Error in the mail settings. Please correct and try again.' => 'Kesalahan di dalam pengaturan surat. Tolong betulkan dan coba lagi',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Seleksi tanggal terbuka',
        'Invalid date (need a future date)!' => 'Tanggal tidak sah (membutuhkan tanggal yang mendatang)!',
        'Invalid date (need a past date)!' => 'Tanggal tidak sah (membutuhkan tanggal terakhir)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'Tidak tersedia',
        'and %s more...' => 'dan %s lagi',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => 'Hapus semua',
        'Filters' => 'Filter',
        'Clear search' => 'Hapus pencarian',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Apabila anda meninggalkan halam ini, semua jendela yang terbuka akan tertutup, juga!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Sebuah popup layar ini sudah terbuka. Apakah Anda ingin menutupnya dan memuatnya?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Tidak bisa membuka window. Harap menonaktifkan popup bloker untuk aplikasi ini',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => '',
        'Descending sort applied, ' => '',
        'No sort applied, ' => '',
        'sorting is disabled' => '',
        'activate to apply an ascending sort' => '',
        'activate to apply a descending sort' => '',
        'activate to remove the sort' => '',

        # JS File: Core.UI.Table
        'Remove the filter' => '',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'Saat ini tidak ada elemen yang tersedia untuk memilih formulir',

        # JS File: Core.UI
        'Please only select one file for upload.' => '',
        'Sorry, you can only upload one file here.' => '',
        'Sorry, you can only upload %s files.' => '',
        'Please only select at most %s files for upload.' => '',
        'The following files are not allowed to be uploaded: %s' => '',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            '',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            '',
        'No space left for the following files: %s' => '',
        'Available space %s of %s.' => '',
        'Upload information' => '',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            '',

        # JS File: Core.Language.UnitTest
        'yes' => 'ya',
        'no' => 'tidak',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTRSLineChart
        'No Data Available.' => '',

        # JS File: OTRSMultiBarChart
        'Grouped' => 'Grup',
        'Stacked' => 'Ditumpuk',

        # JS File: OTRSStackedAreaChart
        'Stream' => 'Aliran',
        'Expanded' => 'Diperpanjang',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
Pelanggan yang terhormat,

Sayangnya kami tidak bisa mendeteksi number tiket yang sah
dalam subjek Anda, sehingga email ini tidak dapat processed.

Harap membuat tiket baru melalui panel pelanggan

Terima kasih atas bantuan Anda!

Helpdesk Team Anda
',
        ' (work units)' => '(unit kerja)',
        ' 2 minutes' => '2 menit',
        ' 5 minutes' => '5 menit',
        ' 7 minutes' => '7 menit',
        '"Slim" skin which tries to save screen space for power users.' =>
            '"Slim" kulit yang mencoba untuk menghemat ruang layar untuk tenaga pengguna',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '(Pengguna Masuk) Nama depan Nama akhir',
        '(UserLogin) Lastname Firstname' => '(Pengguna masuk) Nama akhir Nama depan',
        '(UserLogin) Lastname, Firstname' => '(Pengguna Masuk) Nama akhir, Nama pertama',
        '*** out of office until %s (%s d left) ***' => '*** Keluar dari kantor sampai%s (%s tinggal) ***',
        '0 - Disabled' => '',
        '1 - Available' => '',
        '1 - Enabled' => '',
        '10 Minutes' => '',
        '100 (Expert)' => '100 (Ahli)',
        '15 Minutes' => '',
        '2 - Enabled and required' => '',
        '2 - Enabled and shown by default' => '',
        '2 - Enabled by default' => '',
        '2 Minutes' => '',
        '200 (Advanced)' => '200 (Atasan)',
        '30 Minutes' => '',
        '300 (Beginner)' => '300 (Pemula)',
        '5 Minutes' => '',
        'A TicketWatcher Module.' => 'Modul Sebuah TicketWatcher ',
        'A Website' => 'Sebuah situs',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'Daftar bidang dinamis yang bergabung ke dalam tiket utama selama operasi gabungan. Hanya bidang dinamis yang kosong dalam tiket utama akan ditetapkan.',
        'A picture' => 'Sebuah gambar',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL modul yang memungkinkan penutupan tiket orangtua hanya jika semua anak-anaknya sudah ditutup ("State"  yang menyatakan tidak tersedia untuk tiket orangtua sampai semua tiket anak ditutup).',
        'Access Control Lists (ACL)' => 'Access Control Lists (ACL)',
        'AccountedTime' => 'Catatanwaktu',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Mengaktifkan mekanisme berkedip dari antrian yang berisi tiket tertua.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Mengaktifkan kehilangan fitur password untuk agen, dalam antarmuka agen.',
        'Activates lost password feature for customers.' => 'Akan mengaktifkan kehilangan fitur password untuk pelanggan.',
        'Activates support for customer and customer user groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Mengaktifkan artikel saringan dalam tampilan zoom untuk menentukan artikel harus ditampilkan.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Mengaktifkan tema yang tersedia pada sistem. Nilai 1 berarti aktif, 0 berarti tidak aktif.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Mengaktifkan sistem pencarian arsip tiket di antarmuka pelanggan.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Mengaktifkan sistem arsip tiket untuk memiliki sistem yang lebih cepat dengan memindahkan beberapa tiket keluar dari ruang lingkup sehari-hari. Untuk mencari tiket ini, bendera arsip harus diaktifkan dalam pencarian tiket.',
        'Activates time accounting.' => 'Mengaktifkan akuntansi waktu.',
        'ActivityID' => 'ActivityID',
        'Add a note to this ticket' => 'Tambahkan catatan pada tiket ini',
        'Add an inbound phone call to this ticket' => 'Tambahkan panggilan telepon masuk ke tiket ini',
        'Add an outbound phone call to this ticket' => 'Tambahkan panggilan telepon keluar untuk tiket ini',
        'Added %s time unit(s), for a total of %s time unit(s).' => '',
        'Added email. %s' => 'Tambahkan email. %s',
        'Added follow-up to ticket [%s]. %s' => '',
        'Added link to ticket "%s".' => 'Ditambahkan Link ke tiket "%s".',
        'Added note (%s).' => '',
        'Added phone call from customer.' => '',
        'Added phone call to customer.' => '',
        'Added subscription for user "%s".' => 'Ditambahkan langganan bagi pengguna "%s".',
        'Added system request (%s).' => '',
        'Added web request from customer.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Menambahkan akhiran dengan tahun aktual dan bulan ke file log OTRS. Sebuah file log untuk setiap bulan akan dibuat.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Menambahkan pelanggan email alamat ke penerima di layar compose tiket dari antarmuka agen. Alamat pelanggan email tidak akan ditambahkan jika jenis artikel adalah email-internal.',
        'Adds the one time vacation days for the indicated calendar.' => '',
        'Adds the one time vacation days.' => '',
        'Adds the permanent vacation days for the indicated calendar.' =>
            '',
        'Adds the permanent vacation days.' => '',
        'Admin' => 'Admin',
        'Admin Area.' => 'Admin Area',
        'Admin Notification' => 'Notifikasi admin',
        'Admin area navigation for the agent interface.' => '',
        'Admin modules overview.' => '',
        'Admin.' => 'Admin.',
        'Administration' => 'Administrasi',
        'Agent Customer Search' => '',
        'Agent Customer Search.' => '',
        'Agent Name' => 'Nama agen',
        'Agent Name + FromSeparator + System Address Display Name' => 'Agen Nama + Dari Separator + Sistem Alamat Nama Tampilan',
        'Agent Preferences.' => 'Preferensi agen.',
        'Agent Statistics.' => '',
        'Agent User Search' => '',
        'Agent User Search.' => '',
        'Agent interface article notification module to check PGP.' => 'Agen modul artikel antarmuka pemberitahuan untuk memeriksa PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Agen modul artikel antarmuka pemberitahuan untuk memeriksa S/MIME.',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'modul antarmuka agen untuk mengakses CIC pencarian melalui nav bar. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan kunci "Group" dan konten seperti "rw:group1;move_into:group2".',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'modul antarmuka agen untuk mengakses pencarian teks penuh untuk navbar. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan kunci "Group" dan konten seperti "rw:group1;move_into:group2".',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'modul antarmuka agen untuk mengakses profil pencarian melalui navbar. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2".',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'modul antarmuka agen untuk memeriksa email yang masuk di Ticket-Zoom-View jika S/MIME-key tersedia dan benar.',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agen modul pemberitahuan antarmuka untuk melihat jumlah tiket yang terkunci. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agen modul pemberitahuan antarmuka untuk melihat jumlah tiket agen bertanggung jawab untuk. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agen modul pemberitahuan antarmuka untuk melihat jumlah tiket di Layanan saya. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti  "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agen modul pemberitahuan antarmuka untuk melihat jumlah tiket yang ditonton. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "group" dan konten seperti "rw:group1;move_into:group2".',
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            '',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            '',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            '',
        'Agents ↔ Groups' => '',
        'Agents ↔ Roles' => '',
        'All CustomerIDs of a customer user.' => '',
        'All attachments (OTRS Business Solution™)' => '',
        'All customer users of a CustomerID' => 'Semua pengguna pelanggan dari ID Pelanggan',
        'All escalated tickets' => 'Semua tiket yang telah tereskalasi',
        'All new tickets, these tickets have not been worked on yet' => 'Semua tiket baru, tiket-tiket ini belum dikerjakan.',
        'All open tickets, these tickets have already been worked on.' =>
            '',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Semua tiket dengan pengingat yang telah diatur dimana tanggal pengingat telah tercapai',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Memungkinkan menambahkan catatan di layar tiket penutupan antarmuka agen. Dapat ditimpa oleh Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Memungkinkan menambahkan catatan dalam tiket layar teks bebas dari antarmuka agen. Dapat ditimpa oleh Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Memungkinkan menambahkan catatan di layar catatan tiket dari antarmuka agen. Dapat ditimpa oleh Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Memungkinkan menambahkan catatan di layar pemilik tiket dari tiket yang diperbesar di antarmuka agen. Dapat ditimpa oleh Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Memungkinkan menambahkan catatan dalam tiket tertunda layar tiket diperbesar dalam antarmuka agen. Dapat ditimpa oleh Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Memungkinkan menambahkan catatan di layar prioritas tiket dari tiket yang diperbesar di antarmuka agen. Dapat ditimpa oleh Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Memungkinkan menambahkan catatan dalam tiket layar yang bertanggung jawab dari antarmuka agen. Dapat ditimpa oleh Ticket::Frontend::NeedAccountedTime.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Memungkinkan agen untuk mengubah sumbu bintang jika mereka menghasilkan satu.',
        'Allows agents to generate individual-related stats.' => 'Memungkinkan agen untuk menghasilkan statistik individu terkait.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Memungkinkan memilih antara menampilkan lampiran dari tiket di browser (inline) atau hanya membuat mereka download (attachment).',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Memungkinkan memilih negara compose berikutnya untuk tiket pelanggan dalam antarmuka pelanggan.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Memungkinkan pelanggan untuk mengubah prioritas tiket di antarmuka pelanggan.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Memungkinkan pelanggan untuk mengatur SLA tiket di antarmuka pelanggan.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Memungkinkan pelanggan untuk mengatur prioritas tiket di antarmuka pelanggan.',
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Memungkinkan pelanggan untuk mengatur layanan tiket di antarmuka pelanggan.',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            'Memungkinkan layanan default yang dipilih juga untuk pelanggan non ada.',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Memungkinkan mendefinisikan layanan dan SLA tiket (e. G. Email, desktop, jaringan, ...), dan eskalasi atribut untuk SLA (jika layanan tiket / fitur SLA diaktifkan).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Memungkinkan kondisi pencarian diperpanjang mencari tiket dari antarmuka agen generik. Dengan fitur ini Anda dapat mencari e. g. title tiket dengan jenis kondisi seperti "(* key1 * && * key2 *)" atau "(* key1 * || * key2 *)".',
        'Allows generic agent to execute custom command line scripts.' =>
            '',
        'Allows generic agent to execute custom modules.' => '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Memungkinkan memiliki gambaran format medium tiket (CustomerInfo => 1 - menunjukkan juga informasi pelanggan).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Memungkinkan memiliki gambaran format kecil tiket (CustomerInfo => 1 - menunjukkan juga informasi pelanggan).',
        'Allows invalid agents to generate individual-related stats.' => 'Memungkinkan agen yang tidak valid untuk menghasilkan statistik individu terkait.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Memungkinkan administrator untuk login sebagai pelanggan lain, melalui panel administrasi pengguna pelanggan.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Memungkinkan administrator untuk login sebagai pengguna lain, melalui panel pengguna administrasi.',
        'Allows to save current work as draft in the close ticket screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the email outbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket compose screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket forward screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket free text screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket move screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket note screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket owner screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket pending screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket priority screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket responsible screen of the agent interface.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Memungkinkan untuk mengatur keadaan tiket baru di layar bergerak tiket dari antarmuka agen.',
        'Always show RichText if available' => 'Selalu menampilkan Rich Text jika tersedia',
        'Answer' => 'Jawab',
        'Appointment Calendar overview page.' => '',
        'Appointment Notifications' => '',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            '',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            '',
        'Appointment edit screen.' => '',
        'Appointment list' => '',
        'Appointment list.' => '',
        'Appointment notifications' => '',
        'Appointments' => '',
        'Arabic (Saudi Arabia)' => 'Arab (Saudi Arabia)',
        'ArticleTree' => 'ArticleTree',
        'Attachment Name' => 'Lampirkan nama',
        'Automated line break in text messages after x number of chars.' =>
            'Baris istirahat otomatis dalam pesan teks setelah x jumlah karakter.',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'Mengunci secara otomatis dan mengatur pemilik untuk Agen saat setelah membuka layar tiket bergerak dari antarmuka agen.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Mengunci secara otomatis dan mengatur pemilik untuk Agen saat setelah memilih untuk Aksi Massal.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            'Secara otomatis menetapkan pemilik tiket sebagai yang bertanggung jawab untuk itu (jika tiket fitur bertanggung jawab diaktifkan). Ini hanya akan bekerja secara manual tindakan login pengguna. Ini tidak bekerja untuk tindakan otomatis mis Generik Agen, Postmaster dan generik Interface.',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Secara otomatis set yang bertanggung jawab dari tiket (jika tidak diatur belum) setelah update pemilik pertama.',
        'Avatar' => '',
        'Balanced white skin by Felix Niklas (slim version).' => 'kulit putih yang seimbang oleh Felix Niklas (versi slim).',
        'Balanced white skin by Felix Niklas.' => 'kulit putih yang seimbang oleh Felix Niklas ',
        'Based on global RichText setting' => 'Berdasarkan pengaturan global Rich Text ',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Blok semua email masuk yang tidak memiliki nomor tiket yang valid dalam subjek dengan Dari: @ example.com sebagai alamat email',
        'Bounced to "%s".' => 'Terpental ke "%s".',
        'Bulgarian' => 'Bulgaria',
        'Bulk Action' => 'Tindakan masal',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'CMD contoh setup. Mengabaikan email mana CMD eksternal kembali output dari STDOUT (email akan disalurkan ke STDIN dari some.bin).',
        'CSV Separator' => 'Pemisah CSV',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Waktu cache di detik untuk otentikasi agen di Generic Interface.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Waktu cache di detik untuk otentikasi pelanggan dalam Generic Interface.',
        'Cache time in seconds for the DB ACL backend.' => 'Waktu tembolok di detik untuk review otentikasi pelanggan hearts Generic Interface.',
        'Cache time in seconds for the DB process backend.' => 'Waktu cache di detik untuk proses backend DB.',
        'Cache time in seconds for the SSL certificate attributes.' => 'Waktu cache di detik untuk atribut sertifikat SSL.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'Waktu cache di detik untuk proses tiket navigasi modul output.',
        'Cache time in seconds for the web service config backend.' => 'Waktu cache di detik untuk layanan web config backend.',
        'Calendar manage screen.' => '',
        'Catalan' => 'Catalan',
        'Change password' => 'Ganti kata sandi',
        'Change queue!' => 'Perubahan antrian!',
        'Change the customer for this ticket' => 'Mengubah pelanggan untuk tiket ini',
        'Change the free fields for this ticket' => 'Mengubah bidang gratis untuk tiket ini',
        'Change the owner for this ticket' => 'Ubah pemilik tiket ini',
        'Change the priority for this ticket' => 'Mengubah tingkat prioritas untuk tiket ini',
        'Change the responsible for this ticket' => 'Mengubah ertanggung jawaban untuk tiket ini',
        'Change your avatar image.' => '',
        'Change your password and more.' => '',
        'Changed SLA to "%s" (%s).' => '',
        'Changed archive state to "%s".' => '',
        'Changed customer to "%s".' => '',
        'Changed dynamic field %s from "%s" to "%s".' => '',
        'Changed owner to "%s" (%s).' => '',
        'Changed pending time to "%s".' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Ubah prioritas dari "%s" (%s) untuk "%s" (%s).',
        'Changed queue to "%s" (%s) from "%s" (%s).' => '',
        'Changed responsible to "%s" (%s).' => '',
        'Changed service to "%s" (%s).' => '',
        'Changed state from "%s" to "%s".' => '',
        'Changed title from "%s" to "%s".' => '',
        'Changed type from "%s" (%s) to "%s" (%s).' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Mengubah pemilik tiket untuk semua orang (berguna untuk ASP). Biasanya hanya agen dengan izin rw dalam antrian tiket akan ditampilkan.',
        'Chat communication channel.' => '',
        'Checkbox' => 'Kotak centang',
        'Checks for articles that needs to be updated in the article search index.' =>
            '',
        'Checks for communication log entries to be deleted.' => '',
        'Checks for queued outgoing emails to be sent.' => '',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            'Cek jika E-Mail merupakan tindak lanjut ke tiket yang ada dengan mencari subjek untuk sejumlah tiket yang sah.',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            '',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            'Cek ketersediaan OTRS Business Solution™ untuk sistem ini.',
        'Checks the entitlement status of OTRS Business Solution™.' => 'Memeriksa status hak dari OTRS Business Solution™.',
        'Child' => 'Child',
        'Chinese (Simplified)' => 'Bahasa Tiongkok (yang disederhanakan)',
        'Chinese (Traditional)' => 'Cina (tradisional)',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            '',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '',
        'Choose which notifications you\'d like to receive.' => '',
        'Christmas Eve' => 'Malam natal',
        'Close' => 'Tutup',
        'Close this ticket' => 'Tutup tiket ini',
        'Closed tickets (customer user)' => 'Tiket tertutup (customer pengguna)',
        'Closed tickets (customer)' => 'Tiket tertutup (pelanggan)',
        'Cloud Services' => 'Layanan Cloud',
        'Cloud service admin module registration for the transport layer.' =>
            'Layanan modul pendaftaran cloud admin untuk transpor layer',
        'Collect support data for asynchronous plug-in modules.' => 'Mengumpulkan data dukungan untuk modul plugin asynchronous.',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Filter tiket kolom untuk Ticket Ikhtisar Jenis "Kecil".',
        'Columns that can be filtered in the escalation view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => 'Komentar untuk entri sejarah baru di antarmuka pelanggan.',
        'Comment2' => 'Komen',
        'Communication' => 'Komunikasi',
        'Communication & Notifications' => '',
        'Communication Log GUI' => '',
        'Communication log limit per page for Communication Log Overview.' =>
            '',
        'CommunicationLog Overview Limit' => '',
        'Company Status' => 'Status perusahaan',
        'Company Tickets.' => 'Tiket perusahaan',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Nama perusahaan yang akan dimasukkan dalam email keluar sebagai X-header.',
        'Compat module for AgentZoom to AgentTicketZoom.' => 'Modul compat untuk Agen Zoom ke Agen Tiket Zoom.',
        'Complex' => 'Rumits',
        'Compose' => 'Susun',
        'Configure Processes.' => 'Proses konfigurasi',
        'Configure and manage ACLs.' => 'Konfigurasi dan mengatus ACLs',
        'Configure any additional readonly mirror databases that you want to use.' =>
            'Konfigurasi tambahan hanya membaca database cermin yang ingin Anda gunakan.',
        'Configure sending of support data to OTRS Group for improved support.' =>
            'Mengkonfigurasi pengiriman data dukungan untuk OTRS Group untuk meningkatkan dukungan.',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'Konfigurasi yang layar harus ditampilkan setelah tiket baru telah dibuat.',
        'Configure your own log text for PGP.' => 'Mengkonfigurasi teks log Anda sendiri untuk PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otrs.com/doc/), chapter "Ticket Event Module".' =>
            'Mengkonfigurasi TicketDynamicField pengaturan default. "Nama" mendefinisikan bidang yang dinamis yang harus digunakan, "Value" adalah data yang akan ditetapkan, dan "Event" mendefinisikan acara pemicu. Silakan periksa pengembang user (https://doc.otrs.com/doc/), bab "Ticket acara Modul".',
        'Controls how to display the ticket history entries as readable values.' =>
            'Kontrol bagaimana menampilkan entri sejarah tiket sebagai nilai-nilai yang dapat dibaca.',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Kontrol jika pelanggan memiliki kemampuan untuk memilah tiket mereka.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Kontrol jika lebih dari satu dari entri dapat diatur dalam tiket ponsel baru di antarmuka agen.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'Kontrol jika admin diperbolehkan untuk mengimpor konfigurasi menyelamatkan sistem di sysconfig.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'Kontrol jika admin diperbolehkan untuk membuat perubahan ke database melalui Admin Pilih Box.',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Kontrol jika bendera tiket dan artikel dilihat dikeluarkan ketika tiket diarsipkan.',
        'Converts HTML mails into text messages.' => 'Mengkonversi mail HTML dalam pesan teks.',
        'Create New process ticket.' => 'Membuat tiket proses Baru.',
        'Create Ticket' => '',
        'Create a new calendar appointment linked to this ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Membuat dan mengelola Service Level Agreements (SLA).',
        'Create and manage agents.' => 'Membuat dan mengelola agen.',
        'Create and manage appointment notifications.' => '',
        'Create and manage attachments.' => 'Membuat dan mengelola lampiran.',
        'Create and manage calendars.' => '',
        'Create and manage customer users.' => 'Membuat dan mengelola pengguna pelanggan.',
        'Create and manage customers.' => 'Membuat dan mengelola pelanggan.',
        'Create and manage dynamic fields.' => 'Membuat dan mengelola bidang dinamis.',
        'Create and manage groups.' => 'Membuat dan mengelola kelompok.',
        'Create and manage queues.' => 'Membuat dan mengelola antrian.',
        'Create and manage responses that are automatically sent.' => 'Membuat dan mengelola respon yang secara otomatis dikirim.',
        'Create and manage roles.' => 'Membuat dan mengelola peran.',
        'Create and manage salutations.' => 'Membuat dan mengelola salutasi',
        'Create and manage services.' => 'Membuat dan mengelola layanan.',
        'Create and manage signatures.' => 'Membuat dan mengelola tanda tangan.',
        'Create and manage templates.' => 'Membuat dan mengelola template.',
        'Create and manage ticket notifications.' => 'Membuat dan mengelola pemberitahuan tiket.',
        'Create and manage ticket priorities.' => 'Membuat dan mengelola prioritas tiket.',
        'Create and manage ticket states.' => 'Membuat dan mengelola state tiket',
        'Create and manage ticket types.' => 'Membuat dan mengelola jenis tiket.',
        'Create and manage web services.' => 'Membuat dan mengelola layanan web.',
        'Create new Ticket.' => 'Buat Tiket baru.',
        'Create new appointment.' => '',
        'Create new email ticket and send this out (outbound).' => 'Membuat tiket email baru dan mengirimkan ini keluar (outbound).',
        'Create new email ticket.' => 'Membuat tiket email baru.',
        'Create new phone ticket (inbound).' => 'Membuat tiket ponsel baru (masuk).',
        'Create new phone ticket.' => 'Membuat tiket ponsel baru.',
        'Create new process ticket.' => 'Membuat tiket proses baru.',
        'Create tickets.' => 'Membuat tiket ',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            '',
        'Croatian' => 'Kroasia',
        'Custom RSS Feed' => 'Kustom RSS feed',
        'Custom RSS feed.' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'Kustom teks untuk halaman ditampilkan kepada pelanggan yang tidak memiliki tiket (jika Anda perlu teks yang diterjemahkan menambahkannya ke modul terjemahan khusus).',
        'Customer Administration' => 'Administrasi pelanggan',
        'Customer Companies' => 'Perusahaan Pelanggan',
        'Customer IDs' => '',
        'Customer Information Center Search.' => 'Pelanggan Pusat Informasi Cari.',
        'Customer Information Center search.' => '',
        'Customer Information Center.' => 'Pusat Informasi pelanggan.',
        'Customer Ticket Print Module.' => 'Tiket pelanggan Print Modul.',
        'Customer User Administration' => 'Administrasi Nasabah Pengguna',
        'Customer User Information' => '',
        'Customer User Information Center Search.' => '',
        'Customer User Information Center search.' => '',
        'Customer User Information Center.' => '',
        'Customer Users ↔ Customers' => '',
        'Customer Users ↔ Groups' => '',
        'Customer Users ↔ Services' => '',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Item pelanggan (icon) yang menunjukkan tiket tertutup pelanggan ini sebagai informasi blok. Pengaturan Pengguna Khusus Login ke 1 pencarian tiket berdasarkan nama login dan bukan ID Pelanggan.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Item pelanggan (icon) yang menunjukkan tiket terbuka pelanggan ini sebagai informasi blok. Pengaturan Pengguna Khusus Login ke 1 pencarian tiket berdasarkan nama login dan bukan ID Pelanggan.',
        'Customer preferences.' => 'preferensi pelanggan.',
        'Customer ticket overview' => 'Keseluruhan tiket pelanggan',
        'Customer ticket search.' => 'pencarian tiket pelanggan.',
        'Customer ticket zoom' => 'zoom tiket pelanggan',
        'Customer user search' => 'Pelanggan pencarian pengguna',
        'CustomerID search' => 'ID pelanggan pencarian',
        'CustomerName' => 'Nama Pelanggan',
        'CustomerUser' => 'nasabah Pengguna',
        'Customers ↔ Groups' => '',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            'kata berhenti disesuaikan untuk indeks fulltext. Kata-kata ini akan dihapus dari indeks pencarian.',
        'Czech' => 'Bahasa Ceko',
        'Danish' => 'Denmark',
        'Dashboard overview.' => '',
        'Data used to export the search result in CSV format.' => 'Data yang digunakan untuk mengekspor hasil pencarian dalam format CSV.',
        'Date / Time' => 'Tanggal / Waktu',
        'Default (Slim)' => 'Default (Slim)',
        'Default ACL values for ticket actions.' => 'Nilai default ACL untuk tindakan tiket.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Proses Manajemen awalan entitas default untuk ID entitas yang secara otomatis dihasilkan.',
        'Default agent name' => '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'default data digunakan pada atribut untuk layar pencarian tiket. Contoh: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'default data digunakan pada atribut untuk layar pencarian tiket. Contoh: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'Jenis tampilan default untuk penerima (To, Cc) nama dalam AgentTicketZoom dan CustomerTicketZoom.',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'display Jenis default untuk jenis kelamin (Dari) nama di Agen Tiket Zoom dan TicketZoom Pelanggan.',
        'Default loop protection module.' => 'Default lingkaran modul ',
        'Default queue ID used by the system in the agent interface.' => 'ID antrian default yang digunakan oleh sistem dalam antarmuka agen.',
        'Default skin for the agent interface (slim version).' => 'kulit default untuk antarmuka agen (versi slim).',
        'Default skin for the agent interface.' => 'kulit default untuk antarmuka agen.',
        'Default skin for the customer interface.' => 'Default skin untuk antarmuka pelanggan',
        'Default ticket ID used by the system in the agent interface.' =>
            'ID tiket default yang digunakan oleh sistem dalam antarmuka agen.',
        'Default ticket ID used by the system in the customer interface.' =>
            'ID tiket default yang digunakan oleh sistem dalam antarmuka pelanggan.',
        'Default value for NameX' => 'Nilai default untuk nama',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            'Tentukan Tindakan adalah tombol pengaturan tersedia di objek widget terkait (LinkObject::ViewMode = "complex"). Harap dicatat bahwa Tindakan ini harus telah mendaftarkan berikut JS dan CSS file: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Tentukan filter untuk output html untuk menambahkan link balik string yang didefinisikan. Elemen Gambar memungkinkan dua jenis masukan. Sekaligus nama dari suatu gambar (misalnya faq.png). Dalam hal ini path gambar OTRS akan digunakan. Kemungkinan kedua adalah untuk memasukkan link ke gambar.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Menentukan nama field dinamis untuk waktu akhir. Bidang ini harus secara manual ditambahkan ke sistem sebagai Tiket: "Date / Time" dan harus diaktifkan dalam layar pembuatan tiket dan/atau dalam layar tindakan tiket lainnya.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Menentukan nama field dinamis untuk waktu mulai. Bidang ini harus secara manual ditambahkan ke sistem sebagai Ticket: "Date/Time" dan harus diaktifkan dalam layar pembuatan tiket dan / atau dalam layar tindakan tiket lainnya.',
        'Define the max depth of queues.' => 'Tentukan max kedalaman antrian.',
        'Define the queue comment 2.' => 'Tentukan max kedalaman antrian.',
        'Define the service comment 2.' => 'Mendefinisikan layanan komentar 2.',
        'Define the sla comment 2.' => 'Tentukan sla komentar 2.',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            'Tentukan hari awal pekan ini untuk pemilih tanggal kalender yang telah ditunjukkan.',
        'Define the start day of the week for the date picker.' => 'Tentukan hari awal pekan ini untuk datepicker.',
        'Define which avatar default image should be used for the article view if no gravatar is assigned to the mail address. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar default image should be used for the current agent if no gravatar is assigned to the mail address of the agent. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar engine should be used for the agent avatar on the header and the sender images in AgentTicketZoom. If \'None\' is selected, initials will be displayed instead. Please note that selecting anything other than \'None\' will transfer the encrypted email address of the particular user to an external service.' =>
            '',
        'Define which columns are shown in the linked appointment widget (LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Mendefinisikan item pelanggan, yang menghasilkan ikon LinkedIn di ujung blok Info pelanggan.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Mendefinisikan item pelanggan, yang menghasilkan ikon XING di ujung blok Info pelanggan.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Mendefinisikan item pelanggan, yang menghasilkan ikon google di ujung blok Info pelanggan.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Mendefinisikan item pelanggan, yang menghasilkan ikon peta google di ujung blok Info pelanggan.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Mendefinisikan sebuah filter untuk output html untuk menambahkan link balik nomor CVE. Elemen Gambar memungkinkan dua jenis masukan. Sekaligus nama dari suatu gambar (misal faq.png). Dalam hal ini path gambar OTRS akan digunakan. Kemungkinan kedua adalah untuk memasukkan link ke gambar.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Mendefinisikan sebuah filter untuk output html untuk menambahkan link balik nomor MS Bulletin. Elemen Gambar memungkinkan dua jenis masukan. Sekaligus nama dari suatu gambar (misalnya faq.png). Dalam hal ini path gambar OTRS akan digunakan. Kemungkinan kedua adalah untuk memasukkan link ke gambar.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Mendefinisikan sebuah filter untuk output html untuk menambahkan link dimana bisa mendefinisikan string. Elemen Gambar memungkinkan dua jenis masukan. Sekaligus nama dari suatu gambar (misal faq.png). Dalam hal ini path gambar OTRS akan digunakan. Kemungkinan kedua adalah untuk memasukkan link ke gambar.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Mendefinisikan sebuah filter untuk output html untuk menambahkan link balik nomor bugtraq. Elemen Gambar memungkinkan dua jenis masukan. Sekaligus nama dari suatu gambar (misal faq.png). Dalam hal ini path gambar OTRS akan digunakan. Kemungkinan keduanya adalah untuk memasukkan link ke gambar',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            'Mendefinisikan sebuah filter untuk mengumpulkan nomor CVE dari teks artikel di AgentTicketZoom. Hasilnya akan ditampilkan dalam meta kotak di samping artikel. Isi URLPreview jika Anda ingin melihat pratinjau ketika memindahkan kursor mouse Anda di atas elemen link. Ini bisa menjadi URL yang sama seperti di URL, tetapi juga salah satu alternatif. Harap dicatat bahwa beberapa situs menyangkal ditampilkan dalam iframe (misalnya Google) dan dengan demikian tidak akan bekerja dengan modus pratinjau.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Mendefinisikan sebuah filter untuk memproses teks dalam artikel, dalam rangka untuk menyoroti kata kunci yang telah ditetapkan.',
        'Defines a permission context for customer to group assignment.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Mendefinisikan ekspresi reguler yang mengecualikan beberapa alamat dari cek sintaks (jika "CheckEmailAddresses" diatur ke "Ya"). Masukkan regex di bidang ini untuk alamat email, yang tidak sintaksis valid, tetapi diperlukan untuk sistem (yaitu "root @ localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Mendefinisikan ekspresi reguler yang menyaring semua alamat email yang tidak boleh digunakan dalam aplikasi.',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            'Mendefinisikan waktu tidur di mikrodetik antara tiket sementara mereka telah diproses oleh pekerjaan.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Mendefinisikan modul yang berguna untuk memuat pilihan pengguna tertentu atau untuk menampilkan berita.',
        'Defines all the X-headers that should be scanned.' => 'Mendefinisikan semua X-header yang harus dipindai.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            'Mendefinisikan semua bahasa yang tersedia untuk aplikasi. Tentukan nama Inggris hanya bahasa di sini.',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            'Mendefinisikan semua bahasa yang tersedia untuk aplikasi. Tentukan hanya nama asli bahasa di sini.',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Mendefinisikan semua parameter untuk objek, Segarkan Waktu dalam preferensi pelanggan antarmuka pelanggan.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Mendefinisikan semua parameter untuk menunjukkan tiket obyek dalam preferensi pelanggan antarmuka pelanggan.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Mendefinisikan semua parameter untuk item ini dalam preferensi pelanggan.',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            'Mendefinisikan semua parameter untuk item ini dalam preferensi pelanggan. \'PasswordRegExp\' memungkinkan untuk mencocokkan password terhadap ekspresi reguler. Menentukan jumlah minimum karakter menggunakan \'PasswordMinSize\'. Tentukan jika setidaknya 2 huruf kecil dan 2 karakter huruf besar dibutuhkan dengan menetapkan pilihan yang sesuai untuk \'1\'. \'PasswordMin2Characters\' mendefinisikan jika password harus berisi minimal 2 karakter huruf (set ke 0 atau 1). \'Password Perlu Digit\' mengontrol kebutuhan minimal 1 digit (set ke 0 atau 1 kontrol).',
        'Defines all the parameters for this notification transport.' => 'Mendefinisikan semua parameter untuk transportasi pemberitahuan ini.',
        'Defines all the possible stats output formats.' => 'Mendefinisikan semua kemungkinan format statistik output.',
        'Defines an alternate URL, where the login link refers to.' => 'Mendefinisikan URL alternatif, di mana link login mengacu pada.',
        'Defines an alternate URL, where the logout link refers to.' => 'Mendefinisikan URL alternatif, di mana link logout mengacu pada.',
        'Defines an alternate login URL for the customer panel..' => 'Mendefinisikan sebuah URL masuk alternatif untuk panel pelanggan',
        'Defines an alternate logout URL for the customer panel.' => 'endefinisikan sebuah URL logout secara alternatif untuk panel pelanggan.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'Mendefinisikan link eksternal ke database pelanggan (misalnya \'http://yourhost/customer.php?CID=[% Data.Customer ID%]\' atau \'\').',
        'Defines an icon with link to the google map page of the current location in appointment edit screen.' =>
            '',
        'Defines an overview module to show the address book view of a customer user list.' =>
            '',
        'Defines available article actions for Chat articles.' => '',
        'Defines available article actions for Email articles.' => '',
        'Defines available article actions for Internal articles.' => '',
        'Defines available article actions for Phone articles.' => '',
        'Defines available article actions for invalid articles.' => '',
        'Defines available groups for the admin overview screen.' => '',
        'Defines chat communication channel.' => '',
        'Defines default headers for outgoing emails.' => '',
        'Defines email communication channel.' => '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Mendefinisikan dari mana atribut tiket agen dapat memilih urutan hasil.',
        'Defines groups for preferences items.' => '',
        'Defines how many deployments the system should keep.' => '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Mendefinisikan bagaimana  \'lapangan/field\' dari email (dikirim dari jawaban dan tiket email) akan terlihat seperti yang ditetapkan',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'Mendefinisikan jika pra-pemilahan berdasarkan prioritas harus dilakukan dalam tampilan antrian.',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            'Mendefinisikan jika pra-pemilahan berdasarkan prioritas harus dilakukan dalam tampilan layanan.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan di layar tiket penutupan antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan di layar keluar email dari antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan di layar bouncing tiket dari antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan di layar compose tiket dari antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan dalam tiket layar depan dari antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan dalam tiket layar teks bebas dari antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan di layar merge tiket dari tiket yang diperbesar di antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan di layar catatan tiket dari antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan di layar pemilik tiket dari tiket yang diperbesar di antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan di layar tiket tertunda tiket diperbesar dalam antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan dalam ponsel tiket layar masuk dari interface agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan di layar keluar ponsel tiket dari antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan di layar prioritas tiket dari tiket yang diperbesar di antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan dalam tiket layar yang bertanggung jawab dari antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mendefinisikan jika kunci tiket diperlukan untuk mengubah pelanggan tiket di antarmuka agen (jika tiket tidak terkunci lagi, tiket akan terkunci dan agen saat ini akan diatur secara otomatis sebagai pemiliknya).',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Mendefinisikan jika agen harus diizinkan untuk login jika mereka tidak memiliki rahasia bersama disimpan dalam preferensi mereka dan oleh karena itu tidak menggunakan 2 faktor yang otentik',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Mendefinisikan jika pelanggan harus diizinkan untuk login jika mereka tidak memiliki rahasia bersama disimpan dalam preferensi mereka dan oleh karena itu tidak menggunakan otentikasi dua faktor.',
        'Defines if the communication between this system and OTRS Group servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'Mendefinisikan jika modus ditingkatkan harus digunakan (memungkinkan penggunaan tabel, mengganti, subscript, superscript, pasta dari kata, dll).',
        'Defines if the first article should be displayed as expanded, that is visible for the related customer. If nothing defined, latest article will be expanded.' =>
            '',
        'Defines if the message in the email outbound screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the email resend screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the ticket compose screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the ticket forward screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the close ticket screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket bulk screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket free text screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket note screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket owner screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket pending screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket priority screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket responsible screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            'Mendefinisikan jika token sebelumnya valid harus diterima untuk otentikasi. Ini adalah sedikit kurang aman tetapi memberikan pengguna 30 detik lebih banyak waktu untuk memasukkan password satu waktu mereka.',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If enabled, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Mendefinisikan jika akuntansi waktu harus ditetapkan untuk semua tiket dalam aksi massal.',
        'Defines internal communication channel.' => '',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            'Mendefinisikan dari pesan kantor Template. Dua parameter String (%s) yang tersedia: tanggal akhir dan jumlah hari yang tersisa.',
        'Defines phone communication channel.' => '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Mendefinisikan antrian bahwa tiket yang digunakan untuk menampilkan sebagai acara kalender.',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Mendefinisikan IP ekspresi reguler untuk mengakses repositori lokal. Anda perlu mengaktifkan ini untuk memiliki akses ke repositori lokal Anda dan Daftar paket::Repository diperlukan pada remote host.',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            '',
        'Defines the URL CSS path.' => 'Mendefinisikan jalur URL CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Mendefinisikan path basis URL ikon, CSS dan Java Script.',
        'Defines the URL image path of icons for navigation.' => 'Mendefinisikan path gambar URL ikon untuk navigasi.',
        'Defines the URL java script path.' => 'Mendefinisikan URL javascript jalan.',
        'Defines the URL rich text editor path.' => 'Mendefinisikan URL kaya jalan editor teks.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Mendefinisikan alamat dari server DNS yang berdedikasi, jika perlu, untuk "Periksa MX Record" pencarian.',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            'Mendefinisikan kunci preferensi agen dimana kunci rahasia disimpan.',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Mendefinisikan body teks untuk kiriman notifikasi dikirim ke pelanggan, tentang akun baru.',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the body text for rejected emails.' => 'Mendefinisikan teks tubuh untuk email yang ditolak.',
        'Defines the calendar width in percent. Default is 95%.' => 'Mendefinisikan lebar kalender persen. Default adalah 95%.',
        'Defines the column to store the keys for the preferences table.' =>
            'Mendefinisikan kolom untuk menyimpan kunci tabel preferensi.',
        'Defines the config options for the autocompletion feature.' => 'Mendefinisikan pilihan konfigurasi untuk fitur autocomplete.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Mendefinisikan parameter konfigurasi dari item ini, akan ditampilkan dalam preferensi tampilan.',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => 'Mendefinisikan koneksi untuk http / ftp, melalui proxy.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            'Mendefinisikan kunci preferensi pelanggan di mana kunci rahasia bersama disimpan.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Mendefinisikan format tanggal input yang digunakan dalam bentuk (pilihan atau masukan bidang).',
        'Defines the default CSS used in rich text editors.' => 'Mendefinisikan CSS default yang digunakan dalam editor teks kaya.',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '',
        'Defines the default auto response type of the article for this operation.' =>
            'Mendefinisikan default jenis respon otomatis dari artikel untuk operasi ini.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Mendefinisikan tubuh default catatan dalam tiket layar teks bebas dari antarmuka agen.',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otrs.com/doc/.' =>
            'Mendefinisikan default front-end (HTML) tema yang akan digunakan oleh agen dan pelanggan. Jika Anda suka, Anda dapat menambahkan tema Anda sendiri. Silahkan lihat manual administrator yang terletak di https://doc.otrs.com/doc/.',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Mendefinisikan bahasa default front-end. Semua nilai yang mungkin ditentukan oleh file bahasa yang tersedia pada sistem (lihat pengaturan berikutnya).',
        'Defines the default history type in the customer interface.' => 'Mendefinisikan jenis sejarah default dalam antarmuka pelanggan.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Mendefinisikan jumlah maksimum default X-axis atribut untuk skala waktu.',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            'Mendefinisikan jumlah maksimum default statistik per halaman pada layar overview.',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            'Mendefinisikan default negara berikutnya tiket setelah pelanggan tindak lanjut dalam antarmuka pelanggan.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Mendefinisikan default state berikutnya tiket setelah menambahkan catatan, di layar tiket penutupan antarmuka agen.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Mendefinisikan default state berikutnya tiket setelah menambahkan catatan, dalam tiket layar teks bebas dari antarmuka agen.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Mendefinisikan default state berikutnya tiket setelah menambahkan catatan, di layar catatan tiket dari antarmuka agen.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Mendefinisikan default state berikutnya tiket setelah menambahkan catatan, di layar pemilik tiket dari tiket yang diperbesar di antarmuka agen.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Mendefinisikan default state berikutnya tiket setelah menambahkan catatan, tiket tertunda dilayar tiket yang diperbesar dalam antarmuka agen.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Mendefinisikan default state berikutnya tiket setelah menambahkan catatan, prioritas tiket dari tiket yang diperbesar di antarmuka agen.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Mendefinisikan default state berikutnya tiket setelah menambahkan catatan, dalam tiket layar yang bertanggung jawab dari antarmuka agen.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Mendefinisikan default berikutnya keadaan tiket setelah memantul, di layar bouncing tiket dari antarmuka agen.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Mendefinisikan default berikutnya keadaan tiket setelah diteruskan, dalam tiket layar depan dari antarmuka agen.',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            'Mendefinisikan default berikutnya keadaan tiket setelah pesan telah dikirim, di layar keluar email dari antarmuka agen.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Mendefinisikan default dalam keadaan berikutnya dari tiket jika itu terdiri/dijawab dalam layar compose tiket dari antarmuka agen.',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Mendefinisikan teks tubuh catatan default untuk tiket telepon di telepon tiket layar masuk dari interface agen.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Mendefinisikan teks tubuh catatan default untuk tiket ponsel di layar keluar ponsel tiket dari antarmuka agen.',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Mendefinisikan prioritas default tiket pelanggan tindak lanjut di layar zoom tiket di antarmuka pelanggan.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Mendefiniskan default prioritas pelanggan tiket baru di antarmuka pelanggan',
        'Defines the default priority of new tickets.' => 'Mendefinisikan default prioritas untuk tiket baru',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Mendefinisikan antrian default untuk pelanggan ticket baru di antarmuka pelanggan',
        'Defines the default queue for new tickets in the agent interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Mendefinisikan pilihan default pada menu drop down untuk objek dinamis (Untuk: Common Spesifikasi).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Mendefinisikan pilihan default pada menu drop down untuk izin (Form: Common Spesifikasi).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Mendefinisikan pilihan default pada menu drop down untuk format statistik (Form: Common Spesifikasi). Silahkan masukkan kunci Format (lihat Statistik::Format).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Mendefinisikan jenis pengirim default untuk tiket telepon di telepon tiket layar masuk dari interface agen.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Mendefinisikan jenis pengirim default untuk tiket ponsel di layar keluar ponsel tiket dari antarmuka agen.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Mendefinisikan jenis pengirim default untuk tiket pesawat di layar zoom tiket dari antarmuka pelanggan.',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            'Mendefinisikan tiket atribut pencarian default ditampilkan untuk layar pencarian tiket (HAllTickets/TiketArchived/NotArchivedTiket).',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Mendefinisikan tiket atribut pencarian default ditampilkan untuk layar pencarian tiket.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'Mendefinisikan tiket atribut pencarian default ditampilkan untuk layar pencarian tiket. Contoh: "Key" harus memiliki nama Lapangan Dinamis dalam hal ini \'X\', "Konten" harus memiliki nilai Bidang Dinamis tergantung pada jenis Bidang Dinamis, Text: \'teks\', Dropdown: \'1\' , Date/Time: \'Search_DynamicField_XTimeSlotStartYear = 1974;
\'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'Mendefinisikan kriteria standar semacam untuk semua antrian ditampilkan dalam tampilan antrian.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            'Mendefinisikan kriteria standar semacam untuk semua layanan yang ditampilkan dalam tampilan layanan.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Mendefinisikan urutan default untuk semua antrian dalam tampilan antrian, setelah prioritas.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            'Mendefinisikan urutan default untuk semua layanan dalam tampilan layanan, setelah  prioritas.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Mendefinisikan keadaan default tiket pelanggan baru di antarmuka pelanggan.',
        'Defines the default state of new tickets.' => 'Mendefinisikan keadaan default tiket baru.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Mendefinisikan subjek default untuk tiket telepon di telepon tiket layar masuk dari antarmuka agen.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Mendefinisikan subjek default untuk tiket ponsel di layar keluar ponsel tiket dari antarmuka agen.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Mendefinisikan subjek default catatan dalam tiket layar teks bebas dari antarmuka agen.',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            'Mendefinisikan default jumlah detik (dari waktu sekarang) untuk kembali ke jadwal-antarmuka yang telah gaga dalaml tugas generik.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Mendefinisikan atribut tiket default untuk tiket yang menyortir dalam pencarian tiket dari antarmuka pelanggan.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Mendefinisikan atribut tiket default untuk tiket menyortir dalam pandangan eskalasi antarmuka agen.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Mendefinisikan atribut tiket default untuk tiket menyortir dalam pandangan tiket terkunci dari antarmuka agen.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Mendefinisikan atribut tiket default untuk tiket menyortir dalam tampilan yang bertanggung jawab dari antarmuka agen.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Mendefinisikan atribut tiket default untuk tiket menyortir dalam tampilan status antarmuka agen.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Mendefinisikan atribut tiket default untuk tiket menyortir dalam tampilan antarmuka agen.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Mendefinisikan atribut tiket default untuk menyortir tiket dari hasil pencarian tiket di antarmuka agen.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'Mendefinisikan atribut tiket default untuk menyortir tiket dari hasil pencarian tiket dari operasi ini.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Mendefinisikan tiket standar memantul pemberitahuan untuk pelanggan/pengirim di layar bouncing tiket dari antarmuka agen.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Mendefinisikan tiket standar negara berikutnya setelah menambahkan catatan telepon di telepon tiket layar masuk dari interface agen.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Mendefinisikan tiket standar negara berikutnya setelah menambahkan catatan telepon di layar keluar ponsel tiket dari antarmuka agen.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Mendefinisikan urutan tiket default (setelah semacam prioritas) dalam pandangan eskalasi antarmuka agen. Up: tertua di atas. Down: terbaru di atas.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Mendefinisikan urutan tiket default (setelah semacam prioritas) dalam tampilan status antarmuka agen. Atas: tertua di atas. Bawah: terbaru di atas.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Mendefinisikan urutan tiket default dalam tampilan yang bertanggung jawab dari antarmuka agen. Atas: tertua di atas. Bawah: terbaru di atas.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Mendefinisikan urutan tiket default di tiket terkunci tampilan antarmuka agen. Atas: tertua di atas. Bawah: terbaru di atas.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Mendefinisikan urutan tiket default dalam hasil pencarian tiket dari antarmuka agen. Atas: tertua di atas. Bawah: terbaru di atas.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            'Mendefinisikan urutan tiket default dalam hasil pencarian tiket dari operasi ini. Atas: tertua di atas. Bawah: terbaru di atas.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Mendefinisikan urutan tiket default dalam menonton tampilan antarmuka agen. Atas: tertua di atas. Bawah: terbaru di atas.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Mendefinisikan urutan tiket default hasil pencarian di antarmuka pelanggan. Atas: tertua di atas. Bawah: terbaru di atas.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Mendefinisikan prioritas tiket default pada layar tiket penutupan di antarmuka agen.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Mendefinisikan prioritas tiket default di layar massal tiket di antarmuka agen.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Mendefinisikan prioritas tiket default di tiket layar teks bebas dari antarmuka agen.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Mendefinisikan prioritas tiket default di layar catatan tiket dari antarmuka agen.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Mendefinisikan prioritas tiket default pada layar pemilik tiket dari tiket yang diperbesar di antarmuka agen.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Mendefinisikan prioritas tiket default di tiket tertunda layar tiket diperbesar dalam antarmuka agen.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Mendefinisikan prioritas tiket default di layar prioritas tiket dari tiket yang diperbesar di antarmuka agen.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Mendefinisikan prioritas tiket default di tiket layar yang bertanggung jawab di antarmuka agen.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'Mendefinisikan jenis tiket default untuk tiket pelanggan baru di antarmuka pelanggan.',
        'Defines the default ticket type.' => 'Mendefinisikan jenis tiket default.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Mendefinisikan default pengguna Frontend-Modul jika tidak ada parameter Action diberikan di url pada interface agen.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Mendefinisikan default pengguna Frontend-Modul jika tidak ada parameter Action diberikan di url pada antarmuka pelanggan.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Mendefinisikan nilai default untuk tindakan parameter frontend publik. Parameter tindakan digunakan dalam skrip dari sistem.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Mendefinisikan default jenis pengirim dapat dilihat dari tiket (default: pelanggan).',
        'Defines the default visibility of the article to customer for this operation.' =>
            '',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Mendefinisikan bidang dinamis yang digunakan untuk menampilkan pada acara kalender.',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            '',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            'Mendefinisikan path jatuh kembali untuk membuka binari fetchmail. Catatan: Nama biner perlu \'fetchmail\', jika berbeda silakan gunakan link simbolik.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Mendefinisikan filter yang memproses teks dalam artikel, dalam rangka untuk menyoroti URL.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'Mendefinisikan format tanggapan di layar compose tiket dari agen antarmuka ([% Data.OrigDari | html%] adalah Dari 1: , [% Data.OrigDariNama | html%] hanya realname Dari).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Mendefinisikan nama domain berkualifikasi lengkap dari sistem. Pengaturan ini digunakan sebagai variabel, OTRS_CONFIG_FQDN yang ditemukan dalam semua bentuk pesan yang digunakan oleh aplikasi, untuk membangun link ke tiket dalam sistem Anda.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            '',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Mendefinisikan tinggi untuk komponen editor teks kaya untuk layar ini. Masukkan nomor (piksel) atau nilai persen (relatif).',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Mendefinisikan tinggi untuk orang kaya komponen editor teks. Masukkan nomor (piksel) atau nilai persen (relatif).',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan komentar sejarah untuk aksi layar tiket dekat, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan komentar sejarah untuk aksi layar tiket email, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan komentar sejarah untuk aksi layar tiket ponsel, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Mendefinisikan komentar sejarah untuk tiket gratis tindakan layar teks, yang akan digunakan untuk sejarah tiket.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan komentar sejarah untuk aksi layar catatan tiket, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan komentar sejarah bagi pemilik tiket tindakan layar, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan komentar sejarah untuk aksi layar tiket tertunda, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan komentar sejarah untuk ponsel tiket tindakan layar masuk, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan komentar sejarah untuk ponsel tiket tindakan layar outbound, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan komentar sejarah untuk aksi layar prioritas tiket, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan komentar sejarah untuk tiket tindakan layar yang bertanggung jawab, akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Mendefinisikan komentar sejarah untuk aksi zoom tiket, yang akan digunakan untuk sejarah tiket di antarmuka pelanggan.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan komentar sejarah untuk operasi ini, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan jenis sejarah untuk aksi layar tiket dekat, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan jenis sejarah untuk aksi layar tiket email, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan jenis sejarah untuk aksi layar tiket ponsel, yang akan digunakan sebagai sejarah tiket di antarmuka agen.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Mendefinisikan nama domain berkualifikasi lengkap dari sistem. Pengaturan ini digunakan sebagai variabel, OTRS_CONFIG_FQDN yang ditemukan dalam semua bentuk pesan yang digunakan oleh aplikasi, untuk membangun link ke tiket dalam sistem Anda.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan jenis sejarah untuk aksi layar catatan tiket, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan jenis sejarah bagi pemilik tiket tindakan layar, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan jenis sejarah untuk tiket tertunda tindakan layar, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan jenis sejarah untuk ponsel tiket tindakan layar masuk, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan jenis sejarah untuk ponsel tiket tindakan layar masuk, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan jenis sejarah untuk aksi layar prioritas tiket, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan jenis sejarah untuk tiket tindakan layar bertanggung jawab, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Mendefinisikan jenis sejarah untuk aksi zoom tiket, yang akan digunakan untuk sejarah tiket di antarmuka pelanggan',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Mendefinisikan jenis sejarah untuk operasi ini, yang akan digunakan untuk sejarah tiket di antarmuka agen.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Mendefinisikan jam dan minggu hari kalender menunjukkan, untuk menghitung waktu kerja.',
        'Defines the hours and week days to count the working time.' => 'Mendefinisikan jam dan hari minggu untuk menghitung waktu kerja.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Mendefinisikan kunci untuk diperiksa dengan Kernel::Modul::AgentInfo. Jika tombol preferensi pengguna ini benar, pesan akan diterima oleh sistem.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Mendefinisikan kunci untuk memeriksa dengan Pelanggan Terima. Jika tombol preferensi pengguna ini benar, maka pesan diterima oleh sistem.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Mendefinisikan link jenis \'Normal\'. Jika nama sumber dan nama target mengandung nilai yang sama, link yang dihasilkan adalah non-directional satu; jika tidak, hasilnya adalah link directional.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Mendefinisikan jenis link \'Parent Child\'. Jika nama sumber dan nama target mengandung nilai yang sama, link yang dihasilkan adalah non-directional satu; jika tidak, hasilnya adalah link directional.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Mendefinisikan kelompok jenis link. Jenis link dari kelompok yang sama membatalkan satu sama lain. Contoh: Jika tiket A dihubungkan per satu \'normal\' hubungan dengan tiket B, maka tiket tersebut tidak dapat tambahan terkait dengan link dari sebuah hubungan \'ParentChild\'.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Mendefinisikan daftar repositori online. instalasi lain dapat digunakan sebagai repositori, misalnya: Key = "http://example.com/otrs/public.pl?Action=PublicRepository;File=" dan Content = "Beberapa Nama".',
        'Defines the list of params that can be passed to ticket search function.' =>
            '',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            'Mendefinisikan daftar kemungkinan tindakan selanjutnya pada layar kesalahan, jalan penuh diperlukan, maka dimungkinkan untuk menambahkan link eksternal jika diperlukan.',
        'Defines the list of types for templates.' => 'Mendefinisikan jenis urutan template',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Mendefinisikan lokasi untuk mendapatkan urutan repositori onlline dan tambahan paket. Hasil yang pertama akan digunakan',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Mendefinisikan modul log untuk sistem. "File" tertulis di semua pesan yang diberikan oleh logfile, "SysLog" digunakan untuk syslog daemon untuk sistem, contoh: syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            'Mendefinisikan ukuran maksimal (dalam byte) untuk upload file melalui browser. Peringatan: Mengatur opsi ini untuk nilai yang terlalu rendah dapat menyebabkan banyak topeng dalam hal OTRS Anda untuk berhenti bekerja (mungkin setiap topeng yang mengambil input dari user).',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Mendefinisikan maksimum waktu yang berlaku (dalam detik) untuk sesi id',
        'Defines the maximum number of affected tickets per job.' => 'Mendefinisikan jumlah maksimum tiket yang terkena per pekerjaan.',
        'Defines the maximum number of pages per PDF file.' => 'Mendefinisikan jumlah maksimum halaman per file PDF.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            'Mendefinisikan jumlah maksimum baris dikutip untuk ditambahkan ke tanggapan.',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            'Mendefinisikan jumlah maksimum tugas yang harus dilaksanakan sebagai waktu yang sama.',
        'Defines the maximum size (in MB) of the log file.' => 'Mendefinisikan ukuran maksimum (dalam MB) dari file log.',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            'Mendefinisikan ukuran maksimum di KiloByte tanggapan Antarmuka Generik yang bisa login ke gi_debugger_entry_content table.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'Mendefinisikan modul yang menunjukkan pemberitahuan generik di antarmuka agen. Baik "Text" - jika dikonfigurasi - atau isi "File" akan ditampilkan.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Mendefinisikan modul yang menunjukkan semua yang sedang login agen di antarmuka agen.',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => 'Mendefinisikan modul untuk mengotentikasi pelanggan.',
        'Defines the module to display a notification if cloud services are disabled.' =>
            'Mendefinisikan modul untuk menampilkan notifikasi jika layanan cloud dinonaktifkan',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            'Mendefinisikan modul untuk menampilkan pemberitahuan di antarmuka yang berbeda pada kesempatan yang berbeda untuk Solusi OTRS Bisnis™.',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            'Mendefinisikan modul untuk menampilkan pemberitahuan di antarmuka agen jika OTRS Daemon tidak berjalan.',
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Mendefinisikan modul untuk menampilkan notifikasi di antarmuka agen, jika agen login sementara memiliki out-of-office yang aktif.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'Mendefinisikan modul untuk menampilkan notifikasi di antarmuka agen, jika agen login sementara memiliki pemeliharaan sistem aktif.',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the installation of not verified packages is activated (only shown to admins).' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Mendefinisikan modul untuk menampilkan notifikasi di antarmuka agen, jika sistem yang digunakan oleh user admin (biasanya Anda tidak harus bekerja sebagai admin).',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            '',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
            'Mendefinisikan modul untuk menghasilkan kode untuk ulang halaman periodik.',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTRS_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Mendefinisikan modul yang digunakan untuk menyimpan data sesi. Dengan "DB" server frontend dapat splitted dari server db. "FS" lebih cepat.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Mendefinisikan nama aplikasi, ditampilkan dalam antarmuka web, tab dan bar judul browser web.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Mendefinisikan nama kolom untuk menyimpan data dalam tabel preferensi.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Mendefinisikan nama kolom untuk menyimpan pengidentifikasi pengguna dalam tabel preferensi.',
        'Defines the name of the indicated calendar.' => 'Mendefinisikan nama kalender yang ditunjukkan.',
        'Defines the name of the key for customer sessions.' => 'Mendefinisikan nama kunci untuk sesi pelanggan.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Mendefinisikan nama kunci sesi. Misalnya. Sesi, sessionid atau OTRS.',
        'Defines the name of the table where the user preferences are stored.' =>
            'Mendefinisikan nama tabel dimana preferensi pengguna disimpan.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Mendefinisikan mungkin state berikutnya setelah menulis / menjawab tiket di layar compose tiket dari antarmuka agen.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Mendefinisikan mungkin state berikutnya setelah forwarding tiket di tiket layar depan dari antarmuka agen.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'Mendefinisikan mungkin state berikutnya setelah mengirim pesan di layar keluar email dari antarmuka agen.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Mendefinisikan kemungkinan state berikutnya untuk tiket pelanggan dalam antarmuka pelanggan.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Mendefinisikan state berikutnya tiket setelah menambahkan catatan, di layar tiket penutupan antarmuka agen.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Mendefinisikan state berikutnya setelah tiket ditambah, tiket freetextscreen dari agen antarmuka',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Mendefinisikan state berikutnya setelah menambahkan catatan, di layar catatan tiket dari antarmuka agen.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Mendefinisikan state tiket berikutnya setelah menambahkan catatan, di layar catatan tiket dari antarmuka agen.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Mendefinisikan state tiket berikutnya setelah menambahkan catatan, di layar tiket tertunda dari tiket yang diperbesar di antarmuka agen.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Mendefinisikan state tiket berikutnya setelah menambahkan catatan, di layar prioritas tiket dari tiket yang diperbesar di antarmuka agen',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Mendefinisikan state tiket berikutnya setelah menambahkan catatan, dalam tiket layar yang bertanggung jawab dari antarmuka agen',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Mendefinisikan state tiket berikutnya setelah memantul, di layar bouncing tiket dari antarmuka agen.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Mendefinisikan state tiket berikutnya setelah pindah ke antrian lain, di layar bergerak tiket dari antarmuka agen.',
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            'Mendefinisikan jumlah karakter per baris digunakan dalam kasus pengganti artikel pratinjau HTML pada Template Generator untuk Pemberitahuan Event.',
        'Defines the number of days to keep the daemon log files.' => 'Mendefinisikan jumlah hari untuk menyimpan file daemon log.',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'Mendefinisikan jumlah field header di modul tampilan untuk menambah dan memperbarui filter postmaster. Ini bisa sampai 99 bidang.',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            '',
        'Defines the number of hours a successful communication will be stored.' =>
            '',
        'Defines the parameters for the customer preferences table.' => 'Mendefinisikan parameter untuk tabel preferensi pelanggan.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Mendefinisikan password untuk mengakses SOAP pegangan (bin/cgi-bin/rpc.pl).',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Mendefinisikan jalur dan TTF-File untuk menangani bold font yang monospace miring di dokumen PDF',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Mendefinisikan jalur dan TTF-File untuk menangani bold font yang proporsional miring di dokumen PDF.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Mendefinisikan jalur dan TTF-File untuk menangani huruf monospace berani dalam dokumen PDF.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Mendefinisikan jalur dan TTF-File untuk menangani font yang proporsional berani dalam dokumen PDF.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Mendefinisikan jalur dan TTF-File untuk menangani font yang monospace miring di dokumen PDF.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Mendefinisikan jalur dan TTF-File untuk menangani font yang proporsional miring di dokumen PDF.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Mendefinisikan jalur dan TTF-File untuk menangani monospace dalam dokumen PDF.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Mendefinisikan jalur dan TTF-File untuk menangani font yang proporsional dalam dokumen PDF.',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            'Mendefinisikan jalur acara file info, yang terletak di bawah Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.',
        'Defines the path to PGP binary.' => 'Mendefinisikan jalan untuk binari PGP ',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Mendefinisikan jalur untuk membuka binari ssl. diperlukan HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the postmaster default queue.' => 'Mendefinisikan antrian postmaster default.',
        'Defines the priority in which the information is logged and presented.' =>
            'Mendefinisikan prioritas di mana informasi login dan disajikan.',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            'Mendefinisikan target penerima tiket telepon dan pengirim tiket email ("Antrian" menunjukkan semua antrian, "alamat Sistem" menampilkan semua alamat sistem) dalam antarmuka agen.',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            'Mendefinisikan target penerima tiket ("Antrian" menunjukkan semua antrian, "Sistem Alamat" hanya menunjukkan permintaan yang ditugaskan ke alamat sistem) dalam antarmuka pelanggan.',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Mendefinisikan izin yang diperlukan untuk menunjukkan tiket dalam tampilan eskalasi antarmuka agen.',
        'Defines the search limit for the stats.' => 'Mendefinisikan batas pencarian untuk bintang.',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            '',
        'Defines the sender for rejected emails.' => 'Mendefinisikan pengirim bahwa email telah ditolak.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Mendefinisikan pemisah antara agen nama asli dan alamat email antrian diberikan.',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            '',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Mendefinisikan hak akses standar yang tersedia untuk pelanggan dalam aplikasi. Jika lebih banyak izin yang diperlukan, Anda dapat memasukkan mereka di sini. Izin harus sulit kode untuk menjadi efektif. Pastikan, saat menambahkan salah satu izin tersebut, bahwa "rw" izin tetap entri terakhir.',
        'Defines the standard size of PDF pages.' => 'Mendefinisikan ukuran standar halaman PDF.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Mendefinisikan keadaan tiket jika mendapat tindak lanjut dan tiket sudah ditutup.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Mendefinisikan keadaan tiket jika mendapat tindak lanjut.',
        'Defines the state type of the reminder for pending tickets.' => 'Mendefinisikan jenis keadaan pengingat untuk menunggu tiket.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Mendefinisikan subjek untuk kiriman notifikasi dikirim ke agen, tentang katasandi baru.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Mendefinisikan subjek untuk kiriman notifikasi dikirim ke agen, dengan katasandi baru yang diminta.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Mendefinisikan subjek untuk kiriman notifikasi dikirim ke pelanggan, tentang akun baru.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Mendefinisikan subjek untuk kiriman notifikasi dikirim ke pelanggan, tentang katasandi baru.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Mendefinisikan subjek untuk kiriman notifikasi dikirim ke pelanggan, dengan tanda tentang kata sandi baru yang diminta.',
        'Defines the subject for rejected emails.' => 'Mendefinisikan subjek untuk email ditolak.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Mendefinisikan alamat email administrator sistem. Akan ditampilkan di layar dimana terjadi kesalahan pada aplikasi.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'Mendefinisikan sistem identifier. Setiap nomor tiket dan sesi http string berisi ID ini. Hal ini memastikan bahwa hanya tiket yang milik sistem anda akan diproses sebagai tindak lanjut (berguna ketika berkomunikasi antara dua contoh OTRS).',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'Mendefinisikan atribut target link ke database pelanggan eksternal.Contoh \'AsPopup PopupType_TicketAction\'.',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Mendefinisikan atribut target link ke database pelanggan eksternal. Contoh \'target="cdb"\'.',
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            '',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            '',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'Mendefinisikan bidang tiket yang akan menjadi ditampilkan acara kalender. "Kunci" mendefinisikan atribut lapangan atau tiket dan "Konten" mendefinisikan nama tampilan.',
        'Defines the ticket plugin for calendar appointments.' => '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Mendefinisikan zona waktu kalender ditunjukkan, yang dapat diberikan kemudian untuk antrian tertentu.',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => 'Mendefinisikan modul dua faktor untuk otentikasi agen.',
        'Defines the two-factor module to authenticate customers.' => 'Mendefinisikan modul dua faktor untuk mengotentikasi pelanggan.',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Mendefinisikan jenis protokol, yang digunakan oleh web server, untuk melayani aplikasi. Jika protokol https akan digunakan bukan http biasa, itu harus ditentukan di sini. Karena ini tidak berpengaruh pada pengaturan atau perilaku web server, itu tidak akan mengubah metode akses ke aplikasi dan, jika salah, tidak akan mencegah Anda dari masuk ke aplikasi. Pengaturan ini hanya digunakan sebagai variabel, OTRS CONFIG Http Jenis yang ditemukan dalam semua bentuk pesan yang digunakan oleh aplikasi, untuk membangun link ke tiket dalam sistem Anda.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            'Mendefinisikan karakter yang digunakan untuk kutipan email plaintext di layar compose tiket dari antarmuka agen. Jika ini kosong atau tidak aktif, email asli tidak akan dikutip tetapi ditambahkan ke respon.',
        'Defines the user identifier for the customer panel.' => 'Mendefinisikan identifier pengguna untuk panel pelanggan',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Mendefinisikan nama pengguna untuk mengakses SOAP pegangan (bin/cgi-bin/rpc.pl).',
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            'Mendefinisikan negara berlaku untuk tiket dibuka. Untuk membuka tiket script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" dapat digunakan',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Mendefinisikan lebar untuk komponen editor teks ini. Masukkan nomor (piksel) atau nilai persen (relatif).',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Mendefinisikan lebar untuk rich komponen editor teks. Masukkan nomor (piksel) atau nilai persen (relatif).',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            '',
        'Defines whether to index archived tickets for fulltext searches.' =>
            '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Mendefinisikan artikel jenis pengirim dan harus ditampilkan dalam preview tiket.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'Mendefinisikan item yang tersedia untuk \'Action\' di tingkat ketiga dari struktur ACL.',
        'Defines which items are available in first level of the ACL structure.' =>
            'Mendefinisikan item yang tersedia di tingkat pertama dari struktur ACL.',
        'Defines which items are available in second level of the ACL structure.' =>
            'Mendefinisikan item yang tersedia di tingkat pertama dari struktur ACL.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Mendefinisikan state yang harus diatur secara otomatis (Content), setelah waktu tertunda states (Key) telah tercapai.',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'Mendefinisikan, tiket jenis state tidak harus tercantum dalam daftar tiket terkait.',
        'Delete expired cache from core modules.' => 'Hapus tembolok kadaluarsa dari modul inti.',
        'Delete expired loader cache weekly (Sunday mornings).' => 'Hapus loader yang sudah jatuh tempo setiap minggu (Minggu pagi).',
        'Delete expired sessions.' => 'Hapus sesi tamat tempo',
        'Delete expired ticket draft entries.' => '',
        'Delete expired upload cache hourly.' => '',
        'Delete this ticket' => 'Hapus tiket ini',
        'Deleted link to ticket "%s".' => 'Hapus link untuk tiket "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Hapus sesi jika sesi id digunakan dengan alamat IP remote yang tidak valid.',
        'Deletes requested sessions if they have timed out.' => 'Hapus sesi permintaan jika mereka telah habis.',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            'Memberikan informasi debug diperpanjang di frontend dalam hal apapun kesalahan AJAX terjadi, jika diaktifkan.',
        'Deploy and manage OTRS Business Solution™.' => 'Menyebarkan dan mengelola OTRS Business Solution™.',
        'Detached' => '',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Menentukan apakah daftar antrian untuk pindah ke tiket harus ditampilkan dalam daftar dropdown atau di jendela baru di antarmuka agen. Jika "New Window" diatur Anda dapat menambahkan catatan pindah ke tiket.',
        'Determines if the statistics module may generate ticket lists.' =>
            'Menentukan apakah modul statistik dapat menghasilkan daftar tiket.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Menentukan state tiket berikutnya mungkin, setelah terciptanya tiket email baru di antarmuka agen.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Menentukan state tiket berikutnya mungkin, setelah terciptanya tiket ponsel baru di antarmuka agen.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'Menentukan state tiket berikutnya mungkin, untuk tiket proses di antarmuka agen.',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Menentukan layar berikutnya setelah tiket pelanggan baru di antarmuka pelanggan.',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            'Menentukan layar berikutnya setelah layar tindak lanjut dari tiket yang diperbesar di antarmuka pelanggan.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'Menentukan layar berikutnya setelah tiket tersebut akan dipindahkan. Ikhtisar Layar terakhir akan kembali ke layar gambaran (misalnya hasil pencarian, queueview, dashboard). TicketZoom akan kembali ke TicketZoom tersebut.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Menentukan state mungkin tiket yang tertunda berubah state setelah mencapai batas waktu.',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'Menentukan string yang akan ditampilkan sebagai penerima (Untuk :) dari tiket ponsel dan sebagai pengirim (Dari :) dari tiket email di antarmuka agen. Untuk Queue sebagai NewQueueSelectionType "<Antrian>" menunjukkan nama-nama antrian dan untuk SystemAddress "<Realname> << Email >>" menunjukkan nama dan email penerima.',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'Menentukan string yang akan ditampilkan sebagai penerima (Untuk :) dari tiket di antarmuka pelanggan. Untuk Queue sebagai CustomerPanelSelectionType, "<Antrian>" menunjukkan nama-nama antrian, dan untuk SystemAddress, "<Realname> << Email >>" menunjukkan nama dan email penerima.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Menentukan cara objek terkait akan ditampilkan di setiap topeng zoom.',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Menentukan opsi yang akan berlaku jika penerima (tiket ponsel) dan pengirim (tiket email) dalam antarmuka agen.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Menentukan antrian yang akan berlaku untuk tiket penerima di antarmuka pelanggan.',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'Nonaktifkan HTTP header "X-Frame-Options: SAMEORIGIN" untuk memungkinkan OTHERS untuk dimasukkan sebagai iFrame di situs-situs lain. Menonaktifkan HTTP header ini bisa menjadi masalah keamanan! Hanya menonaktifkannya, jika Anda tahu apa yang Anda lakukan!',
        'Disable autocomplete in the login screen.' => '',
        'Disable cloud services' => '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            '',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If not enabled, the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If enabled, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            'Menampilkan peringatan dan mencegah pencarian ketika menggunakan kata-kata berhenti dalam pencarian fulltext.',
        'Display communication log entries.' => '',
        'Display settings to override defaults for Process Tickets.' => 'pengaturan tampilan untuk menimpa default untuk Proses Tiket.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Menampilkan waktu sebuah artikel dalam tampilan zoom tiket.',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            '',
        'Down' => 'Bawah',
        'Dropdown' => 'Jatuhkan ke bawah',
        'Dutch' => '',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            'kata berhenti Belanda untuk indeks fulltext. Kata-kata ini akan dihapus dari indeks pencarian.',
        'Dynamic Fields Checkbox Backend GUI' => 'GUI dinamis Fields Checkbox Backend',
        'Dynamic Fields Date Time Backend GUI' => 'Dinamis Fields Tanggal GUI Waktu Backend',
        'Dynamic Fields Drop-down Backend GUI' => 'Dinamis Fields drop-down GUI Backend',
        'Dynamic Fields GUI' => 'GUI dinamis Fields',
        'Dynamic Fields Multiselect Backend GUI' => 'Dinamis Fields Multiselect Backend GUI',
        'Dynamic Fields Overview Limit' => 'Dinamis Fields Batas keseluruhannya',
        'Dynamic Fields Text Backend GUI' => 'Dinamis Bidang Teks GUI Backend',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Dinamis Fields digunakan untuk mengekspor hasil pencarian dalam format CSV.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'kelompok bidang dinamis untuk proses widget. Kuncinya adalah nama kelompok, nilai berisi bidang yang akan ditampilkan. Contoh: \'Key => Grup saya\', \'Isi: Nama X, Nama Y\'.',
        'Dynamic fields limit per page for Dynamic Fields Overview.' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket overview screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket pending screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            '',
        'DynamicField' => 'DynamicField',
        'DynamicField backend registration.' => 'DynamicField pendaftaran backend.',
        'DynamicField object registration.' => 'DynamicField pendaftaran obyek.',
        'DynamicField_%s' => '',
        'E-Mail Outbound' => 'EMail Outbound',
        'Edit Customer Companies.' => 'Mengatur perusahaan pelanggan',
        'Edit Customer Users.' => 'Mengatur pengguna pelanggan',
        'Edit appointment' => '',
        'Edit customer company' => 'Mengatur perusahaan pelanggan',
        'Email Addresses' => 'Alamat email',
        'Email Outbound' => 'Email keluar',
        'Email Resend' => '',
        'Email communication channel.' => '',
        'Enable highlighting queues based on ticket age.' => '',
        'Enable keep-alive connection header for SOAP responses.' => 'Aktifkan sambungan tetap-hidup untuk respon SOAP.',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Enabled filters.' => 'Filter diaktifkan',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Memungkinkan dukungan PGP. Ketika dukungan PGP diaktifkan untuk menandatangani dan mengenkripsi email, itu sangat dianjurkan bahwa web server berjalan sebagai pengguna OTRS. Jika tidak, akan ada masalah dengan hak ketika mengakses .gnupg folder.',
        'Enables S/MIME support.' => 'Mengaktifkan dukungan S/MIME ',
        'Enables customers to create their own accounts.' => 'Mengaktifkan pelanggan untuk membuat account mereka sendiri.',
        'Enables fetch S/MIME from CustomerUser backend support.' => '',
        'Enables file upload in the package manager frontend.' => 'Mengaktifkan file upload di frontend paket manajer ',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            'Mengaktifkan atau menonaktifkan caching untuk template. PERINGATAN: JANGAN menonaktifkan caching template untuk lingkungan produksi karena akan menyebabkan penurunan kinerja besar! Pengaturan ini hanya harus dinonaktifkan untuk debugging!',
        'Enables or disables the debug mode over frontend interface.' => 'Mengaktifkan atau menonaktifkan mode debug lebih antarmuka front end.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Mengaktifkan atau menonaktifkan fitur pengamat tiket, untuk melacak tiket tanpa  menjadi pemilik atau pihak yang bertanggung jawab.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Memungkinkan kinerja log (halaman waktu respon log). Ini akan mempengaruhi kinerja sistem. Frontend::Module###AdminPerformanceLog  Harus diaktifkan',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'Mengaktifkan ukuran minimal tiket (jika "tanggal" telah dipilih sebagai TicketNumberGenerator)',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Memungkinkan fitur tindakan massal untuk agen frontend yang bekerja pada lebih dari satu tiket pada satu waktu.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Memungkinkan fitur tindakan massal tiket hanya untuk kelompok terdaftar.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Memungkinkan tiket fitur bertanggung jawab, untuk melacak tiket tertentu.',
        'Enables ticket type feature.' => '',
        'Enables ticket watcher feature only for the listed groups.' => 'Memungkinkan fitur watcher tiket hanya untuk kelompok terdaftar.',
        'English (Canada)' => 'English (Kanada)',
        'English (United Kingdom)' => 'English (United Kingdom)',
        'English (United States)' => 'English (United States)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            'kata berhenti Bahasa Inggris untuk indeks fulltext. Kata-kata ini akan dihapus dari indeks pencarian.',
        'Enroll process for this ticket' => 'Daftarkan proses untuk tiket ini',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            '',
        'Escalated Tickets' => 'Tiket tereskalasi',
        'Escalation view' => 'lihat eskalasi',
        'EscalationTime' => 'Waktu Eskalasi',
        'Estonian' => 'Estonia',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'Acara pendaftaran modul. Untuk kinerja yang lebih Anda dapat menentukan peristiwa pemicu (e. G. Kegiatan => BuatTiket).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Acara pendaftaran modul. Untuk kinerja yang lebih Anda dapat menentukan peristiwa pemicu (Event => Creator Ticket e. G.). Ini hanya mungkin jika semua bidang dinamis Ticket perlu acara yang sama.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'Modul peristiwa yang melakukan pernyataan update pada Indeks Tiket untuk mengubah nama antrian ada jika diperlukan dan jika Static sebenarnya digunakan.',
        'Event module that updates customer company object name for dynamic fields.' =>
            '',
        'Event module that updates customer user object name for dynamic fields.' =>
            '',
        'Event module that updates customer user search profiles if login changes.' =>
            'modul acara dimana pengguna sebagai pelanggan diperbarui di pencarian pelanggan pengguna jika ada perubahan masuk',
        'Event module that updates customer user service membership if login changes.' =>
            'Modul acara yang update pelanggan pengguna layanan keanggotaan jika ada perubahan masuk',
        'Event module that updates customer users after an update of the Customer.' =>
            'Modul acara yang update pengguna pelanggan setelah update dari Nasabah.',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Modul acara pembaruan tiket setelah pembaruan dari Nasabah Pengguna.',
        'Event module that updates tickets after an update of the Customer.' =>
            'Modul acara pembaruan tiket setelah update dari Nasabah',
        'Events Ticket Calendar' => 'Kalender tiket untuk event',
        'Example package autoload configuration.' => '',
        'Execute SQL statements.' => 'Mengeksekusi pernyataan SQL.',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            'Mengeksekusi perintah kustom atau modul. Catatan: jika modul yang digunakan, fungsi diperlukan.',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'Mengeksekusi cek menindaklanjuti In-Reply-To atau References header untuk email yang tidak memiliki nomor tiket di subjek.',
        'Executes follow-up checks on OTRS Header \'X-OTRS-Bounce\'.' => '',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            'Mengeksekusi cek menindaklanjuti isi lampiran untuk mail yang tidak memiliki nomor tiket di subjek.',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            'Mengeksekusi pemeriksaan tindak lanjut pada tubuh email untuk mail yang tidak memiliki nomor tiket di subjek.',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            'Mengeksekusi pemeriksaan tindak lanjut dari email sumber baku mail yang tidak memiliki nomor tiket di subjek.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Ekspor keseluruhan artikel dalam hasil pencarian (dapat mempengaruhi kinerja sistem).',
        'External' => '',
        'External Link' => '',
        'Fetch emails via fetchmail (using SSL).' => 'Mengambil email via fetchmail (menggunakan SSL).',
        'Fetch emails via fetchmail.' => 'Mengambil email via fetchmail.',
        'Fetch incoming emails from configured mail accounts.' => 'Mengambil email yang masuk dari akun email yang dikonfigurasi.',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Menjemput paket melalui proxy. menimpa "WebUserAgent::Proxy".',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            'File yang ditampilkan dalam Kernel::Modules::AgentInfo modul, terletak di bawah Kernel/Output/HTML/Template/Standard/AgentInfo.tt',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Filter untuk debugging ACL. Catatan: atribut tiket lebih lanjut dapat ditambahkan dalam format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Filter untuk debugging Transisi. Catatan: Lebih filter dapat ditambahkan dalam format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.',
        'Filter incoming emails.' => 'Menyaring email yang masuk.',
        'Finnish' => 'Selesei',
        'First Christmas Day' => 'Hari Natal',
        'First Queue' => 'Antrian pertama',
        'First response time' => '',
        'FirstLock' => 'Kunci pertama',
        'FirstResponse' => 'Respon pertama',
        'FirstResponseDiffInMin' => 'FirstResponseDiffInMin',
        'FirstResponseInMin' => 'Minimal respon pertama',
        'Firstname Lastname' => 'Nama pertama dan nama akhir',
        'Firstname Lastname (UserLogin)' => 'Nama pertama Nama akhir (PenggunaMasuk)',
        'For these state types the ticket numbers are striked through in the link table.' =>
            '',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Pasukan encoding email keluar (7 bit | 8bit | quoted-printable | base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Dipaksa untuk memilih keadaan tiket yang berbeda (dari saat ini) setelah aksi kunci. Mendefinisikan keadaan saat sebagai kunci, dan negara berikutnya setelah aksi kunci sebagai konten.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Kekuatan untuk membuka tiket setelah dipindahkan ke antrian yang lain.',
        'Forwarded to "%s".' => 'diteruskan ke "%s".',
        'Free Fields' => 'Bidang bebas',
        'French' => 'Perancis',
        'French (Canada)' => 'Perancis (Kanada)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            'kata berhenti Perancis untuk indeks fulltext. Kata-kata ini akan dihapus dari indeks pencarian.',
        'Frontend' => 'paling depan',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'pendaftaran modul antarmuka (menonaktifkan link di perusahaan jika tidak ada fitur perusahaan yang digunakan).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            'pendaftaran modul antarmuka (proses tiket dinonaktifkan layar jika tidak ada proses yang tersedia) untuk Pelanggan.',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'pendaftaran modul antarmuka (proses tiket dinonaktifkan layar jika tidak ada proses yang tersedia).',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            '',
        'Frontend module registration for the agent interface.' => 'Frontend pendaftaran modul untuk antarmuka agen.',
        'Frontend module registration for the customer interface.' => 'Frontend pendaftaran modul untuk antarmuka pelanggan.',
        'Frontend module registration for the public interface.' => 'Pendaftaran modul Halamandepan untuk antarmuka umum.',
        'Full value' => 'nilai penuh',
        'Fulltext index regex filters to remove parts of the text.' => 'Fulltext filter Indeks regex untuk menghapus bagian-bagian dari teks.',
        'Fulltext search' => 'Pencarian Teks Penuh',
        'Galician' => 'Galician',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => 'Menghasilkan statistik dashboard.',
        'Generic Info module.' => 'Info generik modul.',
        'GenericAgent' => 'Agen generik',
        'GenericInterface Debugger GUI' => 'GUI generik Antarmuka Debugger',
        'GenericInterface ErrorHandling GUI' => '',
        'GenericInterface Invoker Event GUI' => '',
        'GenericInterface Invoker GUI' => 'GUI generik Antarmuka Invoke',
        'GenericInterface Operation GUI' => 'GUI generik Antarmuka Operasi',
        'GenericInterface TransportHTTPREST GUI' => 'GUI generik Antarmuka Transportasi HTTPREST',
        'GenericInterface TransportHTTPSOAP GUI' => 'SOAP GUI generik Antarmuka Transportasi HTTP',
        'GenericInterface Web Service GUI' => 'Generik Antarmuka Web Service GUI',
        'GenericInterface Web Service History GUI' => '',
        'GenericInterface Web Service Mapping GUI' => '',
        'GenericInterface module registration for an error handling module.' =>
            '',
        'GenericInterface module registration for the invoker layer.' => 'Generik pendaftaran Antarmuka modul untuk lapisan Invoker.',
        'GenericInterface module registration for the mapping layer.' => 'Generik pendaftaran Antarmuka modul untuk lapisan pemetaan.',
        'GenericInterface module registration for the operation layer.' =>
            'Generik pendaftaran Antarmuka modul untuk lapisan operasi.',
        'GenericInterface module registration for the transport layer.' =>
            'Generik pendaftaran Antarmuka modul untuk lapisan transport.',
        'German' => 'Jerman',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            'kata berhenti Jerman untuk indeks fulltext. Kata-kata ini akan dihapus dari indeks pencarian.',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Global Search Module.' => 'Modul pencarian global',
        'Go to dashboard!' => 'Pergi ke dasbor',
        'Good PGP signature.' => '',
        'Google Authenticator' => 'Google Authenticator',
        'Graph: Bar Chart' => 'Grafik: Bar Chart',
        'Graph: Line Chart' => 'Graph: Garis chart',
        'Graph: Stacked Area Chart' => 'Grafik: Tumpukan Bagan Lokasi',
        'Greek' => 'Yunani',
        'Hebrew' => 'Ibrani',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            '',
        'High Contrast' => '',
        'High contrast skin for visually impaired users.' => '',
        'Hindi' => 'Hindi',
        'Hungarian' => 'Hongaria',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Jika "DB" dipilih untuk  Customer::AuthModule, sebuah driver database (biasanya autodetection digunakan) dapat ditentukan.',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Jika "DB" dipilih untuk Customer::AuthModule, password yang terhubung ke tabel pelanggan dapat ditentukan.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Jika "DB" dipilih untuk Customer::AuthModule, username untuk menghubungkan ke meja pelanggan dapat ditentukan.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Jika "DB" dipilih untuk Customer::AuthModule, DSN untuk koneksi ke tabel pelanggan harus ditentukan.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Jika "DB" dipilih untuk Customer::AuthModule, nama kolom untuk Sandi Pelanggan di tabel pelanggan harus ditentukan.',
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'If "DB" was selected for Customer::AuthModule, nama kolom untuk Key Pelanggan di tabel pelanggan harus ditentukan.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'If "DB" was selected for Customer::AuthModule, nama tabel dimana data pelanggan Anda harus disimpan harus ditentukan.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Jika "DB" dipilih untuk Sesi Modul, tabel dalam database dimana data sesi akan disimpan harus ditentukan.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Jika "FS" dipilih untuk Sesi Modul, direktori dimana data sesi akan disimpan harus ditentukan.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, Anda dapat menentukan (dengan menggunakan regex) untuk strip bagian REMOTE_USER (e. g. untuk menghapus mengikuti domain). RegExp-Note, $1 akan menjadi baru Login.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule,',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, dan jika Anda ingin menambahkan akhiran untuk setiap nama login pelanggan, tentukan di sini, e. g. Anda hanya ingin menulis pengguna nama pengguna tetapi dalam direktori LDAP ada user@domain.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, dan parameter khusus yang diperlukan untuk modul perl, Anda dapat menentukan mereka di sini. Lihat "perldocNet::LDAP" untuk informasi lebih lanjut tentang parameter.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, dan pengguna Anda hanya memiliki akses anonim ke pohon LDAP, tetapi Anda ingin mencari melalui data, Anda dapat melakukan ini dengan pengguna yang memiliki akses ke direktori LDAP. Tentukan password untuk pengguna khusus ini di sini.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, dan pengguna Anda hanya memiliki akses anonim ke pohon LDAP, tetapi Anda ingin mencari melalui data, Anda dapat melakukan ini dengan pengguna yang memiliki akses ke direktori LDAP. Tentukan nama pengguna untuk pengguna khusus ini di sini.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, Basis DN harus ditentukan.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, host LDAP dapat ditentukan.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, pengidentifikasi pengguna harus ditentukan.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, atribut pengguna dapat ditentukan. Untuk LDAP Grup POSIX menggunakan UID, untuk non LDAP Grup POSIX menggunakan pengguna penuh DN',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, Anda dapat menentukan atribut akses di sini.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, Anda dapat menentukan apakah aplikasi akan berhenti jika e. g. koneksi ke server tidak dapat dibangun karena masalah jaringan.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, Anda dapat memeriksa apakah pengguna diijinkan untuk otentikasi karena ia berada dalam posixGroup, misalnya kebutuhan pengguna berada dalam xyz kelompok untuk menggunakan OTRS. Tentukan kelompok, yang dapat mengakses sistem.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Jika "LDAP" dipilih, Anda dapat menambahkan filter untuk setiap query LDAP, (email = *), (objectclass=user) atau (!Objectclass=komputer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'assword untuk otentikasi ke host radius harus ditentukan.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Jika "Radius" dipilih untuk Customer::AuthModule, host radius harus ditentukan.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Jika "Radius" dipilih untuk Customer::AuthModule, Anda dapat menentukan apakah aplikasi akan berhenti jika e. g. koneksi ke server tidak dapat dibangun karena masalah jaringan.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Jika "Sendmail" terpilih sebagai SendmailModul, lokasi biner sendmail dan opsi yang diperlukan harus ditentukan.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'Jika "syslog" dipilih untuk LogModule, fasilitas log khusus dapat ditentukan.',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Jika "syslog" dipilih untuk LogModule, yang charset harus digunakan untuk penebangan dapat ditentukan.',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Jika "file" dipilih untuk LogModule, file log harus ditentukan. Jika file tidak ada, maka akan dibuat oleh sistem.',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            'Jika aktif, tidak ada ekspresi reguler dapat mencocokkan alamat email pengguna untuk memungkinkan pendaftaran.',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            'Jika aktif, salah satu ekspresi reguler harus sesuai alamat email pengguna untuk memungkinkan pendaftaran.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Jika salah satu "SMTP" mekanisme terpilih sebagai Sendmail Modul, dan otentikasi ke mail server diperlukan, password harus ditentukan.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Jika salah satu "SMTP" mekanisme terpilih sebagai Sendmail Modul, dan otentikasi ke mail server yang dibutuhkan, username harus ditentukan.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Jika salah satu "SMTP" mekanisme terpilih sebagai Sendmail Modul, yang mailhost yang mengirimkan kiriman harus ditentukan.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Jika salah satu "SMTP" mekanisme terpilih sebagai Sendmail Modul, port mana mail server Anda mendengarkan koneksi masuk harus ditentukan.',
        'If enabled debugging information for ACLs is logged.' => 'Jika informasi debugging diaktifkan untuk ACL login.',
        'If enabled debugging information for transitions is logged.' => 'Jika diaktifkan informasi untuk transisi debug login.',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            'Jika diaktifkan daemon akan mengarahkan aliran standard error ke file log.',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            'Jika diaktifkan daemon akan mengarahkan output stream standar untuk file log.',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTRSHome>/var/run/ can not be used.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'Jika diaktifkan, OTRS akan memberikan semua file JavaScript dalam bentuk minified.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Jika diaktifkan, Telepon Tiket dan Ticket Email akan terbuka di jendela baru.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the cache data be held in memory.' => '',
        'If enabled, the cache data will be stored in cache backend.' => '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            'Jika diaktifkan, pelanggan dapat mencari tiket di semua layanan (layanan terlepas apa yang ditugaskan kepada pelanggan).',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Jika diaktifkan, ikhtisar yang berbeda (Dashboard, Lockview, QueueView) akan secara otomatis me-refresh setelah waktu yang ditentukan.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Jika diaktifkan, tingkat pertama dari menu utama terbuka pada mouse hover (bukan klik saja).',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTRSTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            '',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            'Jika diatur, alamat ini digunakan sebagai pengirim amplop di pesan keluar (tidak pemberitahuan - lihat di bawah). Jika tidak ada alamat yang ditentukan, pengirim amplop sama dengan antrian alamat e-mail.',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Jika regex ini cocok, tidak ada pesan akan dikirim oleh autoresponder.',
        'If this setting is enabled, it is possible to install packages which are not verified by OTRS Group. These packages could threaten your whole system!' =>
            '',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            '',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Import appointments screen.' => '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            'Termasuk tiket dari subqueues per default ketika memilih antrian.',
        'Include unknown customers in ticket filter.' => 'Termasuk pelanggan yang tidak diketahui dalam filter tiket.',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Termasuk artikel untuk membuat waktu dalam pencarian tiket dari antarmuka agen.',
        'Incoming Phone Call.' => 'Masuk Panggilan Telepon.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            'IndexAccelerator: untuk memilih modul backend TicketViewAccelerator Anda. "RuntimeDB" menghasilkan setiap tampilan antrian pada terbang dari meja tiket (tidak ada masalah kinerja sampai dengan kira-kira. 60.000 tiket total dan 6.000 tiket terbuka dalam sistem). "StaticDB" adalah modul yang paling kuat, itu menggunakan tiket-indeks tabel tambahan yang bekerja seperti pandangan (dianjurkan jika lebih dari 80.000 dan 6.000 tiket terbuka disimpan dalam sistem). Gunakan perintah "bin / otrs.Console.pl Maint :: Ticket :: QueueIndexRebuild" untuk penciptaan indeks awal.',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            '',
        'Indonesian' => 'Indonesia',
        'Inline' => '',
        'Input' => 'Input',
        'Interface language' => 'bahasa antarmuka',
        'Internal communication channel.' => '',
        'International Workers\' Day' => 'Hari Pekerja Internasional',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Hal ini dimungkinkan untuk mengkonfigurasi kulit yang berbeda, misalnya untuk membedakan antara agen berbeda, untuk digunakan pada basis per-domain dalam aplikasi. Menggunakan ekspresi reguler (regex), Anda dapat mengkonfigurasi sepasang Konten/Key untuk mencocokkan domain. Nilai di "Key" harus sesuai domain, dan nilai dalam "Content" harus menjadi kulit valid pada sistem Anda. Silahkan lihat contoh entri untuk bentuk yang tepat dari regex.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Hal ini dimungkinkan untuk mengkonfigurasi kulit yang berbeda, misalnya untuk membedakan antara pelanggan yang berbeda, untuk digunakan pada basis per-domain dalam aplikasi. Menggunakan ekspresi reguler (regex), Anda dapat mengkonfigurasi sepasang Konten / Key untuk mencocokkan domain. Nilai di "Key" harus sesuai domain, dan nilai dalam "Content" harus menjadi kulit valid pada sistem Anda. Silahkan lihat contoh entri untuk bentuk yang tepat dari regex.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'Hal ini dimungkinkan untuk mengkonfigurasi tema yang berbeda, misalnya untuk membedakan antara agen dan pelanggan, untuk digunakan pada basis per-domain dalam aplikasi. Menggunakan ekspresi reguler (regex), Anda dapat mengkonfigurasi sepasang Konten / Key untuk mencocokkan domain. Nilai di "Key" harus sesuai domain, dan nilai dalam "Content" harus menjadi tema yang valid pada sistem Anda. Silahkan lihat contoh entri untuk bentuk yang tepat dari regex.',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            '',
        'Italian' => 'Italia',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            'kata berhenti Italia untuk indeks fulltext. Kata-kata ini akan dihapus dari indeks pencarian.',
        'Ivory' => 'Gading',
        'Ivory (Slim)' => 'Ivory (slim)',
        'Japanese' => 'Jepang',
        'JavaScript function for the search frontend.' => 'Fungsi JavaScript untuk pencarian frontend ',
        'Korean' => '',
        'Language' => 'Bahasa',
        'Large' => 'Besar',
        'Last Screen Overview' => '',
        'Last customer subject' => 'subjek pelanggan terakhir',
        'Lastname Firstname' => 'Nama Pertama Nama Akhir',
        'Lastname Firstname (UserLogin)' => 'Nama Akhir Nama Pertama (Pengguna masuk)',
        'Lastname, Firstname' => 'Nama akhir, nama pertama',
        'Lastname, Firstname (UserLogin)' => 'Nama akhir, nama pertama (Pengguna Masuk)',
        'LastnameFirstname' => '',
        'Latvian' => 'Latvia',
        'Left' => 'Kiri',
        'Link Object' => 'Hubungkan objek',
        'Link Object.' => 'Hubungkan objek',
        'Link agents to groups.' => 'Hubungkan agen ke grup',
        'Link agents to roles.' => 'Hubungkan agen ke rol',
        'Link customer users to customers.' => '',
        'Link customer users to groups.' => '',
        'Link customer users to services.' => '',
        'Link customers to groups.' => '',
        'Link queues to auto responses.' => 'Link permintaan otomatis respon',
        'Link roles to groups.' => 'Menghubungkan peran ke kelompok.',
        'Link templates to attachments.' => '',
        'Link templates to queues.' => 'Link template untuk antrian.',
        'Link this ticket to other objects' => 'Hubungkan tiket ini dengan objek lain',
        'Links 2 tickets with a "Normal" type link.' => 'Link 2 tiket dengan jenis link "Normal"',
        'Links 2 tickets with a "ParentChild" type link.' => 'Link 2 tiket dengan jenis link "ParentChild" ',
        'Links appointments and tickets with a "Normal" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Daftar file CSS untuk selalu dimuat ke antarmuka agen.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Daftar file CSS untuk selalu dimuat ke antarmuka pelanggan.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Daftar file JS untuk selalu dimuat untuk antarmuka agen.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Daftar file JS untuk selalu dimuat untuk antarmuka pelanggan.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'Daftar semua peristiwa Perusahaan Pelanggan yang akan ditampilkan di GUI',
        'List of all CustomerUser events to be displayed in the GUI.' => 'Daftar semua peristiwa Nasabah Pengguna yang akan ditampilkan di GUI.',
        'List of all DynamicField events to be displayed in the GUI.' => 'Daftar semua peristiwa DynamicField yang akan ditampilkan di GUI.',
        'List of all LinkObject events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => 'Daftar semua peristiwa Paket yang akan ditampilkan di GUI.',
        'List of all appointment events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => 'Daftar semua peristiwa artikel yang akan ditampilkan di GUI.',
        'List of all calendar events to be displayed in the GUI.' => '',
        'List of all queue events to be displayed in the GUI.' => 'Daftar semua peristiwa antrian yang akan ditampilkan di GUI.',
        'List of all ticket events to be displayed in the GUI.' => 'Daftar semua peristiwa tiket yang akan ditampilkan di GUI.',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Daftar default Standar Template yang ditugaskan secara otomatis ke Antrian baru pada penciptaan.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            'Daftar file CSS responsif untuk selalu dimuat ke antarmuka agen.',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            'Daftar file CSS responsif untuk selalu dimuat ke antarmuka pelanggan.',
        'List view' => 'Daftar tampilan',
        'Lithuanian' => 'Lithuania',
        'Loader module registration for the agent interface.' => '',
        'Loader module registration for the customer interface.' => '',
        'Lock / unlock this ticket' => 'Mengunci / membuka tiket ini',
        'Locked Tickets' => 'Tiket terkunci',
        'Locked Tickets.' => 'Tiket dikunci',
        'Locked ticket.' => 'Tiket yang dikunci',
        'Logged in users.' => '',
        'Logged-In Users' => '',
        'Logout of customer panel.' => 'Keluar dari panel pelanggan.',
        'Look into a ticket!' => 'Lihat ke dalam tiket ini!',
        'Loop protection: no auto-response sent to "%s".' => '',
        'Macedonian' => '',
        'Mail Accounts' => 'Akun email',
        'MailQueue configuration settings.' => '',
        'Main menu item registration.' => '',
        'Main menu registration.' => 'Menu utama untuk pendaftaran ',
        'Makes the application block external content loading.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Membuat aplikasi untuk memeriksa catatan MX alamat email sebelum mengirim email   telepon atau email tiket.',
        'Makes the application check the syntax of email addresses.' => 'Membuat aplikasi memeriksa catatan MX alamat email sebelum mengirim email untuk mengirimkan telepon atau email tiket.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Membuat manajemen sesi cookie penggunaan html. Jika html cookies dinonaktifkan atau jika cookies html browser klien dinonaktifkan, maka sistem akan bekerja seperti biasa dan menambahkan sesi id ke link.',
        'Malay' => 'Melayu',
        'Manage OTRS Group cloud services.' => 'Mengelola layanan cloud OTRS Group.',
        'Manage PGP keys for email encryption.' => 'Mengelola kunci PGP untuk enkripsi email.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Mengelola POP3 atau IMAP account untuk mengambil email dari.',
        'Manage S/MIME certificates for email encryption.' => 'Mengelola sertifikat  S/MIME untuk enkripsi email.',
        'Manage System Configuration Deployments.' => '',
        'Manage different calendars.' => '',
        'Manage existing sessions.' => 'Mengelola sesi yang ada.',
        'Manage support data.' => 'Mengelola data dukungan.',
        'Manage system registration.' => 'Mengelola sistem pendaftaran.',
        'Manage tasks triggered by event or time based execution.' => 'Mengelola tugas dipicu oleh peristiwa atau waktu eksekusi berdasarkan.',
        'Mark as Spam!' => 'Tandai sebagai Spam!',
        'Mark this ticket as junk!' => 'Tandai tiket ini sebagai sampah!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Ukuran Max (dalam karakter) dari meja informasi pelanggan (telepon dan email) di layar compose.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Ukuran Max (dalam baris) dari agen informasi kotak di antarmuka agen.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Ukuran Max (dalam baris) yang terlibat dengan agen kotak di antarmuka agen.',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            'Ukuran Max subjek dalam email balasan dan di beberapa layar gambar',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'email tanggapan auto maksimum untuk email-address sendiri hari (Loop-Protection).',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Ukuran maksimal di KByte untuk mail yang dapat diambil melalui POP3/POP3S/IMAP/IMAPS(KByte).',
        'Maximum Number of a calendar shown in a dropdown.' => 'Jumlah maksimum kalender ditampilkan dalam sebuah dropdown.',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Panjang maksimal (dalam karakter) dari bidang yang dinamis dalam artikel dari tampilan zoom tiket.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'panjang maksimum (dalam karakter) dari bidang yang dinamis di sidebar tampilan zoom tiket.',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Jumlah maksimum tiket yang akan ditampilkan dalam hasil pencarian di antarmuka agen.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Jumlah maksimum tiket yang akan ditampilkan dalam hasil pencarian di antarmuka pelanggan.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            'Jumlah maksimum tiket yang akan ditampilkan dalam hasil operasi ini.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'ukuran maksimum (dalam karakter) dari meja informasi pelanggan dalam tampilan zoom tiket.',
        'Medium' => 'Medium',
        'Merge this ticket and all articles into another ticket' => '',
        'Merged Ticket (%s/%s) to (%s/%s).' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => 'igabung Tiket <OTRS TIKET> ke <OTRS MERGE_TO_TICKET>.',
        'Minute' => '',
        'Miscellaneous' => 'bermacam-macam',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Modul untuk To-pilihan di layar tiket baru di antarmuka pelanggan.',
        'Module to check if a incoming e-mail message is bounce.' => '',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            'Modul untuk memeriksa izin kelompok untuk akses pelanggan untuk tiket.',
        'Module to check the group permissions for the access to tickets.' =>
            'Modul untuk memeriksa akses group untuk akses ke tiket.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Modul untuk menulis pesan ditandatangani (PGP atau S/MIME).',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            '',
        'Module to encrypt composed messages (PGP or S/MIME).' => '',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Modul untuk menyaring dan memanipulasi pesan yang masuk. Blok / mengabaikan semua email spam yang dengan Dari: noreply @ alamat.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'Modul untuk menyaring dan memanipulasi pesan yang masuk. Dapatkan nomor 4 digit untuk tiket teks bebas, menggunakan regex di Pertandingan e. g. Dari => \'(. +?) @. +?\', Dan menggunakan () sebagai [***] di Set =>.',
        'Module to filter encrypted bodies of incoming messages.' => '',
        'Module to generate accounted time ticket statistics.' => 'Modul untuk menghasilkan catatan statistik tiket waktu.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Modul untuk menghasilkan profil OpenSearch html untuk pencarian tiket singkat di antarmuka agen.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Modul untuk menghasilkan profil OpenSearch html untuk pencarian tiket singkat di antarmuka pelanggan.',
        'Module to generate ticket solution and response time statistics.' =>
            'Modul untuk menghasilkan solusi tiket dan waktu statistik respon.',
        'Module to generate ticket statistics.' => 'Modul untuk menghasilkan statistik tiket.',
        'Module to grant access if the CustomerID of the customer has necessary group permissions.' =>
            '',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            'Modul untuk memberikan akses jika ID Pelanggan tiket sesuai dengan ID Pelanggan dari pelanggan.',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            'Modul untuk memberikan akses jika UserID Pelanggan tiket sesuai dengan UserID pelanggan dari pelanggan.',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            'Modul untuk memberikan akses ke agen yang telah terlibat dalam tiket di masa lalu (berdasarkan entri sejarah tiket).',
        'Module to grant access to the agent responsible of a ticket.' =>
            'Modul untuk memberikan akses ke agen yang bertanggung jawab dari tiket.',
        'Module to grant access to the creator of a ticket.' => 'Modul untuk memberikan akses ke pencipta tiket.',
        'Module to grant access to the owner of a ticket.' => 'Modul untuk memberikan akses kepada pemilik tiket.',
        'Module to grant access to the watcher agents of a ticket.' => 'Modul untuk memberikan akses ke agen Penjaga tiket.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'Modul untuk menampilkan pemberitahuan dan eskalasi (Tampil Max: Max ditampilkan escalations, Eskalasi Menit: Tampilkan tiket yang akan eskalasi dalam, CacheTime: Cache eskalasi dihitung dalam detik).',
        'Module to use database filter storage.' => 'Modul untuk menggunakan database penyimpanan filter.',
        'Module used to detect if attachments are present.' => '',
        'Multiselect' => 'Berbagai pilihan',
        'My Queues' => 'Antrian saya',
        'My Services' => 'Layanan saya',
        'My Tickets.' => 'Tiket saya',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Nama antrian kustom. Antrian kustom adalah pilihan antrian antrian pilihan Anda dan dapat dipilih dalam pengaturan preferensi.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            'Nama layanan kustom. Layanan kustom adalah pilihan layanan jasa Anda disukai dan dapat dipilih dalam pengaturan preferensi.',
        'NameX' => 'Nama X',
        'New Ticket' => 'Tiket baru',
        'New Tickets' => 'Tiket baru',
        'New Window' => 'Jendela baru',
        'New Year\'s Day' => 'Hari Tahun Baru',
        'New Year\'s Eve' => 'Malam Tahun Baru',
        'New process ticket' => 'Proses tiket baru',
        'News about OTRS releases!' => 'Berita tentang perilisan OTRS!',
        'News about OTRS.' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Berikutnya state tiket memungkinkan setelah menambahkan catatan telepon di telepon tiket layar masuk dari interface agen.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Berikutnya state tiket memungkinkan setelah menambahkan catatan telepon di layar keluar ponsel tiket dari antarmuka agen.',
        'No public key found.' => '',
        'No valid OpenPGP data found.' => '',
        'None' => 'None',
        'Norwegian' => 'Norwegian',
        'Notification Settings' => 'Pengaturan notifikasi',
        'Notified about response time escalation.' => '',
        'Notified about solution time escalation.' => '',
        'Notified about update time escalation.' => '',
        'Number of displayed tickets' => 'Jumlah tiket yang ditampilkan',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Jumlah baris (per tiket) yang ditunjukkan oleh utilitas pencarian di antarmuka agen.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Jumlah tiket yang akan ditampilkan di setiap halaman hasil pencarian di antarmuka agen.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Jumlah tiket yang akan ditampilkan di setiap halaman hasil pencarian di antarmuka pelanggan.',
        'Number of tickets to be displayed in each page.' => '',
        'OTRS Group Services' => '',
        'OTRS News' => 'Berita OTRS',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            'OTRS dapat menggunakan satu atau lebih database cermin dibaca untuk operasi mahal seperti penuh pencarian teks atau statistik generasi. Di sini Anda dapat menentukan DSN untuk database cermin pertama.',
        'OTRS doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            '',
        'Open an external link!' => '',
        'Open tickets (customer user)' => 'Tiket terbuka (pelanggan pengguna)',
        'Open tickets (customer)' => 'Buka tiket (pelanggan)',
        'Option' => 'Pilihan',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'batasan antrian opsional untuk Creator Periksa modul izin. Jika diatur, izin hanya diberikan tiket di antrian yang ditentukan.',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'batasan antrian opsional untuk modul InvolvedCheck izin . Jika diatur, izin hanya diberikan tiket di antrian yang ditentukan.',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'batasan antrian opsional untuk OwnerCheck modul izin. Jika diatur, izin hanya diberikan tiket di antrian yang ditentukan.',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'batasan antrian opsional untuk modul ResponsibleCheck izin. Jika diatur, izin hanya diberikan tiket di antrian yang ditentukan.',
        'Other Customers' => '',
        'Out Of Office' => 'Diluar kantor',
        'Out Of Office Time' => 'Waktu diluar kantor',
        'Out of Office users.' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Overload (mengubah) fungsi yang ada di Kernel::Sistem::Ticket. Digunakan dengan mudah untuk menambahkan kustomisasi.',
        'Overview Escalated Tickets.' => 'Ikhtisar Tiket meningkat.',
        'Overview Refresh Time' => 'Ikhtisar Segarkan Waktu',
        'Overview of all Tickets per assigned Queue.' => '',
        'Overview of all appointments.' => '',
        'Overview of all escalated tickets.' => 'Tinjauan dari semua eskalasi tiket',
        'Overview of all open Tickets.' => 'Tinjauan dari semua Tiket terbuka.',
        'Overview of all open tickets.' => 'Tinjauan dari semua tiket terbuka.',
        'Overview of customer tickets.' => 'Ikhtisar tiket pelanggan.',
        'PGP Key' => 'Kunci PGP',
        'PGP Key Management' => 'PGP Manajemen Kunci',
        'PGP Keys' => 'Kunci-kunci PGP',
        'Package event module file a scheduler task for update registration.' =>
            'Paket acara modul mengajukan tugas scheduler untuk pendaftaran pembaruan.',
        'Parameters for the CreateNextMask object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the column filters of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameter untuk backend dashboard pelanggan id Status widget dari antarmuka agen. "Grup" digunakan untuk membatasi akses ke plugin (e g Grup:.. Admin; group1, group2;). "Default" menentukan apakah plugin diaktifkan secara default atau jika pengguna perlu mengaktifkannya secara manual. "CacheTTLLocal" adalah waktu cache di menit untuk plugin.',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameter untuk backend dashboard pelanggan pengguna daftar gambaran dari antarmuka agen. "Batas" adalah jumlah entri yang ditampilkan secara default. "Grup" digunakan untuk membatasi akses ke plugin (e g Grup:.. Admin; group1, group2;). "Default" menentukan apakah plugin diaktifkan secara default atau jika pengguna perlu mengaktifkannya secara manual. "CacheTTLLocal" adalah waktu cache di menit untuk plugin.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the pages (in which the communication log entries are shown) of the communication log overview.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => 'Parameter dari contoh SLA atribut Komentar 2.',
        'Parameters of the example queue attribute Comment2.' => 'Parameter dari contoh antrian atribut Komentar 2.',
        'Parameters of the example service attribute Comment2.' => 'Parameter dari layanan contoh atribut Komentar 2.',
        'Parent' => 'Parent',
        'ParentChild' => 'Parentchild',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Path untuk file log (hanya berlaku jika "FS" dipilih untuk loop Modul Perlindungan dan itu adalah wajib).',
        'Pending time' => '',
        'People' => 'Orang',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            '',
        'Permitted width for compose email windows.' => 'lebar diizinkan untuk windows email compose.',
        'Permitted width for compose note windows.' => 'lebar diizinkan untuk windows catatan tulis.',
        'Persian' => 'Persia',
        'Phone Call Inbound' => 'Panggilan telepon masuk',
        'Phone Call Outbound' => 'Panggilan telepon keluar',
        'Phone Call.' => 'Panggilan telepon.',
        'Phone call' => 'Panggilan telepon',
        'Phone communication channel.' => '',
        'Phone-Ticket' => 'Telepon-Tiket',
        'Picture Upload' => 'muat naik gambar',
        'Picture upload module.' => 'Modul muat naik gambar',
        'Picture-Upload' => 'Gambar-dimuat',
        'Plugin search' => '',
        'Plugin search module for autocomplete.' => '',
        'Polish' => 'Polandia',
        'Portuguese' => 'Portugis',
        'Portuguese (Brasil)' => 'Portugis (Brasil)',
        'PostMaster Filters' => 'Filter PostMaster',
        'PostMaster Mail Accounts' => 'Akun email postmaster',
        'Print this ticket' => 'Cetak tiket ini',
        'Priorities' => 'Prioritas',
        'Process Management Activity Dialog GUI' => 'Proses Kegiatan Dialog GUI Manajemen',
        'Process Management Activity GUI' => 'Proses manajemen aktivitas GUI',
        'Process Management Path GUI' => 'Proses manajemen GUI',
        'Process Management Transition Action GUI' => 'Proses Manajemen aksi transisi GUI',
        'Process Management Transition GUI' => 'Proses manajemen transisi GUI',
        'Process Ticket.' => 'Proses tiket',
        'Process pending tickets.' => 'Proses pending tiket',
        'ProcessID' => 'ProcessID',
        'Processes & Automation' => '',
        'Product News' => 'Berita produk',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue' =>
            '',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            '',
        'Public Calendar' => '',
        'Public calendar.' => '',
        'Queue view' => 'lihat antrian',
        'Queues ↔ Auto Responses' => '',
        'Rebuild the ticket index for AgentTicketQueue.' => 'Membangun kembali indeks tiket untuk AgentTicketQueue.',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            '',
        'Refresh interval' => 'refresh interval',
        'Registers a log module, that can be used to log communication related information.' =>
            '',
        'Reminder Tickets' => 'Tiket pengingat',
        'Removed subscription for user "%s".' => 'Hapus berlangganan untuk pengguna "%s".',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            '',
        'Removes old system configuration deployments (Sunday mornings).' =>
            '',
        'Removes old ticket number counters (each 10 minutes).' => '',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'Menghapus informasi watcher tiket ketika tiket diarsipkan.',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Menggantikan pengirim asli dengan alamat email pelanggan saat ini pada jawaban compose di layar compose tiket dari antarmuka agen.',
        'Reports' => 'Laporan',
        'Reports (OTRS Business Solution™)' => 'Laporan (Solusi bisnis OTRS™)',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            'Memproses ulang email dari direktori spool yang tidak dapat diimpor di tempat pertama.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'izin yang diperlukan untuk mengubah pelanggan tiket di antarmuka agen.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan layar tiket dekat di antarmuka agen.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan layar keluar email di antarmuka agen.',
        'Required permissions to use the email resend screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan layar bouncing tiket di antarmuka agen.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan layar compose tiket di antarmuka agen.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan tiket layar maju dalam antarmuka agen.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan layar teks bebas tiket di antarmuka agen.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan layar gabungan tiket dari tiket yang diperbesar di antarmuka agen.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan layar catatan tiket di antarmuka agen.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan layar pemilik tiket dari tiket yang diperbesar di antarmuka agen.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan layar tiket tertunda tiket diperbesar antarmuka agen.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan layar masuk ponsel tiket di antarmuka agen.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan layar keluar ponsel tiket di antarmuka agen.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan layar prioritas tiket dari tiket yang diperbesar di antarmuka agen.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'izin yang diperlukan untuk menggunakan tiket layar yang bertanggung jawab dalam antarmuka agen.',
        'Resend Ticket Email.' => '',
        'Resent email to "%s".' => '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Ulang dan membuka pemilik tiket jika itu dipindahkan ke antrian yang lain.',
        'Resource Overview (OTRS Business Solution™)' => '',
        'Responsible Tickets' => 'Tiket bertanggung jawab',
        'Responsible Tickets.' => 'Tiket penanggung jawab',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            'Mempertahankan semua layanan dalam daftar bahkan jika mereka adalah anak-anak dari elemen yang tidak valid.',
        'Right' => 'Kanan',
        'Roles ↔ Groups' => '',
        'Romanian' => '',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => 'Menjalankan proses tiket',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            'Menjalankan pencarian wildcard awal perusahaan pelanggan yang ada saat mengakses modul AdminCustomerCompany',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Menjalankan pencarian wildcard awal dari pengguna pelanggan yang ada saat mengakses modul AdminCustomerUser',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => 'Rusia',
        'S/MIME Certificates' => 'Sertifikat S/MIME',
        'SMS' => 'SMS',
        'SMS (Short Message Service)' => 'SMS (Layanan mesej pendek)',
        'Salutations' => 'Salam Pembuka',
        'Sample command output' => 'Contoh perintah output',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            'Menyimpan lampiran dari artikel. "DB" menyimpan semua data dalam database (tidak disarankan untuk menyimpan lampiran besar). "FS" menyimpan data di filesystem; ini lebih cepat tapi webserver harus berjalan di bawah pengguna OTRS. Anda dapat beralih antara modul bahkan pada sistem yang sudah di produksi tanpa kehilangan data. Catatan: Mencari nama lampiran tidak didukung ketika "FS" digunakan.',
        'Schedule a maintenance period.' => 'Jadwalkan masa pemeliharaan.',
        'Screen after new ticket' => 'Layar setelah tiket baru',
        'Search Customer' => 'Cari Pelanggan',
        'Search Ticket.' => 'Cari Tiket.',
        'Search Tickets.' => 'Cari Tiket.',
        'Search User' => 'Cari Pengguna',
        'Search backend default router.' => 'Cari backend default router.',
        'Search backend router.' => 'Cari router backend.',
        'Search.' => 'Mencari',
        'Second Christmas Day' => 'Hari Natal kedia',
        'Second Queue' => 'Antrian kedua',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => '',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Pilih pemisah karakter yang digunakan pada berkas CSV (Statistik dan pencarian). Jika anda tidak memilih pemisah disini, pemisah default untuk bahasa anda akan digunakan.',
        'Select your frontend Theme.' => 'Pilih tema frontend anda',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            '',
        'Select your preferred layout for the software.' => '',
        'Select your preferred theme for OTRS.' => '',
        'Selects the cache backend to use.' => 'Memilih backend cache untuk digunakan.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Memilih modul untuk menangani upload melalui antarmuka web. "DB" toko semua upload dalam database, "FS" menggunakan sistem file.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            '',
        'Send new outgoing mail from this ticket' => 'Kirim surat keluar baru dari tiket ini',
        'Send notifications to users.' => 'Mengirimkan pemberitahuan kepada pengguna.',
        'Sender type for new tickets from the customer inteface.' => 'Jenis pengirim untuk tiket baru dari antarmuka pelanggan.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Mengirimkan agen tindak lanjut pemberitahuan hanya untuk pemilik, jika tiket dibuka (default adalah untuk mengirim pemberitahuan ke semua agen).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Mengirimkan semua email keluar melalui bcc ke alamat yang ditentukan. Silakan gunakan ini hanya untuk alasan cadangan.',
        'Sends customer notifications just to the mapped customer.' => '',
        'Sends registration information to OTRS group.' => 'Mengirimkan informasi pendaftaran untuk kelompok OTRS.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Mengirimkan pemberitahuan amaran terkunci tiket setelah mencapai tanggal yang ditetapkan (hanya dikirim ke pemilik tiket).',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            '',
        'Sent "%s" notification to "%s" via "%s".' => '',
        'Sent auto follow-up to "%s".' => '',
        'Sent auto reject to "%s".' => '',
        'Sent auto reply to "%s".' => '',
        'Sent email to "%s".' => '',
        'Sent email to customer.' => '',
        'Sent notification to "%s".' => '',
        'Serbian Cyrillic' => 'Cyrillic Serbia',
        'Serbian Latin' => 'Serbia Latin',
        'Service Level Agreements' => 'Perjanjian Tingkat Layanan',
        'Service view' => 'lihat layanan',
        'ServiceView' => 'Tampilan servis',
        'Set a new password by filling in your current password and a new one.' =>
            '',
        'Set sender email addresses for this system.' => 'Mengatur alamat email pengirim untuk sistem ini.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Mengatur tinggi default (dalam piksel) dari artikel HTML inline di Agen Tiket Zoom.',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            'Mengatur batas dari tiket yang akan dilaksanakan pada agen generik yang akan mengeksekusi pekerjaan tunggal.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Mengatur ketinggian maksimum (dalam piksel) dari artikel HTML inline di Agen Tiket Zoom.',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '',
        'Set this ticket to pending' => 'Atur tiket ini menjadi Ditunda',
        'Sets if SLA must be selected by the agent.' => 'Set SLA harus dipilih oleh agen.',
        'Sets if SLA must be selected by the customer.' => 'Set SLA harus dipilih oleh pelanggan.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Menetapkan jika catatan harus diisi oleh agen. Dapat ditimpa oleh Ticket::Frontend::NeedAccountedTime.',
        'Sets if queue must be selected by the agent.' => '',
        'Sets if service must be selected by the agent.' => 'Set layanan harus dipilih oleh agen.',
        'Sets if service must be selected by the customer.' => 'Set layanan harus dipilih oleh pelanggan.',
        'Sets if state must be selected by the agent.' => '',
        'Sets if ticket owner must be selected by the agent.' => 'Set pemilik tiket harus dipilih oleh agen.',
        'Sets if ticket responsible must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Mengatur PendingTime dari tiket ke 0 jika negara berubah ke keadaan non-pending.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Menetapkan usia di menit (tingkat pertama) untuk menyoroti antrian yang berisi tiket tidak tersentuh.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Menetapkan usia di menit (tingkat kedua) untuk menyoroti antrian yang berisi tiket tidak tersentuh.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Menetapkan tingkat konfigurasi administrator. Tergantung pada tingkat config, beberapa pilihan sysconfig akan tidak ditampilkan. Tingkat config berada di dalam urutan: Expert, Advanced, Pemula. adalah tinggi tingkat config (contoh: Pemula adalah tertinggi), semakin kecil kemungkinan adalah bahwa pengguna tidak sengaja dapat mengkonfigurasi sistem dengan cara yang tidak dapat digunakan lagi.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            'Set hitungan artikel terlihat dalam modus preview ikhtisar tiket.',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            '',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Mengatur teks tubuh default untuk catatan ditambahkan dalam layar tiket penutupan antarmuka agen.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Mengatur teks tubuh default untuk catatan ditambahkan dalam layar tiket bergerak dari antarmuka agen.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Mengatur tubuh teks default untuk catatan ditambahkan dalam layar catatan tiket dari antarmuka agen.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Mengatur teks tubuh default untuk catatan ditambahkan dalam layar pemilik tiket dari tiket yang diperbesar di antarmuka agen.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Mengatur teks tubuh default untuk catatan ditambahkan dalam layar tiket yang tertunda dari tiket yang diperbesar di antarmuka agen.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Mengatur teks tubuh default untuk catatan yang ditambahkan dalam layar prioritas tiket dari tiket yang diperbesar di antarmuka agen.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Mengatur teks tubuh default untuk catatan yang ditambahkan dalam tiket layar yang bertanggung jawab dari antarmuka agen.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Mengatur pesan kesalahan default untuk layar login pada Agen dan antarmuka Pelanggan, itu ditunjukkan saat masa pemeliharaan sistem berjalan aktif.',
        'Sets the default link type of split tickets in the agent interface.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Mengatur jenis link default tiket di antarmuka agen.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Mengatur pesan default untuk layar login di Agen dan antarmuka Pelanggan, itu ditunjukkan saat masa pemeliharaan sistem berjalan aktif.',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            'Mengatur pesan default untuk pemberitahuan yang ditampilkan pada masa pemeliharaan sistem berjalan.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Set default berikutnya untuk tiket ponsel baru di antarmuka agen.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Menetapkan keadaan default tiket berikutnya, setelah terciptanya sebuah tiket email di antarmuka agen.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Mengatur teks catatan default untuk tiket telepon baru. Contoh \'tiket Baru melalui panggilan\' di antarmuka agen.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Menetapkan prioritas default untuk tiket email baru di antarmuka agen.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Menetapkan prioritas default untuk tiket ponsel baru di antarmuka agen.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Mengatur tipe pengirim default untuk tiket email baru di antarmuka agen.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Mengatur tipe pengirim default untuk tiket ponsel baru di antarmuka agen.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Menetapkan subjek default untuk tiket email baru (misalnya \'email Outbound\') di antarmuka agen.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Menetapkan subjek default untuk tiket ponsel baru (misalnya \'panggilan Telepon\') di antarmuka agen.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Menetapkan subjek default untuk catatan ditambahkan dalam layar tiket penutupan antarmuka agen.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Menetapkan subjek standar untuk review Catatan ditambahkan hearts Layar Tiket Penutupan Antarmuka agen.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Menetapkan subjek default untuk catatan ditambahkan dalam layar catatan tiket dari antarmuka agen.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Menetapkan subjek default untuk catatan ditambahkan dalam layar pemilik tiket dari tiket yang diperbesar di antarmuka agen.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Menetapkan subjek default untuk catatan ditambahkan dalam layar tiket tertunda dari tiket yang diperbesar di antarmuka agen.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Menetapkan subjek default untuk catatan ditambahkan dalam layar prioritas tiket dari tiket yang diperbesar di antarmuka agen.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Menetapkan subjek default untuk catatan ditambahkan dalam tiket layar yang bertanggung jawab dari antarmuka agen.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Mengatur teks default untuk tiket email baru di antarmuka agen',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime before a prior warning will be visible for the logged in agents.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the method PGP will use to sing and encrypt emails. Note Inline method is not compatible with RichText messages.' =>
            '',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            'Set ukuran loket tiket minimal "Auto Increment" terpilih sebagai TicketNumberGenerator. Default adalah 5, ini berarti konter dimulai dari 10000.',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            'Mengatur menit pemberitahuan ditampilkan untuk pemberitahuan tentang masa pemeliharaan sistem yang akan datang.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Menetapkan jumlah baris yang ditampilkan dalam pesan teks (misalnya garis tiket di Antrian Zoom).',
        'Sets the options for PGP binary.' => 'Menetapkan pilihan untuk PGP biner.',
        'Sets the password for private PGP key.' => 'Mengatur password untuk kunci PGP pribadi.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Mengatur unit waktu prefered (misalnya unit kerja, jam, menit).',
        'Sets the preferred digest to be used for PGP binary.' => '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Menetapkan awalan ke script folder di server, sebagai dikonfigurasi pada server web. Pengaturan ini digunakan sebagai variabel, OTRS_CONFIG_ScriptAlias yang ditemukan dalam semua bentuk pesan yang digunakan oleh aplikasi, untuk membangun link ke tiket dalam sistem.',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            'Set antrian dalam tiket layar penutupan tiket diperbesar dalam antarmuka agen.',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            'Set antrian di layar teks tiket gratis dari tiket yang diperbesar di antarmuka agen.',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            'Set antrian di layar catatan tiket dari tiket yang diperbesar di antarmuka agen.',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Set antrian di layar pemilik tiket dari tiket yang diperbesar di antarmuka agen.',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Set antrian di layar tiket tertunda tiket diperbesar antarmuka agen.',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Set antrian di layar prioritas tiket dari tiket yang diperbesar di antarmuka agen.',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            'Set antrian dalam tiket layar bertanggung jawab dari tiket yang diperbesar di antarmuka agen.',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'Set agen yang bertanggung jawab dari tiket di layar tiket penutupan antarmuka agen.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Set agen yang bertanggung jawab dari tiket di layar massal tiket dari antarmuka agen.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Set agen yang bertanggung jawab dari tiket di tiket layar teks bebas dari antarmuka agen.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Set agen yang bertanggung jawab dari tiket di layar catatan tiket dari antarmuka agen.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Set agen yang bertanggung jawab dari tiket di layar pemilik tiket dari tiket yang diperbesar di antarmuka agen.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Set agen yang bertanggung jawab dari tiket di layar tiket tertunda tiket diperbesar antarmuka agen.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Set agen yang bertanggung jawab dari tiket di layar prioritas tiket dari tiket yang diperbesar di antarmuka agen.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Set agen yang bertanggung jawab dari tiket di tiket layar yang bertanggung jawab dari antarmuka agen.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the stats hook.' => 'Mengatur stats hook',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Menetapkan pemilik tiket di layar tiket penutupan antarmuka agen.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Menetapkan pemilik tiket di layar massal tiket dari antarmuka agen.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Menetapkan pemilik tiket di tiket layar teks bebas dari antarmuka agen.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Menetapkan pemilik tiket di layar catatan tiket dari antarmuka agen.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Menetapkan pemilik tiket di layar pemilik tiket dari tiket yang diperbesar di antarmuka agen.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Menetapkan pemilik tiket di tiket tertunda layar tiket diperbesar dalam antarmuka agen.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Menetapkan pemilik tiket di layar prioritas tiket dari tiket yang diperbesar di antarmuka agen.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Menetapkan pemilik tiket di tiket layar yang bertanggung jawab dari antarmuka agen.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Menetapkan jenis tiket di layar massal tiket dari antarmuka agen.',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the time zone being used internally by OTRS to e. g. store dates and times in the database. WARNING: This setting must not be changed once set and tickets or any other data containing date/time have been created.' =>
            '',
        'Sets the time zone that will be assigned to newly created users and will be used for users that haven\'t yet set a time zone. This is the time zone being used as default to convert date and time between the OTRS time zone and the user\'s time zone.' =>
            '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Menetapkan batas waktu (dalam detik) untuk download http / ftp.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Menetapkan batas waktu (dalam detik) untuk download paket. Menimpa "Web UserAgent :: Timeout".',
        'Shared Secret' => 'Berbagi rahasia',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Tampilkan pilihan yang bertanggung jawab di telepon dan email tiket di antarmuka agen.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Tampilkan artikel sebagai teks kaya bahkan jika menulis teks kaya dinonaktifkan.',
        'Show command line output.' => '',
        'Show queues even when only locked tickets are in.' => 'Tampilkan antrian bahkan ketika tiket hanya terkunci dalam.',
        'Show the current owner in the customer interface.' => 'Tampilkan pemilik saat ini di antarmuka pelanggan.',
        'Show the current queue in the customer interface.' => 'Tampilkan antrian saat ini di antarmuka pelanggan.',
        'Show the history for this ticket' => 'Tampilkan sejarah untuk tiket ini',
        'Show the ticket history' => 'Tunjukan riwayat tiket',
        'Shows a count of attachments in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for creating a calendar appointment linked to the ticket directly from the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu untuk berlangganan / berhenti berlangganan dari tiket dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu yang digunakan untuk Key "ClusterName" dan untuk Konten nama apapun yang ingin Anda lihat di UI.Menggunakan "ClusterPriority" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu yang memungkinkan menghubungkan tiket dengan obyek lain dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu yang digunakan untuk Key "ClusterName" dan untuk Konten nama apapun yang ingin Anda lihat di UI. Gunakan "Cluster Prioritas" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu yang memungkinkan penggabungan tiket dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu digunakan untuk Key "ClusterName" dan untuk Konten nama apapun yang ingin Anda lihat di AS. Menggunakan "ClusterPriority" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu untuk mengakses sejarah tiket dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu digunakan untuk Key "ClusterName" dan untuk Konten nama apapun yang ingin Anda lihat di AS. Menggunakan "ClusterPriority" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu untuk menambahkan kolom teks bebas dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu digunakan untuk Key "ClusterName" dan untuk Konten nama apapun yang ingin Anda lihat di UI. Menggunakan "Cluster Prioritas" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu untuk menambahkan catatan dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu digunakan untuk Key "CLUSTERNAME" dan untuk Konten nama apapun yang ingin Anda lihat di UI. Gunakan "ClusterPriority" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Menunjukkan link dalam menu untuk menambahkan catatan untuk tiket di setiap gambaran tiket dari antarmuka agen.',
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Menunjukkan link dalam menu untuk menutup tiket di setiap gambaran tiket dari antarmuka agen.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu untuk menutup tiket dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu digunakan untuk Key "CLUSTERNAME" dan untuk Konten nama apapun yang ingin Anda lihat di UI. Gunakan "ClusterPriority" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Menunjukkan link dalam menu untuk menghapus tiket di setiap gambaran tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2".',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu untuk menghapus tiket dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu digunakan untuk Key "ClusterName" dan untuk Konten nama apapun yang ingin Anda lihat di UI. Menggunakan "ClusterPriority" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            'Menunjukkan link dalam menu untuk mendaftarkan tiket ke proses dalam tampilan zoom tiket dari antarmuka agen.',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu untuk kembali dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu digunakan untuk Key "ClusterName" dan untuk Konten nama apapun yang ingin Anda lihat di UI. Menggunakan "ClusterPriority" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Menunjukkan link dalam menu untuk mengunci / membuka tiket di ikhtisar tiket dari antarmuka agen.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu untuk mengunci / membuka tiket dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu digunakan untuk Key "ClusterName" dan untuk Konten nama apapun yang ingin Anda lihat di UI. Menggunakan "ClusterPriority" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Menunjukkan link dalam menu untuk bergerak tiket di setiap gambaran tiket dari antarmuka agen.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu untuk mencetak tiket atau artikel dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu digunakan untuk Key "ClusterName" dan untuk Konten nama apapun yang ingin Anda lihat di UI. Menggunakan "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Menunjukkan link dalam menu untuk melihat sejarah tiket di setiap gambaran tiket dari antarmuka agen.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu untuk melihat prioritas tiket dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2".  Cluster item menu digunakan untuk Key "ClusterName" dan untuk Konten nama apapun yang ingin Anda lihat di UI. Menggunakan "ClusterPriority" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu untuk mengirim email keluar dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu digunakan untuk Key "ClusterName" dan untuk Konten nama apapun yang ingin Anda lihat di UI. Menggunakan "ClusterPriority" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Menunjukkan link dalam menu untuk mengatur tiket sebagai sampah di setiap gambaran tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2".',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link dalam menu untuk mengatur tiket sebagai tertunda dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu digunakan untuk Key "ClusterName" dan untuk Konten nama apapun yang ingin Anda lihat di UI. Menggunakan "ClusterPriority" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Menunjukkan link dalam menu untuk mengatur prioritas tiket di setiap gambaran tiket dari antarmuka agen.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Menunjukkan link dalam menu untuk tampilannya tiket di ikhtisar tiket dari antarmuka agen.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Menunjukkan link untuk mengakses lampiran artikel melalui viewer secara online html dalam tampilan zoom dari artikel di antarmuka agen.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Menunjukkan link untuk men-download lampiran artikel dalam tampilan zoom dari artikel di antarmuka agen.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Menunjukkan link untuk melihat tiket email yang diperbesar dalam teks biasa.',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Menunjukkan link untuk mengatur tiket sebagai sampah dalam tampilan zoom tiket dari antarmuka agen. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2". Cluster item menu digunakan untuk Key "ClusterName" dan untuk Konten nama apapun yang ingin Anda lihat di UI. Menggunakan "ClusterPriority" untuk mengkonfigurasi urutan cluster tertentu dalam toolbar.',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Menunjukkan daftar semua agen yang terlibat pada tiket ini, di layar tiket penutupan antarmuka agen.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Menunjukkan daftar semua agen yang terlibat pada tiket ini, di layar catatan tiket dari antarmuka agen.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan daftar semua agen yang terlibat pada tiket ini, di layar pemilik tiket dari tiket yang diperbesar di antarmuka agen.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan daftar semua agen yang terlibat pada tiket ini, di layar tiket tertunda dari tiket yang diperbesar di antarmuka agen.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan daftar semua agen yang terlibat pada tiket ini, di layar prioritas tiket dari tiket yang diperbesar di antarmuka agen.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Menunjukkan daftar semua agen yang terlibat pada tiket ini, dalam tiket layar yang bertanggung jawab dari antarmuka agen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Menunjukkan daftar semua agen yang mungkin (semua agen dengan izin catatan di antrian / tiket) untuk menentukan siapa yang harus diberitahu tentang catatan ini, di layar tiket penutupan antarmuka agen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Menunjukkan daftar semua agen yang mungkin (semua agen dengan izin catatan di antrian / tiket) untuk menentukan siapa yang harus diberitahu tentang catatan ini, dalam tiket layar teks bebas dari antarmuka agen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Menunjukkan daftar semua agen yang mungkin (semua agen dengan izin catatan di antrian / tiket) untuk menentukan siapa yang harus diberitahu tentang catatan ini, dalam tiket layar teks bebas dari antarmuka agen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan daftar semua agen yang mungkin (semua agen dengan izin catatan di antrian / tiket) untuk menentukan siapa yang harus diberitahu tentang catatan ini, di layar pemilik tiket dari tiket yang diperbesar di antarmuka agen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan daftar semua agen yang mungkin (semua agen dengan izin catatan di antrian / tiket) untuk menentukan siapa yang harus diberitahu tentang catatan ini, dalam tiket tertunda layar tiket diperbesar dalam antarmuka agen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan daftar semua agen yang mungkin (semua agen dengan izin catatan di antrian / tiket) untuk menentukan siapa yang harus diberitahu tentang catatan ini, di layar prioritas tiket dari tiket yang diperbesar di antarmuka agen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Menunjukkan daftar semua agen yang mungkin (semua agen dengan izin catatan di antrian / tiket) untuk menentukan siapa yang harus diberitahu tentang catatan ini, dalam tiket layar yang bertanggung jawab dari antarmuka agen.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Menunjukkan preview dari gambaran tiket (CustomerInfo => 1 - menunjukkan juga pelanggan-Info, CustomerInfo Max Ukuran max ukuran dalam karakter Pelanggan-Info.).',
        'Shows a teaser link in the menu for the ticket attachment view of OTRS Business Solution™.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => 'Menunjukkan semua baik antrian ro dan rw dalam tampilan antrian.',
        'Shows all both ro and rw tickets in the service view.' => 'Menunjukkan semua baik tiket ro dan rw dalam tampilan layanan.',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Menunjukkan semua tiket terbuka (bahkan jika mereka terkunci) dalam tampilan eskalasi antarmuka agen.',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Menunjukkan semua pengidentifikasi pelanggan dalam bidang multi-pilih (tidak berguna jika Anda memiliki banyak pengenal pelanggan).',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Menunjukkan pilihan pemilik di telepon dan email tiket di antarmuka agen.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Menunjukkan tiket sejarah pelanggan di AgentTicketPhone, AgentTicketEmail dan Pelanggan Agen Tiket.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Menunjukkan baik subjek pelanggan artikel terakhir atau judul tiket di gambaran format kecil.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Menunjukkan daftar antrian orang tua / anak yang ada dalam sistem dalam bentuk pohon atau daftar.',
        'Shows information on how to start OTRS Daemon' => 'Menunjukkan informasi tentang cara untuk memulai OTRS Daemon',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows the article head information in the agent zoom view.' => '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Menunjukkan artikel diurutkan secara normal atau terbalik, di bawah zoom tiket di antarmuka agen.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Menunjukkan informasi pelanggan pengguna (telepon dan email) di layar compose.',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Menunjukkan pesan hari di layar login dari antarmuka agen.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Menunjukkan sejarah tiket (urutan terbalik) di antarmuka agen.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Menunjukkan pilihan prioritas tiket di layar tiket penutupan antarmuka agen.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Menunjukkan pilihan prioritas tiket di layar bergerak tiket dari antarmuka agen.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Menunjukkan pilihan prioritas tiket di layar massal tiket dari antarmuka agen.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Menunjukkan pilihan prioritas tiket di tiket layar teks bebas dari antarmuka agen.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Menunjukkan pilihan prioritas tiket di layar catatan tiket dari antarmuka agen.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan pilihan prioritas tiket di layar pemilik tiket dari tiket yang diperbesar di antarmuka agen.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan pilihan prioritas tiket di tiket tertunda layar tiket diperbesar dalam antarmuka agen.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan pilihan prioritas tiket di layar prioritas tiket dari tiket yang diperbesar di antarmuka agen.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Menunjukkan pilihan prioritas tiket di tiket layar yang bertanggung jawab dari antarmuka agen.',
        'Shows the title field in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if enabled; or in short format (days, hours), if not enabled.' =>
            '',
        'Shows time use complete description (days, hours, minutes), if enabled; or just first letter (d, h, m), if not enabled.' =>
            '',
        'Signature data.' => '',
        'Signatures' => 'Tanda tangan',
        'Simple' => 'Sederhana',
        'Skin' => 'Kulit',
        'Slovak' => 'Slovak',
        'Slovenian' => 'Slovenia',
        'Small' => 'Kecil',
        'Software Package Manager.' => 'Software Package Manager.',
        'Solution time' => '',
        'SolutionDiffInMin' => 'solusi diffinmin',
        'SolutionInMin' => 'Solusi InMin',
        'Some description!' => 'Beberapa deskripsi!',
        'Some picture description!' => 'Beberapa keterangan gambar!',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Macam tiket (ascendingly atau descendingly) ketika antrian tunggal yang dipilih dalam tampilan antrian dan setelah tiket diurutkan berdasarkan prioritas. Nilai: 0 = naik (tertua di atas, default), 1 = descending (termuda di atas). Gunakan QueueID untuk kunci dan 0 atau 1 untuk nilai.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            'Macam tiket (ascendingly atau descendingly) ketika antrian tunggal yang dipilih dalam tampilan layanan dan setelah tiket diurutkan berdasarkan prioritas. Nilai: 0 = naik (tertua di atas, default), 1 = descending (termuda di atas). Gunakan ServiceID untuk kunci dan 0 atau 1 untuk nilai.',
        'Spam' => 'Spam',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Spam Assassin contoh setup. Mengabaikan email yang ditandai dengan SpamAssassin.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Spamassassin contoh setup. Bergerak ditandai mail ke antrian spam.',
        'Spanish' => 'Spanyol',
        'Spanish (Colombia)' => 'Spanyol (Colombia)',
        'Spanish (Mexico)' => 'Spanyol (Meksiko)',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            'kata berhenti Spanyol untuk indeks fulltext. Kata-kata ini akan dihapus dari indeks pencarian.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'kata berhenti Spanyol untuk indeks fulltext. Kata-kata ini akan dihapus dari indeks pencarian.',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => 'Menentukan direktori dimana sertifikat SSL disimpan.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Menentukan direktori dimana sertifikat SSL pribadi disimpan.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            'Menentukan alamat email yang harus digunakan oleh aplikasi saat mengirim pemberitahuan. Alamat email digunakan untuk membangun nama lengkap tampilan untuk master pemberitahuan (yaitu "OTRS Pemberitahuan" otrs@your.example.com). Anda dapat menggunakan variabel OTRS_CONFIG_FQDN sebagai set di configuation Anda, atau memilih alamat email lain.',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            'Menentukan alamat email untuk mendapatkan pesan pemberitahuan dari tugas scheduler.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'Menentukan kelompok mana kebutuhan pengguna izin rw sehingga ia dapat mengakses "Beralih Pelanggan" fitur.',
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
            '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            'Menentukan nama yang harus digunakan oleh aplikasi saat mengirim pemberitahuan. Nama pengirim digunakan untuk membangun nama lengkap tampilan untuk master pemberitahuan (yaitu "OTRS Pemberitahuan" otrs@your.example.com).',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Menentukan urutan nama depan dan nama belakang dari agen akan ditampilkan.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Menentukan path file untuk logo di header halaman  (gif|jpg|png, 700 x 100 pixel).',
        'Specifies the path of the file for the performance log.' => 'Menentukan path dari file untuk log kinerja.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Menentukan path ke converter yang memungkinkan tampilan file Microsoft Excel, di antarmuka web.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Menentukan path ke converter yang memungkinkan tampilan file Microsoft Word, di antarmuka web.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Menentukan path ke converter yang memungkinkan tampilan dokumen PDF, di antarmuka web.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Menentukan path ke converter yang memungkinkan tampilan file XML, di antarmuka web.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Menentukan teks yang akan muncul dalam file log untuk menunjukkan entri skrip CGI.',
        'Specifies user id of the postmaster data base.' => 'Ditentukan user id dari database postmaster.',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            'Menentukan apakah semua backends penyimpanan harus diperiksa ketika mencari lampiran. Ini hanya diperlukan untuk instalasi di mana beberapa lampiran dalam sistem file, dan lain-lain dalam database.',
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            'Tentukan berapa tingkat subdirektori untuk digunakan saat membuat file cache. Ini harus mencegah terlalu banyak file cache berada di satu direktori.',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            'Tentukan channel yang akan digunakan untuk mengambil update OTRS Business Solution ™. Peringatan: rilis Pembangunan mungkin tidak lengkap, sistem anda mungkin mengalami kesalahan dipulihkan dan pada kasus yang ekstrim bisa menjadi tidak responsif!',
        'Specify the password to authenticate for the first mirror database.' =>
            'Tentukan password untuk otentikasi untuk database cermin pertama.',
        'Specify the username to authenticate for the first mirror database.' =>
            'Tentukan username untuk otentikasi untuk database cermin pertama.',
        'Stable' => 'Stabil',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'izin tersedia standar untuk agen dalam aplikasi. Jika lebih banyak izin yang diperlukan, mereka dapat dimasukkan di sini. Izin harus didefinisikan untuk menjadi efektif. Beberapa izin yang baik lainnya juga telah tersedia built-in: dicatat, dekat, tertunda, pelanggan, FREETEXT, bergerak, menulis, bertanggung jawab, maju, dan mental. Pastikan bahwa "rw" selalu izin terdaftar terakhir.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Mulai nomor untuk statistik menghitung. Setiap kenaikan statebaru nomor ini.',
        'Started response time escalation.' => '',
        'Started solution time escalation.' => '',
        'Started update time escalation.' => '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Memulai pencarian wildcard dari objek aktif setelah link objek topeng dimulai.',
        'Stat#' => 'Stat#',
        'States' => 'Kondisi',
        'Statistic Reports overview.' => '',
        'Statistics overview.' => '',
        'Status view' => 'lihat Status',
        'Stopped response time escalation.' => '',
        'Stopped solution time escalation.' => '',
        'Stopped update time escalation.' => '',
        'Stores cookies after the browser has been closed.' => 'Toko kue setelah browser telah ditutup.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Strip garis kosong di preview tiket dalam tampilan antrian.',
        'Strips empty lines on the ticket preview in the service view.' =>
            'Strip garis kosong di preview tiket di tampilan layanan.',
        'Support Agent' => '',
        'Swahili' => 'Swahili',
        'Swedish' => 'Swedia',
        'System Address Display Name' => 'Sistem Alamat Nama Tampilan',
        'System Configuration Deployment' => '',
        'System Configuration Group' => '',
        'System Maintenance' => 'Perbaikan sistem',
        'Templates ↔ Attachments' => '',
        'Templates ↔ Queues' => '',
        'Textarea' => 'textarea',
        'Thai' => 'Thai',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'agen menguliti Nama internal yang harus digunakan dalam antarmuka agen. Silakan periksa kulit yang tersedia di  Frontend::Agent::Skins.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'Kulit pelanggan Nama internal yang harus digunakan dalam antarmuka pelanggan. Silakan periksa kulit yang tersedia di Frontend::Customer::Skins.',
        'The daemon registration for the scheduler cron task manager.' =>
            'Pendaftaran daemon untuk scheduler cron task manager.',
        'The daemon registration for the scheduler future task manager.' =>
            'Pendaftaran daemon untuk task manager masa depan yang dijadwalkan.',
        'The daemon registration for the scheduler generic agent task manager.' =>
            'Pendaftaran daemon untuk scheduler agen generik task manager.',
        'The daemon registration for the scheduler task worker.' => 'Pendaftaran daemon untuk pekerja tugas scheduler.',
        'The daemon registration for the system configuration deployment sync manager.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'Pembatas antara TicketHook dan nomor tiket. Mis \': \'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'Durasi dalam hitungan menit setelah memancarkan sebuah acara, di mana eskalasi baru memberitahukan dan mulai acara ditekan.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            'Format subjek. \'Left\' berarti \'[TicketHook #: 12345] Beberapa Subjek\', \'kanan\' berarti \'Beberapa Subjek [TicketHook #: 12345]\', \'Tidak\' berarti \'Beberapa Subjek\' dan tidak ada nomor tiket. Dalam kasus terakhir Anda harus memverifikasi bahwa Postmaster pengaturan :: CheckFollowUpModule ### 0200-Referensi diaktifkan untuk mengenali followups berdasarkan header email.',
        'The headline shown in the customer interface.' => 'judul menunjukkan dalam antarmuka pelanggan.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'Pengenal untuk tiket, e. Tiket #, Panggil #, MyTicket #. default adalah Ticket #.',
        'The logo shown in the header of the agent interface for the skin "High Contrast". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            'Logo dalam header dari antarmuka agen untuk kulit "default". Lihat "Agen Logo" untuk deskripsi lebih lanjut.',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            'Logo dalam header dari antarmuka agen untuk kulit "gading". Lihat "Agen Logo" untuk deskripsi lebih lanjut.',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            'Logo dalam header dari antarmuka agen untuk kulit "gading-slim". Lihat "Agen Logo" untuk deskripsi lebih lanjut.',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            'Logo dalam header dari antarmuka agen untuk kulit "tipis". Lihat "Agen Logo" untuk deskripsi lebih lanjut.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Logo dalam header dari antarmuka agen. URL untuk gambar bisa menjadi URL relatif ke direktori image kulit, atau URL lengkap ke web server jauh.',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Logo dalam header dari antarmuka pelanggan. URL untuk gambar bisa menjadi URL relatif ke direktori image kulit, atau URL lengkap ke web server jauh.',
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'Jumlah maksimal artikel diperluas pada satu halaman di  AgentTicketZoom.',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            'Jumlah maksimal artikel ditampilkan pada satu halaman di AgentTicketZoom.',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            'Jumlah maksimum mail diambil sekaligus sebelum menghubungkan kembali ke server.',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Teks pada awal subjek di balasan email, e.g.g. RAW, atau AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Teks pada awal subjek ketika email diteruskan, misalnya FW, Fwd, atau WG.',
        'The value of the From field' => '',
        'Theme' => 'Tema',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            '',
        'This is a Description for Comment on Framework.' => '',
        'This is a Description for DynamicField on Framework.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            'Ini adalah oranye standar - kulit hitam untuk antarmuka pelanggan.',
        'This is the default orange - black skin.' => 'Ini adalah oranye standar - kulit hitam.',
        'This key is not certified with a trusted signature!' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Modul ini dan fungsinya Pre Run () akan dieksekusi, jika ditetapkan, untuk setiap permintaan. Modul ini berguna untuk memeriksa beberapa pilihan pengguna atau untuk menampilkan berita tentang aplikasi baru.',
        'This module is part of the admin area of OTRS.' => 'Modul ini merupakan bagian admin dari OTRS.',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'Opsi ini mendefinisikan bidang yang dinamis di mana Proses Manajemen aktivitas entitas id disimpan.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'Opsi ini mendefinisikan bidang yang dinamis di mana Proses Manajemen proses entitas id disimpan.',
        'This option defines the process tickets default lock.' => 'Opsi ini mendefinisikan proses kunci default tiket',
        'This option defines the process tickets default priority.' => 'Opsi ini mendefinisikan prioritas default tiket proses.',
        'This option defines the process tickets default queue.' => 'Opsi ini mendefinisikan proses default queue tiket',
        'This option defines the process tickets default state.' => 'Opsi ini mendefinisikan tiket proses keadaan default.',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            'Opsi ini akan menyangkal akses ke tiket perusahaan pelanggan, yang tidak dibuat oleh pengguna pelanggan.',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            'Pengaturan ini memungkinkan Anda untuk menimpa daftar statebuilt-in dengan daftar negara Anda sendiri. Hal ini terutama berguna jika Anda hanya ingin menggunakan kelompok memilih kecil negara.',
        'This setting is deprecated. Set OTRSTimeZone instead.' => '',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
            '',
        'This will allow the system to send text messages via SMS.' => 'Hal ini akan memungkinkan sistem untuk mengirim pesan teks melalui SMS.',
        'Ticket Close.' => 'Tutup tiket.',
        'Ticket Compose Bounce Email.' => 'Tiket Compose Bounce Email.',
        'Ticket Compose email Answer.' => 'Tiket Susun email Jawaban.',
        'Ticket Customer.' => 'Tiket pelanggan',
        'Ticket Forward Email.' => 'Tiket yang di teruskan melalui email',
        'Ticket FreeText.' => 'Tiket bebas teks',
        'Ticket History.' => 'Riwayat tiket ',
        'Ticket Lock.' => 'Kunci tiket',
        'Ticket Merge.' => 'Tiket digabungkan',
        'Ticket Move.' => 'Tiket telah dipindahkan',
        'Ticket Note.' => 'Nota tiket ',
        'Ticket Notifications' => 'Pemberitahuan tiket',
        'Ticket Outbound Email.' => 'Tiket outbound email',
        'Ticket Overview "Medium" Limit' => 'Batas Gambaran "sedang" Tiket',
        'Ticket Overview "Preview" Limit' => 'Batas gambaran "pratinjau" tiket',
        'Ticket Overview "Small" Limit' => 'Batas Gambaran "Kecil" tiket',
        'Ticket Owner.' => 'Pemilik tiket',
        'Ticket Pending.' => 'Penundaan tiket',
        'Ticket Print.' => 'Cetak tiket',
        'Ticket Priority.' => 'Prioritas tiket',
        'Ticket Queue Overview' => 'Antrian tiket keseluruhan',
        'Ticket Responsible.' => 'Penanggung jawab tiket',
        'Ticket Watcher' => 'Watcher tiket',
        'Ticket Zoom' => '',
        'Ticket Zoom.' => 'Tiket Zoom.',
        'Ticket bulk module.' => 'Tiket massal modulus.',
        'Ticket event module that triggers the escalation stop events.' =>
            'Tiket acara modul yang memicu peristiwa eskalasi berhenti.',
        'Ticket limit per page for Ticket Overview "Medium".' => '',
        'Ticket limit per page for Ticket Overview "Preview".' => '',
        'Ticket limit per page for Ticket Overview "Small".' => '',
        'Ticket notifications' => 'Pemberitahuan tiket',
        'Ticket overview' => 'Keseluruhan tiket',
        'Ticket plain view of an email.' => 'Tampilan tiket polos di email',
        'Ticket split dialog.' => '',
        'Ticket title' => 'Judul tiket',
        'Ticket zoom view.' => 'Pandangan dekat tiket',
        'TicketNumber' => 'Nomor tiket',
        'Tickets.' => 'Tiket',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Waktu dalam detik yang akan ditambahkan ke waktu yang sebenarnya dari pengaturan tertunda-negara (default: 86400 = 1 hari).',
        'To accept login information, such as an EULA or license.' => 'Untuk menerima masuk nya informasi, seperti EULA atau surat izin.',
        'To download attachments.' => 'Untuk unduh lampiran',
        'To view HTML attachments.' => '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Matikan tampilan Fitur OTRS Add ons daftar di Package Manager.',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Toolbar Barang untuk jalan pintas. kontrol akses tambahan untuk menampilkan atau tidak menampilkan link ini dapat dilakukan dengan menggunakan Key "Group" dan konten seperti "rw:group1;move_into:group2".',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Tree view' => 'Tampilan struktur pohon',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            '',
        'Triggers ticket escalation events and notification events for escalation.' =>
            'Pemicu tiket acara eskalasi dan acara pemberitahuan untuk eskalasi.',
        'Turkish' => 'Turkish',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            'Mematikan validasi sertifikat SSL, misalnya jika Anda menggunakan proxy HTTPS transparan. Gunakan dengan resiko Anda sendiri!',
        'Turns on drag and drop for the main navigation.' => 'Menghidupkan drag and drop untuk navigasi utama.',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Tweak the system as you wish.' => '',
        'Type of daemon log rotation to use: Choose \'OTRS\' to let OTRS system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            '',
        'Ukrainian' => 'Ukraina',
        'Unlock tickets that are past their unlock timeout.' => 'Membuka tiket yang terakhir batas waktu membuka mereka.',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'Membuka tiket setiap kali catatan yang ditambahkan dan pemilik keluar dari kantor.',
        'Unlocked ticket.' => 'tiket dibuka.',
        'Up' => 'Atas',
        'Upcoming Events' => 'Event mendatang',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Update Ticket "Terlihat" bendera jika setiap artikel mendapat dilihat atau Pasal baru mendapat dibuat.',
        'Update time' => '',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Update indeks eskalasi tiket setelah atribut tiket harus diperbarui.',
        'Updates the ticket index accelerator.' => 'Updated indeks tiket akselerator.',
        'Upload your PGP key.' => 'Unggah kunci PGP Anda.',
        'Upload your S/MIME certificate.' => 'Unggah sertifikat S/MIME Anda',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            'Gunakan jenis baru bidang pilih dan autocomplete di antarmuka agen, di mana berlaku (InputFields).',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            'Gunakan jenis baru bidang pilih dan autocomplete di antarmuka pelanggan, di mana berlaku (InputFields).',
        'User Profile' => 'Profil pengguna',
        'UserFirstname' => 'Nama awal pemakai',
        'UserLastname' => 'Nama akhir pemakai',
        'Users, Groups & Roles' => '',
        'Uses richtext for viewing and editing ticket notification.' => 'Menggunakan richtext untuk pemberitahuan melihat dan mengedit tiket.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'Menggunakan teks kaya untuk melihat dan mengedit: artikel, salam, tanda tangan, template standar, tanggapan otomatis dan pemberitahuan.',
        'Vietnam' => 'Vietnam',
        'View all attachments of the current ticket' => '',
        'View performance benchmark results.' => 'Lihat hasil kinerja benchmark.',
        'Watch this ticket' => 'Amati tiket ini',
        'Watched Tickets' => 'Tiket yang diamati',
        'Watched Tickets.' => 'Tiket yang telah di amati',
        'We are performing scheduled maintenance.' => 'Kami sedang melakukan pemeliharaan yang telah terjadwal.',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'Kami sedang melakukan pemeliharaan yang telah terjadwal. Untuk sementara ini Login tidak tersedia.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'Kami sedang melakukan pemeliharaan yang telah terjadwal. Kami akan kembali Online sesaat lagi.',
        'Web Services' => 'Web servis',
        'Web View' => 'Tampilan jaringan.',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Ketika tiket digabung, catatan akan ditambahkan secara otomatis ke tiket yang tidak lagi aktif. Di sini Anda dapat menentukan isi catatan ini (teks ini tidak dapat diubah oleh agen).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'Ketika tiket digabung, catatan akan ditambahkan secara otomatis ke tiket yang tidak lagi aktif. Di sini Anda dapat menentukan subjek catatan ini (hal ini tidak dapat diubah oleh agen).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Ketika tiket digabung, pelanggan dapat diinformasikan per email dengan menetapkan kotak centang "Informasikan Sender". Di area teks ini, Anda dapat menentukan teks berformat pra yang nantinya dapat dimodifikasi oleh agen.',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            'Apakah atau tidak untuk mengumpulkan informasi meta dari artikel menggunakan filter dikonfigurasi di Ticket::Frontend::ZoomMetaFiltersCollect.',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            '',
        'Yes, but hide archived tickets' => 'Ya, tapi sembunyikan tiket yang telah di arsipkan.',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            'Email anda dengan nomor tiket "<OTRS_TICKET>" telah di gabung menjadi "<OTRS_BOUNCE_TO>". Hubungi alamat ini untuk informasi libel lanjut.',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Email anda dengan nomor tiket "<OTRS_TICKET>" telah di gabung menjadi "<OTRS_MERGE_TO_TICKET>".',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '',
        'Zoom' => 'Zoom',
        'attachment' => 'Lampiran',
        'bounce' => 'memantul',
        'compose' => 'buat',
        'debug' => 'Debug',
        'error' => 'eror',
        'forward' => 'lanjut',
        'info' => 'Info',
        'inline' => 'Di barisan',
        'normal' => 'normal',
        'notice' => 'Peringatan',
        'pending' => 'ditunda',
        'phone' => 'telepon',
        'responsible' => 'bertanggung jawab',
        'reverse' => 'Mundur',
        'stats' => 'statistik',

    };

    $Self->{JavaScriptStrings} = [
        ' ...and %s more',
        ' ...show less',
        '%s B',
        '%s GB',
        '%s KB',
        '%s MB',
        '%s TB',
        '+%s more',
        'A key with this name (\'%s\') already exists.',
        'A package upgrade was recently finished. Click here to see the results.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.',
        'Add',
        'Add Event Trigger',
        'Add all',
        'Add entry',
        'Add key',
        'Add new draft',
        'Add new entry',
        'Add to favourites',
        'Agent',
        'All occurrences',
        'All-day',
        'An error occurred during communication.',
        'An error occurred! Please check the browser error log for more details!',
        'An item with this name is already present.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.',
        'An unknown error occurred. Please contact the administrator.',
        'Apply',
        'Appointment',
        'Apr',
        'April',
        'Are you sure you want to delete this appointment? This operation cannot be undone.',
        'Are you sure you want to update all installed packages?',
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.',
        'Article display',
        'Article filter',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?',
        'Ascending sort applied, ',
        'Attachment was deleted successfully.',
        'Attachments',
        'Aug',
        'August',
        'Available space %s of %s.',
        'Basic information',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?',
        'Calendar',
        'Cancel',
        'Cannot proceed',
        'Clear',
        'Clear all',
        'Clear debug log',
        'Clear search',
        'Click to delete this attachment.',
        'Click to select a file for upload.',
        'Click to select a file or just drop it here.',
        'Click to select files or just drop them here.',
        'Clone web service',
        'Close preview',
        'Close this dialog',
        'Complex %s with %s arguments',
        'Confirm',
        'Could not open popup window. Please disable any popup blockers for this application.',
        'Current selection',
        'Currently not possible',
        'Customer interface does not support articles not visible for customers.',
        'Data Protection',
        'Date/Time',
        'Day',
        'Dec',
        'December',
        'Delete',
        'Delete Entity',
        'Delete conditions',
        'Delete draft',
        'Delete error handling module',
        'Delete field',
        'Delete invoker',
        'Delete operation',
        'Delete this Attachment',
        'Delete this Event Trigger',
        'Delete this Invoker',
        'Delete this Key Mapping',
        'Delete this Mail Account',
        'Delete this Operation',
        'Delete this PostMasterFilter',
        'Delete this Template',
        'Delete web service',
        'Deleting attachment...',
        'Deleting the field and its data. This may take a while...',
        'Deleting the mail account and its data. This may take a while...',
        'Deleting the postmaster filter and its data. This may take a while...',
        'Deleting the template and its data. This may take a while...',
        'Deploy',
        'Deploy now',
        'Deploying, please wait...',
        'Deployment comment...',
        'Deployment successful. You\'re being redirected...',
        'Descending sort applied, ',
        'Description',
        'Dismiss',
        'Do not show this warning again.',
        'Do you really want to continue?',
        'Do you really want to delete "%s"?',
        'Do you really want to delete this certificate?',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!',
        'Do you really want to delete this generic agent job?',
        'Do you really want to delete this key?',
        'Do you really want to delete this link?',
        'Do you really want to delete this notification language?',
        'Do you really want to delete this notification?',
        'Do you really want to delete this scheduled system maintenance?',
        'Do you really want to delete this statistic?',
        'Do you really want to reset this setting to it\'s default value?',
        'Do you really want to revert this setting to its historical value?',
        'Don\'t save, update manually',
        'Draft title',
        'Duplicate event.',
        'Duplicated entry',
        'Edit Field Details',
        'Edit this setting',
        'Edit this transition',
        'End date',
        'Error',
        'Error during AJAX communication',
        'Error during AJAX communication. Status: %s, Error: %s',
        'Error in the mail settings. Please correct and try again.',
        'Error: Browser Check failed!',
        'Event Type Filter',
        'Expanded',
        'Feb',
        'February',
        'Filters',
        'Find out more',
        'Finished',
        'First select a customer user, then select a customer ID to assign to this ticket.',
        'Fr',
        'Fri',
        'Friday',
        'Generate',
        'Generate Result',
        'Generating...',
        'Grouped',
        'Help',
        'Hide EntityIDs',
        'If you now leave this page, all open popup windows will be closed, too!',
        'Import web service',
        'Information about the OTRS Daemon',
        'Invalid date (need a future date)!',
        'Invalid date (need a past date)!',
        'Invalid date!',
        'It is going to be deleted from the field, please try again.',
        'It is not possible to add a new event trigger because the event is not set.',
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.',
        'It was not possible to delete this draft.',
        'It was not possible to generate the Support Bundle.',
        'Jan',
        'January',
        'Jul',
        'July',
        'Jump',
        'Jun',
        'June',
        'Just this occurrence',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.',
        'Less',
        'Link',
        'Loading, please wait...',
        'Loading...',
        'Location',
        'Mail check successful.',
        'Mapping for Key',
        'Mapping for Key %s',
        'Mar',
        'March',
        'May',
        'May_long',
        'Mo',
        'Mon',
        'Monday',
        'Month',
        'More',
        'Name',
        'Namespace %s could not be initialized, because %s could not be found.',
        'Next',
        'No Data Available.',
        'No TransitionActions assigned.',
        'No data found.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.',
        'No matches found.',
        'No package information available.',
        'No response from get package upgrade result.',
        'No response from get package upgrade run status.',
        'No response from package upgrade all.',
        'No sort applied, ',
        'No space left for the following files: %s',
        'Not available',
        'Notice',
        'Notification',
        'Nov',
        'November',
        'OK',
        'Oct',
        'October',
        'One or more errors occurred!',
        'Open URL in new tab',
        'Open date selection',
        'Open this node in a new window',
        'Please add values for all keys before saving the setting.',
        'Please check the fields marked as red for valid inputs.',
        'Please either turn some off first or increase the limit in configuration.',
        'Please enter at least one search value or * to find anything.',
        'Please enter at least one search word to find anything.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.',
        'Please only select at most %s files for upload.',
        'Please only select one file for upload.',
        'Please remove the following words from your search as they cannot be searched for:',
        'Please see the documentation or ask your admin for further information.',
        'Please turn off Compatibility Mode in Internet Explorer!',
        'Please wait...',
        'Preparing to deploy, please wait...',
        'Press Ctrl+C (Cmd+C) to copy to clipboard',
        'Previous',
        'Process state',
        'Queues',
        'Reload page',
        'Reload page (%ss)',
        'Remove',
        'Remove Entity from canvas',
        'Remove active filters for this widget.',
        'Remove all user changes.',
        'Remove from favourites',
        'Remove selection',
        'Remove the Transition from this Process',
        'Remove the filter',
        'Remove this dynamic field',
        'Remove this entry',
        'Repeat',
        'Request Details',
        'Request Details for Communication ID',
        'Reset',
        'Reset globally',
        'Reset locally',
        'Reset option is required!',
        'Reset options',
        'Reset setting',
        'Reset setting on global level.',
        'Resource',
        'Resources',
        'Restore default settings',
        'Restore web service configuration',
        'Rule',
        'Running',
        'Sa',
        'Sat',
        'Saturday',
        'Save',
        'Save and update automatically',
        'Scale preview content',
        'Search',
        'Search attributes',
        'Search the System Configuration',
        'Searching for linkable objects. This may take a while...',
        'Select a customer ID to assign to this ticket',
        'Select a customer ID to assign to this ticket.',
        'Select all',
        'Sending Update...',
        'Sep',
        'September',
        'Setting a template will overwrite any text or attachment.',
        'Settings',
        'Show',
        'Show EntityIDs',
        'Show current selection',
        'Show or hide the content.',
        'Slide the navigation bar',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.',
        'Sorry, but you can\'t disable all methods for this notification.',
        'Sorry, the only existing condition can\'t be removed.',
        'Sorry, the only existing field can\'t be removed.',
        'Sorry, the only existing parameter can\'t be removed.',
        'Sorry, you can only upload %s files.',
        'Sorry, you can only upload one file here.',
        'Split',
        'Stacked',
        'Start date',
        'Status',
        'Stream',
        'Su',
        'Sun',
        'Sunday',
        'Support Bundle',
        'Support Data information was successfully sent.',
        'Switch to desktop mode',
        'Switch to mobile mode',
        'System Registration',
        'Team',
        'Th',
        'The browser you are using is too old.',
        'The deployment is already running.',
        'The following files are not allowed to be uploaded: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s',
        'The following files were already uploaded and have not been uploaded again: %s',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.',
        'The key must not be empty.',
        'The mail could not be sent',
        'There are currently no elements available to select from.',
        'There are no more drafts available.',
        'There is a package upgrade process running, click here to see status information about the upgrade progress.',
        'There was an error deleting the attachment. Please check the logs for more information.',
        'There was an error. Please save all settings you are editing and check the logs for more information.',
        'This Activity cannot be deleted because it is the Start Activity.',
        'This Activity is already used in the Process. You cannot add it twice!',
        'This Transition is already used for this Activity. You cannot use it twice!',
        'This TransitionAction is already used in this Path. You cannot use it twice!',
        'This address already exists on the address list.',
        'This element has children elements and can currently not be removed.',
        'This event is already attached to the job, Please use a different one.',
        'This feature is part of the %s. Please contact us at %s for an upgrade.',
        'This field can have no more than 250 characters.',
        'This field is required.',
        'This is %s',
        'This is a repeating appointment',
        'This is currently disabled because of an ongoing package upgrade.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?',
        'This option is currently disabled because the OTRS Daemon is not running.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.',
        'This window must be called from compose window.',
        'Thu',
        'Thursday',
        'Timeline Day',
        'Timeline Month',
        'Timeline Week',
        'Title',
        'Today',
        'Too many active calendars',
        'Try again',
        'Tu',
        'Tue',
        'Tuesday',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.',
        'Unknown',
        'Unlock setting.',
        'Update All Packages',
        'Update Result',
        'Update all packages',
        'Update manually',
        'Upload information',
        'Uploading...',
        'Use options below to narrow down for which tickets appointments will be automatically created.',
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.',
        'Warning',
        'Was not possible to send Support Data information.',
        'We',
        'Wed',
        'Wednesday',
        'Week',
        'Would you like to edit just this occurrence or all occurrences?',
        'Yes',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.',
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.',
        'You have undeployed settings, would you like to deploy them?',
        'activate to apply a descending sort',
        'activate to apply an ascending sort',
        'activate to remove the sort',
        'and %s more...',
        'day',
        'month',
        'more',
        'no',
        'none',
        'or',
        'sorting is disabled',
        'user(s) have modified this setting.',
        'week',
        'yes',
    ];

    # $$STOP$$
    return;
}

1;
