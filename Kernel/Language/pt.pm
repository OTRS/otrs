# --
# Kernel/Language/pt.pm - provides pt language translation
# Copyright (C) 2004 CAT- Centro Apoio Técnico <suporte at cat.novis.pt>
# --
# $Id: pt.pm,v 1.1 2004-01-21 20:37:04 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::pt;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Wed Jan 21 21:21:08 2004 by 

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
      '10 minutes' => '10 minutos',
      '15 minutes' => '15 minutos',
      'AddLink' => 'Adicionar link',
      'Admin-Area' => '',
      'agent' => '',
      'Agent-Area' => '',
      'all' => 'todos',
      'All' => 'Todos',
      'Attention' => 'Atenção',
      'Bug Report' => 'Relatório de Erros',
      'Cancel' => 'Cancelar',
      'change' => 'alterar',
      'Change' => 'Alterar',
      'change!' => 'alterar!',
      'click here' => 'clique aqui',
      'Comment' => 'Comentário',
      'Customer' => 'Cliente',
      'customer' => '',
      'Customer Info' => 'Informáção do Cliente',
      'day' => 'dia',
      'days' => 'dias',
      'description' => 'descrição',
      'Description' => 'Descrição',
      'Dispatching by email To: field.' => 'Despachar pelo campo de email To:',
      'Dispatching by selected Queue.' => 'Despachar pela fila selecionada',
      'Don\'t show closed Tickets' => '',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Não trabalhe com o UsrID 1(Conta de Sistema)! Criar novos users!',
      'Done' => 'Feito',
      'end' => 'fim',
      'Error' => 'Erro',
      'Example' => 'Exemplo',
      'Examples' => 'Exemplos',
      'Facility' => 'Facilidade',
      'FAQ-Area' => '',
      'Feature not active!' => 'Característica não activa!',
      'go' => 'ir',
      'go!' => 'ir!',
      'Group' => 'Grupo',
      'Hit' => 'Hit',
      'Hits' => 'Hits',
      'hour' => 'hora',
      'hours' => 'horas',
      'Ignore' => 'Ignorar',
      'invalid' => 'inválido',
      'Invalid SessionID!' => 'Identificador de Sessão Inválido',
      'Language' => 'Idioma',
      'Languages' => 'Idiomas',
      'Line' => 'Linha',
      'Lite' => 'Lite',
      'Login failed! Your username or password was entered incorrectly.' => 'Login inválido! Seu username ou password foram introduzidos incorrectamentes.',
      'Logout successful. Thank you for using OTRS!' => 'Logout com sucesso. Obrigado por utilizar o OTRS!',
      'Message' => 'Mensagem',
      'minute' => 'minuto',
      'minutes' => 'minutos',
      'Module' => 'Módulo',
      'Modulefile' => 'Ficheiro de Módulo',
      'Name' => 'Nome',
      'New message' => 'Nova mensagem',
      'New message!' => 'Nova mensagem!',
      'No' => 'Não',
      'no' => 'nenhuma',
      'No entry found!' => '',
      'No suggestions' => 'Sem sugestões',
      'none' => 'nada',
      'none - answered' => 'nada  - respondido',
      'none!' => 'nada!',
      'Off' => 'Desligado',
      'off' => 'desligado',
      'On' => 'Ligado',
      'on' => 'ligado',
      'Password' => 'Senha',
      'Pending till' => 'Gaveta pendente',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Por favor, responda este(s) ticket(s) para retornar para vista normal da queue!',
      'Please contact your admin' => 'Por favor, contactar administrador',
      'please do not edit!' => 'Por favor, não editar!',
      'Please go away!' => '',
      'possible' => 'possível',
      'QueueView' => 'QueueView',
      'reject' => 'rejeitar',
      'replace with' => 'substituir com',
      'Reset' => 'Reset',
      'Salutation' => 'Saudação',
      'Session has timed out. Please log in again.' => 'Time Out. Por favor, logar-se novamente',
      'Show closed Tickets' => '',
      'Signature' => 'Assinatura',
      'Sorry' => 'Desculpe',
      'Stats' => 'Estatísticas',
      'Subfunction' => 'Sub-função',
      'submit' => 'Submeter',
      'submit!' => 'Submeter!',
      'system' => 'Sistema',
      'Take this User' => 'Utilize este user',
      'Text' => 'Texto',
      'The recommended charset for your language is %s!' => 'O conjunto de caracteres recomendado para o seu idioma é %s!',
      'Theme' => 'Tema',
      'There is no account with that login name.' => 'Não existe conta com esse login',
      'Timeover' => 'Tempo esgotado',
      'To: (%s) replaced with database email!' => '',
      'top' => 'início',
      'update' => 'actualizar',
      'update!' => 'actualizar!',
      'User' => 'User',
      'Username' => 'Nome de Usuário',
      'Valid' => 'Válido',
      'Warning' => 'Aviso',
      'Welcome to OTRS' => 'Bem-vindo ao OTRS',
      'Word' => 'Palavra',
      'wrote' => 'escreveu',
      'yes' => 'sim',
      'Yes' => 'Sim',
      'You got new message!' => 'Você recebeu uma nova mensagem',
      'You have %s new message(s)!' => 'Você tem %s nova(s) mensagem(s)!',
      'You have %s reminder ticket(s)!' => 'Você tem %s reminder ticket(s)',

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
      'Closed Tickets' => 'Tickets Fechados',
      'Custom Queue' => 'Queue Personalizada',
      'Follow up notification' => 'Notificação de Follow up',
      'Frontend' => 'Interface',
      'Mail Management' => 'Gestão de Mails',
      'Max. shown Tickets a page in Overview.' => '',
      'Max. shown Tickets a page in QueueView.' => '',
      'Move notification' => 'Notificação de movimentos',
      'New ticket notification' => 'Notificação de novo ticket',
      'Other Options' => 'Outras Opções',
      'PhoneView' => 'Chamada',
      'Preferences updated successfully!' => 'Preferências actualizadas com sucesso!',
      'QueueView refresh time' => 'Tempo de refresh da QueueView',
      'Screen after new phone ticket' => '',
      'Select your default spelling dictionary.' => 'Seleccionar o seu corrector ortográfico',
      'Select your frontend Charset.' => 'Selecionar o Conjunto de Caracteres da sua Interface .',
      'Select your frontend language.' => 'Selecionar o Idioma da sua Interface.',
      'Select your frontend QueueView.' => 'Selecionar o seu Interface da QueueView.',
      'Select your frontend Theme.' => 'Selecionar o Tema do seu Interface.',
      'Select your QueueView refresh time.' => 'Selecionar o tempo de refresh da QueueView',
      'Select your screen after creating a new ticket via PhoneView.' => '',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Notificar se um cliente enviar uma follow up e sou o owner desse ticket.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Notificar se um ticket for movido para uma queue personalizada',
      'Send me a notification if a ticket is unlocked by the system.' => 'Notificar se um ticket for desbloqueado pelo sistema.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Notificar se há um novo ticket na minhas queues personalizadas.',
      'Show closed tickets.' => 'Mostrar tickets fechados',
      'Spelling Dictionary' => 'Corrector Ortográfico',
      'Ticket lock timeout notification' => 'Notificação de bloqueio por tempo expirado',
      'TicketZoom' => '',

    # Template: AAATicket
      '1 very low' => '1 muito baixo',
      '2 low' => '2 baixo',
      '3 normal' => '3 normal',
      '4 high' => '4 alto',
      '5 very high' => '5 muito alto',
      'Action' => 'Acção',
      'Age' => 'Idade',
      'Article' => 'Artigo',
      'Attachment' => 'Anexo',
      'Attachments' => 'Anexos',
      'Bcc' => 'Copia Invisível',
      'Bounce' => 'Devolver',
      'Cc' => 'Cópia ',
      'Close' => 'Fechar',
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
      'pending auto close+' => 'pendente fecho automático+',
      'pending auto close-' => 'pendente fecho automático-',
      'pending reminder' => 'post-it de pendente',
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
      'This is a HTML email. Click here to show it.' => 'Esta é um email HTML. Clicar aqui para exibi-lo.',
      'This message was written in a character set other than your own.' => 'Esta mensagem foi escrita utilizando um conjunto de caracteres diferente do seu.',
      'Ticket' => 'Ticket',
      'Ticket "%s" created!' => '',
      'To' => 'Para',
      'to open it in a new window.' => 'para abrir em nova janela.',
      'unlock' => 'desbloquear',
      'Unlock' => 'Desbloquear',
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
      'Add auto response' => 'Adicionar uma auto-resposta',
      'Auto Response From' => 'Auto-Resposta De',
      'Auto Response Management' => 'Gerênciamento de Auto-Respostas',
      'Change auto response settings' => 'Modificar as configurações da auto-resposta',
      'Note' => 'Nota',
      'Response' => 'Resposta',
      'to get the first 20 character of the subject' => 'para obter os 20 primeiros caracteres do assunto',
      'to get the first 5 lines of the email' => 'para obter as 5 primeiras linhas do email',
      'to get the from line of the email' => 'para obter a linha "From" do email',
      'to get the realname of the sender (if given)' => 'para obter o nome do remetente (se possuir no email)',
      'to get the ticket id of the ticket' => 'para obter o ID do ticket',
      'to get the ticket number of the ticket' => 'para obter o número do ticket',
      'Type' => 'Tipo',
      'Useable options' => 'Opções acessíveis',

    # Template: AdminCharsetForm
      'Charset' => 'Conjunto de Caracteres',
      'System Charset Management' => 'Gerênciamento de Conjunto de Caracteres do Sistema',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Gestão de Users de Clientes',
      'Customer user will be needed to to login via customer panels.' => 'Um user de cliente é necessário para se logar pelo painel de clientes',

    # Template: AdminCustomerUserGeneric

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
      'Change user <-> group settings' => 'Modificar users <-> configurações de grupos',

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Email do Admin.',
      'Body' => 'Corpo',
      'OTRS-Admin Info!' => 'Informação do Administrador do OTRS!',
      'Recipents' => 'Destinatários',
      'send' => '',

    # Template: AdminEmailSent
      'Message sent to' => 'Mensagem enviada para',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Crie novos grupos para manipular as permissões de acesso para diferentes grupos de agentes (exemplos: departamento de compras, departamento de suporte, departamento de vendas, etc...).',
      'Group Management' => 'Gestão de Grupos',
      'It\'s useful for ASP solutions.' => 'Isto é útil para soluções ASP.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'O grupo admin é para uso na área de administração e o grupo stats é para uso na área de estatísticas.',

    # Template: AdminLog
      'System Log' => 'Registro do Sistema',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Email do Administrador',
      'Attachment <-> Response' => '',
      'Auto Response <-> Queue' => 'Auto-Respostas <-> Queue',
      'Auto Responses' => 'Auto-Respostas',
      'Customer User' => 'User de Cliente',
      'Customer User <-> Groups' => '',
      'Email Addresses' => 'Endereços de Emails',
      'Groups' => 'Grupos',
      'Logout' => 'Deslogar-se',
      'Misc' => 'Variedades',
      'Notifications' => '',
      'POP3 Account' => 'Conta POP3',
      'Responses' => 'Respostas',
      'Responses <-> Queue' => 'Respostas <-> Filas',
      'Select Box' => 'Caixa de Seleção',
      'Session Management' => 'Gestão de Sessões',
      'Status' => 'Status',
      'System' => 'Sistema',
      'User <-> Groups' => 'User <-> Grupos',

    # Template: AdminNotificationForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Uma resposta é um texto padrão para compôr respostas rápidas (com texto padrão) para clientes.',
      'Don\'t forget to add a new response a queue!' => 'Não se esqueça de adicionar a nova resposta a uma fila!',
      'Next state' => '',
      'Notification Management' => '',
      'The current ticket state is' => '',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Todos os emails de entrada com uma conta será despachado na queue selecionada!',
      'Dispatching' => 'Despachando',
      'Host' => '',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Se sua conta é confiável, os cabeçalhos x-otrs (para prioridade, ...) serão utilizados!',
      'Login' => '',
      'POP3 Account Management' => 'Gestão de Contas POP3',
      'Trusted' => 'Confiável',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Gestão de Queues <-> Auto-Resposta',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = sem escalação',
      '0 = no unlock' => '0 = sem desbloqueio',
      'Customer Move Notify' => '',
      'Customer Owner Notify' => '',
      'Customer State Notify' => '',
      'Escalation time' => 'Tempo de escalação',
      'Follow up Option' => 'Opção de follow up',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Se um ticket está fechado e um cliente envia um follow up, este mesmo ticket será bloqueado para o antigo proprietário.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Se um ticket não foi respondido dentro deste tempo, apenas os tickets com este tempo vencido serão exibidos.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Se um agente bloqueia um ticket e ele não envia uma resposta dentro deste tempo, o ticket será desbloqueado automaticamente. Então o ticket será visível para todos os outros agentes.',
      'Key' => 'Chave',
      'OTRS sends an notification email to the customer if the ticket is moved.' => '',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => '',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => '',
      'Queue Management' => 'Gestão de Queues',
      'Sub-Queue of' => 'Sub-Queue de',
      'Systemaddress' => 'Endereço do Sistema',
      'The salutation for email answers.' => 'A saudação para as respostas de emails.',
      'The signature for email answers.' => 'A assinatura para as respostas de emails.',
      'Ticket lock after a follow up' => 'Bloqueio do bilhete após as continuações',
      'Unlock timeout' => 'Tempo de expiração de desbloqueio',
      'Will be the sender address of this queue for email answers.' => 'Será o endereço de email de respostas desta queue.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Gestão de Respostas Padrão <-> Queues',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Resposta',
      'Change answer <-> queue settings' => 'Modificar respostas <-> configurações de queues',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Respostas Padrão <-> Gestão Anexos Padrão',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Modificar Resposta <-> Configurações de Anexos',

    # Template: AdminResponseForm
      'Response Management' => 'Gestão de Respostas',

    # Template: AdminSalutationForm
      'customer realname' => 'Nome do cliente',
      'for agent firstname' => 'Nome do Agente',
      'for agent lastname' => 'Sobrenome do Agente',
      'for agent login' => '',
      'for agent user id' => '',
      'Salutation Management' => 'Gestão de Saudações',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Número máximo de linhas',

    # Template: AdminSelectBoxResult
      'Limit' => 'Limite',
      'Select Box Result' => 'Selecione a Caixa de Resultado',
      'SQL' => 'SQL',

    # Template: AdminSession
      'Agent' => '',
      'kill all sessions' => 'Finalizar todas as sessões',
      'Overview' => '',
      'Sessions' => '',
      'Uniq' => '',

    # Template: AdminSessionTable
      'kill session' => 'Finalizar sessão',
      'SessionID' => 'Identificação da sessão',

    # Template: AdminSignatureForm
      'Signature Management' => 'Gestão de Assinaturas',

    # Template: AdminStateForm
      'See also' => '',
      'State Type' => '',
      'System State Management' => 'Gestão de Estados do Sistema',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Todos os emails de entrada com este Email(To:) serão despachados na queue selecionada!',
      'Email' => '',
      'Realname' => 'Nome',
      'System Email Addresses Management' => 'Gestão dos Endereços de Emails do Sistema',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Não esqueça de adicionar um novo user nos grupos!',
      'Firstname' => 'Nome',
      'Lastname' => 'Sobrenome',
      'User Management' => 'Gestão de Users',
      'User will be needed to handle tickets.' => 'Será necessário um user para manipular os tickets.',

    # Template: AdminUserGroupChangeForm
      'create' => '',
      'move_into' => '',
      'owner' => '',
      'Permissions to change the ticket owner in this group/queue.' => '',
      'Permissions to change the ticket priority in this group/queue.' => '',
      'Permissions to create tickets in this group/queue.' => '',
      'Permissions to move tickets into this group/queue.' => '',
      'priority' => '',
      'User <-> Group Management' => 'Users <-> Gestão de Grupos',

    # Template: AdminUserGroupForm

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBook
      'Addressbook' => '',
      'Discard all changes and return to the compose screen' => 'Descartar todas as modificações e retornar para o ecrã de composição',
      'Return to the compose screen' => 'Retornar para o ecrã de composição',
      'Search' => '',
      'The message being composed has been closed.  Exiting.' => 'A mensagem sendo composta foi fechada. Saindo.',
      'This window must be called from compose window' => 'Esta janela deve ser chamada da janela de composição',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Uma mensagem deve possuir um To: destinatário!',
      'Bounce ticket' => 'Devolver bilhete',
      'Bounce to' => 'Devolver para',
      'Inform sender' => 'Informe o remetente',
      'Next ticket state' => 'Próximo estado do ticket',
      'Send mail!' => 'Enviar email!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Precisa de um endereço de email (exemplo: cliente@exemplo.com.br) no To:!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Seu email com o número de ticket "<OTRS_TICKET>" foi devolvido para "<OTRS_BOUNCE_TO>". Contate este endereço para mais informações.',

    # Template: AgentClose
      ' (work units)' => ' (unidades de trabalho)',
      'A message should have a body!' => '',
      'A message should have a subject!' => 'Uma mensagem deve conter um assunto!',
      'Close ticket' => 'Fechar ticket',
      'Close type' => 'Tipo de fecho',
      'Close!' => 'Fechar!',
      'Note Text' => 'Nota',
      'Note type' => 'Tipo de nota',
      'Options' => 'Opções',
      'Spell Check' => 'Checar Ortografia',
      'Time units' => 'Unidades de tempo',
      'You need to account time!' => '',

    # Template: AgentCompose
      'A message must be spell checked!' => '',
      'Address Book' => '',
      'Attach' => 'Anexo',
      'Compose answer for ticket' => 'Compôr uma resposta para o ticket',
      'for pending* states' => 'em estado pendente*',
      'Is the ticket answered' => 'O ticket foi respondido',
      'Pending Date' => 'Data de Pendência',

    # Template: AgentCustomer
      'Back' => 'Retornar',
      'Change customer of ticket' => 'Modificar o cliente do ticket',
      'CustomerID' => 'Id.do Cliente',
      'Search Customer' => 'Busca do cliente',
      'Set customer user and customer id of a ticket' => '',

    # Template: AgentCustomerHistory
      'All customer tickets.' => '',
      'Customer history' => 'Histórico do cliente',

    # Template: AgentCustomerMessage
      'Follow up' => 'Follow up',

    # Template: AgentCustomerView
      'Customer Data' => 'Dados do Cliente',

    # Template: AgentForward
      'Article type' => 'Tipo de artigo',
      'Date' => 'Data',
      'End forwarded message' => 'Final da mensagem encaminhada',
      'Forward article of ticket' => 'Encaminhar o artigo do bilhete',
      'Forwarded message from' => 'Mensagem encaminhada de',
      'Reply-To' => 'Responder-Para',

    # Template: AgentFreeText
      'Change free text of ticket' => '',
      'Value' => '',

    # Template: AgentHistoryForm
      'History of' => 'Histórico de',

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
      'Reminder' => 'Post-its',
      'Reminder messages' => 'Mensagens com post-its',
      'Sort by' => 'Ordenado pela',
      'Tickets' => 'Bilhetes',
      'up' => 'normal',

    # Template: AgentMailboxTicket
      '"}' => '',
      '"}","14' => '',

    # Template: AgentMove
      'All Agents' => '',
      'Move Ticket' => '',
      'New Owner' => '',
      'New Queue' => '',
      'Previous Owner' => '',
      'Queue ID' => '',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Tickets bloqueados',
      'new message' => 'Nova mensagem',
      'Preferences' => 'Preferências',
      'Utilities' => 'Utilitários',

    # Template: AgentNote
      'Add note to ticket' => 'Adicionar nota ao ticket',
      'Note!' => 'Nota!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Modificar o proprietário do bilhete',
      'Message for new Owner' => 'Mensagem para um novo Proprietário',

    # Template: AgentPending
      'Pending date' => 'Data da pendência',
      'Pending type' => 'Tipo de pendência',
      'Pending!' => '',
      'Set Pending' => 'Marcar Pendente',

    # Template: AgentPhone
      'Customer called' => 'Cliente chamado',
      'Phone call' => 'Chamada telefônica',
      'Phone call at %s' => 'Chamada telefônica em %s',

    # Template: AgentPhoneNew
      'Clear From' => '',
      'Lock Ticket' => '',
      'new ticket' => 'novo ticket',

    # Template: AgentPlain
      'ArticleID' => 'Id.do artigo',
      'Plain' => 'Texto',
      'TicketID' => 'TicketID',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Selecione a sua queue personalizada',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Modificar Password',
      'New password' => 'Nova password',
      'New password again' => 'Re-introduza a nova senha',

    # Template: AgentPriority
      'Change priority of ticket' => 'Modificar a prioridade do ticket',

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
      'Ticket Status' => 'Estado do ticket',
      'U' => 'C',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket bloqueado!',
      'Ticket unlock!' => '',

    # Template: AgentTicketPrint
      'by' => 'por',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Tempo contabilizado',
      'Escalation in' => 'Escalado em',

    # Template: AgentUtilSearch
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      '(e. g. U5150)' => '',
      'and' => '',
      'Customer User Login' => '',
      'Delete' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      'No time settings.' => '',
      'Profile' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Search-Template' => '',
      'Select' => '',
      'Ticket created' => '',
      'Ticket created between' => '',
      'Ticket Search' => '',
      'TicketFreeText' => '',
      'Times' => '',
      'Yes, save it with name' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Busca no Histórico do cliente',
      'Customer history search (e. g. "ID342425").' => 'Busca no Histórico do cliente (exemplo: "ID342425")',
      'No * possible!' => 'Não são possíveis *!',

    # Template: AgentUtilSearchNavBar
      'Change search options' => '',
      'Results' => 'Resultados',
      'Search Result' => '',
      'Total hits' => 'Total de acertos',

    # Template: AgentUtilSearchResult
      '"}","15' => '',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultPrintTable
      '"}","30' => '',

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilSearchResultShortTable

    # Template: AgentUtilSearchResultShortTableNotAnswered

    # Template: AgentUtilTicketStatus
      'All closed tickets' => '',
      'All open tickets' => 'Todos os tickets abertos',
      'closed tickets' => '',
      'open tickets' => 'tickets abertos',
      'or' => '',
      'Provides an overview of all' => 'Dá uma visão geral de todos os',
      'So you see what is going on in your system.' => 'Então, você vê o que está acontecendo no seu sistema.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => '',
      'Your own Ticket' => '',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Compôr resposta',
      'Contact customer' => 'Contatar cliente',
      'phone call' => 'chamada telefónica',

    # Template: AgentZoomArticle
      'Split' => '',

    # Template: AgentZoomBody
      'Change queue' => 'Modificar Queue',

    # Template: AgentZoomHead
      'Free Fields' => '',
      'Print' => 'Imprimir',

    # Template: AgentZoomStatus
      '"}","18' => '',

    # Template: CustomerCreateAccount
      'Create Account' => 'Criar Conta',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFooter
      'Powered by' => 'Movido à',

    # Template: CustomerHeader
      'Contact' => 'Contacto',
      'Home' => 'Início',
      'Online-Support' => 'Suporte-Online',
      'Products' => 'Produtos',
      'Support' => 'Suporte',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Esqueceu password?',
      'Request new password' => 'Solicitar nova password',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Criar um novo ticket',
      'New Ticket' => 'Novo Tickets',
      'Ticket-Overview' => 'Resumo do Ticket',
      'Welcome %s' => 'Bem-vindo %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'My Tickets' => 'Meus Tickets',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Clicar para relatar um erro!',

    # Template: FAQArticleDelete
      'FAQ Delete' => '',
      'You really want to delete this article?' => '',

    # Template: FAQArticleForm
      'Category' => '',
      'FAQ Article' => '',
      'Filename' => '',
      'Keywords' => '',
      'Problem' => '',
      'Short Description' => '',
      'Solution' => '',
      'Sympthom' => '',

    # Template: FAQArticleHistory
      'delete' => '',
      'edit' => '',
      'FAQ History' => '',
      'print' => '',
      'view' => '',

    # Template: FAQArticlePrint
      'Last update' => '',

    # Template: FAQArticleSystemHistory
      'FAQ System History' => '',

    # Template: FAQArticleView
      'history' => '',

    # Template: FAQCategoryForm
      'FAQ Category' => '',

    # Template: FAQLanguageForm
      'FAQ Language' => '',

    # Template: FAQNavigationBar

    # Template: FAQSearch
      'FAQ Search' => '',
      'Fulltext' => '',
      'Keyword' => '',

    # Template: FAQSearchResult
      'FAQ Search Result' => '',

    # Template: Footer
      'Top of Page' => '',

    # Template: Header

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
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificador do Ticket. Algumas pessoas gostam de usar por exemplo \'Ticket#\, \'Chamada#\' ou \'MeuTicket#\')',
      '(Used default language)' => '(Idioma padrão utilizado)',
      '(Used log backend)' => '()',
      '(Used ticket number format)' => '(Formato de ticket utilizado)',
      'CheckMXRecord' => '',
      'Default Charset' => 'Conjunto de Caracteres Padrão',
      'Default Language' => 'Idioma Padrão',
      'Logfile' => 'Arquivo de registro',
      'LogModule' => '',
      'Organization' => 'Organização',
      'System FQDN' => 'FQDN do sistema',
      'SystemID' => 'ID do sistema',
      'Ticket Hook' => '',
      'Ticket Number Generator' => 'Gerador de Números de Tickets',
      'Webfrontend' => 'Interface Web',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Sem Permissão',

    # Template: Notify
      'Info' => 'Informação',

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: PrintHeader
      'printed by' => 'impresso por',

    # Template: QueueView
      'All tickets' => 'Todos tickets',
      'Page' => '',
      'Queues' => 'Queues',
      'Tickets available' => 'Tickets disponíveis',
      'Tickets shown' => 'Tickets mostrados',

    # Template: SystemStats
      'Graphs' => 'Gráficos',

    # Template: Test
      'OTRS Test Page' => 'Página de Teste do OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Escalamento de tickets!',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Adicionar Nota',

    # Template: Warning

    # Misc
      '(Click here to add a group)' => '(Clique aqui para adicionar um grupo)',
      '(Click here to add a queue)' => '(Clique aqui para adicionar uma queue)',
      '(Click here to add a response)' => '(Clique aqui para adicionar uma resposta)',
      '(Click here to add a salutation)' => '(Clique aqui para adicionar uma saudação)',
      '(Click here to add a signature)' => '(Clique aqui para adicionar uma assinatura)',
      '(Click here to add a system email address)' => '(Clique aqui para adicionar um endereço de email do sistema)',
      '(Click here to add a user)' => '(Clique aqui para adicionar um user)',
      '(Click here to add an auto response)' => '(Clique aqui para adicionar uma auto-resposta)',
      '(Click here to add charset)' => '(Clique aqui para adicionar um conjunto de caracteres)',
      '(Click here to add language)' => '(Clique aqui para adicionar um idioma)',
      '(Click here to add state)' => '(Clique aqui para adicionar um estado)',
      'A message should have a From: recipient!' => 'Uma mensagem deve conter um From: remetente!',
      'Add POP3 Account' => 'Adicionar Conta POP3',
      'Add attachment' => 'Adicionar anexo',
      'Add charset' => 'Adicionar conjunto de caracteres',
      'Add customer user' => 'Adicionar user de cliente',
      'Add group' => 'Adicionar grupo',
      'Add language' => 'Adicionar idioma',
      'Add queue' => 'Adicionar queue',
      'Add response' => 'Adicionar resposta',
      'Add salutation' => 'Adicionar saudação',
      'Add signature' => 'Adicionar assinatura',
      'Add state' => 'Adicionar estado',
      'Add system address' => 'Adicionar um endereço do sistema',
      'Add user' => 'Adicionar user',
      'AdminArea' => 'Área de Administração',
      'AgentFrontend' => 'Interface do Agente',
      'Article free text' => 'Texto livre do artigo',
      'Attachment <-> Anexo' => '',
      'Backend' => '',
      'BackendMessage' => '',
      'Change  settings' => 'Modificar as configurações',
      'Change Group settings' => 'Modificar as configurações do grupo',
      'Change POP3 Account setting' => 'Modificar as configurações da conta POP3',
      'Change User settings' => 'Modificar as configurações do user',
      'Change attachment settings' => 'Modificar as configurações do anexo',
      'Change customer user settings' => 'Modificar as configurações do user de cliente',
      'Change group settings' => 'Modificar as configurações do grupo',
      'Change queue settings' => 'Modificar as configurações da queue',
      'Change response settings' => 'Modificar as configurações da resposta',
      'Change salutation settings' => 'Modificar as configurações da saudação',
      'Change signature settings' => 'Modificar as configurações da assinatura',
      'Change system address setting' => 'Modificar o endereço do sistema',
      'Change system charset setting' => 'Modificar as configurações do conjunto de caracteres do sistema',
      'Change system language setting' => 'Modificar as configurações de idioma',
      'Change system state setting' => 'Modificar as configurações do estado do sistema',
      'Change user settings' => 'Modificar as configurações de user',
      'Charsets' => 'Conjunto de Caracteres',
      'Create' => 'Criar',
      'CustomerUser' => 'Usuário Cliente',
      'FAQ' => 'FAQ',
      'Fulltext search' => 'Busca completa de texto',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Busca completa em todo texto (exemplo: "Mar*in" ou "Constru*" ou "martin+bonjour")',
      'Handle' => 'Manipular',
      'New state' => 'Novo estado',
      'New ticket via call.' => 'Novo bilhete via chamada telefônica.',
      'New user' => 'Novo user',
      'Search in' => 'Buscar em',
      'Set customer id of a ticket' => 'Definir a identificação do cliente de um ticket',
      'Show all' => 'Mostrar todos os',
      'Status defs' => 'Estados',
      'System Language Management' => 'Gestão de Idiomas do Sistema',
      'Ticket free text' => 'Texto livre do ticket',
      'Ticket limit:' => 'Limite do Ticket:',
      'Time till escalation' => 'Tempo para escalação',
      'Update auto response' => 'Actualizar a auto-resposta',
      'Update charset' => 'Actualizar o conjunto de caracteres',
      'Update group' => 'Actualizar o grupo',
      'Update language' => 'Actualizar o idioma',
      'Update queue' => 'Actualizar queue',
      'Update response' => 'Actualizar a resposta',
      'Update salutation' => 'Actualizar a saudação',
      'Update signature' => 'Actualizar a assinatura',
      'Update state' => 'Actualizar o estado',
      'Update system address' => 'Actualizar o endereço do sistema',
      'Update user' => 'Actualizar o usuário',
      'With State' => 'Com Estado',
      'You have to be in the admin group!' => 'Tem que estar no grupo admin!',
      'You have to be in the stats group!' => 'Ttem que estar no grupo stats!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Precisa de um endereço de email (ex:cliente@exemplo.com.br) no From:!',
      'auto responses set' => 'auto-respostas activas',
      'search' => 'buscar',
      'search (e. g. 10*5155 or 105658*)' => 'buscar (exemplo: 1055155 ou 105658*)',
      'store' => 'armazenar',
      'tickets' => 'tickets',
      'valid' => 'válido',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
