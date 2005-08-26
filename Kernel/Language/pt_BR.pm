# --
# Kernel/Language/pt_BR.pm - provides pt_BR language translation
# Copyright (C) 2003 Gilberto Cezar de Almeida <gibalmeida at hotmail.com>
# --
# $Id: pt_BR.pm,v 1.28 2005-08-26 15:58:46 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
#Alterado por Glaucia C. Messina (glauglauu@yahoo.com)

package Kernel::Language::pt_BR;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.28 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Jul 28 22:14:43 2005

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
      # Template: AAABase
      'Yes' => 'Sim',
      'No' => 'Não',
      'yes' => 'sim',
      'no' => 'não',
      'Off' => 'Desligado',
      'off' => 'desligado',
      'On' => 'Ligado',
      'on' => 'ligado',
      'top' => 'início',
      'end' => 'fim',
      'Done' => 'Feito',
      'Cancel' => 'Cancelar',
      'Reset' => 'Re-iniciar',
      'last' => 'último',
      'before' => 'antes',
      'day' => 'dia',
      'days' => 'dias',
      'day(s)' => 'dia(s)',
      'hour' => 'hora',
      'hours' => 'horas',
      'hour(s)' => 'hora(s)',
      'minute' => 'minuto',
      'minutes' => 'minutos',
      'minute(s)' => 'minuto(s)',
      'month' => 'mês',
      'months' => 'meses',
      'month(s)' => 'mês(s)',
      'week' => 'semana',
      'week(s)' => 'semana(s)',
      'year' => 'ano',
      'years' => 'anos',
      'year(s)' => 'ano(s)',
      'wrote' => 'escreveu',
      'Message' => 'Mensagem',
      'Error' => 'Erro',
      'Bug Report' => 'Relatório de Erros',
      'Attention' => 'Atenção',
      'Warning' => 'Aviso',
      'Module' => 'Módulo',
      'Modulefile' => 'Arquivo de Módulo',
      'Subfunction' => 'Sub-função',
      'Line' => 'Linha',
      'Example' => 'Exemplo',
      'Examples' => 'Exemplos',
      'valid' => 'válido',
      'invalid' => 'inválido',
      'invalid-temporarily' => 'inválido-temporariamente',
      ' 2 minutes' => ' 2 minutos',
      ' 5 minutes' => ' 5 minutos',
      ' 7 minutes' => ' 7 minutos',
      '10 minutes' => '10 minutos',
      '15 minutes' => '15 minutos',
      'Mr.' => 'Sr.',
      'Mrs.' => 'Sra.',
      'Next' => 'Próximo',
      'Back' => 'Voltar',
      'Next...' => 'Próximo',
      '...Back' => '...Voltar',
      '-none-' => 'vazio',
      'none' => 'vazio',
      'none!' => 'vazio!',
      'none - answered' => 'vazio  - respondido',
      'please do not edit!' => 'Por favor, não edite!',
      'AddLink' => 'Adicionar link',
      'Link' => '',
      'Linked' => '',
      'Link (Normal)' => '',
      'Link (Parent)' => '',
      'Link (Child)' => '',
      'Normal' => '',
      'Parent' => '',
      'Child' => '',
      'Hit' => '',
      'Hits' => '',
      'Text' => 'Texto',
      'Lite' => 'Simples',
      'User' => 'Usuário',
      'Username' => 'Login',
      'Language' => 'Idioma',
      'Languages' => 'Idiomas',
      'Password' => 'Senha',
      'Salutation' => 'Saudação',
      'Signature' => 'Assinatura',
      'Customer' => 'Cliente',
      'CustomerID' => 'ID.Cliente',
      'CustomerIDs' => 'ID.Clientes',
      'customer' => 'cliente',
      'agent' => 'Atendente',
      'system' => 'sistema',
      'Customer Info' => 'Informação do Cliente',
      'go!' => 'ir!',
      'go' => 'ir',
      'All' => 'Todos',
      'all' => 'todos',
      'Sorry' => 'Desculpe',
      'update!' => 'atualizar!',
      'update' => 'atualizar',
      'Update' => 'Atualizar',
      'submit!' => 'Enviar!',
      'submit' => 'enviar',
      'Submit' => 'Enviar',
      'change!' => 'alterar!',
      'Change' => 'Alterar',
      'change' => 'alterar',
      'click here' => 'clique aqui',
      'Comment' => 'Comentário',
      'Valid' => 'Válido',
      'Invalid Option!' => 'Opção Inválida',
      'Invalid time!' => 'Hora Inválida',
      'Invalid date!' => 'Data Inválida',
      'Name' => 'Nome',
      'Group' => 'Grupo',
      'Description' => 'Descrição',
      'description' => 'descrição',
      'Theme' => 'Tema',
      'Created' => 'Criado',
      'Created by' => 'Criado por',
      'Changed' => 'Alterado',
      'Changed by' => 'Alterado por',
      'Search' => 'Procurar',
      'and' => 'e',
      'between' => 'entre',
      'Fulltext Search' => 'Procura por texto completo',
      'Data' => 'Dado',
      'Options' => 'Opções',
      'Title' => 'Título',
      'Item' => '',
      'Delete' => 'Excluir',
      'Edit' => 'Editar',
      'View' => 'Ver',
      'Number' => 'Número',
      'System' => 'Sistema',
      'Contact' => 'Contato',
      'Contacts' => 'Contatos',
      'Export' => 'Exportar',
      'Up' => 'Acima',
      'Down' => 'Abaixo',
      'Add' => 'Adicionar',
      'Category' => 'Categoria',
      'Viewer' => 'Visualização',
      'New message' => 'Nova mensagem',
      'New message!' => 'Nova mensagem!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Por favor, responda este(s) chamado(s) para retornar a fila!',
      'You got new message!' => 'Você recebeu uma nova mensagem',
      'You have %s new message(s)!' => 'Você tem %s nova(s) mensagem(s)!',
      'You have %s reminder ticket(s)!' => 'Você tem %s chamado(s) remanescente(s)',
      'The recommended charset for your language is %s!' => 'O conjunto de caracteres recomendado para o seu idioma é %s!',
      'Passwords dosn\'t match! Please try it again!' => 'Senha não encontrada! Tente de novo!',
      'Password is already in use! Please use an other password!' => 'Senha em uso! Tente outra senha!',
      'Password is already used! Please use an other password!' => 'Senha está sendo utilizada! Tente outra senha!',
      'You need to activate %s first to use it!' => 'Primeiramente ative %s, para uso!',
      'No suggestions' => 'Sem sugestões',
      'Word' => 'Palavra',
      'Ignore' => 'Ignorar',
      'replace with' => 'substituir com',
      'Welcome to OTRS' => 'Bem-vindo ao Service Desk SAP',
      'There is no account with that login name.' => 'Não existe conta com este nome de usuário',
      'Login failed! Your username or password was entered incorrectly.' => 'Login incorreto! Seu Login  ou senha foram informados incorretamente.',
      'Please contact your admin' => 'Por favor, contate administrador do sistema!',
      'Logout successful. Thank you for using OTRS!' => 'Encerrado com sucesso. Obrigado por utilizar o Service Desk SAP!',
      'Invalid SessionID!' => 'Identificação de Sessão Inválida',
      'Feature not active!' => 'Característica não ativada!',
      'Take this Customer' => '',
      'Take this User' => '',
      'possible' => 'possível',
      'reject' => 'rejeitar',
      'Facility' => 'Facilidade',
      'Timeover' => 'Tempo esgotado',
      'Pending till' => 'Gaveta pendente',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Não trabalhe com o UserID 1(Conta do Sistema)! Crie novos usuários!',
      'Dispatching by email To: field.' => 'Despachar pelo PARA:  email',
      'Dispatching by selected Queue.' => 'Despachar pela fila selecionada',
      'No entry found!' => 'Não há entradas!',
      'Session has timed out. Please log in again.' => 'Tempo esgotado de sessão. Entre novamente.',
      'No Permission!' => 'Sem permissão!',
      'To: (%s) replaced with database email!' => 'PARA: (%s)  alterado!',
      'Cc: (%s) added database email!' => 'CC: (%s) adicionado! ',
      '(Click here to add)' => '(Clique aqui para adicionar)',
      'Preview' => 'Visualizar',
      'Added User "%s"' => 'Usuário Adicionado "%s"',
      'Contract' => 'Contrato',
      'Online Customer: %s' => 'Clientes Online: %s',
      'Online Agent: %s' => 'Atendentes Online: %s',
      'Calendar' => 'Calendário',
      'File' => 'Arquivo',
      'Filename' => 'Nome Arquivo',
      'Type' => 'Tipo',
      'Size' => 'Tam',
      'Upload' => '',
      'Directory' => 'Diretório',
      'Signed' => '',
      'Sign' => '',
      'Crypted' => '',
      'Crypt' => '',

      # Template: AAAMonth
      'Jan' => '',
      'Feb' => 'Fev',
      'Mar' => '',
      'Apr' => 'Abr',
      'May' => 'Mai',
      'Jun' => '',
      'Jul' => '',
      'Aug' => 'Ago',
      'Sep' => 'Set',
      'Oct' => 'Out',
      'Nov' => '',
      'Dec' => 'Dez',

      # Template: AAANavBar
      'Admin-Area' => 'Área-Administração',
      'Agent-Area' => 'Área-Atendente',
      'Ticket-Area' => 'Área-Chamado',
      'Logout' => 'Sair',
      'Agent Preferences' => 'Preferências Atendente',
      'Preferences' => 'Preferências',
      'Agent Mailbox' => 'Mailbox Atendente',
      'Stats' => 'Estatísticas',
      'Stats-Area' => 'Área-Estatísticas',
      'FAQ-Area' => 'Base Conhecimento',
      'FAQ' => 'Base Conhecimento',
      'FAQ-Search' => 'Busca Base Conhecimento',
      'FAQ-Article' => 'Artigos Base Conhecimento',
      'New Article' => 'Novo Artigo',
      'FAQ-State' => 'Estado Base Conhecimento',
      'Admin' => '',
      'A web calendar' => 'Calendário',
      'WebMail' => '',
      'A web mail client' => 'Webmail Cliente',
      'FileManager' => 'Adm Arquivo',
      'A web file manager' => 'Adm Arquivo Web',
      'Artefact' => '',
      'Incident' => 'Incidente',
      'Advisory' => '',
      'WebWatcher' => '',
      'Customer Users' => 'Clientes',
      'Customer Users <-> Groups' => 'Clientes <-> Grupos',
      'Users <-> Groups' => 'Usuários <-> Grupos',
      'Roles' => 'Regras',
      'Roles <-> Users' => 'Regras <-> Usuários',
      'Roles <-> Groups' => 'Regras <-> Grupos',
      'Salutations' => 'Saudações',
      'Signatures' => 'Assinaturas',
      'Email Addresses' => 'E-mail',
      'Notifications' => 'Notificações',
      'Category Tree' => 'Categorias',
      'Admin Notification' => 'Notificação Admin',

      # Template: AAAPreferences
      'Preferences updated successfully!' => 'Preferências atualizadas com sucesso!',
      'Mail Management' => 'Gerênciamento Mail',
      'Frontend' => 'Interface',
      'Other Options' => 'Outras Opções',
      'Change Password' => 'Trocar senha',
      'New password' => 'Nova senha',
      'New password again' => 'Redigite a nova senha de novo',
      'Select your QueueView refresh time.' => 'Selecione o tempo de atualização das Filas',
      'Select your frontend language.' => 'Selecione o Idioma.',
      'Select your frontend Charset.' => 'Selecione o Conjunto de Caracteres.',
      'Select your frontend Theme.' => 'Selecione o Tema.',
      'Select your frontend QueueView.' => 'Selecione a Visão da Fila.',
      'Spelling Dictionary' => 'Dicionário (Língua)',
      'Select your default spelling dictionary.' => 'Escolha o seu corretor ortográfico padrão.',
      'Max. shown Tickets a page in Overview.' => 'Max. Chamados em uma tela.',
      'Can\'t update password, passwords dosn\'t match! Please try it again!' => 'Senha não atualizada, por que estão diferentes! Tente novamente!',
      'Can\'t update password, invalid characters!' => 'Senha não atualizada, caracteres inválidos!',
      'Can\'t update password, need min. 8 characters!' => 'Senha não atualizada, digite no mínimo 8 caracteres!',
      'Can\'t update password, need 2 lower and 2 upper characters!' => '',
      'Can\'t update password, need min. 1 digit!' => '',
      'Can\'t update password, need min. 2 characters!' => '',
      'Password is needed!' => 'Senha é obrigatória!',

      # Template: AAATicket
      'Lock' => 'Bloquear',
      'Unlock' => 'Desbloquear',
      'History' => 'Histórico',
      'Zoom' => 'Detalhes',
      'Age' => 'Tempo',
      'Bounce' => 'Devolver',
      'Forward' => 'Encaminhar',
      'From' => 'De',
      'To' => 'Para',
      'Cc' => 'Cópia ',
      'Bcc' => 'Copia Invisível',
      'Subject' => 'Assunto',
      'Move' => 'Mover',
      'Queue' => 'Fila',
      'Priority' => 'Prioridade',
      'State' => 'Estado',
      'Compose' => 'Compôr',
      'Pending' => 'Pendentes',
      'Owner' => 'Proprietário',
      'Owner Update' => 'Atualização Proprietário',
      'Sender' => 'Remetente',
      'Article' => 'Artigo',
      'Ticket' => 'Chamado',
      'Createtime' => 'Hora de criação',
      'plain' => 'texto',
      'eMail' => 'Mail',
      'email' => 'mail',
      'Close' => 'Fechar',
      'Action' => 'Ação',
      'Attachment' => 'Anexo',
      'Attachments' => 'Anexos',
      'This message was written in a character set other than your own.' => 'Esta mensagem foi escrita utilizando um conjunto de caracteres diferente do seu.',
      'If it is not displayed correctly,' => 'Se ele não for exibido corretamente,',
      'This is a' => 'Este é um',
      'to open it in a new window.' => 'para abri-lo em uma nova janela.',
      'This is a HTML email. Click here to show it.' => 'Este e-mail está em formato HTML. Clique aqui para exibi-lo.',
      'Free Fields' => 'Campos Livres',
      'Merge' => 'Mesclar',
      'closed successful' => 'fechado com êxito',
      'closed unsuccessful' => 'fechado sem êxito',
      'new' => 'novo',
      'open' => 'aberto',
      'closed' => 'fechado',
      'removed' => 'removido',
      'pending reminder' => 'lembrete de pendente',
      'pending auto close+' => 'pendente auto fechamento+',
      'pending auto close-' => 'pendente auto fechamento-',
      'email-external' => 'email-externo',
      'email-internal' => 'email-interno',
      'note-external' => 'nota-externa',
      'note-internal' => 'nota-interna',
      'note-report' => 'nota-relatório',
      'phone' => 'telefone',
      'sms' => '',
      'webrequest' => 'Solicitar via web',
      'lock' => 'bloqueado',
      'unlock' => 'desbloquear',
      'very low' => 'muito baixo',
      'low' => 'baixo',
      'normal' => '',
      'high' => 'alto',
      'very high' => 'muito alto',
      '1 very low' => '1 muito baixo',
      '2 low' => '2 baixo',
      '3 normal' => '',
      '4 high' => '4 alto',
      '5 very high' => '5 muito alto',
      'Ticket "%s" created!' => 'Chamado "%s" criado!',
      'Ticket Number' => 'N° Chamado',
      'Ticket Object' => 'Objeto Chamado',
      'No such Ticket Number "%s"! Can\'t link it!' => '',
      'Don\'t show closed Tickets' => 'Não mostrar chamados fechados',
      'Show closed Tickets' => 'Mostrar chamados fechados',
      'Email-Ticket' => 'Chamado-Mail',
      'Create new Email Ticket' => 'Criar novo Mail Chamado',
      'Phone-Ticket' => 'Chamado-Fone',
      'Create new Phone Ticket' => 'Criar novo Fone Chamado',
      'Search Tickets' => 'Pesquisar Chamados',
      'Edit Customer Users' => 'Editar Clientes(Usuários)',
      'Bulk-Action' => '',
      'Bulk Actions on Tickets' => '',
      'Send Email and create a new Ticket' => 'Enviar mail e criar novo Chamado',
      'Overview of all open Tickets' => 'Visão geral de todos Chamados abertos',
      'Locked Tickets' => 'Chamados Bloqueados',
      'Lock it to work on it!' => 'Bloquear para trabalhar com o Chamado!',
      'Unlock to give it back to the queue!' => '',
      'Shows the ticket history!' => 'Apresentar histórico de Chamados',
      'Print this ticket!' => 'Imprimir este Chamado!',
      'Change the ticket priority!' => 'Alterar a prioridade do Chamado!',
      'Change the ticket free fields!' => '',
      'Link this ticket to an other objects!' => '',
      'Change the ticket owner!' => 'Mudar proprietário do Chamado!',
      'Change the ticket customer!' => 'Mudar o Cliente do Chamado',
      'Add a note to this ticket!' => 'Adicionar um Note neste Chamado!',
      'Merge this ticket!' => '',
      'Set this ticket to pending!' => 'Marcar este Chamado como Pendente!',
      'Close this ticket!' => 'Feche este chamado!',
      'Look into a ticket!' => 'Olhe conteúdo de um chamado!',
      'Delete this ticket!' => 'Apague este Chamado',
      'Mark as Spam!' => 'Marque como Spam',
      'My Queues' => 'Minhas Filas',
      'Shown Tickets' => 'Mostrar Chamados',
      'New ticket notification' => 'Notificação de novo Chamado',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Envie-me uma notificação se há um Novo Chamado em "Minhas Filas".',
      'Follow up notification' => 'Notificação de continuação',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Notifique me se um cliente enviar uma continuação e sou o proprietário do Chamado.',
      'Ticket lock timeout notification' => 'Notificação de bloqueio por tempo expirado',
      'Send me a notification if a ticket is unlocked by the system.' => 'Notifique me se um Chamado é desbloqueado pelo sistema.',
      'Move notification' => 'Notificação de movimentos',
      'Send me a notification if a ticket is moved into one of "My Queues".' => 'Notifique-me se  Chamados foram movimentados para "Minhas Filas"',
      'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.' => '',
      'Custom Queue' => 'Fila Personalizada',
      'QueueView refresh time' => 'Tempo de atualização das Filas',
      'Screen after new ticket' => '',
      'Select your screen after creating a new ticket.' => '',
      'Closed Tickets' => 'Chamados Fechados',
      'Show closed tickets.' => 'Apresentar chamados fechados.',
      'Max. shown Tickets a page in QueueView.' => 'N° máximo de chamados apresentados por página.',
      'Responses' => 'Respostas',
      'Responses <-> Queue' => 'Respostas <-> Fila',
      'Auto Responses' => 'Auto respostas',
      'Auto Responses <-> Queue' => 'Auto respostas <-> Fila',
      'Attachments <-> Responses' => 'Anexos <-> respostas',
      'History::Move' => 'Chamado foi movido para a Fila "%s" (%s) vinda da Fila "%s" (%s).',
      'History::NewTicket' => 'Novo Chamado  [%s] foi criado (Q=%s;P=%s;S=%s).',
      'History::FollowUp' => 'FollowUp for [%s]. %s',
      'History::SendAutoReject' => 'Rejeição automática enviada para "%s".',
      'History::SendAutoReply' => 'Auto Resposta enviada para "%s".',
      'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
      'History::Forward' => 'Forwarded to "%s".',
      'History::Bounce' => 'Bounced to "%s".',
      'History::SendAnswer' => 'Email enviado para "%s".',
      'History::SendAgentNotification' => '"%s"-notificação enviada para "%s".',
      'History::SendCustomerNotification' => 'Notificação enviada para "%s".',
      'History::EmailAgent' => 'Email enviado para Cliente.',
      'History::EmailCustomer' => 'Email adicionado. %s',
      'History::PhoneCallAgent' => 'Atendente telefonou para Cliente.',
      'History::PhoneCallCustomer' => 'Cliente telefonou para Service Desk SAP.',
      'History::AddNote' => 'Nota adicionada (%s)',
      'History::Lock' => 'Chamado Bloqueado.',
      'History::Unlock' => 'Chamado Desbloqueado.',
      'History::TimeAccounting' => '%s time unit(s) accounted. Now total %s time unit(s).',
      'History::Remove' => '%s',
      'History::CustomerUpdate' => 'Atualizado: %s',
      'History::PriorityUpdate' => 'Prioridade atualizada por "%s" (%s) to "%s" (%s).',
      'History::OwnerUpdate' => 'Novo proprietário é "%s" (ID=%s).',
      'History::LoopProtection' => 'Proteção de Loop! Auto resposta enviada para "%s".',
      'History::Misc' => '%s',
      'History::SetPendingTime' => 'Atualizado: %s',
      'History::StateUpdate' => 'Old: "%s" Novo: "%s"',
      'History::TicketFreeTextUpdate' => 'Atualizado: %s=%s;%s=%s;',
      'History::WebRequestCustomer' => 'Requisição do Cliente via web.',
      'History::TicketLinkAdd' => 'Adicionados links ao Chamado "%s".',
      'History::TicketLinkDelete' => 'Links do Chamado Excluídos "%s".',

      # Template: AAAWeekDay
      'Sun' => 'Dom',
      'Mon' => 'Seg',
      'Tue' => 'Ter',
      'Wed' => 'Qua',
      'Thu' => 'Qui',
      'Fri' => 'Sex',
      'Sat' => 'Sab',

      # Template: AdminAttachmentForm
      'Attachment Management' => 'Administração de Anexos',

      # Template: AdminAutoResponseForm
      'Auto Response Management' => 'Administração de Auto-Respostas',
      'Response' => 'Resposta',
      'Auto Response From' => 'Auto-Resposta De',
      'Note' => 'Nota',
      'Useable options' => 'Opções acessíveis',
      'to get the first 20 character of the subject' => 'para obter os 20 primeiros caracteres do assunto',
      'to get the first 5 lines of the email' => 'para obter as 5 primeiras linhas do email',
      'to get the from line of the email' => 'para obter a linha "From" do email',
      'to get the realname of the sender (if given)' => 'para obter o nome do remetente (se possuir no email)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'A mensagem sendo composta foi fechada. Saindo.',
      'This window must be called from compose window' => 'Esta janela deve ser chamada da janela de composição',
      'Customer User Management' => 'Administração de Clientes',
      'Search for' => 'Pesquisar por',
      'Result' => 'Resultado',
      'Select Source (for add)' => 'Selecione Origem (para adição)',
      'Source' => 'Origem',
      'This values are read only.' => 'Estes valores são apenas para leitura.',
      'This values are required.' => 'Estes valores são obrigatórios.',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => '',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => 'Clientes <-> Admin Grupos',
      'Change %s settings' => 'Modificar %s configurações',
      'Select the user:group permissions.' => 'Selecionar as permissões de  usuário:grupo.',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
      'Permission' => 'Permissões',
      'ro' => '',
      'Read only access to the ticket in this group/queue.' => 'Acesso Somente com Leitura de chamados neste grupo/fila',
      'rw' => '',
      'Full read and write access to the tickets in this group/queue.' => 'Acesso leitura e escrita  de chamados neste grupo/fila',

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Mensagem enviada para',
      'Recipents' => 'Destinatários',
      'Body' => 'Corpo',
      'send' => 'enviar',

      # Template: AdminGenericAgent
      'GenericAgent' => '',
      'Job-List' => '',
      'Last run' => '',
      'Run Now!' => 'Executar Agora',
      'x' => '',
      'Save Job as?' => '',
      'Is Job Valid?' => '',
      'Is Job Valid' => '',
      'Schedule' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      'Customer User Login' => 'Cliente Login',
      '(e. g. U5150)' => '',
      'Agent' => 'Atendente',
      'TicketFreeText' => 'Texto livre Chamado',
      'Ticket Lock' => 'Chamado bloqueado',
      'Times' => 'Hora',
      'No time settings.' => 'Sem configurações de hora.',
      'Ticket created' => 'Chamado criado',
      'Ticket created between' => 'Chamado criado entre',
      'New Priority' => 'Nova Prioridade',
      'New Queue' => 'Nova Fila',
      'New State' => 'Novo Estado',
      'New Agent' => 'Novo Atendente',
      'New Owner' => 'Novo Proprietário',
      'New Customer' => 'Novo Cliente',
      'New Ticket Lock' => 'Chamado novo bloqueado',
      'CustomerUser' => 'Usuário Cliente',
      'Add Note' => 'Adicionar Nota',
      'CMD' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Delete tickets' => 'Excluir Chamados',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Alerta! Este Chamado será removido da base de dados! Este Chamado esrá perdido permanentemente!',
      'Modules' => 'Modulos',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Save' => 'Salvar',

      # Template: AdminGroupForm
      'Group Management' => 'Admin de Grupos',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'O grupo admin é para uso na área de administração e o grupo stats é para uso na área de estatísticas.',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Crie novos grupos para manipular as permissões de acesso para diferentes grupos de agentes (exemplos: departamento de compras, departamento de suporte, departamento de vendas, etc...).',
      'It\'s useful for ASP solutions.' => 'Isto é útil para soluções ASP.',

      # Template: AdminLog
      'System Log' => 'Registro do Sistema',
      'Time' => 'Hora',

      # Template: AdminNavigationBar
      'Users' => 'Usuários',
      'Groups' => 'Grupos',
      'Misc' => 'Variedades',

      # Template: AdminNotificationForm
      'Notification Management' => 'Admin de Notificações',
      'Notification' => 'Notificações',
      'Notifications are sent to an agent or a customer.' => 'Notificações serão enviadas a um Agent ou a um Cliente.',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',

      # Template: AdminPackageManager
      'Package Manager' => 'Admin Pacotes',
      'Uninstall' => 'Desinstalar',
      'Verion' => 'Versão',
      'Do you really want to uninstall this package?' => '',
      'Install' => 'Instalar',
      'Package' => 'Pacotes',
      'Online Repository' => 'Repositório OnLine',
      'Version' => 'Versão',
      'Vendor' => 'Vendedor',
      'Upgrade' => '',
      'Local Repository' => '',
      'Status' => '',
      'Overview' => '',
      'Download' => '',
      'Rebuild' => '',
      'Reinstall' => '',

      # Template: AdminPGPForm
      'PGP Management' => '',
      'Identifier' => '',
      'Bit' => '',
      'Key' => 'Chave',
      'Fingerprint' => '',
      'Expires' => '',
      'In this way you can directly edit the keyring configured in SysConfig.' => '',

      # Template: AdminPOP3Form
      'POP3 Account Management' => 'Gerênciamento de Contas POP3',
      'Host' => '',
      'Trusted' => 'Confiável',
      'Dispatching' => 'Despachando',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Todos os emails de entrada com uma conta será despachado na fila selecionada!',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => 'Adm Filtros Postmaster',
      'Filtername' => 'Nome Filtro',
      'Match' => 'Busca',
      'Header' => 'Cabeçalho',
      'Value' => 'Valor',
      'Set' => '',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => 'Fila <-> Adm de Auto respostas',

      # Template: AdminQueueAutoResponseTable

      # Template: AdminQueueForm
      'Queue Management' => 'Admin de Filas',
      'Sub-Queue of' => 'Sub-Fila de',
      'Unlock timeout' => 'Tempo de expiração de desbloqueio',
      '0 = no unlock' => '0 = sem desbloqueio',
      'Escalation time' => 'Tempo de escalação',
      '0 = no escalation' => '0 = sem escalação',
      'Follow up Option' => 'Opção de continuação',
      'Ticket lock after a follow up' => 'Bloqueio do chamado após as continuações',
      'Systemaddress' => 'Endereço do Sistema',
      'Customer Move Notify' => 'Cliente Notificar Alteração',
      'Customer State Notify' => 'Cliente Notificar Estado',
      'Customer Owner Notify' => 'Cliente Notificar Proprietário',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Se um Atendente bloquear um chamado e ele não enviar uma resposta dentro deste tempo, o Chamado será desbloqueado automaticamente. Então o Chamado será visível para todos Atendentes.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Se um Chamado, não for respondido dentro do prazo, serão apresentados.',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Se um chamado está fechado e um cliente envia uma continuação, este mesmo chamado será bloqueado para o antigo proprietário.',
      'Will be the sender address of this queue for email answers.' => 'Será o endereço de email de respostas desta fila.',
      'The salutation for email answers.' => 'A saudação para as respostas de emails.',
      'The signature for email answers.' => 'A assinatura para as respostas de emails.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => '',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => '',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => '',

      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => 'Respostas <-> Adm Fila',

      # Template: AdminQueueResponsesForm
      'Answer' => 'Resposta',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => 'Respostas <-> Admin Anexos',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'Admin Respostas',
      'A response is default text to write faster answer (with default text) to customers.' => 'Uma resposta padrão foi composta, para respostas rápidas (com texto padrão) para clientes.',
      'Don\'t forget to add a new response a queue!' => 'Não se esqueça de adicionar a nova resposta a uma fila!',
      'Next state' => 'Novo Estado',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'The current ticket state is' => 'O Estado do Chamado é ',
      'Your email address is new' => 'Seu  mail é novo',

      # Template: AdminRoleForm
      'Role Management' => 'Regras Admin',
      'Create a role and put groups in it. Then add the role to the users.' => 'Crie uma regra e relacione grupos a ele. Então adicione regras aos usuários. ',
      'It\'s useful for a lot of users and groups.' => '',

      # Template: AdminRoleGroupChangeForm
      'Roles <-> Groups Management' => 'Regras <-> Admin Grupos',
      'move_into' => 'mova_para',
      'Permissions to move tickets into this group/queue.' => 'Permissões para movimento de Chamados neste grupo/fila.',
      'create' => 'criar',
      'Permissions to create tickets in this group/queue.' => 'Permissões para criar Chamados neste grupo/fila. ',
      'owner' => 'proprietário',
      'Permissions to change the ticket owner in this group/queue.' => 'Permissões para alterar o Chamado neste grupo/fila.  ',
      'priority' => 'prioridade',
      'Permissions to change the ticket priority in this group/queue.' => 'Permissões para alterar o proprietário neste grupo/fila.',

      # Template: AdminRoleGroupForm
      'Role' => 'Regra',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => '',
      'Active' => '',
      'Select the role:user relations.' => '',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Gerênciamento de Saudações',
      'customer realname' => 'Nome do cliente',
      'for agent firstname' => 'Nome do Agente',
      'for agent lastname' => 'Sobrenome do Agente',
      'for agent user id' => '',
      'for agent login' => '',

      # Template: AdminSelectBoxForm
      'Select Box' => 'Caixa de Seleção',
      'SQL' => '',
      'Limit' => 'Limite',
      'Select Box Result' => 'Selecione a Caixa de Resultado',

      # Template: AdminSession
      'Session Management' => 'Gerênciamento de Sessões',
      'Sessions' => '',
      'Uniq' => '',
      'kill all sessions' => 'Finalizar todas as sessões',
      'Session' => '',
      'kill session' => 'Finalizar sessão',

      # Template: AdminSignatureForm
      'Signature Management' => 'Gerênciamento de Assinaturas',

      # Template: AdminSMIMEForm
      'SMIME Management' => '',
      'Add Certificate' => '',
      'Add Private Key' => '',
      'Secret' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',

      # Template: AdminStateForm
      'System State Management' => 'Gerênciamento de Estados do Sistema',
      'State Type' => '',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',
      'See also' => '',

      # Template: AdminSysConfig
      'SysConfig' => '',
      'Group selection' => '',
      'Show' => '',
      'Download Settings' => '',
      'Download all system config changes.' => '',
      'Load Settings' => '',
      'Subgroup' => '',
      'Elements' => '',

      # Template: AdminSysConfigEdit
      'Config Options' => '',
      'Default' => '',
      'Content' => '',
      'New' => 'Novos',
      'New Group' => '',
      'Group Ro' => '',
      'New Group Ro' => '',
      'NavBarName' => '',
      'Image' => '',
      'Prio' => '',
      'Block' => '',
      'NavBar' => '',
      'AccessKey' => '',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'Gerênciamento dos Endereços de Emails do Sistema',
      'Email' => '',
      'Realname' => 'Nome',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Todos os emails entrantes com este Email(To:) serão despachados na fila selecionada!',

      # Template: AdminUserForm
      'User Management' => 'Gerênciamento de Usuários',
      'Firstname' => 'Nome',
      'Lastname' => 'Sobrenome',
      'User will be needed to handle tickets.' => 'Será necessário um usuário para manipular os chamados.',
      'Don\'t forget to add a new user to groups and/or roles!' => '',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => '',

      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => '',
      'Return to the compose screen' => 'Retornar para a tela de composição',
      'Discard all changes and return to the compose screen' => 'Descartar todas as modificações e retornar para a tela de composição',

      # Template: AgentCalendarSmall

      # Template: AgentCalendarSmallIcon

      # Template: AgentCustomerTableView

      # Template: AgentInfo
      'Info' => 'Informação',

      # Template: AgentLinkObject
      'Link Object' => '',
      'Select' => '',
      'Results' => 'Resultados',
      'Total hits' => 'Total de acertos',
      'Site' => '',
      'Detail' => '',

      # Template: AgentLookup
      'Lookup' => '',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Checar a Ortografica',
      'spelling error(s)' => 'erro(s) ortográficos',
      'or' => '',
      'Apply these changes' => 'Aplicar estas modificações',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Uma mensagem deve possuir um To: destinatário!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Você precisa de um endereço de email (exemplo: cliente@exemplo.com.br) no To:!',
      'Bounce ticket' => 'Devolver chamado',
      'Bounce to' => 'Devolver para',
      'Next ticket state' => 'Próximo estado do chamado',
      'Inform sender' => 'Informe o remetente',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Seu email com o número de chamado "<OTRS_TICKET>" foi devolvido para "<OTRS_BOUNCE_TO>". Contate este endereço para mais informações.',
      'Send mail!' => 'Enviar email!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'Uma mensagem deve conter um assunto!',
      'Ticket Bulk Action' => '',
      'Spell Check' => 'Checar Ortografia',
      'Note type' => 'Tipo de nota',
      'Unlock Tickets' => '',

      # Template: AgentTicketClose
      'A message should have a body!' => '',
      'You need to account time!' => '',
      'Close ticket' => 'Fechar o chamado',
      'Note Text' => 'Nota',
      'Close type' => 'Tipo de fechamento',
      'Time units' => 'Unidades de tempo',
      ' (work units)' => ' (unidades de trabalho)',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => '',
      'Compose answer for ticket' => 'Compôr uma resposta para o chamado',
      'Attach' => 'Anexo',
      'Pending Date' => 'Data de Pendência',
      'for pending* states' => 'em estado pendente*',

      # Template: AgentTicketCustomer
      'Change customer of ticket' => 'Modificar o cliente do chamado',
      'Set customer user and customer id of a ticket' => '',
      'Customer User' => 'Cliente',
      'Search Customer' => 'Busca do cliente',
      'Customer Data' => 'Dados do Cliente',
      'Customer history' => 'Histórico do cliente',
      'All customer tickets.' => '',

      # Template: AgentTicketCustomerMessage
      'Follow up' => 'Continuação',

      # Template: AgentTicketEmail
      'Compose Email' => 'Compor Email',
      'new ticket' => 'Novo Chamado',
      'Clear To' => '',
      'All Agents' => '',
      'Termin1' => '',

      # Template: AgentTicketForward
      'Article type' => 'Tipo de artigo',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => '',

      # Template: AgentTicketHistory
      'History of' => 'Histórico de',

      # Template: AgentTicketLocked
      'Ticket locked!' => 'Chamado bloqueado!',
      'Ticket unlock!' => 'Chamado desbloqueado!',

      # Template: AgentTicketMailbox
      'Mailbox' => 'Caixa de Entrada',
      'Tickets' => 'Chamado',
      'All messages' => 'Todas as mensagens',
      'New messages' => 'Mensagens novas',
      'Pending messages' => 'Mensagens pendentes',
      'Reminder messages' => 'Mensagens com lembretes',
      'Reminder' => 'Lembretes',
      'Sort by' => 'Ordenado pela',
      'Order' => 'Ordem',
      'up' => 'normal',
      'down' => 'inversa',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => '',
      'Ticket Merge' => '',
      'Merge to' => '',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '',

      # Template: AgentTicketMove
      'Queue ID' => '',
      'Move Ticket' => '',
      'Previous Owner' => '',

      # Template: AgentTicketNote
      'Add note to ticket' => 'Adicionar nota ao chamado',
      'Inform Agent' => '',
      'Optional' => '',
      'Inform involved Agents' => '',

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Modificar o proprietário do chamado',
      'Message for new Owner' => 'Mensagem para um novo Proprietário',

      # Template: AgentTicketPending
      'Set Pending' => 'Marcar Pendente',
      'Pending type' => 'Tipo de pendência',
      'Pending date' => 'Data da pendência',

      # Template: AgentTicketPhone
      'Phone call' => 'Chamada telefônica',

      # Template: AgentTicketPhoneNew
      'Clear From' => '',

      # Template: AgentTicketPlain
      'Plain' => 'Texto',
      'TicketID' => 'Id.do Chamado',
      'ArticleID' => 'Id.do artigo',

      # Template: AgentTicketPrint
      'Ticket-Info' => '',
      'Accounted time' => 'Tempo contabilizado',
      'Escalation in' => 'Escalado em',
      'Linked-Object' => '',
      'Parent-Object' => '',
      'Child-Object' => '',
      'by' => 'por',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Modificar a prioridade do chamado',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Chamados mostrados',
      'Page' => '',
      'Tickets available' => 'Chamados disponíveis',
      'All tickets' => 'Todos chamados',
      'Queues' => 'Filas',
      'Ticket escalation!' => 'Escalação de chamados!',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => '',
      'Compose Follow up' => '',
      'Compose Answer' => 'Compôr resposta',
      'Contact customer' => 'Contatar cliente',
      'Change queue' => 'Modificar Fila',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketSearch
      'Ticket Search' => '',
      'Profile' => '',
      'Search-Template' => '',
      'Created in Queue' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Yes, save it with name' => '',
      'Customer history search' => 'Busca no Histórico do cliente',
      'Customer history search (e. g. "ID342425").' => 'Busca no Histórico do cliente (exemplo: "ID342425")',
      'No * possible!' => 'Não são possíveis *!',

      # Template: AgentTicketSearchResult
      'Search Result' => '',
      'Change search options' => '',

      # Template: AgentTicketSearchResultPrint
      '"}' => '',

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'ordem crescente',
      'U' => 'C',
      'sort downward' => 'ordem decrescente',
      'D' => '',

      # Template: AgentTicketStatusView
      'Ticket Status View' => '',
      'Open Tickets' => '',

      # Template: AgentTicketZoom
      'Split' => '',

      # Template: AgentTicketZoomStatus
      'Locked' => '',

      # Template: AgentWindowTabStart

      # Template: AgentWindowTabStop

      # Template: Copyright

      # Template: css

      # Template: customer-css

      # Template: CustomerAccept

      # Template: CustomerCalendarSmallIcon

      # Template: CustomerError
      'Traceback' => '',

      # Template: CustomerFAQ
      'Print' => 'Imprimir',
      'Keywords' => '',
      'Symptom' => '',
      'Problem' => '',
      'Solution' => '',
      'Modified' => '',
      'Last update' => '',
      'FAQ System History' => '',
      'modified' => '',
      'FAQ Search' => '',
      'Fulltext' => '',
      'Keyword' => '',
      'FAQ Search Result' => '',
      'FAQ Overview' => '',

      # Template: CustomerFooter
      'Powered by' => 'Movido à',

      # Template: CustomerFooterSmall

      # Template: CustomerHeader

      # Template: CustomerHeaderSmall

      # Template: CustomerLogin
      'Login' => '',
      'Lost your password?' => 'Esqueceu sua senha?',
      'Request new password' => 'Solicitar uma nova senha',
      'Create Account' => 'Criar Conta',

      # Template: CustomerNavigationBar
      'Welcome %s' => 'Bem-vindo %s',

      # Template: CustomerPreferencesForm

      # Template: CustomerStatusView
      'of' => 'de',

      # Template: CustomerTicketMessage

      # Template: CustomerTicketMessageNew

      # Template: CustomerTicketSearch

      # Template: CustomerTicketSearchResultCSV

      # Template: CustomerTicketSearchResultPrint

      # Template: CustomerTicketSearchResultShort

      # Template: CustomerTicketZoom

      # Template: CustomerWarning

      # Template: Error
      'Click here to report a bug!' => 'Clique aqui para relatar um erro!',

      # Template: FAQ
      'Comment (internal)' => '',
      'A article should have a title!' => 'O Artigo deverá ter um Título!',
      'New FAQ Article' => 'Novo Artigo Base de Conhecimento',
      'Do you really want to delete this Object?' => '',
      'System History' => '',

      # Template: FAQCategoryForm
      'Name is required!' => '',
      'FAQ Category' => '',

      # Template: FAQLanguageForm
      'FAQ Language' => '',

      # Template: Footer
      'QueueView' => 'Fila',
      'PhoneView' => 'Chamada',
      'Top of Page' => '',

      # Template: FooterSmall

      # Template: Header
      'Home' => 'Início',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => '',
      'accept license' => '',
      'don\'t accept license' => '',
      'Admin-User' => '',
      'Admin-Password' => '',
      'your MySQL DB should have a root password! Default is empty!' => '',
      'Database-User' => '',
      'default \'hot\'' => '',
      'DB connect host' => '',
      'Database' => '',
      'Create' => '',
      'false' => '',
      'SystemID' => 'ID do sistema',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(A identidade do sistema. Cada número de chamado e cada id. da sessão http, inicia com este número)',
      'System FQDN' => 'FQDN do sistema',
      '(Full qualified domain name of your system)' => '(Nome completo do domínio de seu sistema)',
      'AdminEmail' => 'Email do Administrador',
      '(Email of the system admin)' => '(Email do administrador do sistema)',
      'Organization' => 'Organização',
      'Log' => '',
      'LogModule' => 'LOG Modulo',
      '(Used log backend)' => '(Utilizado LOG como base)',
      'Logfile' => 'Arquivo de registro',
      '(Logfile just needed for File-LogModule!)' => '(Arquivo de registro para File-LogModule)',
      'Webfrontend' => 'Interface Web',

      'Default Charset' => 'Conjunto de Caracteres Padrão',
      'Use utf-8 it your database supports it!' => 'A sua Base de dados suporta utf-8!',
      'Default Language' => 'Idioma Padrão',
      '(Used default language)' => '(Idioma padrão utilizado)',
      'CheckMXRecord' => 'Averiguar MX',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
      'Restart your webserver' => 'Reiniciar o Webserver',
      'After doing so your OTRS is up and running.' => '',
      'Start page' => 'Iniciar página',
      'Have a lot of fun!' => 'Divirta-se!',
      'Your OTRS Team' => 'Equipe Service Desk SAP',

      # Template: Login

      # Template: Motd

      # Template: NoPermission
      'No Permission' => 'Sem Permissão',

      # Template: Notify
      'Important' => 'Importante',

      # Template: PrintFooter
      'URL' => '',

      # Template: PrintHeader
      'printed by' => 'impresso por',

      # Template: Redirect

      # Template: SystemStats
      'Format' => 'Formato',

      # Template: Test
      'OTRS Test Page' => 'Página de Teste Service Desk SAP',
      'Counter' => 'Contador',

      # Template: Warning
      # Misc
      'Change roles <-> groups settings' => 'Alterar configurações Regras <-> Grupos',
      'Ticket Number Generator' => 'Gerador de Números de Chamados',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificador Chamado. Algumas pessoas gostam de usar por exemplo \'Chamado#\, \'Chamado#\' ou \'MeuChamado#\')',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Close!' => 'Fechar!',
      'Don\'t forget to add a new user to groups!' => 'Não esqueça de adicionar um novo usuário nos grupos!',
      'License' => 'Licença',
      'System Settings' => 'Configurações Sistema',
      'Finished' => 'Finalizado',
      'Locked tickets' => 'Chamados Bloqueados',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_TicketID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Opções de dados do Chamado (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_TicketID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
      'Change user <-> group settings' => 'Modificar configurações de usuários <-> grupos',
      'next step' => 'próximo passo',
      'Admin-Email' => 'Email Admin.',
      'Options ' => 'Opções',
      '(Used ticket number format)' => '(Formato de Chamado utilizado)',
      'Package not correctly deployed, you need to deploy it again!' => '',
    };
    # $$STOP$$
}
# --
1;
