# --
# Kernel/Language/ms.pm - provides Malay language translation
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::ms;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-10-17 13:50:05

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T - %D.%M.%Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    # csv separator
    $Self->{Separator} = ';';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Ya',
        'No' => 'Tidak',
        'yes' => 'ya',
        'no' => 'tidak',
        'Off' => 'Tutup',
        'off' => 'tutup',
        'On' => 'Buka',
        'on' => 'buka',
        'top' => 'atas',
        'end' => 'tamat',
        'Done' => 'Selesai',
        'Cancel' => 'Batal',
        'Reset' => 'Set Semula',
        'more than ... ago' => '',
        'in more than ...' => '',
        'within the last ...' => '',
        'within the next ...' => '',
        'Created within the last' => '',
        'Created more than ... ago' => '',
        'Today' => 'Hari ini',
        'Tomorrow' => 'Esok',
        'Next week' => 'Minggu Hadapan',
        'day' => 'hari',
        'days' => 'beberapa hari',
        'day(s)' => 'hari(beberapa)',
        'd' => 'd',
        'hour' => 'jam',
        'hours' => 'beberapa jam',
        'hour(s)' => 'jam(beberapa)',
        'Hours' => 'Beberapa Jam',
        'h' => 'h',
        'minute' => 'minit',
        'minutes' => 'Beberapa minit',
        'minute(s)' => 'minit(beberapa)',
        'Minutes' => 'Beberapa Minit',
        'm' => 'm',
        'month' => 'bulan',
        'months' => 'Beberapa Bulan',
        'month(s)' => 'Bulan(beberapa)',
        'week' => 'minggu',
        'week(s)' => 'minggu(beberapa)',
        'year' => 'tahun',
        'years' => 'beberapa tahun',
        'year(s)' => 'tahun(beberapa)',
        'second(s)' => 'saat(beberapa)',
        'seconds' => 'beberapa saat',
        'second' => 'saat',
        's' => 's',
        'Time unit' => '',
        'wrote' => 'menulis',
        'Message' => 'Mesej',
        'Error' => 'Kesilapan',
        'Bug Report' => 'Laporan Kecacatan',
        'Attention' => 'Perhatian',
        'Warning' => 'Amaran',
        'Module' => 'Modul',
        'Modulefile' => 'Fail Modul',
        'Subfunction' => 'Subfungsi',
        'Line' => 'Garisan',
        'Setting' => 'Tetapan',
        'Settings' => 'Tetapan',
        'Example' => 'Contoh',
        'Examples' => 'Contoh',
        'valid' => 'sah',
        'Valid' => 'Sah',
        'invalid' => 'tidak sah',
        'Invalid' => 'Tidak Sah',
        '* invalid' => '* tidak sah',
        'invalid-temporarily' => 'tidak sah-sementara',
        ' 2 minutes' => ' 2 Minit',
        ' 5 minutes' => ' 5 Minit',
        ' 7 minutes' => ' 7 Minit',
        '10 minutes' => '10 Minit',
        '15 minutes' => '15 Minit',
        'Mr.' => 'Encik',
        'Mrs.' => 'Puan',
        'Next' => 'Seterusnya',
        'Back' => 'Kebelakang',
        'Next...' => 'Seterusnya...',
        '...Back' => '...Kebelakang',
        '-none-' => '-tiada-',
        'none' => 'tiada',
        'none!' => 'tiada!',
        'none - answered' => 'tiada - dijawab',
        'please do not edit!' => 'Tolong jangan edit!',
        'Need Action' => 'Perlu Tindakan',
        'AddLink' => 'Tambah Pautan',
        'Link' => 'Pautan',
        'Unlink' => 'Menyahpaut',
        'Linked' => 'Dipautkan',
        'Link (Normal)' => 'Pautan (Biasa)',
        'Link (Parent)' => 'Pautan (Parent)',
        'Link (Child)' => 'Pautan (Child)',
        'Normal' => 'Normal',
        'Parent' => 'Parent',
        'Child' => 'Child',
        'Hit' => 'Tekan',
        'Hits' => 'Menekan',
        'Text' => 'Teks',
        'Standard' => 'Piawaian',
        'Lite' => 'Sedikit',
        'User' => 'Pengguna',
        'Username' => 'Nama Pengguna',
        'Language' => 'Bahasa',
        'Languages' => 'Bahasa',
        'Password' => 'Kata Laluan',
        'Preferences' => 'Pilihan',
        'Salutation' => 'Kata Aluan',
        'Salutations' => 'Kata Aluan',
        'Signature' => 'Tanda Tangan',
        'Signatures' => 'Tanda Tangan',
        'Customer' => 'Pelanggan',
        'CustomerID' => 'IDPelanggan',
        'CustomerIDs' => 'IDPelanggan',
        'customer' => 'pelanggan',
        'agent' => 'ejen',
        'system' => 'sistem',
        'Customer Info' => 'Info Pelanggan',
        'Customer Information' => 'Informasi Pelanggan',
        'Customer Company' => 'Firma Pelanggan',
        'Customer Companies' => 'Firma Pelanggan',
        'Company' => 'Firma',
        'go!' => 'mula!',
        'go' => 'mula',
        'All' => 'Semua',
        'all' => 'semua',
        'Sorry' => 'Maaf',
        'update!' => 'Kemaskini!',
        'update' => 'kemaskini',
        'Update' => 'Kemaskini',
        'Updated!' => 'Dikemaskini!',
        'submit!' => 'hantar!',
        'submit' => 'hantar',
        'Submit' => 'Hantar',
        'change!' => 'Ubah!',
        'Change' => 'Ubah',
        'change' => 'ubah',
        'click here' => 'Tekan Sini',
        'Comment' => 'Komen',
        'Invalid Option!' => 'Pilihan Tidak Sah!',
        'Invalid time!' => 'Masa Tidak Sah!',
        'Invalid date!' => 'Tarikh Tidak Sah!',
        'Name' => 'Nama',
        'Group' => 'Kumpulan',
        'Description' => 'Penerangan',
        'description' => 'penerangan',
        'Theme' => 'Tema',
        'Created' => 'Dicipta',
        'Created by' => 'Dicipta oleh',
        'Changed' => 'Diubah',
        'Changed by' => 'Diubah oleh',
        'Search' => 'Carian',
        'and' => 'dan',
        'between' => 'diantara',
        'before/after' => '',
        'Fulltext Search' => 'Carian Teks Penuh',
        'Data' => 'Data',
        'Options' => 'Pilihan',
        'Title' => 'Tajuk',
        'Item' => 'Item',
        'Delete' => 'Padam',
        'Edit' => 'Mengedit',
        'View' => 'Melihat',
        'Number' => 'Nombor',
        'System' => 'Sistem',
        'Contact' => 'Hubungi',
        'Contacts' => 'Hubungi',
        'Export' => 'Eksport',
        'Up' => 'Atas',
        'Down' => 'Bawah',
        'Add' => 'Tambah',
        'Added!' => 'Ditambah!',
        'Category' => 'Kategori',
        'Viewer' => 'Pelihat',
        'Expand' => 'Kembang',
        'Small' => 'Kecil',
        'Medium' => 'Sederhana',
        'Large' => 'Besar',
        'Date picker' => 'Pemilih tarikh',
        'Show Tree Selection' => '',
        'New message' => 'Mesej baru',
        'New message!' => 'Mesej baru!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Sila jawab ticket ini untuk balik ke Aturan Melihat yang biasa!',
        'You have %s new message(s)!' => 'Anda mempunyai %s mesej baru!',
        'You have %s reminder ticket(s)!' => 'Anda mempunyai %s tiket peringatan!',
        'The recommended charset for your language is %s!' => 'Set Karakter yang dicadangkan untuk bahasa anda ialah %s!',
        'Change your password.' => 'Tukar kata laluan anda.',
        'Please activate %s first!' => 'Sila aktifkan %s dahulu.',
        'No suggestions' => 'Tiada cadangan',
        'Word' => 'Perkataan',
        'Ignore' => 'Abaikan',
        'replace with' => 'ganti dengan',
        'There is no account with that login name.' => 'Tiada no akaun dengan nama log masuk.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Log masuk gagal. Kata nama anda atau kata laluan yang dimasukkan tidak tepat',
        'There is no acount with that user name.' => 'Tiada akaun dengan nama pengguna tersebut.',
        'Please contact your administrator' => 'Sila hubungi pentadbir anda',
        'Logout' => 'Log keluar',
        'Logout successful. Thank you for using %s!' => '',
        'Feature not active!' => 'Ciri-ciri tidak aktif!',
        'Agent updated!' => 'Ejen dikemaskini!',
        'Database Selection' => '',
        'Create Database' => 'Mencipta pangkalan data',
        'System Settings' => 'Pengaturan sistem',
        'Mail Configuration' => 'Konfigurasi mel',
        'Finished' => 'Ditamatkan',
        'Install OTRS' => 'Memasang OTRS',
        'Intro' => 'Permulaan',
        'License' => 'Lesen',
        'Database' => 'Pangkalan data',
        'Configure Mail' => 'Konfigurasi emel',
        'Database deleted.' => 'Pangkalan data dipadam.',
        'Enter the password for the administrative database user.' => '',
        'Enter the password for the database user.' => '',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '',
        'Database already contains data - it should be empty!' => '',
        'Login is needed!' => 'Log masuk diperlukan!',
        'Password is needed!' => 'Kata laluan diperlukan!',
        'Take this Customer' => 'Ambil pelanggan ini',
        'Take this User' => 'Ambil pengguna ini',
        'possible' => 'mungkin',
        'reject' => 'menolak',
        'reverse' => 'berbalik',
        'Facility' => 'Kemudahan',
        'Time Zone' => 'Zon Masa',
        'Pending till' => 'Menunggu sehingga',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Jangan guna akaun Pengguna Besar untuk kerja dengan OTRS! Cipta ejen baru and kerja dengan akaun tersebut',
        'Dispatching by email To: field.' => 'Menghantar oleh emel kepada: bidang.',
        'Dispatching by selected Queue.' => 'Menghantar oleh Barisan dipilih.',
        'No entry found!' => 'Tiada kemasukan ditemui!',
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => 'Sesi ini sudah tamat. Sila log masuk semula',
        'Session limit reached! Please try again later.' => '',
        'No Permission!' => 'Tiada kebenaran!',
        '(Click here to add)' => '(Klik sini untuk tambah)',
        'Preview' => 'Perlihat',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Pakej tidak dikerah dengan betul! Sila memasang semula pakej.',
        '%s is not writable!' => '%s adalah tidak boleh ditulis!',
        'Cannot create %s!' => 'Tidak boleh mencipta %s!',
        'Check to activate this date' => 'Periksa untuk mengaktifkan tarikh ini',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Anda membolehkan keluar dari pejabat, adakah anda ingin melumpuhkan ia?',
        'Customer %s added' => 'Pelanggan %s ditambah',
        'Role added!' => 'Watak ditambah!',
        'Role updated!' => 'watak dikemaskini!',
        'Attachment added!' => 'Lampiran ditambah!',
        'Attachment updated!' => 'Lampiran dikemaskini!',
        'Response added!' => 'Tindak balas ditambah!',
        'Response updated!' => 'Tindak balas dikemaskini!',
        'Group updated!' => 'Kumpulan dikemaskini',
        'Queue added!' => 'Barisan ditambah!',
        'Queue updated!' => 'Barisan dikemaskini!',
        'State added!' => 'Keadaan ditambah!',
        'State updated!' => 'Keadaan dikemaskini!',
        'Type added!' => 'Jenis ditambah!',
        'Type updated!' => 'Jenis dikemaskini!',
        'Customer updated!' => 'Pelanggan dikemaskini!',
        'Customer company added!' => 'Syarikat pelanggan ditambah!',
        'Customer company updated!' => 'Syarikat pelanggan dikemaskini!',
        'Note: Company is invalid!' => '',
        'Mail account added!' => 'Akaun emel ditambah!',
        'Mail account updated!' => 'Akaun emel dikemaskini!',
        'System e-mail address added!' => 'Alamat sistem emel ditambah!',
        'System e-mail address updated!' => 'Alamat sistem emel dikemaskini!',
        'Contract' => 'Kontrak',
        'Online Customer: %s' => 'Pelanggan dalam talian: %s',
        'Online Agent: %s' => 'Egen dalam talian: %s',
        'Calendar' => 'Kalendar',
        'File' => 'Fail',
        'Filename' => 'Nama fail',
        'Type' => 'Jenis',
        'Size' => 'Saiz',
        'Upload' => 'Muat naik',
        'Directory' => 'Direktori',
        'Signed' => 'Ditandatngani',
        'Sign' => 'Menandatangani',
        'Crypted' => 'Dikodkan',
        'Crypt' => 'Kod',
        'PGP' => 'PGP',
        'PGP Key' => 'Kunci PGP',
        'PGP Keys' => 'Kunci PGP',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'Sijil S/MIME',
        'S/MIME Certificates' => 'Sijil S/MIME',
        'Office' => 'Pejabat',
        'Phone' => 'Telefon',
        'Fax' => 'Faks',
        'Mobile' => 'mudah alih',
        'Zip' => 'Poskod',
        'City' => 'Bandar',
        'Street' => 'Jalan',
        'Country' => 'Negara',
        'Location' => 'Lokasi',
        'installed' => 'Dipasangkan',
        'uninstalled' => 'Dinyahpasangkan',
        'Security Note: You should activate %s because application is already running!' =>
            'Nota Keselamatan: Kamu harus mengaktifkan %s kerana aplikasi ini sudah berjalan!',
        'Unable to parse repository index document.' => 'Tidak dapat menghurai repositori dokumen indeks.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Tiada pakej untuk rangka kerja anda ditemui didalam repositori ini, ia hanya mengandungi pakej untuk rangka kerja versi lain.',
        'No packages, or no new packages, found in selected repository.' =>
            'Tiada pakej, atau tiada pakej baru, dijumpai didalam repositori yang dipilih.',
        'Edit the system configuration settings.' => 'Mengaudit aturan konfigurasi sistem',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '',
        'printed at' => 'dicetak di',
        'Loading...' => 'Memuatkan...',
        'Dear Mr. %s,' => 'Kepada Encik %s,',
        'Dear Mrs. %s,' => 'Kepada Puan %s,',
        'Dear %s,' => 'Kepada %s,',
        'Hello %s,' => 'Hello %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'Alamat emel ini sudah digunakan. Sila log masuk atau set semula kata laluan',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Akaun baru telah didaftarkan. Hantar maklumat log masuk kepada %s. Sila periksa emel anda',
        'Please press Back and try again.' => 'Sila tekan kembali dan cuba sekali lagi.',
        'Sent password reset instructions. Please check your email.' => 'Hantar arahan set semula kata laluan. Sila periksa emel anda.',
        'Sent new password to %s. Please check your email.' => 'Hantar kata laluan baru kepada &s. Sila periksa emel anda.',
        'Upcoming Events' => 'Acara akan datang',
        'Event' => 'Acara',
        'Events' => 'Acara',
        'Invalid Token!' => 'Tanda tidak sah!',
        'more' => 'lagi',
        'Collapse' => 'Tumbang',
        'Shown' => 'Ditunjukkan',
        'Shown customer users' => '',
        'News' => 'Berita',
        'Product News' => 'Berita produk',
        'OTRS News' => 'Berita OTRS',
        '7 Day Stats' => 'Statistik 7 hari',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Mark' => '',
        'Unmark' => '',
        'Bold' => 'Bold',
        'Italic' => 'Italic',
        'Underline' => 'Garisan Bawah',
        'Font Color' => 'Warna Tulisan',
        'Background Color' => 'Warna latarbelakang',
        'Remove Formatting' => 'Buang format',
        'Show/Hide Hidden Elements' => 'Tunjuk/Sembunyi Elemen tersembunyi',
        'Align Left' => 'Menyelaras ke kiri',
        'Align Center' => 'Menyelaras ke tengah',
        'Align Right' => 'Menyelaras ke Kanan',
        'Justify' => 'Mewajarkan',
        'Header' => 'Permulaan',
        'Indent' => 'Peningkatan lekuk',
        'Outdent' => 'Pengurangan lekuk',
        'Create an Unordered List' => 'Cipta senarai tidak tertib',
        'Create an Ordered List' => 'Cipta senarai tertib',
        'HTML Link' => 'Pautan HTML',
        'Insert Image' => 'Masuk gambar',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Undur',
        'Redo' => 'Buat semula',
        'Scheduler process is registered but might not be running.' => 'Proses penjadual adalah berdaftar tetapi kemungkinan besar tidak berjalan.',
        'Scheduler is not running.' => 'Penjadualan tidak berjalan.',
        'Can\'t contact registration server. Please try again later.' => '',
        'No content received from registration server. Please try again later.' =>
            '',
        'Problems processing server result. Please try again later.' => '',
        'Username and password do not match. Please try again.' => '',

        # Template: AAACalendar
        'New Year\'s Day' => 'Hari Tahun Baru',
        'International Workers\' Day' => 'Hari Pekerja Kebangsaan',
        'Christmas Eve' => 'Perayaan Natal',
        'First Christmas Day' => 'Hari Pertama Natal',
        'Second Christmas Day' => 'Hari Kedua Natal',
        'New Year\'s Eve' => 'Perayaan Tahun Baru',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS sebagai peminta',
        'OTRS as provider' => 'OTRS sebagai pembekal',
        'Webservice "%s" created!' => 'Servis Sesawang "%s" dicipta!',
        'Webservice "%s" updated!' => 'Servis Sesawang "%s" dikemaskini!',

        # Template: AAAMonth
        'Jan' => 'Jan',
        'Feb' => 'Feb',
        'Mar' => 'Mac',
        'Apr' => 'Apr',
        'May' => 'Mei',
        'Jun' => 'Jun',
        'Jul' => 'Jul',
        'Aug' => 'Ogs',
        'Sep' => 'Sep',
        'Oct' => 'Okt',
        'Nov' => 'Nov',
        'Dec' => 'Dis',
        'January' => 'Januari',
        'February' => 'Februari',
        'March' => 'Mac',
        'April' => 'April',
        'May_long' => 'Mei',
        'June' => 'Jun',
        'July' => 'Julai',
        'August' => 'Ogos',
        'September' => 'September',
        'October' => 'Oktober',
        'November' => 'November',
        'December' => 'Disember',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Kemaskini pilihan berjaya!',
        'User Profile' => 'Butiran Pengguna',
        'Email Settings' => 'Aturan Emel',
        'Other Settings' => 'Aturan Lain',
        'Change Password' => 'Tukar kata laluan',
        'Current password' => 'Kata laluan asal',
        'New password' => 'Kata laluan baru',
        'Verify password' => 'Mengesahkan kata laluan',
        'Spelling Dictionary' => 'Kamus ejaan',
        'Default spelling dictionary' => 'Kamus ejaan sedia ada ',
        'Max. shown Tickets a page in Overview.' => 'Tiket maksimum ditunjukkan di gambaran.',
        'The current password is not correct. Please try again!' => 'Kata laluan asal tidak tepat. Sila cuba lagi!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Tidak boleh kemas kini kata laluan, kata laluan baru anda tidak sama. Sila cuba sekali lagi!',
        'Can\'t update password, it contains invalid characters!' => 'Tidak boleh kemaskini kata laluan, ia mengandungi karakter tidak sah.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Tidak boleh kemaskini kata laluan, ia mesti mengandungi sekurang kurangnya %s karakter panjang.',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Tidak boleh kemaskini kata laluan, ia mesti mengandungi sekurang-kurangnya 2 huruf kecil dan 2 huruf besar karakter.',
        'Can\'t update password, it must contain at least 1 digit!' => 'Tidak boleh mengemaskini kata laluan, ia mesti mengandungi sekurang-kurangnya 1 digit.',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Tidak boleh mengemaskini kata laluan, ia mesti mengandungi sekurang-kurangnya 2 karakter.',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Tidak boleh kemaskini kata laluan, kata laluan ini sudah digunakan. Sila pilih yang baru.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Pilih pengasing karakter untuk diguna dalam fail CSV (statistik dan pencarian). Jika anda tidak pilih pengasing disini, pengasing sedia ada untuk bahasa anda akan digunakan.',
        'CSV Separator' => 'Pengasing CSV',

        # Template: AAAStats
        'Stat' => 'Statistik',
        'Sum' => 'Jumlah',
        'No (not supported)' => '',
        'Please fill out the required fields!' => 'Sila isi bidang yang diperlukan!',
        'Please select a file!' => 'Sila pilih fail!',
        'Please select an object!' => 'Sila pilih objek!',
        'Please select a graph size!' => 'Sila pilih saiz graf!',
        'Please select one element for the X-axis!' => 'Sila pilih elemen untuk lajur-X!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Sila pilih satu elemen atau matikan butang \'Ditetapkan\' dimana bidang yang dipilih ditanda!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Jika anda mengunakan kotak cek, anda harus memilih beberapa sifat sifat untuk bidang terpilih!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Sila pilih nilai dalam bidang input terpilih atau matikan \'Ditetapkan\' kotak cek!',
        'The selected end time is before the start time!' => 'Masa tamat yang dipilih adalah sebelum masa mula!',
        'You have to select one or more attributes from the select field!' =>
            'Anda perlu memilih satu atau lebih sifat dari bidang yang dipilih!',
        'The selected Date isn\'t valid!' => 'Tarikh dipilih adalah tidak sah!',
        'Please select only one or two elements via the checkbox!' => 'Sila pilih satu atau dua elemen melalui kotak cek!',
        'If you use a time scale element you can only select one element!' =>
            'Jika anda menggunakan skala elemen anda hanya boleh memilih satu elemen!',
        'You have an error in your time selection!' => 'Anda mempunyai kesilapan dalam pilihan masa!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Selang masa laporan anda adalah terlalu kecil, sila gunakan skala masa yang lebih besar!',
        'The selected start time is before the allowed start time!' => 'Masa permulaan yang dipilih adalah seblum masa mula yang dibenarkan!',
        'The selected end time is after the allowed end time!' => 'Masa tamat yang dipilih adalah selepas masa tamat yang dibenarkan!',
        'The selected time period is larger than the allowed time period!' =>
            'Tempoh masa yang dipilih adalah lebih besar dari tempoh masa yang dibenarkan!',
        'Common Specification' => 'Spesifikasi biasa',
        'X-axis' => 'Paksi-X',
        'Value Series' => 'Siri nilai',
        'Restrictions' => 'Sekatan',
        'graph-lines' => 'Graf garis',
        'graph-bars' => 'Graf bar',
        'graph-hbars' => 'Graf bar (mendatar)',
        'graph-points' => 'Graf mata',
        'graph-lines-points' => 'Graf garis mata',
        'graph-area' => 'Graf kawasan',
        'graph-pie' => 'Graf pai',
        'extended' => 'Dianjakkan',
        'Agent/Owner' => 'Egen/Pemilik',
        'Created by Agent/Owner' => 'Dicipta oleh Egen/Pemilik',
        'Created Priority' => 'Keutamaan dicipta',
        'Created State' => 'Status dicipta',
        'Create Time' => 'Masa dicipta',
        'CustomerUserLogin' => 'LogMasukPenggunaPelanggan',
        'Close Time' => 'Masa tutup',
        'TicketAccumulation' => 'Pengumpulan tiket',
        'Attributes to be printed' => 'Sifat-sifat untuk dicetak',
        'Sort sequence' => 'Susun urutan',
        'Order by' => 'Disusun mengikut',
        'Limit' => 'Menghadkan',
        'Ticketlist' => 'Senarai Tiket',
        'ascending' => 'Menaik',
        'descending' => 'Menurun',
        'First Lock' => 'Kunci pertama',
        'Evaluation by' => 'Disemak oleh',
        'Total Time' => 'Jumlah masa',
        'Ticket Average' => 'Purata tiket',
        'Ticket Min Time' => 'Masa Minimum Tiket',
        'Ticket Max Time' => 'Masa Maksimum Tiket',
        'Number of Tickets' => 'Bilangan Tiket',
        'Article Average' => 'Purata Artikel',
        'Article Min Time' => 'Masa Minimum Artikel',
        'Article Max Time' => 'Masa Maximum Artikel',
        'Number of Articles' => 'Bilangan Artikel',
        'Accounted time by Agent' => 'Menyumbang masa oleh ejen',
        'Ticket/Article Accounted Time' => 'Tiket/Artikel Menyumbang Masa',
        'TicketAccountedTime' => 'TiketMenyumbangMasa',
        'Ticket Create Time' => 'Tiket Mencipta Masa',
        'Ticket Close Time' => 'Tiket Menutup Masa',

        # Template: AAATicket
        'Status View' => 'Lihat Status',
        'Bulk' => 'Pukal',
        'Lock' => 'Kunci',
        'Unlock' => 'Membuka',
        'History' => 'Sejarah',
        'Zoom' => 'zoom',
        'Age' => 'Umur',
        'Bounce' => 'Lantun',
        'Forward' => 'Kehadapan',
        'From' => 'Daripada',
        'To' => 'Kepada',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'Subjek',
        'Move' => 'Gerak',
        'Queue' => 'Barisan',
        'Queues' => 'Barisan',
        'Priority' => 'Keutamaan',
        'Priorities' => 'Keutamaan',
        'Priority Update' => 'Kemaskini Keutamaan',
        'Priority added!' => 'Keutamaan ditambah!',
        'Priority updated!' => 'Keutamaan dikemaskini!',
        'Signature added!' => 'Tandatangan ditambah!',
        'Signature updated!' => 'Tandatangan dikemaskini!',
        'SLA' => 'TPP',
        'Service Level Agreement' => 'Tahap Persetujuan Perkhidmatan',
        'Service Level Agreements' => 'Tahap Persetujuan Perkhidmatan',
        'Service' => 'Servis',
        'Services' => 'Servis',
        'State' => 'Keadaan',
        'States' => 'Keadaan',
        'Status' => 'Status',
        'Statuses' => 'Status',
        'Ticket Type' => 'Jenis Tiket',
        'Ticket Types' => 'Jenis Ticket',
        'Compose' => 'Mengarang',
        'Pending' => 'Tergantung',
        'Owner' => 'Pemilik',
        'Owner Update' => 'Kemaskini pemilik',
        'Responsible' => 'Tanggungjawab',
        'Responsible Update' => 'Tanggungjawab dikemaskini',
        'Sender' => 'Penghantar',
        'Article' => 'Artikel',
        'Ticket' => 'Tiket',
        'Createtime' => 'Cipta masa',
        'plain' => 'kosong',
        'Email' => 'Emel',
        'email' => 'emel',
        'Close' => 'Tutup',
        'Action' => 'Tindakan',
        'Attachment' => 'Lampiran',
        'Attachments' => 'Lampiran',
        'This message was written in a character set other than your own.' =>
            'Mesej ini ditulis dalam set karakter lain dari anda.',
        'If it is not displayed correctly,' => 'Jika ia tidak dipaparkan dengan betul,',
        'This is a' => 'Ini adalah',
        'to open it in a new window.' => 'untuk buka ia dalam tetingkap baru',
        'This is a HTML email. Click here to show it.' => 'Ini adalah emel HTML. Tekan sini untuk menunjukkan ia.',
        'Free Fields' => 'Bidang percuma',
        'Merge' => 'Bergabung',
        'merged' => 'Digabungkan',
        'closed successful' => 'Ditutup dengan jayanya',
        'closed unsuccessful' => 'Ditutup dengan gagalnya',
        'Locked Tickets Total' => 'Jumlah Tiket Dikunci',
        'Locked Tickets Reminder Reached' => 'Jangkauan peringatan tiket dikunci',
        'Locked Tickets New' => 'Tiket Baru Dikunci',
        'Responsible Tickets Total' => 'Jumlah Tanggungjawab Tiket',
        'Responsible Tickets New' => 'Tanggungjawab Tiket Baru',
        'Responsible Tickets Reminder Reached' => 'Tanggungjawab Tiket Mencapai Peringatan',
        'Watched Tickets Total' => 'Memerhati Jumlah Tiket',
        'Watched Tickets New' => 'Memerhati Tiket Baru',
        'Watched Tickets Reminder Reached' => 'Memerhati Tiket Mencapai Peringatan',
        'All tickets' => 'Semua Tiket',
        'Available tickets' => 'Tiket disediakan',
        'Escalation' => 'Peningkatan',
        'last-search' => 'Carian-akhir',
        'QueueView' => 'Lihat-Barisan',
        'Ticket Escalation View' => 'Lihat Peningkatan Tiket',
        'Message from' => 'Mesej daripada',
        'End message' => 'Akhir mesej',
        'Forwarded message from' => 'Mesej dikemukan daripada',
        'End forwarded message' => 'Mesej akhir dikemukan',
        'new' => 'baru',
        'open' => 'buka',
        'Open' => 'Buka',
        'Open tickets' => 'Buka tiket',
        'closed' => 'ditutup',
        'Closed' => 'Ditutup',
        'Closed tickets' => 'Tiket ditutup',
        'removed' => 'Dibuang',
        'pending reminder' => 'Peringatan tergantung',
        'pending auto' => 'auto tergantung',
        'pending auto close+' => 'auto tergantung tutup+',
        'pending auto close-' => 'auto tergantung tutup-',
        'email-external' => 'emel-luaran',
        'email-internal' => 'emel-dalaman',
        'note-external' => 'nota-luaran',
        'note-internal' => 'nota-dalaman',
        'note-report' => 'nota-laporan',
        'phone' => 'Telefon',
        'sms' => 'sms',
        'webrequest' => 'permintaan sesawang',
        'lock' => 'kunci',
        'unlock' => 'buka',
        'very low' => 'sangat rendah',
        'low' => 'rendah',
        'normal' => 'biasa',
        'high' => 'tinggi',
        'very high' => 'sangat tinggi',
        '1 very low' => '1 sangat rendah',
        '2 low' => '2 rendah',
        '3 normal' => '3 biasa',
        '4 high' => '4 tinggi',
        '5 very high' => '5 sangat tinggi',
        'auto follow up' => 'mengikut auto',
        'auto reject' => 'ditolak auto',
        'auto remove' => 'buang auto',
        'auto reply' => 'balas auto',
        'auto reply/new ticket' => 'balas auto/tiket baru',
        'Create' => 'Buat',
        'Answer' => '',
        'Phone call' => 'Panggilan telefon',
        'Ticket "%s" created!' => 'Tiket "%s" dicipta!',
        'Ticket Number' => 'Nombor Tiket',
        'Ticket Object' => 'Tiket Objek',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Tiada Nombor Tiket "%s"! Tidak boleh dipautkan!',
        'You don\'t have write access to this ticket.' => 'Anda tidak mempunyai akses menulis untuk tiket ini.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Maaf, anda perlu menjadi pemilik tiket untuk melaksanakan tindakan ini.',
        'Please change the owner first.' => '',
        'Ticket selected.' => 'Tiket dipilih.',
        'Ticket is locked by another agent.' => 'Tiket dikunci oleh ejen lain!',
        'Ticket locked.' => 'Tiket dikunci.',
        'Don\'t show closed Tickets' => 'Jangan tunjuk tiket yang ditutup',
        'Show closed Tickets' => 'Tunjuk Tiket Ditutup',
        'New Article' => 'Artikel Baru',
        'Unread article(s) available' => 'Artikel yang tidak dibaca disediakan',
        'Remove from list of watched tickets' => 'Dibuang daripada senarai tiket dilihat',
        'Add to list of watched tickets' => 'Tambah kepada senarai tiket yang dilihat',
        'Email-Ticket' => 'emel-tiket',
        'Create new Email Ticket' => 'Mencipta Emel Tiket baru',
        'Phone-Ticket' => 'Tiket-Telefon',
        'Search Tickets' => 'Cari Tiket',
        'Edit Customer Users' => 'Audit Pengguna Pelanggan',
        'Edit Customer Company' => 'Audit Syarikat Pelanggan',
        'Bulk Action' => 'Tindakan pukal',
        'Bulk Actions on Tickets' => 'Tindakan Pukal pada Tiket',
        'Send Email and create a new Ticket' => 'Hantar Emel dan cipta satu tiket baru',
        'Create new Email Ticket and send this out (Outbound)' => 'Cipta Tiket baru dan hantar ini keluar (Keluar)',
        'Create new Phone Ticket (Inbound)' => 'Cipta Tiket Telefon baru (Masuk)',
        'Address %s replaced with registered customer address.' => 'Alamat %s digantikan dengan alamat pelanggan yang didaftar.',
        'Customer user automatically added in Cc.' => '',
        'Overview of all open Tickets' => 'Lihat Semula kesemua tiket yang dibuka',
        'Locked Tickets' => 'Tiket Dikunci',
        'My Locked Tickets' => 'Tiket Kunci Saya',
        'My Watched Tickets' => 'Tiket yang diperhati saya',
        'My Responsible Tickets' => 'Tiket Tanggungjawab saya',
        'Watched Tickets' => 'Tiket Diperhati',
        'Watched' => 'Diperhati',
        'Watch' => 'Perhati',
        'Unwatch' => 'Tidak diperhati',
        'Lock it to work on it' => 'Kunci ia untuk digunakan ia',
        'Unlock to give it back to the queue' => 'Buka untuk diberi semula pada barisan',
        'Show the ticket history' => 'Tunjuk sejarah tiket',
        'Print this ticket' => 'Cetak tiket ini',
        'Print this article' => 'Cetak tiket ini',
        'Split' => '',
        'Split this article' => 'Pisahkan artikel ini',
        'Forward article via mail' => 'Kehadapankan artikel melalui mel',
        'Change the ticket priority' => 'Tukar kepentingan tiket',
        'Change the ticket free fields!' => 'Tukar tiket bidang percuma',
        'Link this ticket to other objects' => 'Pautkan tiket ini kepada objek lain',
        'Change the owner for this ticket' => 'Tukar pemilik untuk tiket ini',
        'Change the  customer for this ticket' => 'Tukar pelanggan untuk tiket ini',
        'Add a note to this ticket' => 'Tambah nota kepada tiket ini',
        'Merge into a different ticket' => 'Gabungkan kedalam tiket berbeza',
        'Set this ticket to pending' => 'Tetapkan tiket ini kepada tergantung',
        'Close this ticket' => 'Tutup tiket ini',
        'Look into a ticket!' => 'Lihat kedalam tiket!',
        'Delete this ticket' => 'Padam tiket ini!',
        'Mark as Spam!' => 'Tanda sebagai Spam!',
        'My Queues' => 'Barisan saya',
        'Shown Tickets' => 'Perlihat Tiket',
        'Shown Columns' => '',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Emel anda dengan nombor tiket "<OTRS_TICKET>" adalah digabungkan kepada "<OTRS_MERGE_TO_TICKET>"!',
        'Ticket %s: first response time is over (%s)!' => 'Tiket %s: Reaksi pertama masa adalah tamat (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Tiket %s: Reaksi pertama masa akan tamat dalam %s!',
        'Ticket %s: update time is over (%s)!' => 'Tiket %s: masa kemaskini sudah tamat (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Tiket %s: masa kemaskini akan tamat dalam %s!',
        'Ticket %s: solution time is over (%s)!' => 'Tiket %s: masa penyelesaian sudah tamat (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Tiket %s: masa penyelesaian akan tamat dalam %s!',
        'There are more escalated tickets!' => 'Terdapat banyak lagi peningkatan tiket!',
        'Plain Format' => 'Format kosong',
        'Reply All' => 'Balas semua',
        'Direction' => 'Arah',
        'Agent (All with write permissions)' => 'Ejen (Semua dengan menulis kebenaran)',
        'Agent (Owner)' => 'Ejen (Pemilik)',
        'Agent (Responsible)' => 'Egen (Tanggungjawab)',
        'New ticket notification' => 'Pemberitahuan tiket baru',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Hantar saya pemberitahuan jika terdapat tiket baru dalam "Barisan saya".',
        'Send new ticket notifications' => 'Hantar pemberitahuan tiket baru',
        'Ticket follow up notification' => 'Pemberitahuan mengikuti tiket',
        'Ticket lock timeout notification' => 'Pemberitahuan tiket dikunci masa tamat',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Hantar saya pemberitahuan jika tiket dibuka oleh sistem ("buka")',
        'Send ticket lock timeout notifications' => 'Hantar pemberitahuan tiket dikunci masa tamat',
        'Ticket move notification' => 'Pemberitahuan pengalihan tiket',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Hantar saua pemberitahuan jika tiket dipindahkan kedalah salah satu daripada "Barisan saya".',
        'Send ticket move notifications' => 'Hantar pemberitahuan pindah tiket',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Barisan pilihan anda daripada barisan kegemaran. Anda juga akan diberitahu tentang kesemua barisan melalui emel sekiranya diaktifkan',
        'Custom Queue' => 'Barisan Sendiri',
        'QueueView refresh time' => 'Masa segar BarisanPapar ',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Jika diaktifkan, BarisanPapar akan secara automatik segar selepas masa yang ditetapkan',
        'Refresh QueueView after' => 'Segar BarisanPapar selepas',
        'Screen after new ticket' => 'Skrin selepas tiket baru',
        'Show this screen after I created a new ticket' => 'Papar skrin ini selepas saya mencipta tiket baru',
        'Closed Tickets' => 'Tutup Tiket',
        'Show closed tickets.' => 'Papar tiket ditutup.',
        'Max. shown Tickets a page in QueueView.' => 'Maksimum memaparkan mukasurat tiket dalam BarisanPapar.',
        'Ticket Overview "Small" Limit' => 'Lihat semula tiket "Kecil" Had',
        'Ticket limit per page for Ticket Overview "Small"' => 'Had tiket dalam muka surat untuk lihat semula tiket "Kecil"',
        'Ticket Overview "Medium" Limit' => 'Lihat semula Tiket "Sederhana" Had',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Had tiket dalam mula surat untuk lihat semula tiket "Sederhana"',
        'Ticket Overview "Preview" Limit' => 'Lihat semula Tiket "Yang Ditunjuk" Had',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Had tiket dalam mula surat untuk lihat semula tiket "Yang Ditunjuk"',
        'Ticket watch notification' => 'Pemberitahuan tiket diperhati',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Hantar saya pemberitahuan yang sama untuk tiket yang saya perhati dimana pemilik tiket akan dapat.',
        'Send ticket watch notifications' => 'Hantar pemberitahuan tiket yang diperhati',
        'Out Of Office Time' => 'Masa Keluar dari Pejabat',
        'New Ticket' => 'Tiket Baru',
        'Create new Ticket' => 'Cipta tiket baru',
        'Customer called' => 'Pelanggan dipanggil',
        'phone call' => 'Panggilan telefon',
        'Phone Call Outbound' => 'Panggilan telefon keluar',
        'Phone Call Inbound' => 'Panggilan telefon masuk',
        'Reminder Reached' => 'Peringatan Disampaikan',
        'Reminder Tickets' => 'Peringatan Tiket',
        'Escalated Tickets' => 'Peningkatan Tiket',
        'New Tickets' => 'Tiket Baru',
        'Open Tickets / Need to be answered' => 'Tiket Buka / Perlu untuk dijawab',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Semua tiket buka, tiket ini sudah dijalankan, tetapi perlu tindak balas',
        'All new tickets, these tickets have not been worked on yet' => 'Semua tiket baru, tiket ini masih belum dijalankan lagi',
        'All escalated tickets' => 'Semua peningkatan tiket',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Semua tiket dengan set peringatan dimana tarikh peringatan telah tiba',
        'Archived tickets' => 'Tiket Disimpan',
        'Unarchived tickets' => 'Mengeluarkan tiket',
        'Ticket Information' => 'Informasi Tiket',
        'History::Move' => 'Tiket berpindah ke Queue "% s" (%s) dari "%s" beratur (% s).',
        'History::TypeUpdate' => 'jenis dikemaskini "%s" (ID=%s).',
        'History::ServiceUpdate' => 'perkhidmatan kemas kini "%s" (ID=%s).',
        'History::SLAUpdate' => 'SLA dikemaskini "%s" (ID=%s).',
        'History::NewTicket' => 'Tiket baru [% s] dicipta (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Susulan untuk [%s]. %s',
        'History::SendAutoReject' => 'Menolak auto dihantar kepada "% s".',
        'History::SendAutoReply' => 'AutoBalas "% S" telah menghantar.',
        'History::SendAutoFollowUp' => 'Susulan Auto "%s" telah menghantar.',
        'History::Forward' => 'dikemukakan kepada "%s".',
        'History::Bounce' => 'bangkit satu "%s".',
        'History::SendAnswer' => 'Emel dihantar ke "%s".',
        'History::SendAgentNotification' => '"%s"-Pemberitahuan dihantar kepada "%s".',
        'History::SendCustomerNotification' => 'Pemberitahuan dihantar kepada "%s".',
        'History::EmailAgent' => 'Emel dihantar kepada pelanggan.',
        'History::EmailCustomer' => 'Tambah emel. %s',
        'History::PhoneCallAgent' => 'pelanggan memanggil.',
        'History::PhoneCallCustomer' => 'Pelanggan yang dipanggil.',
        'History::AddNote' => 'Nota Ditambah (%s)',
        'History::Lock' => 'Tiket ditutup.',
        'History::Unlock' => 'Kunci Tiket dilepaskan.',
        'History::TimeAccounting' => '%s Unit masa (s) dikira. % Unit masa dijumpai(s).',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'dikemaskini: %s',
        'History::PriorityUpdate' => 'Keutamaan kemaskini dari "%s" (%s) ke "%s" (%s).',
        'History::OwnerUpdate' => 'Pemilik baru "%s" (ID=%s).',
        'History::LoopProtection' => 'Gelung Perlindungan! Tiada auto balasan dihantar ke "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'dikemaskini: %s',
        'History::StateUpdate' => 'Lama: "%s" Baru: "%s"',
        'History::TicketDynamicFieldUpdate' => 'Dikemaskini: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Permintaan pelanggan yang dikemukakan melalui laman web.',
        'History::TicketLinkAdd' => 'Jalan pintas untuk "%s" dihasilkan.',
        'History::TicketLinkDelete' => 'Jalan pintas untuk "%s" dipadam.',
        'History::Subscribe' => 'Langgan Pengguna "%s" dimasukkan.',
        'History::Unsubscribe' => 'Langgan Pengguna "%s" yang diadakan.',
        'History::SystemRequest' => 'Systemanfrage (%s).',
        'History::ResponsibleUpdate' => 'Pengurus baru "%s" (ID=%s).',
        'History::ArchiveFlagUpdate' => 'Status berubah Arkib: "%s"',
        'History::TicketTitleUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => 'Ahd',
        'Mon' => 'Isn',
        'Tue' => 'Sel',
        'Wed' => 'Rab',
        'Thu' => 'Kha',
        'Fri' => 'Jum',
        'Sat' => 'Sab',

        # Template: AdminACL
        'ACL Management' => '',
        'Filter for ACLs' => '',
        'Filter' => 'Tapisan',
        'ACL Name' => '',
        'Actions' => 'Tindakan',
        'Create New ACL' => '',
        'Deploy ACLs' => '',
        'Export ACLs' => '',
        'Configuration import' => 'Import konfigurasi',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '',
        'This field is required.' => 'Bidang ini diperlukan.',
        'Overwrite existing ACLs?' => '',
        'Upload ACL configuration' => '',
        'Import ACL configuration(s)' => '',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '',
        'ACLs' => '',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '',
        'ACL name' => '',
        'Validity' => 'Pengesahan',
        'Copy' => 'Salin',
        'No data found.' => 'Tiada data dijumpai.',

        # Template: AdminACLEdit
        'Edit ACL %s' => '',
        'Go to overview' => 'Pergi ke papar semua',
        'Delete ACL' => '',
        'Delete Invalid ACL' => '',
        'Match settings' => '',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '',
        'Change settings' => '',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '',
        'Check the official' => '',
        'documentation' => '',
        'Show or hide the content' => 'Menunjukkan atau menyembunyikan kandungan',
        'Edit ACL information' => '',
        'Stop after match' => 'Berhenti selepas perlawanan',
        'Edit ACL structure' => '',
        'Save' => 'Simpan',
        'or' => 'atau',
        'Save and finish' => 'Simpan dan tamat',
        'Do you really want to delete this ACL?' => '',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '',
        'An item with this name is already present.' => '',
        'Add all' => '',
        'There was an error reading the ACL data.' => '',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '',

        # Template: AdminAttachment
        'Attachment Management' => 'Pengurusan Lampiran',
        'Add attachment' => 'Tambahan lampiran',
        'List' => 'Senarai',
        'Download file' => 'Muat turun fail',
        'Delete this attachment' => 'Padam lampiran ini',
        'Add Attachment' => 'Tambah lampiran',
        'Edit Attachment' => 'Audit lampiran',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Pengurusan tindak balas automatik',
        'Add auto response' => 'Tambah balasan automatik',
        'Add Auto Response' => 'Tambah balasan automatik',
        'Edit Auto Response' => 'Tambah balasan automatik',
        'Response' => 'Tindak balas',
        'Auto response from' => 'Jawapan automatik',
        'Reference' => 'Rujukan(en)',
        'You can use the following tags' => 'Tag berikut boleh digunakan',
        'To get the first 20 character of the subject.' => '20 aksara pertama subjek',
        'To get the first 5 lines of the email.' => 'Yang pertama lima baris mesej',
        'To get the realname of the sender (if given).' => 'Nama pengguna (jika dinyatakan)',
        'To get the article attribute' => 'Atribut Seksyen',
        ' e. g.' => 'cth.',
        'Options of the current customer user data' => 'Atribut pelanggan semasa',
        'Ticket owner options' => 'Atribut memegang tiket',
        'Ticket responsible options' => 'Atribut caj tiket',
        'Options of the current user who requested this action' => 'Pilihan pengguna semasa yang meminta tindakan ini',
        'Options of the ticket data' => 'Pilihan data tiket',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'tetapan tatarajah',
        'Example response' => 'balas daripada sampel',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Pengurusan Pelanggan',
        'Wildcards like \'*\' are allowed.' => '',
        'Add customer' => 'menambah Pelanggan',
        'Select' => 'Pilih',
        'Please enter a search term to look for customers.' => 'Sila masukkan kata kunci untuk mencari pelanggan.',
        'Add Customer' => 'Tambah pelanggan',
        'Edit Customer' => 'Audit pelanggan',

        # Template: AdminCustomerUser
        'Customer User Management' => '',
        'Back to search results' => '',
        'Add customer user' => '',
        'Hint' => 'Petunjuk',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '',
        'Last Login' => 'Log masuk terakhir',
        'Login as' => 'Log masuk sebagai',
        'Switch to customer' => '',
        'Add Customer User' => '',
        'Edit Customer User' => '',
        'This field is required and needs to be a valid email address.' =>
            'Bidang ini diperlukan dan mestilah alamat e-mel yang sah.',
        'This email address is not allowed due to the system configuration.' =>
            'Ini alamat e-mel tidak dibenarkan oleh konfigurasi sistem semasa.',
        'This email address failed MX check.' => 'Untuk alamat e-mel MX-ujian gagal.',
        'DNS problem, please check your configuration and the error log.' =>
            'Masalah DNS, sila semak konfigurasi anda dan log ralat.',
        'The syntax of this email address is incorrect.' => 'Sintaks alamat e-mel tidak sah.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Pelanggan tugasan kumpulan Mengurus',
        'Notice' => 'Catatan',
        'This feature is disabled!' => 'Ciri ini dilumpuhkan!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Gunakan fungsi ini program jika anda mahu untuk menentukan kebenaran kumpulan untuk pelanggan.',
        'Enable it here!' => 'untuk mengaktifkan!',
        'Search for customers.' => 'Mencari pelanggan.',
        'Edit Customer Default Groups' => 'Edit Kumpulan Pelanggan Sedia Ada',
        'These groups are automatically assigned to all customers.' => 'Kumpulan-kumpulan ini secara automatik diberikan kepada semua pelanggan.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Anda boleh menguruskan kumpulan ini melalui tetapan tatarajah "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Penapis untuk kumpulan',
        'Select the customer:group permissions.' => 'Pilih pelanggan: dari kumpulan hak',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Jika tiada apa yang dipilih, maka terdapat tiada kebenaran dalam kumpulan ini (tiket tidak akan disediakan untuk pelanggan).',
        'Search Results' => 'Search Results',
        'Customers' => 'Pelanggan',
        'Groups' => 'Kumpulan',
        'No matches found.' => 'Tiada padanan ditemui.',
        'Change Group Relations for Customer' => 'Kumpulan tugasan untuk menguruskan pelanggan',
        'Change Customer Relations for Group' => 'Tukar Perhubungan Pelanggan untuk Kumpulan',
        'Toggle %s Permission for all' => 'Undang-undang% s untuk semua suis',
        'Toggle %s permission for %s' => 'Kebenaran untuk% s% ubah',
        'Customer Default Groups:' => 'Kumpulan standard:',
        'No changes can be made to these groups.' => 'Dalam kumpulan-kumpulan ini tidak boleh diubah suai.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Baca sahaja akses kepada tiket dalam kumpulan ini / beratur.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Penuh membaca dan menulis akses kepada tiket dalam kumpulan ini / beratur.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Khidmat Pelanggan Mengurus tugasan',
        'Edit default services' => 'Standard Perkhidmatan sunting',
        'Filter for Services' => 'Tapisan Perkhidmatan',
        'Allocate Services to Customer' => 'Memperuntukkan Perkhidmatan kepada Pelanggan',
        'Allocate Customers to Service' => 'Memperuntukkan Pelanggan untuk Perkhidmatan',
        'Toggle active state for all' => 'ubah keadaan aktif untuk semua',
        'Active' => 'Aktif',
        'Toggle active state for %s' => 'ubah keadaan aktif untuk %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Pengurusan Dinamik Bidang',
        'Add new field for object' => 'Tambah Bidang Baru bagi objek',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Untuk mewujudkan satu bidang baru, pilih jenis bidang dari senarai objek. Objek mentakrifkan keahlian bidang dan tidak boleh ditukar selepas penciptaan.',
        'Dynamic Fields List' => 'Senarai bidang yang dinamik',
        'Dynamic fields per page' => 'Dinamik bidang per halaman',
        'Label' => 'Label',
        'Order' => 'Menyusun',
        'Object' => 'Objek',
        'Delete this field' => 'Padam bidang ini',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Adakah anda benar-benar mahu untuk memadam bidang ini yang dinamik? SEMUA data yang berkaitan akan HILANG!',
        'Delete field' => 'Padam bidang',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Perlengkapan dinamik',
        'Field' => 'Bidang',
        'Go back to overview' => 'Pergi kembali ke gambaran keseluruhan',
        'General' => 'Umum',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Bidang ini diperlukan, dan nilai harus aksara abjad dan nombor sahaja.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Mestilah unik dan hanya menerima aksara abjad dan nombor.',
        'Changing this value will require manual changes in the system.' =>
            'Menukar nilai ini akan memerlukan perubahan manual dalam sistem.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Ini adalah nama yang ditunjukkan pada skrin di mana bidang aktif.',
        'Field order' => 'Turutan bidang',
        'This field is required and must be numeric.' => 'Bidang ini diperlukan dan mesti terdiri daripada angka.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Ini adalah perintah di mana bidang ini akan ditunjukkan pada skrin di mana aktif.',
        'Field type' => 'Jenis bidang',
        'Object type' => 'Jenis objek',
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => '',
        'Field Settings' => 'Aturan bidang',
        'Default value' => 'Nilai sedia ada',
        'This is the default value for this field.' => 'Ini adalah nilai lalai untuk bidang ini',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Perbezaan tarikh sedia ada',
        'This field must be numeric.' => 'Bidang ini mestilah angka.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Perbezaan dari SEKARANG (dalam saat) untuk mengira nilai bidang lalai (contohnya 3600 atau -60).',
        'Define years period' => 'Tentukan tahun',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Aktifkan ciri ini untuk menentukan pelbagai tetap tahun (pada masa hadapan dan pada masa lalu) akan dipaparkan pada bahagian tahun bidang.',
        'Years in the past' => 'Tahun pada masa lalu',
        'Years in the past to display (default: 5 years).' => 'Tahun pada masa lalu untuk memaparkan (lalai: 5 tahun).',
        'Years in the future' => 'Tahun pada masa hadapan',
        'Years in the future to display (default: 5 years).' => 'Tahun akan datang untuk memaparkan (lalai: 5 tahun).',
        'Show link' => 'Papar pautan',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Disini anda boleh menyatakan pilihan pautan HTTP untuk nilai bidang dalam gambaran keseluruhan dan skrin Zoom.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'nilai yang mungkin',
        'Key' => 'Kunci',
        'Value' => 'Nilai',
        'Remove value' => 'Buang nilai',
        'Add value' => 'Tambah nilai',
        'Add Value' => 'Tambah Nilai',
        'Add empty value' => 'Tambah nilai kosong',
        'Activate this option to create an empty selectable value.' => 'Aktifkan pilihan ini untuk mewujudkan nilai dipilih kosong.',
        'Tree View' => '',
        'Activate this option to display values as a tree.' => '',
        'Translatable values' => 'nilai yang boleh diterjemahkan',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Jika anda mengaktifkan pilihan ini nilai akan diterjemahkan kepada pengguna ditakrifkan bahasa.',
        'Note' => 'Nota',
        'You need to add the translations manually into the language translation files.' =>
            'Anda perlu menambah terjemahan secara manual ke dalam fail terjemahan bahasa.',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Bilangan baris',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Tentukan ketinggian (dalam barisan) untuk bidang ini dalam mod edit.',
        'Number of cols' => 'Bilangan lajur',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Menetapkan lebar dalam aksara untuk bidang ini dalam mod edit.',

        # Template: AdminEmail
        'Admin Notification' => 'Pemberitahuan admin',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Dengan modul ini, pentadbir boleh menghantar mesej kepada ejen, kumpulan atau peranan ahli.',
        'Create Administrative Message' => 'Buat Mesej Pentadbiran',
        'Your message was sent to' => 'Mesej anda telah dihantar kepada',
        'Send message to users' => 'Hantar mesej kepada pengguna',
        'Send message to group members' => 'Hantar mesej kepada ahli kumpulan',
        'Group members need to have permission' => 'Ahli kumpulan perlu mempunyai kebenaran',
        'Send message to role members' => 'Hantar mesej kepada ahli peranan',
        'Also send to customers in groups' => 'Juga dihantar kepada kumpulan pelanggan',
        'Body' => 'Badan',
        'Send' => 'Hantar',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Agen generik',
        'Add job' => 'Tambah Kerja',
        'Last run' => 'jangka terakhir',
        'Run Now!' => 'Main Sekarang!',
        'Delete this task' => 'Padam tugas ini',
        'Run this task' => 'Jalankan tugas ini',
        'Job Settings' => 'kerja Tetapan',
        'Job name' => 'Nama kerja',
        'Toggle this widget' => 'ubah widget ini',
        'Automatic execution (multiple tickets)' => '',
        'Execution Schedule' => '',
        'Schedule minutes' => 'Jadual minit(n)',
        'Schedule hours' => 'jadual waktu(n)',
        'Schedule days' => 'Jadual hari(en)',
        'Currently this generic agent job will not run automatically.' =>
            'Masa kerja ini ejen generik tidak akan berjalan secara automatik.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Untuk membolehkan pelaksanaan automatik pilih sekurang-kurangnya satu nilai daripada minit, jam dan hari!',
        'Event based execution (single ticket)' => '',
        'Event Triggers' => 'Pencentus Acara',
        'List of all configured events' => '',
        'Delete this event' => 'Padam acara ini',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => 'Anda pasti mahu memadam pencetus acara ini?',
        'Add Event Trigger' => 'Tambah pencetus acara',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Untuk menambah acara baru pilih objek acara dan nama acara kemudian tekan pada butang "+"',
        'Duplicate event.' => '',
        'This event is already attached to the job, Please use a different one.' =>
            '',
        'Delete this Event Trigger' => 'Padam pencetus acara ini',
        'Ticket Filter' => 'Penapis tiket',
        '(e. g. 10*5155 or 105658*)' => 'contoh. 10*5144 atau 105658*',
        '(e. g. 234321)' => 'contoh. 234321',
        'Customer login' => 'Pelanggan Log Masuk',
        '(e. g. U5150)' => 'cth. U5150',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Teks Carian Penuh dalam artikel-artikel (cth. "Mar*in" atau "Baue*").',
        'Agent' => 'Ejen',
        'Ticket lock' => 'Mengunci Tiket',
        'Create times' => 'Buat kali',
        'No create time settings.' => 'Tiada mewujudkan tetapan masa',
        'Ticket created' => 'tiket menciptakan',
        'Ticket created between' => 'Tiket diwujudkan antara',
        'Change times' => 'Perubahan kali',
        'No change time settings.' => 'Tiada masa perubahan tetapan',
        'Ticket changed' => 'tiket berubah',
        'Ticket changed between' => 'Tiket berubah antara',
        'Close times' => 'kali Tutup',
        'No close time settings.' => 'Tiada tetapan masa dekat',
        'Ticket closed' => 'tiket ditutup',
        'Ticket closed between' => 'Tiket ditutup antara',
        'Pending times' => 'Menunggu masa',
        'No pending time settings.' => 'Tetapan Tiada masa menunggu',
        'Ticket pending time reached' => 'Masa Tiket menunggu sampai',
        'Ticket pending time reached between' => 'Masa Tiket menunggu dicapai antara',
        'Escalation times' => 'peningkatan kali',
        'No escalation time settings.' => 'Tiada peningkatan tetapan masa',
        'Ticket escalation time reached' => 'Masa peningkatan Tiket mencapai',
        'Ticket escalation time reached between' => 'Tiket masa peningkatan dicapai antara',
        'Escalation - first response time' => 'Peningkatan tindak balas kali pertama',
        'Ticket first response time reached' => 'Tiket masa tindak balas pertama mencecah',
        'Ticket first response time reached between' => 'Tiket tindak balas kali pertama dicapai antara',
        'Escalation - update time' => 'Peningkatan - kemas kini masa',
        'Ticket update time reached' => 'Tiket kemas kini masa sampai',
        'Ticket update time reached between' => 'Tiket kemas kini masa dicapai antara',
        'Escalation - solution time' => 'Peningkatan - penyelesaian masa',
        'Ticket solution time reached' => 'Masa penyelesaian Tiket mencapai',
        'Ticket solution time reached between' => 'Tiket masa penyelesaian dicapai antara',
        'Archive search option' => 'Arkib carian pilihan',
        'Ticket Action' => 'Tindakan tiket',
        'Set new service' => 'Tetapkan perkhidmatan baru',
        'Set new Service Level Agreement' => 'Tetapkan Perjanjian Tahap Perkhidmatan baru',
        'Set new priority' => 'Tetapkan keutamaan baru',
        'Set new queue' => 'Tetapkan barisan baru',
        'Set new state' => 'Tetapkan keadaan yang baru',
        'Pending date' => 'Tarikh Penangguhan',
        'Set new agent' => 'Tetapkan ejen baru',
        'new owner' => 'Pemilik baru',
        'new responsible' => 'tanggungjawab baru',
        'Set new ticket lock' => 'Tetapkan kunci tiket baru',
        'New customer' => 'pelanggan baru',
        'New customer ID' => 'ID pelanggan Baru',
        'New title' => 'tajuk baru',
        'New type' => 'jenis baru',
        'New Dynamic Field Values' => 'Nilai Bidang Dinamik Baru',
        'Archive selected tickets' => 'Arkib dipilih tiket',
        'Add Note' => 'Tambah Nota',
        'Time units' => 'masa unit',
        ' (work units)' => ' (unit bekerja)',
        'Ticket Commands' => 'tiket Perintah',
        'Send agent/customer notifications on changes' => 'Hantar ejen / pelanggan pemberitahuan mengenai perubahan',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Arahan ini akan dilaksanakan. ARG [0] akan menjadi nombor tiket. ARG [1] id tiket.',
        'Delete tickets' => 'Padam tiket',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Amaran: Semua tiket yang terjejas akan dikeluarkan dari pangkalan data dan tidak boleh dipulihkan.',
        'Execute Custom Module' => 'Melaksanakan Modul Custom',
        'Param %s key' => 'Parameter Utama %s',
        'Param %s value' => 'Nilai Parameter %s',
        'Save Changes' => 'Simpan Perubahan',
        'Results' => 'Keputusan',
        '%s Tickets affected! What do you want to do?' => '%s Tiket terjejas! Apa yang anda mahu lakukan?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Amaran: Anda menggunakan pilihan DELETE. Semua tiket yang dipadam akan hilang!',
        'Edit job' => 'Edit Kerja',
        'Run job' => 'Jalankan kerja',
        'Affected Tickets' => 'Tiket yang terjejas',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'GenericInterface Debugger untuk Perkhidmatan Web %s',
        'Web Services' => 'Perkhidmatan Web',
        'Debugger' => 'penyahpepijat',
        'Go back to web service' => 'Kembali kepada perkhidmatan web',
        'Clear' => 'Padam',
        'Do you really want to clear the debug log of this web service?' =>
            'Adakah anda benar-benar mahu untuk membersihkan debug log perkhidmatan web ini?',
        'Request List' => 'Senarai Permintaan',
        'Time' => 'Masa',
        'Remote IP' => 'IP Jauh',
        'Loading' => 'Memuatkan...',
        'Select a single request to see its details.' => 'Pilih permintaan tunggal untuk melihat butirannya.',
        'Filter by type' => 'Tapis mengikut jenis',
        'Filter from' => 'Tapis dari',
        'Filter to' => 'Tapis untuk',
        'Filter by remote IP' => 'Menapis oleh IP jauh',
        'Refresh' => 'Menyegarkan',
        'Request Details' => 'Butiran Permintaan ',
        'An error occurred during communication.' => 'Ralat berlaku semasa komunikasi.',
        'Clear debug log' => 'debug log yang jelas',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Tambah Invoker Baru untuk Perkhidmatan Web %s',
        'Change Invoker %s of Web Service %s' => 'Perubahan Invoker %s daripada Perkhidmatan Web %s',
        'Add new invoker' => 'Tambah invoker baru',
        'Change invoker %s' => 'Perubahan invoker %s',
        'Do you really want to delete this invoker?' => 'Adakah anda benar-benar mahu memadam invoker ini?',
        'All configuration data will be lost.' => 'Semua data konfigurasi akan hilang.',
        'Invoker Details' => 'Butiran Invoker',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Nama biasanya digunakan untuk memanggil operasi perkhidmatan web jauh.',
        'Please provide a unique name for this web service invoker.' => 'Sila berikan nama unik untuk invoker perkhidmatan web ini.',
        'The name you entered already exists.' => 'Nama yang anda masukkan sudah wujud.',
        'Invoker backend' => 'Invoker backend',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Modul OTRS invoker backend ini akan dipanggil untuk menyediakan data untuk dihantar ke sistem jauh, dan untuk memproses data respons.',
        'Mapping for outgoing request data' => 'Pemetaan untuk permintaan data keluar',
        'Configure' => 'Konfigurasi',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Data dari invoker daripada OTRS akan diproses oleh pemetaan ini, untuk mengubah kepada jenis data sistem jauh menjangka.',
        'Mapping for incoming response data' => 'Pemetaan data respons masuk',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'Data tindak balas akan diproses oleh pemetaan ini, untuk mengubah kepada jenis data invoker jangkaan OTRS.',
        'Asynchronous' => 'Asynchronous',
        'This invoker will be triggered by the configured events.' => 'Invoker ini akan dicetuskan oleh peristiwa-peristiwa yang dikonfigurasikan.',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            'Pencetus acara yang tidak segerak akan diuruskan oleh penjadual OTRS di latar belakang (disarankan).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Pencetus acara yang segerak akan diproses terus semasa permintaan web.',
        'Save and continue' => 'Simpan dan sambung',
        'Delete this Invoker' => 'Padam Invoker ini',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'Pemetaan GenericInterface mudah untuk Perkhidmatan Web %s',
        'Go back to' => 'Kembali ke',
        'Mapping Simple' => 'Pemetaan mudah',
        'Default rule for unmapped keys' => 'Peraturan asal untuk kekunci yang tidak dipetakan',
        'This rule will apply for all keys with no mapping rule.' => 'Peraturan ini akan dipakai untuk semua kunci yang tiada peraturan pemetaan.',
        'Default rule for unmapped values' => 'Peraturan asal untuk nilai yang tidak dipetakan.',
        'This rule will apply for all values with no mapping rule.' => 'Peraturan ini akan dipakai untuk semua nilai yang tiada peraturan pemetaan.',
        'New key map' => 'Kunci peta baru',
        'Add key mapping' => 'Tambah pemetaan kunci',
        'Mapping for Key ' => 'Pemetaan untuk kunci',
        'Remove key mapping' => 'Buang pemetaan kunci',
        'Key mapping' => 'Pemetaan kunci',
        'Map key' => 'Peta kunci',
        'matching the' => 'memadankan',
        'to new key' => 'kepada kunci baru',
        'Value mapping' => 'pemetaan nilai',
        'Map value' => 'peta nilai',
        'to new value' => 'kepada nilai baru',
        'Remove value mapping' => 'Buang pemetaan nilai',
        'New value map' => 'Pemetaan nilai baru',
        'Add value mapping' => 'Tambah pemetaan nilai',
        'Do you really want to delete this key mapping?' => 'Anda pasti mahu memadam pemetaan kunci ini?',
        'Delete this Key Mapping' => 'Padam pemetaan kunci ini',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Tambah operasi baru ke perkhidmatan web %s',
        'Change Operation %s of Web Service %s' => 'Ubah operasi %s perkhidmatan web %s',
        'Add new operation' => 'Tamabh operasi baru',
        'Change operation %s' => 'Ubah operasi',
        'Do you really want to delete this operation?' => 'Anda pasti mahu memadam operasi ini?',
        'Operation Details' => 'Butiran operasi',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Nama biasanya digunakan untuk memanggil operasi perkhidmatan web ini dari sistem yang jauh.',
        'Please provide a unique name for this web service.' => 'Sila berikan nama unik untuk perkhidmatan web ini.',
        'Mapping for incoming request data' => 'Pemetaan untuk permintaan masuk data.',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'Data yang dipinta akan diproses oleh pemetaan ini, untuk mengubah ia kepada jenis data yang dijangka OTRS.',
        'Operation backend' => 'Operasi backend',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Operasi backend OTRS ini akan dipanggil secara dalaman untuk memproses permintaan itu, menjana data untuk tidak balas.',
        'Mapping for outgoing response data' => 'Pemetaan untuk tindak balas data yang keluar.',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Data yang bertindak balas akan diproses oleh pemetaan ini, untuk mengubah kepada jenis data yang dijangka oleh sistem jauh itu.',
        'Delete this Operation' => 'Padam operasi ini',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'Pengangkutan GenericInterface HTTP::SOAP untuk perkhidmatan web %s',
        'Network transport' => 'Pengangkutan Rangkaian',
        'Properties' => 'Sifat',
        'Endpoint' => 'Titik akhir',
        'URI to indicate a specific location for accessing a service.' =>
            'URI untuk menunjukkan lokasi tertentu untuk mengakses perkhidmatan.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'contoh: http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Ruang nama',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI untuk memberi kaedah SOAP konteks, mengurangkan kekaburan.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'contoh: urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions',
        'Maximum message length' => 'Panjang maksimum mesej',
        'This field should be an integer number.' => 'Ruang ini haruslah disi dengan nombor.',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Di sini anda boleh menentukan saiz maksimum (dalam byte) mesej SOAP yang akan diproses oleh OTRS.',
        'Encoding' => 'Pengekodan',
        'The character encoding for the SOAP message contents.' => 'Pengekodan aksara bagi kandungan mesej SOAP.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'contoh: utf-8, latin1, iso-8859-1, cp1250, dll.',
        'SOAPAction' => 'TindakanSOAP',
        'Set to "Yes" to send a filled SOAPAction header.' => 'Tetapkan kepada "Ye" untuk menghantar header  TindakanSOAP yang disi.',
        'Set to "No" to send an empty SOAPAction header.' => 'Tetapkan kepada "Tidak" untuk menghantar header TindakanSOAP yang kosong.',
        'SOAPAction separator' => 'Pemisah TindakanSOAP',
        'Character to use as separator between name space and SOAP method.' =>
            'Aksara untuk digunakan sebagai pemisah ruang nama dan kaedah SOAP.',
        'Usually .Net web services uses a "/" as separator.' => 'Selalunya perkhidmatan web .Net menggunakan "/" sebagai pemisah.',
        'Authentication' => 'Pengesahan',
        'The authentication mechanism to access the remote system.' => 'Mekanisme pengesahan untuk mengakses sistem jauh.',
        'A "-" value means no authentication.' => 'Nilai "-" bermaksud tiada pengesahan.',
        'The user name to be used to access the remote system.' => 'Nama pengguna yang akan digunakan untuk mengakses sistem jauh.',
        'The password for the privileged user.' => 'Kata laluan untuk pengguna istimewa.',
        'Use SSL Options' => 'Gunakan pilihan SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Menunjukkan atau menyembunyikan pilihan SSL untuk menyambung ke sistem jauh.',
        'Certificate File' => 'Fail Sijil',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'Laluan penuh dan nama fail sijil SSL (mesti berada dalam format. P12).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'contoh: /opt/otrs/var/certificates/SOAP/certificate.p12',
        'Certificate Password File' => 'Fail Password Sijil',
        'The password to open the SSL certificate.' => 'Kata laluan untuk membuka sijil SSL.',
        'Certification Authority (CA) File' => 'Fail Pihak berkuasa Persijilan (CA)',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Laluan penuh dan nama fail pensijilan sijil kuasa yang mengesahkan sijil SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'contoh: /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Direktori Pihak Berkuasa Persijilan (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Laluan penuh direktori pihak berkuasa pemerakuan yang mana sijil CA disimpan dalam sistem fail.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'contoh: /opt/otrs/var/certificates/SOAP/CA',
        'Proxy Server' => 'Server Proksi',
        'URI of a proxy server to be used (if needed).' => 'URI server proksi yang boleh digunakan (jika diperlukan)',
        'e.g. http://proxy_hostname:8080' => 'contoh: http://proxy_hostname:8080',
        'Proxy User' => 'Pengguna Proksi',
        'The user name to be used to access the proxy server.' => 'Nama pengguna yang akan digunakan untuk mengakses server proksi.',
        'Proxy Password' => 'Kata laluan Proksi',
        'The password for the proxy user.' => 'Kata laluan untuk pengguna proksi.',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'Pengurusan Perkhidmatan Wen GenericInterface',
        'Add web service' => 'Tambah perkhidmatan web',
        'Clone web service' => 'Klon perkhidmatan web',
        'The name must be unique.' => 'Nama perlu unik',
        'Clone' => 'Klon',
        'Export web service' => 'Eksport perkhidmatan web',
        'Import web service' => 'Import perkhidmatan web',
        'Configuration File' => 'Fail Konfigurasi',
        'The file must be a valid web service configuration YAML file.' =>
            'Fail tersebut mestilah fail konfigurasi YAML perkhidmatan web yang sah',
        'Import' => 'Import',
        'Configuration history' => 'Sejarah konfigurasi',
        'Delete web service' => 'Padam perkhidmatan web',
        'Do you really want to delete this web service?' => 'Anda pasti mahu memadam perkhidmatan web ini?',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Selepas anda menyimpan konfigurasi anda akan dibawa semula ke skrin sunting.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Jika anda ingin kembali ke gambaran sila klik butang "Pergi ke gambaran".',
        'Web Service List' => 'Senarai Perkhidmatan Web',
        'Remote system' => 'Sistem jarak jauh',
        'Provider transport' => 'Pengankutan pembekal',
        'Requester transport' => 'Pengangkutan peminta',
        'Details' => 'Butiran',
        'Debug threshold' => 'Paras ambang debug.',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'Dalam mod pembekal, OTRS menawarkan perkhidmatan web yang digunakan oleh sistem jauh.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'Dalam mod peminta, OTRS menggunakan perkhidmatan web sistem terpencil.',
        'Operations are individual system functions which remote systems can request.' =>
            'Operasi fungsi sistem individu yang sistem jauh boleh meminta.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invokers menyediakan data untuk permintaan untuk perkhidmatan web jauh, dan memproses data respons.',
        'Controller' => 'Pengawal',
        'Inbound mapping' => 'Pemetaan dalam',
        'Outbound mapping' => 'Pemetaan keluar',
        'Delete this action' => 'Padam tindakan ini',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Sekurang-kurangnya satu %s mempunyai pengawal yang sama ada tidak aktif atau tidak hadir, sila semak pendaftaran pengawal atau memadam %s',
        'Delete webservice' => 'Param perkhidmatan web',
        'Delete operation' => 'Padam operasi',
        'Delete invoker' => 'Padam invoker',
        'Clone webservice' => 'Klon perkhidmatan web',
        'Import webservice' => 'Import perkhidmatan web',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'GenericInterface Sejarah Konfigurasi Web Perkhidmatan %s',
        'Go back to Web Service' => 'Pergi kembali ke Perkhidmatan Web',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Di sini anda boleh melihat versi yang lebih lama perkhidmatan web semasa tatarajah, eksport atau malah memulihkan mereka.',
        'Configuration History List' => 'Senarai Sejarah Konfigurasi',
        'Version' => 'Versi',
        'Create time' => 'Mencipta masa',
        'Select a single configuration version to see its details.' => 'Pilih versi konfigurasi tunggal untuk melihat butirannya.',
        'Export web service configuration' => 'Eksport konfigurasi perkhidmatan web',
        'Restore web service configuration' => 'Kembalikan konfigurasi perkhidmatan web',
        'Do you really want to restore this version of the web service configuration?' =>
            'Adakah anda benar-benar mahu memulihkan versi ini konfigurasi perkhidmatan web?',
        'Your current web service configuration will be overwritten.' => 'Perkhidmatan web konfigurasi semasa anda akan diganti.',
        'Show or hide the content.' => 'Menunjukkan atau menyembunyikan kandungan.',
        'Restore' => 'Memulihkan',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'AMARAN: Bila anda tukar nama kumpulan \'admin\'-sebelum membuat perubahan dalam SysConfig, anda akan mengunci panel admin! Jika ini berlaku, sila nama semula kumpulan kembali kepada admin seperti penyata SQL',
        'Group Management' => 'Pengurusan Kumpulan',
        'Add group' => 'Tambah kumpulan',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Kumpulan admin adalah untuk masuk ke kawasan admin dan statistik kumpulan untuk mendapat statistik kawasan.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Cipta kumpulan baru untuk memberi kebenaran untuk perbezaan kumpulan dari ejen (cth. membeli jabatan, sokongan jabatan, jabatan jualan, ...).',
        'It\'s useful for ASP solutions. ' => 'Ianya berguna untuk solusi ASP.',
        'Add Group' => 'Tambah Kumpulan',
        'Edit Group' => 'Audit Kumpulan',

        # Template: AdminLog
        'System Log' => 'Log Sistem',
        'Here you will find log information about your system.' => 'Disini anda akan dapat log informasi mengenani sistem anda.',
        'Hide this message' => 'Sorok mesej ni',
        'Recent Log Entries' => 'Log Masuk Baru',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Pengurusan Akaun Emel',
        'Add mail account' => 'Tambah emel akaun',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Kesemua emel masuk dengan satu akaun akan ditampalkan dalam barisan terpilih!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Jika akaun anda dipercayai, kepala X-OTRS yang sudah ada pada masa tiba (untuk keutamaan, ...) akan digunakan! penapis PostMaster akan digunakan sekalipun.',
        'Host' => 'Hos',
        'Delete account' => 'Padam akaun',
        'Fetch mail' => 'E-Mails abholen',
        'Add Mail Account' => 'Tambah emel akaun',
        'Example: mail.example.com' => 'Contoh: mail.contoh.com',
        'IMAP Folder' => 'folder IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Hanya mengubah suai ini jika anda perlu mengambil mel dari folder yang berbeza daripada PET MASUK.',
        'Trusted' => 'dipercayai',
        'Dispatching' => 'menghantar',
        'Edit Mail Account' => 'Edit Akaun Mel',

        # Template: AdminNavigationBar
        'Admin' => 'Admin',
        'Agent Management' => 'Pengurusan Ejen',
        'Queue Settings' => 'Aturan Barisan',
        'Ticket Settings' => 'Aturan Tiket',
        'System Administration' => 'sistem Pentadbiran',

        # Template: AdminNotification
        'Notification Management' => 'Pengurusan Pemberitahuan',
        'Select a different language' => 'Pilih bahasa yang berlainan',
        'Filter for Notification' => 'Tapis untuk pemberitahuan',
        'Notifications are sent to an agent or a customer.' => 'Pemberitahuan dihantar kepada ejen atau pelanggan.',
        'Notification' => 'Pemberitahuan',
        'Edit Notification' => 'Edit pemberitahuan',
        'e. g.' => 'cth.',
        'Options of the current customer data' => 'Pilihan data pelanggan semasa',

        # Template: AdminNotificationEvent
        'Add notification' => 'Tambah pemberitahuan',
        'Delete this notification' => 'Padam pemberitahuan ini',
        'Add Notification' => 'Tambah pemberitahuan',
        'Article Filter' => 'Tapisan Artikel',
        'Only for ArticleCreate event' => 'Hanya kerana Perkara Buat acara',
        'Article type' => 'Jenis artikel',
        'Article sender type' => '',
        'Subject match' => 'perlawanan tertakluk',
        'Body match' => 'perlawanan badan',
        'Include attachments to notification' => 'Termasuk lampiran pemberitahuan',
        'Recipient' => 'Penerima',
        'Recipient groups' => 'penerima kumpulan',
        'Recipient agents' => 'penerima ejen',
        'Recipient roles' => 'penerima peranan',
        'Recipient email addresses' => 'penerima alamat emel',
        'Notification article type' => 'Pemberitahuan artikel jenis',
        'Only for notifications to specified email addresses' => 'Hanya untuk pemberitahuan ke alamat e-mel yang ditetapkan',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Untuk mendapatkan pertama 20 watak subjek (artikel ejen terbaru).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Untuk mendapatkan 5 baris pertama badan (artikel ejen terbaru).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Untuk mendapatkan pertama 20 watak subjek (artikel pelanggan terbaru)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Untuk mendapatkan 5 baris pertama badan (pelanggan artikel yang terbaru).',

        # Template: AdminPGP
        'PGP Management' => 'PGP-Pengurusan',
        'Use this feature if you want to work with PGP keys.' => 'Gunakan ciri ini jika anda mahu bekerja dengan kekunci PGP.',
        'Add PGP key' => 'Tambah kekunci PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Dengan cara ini, anda boleh terus edit gegelang kunci dikonfigurasikan dalam SysConfig.',
        'Introduction to PGP' => 'Pengenalan kepada PGP',
        'Result' => 'Keputusan',
        'Identifier' => 'Kenal pasti',
        'Bit' => 'Bit',
        'Fingerprint' => 'cap jari',
        'Expires' => 'Tamat',
        'Delete this key' => 'Padamkan kunci ini',
        'Add PGP Key' => 'Tambah Kunci PGP',
        'PGP key' => 'PGP kunci',

        # Template: AdminPackageManager
        'Package Manager' => 'Pengurus pakej',
        'Uninstall package' => 'buang pakej',
        'Do you really want to uninstall this package?' => 'Adakah anda benar-benar mahu untuk memadam pakej ini?',
        'Reinstall package' => 'Pasang semula pakej',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Adakah anda benar-benar mahu memasang semula pakej ini? Sebarang perubahan manual akan hilang.',
        'Continue' => 'Sambung',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'Pasang',
        'Install Package' => 'Pasang Pakej',
        'Update repository information' => 'Kemaskini maklumat repositori',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'repositori talian',
        'Vendor' => 'Penjual',
        'Module documentation' => 'dokumentasi modul',
        'Upgrade' => 'Kemaskini',
        'Local Repository' => 'Direktori tempatan',
        'This package is verified by OTRSverify (tm)' => '',
        'Uninstall' => 'Nyah-pasang',
        'Reinstall' => 'Pasang semula',
        'Feature Add-Ons' => 'Menampilkan Tambahan',
        'Download package' => 'Muat pakej',
        'Rebuild package' => 'membina pakej',
        'Metadata' => 'metadata',
        'Change Log' => 'Perubahan Log',
        'Date' => 'Tarikh',
        'List of Files' => 'Senarai Fail',
        'Permission' => 'Kebenaran',
        'Download' => 'Muat turun',
        'Download file from package!' => 'Muat turun fail dari pakej!',
        'Required' => 'Diperlukan',
        'PrimaryKey' => 'Kunci Utama',
        'AutoIncrement' => 'Kenaikan Auto',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Fail perbezaan untuk fail %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log prestasi',
        'This feature is enabled!' => 'Ciri ini diaktifkan!',
        'Just use this feature if you want to log each request.' => 'Hanya menggunakan ciri ini jika anda mahu untuk log setiap permintaan.',
        'Activating this feature might affect your system performance!' =>
            'Mengaktifkan ciri ini mungkin menjejaskan prestasi sistem anda!',
        'Disable it here!' => 'Melumpuhkan ia di sini!',
        'Logfile too large!' => 'Fail log terlalu besar!',
        'The logfile is too large, you need to reset it' => 'Fail log adalah terlalu besar, anda perlu untuk menetapkan semula',
        'Overview' => 'Gambaran keseluruhan',
        'Range' => 'Pertengahan',
        'last' => 'akhir',
        'Interface' => 'Paparan',
        'Requests' => 'permintaan',
        'Min Response' => 'Tindakbalas min',
        'Max Response' => 'Tindakbalas Max',
        'Average Response' => 'purata Tindakbalas',
        'Period' => 'tempoh',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'purata',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Postmaster Penapis Pengurusan',
        'Add filter' => 'Tambah penapis',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Untuk penghantaran atau menapis e-mel masuk berdasarkan pengepala e. Pemadanan menggunakan Ungkapan Biasa juga mungkin.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Jika anda mahu untuk dipadankan hanya alamat e-mel, menggunakan ALAMAT EMAIL: info@example.come masuk Dari, Kepada atau Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Jika anda menggunakan Ungkapan Biasa, anda juga boleh menggunakan nilai yang dipadankan dalam () sebagai [***] di \'Set\' tindakan.',
        'Delete this filter' => 'Padam penapis ini',
        'Add PostMaster Filter' => 'Tambah Postmaster Penapis',
        'Edit PostMaster Filter' => 'Edit Postmaster Penapis',
        'The name is required.' => 'Nama diperlukan.',
        'Filter Condition' => 'Keadaan penapis',
        'AND Condition' => '',
        'Negate' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Bidang perlu untuk menjadi ungkapan yang sah tetap atau perkataan literal.',
        'Set Email Headers' => 'Tetapkan Pengepala E-mel',
        'The field needs to be a literal word.' => 'Bidang perlu menjadi perkataan literal.',

        # Template: AdminPriority
        'Priority Management' => 'Pengurusan keutamaan',
        'Add priority' => 'Tambah keutamaan',
        'Add Priority' => 'Tambah Keutamaan',
        'Edit Priority' => 'Edit Keutamaan',

        # Template: AdminProcessManagement
        'Process Management' => 'Pengurusan Proses',
        'Filter for Processes' => 'Penapis untuk Proses',
        'Process Name' => 'Nama Proses',
        'Create New Process' => 'Cipta Proses Baru',
        'Synchronize All Processes' => 'Menyamakan Semua Proses',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Disini anda boleh muat naik fail konfigurasi untuk import proses kedalam sistem anda. Fail itu mestilah di dalam format .yml seperti yang diexport oleh modul pengurusan proses.',
        'Upload process configuration' => 'Muat naik konfigurasi proses',
        'Import process configuration' => 'Import konfigurasi proses',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Untuk cipta Proses baru anda boleh sama ada import sebuah Proses yang telah diexport daripada sistem lain atau cipta proses yang baru.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Perubahan kepada Proses disini hanya akan memberi kesan kepada kelakuan sistem, jika anda menyamakan data Proses. Dengan menyamakan Proses, perubahan yang baru akan ditulis ke Konfigurasi.',
        'Processes' => 'Proses',
        'Process name' => 'Nama Proses',
        'Print' => 'Cetak',
        'Export Process Configuration' => 'Export Konfigurasi Proses',
        'Copy Process' => 'Salin Proses',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Batal dan Tutup tetingkap.',
        'Go Back' => 'Kembali',
        'Please note, that changing this activity will affect the following processes' =>
            'Sila ambil perhatian bahawa mengubah aktiviti ini akan menjejaskan proses berikut',
        'Activity' => 'Aktiviti',
        'Activity Name' => 'Nama Aktiviti',
        'Activity Dialogs' => 'Dialog Aktiviti',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Anda boleh berikan Dialog Aktiviti ke Aktiviti ini dengan menarik unsur tersebut menggunakan tetikus dari senarai kiri ke senarai kanan.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Memesan unsur dalam senarai juga boleh dilakukan dengan drag dan drop.',
        'Filter available Activity Dialogs' => 'Dialog Aktiviti dengan Penapis',
        'Available Activity Dialogs' => 'Dialog Aktiviti Tersedia',
        'Create New Activity Dialog' => 'Cipta Dialog Aktiviti Baru',
        'Assigned Activity Dialogs' => 'Dialog Aktiviti Ditugaskan',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Selepas sahaja anda guna butang atau pautan ini, anda akan meninggalkan skrin ini dan keadaan semasa akan disimpan secara automatik. Adakah anda mahu teruskan?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '',
        'Activity Dialog' => '',
        'Activity dialog Name' => '',
        'Available in' => '',
        'Description (short)' => '',
        'Description (long)' => '',
        'The selected permission does not exist.' => '',
        'Required Lock' => '',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => '',
        'Submit Button Text' => '',
        'Fields' => '',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available fields' => '',
        'Available Fields' => '',
        'Assigned Fields' => '',
        'Edit Details for Field' => '',
        'ArticleType' => '',
        'Display' => '',
        'Edit Field Details' => '',
        'Customer interface does not support internal article types.' => '',

        # Template: AdminProcessManagementPath
        'Path' => '',
        'Edit this transition' => '',
        'Transition Actions' => '',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available Transition Actions' => '',
        'Available Transition Actions' => '',
        'Create New Transition Action' => '',
        'Assigned Transition Actions' => '',

        # Template: AdminProcessManagementPopupResponse

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '',
        'Filter Activities...' => '',
        'Create New Activity' => '',
        'Filter Activity Dialogs...' => '',
        'Transitions' => '',
        'Filter Transitions...' => '',
        'Create New Transition' => '',
        'Filter Transition Actions...' => '',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '',
        'Print process information' => '',
        'Delete Process' => '',
        'Delete Inactive Process' => '',
        'Available Process Elements' => '',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => '',
        'The selected state does not exist.' => '',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Edit this Activity' => '',
        'Save settings' => '',
        'Save Activities, Activity Dialogs and Transitions' => '',
        'Do you really want to delete this Process?' => '',
        'Do you really want to delete this Activity?' => '',
        'Do you really want to delete this Activity Dialog?' => '',
        'Do you really want to delete this Transition?' => '',
        'Do you really want to delete this Transition Action?' => '',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Hide EntityIDs' => '',
        'Delete Entity' => '',
        'Remove Entity from canvas' => '',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '',
        'Remove the Transition from this Process' => '',
        'No TransitionActions assigned.' => '',
        'The Start Event cannot loose the Start Transition!' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => '',
        'Contains %s dialog(s)' => '',
        'Assigned dialogs' => '',
        'Activities are not being used in this process.' => '',
        'Assigned fields' => '',
        'Activity dialogs are not being used in this process.' => '',
        'Condition linking' => '',
        'Conditions' => '',
        'Condition' => '',
        'Transitions are not being used in this process.' => '',
        'Module name' => '',
        'Configuration' => '',
        'Transition actions are not being used in this process.' => '',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '',
        'Transition' => '',
        'Transition Name' => '',
        'Type of Linking between Conditions' => '',
        'Remove this Condition' => '',
        'Type of Linking' => '',
        'Remove this Field' => '',
        'Add a new Field' => '',
        'Add New Condition' => '',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '',
        'Transition Action' => '',
        'Transition Action Name' => '',
        'Transition Action Module' => '',
        'Config Parameters' => '',
        'Remove this Parameter' => '',
        'Add a new Parameter' => '',

        # Template: AdminQueue
        'Manage Queues' => 'Pengurusan Barisan',
        'Add queue' => 'Tambah barisan',
        'Add Queue' => 'Tambah Barisan',
        'Edit Queue' => 'Edit barisan',
        'Sub-queue of' => 'Sub-barisan',
        'Unlock timeout' => 'Buka masa tamat',
        '0 = no unlock' => '0 = tidak buka kunci',
        'Only business hours are counted.' => 'Hanya waktu perniagaan dikira.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Jika ejen mengunci tiket dan tidak menutupnya sebelum masa tamat membuka telah berlalu, tiket akan membuka dan akan menjadi tersedia untuk ejen-ejen lain.',
        'Notify by' => 'memberitahu melalui',
        '0 = no escalation' => '0 = tidak peningkatan',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Jika ada tidak menambah kenalan pelanggan, sama ada melalui e-mel luaran atau telefon, tiket baru sebelum tamat tempoh masa yang ditetapkan, di sini, tiket meningkat.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Jika terdapat satu artikel menambah, seperti susulan melalui e-mel atau portal pelanggan, masa peningkatan kemas kini semula. Jika tiada hubungan pelanggan, sama ada melalui e-mel luaran atau telefon, ditambah kepada tiket sebelum tamat tempoh masa yang ditetapkan, di sini, tiket meningkat.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Jika tiket itu tidak bersedia untuk ditutup sebelum tamat tempoh masa yang ditetapkan, di sini, tiket meningkat.',
        'Follow up Option' => 'Susulan Pilihan',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Menetapkan jika susulan kepada tiket ditutup akan membuka semula tiket, boleh ditolak atau membawa kepada tiket baru.',
        'Ticket lock after a follow up' => 'Tiket kunci selepas susulan',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Jika tiket ditutup dan pelanggan menghantar susulan tiket akan dikunci kepada pemilik lama.',
        'System address' => 'Alamat Sistem',
        'Will be the sender address of this queue for email answers.' => 'Akan menjadi alamat pengirim barisan ini untuk mendapatkan jawapan e-mel.',
        'Default sign key' => 'Tanda kunci lalai',
        'The salutation for email answers.' => 'Kata aluan untuk mendapatkan jawapan e-mel.',
        'The signature for email answers.' => 'Tandatangan untuk mendapatkan jawapan e-mel.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Mengurus Perhubungan Response Barisan-Auto',
        'Filter for Queues' => 'Penapis untuk barisan',
        'Filter for Auto Responses' => 'Penapis untuk Tindak Balas Auto',
        'Auto Responses' => 'Auto Tindak Balas',
        'Change Auto Response Relations for Queue' => 'Tukar Perhubungan Response Auto untuk Barisan',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '',
        'Filter for Templates' => '',
        'Templates' => '',
        'Change Queue Relations for Template' => '',
        'Change Template Relations for Queue' => '',

        # Template: AdminRegistration
        'System Registration Management' => '',
        'Edit details' => '',
        'Overview of registered systems' => '',
        'Deregister system' => '',
        'System Registration' => '',
        'This system is registered with OTRS Group.' => '',
        'System type' => '',
        'Unique ID' => '',
        'Last communication with registration server' => '',
        'OTRS-ID Login' => '',
        'System registration is a service of OTRS group, which provides a lot of advantages!' =>
            '',
        'Read more' => '',
        'You need to log in with your OTRS-ID to register your system.' =>
            '',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            '',
        'What are the advantages of system registration?' => '',
        'You will receive updates about relevant security releases.' => '',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '',
        'This is only the beginning!' => '',
        'We will inform you about our new services and offerings soon.' =>
            '',
        'Can I use OTRS without being registered?' => '',
        'System registration is optional.' => '',
        'You can download and use OTRS without being registered.' => '',
        'Is it possible to deregister?' => '',
        'You can deregister at any time.' => '',
        'Which data is transfered when registering?' => '',
        'A registered system sends the following data to OTRS Group:' => '',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            '',
        'Why do I have to provide a description for my system?' => '',
        'The description of the system is optional.' => '',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '',
        'How often does my OTRS system send updates?' => '',
        'Your system will send updates to the registration server at regular intervals.' =>
            '',
        'Typically this would be around once every three days.' => '',
        'In case you would have further questions we would be glad to answer them.' =>
            '',
        'Please visit our' => '',
        'portal' => '',
        'and file a request.' => '',
        'If you deregister your system, you will loose these benefits:' =>
            '',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            '',
        'OTRS-ID' => '',
        'You don\'t have an OTRS-ID yet?' => '',
        'Sign up now' => 'Daftar sekarang',
        'Forgot your password?' => '',
        'Retrieve a new one' => '',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            '',
        'Attribute' => '',
        'FQDN' => '',
        'OTRS Version' => '',
        'Operating System' => '',
        'Perl Version' => '',
        'Optional description of this system.' => '',
        'Register' => '',
        'Deregister System' => '',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            '',
        'Deregister' => '',
        'You can modify the system type and description here.' => '',

        # Template: AdminRole
        'Role Management' => 'Pengurusan peranan',
        'Add role' => 'menambah peranan',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Buat peranan dan meletakkan kumpulan di dalamnya. Kemudian menambah peranan kepada pengguna.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Tiada peranan ditakrifkan. Sila gunakan \'Tambah\' butang untuk mencipta peranan baru.',
        'Add Role' => 'Tambah Peranan',
        'Edit Role' => 'Edit Peranan',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Mengurus Perhubungan Kumpulan Peranan',
        'Filter for Roles' => 'Menapis Peranan',
        'Roles' => 'peranan',
        'Select the role:group permissions.' => 'Pilih peranan: kebenaran kumpulan.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Jika tiada apa yang dipilih, maka terdapat tiada kebenaran dalam kumpulan ini (tiket tidak akan disediakan untuk peranan).',
        'Change Role Relations for Group' => 'Perubahan Peranan Perhubungan bagi Kumpulan',
        'Change Group Relations for Role' => 'Tukar Perhubungan Kumpulan bagi Peranan',
        'Toggle %s permission for all' => 'Togol %s kebenaran untuk semua',
        'move_into' => 'move_into',
        'Permissions to move tickets into this group/queue.' => 'Kebenaran untuk bergerak tiket ke kumpulan ini / barisan.',
        'create' => 'mewujudkan',
        'Permissions to create tickets in this group/queue.' => 'Kebenaran untuk mewujudkan tiket dalam kumpulan ini / barisan.',
        'priority' => 'Keutamaan',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Keizinan untuk menukar keutamaan tiket dalam kumpulan ini / barisan.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Mengurus Perhubungan Ejen-Peranan',
        'Filter for Agents' => 'Tapis untuk Ejen',
        'Agents' => 'Ejen-ejen',
        'Manage Role-Agent Relations' => 'Mengurus Perhubungan Peranan Agen',
        'Change Role Relations for Agent' => 'Perubahan Peranan Perhubungan untuk Agen',
        'Change Agent Relations for Role' => 'Tukar Perhubungan Agen untuk Peranan',

        # Template: AdminSLA
        'SLA Management' => 'SLA-Pengurusan',
        'Add SLA' => 'SLA Tambah',
        'Edit SLA' => 'SLA Edit',
        'Please write only numbers!' => 'Sila tulis nombor sahaja!',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME-Pengurusan',
        'Add certificate' => 'Tambah sijil',
        'Add private key' => 'Tambah kunci persendirian',
        'Filter for certificates' => 'Tapis bagi sijil',
        'Filter for SMIME certs' => 'Penapis untuk SMIME sijil',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            'Di sini anda boleh menambah hubungan sijil peribadi anda, ini akan tertanam tandatangan SMIME setiap kali anda menggunakan sijil ini untuk menandatangani e-mel',
        'See also' => 'Lihat juga',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Dengan cara ini, anda boleh terus mengedit kunci pensijilan dan swasta dalam sistem fail.',
        'Hash' => 'Hash',
        'Handle related certificates' => 'Mengendalikan sijil yang berkaitan',
        'Read certificate' => '',
        'Delete this certificate' => 'Padam sijil ini',
        'Add Certificate' => 'Tambah Sijil',
        'Add Private Key' => 'Tambah Kunci Persendirian',
        'Secret' => 'rahsia',
        'Related Certificates for' => 'Pensijilan berkaitan untuk',
        'Delete this relation' => 'Padam hubungan ini',
        'Available Certificates' => 'Pensijilan yang disediakan',
        'Relate this certificate' => 'Hubungkaitkan sijil ini',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => '',
        'Close window' => 'Tutup tetingkap',

        # Template: AdminSalutation
        'Salutation Management' => 'salam Pengurusan',
        'Add salutation' => 'Tambah salam',
        'Add Salutation' => 'Tambah salam',
        'Edit Salutation' => 'Edit salam',
        'Example salutation' => 'salam contoh',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            'Pilihan ini akan memaksa Berjadual untuk memulakan walaupun jika proses itu masih didaftarkan di dalam pangkalan data',
        'Start scheduler' => 'Mula penjadual',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            'Penjadual tidak dapat dimulakan.Semak jika penjadual tidak berjalan dan cuba sekali lagi dengan pilihan Paksa Mula',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Mod selamat perlu didayakan!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'DerMod selamat (biasanya) akan ditetapkan selepas pemasangan awal selesai.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Jika mod selamat tidak diaktifkan, mengaktifkannya melalui SysConfig kerana permohonan anda sudah berjalan.',

        # Template: AdminSelectBox
        'SQL Box' => 'Kotak SQL',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Sini anda boleh masukkan SQL untuk menghantar terus kepada pangkalan data permohonan.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Syntax query SQL anda mempunyai kesilapan. Sila semak.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Terdapat sekurang-kurangnya satu parameter yang hilang untuk mengikat. Sila semak.',
        'Result format' => 'format Keputusan',
        'Run Query' => 'Jalankan Query',

        # Template: AdminService
        'Service Management' => 'perkhidmatan Pengurusan',
        'Add service' => 'Tambah perkhidmatan',
        'Add Service' => 'Tambah Perkhidmatan',
        'Edit Service' => 'Edit Perkhidmatan',
        'Sub-service of' => 'Sub-perkhidmatan',

        # Template: AdminSession
        'Session Management' => 'Pengurusan sesi',
        'All sessions' => 'semua sesi',
        'Agent sessions' => 'agen sesi',
        'Customer sessions' => 'Pelanggan sesi',
        'Unique agents' => 'ejen unik',
        'Unique customers' => 'pelanggan unik',
        'Kill all sessions' => 'Bunuh semua sesi',
        'Kill this session' => 'Bunuh sesi ini',
        'Session' => 'sesi',
        'Kill' => 'Bunuh',
        'Detail View for SessionID' => 'Lihat Detail ID Sesi',

        # Template: AdminSignature
        'Signature Management' => 'Pengurusan tandatangan',
        'Add signature' => 'Tambah tandatangan',
        'Add Signature' => 'Tambah Tandatangan',
        'Edit Signature' => 'Edit Tandatangan',
        'Example signature' => 'tandatangan contoh',

        # Template: AdminState
        'State Management' => 'Pengurusan Keadaan',
        'Add state' => 'Tambah keadaan',
        'Please also update the states in SysConfig where needed.' => 'Sila juga mengemaskini keadaan dalam SysConfig mana diperlukan',
        'Add State' => 'Tambah keadaan',
        'Edit State' => 'Edit keadaan',
        'State type' => 'Jenis Keadaan',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Navigate by searching in %s settings' => 'Navigasi dengan mencari dalam tetapan %s',
        'Navigate by selecting config groups' => 'Navigasi mengikut memilih kumpulan config',
        'Download all system config changes' => 'Muat turun semua perubahan config sistem',
        'Export settings' => 'eksport tetapan',
        'Load SysConfig settings from file' => 'SysConfig tetapan beban dari fail',
        'Import settings' => 'import tetapan',
        'Import Settings' => 'import tetapan',
        'Please enter a search term to look for settings.' => 'Sila masukkan istilah carian untuk mencari tetapan.',
        'Subgroup' => 'subkumpulan',
        'Elements' => 'Elemen',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Edit Tetapan Config',
        'This config item is only available in a higher config level!' =>
            'Item ini config adalah hanya terdapat dalam config tahap yang lebih tinggi!',
        'Reset this setting' => 'Reset tetapan ini',
        'Error: this file could not be found.' => 'Ralat: fail ini tidak dapat ditemui.',
        'Error: this directory could not be found.' => 'Ralat: direktori ini tidak dapat ditemui.',
        'Error: an invalid value was entered.' => 'Ralat: nilai tidak sah telah dimasukkan.',
        'Content' => 'kandungan',
        'Remove this entry' => 'Buang lema ini',
        'Add entry' => 'Tambah entri',
        'Remove entry' => 'Buang kemasukan',
        'Add new entry' => 'Tambah kemasukan baru',
        'Delete this entry' => 'Padam entri ini',
        'Create new entry' => 'Buat kemasukan baru',
        'New group' => 'kumpulan baru',
        'Group ro' => 'Kumpulan ro',
        'Readonly group' => 'hanya untuk dibaca kumpulan',
        'New group ro' => 'baru kumpulan ro',
        'Loader' => 'pemuat',
        'File to load for this frontend module' => 'Fail untuk memuatkan modul frontend ini',
        'New Loader File' => 'baru pemuat Fail',
        'NavBarName' => 'NamaBarNav',
        'NavBar' => 'BarNav',
        'LinkOption' => 'PautanPilihan',
        'Block' => 'Halang',
        'AccessKey' => 'KunciKebenaran',
        'Add NavBar entry' => 'Tambah entri BarNav',
        'Year' => 'Tahun',
        'Month' => 'Bulan',
        'Day' => 'Hari',
        'Invalid year' => 'tahun tidak sah',
        'Invalid month' => 'bulan tidak sah',
        'Invalid day' => 'hari tidak sah',
        'Show more' => '',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Sistem E-mel Alamat Pengurusan',
        'Add system address' => 'Tambah alamat sistem',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Semua e-mel masuk dengan alamat ini Untuk atau Cc akan dihantar ke barisan yang dipilih.',
        'Email address' => 'alamat e-mel',
        'Display name' => 'Paparkan nama',
        'Add System Email Address' => 'Tambah Sistem Alamat E-mel',
        'Edit System Email Address' => 'Edit Alamat E-mel System',
        'The display name and email address will be shown on mail you send.' =>
            'Nama paparan dan alamat e-mel akan ditunjukkan di atas email yang anda hantar.',

        # Template: AdminTemplate
        'Manage Templates' => '',
        'Add template' => '',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '',
        'Don\'t forget to add new templates to queues.' => '',
        'Add Template' => '',
        'Edit Template' => '',
        'Template' => '',
        'Create type templates only supports this smart tags' => '',
        'Example template' => '',
        'The current ticket state is' => 'Keadaan tiket semasa',
        'Your email address is' => 'Alamat e-mel anda adalah',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => '',
        'Filter for Attachments' => 'Penapis lampiran',
        'Change Template Relations for Attachment' => '',
        'Change Attachment Relations for Template' => '',
        'Toggle active for all' => 'Togol aktif untuk semua',
        'Link %s to selected %s' => 'Pautan %s terpilih %s',

        # Template: AdminType
        'Type Management' => 'Pengurusan jenis',
        'Add ticket type' => 'Tambah jenis tiket',
        'Add Type' => 'Tambah Jenis',
        'Edit Type' => 'Edit Jenis',

        # Template: AdminUser
        'Add agent' => 'Tambah ejen',
        'Agents will be needed to handle tickets.' => 'Ejen akan diperlukan untuk mengendalikan tiket.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Jangan lupa untuk menambah ejen baru kepada kumpulan dan / atau peranan!',
        'Please enter a search term to look for agents.' => 'Sila masukkan istilah carian untuk mencari ejen.',
        'Last login' => 'log masuk terakhir',
        'Switch to agent' => 'Beralih kepada ejen',
        'Add Agent' => 'Tambah Agen',
        'Edit Agent' => 'Edit Agen',
        'Firstname' => 'Nama Pertama',
        'Lastname' => 'Nama Akhir',
        'Will be auto-generated if left empty.' => '',
        'Start' => 'mula',
        'End' => 'Tamat',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Mengurus Perhubungan Kumpulan-Ejen',
        'Change Group Relations for Agent' => 'Tukar Kumpulan Perhubungan untuk Ejen',
        'Change Agent Relations for Group' => 'Tukar Perhubungan Agen untuk Kumpulan',
        'note' => 'nota',
        'Permissions to add notes to tickets in this group/queue.' => 'Kebenaran untuk menambah nota untuk tiket dalam kumpulan ini / beratur.',
        'owner' => 'pemilik',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Kebenaran untuk menukar pemilik tiket dalam kumpulan ini / beratur.',

        # Template: AgentBook
        'Address Book' => 'Buku Alamat',
        'Search for a customer' => 'Cari pelanggan',
        'Add email address %s to the To field' => 'Tambah alamat e-mel %s ke bidang Kepada',
        'Add email address %s to the Cc field' => 'Tambah alamat e-mel %s ke bidang Cc',
        'Add email address %s to the Bcc field' => 'Tambah alamat e-mel %s ke bidang Bcc',
        'Apply' => 'Mohon',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'ID Pelanggan',
        'Customer User' => '',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'kemasukan disalin',
        'This address already exists on the address list.' => 'Alamat ini sudah pun wujud pada senarai alamat',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '',

        # Template: AgentDashboard
        'Dashboard' => 'Dashboard',

        # Template: AgentDashboardCalendarOverview
        'in' => 'dalam',

        # Template: AgentDashboardCommon
        'Available Columns' => '',
        'Visible Columns (order by drag & drop)' => '',

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => '',
        'Phone ticket' => '',
        'Email ticket' => '',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'New phone ticket from %s' => '',
        'New email ticket to %s' => '',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s kini boleh didapati!',
        'Please update now.' => 'Sila kemas kini sekarang.',
        'Release Note' => 'Lepaskan Nota',
        'Level' => 'tahap',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Dipos %s lalu.',

        # Template: AgentDashboardStats
        'The content of this statistic is being prepared for you, please be patient.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Tiket dikunci saya',
        'My watched tickets' => 'Tiket menonton saya',
        'My responsibilities' => 'saya tanggungjawab',
        'Tickets in My Queues' => 'Tiket dalam barisan saya',
        'Service Time' => 'Masa Servis',
        'Remove active filters for this widget.' => '',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => '',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Tiket telah dikunci',
        'Undo & close window' => 'Undo & menutup tetingkap',

        # Template: AgentInfo
        'Info' => 'Info',
        'To accept some news, a license or some changes.' => 'Untuk menerima beberapa berita, lesen atau beberapa perubahan.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Objek pautan: %s',
        'go to link delete screen' => 'pergi untuk menghubungkan skrin padam',
        'Select Target Object' => 'Pilih Objek Sasaran',
        'Link Object' => 'Objek pautan',
        'with' => 'dengan',
        'Unlink Object: %s' => 'Nyahpaut Objek: %s',
        'go to link add screen' => 'pergi untuk menghubungkan skrin menambah',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Edit pilihan anda',

        # Template: AgentSpelling
        'Spell Checker' => 'Penyemak Ejaan',
        'spelling error(s)' => 'kesalahan ejaan',
        'Apply these changes' => 'Memohon perubahan ini',

        # Template: AgentStatsDelete
        'Delete stat' => 'Padam stat',
        'Stat#' => 'Nombor Statistik.',
        'Do you really want to delete this stat?' => 'Adakah anda benar-benar mahu untuk memadam stat ini?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'langkah %s',
        'General Specifications' => 'Spesifikasi Am',
        'Select the element that will be used at the X-axis' => 'Pilih elemen yang akan digunakan pada paksi-X',
        'Select the elements for the value series' => 'Pilih unsur-unsur untuk siri nilai',
        'Select the restrictions to characterize the stat' => 'Pilih sekatan untuk mencirikan stat',
        'Here you can make restrictions to your stat.' => 'Di sini anda boleh membuat sekatan untuk stat anda.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Jika anda membuang cangkuk di kotak semak "Tetap", ejen menjana stat yang boleh mengubah sifat-sifat unsur yang sama.',
        'Fixed' => 'tetap',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Sila pilih hanya satu elemen atau mematikan butang \'Tetap\'!',
        'Absolute Period' => 'Tempoh mutlak',
        'Between' => 'Between',
        'Relative Period' => 'Tempoh relatif',
        'The last' => 'yang terakhir',
        'Finish' => 'selesai',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'kebenaran',
        'You can select one or more groups to define access for different agents.' =>
            'Anda boleh memilih satu atau lebih kumpulan untuk menentukan akses untuk ejen yang berbeza.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Sesetengah format hasil dilumpuhkan kerana sekurang-kurangnya satu pakej diperlukan tidak dipasang.',
        'Please contact your administrator.' => 'Sila hubungi pentadbir anda.',
        'Graph size' => 'Size graf',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Jika anda menggunakan graf sebagai format output, anda perlu untuk memilih sekurang-kurangnya satu saiz graf.',
        'Sum rows' => 'Jumlah baris',
        'Sum columns' => 'Jumlah lajur',
        'Use cache' => 'Guna cache',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'Kebanyakan statistik boleh cache. Ini akan mempercepatkan pembentangan stat ini.',
        'Show as dashboard widget' => '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '',
        'Please note' => '',
        'Enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'Agents will not be able to change absolute time settings for statistics dashboard widgets.' =>
            '',
        'IE8 doesn\'t support statistics dashboard widgets.' => '',
        'If set to invalid end users can not generate the stat.' => 'Jika ditetapkan ke tidak sah, pengguna tidak boleh menjana stat',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Sini anda boleh menentukan siri nilai.',
        'You have the possibility to select one or two elements.' => 'Anda mempunyai peluang untuk memilih satu atau dua elemen.',
        'Then you can select the attributes of elements.' => 'Kemudian anda boleh memilih sifat-sifat unsur-unsur.',
        'Each attribute will be shown as single value series.' => 'Setiap atribut akan ditunjukkan sebagai satu siri nilai tunggal.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Jika anda tidak memilih mana-mana sifat yang semua sifat-sifat unsur akan digunakan jika anda menjana stat, serta ciri-ciri baru yang telah ditambah sejak konfigurasi terakhir.',
        'Scale' => 'Skala',
        'minimal' => 'minimum',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Sila ingat, bahawa skala untuk siri nilai untuk menjadi lebih besar daripada skala untuk X-paksi (contohnya X-Paksi => Bulan, ValueSeries => Tahun).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Sini anda boleh menentukan paksi-x. Anda boleh pilih satu elemen melalui butang radio.',
        'maximal period' => 'tempoh maksimum',
        'minimal scale' => 'skala minimum',

        # Template: AgentStatsImport
        'Import Stat' => 'Import Statistik',
        'File is not a Stats config' => 'Fail bukan konfig statistik',
        'No File selected' => 'Tiada fail yang dipilih',

        # Template: AgentStatsOverview
        'Stats' => 'Statistik',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Tiada unsur yang dipilih.',

        # Template: AgentStatsView
        'Export config' => 'Export konfig',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Dengan medan input dan pilih anda boleh mempengaruhi format dan kandungan statistik.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Secara tepatnya, bidang dan format yang anda boleh pengaruhi ditakrifkan oleh pentadir statistik.',
        'Stat Details' => 'Butiran Statistik',
        'Format' => 'Format',
        'Graphsize' => 'SizeGraf',
        'Cache' => 'Cache',
        'Exchange Axis' => 'Paksi Pertukaran',

        # Template: AgentStatsViewSettings
        'Configurable params of static stat' => 'Parameter statistik statik yang boleh dikonfigurasi.',
        'No element selected.' => 'Tiada unsur yang dipilih.',
        'maximal period from' => 'tempoh maksimum daripada',
        'to' => 'kepada',
        'not changable for dashboard statistics' => '',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Tukar Teks Percuma Tiket.',
        'Change Owner of Ticket' => 'Tukar Pemilik Tiket',
        'Close Ticket' => 'Tutup Tiket',
        'Add Note to Ticket' => 'Tambah Nota Tiket.',
        'Set Pending' => 'Tetapkan Penangguhan.',
        'Change Priority of Ticket' => 'Ubah Keutamaan Tiket',
        'Change Responsible of Ticket' => 'Ubah Tanggungjawab Tiket',
        'All fields marked with an asterisk (*) are mandatory.' => '',
        'Service invalid.' => 'Perkhidmatan tidak sah.',
        'New Owner' => 'Pemilik baru',
        'Please set a new owner!' => 'Sila tetapkan pemilik baru!',
        'Previous Owner' => 'Pemilik sebelumnya',
        'Inform Agent' => 'Memaklumkan Agen.',
        'Optional' => 'Pilihan',
        'Inform involved Agents' => 'Beritahu Ejen terlibat',
        'Spell check' => 'semak ejaan',
        'Note type' => 'Jenis Nota',
        'Next state' => 'Status Seterusnya',
        'Date invalid!' => 'Tarikh tidak sah!',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Bounce Tiket.',
        'Bounce to' => 'Bounce kepada',
        'You need a email address.' => 'Anda perlu alamat e-mel.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Perlu alamat emel yang sah atau jangan menggunakan alamat emel tempatan.',
        'Next ticket state' => 'Status tiket seterusnya',
        'Inform sender' => 'Memaklumkan penghantar',
        'Send mail' => 'Hantar mel!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Tindakan Pukal Tiket',
        'Send Email' => 'Hantar Emel',
        'Merge to' => 'Gabung dengan',
        'Invalid ticket identifier!' => 'Pengecam tiket tidak sah!',
        'Merge to oldest' => 'Bergabung kepada yang terlama',
        'Link together' => 'Cantum bersama',
        'Link to parent' => 'Cantum dengan yang paling asal',
        'Unlock tickets' => 'Buka tiket',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Karang jawapan untuk tiket',
        'Please include at least one recipient' => 'Sila sertakan sekurang-kurangnya satu penerima',
        'Remove Ticket Customer' => 'Buang Pelanggan Tiket',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Sila keluarkan entri ini dan masukkan satu yang baru dengan nilai yang betul.',
        'Remove Cc' => 'Buang Cc',
        'Remove Bcc' => 'Buang Bcc',
        'Address book' => 'Buku Alamat',
        'Pending Date' => 'Tarikh penangguhan',
        'for pending* states' => 'Untuk status tertangguh',
        'Date Invalid!' => 'Tarikh tidak sah!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Ubah pelanggan tiker',
        'Customer user' => 'Pengguna pelanggan',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Buat Tiket Email Baru.',
        'From queue' => 'Dari barisan.',
        'To customer user' => '',
        'Please include at least one customer user for the ticket.' => '',
        'Select this customer as the main customer.' => '',
        'Remove Ticket Customer User' => '',
        'Get all' => 'Dapatkan semua.',
        'Text Template' => '',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Mengemukakan tiket.:  %s - %s',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Sejarah untuk',
        'History Content' => 'Kandungan sejarah',
        'Zoom view' => 'Pandangan dibesarkan',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Tiket bergabung',
        'You need to use a ticket number!' => 'Anda perlu menggunakan nombor tiket!',
        'A valid ticket number is required.' => 'Nombor tiket yang sah diperlukan.',
        'Need a valid email address.' => 'Memerlukan alamat emel yang sah.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Pindah tiket',
        'New Queue' => 'Barisan baru',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Pilih semua',
        'No ticket data found.' => 'Tiada data tiket ditemui.',
        'First Response Time' => 'Masa respon pertama',
        'Update Time' => 'Masa Kemas Kini',
        'Solution Time' => 'Masa Penyelasaian',
        'Move ticket to a different queue' => 'Pindah tiket ke barisan baru',
        'Change queue' => 'Ubah barisan',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Ubah opsyen pencarian',
        'Remove active filters for this screen.' => '',
        'Tickets per page' => 'Tiket setiap halaman',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Buat Tiket Telefon Baru.',
        'Please include at least one customer for the ticket.' => 'Sila masukkan sekurang-kurangnya satu pelanggan bagi tiket.',
        'To queue' => 'Kepada barisan',

        # Template: AgentTicketPhoneCommon

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Emel teks paparan mudah',
        'Plain' => 'Biasa',
        'Download this email' => 'Muat turun emel ini',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Maklumat-tiket',
        'Accounted time' => 'Masa yang diperuntukan',
        'Linked-Object' => 'Objek yang dihubungkan',
        'by' => 'oleh',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Cari templat',
        'Create Template' => 'Buat templat',
        'Create New' => 'Buat baru',
        'Profile link' => 'Pautan profil.',
        'Save changes in template' => 'Simpan perubahan dalam templat.',
        'Add another attribute' => 'Tambah atribut lain',
        'Output' => 'Output',
        'Fulltext' => 'Teks penuh',
        'Remove' => 'Buang',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Log masuk pengguna pelanggan',
        'Created in Queue' => 'Dibuat dalam barisan',
        'Lock state' => 'Kunci status',
        'Watcher' => 'Pemerhati',
        'Article Create Time (before/after)' => 'Masa Artikel Dibuat (sebelum/selepas)',
        'Article Create Time (between)' => 'Masa Artikel Dibuat (diantara)',
        'Ticket Create Time (before/after)' => 'Masa Tiket Dibuat (sebelum/selepas)',
        'Ticket Create Time (between)' => 'Masa Tiket Dibuat (diantara)',
        'Ticket Change Time (before/after)' => 'Masa Tiket Diubah (sebelum/selepas)',
        'Ticket Change Time (between)' => 'Masa Tiket Diubah (diantara)',
        'Ticket Close Time (before/after)' => 'Masa Tiket Ditutup (sebelum/selepas)',
        'Ticket Close Time (between)' => 'Masa Tiket Ditutup (diantara)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Carian Arkib',
        'Run search' => 'Jalankan carian',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Tapisan artikel',
        'Article Type' => 'Jenis artikel',
        'Sender Type' => 'Jenis penghantar',
        'Save filter settings as default' => 'Simpan tetapan penapis sebagai piawai.',
        'Archive' => '',
        'This ticket is archived.' => '',
        'Locked' => 'Terkunci',
        'Linked Objects' => 'Objek yang Dihubungkan',
        'Article(s)' => 'Artikel',
        'Change Queue' => 'Ubah Barisan',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Add Filter' => 'Tambah Tapisan',
        'Set' => 'Tetapkan',
        'Reset Filter' => 'Tetapkan semula penapis',
        'Show one article' => 'Tunjukkan satu artikel',
        'Show all articles' => 'Tunjukkan kesemua artikel',
        'Unread articles' => 'Artikel yang belum dibaca',
        'No.' => 'Tidak',
        'Important' => '',
        'Unread Article!' => 'Artikel belum dibaca!',
        'Incoming message' => 'Mesej masuk',
        'Outgoing message' => 'Mesej keluar',
        'Internal message' => 'Mesej dalaman',
        'Resize' => 'Mengubah saiz',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'Buka kandungan yang disekat.',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Menjejaki kembali',

        # Template: CustomerFooter
        'Powered by' => 'Dikuasakan oleh',
        'One or more errors occurred!' => 'Satu atau lebih kesilapan berlaku!',
        'Close this dialog' => 'Tutup dialog ini',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Tidak boleh membuka tetingkap pop timbul. Sila lumpuhkan sebarang penyekat pop timbul untuk aplikasi ini.',
        'There are currently no elements available to select from.' => '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript idak disediakan',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Untuk menikmati OTRS, anda perlu mengaktifkah JavaScript di dalam browser anda.',
        'Browser Warning' => 'Amaran Browser',
        'The browser you are using is too old.' => 'Browser yang anda gunakan adalah terlalu lama.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS dijalankan dengan senarai browser yang besar. Sila naik taraf kepada salah satu darinya.',
        'Please see the documentation or ask your admin for further information.' =>
            'Sila lihat dokumentasi atau menanya kepada admin anda untuk maklumat lanjut.',
        'Login' => 'Log masuk',
        'User name' => 'Nama pengguna',
        'Your user name' => 'Nama pengguna anda',
        'Your password' => 'Kata kunci anda',
        'Forgot password?' => 'Lupa kata kunci?',
        'Log In' => 'Log masuk',
        'Not yet registered?' => 'Belum lagi mendaftar?',
        'Request new password' => 'Mohon kata kunci yang baru',
        'Your User Name' => 'Nama pengguna anda',
        'A new password will be sent to your email address.' => 'Kata kunci yang baru akan dihantar ke alamat emel anda.',
        'Create Account' => 'Buat akaun',
        'Please fill out this form to receive login credentials.' => 'Sila isi borang ini untuk menerima butiran log masuk.',
        'How we should address you' => 'Bagaimana harus kami memanggil anda?',
        'Your First Name' => 'Nama pertama anda',
        'Your Last Name' => 'Nama akhir anda',
        'Your email address (this will become your username)' => 'Alamat emel anda (ini akan menjadi nama pengguna anda)',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Edit pilihan peribadi',
        'Logout %s' => '%s Log keluar',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Perjanjian tahap perkhidmatan.',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Selamat datang!',
        'Please click the button below to create your first ticket.' => 'Sila tekan butang di bawah untuk membuat tiket pertama anda.',
        'Create your first ticket' => 'Buat tiket pertama anda',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Cetak Tiket',
        'Ticket Dynamic Fields' => '',

        # Template: CustomerTicketProcess

        # Template: CustomerTicketProcessNavigationBar

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'contoj: 10*5155 atau 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Carian teks penuh dalam tiket (contoh: "John*n" atau "Will*")',
        'Carbon Copy' => 'Salinan Karbon',
        'Types' => 'Jenis',
        'Time restrictions' => 'Kekangan masa',
        'No time settings' => 'Tiada tetapan masa',
        'Only tickets created' => 'Hanya tiket yang dibuat',
        'Only tickets created between' => 'Hanya tiket yang dibuat diantara',
        'Ticket archive system' => 'Sistem arkib tiket',
        'Save search as template?' => 'Simpan carian sebagai templat?',
        'Save as Template?' => 'Simpan sebagai templat?',
        'Save as Template' => 'Simpan sebagai templat',
        'Template Name' => 'Nama templat',
        'Pick a profile name' => 'Pilih nama profil',
        'Output to' => 'Output kepada',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'daripada',
        'Page' => 'Halaman',
        'Search Results for' => 'Hasil Carian untuk',

        # Template: CustomerTicketZoom
        'Expand article' => 'Kembangkan artikel',
        'Information' => '',
        'Next Steps' => '',
        'Reply' => 'Balas',

        # Template: CustomerWarning

        # Template: DashboardEventsTicketCalendar
        'Sunday' => 'Ahad',
        'Monday' => 'Isnin',
        'Tuesday' => 'Selasa',
        'Wednesday' => 'Rabu',
        'Thursday' => 'Khamis',
        'Friday' => 'Jumaat',
        'Saturday' => 'Sabtu',
        'Su' => 'Ahd',
        'Mo' => 'Isn',
        'Tu' => 'Sel',
        'We' => 'Rbu',
        'Th' => 'Kha',
        'Fr' => 'Jum',
        'Sa' => 'Sab',
        'Event Information' => '',
        'Ticket fields' => '',
        'Dynamic fields' => '',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Tarikh tidak sah (memerlukan tarikh di hadapan)!',
        'Previous' => 'Sebelum',
        'Open date selection' => 'Buka pilihan tarikh',

        # Template: Error
        'Oops! An Error occurred.' => 'Oops! Ada kesilapan berlaku.',
        'Error Message' => 'Mesej kesilapan',
        'You can' => 'Anda boleh',
        'Send a bugreport' => 'Hantar laporan bug',
        'go back to the previous page' => 'kembali ke halaman sebelum',
        'Error Details' => 'Butiran kesilapan',

        # Template: Footer
        'Top of page' => 'Bahagian atas halaman',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Jika anda meninggalkan halaman ini sekarang, kesemua tetingkap timbul juga akan ditutup!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Tetingkap timbul untuk skrin ini sudah dibuka. Adakah anda mahu menutupnya dan membuka yang ini?',
        'Please enter at least one search value or * to find anything.' =>
            'Sila masukkan sekurang-kurangnya satu nilai carian atau * untuk mencari apa saja.',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'You are logged in as' => 'Anda menlog masuk sebagai',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript tidak disediakan',
        'Database Settings' => 'Datenbankeinstellungen',
        'General Specifications and Mail Settings' => 'Spesifikasi Am dan Tetapan Mail',
        'Welcome to %s' => 'Selamat datang ke %s',
        'Web site' => 'Laman web',
        'Mail check successful.' => 'Semakan mel berjaya',
        'Error in the mail settings. Please correct and try again.' => 'Kesilapan dalam konfigurasi e-mel. Sila betulkan dan cuba lagi.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Konfigurasi penghantaran mel',
        'Outbound mail type' => 'Jenis e-mel keluar',
        'Select outbound mail type.' => 'Pilih jenis mel keluar',
        'Outbound mail port' => 'Port emel keluar',
        'Select outbound mail port.' => 'Pilih port emel keluar',
        'SMTP host' => 'Hos SMTP',
        'SMTP host.' => 'Hos SMTP.',
        'SMTP authentication' => 'Pengesahan SMTP',
        'Does your SMTP host need authentication?' => 'Adakah hos SMTP anda perlukan pengesahan?',
        'SMTP auth user' => 'pengguna SMTP yang disahkan',
        'Username for SMTP auth.' => 'Nama pengguna untuk pengesahan SMTP',
        'SMTP auth password' => 'Kata kunci pengesahan SMTP',
        'Password for SMTP auth.' => 'Kata kunci untuk pegesahan SMTP.',
        'Configure Inbound Mail' => 'Konfigurasi mel masuk',
        'Inbound mail type' => 'Jenis mel masuk',
        'Select inbound mail type.' => 'Pilih jenis mel masuk',
        'Inbound mail host' => 'Hos mel masuk',
        'Inbound mail host.' => 'Hos mel masuk.',
        'Inbound mail user' => 'Pengguna mel masuk',
        'User for inbound mail.' => 'Pengguna untuk mel masuk',
        'Inbound mail password' => 'Kata kunci mel masuk',
        'Password for inbound mail.' => 'Kata kunci untuk mel masuk.',
        'Result of mail configuration check' => 'Hasil untuk semakan konfigurasi mel',
        'Check mail configuration' => 'Semak konfigurasi mel',
        'Skip this step' => 'Langkau langkah ini',

        # Template: InstallerDBResult
        'Database setup successful!' => 'Penubuhan pangkalan data berjaya!',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a new database for OTRS' => '',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'Database name' => '',
        'Check database settings' => 'Semak tetapan database',
        'Result of database check' => 'Hasil semakan database',
        'OK' => '',
        'Database check successful.' => 'Semakan database berjaya.',
        'Database User' => '',
        'New' => 'Baru',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Seorang pengguna pangkalan data baru dengan keistimewaan yang terhad dicipta pada sistem OTRS ini.',
        'Repeat Password' => '',
        'Generated password' => '',

        # Template: InstallerDBmysql
        'Passwords do not match' => '',

        # Template: InstallerDBoracle
        'SID' => '',
        'Port' => '',

        # Template: InstallerDBpostgresql

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Untuk menggunakan OTRS, mesti masukkan baris berikut sebagai root pada baris arahan (terminal / shell).',
        'Restart your webserver' => 'Mulakan semula webserver anda.',
        'After doing so your OTRS is up and running.' => 'Selepas berbuat demikian OTRS anda akan bersedia untuk dijalankan',
        'Start page' => 'Halaman mula',
        'Your OTRS Team' => 'Team OTRS anda',

        # Template: InstallerLicense
        'Accept license' => 'Menerima lesen',
        'Don\'t accept license' => 'Jangan menerima lesen',

        # Template: InstallerLicenseText

        # Template: InstallerSystem
        'SystemID' => 'IDSistem',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Pengecam sistem. Setiap nombor tiket dan setiap ID sesi HTTP, dan nombor.',
        'System FQDN' => 'Sistem FQDN',
        'Fully qualified domain name of your system.' => 'Nama domain sistem anda yang layak sepenuhnya.',
        'AdminEmail' => 'Emel Admin',
        'Email address of the system administrator.' => 'Alamat e-mel pentadbir sistem.',
        'Organization' => 'Organisasi',
        'Log' => 'Log',
        'LogModule' => 'log modul',
        'Log backend to use.' => 'Log backend untuk digunakan.',
        'LogFile' => 'Log Fail',
        'Webfrontend' => 'Webfrontend',
        'Default language' => 'Bahasa asal',
        'Default language.' => 'Bahasa asal.',
        'CheckMXRecord' => 'Semak MX-Records',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Alamat E-mel yang dinyatakan oleh pengguna diperiksa terhadap rekod MX dalam DNS. Gunakan pilihan ini jika DNS anda adalah lambat atau tidak boleh menyelesaikan alamat awam.',

        # Template: LinkObject
        'Object#' => 'Objek#',
        'Add links' => 'Tambah pautan',
        'Delete links' => 'Padam pautan',

        # Template: Login
        'Lost your password?' => 'Hilang kata kunci anda?',
        'Request New Password' => 'Mohon Kata Kunci Baru',
        'Back to login' => 'Kembali ke log masuk',

        # Template: Motd
        'Message of the Day' => 'Mesej untuk hari ini',

        # Template: NoPermission
        'Insufficient Rights' => 'Hak tidak mencukupi',
        'Back to the previous page' => 'Kembali ke halaman sebelumnya',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'Pamer halaman pertama',
        'Show previous pages' => 'Pamer halaman sebelumnya',
        'Show page %s' => 'Pamer halaman %s',
        'Show next pages' => 'Pamer halaman seterusnya',
        'Show last page' => 'Pamer halaman terakhir',

        # Template: PictureUpload
        'Need FormID!' => 'Perlu IDForm',
        'No file found!' => 'Tiada fail ditemui!',
        'The file is not an image that can be shown inline!' => 'Fail bukan imej yang boleh ditunjukkan sebaris!',

        # Template: PrintFooter

        # Template: PrintHeader
        'printed by' => 'dicetak oleh',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'Halaman percubaan OTRS',
        'Welcome %s' => 'Selamat Datang %s',
        'Counter' => 'Kaunter',

        # Template: Warning
        'Go back to the previous page' => 'Kembali ke halaman sebelumnya',

        # SysConfig
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Modul ACL yang membolehkan penutupan tiket induk hanya jika kesemua anaknya telah ditutup ("Status" menunjukkan status yang tidak disediakan untuk tiket induk sehingga semua anak tiket ditutup)',
        'Access Control Lists (ACL)' => '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Mengaktifkan mekanisma berkelip untuk barisan yang mengandungi tiket yang terlama.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Mengaktifkan ciri kata kunci yang hilang untuk ejen, di dalam interface ejen',
        'Activates lost password feature for customers.' => 'Mengaktifkan ciri kata kunci yang hilang untuk pelanggan.',
        'Activates support for customer groups.' => 'Mengaktifkan sokongan untuk kumpulan pelanggan.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Mengaktifkan tapisan artikel dalam paparan besar untuk menyatakan artikel yang perlu dipaparkan.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Mengaktifkan tema yang disediajan di dalam sistem. Nilai 1 bermaksud aktif, 0 bermaksud tidak aktif.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Mengaktifkan pencarian sistem arkib tiket di dalam interface pelanggan.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Mengaktifkan sistem arkib tiket untuk mempunyai sistem yang lebih laju dengan memindahkan sebahagian tiket keluar daripada skop harian. Untuk mencari tiket ini, bendera arkib mestilah diaktifkan pada carian tiket.',
        'Activates time accounting.' => 'Mengaktifkan perakaunan masa.',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Tambah akhiran dengan tahun sebenar dan bulan untuk fail log OTRS. Satu fail log bagi setiap bulan akan diwujudkan.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Tambah satu percutian hari masa untuk menunjukkan kalendar. Sila menggunakan corak digit tunggal bagi nombor 1-9 (bukannya 01-09).',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Tambah satu hari masa percutian. Sila menggunakan corak digit tunggal bagi nombor 1-9 (bukannya 01-09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Menambah hari bercuti tetap untuk menunjukkan kalendar. Sila menggunakan corak digit tunggal bagi nombor 1-9 (bukannya 01-09).',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Menambah hari bercuti tetap. Sila menggunakan corak digit tunggal bagi nombor 1-9 (bukannya 01-09).',
        'Agent Notifications' => 'Notifikasi Ejen',
        'Agent interface article notification module to check PGP.' => 'Interface artikel pemberitahuan modul ejen untuk memeriksa PGP',
        'Agent interface article notification module to check S/MIME.' =>
            'Interface artikel pemberitahuan modul ejen untuk memeriksa S/MIME.',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Interface modul ejen untuk mengakses pencarian teks penuh menggunakan bar navigasi.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Interface modul ejen untuk mengakses profil pencarian menggunakan bar navigasi.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Interface modul ejen untuk menyemak emel masuk di dalam Paparan-Besar-Tiket jika kunci S/MIME tersedia dan betul.',
        'Agent interface notification module to check the used charset.' =>
            'Interface modul notifikasi ejen untuk menyemak set aksara yang digunakan.',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Interface modul notifikasi ejen untuk melihat nombor tiket yang dipertanggungjawabkan kepada ejen.',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Interface modul notifikasi ejen untuk melihat nombor tiket yang diperhati.',
        'Agents <-> Groups' => 'Ejen <-> Kumpulan',
        'Agents <-> Roles' => 'Ejen <-> Peranan',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            'Membolehkan penambahan nota di dalam skrin tiket tertutup di dalam interface ejen.',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            'Membolehkan penambahan nota di dalam skrin teks bebas tiket di dalam interface ejen.',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            'Membolehkan penambahan nota di dalam skrin nota tiket di dalam interface ejen.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Membolehkan penambahan nota di dalam skrin penangguhan tiket untuk ticket yang diperbesarkan di dalam interface ejen.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Membolehkan penambahan nota di dalam skrin keutamaan tiket untuk tiket yag diperbesarkan di dalam interface ejen.',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            'Membolehkan penambahan nota di dalam skrin tanggungjawab tiket di dalam interface ejen.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Membolehkan ejen untuk menukar paksi sesebuah status jika ia menghasilkan satu.',
        'Allows agents to generate individual-related stats.' => 'Membolehkan ejen untuk menghasilkan status pautan individu.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Membolehkan memilih antara menunjukkan lampiran tiket dalam pelayar (sebaris) atau hanya membuat mereka dimuat turun (lampiran).',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Membolehkan memilih status yang diwujudkan seterusnya untuk tiket pelanggan di dalam interface pelanggan.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Membolehkan pelanggan untuk menukar keutamaan tiket di dalam interface pelanggan.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Membolehkan pelanggan untuk menetapkan tiket SLA di dalam interface pelanggan.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Membolehkan pelanggan untuk menetapkan keutamaan tiket di dalam interface pelanggan.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Memblehkan pelanggan untuk menetapkan barisan tiket di dalam interface pelanggan. Jika ini disetkan kepada \'Tidak\', BarisanAsal perlu di konfigur.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Membolehkan pelanggan untuk menetapkan perkhidmatan tiket di dalam interface Allows choosing the next compose state for customer tickets in the customer interface pelanggan.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            'Membolehkan perkhidmatan asal dipilih juga untuk pelanggan yang tidak wujud.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Membolehkan jenis tiket yang baru didefinasikan (jika fungsi jenis tiket diaktifkan).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Membolehkan perkhidmatan didefinisi dan SLA untuk tiket (contoh: emel, desktop, rangkaian, ...), dan atribut maklum balas untuk SLAs (jika perkhidmatan tiket/fungsi SLA diaktifkan).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Membolehkan keadaan carian diperluaskan di dalam pencarian tiket dalam interface pelanggan. Dengan fungsi ini, anda boleh tetapkan carian menggunakan kondisi seperti "(key1&&key2)" atau "(key1||key2)".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Membolehkan mempunyai format tiket gambaran sederhana (CustomerInfo => 1 - juga menunjukkan maklumat pelanggan).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Membolehkan mempunyai format tiket gambaran kecil (CustomerInfo => 1 - juga menunjukkan maklumat pelanggan).',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Membolehkan untuk menetapkan status tiket baru di dalam skrin pindahan tiket di dalam interface ejen.',
        'ArticleTree' => '',
        'Attachments <-> Templates' => '',
        'Auto Responses <-> Queues' => 'Tindak Balas Auto <-> Barisan',
        'Automated line break in text messages after x number of chars.' =>
            'Memecahkan garis Automatik dalam mesej teks selepas beberapa x aksara.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Secara automatik mengunci dan menetapkan pemilik kepada Ejen semasa, selepas memilih untuk Tindakan Pukal.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'Secara automatik menetapkan pemilik tiket sebagai bertanggungjawab untuk ia (jika ciri tiket bertanggungjawab diaktifkan).',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Secara automatik menetapkan tanggungjawab sesebuah tiket (jika ia tidak ditetapkan lagi) selepas kemas kini pemilik pertama.',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => 'Kulit puih seimbang oleh Felix Niklas.',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Blok semua e-mel masuk yang tidak mempunyai nombor tiket yang sah tertakluk dengan Dari: @ example.com alamat.',
        'Builds an article index right after the article\'s creation.' =>
            'Membina indeks artikel sejurus selepas penciptaan artikel.',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'CMD contoh persediaan. Mengabaikan emel dimana CMD luaran kembali beberapa output dalam STDOUT (emel akan disalurkan kedalam STDIN daripada some.bin).',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Masa Cache dalam saat untuk pengesahan ejen dalam GenericInterface.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Masa Cache dalam saat untuk pengesahan pelanggan di GenericInterface.',
        'Cache time in seconds for the DB ACL backend.' => '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the SSL certificate attributes.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => 'Masa Cache dalam saat untuk backend web config perkhidmatan.',
        'Change password' => 'Ubah kata laluan',
        'Change queue!' => 'Ubah barisan',
        'Change the customer for this ticket' => 'Ubah pelanggan untuk tiket ini',
        'Change the free fields for this ticket' => 'Ubah medan bebas untuk tiket ini',
        'Change the priority for this ticket' => 'Ubah keutamaan untuk tiket ini',
        'Change the responsible person for this ticket' => 'Ubah orang yang bertanggungjawab untuk tiket ini',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Perubahan pemilik tiket kepada semua orang (bergunda untuk ASP). Kebiasaannya, hanya ejen yang mempunyai kebenaran rw di dalam barisan yang akan ditunjukkan.',
        'Checkbox' => 'Kotak petak',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Menyemak IDSistem di dalam pengesanan nombor tiket untuk susulan (guna "Tidak" jika IDSistem telah diubah selepas menggunakan sistem).',
        'Closed tickets of customer' => 'Tiket customer yang tertutup',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled. Note: no more columns are allowed and will be discarded.' =>
            '',
        'Comment for new history entries in the customer interface.' => 'Komen untuk kemasukan sejarah baru di dalam interface pelanggan.',
        'Company Status' => '',
        'Company Tickets' => 'Tiket Syarikat',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => '',
        'Configure your own log text for PGP.' => 'Konfigur teks log anda sendiri untuk PGP.',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            'Mengkonfigurasi tetapan lalai TicketDynmicField. "Nama" mentakrifkan bidang yang dinamik yang perlu digunakan, "Nilai" adalah data yang akan ditetapkan, dan "Acara" mentakrifkan pencetus acara. Sila semak manual pemaju (http://doc.otrs.org/), bab "Tiket Event Module".',
        'Controls if customers have the ability to sort their tickets.' =>
            'Kawalan jika pelanggan mempunyai keupayaan untuk mengatur tiket mereka.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Kawalan jika lebih daripada satu daripada kemasukan boleh ditetapkan dalam tiket telefon baru dalam interface ejen.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => 'Menukarkan mel HTML ke dalam mesej teks.',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Mewujudkan dan menguruskan Perjanjian Tahap Perkhidmatan (SLA).',
        'Create and manage agents.' => 'Mewujudkan dan menguruskan ejen.',
        'Create and manage attachments.' => 'Mewujudkan dan menguruskan lampiran.',
        'Create and manage customer users.' => '',
        'Create and manage customers.' => 'Mewujudkan dan menguruskan pelanggan.',
        'Create and manage dynamic fields.' => 'Mewujudkan dan menguruskan bidang dinamik.',
        'Create and manage event based notifications.' => 'Buat dan urus notifikasi berasaskan peristiwa.',
        'Create and manage groups.' => 'Mewujudkan dan menguruskan kumpulan.',
        'Create and manage queues.' => 'Mewujudkan dan menguruskan barisan.',
        'Create and manage responses that are automatically sent.' => 'Mewujudkan dan menguruskan tindak balas yang dihantar secara automatik.',
        'Create and manage roles.' => 'Mewujudkan dan menguruskan peranan.',
        'Create and manage salutations.' => 'Mewujudkan dan menguruskan penghormatan.',
        'Create and manage services.' => 'Mewujudkan dan menguruskan perkhidmatan.',
        'Create and manage signatures.' => 'Mewujudkan dan menguruskan tanda tangan.',
        'Create and manage templates.' => '',
        'Create and manage ticket priorities.' => 'Mewujudkan dan menguruskan keutamaan tiket.',
        'Create and manage ticket states.' => 'Mewujudkan dan menguruskan status tiket.',
        'Create and manage ticket types.' => 'Mewujudkan dan menguruskan jenis tiket.',
        'Create and manage web services.' => 'Mewujudkan dan menguruskan perkhidmatan web.',
        'Create new email ticket and send this out (outbound)' => 'Buat tiket e-mel baru dan menghantar ia keluar (keluar)',
        'Create new phone ticket (inbound)' => 'Buat tiket telefon baru (masuk).',
        'Create new process ticket' => '',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            'Teks direka untuk halaman yang ditunjukkan kepada pelanggan yang belum mempunyai tiket.',
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User <-> Groups' => '',
        'Customer User <-> Services' => '',
        'Customer User Administration' => '',
        'Customer Users' => '',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Item pelanggan (icon) yang menunjukkan tiket tertutup pelanggan ini sebagai blok info. Menetapkan CustomerUserLogin kepada carian 1 untuk tiket berdasarkan nama log masuk dan bukannya CustomerID.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Item pelanggan (icon) yang menunjukkan tiket terbuka pelanggan ini sebagai blok info. Menetapkan CustomerUserLogin kepada carian 1 untuk tiket berdasarkan nama log masuk dan bukannya CustomerID.',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Pelanggan <-> Kumpulan',
        'Data used to export the search result in CSV format.' => 'Data digunakan untuk mengeksport hasil carian dalam format CSV.',
        'Date / Time' => 'Tarikh / Masa',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Debugs set terjemahan. Jika ini diset kepada "Ya" berkaitan semua (teks) tanpa penterjemahan ditulis kepada STDERR. Ini boleh membantu apabila awak membuat fail penterjemahan baru. Melainkan, pilihan ini harus dikekalkan set kepada "Tidak".',
        'Default ACL values for ticket actions.' => 'Nilai asal ACL untuk tindakan tiket',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Data asal digunakan untuk sifat bagi skrin carian tiket. Contoh: TicketCreateTimePointFormat=tahun;TicketCreateTimePointStart=Terakhir;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Data asal digunakan untuk sifat bagi skrin carian tiket. Contoh: TicketCrateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default loop protection module.' => 'Modul perlindungan lingkaran asal.',
        'Default queue ID used by the system in the agent interface.' => 'Barisan ID asal yang digunakan sistem di dalam paparan ejen.',
        'Default skin for OTRS 3.0 interface.' => 'Kulit asal untuk paparan OTRS 3.0.',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            'Tiket ID asal digunakan oleh sistem di dalam paparan ejen.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Tiket ID asal digunakan oleh sistem di dalam paparan pengguna.',
        'Default value for NameX' => 'Nilai asal untuk NameX',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Mentakrif tapisan untuk output html untuk menambah pautan di sebalik takrifan yang berkait. Imej unsur membolehkan 2 jenis input. Sekaligus nama sesuatu imej (Contohnya faq.png). Dalam kes ini laluan imej OTRS akan digunakan. Kemungkinan kedua adalah untuk memasukkan pautan kepada imej.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the start day of the week for the date picker.' => 'Menetukan hari permulaan mingguan untuk pemilih tarikh.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Mentakrifkan item pelanggan, yang menjana ikon LinkedIn pada akhir blok info pelanggan.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Mentakrifkan item pelanggan, yang menjana ikon XING pada akhir blok info pelanggan.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Mentakrifkan item pelanggan, yang menjana ikon google pada akhir blok info pelanggan.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Mentakrifkan item pelanggan, yang menjana ikon peta google pada akhir blok info pelanggan.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Mentakrifkan senarai perkataan asal, yang diabaikan oleh pemeriksa ejaan.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Mentakrifkan tapisan untuk output html untuk menambah pautan di belakang nombor CVE. Imej unsur membolehkan dua jenis input. Sekaligus nama satu imej (contoh faq.png). Dalam kes ini laluan imej OTRS akan digunakan. Kemungkinan yang kedua adalah memasukkan pautan pada imej.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Mentakrifkan tapisan untuk output html untuk menambah pautan di belakang nombor MSBulletin. Imej unsur membolehkan dua jenis input. Sekaligus nama satu imej (contoh faq.png). Dalam kes ini laluan imej OTRS akan digunakan. Kemungkinan yang kedua adalah memasukkan pautan pada imej.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Mentakrifkan tapisan untuk output html untuk menambah pautan di belakang string yang ditakrifkan. Imej unsur membolehkan dua jenis input. Sekaligus nama satu imej (contoh faq.png). Dalam kes ini laluan imej OTRS akan digunakan. Kemungkinan yang kedua adalah memasukkan pautan pada imej.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Mentakrifkan tapisan untuk output html untuk menambah pautan di belakang nombor bugtraq. Imej unsur membolehkan dua jenis input. Sekaligus nama satu imej (contoh faq.png). Dalam kes ini laluan imej OTRS akan digunakan. Kemungkinan yang kedua adalah memasukkan pautan pada imej.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Mentakrifkan tapisan untuk memproses teks dalam artikel, dalam usaha untuk menyerlahkan kata kunci yang dipratentukan.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Mentakrifkan ungkapan biasa yang tidak termasuk sebarang alamat daripada menyemak syntax (jika "CheckEmailAddress" diset kepada "Ya"). Sila masukkan regex dalam bidang ini untuk alamat e-mel, yang tidak sah syntaxnya, tetapi diperlukan oleh sistem (contoh "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Mentakrifkan ungkapan biasa yang menapis semua alamat e-mel yang tidak patut digunakan dalam aplikasi.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Mentakrifkan modul yang berguna untuk memuatkan pilihan pengguna tertentu atau memaparkan berita.',
        'Defines all the X-headers that should be scanned.' => 'Mentakrifkan semua X-headers yang perlu diimbas.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            'Mentakrifkan semua bahasa yang disediakan pada applikasi. Sepasang Kunci/Kandungan berhubung paparan nama hujung-depan kepada bahasa fail PM yang sesuai. Nilai "Kunci" sepatutnya nama-asas fail PM (contoh de.pm adalh failnya, kemudian de adalah nilai "Kunci"). Nilai "Kandungan" sepatutnya menjadi paparan nama untuk hujung-depan. Nyatakan apa-apa bahasa takrifan sendiri di sini (lihat dokumentasi pembangun http://doc.otrs.org/ untuk maklumat lanjut). Sila ingat untuk menggunakan persamaan HTML untuk karakter bukan ASCII (contoh untuk German oe = o umlaut, ia adalah perlu untuk menggunakan &ouml; simbol).',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Mentakrifkan semua parameter untuk objek RefreshTime dalam keutamaan pelanggan dari paparan pelanggan.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Mentakrifkan semua parameter untuk objek ShownTickets dalam keutamaan pelanggan dari paparan pelanggan.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Mentakrifkan semua parameter untuk item ini dalam keutamaan pelanggan.',
        'Defines all the possible stats output formats.' => 'Mentakrifkan semua kemungkinan statistik format output.',
        'Defines an alternate URL, where the login link refers to.' => 'Mentakrifkan URL gantian, dimana pautan log masuk merujuk kepada.',
        'Defines an alternate URL, where the logout link refers to.' => 'Mentakrifkan URL gantian, dimana pautan log keluar merujuk kepada.',
        'Defines an alternate login URL for the customer panel..' => 'Mentakrifkan URL log masuk gantian untuk panel pelanggan..',
        'Defines an alternate logout URL for the customer panel.' => 'Mentakrifkan URL log keluar gantian untuk panel pelanggan.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            'Mentakrifkan pautan luaran pada pangkalan data pelanggan (contoh \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' atau \'\').',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Mentakrifkan bagaimana bidang From dari e-mel (dihantar daripada jawapan dan tiket e-mel) mestilah kelihatan sama.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket adalah diperlukan dalam skrin tiket tutup dari paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket diperlukan dalam skrin lantun tiket dari paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket diperlukan dalam skrin mengarang dari paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket diperlukan dalam skrin hadapan dari paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket diperlukan dalam skrin percuma dari paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket diperlukan dalam skrin gabungan tiket dari tiket dizum dalam paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket diperlukan dalam skrin nota tiket dari paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket diperlukan dalam skrin pemilik tiket dari tiket dizum dalam paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket diperlukan dalam skrin menunggu tiket dari tiket dizum dalam paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket diperlukan dalam skrin tiket telefon masuk dari paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket diperlukan dalam skrin tiket telefon keluar dari paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket diperlukan dalam skrin keutamaaan tiket dari tiket dizum dalam paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket diperlukan dalam skrin tanggungjawab tiket dari paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Mentakrifkan jika kunci tiket diperlukan untuk menukar pelanggan tiket dalam paparan ejen (jika tiket tidak dikunci lagi, tiket akan dikunci dan ejen semasa akan diset secara automatik sebagai pemiliknya).',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Mentakrifkan jika mesej yang digubah perlu diperiksa ejaanya dalam paparan ejen.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            'Mentakrifkan jika perakaunan masa adalah wajib dalam paparan ejen.',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Mentakrifkan jika perakaunan masa mesti diset kepada semua tiket dalam tindakan pukal.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            'Mentakrifkan kemaskini masa penjadual PID dalam saat (nombor sudut terapung).',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            'Mentakrifkan masa tidur penjadual dalam saat selepas memproses semua tugas-tugas yang ada (nombor sudut terapung).',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Mentakrifkan ungkapan biasa IP untuk mengakses repositori tempatan. Anda perlu untuk membolehkan ini untuk mempunyai akses untuk repositori tempatan anda dan package::RepositoryList adalah diperlukan pada hos jauh.',
        'Defines the URL CSS path.' => 'Mentakrifkan laluan URL CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Mentakrifkan laluan asas URL dari ikon, CSS dan Java Script.',
        'Defines the URL image path of icons for navigation.' => 'Mentakrifkan laluan imej URL dari ikon untuk navigasi.',
        'Defines the URL java script path.' => 'Mentakrifkan laluan URL java script',
        'Defines the URL rich text editor path.' => 'Mentakrifkan laluan URL editor teks kaya.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Mentakrifkan alamat server DNS yangng berdedikasi, jika perlu, untuk melihat "CheckMXRecord".',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Mentakrifkan teks badan untuk mel pemberitahuan dihantar kepada ejen, tentang kata laluan baru (selepas guna pautan ini kata laluan baru akan dihantar).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Mentakrifkan teks badan untuk mel pemberitahuan dihantar kepada ejen, dengan token tentang kata laluan baru yang diminta (selepas guna pautan ini kata laluan baru akan dihantar).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Mentakrifkan teks badan untuk mel pemberitahuan dihantar kepada pelanggan, tentang akaun baru.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Mentakrifkan teks badan untuk mel pemberitahuan dihantar kepada pelanggan, tentang kata laluan baru (selepas guna pautan ini kata laluan baru akan dihantar).',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Mentakrifkan teks badan untuk mel pemberitahuan dihantar kepada pelanggan, dengan token tentang kata lauan baru yang diminta (selepas guna pautan ini kata laluan baru akan dihantar).',
        'Defines the body text for rejected emails.' => 'Mentakrifkan teks badan untuk e-mel yang ditolak.',
        'Defines the boldness of the line drawed by the graph.' => 'Mentakrifkan keberanian barisan yang dilukis oleh graf.',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the colors for the graphs.' => 'Mentakrifkan warna untuk graf.',
        'Defines the column to store the keys for the preferences table.' =>
            'Mentakrifkan ruangan untuk menyimpan kunci untuk jadual keutamaan.',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Mentakrifkan parameter konfig dari item ini, untuk dipamerkan  dalam lihat keutamaan.',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'Mentakrifkan parameter konfig dari item ini, untuk dipamerkan dalam lihat keutamaan. Menjaga untuk mengekalkan kamus yang dipasang dalam sistem  dalam bahagian data.',
        'Defines the connections for http/ftp, via a proxy.' => 'Mentakrifkan sambungan untuk http/ftp, melalui proksi.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Mentakrifkan format input tarikh yang digunakan dalam bentuk (pilihan atau medan input).',
        'Defines the default CSS used in rich text editors.' => 'Mentakrifkan CSS asal yang digunakan dalam editor teks kaya.',
        'Defines the default auto response type of the article for this operation.' =>
            'Mentakrifkan jenis tindakbalas auto asal dari artikel untuk operasi ini.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Mentakrifkan badan asal nota dalam skrin tiket teks percuma dari paparan ejen.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Mentakrifkan  bahasa hadapan-hujung asal. Semua nilai-nilai yang mungkin ditentukan oleh fail bahasa yang ada pada sistem (lihat tetapan yang seterusnya).',
        'Defines the default history type in the customer interface.' => 'Mentakrifkan jenis sejarah asal dalam paparan pelanggan.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Mentakrifkan nombor maksimum asal dari sifat-sifat paksi-x untuk skala masa.',
        'Defines the default maximum number of search results shown on the overview page.' =>
            'Mentakrifkan nombor maksimum asal dari keputusan carian yang dipamerkan pada halaman gambaran.',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            'Mentakrifkan asal keadaan seterusnya untuk tiket selepas pelanggan membuat susulan dalam paparan pelanggan.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Mentakrifkan asal keadaan seterusnya dari tiket selepas menambah nota, dalam skrin tiket tutup dari paparan ejen.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Mentakrifkan asal keadaan seterusnya dari tiket selepas menambah nota, dalam skrin pukal tiket dari paparan ejen.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Mentakrifkan asal keadaan seterusnya dari tiket selepas menambah nota, dalam skrin teks percuma tiket dari paparan ejen.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Mentakrifkan asal keadaan seterusnya dari tiket selepas menambah nota, dalam skrin nota tiket dari paparan ejen.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Mentakrifkan asal keadaan seterusnya dari tiket selepas menambah nota, dalam skrin pemilik tiket dari tiket dizum dalam paparan ejen.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Mentakrifkan asal keadaan seterusnya dari tiket selepas menambah nota, dalam skrin menunggu tiket dari tiket dizum dalam paparan ejen.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Mentakrifkan asal keadaan seterusnya dari tiket selepas menambah nota, dalam skrin keutamaan tiket dari tiket dizum dalam paparan ejen.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Mentakrifkan asal keadaan seterusnya dari tiket selepas menambah nota, dalam skrin tanggungjawab tiket dari paparan ejen.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Mentakrifkan asal keadaan seterusnya dari tiket selepas dilantun, dalam skrin lantun tiket dari paparan ejen.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Mentakrifkan asal keadaan seterusnya dari tiket selepas dihadapankan, dalam skrin hadapan tiket dari paparan ejen.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Mentakrifkan asal keadaan seterusnya dari tiket jika ia digubah / dijawab dalam skrin gubah tiket dari paparan ejen.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Mentakrifkan teks badan nota asal untuk tiket telefon dalam skrin masuk telefon tiket dari paparan ejen.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Mentakrifkan teks badan nota asal untuk tiket telefon dalam skrin keluar telefon tiket dari paparan ejen.',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Mentakrifkan keutamaan asal tiket pengguna susulan dalam skrin zum tiket dalam paparan pelanggan.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Mentakrifkan keutamaan asal dari tiket pengguna baru dalam paparan pelanggan.',
        'Defines the default priority of new tickets.' => 'Mentakrifkan keutamaan asal tiket baru.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Mentakrifkan aturan asal untuk tiket pelanggan baru dalam paparan pelanggan.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Mentakrifkan pemilihan asal pada menu drop down untuk objek dinamik (Bentuk: Spesifikasi Biasa).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Mentakrifkan pemilihan asal pada menu drop down untuk keizinan (Bentuk: Spesifikasi Biasa).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Mentakrifkan pemilihan asal pada menu drop down untuk keizinan (Bentuk: Spesifikasi Biasa). Sila masukkan kunci format (lihar Stats::Format)',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Mentakrifkan jenis asal penghantar untuk tiket telefon di skrin telefon tiket masuk paparan ejen.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Mentakrifkan jenis asal penghantar untuk tiket telefon di skrin telefon tiket keluar paparan ejen.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Mentakrifkan jenis penghantar asal untuk tiket dalam skrin zum tiket dari paparan pelanggan.',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Mentakrifkan sifat pencarian tiket yang ditunjuk yang asal untuk skrin carian tiket.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Mentakrifkan turutan susunan asal untuk kesemua aturan dalam paparan aturan, selepas aturan keutamaan.',
        'Defines the default spell checker dictionary.' => 'Mentakrifkan kamus penyemak ejaan yang asal.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Mentakrifkan status asal untuk tiket pelanggan baru dalam paparan pelanggan.',
        'Defines the default state of new tickets.' => 'Mentakrifkan status asal tiket baru',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Mentakrifkan subjek asal untuk tiket telefon dalam skrin tiket telefon masuk dari paparan ejen.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Mentakrifkan subjek asal untuk tiket telefon dalam skrin tiket telefon keluar dari paparan ejen.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Mentakrifkan subjek nota asal dalam sirin tiket bebas teks dari paparan ejen.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Mentakrifkan sifate tiket asal untuk penyusunan tiket dalam pencarian tiket dari paparan pelanggan',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Mentakrifkan sifat tiket asal untuk penyusunan tiket dalam paparan lambungan dari paparan ejen',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Mentakrifkan sifat tiket asal untuk penyusunan tiket dalam paparan tiket terkunci dari paparan ejen.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Mentakrifkan sifat tiket asal untuk penyusunan tiket dalam paparan tanggungjawab dari paparan ejen.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Mentakrifkan sifat tiket asal untuk penyusunan tiket dalam paparan status dari paparan ejen.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Mentakrifkan sifat tiket asal untuk aturan tiket dalam paparan pantau dari paparan ejen',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Mentakrifkan sifat tiket asal untuk aturan tiket dalam hasil pencarian tiket dari paparan ejen.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Mentakrifkan notifikasi melantun tiket asal untuk pelanggan/penghantar dalam skrin lantunan tiket dari paparan ejen.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Mentakrifkan keadaan seterusnya tiket asal selepas menambah nota telefon dalam skrin tiket telefon masuk dari paparan ejen.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Mentakrifkan keadaan seterusnya tiket asal selepas menambah nota telefon dalam skrin tiket telefon keluar dari paparan ejen.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Mentakrifkan turutan tiket asal (selepas susunan keutamaan) dalam paparan lambungan dari paparan ejen. Atas: yang lama di atas. Bawah: yang terbaru di atas.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Mentakrifkan turutan tiket asal (selepas susunan keutamaan) dalam paparan status dari paparan ejen. Atas: yang lama di atas. Bawah: yang terbaru di atas.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Mentakrifkan turutan tiket asal dalam paparan tanggungjawab dari paparan ejen. Atas: yang lama di atas. Bawah: yang terbaru di atas.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Mentakrifkan turutan tiket asal dalam paparan tiket terkunci dari paparan ejen. Atas: yang lama di atas. Bawah: yang terbaru di atas.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Mentakrifkan turutan tiket asal dalam hasil carian tiket dari paparan ejen. Atas: yang lama di atas. Bawah: yang terbaru di atas.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Mentakrifkan turutan tiket asal dalam paparan pantau dari paparan ejen. Atas: yang lama di atas. Bawah: yang terbaru di atas.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Mentakrifkan turutan tiket asal dalam hasil carian dari paparan pelanggan. Atas: yang lama di atas. Bawah: yang terbaru di atas.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Mentakrifkan keutamaan tiket asal dalam skrin tiket tertutup dari paparan ejen.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Mentakrifkan keutamaan tiket asal dalam skrin tiket pukal dari paparan ejen.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Mentakrifkan keutamaan tiket asal dalam skrin tiket bebas teks dari paparan ejen.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Mentakrifkan keutamaan tiket asal dalam skrin nota tiket dari paparan ejen.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Mentakrifkan keutamaan tiket asal dalam skrin pemilik tiket dalam tiket dizum dari paparan ejen.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Mentakrifkan keutamaan tiket asal dalam skrin tiket tangguhan dalam tiket dizum dari paparan ejen.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Mentakrifkan keutamaan tiket asal dalam skrin keutamaan tiket dalam tiket dizum dari paparan ejen.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Mentakrifkan keutamaan tiket asal dalam skrin tanggungjawab tiket dari paparan ejen.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default type for article in the customer interface.' =>
            'Mentakrifkan jenis asal untuk artikel dari paparan pelanggan.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            'Mentakrifkan jenis asal mesej yang dikehadapankan dalam skrin tiket dikahadapankan dari paparan ejen.',
        'Defines the default type of the article for this operation.' => 'Mentakrifkan jnis asal artikel untuk operasi ini.',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'Mentakrifkan jenis asal nota dalam skrin tiket tertutup dari paparan ejen.',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'Mentakrifkan jenis asal nota dalam skrin tiket pukal dari paparan ejen.',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            'Mentakrifkan jenis asal nota dalam skrin tiket bebas teks dari paparan ejen.',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'Mentakrifkan jenis asal nota dalam skrin tiket nota dari paparan ejen.',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Mentakrifkan jenis asal nota dalam skrin pemilik tiket dari tiket dizum dalam paparan ejen.',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Mentakrifkan jenis asal nota dalam skrin tiket tangguhan dari tiket dizum dalam paparan ejen.',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            'Mentakrifkan jenis asal nota dalam skrin tiket telefon masuk dari paparan ejen.',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            'Mentakrifkan jenis asal nota dalam skrin tiket telefon keluar dari paparan ejen.',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Mentakrifkan jenis asal nota dalam skrin keutamaan tiket dari tiket dizum dalam paparan ejen.',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'Mentakifkan jenis asal nota dalam skrin tanggungjawab tiket dari paparan ejen.',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'Mentakifkan jenis asal nota dalam skrin tiket zum dari paparan pelanggan.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Mentakrifkan penggunaan asal Modul Frontend jika tiada parameter tindakan diberi dalam url dari paparan ejen.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Mentakrifkan penggunaan asal Modul Frontend jika tiada parameter tindakan diberi dalam url dari paparan pelanggan.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Mentakrifkan nilai asal parameter tindakan untuk frontend umum. Paramater tindakan digunakan di dalam skrip daripada sistem.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Mentakrifkan jenis penghantar tiket asal yang boleh dilihat (asal: customer).',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Mentakrifkan penapis yang memproses teks di dalam artikel, untuk menampakan URLs.',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            'Mentakrifkan format tindak balas di dalam skrin karang tiket dari paparan ejen ($QData{"OrigFrom"} ialah dari 1:1, $QData{"OrigFromName"} ialah hanya realname dari From).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Mentakrifkan nama domain sistem yang layak sepenuhnya. Tetapan ini digunakan sebagai pembolehubah, OTRS_CONFIG_FQDN dimana ia wujud dalam beberapa bentuk mesej yang digunakan oleh aplikasi itu.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            'Mentakrifkan kumpulan yang mengandungi setiap pelanggan pengguna (jika CustomerGroupSupport diaktifkan dan anda tidak mahu menguruskan setiap pengguna untuk kumpulan ini).',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Mentakrifkan ketinggian untuk komponent editor teks beraneka. Masukkan nombor (piksel) atau nilai peratus (relatif).',
        'Defines the height of the legend.' => 'Mentakrifkan ketinggian legenda.',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan sejarah komen untuk tindakan skrin tiket tertutup, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan sejarah komen untuk tindakan skrin tiket emel, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan sejarah komen untuk tindakan skrin tiket telefon, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Mentakrifkan sejarah komen untuk tindakan skrin tiket bebas teks, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan sejarah komen untuk tindakan skrin nota tiket, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan sejarah komen untuk tindakan skrin pemilik tiket, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan sejarah komen untuk tindakan skrin tiket tertangguh, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan sejarah komen untuk tindakan skrin tiket telefon masuk, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan sejarah komen untuk tindakan skrin tiket telefon keluar, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan sejarah komen untuk tindakan skrin keutamaan tiket, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan sejarah komen untuk tindakan skrin tanggungjawab tiket, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Mentakrifkan sejarah komen untuk tindakan zum tiket, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan sejarah komen untuk operasi ini, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan jenis sejarah untuk tindakan skrin tiket tertutup, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan jenis sejarah untuk tindakan skrin tiket emel, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan jenis sejarah untuk tindakan skrin tiket telefon, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Mentakrifkan jenis sejarah untuk tindakan skrin tiket bebas teks, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan jenis sejarah untuk tindakan skrin nota tiket, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan jenis sejarah untuk tindakan skrin pemilik tiket, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan jenis sejarah untuk tindakan skrin tiket tertangguh, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan jenis sejarah untuk tindakan skrin tiket telefon masuk, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan jenis sejarah untuk tindakan skrin tiket telefon keluar, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan jenis sejarah untuk tindakan skrin keutamaan tiket, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan jenis sejarah untuk tindakan skrin tanggungjawab tiket, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Mentakrifkan jenis sejarah untuk tindakan skrin zum tiket, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Mentakrifkan jenis sejarah untuk operasi ini, yang dapat digunakan untuk sejarah tiket di dalam paparan ejen.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Mentakrifkan jam dan minggu hari dari kalendar yang dinyatakan, untuk mengira masa berkerja.',
        'Defines the hours and week days to count the working time.' => 'Mentakrifkan jam dan minggu hari untuk mengira masa berkerja.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Mentakrifkan kunci untuk disemak bersama modul Kernel::Modues""AgentInfo. Jika tetapan kunci pengguna ini benar, mesej akan diterima oleh sistem.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Mentakrifkan kunci untuk disemak bersama CustomerAccept. Jika tetapan kunci pengguna ini adalah benar, mesej itu akan diterima oleh sistem.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Mentakrifkan pautan jenis \'Normal\'. Jika nama sumber dan nama sasaran mengandungi nilai yang sama, pautan yang terhasil adalah yang tidak berhala tuju; sebaliknya, hasil akan memberikan pautan yang mempunyai hala tuju.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Mentakrifkan pautan jenis \'ParentChild\'. Jika nama sumber dan nama sasaran mengandungi nilai yang sama, pautan yang terhasil adalah yang tidak berhala tuju; sebaliknya, hasil akan memberikan pautan yang mempunyai hala tuju.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Mentakrifkan pautan jenis kumpulan. Jenis pautan dari kumpulan yang sama membatalkan satu sama lain. Contoh: Jika tiket A dipaut kan mengunakan pautan \'Normal\' bersama tiket B, maka tiket ini tidak boleh menambah pautan bersama pautan dari hubungan \'ParentChild\'.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Mentakifkan senarai repositori dalam talian. Pemasangan lain boleh digunakan sebagai repositori, contoh seperti: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".',
        'Defines the list of possible next actions on an error screen.' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Mentakrifkan lokasi untuk mendapatkan senarai repositori dalam talian untuk pakej tambahan. Hasil pertama yang tersedia akan digunakan.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Mentakrifkan modul log untuk sistem. "File" menulis kesemua mesej dalam fail log yang diberi, "SysLog" menggunakan syslog daemon dari sistem, contoh: syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Mentakrifkan masa sah  maksima (dalam saat) untuk satu id sesi.',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => 'Mentakrifkan nombor maksima mukasurat untuk satu fail PDF.',
        'Defines the maximum size (in MB) of the log file.' => 'Mentakrifkan saiz maksima (dalam MB) fail log.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'Mentakrifkan modul yang menunjukkan notifikasi generik dalam paparan ejen. Samada "Text" - jika dikonfigurasi - atau isi kandungan "File" akan dipamerkan.',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            'Mentakrifkan modul yang menunjukkan kesemua pelanggan yang sedang log masuk dalam paparan ejen.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Mentakrifkan modul yang menunjukkan kesemua ejen yang sedang log masuk dalam paparan ejen.',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            'Mentakrifkan modul yang menunjukkan kesemua ejen yang sedang log masuk dalam paparan pelanggan',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            'Mentakrifkan modul yang menunjukkan kesemua pelanggan yang sedang log masuk dalam paparan pelanggan.',
        'Defines the module to authenticate customers.' => 'Mentakrifkan modul untuk mengesahkan pelanggan.',
        'Defines the module to display a notification in the agent interface if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Mentakrifkan modul untuk mempamerkan notifikasi dalam paparan ejen, jika ejen menlog keluar semasa out-of-office aktif.',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Mentakrifkan modul untuk mempamerkan notifikasi dalam paparan ejen, jika sistem digunakan oleh pengguna admin (kebiasaannya anda tidak patut berkerja sebagai admin).',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            'Mentakrifkan modul untuk menjana html refersh headers dari laman html, dalam paparan pelanggan.',
        'Defines the module to generate html refresh headers of html sites.' =>
            'Mentakrifkan modul untuk menjana html refersh headers dari laman html.',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'Mentakrifkan modul untuk menghantar emel. "Sendmail" menggunakan secara terus binari sendmail dari sistem operasi. Mana-mana makanisme "SMTP" menggunakan mailserver yang ditentukan. "DoNotSendEmail" tidak menghantar emel dan ia berguna untuk ujian sistem.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Mentakrifkan modul digunakan untuk menyimpan data sesi. Dengan "DB" server frontend boleh dipisahkan dari server db. "FS" adalah lebih laju.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Mentakrifkan nama aplikasi, ditunjukkan dalam paparan web, tab dan bar tajuk browser web.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Mentakrifkan nama kolum untuk menyimpan data dalam jadual tetapan.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Mentakrifkan nama kolum untuk menyimpan pengenal pasti pelanggan dalam jadual tetapan.',
        'Defines the name of the indicated calendar.' => 'Mentakrifkan nama kalendar yang dinyatakan.',
        'Defines the name of the key for customer sessions.' => 'Mentakrifkan nama kunci untuk sesi pelanggan.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Mentakrifkan nama kunic sesi. Contoh: Session, SessionID atau OTRS.',
        'Defines the name of the table, where the customer preferences are stored.' =>
            'Mentakrifkan nama jadual, dimana tetapan pelanggan disimpan.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Mentakrifkan status yang mungkin yang seterusya selepas mengarang / menjawab tiket dalam skrin karang tiket dari paparan ejen.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Mentakrifkan status yang mungkin yang seterusya selepas penghantaran tiket dalam skrin hantar tiket dari paparan ejen.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Mentakrifkan status yang mungkin yang seterusya untuk tiket pelanggan dalam paparan pelanggan.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Mentakrifkan status tiket seterusnya selepas menambah satu nota, dalam skrin tiket tertutup dari paparan ejen.',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Mentakrifkan status tiket seterusnya selepas menambah satu nota, dalam skrin tiket pukal dari paparan ejen.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Mentakrifkan status tiket seterusnya selepas menambah satu nota, dalam skrin tiket bebas teks dari paparan ejen.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Mentakrifkan status tiket seterusnya selepas menambah satu nota, dalam skrin nota tiket dari paparan ejen.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Mentakrifkan status tiket seterusnya selepas menambah satu nota, dalam skrin pemilik tiket dari tiket yang dizum dalam paparan ejen.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Mentakrifkan status tiket seterusnya selepas menambah satu nota, dalam skrin tiket tertangguh dari tiket yang dizum dalam paparan ejen.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Mentakrifkan status tiket seterusnya selepas menambah satu nota, dalam skrin keutamaan tiket dari tiket yang dizum dalam paparan ejen.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Mentakrifkan status tiket seterusnya selepas menambah satu nota, dalam skrin tanggungjawab tiket dari paparan ejen.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Mentakrifkan status tiket seterusnya selepas dilantun, dalam skrin lantunan tiket dari paparan ejen.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Mentakrifkan status tiket seterusnya selepas dipindahkan ke aturan yang lain, dalam skrin pindah tiket dari paparan ejen.',
        'Defines the parameters for the customer preferences table.' => 'Mentakrifkan parameter untuk jadual tetapan pelanggan.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Mentakrifkan parameter untuk dasboard backend. "Group" digunakan untuk menyekt akses kepada plugin (Contoh : Group: admin;group1;group2;). "Default" menunjukkan jika plugin diaktifkan oleh default atau jika pengguna perlu mengaktifkannya secara manual. "CacheTTL" menunjukkan tempoh tamat cache dalam minit untuk plugin.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Mentakrifkan parameter untuk dasboard backend. "Group" digunakan untuk menyekt akses kepada plugin (Contoh : Group: admin;group1;group2;). "Default" menunjukkan jika plugin diaktifkan oleh default atau jika pengguna perlu mengaktifkannya secara manual. "CacheTTLLocal" mentakrifkan tempoh tamat cache dalam minit untuk plugin.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Mentakrifkan parameter untuk dasboard backend. "Limit" mentakrifkan jumlah entri yang dipamerkan secara default. "Group" digunakan untuk menyekt akses kepada plugin (Contoh : Group: admin;group1;group2;). "Default" menunjukkan jika plugin diaktifkan oleh default atau jika pengguna perlu mengaktifkannya secara manual. "CacheTTL" menunjukkan tempoh tamat cache dalam minit untuk plugin.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Mentakrifkan parameter untuk dasboard backend. "Limit" mentakrifkan jumlah entri yang dipamerkan secara default. "Group" digunakan untuk menyekt akses kepada plugin (Contoh : Group: admin;group1;group2;). "Default" menunjukkan jika plugin diaktifkan oleh default atau jika pengguna perlu mengaktifkannya secara manual. "CacheTTLLocal" mentakrifkan tempoh tamat cache dalam minit untuk plugin.',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Mentakrifkan katalaluan untuk akses SOAP handle',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Mentakrifkan laluan dan TTF-File untuk mengendalikan font monospaced italik tebal dalam dokumen PDF.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Mentakrifkan laluan dan TTF-File untuk mengendalikan font propotional italik tebal dalam dokumen PDF.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Mentakrifkan laluan dan TTF-File untuk mengendalikan font monospaced tebal dalam dokumen PDF.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Mentakrifkan laluan dan TTF-File untuk mengendalikan font proportional tebal dalam dokumen PDF.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Mentakrifkan laluan dan TTF-File untuk mengendalikan font monospaced italik dalam dokumen PDF.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Mentakrifkan laluan dan TTF-File untuk mengendalikan font propotional italik dalam dokumen PDF.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Mentakrifkan laluan dan TTF-File untuk mengendalikan font monospaced dalam dokumen PDF.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Mentakrifkan laluan dan TTF-File untuk mengendalikan font proportional dalam dokumen PDF.',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            'Mentakrifkan laluan untuk penjadual untuk menyimpan output konsol (SchedulerOUT.log dan SchedulerERR.log).',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            'Mentakrifkan laluan fail maklumat yang ditunjukkan, yang terletak dalam Kernel/Output/HTML/Standard/CustomerAccept.dtl.',
        'Defines the path to PGP binary.' => 'Mentakrifkan laluan ke binari PGP',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Mentakrifkan laluan ke binari open ssl. Ia mungkin memerlukan satu HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            'Mentakrifkan perletakan legenf. Ini sepatutnya kunci dua huruf dalam bentuk: \'B[LCR |R[TCB]\'. Huruf yang pertama menunjukkan perletakan (Bawah atau Kanan), dan huruf yang kedua penjajaran (Kiri, Kanan, Tengah, Atas, atau Bawah).',
        'Defines the postmaster default queue.' => 'Mentakrifkan aturan postmaster default.',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            'Mentakrifkan sasaran penerima dari tiket telefon dan penghantar dari tiket emel ("Queue" menunjukkan kesemua aturan, "SystemAddress" memaparkan kesemua alamat sistem) dalam paparan ejen.',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            'Mentakrifkan sasaran penerima dari tiket ("Queue" menunjukkan kesemua aturan, "SystemAddress" memaparkan kesemua alamat sistem) dalam paparan pelanggan.',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Mentakrifkan kebenaran yang diperlukan untuk menunjukkan paparan lambungan tiket dari paparan ejen.',
        'Defines the search limit for the stats.' => 'Mentakrifkan had carian untuk status.',
        'Defines the sender for rejected emails.' => 'Mentakrifkan penghantar untuk emel yang ditolak.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Mentakrifkan pemisah antara nama sebenar ejen dan alamat emel aturan yang diberi.',
        'Defines the spacing of the legends.' => 'Mentakrifkan jarak legend.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Mentakrifkan kebenaran standard disediakan untuk pelanggan dalam aplikai. Jika lebih banyak kebenaran yang diperlukan, anda boleh masukkan mereka di sini. Kebenaran mesti "hard coded" untuk berkesan. Sila pastikan, apabila menambah mana-mana satu kebenaran yang dinyatakan, bahawa kebenaran "rw" kekal kemasukan terakhir.',
        'Defines the standard size of PDF pages.' => 'Mentakrifkan saiz standard mukasurat PDF.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Mentakrifkan status sesuatu tiket jika mendapat susulan dan tiket tersebut sudah ditutup.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Mentakrifkan status sesuatu tiket jika mendapat susulan.',
        'Defines the state type of the reminder for pending tickets.' => 'Mentakrifkan jenis status dari peringatan untuk tiket tertangguh.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Mentakrifkan subjek untuk mel notifikasi dihantar kepada ejen, mengenai katalauan baru.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Mentakrifkan subjek mel notifikasi dihantar kepada ejen, dengan token mengenai katalaluan baru yang diminta.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Mentakrifkan subjek untuk mel notfikasi dihantar kepada pelanggan, mengenai akaun baru.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Mentakrifkan subjek untuk mel notfikasi dihantar kepada pelanggan, mengenai katalaluan baru.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Mentakrifkan subjek untuk mel notfikasi dihantar kepada pelanggan, dengan token mengenai katalaluan baru yang diminta.',
        'Defines the subject for rejected emails.' => 'Mentakrifkan subjek untuk emel yang ditolak.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Mentakrifkan alamat emel pentadbir sistem. Ia akan dipamerkan dalam skrin error aplikasi.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Mentakrifkan sifat sasaran di dalam pautan ke pangkalan data pelanggan luaran.',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the time in days to keep log backup files.' => 'Mentakrifkan masa dalam hari untuk simpan fail log sokongan.',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            'Mentakrifkan masa dalam saat selepas di mana penjadual menjalankan restart automatik.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Mentakrifkan zon masa dari kalendar yang dinyatakan, dimana ia boleh ditetapkan kemudian kepada aturan yang tertentu.',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            'Mentakrifkan aksara yang digunakan untuk emel di dalam skrin karang tiket dari paparan ejen.',
        'Defines the user identifier for the customer panel.' => 'Mentakrifkan pengecam pengguna untuk panel pelanggan.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Mentakrifkan nama pengguna untuk akses SOAP handle (bin/cgi-bin/rpc.pl).',
        'Defines the valid state types for a ticket.' => 'Mentakrifkan jenis status yang sah untuk tiket.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            'Mentakrifkan status yang sah untuk tiket yang tidak terkunci. Untuk membuka tiket, skrip "bin/otrs.UnlockTickets.pl" boleh digunakan.',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            'Mentakrifkan tiket dikunci yang boleh dilihat. Default: unlock. tmp_lock.',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Mentakrifkan kelebaran untuk komponen editor teks beraneka. Masukkan nombor (piksel) atau nilai peratus (relatif).',
        'Defines the width of the legend.' => 'Mentakrifkan kelebaran legend.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Mentakrifkan artikel jenis penghantar yang mana harus di pamerkan dalam previu tiket.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            '',
        'Defines which items are available in first level of the ACL structure.' =>
            '',
        'Defines which items are available in second level of the ACL structure.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Mentakrifkan status yang mana harus di set secara automatik (Isi kandungan), selepas masa tangguhan status (Kunci) telah dicapai.',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Memadam sesuatu sesi jika id sesi digunakan bersama alamat IP jarak jauh yang tidak sah.',
        'Deletes requested sessions if they have timed out.' => 'Memadam sesi yang diminta jika mereka telah tamat masa.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Menentukan jika senarai aturan yang mungkin untuk dipindahkan ke tiket perlu dipamerkan dalam senarai dropdown atau dalam window yang baru dalam paparan ejen.',
        'Determines if the statistics module may generate ticket lists.' =>
            'Menentukan jika modul statistik boleh menjana senarai tiket.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Menetukan status tiket kemungkinan yang seterusnya, selepas penciptaan tiket emel baru dalam paparan ejen.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Menentukan status tiket kemungkinan yang seterusnya, selepas penciptaan tiket telefon baru dalam paparan ejen.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Menentukan skrin seterusnya selepas tiket pelanggan baru dalam paparan pelanggan.',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            'Menentukan skrin seterusnya selapas skrin susulan tiket dizum dalam paparan pelanggan.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Menentukan status kemungkinan untuk tiket tertangguh yang mengubah status selepas mencapai had masa.',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Menentukan rangkaian yang akan dipamerkan sebagai penerima (Kepada:) tiket telefon dan sebagai penghantar (Daripada:) tiket emel dalam paparan ejen. Untuk Queue sebagai NewQeueuSelectionType "<Queue>" menunjukkan nama aturan dan untuk SystemAddress "<RealName> <<Email>>" menunjukkan nama dan emel penerima.',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Menentukan rangkaian yang akan dipamerkan sebagai penerima (Kepada:) tiket dalam paparan pelanggan. Untuk Queue sebagai NewQeueuSelectionType "<Queue>" menunjukkan nama aturan dan untuk SystemAddress "<RealName> <<Email>>" menunjukkan nama dan emel penerima.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Menentukan cara objek yang dipaut dipamerkan di dalam setiap zoom mask.',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Menentukan pilihan yang mana akan sah dari penerima (tiket telefon) dan penghantar (tiket emel) dalam paparan ejen.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Menentukan aturan mana akan sah untuk penerima tiket dalam paparan pelanggan.',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE8.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            'Lumpuhkan notifikasi peringatan penghantaran kepada ejen yang bertanggungjawab kepada tiket. (Tiket::Responsible perlu diaktifkan).',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Pamerkan masa yang diperuntukkan untuk artikel dalam paparan zum tiket.',
        'Dropdown' => 'Dropdown',
        'Dynamic Fields Checkbox Backend GUI' => 'GUI Backend Checkbox Medan Dinamik',
        'Dynamic Fields Date Time Backend GUI' => 'GUI Backend Tarikh Masa Medan Dinamik',
        'Dynamic Fields Drop-down Backend GUI' => 'GUI Backend Drop-down Medan Dinamik',
        'Dynamic Fields GUI' => 'GUI Medan Dinamik',
        'Dynamic Fields Multiselect Backend GUI' => 'GUI Backend Multiselect Medan Dinamik',
        'Dynamic Fields Overview Limit' => 'Had Overview Medan Dinamik',
        'Dynamic Fields Text Backend GUI' => 'GUI Backend Teks Medan Dinamik',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Medan Dinamik digunakan untuk export hasil carian dalam format CSV.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => 'Had Medan Dinamik untuk satu halaman untuk Overview Medan Dinamik.',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket tertutup dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin karang tiket dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket emel dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin hantaran tiket dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket bebas teks dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket overview format sederhana dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan.',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket pindah dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin nota tiket dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin pemilik tiket dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket tertangguh dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket telefon masuk dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket telefon keluar dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket telefon dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Medan Dinamik ditunjukkan dalam skrin format overview previu tiket dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket cetak dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan.',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket cetak dari paparan pelanggan. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan.',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin keutamaan tiket dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Medan Dinamik ditunjukkan dalam skrin tanggungjawab tiket dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Medan Dinamik ditunjukkan dalam skrin hasil carian overview tiket dari paparan pelanggan. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan.',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Medan Dinamik ditunjukkan dalam skrin carian tiket dari paparan pelanggan. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket overview format kecil dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan.',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket zum dari paparan pelanggan. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan.',
        'DynamicField backend registration.' => 'Pendaftaran backend DynamicField',
        'DynamicField object registration.' => 'pendaftaran objek DynamicField',
        'Edit customer company' => '',
        'Email Addresses' => 'Alamat emel',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            'Mengaktifkan output PDF. Modul CPAN PDF::API2 diperlukan, jika di dipasangkan,output PDF akan dilumpuhkan.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Mengaktifkan sokongan S/MIME.',
        'Enables customers to create their own accounts.' => 'Membolehkan pelanggan untuk mencipta akaun mereka sendiri.',
        'Enables file upload in the package manager frontend.' => 'Membolehkan muat naik fail dalam frontend pengurusan pakej.',
        'Enables or disable the debug mode over frontend interface.' => 'Mengaktifkan atau melumpuhkan mod debug di paparan frontend.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Mengaktifkan atau melumpuhkan fungsi pemantau tiket, untuk mengikuti perkembangan tiket tanpa pemilik atau yang bertanggungjawab.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Mengaktifkan log prestasi (untuk menlog masa tindak balas halaman). Ia akan menjejaskan prestasi sistem. Frontend::Module###AdminPerformanceLog mesti diaktifkan.',
        'Enables spell checker support.' => 'Mengaktifkan sokongan semakan ejaan.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Mengaktifkan fungsi tindakan tiket pukal untuk frontend ejen untuk melaksanakan lebih dari satu tiket pada satu masa.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Mengaktifkan fungsi tindakan tiket pukal hanya untuk kumpulan yang tersenarai.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Mengaktifkan fungsi tanggungjawab tiket, untuk mengikuti perkembangan tiket tertentu.',
        'Enables ticket watcher feature only for the listed groups.' => 'Mengaktifkan fungsi pantauan tiket hanya untuk kumpulan yang tersenarai.',
        'Escalation view' => 'Paparan lambungan',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Pendaftaran modul acara. Untuk lebih prestasi anda boleh mentakrifkan acara pencetus (contoh: Event => TicketCreate). Ini hanya mungkin jika kesemua medan dinamik Tiket perlu acara yang sama.',
        'Event module that updates customer user service membership if login changes.' =>
            '',
        'Event module that updates customer users after an update of the Customer Company.' =>
            '',
        'Event module that updates tickets after an update of the Customer Company.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            '',
        'Execute SQL statements.' => 'Melaksanakan penyata SQL.',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'Melaksanakan semakan susulan dalam pada In-Reply-To atau headers Rujukan untuk mel yang tidak mempunyai nombor tiket di dalam subjek.',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            'Melaksanakan semakan lampiran mel susulan dalam mel yang tidak mempunyai nombor tiket di dalam subjek.',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            'Melaksanakan semakan badan mel susulan dalam mel yang tidak mempunyai nombor tiket di dalam subjek.',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            'Melaksanakan semakan mel kosong/raw susulan dalam mel yang tidak mempunyai nombor tiket di dalam subjek.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Export keseluruh pokok artikel dalam hasil carian (ia boleh menjejaskan prestasi sistem).',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Memperoleh pakej menggunakan proxy. Mengganti "WebUserAgent::Proxy".',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            'Fail yang dipamerkan di dalam modul Kernel::Modules::AgentInfo, jika terletak di bawah Kernel/OutputHTML/Standard/AgentInfo.dll.',
        'Filter incoming emails.' => 'Penapis emel masuk.',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Memaksa pengekodan emel keluar (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Memaksa untuk memilih status tiket yang lain (daripada yang terkini) selepas tindakan mengunci. Mentakrifkan status terkini sebagai kunci, dan status seterusnya selepas tindakan mengunci sebagai isi kandungan.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Memaksa untuk membuka tiket selepas dipindahkan ke aturan yang lain.',
        'Frontend language' => 'Bahasa Frontend',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Pendaftaran modul frontend (melumpuhkan pautan syarikat jika tiada fungsi syarikat yang digunakan).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => 'Pendaftaran modul frontend untuk paparan ejen.',
        'Frontend module registration for the customer interface.' => 'Pendaftaran modul frontend untuk paparan pelanggan.',
        'Frontend theme' => 'Tema frontend',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'General ticket data shown in the dashboard widgets. Possible settings: 0 = Disabled, 1 = Enabled. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'GenericAgent' => 'GenericAgent',
        'GenericInterface Debugger GUI' => 'GenericInterface Debugger GUI',
        'GenericInterface Invoker GUI' => 'GenericInterface Pencetus GUI',
        'GenericInterface Operation GUI' => 'GenericInterface Operasi GUI',
        'GenericInterface TransportHTTPSOAP GUI' => 'GenericInterface TransportHTPSOAP GUI',
        'GenericInterface Web Service GUI' => 'GenericInterface GUI Perkhidmatan Web',
        'GenericInterface Webservice History GUI' => 'GenericInterface GUI Sejarah PerkhidmatanWeb',
        'GenericInterface Webservice Mapping GUI' => 'GenericInterface GUI Pemetaan PerkhidmatanWeb',
        'GenericInterface module registration for the invoker layer.' => 'Pendaftaran modul GenericInterface untuk lapisan pencetus.',
        'GenericInterface module registration for the mapping layer.' => 'Pendaftaran modul GenericInterface untuk lapisan pemetaan.',
        'GenericInterface module registration for the operation layer.' =>
            'Pendaftaran modul GenericInterface untuk lapisan operasi.',
        'GenericInterface module registration for the transport layer.' =>
            'Pendaftaran modul GenericInterface untuk lapisan pengangkutan.',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            'Memberi pengguna akhir kemungkinan untuk mengatasi aksara pemisah untuk failCSV, ditakrifkan di dalam fail terjemahan.',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            'Memberi akses, jika ID Pelanggan dari tiket padan dengan ID Pengguna pelanggan dan pengguna pelanggan ada kebenaran kumpulan pada aturan yang memiliki tiket itu.',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            'Membantu untuk membesarkan carian arikel teks penuh arikel (Dari, Ke, Cc, Subjek dan Carian badan). Runtime akan menjalankan pencarian teks penuh pada data langsung (ia berfungsi dengan baik untuk sampai ke 50,000 tiket). StaticDB akan melucutkan kesemua artikel dan akan membina indeks selepas penciptaan artikel, menikkan carian teks penuh kira-kira 50%. Untuk mencipta indeks permulaan, gunakan "bin/otrs.RebuildFulltextIndex.pl".',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Jika "DB" dipilih untuk Customer::AuthModule, pemacu pangkalan data (biasanya pengesanan auto akan digunakan) boleh ditentukan.',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Jika "DB" dipilih untuk Customer::AuthModule, katalaluan untuk sambung ke jadual pelanggan boleh ditentukan.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Jika "DB" dipilih untuk Customer::AuthModule, nama pengguna untuk sambung ke jadual pelanggan boleh ditentukan.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Jika "DB" dipilih untuk Customer::AuthModule, DSN untuk sambungan ke jadual pelanggan mesti ditentukan.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Jika "DB" dipilih untuk Customer::AuthModule, nama kolum untuj CustomerPassword dalam jadual pelanggan mesti ditentukan.',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'Jika "DB" dipilih untuk Customer::AuthModule, jenis crypt katalaluan mesti ditentukan.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Jika "DB" dipilih untuk Customer::AuthModule, nama kolum untuk CustomerKey dalam  jadual pelanggan mesti ditentukan.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Jika "DB" dipilih untuk Customer::AuthModule, nama untuk jadual dimana data pelanggan anda disimpankan mesti ditentukan.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Jika "DB" dipilih untuk SessionModule, jadual di dalam pangakalan data dimana data sesi akan disimpan mesti ditentukan.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Jika "DB" dipilih untuk SessionModule, direktori dimana data sesi akan disimpan mesti ditentukan.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, anda boleh tentukan (dengan menggunakan RegExp) untuk lucutkan bahagian dari REMOTE_USER (cth: untuk membuang trailing domain). RegExp-Note, $1 akan jadi log masuk yang baru.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Jika "HTTPBasicAuth" dipilih untuk Customer::AuthModule, anda boleh tentukan untuk lucutkan bahagian termuka dari nama pengguna (cth: untuk domain seperti example_domain\user kepada user).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Jika "LDAP" dipilih untuk Customer::AuthModule dan jika anda mahu menambah akhiran kepada setiap nama log masuk pelanggan, tentukan ia disini, cthL anda hanya mahu menulis nama pengguna untuk pengguna tapi dalam direktori LDAP anda wujudnya user@domain.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Jika "LDAP" dipilih untuk Customer::AuthModule dan parameter istimewa diperlkan untuk modul perl Net::LDAP, anda boleh tentukannya di sini. Lihat "perldoc Net::LDAP" untuk maklumat lebih mengenai parameter.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Jika "LDAP" dipilih untuk Customer::AuthModule dan pengguna anda hanya ada aksestanpa nama kepada pokok LDAP, tapi anda mahu cari melalui data itu, anda boleh lakukannya dengan pengguna yang mempunyai akses kepada direktori LDAP. Tentukan katalaluan untuk pengguna istimewa ini di sini.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Jika "LDAP" dipilih untuk Customer::AuthModule dan pengguna anda hanya ada aksestanpa nama kepada pokok LDAP, tapi anda mahu cari melalui data itu, anda boleh lakukannya dengan pengguna yang mempunyai akses kepada direktori LDAP. Tentukan katalaluan untuk pengguna istimewa ini di sini.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Jika "LDAP" dipilih untuk Customer::AuthModule, BaseDN mesti ditentukan',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Jika "LDAP" dipilih untuk Customer::AuthModule, hos LDAP mesti ditentukan.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Jika "LDAP" dipilih untuk Customer::AuthModule, pengecam pengguna mesti ditentukan.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Jika "LDAP" dipilih untuk Customer::AuthModule, atribut pengguna boleh ditentukan. Untuk LDAP posixGroups gne UID, untuk bukan LDAP posixGroups guna DN pengguna penuh.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Jika "LDAP" dipilih untuk Customer::AuthModule, anda boleh tentukan atribut akses disini.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Jika "LDAP" dipilih untuk Customer::AuthModule, anda boleh tentukan samada aplikasi akan berhenti jika cth: suatu sambungan kepada server tidak dapat dihubungi disebabkan masalah jaringan.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'Jika "LDAP" dipilih untuk Customer::AuthModule, anda boleh semak jika pengguna dibenarkan untuk mengesahkan sebab pengguna tersebut berada dalam posixGroup, cth: pengguna perlu berada di dalam kumpulan xyz untuk gunaOTRS. Tentukan kumpulan tersebut, siapa yang boleh akses sistem tersebut.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Jika "LDAP" dipilih, anda boleh menambah penapis untuk setiap aturan LDAP, cth: (mail=*), (objectclass=user) atau (!objectclass=computer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Jika "Radius" dipilih untuk Customer::AuthModule, katalaluan untuk mengesahkan hos radius mesti ditentukan.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Jika "Radius" dipilih untuk Customer::AuthModule, hos radius mesti ditentukan.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Jika "Radius" dipilih untuk Customer::AuthModule, anda boleh tentukan samada aplikasi akan berhenti jika cth: suatu sambungan kepada server tidak dapat dihubungi disebabkan masalah jaringan.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Jika "Sendmail" dipilih sebagai SendmailModule, lokasi bagi binari sendmail dan pilihan yang diperlukan mesti ditentukan.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'Jika "SysLog" dipilih untuk LogModule, kemudahan log istimewa boleh ditentukan.',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            'Jika "SysLog" dipilih untuk LogModule, sarung log istimewa boleh ditentukan (pada solaris anda mungkin perlu menggunakan \'stream\').',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Jika "SysLog" dipilih untuk LogModule, set aksara yang sepatutnya digunakan untuk menlog boleh ditentukan.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Jika "file" dipilih untuk LogModule, suatu logfile mesti ditentukan. Jika fail tersebut tidak wujud, ia akan dicipta oleh sistem.',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            'Jika suatu nota ditambah oleh ejen, tetapkan status tiket di dalam skrin tiket tertutup dari paparan ejen.',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            'Jika suatu nota ditambah oleh ejen, tetapkan status tiket di dalam skrin tiket pukal dari paparan ejen.',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'Jika suatu nota ditambah oleh ejen, tetapkan status tiket di dalam skrin tiket bebas teks dari paparan ejen.',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'Jika suatu nota ditambah oleh ejen, tetapkan status tiket di dalam skrin nota tiket dari paparan ejen.',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'Jika suatu nota ditambah oleh ejen, tetapkan status tiket di dalam skrin tanggungjawab tiket dari paparan ejen.',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Jika suatu nota ditambah oleh ejen, tetapkan status tiket di dalam skrin pemilik tiket dari tiket dizum dalam paparan ejen.',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Jika suatu nota ditambah oleh ejen, tetapkan status tiket di dalam skrin tiket tertangguh dari tiket dizum dalam paparan ejen.',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Jika suatu nota ditambah oleh ejen, tetapkan status tiket di dalam skrin keutamaan tiket dari tiket dizum dalam paparan ejen.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Jika satu daripada mekanisme "SMTP" dipilih sebagai SendmailModule, dan pengesahan kepada server mel diperlukan, katalalun mesti ditentukan.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Jika satu daripada mekanisme "SMTP" dipilih sebagai SendmailModule, dan pengesahan kepada server mel diperlukan, nama pengguna mesti ditentukan.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Jika satu daripada mekanisme "SMTP" dipilih sebagai SendmailModule, hos mel yang menghantar mel keluar mesti ditentukan.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Jika satu daripada mekanisme "SMTP" dipilih sebagai SendmailModule, port dimana server mel anda mendengar untuk sambungan masuk mesti ditentukan.',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            'Jika diaktikan, OTRS akan menghantar kesemua fail CSS dalam bentuk yang dikecilkn. AMARAN: Jika anda mematikan ini, kebarangkalian akan berlaku masalah dalam IE 7, kerana ia tidak dapat untuk memuatkan lebih dari 32 fail CSS.',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'Jika diakifkan, OTRS akan menghantar kesemua fail JavaScript dalam bentuk yang dikecilkan.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Jika diaktifkan, TicketPhone dan TicketEmail akan di buka di tingkap yang baru.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails.' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Jika diaktifkan, overviews yang berbeza (Dashboard, LockedView, QueueView) akan direfresh secara automatik selepas masa yang tertentu.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Jika diaktifkan, tahap pertama menu utama akan dibuka pada saat tetikus diatasnya (dan bukannya hanya dengan klik).',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            'Jika ditetapkan, alamat ini akan digunakan sebagai sampul header penghantar dalam notifikasi keluar. Jika tiada alamat yang ditentukan, sampul header penghantar adalah kosong.',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.' =>
            '',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Jika regex ini padan, tiada mesej akan dihantar oleh tindak balas auto.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            'Jika anda mahu menggunakan pangkalan data cermin untuk ejen carian tiket teks penuh atau untuk menjana status, tentukan DSN kepada database ini.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            'Jika anda mahu menggunakan pangkalan data cermin untuk ejen carian tiket teks penuh atau untuk menjana status, katalaluan untuk untuk pengesahan kepada pangakalan data ini mesti ditentukan.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            'Jika anda mahu menggunakan pangkalan data cermin untuk ejen carian tiket teks penuh atau untuk menjana status, pengguna untuk pengesahan kepada pangkalan data ini boleh ditentukan.',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            'Hiraukan artikel dengan sistem jenis penghantar untuk ciri artikel baru (cth: tindak balas auto atau notifikasi emel).',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Termasuk masa artikel dicipta dalam carian tiket dari paparan ejen.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            'IndexAccelerator: untuk memilih modul backend TicketViewAccelerator anda/ "RuntimeDB" menjana setiap paparan aturan pada jadual dengan cepat dari jadual tiket (tiada masalah prestasi dijangka sehingga berjumlah 60,000 tiket dan 6,000 tiket terbuka di dalam sistem). Menggunakan skrip "bin/otrs.RebuildTicketIndex.pl" untuk mengemas kini indeks permulaan.',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            'Pasang ispell atau aspell pada sistem, jika anda mahu menggunakan penyemak ejaanSila tentukan laluan kepada binari aspell atau ispell pada sistem operasi anda.',
        'Interface language' => 'Bahasa Paparan',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Ia adalah mungkin untuk mengkonfigurasi kulit yang berbeza, contohnya untuk membezakan antara agen berbeza dari faktor, yang akan digunakan atas dasar per domain dalam aplikasi. Menggunakan ungkapan biasa (regex), anda boleh mengkonfigurasi sepasang Kunci / Kandungan untuk dipadankan domain. Nilai dalam "Key" harus sepadan domain, dan nilai dalam "Content" harus menjadi kulit yang sah pada sistem anda. Sila lihat catatan contoh untuk bentuk yang betul daripada regex.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Ia adalah mungkin untuk mengkonfigurasi kulit yang berbeza, contohnya untuk membezakan antara pelanggan berbeza dari faktor, yang akan digunakan atas dasar per domain dalam aplikasi. Menggunakan ungkapan biasa (regex), anda boleh mengkonfigurasi sepasang Kunci / Kandungan untuk dipadankan domain. Nilai dalam "Key" harus sepadan domain, dan nilai dalam "Content" harus menjadi kulit yang sah pada sistem anda. Sila lihat catatan contoh untuk bentuk yang betul daripada regex.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'Ia adalah mungkin untuk mengkonfigurasi tema yang berbeza, sebagai contoh untuk membezakan antara ejen dan pelanggan, yang akan digunakan atas dasar per domain dalam aplikasi. Menggunakan ungkapan biasa (regex), anda boleh mengkonfigurasi sepasang Kunci / Kandungan untuk dipadankan domain. Nilai dalam "Key" harus sepadan domain, dan nilai dalam "Content" harus menjadi tema yang sah pada sistem anda. Sila lihat catatan contoh untuk bentuk yang betul daripada regex.',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'Link agents to groups.' => 'Pautan ejen kepada kumpulan.',
        'Link agents to roles.' => 'Pautan ejen kepada peranan.',
        'Link attachments to templates.' => '',
        'Link customer user to groups.' => '',
        'Link customer user to services.' => '',
        'Link queues to auto responses.' => 'Pautan aturan kepada tindak balas auto.',
        'Link roles to groups.' => 'Pautan peranan kepada kumpulan.',
        'Link templates to queues.' => '',
        'Links 2 tickets with a "Normal" type link.' => 'Pautkan 2 tiket dengan pautan jenis "Normal".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Pautkan 2 tiket dengan pautan jenis "ParentChild".',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Senarai fail CSS untuk sentiasa dimuatkan untuk paparan ejen.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Senarai fail CSS untuk sentiasa dimuatkan untuk paparan pelanggan.',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            'Senarai fail IE8-specific CSS untuk sentiasa dimuatkan untuk paparan ejen.',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            'Senarai fail IE8-specific CSS untuk sentiasa dimuatkan untuk paparan pelanggan.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Senarai fail JS untuk sentiasa dimuatkan untuk paparan ejen.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Senarai fail JS untuk sentiasa dimuatkan untuk paparan pelanggan.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '',
        'List of all CustomerUser events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => 'Fail log untuk kaunter tiket.',
        'Mail Accounts' => 'Akaun Mel',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Membuatkan aplikasi menyemak rekod MX alamat emel sebelum menghantar emel atau menyerahakan tiket telefon atau emel.',
        'Makes the application check the syntax of email addresses.' => 'Membuatkan aplikasi menyemak sintaks alamat emel.',
        'Makes the picture transparent.' => 'Membuatkan gambar menjadi lutsinar.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Membuatkan pengurusan sesi menggunakan cookies html. Jika cookies html dimatikan atau browser klien matikan cookies html, sistem akan berjalan seperti biasa dan melampirkan id sesi kepada pautan.',
        'Manage PGP keys for email encryption.' => 'Mengurus kunci PGP untuk enkripsi emel.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Mengurus akaun POP3 atau IMAP untuk mengambil emel dari.',
        'Manage S/MIME certificates for email encryption.' => 'Mengurus Perakuan S/MIME untuk enkripsi emel.',
        'Manage existing sessions.' => 'Mengurus sesi yang sedia ada.',
        'Manage notifications that are sent to agents.' => 'Mengurus notifikasi yang dihantar kepada ejen.',
        'Manage system registration.' => '',
        'Manage tasks triggered by event or time based execution.' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Saiz maksimum (dalam aksara) pada jadual informasi pelanggan (telefon dan emel) dalam skrin karang.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Saiz maksimum (dalam baris) pada kotak ejen telah dimaklumkan dalam paparan ejen.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Saiz maksimum (dalam baris) pada kotak ejen terlibat dalam paparan ejen.',
        'Max size of the subjects in an email reply.' => 'Saiz maksimum subjek dalam badan balasan emel.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Tindak balas auto emel maksimum kepada alamat emel sendiri sehari (perlindungan pengulangan).',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Saiz maksimum dalam KBytes untuk mel yang dapat diambil melalui POP3/POP3S/IMAP/IMAPS (KBytes).',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Jumlah maksimum tiket untuk dipamerkan dalam hasil carian dalam paparan ejen.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Jumlah tiket untuk dipamerkan dalam hasil carian dalam paparan pelanggan.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Saiz maksimum (dalam aksara) dari jadual maklumat pelanggan dalam paparan zum tiket.',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Modul untuk To-selecion dalam skrin tiket baru dalam paparan pelanggan.',
        'Module to check customer permissions.' => 'Modul untuk menyemak kebenaran pelanggan.',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            'Modul untuk menyemak jika suatu pengguna ada di dalam kumpulan yang istimewa. Akses diberikan, jika pengguna ada di dalam kumpulan yang ditentukan dan ada kebenaran ro dan rw.',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            'Modul untuk menyemak jika emel yang sampai perlu ditanda sebagai email dalaman (kerana emel dalaman asal yang dihadapankan). ArticleType dan SenderType takrifkan nilai untuk emel/artikel yang sampai.',
        'Module to check the agent responsible of a ticket.' => 'Modul untuk menyemak tanggungjawab ejen pada tiket.',
        'Module to check the group permissions for the access to customer tickets.' =>
            'Modul untuk menyemak kebenaran kumpulan untuk akses kepada tiket pelanggan.',
        'Module to check the owner of a ticket.' => 'Modul untuk menyemak pemilik kepada tiket.',
        'Module to check the watcher agents of a ticket.' => 'Modul untuk menyemak ejen pemantau kepada tiket.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Modul untuk karang mesej ditandatangan (PGP atau S/MIME).',
        'Module to crypt composed messages (PGP or S/MIME).' => 'Modul untuk crypt mesej yang dikarang (PGP atau S/MIME).',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Modul untuk menapis dan memanipulasi mesej yang masuk. Halang/abai kesemua emel span dengan Dari: noreply@ address.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'Modul untuk menapis dan memanipulasi mesej yang masuk. Dapatkan nombor 4 digit kepada tiket bebas teks, guna regex dalam Padanan cth: From => \'(.+?)@.+?\', dan guna () sebagai [***] dalam Set =>.',
        'Module to generate accounted time ticket statistics.' => 'Modul untuk menjana statistik tiket masa yang diperuntukkan',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Modul untuk menjana profil html OpenSearch untuk carian pendek tiket dalam paparan ejen.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Modul untuk menjana profil html OpenSearch untuk carian pendek tiket dalam paparan pelanggan. ',
        'Module to generate ticket solution and response time statistics.' =>
            'Modul untuk menjana penyelesaian tiket dan statistik masa tindak balas.',
        'Module to generate ticket statistics.' => 'Modul untuk menjana statistik tiket.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'Modul untuk menunjukkan notifikasi dan lambungan (ShownMax: lambungan maksimum dipamerkan, EscalationInMinutes: Menunjukkan tiket dimana akan dilambungkan, CacheTimet: Cache lambungan uang dikira dalam saat).',
        'Module to use database filter storage.' => 'Modul untuk menggunakan penyimpanan penapis pangkalan data.',
        'Multiselect' => 'Multiselect',
        'My Tickets' => 'Tiket Saya',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Nama aturan tersuai. Aturan tersuai ialah pemilihan aturan pada aturan yang anda inginkan dan boleh dipilih dalam tetapan pilihan.',
        'NameX' => 'NamaX',
        'New email ticket' => 'Tiket emel baru',
        'New phone ticket' => 'Tiket telefon baru',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Status tiket yang mungkin yang seterusnya selepas menambah nota telefon dalam skrin tiket telefon masuk dari paparan ejen.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Status tiket yang mungkin yang seterusnya selepas menambah nita telefon dalam skrin tiket telefon keluar dari paparan ejen.',
        'Notifications (Event)' => 'Notifikasi (Acara)',
        'Number of displayed tickets' => 'Jumlah tiket yang dipamerkan',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Jumlah barisan (setiap tiket) yang diunjukkan oleh utiliti carian dalam paparan ejen.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Jumlah tiket yang akan dipamerkan dalam setiap halaman dari hasil carian dalam paparan ejen.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Jumlah tiket yang akan dipamerkan dalam setiap halaman dari hasil carian dalam paparan pelanggan.',
        'Open tickets of customer' => 'Tiket terbuka pelanggan',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Terlebih muat (mentakrifkan semula) fungsi sedia ada dalam Kernel::System::Ticket. Digunakan untuk memudahkan menambah penyesuaian.',
        'Overview Escalated Tickets' => 'Overview Tiket yang Dilambung',
        'Overview Refresh Time' => 'Overview masa refresh',
        'Overview of all open Tickets.' => 'Overview kesemua Tiket terbuka.',
        'PGP Key Management' => 'Pengurusan Kunci PGP',
        'PGP Key Upload' => 'Muat naik Kunci PGP',
        'Parameters for .' => '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            'Parameters untuk objek CreateNextMask dalam paparan pilihan dari paparan ejen.',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            'Parameter untuk objek FollowUpNotify dalam paparan pilihan dari paparan ejen.',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            'Parameter untuk objek LockTimeoutNotify dalam paparan pilihan dari paparan ejen.',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            'Parameter untuk objek MoveNotify dalam paparan pilihan dari paparan ejen.',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            'Parameter untuk objek NewTicketNotify dalam paparan pilihan dari paparan ejen.',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            'Parameter untuk objek RefreshTime dalam paparan pilihan dari paparan ejen.',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            'Parameter untuk objek WatcherNotify dalam paparan pilihan dari paparan ejen.',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameter untuk dashboard backend overview tiket baru dari paparan ejen. "Limit" adalah jumlah kemasukan yang dipamerkan secara deault. "Group" digunakan untuk menyekat akses ke plugin (cth: Group: admin;group1;group2;). "Deault" menentukan jika plugin adalan diaktifkan secara default atau jika pengguna perlu untuk mengaktifkannya secara manual. "CacheTTLLocal" adalah masa cache dalam minit untuk plugin.',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameter untuk dashboard backend kalendar tiket dari paparan ejen. "Limit" adalah jumlah kemasukan yang dipamerkan secara deault. "Group" digunakan untuk menyekat akses ke plugin (cth: Group: admin;group1;group2;). "Deault" menentukan jika plugin adalan diaktifkan secara default atau jika pengguna perlu untuk mengaktifkannya secara manual. "CacheTTLLocal" adalah masa cache dalam minit untuk plugin.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameter untuk dashboard backend overview lambungan tiket dari paparan ejen. "Limit" adalah jumlah kemasukan yang dipamerkan secara deault. "Group" digunakan untuk menyekat akses ke plugin (cth: Group: admin;group1;group2;). "Deault" menentukan jika plugin adalan diaktifkan secara default atau jika pengguna perlu untuk mengaktifkannya secara manual. "CacheTTLLocal" adalah masa cache dalam minit untuk plugin.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameter untuk dashboard backend peringatan tiket tertangguh dari paparan ejen. "Limit" adalah jumlah kemasukan yang dipamerkan secara deault. "Group" digunakan untuk menyekat akses ke plugin (cth: Group: admin;group1;group2;). "Deault" menentukan jika plugin adalan diaktifkan secara default atau jika pengguna perlu untuk mengaktifkannya secara manual. "CacheTTLLocal" adalah masa cache dalam minit untuk plugin.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameter untuk dashboard backend peringatan tiket tertangguh dari paparan ejen. "Limit" adalah jumlah kemasukan yang dipamerkan secara deault. "Group" digunakan untuk menyekat akses ke plugin (cth: Group: admin;group1;group2;). "Deault" menentukan jika plugin adalan diaktifkan secara default atau jika pengguna perlu untuk mengaktifkannya secara manual. "CacheTTLLocal" adalah masa cache dalam minit untuk plugin.',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameter untuk dashboard backend status tiket dari paparan ejen. "Limit" adalah jumlah kemasukan yang dipamerkan secara deault. "Group" digunakan untuk menyekat akses ke plugin (cth: Group: admin;group1;group2;). "Deault" menentukan jika plugin adalan diaktifkan secara default atau jika pengguna perlu untuk mengaktifkannya secara manual. "CacheTTLLocal" adalah masa cache dalam minit untuk plugin.',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            'Parameter untuk halaman (dimana medan dinamik ditunjuk) overview medan dinamik.',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            'Parameter untuk halaman (dimana tiket ditunjuk) overview tiket sederhana.',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            'Parameter untuk halaman (dimana tiket ditunjuk) overview tiket kecil.',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            'Parameter untuk halaman (dimana tiket ditunjuk) overview previu tiket.',
        'Parameters of the example SLA attribute Comment2.' => 'Parameter contoh atribut SLA Komen2',
        'Parameters of the example queue attribute Comment2.' => 'Parameter contoh atribut aturan Komen2',
        'Parameters of the example service attribute Comment2.' => 'Parameter contoh atribut perkhidmatan Komen2',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Laluan untuk fail log (ia hanya diunakan jika "FS" dipilh untuk LoopProtectionModule dan ia adalam mandatori).',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            'Laluan fail yang menyimpan kesemua tetapan untuk objek QueueObject untuk paparan ejen.',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            'Laluan fail yang menyimpan kesemua tetapan untuk objek QueueObject untuk paparan pelanggan.',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            'Laluan fail yang menyimpan kesemua tetapan untuk TicketOject untuk paparan ejen.',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            'Laluan fail yang menyimpan kesemua tetapan untuk TicketObject untuk paparan pelanggan.',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            'Melakukan tindakan yang telah dikonfigurasi untuk setiap acara (sebagai pencetus) untuk setiap Webservice yang telah dikonfigurasi.',
        'Permitted width for compose email windows.' => 'Kelebaran yang diberi kebenaran untuk karang emel windows.',
        'Permitted width for compose note windows.' => 'Kelebaran yang diberi kebenaran untuk karan nota windows.',
        'Picture-Upload' => 'Muatnaik Gambar',
        'PostMaster Filters' => 'Penapis PostMaster',
        'PostMaster Mail Accounts' => 'Akaun Mel PostMaster',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Perlindungan terhadap eksploitasi CSRF (Pemalsuan Permintaan Laman Silang)(untuk lebih maklumat lihat http://en.wikipedia.org/wiki/Cross-site_request_forgery).',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '',
        'Queue view' => 'Paparan Aturan',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh Overviews after' => 'Refresh Overview selepas',
        'Refresh interval' => 'Tempoh selang refresh',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Menggantikan pengganti asal dengan alamat emel pelanggan semasa pada jawapan dikarang dalam skrin karang tiket dari paparan ejen.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Memerkulan kebenaran untuk mengubah pelanggan sesuatu tiket dalam paparan ejen.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Memerlukan kebenaran untuk menggunakan skrin tiket tertutup dalam paparan ejen.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Memerlukan kebenaran untuk menggunakan skrin tiket latun dalam paparan ejen.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Memerlukan kebenaran untuk menggunakan skrin karang tiket dalam paparan ejen.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Memerlukan kebenaran untuk menggunakan skrin menghadapankan tiket dalam paparan ejen.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Memerlukan kebenaran untuk menggunakan skrin tiket bebas teks dalam paparan ejen.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Memerlukan kebenaran untuk menggunakan skrin tiket gabung dari tiket dizum dalam paparan ejen.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Memerlukan kebenaran untuk menggunakan skrin nota tiket dalam paparan ejen.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Memerlukan kebenaran untuk menggunakan skrin pemilik tiket ari tiket dizum dalam paparan ejen.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Memerlukan kebenaran untuk menggunakan skrin tiket tertangguh dari tiket dizum dalam paparan ejen.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Memerlukan kebenaran untuk menggunakan skrin tiket telefon masuk dalam paparan ejen.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Memerlukan kebenaran untuk menggunakan skrin tiket telefon keluar dalam paparan ejen.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Memerlukan kebenaran untuk menggunakan skrin keutamaan tiket dari tiket dizum dalam paparan ejen.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Memerlukan kebenaran untuk menggunakan skrin tanggungjawab tiket dalam paparan ejen.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Reset dan membuka pemilik sesuatu tiket jika ia telah dipindahkan ke aturan yang lain.',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'Memulihkan tiket daripada arkib (hanya jika acara ialah status berubah, daripada tertutup kepada mana-mana status terbuka yang tersedia).',
        'Roles <-> Groups' => 'Peranan <-> Kumpulan',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Menjalankan carian wildcard awal daripada pengguna pelanggan yang sedia ada semasa mengakses modul AdminCustomerUser itu.',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'Menjalankan sistem dalam mod "Demo". Jika ditetapkan kepada "Yes", ejen boleh menukar pilihan, seperti pemilihan bahasa dan tema melalui antara muka web ejen. Perubahan ini hanya sah untuk sesi semasa. Ia tidak akan mungkin bagi ejen untuk menukar kata laluan mereka.',
        'S/MIME Certificate Upload' => 'Muatnaik perakuan S/MME',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            'Menyimpan lampiran artikel. "DB" menyimpan semua data dalam pangkalan data (tidak digalakkan untuk menyimpan lampiran besar). "FS" menyimpan data pada sistem fail, ini adalah lebih cepat tetapi server web perlu dijalankan di bawah pengguna OTRS itu. Anda boleh bertukar antara modul walaupun pada satu sistem yang sudah dalam pengeluaran tanpa kehilangan data.',
        'Search Customer' => 'Carian Pelanggan',
        'Search User' => '',
        'Search backend default router.' => 'Mencari router backend default.',
        'Search backend router.' => 'Mencari router backend',
        'Select your frontend Theme.' => 'Memilih tema frontend anda.',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Memilih modul untuk mengendalikan Gambar melalui paparan web. "DB" menyimpan semua Gambar dalam pangkalan data, "FS" menggunakan sistem fail.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            'Memilih nombor tiket modul penjana. "AutoIncrement" kenaikan bilangan tiket Undur dan kaunter digunakan dengan format SystemID.counter (contohnya 1010138, 1010139). Dengan "Date" nombor tiket akan dijana oleh tarikh semasa, Undur dan kaunter. Format kelihatan seperti Year.Month.Day.SystemID.counter (contohnya 200206231010138, 200206231010139). Dengan "DateChecksum" kaunter itu akan dikepilkan sebagai checksum untuk rentetan tarikh dan Undur. Checksum akan digilirkan setiap hari. Format kelihatan seperti Year.Month.Day.SystemID.Counter.CheckSum (contohnya 2002070110101520, 2002070110101535). "Random" menjana nombor tiket rawak dalam format "SystemID.Random" (contohnya 100057866352, 103745394596).',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Hantar saya pemberitahuan jika pelanggan menghantar susulan dan saya pemilik tiket atau tiket dikunci dan berada dalam salah satu daripada aturan langganan saya.',
        'Send notifications to users.' => 'Hantar notifikasi kepada pelanggan.',
        'Send ticket follow up notifications' => 'Hantar notifikasi susulan tiket.',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Menghantar notifikasi susulan ejen hanya kepada pemilik, jika tiket tidak dikunci (default ialah untuk hantar notifikasi kepada kesemua ejen).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Hantar kesemua emel keluar melalui bcc kepada alamat tertentu. Sila guna ini hanya untuk tindak balas sokongan.',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            'Hantar notifikasi pelanggan hanya kepada pelanggan yang dipeta. Biasanya, jika tiada pelanggan yang dipeta, penghantar pelanggan yang terkini akan dapat notifikasi tersebut.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Hantar notifikasi peringatan tiket terbuka selapas mencapai tarikh peringatan (hanya hantar kepada pemilik tiket).',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            'Hantar notifikasi yang telah dikonfigurasi dalam paparan admin di bawah "Notifikasi (Acara)".',
        'Set sender email addresses for this system.' => 'Tetapkan alamat emel penghantar untuk sistem ini..',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Tetapkan ketinggian default (dalam piksel) artikel inline HTML dalam AgentTicketZoom.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Tetapkan ketinggian maksimum (dalam piksel) artikel inline HTML dalam AgentTicketZoom.',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'Tetapkan ini kepada yes jika anda percaya dalam kesemua kunci pgp public dan private anda, walaupun jika mereka tidak diakui dengan tanda tangan yang dipercayai.',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent.' => '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if ticket owner must be selected by the agent.' => 'Tetapkan jika pemilik tiket mesti dipilih oleh ejen.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Tetapkan PendingTime untuk suatu tiket kepada 0 jika statusnya telah diubah kepada status bukan pending.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Tetapkan umur dalam minit (tahap pertama) untuk aturan ditonjolkan ang mengandungi tiket yang tidak disentuh.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Tetapkan umur dalam minit (tahap kedua) untuk aturan ditonjolkan ang mengandungi tiket yang tidak disentuh.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Menetapkan tahap konfigurasi pentadbir. Bergantung kepada tahap config, beberapa pilihan sysconfig akan tidak ditunjukkan. Tahap config di dalam tertib menaik: Pakar, Advanced, Permulaan. Semakin tinggi tahap config (Permulaan contohnya adalah yang tertinggi), semakin kurang kemungkinan adalah bahawa pengguna tidak sengaja boleh mengkonfigurasi sistem dalam cara yang ia tidak boleh digunakan lagi.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article type for new email tickets in the agent interface.' =>
            'Tetapkan jenis artikel default untuk tiket emel baru dalam paparan ejen.',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            'Tetapkan jenis artikel default untuk tiket telefon baru dalam paparan ejen.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Tetapkan teks body untuk nota yang ditambah dalam skrin tiket tertutup dari paparan ejen.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Tetapkan teks body untuk nota yang ditambah dalam skrin pindah tiket dari paparan ejen.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Tetapkan teks body untuk nota yang ditambah dalam skrin nota tiket dari paparan ejen.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Tetapkan teks body untuk nota yang ditambah dalam skrin pemilik tiket dari tiket dizum dalam paparan ejen.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Tetapkan teks body untuk nota yang ditambah dalam skrin tiket tertangguh dari tiket dizum dalam paparan ejen.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Tetapkan teks body untuk nota yang ditambah dalam skrin keutamaan tiket dari tiket dizum dalam paparan ejen.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Tetapkan teks body untuk nota yang ditambah dalam skrin tanggungjawab tiket dari paparan ejen.',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Tetapkan jenis pautan default tiket yang dipisahkan dalam paparn ejen.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Tetapkan status default seterusnya untuk tiket telefon baru dalam paparan ejen.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Tetapkan status tiket default seterusnya, selepas penciptaan tiket emel dalam paparan ejen.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Tetapkan teks nota default untuk tiket telefon baru. Cth: \'Tiket baru melalui panggilan\' dalam paparan ejen.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Tetapkan keutamaan default untuk tiket emel baru dalam paparan ejen.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Tetapkan keutamaan default untuk tiket telefon baru dalam paparan ejen.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Tetapkan jenis penghantar default untuk tiket emel baru dalam paparan ejen.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Tetapkan jenis penghantar default untuk tiket telefon baru dalam paparan ejen.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Tetapkan subjek default untuk tiket emel baru (cth: \'emel keluar\') dalam paparan ejen.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Tetapkan subjek default untuk tiket telefon baru (cth: \'Panggilan telefon\') dalam paparan ejen.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Tetapkan subjek default untuk nota yang ditambah dalam skrin tiket tertutup dari paparan ejen.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Tetapkan subjek default untuk nota yang ditambah dalam skrin pindah tiket dari paparan ejen.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Tetapkan subjek default untuk nota yang ditambah dalam skrin nota tiket dari paparan ejen.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Tetapkan subjek default untuk nota yang ditambah dalam skrin pemilik tiket dari tiket dizum dalam  paparan ejen.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Tetapkan subjek default untuk nota yang ditambah dalam skrin tiket tertangguh dari tiket dizum dalam paparan ejen.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Tetapkan subjek default untuk nota yang ditambah dalam skrin keutamaan tiket daritiket dizum dalam paparan ejen.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Tetapkan subjek default untuk nota yang ditambah dalam skrin tanggungjawab tiket dari paparan ejen.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Tetapkan teks default untuk tiket emel baru dalam paparan ejen.',
        'Sets the display order of the different items in the preferences view.' =>
            'Tetapkan giliran paparan dari item yang berbeza dalam paparan pilihan.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            'Tetapkan masa tidak aktif (dalam saat) untuk berlalu sebelum suatu sesi dimatikan dan pengguna dilog keluar.',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            'Tetapkan saiz kiraan tikt minimum (jika "AutoIncrement" dipilih sebgai TicketNumberGenerator). Default ialah 5. ini bermakna kiraan bermula dari 10000.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Tetapkan jumlah barisan yang dipamerkan dalam mesej teks (cth: barisan tiket dalam dalam QueueZoom).',
        'Sets the options for PGP binary.' => 'Tetapkan pilihan untuk binari PGP.',
        'Sets the order of the different items in the customer preferences view.' =>
            'Tetapkan giliran item yang berbeza dalam papran pilihan pelanggan.',
        'Sets the password for private PGP key.' => 'Tetapkan katalaluan untuk kunci PGP private.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Tetapkan unit masa yang disukai (cth: unit kerja, jam, minit).',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Set prefiks untuk folder skrip pada server, seperti yang dikonfigurasikan pada server web. Tetapan ini digunakan sebagai pembolehubah, OTRS_CONFIG_ScriptAlias ​​yang terdapat dalam semua bentuk pesanan yang digunakan oleh aplikasi, untuk membina hubungan tiket dalam sistem.',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'Tetapkan ejen bertanggungjawab untuk tiket dalam skrin tiket tertutup dari paparan ejen.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Tetapkan ejen bertanggungjawab untuk tiket dalam skrin tiket pukal dari paparan ejen.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Tetapkan ejen bertanggungjawab untuk tiket dalam skrin tiket bebas teks dari paparan ejen.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Tetapkan ejen bertanggungjawab untuk tiket dalam skrin nota tiket dari paparan ejen.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Tetapkan ejen bertanggungjawab untuk tiket dalam skrin pemilik tiket dari tiket dizum dalam paparan ejen.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Tetapkan ejen bertanggungjawab untuk tiket dalam skrin tiket tertangguh dari tiket dizum dalam paparan ejen.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Tetapkan ejen bertanggungjawab untuk tiket dalam skrin keutamaan tiket dari tiket dizum dalam paparan ejen.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Tetapkan ejen bertanggungjawab untuk tiket dalam skrin tanggungjawab tiket dari paparan ejen.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Tetapkan perkhidmatan dalam skrin tiket tertutup dari paparan ejen (Ticket::Service perlu diaktifkan).',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Tetapkan perkhidmatan dalam skrin tiket bebas teks dari paparan ejen (Ticket::Service perlu diaktifkan).',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Tetapkan perkhidmatan dalam skrin nota tiket dari paparan ejen (Ticket::Service perlu diaktifkan).',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Tetapkan perkhidmatan dalam skrin pemilik tiket dari tiket dizum dalam paparan ejen (Ticket::Service perlu diaktifkan).',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Tetapkan perkhidmatan dalam skrin tiket tertangguh dari tiket dizum dalam paparan ejen (Ticket::Service perlu diaktifkan).',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Tetapkan perkhidmatan dalam skrin keutamaan tiket dari tiket dizum dalam paparan ejen (Ticket::Service perlu diaktifkan).',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Tetapkan perkhidmatan dalam skrin tanggungjawab tiket dari paparan ejen (Ticket::Service perlu diaktifkan).',
        'Sets the size of the statistic graph.' => 'Tetapkan saiz untuk graf statisktik.',
        'Sets the stats hook.' => 'Tetapkan hook status.',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            'Tetapkan zon masa sistem (memerlukan sistem dengan UTC sebagai sistem masa). Jika tidak ini ialah masa berbeza kepada masa tempatan.',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Tetapkan pemilik tiket dalam skrin tiket tertutup dari paparan ejen.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Tetapkan pemilik tiket dalam skrin tiket pukal dari paparan ejen.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Tetapkan pemilik tiket dalam skrin tiket bebas teks dari paparan ejen.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Tetapkan pemilik tiket dalam skrin nota tiket dari paparan ejen.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Tetapkan pemilik tiket dalam skrin pemilik tiket dari tiket dizum dalam paparan ejen.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Tetapkan pemilik tiket dalam skrin tiket tertangguh dari tiket dizum dalam paparan ejen.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Tetapkan pemilik tiket dalam skrin keutamaan tiket dari tiket dizum dalam paparan ejen.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Tetapkan pemilik tiket dalam skrin tanggungjawab tiket dari paparan ejen.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Tetapkan jenis tiket dalam skrin tiket tertutup dari paparan ejen (Ticket::Type perlu diaktifkan).',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Tetapkan jenis tiket dalam skrin tiket pukal dari paparan ejen.',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Tetapkan jenis tiket dalam skrin tiket bebas teks dari paparan ejen (Ticket::Type perlu diaktifkan).',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Tetapkan jenis tiket dalam skrin nota tiket dari paparan ejen (Ticket::Type perlu diaktifkan).',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Tetapkan jenis tiket dalam skrin pemilik tiket dari tiket dizum dalam paparan ejen (Ticket::Type perlu diaktifkan).',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Tetapkan jenis tiket dalam skrin tiket tertangguh dari tiket dizum dalam paparan ejen (Ticket::Type perlu diaktifkan).',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Tetapkan jenis tiket dalam skrin keutamaan tiket dari tiket dizum dalam paparan ejen (Ticket::Type perlu diaktifkan).',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Tetapkan jenis tiket dalam skrin tanggungjawab tiket dari paparan ejen (Ticket::Type perlu diaktifkan).',
        'Sets the time (in seconds) a user is marked as active.' => '',
        'Sets the time type which should be shown.' => 'Tetapkan jenis masa yang perlu ditunjukkan',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Tetapkan masa tamat (dalam saat) untuk http/ftp muat turun.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Tetapkan masa tamat (dalam saat) untuk muat turun pakej. Menggantikan "WebUserAgent::Timeout".',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            'Tetapkan zon masa pengguna setiap pengguna (memerlukan sistem dengan UTC sebagai sistem masa and UTC dibawah TimeZone). Jika tidak ini ialah masa berbeza kepada masa tempatan.',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            'Tetapkan zon masa pengguna setiap pengguna berdasarkan fungsi skrip java / browser offset zon masa di masa log masuk.',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Menunjukkan pilihan tanggungjawab dalam tiket telefon dan emel dalam paparan ejen.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Menunjukkan artikel sebagai teks walaupun penulisan teks aneka dimatikan.',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            'Menunjukkan kiraan ikon dalam tiket zum, jika artikel mempunyai lampiran.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk melanggan/henti melanggan dari tiket dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu yang membolehkan memaut tiket dengan objek lain dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dlam menu yang membolehkan tiket digabung dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk akses sejarah tiket dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk menambah medan bebas teks dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk menambah nota dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk menambah nota kepada tiket dalam setiap overview tiket dari paparan ejen.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk menutup tiket dalam setiap overview tiket dari paparan ejen.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk menutup tiket dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Menunjukkan pautan dalam menu untuk memadam tiket dalam setiap overview tiket dari paparan ejen. Kawalan akses tambahan untuk tunjuk atau tidak tunjuk pautan ini boleh dilakukan menggunakan Kunci "Group" dan Kandungan seperti "rw:group1;move_into:group2".',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Menunjukkan pautan dalam menu untuk memadam tiket dalam paparan zum tiket dari paparan ejen. Kawalan akses tambahan untuk tunjuk atau tidak tunjuk pautan ini boleh dilakukan menggunakan Kunci "Group" dan Kandungan seperti "rw:group1;move_into:group2".',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk kembali dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk mengunci/membuka tiket dalam overview tiket dari paparan ejen.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk mengunci/membuka tiket dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk pindah tiket dalam setiap overview tiket dari paparan ejen.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk mencetak tiket atau artikel paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk melihat pelanggan yang meminta tiket dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk melihat sejarah tiket dalam setiap overview tiket dari paparan ejen.',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk melihat pemilik tiket dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk melihat keutamaan tiket dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk melihat ejen bertanggungjawab untuk tiket dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk tetapkan tiket sebagai tertangguh dalam paparan zum tiket dari paparan ejen.',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Menunjukkan pautan dalam menu untuk tetapkan tiket sebagai spam dalam setiap overview tiket dari paparan ejen. Kawalan akses tambahan untuk tunjuk atau tidak tunjuk pautan ini boleh dilakukan menggunakan Kunci "Group" dan Kandungan seperti "rw:group1;move_into:group2".',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk tetapkan keutamaan tiket dalam setiap overview tiket dari paparan ejen.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Menunjukkan pautan dalam menu untuk zum  tiket dalam overview tiket dari paparan ejen.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Menunjukkan pautan untuk akses lampiran artikel melalui penglihat html online dalam paparan zum artikel dalam paparan ejen.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Menunjukkan pautan untk muat turun lampiran artikel dalam paparan zum artikel dalam paparan ejen.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Menunjukkan pautan untuk melihat tiket emel yang dizum dalam teks kosong.',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Menunjukkan pautan untuk tetapkan tiket sebagai spam dalam paparan zum tiket dari paparan ejen. Kawalan akses tambahan untuk tunjuk atau tidak tunjuk pautan ini boleh dilakukan menggunakan Kunci "Group" dan Kandungan seperti "rw:group1;move_into:group2".',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang terlibat pada tiket ini, dalam skrin tiket tertutup dari paparan ejen.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang terlibat pada tiket ini, dalam skrin tiket bebas teks dari paparan ejen.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang terlibat pada tiket ini, dalam skrin nota tiket dari paparan ejen.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang terlibat pada tiket ini, dalam skrin pemilik tiket dari paparan ejen.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang terlibat pada tiket ini, dalam skrin tiket tertangguh dari paparan ejen.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang terlibat pada tiket ini, dalam skrin keutamaan tiket dari tiket dizum dalam paparan ejen.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang terlibat pada tiket ini, dalam skrin tanggungjawab tiket dari paparan ejen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang mungkin (semua ejen dengan kebenara nota pada aturan/tiket) untuk menentukan siapa yang sepatutnya diberitahu mengenai nota ini, dalam skrin tiket tertutup dari paparan ejen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang mungkin (semua ejen dengan kebenara nota pada aturan/tiket) untuk menentukan siapa yang sepatutnya diberitahu mengenai nota ini, dalam skrin tiket bebas teks dari paparan ejen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang mungkin (semua ejen dengan kebenara nota pada aturan/tiket) untuk menentukan siapa yang sepatutnya diberitahu mengenai nota ini, dalam skrin nota tiket dari paparan ejen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang mungkin (semua ejen dengan kebenara nota pada aturan/tiket) untuk menentukan siapa yang sepatutnya diberitahu mengenai nota ini, dalam skrin pemilik tiket dari tiket dizum dalam paparan ejen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang mungkin (semua ejen dengan kebenara nota pada aturan/tiket) untuk menentukan siapa yang sepatutnya diberitahu mengenai nota ini, dalam skrin tiket tertangguh dari tiket dizum dalam paparan ejen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang mungkin (semua ejen dengan kebenara nota pada aturan/tiket) untuk menentukan siapa yang sepatutnya diberitahu mengenai nota ini, dalam skrin keutamaan tiket dari tiket dizum dalam paparan ejen.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Menunjukkan senarai kesemua ejen yang mungkin (semua ejen dengan kebenara nota pada aturan/tiket) untuk menentukan siapa yang sepatutnya diberitahu mengenai nota ini, dalam skrin tanggungjawab tiket dari paparan ejen.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Menunjukkan previu overview tiket (CustomerInfo => 1 - tunjuk juga maklumat pelanggan, CustomerInfoMaxSize saiz maksimum aksara maklumat pelanggan).',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => 'Menunjukkan kesemua aturan kedua-dua ro dan rw dalam paparan aturan.',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Menunjukkan kesemua tiket terbuka (walaupuan jika mereka dikunci) dalam paparan labungan dari paparan ejen.',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            'Menunjukkan kesemua tiket terbuka (walaupuan jika mereka dikunci) dalam paparan status dari paparan ejen.',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            'Menunjukkan kesemua artikel tiket (dikembangkan) dalam paparan zum.',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Menunjukkan kesemua pengecam pelanggan dalam medan multi-select (tidak berguna jika anda ada banyak pengecam pelanggan).',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Menunjukkan pemilihan pemilik dalam tiket telefon dan emel dalam paparan ejen.',
        'Shows colors for different article types in the article table.' =>
            'Menunjukkan warna untuk jenis artikel berbeza dalam jadual artikel.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Menunjukkan sejarah tiket pelanggan dalam AgentTicketPhone, AgentTicketEmail dan AgentTicketCustomer.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Menunjukkan samada subjek artikel pelanggan terakhir atau tajuk tiket dalam overview format kecil.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Menunjukkan senarai aturan parent/child yang sedia ada dalam sistem dalam bentuk pokok atau senarai.',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Menunjukkan atribut tiket yang diaktifkan dalam paparan pelanggan (0 = Dimatikan dan 1 = Diaktifkan).',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Menunjukkan aritkel disusun seperti biasa atau terbalik, dibawah tiket zum dalam paparan ejen.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Menunjukkan maklumat pelanggan pengguna (telefon dan emel) dalam skrin karang.',
        'Shows the customer user\'s info in the ticket zoom view.' => 'Menunjukkan maklumat pelanggan pengguna dalam paparan zum tiket.',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            'Menunjukkan mesej untuk hari itu (MOTD) dalam dashboard ejen. "Group" digunakan untuk menyekat akses kepada plugin (cth: Group: admin;group1;group2;). "Default" menunjukkan jika plugin diaktifkan melalui default atau jika pengguna perlu untuk mengaktifkannya secara manual.',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Menunjukkan mesej untuk hari itu pada srin log masuk dari paparan ejen.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Menunjukkan sejarah tiekt (susunan terbalik) dalam paparan ejen.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Menunjukkan pilihan keutamaan tiket dalam skrin tiket tertutup dari paparan ejen.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Menunjukkan pilihan keutamaan tiket dalam skrin pindah tiket dari paparan ejen.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Menunjukkan pilihan keutamaan tiket dalam skrin tiket pukal dari paparan ejen.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Menunjukkan pilihan keutamaan tiket dalam skrin tiket bebas teks dari paparan ejen.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Menunjukkan pilihan keutamaan tiket dalam skrin nota tiket dari paparan ejen.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan pilihan keutamaan tiket dalam skrin pemilik tiket dari tiket dizum dalam paparan ejen.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan pilihan keutamaan tiket dalam skrin tiket tertangguh dari tiket dizum dalam paparan ejen.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan pilihan keutamaan tiket dalam skrin keutamaan tiket dari tiket dizum dalam paparan ejen.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Menunjukkan pilihan keutamaan tiket dalam skrin tanggungjawab tiket dari paparan ejen.',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            'Menunjukkan medan tajuk dari skrin tiket tertutup dari paparan ejen.',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            'Menunjukkan medan tajuk dari skrin tiket bebas teks dari paparan ejen.',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            'Menunjukkan medan tajuk dari skrin nota tiketdari paparan ejen.',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan medan tajuk dari skrin pemilik tiket dari tiket dizum dalam paparan ejen.',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan medan tajuk dari skrin tiket tertangguh dari tiket dizum dalam paparan ejen.',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Menunjukkan medan tajuk dari skrin keutamaan tiket dari tiket dizum dalam paparan ejen.',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            'Menunjukkan medan tajuk dari skrin tanggungjawab tiket dari paparan ejen.',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            'Menunjukkan masa format panjang (hari, jam, minit), jika tetapkan ke "Yes"; atau format pendek (hari, jam), jika tetapkan ke "No".',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            'Menunjukkan masa menggunakan deskripsi lengkap (hari, jam, minit), jika tetapkan ke "Yes"; atau hanya huruf pertama (d, h, m), jika tetapkan ke "No".',
        'Skin' => 'Kulit',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Susun tiket (menaik atau menurun) apabila atau aturan tunggal dipilh dalam paparan aturan dan selepas tiket disusun mengikut keutamaan. Nilai: 0 = menaik (terlama diatas, default), 1 = menurun (terbaru diatas). Menggunakan QueueID untuk kunci dan 0 atau 1 untuk nilai.',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Contoh pemasangan Spam Assassin. Abaikan emel yang ditanda dengan SpamAssassin.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Contoh pemasangan Spam Assassin. Pindah mel ditanda ke aturan spam.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Tentukan jika ejen sepatutnya menerima notifikasi emel dari tindakannya sendiri.',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => 'Tentukan warna latar pada carta.',
        'Specifies the background color of the picture.' => 'Tentukan warna latar pada gambar.',
        'Specifies the border color of the chart.' => 'Tentukan warna sempadan pada carta.',
        'Specifies the border color of the legend.' => 'Tentukan warna sempadan pada legend.',
        'Specifies the bottom margin of the chart.' => 'Tentukan margin bawah untuk carta.',
        'Specifies the different article types that will be used in the system.' =>
            'Tetntukan jenis artikel yang berbeza yang akan digunakan dalam sistem.',
        'Specifies the different note types that will be used in the system.' =>
            'Tentukan jenis nota berbeza yang akan digunakan dalam sistem.',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'Tentukan direktori untuk menyimpan data, jika "FS" dipilih untuk TicketStorageModule.',
        'Specifies the directory where SSL certificates are stored.' => 'Tentukan direktori dimana perakuan SSL disimpan.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Tentukan direktori dimana perakuan SSL private disimpan.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => 'Menentukan margin kiri pada carta.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Menentukan alamat e-mel yang boleh digunakan oleh aplikasi apabila menghantar notifikasi. Nama penghantar digunakan untuk membina nama paparan lengkap untuk master notifikasi (iaitu "OTRS Notification Master" otrs@your.example.com). Notifikasi adalah mesej seperti en::Customer::QueueUpdate atau en::Agent::Move.',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            '',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Menentukan laluan fail untuk logo dalam header halaman (gif|jpg|png, 700 x 100 piksel).',
        'Specifies the path of the file for the performance log.' => 'Menentukan laluan fail untuk log prestasi.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Menentukan laluan kepada penukar yang membenarkan paparan fail Microsoft Excel, dalam paparan web.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Menentukan laluan kepada penukar yang membolehkan paparan fail Microsoft Word, dalam paparan web.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Menentukan laluan kepada penukar yang membenarkan paparan dokumen PDF, dalam paparan web.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Menetukan laluan kepada penukar yang membolehkan paparan fail XML, dalam paparan web.',
        'Specifies the right margin of the chart.' => 'Menentukan margin kanan untuk carta.',
        'Specifies the text color of the chart (e. g. caption).' => 'Menentukan warna teks pada carta (cth: kapsyen).',
        'Specifies the text color of the legend.' => 'Menentukan warna teks pada penunjuk.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Menentukan teks yang patut muncul dalam fail log untuk menunjukkan kemasukan skrip CGI.',
        'Specifies the top margin of the chart.' => 'Menentukan margin atas untuk carta.',
        'Specifies user id of the postmaster data base.' => 'Menentukan id pengguna pada pangkalan data postmaster.',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Standard kebenaran disediakan untuk ejen dalam aplikasi. Jika lebih banyak kebenaran yang diperlukan, mereka boleh dimasukkan di sini. Kebenaran mesti ditakrifkan untuk menjadi berkesan. Beberapa kebenaran lain yang baik juga telah disediakan terbina dalam: Note, close pending, customer, freetext, move, compose, responsible, forward, dan bounce. Pastikan bahawa "rw" sentiasa kebenaran berdaftar terakhir.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Nombor permulaan untuk pengiraan statistik. Setiap kenaikan status baru nombor ini.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Memulakan carian wildcard pada objek aktif selepas pautan mask objek dimulakan.',
        'Statistics' => 'Statistik',
        'Status view' => 'Paparan statistik',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => 'Menyimpan cookies selepas browser telah ditutup.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Melucutkan barisan kosong pada previu tiket dalam paparan aturan.',
        'Templates <-> Queues' => '',
        'Textarea' => 'Textarea',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            'The "bin / PostMasterMailAccount.pl" akan menyambung semula ke hos POP3/POP3S/IMAP/IMAPS selepas kiraan tertentu mesej.',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'Kulit InternalName ejen yang patut digunakan dalam paparan ejen. Sila semak kulit yang tersedia dalam Frontend::Agent::Skins.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'Kulit InternalName pelanggan yang patut digunakan dalam paparan pelanggan. Sila semak kulit yang tersedia dalam Frontend::Customer::Skins.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'Pemisah diantara TicketHook dan nombor tiket. Cth: \':\'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'Tempoh dalam beberapa minit selepas mengeluarkan sesuatu acara, di mana peningkatan yang baru dan mula memberitahu peristiwa-peristiwa yang ditindas.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            'Format untuk subjek. \'Kiri\' means \'[TicketHook#:12345] Sesuatu Subjek\', \'Kanan\' means \'Sesuatu Subjek [TicketHook#:12345]\', \'None\' means \'Sesuatu Subjek\' dan tiada nombor tiket. Dalam hal yang terakhir anda perlu mengaktifkan PostmasterFollowupSearchInRaw atau PostmasterFollowUpSearchInReferences untuk mengenali susulan berdasarkan tauk emel dan/atau body.',
        'The headline shown in the customer interface.' => 'Headline ditunjukkan dalam paparan pelanggan.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'Pengecam untuk tiket, cth: Ticket#, Call#, MyTicket#. Default ialah Ticket#.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Logo ditunjukkan dalam header paparan ejen. URL kepada imej boleh relatif kepada direktori kulit imej, atau URL penuh ke server web jauh.',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Logo ditunjukkan dalam header paparan pelanggan. URL kepada imej boleh relatif kepada direktori kulit imej, atau URL penuh ke server web jauh.',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            'Logo ditunjukkan diatas kotak log masuk dari paparan ejen. URL kepada imej mesti URL relatif kepada direktori kulit imej.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Teks pada permulaan subjek dalam emel balas, cth: RE, AW, atau AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Teks pada permulaan subjek dalam emel dikehadapankan, cth: FW, Fwd, atau WG.',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Modul ini dan fungsi PreRun() akan dilaksanankan, jika ditakrifkan, untuk setiap permintaan. Modul ini berguna untuk semak beberapa pilihan pengguna atau untuk mempamerkan berita mengenai aplikasi baru.',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            'Tetapan ini membolehkan anda untuk mengatasi senarai negara yang dibina dalam sistem dengan senarai negara anda sendiri. Ini berguna khususnya jika anda hanya mahu menggunakan kumpulan kecil negara.',
        'Ticket Queue Overview' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            'Modul acara tiket yang mencetuskan lambungan hentian acara..',
        'Ticket overview' => 'Overview tiket',
        'TicketNumber' => '',
        'Tickets' => 'Tiket',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Masa dalam saat yang dapat menambah ke masa sebenar jika menetapkan keadaan tertangguh (default: 86400 = 1 hari).',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Bertukar-tukar paparan senarai OTRS FeatureAddons dalam PackageManager.',
        'Toolbar Item for a shortcut.' => 'Item Toolbar untuk jalan pintas.',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            'Menghidupkan animasi digunakan dalam GUI. Jika anda ada masalah dengan animasi ini (cth: isu prestasi), anda boleh mematikannya di sini.',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'Menghidupkan penyemak alamat ip jauh. Ia sepatutnya ditetapkan ke "No", jika aplikasi tersebtu digunakan, sebagai contoh, melalui ladang proksi atau sambungan dialup, kerana alamat ip jauh kebanyakannya erbeza untuk permintaan tersebut.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Naik taraf bendera "Seen" tiket jika setiap artikel telah dilihat atau Artikel baru telah dicipta.',
        'Update and extend your system with software packages.' => 'Naik taraf dan kembangkan sistem anda dengan pakej perisian.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Naik tarah indeks lambungan tiket selepas atribut tiket dinaik taraf.',
        'Updates the ticket index accelerator.' => 'Naik taraf pemecut indeks tiket.',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            'Menggunakan penerima Cc dalam senarai balas Cc pada karangan jawapan email dalam skrin karang tiket pada paparan ejen.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Melihat hasil penanda aras prestasi.',
        'View system log messages.' => 'Melihat mesej log sistem.',
        'Wear this frontend skin' => 'Guna kulit frontend ini.',
        'Webservice path separator.' => 'Pemisah laluan Webservice.',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Apabila tiket digabungkan, pelanggan boleh diberitahu setiap e-mel dengan menetapkan kotak semak "Memaklumkan Penghantar". Dalam kawasan teks ini, anda boleh menentukan teks pra-format yang kemudiannya boleh diubah suai oleh ejen.',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Pilihan aturan kegemaran anda. Anda juga dinotifikasikan mengenai aturan tersebut melalui emel jika diaktifkan.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        '","18' => '","18',
        '","26' => '","26',
        '","30' => '","30',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            'Sambutan adalah teks lalai yang membantu ejen anda untuk menulis jawapan yang lebih cepat kepada pelanggan.',
        'Add Customer Company' => 'Tambah syarikat',
        'Add Response' => 'Tambah Tindak Balas',
        'Add customer company' => 'Tambah syarikat',
        'Add response' => 'Tambah jawapan',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            'Tambah alamat emel pelanggan kepada penerima dalam skrin mengarang tiket dalam interface ejen.',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Membolehkan keadaan carian diperluaskan di dalam pencarian tiket dalam interface ejen. Dengan fungsi ini, anda boleh tetapkan carian menggunakan kondisi seperti "(key1&&key2)" atau "(key1||key2)".',
        'Attachments <-> Responses' => 'Lampiran <-> Tindak Balas',
        'Change Attachment Relations for Response' => 'Tukar Perhubungan Attachment untuk Tindak Balas',
        'Change Queue Relations for Response' => 'Tukar Perhubungan Barisan untuk Tindak Balas',
        'Change Response Relations for Attachment' => 'tindak balas tugasan untuk perubahan sistem',
        'Change Response Relations for Queue' => 'Tukar Perhubungan Tindak Balas untuk Barisan',
        'Companies' => 'Syarikat',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            'Nama syarikat untuk interface web pelanggan. Juga akan disertakan di dalam emel sebagai X-header.',
        'Complete registration and continue' => 'Lengkapkan pendaftaran dan teruskan.',
        'Configures the full-text index. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            'Mengkonfigurasi indeks teks penuh. Melaksanakan "bin / otrs.RebuildFulltextIndex.pl" untuk menjana indeks baru.',
        'Create and manage companies.' => 'Mewujudkan dan menguruskan syarikat.',
        'Create and manage response templates.' => 'Mewujudkan dan menguruskan templat tindak balas.',
        'Currently only MySQL is supported in the web installer.' => 'Kini hanya MySQL disokong pada pemasangan Web.',
        'Customer Company Management' => 'Pelanggan syarikat pengurusan',
        'Customer Data' => 'Data pelanggan',
        'Customer automatically added in Cc.' => 'Pelanggan secara automatik ditambah pada Cc.',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Pelanggan dikehendaki untuk menyediakan sejarah pelanggan dan untuk pengisytiharan akses pelanggan.',
        'Customers <-> Services' => 'Pelanggan <-> Perkhidmatan',
        'DB--- host' => 'Hos DB---',
        'DEPRECATED! This setting is not used any more and will be removed in a future version of OTRS.' =>
            'DIKECAM! Penetapan ini tidak digunakan lagi dan akan dikeluarkan dalam OTRS versi masa depan.',
        'Database-User' => 'Pengguna database',
        'Default skin for interface.' => 'Kulit asal untuk paparan.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            'Mentakrifkan tema hadapan-hujung asal (HTML) untuk digunakan oleh ejen dan pelanggan. Tema asal adalah Standard dan Lite. Jika anda suka, anda boleh menambah tema anda sendiri. Sila rujuk manual pentadbir yang terletak di http://doc.otrs.org/.',
        'Defines the default sender type of the article for this operation.' =>
            'Mentakrifkan jenis penghantar asal untuk artikel operasi ini.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, DynamicField_Field1StartYear=2002; DynamicField_Field1StartMonth=12; DynamicField_Field1StartDay=12; DynamicField_Field1StartHour=00; DynamicField_Field1StartMinute=00; DynamicField_Field1StartSecond=00; DynamicField_Field1StopYear=2009; DynamicField_Field1StopMonth=02; DynamicField_Field1StopDay=10; DynamicField_Field1StopHour=23; DynamicField_Field1StopMinute=59; DynamicField_Field1StopSecond=59;.' =>
            'Mentakrifkan sifat pencarian tiket yang ditunjuk yang asal untuk skrin carian tiket. Contoh: a text, 1, DynamicField_Field1StartYear=2002; DynamicField_Field1StartMonth=12; DynamicField_Field1StartDay=12; DynamicField_Field1StartHour=00; DynamicField_Field1StartMinute=00; DynamicField_Field1StartSecond=00; DynamicField_Field1StopYear=2009; DynamicField_Field1StopMonth=02; DynamicField_Field1StopDay=10; DynamicField_Field1StopHour=23; DynamicField_Field1StopMinute=59; DynamicField_Field1StopSecond=59;.',
        'Defines the default sort criteria for all queues displayed in the queue view, after sort by priority is done.' =>
            'Mentakrifkan kriteria susunan asal untuk kesemua aturan yang dipamerkan dalam paparan aturan, selepas susunan berdasarkan keutamaan telah dilakukan.',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
            'Mentakrifkan saiz maksima (dalam bytes) untuk muat naik fail menggunakan browser.',
        'Defines the module to display a notification in the agent interface, (only for agents on the admin group) if the scheduler is not running.' =>
            'Mentakrifkan modul untuk mempamerkan notifikasi dalam paparan ejen, (hanya untuk ejen dalam kumpulan admin) jika penjadual tidak aktif.',
        'Defines the system identifier. Every ticket number and http session string contain this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'Mentakrifkan pengecam sistem. Setiap nomnor tiekt dan rangkaian sesi http mengandungi ID ini. Ini memastikan hanya tiket yang dimiliki sistem anda akan diproses sebagai susulan (berguna semasa komunikasi antara dua keadaan OTRS).',
        'Defines the type of protocol, used by ther web server, to serve the application. If https protocol will be used instead of plain http, it must be specified it here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Mentakrifkan jenis protokol, digunakan oleh web server, untuk berkhidmat kepada aplikasi. jika protokol https akan digunakan dan bukannya http kosong, ia perlu dinyatakan di sini. Memandangkan ini tidak memberi pengaruh kepada tetapan atau kelakuan web server,ia tidak akan mengubah kaedah akses untuk aplikasi dan, jika ia salah, ia tidak akan menghalang anda dari log masuk ke dalam aplikasi. Tetapan ini digunakan sebagai pembolehubah, OTRS_CONFIG HttpType dimana dijumpai dalam semua bentuk mesej digunakan oleh aplikasi, untuk membina pautan kepada tiket di dalam sistem anda.',
        'Defines which article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            'Mentakrifkan jenis artikel yang mana harus di kembangkan semasa memasuki overview. Jika tiada yang ditakrifkan, arikel yang terkini akan di kembangkan.',
        'Delay time between autocomplete queries in milliseconds.' => 'Menangguhkan masa antara aturan autolengkap dalam milisaat.',
        'Determines if the search results container for the autocomplete feature should adjust its width dynamically.' =>
            'Menetukan jika bekas hasil carian untuk fungsi autocomplete perlu menyusuaikan keberannya secara dinamik.',
        'Did not find a required feature? OTRS Group provides their subscription customers with exclusive Add-Ons:' =>
            'Tidak mencari ciri-ciri yang diperlukan? OTRS Kumpulan menyediakan pelanggan langganan mereka dengan eksklusif Tambahan:',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box (to avoid the use of destructive queries, such as DROP DATABASE, and also to steal user passwords).' =>
            'Lumpuhkan pemasangan web (http://hostanda.contoh.com/otrs/installer.pl), untuk megelakkan dari sistem diceroboh. Jika di set ke "No", sistem akan dipasangkan semula dan konfigurasi asas semasa akan digunakan untuk pra-mengisi soalan dalam skrip pemasangan. Jika tidak aktif, ia juga akan lumpuhkan GenericAgent, PackageManager dan kotak SQL (untuk mengelakkan penggunaan queries yang merosakkan, seperti DROP DATABASE, dan juga untuk mencuri katalaluan pengguna).',
        'Don\'t forget to add new responses to queues.' => 'Jangan lupa untuk menambah maklum balas yang baru untuk barisan!',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###AttributesView.' =>
            'Pilihan Medan Dinamik ditunjukkan dalam skrin mesej tiket dari paparan pelanggan. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan, 2 = Diaktifkan dan Diperlukan. Jika anda mahu mempamerkan medan ini juga dalam zum tiket dari paparan pelanggan, anda perlu untuk aktifkan mereka dalam CustomerTicketZoom###AttributesView.',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Medan Dinamik ditunjukkan dalam skrin carian tiket dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan.',
        'Dynamic fields shown in the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Medan Dinamik ditunjukkan dalam skrin tiket zum dari paparan ejen. Tetapan Kemungkinan: 0 = Dilumpuhkan, 1 = Diaktifkan.',
        'Edit Response' => 'Edit Tindak Balas',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Mengaktifkan sokongan PGP. Apabila sokongan PGP diaktifkan untuk menandatangani dan mendapatkan mel, sangat disranakan web server dijalankan sebagai pengguna OTRS. Jika tidak, akan muncul masalah dengan hak istimewa semasa mengakses folder .gnupg.',
        'Enables or disables the autocomplete feature for the customer search in the agent interface.' =>
            'Mengaktifkan atau melumpuhkan fungsi autolengkap untuk carian pelanggan dalam paparan ejen.',
        'Escalation in' => 'Maklum balas dalam',
        'Event list to be displayed on GUI to trigger generic interface invokers.' =>
            'Senarai acara untuk dipamerkan dalam GUI untuk mencetus pencetus paparan generic.',
        'Example for free text' => 'Contoh untuk teks bebas',
        'Experimental "Slim" skin which tries to save screen space for power users.' =>
            'Kulit uji kaji "Slim" yang cuba untuk menyelamatkan ruang skrin untuk pengguna berkuasa.',
        'False' => 'Salah',
        'Filter for Responses' => 'Menapis Tindak Balas',
        'Filter name' => 'nama penapis',
        'For more info see:' => 'Untuk maklumat lanjut lihat:',
        'From customer' => 'Dari pelanggan',
        'If "DB" was selected for SessionModule, a column for the identifiers in session table must be specified.' =>
            'Jika "DB" dipilih untuk SessionModule, kolum untuk pengecam dalam jadual sesi mesti ditentukan.',
        'If "DB" was selected for SessionModule, a column for the values in session table must be specified.' =>
            'Jika "DB" dipilih untuk SessionModule, kolum untuk nilai di dallam jadual sesi mesti ditentukan.',
        'If enabled, the OTRS version tag will be removed from the HTTP headers.' =>
            'Jika diaktifkan, tag versi OTRS akan dibuang daripada HTTP headers.',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Jika kata laluan akar telah ditetapkan untuk pangkalan data, ia mesti dimasukkan di sini. Jika tiada password yang ditetapkan, bidang mesti ditinggalkan kosong. Atas sebab-sebab keselamatan, kami mencadangkan untuk menetapkan kata laluan akar. Untuk maklumat lanjut, lihat dokumentasi untuk pangkalan data anda.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Jika anda ingin memasang OTRS pada pangkalan data lain, sila baca fail README.database.',
        'Invalid SessionID!' => 'IDSesi tidak sah!',
        'Link attachments to responses templates.' => 'Pautan lampiran kepada templat tindak balas.',
        'Link customers to groups.' => 'Pautan pelanggan kepada kumpulan.',
        'Link customers to services.' => 'Pautan pelanggan kepada perkhidmatan.',
        'Link responses to queues.' => 'Pautan tindak balas kepada aturan.',
        'List of IE6-specific CSS files to always be loaded for the customer interface.' =>
            'Senarai fail IE6-specific CSS untuk sentiasa dimuatkan untuk paparan pelanggan.',
        'List of IE7-specific CSS files to always be loaded for the customer interface.' =>
            'Senarai fail IE7-specific CSS untuk sentiasa dimuatkan untuk paparan pelanggan.',
        'List of default StandardResponses which are assigned automatically to new Queues upon creation.' =>
            'Senarai StandardResponses default yang ditugaskan secara automatik kepada aturan baru di saat penciptaan.',
        'Log file location is only needed for File-Log-Backend Module!' =>
            'Lokasi log fail hanya diperlukan untuk modul Fail-Log-Backend!',
        'Logout successful. Thank you for using OTRS!' => 'Log keluar berjaya! Terima kasih kerana menggunakan OTRS!',
        'Manage Response-Queue Relations' => 'Mengurus Perhubungan Tindak Balas-Barisan',
        'Manage Responses' => 'mengurus Tindak Balas',
        'Manage Responses <-> Attachments Relations' => 'Urus Tindak Balas <-> lampiran Perhubungan',
        'Manage periodic tasks.' => 'Mengurus tugas yang berkala.',
        'Maximum size (in characters) of the customer info table in the queue view.' =>
            'Saiz maksimum (dalam aksara) dari jadual maklumat pelanggan dalam paparan aturan.',
        'Need a valid email address or don\'t use a local email address' =>
            'Perlukan alamat emel yang sah atau jangan menggunakan alamat emel tempatan.',
        'Package verification failed!' => 'Pengesahan pakej gagal',
        'Parameter for the CustomQueue object in the preference view of the agent interface.' =>
            'Parameter untuk objek CustomQueue dalam paparan pilihan dari paparan ejen.',
        'Password is required.' => 'Kata laluan diperlukan.',
        'Please enter a search term to look for customer companies.' => 'Sila masukkan kata kunci untuk mencari sebuah syarikat.',
        'Please fill in all fields marked as mandatory.' => 'Sila lengkapkan semua medan yang diperlukan.',
        'Please supply a' => 'Sila bekalkan',
        'Please supply a first name' => 'Sila bekalkan nama pertama anda',
        'Please supply a last name' => 'Sila bekalkan nama akhir anda',
        'Position' => 'Posisi',
        'Registration' => 'Pendaftaran',
        'Responses' => 'Tindak Balas',
        'Responses <-> Queues' => 'Tindak Balas <-> Aturan',
        'Saves the login and password on the session table in the database, if "DB" was selected for SessionModule.' =>
            'Menyimpan login dan kata laluan di atas meja sesi dalam pangkalan data, jika "DB" telah dipilih untuk SessionModule.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'Mod selamat mesti dilumpuhkan untuk memasang semula menggunakan web-pemasang.',
        'Sender type for new tickets from the customer interface.' => 'Jenis penghantar untuk tiket baru daripada paparan pelanggan.',
        'Sets the minimum number of characters before autocomplete query is sent.' =>
            'Tetapkan jumlah aksara minimum sebelum aturan autocompete dihantar.',
        'Sets the number of search results to be displayed for the autocomplete feature.' =>
            'Tetapkan jumlah hasil carian untuk dipamerkan untuk fungsi autocomplete.',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            'Jika anda melangkau langkah ini, pendaftaran sistem OTRS anda juga dilangkau. Anda benar-benar mahu meneruskan?',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuration, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Menentukan alamat e-mel yang boleh digunakan oleh aplikasi apabila menghantar notifikasi. Alamat e-mel yang digunakan untuk membina nama paparan lengkap untuk master notifikasi (iaitu "OTRS Notification Master" otrs@your.example.com). Anda boleh menggunakan OTRS_CONFIG_FQDN pembolehubah seperti yang dinyatakan dalam konfigurasi anda, atau memilih alamat e-mel yang lain. Notifikasi adalah mesej seperti en::Customer::QueueUpdate atau en::Agent::Move.',
        'To customer' => 'Kepada Pelanggan',
        'To protect your privacy, active or/and remote content has blocked.' =>
            'Untuk melindungi privasi anda, aktif dan / atau kandungan jauh telah disekat.',
        'URL' => 'URL',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            'Menggunakan richtet untuk melihat dan menyunting: artikel, Ucapan Hormat, Tandatangan, tindak balas standard, tindak balas auto dan notifikasi.',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            'Apabila tiket digabungkan, nota akan ditambah secara automatik untuk tiket yang tidak lagi aktif. Dalam kawasan teks ini, anda boleh menentukan teks ini (Teks ini tidak boleh diubah oleh ejen itu).',
        'Your language' => 'Bahasa anda',
        'before' => 'sebelum',
        'default \'hot\'' => 'asal \'hot\'',
        'settings' => 'tetapan',

    };
    # $$STOP$$
    return;
}

1;
