# --
# Kernel/Language/pt_BR.pm - provides pt_BR language translation
# Copyright (C) 2003 Gilberto Cezar de Almeida <gibalmeida at hotmail.com>
# --
# $Id: pt_BR.pm,v 1.20 2005-02-23 10:04:21 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::pt_BR;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.20 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Aug 24 10:11:30 2004 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 minutos',
      ' 5 minutes' => ' 5 minutos',
      ' 7 minutes' => ' 7 minutos',
      '(Click here to add)' => '',
      '...Back' => '',
      '10 minutes' => '10 minutos',
      '15 minutes' => '15 minutos',
      'Added User "%s"' => '',
      'AddLink' => 'Adicionar link',
      'Admin-Area' => 'Área de Administração',
      'agent' => '',
      'Agent-Area' => '',
      'all' => 'todos',
      'All' => 'Todos',
      'Attention' => 'Atenção',
      'Back' => 'Retornar',
      'before' => '',
      'Bug Report' => 'Relatório de Erros',
      'Calendar' => '',
      'Cancel' => 'Cancelar',
      'change' => 'alterar',
      'Change' => 'Alterar',
      'change!' => 'alterar!',
      'click here' => 'clique aqui',
      'Comment' => 'Comentário',
      'Contract' => '',
      'Crypt' => '',
      'Crypted' => '',
      'Customer' => 'Cliente',
      'customer' => '',
      'Customer Info' => 'Informáção do Cliente',
      'day' => 'dia',
      'day(s)' => '',
      'days' => 'dias',
      'description' => 'descrição',
      'Description' => 'Descrição',
      'Directory' => '',
      'Dispatching by email To: field.' => 'Despachar pelo campo de email To:',
      'Dispatching by selected Queue.' => 'Despachar pela fila selecionada',
      'Don\'t show closed Tickets' => '',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Não trabalhe com o Identificador de Usuário 1(Conta do Sistema)! Crie novos usuários!',
      'Done' => 'Feito',
      'end' => 'fim',
      'Error' => 'Erro',
      'Example' => 'Exemplo',
      'Examples' => 'Exemplos',
      'Facility' => 'Facilidade',
      'FAQ-Area' => '',
      'Feature not active!' => 'Característica não ativada!',
      'go' => 'ir',
      'go!' => 'ir!',
      'Group' => 'Grupo',
      'History::AddNote' => 'Added note (%s)',
      'History::Bounce' => 'Bounced to "%s".',
      'History::CustomerUpdate' => 'Updated: %s',
      'History::EmailAgent' => 'Email sent to customer.',
      'History::EmailCustomer' => 'Added email. %s',
      'History::FollowUp' => 'FollowUp for [%s]. %s',
      'History::Forward' => 'Forwarded to "%s".',
      'History::Lock' => 'Locked ticket.',
      'History::LoopProtection' => 'Loop-Protection! No auto-response sent to "%s".',
      'History::Misc' => '%s',
      'History::Move' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
      'History::NewTicket' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
      'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
      'History::PhoneCallAgent' => 'Agent called customer.',
      'History::PhoneCallCustomer' => 'Customer called us.',
      'History::PriorityUpdate' => 'Changed priority from "%s" (%s) to "%s" (%s).',
      'History::Remove' => '%s',
      'History::SendAgentNotification' => '"%s"-notification sent to "%s".',
      'History::SendAnswer' => 'Email sent to "%s".',
      'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
      'History::SendAutoReject' => 'AutoReject sent to "%s".',
      'History::SendAutoReply' => 'AutoReply sent to "%s".',
      'History::SendCustomerNotification' => 'Notification sent to "%s".',
      'History::SetPendingTime' => 'Updated: %s',
      'History::StateUpdate' => 'Old: "%s" New: "%s"',
      'History::TicketFreeTextUpdate' => 'Updated: %s=%s;%s=%s;',
      'History::TicketLinkAdd' => 'Added link to ticket "%s".',
      'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',
      'History::TimeAccounting' => '%s time unit(s) accounted. Now total %s time unit(s).',
      'History::Unlock' => 'Unlocked ticket.',
      'History::WebRequestCustomer' => 'Customer request via web.',
      'History::SystemRequest' => 'System Request (%s).',
      'Hit' => 'Hit',
      'Hits' => 'Hits',
      'hour' => 'hora',
      'hours' => 'horas',
      'Ignore' => 'Ignorar',
      'invalid' => 'inválido',
      'Invalid SessionID!' => 'Identificação de Sessão Inválida',
      'Language' => 'Idioma',
      'Languages' => 'Idiomas',
      'last' => '',
      'Line' => 'Linha',
      'Lite' => 'Lite',
      'Login failed! Your username or password was entered incorrectly.' => 'Identificação incorreta! Seu nome de usuário ou senha foram informadas incorretamentes.',
      'Logout successful. Thank you for using OTRS!' => 'Desconexão com sucesso. Obrigado por utilizar o OTRS!',
      'Message' => 'Mensagem',
      'minute' => 'minuto',
      'minutes' => 'minutos',
      'Module' => 'Módulo',
      'Modulefile' => 'Arquivo de Módulo',
      'month(s)' => '',
      'Name' => 'Nome',
      'New Article' => '',
      'New message' => 'Nova mensagem',
      'New message!' => 'Nova mensagem!',
      'Next' => '',
      'Next...' => '',
      'No' => 'Não',
      'no' => 'nenhuma',
      'No entry found!' => '',
      'No Permission!' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => '',
      'No suggestions' => 'Sem sugestões',
      'none' => 'nada',
      'none - answered' => 'nada  - respondido',
      'none!' => 'nada!',
      'Normal' => '',
      'off' => 'desligado',
      'Off' => 'Desligado',
      'On' => 'Ligado',
      'on' => 'ligado',
      'Online Agent: %s' => '',
      'Online Customer: %s' => '',
      'Password' => 'Senha',
      'Passwords dosn\'t match! Please try it again!' => '',
      'Pending till' => 'Gaveta pendente',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Por favor, responda este(s) bilhete(s) para retornar para visão normal da fila!',
      'Please contact your admin' => 'Por favor, contate seu administrador',
      'please do not edit!' => 'Por favor, não edite!',
      'possible' => 'possível',
      'Preview' => '',
      'QueueView' => 'Fila',
      'reject' => 'rejeitar',
      'replace with' => 'substituir com',
      'Reset' => 'Re-iniciar',
      'Salutation' => 'Saudação',
      'Session has timed out. Please log in again.' => '',
      'Show closed Tickets' => '',
      'Sign' => '',
      'Signature' => 'Assinatura',
      'Signed' => '',
      'Size' => '',
      'Sorry' => 'Desculpe',
      'Stats' => 'Estatísticas',
      'Subfunction' => 'Sub-função',
      'submit' => 'Enviar',
      'submit!' => 'Enviar!',
      'system' => '',
      'Take this Customer' => '',
      'Take this User' => '',
      'Text' => 'Texto',
      'The recommended charset for your language is %s!' => 'O conjunto de caracteres recomendado para o seu idioma é %s!',
      'Theme' => 'Tema',
      'There is no account with that login name.' => 'Não existe conta com este nome de usuário',
      'Ticket Number' => '',
      'Timeover' => 'Tempo esgotado',
      'To: (%s) replaced with database email!' => '',
      'top' => 'início',
      'Type' => 'Tipo',
      'update' => 'atualizar',
      'Update' => '',
      'update!' => 'atualizar!',
      'Upload' => '',
      'User' => 'Usuário',
      'Username' => 'Nome de Usuário',
      'Valid' => 'Válido',
      'Warning' => 'Aviso',
      'week(s)' => '',
      'Welcome to OTRS' => 'Bem-vindo ao OTRS',
      'Word' => 'Palavra',
      'wrote' => 'escreveu',
      'year(s)' => '',
      'Yes' => 'Sim',
      'yes' => 'sim',
      'You got new message!' => 'Você recebeu uma nova mensagem',
      'You have %s new message(s)!' => 'Você tem %s nova(s) mensagem(s)!',
      'You have %s reminder ticket(s)!' => 'Você tem %s bilhete(s) remanescente(s)',

    # Template: AAAMonth
      'Apr' => 'Abr',
      'Aug' => 'Ago',
      'Dec' => 'Dec',
      'Feb' => 'Fev',
      'Jan' => 'Jan',
      'Jul' => 'Jul',
      'Jun' => 'Jun',
      'Mar' => 'Mar',
      'May' => 'Mai',
      'Nov' => 'Nov',
      'Oct' => 'Out',
      'Sep' => 'Set',

    # Template: AAAPreferences
      'Closed Tickets' => '',
      'CreateTicket' => '',
      'Custom Queue' => 'Fila Personalizada',
      'Follow up notification' => 'Notificação de continuação',
      'Frontend' => 'Interface',
      'Mail Management' => 'Gerênciamento de Correios',
      'Max. shown Tickets a page in Overview.' => '',
      'Max. shown Tickets a page in QueueView.' => '',
      'Move notification' => 'Notificação de movimentos',
      'New ticket notification' => 'Notificação de novo bilhete',
      'Other Options' => 'Outras Opções',
      'PhoneView' => 'Chamada',
      'Preferences updated successfully!' => 'Preferências atualizadas com sucesso!',
      'QueueView refresh time' => 'Tempo de atualização das Filas',
      'Screen after new ticket' => '',
      'Select your default spelling dictionary.' => '',
      'Select your frontend Charset.' => 'Selecione o Conjunto de Caracteres da sua Interface .',
      'Select your frontend language.' => 'Selecione o Idioma da sua Interface.',
      'Select your frontend QueueView.' => 'Selecione a Visão da Fila da sua Interface.',
      'Select your frontend Theme.' => 'Selecione o Tema da sua Interface.',
      'Select your QueueView refresh time.' => 'Selecione o tempo de atualização das Filas',
      'Select your screen after creating a new ticket.' => '',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Notifique me se um cliente enviar uma continuação e sou o dono do bilhete.',
      'Send me a notification if a ticket is moved into one of "My Queues".' => '',
      'Send me a notification if a ticket is unlocked by the system.' => 'Notifique me se um bilhete é desbloqueado pelo sistema.',
      'Send me a notification if there is a new ticket in "My Queues".' => '',
      'Show closed tickets.' => '',
      'Spelling Dictionary' => '',
      'Ticket lock timeout notification' => 'Notificação de bloqueio por tempo expirado',
      'TicketZoom' => '',

    # Template: AAATicket
      '1 very low' => '1 muito baixo',
      '2 low' => '2 baixo',
      '3 normal' => '3 normal',
      '4 high' => '4 alto',
      '5 very high' => '5 muito alto',
      'Action' => 'Ação',
      'Age' => 'Idade',
      'Article' => 'Artigo',
      'Attachment' => 'Anexo',
      'Attachments' => 'Anexos',
      'Bcc' => 'Copia Invisível',
      'Bounce' => 'Devolver',
      'Cc' => 'Cópia ',
      'Close' => 'Fechar',
      'closed' => '',
      'closed successful' => 'fechado com êxito',
      'closed unsuccessful' => 'fechado sem êxito',
      'Compose' => 'Compôr',
      'Created' => 'Criado',
      'Createtime' => 'Hora de criação',
      'email' => 'email',
      'eMail' => 'eMail',
      'email-external' => 'email-externo',
      'email-internal' => 'email-interno',
      'Forward' => 'Encaminhar',
      'From' => 'De',
      'high' => 'alto',
      'History' => 'Histórico',
      'If it is not displayed correctly,' => 'Se ele não for exibido corretamente,',
      'lock' => '',
      'Lock' => 'Bloquear',
      'low' => 'baixo',
      'Move' => 'Mover',
      'new' => 'novo',
      'normal' => 'normal',
      'note-external' => 'nota-externa',
      'note-internal' => 'nota-interna',
      'note-report' => 'nota-relatório',
      'open' => 'aberto',
      'Owner' => 'Proprietário',
      'Pending' => 'Pendentes',
      'pending auto close+' => 'pendente auto fechamento+',
      'pending auto close-' => 'pendente auto fechamento-',
      'pending reminder' => 'lembrete de pendente',
      'phone' => 'telefone',
      'plain' => 'texto',
      'Priority' => 'Prioridade',
      'Queue' => 'Fila',
      'removed' => 'removido',
      'Sender' => 'Remetente',
      'sms' => 'sms',
      'State' => 'Estado',
      'Subject' => 'Assunto',
      'This is a' => 'Este é um',
      'This is a HTML email. Click here to show it.' => 'Esta é um email HTML. Clique aqui para exibi-lo.',
      'This message was written in a character set other than your own.' => 'Esta mensagem foi escrita utilizando um conjunto de caracteres diferente do seu.',
      'Ticket' => 'Bilhete',
      'Ticket "%s" created!' => '',
      'To' => 'Para',
      'to open it in a new window.' => 'para abri-lo em uma nova janela.',
      'Unlock' => 'Desbloquear',
      'unlock' => 'desbloquear',
      'very high' => 'muito alto',
      'very low' => 'muito baixo',
      'View' => 'Ver',
      'webrequest' => 'Solicitar via web',
      'Zoom' => 'Detalhes',

    # Template: AAAWeekDay
      'Fri' => 'Sex',
      'Mon' => 'Seg',
      'Sat' => 'Sab',
      'Sun' => 'Dom',
      'Thu' => 'Qui',
      'Tue' => 'Ter',
      'Wed' => 'Qua',

    # Template: AdminAttachmentForm
      'Add' => '',
      'Attachment Management' => 'Gerênciamento de Anexos',

    # Template: AdminAutoResponseForm
      'Auto Response From' => 'Auto-Resposta De',
      'Auto Response Management' => 'Gerênciamento de Auto-Respostas',
      'Note' => 'Nota',
      'Response' => 'Resposta',
      'to get the first 20 character of the subject' => 'para obter os 20 primeiros caracteres do assunto',
      'to get the first 5 lines of the email' => 'para obter as 5 primeiras linhas do email',
      'to get the from line of the email' => 'para obter a linha "From" do email',
      'to get the realname of the sender (if given)' => 'para obter o nome do remetente (se possuir no email)',
      'to get the ticket id of the ticket' => '',
      'to get the ticket number of the ticket' => 'para obter o número do bilhete',
      'Useable options' => 'Opções acessíveis',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Gerênciamento de Clientes',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => '',
      'Result' => '',
      'Search' => '',
      'Search for' => '',
      'Select Source (for add)' => '',
      'Source' => '',
      'The message being composed has been closed.  Exiting.' => 'A mensagem sendo composta foi fechada. Saindo.',
      'This values are read only.' => '',
      'This values are required.' => '',
      'This window must be called from compose window' => 'Esta janela deve ser chamada da janela de composição',

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Modificar %s configurações',
      'Customer User <-> Group Management' => '',
      'Full read and write access to the tickets in this group/queue.' => '',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
      'Permission' => '',
      'Read only access to the ticket in this group/queue.' => '',
      'ro' => '',
      'rw' => '',
      'Select the user:group permissions.' => '',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Modificar as configurações de usuários <-> grupos',

    # Template: AdminEmail
      'Admin-Email' => 'Email do Admin.',
      'Body' => 'Corpo',
      'OTRS-Admin Info!' => 'Informação do Administrador do OTRS!',
      'Recipents' => 'Destinatários',
      'send' => '',

    # Template: AdminEmailSent
      'Message sent to' => 'Mensagem enviada para',

    # Template: AdminGenericAgent
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      '(e. g. U5150)' => '',
      '-' => '',
      'Add Note' => 'Adicionar Nota',
      'Agent' => '',
      'and' => '',
      'CMD' => '',
      'Customer User Login' => '',
      'CustomerID' => 'Id.do Cliente',
      'CustomerUser' => 'Usuário Cliente',
      'Days' => '',
      'Delete' => '',
      'Delete tickets' => '',
      'Edit' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      'GenericAgent' => '',
      'Hours' => '',
      'Job-List' => '',
      'Jobs' => '',
      'Last run' => '',
      'Minutes' => '',
      'Modules' => '',
      'New Agent' => '',
      'New Customer' => '',
      'New Owner' => '',
      'New Priority' => '',
      'New Queue' => '',
      'New State' => '',
      'New Ticket Lock' => '',
      'No time settings.' => '',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Save' => '',
      'Save Job as?' => '',
      'Schedule' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Ticket created' => '',
      'Ticket created between' => '',
      'Ticket Lock' => '',
      'TicketFreeText' => '',
      'Times' => '',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => '',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Crie novos grupos para manipular as permissões de acesso para diferentes grupos de agentes (exemplos: departamento de compras, departamento de suporte, departamento de vendas, etc...).',
      'Group Management' => 'Gerênciamento de Grupos',
      'It\'s useful for ASP solutions.' => 'Isto é útil para soluções ASP.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'O grupo admin é para uso na área de administração e o grupo stats é para uso na área de estatísticas.',

    # Template: AdminLog
      'System Log' => 'Registro do Sistema',
      'Time' => '',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Email do Administrador',
      'Attachment <-> Response' => '',
      'Auto Response <-> Queue' => 'Auto-Respostas <-> Filas',
      'Auto Responses' => 'Auto-Respostas',
      'Customer User' => 'Cliente',
      'Customer User <-> Groups' => '',
      'Email Addresses' => 'Endereços de Emails',
      'Groups' => 'Grupos',
      'Logout' => 'Desconectar-se',
      'Misc' => 'Variedades',
      'Notifications' => '',
      'PGP Keys' => '',
      'PostMaster Filter' => '',
      'PostMaster POP3 Account' => 'PostMaster Conta POP3',
      'Responses' => 'Respostas',
      'Responses <-> Queue' => 'Respostas <-> Filas',
      'Role' => '',
      'Role <-> Group' => '',
      'Role <-> User' => '',
      'Roles' => '',
      'Select Box' => 'Caixa de Seleção',
      'Session Management' => 'Gerênciamento de Sessões',
      'SMIME Certificates' => '',
      'Status' => '',
      'System' => 'Sistema',
      'User <-> Groups' => 'Usuários <-> Grupos',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
      'Notification Management' => '',
      'Notifications are sent to an agent or a customer.' => '',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',

    # Template: AdminPGPForm
      'Bit' => '',
      'Expires' => '',
      'File' => '',
      'Fingerprint' => '',
      'FIXME: WHAT IS PGP?' => '',
      'Identifier' => '',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Key' => 'Chave',
      'PGP Key Management' => '',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Todos os emails de entrada com uma conta será despachado na fila selecionada!',
      'Dispatching' => 'Despachando',
      'Host' => '',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',
      'POP3 Account Management' => 'Gerênciamento de Contas POP3',
      'Trusted' => 'Confiável',

    # Template: AdminPostMasterFilter
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'Filtername' => '',
      'Header' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',
      'Match' => '',
      'PostMaster Filter Management' => '',
      'Set' => '',
      'Value' => '',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Gerênciamento de Filas <-> Auto-Resposta',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = sem escalação',
      '0 = no unlock' => '0 = sem desbloqueio',
      'Customer Move Notify' => '',
      'Customer Owner Notify' => '',
      'Customer State Notify' => '',
      'Escalation time' => 'Tempo de escalação',
      'Follow up Option' => 'Opção de continuação',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Se um bilhete está fechado e um cliente envia uma continuação, este mesmo bilhete será bloqueado para o antigo proprietário.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Se um bilhete não foi respondido dentro deste tempo, apenas os bilhetes com este tempo vencido serão exibidos.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Se um agente bloqueia um bilhete e ele não envia uma resposta dentro deste tempo, o bilhete será desbloqueado automaticamente. Então o bilhete será visível para todos os outros agentes.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => '',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => '',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => '',
      'Queue Management' => 'Gerênciamento de Filas',
      'Sub-Queue of' => '',
      'Systemaddress' => 'Endereço do Sistema',
      'The salutation for email answers.' => 'A saudação para as respostas de emails.',
      'The signature for email answers.' => 'A assinatura para as respostas de emails.',
      'Ticket lock after a follow up' => 'Bloqueio do bilhete após as continuações',
      'Unlock timeout' => 'Tempo de expiração de desbloqueio',
      'Will be the sender address of this queue for email answers.' => 'Será o endereço de email de respostas desta fila.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Gerênciamento de Respostas Padrões <-> Filas',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Resposta',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Gerênciamento de Respostas Padrões <-> Anexos',

    # Template: AdminResponseAttachmentForm

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Uma resposta é um texto padrão para compôr respostas rápidas (com texto padrão) para clientes.',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'Don\'t forget to add a new response a queue!' => 'Não se esqueça de adicionar a nova resposta a uma fila!',
      'Next state' => '',
      'Response Management' => 'Gerênciamento de Respostas',
      'The current ticket state is' => '',
      'Your email address is new' => '',

    # Template: AdminRoleForm
      'Create a role and put groups in it. Then add the role to the users.' => '',
      'It\'s useful for a lot of users and groups.' => '',
      'Role Management' => '',

    # Template: AdminRoleGroupChangeForm
      'create' => '',
      'move_into' => '',
      'owner' => '',
      'Permissions to change the ticket owner in this group/queue.' => '',
      'Permissions to change the ticket priority in this group/queue.' => '',
      'Permissions to create tickets in this group/queue.' => '',
      'Permissions to move tickets into this group/queue.' => '',
      'priority' => '',
      'Role <-> Group Management' => '',

    # Template: AdminRoleGroupForm
      'Change role <-> group settings' => '',

    # Template: AdminRoleUserChangeForm
      'Active' => '',
      'Role <-> User Management' => '',
      'Select the role:user relations.' => '',

    # Template: AdminRoleUserForm
      'Change user <-> role settings' => '',

    # Template: AdminSMIMEForm
      'Add Certificate' => '',
      'Add Private Key' => '',
      'FIXME: WHAT IS SMIME?' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',
      'Secret' => '',
      'SMIME Certificate Management' => '',

    # Template: AdminSalutationForm
      'customer realname' => 'Nome do cliente',
      'for agent firstname' => 'Nome do Agente',
      'for agent lastname' => 'Sobrenome do Agente',
      'for agent login' => '',
      'for agent user id' => '',
      'Salutation Management' => 'Gerênciamento de Saudações',

    # Template: AdminSelectBoxForm
      'Limit' => 'Limite',
      'SQL' => 'SQL',

    # Template: AdminSelectBoxResult
      'Select Box Result' => 'Selecione a Caixa de Resultado',

    # Template: AdminSession
      'kill all sessions' => 'Finalizar todas as sessões',
      'kill session' => 'Finalizar sessão',
      'Overview' => '',
      'Session' => '',
      'Sessions' => '',
      'Uniq' => '',

    # Template: AdminSignatureForm
      'Signature Management' => 'Gerênciamento de Assinaturas',

    # Template: AdminStateForm
      'See also' => '',
      'State Type' => '',
      'System State Management' => 'Gerênciamento de Estados do Sistema',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Todos os emails entrantes com este Email(To:) serão despachados na fila selecionada!',
      'Email' => '',
      'Realname' => 'Nome',
      'System Email Addresses Management' => 'Gerênciamento dos Endereços de Emails do Sistema',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Não esqueça de adicionar um novo usuário nos grupos!',
      'Firstname' => 'Nome',
      'Lastname' => 'Sobrenome',
      'User Management' => 'Gerênciamento de Usuários',
      'User will be needed to handle tickets.' => 'Será necessário um usuário para manipular os bilhetes.',

    # Template: AdminUserGroupChangeForm
      'User <-> Group Management' => 'Gerênciamento de Usuários <-> Grupos',

    # Template: AdminUserGroupForm

    # Template: AgentBook
      'Address Book' => '',
      'Discard all changes and return to the compose screen' => 'Descartar todas as modificações e retornar para a tela de composição',
      'Return to the compose screen' => 'Retornar para a tela de composição',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Uma mensagem deve possuir um To: destinatário!',
      'Bounce ticket' => 'Devolver bilhete',
      'Bounce to' => 'Devolver para',
      'Inform sender' => 'Informe o remetente',
      'Next ticket state' => 'Próximo estado do bilhete',
      'Send mail!' => 'Enviar email!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Você precisa de um endereço de email (exemplo: cliente@exemplo.com.br) no To:!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Seu email com o número de bilhete "<OTRS_TICKET>" foi devolvido para "<OTRS_BOUNCE_TO>". Contate este endereço para mais informações.',

    # Template: AgentBulk
      '$Text{"Note!' => '',
      'A message should have a subject!' => 'Uma mensagem deve conter um assunto!',
      'Note type' => 'Tipo de nota',
      'Note!' => 'Nota!',
      'Options' => 'Opções',
      'Spell Check' => 'Checar Ortografia',
      'Ticket Bulk Action' => '',

    # Template: AgentClose
      ' (work units)' => ' (unidades de trabalho)',
      'A message should have a body!' => '',
      'Close ticket' => 'Fechar o bilhete',
      'Close type' => 'Tipo de fechamento',
      'Close!' => 'Fechar!',
      'Note Text' => 'Nota',
      'Time units' => 'Unidades de tempo',
      'You need to account time!' => '',

    # Template: AgentCompose
      'A message must be spell checked!' => '',
      'Attach' => 'Anexo',
      'Compose answer for ticket' => 'Compôr uma resposta para o bilhete',
      'for pending* states' => 'em estado pendente*',
      'Is the ticket answered' => 'O bilhete foi respondido',
      'Pending Date' => 'Data de Pendência',

    # Template: AgentCrypt

    # Template: AgentCustomer
      'Change customer of ticket' => 'Modificar o cliente do bilhete',
      'Search Customer' => 'Busca do cliente',
      'Set customer user and customer id of a ticket' => '',

    # Template: AgentCustomerHistory
      'All customer tickets.' => '',
      'Customer history' => 'Histórico do cliente',

    # Template: AgentCustomerMessage
      'Follow up' => 'Continuação',

    # Template: AgentCustomerView
      'Customer Data' => 'Dados do Cliente',

    # Template: AgentEmailNew
      'All Agents' => '',
      'Clear To' => '',
      'Compose Email' => '',
      'new ticket' => 'novo bilhete',

    # Template: AgentForward
      'Article type' => 'Tipo de artigo',
      'Date' => 'Data',
      'End forwarded message' => 'Final da mensagem encaminhada',
      'Forward article of ticket' => 'Encaminhar o artigo do bilhete',
      'Forwarded message from' => 'Mensagem encaminhada de',
      'Reply-To' => 'Responder-Para',

    # Template: AgentFreeText
      'Change free text of ticket' => '',

    # Template: AgentHistoryForm
      'History of' => 'Histórico de',

    # Template: AgentHistoryRow

    # Template: AgentInfo
      'Info' => 'Informação',

    # Template: AgentLookup
      'Lookup' => '',

    # Template: AgentMailboxNavBar
      'All messages' => 'Todas as mensagens',
      'down' => 'inversa',
      'Mailbox' => 'Caixa de Entrada',
      'New' => 'Novos',
      'New messages' => 'Mensagens novas',
      'Open' => 'Abertos',
      'Open messages' => 'Mensagens abertas',
      'Order' => 'Ordem',
      'Pending messages' => 'Mensagens pendentes',
      'Reminder' => 'Lembretes',
      'Reminder messages' => 'Mensagens com lembretes',
      'Sort by' => 'Ordenado pela',
      'Tickets' => 'Bilhetes',
      'up' => 'normal',

    # Template: AgentMailboxTicket
      '"}' => '',
      '"}","14' => '',
      'Add a note to this ticket!' => '',
      'Change the ticket customer!' => '',
      'Change the ticket owner!' => '',
      'Change the ticket priority!' => '',
      'Close this ticket!' => '',
      'Shows the detail view of this ticket!' => '',
      'Unlock this ticket!' => '',

    # Template: AgentMove
      'Move Ticket' => '',
      'Previous Owner' => '',
      'Queue ID' => '',

    # Template: AgentNavigationBar
      'Agent Preferences' => '',
      'Bulk Action' => '',
      'Bulk Actions on Tickets' => '',
      'Create new Email Ticket' => '',
      'Create new Phone Ticket' => '',
      'Email-Ticket' => '',
      'Locked tickets' => 'Bilhetes bloqueados',
      'new message' => 'Nova mensagem',
      'Overview of all open Tickets' => '',
      'Phone-Ticket' => '',
      'Preferences' => 'Preferências',
      'Search Tickets' => '',
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

    # Template: AgentNote
      'Add note to ticket' => 'Adicionar nota ao bilhete',

    # Template: AgentOwner
      'Change owner of ticket' => 'Modificar o proprietário do bilhete',
      'Message for new Owner' => 'Mensagem para um novo Proprietário',

    # Template: AgentPending
      'Pending date' => 'Data da pendência',
      'Pending type' => 'Tipo de pendência',
      'Set Pending' => 'Marcar Pendente',

    # Template: AgentPhone
      'Phone call' => 'Chamada telefônica',

    # Template: AgentPhoneNew
      'Clear From' => '',

    # Template: AgentPlain
      'ArticleID' => 'Id.do artigo',
      'Download' => '',
      'Plain' => 'Texto',
      'TicketID' => 'Id.do Bilhete',

    # Template: AgentPreferencesCustomQueue
      'My Queues' => '',
      'You also get notified about this queues via email if enabled.' => '',
      'Your queue selection of your favorite queues.' => '',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Modificar Senha',
      'New password' => 'Nova senha',
      'New password again' => 'Re-digite a nova senha',

    # Template: AgentPriority
      'Change priority of ticket' => 'Modificar a prioridade do bilhete',

    # Template: AgentSpelling
      'Apply these changes' => 'Aplicar estas modificações',
      'Spell Checker' => 'Checar a Ortografica',
      'spelling error(s)' => 'erro(s) ortográficos',

    # Template: AgentStatusView
      'D' => 'D',
      'of' => 'de',
      'Site' => '',
      'sort downward' => 'ordem decrescente',
      'sort upward' => 'ordem crescente',
      'Ticket Status' => 'Estado do Bilhete',
      'U' => 'C',

    # Template: AgentTicketLink
      'Delete Link' => '',
      'Link' => '',
      'Link to' => '',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Bilhete bloqueado!',
      'Ticket unlock!' => '',

    # Template: AgentTicketPrint

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Tempo contabilizado',
      'Escalation in' => 'Escalado em',

    # Template: AgentUtilSearch
      'Profile' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Search-Template' => '',
      'Select' => '',
      'Ticket Search' => '',
      'Yes, save it with name' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Busca no Histórico do cliente',
      'Customer history search (e. g. "ID342425").' => 'Busca no Histórico do cliente (exemplo: "ID342425")',
      'No * possible!' => 'Não são possíveis *!',

    # Template: AgentUtilSearchResult
      'Change search options' => '',
      'Results' => 'Resultados',
      'Search Result' => '',
      'Total hits' => 'Total de acertos',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilTicketStatus
      'All closed tickets' => '',
      'All open tickets' => 'Todos os bilhetes abertos',
      'closed tickets' => '',
      'open tickets' => 'bilhetes abertos',
      'or' => '',
      'Provides an overview of all' => 'Dá uma visão geral de todos os',
      'So you see what is going on in your system.' => 'Então, você vê o que está acontecendo no seu sistema.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => '',
      'Your own Ticket' => '',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Compôr resposta',
      'Contact customer' => 'Contatar cliente',
      'phone call' => 'chamada telefônica',

    # Template: AgentZoomArticle
      'Split' => '',

    # Template: AgentZoomBody
      'Change queue' => 'Modificar Fila',

    # Template: AgentZoomHead
      'Change the ticket free fields!' => '',
      'Free Fields' => '',
      'Link this ticket to an other one!' => '',
      'Lock it to work on it!' => '',
      'Print' => 'Imprimir',
      'Print this ticket!' => '',
      'Set this ticket to pending!' => '',
      'Shows the ticket history!' => '',

    # Template: AgentZoomStatus
      '"}","18' => '',
      'Locked' => '',
      'SLA Age' => '',

    # Template: Copyright
      'printed by' => 'impresso por',

    # Template: CustomerAccept

    # Template: CustomerCreateAccount
      'Create Account' => 'Criar Conta',
      'Login' => '',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFAQArticleHistory
      'FAQ History' => '',

    # Template: CustomerFAQArticlePrint
      'Category' => '',
      'Keywords' => '',
      'Last update' => '',
      'Problem' => '',
      'Solution' => '',
      'Symptom' => '',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => '',

    # Template: CustomerFAQArticleView
      'FAQ Article' => '',
      'Modified' => '',

    # Template: CustomerFAQOverview
      'FAQ Overview' => '',

    # Template: CustomerFAQSearch
      'FAQ Search' => '',
      'Fulltext' => '',
      'Keyword' => '',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => '',

    # Template: CustomerFooter
      'Powered by' => 'Movido à',

    # Template: CustomerLostPassword
      'Lost your password?' => 'Esqueceu sua senha?',
      'Request new password' => 'Solicitar uma nova senha',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'CompanyTickets' => '',
      'Create new Ticket' => 'Criar um novo bilhete',
      'FAQ' => 'FAQ',
      'MyTickets' => '',
      'New Ticket' => 'Novo Bilhete',
      'Welcome %s' => 'Bem-vindo %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerTicketSearch

    # Template: CustomerTicketSearchResultPrint

    # Template: CustomerTicketSearchResultShort

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Clique aqui para relatar um erro!',

    # Template: FAQArticleDelete
      'FAQ Delete' => '',
      'You really want to delete this article?' => '',

    # Template: FAQArticleForm
      'A article should have a title!' => '',
      'Comment (internal)' => '',
      'Filename' => '',
      'Title' => '',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQArticleViewSmall

    # Template: FAQCategoryForm
      'FAQ Category' => '',
      'Name is required!' => '',

    # Template: FAQLanguageForm
      'FAQ Language' => '',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: Footer
      'Top of Page' => '',

    # Template: FooterSmall

    # Template: InstallerBody
      'Create Database' => '',
      'Drop Database' => '',
      'Finished' => '',
      'System Settings' => '',
      'Web-Installer' => '',

    # Template: InstallerFinish
      'Admin-User' => '',
      'After doing so your OTRS is up and running.' => '',
      'Have a lot of fun!' => '',
      'Restart your webserver' => '',
      'Start page' => '',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
      'Your OTRS Team' => '',

    # Template: InstallerLicense
      'accept license' => '',
      'don\'t accept license' => '',
      'License' => '',

    # Template: InstallerStart
      'Create new database' => '',
      'DB Admin Password' => '',
      'DB Admin User' => '',
      'DB Host' => '',
      'DB Type' => '',
      'default \'hot\'' => '',
      'Delete old database' => '',
      'next step' => 'próximo passo',
      'OTRS DB connect host' => '',
      'OTRS DB Name' => '',
      'OTRS DB Password' => '',
      'OTRS DB User' => '',
      'your MySQL DB should have a root password! Default is empty!' => '',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      '(Email of the system admin)' => '(Email do administrador do sistema)',
      '(Full qualified domain name of your system)' => '(Nome completo do domínio de seu sistema)',
      '(Logfile just needed for File-LogModule!)' => '(Arquivo de registro para File-LogModule)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(A identidade do sistema. Cada número de bilhete e cada id. da sessão http, inicia com este número)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificador do Bilhete. Algumas pessoas gostam de usar por exemplo \'Bilhete#\, \'Chamada#\' ou \'MeuBilhete#\')',
      '(Used default language)' => '(Idioma padrão utilizado)',
      '(Used log backend)' => '()',
      '(Used ticket number format)' => '(Formato de bilhete utilizado)',
      'CheckMXRecord' => '',
      'Default Charset' => 'Conjunto de Caracteres Padrão',
      'Default Language' => 'Idioma Padrão',
      'Logfile' => 'Arquivo de registro',
      'LogModule' => '',
      'Organization' => 'Organização',
      'System FQDN' => 'FQDN do sistema',
      'SystemID' => 'ID do sistema',
      'Ticket Hook' => '',
      'Ticket Number Generator' => 'Gerador de Números de Bilhetes',
      'Use utf-8 it your database supports it!' => '',
      'Webfrontend' => 'Interface Web',

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Sem Permissão',

    # Template: Notify

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: QueueView
      'All tickets' => 'Todos bilhetes',
      'Page' => '',
      'Queues' => 'Filas',
      'Tickets available' => 'Bilhetes disponíveis',
      'Tickets shown' => 'Bilhetes mostrados',

    # Template: SystemStats

    # Template: Test
      'OTRS Test Page' => 'Página de Teste do OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Escalação de bilhetes!',

    # Template: TicketView

    # Template: TicketViewLite

    # Template: Warning

    # Template: css
      'Home' => 'Início',

    # Template: customer-css
      'Contact' => 'Contato',
      'Online-Support' => 'Suporte-Online',
      'Products' => 'Produtos',
      'Support' => 'Suporte',

    # Misc
      '"}","15' => '',
      '"}","30' => '',
      'A message should have a From: recipient!' => 'Uma mensagem deve conter um From: remetente!',
      'Add auto response' => 'Adicionar uma auto-resposta',
      'AgentFrontend' => 'Interface do Agente',
      'Article free text' => 'Texto livre do artigo',
      'Change Response <-> Attachment settings' => 'Modificar as configurações de Respostas <-> Anexos',
      'Change answer <-> queue settings' => 'Modificar as configurações de respostas <-> filas',
      'Change auto response settings' => 'Modificar as configurações da auto-resposta',
      'Charset' => 'Conjunto de Caracteres',
      'Charsets' => 'Conjunto de Caracteres',
      'Create' => 'Criar',
      'Customer called' => 'Cliente chamado',
      'Customer user will be needed to to login via customer panels.' => 'Um cliente é necessário para se conectar pelo painel de clientes',
      'FAQ State' => '',
      'Fulltext search' => 'Busca completa de texto',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Busca completa em todo texto (exemplo: "Mar*in" ou "Constru*" ou "martin+bonjour")',
      'Graphs' => 'Gráficos',
      'Handle' => 'Manipular',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Se sua conta é confiável, os cabeçalhos x-otrs (para prioridade, ...) serão utilizados!',
      'Lock Ticket' => '',
      'Max Rows' => 'Número máximo de linhas',
      'My Tickets' => 'Meus Bilhetes',
      'New state' => 'Novo estado',
      'New ticket via call.' => 'Novo bilhete via chamada telefônica.',
      'New user' => 'Novo usuário',
      'Pending!' => '',
      'Phone call at %s' => 'Chamada telefônica em %s',
      'Please go away!' => '',
      'PostMasterFilter Management' => '',
      'Screen after new phone ticket' => '',
      'Search in' => 'Buscar em',
      'Select source:' => '',
      'Select your custom queues' => 'Seleciona sua fila personalizada',
      'Select your screen after creating a new ticket via PhoneView.' => '',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Notifique me se um bilhete é movido para uma fila personalizada',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Notifique me se há um novo bilhete em minhas filas personalizadas.',
      'SessionID' => 'Identificação da sessão',
      'Set customer id of a ticket' => 'Definir a identificação do cliente de um bilhete',
      'Short Description' => '',
      'Show all' => 'Mostrar todos os',
      'Status defs' => 'Estados',
      'System Charset Management' => 'Gerênciamento de Conjunto de Caracteres do Sistema',
      'System Language Management' => 'Gerênciamento de Idiomas do Sistema',
      'Ticket free text' => 'Texto livre do bilhete',
      'Ticket limit:' => 'Limite do Bilhete:',
      'Ticket-Overview' => 'Resumo do Bilhete',
      'Time till escalation' => 'Tempo para escalação',
      'Utilities' => 'Utilitários',
      'With State' => 'Com Estado',
      'You have to be in the admin group!' => 'Você tem que estar no grupo admin!',
      'You have to be in the stats group!' => 'Você tem que estar no grupo stats!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Você precisa de um endereço de email (ex:cliente@exemplo.com.br) no From:!',
      'auto responses set' => 'auto-respostas ativadas',
      'by' => 'por',
      'search' => 'buscar',
      'search (e. g. 10*5155 or 105658*)' => 'buscar (exemplo: 1055155 ou 105658*)',
      'store' => 'armazenar',
      'tickets' => 'bilhetes',
      'valid' => 'válido',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
