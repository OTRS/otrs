# --
# Kernel/Language/pt.pm - provides pt language translation
# Copyright (C) 2004 CAT <filipehenriques at ip.pt>
# --
# $Id: pt.pm,v 1.5 2004-02-02 23:56:39 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::pt;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Feb  3 00:43:42 2004 by 

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
      '10 minutes' => '10 minutos',
      '15 minutes' => '15 minutos',
      'AddLink' => 'Adicionar link',
      'Admin-Area' => 'Área de Administração',
      'agent' => 'Agente',
      'Agent-Area' => 'Área de Agente',
      'all' => 'todos',
      'All' => 'Todos',
      'Attention' => 'Atenção',
      'before' => '',
      'Bug Report' => 'Relatório de Erros',
      'Cancel' => 'Cancelar',
      'change' => 'alterar',
      'Change' => 'Alterar',
      'change!' => 'alterar!',
      'click here' => 'clique aqui',
      'Comment' => 'Comentário',
      'Customer' => 'Cliente',
      'customer' => 'cliente',
      'Customer Info' => 'Informação do Cliente',
      'day' => 'dia',
      'day(s)' => '',
      'days' => 'dias',
      'description' => 'descrição',
      'Description' => 'Descrição',
      'Dispatching by email To: field.' => 'Despachado pelo campo de email Para:',
      'Dispatching by selected Queue.' => 'Despachado pela Queue seleccionada',
      'Don\'t show closed Tickets' => 'Não mostrar Tickets fechados',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Não trabalhe com o UserID 1(Conta de Sistema)! Criar novos utilizadores!',
      'Done' => 'Feito',
      'end' => 'fim',
      'Error' => 'Erro',
      'Example' => 'Exemplo',
      'Examples' => 'Exemplos',
      'Facility' => 'Facilidade',
      'FAQ-Area' => 'Área FAQ',
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
      'last' => '',
      'Line' => 'Linha',
      'Lite' => 'Lite',
      'Login failed! Your username or password was entered incorrectly.' => 'Login inválido! O utilizador ou password foram introduzidos incorrectamente.',
      'Logout successful. Thank you for using OTRS!' => 'Saiu com sucesso. Obrigado por utilizar o OTRS!',
      'Message' => 'Mensagem',
      'minute' => 'minuto',
      'minutes' => 'minutos',
      'Module' => 'Módulo',
      'Modulefile' => 'Ficheiro de Módulo',
      'month(s)' => '',
      'Name' => 'Nome',
      'New Article' => 'Novo Artigo',
      'New message' => 'Nova mensagem',
      'New message!' => 'Nova mensagem!',
      'No' => 'Não',
      'no' => 'não',
      'No entry found!' => 'Sem resultados',
      'No suggestions' => 'Sem sugestões',
      'none' => 'Nada',
      'none - answered' => 'nada  - respondido',
      'none!' => 'Nada!',
      'Normal' => '',
      'Off' => 'Desligado',
      'off' => 'desligado',
      'On' => 'Ligado',
      'on' => 'ligado',
      'Password' => 'Senha de Acesso',
      'Pending till' => 'Pendente até',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Por favor, responda a este(s) ticket(s) para retornar à vista normal da Queue!',
      'Please contact your admin' => 'Por Favor contactar o administrador',
      'please do not edit!' => 'por favor não editar!',
      'Please go away!' => 'Sair, por favor',
      'possible' => 'possível',
      'Preview' => '',
      'QueueView' => 'QueueView',
      'reject' => 'rejeitar',
      'replace with' => 'substituir por',
      'Reset' => 'Reset',
      'Salutation' => 'Saudação',
      'Session has timed out. Please log in again.' => 'A sessão expirou. Por favor autentique-se novamente',
      'Show closed Tickets' => 'Mostrar Tickets fechados',
      'Signature' => 'Assinatura',
      'Sorry' => 'Desculpe',
      'Stats' => 'Estatísticas',
      'Subfunction' => 'Sub-função',
      'submit' => 'Submeter',
      'submit!' => 'Submeter!',
      'system' => 'Sistema',
      'Take this User' => 'Utilize este utilizador',
      'Text' => 'Texto',
      'The recommended charset for your language is %s!' => 'O conjunto de caracteres recomendado para o seu idioma é %s!',
      'Theme' => 'Tema',
      'There is no account with that login name.' => 'Não existe conta com esse utilizador',
      'Timeover' => 'Tempo esgotado',
      'To: (%s) replaced with database email!' => 'Para: (%s) substituido pelo email da base de dados',
      'top' => 'início',
      'update' => 'actualizar',
      'Update' => '',
      'update!' => 'actualizar!',
      'User' => 'Utilizador',
      'Username' => 'Nome de Utilizador',
      'Valid' => 'Válido',
      'Warning' => 'Aviso',
      'week(s)' => '',
      'Welcome to OTRS' => 'Bem-vindo ao OTRS',
      'Word' => 'Palavra',
      'wrote' => 'escreveu',
      'year(s)' => '',
      'yes' => 'sim',
      'Yes' => 'Sim',
      'You got new message!' => 'Recebeu uma mensagem nova',
      'You have %s new message(s)!' => 'Tem %s mensagem(s) nova(s)!',
      'You have %s reminder ticket(s)!' => 'Tem %s lembrete(s)',

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
      'Max. shown Tickets a page in Overview.' => 'Nº máximo de tickets por página em OverView ',
      'Max. shown Tickets a page in QueueView.' => 'Nº máximo de tickets por página em QueueView',
      'Move notification' => 'Notificação de movimentos',
      'New ticket notification' => 'Notificação de novo ticket',
      'Other Options' => 'Outras Opções',
      'PhoneView' => 'Chamada',
      'Preferences updated successfully!' => 'Preferências actualizadas com sucesso!',
      'QueueView refresh time' => 'Tempo de refresh da QueueView',
      'Screen after new phone ticket' => 'Ecrã após novo ticket',
      'Select your default spelling dictionary.' => 'Seleccionar o seu corrector ortográfico',
      'Select your frontend Charset.' => 'Selecionar o Conjunto de Caracteres da sua Interface .',
      'Select your frontend language.' => 'Selecionar o Idioma da sua Interface.',
      'Select your frontend QueueView.' => 'Selecionar o seu Interface da QueueView.',
      'Select your frontend Theme.' => 'Selecionar o Tema do seu Interface.',
      'Select your QueueView refresh time.' => 'Selecionar o tempo de refresh da QueueView',
      'Select your screen after creating a new ticket via PhoneView.' => 'Seleccionar ecrã após criação de novo ticket via Chamada.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Notificar se um cliente enviar um follow up e sou o owner desse ticket.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Notificar se um ticket for movido para uma Queue personalizada',
      'Send me a notification if a ticket is unlocked by the system.' => 'Notificar se um ticket for desbloqueado pelo sistema.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Notificar se há um novo ticket nas minhas Queues personalizadas.',
      'Show closed tickets.' => 'Mostrar tickets fechados',
      'Spelling Dictionary' => 'Corrector Ortográfico',
      'Ticket lock timeout notification' => 'Notificação de bloqueio por tempo expirado',
      'TicketZoom' => 'Detalhes do ticket',

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
      'If it is not displayed correctly,' => 'Se ele não for exibido correctamente,',
      'lock' => 'bloquear',
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
      'Queue' => 'Queue',
      'removed' => 'removido',
      'Sender' => 'Remetente',
      'sms' => 'sms',
      'State' => 'Estado',
      'Subject' => 'Assunto',
      'This is a' => 'Este é um',
      'This is a HTML email. Click here to show it.' => 'Este é um email HTML. Clicar aqui para mostrar.',
      'This message was written in a character set other than your own.' => 'Esta mensagem foi escrita utilizando um conjunto de caracteres diferente do seu.',
      'Ticket' => 'Ticket',
      'Ticket "%s" created!' => 'Ticket "%s" criados!',
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
      'Add' => 'Adicionar',
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
      'to get the from line of the email' => 'para obter a linha "De" do email',
      'to get the realname of the sender (if given)' => 'para obter o nome do remetente (se possuir no email)',
      'to get the ticket id of the ticket' => 'para obter o ID do ticket',
      'to get the ticket number of the ticket' => 'para obter o número do ticket',
      'Type' => 'Tipo',
      'Useable options' => 'Opções acessíveis',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Gestão de Users de Clientes',
      'Customer user will be needed to to login via customer panels.' => 'Um user de cliente é necessário para se logar pelo painel de clientes',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Modificar %s configurações',
      'Customer User <-> Group Management' => 'Personalizar Utilizador <-> Grupo de Gestão',
      'Full read and write access to the tickets in this group/queue.' => 'Acesso total de leitura e escrita para os tickets neste grupo/Queue.',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Se nada for seleccionado, então não há permissões neste grupo (tickets não estaram disponíveis para o utilizador).',
      'Permission' => 'Permissão',
      'Read only access to the ticket in this group/queue.' => 'Acesso apenas de leitura para o ticket neste grupo/Queue.',
      'ro' => 'ro',
      'rw' => 'rw',
      'Select the user:group permissions.' => 'Seleccionar o utilizador:permissões de grupo.',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Modificar users <-> configurações de grupos',

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Email do Admin.',
      'Body' => 'Corpo',
      'OTRS-Admin Info!' => 'Informação do Administrador do OTRS!',
      'Recipents' => 'Destinatários',
      'send' => 'enviar',

    # Template: AdminEmailSent
      'Message sent to' => 'Mensagem enviada para',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Crie novos grupos para manipular as permissões de acesso para diferentes grupos de agentes (exemplos: departamento de compras, departamento de suporte, departamento de vendas, etc...).',
      'Group Management' => 'Gestão de Grupos',
      'It\'s useful for ASP solutions.' => 'Isto é útil para soluções ASP.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'O grupo admin é para uso na área de administração e o grupo estatísticas é para uso na área de estatísticas.',

    # Template: AdminLog
      'System Log' => 'Registro do Sistema',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Email do Administrador',
      'Attachment <-> Response' => 'Anexo <-> Resposta',
      'Auto Response <-> Queue' => 'Auto-Respostas <-> Queue',
      'Auto Responses' => 'Auto-Respostas',
      'Customer User' => 'Utilizador de Cliente',
      'Customer User <-> Groups' => 'Utilizador de Cliente <-> Grupos',
      'Email Addresses' => 'Endereços de Emails',
      'Groups' => 'Grupos',
      'Logout' => 'Sair',
      'Misc' => 'Variedades',
      'Notifications' => 'Notificações',
      'PostMaster Filter' => '',
      'PostMaster POP3 Account' => '',
      'Responses' => 'Respostas',
      'Responses <-> Queue' => 'Respostas <-> Queues',
      'Select Box' => 'Caixa de Seleção',
      'Session Management' => 'Gestão de Sessões',
      'Status' => 'Status',
      'System' => 'Sistema',
      'User <-> Groups' => 'Utilizador <-> Grupos',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
      'Notification Management' => 'Gestão de Notificação',
      'Notifications are sent to an agent or a customer.' => '',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Todos os emails de entrada com uma conta será despachado na Queue selecionada!',
      'Dispatching' => 'Despachando',
      'Host' => 'Anfitrião',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Se sua conta é confiável, os cabeçalhos x-otrs (para prioridade, ...) serão utilizados!',
      'Login' => 'Login',
      'POP3 Account Management' => 'Gestão de Contas POP3',
      'Trusted' => 'Confiável',

    # Template: AdminPostMasterFilterForm
      'Match' => '',
      'PostMasterFilter Management' => '',
      'Set' => '',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Gestão de Queues <-> Auto-Resposta',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = sem escalamento',
      '0 = no unlock' => '0 = sem desbloqueio',
      'Customer Move Notify' => 'Movimento de Cliente Notificado',
      'Customer Owner Notify' => 'Owner de Cliente Notificado',
      'Customer State Notify' => 'Estado de Cliente Notificado',
      'Escalation time' => 'Tempo de escalamento',
      'Follow up Option' => 'Opção de follow up',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Se um ticket está fechado e um cliente envia um follow up, este mesmo ticket será bloqueado para o antigo proprietário.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Se um ticket não foi respondido dentro deste tempo, apenas os tickets com este tempo vencido serão exibidos.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Se um agente bloqueia um ticket e ele não envia uma resposta dentro deste tempo, o ticket será desbloqueado automaticamente. Então o ticket será visível para todos os outros agentes.',
      'Key' => 'Chave',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS envia um email de  notificação para o cliente se ticket for movido.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS envia um email de notificação se o owner do ticket for alterado.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS envia um email de notificação se o estado do ticket for alterado.',
      'Queue Management' => 'Gestão de Queues',
      'Sub-Queue of' => 'Sub-Queue de',
      'Systemaddress' => 'Endereço do Sistema',
      'The salutation for email answers.' => 'A saudação para as respostas de emails.',
      'The signature for email answers.' => 'A assinatura para as respostas de emails.',
      'Ticket lock after a follow up' => 'Bloqueio do bilhete após os follow ups',
      'Unlock timeout' => 'Tempo de desbloqueio',
      'Will be the sender address of this queue for email answers.' => 'Será o endereço de email de respostas desta Queue.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Respostas Padrão <-> Gestão de Queues',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Resposta',
      'Change answer <-> queue settings' => 'Modificar respostas <-> configurações de Queues',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Respostas Padrão <-> Gestão Anexos Padrão',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Modificar Resposta <-> Configurações de Anexos',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Uma resposta é um texto padrão para compôr respostas rápidas (com texto padrão) para clientes.',
      'Don\'t forget to add a new response a queue!' => 'Não se esqueça de adicionar a nova resposta a uma Queue!',
      'Next state' => 'Próximo estado',
      'Response Management' => 'Gestão de Respostas',
      'The current ticket state is' => 'O estado corrento do ticket é',

    # Template: AdminSalutationForm
      'customer realname' => 'Nome do cliente',
      'for agent firstname' => 'Nome do Agente',
      'for agent lastname' => 'Sobrenome do Agente',
      'for agent login' => 'para login de agente',
      'for agent user id' => 'para ID de utilizador de agente',
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
      'Overview' => 'Overview',
      'Sessions' => 'Sessões',
      'Uniq' => 'Único',

    # Template: AdminSessionTable
      'kill session' => 'Finalizar sessão',
      'SessionID' => 'Identificação da sessão',

    # Template: AdminSignatureForm
      'Signature Management' => 'Gestão de Assinaturas',

    # Template: AdminStateForm
      'See also' => 'Ver também',
      'State Type' => 'Estado Tipo',
      'System State Management' => 'Gestão de Estados do Sistema',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Ter em conta que também actualizaste',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Todos os emails de entrada com este Email(Para:) serão despachados na Queue selecionada!',
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
      'create' => 'Criar',
      'move_into' => 'Mover para',
      'owner' => 'Dono',
      'Permissions to change the ticket owner in this group/queue.' => '',
      'Permissions to change the ticket priority in this group/queue.' => '',
      'Permissions to create tickets in this group/queue.' => '',
      'Permissions to move tickets into this group/queue.' => '',
      'priority' => '',
      'User <-> Group Management' => 'Users <-> Gestão de Grupos',

    # Template: AdminUserGroupForm

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBook
      'Address Book' => '',
      'Discard all changes and return to the compose screen' => 'Descartar todas as modificações e retornar para o ecrã de composição',
      'Return to the compose screen' => 'Retornar para o ecrã de composição',
      'Search' => '',
      'The message being composed has been closed.  Exiting.' => 'A mensagem sendo composta foi fechada. Saindo.',
      'This window must be called from compose window' => 'Esta janela deve ser chamada da janela de composição',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Uma mensagem deve possuir um Para: destinatário!',
      'Bounce ticket' => 'Devolver bilhete',
      'Bounce to' => 'Devolver para',
      'Inform sender' => 'Informe o remetente',
      'Next ticket state' => 'Próximo estado do ticket',
      'Send mail!' => 'Enviar email!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Precisa de um endereço de email (exemplo: cliente@exemplo.pt) no Para:!',
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
      'Attach' => 'Anexo',
      'Compose answer for ticket' => 'Compôr uma resposta para o ticket',
      'for pending* states' => 'em estado pendente*',
      'Is the ticket answered' => 'O ticket foi respondido',
      'Pending Date' => 'Data de Pendência',

    # Template: AgentCustomer
      'Back' => 'Retornar',
      'Change customer of ticket' => 'Modificar o cliente do ticket',
      'CustomerID' => 'Id.do Cliente',
      'Search Customer' => 'Procurar cliente',
      'Set customer user and customer id of a ticket' => '',

    # Template: AgentCustomerHistory
      'All customer tickets.' => 'Todos os Tickets do utilizador',
      'Customer history' => 'Histórico do cliente',

    # Template: AgentCustomerMessage
      'Follow up' => 'Follow up',

    # Template: AgentCustomerView
      'Customer Data' => 'Dados do Cliente',

    # Template: AgentForward
      'Article type' => 'Tipo de artigo',
      'Date' => 'Data',
      'End forwarded message' => 'Terminar mensagem encaminhada',
      'Forward article of ticket' => 'Encaminhar o artigo do Ticket',
      'Forwarded message from' => 'Mensagem encaminhada de',
      'Reply-To' => 'Responder-Para',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Alterar Texto livre do Ticket',
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
      'Reminder' => 'Lembretes',
      'Reminder messages' => 'Mensagens com lembretes',
      'Sort by' => 'Ordenado pela',
      'Tickets' => 'Tickets',
      'up' => 'normal',

    # Template: AgentMailboxTicket
      '"}' => '',
      '"}","14' => '',

    # Template: AgentMove
      'All Agents' => 'Todos os Agentes',
      'Move Ticket' => 'Mover Ticket',
      'New Owner' => 'Novo Proprietário',
      'New Queue' => 'Nova Queue',
      'Previous Owner' => 'Pro+rietário Anterior',
      'Queue ID' => 'ID da Queue',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Tickets bloqueados',
      'new message' => 'Nova mensagem',
      'Preferences' => 'Preferências',
      'Utilities' => 'Utilitários',

    # Template: AgentNote
      'Add note to ticket' => 'Adicionar nota ao Ticket',
      'Note!' => 'Nota!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Modificar o proprietário do Ticket',
      'Message for new Owner' => 'Mensagem para um novo Proprietário',

    # Template: AgentPending
      'Pending date' => 'Data da pendência',
      'Pending type' => 'Tipo de pendência',
      'Pending!' => 'Pendente!',
      'Set Pending' => 'Definir como Pendente',

    # Template: AgentPhone
      'Customer called' => 'Cliente contactado',
      'Phone call' => 'Chamada telefónica',
      'Phone call at %s' => 'Chamada telefónica ás %s',

    # Template: AgentPhoneNew
      'Clear From' => 'Limpar "De:"',
      'Lock Ticket' => 'Bloquear Ticket',
      'new ticket' => 'novo ticket',

    # Template: AgentPlain
      'ArticleID' => 'Id.do artigo',
      'Plain' => 'Texto',
      'TicketID' => 'TicketID',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Seleccione a sua Queue personalizada',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Modificar Password',
      'New password' => 'Nova password',
      'New password again' => 'Re-introduza a nova password',

    # Template: AgentPriority
      'Change priority of ticket' => 'Modificar a prioridade do ticket',

    # Template: AgentSpelling
      'Apply these changes' => 'Aplicar estas modificações',
      'Spell Checker' => 'Verificar a Ortografica',
      'spelling error(s)' => 'erro(s) ortográficos',

    # Template: AgentStatusView
      'D' => 'D',
      'of' => 'de',
      'Site' => 'Site',
      'sort downward' => 'ordem decrescente',
      'sort upward' => 'ordem crescente',
      'Ticket Status' => 'Estado do ticket',
      'U' => 'C',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLink
      'Link' => '',
      'Link to' => '',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket bloqueado!',
      'Ticket unlock!' => 'Ticket desbloqueado!',

    # Template: AgentTicketPrint
      'by' => 'por',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Tempo contabilizado',
      'Escalation in' => 'Escalado em',

    # Template: AgentUtilSearch
      '(e. g. 10*5155 or 105658*)' => '(ex: 10*5155 ou 105658*)',
      '(e. g. 234321)' => '(ex: 234321)',
      '(e. g. U5150)' => '(ex: U5150)',
      'and' => 'e',
      'Customer User Login' => 'Login de Cliente',
      'Delete' => 'Eliminar',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Procura de texto-completo no artigo (ex: "Mar*in" ou "Baue*")',
      'No time settings.' => 'Sem definições de tempo',
      'Profile' => 'Perfil',
      'Result Form' => 'Formulário de resultado',
      'Save Search-Profile as Template?' => 'Guardar Perfil de Procura como Template',
      'Search-Template' => 'Template de procura',
      'Select' => 'Seleccionar',
      'Ticket created' => 'Ticket criado',
      'Ticket created between' => 'Ticket criado entre',
      'Ticket Search' => 'Procura de Tickets',
      'TicketFreeText' => 'Texto liver do Ticket',
      'Times' => 'Vezes',
      'Yes, save it with name' => 'Sim, guardar com o nome',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Procura no Histórico do cliente',
      'Customer history search (e. g. "ID342425").' => 'Procura no Histórico do cliente (exemplo: "ID342425")',
      'No * possible!' => 'Não são possíveis *!',

    # Template: AgentUtilSearchNavBar
      'Change search options' => 'Alterar opções de procura',
      'Results' => 'Resultados',
      'Search Result' => 'Resultado de Procura',
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
      'All closed tickets' => 'Todos os Tickets fechados',
      'All open tickets' => 'Todos os tickets abertos',
      'closed tickets' => 'Tickets fechados',
      'open tickets' => 'Tickets abertos',
      'or' => 'ou',
      'Provides an overview of all' => 'Dá uma visão geral de todos os',
      'So you see what is going on in your system.' => 'Então, você vê o que está a acontecer no seu sistema.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Compor Follow up',
      'Your own Ticket' => 'O seu Ticket',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Compôr resposta',
      'Contact customer' => 'Contactar cliente',
      'phone call' => 'chamada telefónica',

    # Template: AgentZoomArticle
      'Split' => 'Dividir',

    # Template: AgentZoomBody
      'Change queue' => 'Modificar Queue',

    # Template: AgentZoomHead
      'Free Fields' => 'Campos Livres',
      'Print' => 'Imprimir',

    # Template: AgentZoomStatus
      '"}","18' => '',

    # Template: CustomerCreateAccount
      'Create Account' => 'Criar Conta',

    # Template: CustomerError
      'Traceback' => 'Retroceder',

    # Template: CustomerFAQArticleHistory
      'Edit' => 'Editar',
      'FAQ History' => 'Histórico da FAQ',

    # Template: CustomerFAQArticlePrint
      'Category' => 'Categorias',
      'Keywords' => 'Palavras Chave',
      'Last update' => 'Última Actualização',
      'Problem' => 'Problema',
      'Solution' => 'Solução',
      'Symptom' => 'Sintoma',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => 'Sistema de Histórico da FAQ',

    # Template: CustomerFAQArticleView
      'FAQ Article' => 'Artigo da FAQ',
      'Modified' => 'Modificado',

    # Template: CustomerFAQOverview
      'FAQ Overview' => 'Resumo da FAQ',

    # Template: CustomerFAQSearch
      'FAQ Search' => 'Procura na FAQ',
      'Fulltext' => 'Texto completo',
      'Keyword' => 'Palavra chave',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => 'Resultado da Procura na FAQ',

    # Template: CustomerFooter
      'Powered by' => 'Produzido por',

    # Template: CustomerHeader
      'Contact' => 'Contacto',
      'Home' => 'Início',
      'Online-Support' => 'Suporte-Online',
      'Products' => 'Produtos',
      'Support' => 'Suporte',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Esqueceu-se da password?',
      'Request new password' => 'Solicitar nova password',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Criar um novo Ticket',
      'FAQ' => 'FAQ',
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
      'Click here to report a bug!' => 'Clicar para reportar um erro!',

    # Template: FAQArticleDelete
      'FAQ Delete' => 'Eliminar FAQ',
      'You really want to delete this article?' => 'Deseja mesmo eliminar este artigo?',

    # Template: FAQArticleForm
      'Comment (internal)' => '',
      'Filename' => 'Nome do Ficheiro',
      'Short Description' => 'Pequena Descrição',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQCategoryForm
      'FAQ Category' => 'Categoria da FAQ',

    # Template: FAQLanguageForm
      'FAQ Language' => 'Idioma da FAQ',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: FAQStateForm
      'FAQ State' => '',

    # Template: Footer
      'Top of Page' => 'Topo da Página',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => 'Criar Base de Dados',
      'Drop Database' => 'Apagar Base de Dados',
      'Finished' => 'Terminado',
      'System Settings' => 'Propriedades de Sistema',
      'Web-Installer' => 'Instalador Web',

    # Template: InstallerFinish
      'Admin-User' => 'Utilizador de Admin',
      'After doing so your OTRS is up and running.' => 'Depois disto o seu OTRS estará completamente funcional',
      'Have a lot of fun!' => 'Divirta-se!',
      'Restart your webserver' => 'Reinicie o seu servidor Web',
      'Start page' => 'Página Inicial',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
      'Your OTRS Team' => 'A sua Equipa OTRS',

    # Template: InstallerLicense
      'accept license' => 'Aceitar licença',
      'don\'t accept license' => 'Não Aceitar licença',
      'License' => 'Licença',

    # Template: InstallerStart
      'Create new database' => 'Criar nova Base de Dados',
      'DB Admin Password' => 'Password Admin da Base de Dados',
      'DB Admin User' => 'Utilizador Admin da Base de Dados',
      'DB Host' => 'Servidor Base de Dados',
      'DB Type' => 'Tipo da Base de Dados',
      'default \'hot\'' => 'por defeito \'hot\'',
      'Delete old database' => 'Eliminar Base de Dados Antiga',
      'next step' => 'próximo passo',
      'OTRS DB connect host' => 'Servidor de ligação da Base de Dados OTRS',
      'OTRS DB Name' => 'Nome da Base de Dados OTRS',
      'OTRS DB Password' => 'Password da Base de Dados OTRS',
      'OTRS DB User' => 'Utilizador Base de Dados OTRS',
      'your MySQL DB should have a root password! Default is empty!' => 'A sua Base de Dados MySQL deve ter uma password de root! Por defeito não tem password!',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '
