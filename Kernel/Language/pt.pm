# --
# Kernel/Language/pt.pm - provides pt language translation
# Copyright (C) 2004 CAT <filipehenriques at ip.pt>
# --
# $Id: pt.pm,v 1.33 2006-10-12 09:23:30 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::pt;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.33 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Oct  5 06:05:04 2006

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%Y-%M-%D %T';
    $Self->{DateFormatLong} = '%A, %D de %B de %Y, %T';
    $Self->{DateFormatShort} = '';
    $Self->{DateInputFormat} = '%Y-%M-%D';
    $Self->{DateInputFormatLong} = '%Y-%M-%D - %T';

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
      'Reset' => 'Limpar',
      'last' => 'nos últimos',
      'before' => 'há mais de',
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
      'month(s)' => 'mes(ses)',
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
      'Modulefile' => 'Ficheiro de Módulo',
      'Subfunction' => 'Subfunção',
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
      'Mrs.' => 'Sr.ª',
      'Next' => 'Próximo',
      'Back' => 'Voltar',
      'Next...' => 'Próximo...',
      '...Back' => '...Voltar',
      '-none-' => '-nenhum(a)-',
      'none' => 'nenhum(a)',
      'none!' => 'nenhum(a)!',
      'none - answered' => 'nenhum - respondido',
      'please do not edit!' => 'por favor não editar!',
      'AddLink' => 'Adicionar Ligação',
      'Link' => 'Ligar',
      'Linked' => 'Ligado',
      'Link (Normal)' => 'Ligar (Normal)',
      'Link (Parent)' => 'Ligar (Ascendente)',
      'Link (Child)' => 'Ligar (Descendente)',
      'Normal' => '',
      'Parent' => 'Ascendente',
      'Child' => 'Descendente',
      'Hit' => 'Acerto',
      'Hits' => 'Acertos',
      'Text' => 'Texto',
      'Lite' => 'Leve',
      'User' => 'Utilizador',
      'Username' => 'Nome de utilizador',
      'Language' => 'Idioma',
      'Languages' => 'Idiomas',
      'Password' => 'Palavra-passe',
      'Salutation' => 'Saudação',
      'Signature' => 'Assinatura',
      'Customer' => 'Cliente',
      'CustomerID' => 'ID de Cliente',
      'CustomerIDs' => 'ID de Cliente',
      'customer' => 'cliente',
      'agent' => 'agente',
      'system' => 'sistema',
      'Customer Info' => 'Informação de Cliente',
      'go!' => 'ir!',
      'go' => 'ir',
      'All' => 'Todos',
      'all' => 'todos',
      'Sorry' => 'Desculpe',
      'update!' => 'actualizar!',
      'update' => 'actualizar',
      'Update' => 'Actualizar',
      'submit!' => 'submeter!',
      'submit' => 'Submeter',
      'Submit' => 'Submeter',
      'change!' => 'alterar!',
      'Change' => 'Alterar',
      'change' => 'alterar',
      'click here' => 'clique aqui',
      'Comment' => 'Comentário',
      'Valid' => 'Válido',
      'Invalid Option!' => 'Opção Inválida!',
      'Invalid time!' => 'Hora inválida!',
      'Invalid date!' => 'Data inválida!',
      'Name' => 'Nome',
      'Group' => 'Grupo',
      'Description' => 'Descrição',
      'description' => 'descrição',
      'Theme' => 'Tema',
      'Created' => 'Criado',
      'Created by' => 'Criado por',
      'Changed' => 'Modificado',
      'Changed by' => 'Modificado por',
      'Search' => 'Procurar',
      'and' => 'e',
      'between' => 'entre',
      'Fulltext Search' => 'Procura Exaustiva no Texto',
      'Data' => '',
      'Options' => 'Opções',
      'Title' => 'Título',
      'Item' => '',
      'Delete' => 'Eliminar',
      'Edit' => 'Editar',
      'View' => 'Ver',
      'Number' => 'Número',
      'System' => 'Sistema',
      'Contact' => 'Contacto',
      'Contacts' => 'Contactos',
      'Export' => 'Exportar',
      'Up' => 'Subir',
      'Down' => 'Descer',
      'Add' => 'Adicionar',
      'Category' => 'Categoria',
      'Viewer' => 'Visualizador',
      'New message' => 'Nova mensagem',
      'New message!' => 'Nova mensagem!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Por favor, responda a este(s) bilhete(s) para regressar à visualização de filas!',
      'You got new message!' => 'Tem uma mensagem nova!',
      'You have %s new message(s)!' => 'Tem %s mensagem(s) nova(s)!',
      'You have %s reminder ticket(s)!' => 'Tem %s lembrete(s)!',
      'The recommended charset for your language is %s!' => 'O código recomendado para o seu idioma é %s!',
      'Passwords doesn\'t match! Please try it again!' => 'As palavras-passe não correspondem! Tente de novo!',
      'Password is already in use! Please use an other password!' => 'A palavra-passe está já em uso! Por favor use outra!',
      'Password is already used! Please use an other password!' => 'A palavra-passe já foi usada! Por favor use outra!',
      'You need to activate %s first to use it!' => 'Tem de activar %s antes de o usar!',
      'No suggestions' => 'Sem sugestões',
      'Word' => 'Palavra',
      'Ignore' => 'Ignorar',
      'replace with' => 'substituir por',
      'Welcome to OTRS' => 'Bem-vindo ao OTRS',
      'There is no account with that login name.' => 'Não existe nenhuma conta com esse nome de utilizador',
      'Login failed! Your username or password was entered incorrectly.' => 'Entrada falhou! Ou o nome de utilizador ou a palavra-passe foram introduzidos incorrectamente.',
      'Please contact your admin' => 'Por favor contactar o seu administrador de sistemas',
      'Logout successful. Thank you for using OTRS!' => 'Saiu com sucesso. Obrigado por utilizar o Sistema de Ajuda do ISCTE!',
      'Invalid SessionID!' => 'ID de Sessão Inválido',
      'Feature not active!' => 'Característica não activa!',
      'License' => 'Licença',
      'Take this Customer' => 'Fique com este Cliente',
      'Take this User' => 'Fique com este Utilizador',
      'possible' => 'possível',
      'reject' => 'rejeitar',
      'reverse' => '',
      'Facility' => 'Instalação',
      'Timeover' => 'Tempo a mais',
      'Pending till' => 'Pendente até',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Não trabalhe com o UserID 1 (Conta de sistema)! Crie novos utilizadores!',
      'Dispatching by email To: field.' => 'Despachado através do campo Para:',
      'Dispatching by selected Queue.' => 'Despachado pela Fila escolhida',
      'No entry found!' => 'Não se encontrou nada!',
      'Session has timed out. Please log in again.' => 'A sessão expirou. Por favor autentique-se novamente',
      'No Permission!' => 'Sem Permissão!',
      'To: (%s) replaced with database email!' => 'Para: (%s) substituído pelo endereço na base de dados!',
      'Cc: (%s) added database email!' => 'Cc: (%s) acrescentado endereço na base de dados!',
      '(Click here to add)' => '(Clique aqui para adicionar)',
      'Preview' => 'Prever',
      'Package not correctly deployed! You should reinstall the Package again!' => '',
      'Added User "%s"' => 'Acrescentado Utilizador "%s"',
      'Contract' => 'Contrato',
      'Online Customer: %s' => 'Cliente em-linha: %s',
      'Online Agent: %s' => 'Agente em-linha: %s',
      'Calendar' => 'Calendário',
      'File' => 'Ficheiro',
      'Filename' => 'Nome de ficheiro',
      'Type' => 'Tipo',
      'Size' => 'Tamanho',
      'Upload' => 'Carregar',
      'Directory' => 'Pasta',
      'Signed' => 'Assinado',
      'Sign' => 'Assinar',
      'Crypted' => 'Cifrado',
      'Crypt' => 'Cifrar',
      'Office' => 'Gabinete',
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
      'Jan' => 'Janeiro',
      'Feb' => 'Feveveiro',
      'Mar' => 'Março',
      'Apr' => 'Abril',
      'May' => 'Maio',
      'Jun' => 'Junho',
      'Jul' => 'Julho',
      'Aug' => 'Agosto',
      'Sep' => 'Setembro',
      'Oct' => 'Outubro',
      'Nov' => 'Novembro',
      'Dec' => 'Dezembro',
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
      'Admin-Area' => 'Área de Administração',
      'Agent-Area' => 'Área de Agente',
      'Ticket-Area' => 'Área de Bilhetes',
      'Logout' => 'Sair',
      'Agent Preferences' => 'Preferências de Agente',
      'Preferences' => 'Preferências',
      'Agent Mailbox' => 'Caixa do Correio do Agente',
      'Stats' => 'Estatísticas',
      'Stats-Area' => 'Área de Estatísticas',
      'New Article' => 'Novo Artigo',
      'Admin' => 'Administração',
      'A web calendar' => 'Um calendário na Web',
      'WebMail' => 'Correio electrónico na Web',
      'A web mail client' => 'Um cliente de correio electrónico na Web',
      'FileManager' => 'Gestor de Ficheiros',
      'A web file manager' => 'Um gestor de ficheiros na Web',
      'Artefact' => 'Artefacto',
      'Incident' => 'Incidente',
      'Advisory' => 'Recomendação',
      'WebWatcher' => 'Observador da Web',
      'Customer Users' => 'Utilizadores Clientes',
      'Customer Users <-> Groups' => 'Utilizadores Clientes <-> Grupos',
      'Users <-> Groups' => 'Utilizadores <-> Grupos',
      'Roles' => 'Papeis',
      'Roles <-> Users' => 'Papeis <-> Utilizadores',
      'Roles <-> Groups' => 'Papeis <-> Grupos',
      'Salutations' => 'Saudações',
      'Signatures' => 'Assinaturas',
      'Email Addresses' => 'Endereços de Correio Electrónico',
      'Notifications' => 'Notificações',
      'Category Tree' => 'Árvore de Categorias',
      'Admin Notification' => 'Notificações de Administração',

      # Template: AAAPreferences
      'Preferences updated successfully!' => 'Preferências actualizadas com sucesso!',
      'Mail Management' => 'Gestão de Correio Electrónico',
      'Frontend' => 'Interface',
      'Other Options' => 'Outras Opções',
      'Change Password' => 'Mudar a Palavra-passe',
      'New password' => 'Nova palavra-passe',
      'New password again' => 'De novo',
      'Select your QueueView refresh time.' => 'Selecione o tempo de refrescamento da Visualização de Filas.',
      'Select your frontend language.' => 'Selecione o idioma da interface.',
      'Select your frontend Charset.' => 'Selecione a codificação da interface.',
      'Select your frontend Theme.' => 'Selecione o tema da sua interface.',
      'Select your frontend QueueView.' => 'Selecione a Visualização de Filas da Interface.',
      'Spelling Dictionary' => 'Dicionário Ortográfico',
      'Select your default spelling dictionary.' => 'Seleccione o dicionário ortográfico por omissão.',
      'Max. shown Tickets a page in Overview.' => 'Número máximo de bilhetes por página em Visão Geral.',
      'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'Impossível actualizar a palavra-passe: as palavras-passe não correspondem! Tente de novo!',
      'Can\'t update password, invalid characters!' => 'Impossível actualizar palavra-passe: caracteres inválidos!',
      'Can\'t update password, need min. 8 characters!' => 'Impossível actualizar palavra-passe: necessários pelo menos oito caracteres!',
      'Can\'t update password, need 2 lower and 2 upper characters!' => 'Impossível actualizar palavra-passe: pelo menos duas minúsculas e duas maiúsculas!',
      'Can\'t update password, need min. 1 digit!' => 'Impossível actualizar palavra-passe: pelo menos um dígito!',
      'Can\'t update password, need min. 2 characters!' => 'Impossível actualizar palavra-passe: pelo menos um caractere!',
      'Password is needed!' => 'Palavra-passe indispensável!',

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
      'Zoom' => 'Pormenores',
      'Age' => 'Idade',
      'Bounce' => 'Devolver',
      'Forward' => 'Encaminhar',
      'From' => 'De',
      'To' => 'Para',
      'Cc' => '',
      'Bcc' => '',
      'Subject' => 'Assunto',
      'Move' => 'Mover',
      'Queue' => 'Fila',
      'Priority' => 'Prioridade',
      'State' => 'Estado',
      'Compose' => 'Compôr',
      'Pending' => 'Pendências',
      'Owner' => 'Proprietário',
      'Owner Update' => 'Actualizar Proprietário',
      'Responsible' => '',
      'Responsible Update' => '',
      'Sender' => 'Remetente',
      'Article' => 'Artigo',
      'Ticket' => 'Bilhete',
      'Createtime' => 'Hora de criação',
      'plain' => 'verbatim',
      'Email' => 'Correio Electrónico',
      'email' => 'correio electrónico',
      'Close' => 'Fechar',
      'Action' => 'Acção',
      'Attachment' => 'Anexo',
      'Attachments' => 'Anexos',
      'This message was written in a character set other than your own.' => 'Esta mensagem foi escrita usando uma codificação diferente da sua.',
      'If it is not displayed correctly,' => 'Se não for exibida correctamente,',
      'This is a' => 'Este é um',
      'to open it in a new window.' => 'para a abrir em nova janela.',
      'This is a HTML email. Click here to show it.' => 'Esta é uma mensagem HTML. Clicar aqui para a mostrar.',
      'Free Fields' => 'Campos Livres',
      'Merge' => 'Juntar',
      'closed successful' => 'fechado com sucesso',
      'closed unsuccessful' => 'fechado sem sucesso',
      'new' => 'novo',
      'open' => 'aberto',
      'closed' => 'fechado',
      'removed' => 'removido',
      'pending reminder' => 'pendente com lembrete',
      'pending auto close+' => 'pendente com fecho automático positivo',
      'pending auto close-' => 'pendente com fecho automático negativo',
      'email-external' => 'mensagem de correio electrónico externa',
      'email-internal' => 'mensagem de correio electrónico externa',
      'note-external' => 'nota externa',
      'note-internal' => 'nota interna',
      'note-report' => 'relatório de nota',
      'phone' => 'telefone',
      'sms' => '',
      'webrequest' => 'pedido via Web',
      'lock' => 'bloquear',
      'unlock' => 'desbloquear',
      'very low' => 'muito baixa',
      'low' => 'baixa',
      'normal' => '',
      'high' => 'alta',
      'very high' => 'muito alta',
      '1 very low' => '1 muito baixa',
      '2 low' => '2 baixa',
      '3 normal' => '',
      '4 high' => '4 alta',
      '5 very high' => '5 muito alta',
      'Ticket "%s" created!' => 'Bilhete "%s" criado!',
      'Ticket Number' => 'Número do Bilhete',
      'Ticket Object' => 'Objecto Bilhete',
      'No such Ticket Number "%s"! Can\'t link it!' => 'Não existe Número de Bilhete "%s"! Não posso ligar a ele!',
      'Don\'t show closed Tickets' => 'Não mostrar bilhetes fechados',
      'Show closed Tickets' => 'Mostrar bilhetes fechados',
      'Email-Ticket' => 'Mensagem',
      'Create new Email Ticket' => 'Criar novo Bilhete via Correio Electrónico',
      'Phone-Ticket' => 'Telefonema',
      'Create new Phone Ticket' => 'Criar novo Bilhete via Telefone',
      'Search Tickets' => 'Procurar Bilhetes',
      'Edit Customer Users' => 'Editar Utilizadores Clientes',
      'Bulk-Action' => 'Em Lote',
      'Bulk Actions on Tickets' => 'Acções em Lote sobre Bilhetes',
      'Send Email and create a new Ticket' => 'Enviar mensagem e criar novo Bilhete',
      'Overview of all open Tickets' => 'Visão geral de todos os Bilhetes abertos',
      'Locked Tickets' => 'Bilhetes Bloqueados',
      'Lock it to work on it!' => 'Bloqueie-o para trabalhar nele!',
      'Unlock to give it back to the queue!' => 'Desbloqueie-o para o devolver à fila!',
      'Shows the ticket history!' => 'Mostra o histórico do bilhete!',
      'Print this ticket!' => 'Imprime o bilhete!',
      'Change the ticket priority!' => 'Muda a prioridade do bilhete!',
      'Change the ticket free fields!' => 'Alterar os campos livres do bilhete!',
      'Link this ticket to an other objects!' => 'Liga este bilhete a outros objectos!',
      'Change the ticket owner!' => 'Muda o proprietário do bilhete!',
      'Change the ticket customer!' => 'Muda o cliente do bilhete!',
      'Add a note to this ticket!' => 'Acrescentar uma nota ao bilhete!',
      'Merge this ticket!' => 'Juntar este bilhete a outro!',
      'Set this ticket to pending!' => 'Tornar o bilhete pendente!',
      'Close this ticket!' => 'Fechar este bilhete!',
      'Look into a ticket!' => 'Ver um bilhete!',
      'Delete this ticket!' => 'Remover este bilhete!',
      'Mark as Spam!' => 'Marcar como Spam!',
      'My Queues' => 'As Minhas Filas',
      'Shown Tickets' => 'Mostrar Bilhetes',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'A sua mensagem com o número de bilhete "<OTRS_TICKET>" foi junta a "<OTRS_MERGE_TO_TICKET>".',
      'New ticket notification' => 'Notificação de novo bilhete',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Envie-me uma notificação se houver um novo bilhete nas "Minhas Filas".',
      'Follow up notification' => 'Notificação de seguimento',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Notifique-me se um cliente enviar um seguimento e eu for proprietário deste bilhete.',
      'Ticket lock timeout notification' => 'Notificação por expiração do tempo de bloqueio',
      'Send me a notification if a ticket is unlocked by the system.' => 'Notifique-me se um bilhete for desbloqueado pelo sistema.',
      'Move notification' => 'Notificação de movimentos',
      'Send me a notification if a ticket is moved into one of "My Queues".' => 'Notifique-me se um bilhete for movido para uma das "Minhas Filas".',
      'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Selecção das suas filas favoritas. Será notificado acerca destas filas via correio electrónico se o serviço estiver activo.',
      'Custom Queue' => 'Fila Personalizada',
      'QueueView refresh time' => 'Tempo de refrescamento da Visualização  de Filas',
      'Screen after new ticket' => 'Ecrã após novo bilhete',
      'Select your screen after creating a new ticket.' => 'Seleccionar ecrã após criação de novo bilhete.',
      'Closed Tickets' => 'Bilhetes Fechados',
      'Show closed tickets.' => 'Mostrar bilhetes fechados',
      'Max. shown Tickets a page in QueueView.' => 'Número máximo de bilhetes por página em Visualição de Filas',
      'CompanyTickets' => 'Bilhetes da Instituição',
      'MyTickets' => 'Meus Bilhetes',
      'New Ticket' => 'Novo Bilhete',
      'Create new Ticket' => 'Criar novo Bilhete',
      'Customer called' => 'O cliente telefonou',
      'phone call' => '',
      'Responses' => 'Respostas',
      'Responses <-> Queue' => 'Respostas <-> Filas',
      'Auto Responses' => 'Respostas Automáticas',
      'Auto Responses <-> Queue' => 'Respostas Automáticas <-> Filas',
      'Attachments <-> Responses' => 'Anexos <-> Respostas',
      'History::Move' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
      'History::NewTicket' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
      'History::FollowUp' => 'FollowUp for [%s]. %s',
      'History::SendAutoReject' => 'AutoReject sent to "%s".',
      'History::SendAutoReply' => 'AutoReply sent to "%s".',
      'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
      'History::Forward' => 'Forwarded to "%s".',
      'History::Bounce' => 'Bounced to "%s".',
      'History::SendAnswer' => 'Email sent to "%s".',
      'History::SendAgentNotification' => '"%s"-notification sent to "%s".',
      'History::SendCustomerNotification' => 'Notification sent to "%s".',
      'History::EmailAgent' => 'Email sent to customer.',
      'History::EmailCustomer' => 'Added email. %s',
      'History::PhoneCallAgent' => 'Agent called customer.',
      'History::PhoneCallCustomer' => 'Customer called us.',
      'History::AddNote' => 'Added note (%s)',
      'History::Lock' => 'Locked ticket.',
      'History::Unlock' => 'Unlocked ticket.',
      'History::TimeAccounting' => '%s time unit(s) accounted. Now total %s time unit(s).',
      'History::Remove' => '%s',
      'History::CustomerUpdate' => 'Updated: %s',
      'History::PriorityUpdate' => 'Changed priority from "%s" (%s) to "%s" (%s).',
      'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
      'History::LoopProtection' => 'Loop-Protection! No auto-response sent to "%s".',
      'History::Misc' => '%s',
      'History::SetPendingTime' => 'Updated: %s',
      'History::StateUpdate' => 'Old: "%s" New: "%s"',
      'History::TicketFreeTextUpdate' => 'Updated: %s=%s;%s=%s;',
      'History::WebRequestCustomer' => 'Customer request via web.',
      'History::TicketLinkAdd' => 'Added link to ticket "%s".',
      'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',

      # Template: AAAWeekDay
      'Sun' => 'domingo',
      'Mon' => 'segunda-feira',
      'Tue' => 'terça-feira',
      'Wed' => 'quarta-feira',
      'Thu' => 'quinta-feira',
      'Fri' => 'sexta-feira',
      'Sat' => 'sábado',

      # Template: AdminAttachmentForm
      'Attachment Management' => 'Gestão de Anexos',

      # Template: AdminAutoResponseForm
      'Auto Response Management' => 'Gestão de Respostas Automáticas',
      'Response' => 'Resposta',
      'Auto Response From' => 'Resposta Automática De',
      'Note' => 'Nota',
      'Useable options' => 'Opções acessíveis',
      'to get the first 20 character of the subject' => 'para obter os 20 primeiros caracteres do assunto',
      'to get the first 5 lines of the email' => 'para obter as 5 primeiras linhas da mensagem de correio electrónico',
      'to get the from line of the email' => 'para obter a linha "De:" da mensagem',
      'to get the realname of the sender (if given)' => 'para obter o nome do remetente (se indicado na mensagem)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Opções dos dados do bilhete (e.g., &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Opções de Configuração (Ex. &lt;OTRS_CONFIG_HttpType&gt;)',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'A mensagem sendo composta foi fechada. Saindo.',
      'This window must be called from compose window' => 'Esta janela deve ser chamada da janela de composição',
      'Customer User Management' => 'Gestão de Utilizadores Clientes',
      'Search for' => 'Procurar por',
      'Result' => 'Resultado',
      'Select Source (for add)' => 'Seleccionar fonte (para a adição)',
      'Source' => 'Fonte',
      'This values are read only.' => 'Estes valores são apenas de leitura.',
      'This values are required.' => 'Estes valores são obrigatórios.',
      'Customer user will be needed to have a customer history and to login via customer panel.' => 'Utilizador cliente terá de ter um historial como cliente e de se autenticar via os paineis de cliente.',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => '',
      'Change %s settings' => 'Modificar %s configurações',
      'Select the user:group permissions.' => 'Seleccionar o utilizador:permissões de grupo.',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Se nada for seleccionado, então não há permissões neste grupo (bilhetes não estaram disponíveis para o utilizador).',
      'Permission' => 'Permissão',
      'ro' => 'leitura',
      'Read only access to the ticket in this group/queue.' => 'Acesso apenas de leitura para o bilhete neste grupo/fila.',
      'rw' => 'escrita',
      'Full read and write access to the tickets in this group/queue.' => 'Acesso total de leitura e escrita para os bilhetes neste grupo/queue.',

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Mensagem enviada para',
      'Recipents' => 'Destinatários',
      'Body' => 'Corpo',
      'send' => 'enviar',

      # Template: AdminGenericAgent
      'GenericAgent' => 'Agente Genérico',
      'Job-List' => 'Lista de Tarefas',
      'Last run' => 'Última execução',
      'Run Now!' => 'Excutar Agora!',
      'x' => '',
      'Save Job as?' => 'Guardar Tarefa como?',
      'Is Job Valid?' => 'A Tarefa é Válida?',
      'Is Job Valid' => 'A Tarefa é Válida',
      'Schedule' => 'Agendamento',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Procura exaustiva no texto no artigo (ex: "autentic*" ou "*vido")',
      '(e. g. 10*5155 or 105658*)' => '(e.g., 10*5155 ou 105658*)',
      '(e. g. 234321)' => '(e.g., 234321)',
      'Customer User Login' => 'Nome de Utilizador de Cliente',
      '(e. g. U5150)' => '(e.g., mms ou jpps)',
      'Agent' => 'Agente',
      'Ticket Lock' => 'Bloqueio de Bilhete',
      'TicketFreeFields' => '',
      'Times' => 'Tempos',
      'No time settings.' => 'Sem definições de tempo.',
      'Ticket created' => 'Bilhete criado',
      'Ticket created between' => 'Bilhete criado entre',
      'New Priority' => 'Nova Prioridade',
      'New Queue' => 'Nova Fila',
      'New State' => 'Novo Estado',
      'New Agent' => 'Novo Agente',
      'New Owner' => 'Novo Proprietário',
      'New Customer' => 'Novo Cliente',
      'New Ticket Lock' => 'Novo Bloqueio do Bilhete',
      'CustomerUser' => 'Utilizador Cliente',
      'New TicketFreeFields' => '',
      'Add Note' => 'Adicionar Nota',
      'CMD' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Este comando será executado. ARG[0] será o número do bilhete e ARG[1] o seu ID.',
      'Delete tickets' => 'Remover bilhetes',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Aviso! Estes bilhetes serão removidos da base de dados! Serão perdidos!',
      'Send Notification' => '',
      'Param 1' => 'Parâmetro 1',
      'Param 2' => 'Parâmetro 2',
      'Param 3' => 'Parâmetro 3',
      'Param 4' => 'Parâmetro 4',
      'Param 5' => 'Parâmetro 5',
      'Param 6' => 'Parâmetro 6',
      'Send no notifications' => '',
      'Yes means, send no agent and customer notifications on changes.' => '',
      'No means, send agent and customer notifications on changes.' => '',
      'Save' => 'Guardar',
      '%s Tickets affected! Do you really want to use this job?' => '',

      # Template: AdminGroupForm
      'Group Management' => 'Gestão de Grupos',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'O grupo admin é para uso na área de administração e o grupo stats é para uso na área de estatísticas.',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Crie novos grupos para manipular as permissões de acesso para diferentes grupos de agentes (e.g., departamento de compras, departamento de suporte, departamento de vendas, etc.).',
      'It\'s useful for ASP solutions.' => 'Isto é útil para soluções ASP.',

      # Template: AdminLog
      'System Log' => 'Registo do Sistema',
      'Time' => 'Tempo',

      # Template: AdminNavigationBar
      'Users' => 'Utilizadores',
      'Groups' => 'Grupos',
      'Misc' => 'Vários',

      # Template: AdminNotificationForm
      'Notification Management' => 'Gestão de Notificação',
      'Notification' => 'Notificações',
      'Notifications are sent to an agent or a customer.' => 'As notificações são enviadas para um agente ou um cliente.',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Opções do dono do bilhete',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opções do utilizador que requereu a acção (Ex. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opçoes do Cliente corrente (Ex. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

      # Template: AdminPackageManager
      'Package Manager' => 'Gestor de Pacotes',
      'Uninstall' => 'Desinstalar',
      'Version' => 'Versão',
      'Do you really want to uninstall this package?' => 'Deseja mesmo desinstalar este pacote?',
      'Reinstall' => 'Reinstalar',
      'Do you really want to reinstall this package (all manual changes get lost)?' => '',
      'Install' => 'Instalar',
      'Package' => 'Pacote',
      'Online Repository' => 'Repositório Em-linha',
      'Vendor' => 'Vendedor',
      'Upgrade' => 'Melhoria de Versão',
      'Local Repository' => 'Repositório Local',
      'Status' => 'Estado',
      'Package not correctly deployed, you need to deploy it again!' => '',
      'Overview' => 'Visão Geral',
      'Download' => 'Descarregar',
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
      'PGP Management' => 'Gestão de PGP',
      'Identifier' => 'Identificador',
      'Bit' => '',
      'Key' => 'Chave',
      'Fingerprint' => 'Impressão Digital',
      'Expires' => 'Expira',
      'In this way you can directly edit the keyring configured in SysConfig.' => 'Desta forma pode editar directamente o anel de chaves configurado no SysConfig',

      # Template: AdminPOP3
      'POP3 Account Management' => 'Gestão de Contas POP3',
      'Host' => 'Anfitrião',
      'List' => '',
      'Trusted' => 'Confiável',
      'Dispatching' => 'Despachando',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Todas as mensagens recebidas correspondentes a uma com uma conta serão despachados para a fila selecionada!',
      'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => 'Gestão de Filtros do Chefe do Correio',
      'Filtername' => 'Nome do Filtro',
      'Match' => 'Corresponde',
      'Header' => 'Cabeçalho',
      'Value' => 'Valor',
      'Set' => 'Coloca',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Despachar ou filtrar mensagens recebidas de acordo com os seus Cabeçalhos-X! Pode-se usar expressões regulares.',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Se usar expressões regulares, pode aceder ao valor emparelhado em () como [***] em \'Coloca\'.',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => 'Fila <-> Gestão de Respostas Automáticas',

      # Template: AdminQueueForm
      'Queue Management' => 'Gestão de Filas',
      'Sub-Queue of' => 'Subfila de',
      'Unlock timeout' => 'Tempo de desbloqueio',
      '0 = no unlock' => '0 = sem desbloqueio',
      'Escalation time' => 'Tempo de escalamento',
      '0 = no escalation' => '0 = sem escalamento',
      'Follow up Option' => 'Opção de Seguimento',
      'Ticket lock after a follow up' => 'Bloqueio do bilhete após seguimento',
      'Systemaddress' => 'Endereço do Sistema',
      'Customer Move Notify' => 'Movimento de Cliente Notificado',
      'Customer State Notify' => 'Estado de Cliente Notificado',
      'Customer Owner Notify' => 'Proprietário de Cliente Notificado',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Se um agente bloqueia um bilhete e não enviar uma resposta dentro deste tempo, o bilhete será desbloqueado automaticamente, ficando visível para todos os outros agentes.',
      'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Se um bilhete não for respondido dentro deste tempo, apenas os bilhetes com este tempo vencido serão exibidos.',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Se um bilhete estiver fechado e um cliente enviar um seguimento, será bloqueado em nome do seu proprietário.',
      'Will be the sender address of this queue for email answers.' => 'Será o endereço de correio electrónico usado para respostas nesta fila.',
      'The salutation for email answers.' => 'A saudação das respostas de correio electrónico.',
      'The signature for email answers.' => 'A assinatura das respostas de correio electrónico.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'O OTRS envia uma mensagem de notificação ao cliente se o bilhete for movido.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'O OTRS envia uma mensagem de notificação ao cliente se o estado do bilhete for alterado.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'O OTRS envia uma mensagem de notificação ao cliente se o proprietário do bilhete for alterado.',

      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => 'Respostas <-> Gestão de Filas',

      # Template: AdminQueueResponsesForm
      'Answer' => 'Resposta',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => 'Respostas <-> Gestão de Anexos',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'Gestão de Respostas',
      'A response is default text to write faster answer (with default text) to customers.' => 'Uma resposta é um texto padrão para compôr respostas rápidas (com texto padrão) para clientes.',
      'Don\'t forget to add a new response a queue!' => 'Não se esqueça de adicionar a nova resposta a uma fila!',
      'Next state' => 'Próximo estado',
      'All Customer variables like defined in config option CustomerUser.' => 'todas as variáveis de Cliente tais como definidas na opção de configuração CustomerUser',
      'The current ticket state is' => 'O estado corrente do bilhete é',
      'Your email address is new' => 'O seu endereço de correio electrónico é novo',

      # Template: AdminRoleForm
      'Role Management' => 'Gestão de Papeis',
      'Create a role and put groups in it. Then add the role to the users.' => 'Criar um papel e atribuir-lhe grupos. Depois acrescentar o papel aos utilizadores.',
      'It\'s useful for a lot of users and groups.' => 'Útil para muitos utilizadores e grupos.',

      # Template: AdminRoleGroupChangeForm
      'Roles <-> Groups Management' => 'Papeis <-> Gestão de Grupos',
      'move_into' => 'mover para',
      'Permissions to move tickets into this group/queue.' => 'Permissões para mover bilhetes neste grupo/queue',
      'create' => 'criar',
      'Permissions to create tickets in this group/queue.' => 'Permisses para criar bilhetes neste grupo/queue',
      'owner' => 'dono',
      'Permissions to change the ticket owner in this group/queue.' => 'Permissões para modificar o dono do bilhete neste grupo/queue',
      'priority' => 'prioridade',
      'Permissions to change the ticket priority in this group/queue.' => 'Permissões para modificar a prioridade do bilhete neste grupo/queue',

      # Template: AdminRoleGroupForm
      'Role' => 'Papel',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => 'Papeis <-> Gestão de Utilizadores',
      'Active' => 'Activo',
      'Select the role:user relations.' => 'Seleccione as relações papel:utilizador',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Gestão de Saudações',
      'customer realname' => 'nome do cliente',
      'All Agent variables.' => '',
      'for agent firstname' => 'para o nome próprio do agente',
      'for agent lastname' => 'para o apelido do agente',
      'for agent user id' => 'para o ID de utilizador do agente',
      'for agent login' => 'para o nome de utilizador do agente',

      # Template: AdminSelectBoxForm
      'Select Box' => 'Caixa de Selecção',
      'Limit' => 'Limite',
      'Select Box Result' => 'Selecione a Caixa de Resultado',

      # Template: AdminSession
      'Session Management' => 'Gestão de Sessões',
      'Sessions' => 'Sessões',
      'Uniq' => 'Único',
      'kill all sessions' => 'Finalizar todas as sessões',
      'Session' => 'Sessão',
      'Content' => 'Conteúdo',
      'kill session' => 'finalizar sessão',

      # Template: AdminSignatureForm
      'Signature Management' => 'Gestão de Assinaturas',

      # Template: AdminSMIMEForm
      'S/MIME Management' => '',
      'Add Certificate' => 'Adicionar Certificado',
      'Add Private Key' => 'Adicionar Chave Privada',
      'Secret' => 'Segredo',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => 'Aqui pode editar directamente os certificados e chaves privadas presentes no sistema de ficheiros.',

      # Template: AdminStateForm
      'System State Management' => 'Gestão de Estados do Sistema',
      'State Type' => 'Estado Tipo',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Garanta que também actualisou os estados por omissão no seu Kernel/Config.pm!',
      'See also' => 'Ver também',

      # Template: AdminSysConfig
      'SysConfig' => 'Configuração do Sistema',
      'Group selection' => 'Selecção do grupo',
      'Show' => 'Mostrar',
      'Download Settings' => 'Descarregar Configuração',
      'Download all system config changes.' => 'Descarregar todas as alterações da configuração do sistema.',
      'Load Settings' => 'Carregar Configuração',
      'Subgroup' => 'Subgrupo',
      'Elements' => 'Elementos',

      # Template: AdminSysConfigEdit
      'Config Options' => 'Opções de Configuração',
      'Default' => 'Por Omissão',
      'New' => 'Novo',
      'New Group' => 'Novo Grupo',
      'Group Ro' => '',
      'New Group Ro' => '',
      'NavBarName' => '',
      'NavBar' => '',
      'Image' => 'Imagem',
      'Prio' => '',
      'Block' => '',
      'AccessKey' => '',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'Gestão dos Endereços de Correio Electrónico do Sistema',
      'Realname' => 'Nome',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Todas mensagens recebidas com este destinatário (Para:) serão despachados para a fila selecionada!',

      # Template: AdminUserForm
      'User Management' => 'Gestão de Utilizadores',
      'Login as' => 'Entrar como',
      'Firstname' => 'Nome',
      'Lastname' => 'Apelido',
      'User will be needed to handle tickets.' => 'É necessário um utilizador para manipular os bilhetes.',
      'Don\'t forget to add a new user to groups and/or roles!' => 'Não se esqueça de adicionar um novo utilizador a grupos e/ou papeis!',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => 'Utilizadores <-> Gestão de Grupos',

      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => 'Lista de Endereços',
      'Return to the compose screen' => 'Retornar para o ecrã de composição',
      'Discard all changes and return to the compose screen' => 'Descartar todas as modificações e retornar para o ecrã de composição',

      # Template: AgentCalendarSmall

      # Template: AgentCalendarSmallIcon

      # Template: AgentCustomerTableView

      # Template: AgentInfo
      'Info' => 'Informação',

      # Template: AgentLinkObject
      'Link Object' => 'Ligar Objecto',
      'Select' => 'Seleccionar',
      'Results' => 'Resultados',
      'Total hits' => 'Total de acertos',
      'Page' => 'Página',
      'Detail' => 'Pormenor',

      # Template: AgentLookup
      'Lookup' => 'Procura',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => 'Bilhete seleccionado para acção em lote!',
      'You need min. one selected Ticket!' => 'Precisa de seleccionar pelo menos um Bilhete!',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Verificador Ortográfico',
      'spelling error(s)' => 'erro(s) ortográfico(s)',
      'or' => 'ou',
      'Apply these changes' => 'Aplicar estas modificações',

      # Template: AgentStatsDelete
      'Do you really want to delete this Object?' => 'Deseja realmente remover este Objecto?',

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
      'Start' => 'Início',
      'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Uma mensagem deve possuir um Para: destinatário!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Precisa de um endereço de correio electrónico (e.g., cliente@exemplo.pt) no Para:!',
      'Bounce ticket' => 'Devolver bilhete',
      'Bounce to' => 'Devolver para',
      'Next ticket state' => 'Próximo estado do bilhete',
      'Inform sender' => 'Informe o remetente',
      'Send mail!' => 'Enviar mensagem de correio electrónico!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'A mensagem deve conter um assunto!',
      'Ticket Bulk Action' => 'Acção sobre Lote de Bilhetes',
      'Spell Check' => 'Verificar Ortografia',
      'Note type' => 'Tipo de nota',
      'Unlock Tickets' => 'Desbloquear Bilhetes',

      # Template: AgentTicketClose
      'A message should have a body!' => 'A mensagem deve conter um texto!',
      'You need to account time!' => 'É necessário o tempo dispendido',
      'Close ticket' => 'Fechar bilhete',
      'Ticket locked!' => 'Bilhete bloqueado!',
      'Ticket unlock!' => 'Bilhete desbloqueado!',
      'Previous Owner' => 'Proprietário Anterior',
      'Inform Agent' => '',
      'Optional' => '',
      'Inform involved Agents' => '',
      'Attach' => 'Anexo',
      'Pending date' => 'Data da pendência',
      'Time units' => 'Unidades de tempo',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => 'Tem de verificar a ortografia da mensagem!',
      'Compose answer for ticket' => 'Compor uma resposta para o bilhete',
      'Pending Date' => 'Prazo de pendência',
      'for pending* states' => 'para os estados "pendente ..."',

      # Template: AgentTicketCustomer
      'Change customer of ticket' => 'Modificar o cliente do bilhete',
      'Set customer user and customer id of a ticket' => 'Atribua o nome de utilizador e o ID do cliente do bilhete',
      'Customer User' => 'Nome de Utilizador do Cliente',
      'Search Customer' => 'Procurar Cliente',
      'Customer Data' => 'Dados do Cliente',
      'Customer history' => 'Histórico do cliente',
      'All customer tickets.' => 'Todos os bilhetes do cliente.',

      # Template: AgentTicketCustomerMessage
      'Follow up' => 'Seguimento',

      # Template: AgentTicketEmail
      'Compose Email' => 'Compor Mensagem de Correio Electrónico',
      'new ticket' => 'novo bilhete',
      'Refresh' => '',
      'Clear To' => '',
      'All Agents' => 'Todos os Agentes',

      # Template: AgentTicketForward
      'Article type' => 'Tipo de artigo',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => 'Alterar Texto livre do bilhete',

      # Template: AgentTicketHistory
      'History of' => 'Histórico de',

      # Template: AgentTicketLocked

      # Template: AgentTicketMailbox
      'Mailbox' => 'Caixa de Entrada',
      'Tickets' => 'Bilhetes',
      'of' => 'de',
      'Filter' => '',
      'All messages' => 'Todas as mensagens',
      'New messages' => 'Mensagens novas',
      'Pending messages' => 'Mensagens pendentes',
      'Reminder messages' => 'Mensagens com lembretes',
      'Reminder' => 'Lembretes',
      'Sort by' => 'Ordenado pela',
      'Order' => 'Ordem',
      'up' => 'crescente',
      'down' => 'decrescente',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => '',
      'Ticket Merge' => 'Juntar Bilhete',
      'Merge to' => 'Juntar a',

      # Template: AgentTicketMove
      'Move Ticket' => 'Mover Bilhete',

      # Template: AgentTicketNote
      'Add note to ticket' => 'Adicionar nota ao bilhete',

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Modificar o proprietário do bilhete',

      # Template: AgentTicketPending
      'Set Pending' => 'Definir como Pendente',

      # Template: AgentTicketPhone
      'Phone call' => 'Chamada telefónica',
      'Clear From' => 'Limpar De',
      'Create' => 'Criar',

      # Template: AgentTicketPhoneOutbound

      # Template: AgentTicketPlain
      'Plain' => 'Verbatim',
      'TicketID' => 'ID de Bilhete',
      'ArticleID' => 'ID de Artigo',

      # Template: AgentTicketPrint
      'Ticket-Info' => 'Informação de Bilhete',
      'Accounted time' => 'Tempo contabilizado',
      'Escalation in' => 'Escalado em',
      'Linked-Object' => 'Objecto-Ligado',
      'Parent-Object' => 'Objecto-Ascendente',
      'Child-Object' => 'Objecto-Descendente',
      'by' => 'por',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Modificar a prioridade do bilhete',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Bilhetes mostrados',
      'Tickets available' => 'Bilhetes disponíveis',
      'All tickets' => 'Todos os bilhetes',
      'Queues' => 'Filas',
      'Ticket escalation!' => 'Escalamento de bilhetes!',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => 'O seu Bilhete',
      'Compose Follow up' => 'Compor Seguimento',
      'Compose Answer' => 'Compor resposta',
      'Contact customer' => 'Contactar o cliente',
      'Change queue' => 'Modificar a fila',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketResponsible
      'Change responsible of ticket' => '',

      # Template: AgentTicketSearch
      'Ticket Search' => 'Procura de Bilhetes',
      'Profile' => 'Perfil',
      'Search-Template' => 'Modelo de procura',
      'TicketFreeText' => 'Texto Livre do Bilhete',
      'Created in Queue' => 'Criado na Fila',
      'Result Form' => 'Formato do resultado',
      'Save Search-Profile as Template?' => 'Guardar Perfil de Procura como Modelo?',
      'Yes, save it with name' => 'Sim, guardar com o nome',

      # Template: AgentTicketSearchResult
      'Search Result' => 'Resultado de Procura',
      'Change search options' => 'Alterar opções de procura',

      # Template: AgentTicketSearchResultPrint

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'ordenar crescentemente',
      'U' => 'C',
      'sort downward' => 'ordenar decrescentemente',
      'D' => '',

      # Template: AgentTicketStatusView
      'Ticket Status View' => 'Visualização do Estado dos Bilhetes',
      'Open Tickets' => 'Bilhetes Abertos',

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
      'Traceback' => 'Retroceder',

      # Template: CustomerFooter
      'Powered by' => 'Produzido por',

      # Template: CustomerFooterSmall

      # Template: CustomerHeader

      # Template: CustomerHeaderSmall

      # Template: CustomerLogin
      'Login' => 'Autenticação',
      'Lost your password?' => 'Esqueceu a palavra-passe?',
      'Request new password' => 'Solicitar nova palavra-passe',
      'Create Account' => 'Criar Conta',

      # Template: CustomerNavigationBar
      'Welcome %s' => 'Bem-vindo, %s',

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
      'Click here to report a bug!' => 'Clique aqui para reportar um erro!',

      # Template: Footer
      'Top of Page' => 'Topo da Página',

      # Template: FooterSmall

      # Template: Header
      'Home' => 'Início',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => 'Instalador Web',
      'accept license' => 'aceitar licença',
      'don\'t accept license' => 'não aceitar licença',
      'Admin-User' => 'Utilizador de Admin',
      'Admin-Password' => '',
      'your MySQL DB should have a root password! Default is empty!' => 'a sua Base de Dados MySQL deve ter uma palavra-passe de administração! Por omissão ela está vazia!',
      'Database-User' => 'Utilizador da Base de Dados',
      'default \'hot\'' => 'por omissão \'hot\'',
      'DB connect host' => 'Anfitrião para ligações à Base de Dados',
      'Database' => 'Base de dados',
      'false' => 'falso',
      'SystemID' => 'ID do sistema',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(A identidade do sistema. Cada número de bilhete e cada id. da sessão http, inicia com este número)',
      'System FQDN' => 'FQDN do sistema',
      '(Full qualified domain name of your system)' => '(Nome de domínio totalmente qualificado do seu sistema)',
      'AdminEmail' => 'Correio Electrónico do Administrador',
      '(Email of the system admin)' => '(Endereço de correio electrónico do administrador do sistema)',
      'Organization' => 'Organização',
      'Log' => 'Registo',
      'LogModule' => 'Módulo de Registos',
      '(Used log backend)' => '(Usei o sistema de registos)',
      'Logfile' => 'Ficheiro de Log',
      '(Logfile just needed for File-LogModule!)' => '(Ficheiro de registo para File-LogModule)',
      'Webfrontend' => 'Interface Web',
      'Default Charset' => 'Codificação por Omissão',
      'Use utf-8 it your database supports it!' => 'Usar UTF-8 se a base de dados o suportar',
      'Default Language' => 'Idioma por Omissão',
      '(Used default language)' => '(Idioma por omissão utilizado)',
      'CheckMXRecord' => 'Verificar registo MX',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Verifica os registos MX dos endereços de correio electrónico usados quando compõe uma resposta. Não usar caso esteja a usar uma ligação telefónica!)',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Para usar o OTRS tem de dar o seguinte comando no seu Terminal/Consola, como administrador.',
      'Restart your webserver' => 'Reinicie o seu servidor Web',
      'After doing so your OTRS is up and running.' => 'Depois de o fazer, o seu OTRS estará funcional.',
      'Start page' => 'Página inicial',
      'Have a lot of fun!' => 'Divirta-se!',
      'Your OTRS Team' => 'A sua Equipa OTRS',

      # Template: Login
      'Welcome to %s' => '',

      # Template: Motd

      # Template: NoPermission
      'No Permission' => 'Sem Autorização',

      # Template: Notify
      'Important' => 'Importante',

      # Template: PrintFooter
      'URL' => '',

      # Template: PrintHeader
      'printed by' => 'impresso por',

      # Template: Redirect

      # Template: Test
      'OTRS Test Page' => 'Página de Teste do OTRS',
      'Counter' => 'Contador',

      # Template: Warning
      # Misc
      'OTRS DB connect host' => 'Servidor de ligação da Base de Dados OTRS',
      'Create Database' => 'Criar Base de Dados',
      'End' => 'Fim',
      ' (work units)' => ' (unidades de trabalho)',
      'DB Host' => 'Servidor Base de Dados',
      'Multiplier:' => 'Multiplicador:',
      'Ticket Number Generator' => 'Gerador de Números de Bilhetes',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificação do bilhete. Algumas pessoas usam \'Bilhete#\', \'Chamada#\' or \'MeuBilhete#\')',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Symptom' => 'Sintoma',
      'Site' => 'Página',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Se a sua conta for acreditada, cabeçalhos X-OTRS existentes à chegada (para prioridade, etc.) serão usados! O filtro do Chefe do Correio será sempre usado, no entanto.',
      'Customer history search (e. g. "ID342425").' => 'Procura no histórico do cliente (e.g., "ID342425")',
      'Ticket Hook' => 'Identificador do Bilhete',
      'Close!' => 'Fechar!',
      'TicketZoom' => 'DetalhesDoBilhete',
      'Don\'t forget to add a new user to groups!' => 'Não esqueça de adicionar um novo user nos grupos!',
      'OTRS DB Name' => 'Nome da Base de Dados OTRS',
      'PGP Key' => 'Chave PGP',
      'System Settings' => 'Propriedades de Sistema',
      'Finished' => 'Terminado',
      'System Status' => 'Estado do Sistema',
      'Queue ID' => 'ID da Queue',
      'A article should have a title!' => 'Um artigo tem de ter um título!',
      'System History' => 'Histórico do Sistema',
      'Benchmark' => 'Desempenho',
      'Update:' => 'Actualizar:',
      'Modules' => 'Módulos',
      'PGP Key Upload' => 'Carregamento de Chave PGP',
      'Keyword' => 'Palavra-chave',
      'with' => 'a',
      'Close type' => 'Tipo de fecho',
      'DB Admin User' => 'Utilizador Admin da Base de Dados',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_TicketID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
      'Change user <-> group settings' => 'Modificar users <-> configurações de grupos',
      'Name is required!' => 'É necessário um nome!',
      'Problem' => 'Problema',
      'DB Type' => 'Tipo da Base de Dados',
      'next step' => 'próximo passo',
      'Termin1' => '',
      'Customer history search' => 'Procura no histórico do cliente',
      'Solution' => 'Solução',
      'Admin-Email' => 'Endereço de Correio Electrónico do Administrador',
      'OTRS-Admin Info!' => 'Informação do Administrador OTRS!',
      'Requests:' => 'Pedidos:',
      'QueueView' => 'Filas',
      'SMIME Certificate Upload' => 'Carregamento de Certificado SMIME',
      'Create new database' => 'Criar nova base de dados',
      'SMIME Certificate' => 'Certificado SMIME',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Seu email com o número de bilhete "<OTRS_TICKET>" foi devolvido para "<OTRS_BOUNCE_TO>". Contate este endereço para mais informações.',
      'Delete old database' => 'Eliminar base de dados antiga',
      'Ticket %s locked.' => 'Bilhete %s bloqueado.',
      'Keywords' => 'Palavras-chave',
      'Note Text' => 'Nota',
      'Select:' => 'Seleccionar:',
      'No * possible!' => 'Não são possíveis *!',
      'Insert:' => 'Inserir:',
      'Security Note: You should activate %s because applications is already running!' => 'Nota de Segurança: Deve activar o %s, pois a aplicação está já em produção!',
      'PostMaster Filter' => 'Filtros do Chefe do Correio',
      'OTRS DB User' => 'Utilizador de Base de Dados OTRS',
      'PhoneView' => 'Visualização de Chamada',
      'PostMaster POP3 Account' => 'Conta do Chefe do Correio',
      'Verion' => 'Versão',
      'Message for new Owner' => 'Mensagem para o novo Proprietário',
      'merged' => 'junto',
      'OTRS DB Password' => 'Palavra-passe da Base de Dados OTRS',
      'Last update' => 'Última actualização',
      'Sorry, feature not active!' => 'Lamentamos, característica não activa!',
      'DB Admin Password' => 'Palavra-passe de Administrador da Base de Dados',
      'Drop Database' => 'Apagar Base de Dados',
      'Pending type' => 'Tipo de pendência',
      'Comment (internal)' => 'Comentário (interno)',
      'SMIME Management' => 'Gestão de SMIME',
      'Note!' => 'Nota!',
      '(Used ticket number format)' => '(Formato de número de bilhete utilizado)',
      'Fulltext' => 'Texto completo',
      'Modified' => 'Modificado',
      'Ticket\#' => 'Nú de Bilhete',
      'Watched Tickets' => '',
      'Watched' => '',
    };
    # $$STOP$$
}

1;
