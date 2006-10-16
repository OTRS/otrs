# --
# Kernel/Language/pt_BR.pm - provides pt_BR language translation
# Copyright (C) 2003 Gilberto Cezar de Almeida <gibalmeida at hotmail.com>
# --
# $Id: pt_BR.pm,v 1.41 2006-10-16 19:27:47 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
# Alterado por Glaucia C. Messina (glauglauu@yahoo.com)
# Updated on 02/10/2006, by Fabricio Luiz Machado (soprobr@gmail.com)

package Kernel::Language::pt_BR;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.41 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Oct  5 06:04:57 2006

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateFormatShort} = '';
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
      'Reset' => 'Reiniciar',
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
      'second(s)' => '',
      'seconds' => '',
      'second' => '',
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
      'Link (Parent)' => 'Link (Pai)',
      'Link (Child)' => 'Link (Filho)',
      'Normal' => '',
      'Parent' => 'Pai',
      'Child' => 'Filho',
      'Hit' => '',
      'Hits' => '',
      'Text' => 'Texto',
      'Lite' => 'Simples',
      'User' => 'Usuário',
      'Username' => 'Login',
      'Language' => 'Idioma',
      'Languages' => 'Idiomas',
      'Password' => 'Senha',
      'Salutation' => 'Tratamento (Sr./Sra)',
      'Signature' => 'Assinatura',
      'Customer' => 'Cliente',
      'CustomerID' => 'ID.do Cliente',
      'CustomerIDs' => 'IDs do Cliente',
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
      'Search' => 'Buscar',
      'and' => 'e',
      'between' => 'entre',
      'Fulltext Search' => 'Busca por texto completo',
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
      'Passwords doesn\'t match! Please try it again!' => 'Senha incorreta! Tente novamente!',
      'Password is already in use! Please use an other password!' => 'Senha em uso! Tente outra senha!',
      'Password is already used! Please use an other password!' => 'Senha está sendo utilizada! Tente outra senha!',
      'You need to activate %s first to use it!' => 'Primeiramente ative %s, para uso!',
      'No suggestions' => 'Sem sugestões',
      'Word' => 'Palavra',
      'Ignore' => 'Ignorar',
      'replace with' => 'substituir com',
      'Welcome to OTRS' => 'Bem-vindo ao OTRS',
      'There is no account with that login name.' => 'Não existe conta com este nome de usuário',
      'Login failed! Your username or password was entered incorrectly.' => 'Login incorreto! Seu Login  ou senha foram informados incorretamente.',
      'Please contact your admin' => 'Por favor, contate administrador do sistema!',
      'Logout successful. Thank you for using OTRS!' => 'Encerrado com sucesso. Obrigado por utilizar o OTRS!',
      'Invalid SessionID!' => 'Identificação de Sessão Inválida',
      'Feature not active!' => 'Função não ativada!',
      'License' => 'Licença',
      'Take this Customer' => 'Atenda este Cliente',
      'Take this User' => 'Atenda este Usuário',
      'possible' => 'possível',
      'reject' => 'rejeitar',
      'reverse' => '',
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
      'Package not correctly deployed! You should reinstall the Package again!' => '',
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
      'Signed' => 'Assinado',
      'Sign' => 'Assinar',
      'Crypted' => 'Criptografado',
      'Crypt' => 'Criptografar',
      'Office' => 'Escritório',
      'Phone' => 'Telefone',
      'Fax' => '',
      'Mobile' => '',
      'Zip' => '',
      'City' => '',
      'Country' => '',
      'installed' => 'instalado',
      'uninstalled' => 'desinstalado',
      'printed at' => '',

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
      'January' => '',
      'February' => '',
      'March' => '',
      'April' => '',
      'June' => '',
      'July' => '',
      'August' => '',
      'September' => '',
      'October' => '',
      'November' => '',
      'December' => '',

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
      'New Article' => 'Novo Artigo',
      'Admin' => '',
      'A web calendar' => 'Calendário',
      'WebMail' => '',
      'A web mail client' => 'Webmail Cliente',
      'FileManager' => 'Adm Arquivo',
      'A web file manager' => 'Adm Arquivo Web',
      'Artefact' => '',
      'Incident' => 'Incidente',
      'Advisory' => 'Aviso',
      'WebWatcher' => '',
      'Customer Users' => 'Clientes',
      'Customer Users <-> Groups' => 'Clientes <-> Grupos',
      'Users <-> Groups' => 'Usuários <-> Grupos',
      'Roles' => 'Regras',
      'Roles <-> Users' => 'Regras <-> Usuários',
      'Roles <-> Groups' => 'Regras <-> Grupos',
      'Salutations' => 'Tratamentos (Sr./Sra.)',
      'Signatures' => 'Assinaturas',
      'Email Addresses' => 'Email',
      'Notifications' => 'Notificações',
      'Category Tree' => 'Categorias',
      'Admin Notification' => 'Notificação Admin',

      # Template: AAAPreferences
      'Preferences updated successfully!' => 'Preferências atualizadas com sucesso!',
      'Mail Management' => 'Gerenciamento Mail',
      'Frontend' => 'Interface',
      'Other Options' => 'Outras Opções',
      'Change Password' => 'Trocar senha',
      'New password' => 'Nova senha',
      'New password again' => 'Repita sua nova senha',
      'Select your QueueView refresh time.' => 'Selecione o tempo de atualização das Filas',
      'Select your frontend language.' => 'Selecione o Idioma.',
      'Select your frontend Charset.' => 'Selecione o Conjunto de Caracteres.',
      'Select your frontend Theme.' => 'Selecione o Tema.',
      'Select your frontend QueueView.' => 'Selecione a Visão da Fila.',
      'Spelling Dictionary' => 'Dicionário (Língua)',
      'Select your default spelling dictionary.' => 'Escolha o seu corretor ortográfico padrão.',
      'Max. shown Tickets a page in Overview.' => 'Max. Chamados em uma tela.',
      'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'Senha não atualizada, por que estão diferentes! Tente novamente!',
      'Can\'t update password, invalid characters!' => 'Senha não atualizada, caracteres inválidos!',
      'Can\'t update password, need min. 8 characters!' => 'Senha não atualizada, digite no mínimo 8 caracteres!',
      'Can\'t update password, need 2 lower and 2 upper characters!' => 'Senha não atualizada, digite no mínimo 2 caracteres minúsculos e 2 maiúsculos',
      'Can\'t update password, need min. 1 digit!' => 'Senha não atualizada, digite no mínimo 1 número',
      'Can\'t update password, need min. 2 characters!' => 'Senha não atualizada, digite no mínimo 2 caracteres',
      'Password is needed!' => 'Senha é obrigatória!',

      # Template: AAAStats
      'Stat' => '',
      'Please fill out the required fields!' => '',
      'Please select a file!' => '',
      'Please select an object!' => '',
      'Please select a graph size!' => '',
      'Please select one element for the X-axis!' => '',
      'You have to select two or more attributes from the select field!' => '',
      'Please select only one element or turn of the button \'Fixed\' where the select field is marked!' => '',
      'If you use a checkbox you have to select some attributes of the select field!' => '',
      'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '',
      'The selected end time is before the start time!' => '',
      'You have to select one or more attributes from the select field!' => '',
      'The selected Date isn\'t valid!' => '',
      'Please select only one or two elements via the checkbox!' => '',
      'If you use a time scale element you can only select one element!' => '',
      'You have an error in your time selection!' => '',
      'Your reporting time interval is to small, please use a larger time scale!' => '',
      'The selected start time is before the allowed start time!' => '',
      'The selected end time is after the allowed end time!' => '',
      'The selected time period is larger than the allowed time period!' => '',
      'Common Specification' => '',
      'Xaxis' => '',
      'Value Series' => '',
      'Restrictions' => '',
      'graph-lines' => '',
      'graph-bars' => '',
      'graph-hbars' => '',
      'graph-points' => '',
      'graph-lines-points' => '',
      'graph-area' => '',
      'graph-pie' => '',
      'extended' => '',
      'Agent/Owner' => '',
      'Created by Agent/Owner' => '',
      'Created Priority' => '',
      'Created State' => '',
      'Create Time' => '',
      'CustomerUserLogin' => '',
      'Close Time' => '',

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
      'Bcc' => 'Cópia Oculta',
      'Subject' => 'Assunto',
      'Move' => 'Mover',
      'Queue' => 'Fila',
      'Priority' => 'Prioridade',
      'State' => 'Estado',
      'Compose' => 'Compôr',
      'Pending' => 'Pendentes',
      'Owner' => 'Proprietário',
      'Owner Update' => 'Atualização Proprietário',
      'Responsible' => '',
      'Responsible Update' => '',
      'Sender' => 'Remetente',
      'Article' => 'Artigo',
      'Ticket' => 'Chamado',
      'Createtime' => 'Hora de criação',
      'plain' => 'texto',
      'Email' => 'Email',
      'email' => 'mail',
      'Close' => 'Fechar',
      'Action' => 'Ação',
      'Attachment' => 'Anexo',
      'Attachments' => 'Anexos',
      'This message was written in a character set other than your own.' => 'Esta mensagem foi escrita utilizando um conjunto de caracteres diferente do seu.',
      'If it is not displayed correctly,' => 'Se ele não for exibido corretamente,',
      'This is a' => 'Este é um',
      'to open it in a new window.' => 'para abri-lo em uma nova janela.',
      'This is a HTML email. Click here to show it.' => 'Este email está em formato HTML. Clique aqui para exibi-lo.',
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
      'No such Ticket Number "%s"! Can\'t link it!' => 'Não existe o Chamado "%s"! Não foi possível "linká-lo"',
      'Don\'t show closed Tickets' => 'Não mostrar chamados fechados',
      'Show closed Tickets' => 'Mostrar chamados fechados',
      'Email-Ticket' => 'Chamado-Mail',
      'Create new Email Ticket' => 'Criar novo Mail Chamado',
      'Phone-Ticket' => 'Chamado-Fone',
      'Create new Phone Ticket' => 'Criar novo Fone Chamado',
      'Search Tickets' => 'Pesquisar Chamados',
      'Edit Customer Users' => 'Editar Clientes(Usuários)',
      'Bulk-Action' => 'Executar Ação',
      'Bulk Actions on Tickets' => 'Executar Ação nos Chamados',
      'Send Email and create a new Ticket' => 'Enviar mail e criar novo Chamado',
      'Overview of all open Tickets' => 'Visão geral de todos Chamados abertos',
      'Locked Tickets' => 'Chamados Bloqueados',
      'Lock it to work on it!' => 'Bloquear para trabalhar com o Chamado!',
      'Unlock to give it back to the queue!' => 'Desbloqueie para enviá-lo devolta à fila!',
      'Shows the ticket history!' => 'Apresentar histórico de Chamados',
      'Print this ticket!' => 'Imprimir este Chamado!',
      'Change the ticket priority!' => 'Alterar a prioridade do Chamado!',
      'Change the ticket free fields!' => 'Alterar os campos em branco no Chamado!',
      'Link this ticket to an other objects!' => '"Linkar" este Chamado com outros objetos!',
      'Change the ticket owner!' => 'Mudar proprietário do Chamado!',
      'Change the ticket customer!' => 'Mudar o Cliente do Chamado',
      'Add a note to this ticket!' => 'Adicionar um Note neste Chamado!',
      'Merge this ticket!' => 'Agrupar este chamado!',
      'Set this ticket to pending!' => 'Marcar este Chamado como Pendente!',
      'Close this ticket!' => 'Feche este chamado!',
      'Look into a ticket!' => 'Olhe conteúdo de um chamado!',
      'Delete this ticket!' => 'Apague este Chamado',
      'Mark as Spam!' => 'Marque como Spam',
      'My Queues' => 'Minhas Filas',
      'Shown Tickets' => 'Mostrar Chamados',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'A sua mensagem com o chamado número "<OTRS_TICKET>" foi unido com o chamado número "<OTRS_MERGE_TO_TICKET>".',
      'New ticket notification' => 'Notificação de novo Chamado',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Envie-me uma notificação se há um Novo Chamado em "Minhas Filas".',
      'Follow up notification' => 'Notificação de continuação',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Notifique me se um cliente enviar uma continuação e sou o proprietário do Chamado.',
      'Ticket lock timeout notification' => 'Notificação de bloqueio por tempo expirado',
      'Send me a notification if a ticket is unlocked by the system.' => 'Notifique me se um Chamado é desbloqueado pelo sistema.',
      'Move notification' => 'Notificação de movimentos',
      'Send me a notification if a ticket is moved into one of "My Queues".' => 'Notifique-me se  Chamados foram movimentados para "Minhas Filas"',
      'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Suas filas favoritas. Você também será notificado sobre estas filas via email se habilitado.',
      'Custom Queue' => 'Fila Personalizada',
      'QueueView refresh time' => 'Tempo de atualização das Filas',
      'Screen after new ticket' => 'Tela após novo chamado',
      'Select your screen after creating a new ticket.' => 'Selecione a tela seguinte após a criação de um novo chamado.',
      'Closed Tickets' => 'Chamados Fechados',
      'Show closed tickets.' => 'Apresentar chamados fechados.',
      'Max. shown Tickets a page in QueueView.' => 'N° máximo de chamados apresentados por página.',
      'CompanyTickets' => 'Chamados da Empresa',
      'MyTickets' => 'Meus Chamados',
      'New Ticket' => 'Novo Chamado',
      'Create new Ticket' => 'Criar novo Chamado',
      'Customer called' => 'O Cliente Telefonou',
      'phone call' => '',
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
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Opções de dados do chamado (ex.: &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Opções de configuração (ex.: &lt;OTRS_CONFIG_HttpType&gt;)',

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
      'Customer user will be needed to have a customer history and to login via customer panel.' => 'O usuário do cliente será necessário para que exista um histórico do cliente e para login na área de clientes.',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => 'Clientes <-> Admin Grupos',
      'Change %s settings' => 'Modificar %s configurações',
      'Select the user:group permissions.' => 'Selecionar as permissões de  usuário:grupo.',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Se nada estiver selecionado, então não há nenhuma permissão neste grupo (os chamados não estarão disponíveis para o usuário).',
      'Permission' => 'Permissões',
      'ro' => 'somente leitura',
      'Read only access to the ticket in this group/queue.' => 'Acesso Somente com Leitura de chamados neste grupo/fila',
      'rw' => 'leitura/escrita',
      'Full read and write access to the tickets in this group/queue.' => 'Acesso leitura e escrita  de chamados neste grupo/fila',

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Mensagem enviada para',
      'Recipents' => 'Destinatários',
      'Body' => 'Corpo',
      'send' => 'enviar',

      # Template: AdminGenericAgent
      'GenericAgent' => 'Atendente Genérico',
      'Job-List' => 'Lista de jobs',
      'Last run' => 'Última execução',
      'Run Now!' => 'Executar Agora',
      'x' => '',
      'Save Job as?' => 'Salvar job como',
      'Is Job Valid?' => 'O job é válido?',
      'Is Job Valid' => 'O job é válido.',
      'Schedule' => 'Agenda',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Busca por texto completo no Artigo (ex.: "Mar*in" or "Baue*")',
      '(e. g. 10*5155 or 105658*)' => '(ex.: 10*5155 or 105658*)',
      '(e. g. 234321)' => '(ex.: 234321)',
      'Customer User Login' => 'Cliente Login',
      '(e. g. U5150)' => '(ex.: U5150)',
      'Agent' => 'Atendente',
      'Ticket Lock' => 'Chamado bloqueado',
      'TicketFreeFields' => '',
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
      'New TicketFreeFields' => '',
      'Add Note' => 'Adicionar Nota',
      'CMD' => 'Comando',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Este comando será executado. ARG[0] será o número do chamado. ARG[1] o id do chamado.',
      'Delete tickets' => 'Excluir Chamados',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Alerta! Este Chamado será removido da base de dados! Este Chamado esrá perdido permanentemente!',
      'Send Notification' => '',
      'Param 1' => 'Parâmetro 1',
      'Param 2' => 'Parâmetro 2',
      'Param 3' => 'Parâmetro 3',
      'Param 4' => 'Parâmatro 4',
      'Param 5' => 'Parâmetro 5',
      'Param 6' => 'Parâmetro 6',
      'Send no notifications' => '',
      'Yes means, send no agent and customer notifications on changes.' => '',
      'No means, send agent and customer notifications on changes.' => '',
      'Save' => 'Salvar',
      '%s Tickets affected! Do you really want to use this job?' => '',

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
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Opções de dono do chamado (ex.: &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opções do usuário atual que requisitou esta ação (ex.: &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opções de dados do usuário do cliente atual (ex.: &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

      # Template: AdminPackageManager
      'Package Manager' => 'Admin Pacotes',
      'Uninstall' => 'Desinstalar',
      'Version' => 'Versão',
      'Do you really want to uninstall this package?' => 'Você quer realmente desinstalar este pacote?',
      'Reinstall' => 'Reinstalar',
      'Do you really want to reinstall this package (all manual changes get lost)?' => '',
      'Install' => 'Instalar',
      'Package' => 'Pacotes',
      'Online Repository' => 'Repositório OnLine',
      'Vendor' => 'Vendedor',
      'Upgrade' => 'Atualizar Versão',
      'Local Repository' => 'Repositório Local',
      'Status' => '',
      'Package not correctly deployed, you need to deploy it again!' => 'O pacote não foi instalado corretamente, faz-se necessária a reinstalação!',
      'Overview' => '',
      'Download' => '',
      'Rebuild' => 'Reconstruir',
      'Download file from package!' => '',
      'Required' => '',
      'PrimaryKey' => '',
      'AutoIncrement' => '',
      'SQL' => '',
      'Diff' => '',

      # Template: AdminPerformanceLog
      'Performance Log' => '',
      'Logfile too large!' => '',
      'Logfile too large, you need to reset it!' => '',
      'Range' => '',
      'Interface' => '',
      'Requests' => '',
      'Min Response' => '',
      'Max Response' => '',
      'Average Response' => '',

      # Template: AdminPGPForm
      'PGP Management' => 'Gerenciamento do PGP',
      'Identifier' => 'Identificador',
      'Bit' => '',
      'Key' => 'Chave',
      'Fingerprint' => '',
      'Expires' => 'Expira',
      'In this way you can directly edit the keyring configured in SysConfig.' => 'Neste caso, você pode editar diretamente o "keyring" configurado no "SysConfig".',

      # Template: AdminPOP3
      'POP3 Account Management' => 'Gerenciamento de Contas POP3',
      'Host' => 'Servidor',
      'List' => '',
      'Trusted' => 'Confiável',
      'Dispatching' => 'Despachando',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Todos os emails de entrada com uma conta será despachado na fila selecionada!',
      'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Se a sua conta for "trusted", os headers "X-OTRS" existentes na recepção (para prioridade, ...) serão utilizados! O filtro será utilizado mesmo assim.',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => 'Adm Filtros Postmaster',
      'Filtername' => 'Nome Filtro',
      'Match' => 'Busca',
      'Header' => 'Cabeçalho',
      'Value' => 'Valor',
      'Set' => 'Configurar',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Para despachar ou filtrar os emails entrantes baseados em "X-Headers". Expressões regularos também podem ser utilizadas.',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Se utilizar expressões regulares, você pode usar o valor encontrado no () como [***] em \'Set\'.',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => 'Fila <-> Adm de Auto respostas',

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
      'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Se um Chamado, não for respondido dentro do prazo, serão apresentados.',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Se um chamado está fechado e um cliente envia uma continuação, este mesmo chamado será bloqueado para o antigo proprietário.',
      'Will be the sender address of this queue for email answers.' => 'Será o endereço de email de respostas desta fila.',
      'The salutation for email answers.' => 'A saudação para as respostas de emails.',
      'The signature for email answers.' => 'A assinatura para as respostas de emails.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'O OTRS envia uma notificação por email ao cliente, caso o chamado seja movido.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'O OTRS envia uma notificação por email ao cliente, caso o status do chamado seja alterado.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'O OTRS envia uma notificação por email ao cliente, caso o dono do chamado seja alterado.',

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
      'All Customer variables like defined in config option CustomerUser.' => 'Todas as variáveis do cliente como foram definidas nas opções de configuração de "usuário"',
      'The current ticket state is' => 'O Estado do Chamado é ',
      'Your email address is new' => 'Seu  mail é novo',

      # Template: AdminRoleForm
      'Role Management' => 'Regras Admin',
      'Create a role and put groups in it. Then add the role to the users.' => 'Crie uma regra e relacione grupos a ele. Então adicione regras aos usuários. ',
      'It\'s useful for a lot of users and groups.' => 'Isto é muito útil para uma grande quantidade de usuários e grupos.',

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
      'Role' => 'Papel',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => 'Papel <-> Gerenciamento de Usuários',
      'Active' => 'Ativo',
      'Select the role:user relations.' => 'Selecione a relação entre o papel/usuário.',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Gerenciamento de Tratamento (Sr./Sra.)',
      'customer realname' => 'Nome do cliente',
      'All Agent variables.' => '',
      'for agent firstname' => 'Nome do Atendente',
      'for agent lastname' => 'Sobrenome do Atendente',
      'for agent user id' => 'Id do Atendente',
      'for agent login' => 'Login do Atendente',

      # Template: AdminSelectBoxForm
      'Select Box' => 'Caixa de Seleção',
      'Limit' => 'Limite',
      'Select Box Result' => 'Selecione a Caixa de Resultado',

      # Template: AdminSession
      'Session Management' => 'Gerenciamento de Sessões',
      'Sessions' => 'Sessões',
      'Uniq' => '',
      'kill all sessions' => 'Finalizar todas as sessões',
      'Session' => 'Sessão',
      'Content' => 'Conteúdo',
      'kill session' => 'Finalizar sessão',

      # Template: AdminSignatureForm
      'Signature Management' => 'Gerenciamento de Assinaturas',

      # Template: AdminSMIMEForm
      'S/MIME Management' => 'Gerenciamento S/MIME',
      'Add Certificate' => 'Adicionar Certificado',
      'Add Private Key' => 'Adicionar Chave Privada',
      'Secret' => 'Senha',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => 'Neste caso, você pode editar diretamente a certificação e chaves privadas no sistema de arquivos.',

      # Template: AdminStateForm
      'System State Management' => 'Gerenciamento de Estados do Sistema',
      'State Type' => 'Tipo de Estado',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Tenha cuidado se você também atualizou os estados padrão no Kernel/Config.pm!',
      'See also' => 'Veja também',

      # Template: AdminSysConfig
      'SysConfig' => 'Configuração do Sistema',
      'Group selection' => 'Seleção de Grupo',
      'Show' => 'Visualizar',
      'Download Settings' => 'Baixar Configurações',
      'Download all system config changes.' => 'Baixar todas as configurações do sistema que foram alteradas.',
      'Load Settings' => 'Carregar Configurações',
      'Subgroup' => 'Subgrupo',
      'Elements' => 'Elementos',

      # Template: AdminSysConfigEdit
      'Config Options' => 'Opções de Configuração',
      'Default' => 'Padrão',
      'New' => 'Novo',
      'New Group' => 'Novo Grupo',
      'Group Ro' => 'Grupo Somente Leitura',
      'New Group Ro' => 'Novo Grupo Somente Leitura',
      'NavBarName' => 'Nome da Barra de Navegação',
      'NavBar' => 'Barra de Navegação',
      'Image' => 'Imagem',
      'Prio' => 'Prioridade',
      'Block' => 'Bloquear',
      'AccessKey' => 'Chave de Acesso',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'Gerenciamento dos Endereços de Email do Sistema',
      'Realname' => 'Nome',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Todos os emails entrantes com este Email(To:) serão despachados na fila selecionada!',

      # Template: AdminUserForm
      'User Management' => 'Gerenciamento de Usuários',
      'Login as' => '',
      'Firstname' => 'Nome',
      'Lastname' => 'Sobrenome',
      'User will be needed to handle tickets.' => 'Será necessário um usuário para manipular os chamados.',
      'Don\'t forget to add a new user to groups and/or roles!' => 'Não se esqueça de adicionar o novo usuário em grupos e/ou papéis!',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => 'Usuários <-> Gerenciamento de Grupos',

      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => 'Catálogo de Endereços',
      'Return to the compose screen' => 'Retornar para a tela de composição',
      'Discard all changes and return to the compose screen' => 'Descartar todas as modificações e retornar para a tela de composição',

      # Template: AgentCalendarSmall

      # Template: AgentCalendarSmallIcon

      # Template: AgentCustomerTableView

      # Template: AgentInfo
      'Info' => 'Informação',

      # Template: AgentLinkObject
      'Link Object' => '"Linkar" Objeto',
      'Select' => 'Selecionar',
      'Results' => 'Resultados',
      'Total hits' => 'Total de acertos',
      'Page' => 'Página',
      'Detail' => 'Detalhe',

      # Template: AgentLookup
      'Lookup' => 'Buscar',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => 'Chamado selecionado para execução de ação!',
      'You need min. one selected Ticket!' => 'Você deve selecionar ao menos  1(um) chamado!',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Checar a Ortografica',
      'spelling error(s)' => 'erro(s) ortográficos',
      'or' => 'ou',
      'Apply these changes' => 'Aplicar estas modificações',

      # Template: AgentStatsDelete
      'Do you really want to delete this Object?' => 'Você quer realmente remover este objeto?',

      # Template: AgentStatsEditRestrictions
      'Select the restrictions to characterise the stat' => '',
      'Fixed' => '',
      'Please select only one Element or turn of the button \'Fixed\'.' => '',
      'Absolut Period' => '',
      'Between' => '',
      'Relative Period' => '',
      'The last' => '',
      'Finish' => '',
      'Here you can make restrictions to your stat.' => '',
      'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributs of the corresponding element.' => '',

      # Template: AgentStatsEditSpecification
      'Insert of the common specifications' => '',
      'Permissions' => '',
      'Format' => 'Formato',
      'Graphsize' => '',
      'Sum rows' => '',
      'Sum columns' => '',
      'Cache' => '',
      'Required Field' => '',
      'Selection needed' => '',
      'Explanation' => '',
      'In this form you can select the basic specifications.' => '',
      'Attribute' => '',
      'Title of the stat.' => '',
      'Here you can insert a description of the stat.' => '',
      'Dynamic-Object' => '',
      'Here you can select the dynamic object you want to use.' => '',
      '(Note: It depends on your installation how many dynamic objects you can use)' => '',
      'Static-File' => '',
      'For very complex stats it is possible to include a hardcoded file.' => '',
      'If a new hardcoded file is available this attribute will be shown and you can select one.' => '',
      'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => '',
      'Multiple selection of the output format.' => '',
      'If you use a graph as output format you have to select at least one graph size.' => '',
      'If you need the sum of every row select yes' => '',
      'If you need the sum of every column select yes.' => '',
      'Most of the stats can be cached. This will speed up the presentation of this stat.' => '',
      '(Note: Useful for big databases and low performance server)' => '',
      'With an invalid stat it isn\'t feasible to generate a stat.' => '',
      'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => '',

      # Template: AgentStatsEditValueSeries
      'Select the elements for the value series' => '',
      'Scale' => '',
      'minimal' => '',
      'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '',
      'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

      # Template: AgentStatsEditXaxis
      'Select the element, which will be used at the X-axis' => '',
      'maximal period' => '',
      'minimal scale' => '',
      'Here you can define the x-axis. You can select one element via the radio button. Than you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

      # Template: AgentStatsImport
      'Import' => '',
      'File is not a Stats config' => '',
      'No File selected' => '',

      # Template: AgentStatsOverview
      'Object' => '',

      # Template: AgentStatsPrint
      'Print' => 'Imprimir',
      'No Element selected.' => '',

      # Template: AgentStatsView
      'Export Config' => '',
      'Informations about the Stat' => '',
      'Exchange Axis' => '',
      'Configurable params of static stat' => '',
      'No element selected.' => '',
      'maximal period form' => '',
      'to' => '',
      'Start' => '',
      'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Uma mensagem deve possuir um To: destinatário!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Você precisa de um endereço de email (exemplo: cliente@exemplo.com.br) no To:!',
      'Bounce ticket' => 'Devolver chamado',
      'Bounce to' => 'Devolver para',
      'Next ticket state' => 'Próximo estado do chamado',
      'Inform sender' => 'Informe o remetente',
      'Send mail!' => 'Enviar email!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'Uma mensagem deve conter um assunto!',
      'Ticket Bulk Action' => 'Executar Ação no Chamado',
      'Spell Check' => 'Checar Ortografia',
      'Note type' => 'Tipo de nota',
      'Unlock Tickets' => 'Desbloquear Chamados',

      # Template: AgentTicketClose
      'A message should have a body!' => 'A mensagem deve conter um texto!',
      'You need to account time!' => 'Você deve contabilizar o tempo!',
      'Close ticket' => 'Fechar o chamado',
      'Ticket locked!' => 'Chamado bloqueado!',
      'Ticket unlock!' => 'Chamado desbloqueado!',
      'Previous Owner' => 'Dono Anterior',
      'Inform Agent' => 'Informar Atendente',
      'Optional' => 'Opcional',
      'Inform involved Agents' => 'Informar os Atendentes Envolvidos',
      'Attach' => 'Anexo',
      'Pending date' => 'Data da pendência',
      'Time units' => 'Unidades de tempo',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => 'A mensagem necessita ser verificada ortograficamente!',
      'Compose answer for ticket' => 'Compôr uma resposta para o chamado',
      'Pending Date' => 'Data de Pendência',
      'for pending* states' => 'em estado pendente*',

      # Template: AgentTicketCustomer
      'Change customer of ticket' => 'Modificar o cliente do chamado',
      'Set customer user and customer id of a ticket' => 'Configurar usuário e id do cliente no chamado',
      'Customer User' => 'Cliente',
      'Search Customer' => 'Busca do cliente',
      'Customer Data' => 'Dados do Cliente',
      'Customer history' => 'Histórico do cliente',
      'All customer tickets.' => 'Todos os chamados do cliente',

      # Template: AgentTicketCustomerMessage
      'Follow up' => 'Continuação',

      # Template: AgentTicketEmail
      'Compose Email' => 'Compor Email',
      'new ticket' => 'Novo Chamado',
      'Refresh' => '',
      'Clear To' => 'Limpar',
      'All Agents' => 'Todos os Atendentes',

      # Template: AgentTicketForward
      'Article type' => 'Tipo de artigo',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => 'Alterar os campos em branco no chamado',

      # Template: AgentTicketHistory
      'History of' => 'Histórico de',

      # Template: AgentTicketLocked

      # Template: AgentTicketMailbox
      'Mailbox' => 'Caixa de Entrada',
      'Tickets' => 'Chamado',
      'of' => 'de',
      'Filter' => '',
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
      'You need to use a ticket number!' => 'Você deve utilizar um número de chamado!',
      'Ticket Merge' => 'Unir Chamado',
      'Merge to' => 'Unir com',

      # Template: AgentTicketMove
      'Move Ticket' => 'Mover Chamado',

      # Template: AgentTicketNote
      'Add note to ticket' => 'Adicionar nota ao chamado',

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Modificar o proprietário do chamado',

      # Template: AgentTicketPending
      'Set Pending' => 'Marcar Pendente',

      # Template: AgentTicketPhone
      'Phone call' => 'Chamada telefônica',
      'Clear From' => 'Limpar',
      'Create' => 'Criar',

      # Template: AgentTicketPhoneOutbound

      # Template: AgentTicketPlain
      'Plain' => 'Texto',
      'TicketID' => 'Id.do Chamado',
      'ArticleID' => 'Id.do artigo',

      # Template: AgentTicketPrint
      'Ticket-Info' => 'Informação do Chamado',
      'Accounted time' => 'Tempo contabilizado',
      'Escalation in' => 'Escalado em',
      'Linked-Object' => 'Objeto "Linkado"',
      'Parent-Object' => 'Objeto Pai',
      'Child-Object' => 'Objeto Filho',
      'by' => 'por',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Modificar a prioridade do chamado',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Chamados mostrados',
      'Tickets available' => 'Chamados disponíveis',
      'All tickets' => 'Todos chamados',
      'Queues' => 'Filas',
      'Ticket escalation!' => 'Escalação de chamados!',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => 'Seu próprio Chamado',
      'Compose Follow up' => 'Compor Continuação',
      'Compose Answer' => 'Compôr resposta',
      'Contact customer' => 'Contatar cliente',
      'Change queue' => 'Modificar Fila',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketResponsible
      'Change responsible of ticket' => '',

      # Template: AgentTicketSearch
      'Ticket Search' => 'Busca de Chamado',
      'Profile' => 'Perfil',
      'Search-Template' => 'Modelo de Busca',
      'TicketFreeText' => 'Texto livre Chamado',
      'Created in Queue' => 'Criado na Fila',
      'Result Form' => 'Resultado',
      'Save Search-Profile as Template?' => 'Salvar o Perfil de Busca como Modelo?',
      'Yes, save it with name' => 'Sim, salve-o com o nome',

      # Template: AgentTicketSearchResult
      'Search Result' => 'Resultado da Busca',
      'Change search options' => 'Alterar as oções de busca',

      # Template: AgentTicketSearchResultPrint

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'ordem crescente',
      'U' => 'C',
      'sort downward' => 'ordem decrescente',
      'D' => '',

      # Template: AgentTicketStatusView
      'Ticket Status View' => 'Visualização do Status do Chamado',
      'Open Tickets' => 'Chamados Abertos',

      # Template: AgentTicketZoom
      'Locked' => 'Bloqueado',
      'Split' => 'Dividir',

      # Template: AgentWindowTab

      # Template: AgentWindowTabStart

      # Template: AgentWindowTabStop

      # Template: Copyright

      # Template: css

      # Template: customer-css

      # Template: CustomerAccept

      # Template: CustomerCalendarSmallIcon

      # Template: CustomerError
      'Traceback' => '',

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

      # Template: CustomerTicketMessage

      # Template: CustomerTicketSearch

      # Template: CustomerTicketSearchResultCSV

      # Template: CustomerTicketSearchResultPrint

      # Template: CustomerTicketSearchResultShort

      # Template: CustomerTicketZoom

      # Template: CustomerWarning

      # Template: Error
      'Click here to report a bug!' => 'Clique aqui para relatar um erro!',

      # Template: Footer
      'Top of Page' => 'Topo da Página',

      # Template: FooterSmall

      # Template: Header
      'Home' => 'Início',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => 'Instalador Web',
      'accept license' => 'aceitar licença',
      'don\'t accept license' => 'não acentiar a licença',
      'Admin-User' => 'Usuário do Administrador',
      'Admin-Password' => 'Senha do Administrador',
      'your MySQL DB should have a root password! Default is empty!' => 'O seu MySQL deve ter uma senha de "root"! O padrão é em branco!',
      'Database-User' => 'Usuário da Base',
      'default \'hot\'' => 'padrão \'hot\'',
      'DB connect host' => 'Servidor da Base',
      'Database' => 'Base de Dados',
      'false' => 'falso',
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
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => 'Checar os registros do MX de endereços de email utilizados na composição de uma resposta. Não utilizar checagem de registros do MX se o seu servidor OTRS estiver sib um acesso discado $!',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Para poder utilizar o OTRS você deve',
      'Restart your webserver' => 'Reiniciar o Webserver',
      'After doing so your OTRS is up and running.' => 'Após isto, então seu OTRS está funcionando.',
      'Start page' => 'Iniciar página',
      'Have a lot of fun!' => 'Divirta-se!',
      'Your OTRS Team' => 'Equipe Service Desk SAP',

      # Template: Login
      'Welcome to %s' => '',

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

      # Template: Test
      'OTRS Test Page' => 'Página de Teste Service Desk SAP',
      'Counter' => 'Contador',

      # Template: Warning
      # Misc
      ' (work units)' => ' (unidades de trabalho)',
      'Change roles <-> groups settings' => 'Alterar configurações Regras <-> Grupos',
      'Ticket Number Generator' => 'Gerador de Números de Chamados',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificador Chamado. Algumas pessoas gostam de usar por exemplo \'Chamado#\, \'Chamado#\' ou \'MeuChamado#\')',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Neste caso, você pode editar diretamente a "keyring" configurada no Kernel/Config.pm.',
      'Symptom' => 'Sintoma',
      'Site' => '',
      'Customer history search (e. g. "ID342425").' => 'Busca no Histórico do cliente (exemplo: "ID342425")',
      'Close!' => 'Fechar!',
      'Don\'t forget to add a new user to groups!' => 'Não esqueça de adicionar um novo usuário nos grupos!',
      'System Settings' => 'Configurações Sistema',
      'Finished' => 'Finalizado',
      'Locked tickets' => 'Chamados Bloqueados',
      'Queue ID' => 'ID da Fila',
      'A article should have a title!' => 'O Artigo deverá ter um Título!',
      'System History' => 'Histórico do Sistema',
      'Modules' => 'Modulos',
      'Keyword' => 'Palavra-Chave',
      'Close type' => 'Tipo de fechamento',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_TicketID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Opções de dados do Chamado (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_TicketID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
      'Change user <-> group settings' => 'Modificar configurações de usuários <-> grupos',
      'Name is required!' => 'O Nome é requerido',
      'Problem' => 'Problema',
      'next step' => 'próximo passo',
      'Termin1' => '',
      'Customer history search' => 'Busca no Histórico do cliente',
      'Solution' => 'Solução',
      'Admin-Email' => 'Email Admin.',
      'QueueView' => 'Fila',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Seu email com o número de chamado "<OTRS_TICKET>" foi devolvido para "<OTRS_BOUNCE_TO>". Contate este endereço para mais informações.',
      'modified' => 'modificado',
      'Keywords' => 'Palavras-Chave',
      'Note Text' => 'Nota',
      'No * possible!' => 'Não são possíveis *!',
      'Options ' => 'Opções',
      'PhoneView' => 'Chamada',
      'Verion' => 'Versão',
      'Message for new Owner' => 'Mensagem para um novo Proprietário',
      'Last update' => 'Última Atualização',
      'Pending type' => 'Tipo de pendência',
      'Comment (internal)' => 'Comentário (interno)',
      '(Used ticket number format)' => '(Formato de Chamado utilizado)',
      'Fulltext' => 'Texto Completo',
      'Modified' => 'Modificado',
      'Watched Tickets' => '',
      'Subscribe' => '',
      'Unsubscribe' => '',
    };
    # $$STOP$$
}

1;