(Verifica os apontadores de MX quando compoe uma resposta. Não usar caso esteja a usar uma ligação dial-up!)',
      '(Email of the system admin)' => '(Email do administrador do sistema)',
      '(Full qualified domain name of your system)' => '(Nome completo do domínio do seu sistema)',
      '(Logfile just needed for File-LogModule!)' => '(Ficheiro de registo para File-LogModule)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(A identidade do sistema. Cada número de Ticket e cada id. da sessão http, inicia com este número)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      '(Used default language)' => '(Idioma padrão utilizado)',
      '(Used log backend)' => '()',
      '(Used ticket number format)' => '(Formato de Ticket utilizado)',
      'CheckMXRecord' => 'Verificar apontador de MX',
      'Default Charset' => 'Conjunto de Caracteres Padrão',
      'Default Language' => 'Idioma Padrão',
      'Logfile' => 'Ficheiro de Log',
      'LogModule' => 'Módulo de Logs',
      'Organization' => 'Organização',
      'System FQDN' => 'FQDN do sistema',
      'SystemID' => 'ID do sistema',
      'Ticket Hook' => 'Identificador do Ticket',
      'Ticket Number Generator' => 'Gerador de Números de Tickets',
      'Use utf-8 it your database supports it!' => '',
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
      'All tickets' => 'Todos Tickets',
      'Page' => 'Página',
      'Queues' => 'Queues',
      'Tickets available' => 'Tickets disponíveis',
      'Tickets shown' => 'Tickets mostrados',

    # Template: SystemStats
      'Graphs' => 'Gráficos',

    # Template: Test
      'OTRS Test Page' => 'Página de Teste do OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Escalamento de Tickets!',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Adicionar Nota',

    # Template: Warning

    # Misc
      '(Ticket identifier. Some people want to set this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificador do Ticket. Algumas pessoas gostam de usar por exemplo \'Ticket#\, \'Chamada#\' ou \'MeuTicket#\')',
      'A message should have a From: recipient!' => 'Uma mensagem deve conter um De: remetente!',
      'AdminArea' => 'Área de Administração',
      'AgentFrontend' => 'Interface do Agente',
      'Article free text' => 'Texto livre do artigo',
      'Charset' => 'Conjunto de Caracteres',
      'Charsets' => 'Conjunto de Caracteres',
      'Create' => 'Criar',
      'CustomerUser' => 'Utilizador do Cliente',
      'Fulltext search' => 'Procura completa de texto',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Procura completa em todo texto (exemplo: "Fil*e" ou "Henr*" ou "filipe+henriques")',
      'Handle' => 'Manipular',
      'New state' => 'Novo estado',
      'New ticket via call.' => 'Novo Ticket via chamada telefónica.',
      'New user' => 'Novo Utilizador',
      'POP3 Account' => 'Conta POP3',
      'Search in' => 'Procurar em',
      'Set customer id of a ticket' => 'Definir a identificação do cliente de um ticket',
      'Show all' => 'Mostrar todos os',
      'Status defs' => 'Estados',
      'Sympthom' => 'Sintoma',
      'System Charset Management' => 'Gerênciamento de Conjunto de Caracteres do Sistema',
      'System Language Management' => 'Gestão de Idiomas do Sistema',
      'Ticket free text' => 'Texto livre do ticket',
      'Ticket limit:' => 'Limite do Ticket:',
      'Time till escalation' => 'Tempo para escalação',
      'With State' => 'Com Estado',
      'You have to be in the admin group!' => 'Tem que estar no grupo admin!',
      'You have to be in the stats group!' => 'Tem que estar no grupo stats!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Precisa de um endereço de email (ex:cliente@exemplo.pt) no campo De:!',
      'auto responses set' => 'respostas automáticas activas',
      'search' => 'procurar',
      'search (e. g. 10*5155 or 105658*)' => 'procurar (exemplo: 1055155 ou 105658*)',
      'store' => 'armazenar',
      'tickets' => 'tickets',
      'valid' => 'válido',
      'view' => 'Vista',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;

