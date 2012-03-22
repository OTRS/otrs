# --
# Kernel/Language/pt.pm - provides pt language translation
# Copyright (C) 2004-2007 CAT - Filipe Henriques <filipehenriques at ip.pt>viz
# Copyright (C) 2012 FCCN - Rui Francisco <rui.francisco@fccn.pt>
# --
# $Id: pt.pm,v 1.122 2012-03-22 14:23:58 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.122 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2012-03-22 15:21:44

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%Y-%M-%D %T';
    $Self->{DateFormatLong}      = '%A, %D de %B de %Y, %T';
    $Self->{DateFormatShort}     = '%Y-%M-%D';
    $Self->{DateInputFormat}     = '%Y-%M-%D';
    $Self->{DateInputFormatLong} = '%Y-%M-%D - %T';

    # csv separator
    $Self->{Separator} = ';';

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
        'Today' => 'Hoje',
        'Tomorrow' => 'Amanhã',
        'Next week' => '',
        'day' => 'dia',
        'days' => 'dias',
        'day(s)' => 'dia(s)',
        'd' => '',
        'hour' => 'hora',
        'hours' => 'horas',
        'hour(s)' => 'hora(s)',
        'Hours' => 'Horas',
        'h' => '',
        'minute' => 'minuto',
        'minutes' => 'minutos',
        'minute(s)' => 'minuto(s)',
        'Minutes' => 'Minutos',
        'm' => '',
        'month' => 'mês',
        'months' => 'meses',
        'month(s)' => 'mes(ses)',
        'week' => 'semana',
        'week(s)' => 'semana(s)',
        'year' => 'ano',
        'years' => 'anos',
        'year(s)' => 'ano(s)',
        'second(s)' => 'segundo(s)',
        'seconds' => 'segundos',
        'second' => 'segundo',
        's' => '',
        'wrote' => 'escreveu',
        'Message' => 'Mensagem',
        'Error' => 'Erro',
        'Bug Report' => 'Relatório de Erros',
        'Attention' => 'Atenção',
        'Warning' => 'Aviso',
        'Module' => 'Módulo',
        'Modulefile' => 'Ficheiro de Módulo',
        'Subfunction' => 'Sub-função',
        'Line' => 'Linha',
        'Setting' => 'Configuração',
        'Settings' => 'Configurações',
        'Example' => 'Exemplo',
        'Examples' => 'Exemplos',
        'valid' => 'válido',
        'Valid' => 'Válido',
        'invalid' => 'inválido',
        'Invalid' => '',
        '* invalid' => '* inválido',
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
        'Next...' => 'Próximo...',
        '...Back' => '...Voltar',
        '-none-' => '-nenhum(a)-',
        'none' => 'nenhum(a)',
        'none!' => 'nenhum(a)!',
        'none - answered' => 'nenhum - respondido',
        'please do not edit!' => 'por favor não editar!',
        'Need Action' => '',
        'AddLink' => 'Adicionar Ligação',
        'Link' => 'Ligar',
        'Unlink' => 'Desligar',
        'Linked' => 'Ligado',
        'Link (Normal)' => 'Ligar (Normal)',
        'Link (Parent)' => 'Ligar (Ascendente)',
        'Link (Child)' => 'Ligar (Descendente)',
        'Normal' => 'Normal',
        'Parent' => 'Ascendente',
        'Child' => 'Descendente',
        'Hit' => 'Acerto',
        'Hits' => 'Acertos',
        'Text' => 'Texto',
        'Standard' => '',
        'Lite' => 'Leve',
        'User' => 'Utilizador',
        'Username' => 'Nome de utilizador',
        'Language' => 'Idioma',
        'Languages' => 'Idiomas',
        'Password' => 'Palavra-passe',
        'Preferences' => 'Preferências',
        'Salutation' => 'Saudação',
        'Salutations' => 'Saudações',
        'Signature' => 'Assinatura',
        'Signatures' => 'Assinaturas',
        'Customer' => 'Cliente',
        'CustomerID' => 'ID de Cliente',
        'CustomerIDs' => 'ID de Cliente',
        'customer' => 'cliente',
        'agent' => 'agente',
        'system' => 'sistema',
        'Customer Info' => 'Informação de Cliente',
        'Customer Information' => 'Informação de cliente',
        'Customer Company' => 'Companhia do Cliente',
        'Customer Companies' => 'Companhias de clientes',
        'Company' => 'Companhia',
        'go!' => 'ir!',
        'go' => 'ir',
        'All' => 'Todos',
        'all' => 'todos',
        'Sorry' => 'Desculpe',
        'update!' => 'atualizar!',
        'update' => 'atualizar',
        'Update' => 'Atualizar',
        'Updated!' => 'Atualizado!',
        'submit!' => 'submeter!',
        'submit' => 'Submeter',
        'Submit' => 'Submeter',
        'change!' => 'alterar!',
        'Change' => 'Alterar',
        'change' => 'alterar',
        'click here' => 'clique aqui',
        'Comment' => 'Comentário',
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
        'Data' => 'Data',
        'Options' => 'Opções',
        'Title' => 'Título',
        'Item' => 'Item',
        'Delete' => 'Eliminar',
        'Edit' => 'Editar',
        'View' => 'Ver',
        'Number' => 'Número',
        'System' => 'Sistema',
        'Contact' => 'Contato',
        'Contacts' => 'Contatos',
        'Export' => 'Exportar',
        'Up' => 'Subir',
        'Down' => 'Descer',
        'Add' => 'Adicionar',
        'Added!' => 'Adicionado',
        'Category' => 'Categoria',
        'Viewer' => 'Visualizador',
        'Expand' => 'Expandir',
        'Small' => 'Pequeno',
        'Medium' => 'Médio',
        'Large' => 'Grande',
        'Date picker' => 'Selecionar data',
        'New message' => 'Nova mensagem',
        'New message!' => 'Nova mensagem!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Por favor, responda a este(s) ticket(s) para regressar à visualização de filas!',
        'You have %s new message(s)!' => 'Tem %s mensagem(s) nova(s)!',
        'You have %s reminder ticket(s)!' => 'Tem %s lembrete(s)!',
        'The recommended charset for your language is %s!' => 'O código recomendado para o seu idioma é %s!',
        'Change your password.' => 'Alterar a sua password',
        'Please activate %s first!' => '',
        'No suggestions' => 'Sem sugestões',
        'Word' => 'Palavra',
        'Ignore' => 'Ignorar',
        'replace with' => 'substituir por',
        'There is no account with that login name.' => 'Não existe nenhuma conta com esse nome de utilizador',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Login falhou! Utilizador ou password errada(s).',
        'There is no acount with that user name.' => 'Não existe nenhuma conta com esse nome.',
        'Please contact your administrator' => 'Por favor contate o administrador',
        'Logout' => 'Sair',
        'Logout successful. Thank you for using OTRS!' => 'Saiu com sucesso. Obrigado por utilizar o OTRS!',
        'Invalid SessionID!' => 'ID de Sessão Inválido',
        'Feature not active!' => 'Característica não ativa!',
        'Agent updated!' => 'Agente atualizado',
        'Create Database' => 'Criar Base de Dados',
        'System Settings' => 'Propriedades de Sistema',
        'Mail Configuration' => 'Configuração de correio',
        'Finished' => 'Terminado',
        'Install OTRS' => '',
        'Intro' => '',
        'License' => 'Licença',
        'Database' => 'Base de dados',
        'Configure Mail' => '',
        'Database deleted.' => '',
        'Database setup succesful!' => '',
        'Login is needed!' => 'Entrada necessária',
        'Password is needed!' => 'Palavra-passe indispensável!',
        'Take this Customer' => 'Fique com este Cliente',
        'Take this User' => 'Fique com este Utilizador',
        'possible' => 'possível',
        'reject' => 'rejeitar',
        'reverse' => 'reverter',
        'Facility' => 'Instalação',
        'Time Zone' => 'Fuso horário',
        'Pending till' => 'Pendente até',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            '',
        'Dispatching by email To: field.' => 'Despachado através do campo Para:',
        'Dispatching by selected Queue.' => 'Despachado pela Fila escolhida',
        'No entry found!' => 'Não se encontrou nada!',
        'Session has timed out. Please log in again.' => 'A sessão expirou. Por favor autentique-se novamente',
        'No Permission!' => 'Sem Permissão!',
        'To: (%s) replaced with database email!' => 'Para: (%s) substituído pelo endereço na base de dados!',
        'Cc: (%s) added database email!' => 'Cc: (%s) acrescentado endereço na base de dados!',
        '(Click here to add)' => '(Clique aqui para adicionar)',
        'Preview' => 'Prever',
        'Package not correctly deployed! Please reinstall the package.' =>
            '',
        '%s is not writable!' => '%s não modificável',
        'Cannot create %s!' => 'Não é possível criar %s',
        'Check to activate this date' => '',
        'You have Out of Office enabled, would you like to disable it?' =>
            '',
        'Customer %s added' => 'Cliente %s adicionado.',
        'Role added!' => 'Papel adicionado!',
        'Role updated!' => 'Popel atualizado!',
        'Attachment added!' => 'Anexo adicionado!',
        'Attachment updated!' => 'Anexo actualizado!',
        'Response added!' => 'Resposta adicionada!',
        'Response updated!' => 'Resposta atualizada!',
        'Group updated!' => 'Grupo atualizado',
        'Queue added!' => 'Fila adicionada!',
        'Queue updated!' => 'Fila atualizada!',
        'State added!' => 'Estado adicionado!',
        'State updated!' => 'Estado atualizado!',
        'Type added!' => 'Tipo adicionado!',
        'Type updated!' => 'Tipo atualizado!',
        'Customer updated!' => 'Cliente atualizado!',
        'Customer company added!' => '',
        'Customer company updated!' => '',
        'Mail account added!' => '',
        'Mail account updated!' => '',
        'System e-mail address added!' => '',
        'System e-mail address updated!' => '',
        'Contract' => 'Contrato',
        'Online Customer: %s' => 'Cliente em linha: %s',
        'Online Agent: %s' => 'Agente em linha: %s',
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
        'PGP' => '',
        'PGP Key' => 'Chave PGP',
        'PGP Keys' => 'Chaves PGP',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'Certificado S/MIME',
        'S/MIME Certificates' => 'Certificados S/MIME',
        'Office' => 'Gabinete',
        'Phone' => 'Telefone',
        'Fax' => '',
        'Mobile' => 'Movel',
        'Zip' => 'Código Postal',
        'City' => 'CAntiguidade',
        'Street' => 'Rua',
        'Country' => 'País',
        'Location' => 'Localização',
        'installed' => 'instalado',
        'uninstalled' => 'desinstalado',
        'Security Note: You should activate %s because application is already running!' =>
            '',
        'Unable to parse repository index document.' => 'Não foi possível realizar abrir o documento do repositório',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Não existem pacotes para a versão do software que possui, apenas existem pacotes para outra versões.',
        'No packages, or no new packages, found in selected repository.' =>
            'Não existem pacotes no repositório selecionado',
        'Edit the system configuration settings.' => '',
        'printed at' => 'impresso em',
        'Loading...' => 'A carregar...',
        'Dear Mr. %s,' => 'Exmo Sr, %s',
        'Dear Mrs. %s,' => 'Exma Sra. %s',
        'Dear %s,' => 'Caro %s,',
        'Hello %s,' => 'Cara %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'O email já existe. Inicie a sessão ou recupere a sua password',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Nova conta criada. Informação de inicio de sesão enviada para %s. Verifique o seu email.',
        'Please press Back and try again.' => 'Pressione anterior e tente novamente.',
        'Sent password reset instructions. Please check your email.' => 'Foram enviadas instruções de recuperação de password. Verifique o seu email.',
        'Sent new password to %s. Please check your email.' => 'Enviada nova password para %s. Verifique o seu email',
        'Upcoming Events' => 'Próximos eventos',
        'Event' => 'Evento',
        'Events' => 'Eventos',
        'Invalid Token!' => 'Token inválido',
        'more' => 'mais',
        'For more info see:' => 'Para mais informação consultar:',
        'Package verification failed!' => 'Verificação do pacote falhou',
        'Collapse' => 'Fechar',
        'Shown' => 'Mostrar',
        'News' => 'Notícias',
        'Product News' => 'Novidades do produto',
        'OTRS News' => 'Notícias OTRS',
        '7 Day Stats' => 'Estatísticas dos últimos 7 dias',
        'Bold' => 'Negrito',
        'Italic' => 'Itálico',
        'Underline' => 'Sublinhado',
        'Font Color' => 'Côr',
        'Background Color' => 'Côr de fundo',
        'Remove Formatting' => 'Limpar formação',
        'Show/Hide Hidden Elements' => '',
        'Align Left' => 'Alinhar à esquerda',
        'Align Center' => 'Centrar',
        'Align Right' => 'Alinhar à direita',
        'Justify' => 'Justificar',
        'Header' => 'Cabeçalho',
        'Indent' => 'Identar',
        'Outdent' => 'Desindentar',
        'Create an Unordered List' => 'Criar lista sem ordenação',
        'Create an Ordered List' => 'Criar lista ordenada',
        'HTML Link' => 'Ligação HTML',
        'Insert Image' => 'Inserir imagem',
        'CTRL' => 'CTRL',
        'SHIFT' => 'Shift',
        'Undo' => 'Desfazer',
        'Redo' => 'Refazer',
        'Scheduler process is registered but might not be running.' => '',
        'Scheduler is not running.' => '',

        # Template: AAACalendar
        'New Year\'s Day' => '',
        'International Workers\' Day' => '',
        'Christmas Eve' => '',
        'First Christmas Day' => '',
        'Second Christmas Day' => '',
        'New Year\'s Eve' => '',

        # Template: AAAGenericInterface
        'OTRS as requester' => '',
        'OTRS as provider' => '',
        'Webservice "%s" created!' => '',
        'Webservice "%s" updated!' => '',

        # Template: AAAMonth
        'Jan' => 'Jan',
        'Feb' => 'Fev',
        'Mar' => 'Mar',
        'Apr' => 'Abr',
        'May' => 'Mai',
        'Jun' => 'Jun',
        'Jul' => 'Jul',
        'Aug' => 'Ago',
        'Sep' => 'Set',
        'Oct' => 'Out',
        'Nov' => 'Nov',
        'Dec' => 'Dez',
        'January' => 'Janeiro',
        'February' => 'Fevereiro',
        'March' => 'Março',
        'April' => 'Abril',
        'May_long' => 'Maio',
        'June' => 'Junho',
        'July' => 'Julho',
        'August' => 'Agosto',
        'September' => 'Setembro',
        'October' => 'Outubro',
        'November' => 'Novembro',
        'December' => 'Dezembro',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Preferências atualizadas com sucesso!',
        'User Profile' => 'Perfil de utilizador',
        'Email Settings' => 'Definições de email',
        'Other Settings' => 'Outras definições',
        'Change Password' => 'Mudar a Palavra-passe',
        'Current password' => '',
        'New password' => 'Nova palavra-passe',
        'Verify password' => 'Confirmar password',
        'Spelling Dictionary' => 'Dicionário Ortográfico',
        'Default spelling dictionary' => 'Dicionário ortografia',
        'Max. shown Tickets a page in Overview.' => 'Número máximo de tickets por página em Vista Geral.',
        'The current password is not correct. Please try again!' => 'A password atual não está correta. Tente novamente',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Não foi possível atualizar a password, a nova password é diferente. Tente novamente',
        'Can\'t update password, it contains invalid characters!' => 'Não foi possível atualizar a password, contém carateres inválidos',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Não foi possível atualizar a password, tem de ter no mínimo %s carateres',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            'Não foi possível atualizar a password, tem de conter no mínimo 2 caracteres minúsculos e 2 caracteres maiusculos.',
        'Can\'t update password, it must contain at least 1 digit!' => 'Não foi possível atualizar a password, tem de ter no mínimo 1 dígito',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Não foi possível atualizar a password, tem de ter no mínimo 2 carateres',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Não foi possível atualizar a password, esta password já foi utilizada. Por favor escolha uma nova!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            '',
        'CSV Separator' => 'Separador CSV',

        # Template: AAAStats
        'Stat' => 'Relatórios',
        'Sum' => 'Somatório',
        'Please fill out the required fields!' => 'É necessário preencher os campos necessários',
        'Please select a file!' => 'É necessário escolher um ficheiro',
        'Please select an object!' => 'É necessário escolher um Objeto',
        'Please select a graph size!' => 'É necessário escolher um tamanho de gráfico',
        'Please select one element for the X-axis!' => 'É necessário escolher um elemento',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Selecione apenas um elemento ou desligue a opção Fixed onde o campo selecionado é marcado',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Se utilizar o campo selecionavel terá de selecionar alguns atributos do campo slecionado',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Insira um valor no campo a selecionar ou retire o visto da caixa.',
        'The selected end time is before the start time!' => 'O tempo de fim é anterior ao de inicio.',
        'You have to select one or more attributes from the select field!' =>
            'Terá de selecionar um ou mais atributos do campo selecionado',
        'The selected Date isn\'t valid!' => 'A data selecionada nao é válida',
        'Please select only one or two elements via the checkbox!' => 'Selecione um ou dois elementos da caixa',
        'If you use a time scale element you can only select one element!' =>
            'Se usar um elemento de escala de tempo só pode selecionar um elemento',
        'You have an error in your time selection!' => 'Existe um erro na seleção de tempo',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'O intervalo tempo do relatório é muito pequeno',
        'The selected start time is before the allowed start time!' => 'O tempo de inicio selecionado é anterior ao tempo de inicio permitido',
        'The selected end time is after the allowed end time!' => 'O tempo de fim selecionado é posterior ao tempo de fim permitido',
        'The selected time period is larger than the allowed time period!' =>
            'O intervalo de tempo é superior ao permitido',
        'Common Specification' => 'Especificações Comuns',
        'X-axis' => 'Eixo X',
        'Value Series' => 'Valores das Séries',
        'Restrictions' => 'Restrições',
        'graph-lines' => 'gráfico de linhas',
        'graph-bars' => 'gráfico de barras',
        'graph-hbars' => 'gráfico barras horizontais',
        'graph-points' => 'gráfico de pontos',
        'graph-lines-points' => 'gráfico de linhas e pontos',
        'graph-area' => 'gráfico de área',
        'graph-pie' => 'gráfico circular',
        'extended' => 'extendido',
        'Agent/Owner' => 'Agente',
        'Created by Agent/Owner' => 'Criado por Agente',
        'Created Priority' => 'Prioridade Criada',
        'Created State' => 'Estado de Prioridade',
        'Create Time' => 'Tempo de Prioridade',
        'CustomerUserLogin' => 'Acesso Cliente',
        'Close Time' => 'Tempo de Fecho',
        'TicketAccumulation' => 'Somatório de ticket',
        'Attributes to be printed' => 'Atributos a imprimir',
        'Sort sequence' => 'Sequência de ordenação',
        'Order by' => 'Ordenado por',
        'Limit' => 'Limite',
        'Ticketlist' => 'Lista de tickets',
        'ascending' => 'Ascendente',
        'descending' => 'Descendente',
        'First Lock' => 'Primeiro lock',
        'Evaluation by' => 'Avaliado por',
        'Total Time' => 'Tempo total',
        'Ticket Average' => 'Média de tickets',
        'Ticket Min Time' => 'Tempo Mínimo',
        'Ticket Max Time' => 'Tempo máximo',
        'Number of Tickets' => 'Nr. Tickets',
        'Article Average' => 'Média de artigos',
        'Article Min Time' => 'Tempo mínimo de artigos',
        'Article Max Time' => 'Tempo máximo de artigos',
        'Number of Articles' => 'Nr. Artigos',
        'Accounted time by Agent' => 'Tempo contabilizado pelo agente',
        'Ticket/Article Accounted Time' => 'Tempo contabilizado no Ticket/Artigo',
        'TicketAccountedTime' => 'Tempo contabilizado no ticket',
        'Ticket Create Time' => 'Hora de criação',
        'Ticket Close Time' => 'Hora de fecho',

        # Template: AAATicket
        'Status View' => 'Ver estado',
        'Bulk' => 'Em bloco',
        'Lock' => 'Bloquear',
        'Unlock' => 'Desbloquear',
        'History' => 'Histórico',
        'Zoom' => 'Pormenores',
        'Age' => 'Antiguidade',
        'Bounce' => 'Devolver',
        'Forward' => 'Encaminhar',
        'From' => 'De',
        'To' => 'Para',
        'Cc' => '',
        'Bcc' => '',
        'Subject' => 'Assunto',
        'Move' => 'Mover',
        'Queue' => 'Fila',
        'Queues' => 'Filas',
        'Priority' => 'Prioridade',
        'Priorities' => 'Prioridades',
        'Priority Update' => 'Atualização de Prioridade',
        'Priority added!' => '',
        'Priority updated!' => '',
        'Signature added!' => '',
        'Signature updated!' => '',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Nível de serviço',
        'Service Level Agreements' => 'Níveís de serviço',
        'Service' => 'Serviço',
        'Services' => 'Serviços',
        'State' => 'Estado',
        'States' => 'Estados',
        'Status' => 'Estado',
        'Statuses' => 'Estados',
        'Ticket Type' => 'Tipo de ticket',
        'Ticket Types' => 'Tipos de ticket',
        'Compose' => 'Compôr',
        'Pending' => 'Pendências',
        'Owner' => 'Proprietário',
        'Owner Update' => 'Atualizar Proprietário',
        'Responsible' => 'ResponsabilAntiguidade',
        'Responsible Update' => 'Atualização da ResponsabilAntiguidade',
        'Sender' => 'Remetente',
        'Article' => 'Artigo',
        'Ticket' => 'Ticket',
        'Createtime' => 'Hora de criação',
        'plain' => 'texto',
        'Email' => 'Email',
        'email' => 'email',
        'Close' => 'Fechar',
        'Action' => 'Ação',
        'Attachment' => 'Anexo',
        'Attachments' => 'Anexos',
        'This message was written in a character set other than your own.' =>
            'Esta mensagem foi escrita usando uma codificação diferente da sua.',
        'If it is not displayed correctly,' => 'Se não for exibida correctamente,',
        'This is a' => 'Este é um',
        'to open it in a new window.' => 'para a abrir numa nova janela.',
        'This is a HTML email. Click here to show it.' => 'Esta é uma mensagem HTML. Clicar aqui para visualizar.',
        'Free Fields' => 'Campos Livres',
        'Merge' => 'Fundir',
        'merged' => 'fundido',
        'closed successful' => 'fechado com sucesso',
        'closed unsuccessful' => 'fechado sem sucesso',
        'Locked Tickets Total' => 'Nr. de tickets bloqueado',
        'Locked Tickets Reminder Reached' => 'Lembrete de tickets bloqueado atingido',
        'Locked Tickets New' => 'Novos tickets bloqueados',
        'Responsible Tickets Total' => 'Total de tickets(responsável)',
        'Responsible Tickets New' => 'Novos tickets(responsável)',
        'Responsible Tickets Reminder Reached' => 'Lembrete de tickets(responsável) atingido',
        'Watched Tickets Total' => 'Total de tickets vigiados',
        'Watched Tickets New' => 'Novos tickets vigiados',
        'Watched Tickets Reminder Reached' => 'Lembrete de tickets vigiados',
        'All tickets' => 'Todos os tickets',
        'Available tickets' => '',
        'Escalation' => 'Escalagem',
        'last-search' => 'última pesquisa',
        'QueueView' => 'Filas',
        'Ticket Escalation View' => 'Fila de tickets escalados',
        'Message from' => '',
        'End message' => '',
        'Forwarded message from' => '',
        'End forwarded message' => '',
        'new' => 'novo',
        'open' => 'aberto',
        'Open' => 'Aberto',
        'Open tickets' => '',
        'closed' => 'fechado',
        'Closed' => 'Fechado',
        'Closed tickets' => '',
        'removed' => 'removido',
        'pending reminder' => 'pendente com lembrete',
        'pending auto' => 'pendente com fecho automático',
        'pending auto close+' => 'pendente com fecho automático+',
        'pending auto close-' => 'pendente com fecho automático-',
        'email-external' => 'email externo',
        'email-internal' => 'email interno',
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
        'auto follow up' => '',
        'auto reject' => '',
        'auto remove' => '',
        'auto reply' => '',
        'auto reply/new ticket' => '',
        'Ticket "%s" created!' => 'Ticket "%s" criado!',
        'Ticket Number' => 'Número do Ticket',
        'Ticket Object' => 'Objeto Ticket',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Não existe Número de Ticket "%s"! Não é possível efectuar a ligação!',
        'You don\'t have write access to this ticket.' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '',
        'Ticket selected.' => '',
        'Ticket is locked by another agent.' => '',
        'Ticket locked.' => '',
        'Don\'t show closed Tickets' => 'Não mostrar tickets fechados',
        'Show closed Tickets' => 'Mostrar tickets fechados',
        'New Article' => 'Novo Artigo',
        'Unread article(s) available' => 'Actualização não lidas',
        'Remove from list of watched tickets' => 'Remover dos tickets vigiados',
        'Add to list of watched tickets' => 'Adicionar aos tickets vigiados',
        'Email-Ticket' => 'Mensagem',
        'Create new Email Ticket' => 'Criar novo Ticket via email',
        'Phone-Ticket' => 'Telefonema',
        'Search Tickets' => 'Procurar Tickets',
        'Edit Customer Users' => 'Editar Utilizadores de cliente',
        'Edit Customer Company' => 'Editar a empresa do cliente',
        'Bulk Action' => 'Em bloco',
        'Bulk Actions on Tickets' => 'Operações em bloco sobre Tickets',
        'Send Email and create a new Ticket' => 'Enviar mensagem e criar novo Ticket',
        'Create new Email Ticket and send this out (Outbound)' => 'Criar novo Email Ticket e enviar para fora',
        'Create new Phone Ticket (Inbound)' => 'Criar novo Ticket por telefone',
        'Overview of all open Tickets' => 'Vista de todos os tickets abertos',
        'Locked Tickets' => 'Tickets bloqueados',
        'My Locked Tickets' => 'Os meus tickets bloqueados',
        'My Watched Tickets' => 'Os meus tickets vigiados',
        'My Responsible Tickets' => 'Tickets de que sou responsável',
        'Watched Tickets' => 'Ticket vigiados',
        'Watched' => 'Vigiado',
        'Watch' => 'Vigiar',
        'Unwatch' => '',
        'Lock it to work on it' => '',
        'Unlock to give it back to the queue' => '',
        'Show the ticket history' => '',
        'Print this ticket' => '',
        'Print this article' => '',
        'Split this article' => '',
        'Forward article via mail' => '',
        'Change the ticket priority' => '',
        'Change the ticket free fields!' => 'Alterar os campos livres do ticket!',
        'Link this ticket to other objects' => '',
        'Change the owner for this ticket' => '',
        'Change the  customer for this ticket' => '',
        'Add a note to this ticket' => '',
        'Merge into a different ticket' => '',
        'Set this ticket to pending' => '',
        'Close this ticket' => '',
        'Look into a ticket!' => 'Ver detalhe do ticket!',
        'Delete this ticket' => '',
        'Mark as Spam!' => 'Marcar como Spam!',
        'My Queues' => 'As Minhas Filas',
        'Shown Tickets' => 'Mostrar Tickets',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'O ticket com o número  "<OTRS_TICKET>" foi fundido com o ticket "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: primeira resposta terminou em (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: primeira resposta termina em (%s)!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: tempo de actualização terminou em (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: tempo de atualização termina em (%s)!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: tempo de resolução terminou em (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: tempo de resolução termina em (%s)!',
        'There are more escalated tickets!' => 'Existem mais tickets escalados',
        'Plain Format' => 'Formato de texto',
        'Reply All' => 'Responder a todos',
        'Direction' => 'Direção',
        'Agent (All with write permissions)' => 'Agente (Todos com permissões de escrita)',
        'Agent (Owner)' => 'Agente (proprietário)',
        'Agent (Responsible)' => 'Agente (Responsável)',
        'New ticket notification' => 'Notificação de novo ticket',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Enviar notificação se houver um novo ticket nas "Minhas Filas".',
        'Send new ticket notifications' => 'Enviar notificações em novos tickets',
        'Ticket follow up notification' => 'Enviar notificações em atualizações de tickets',
        'Ticket lock timeout notification' => 'Notificação por expiração de tempo de bloqueio',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Enviar notificação se um ticket for desbloqueado pelo sistema.',
        'Send ticket lock timeout notifications' => 'Enviar notificações quando o tempo de bloqueio expirar',
        'Ticket move notification' => 'Notificações de movimento de tickets',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Notificar-me se um ticket for movido para uma das "Minhas Filas".',
        'Send ticket move notifications' => 'Enviar notificações de movimento de tickets',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Seleção das filas favoritas. Será notificado acerca destas filas via email se o serviço estiver Ativo.',
        'Custom Queue' => 'Fila Personalizada',
        'QueueView refresh time' => 'Tempo de refrescamento da vista de Filas',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Se ativo, a vista de filas será atualizada após um período de tempo',
        'Refresh QueueView after' => 'Atualizar a vista de filas após',
        'Screen after new ticket' => 'Ecrãn após novo ticket',
        'Show this screen after I created a new ticket' => 'Mostrar este ecrã após criar novo ticket',
        'Closed Tickets' => 'Tickets fechados',
        'Show closed tickets.' => 'Mostrar tickets fechados',
        'Max. shown Tickets a page in QueueView.' => 'Número máximo de tickets por página',
        'Ticket Overview "Small" Limit' => 'Limite de tickets na vista "Pequena"',
        'Ticket limit per page for Ticket Overview "Small"' => 'Limite de tickets por página na vista "Pequena" ',
        'Ticket Overview "Medium" Limit' => 'Limite de tickets na vista "Média"',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Limite de tickets por página na vista "Média" ',
        'Ticket Overview "Preview" Limit' => 'Limite de tickets na vista "Detalhe"',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Limite de tickets por página na vista "Detalhe" ',
        'Ticket watch notification' => 'Notificação de tickets vigiados',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Quero receber para os tickets as mesmas notificações que os proprietários recebem',
        'Send ticket watch notifications' => 'Enviar notificações de tickets vigiados',
        'Out Of Office Time' => 'Horário de ausência ',
        'New Ticket' => 'Novo Ticket',
        'Create new Ticket' => 'Criar novo ticket',
        'Customer called' => 'O cliente telefonou',
        'phone call' => 'chamada telefónica',
        'Phone Call Outbound' => 'Realizar chamada telefónica',
        'Phone Call Inbound' => '',
        'Reminder Reached' => 'Limite alcançado',
        'Reminder Tickets' => 'Tickets com lembrete',
        'Escalated Tickets' => 'Tickets escalados',
        'New Tickets' => 'Novos tickets',
        'Open Tickets / Need to be answered' => 'Tickets abertos / precisam de resposta',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Todos os tickets abertos, tickets já tratados e que precisam de resposta adicional',
        'All new tickets, these tickets have not been worked on yet' => 'Todos os tickets, ainda sem qualquer tratamento',
        'All escalated tickets' => 'Todos os tickets eecalados',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Todos os tickets com lembrete ativo e que atigiram o tempo',
        'Archived tickets' => 'Tickets arquivados',
        'Unarchived tickets' => 'Tickets não arquivados',
        'History::Move' => 'Ticket movido para a fila "%s" (%s) da fila "%s" (%s).',
        'History::TypeUpdate' => 'Atualizado tipo para %s (ID=%s).',
        'History::ServiceUpdate' => 'Serviço atualizado para %s (ID=%s).',
        'History::SLAUpdate' => 'SLA atualizada para %s (ID=%s).',
        'History::NewTicket' => 'Novo Ticket [%s] criado (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Atualização para [%s]. %s',
        'History::SendAutoReject' => 'Rejeição automática enviada para "%s".',
        'History::SendAutoReply' => 'Auto resposta enviada para "%s".',
        'History::SendAutoFollowUp' => 'Auto Acompanhamento enviado para "%s".',
        'History::Forward' => 'Encaminhado para "%s".',
        'History::Bounce' => 'Bounced para "%s".',
        'History::SendAnswer' => 'Email enviado para "%s".',
        'History::SendAgentNotification' => '"%s"-notificação enviada para "%s".',
        'History::SendCustomerNotification' => 'Notificação enviada para "%s".',
        'History::EmailAgent' => 'Email enviado para cliente.',
        'History::EmailCustomer' => 'Adicionado Email. %s',
        'History::PhoneCallAgent' => 'Cliente contatado.',
        'History::PhoneCallCustomer' => 'Cliente contatou-nos.',
        'History::AddNote' => 'Nota adicionada (%s)',
        'History::Lock' => 'Ticket bloqueado.',
        'History::Unlock' => 'Ticket desbloqueado.',
        'History::TimeAccounting' => '%s unAntiguidades de tempo contabilizadas. Total %s unAntiguidades de tempo.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Atualizado: %s',
        'History::PriorityUpdate' => 'Alterada Prioridade de "%s" (%s) para "%s" (%s).',
        'History::OwnerUpdate' => 'Novo proprietário: "%s" (ID=%s).',
        'History::LoopProtection' => 'Loop-Protection! Nao foi enviada auto-resposta para "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Atualizado: %s',
        'History::StateUpdate' => 'Antigo: "%s" Novo: "%s"',
        'History::TicketDynamicFieldUpdate' => '',
        'History::WebRequestCustomer' => 'Ticket de cliente via web.',
        'History::TicketLinkAdd' => 'Adicionado novo link ao ticket "%s".',
        'History::TicketLinkDelete' => 'Link de ticket apagado "%s".',
        'History::Subscribe' => 'Adicionada sbscrição para o utilizador "%s".',
        'History::Unsubscribe' => 'Subscrição de ticket removida "%s".',
        'History::SystemRequest' => 'Pedido de sistema',
        'History::ResponsibleUpdate' => 'Atualização do responsável "%s"',
        'History::ArchiveFlagUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => 'Domingo',
        'Mon' => 'Segunda',
        'Tue' => 'Terça',
        'Wed' => 'Quarta',
        'Thu' => 'Quinta',
        'Fri' => 'Sexta',
        'Sat' => 'Sábado',

        # Template: AdminAttachment
        'Attachment Management' => 'Gestão de Anexos',
        'Actions' => 'Ações',
        'Go to overview' => 'Vista geral',
        'Add attachment' => 'Adicionar anexo',
        'List' => 'Listar',
        'Validity' => '',
        'No data found.' => 'não há resultados',
        'Download file' => 'Descarregar ficheiro',
        'Delete this attachment' => 'Remover anexo',
        'Add Attachment' => 'Adicionar anexo',
        'Edit Attachment' => 'Editar anexo',
        'This field is required.' => 'Campo obrigatório',
        'or' => 'ou',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Gestão de Respostas Automáticas',
        'Add auto response' => 'Adicionar auto resposta',
        'Add Auto Response' => 'Adicionar auto resposta',
        'Edit Auto Response' => 'Editar auto resposta',
        'Response' => 'Resposta',
        'Auto response from' => 'Remetente da auto resposta',
        'Reference' => 'Referência',
        'You can use the following tags' => 'Pode utilizar as seguintes tags',
        'To get the first 20 character of the subject.' => 'Para obter os primeiros 20 Caracteres do assunto',
        'To get the first 5 lines of the email.' => 'Para obter as primeiras 5 linhas do email',
        'To get the realname of the sender (if given).' => 'Para obter o nome do remetente (se dado)',
        'To get the article attribute' => 'Para obter os atributos do artigo',
        ' e. g.' => 'ex:',
        'Options of the current customer user data' => 'Opções disponíveis para o cliente atual',
        'Ticket owner options' => 'Opções do proprietário do ticket',
        'Ticket responsible options' => 'Opções do responsável do ticket',
        'Options of the current user who requested this action' => 'Opções do utilizador atual que pediu esta ação',
        'Options of the ticket data' => 'Opções para informação do ticket',
        'Config options' => 'Opções de configuração',
        'Example response' => 'Resposta de exemplo',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'Gestão de utilizadores de cliente',
        'Wildcards like \'*\' are allowed.' => '',
        'Add customer company' => 'Adicionar empresa de cliente',
        'Please enter a search term to look for customer companies.' => 'Introduza o termos de pesquisa',
        'Add Customer Company' => 'Adicionar utilizador de companhia',

        # Template: AdminCustomerUser
        'Customer Management' => 'Gestão de clientes',
        'Add customer' => 'Adicionar cliente',
        'Select' => 'Selecionar',
        'Hint' => 'Sugestão',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'O cliente necessita de possuir histórico e efectuar login no interface cliente',
        'Please enter a search term to look for customers.' => 'Introduza o termo de pesquisa para clientes',
        'Last Login' => 'Último acesso',
        'Add Customer' => 'Adicionar cliente',
        'Edit Customer' => 'Editar cliente',
        'This field is required and needs to be a valid email address.' =>
            'O campo é obrigatório e necessita de ser um email válido',
        'This email address is not allowed due to the system configuration.' =>
            'Email não permitido devido a configuração de sistema.',
        'This email address failed MX check.' => 'Falhou a verificação de registo MX para o email',
        'DNS problem, please check your configuration and the error log.' =>
            '',
        'The syntax of this email address is incorrect.' => 'Sintaxe do email incorreta',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Gerir relações grupo-cliente',
        'Notice' => 'Aviso',
        'This feature is disabled!' => 'Esta opção está inativa',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Utilize esta opção se quiser definir grupos de permissões para clientes',
        'Enable it here!' => 'Ativar aqui',
        'Search for customers.' => '',
        'Edit Customer Default Groups' => 'Editar os grupos de cliente por omissão',
        'These groups are automatically assigned to all customers.' => 'Estes grupos são automaticamente atribuídos a todos os clientes',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Pode gerir estes groups via item de configuração "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filtro de grupos',
        'Select the customer:group permissions.' => 'Selecionar as permissões customer:group',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Se nada for selecionado, o grupo não tem permissões(os tickets não vão estar visisveis para o cliente)',
        'Search Result:' => 'Resultado da pesquisa',
        'Customers' => 'Clientes',
        'Groups' => 'Grupos',
        'No matches found.' => 'Não foram encontrados resultados',
        'Change Group Relations for Customer' => 'Alterar relações de grupo com o cliente',
        'Change Customer Relations for Group' => 'Alterar a relação de cliente com o grupo',
        'Toggle %s Permission for all' => 'Ativar a permissão %s para todos',
        'Toggle %s permission for %s' => 'Ativar a permissão %s para %s',
        'Customer Default Groups:' => 'Grupos por omissão para o cliente',
        'No changes can be made to these groups.' => 'Não é possível realizar alterações aos seguintes grupos',
        'ro' => 'leitura',
        'Read only access to the ticket in this group/queue.' => 'Acesso apenas de leitura para o ticket neste grupo/fila.',
        'rw' => 'escrita',
        'Full read and write access to the tickets in this group/queue.' =>
            'Acesso total de leitura e escrita para os tickets neste grupo/fila.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Gerir relações Cliente-Serviço',
        'Edit default services' => 'Editar os serviços por omissão',
        'Filter for Services' => 'Filtro para serviços',
        'Allocate Services to Customer' => 'Atribuir serviços ao cliente',
        'Allocate Customers to Service' => 'Atribuir clientes ao serviço',
        'Toggle active state for all' => 'Ativar estado para todos',
        'Active' => 'Ativo',
        'Toggle active state for %s' => 'Ativara estar para %s ',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '',
        'Add new field for object' => '',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => '',
        'Dynamic fields per page' => '',
        'Label' => '',
        'Order' => '',
        'Object' => 'Objeto',
        'Delete this field' => '',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '',
        'Delete field' => '',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => '',
        'Field' => '',
        'Go back to overview' => '',
        'General' => '',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '',
        'Changing this value will require manual changes in the system.' =>
            '',
        'This is the name to be shown on the screens where the field is active.' =>
            '',
        'Field order' => '',
        'This field is required and must be numeric.' => '',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '',
        'Field type' => '',
        'Object type' => '',
        'Field Settings' => '',
        'Default value' => 'Valor por omissão',
        'This is the default value for this field.' => '',
        'Save' => 'Guardar',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '',
        'This field must be numeric.' => '',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '',
        'Define years period' => '',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '',
        'Years in the past' => '',
        'Years in the past to display (default: 5 years).' => '',
        'Years in the future' => '',
        'Years in the future to display (default: 5 years).' => '',
        'Show link' => '',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '',
        'Key' => 'Chave',
        'Value' => 'Valor',
        'Remove value' => '',
        'Add value' => '',
        'Add Value' => '',
        'Add empty value' => '',
        'Activate this option to create an empty selectable value.' => '',
        'Translatable values' => '',
        'If you activate this option the values will be translated to the user defined language.' =>
            '',
        'Note' => '',
        'You need to add the translations manually into the language translation files.' =>
            '',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => '',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '',
        'Number of cols' => '',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '',

        # Template: AdminEmail
        'Admin Notification' => 'Notificações de administração',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Com este módulo, os administradores podem enviar mensagens aos agentes, grupos ou membros de um papel',
        'Create Administrative Message' => 'Nova mensagem administrativa',
        'Your message was sent to' => 'Mensagem enviada para',
        'Send message to users' => 'Enviar mensagem a utilizadores',
        'Send message to group members' => 'Enviar mensagem aos membros do grupo',
        'Group members need to have permission' => 'Os membros do grupo necessitam de ter permissões',
        'Send message to role members' => 'Enviar mensagem aos membros do papel',
        'Also send to customers in groups' => 'Enviar também a clientes em grupos',
        'Body' => 'Corpo',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Agente genérico',
        'Add job' => 'Adicionar tarefa',
        'Last run' => 'Última execução',
        'Run Now!' => 'Executar Agora!',
        'Delete this task' => 'Apagar tarefa',
        'Run this task' => 'Executar esta tarefa',
        'Job Settings' => 'Definições da tarefa',
        'Job name' => 'Nome da tarefa',
        'Currently this generic agent job will not run automatically.' =>
            'Atualmente, esta tarefa não é executada automaticamente',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Tem de selecionar pelo menos um minuto, segundo ou dia para ativar a execução automática',
        'Schedule minutes' => 'Minutos agendados',
        'Schedule hours' => 'Horas agendada',
        'Schedule days' => 'Dias agendados',
        'Toggle this widget' => 'Ativar esta funcionalAntiguidade',
        'Ticket Filter' => 'Filtro de tickets',
        '(e. g. 10*5155 or 105658*)' => '(ex., 10*5155 ou 105658*)',
        '(e. g. 234321)' => '(ex., 234321)',
        'Customer login' => 'Login de cliente',
        '(e. g. U5150)' => '(ex., U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Pesquisa em texto integral do artigo (ex. "Mar*in" ou "Baue*")',
        'Agent' => 'Agente',
        'Ticket lock' => 'Ticket bloqueado',
        'Create times' => 'Criar tempo',
        'No create time settings.' => 'Não existem definições de Tempo Criados',
        'Ticket created' => 'Ticket criado',
        'Ticket created between' => 'Ticket criado entre',
        'Change times' => '',
        'No change time settings.' => '',
        'Ticket changed' => '',
        'Ticket changed between' => '',
        'Close times' => 'Tempo de fecho',
        'No close time settings.' => 'Sem definições de tempo de fecho',
        'Ticket closed' => 'Ticket fechado',
        'Ticket closed between' => 'Ticket fechado entre',
        'Pending times' => 'Tempos pendentes',
        'No pending time settings.' => 'Não existem definições de tempo pendente',
        'Ticket pending time reached' => 'Tempo de pendência do ticket atingido',
        'Ticket pending time reached between' => 'Tempo de pendência do ticket entre',
        'Escalation times' => 'Tempos de escalagem',
        'No escalation time settings.' => 'Sem definições de tempo de escalagem',
        'Ticket escalation time reached' => 'Tempo de escalagem atingido',
        'Ticket escalation time reached between' => 'Tempo de escalagem atingido entre',
        'Escalation - first response time' => 'Escalagem - tempo da primeira resposta',
        'Ticket first response time reached' => 'Tempo da primeira reposta atingido',
        'Ticket first response time reached between' => 'Tempo da primeira reposta atingido entre',
        'Escalation - update time' => 'Escalagem - tempo atualizado',
        'Ticket update time reached' => 'Tempo de atualização de ticket atingido',
        'Ticket update time reached between' => 'Tempo de atualização de ticket atingido entre',
        'Escalation - solution time' => 'Escalagem - tempo de solução',
        'Ticket solution time reached' => 'Tempo de solução de ticket atingido',
        'Ticket solution time reached between' => 'Tempo de solução de ticket atingido entre',
        'Archive search option' => 'Arquivar opção de pesquisa',
        'Ticket Action' => 'Ação do ticket',
        'Set new service' => 'Criar novo serviço',
        'Set new Service Level Agreement' => 'Criar novo SLA',
        'Set new priority' => 'Criar nova Prioridade',
        'Set new queue' => 'Criar nova fila',
        'Set new state' => 'Criar novo estado',
        'Set new agent' => 'Criar novo agente',
        'new owner' => 'Novo proprietário',
        'new responsible' => '',
        'Set new ticket lock' => 'Criar novo bloqueio no ticket',
        'New customer' => 'Novo cliente',
        'New customer ID' => 'Novo ID de cliente',
        'New title' => 'Novo título',
        'New type' => 'Novo tipo',
        'New Dynamic Field Values' => '',
        'Archive selected tickets' => 'Arquivar tickets selecionados',
        'Add Note' => 'Adicionar nota',
        'Time units' => 'UnAntiguidades de tempo',
        ' (work units)' => ' (unAntiguidades de trabalho)',
        'Ticket Commands' => 'Comandos para tickets',
        'Send agent/customer notifications on changes' => 'Enviar notificações de alterações a agente/cliente ',
        'CMD' => '',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Este comando será executado. ARG[0] será o número do ticket e ARG[1] o seu ID.',
        'Delete tickets' => 'Remover tickets',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Aviso: todos os tickets afectados serão removidos da base dados e não podem ser recuperados',
        'Execute Custom Module' => 'Executar módulo customizado',
        'Param %s key' => 'Chave do parametro %s',
        'Param %s value' => 'Valor do parametro %s',
        'Save Changes' => 'Guardar alterações ',
        'Results' => 'Resultados',
        '%s Tickets affected! What do you want to do?' => '%s tickets afetados. O que deseja fazer ?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Aviso: Utilizou a opção de APAGAR. Todos os tickets vão ser perdidos.',
        'Edit job' => 'Editar tarefa',
        'Run job' => 'Executar tarefa',
        'Affected Tickets' => 'Tickets afetados',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'Web Services' => '',
        'Debugger' => '',
        'Go back to web service' => '',
        'Clear' => '',
        'Do you really want to clear the debug log of this web service?' =>
            '',
        'Request List' => '',
        'Time' => 'Tempo',
        'Remote IP' => '',
        'Loading' => '',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Refresh' => '',
        'Request Details' => '',
        'An error occurred during communication.' => '',
        'Show or hide the content' => 'Mostrar ou esconder o conteúdo',
        'Clear debug log' => '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => '',
        'Change Invoker %s of Web Service %s' => '',
        'Add new invoker' => '',
        'Change invoker %s' => '',
        'Do you really want to delete this invoker?' => '',
        'All configuration data will be lost.' => '',
        'Invoker Details' => '',
        'The name is typically used to call up an operation of a remote web service.' =>
            '',
        'Please provide a unique name for this web service invoker.' => '',
        'The name you entered already exists.' => '',
        'Invoker backend' => '',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '',
        'Mapping for outgoing request data' => '',
        'Configure' => '',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Mapping for incoming response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '',
        'Event Triggers' => '',
        'Asynchronous' => '',
        'Delete this event' => '',
        'This invoker will be triggered by the configured events.' => '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => '',
        'Save and finish' => '',
        'Delete this Invoker' => '',
        'Delete this Event Trigger' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => '',
        'Go back to' => '',
        'Mapping Simple' => '',
        'Default rule for unmapped keys' => '',
        'This rule will apply for all keys with no mapping rule.' => '',
        'Default rule for unmapped values' => '',
        'This rule will apply for all values with no mapping rule.' => '',
        'New key map' => '',
        'Add key mapping' => '',
        'Mapping for Key ' => '',
        'Remove key mapping' => '',
        'Key mapping' => '',
        'Map key' => '',
        'matching the' => '',
        'to new key' => '',
        'Value mapping' => '',
        'Map value' => '',
        'to new value' => '',
        'Remove value mapping' => '',
        'New value map' => '',
        'Add value mapping' => '',
        'Do you really want to delete this key mapping?' => '',
        'Delete this Key Mapping' => '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => '',
        'Change Operation %s of Web Service %s' => '',
        'Add new operation' => '',
        'Change operation %s' => '',
        'Do you really want to delete this operation?' => '',
        'Operation Details' => '',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '',
        'Please provide a unique name for this web service.' => '',
        'Mapping for incoming request data' => '',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '',
        'Operation backend' => '',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '',
        'Mapping for outgoing response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Delete this Operation' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => '',
        'Network transport' => '',
        'Properties' => '',
        'Endpoint' => '',
        'URI to indicate a specific location for accessing a service.' =>
            '',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => '',
        'Namespace' => '',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Maximum message length' => '',
        'This field should be an integer number.' => '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '',
        'Encoding' => '',
        'The character encoding for the SOAP message contents.' => '',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '',
        'SOAPAction' => '',
        'Set to "Yes" to send a filled SOAPAction header.' => '',
        'Set to "No" to send an empty SOAPAction header.' => '',
        'SOAPAction separator' => '',
        'Character to use as separator between name space and SOAP method.' =>
            '',
        'Usually .Net web services uses a "/" as separator.' => '',
        'Authentication' => '',
        'The authentication mechanism to access the remote system.' => '',
        'A "-" value means no authentication.' => '',
        'The user name to be used to access the remote system.' => '',
        'The password for the privileged user.' => '',
        'Use SSL Options' => '',
        'Show or hide SSL options to connect to the remote system.' => '',
        'Certificate File' => '',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => '',
        'Certificate Password File' => '',
        'The password to open the SSL certificate.' => '',
        'Certification Authority (CA) File' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '',
        'Certification Authority (CA) Directory' => '',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '',
        'Proxy Server' => '',
        'URI of a proxy server to be used (if needed).' => '',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => '',
        'The user name to be used to access the proxy server.' => '',
        'Proxy Password' => '',
        'The password for the proxy user.' => '',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => '',
        'Add web service' => '',
        'Clone web service' => '',
        'The name must be unique.' => '',
        'Clone' => '',
        'Export web service' => '',
        'Import web service' => '',
        'Configuration File' => '',
        'The file must be a valid web service configuration YAML file.' =>
            '',
        'Import' => 'Importar',
        'Configuration history' => '',
        'Delete web service' => '',
        'Do you really want to delete this web service?' => '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '',
        'Web Service List' => '',
        'Remote system' => '',
        'Provider transport' => '',
        'Requester transport' => '',
        'Details' => '',
        'Debug threshold' => '',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '',
        'Operations are individual system functions which remote systems can request.' =>
            '',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '',
        'Controller' => '',
        'Inbound mapping' => '',
        'Outbound mapping' => '',
        'Delete this action' => '',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '',
        'Delete webservice' => '',
        'Delete operation' => '',
        'Delete invoker' => '',
        'Clone webservice' => '',
        'Import webservice' => '',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => '',
        'Go back to Web Service' => '',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '',
        'Configuration History List' => '',
        'Version' => 'Versão',
        'Create time' => '',
        'Select a single configuration version to see its details.' => '',
        'Export web service configuration' => '',
        'Restore web service configuration' => '',
        'Do you really want to restore this version of the web service configuration?' =>
            '',
        'Your current web service configuration will be overwritten.' => '',
        'Show or hide the content.' => '',
        'Restore' => '',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'AVISO: Ao mudar o nome do grupo \'admin\', antes de efetuar as alterações em  SysConfig, vai perder a sessão de administração! Caso aconteça , renomeie o grupo novamente para admin através de SQL.',
        'Group Management' => 'Gestão de Grupos',
        'Add group' => 'Adicionar grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'O grupo admin é para acesso à área de administração e o grupo stats é para acesso à área de estatísticas.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '',
        'It\'s useful for ASP solutions. ' => 'Desnecessário para suloções ASP',
        'Add Group' => 'Adicionar Grupo',
        'Edit Group' => 'Editar grupo',

        # Template: AdminLog
        'System Log' => 'Log de Sistema',
        'Here you will find log information about your system.' => 'Aqui vai encontrar informação acerca do sistema',
        'Hide this message' => 'Esconder esta mensagem',
        'Recent Log Entries' => 'Últimas entradas',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Gestão de contas de email',
        'Add mail account' => 'Adicionar conta de email',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Todas as mensagens recebidas para um email serão enviadas para a fila selecionada!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Se a conta for de confiança, os cabeçalhos X-OTRS header existentes vão ser utilizados(para  priority, ...)! O filtro PostMaster será igualmente utilizado.',
        'Host' => 'Anfitrião',
        'Delete account' => 'Ápagar conta',
        'Fetch mail' => 'Descarregar emails',
        'Add Mail Account' => 'Adicionar conta de email',
        'Example: mail.example.com' => 'Exemplo: mail.example.com',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'De confiança',
        'Dispatching' => 'Enviado',
        'Edit Mail Account' => 'Editar conta de email',

        # Template: AdminNavigationBar
        'Admin' => 'Administração',
        'Agent Management' => 'Gestão de agentes',
        'Queue Settings' => 'Definições de filas',
        'Ticket Settings' => 'Definições de tickets',
        'System Administration' => 'Administração de sistema',

        # Template: AdminNotification
        'Notification Management' => 'Gestão de Notificações',
        'Select a different language' => 'Selecionar um idioma diferente',
        'Filter for Notification' => 'Filtro para notificações',
        'Notifications are sent to an agent or a customer.' => 'As notificações são enviadas para um agente ou um cliente.',
        'Notification' => 'Notificações',
        'Edit Notification' => 'Editar notificação',
        'e. g.' => 'ex. ',
        'Options of the current customer data' => 'Opções para o cliente atual',

        # Template: AdminNotificationEvent
        'Add notification' => 'Adicionar notificação',
        'Delete this notification' => 'Apagar notificação',
        'Add Notification' => 'Adicionar notificação',
        'Recipient groups' => 'Grupos remetentes',
        'Recipient agents' => 'Agentes remetentes',
        'Recipient roles' => 'Papeís remetentes',
        'Recipient email addresses' => 'Emails de remetente',
        'Article type' => 'Tipo de artigo',
        'Only for ArticleCreate event' => 'Apenas para o evento ArticleCreate',
        'Subject match' => 'Igual a assunto',
        'Body match' => 'Igual ao corpo do email',
        'Include attachments to notification' => 'Incluir anexos na notificação',
        'Notification article type' => 'Notificação de tipo de artigo',
        'Only for notifications to specified email addresses' => 'Apenas para notificações a emails específicos ',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Para obter os primeiros 20 carateres do assunto (do último artigo do agente)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Para obter as últimas 5 linhas do corpo do email (do último artigo do agente)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Para obter os primeiros 20 carateres do assunto (do último artigo do cliente)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Para obter as últimas 5 linhas do corpo do email (do último artigo do cliente)',

        # Template: AdminPGP
        'PGP Management' => 'Gestão de PGP',
        'Use this feature if you want to work with PGP keys.' => 'Utilize esta funcionalAntiguidade para utilizar chaves PGP',
        'Add PGP key' => 'Adicionar chave PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Desta forma pode editar diretamente o anel de chaves configurado no SysConfig',
        'Introduction to PGP' => 'Intordução ao PGP',
        'Result' => 'Resultado',
        'Identifier' => 'Identificador',
        'Bit' => '',
        'Fingerprint' => 'Impressão Digital',
        'Expires' => 'Expira',
        'Delete this key' => 'Apagar chave',
        'Add PGP Key' => 'Adicionar chave PGP',
        'PGP key' => 'Chave PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestor de Pacotes',
        'Uninstall package' => 'Desinstalar pacote',
        'Do you really want to uninstall this package?' => 'Deseja mesmo desinstalar este pacote?',
        'Reinstall package' => 'Re-instalar pacote',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Confirma a re-instalação do pacote ? As alterações manuais serão perdidas.',
        'Continue' => 'Continuar',
        'Install' => 'Instalar',
        'Install Package' => 'Instalar pacote',
        'Update repository information' => 'Atualizar informação do repositório',
        'Did not find a required feature? OTRS Group provides their subscription customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'Repositório Online',
        'Vendor' => 'Fabricante',
        'Module documentation' => 'Documentação do módulo',
        'Upgrade' => 'Melhoria de Versão',
        'Local Repository' => 'Repositório Local',
        'Uninstall' => 'Desinstalar',
        'Reinstall' => 'Reinstalar',
        'Feature Add-Ons' => '',
        'Download package' => 'Descarregar pacote',
        'Rebuild package' => 'Reconstruir o pacote',
        'Metadata' => 'Metadados',
        'Change Log' => 'Log de alterações',
        'Date' => 'Data',
        'List of Files' => 'Lista de ficheiros',
        'Permission' => 'Permissão',
        'Download' => 'Descarregar',
        'Download file from package!' => 'Descarregar ficheiro do pacote',
        'Required' => 'Obrigatório',
        'PrimaryKey' => 'ChavePrincipal',
        'AutoIncrement' => 'AutoIncrementar',
        'SQL' => '',
        'File differences for file %s' => 'Diferenças entre ficheiros para %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log de desempenho',
        'This feature is enabled!' => 'Esta opção está ativa',
        'Just use this feature if you want to log each request.' => 'Uuse esta opção apenas se pretender registar cada pedido',
        'Activating this feature might affect your system performance!' =>
            '',
        'Disable it here!' => 'Desativar aqui',
        'Logfile too large!' => 'Ficheiro de log demasiado grande',
        'The logfile is too large, you need to reset it' => 'Ficheiro de log demasiado grande, é necessário limpar',
        'Overview' => 'Vista Geral',
        'Range' => 'Intervalo',
        'Interface' => 'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")',
        'Requests' => 'Pedidos',
        'Min Response' => 'Resposta mínima',
        'Max Response' => 'Resposta máxima',
        'Average Response' => 'Média de Resposta',
        'Period' => 'Período',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Média',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gestão de Filtros de Correio',
        'Add filter' => 'Adicionar filtro',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Para enviar ou filtrar emails baseado nos cabeçalhos. É possível a utilização de expressões regulares.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Se pretender apenas igualar o email, utilize EMAILADDRESS:info@example.com em From, To ou Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Se utilizar expressões regulares, pode condizer valores em () como [***] na ação \'Set\' .',
        'Delete this filter' => 'Apagar filtro',
        'Add PostMaster Filter' => 'Adicionar filtro de correio',
        'Edit PostMaster Filter' => 'Editar filtro de correio',
        'Filter name' => 'Nome do filtro',
        'The name is required.' => 'O nome é obrigatório',
        'Stop after match' => 'Parar após encontrar',
        'Filter Condition' => 'Condição do filtro',
        'The field needs to be a valid regular expression or a literal word.' =>
            'O filtro necessita de ser uma expressão regular válida ou uma palavra.',
        'Set Email Headers' => 'Define os cabeçalhos de email',
        'The field needs to be a literal word.' => 'O campo necessita de ser uma palavra',

        # Template: AdminPriority
        'Priority Management' => 'Gestão de Prioridades',
        'Add priority' => 'Adicionar Prioridade',
        'Add Priority' => 'Adicionar Prioridade',
        'Edit Priority' => 'Editar Prioridade',

        # Template: AdminQueue
        'Manage Queues' => 'Gerir filas',
        'Add queue' => 'Adicionar fila',
        'Add Queue' => 'Adicionar Fila',
        'Edit Queue' => 'Editar fila',
        'Sub-queue of' => 'Sub-fila de ',
        'Unlock timeout' => 'Tempo de desbloqueio',
        '0 = no unlock' => '0 = sem desbloqueio',
        'Only business hours are counted.' => 'Apenas são contabilizadas horas de expediente',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Se um ticket for bloqueado e o agente não o fechar antes de terminar o prazo pendente, o ticket fica desbloqueado e disponível para outros agentes.',
        'Notify by' => 'Notificar por',
        '0 = no escalation' => '0 = sem escalagem',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Se não for adicionar um contacto de cliente ao ticket antes do período definio, o ticket é escalado.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Se um novo artigo for adicionar,por email ou via browser, o tempo de escalagem é reiniciado. Caso contrário se o tempo expirar o ticket é escalado.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Se o ticket não for fechado antes do tempo definido, o ticket é escalado',
        'Follow up Option' => 'Opção de atualização',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Especifica se uma atualização reabre o ticket, rejeita a atualização ou abre um novo ticket',
        'Ticket lock after a follow up' => 'Bloqueio do ticket após atualização',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Se o ticket for fechado e o cliente enviar uma atualização, o ticket vai ficar bloqueado ao último proprietário',
        'System address' => 'Endereço de sistema',
        'Will be the sender address of this queue for email answers.' => 'Será o endereço de email usado para respostas nesta fila.',
        'Default sign key' => 'Chave de assinatura por omissão',
        'The salutation for email answers.' => 'A saudação das respostas de email.',
        'The signature for email answers.' => 'A assinatura das respostas de email.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Gerir as relações Fila - autoresposta',
        'Filter for Queues' => 'Filtro para filas',
        'Filter for Auto Responses' => 'Filtro para auto respostas',
        'Auto Responses' => 'Respostas Automáticas',
        'Change Auto Response Relations for Queue' => 'Alterar as relações de auto respostas para a fila',
        'settings' => 'definições',

        # Template: AdminQueueResponses
        'Manage Response-Queue Relations' => 'Gerir as relações resposta - fila',
        'Filter' => 'Filtro',
        'Filter for Responses' => 'Filtro para respostas',
        'Responses' => 'Respostas',
        'Change Queue Relations for Response' => 'Gerir relações da fila com as respostas',
        'Change Response Relations for Queue' => 'Alterar a relação da resposta com a fila',

        # Template: AdminResponse
        'Manage Responses' => 'Gerir respostas',
        'Add response' => 'Adicionar resposta',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            '',
        'Don\'t forget to add new responses to queues.' => '',
        'Delete this entry' => 'Apagar esta entrada',
        'Add Response' => 'Adicionar resposta',
        'Edit Response' => 'Editar resposta',
        'The current ticket state is' => 'O estado atual do ticket é',
        'Your email address is' => 'O seu email é',

        # Template: AdminResponseAttachment
        'Manage Responses <-> Attachments Relations' => 'Gerir relações respostas <-> Anexos',
        'Filter for Attachments' => 'Filtro para anexos',
        'Change Response Relations for Attachment' => 'Alterar relações da resposta <-> anexo',
        'Change Attachment Relations for Response' => 'Alterar relações resposta <-> anexo',
        'Toggle active for all' => 'Ativar para todos',
        'Link %s to selected %s' => 'Ligar %s a item selecionado %s',

        # Template: AdminRole
        'Role Management' => 'Gestão de Papeis',
        'Add role' => 'Adicionar papel',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Criar um papel e atribuir-lhe grupos. Depois atribuir o papel aos utilizadores.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Não há papeis definidos. Utilize o botão \'Adicionar\' para criar um novo papel ',
        'Add Role' => 'Adicionar Papel',
        'Edit Role' => 'Editar papel',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Gerir relações Papel-Grupo',
        'Filter for Roles' => 'Filtro para papéis',
        'Roles' => 'Papeis',
        'Select the role:group permissions.' => 'Seleciona as permissões papel:grupo',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Se nada for selecionado, o grupo não terá permissões(os tickets não serão visiveis para o papel)',
        'Change Role Relations for Group' => 'Alterar as relações do papel para o grupo',
        'Change Group Relations for Role' => 'Alterar as relações do grupo para o papel',
        'Toggle %s permission for all' => 'Ativar a permissão %s para todos',
        'move_into' => 'mover para',
        'Permissions to move tickets into this group/queue.' => 'Permissões para mover tickets para este grupo/queue',
        'create' => 'criar',
        'Permissions to create tickets in this group/queue.' => 'Permissões para criar tickets neste grupo/queue',
        'priority' => 'Prioridade',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permissões para modificar a Prioridade do ticket neste grupo/queue',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Gerir relações Agente-Papel',
        'Filter for Agents' => 'Filtro para agentes',
        'Agents' => 'Agentes',
        'Manage Role-Agent Relations' => 'Gerir relações papel-agente',
        'Change Role Relations for Agent' => 'Alterar as relações do papel com o agente',
        'Change Agent Relations for Role' => 'Alteras as relações do agente com o papel',

        # Template: AdminSLA
        'SLA Management' => 'Gestão de SLA',
        'Add SLA' => 'Adicionar SLA',
        'Edit SLA' => 'Editar SLA',
        'Please write only numbers!' => 'Introduza apenas números',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gestão de S/MIME',
        'Add certificate' => 'Adicionar certificado',
        'Add private key' => 'Adicionar chave privada',
        'Filter for certificates' => '',
        'Filter for SMIME certs' => '',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Ver também',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Aqui pode editar directamente os certificados e chaves privadas presentes no sistema de ficheiros.',
        'Hash' => '',
        'Create' => 'Criar',
        'Handle related certificates' => '',
        'Delete this certificate' => 'Apagar este certificado',
        'Add Certificate' => 'Adicionar Certificado',
        'Add Private Key' => 'Adicionar Chave Privada',
        'Secret' => 'Segredo',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => '',
        'Relate this certificate' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Gestão de Saudações',
        'Add salutation' => 'Adicionar saudação',
        'Add Salutation' => 'Adicionar Apresentação',
        'Edit Salutation' => 'Editar saudação',
        'Example salutation' => 'Exemplo de saudação',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            '',
        'Start scheduler' => '',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            '',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'O modo seguro necessita de estar ativo',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'O modo seguro vai estar ativo após a instalação inicial estar completa',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'O modo seguro necessita de estar inativo para re-instalar via browser',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '',

        # Template: AdminSelectBox
        'SQL Box' => 'Comandos SQL',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Pode introduzir comandos SQL para executar diretamente na base de dados',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'O comando SQL contém erros. Corija por favor',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Há pelo menos um parametro em falta. Corrija por favor',
        'Result format' => 'Formato do resultado',
        'Run Query' => 'Executar query',

        # Template: AdminService
        'Service Management' => 'Gestão de serviço',
        'Add service' => 'Adicionar serviço',
        'Add Service' => 'Adicionar Serviço',
        'Edit Service' => 'Editar serviço',
        'Sub-service of' => 'Sub-serviço de ',

        # Template: AdminSession
        'Session Management' => 'Gestão de Sessões',
        'All sessions' => 'Todas as sessões',
        'Agent sessions' => 'Sessões de agente',
        'Customer sessions' => 'Sessões de cliente',
        'Unique agents' => 'Agentes únicos',
        'Unique customers' => 'Clientes únicos',
        'Kill all sessions' => 'Terminar todas as sessões',
        'Kill this session' => 'Terminar esta sessão',
        'Session' => 'Sessão',
        'Kill' => 'Terminar',
        'Detail View for SessionID' => 'Vista de detalhe da sessão',

        # Template: AdminSignature
        'Signature Management' => 'Gestão de Assinaturas',
        'Add signature' => 'Adicionar assinatura',
        'Add Signature' => 'Adicionar assinatura',
        'Edit Signature' => 'Editar assinatura',
        'Example signature' => 'Assinatura de exemplo',

        # Template: AdminState
        'State Management' => 'Gestão de estado',
        'Add state' => 'Adicionar estado',
        'Please also update the states in SysConfig where needed.' => '',
        'Add State' => 'Adicionar estado',
        'Edit State' => 'Editar estado',
        'State type' => 'Tipo de estado',

        # Template: AdminSysConfig
        'SysConfig' => 'Configuração de Sistema',
        'Navigate by searching in %s settings' => 'Navegar por pesquisa nas definições %s',
        'Navigate by selecting config groups' => 'Navegar por selecção de grupos de configurações',
        'Download all system config changes' => 'Decarregar todas as alterações realizadas à configuração',
        'Export settings' => 'Exportar definições',
        'Load SysConfig settings from file' => 'Carregar as definições de ficheiro',
        'Import settings' => 'Importar definições',
        'Import Settings' => 'Importar Definições',
        'Please enter a search term to look for settings.' => 'Por favor introduza uma expressão de pesquisa',
        'Subgroup' => 'Subgrupo',
        'Elements' => 'Elementos',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Editar definições de configuração',
        'This config item is only available in a higher config level!' =>
            'Este item de configuração apenas está disponível num nível de acesso mais elevado',
        'Reset this setting' => 'Reiniciar esta definição',
        'Error: this file could not be found.' => 'Erro: ficheiro não encontrado',
        'Error: this directory could not be found.' => 'Erro: pasta não encontrada',
        'Error: an invalid value was entered.' => 'Erro: valor introduzido é inválido',
        'Content' => 'Conteúdo',
        'Remove this entry' => 'Apagar esta entrada',
        'Add entry' => 'Adicionar entrada',
        'Remove entry' => 'Apagar entrada',
        'Add new entry' => 'Adicionar nova entrada',
        'Create new entry' => 'Criar nova entrada',
        'New group' => 'Novo grupo',
        'Group ro' => 'Grupo RO',
        'Readonly group' => 'Grupo de leitura',
        'New group ro' => 'Novo grupo ro',
        'Loader' => '',
        'File to load for this frontend module' => 'Ficheiro a carregar para o módulo de frontend',
        'New Loader File' => 'Novo ficheiro de inicialização',
        'NavBarName' => '',
        'NavBar' => '',
        'LinkOption' => '',
        'Block' => 'Bloquear',
        'AccessKey' => 'Tecla de acesso',
        'Add NavBar entry' => 'Adicionar entrada a NavBar',
        'Year' => 'Ano',
        'Month' => 'Mês',
        'Day' => 'Dia',
        'Invalid year' => 'Ano inválido',
        'Invalid month' => 'Mês inválido',
        'Invalid day' => 'Dia inválido',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Gestão dos Endereços de email do Sistema',
        'Add system address' => 'Adicionar email de sistema',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Todos os emails recebidos para este endereço em To ou CC são enviados para a fila selecionada',
        'Email address' => 'Endereço email',
        'Display name' => 'Nome',
        'Add System Email Address' => 'Adicionar email de sistema',
        'Edit System Email Address' => 'Editar email de sistema',
        'The display name and email address will be shown on mail you send.' =>
            'O nome e endereço email serão mostrados nas mensagens que enviar',

        # Template: AdminType
        'Type Management' => 'Gestão de tipos',
        'Add ticket type' => 'Adicionar tipo de ticket',
        'Add Type' => 'Adicionar tipo',
        'Edit Type' => 'Editar tipo',

        # Template: AdminUser
        'Add agent' => 'Adicionar agente',
        'Agents will be needed to handle tickets.' => 'São necessários agentes para tratar os tickets',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Não esquecer de adicionar um novo agente aos gruupos/papéis',
        'Please enter a search term to look for agents.' => 'Introduza um termo para pesquisar agentes ',
        'Last login' => 'Último acesso',
        'Login as' => 'Entrar como',
        'Switch to agent' => 'Alterar para agente',
        'Add Agent' => 'Adicionar agente',
        'Edit Agent' => 'Editar agente',
        'Firstname' => 'Nome',
        'Lastname' => 'Apelido',
        'Password is required.' => 'Password obrigatória',
        'Start' => 'Início',
        'End' => 'Fim',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gerir relações Agente-grupo',
        'Change Group Relations for Agent' => 'Gerir relações de grupo com o agente',
        'Change Agent Relations for Group' => 'Gerir relações de agente com o grupo',
        'note' => 'nota',
        'Permissions to add notes to tickets in this group/queue.' => 'Permissões para adicionar notas a tickets neste grupo/fila',
        'owner' => 'proprietário',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permissões para alterar o proprietário do ticket neste grupo/fila',

        # Template: AgentBook
        'Address Book' => 'Lista de Endereços',
        'Search for a customer' => 'Pesquisar cliente',
        'Add email address %s to the To field' => 'Adicionar o email %s ao campo TO',
        'Add email address %s to the Cc field' => 'Adicionar o email %s ao campo CC',
        'Add email address %s to the Bcc field' => 'Adicionar o email %s ao campo BCC',
        'Apply' => 'Aplicar',

        # Template: AgentCustomerSearch
        'Search Customer' => 'Procurar Cliente',
        'Duplicated entry' => '',
        'This address already exists on the address list.' => '',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => '',

        # Template: AgentDashboardCalendarOverview
        'in' => 'em',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s está disponível!',
        'Please update now.' => 'Por favor atualize o sistema',
        'Release Note' => 'Notas de versão',
        'Level' => 'Nível',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Publicado há %s',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => '',
        'My watched tickets' => '',
        'My responsibilities' => '',
        'Tickets in My Queues' => '',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Ticket bloqueado',
        'Undo & close window' => 'Cancelar alterações e fechar janela',

        # Template: AgentInfo
        'Info' => 'Informação',
        'To accept some news, a license or some changes.' => 'Para aceitar Novidades, licença ou alterações',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Ligar objeto: %s',
        'Close window' => 'Fechar janela',
        'go to link delete screen' => 'Ir para ecrã de apagar ligação',
        'Select Target Object' => 'Selecionar o Objeto de destino',
        'Link Object' => 'Ligar Objeto',
        'with' => 'com',
        'Unlink Object: %s' => 'Quebrar ligação %s',
        'go to link add screen' => 'Ir para a ecrã de adicionar link',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Editar preferências',

        # Template: AgentSpelling
        'Spell Checker' => 'Corretor Ortográfico',
        'spelling error(s)' => 'erro(s) ortográfico(s)',
        'Apply these changes' => 'Aplicar modificações',

        # Template: AgentStatsDelete
        'Delete stat' => 'Apagar estatística',
        'Stat#' => 'Stat#',
        'Do you really want to delete this stat?' => 'Deseja apagar esta estatística?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Passo %s',
        'General Specifications' => 'Especificações gerais',
        'Select the element that will be used at the X-axis' => 'Selecione o elemento que será utilizado no eixo X',
        'Select the elements for the value series' => 'Selecione os elementos para a série de valores',
        'Select the restrictions to characterize the stat' => 'Selecione as restrições para a estatística',
        'Here you can make restrictions to your stat.' => 'Aqui pode fazer restrições para a estatistica',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Se remover a selecção de "fixo", o agente ao utilizar a estatistica pode mudar os atributos do atributo correspondente',
        'Fixed' => 'Fixo',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Selecione apenas um elemento ou desligue a opção "fixo"',
        'Absolute Period' => 'Período absoluto',
        'Between' => 'Entre',
        'Relative Period' => 'Periodo relativo',
        'The last' => 'O último',
        'Finish' => 'Fim',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Permissões',
        'You can select one or more groups to define access for different agents.' =>
            'Pode selecionar um ou mais grupos para definir o acesso a diferentes agentes',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Há formatos de resultados inativos, devido à falta de um ou mais pacotes.',
        'Please contact your administrator.' => 'Por favor contate o administrador',
        'Graph size' => 'Tamanho do gráfico',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Se utilizar um gráfico como um formato de output, terá de selecionar pelo menos um tamanho de gráfico',
        'Sum rows' => 'Mostrar linhas',
        'Sum columns' => 'Mostrar colunas',
        'Use cache' => 'Utilizar cache',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'Maioria das estatisticas podem ser guardadas em chache. Isto irá aumentar a rapidez da apresentação da estatística',
        'If set to invalid end users can not generate the stat.' => 'Se for colocada como inválida, os utilizadores não pode poderão gerar estatísticas',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'aqui pode definir a série de valores',
        'You have the possibility to select one or two elements.' => 'Existe a possibilAntiguidade de selecionar um ou mais elementos',
        'Then you can select the attributes of elements.' => 'Depois pode selecionar os atributos do elemento',
        'Each attribute will be shown as single value series.' => 'Cada atributo será mostrado numa série individualizada',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Se não selecionar nenhum atributo do elemento, todos serão utilizados na geração de estatísticas, bem como novos atributos que tenham sido adicionados desde a última configuração.',
        'Scale' => 'Escala',
        'minimal' => 'Minima',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'O valor da escala tem de ser superior ao valor máximo para o eixo dos X',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Aqui pode definir o eixo X. Pode apenas selecionar um elemento',
        'maximal period' => 'Período mínimo',
        'minimal scale' => 'Escala mínima',

        # Template: AgentStatsImport
        'Import Stat' => 'Importar estatística',
        'File is not a Stats config' => 'Ficheiro nao é uma configuração de estatística',
        'No File selected' => 'Sem ficheiro selecionado',

        # Template: AgentStatsOverview
        'Stats' => 'Estatísticas',

        # Template: AgentStatsPrint
        'Print' => 'Imprimir',
        'No Element selected.' => 'Sem elemento selecionado',

        # Template: AgentStatsView
        'Export config' => 'Exportar configuração',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Com as opções realizadas pode influenciar o formato e os conteúdos da estatística',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Os campos e formatos podem influenciar as estatísticas são definidos pelo administrador',
        'Stat Details' => 'Detalhes da estatística',
        'Format' => 'Formato',
        'Graphsize' => 'Tamanho do gráfico',
        'Cache' => '',
        'Exchange Axis' => 'Troca de eixos',
        'Configurable params of static stat' => 'Parâmetros configuráveis de estatisticas estatísticas',
        'No element selected.' => 'Sem elemento selecionado',
        'maximal period from' => 'Período maximo periodo desde',
        'to' => 'para',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Alterar os campos de texto livre do ticket',
        'Change Owner of Ticket' => 'Alterar o proprietário do ticket',
        'Close Ticket' => 'Fechar ticket',
        'Add Note to Ticket' => 'Adcionar a nota do ticket',
        'Set Pending' => 'Definir como pendente',
        'Change Priority of Ticket' => 'Alterar a Prioridade do ticket',
        'Change Responsible of Ticket' => 'Alterar o responsável do ticket',
        'Cancel & close window' => 'Cancelar e fechar a janela',
        'Service invalid.' => 'Serviço inválido',
        'New Owner' => 'Novo Proprietário',
        'Please set a new owner!' => 'Por favor, defina o novo proprietário',
        'Previous Owner' => 'Proprietário anterior',
        'Inform Agent' => 'Informar agente',
        'Optional' => 'Opcional',
        'Inform involved Agents' => 'Informar agentes envolvidos',
        'Spell check' => 'Corretor ortográfico',
        'Note type' => 'Tipo de nota',
        'Next state' => 'Próximo estado',
        'Pending date' => 'Data da pendência',
        'Date invalid!' => 'Data inválida',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => '',
        'Bounce to' => 'Devolver para',
        'You need a email address.' => 'Necessita de um endereço de email',
        'Need a valid email address or don\'t use a local email address.' =>
            'Necessita de um endereço de email válido, não utilize endereços de email locais',
        'Next ticket state' => 'Próximo estado do ticket',
        'Inform sender' => 'Informar o remetente',
        'Send mail!' => 'Enviar mensagem de email !',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ação em bloco sobre tickets',
        'Send Email' => '',
        'Merge to' => 'Ligar a',
        'Invalid ticket identifier!' => 'Identificador de ticket inválido',
        'Merge to oldest' => 'Fundir com o mais antigo',
        'Link together' => 'Ligar tickets',
        'Link to parent' => 'Ligar ao pai',
        'Unlock tickets' => 'Desbloquear ticket',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Escrever uma resposta para o ticket',
        'Remove Ticket Customer' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Please include at least one recipient' => '',
        'Remove Cc' => '',
        'Remove Bcc' => '',
        'Address book' => 'Lista de endereços',
        'Pending Date' => 'Prazo de pendência',
        'for pending* states' => 'para os estados "pendentes ..."',
        'Date Invalid!' => 'Data inválida',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Modificar o cliente do ticket',
        'Customer Data' => 'Dados do Cliente',
        'Customer user' => 'Utilizador do cliente',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Criar novo ticket',
        'From queue' => 'Da fila',
        'To customer' => '',
        'Please include at least one customer for the ticket.' => '',
        'Get all' => 'Obter todos',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => '',
        'Need a valid email address or don\'t use a local email address' =>
            'Necessita de um endereço de email válido, não utilize endereços de email locais',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Histórico de',
        'History Content' => 'Histórico do conteúdo',
        'Zoom view' => 'Vista de detalhe',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Fundir Ticket',
        'You need to use a ticket number!' => 'Necessita de um número de ticket!',
        'A valid ticket number is required.' => 'é ncessário um número de ticket válido',
        'Need a valid email address.' => 'Necessita de um email válido',

        # Template: AgentTicketMove
        'Move Ticket' => 'Mover Ticket',
        'New Queue' => 'Nova Fila',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Selecionar tudo',
        'No ticket data found.' => 'Não foram encontrados dados do ticket',
        'First Response Time' => 'Tempo da primeira resposta',
        'Service Time' => 'Tempo de serviço',
        'Update Time' => 'Tempo de actualização',
        'Solution Time' => 'Tempo de solução',
        'Move ticket to a different queue' => 'Mover ticket para uma fila diferente',
        'Change queue' => 'Modificar a fila',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Alterar opções de pesquisa',
        'Tickets per page' => 'Tickets por página',

        # Template: AgentTicketOverviewPreview
        '","26' => '',

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'Escalado em',
        'Locked' => 'Bloqueado',
        '","30' => '',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Criar novo ticket por telefone',
        'From customer' => 'Do cliente',
        'To queue' => 'Para a fila',

        # Template: AgentTicketPhoneCommon
        'Phone call' => 'Chamada telefónica',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Email em texto simples',
        'Plain' => 'texto simples',
        'Download this email' => 'Descarregar este email',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Informação de Ticket',
        'Accounted time' => 'Tempo contabilizado',
        'Linked-Object' => 'Objeto-Ligado',
        'by' => 'por',

        # Template: AgentTicketPriority

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Modelo de pesquisa',
        'Create Template' => 'Criar template',
        'Create New' => 'Criar novo',
        'Profile link' => '',
        'Save changes in template' => 'Guardar alterações ao template',
        'Add another attribute' => 'Adicionar outro atributo',
        'Output' => 'Formato do resultado',
        'Fulltext' => 'Texto integral',
        'Remove' => 'Apagar',
        'Customer User Login' => 'Nome de utilizador de cliente',
        'Created in Queue' => 'Criado na Fila',
        'Lock state' => 'Estado de bloqueio',
        'Watcher' => 'Observador',
        'Article Create Time (before/after)' => 'Data criação do artigo (antes/depois)',
        'Article Create Time (between)' => 'Data criação artigo (entre)',
        'Ticket Create Time (before/after)' => 'Data criação do ticket (antes/depois)',
        'Ticket Create Time (between)' => 'Data criação do ticket (entre)',
        'Ticket Change Time (before/after)' => 'Data alteração do ticket (antes/depois)',
        'Ticket Change Time (between)' => 'Data alteração do ticket (entre)',
        'Ticket Close Time (before/after)' => 'Data fecho do ticket (antes/depois)',
        'Ticket Close Time (between)' => 'Data alteração do ticket (entre)',
        'Archive Search' => 'Guardar pesquisa',
        'Run search' => '',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Filtro de artigos',
        'Article Type' => 'Tipo de artigo',
        'Sender Type' => 'Tipo de remetente',
        'Save filter settings as default' => 'Guardar definições do filtro como padrão',
        'Ticket Information' => 'Informação do ticket',
        'Linked Objects' => 'Objetos ligados',
        'Article(s)' => 'Artigo(s)',
        'Change Queue' => 'Mudar fila',
        'Article Filter' => 'Filtro de artigo',
        'Add Filter' => 'Adicionar filtro',
        'Set' => 'Define',
        'Reset Filter' => 'Reiniciar filtro',
        'Show one article' => 'Mostrar um artigo',
        'Show all articles' => 'Mostrar todos os artigos',
        'Unread articles' => 'Artigos por ler',
        'No.' => '',
        'Unread Article!' => 'Artigo não lido!',
        'Incoming message' => 'Mensagem de entrada',
        'Outgoing message' => 'Mensagem de saída',
        'Internal message' => 'Mensagem interna',
        'Resize' => 'Redimensionar',

        # Template: AttachmentBlocker
        'To protect your privacy, active or/and remote content has blocked.' =>
            'para proteger a privacAntiguidade, conteúdo ativo e/ou remoto foi bloqueado',
        'Load blocked content.' => 'Carregar conteúdo bloqueado',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Retroceder',

        # Template: CustomerFooter
        'Powered by' => 'Produzido por',
        'One or more errors occurred!' => 'Ocorreu um ou mais erros',
        'Close this dialog' => 'Fechar esta janela',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Não foi possível abrir uma nova janela. Desabilite programas que bloqueiam popups para esta aplicação',

        # Template: CustomerHeader

        # Template: CustomerLogin
        'Login' => 'Autenticação',
        'User name' => 'Cód. utilizador',
        'Your user name' => 'O seu cód. utilizador',
        'Your password' => 'A sua password',
        'Forgot password?' => 'Esqueceu a password?',
        'Log In' => 'Login',
        'Not yet registered?' => 'Ainda não está registado(a)?',
        'Sign up now' => 'Registar-se agora',
        'Request new password' => 'Solicitar nova palavra-passe',
        'Your User Name' => 'O seu cód. utilizador',
        'A new password will be sent to your email address.' => 'A nova password será enviada para o seu email.',
        'Create Account' => 'Criar conta',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => 'Como deseja ser tratado',
        'Your First Name' => 'O seu nome',
        'Please supply a first name' => 'Por favor introduza o seu nome',
        'Your Last Name' => 'O seu apelido',
        'Please supply a last name' => 'Por favor introduza o seu apelido',
        'Your email address (this will become your username)' => '',
        'Please supply a' => 'Por favor introduza ',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Preferências pessoais',
        'Logout %s' => '',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'SLA',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Bem vindo!',
        'Please click the button below to create your first ticket.' => 'Clique no botão abaixo para criar o seu primeiro ticket',
        'Create your first ticket' => 'Criar o seu primeiro ticket',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Imprimir ticket',

        # Template: CustomerTicketSearch
        'Profile' => 'Perfil',
        'e. g. 10*5155 or 105658*' => '',
        'Customer ID' => 'No. Cliente',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Pesquisa no texto integral do ticket (ex. "John*n" ou "Will*")',
        'Recipient' => 'Destinatário',
        'Carbon Copy' => 'CC',
        'Time restrictions' => 'Restrição horária',
        'No time settings' => '',
        'Only tickets created' => 'Apenas tickets criados',
        'Only tickets created between' => 'Apenas tickets criados entre',
        'Ticket archive system' => '',
        'Save search as template?' => '',
        'Save as Template?' => 'Guardar como modelo',
        'Save as Template' => '',
        'Template Name' => 'Nome do modelo',
        'Pick a profile name' => '',
        'Output to' => 'Tipo de resultado',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Page' => 'Página',
        'Search Results for' => 'Pesquisar resultados para',
        '","18' => '',

        # Template: CustomerTicketZoom
        'Expand article' => 'Expandir artigo',
        'Reply' => 'Responder',

        # Template: CustomerWarning

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Data inválida (escolha uma data futura)!',
        'Previous' => 'Anterior',
        'Sunday' => 'Domingo',
        'Monday' => 'Segunda',
        'Tuesday' => 'Terça',
        'Wednesday' => 'Quarta',
        'Thursday' => 'Quinta',
        'Friday' => 'Sexta',
        'Saturday' => 'Sábado',
        'Su' => 'Dom',
        'Mo' => 'Seg',
        'Tu' => 'Ter',
        'We' => 'Qua',
        'Th' => 'Qui',
        'Fr' => 'Sex',
        'Sa' => 'Sáb',
        'Open date selection' => 'Data aberta',

        # Template: Error
        'Oops! An Error occurred.' => 'Ocorreu um erro.',
        'Error Message' => 'Mensagem de erro',
        'You can' => 'Pode ',
        'Send a bugreport' => 'Enviar um relatório de erro',
        'go back to the previous page' => 'Voltar à página anterior',
        'Error Details' => 'Detalhes do erro',

        # Template: Footer
        'Top of page' => 'Topo da página',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Se abandonar esta página, todas as janelas popup abertas serão fechadas',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Já existe uma janela popup aberta. Deseja fecha-la e abrir uma nova ?',
        'Please enter at least one search value or * to find anything.' =>
            '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'You are logged in as' => 'Autenticado como ',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'Javascript não disponível',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Para utilizar o OTRS, necessita de ativar javascript no browser',
        'Database Settings' => 'Definições de base de dados',
        'General Specifications and Mail Settings' => 'Especificações comuns e definições de email',
        'Registration' => '',
        'Welcome to %s' => 'Bem vindo a %s',
        'Web site' => 'Site',
        'Database check successful.' => 'Verificação de base de dados com sucesso',
        'Mail check successful.' => 'Verificação de email com sucesso',
        'Error in the mail settings. Please correct and try again.' => 'Erro nas definições de email. Corrija e tente novamente',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Servidor de email de saída',
        'Outbound mail type' => 'Tipo de servidor de saída',
        'Select outbound mail type.' => 'Selecione o tipo de servidor',
        'Outbound mail port' => 'Porto de email do servidor de saída',
        'Select outbound mail port.' => 'Selecione o porto do servidor de saída',
        'SMTP host' => 'Servidor SMTP',
        'SMTP host.' => 'Servidor SMTP.',
        'SMTP authentication' => 'Autenticação SMTP',
        'Does your SMTP host need authentication?' => 'O servidor SMTP requere autenticação?',
        'SMTP auth user' => 'Utilizador SMTP',
        'Username for SMTP auth.' => 'Utilizador para autenticação SMTP',
        'SMTP auth password' => 'Password de autenticação SMTP',
        'Password for SMTP auth.' => 'Password de autenticação SMTP',
        'Configure Inbound Mail' => 'Configuração recepção de email',
        'Inbound mail type' => 'Tipo de servidor de correio de chegada',
        'Select inbound mail type.' => 'Selecione o tipo de servidor de correio de chegada',
        'Inbound mail host' => 'Servidor de recepção de email',
        'Inbound mail host.' => 'Servidor de recepção de email.',
        'Inbound mail user' => 'Utilizador de recepção de email',
        'User for inbound mail.' => 'Utilizador de recepção de email',
        'Inbound mail password' => 'Password para recepção de email',
        'Password for inbound mail.' => 'Password para recepção de email',
        'Result of mail configuration check' => 'Resultado da verificação de recepção de email',
        'Check mail configuration' => 'Verifique a configuração de correio',
        'Skip this step' => 'Saltar esta etapa',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            '',

        # Template: InstallerDBResult
        'False' => 'Falso',

        # Template: InstallerDBStart
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Se selecionou a password de root para a base de dados, introduza-a aqui. Senão, deixe este campo em branco. Por razões de segurança recomendamos definir a password de root. Para mais informações consulte a documentação da base de dados.',
        'Currently only MySQL is supported in the web installer.' => 'Atualmente, apenas Mysql é suportado no instalador web.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Se quiser instalar o OTRS com outro motor de base de dados, consulte o ficheiro README.database',
        'Database-User' => 'Utilizador da Base de Dados',
        'New' => 'Novo',
        'A new database user with limited rights will be created for this OTRS system.' =>
            'Vai ser criado um novo utilizador de base de dados com permissões limitadas para o OTRS',
        'default \'hot\'' => 'por omissão \'hot\'',
        'DB--- host' => 'Servidor de BD',
        'Check database settings' => 'Verificar definições de base de dados',
        'Result of database check' => 'Resultado da verificação à base de dados',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Para usar o OTRS tem de executar o comando na consola, como administrador.',
        'Restart your webserver' => 'Reinicie o servidor Web',
        'After doing so your OTRS is up and running.' => 'Depois de o fazer, o OTRS estará funcional.',
        'Start page' => 'Página inicial',
        'Your OTRS Team' => 'A equipa OTRS',

        # Template: InstallerLicense
        'Accept license' => 'Aceitar licença',
        'Don\'t accept license' => 'Nao aceitar licença',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Organização',
        'Position' => '',
        'Complete registration and continue' => '',
        'Please fill in all fields marked as mandatory.' => '',

        # Template: InstallerSystem
        'SystemID' => 'ID do sistema',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Identificador do sistema. Todos os tivkets e sessões HTTP possuem este número',
        'System FQDN' => 'FQDN do sistema',
        'Fully qualified domain name of your system.' => 'FQDN do sistema',
        'AdminEmail' => 'Email do Administrador',
        'Email address of the system administrator.' => 'Email do administrador de sistema',
        'Log' => 'Log',
        'LogModule' => 'Módulo de Log',
        'Log backend to use.' => 'Módulo de log',
        'LogFile' => 'Ficheiro de log',
        'Log file location is only needed for File-LogModule!' => 'A localização do ficheiro é necessário com File-LogModule',
        'Webfrontend' => 'Interface Web',
        'Default language' => 'Idioma por omissão',
        'Default language.' => 'Idioma por omissão.',
        'CheckMXRecord' => 'Verificar registo MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Endereços de email introduzidos manualmente são verificados com o registo MX no DNS. Não utilize esta opção se o seu servidor DNS é lento ou não resolve endereços públicos.',

        # Template: LinkObject
        'Object#' => 'Objeto#',
        'Add links' => 'Adicionar ligações',
        'Delete links' => 'Apagar ligações',

        # Template: Login
        'JavaScript Not Available' => 'Javascript não disponível',
        'Browser Warning' => 'Aviso de browser',
        'The browser you are using is too old.' => 'O browser que está a usar está muito desatualizado',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'O OTRS corre numa lista de browsers grande, por favor atualize para um deles.',
        'Please see the documentation or ask your admin for further information.' =>
            'Consulte a informação por favor ou peça mais informação ao administrador de sistema',
        'Lost your password?' => 'Esqueceu a palavra-passe?',
        'Request New Password' => 'Recuperar password',
        'Back to login' => 'Voltar ao login',

        # Template: Motd
        'Message of the Day' => 'Mensagem do dia',

        # Template: NoPermission
        'Insufficient Rights' => 'Permissões insuficientes',
        'Back to the previous page' => 'Voltar à página anterior',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'Mostrar a primeira página',
        'Show previous pages' => 'Mostrar páginas anteriores',
        'Show page %s' => 'Mostrar a %s página ',
        'Show next pages' => 'Mostrar as próximas páginas',
        'Show last page' => 'Mostrar a última página',

        # Template: PictureUpload
        'Need FormID!' => 'Form ID necessário',
        'No file found!' => 'não foi encontrado o ficheiro',
        'The file is not an image that can be shown inline!' => 'O ficheiro não é uma imagem que pode ser visualizada',

        # Template: PrintFooter
        'URL' => '',

        # Template: PrintHeader
        'printed by' => 'impresso por',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'Página de Teste do OTRS',
        'Welcome %s' => 'Bem-vindo, %s',
        'Counter' => 'Contador',

        # Template: Warning
        'Go back to the previous page' => 'Voltar à página anterior',

        # SysConfig
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Módulo ACL que permite o fecho de tickets apenas se todos os tickets filhos estiverem fechados("Estado" mostra os estados não disponíveis ao pai até que todos os filhos estejam fechados).',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            '',
        'Activates lost password feature for agents, in the agent interface.' =>
            '',
        'Activates lost password feature for customers.' => '',
        'Activates support for customer groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            '',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            '',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            '',
        'Activates time accounting.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Adiciona um sufixo com o ano e mês atual ao ficheiro de log do OTRS. Vai ser criado um ficheiro mensal.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            'Adiciona emails do cliente aos remetentes na criação de ticket no interface de agente.',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias permanente. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Agent Notifications' => 'Notificações de agente',
        'Agent interface article notification module to check PGP.' => 'Módulo de notificações no interface de agente para verificar PGP',
        'Agent interface article notification module to check S/MIME.' =>
            'Módulo de notificações no interface de agente para verificar S/MIME',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Módulo de notificações no interface de agente para pesquisa de texto integral',
        'Agent interface module to access search profiles via nav bar.' =>
            'Módulo de notificações no interface de agente para pesquisar perfis',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Módulo de notificações no interface de agente para verificar a recepção de emails na vista de detalhe se a chave S/MIME estiver ativa.',
        'Agent interface notification module to check the used charset.' =>
            'Módulo de notificações no interface de agente para verificar o código de página',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Módulo de notificações no interface de agente para visualizar o nº de tickets por que é responsável',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Módulo de notificações no interface de agente para visualizar o nº de tickets vigiados',
        'Agents <-> Groups' => 'Agentes<->Grupos',
        'Agents <-> Roles' => 'Agentes<->Papéis',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            'Permite adicionar notas no ecrã de fecho de tickets no interface de agente',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            'Permite adicionar notas no ecrã de campos de texto livre de tickets no interface de agente',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            'Permite adicionar notas no ecrã de notas de tickets no interface de agente',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Permite adicionar notas no ecrã de proprietário de tickets no interface de agente',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Permite adicionar notas no ecrã de pendentes de tickets no interface de agente',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Permite adicionar notas no ecrã de Prioridade de tickets no interface de agente',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            'Permite adicionar notas no ecrã de proprietário de tickets no interface de agente',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Permite aos agentes trocar os eixos da estatística na geração',
        'Allows agents to generate individual-related stats.' => 'Permite aos agentes a geração de estatísticas individuais',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Permite escolher entre mostrar o conteúdo dos anexos ou apenas descarregar',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Permite escolher o próximo estado de criação de tickets no interface de cliente',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Permite aos clientes alterar a Prioridade do ticket no interface web',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Permite aos clientes definir o SLA do ticket no interface web',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Permite aos clientes definir a Prioridade do ticket no interface web',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Permite aos clientes definir a fila do ticket no interface web. Se for \'Não\'. A fila por omissão deve ser configurada ',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Permite aos clientes definir o serviço do ticket no interface web',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Permite definir novos tipos de tickets (se a funcionalAntiguidade de tipo de ticket estiver ativa).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permite definir serviços e SLAs para os tickets(ex. email, desktop, network, ...), e atributos de escalagem para os SLAs(caso a funcionalAntiguidade service/SLA esteja ativa).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite condições de pesquisa de tickets aumentadas no interface de agente . Com esta funcionalAntiguidade pode pesquisar com por ex. "(key1&&key2)" or "(key1||key2)".',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite condições de pesquisa de tickets aumentadas no interface de cliente . Com esta funcionalAntiguidade pode pesquisar com por ex. "(key1&&key2)" or "(key1||key2)".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite ter vista em formato médio do ticket (CustomerInfo=>1 - mostra informação de cliente).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'shows also the customer information).',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'Attachments <-> Responses' => '',
        'Auto Responses <-> Queues' => '',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas.' => '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Builds an article index right after the article\'s creation.' =>
            '',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => '',
        'Change queue!' => '',
        'Change the customer for this ticket' => '',
        'Change the free fields for this ticket' => '',
        'Change the priority for this ticket' => '',
        'Change the responsible person for this ticket' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Closed tickets of customer' => '',
        'Comment for new history entries in the customer interface.' => '',
        'Companies' => '',
        'Company Tickets' => '',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Configures the full-text index. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create and manage Service Level Agreements (SLAs).' => '',
        'Create and manage agents.' => '',
        'Create and manage attachments.' => '',
        'Create and manage companies.' => '',
        'Create and manage customers.' => '',
        'Create and manage dynamic fields.' => '',
        'Create and manage event based notifications.' => '',
        'Create and manage groups.' => '',
        'Create and manage notifications that are sent to agents.' => '',
        'Create and manage queues.' => '',
        'Create and manage response templates.' => '',
        'Create and manage responses that are automatically sent.' => '',
        'Create and manage roles.' => '',
        'Create and manage salutations.' => '',
        'Create and manage services.' => '',
        'Create and manage signatures.' => '',
        'Create and manage ticket priorities.' => '',
        'Create and manage ticket states.' => '',
        'Create and manage ticket types.' => '',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => '',
        'Create new phone ticket (inbound)' => '',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customers <-> Groups' => '',
        'Customers <-> Services' => '',
        'DEPRECATED! This setting is not used any more and will be removed in a future version of OTRS.' =>
            '',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => '',
        'Default skin for OTRS 3.0 interface.' => '',
        'Default skin for interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define the start day of the week for the date picker.' => '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            '',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => '',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the URL CSS path.' => '',
        'Defines the URL base path of icons, CSS and Java Script.' => '',
        'Defines the URL image path of icons for navigation.' => '',
        'Defines the URL java script path.' => '',
        'Defines the URL rich text editor path.' => '',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for rejected emails.' => '',
        'Defines the boldness of the line drawed by the graph.' => '',
        'Defines the colors for the graphs.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of search results shown on the overview page.' =>
            '',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '',
        'Defines the default priority of new tickets.' => '',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default sender type of the article for this operation.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, DynamicField_Field1StartYear=2002;DynamicField_Field1StartMonth=12;DynamicField_Field1StartDay=12;DynamicField_Field1StartHour=00;DynamicField_Field1StartMinute=00;DynamicField_Field1StartSecond=00;DynamicField_Field1StopYear=2009;DynamicField_Field1StopMonth=02;DynamicField_Field1StopDay=10;DynamicField_Field1StopHour=23;DynamicField_Field1StopMinute=59;DynamicField_Field1StopSecond=59;.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view, after sort by priority is done.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default spell checker dictionary.' => '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => '',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default type for article in the customer interface.' =>
            '',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => '',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => '',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            '',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            '',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            '',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => '',
        'Defines the module to display a notification in the agent interface, (only for agents on the admin group) if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            '',
        'Defines the module to generate html refresh headers of html sites.' =>
            '',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            '',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            '',
        'Defines the name of the column to store the data in the preferences table.' =>
            '',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            '',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => '',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            '',
        'Defines the name of the table, where the customer preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            '',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the spacing of the legends.' => '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => '',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            '',
        'Defines the state of a ticket if it gets a follow-up.' => '',
        'Defines the state type of the reminder for pending tickets.' => '',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            '',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the subject for rejected emails.' => '',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            '',
        'Defines the system identifier. Every ticket number and http session string contain this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the type of protocol, used by ther web server, to serve the application. If https protocol will be used instead of plain http, it must be specified it here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width of the legend.' => '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Delay time between autocomplete queries in milliseconds.' => '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the search results container for the autocomplete feature should adjust its width dynamically.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return to search results, queueview, dashboard or the like, LastScreenView will return to TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box (to avoid the use of destructive queries, such as DROP DATABASE, and also to steal user passwords).' =>
            '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Dropdown' => '',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => '',
        'Dynamic Fields Overview Limit' => '',
        'Dynamic Fields Text Backend GUI' => '',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###AttributesView.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Email Addresses' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => '',
        'Enables customers to create their own accounts.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
        'Enables or disables the autocomplete feature for the customer search in the agent interface.' =>
            '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Escalation view' => '',
        'Event list to be displayed on GUI to trigger generic interface invokers.' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Example for free text' => '',
        'Execute SQL statements.' => '',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Experimental "Slim" skin which tries to save screen space for power users.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            '',
        'Filter incoming emails.' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Frontend language' => '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => '',
        'GenericAgent' => '',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => '',
        'GenericInterface Web Service GUI' => '',
        'GenericInterface Webservice History GUI' => '',
        'GenericInterface Webservice Mapping GUI' => '',
        'GenericInterface module registration for the invoker layer.' => '',
        'GenericInterface module registration for the mapping layer.' => '',
        'GenericInterface module registration for the operation layer.' =>
            '',
        'GenericInterface module registration for the transport layer.' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            '',
        'If "DB" was selected for SessionModule, a column for the identifiers in session table must be specified.' =>
            '',
        'If "DB" was selected for SessionModule, a column for the values in session table must be specified.' =>
            '',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            '',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            '',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            '',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the HTTP headers.' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            '',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => '',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Link agents to groups.' => '',
        'Link agents to roles.' => '',
        'Link attachments to responses templates.' => '',
        'Link customers to groups.' => '',
        'Link customers to services.' => '',
        'Link queues to auto responses.' => '',
        'Link responses to queues.' => '',
        'Link roles to groups.' => '',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE6-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE7-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of default StandardResponses which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => '',
        'Mail Accounts' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the picture transparent.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage PGP keys for email encryption.' => '',
        'Manage POP3 or IMAP accounts to fetch email from.' => '',
        'Manage S/MIME certificates for email encryption.' => '',
        'Manage existing sessions.' => '',
        'Manage periodic tasks.' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size of the subjects in an email reply.' => '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum size (in characters) of the customer info table in the queue view.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => '',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => '',
        'Module to check the group permissions for the access to customer tickets.' =>
            '',
        'Module to check the owner of a ticket.' => '',
        'Module to check the watcher agents of a ticket.' => '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to crypt composed messages (PGP or S/MIME).' => '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => '',
        'My Tickets' => '',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => '',
        'New phone ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => '',
        'Number of displayed tickets' => '',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => '',
        'Overview Refresh Time' => '',
        'Overview of all open Tickets.' => '',
        'PGP Key Management' => '',
        'PGP Key Upload' => '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => '',
        'Parameters of the example queue attribute Comment2.' => '',
        'Parameters of the example service attribute Comment2.' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            '',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Picture-Upload' => '',
        'PostMaster Filters' => '',
        'PostMaster Mail Accounts' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Queue view' => '',
        'Refresh Overviews after' => '',
        'Refresh interval' => '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '',
        'Responses <-> Queues' => '',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            '',
        'Roles <-> Groups' => '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Saves the login and password on the session table in the database, if "DB" was selected for SessionModule.' =>
            '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            '',
        'Send notifications to users.' => '',
        'Send ticket follow up notifications' => '',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Set sender email addresses for this system.' => '',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the default article type for new email tickets in the agent interface.' =>
            '',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '',
        'Sets the default priority for new email tickets in the agent interface.' =>
            '',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            '',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            '',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default text for new email tickets in the agent interface.' =>
            '',
        'Sets the display order of the different items in the preferences view.' =>
            '',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minimum number of characters before autocomplete query is sent.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the number of search results to be displayed for the autocomplete feature.' =>
            '',
        'Sets the options for PGP binary.' => '',
        'Sets the order of the different items in the customer preferences view.' =>
            '',
        'Sets the password for private PGP key.' => '',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the size of the statistic graph.' => '',
        'Sets the stats hook.' => '',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the time type which should be shown.' => '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to see a zoomed email ticket in plain text.' => '',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '',
        'Shows colors for different article types in the article table.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '',
        'Shows the customer user\'s info in the ticket zoom view.' => '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            '',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            '',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            '',
        'Skin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the background color of the chart.' => '',
        'Specifies the background color of the picture.' => '',
        'Specifies the border color of the chart.' => '',
        'Specifies the border color of the legend.' => '',
        'Specifies the bottom margin of the chart.' => '',
        'Specifies the different article types that will be used in the system.' =>
            '',
        'Specifies the different note types that will be used in the system.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the left margin of the chart.' => '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            '',
        'Specifies the path of the file for the performance log.' => '',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            '',
        'Specifies the right margin of the chart.' => '',
        'Specifies the text color of the chart (e. g. caption).' => '',
        'Specifies the text color of the legend.' => '',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies the top margin of the chart.' => '',
        'Specifies user id of the postmaster data base.' => '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Statistics' => '',
        'Status view' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Textarea' => '',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => '',
        'Tickets' => '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Types' => '',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => '',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => '',
        'View system log messages.' => '',
        'Wear this frontend skin' => '',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your language' => '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            '',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        '' => 'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).',
        '%s Tickets afectados! Tem a certeza que pretende efectuar este trabalho?' =>
            '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)',
        '(A identAntiguidade do sistema. Cada número de ticket e cada id. da sessão http, inicia com este número)' =>
            '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')',
        '(Endereço de correio electrónico do administrador do sistema)' =>
            '(Full qualified domain name of your system)',
        '(Ficheiro de registo para File-LogModule)' => '(Note: It depends on your installation how many dynamic objects you can use)',
        '(Formato de número de ticket utilizado)' => 'A article should have a title!',
        '(Identificação do ticket. Algumas pessoas usam \'Ticket#\', \'Chamada#\' or \'MeuTicket#\')' =>
            '(Used default language)',
        '(Idioma por omissão utilizado)' => '(Used log backend)',
        '(Nome de domínio totalmente qualificado do seu sistema)' => '(Logfile just needed for File-LogModule!)',
        '(Usei o sistema de registos)' => '(Used ticket number format)',
        '(Verifica os registos MX dos endereços de correio electrónico usados quando compõe uma resposta. Não usar caso esteja a usar uma ligação telefónica!)' =>
            '(Email of the system admin)',
        'A Tarefa é Válida' => 'Is Job Valid?',
        'A Tarefa é Válida?' => 'It\'s useful for ASP solutions.',
        'A mensagem deve conter um assunto!' => 'A web calendar',
        'A mensagem deve conter um texto!' => 'A message should have a subject!',
        'A mensagem sendo composta foi fechada. Saindo.' => 'These values are read-only.',
        'A palavra-passe está já em uso! Por favor use outra!' => 'Password is already used! Please use an other password!',
        'A palavra-passe já foi usada! Por favor use outra!' => 'Passwords doesn\'t match! Please try it again!',
        'A response is default text to write faster answer (with default text) to customers.' =>
            'Uma resposta é um texto padrão para escrever respostas rápidas (com texto padrão) para clientes.',
        'ACL por omissão para as ações de tickets' => 'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".',
        'Acrescentado Utilizador "%s"' => 'Admin-Area',
        'Add a note to this ticket!' => 'Adicionar uma nota ao ticket!',
        'Adds the one time vacation days for the calendar number 1. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias ao calendário 1. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the one time vacation days for the calendar number 2. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias ao calendário 2. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the one time vacation days for the calendar number 3. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias ao calendário 3. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the one time vacation days for the calendar number 4. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias ao calendário 4. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the one time vacation days for the calendar number 5. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias ao calendário 5. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the one time vacation days for the calendar number 6. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias ao calendário 6. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the one time vacation days for the calendar number 7. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias ao calendário 7. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the one time vacation days for the calendar number 8. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias ao calendário 8. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the one time vacation days for the calendar number 9. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias ao calendário 9. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the permanent vacation days for the calendar number 1. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias permanente ao calendário 1. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the permanent vacation days for the calendar number 2. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias permanente ao calendário 2. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the permanent vacation days for the calendar number 3. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias permanente ao calendário 3. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the permanent vacation days for the calendar number 4. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias permanente ao calendário 4. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the permanent vacation days for the calendar number 5. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias permanente ao calendário 5. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the permanent vacation days for the calendar number 6. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias permanente ao calendário 6. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the permanent vacation days for the calendar number 7. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias permanente ao calendário 7. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the permanent vacation days for the calendar number 8. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias permanente ao calendário 8. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adds the permanent vacation days for the calendar number 9. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona um dia de férias permanente ao calendário 9. Utilize apenas um dígito para números entre 1 e 9 (em vez de 01-09)',
        'Adicionar endereço de sistema' => 'Add a new Customer Company.',
        'Adicionar nota ao ticket' => 'Added User "%s"',
        'Adicionar nova Apresentação' => 'Add a new Service.',
        'Adicionar nova assinatura' => 'Add a new State.',
        'Adicionar novo SLA' => 'Add a new Salutation.',
        'Adicionar novo endereço de sistema' => 'Add note to ticket',
        'Adicionar novo estado' => 'Add a new System Address.',
        'Adicionar novo papel' => 'Add a new SLA.',
        'Adicionar novo serviço' => 'Add a new Signature.',
        'Adicionar um novo Grupo.' => 'Add a new Role.',
        'Adicione Utilizador de Cliente' => 'Add System Address',
        'Adicione um novo Utilizador de Companhia' => 'Add a new Group.',
        'Agendamento' => 'Search Result',
        'Agente Genérico' => 'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.',
        'Altera o responsável de fila' => 'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.',
        'Altera o responsável de ticket a todos os agentes (útil em ASP). Apenas agentes com permisssões rw na fila vão ser mostrados' =>
            'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).',
        'Alterar Texto livre do ticket' => 'Change owner of ticket',
        'Alterar fila' => 'Change the ticket responsible!',
        'Alterar password' => 'Change queue!',
        'Anexo' => 'Attribute',
        'Anexos <-> Respostas' => 'Auto Responses <-> Queues',
        'Anfitrião para ligações à Base de Dados' => 'Default',
        'Apaga a sessão caso seja proveniente de um endereço IP inválido' =>
            'Deletes requested sessions if they have timed out.',
        'Apaga as sessões expiradas' => 'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.',
        'Apagar Base de Dados' => 'Edit Article',
        'Aqui pode inserir a descriçao da estatistica' => 'Here you can select the dynamic object you want to use.',
        'Aqui pode selecionar o Dynamic object que pretende usar ' => 'Home',
        'Artefacto' => 'ArticleID',
        'As palavras-passe não correspondem! Tente de novo!' => 'Pending Times',
        'Ativa a funcionalAntiguidade de operações em bloco apenas para os grupos selecionados' =>
            'Enables ticket responsible feature, to keep track of a specific ticket.',
        'Ativa a funcionalAntiguidade de operações em bloco no interface de agente para trabalhar em múltiplos tickets' =>
            'Enables ticket bulk action feature only for the listed groups.',
        'Ativa a funcionalAntiguidade de responsável, para acompanhar um ticket específico' =>
            'Enables ticket watcher feature only for the listed groups.',
        'Ativa a funcionalAntiguidade de vigilância de ticket apenas para grupos selecionados' =>
            'Escalation view',
        'Ativa a geração de PDFs. O módulo CPAN PDF::API2 é obrigatório, caso contrário estará inativo. ' =>
            'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.',
        'Ativa as notificações utilizadas na GUI. Se tiver problemas de performance pode desativar aqui.' =>
            'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.',
        'Ativa o log de performance (para medir os tempos de respontas). vai afetar o desempenho do sistema. Frontend::Module###AdminPerformanceLog tem de estar ativo' =>
            'Enables spell checker support.',
        'Ativa o suporte PGP. O PGP serve para assinar e proteger o email, é recomendável que o que o servidor web seja executado com o utilizador OTRS, caso contrário vão existir problemas de acesso à pasta .gnupg .' =>
            'Enables S/MIME support.',
        'Ativa o suporte para o corretor ortográfico' => 'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.',
        'Ativa ou desativa a funcionalAntiguidade de vigilância de ticket, para acompanhar tickets que não é proprietário nem responsável' =>
            'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.',
        'Ativa ou desativa o funcionalAntiguidade de autocomplete na pesquisa de clientes no interface de agente' =>
            'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.',
        'Ativa ou inativa o modo de debug no interface de frontend' => 'Enables or disables the autocomplete feature for the customer search in the agent interface.',
        'Ativa suporte S/MIME' => 'Enables customers to create their own accounts.',
        'Atribua o nome de utilizador e o ID do cliente do ticket' => 'Show',
        'Atributo' => 'Auto Response From',
        'Atualiza a flag de lido do ticket, se todos os artigos estiverem lidos ou se um novo artigo for criado' =>
            'Update and extend your system with software packages.',
        'Atualiza o acelerador de indice do tickets' => 'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.',
        'Atualiza o indice de tickets escalados após um atributo do ticket ser alterado' =>
            'Updates the ticket index accelerator.',
        'Atualizar' => 'Reminder',
        'Atualizar e estender o sistema com pacotes de software' => 'Updates the ticket escalation index after a ticket attribute got updated.',
        'Atualizar:' => 'Use utf-8 it your database supports it!',
        'Atualização em' => 'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.',
        'Atva a verificação de endereços ip remotos. Deve ser "Não" se a aplicação for utilizada via proxy.' =>
            'Types',
        'Auto respostas <-> Filas' => 'Automated line break in text messages after x number of chars.',
        'Automaticamente define o responsável do ticket (se ainda não estiver definido) após definir o primeiro proprietário' =>
            'Balanced white skin by Felix Niklas.',
        'Aviso! Estes tickets serão removidos da base de dados! Serão perdidos!' =>
            'Web-Installer',
        'Bem-vindo ao OTRS' => 'With an invalid stat it isn\'t feasible to generate a stat.',
        'Bloqueia a recepção de todos os emails que não têm um número de ticket válido no assunto provenientes de: @example.com' =>
            'Builds an article index right after the article\'s creation.',
        'Bloqueio de Ticket' => 'Ticket Number Generator',
        'Bounce Ticket: ' => 'Devolver ticket',
        'C' => 'Unable to parse Online Repository index document!',
        'Caixa de Entrada' => 'Match',
        'Caixa de Seleção' => 'Select Box Result',
        'Caixa do Correio do Agente' => 'Agent Preferences',
        'Caminho do ficheiro de log (Apenas se for escolhido "FS" em LoopProtectionModule)' =>
            'Path of the file that stores all the settings for the QueueObject object for the agent interface.',
        'Caminho do ficheiro que guarda as definições para o objeto QueueObject no interface de agente' =>
            'Path of the file that stores all the settings for the QueueObject object for the customer interface.',
        'Caminho do ficheiro que guarda as definições para o objeto QueueObject no interface de cliente' =>
            'Path of the file that stores all the settings for the TicketObject for the agent interface.',
        'Caminho do ficheiro que guarda as definições para o objeto TicketObject no interface de agente' =>
            'Path of the file that stores all the settings for the TicketObject for the customer interface.',
        'Caminho do ficheiro que guarda as definições para o objeto TicketObject no interface de cliente' =>
            'Permitted width for compose email windows.',
        'Campo Obrigatorio' => 'Response Management',
        'Carregamento de Certificado SMIME' => 'SMIME Management',
        'Carregamento de Chave PGP' => 'Parameters for the CreateNextMask object in the preference view of the agent interface.',
        'Carregamento de certificados S/MIME' => 'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.',
        'Carregar Configuração' => 'Logfile',
        'Certificado SMIME' => 'SMIME Certificate Upload',
        'Change the ticket customer!' => 'Mudar o cliente do ticket!',
        'Change the ticket owner!' => 'Mudar o proprietário do ticket!',
        'Change the ticket priority!' => 'Muda a Prioridade do ticket!',
        'Clear para' => 'Click here to report a bug!',
        'Clientes<->Grupos' => 'Customers <-> Services',
        'Clientes<->Serviços' => 'Data used to export the search result in CSV format.',
        'Clique aqui para reportar um erro!' => 'Close ticket',
        'Close this ticket!' => 'Fechar  ticket!',
        'Codificação por Omissão' => 'Default Language',
        'Com uma estatistica invalida é impossivel gerar uma estatistica' =>
            'Yes means, send no agent and customer notifications on changes.',
        'Comentar novas entradas no histórico do ticket no inteface de cliente' =>
            'Companies',
        'Comentário (interno)' => 'CompanyTickets',
        'Companhia' => 'Company Tickets',
        'Compor Mensagem de Correio Electrónico' => 'Compose Follow up',
        'Compor Seguimento' => 'Config Options',
        'Compor resposta' => 'Compose Email',
        'Configura a definição de TicketFreeField por omissão. "Counter" define o campo de texto livre a usar, "Key" é a TicketFreeKey, "Value" é o TicketFreeText e "Event" define o gatilho' =>
            'Configures the full-text index. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.',
        'Configura a definição de TicketFreeField por omissão. "Counter" define o campo de texto livre a usar, "Key" é a TicketFreeKey, "Value" é o TicketFreeText e "Event" define o gatilho  ' =>
            'Configures a default TicketFreeField setting. "Counter" defines the free text field which should be used, "Key" is the TicketFreeKey, "Value" is the TicketFreeText and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".',
        'Configura a indexação de texto integral. Executar "bin/otrs.RebuildFulltextIndex.pl" para gerar o indice' =>
            'Controls if customers have the ability to sort their tickets.',
        'Configurar o texto de log próprio para PGP' => 'Configures a default TicketFreeField setting. "Counter" defines the free text field which should be used, "Key" is the TicketFreeKey, "Value" is the TicketFreeText and "Event" defines the trigger event.',
        'Conta do Chefe do Correio' => 'Problem',
        'Contactar o cliente' => 'Create Times',
        'Contas de email Postmaster' => 'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).',
        'Controla se os clientes podem ordenar os seus tickets' => 'Converts HTML mails into text messages.',
        'Converte email HTML em texto simples' => 'Create and manage Service Level Agreements (SLAs).',
        'Correio electrónico na Web' => 'WebWatcher',
        'Corresponde' => 'Message for new Owner',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' =>
            'Cria novos grupos para gerir o acesso a permissões a grupos de agentes (ex. departamento de compras, suporte, vendas, ...).',
        'Create/Expires' => 'Criar/expirar',
        'Cria um indice de artigos após criação de artigos' => 'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).',
        'Criae e gerir SLAs' => 'Create and manage agents.',
        'Criar Tempos' => 'Create new Phone Ticket',
        'Criar e gerir Prioridades' => 'Create and manage ticket states.',
        'Criar e gerir agentes ' => 'Create and manage attachments.',
        'Criar e gerir anexos' => 'Create and manage companies.',
        'Criar e gerir assinaturas' => 'Create and manage ticket priorities.',
        'Criar e gerir clientes.' => 'Create and manage event based notifications.',
        'Criar e gerir companhias' => 'Create and manage customers.',
        'Criar e gerir estados de ticket' => 'Create and manage ticket types.',
        'Criar e gerir filas' => 'Create and manage response templates.',
        'Criar e gerir grupos' => 'Create and manage notifications that are sent to agents.',
        'Criar e gerir notificações baseadas em eventos' => 'Create and manage groups.',
        'Criar e gerir papéis' => 'Create and manage salutations.',
        'Criar e gerir respostas enviadas automáticamente' => 'Create and manage roles.',
        'Criar e gerir saudações' => 'Create and manage services.',
        'Criar e gerir serviços' => 'Create and manage signatures.',
        'Criar e gerir templates de resposta' => 'Create and manage responses that are automatically sent.',
        'Criar e gerir tipos de tickets' => 'Create new email ticket and send this out (outbound)',
        'Criar nova base de dados' => 'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).',
        'Criar novo Ticket via Telefone' => 'Create new database',
        'Criar novo ticket por email e enviar (Saída)' => 'Create new phone ticket (inbound)',
        'Criar novo ticket por telefone (entrada)' => 'Custom text for the page shown to customers that have no tickets yet.',
        'Crie novos grupos para manipular as permissões de acesso para diferentes grupos de agentes (e.g., departamento de compras, departamento de suporte, departamento de vendas, etc.).' =>
            'Customer Move Notify',
        'Current Password' => 'Password atual',
        'Dados por omissão na pesquisa de tickets. Exemplo:"TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Dados por omissão na pesquisa de tickets.Exemplo: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;"' =>
            'Default loop protection module.',
        'Dados utlilizados para export os resultados da pesquisa em formato CSV' =>
            'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".',
        'De novo' => 'No * possible!',
        'Define a =hHeight para o editor rtf. Introduza um número(pixels) ou uma percentagem (relativa).' =>
            'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.',
        'Define a Antiguidade em minutos (primeiro nível) para filas selecionadas que possuem tickets não atendidos' =>
            'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.',
        'Define a Antiguidade em minutos (segundo nível) para filas selecionadas que possuem tickets não atendidos' =>
            'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.',
        'Define a Prioridade por omissão de um novo ticket no interface de cliente' =>
            'Defines the default priority of new tickets.',
        'Define a Prioridade por omissão na resposta de cliente no interface de cliente' =>
            'Defines the default priority of new customer tickets in the customer interface.',
        'Define a Prioridade por omissão no ecrã de Prioridade de tickets no interface de agente' =>
            'Defines the default ticket priority in the ticket responsible screen of the agent interface.',
        'Define a Prioridade por omissão no ecrã de campos de texto livre no interface de agente' =>
            'Defines the default ticket priority in the ticket note screen of the agent interface.',
        'Define a Prioridade por omissão no ecrã de fecho de tickets no interface de agente' =>
            'Defines the default ticket priority in the ticket bulk screen of the agent interface.',
        'Define a Prioridade por omissão no ecrã de notas de tickets no interface de agente' =>
            'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Define a Prioridade por omissão no ecrã de operações em bloco de tickets no interface de agente' =>
            'Defines the default ticket priority in the ticket free text screen of the agent interface.',
        'Define a Prioridade por omissão no ecrã de pendentes no interface de agente' =>
            'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Define a Prioridade por omissão no ecrã de proprietário de tickets no interface de agente' =>
            'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Define a Prioridade por omissão no ecrã de responsável de tickets no interface de agente' =>
            'Defines the default type for article in the customer interface.',
        'Define a Prioridade por omissão para novos tickets' => 'Defines the default queue for new customer tickets in the customer interface.',
        'Define a Prioridade por omissão para novos tickets por email no interface de agente' =>
            'Sets the default priority for new phone tickets in the agent interface.',
        'Define a Prioridade por omissão para novos tickets por telefone no interface de agente' =>
            'Sets the default sender type for new email tickets in the agent interface.',
        'Define a altura da legenda' => 'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.',
        'Define a altura máxima de artigos HTML inline em AgentTicketZoom' =>
            'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.',
        'Define a altura por omissão de artigos HTML inline em AgentTicketZoom' =>
            'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.',
        'Define a chave a ser verificada no módulo Kernel::Modules::AgentInfo. Se a chave de preferências do utilizador estiver ativa,a mesnagem é aceite pelo sistema.' =>
            'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.',
        'Define a chave do campo de tempo livre 1 para tickets' => 'Defines the free time key field number 2 for tickets.',
        'Define a chave do campo de tempo livre 2 para tickets' => 'Defines the free time key field number 3 for tickets.',
        'Define a chave do campo de tempo livre 3 para tickets' => 'Defines the free time key field number 4 for tickets.',
        'Define a chave do campo de tempo livre 4 para tickets' => 'Defines the free time key field number 5 for tickets.',
        'Define a chave do campo de tempo livre 5 para tickets' => 'Defines the free time key field number 6 for tickets.',
        'Define a chave do campo de tempo livre 6 para tickets' => 'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.',
        'Define a chave do campo livre número 1 do ticket na adição de novos atributos' =>
            'Defines the free key field number 10 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 1 para artigos na adição de novos atributos' =>
            'Defines the free key field number 1 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 10 do ticket na adição de novos atributos' =>
            'Defines the free key field number 11 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 11 do ticket na adição de novos atributos' =>
            'Defines the free key field number 12 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 12 do ticket na adição de novos atributos' =>
            'Defines the free key field number 13 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 13 do ticket na adição de novos atributos' =>
            'Defines the free key field number 14 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 14 do ticket na adição de novos atributos' =>
            'Defines the free key field number 15 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 15 do ticket na adição de novos atributos' =>
            'Defines the free key field number 16 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 16 do ticket na adição de novos atributos' =>
            'Defines the free key field number 2 for articles to add a new article attribute.',
        'Define a chave do campo livre número 2 do artigo na adição de novos atributos' =>
            'Defines the free key field number 2 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 2 do ticket na adição de novos atributos' =>
            'Defines the free key field number 3 for articles to add a new article attribute.',
        'Define a chave do campo livre número 3 do artigo na adição de novos atributos' =>
            'Defines the free key field number 3 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 3 do ticket na adição de novos atributos' =>
            'Defines the free key field number 4 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 4 do ticket na adição de novos atributos' =>
            'Defines the free key field number 5 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 5 do ticket na adição de novos atributos' =>
            'Defines the free key field number 6 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 6 do ticket na adição de novos atributos' =>
            'Defines the free key field number 7 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 7 do ticket na adição de novos atributos' =>
            'Defines the free key field number 8 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 8 do ticket na adição de novos atributos' =>
            'Defines the free key field number 9 for tickets to add a new ticket attribute.',
        'Define a chave do campo livre número 9 do ticket na adição de novos atributos' =>
            'Defines the free text field number 1 for articles to add a new article attribute.',
        'Define a chave para verificar CustomerAccept. Se a chave estiver ativa, a mensagem é aceite pelo sistema' =>
            'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.',
        'Define a espessura da linha desenhada nos gráficos' => 'Defines the colors for the graphs.',
        'Define a expressão regular para endereços IP no acesso ao repositório local. Necessita de ativar esta opção para acesso ao repositório local e o pacote::RepositoryList no servidor.' =>
            'Defines the URL CSS path.',
        'Define a expressão regular que filtra todos os emails que não devem ser utilizados pela aplicação' =>
            'Defines a useful module to load specific user options or to display news.',
        'Define a fila por omissão do postmaster' => 'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.',
        'Define a fila por omissão para novos tickets de cliente no interface de cliente' =>
            'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).',
        'Define a largura da legenda' => 'Defines the years (in future and in past) which can get selected in free time field number 1.',
        'Define a largura do editor de texto. Introduza um número (pixels) ou percentagem (relativo)' =>
            'Defines the width of the legend.',
        'Define a lista de palavras por omissão, que são ignoradas pelo corretor ortográfico.' =>
            'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.',
        'Define a lista de próximos estados após criar/responder a um ticket no interface de agente ' =>
            'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.',
        'Define a lista de próximos estados após encaminhar um ticket no interface de agente ' =>
            'Defines the next possible states for customer tickets in the customer interface.',
        'Define a lista de próximos estados no interface de agente ' => 'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.',
        'Define a lista de repositórios online. Outras instalações podem ser usadas como repositório, por examplo: Chave="http://example.com/otrs/public.pl?Action=PublicRepository;File=" e conteúdo="nome qualquer".' =>
            'Defines the location to get online repository list for additional packages. The first available result will be used.',
        'Define a localização da legenda. Escrever duas letras no formato: \'B[LCR]|R[TCB]\'. A primeira letra indica a localização(Bottom(baixo) ou Right(direita)), e a segunda letra o alinhamento(Left - esquerda, Right - direita, Center - centro, Top - topo, ou Bottom - baixo).' =>
            'Defines the postmaster default queue.',
        'Define a localização para obter a lista de positórios de pacotes. O primeiro disponível será utilizado' =>
            'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.',
        'Define a notificação por omissão para recusas de cliente/agente no ecrã de recusas no interface de agente' =>
            'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.',
        'Define a ordenação de diferentes items nas preferências de cliente' =>
            'Sets the password for private PGP key.',
        'Define a ordenação de items diferentes na vista de preferências ' =>
            'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.',
        'Define a ordenação por omissão (após ordenção por Prioridade) no ecrã de delegação no interface de agente. Asc: antigos no topo, Desc: recentes no topo' =>
            'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.',
        'Define a ordenação por omissão (após ordenção por Prioridade) no ecrã de escalagem no interface de agente. Asc: antigos no topo, Desc: recentes no topo ' =>
            'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.',
        'Define a ordenação por omissão (após ordenção por Prioridade) no ecrã de estado no interface de agente. Asc: antigos no topo, Desc: recentes no topo' =>
            'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.',
        'Define a ordenação por omissão (após ordenção por Prioridade) no ecrã de responsável no interface de agente. Asc: antigos no topo, Desc: recentes no topo' =>
            'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.',
        'Define a ordenação por omissão (após ordenção por Prioridade) no ecrã de resultados de pesquisa no interface de agente. Asc: antigos no topo, Desc: recentes no topo' =>
            'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.',
        'Define a ordenação por omissão (após ordenção por Prioridade) no ecrã de vigilância de tickets no interface de agente. Asc: antigos no topo, Desc: recentes no topo' =>
            'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.',
        'Define a ordenação por omissão no ecrã de resultados de pesquisa no interface de cliente. Asc: antigos no topo, Desc: recentes no topo' =>
            'Defines the default ticket priority in the close ticket screen of the agent interface.',
        'Define a ordenação por omissão para as filas na vista de filas, após ordenação por Prioridade' =>
            'Defines the default sort order for all queues in the queue view, after priority sort.',
        'Define a ordenação por omissão para todas as filas, após ordenação por Prioridade' =>
            'Defines the default spell checker dictionary.',
        'Define a password de acesso aos webservices SOAP(bin/cgi-bin/rpc.pl)' =>
            'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.',
        'Define a password para a chave privada PGP' => 'Sets the prefered time units (e.g. work units, hours, minutes).',
        'Define a seleção por omissão da chave de campo livre 1 para artigos (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 1 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 1 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 10 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 10 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 11 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 11 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 12 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 12 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 13 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 13 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 14 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 14 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 15 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 15 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 16 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 16 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 2 for articles (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 2 para artigos (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 2 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 2 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 3 for articles (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 3 para artigos (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 3 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 3 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 4 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 4 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 5 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 5 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 6 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 6 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 7 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 7 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 8 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 8 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free key field number 9 for tickets (if more than one option is provided).',
        'Define a seleção por omissão da chave de campo livre 9 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 1 for articles (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 1 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 10 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 10 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 11 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 11 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 12 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 12 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 13 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 13 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 14 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 14 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 15 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 15 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 16 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 16 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 2 for articles (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 2 para artigos (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 2 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 2 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 3 for articles (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 3 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 4 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 4 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 5 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 5 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 6 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 6 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 7 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 7 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 8 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 8 para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 9 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do campo de texto livre 9 para tickets (se existir mais de uma opção)' =>
            'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.',
        'Define a seleção por omissão do campo de texto livre para tickets (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 3 for tickets (if more than one option is provided).',
        'Define a seleção por omissão do texto de campo livre 1 para artigos (se existir mais de uma opção)' =>
            'Defines the default selection of the free text field number 1 for tickets (if more than one option is provided).',
        'Define a seleção por omissão no menu de estatísticas (Form: especificações comuns)' =>
            'Defines the default selection of the free key field number 1 for articles (if more than one option is provided).',
        'Define a seleção por omissão no menu de objetos dinâmicos (Form: especificações comuns)' =>
            'Defines the default selection at the drop down menu for permissions (Form: Common Specification).',
        'Define a seleção por omissão no menu de permissões (Form: especificações comuns)' =>
            'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).',
        'Define a unAntiguidade de tempo preferida (ex: unAntiguidades de trabalho, horas, minutos)' =>
            'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.',
        'Define as cores utilizadas nos gráficos' => 'Defines the column to store the keys for the preferences table.',
        'Define as ligações http/ftp via proxy.' => 'Defines the date input format used in forms (option or input fields).',
        'Define as opções do binário PGP' => 'Sets the order of the different items in the customer preferences view.',
        'Define as permissões por omissão de clientes na aplicação. Se forem necessárias mais permissões, podem ser introduzidas aqui.As permissões necessitam de ser hard coded para serem efetivas. Verifique que ao adicionar as permissões que seleciona também "rw".' =>
            'Defines the standard size of PDF pages.',
        'Define o FQDN do sistema. Esta definição é utilizada na variável OTRS_CONFIG_FQDN, encontrada em todos os formulários e mensagem da aplicação, para construir links para os tickets no sistema .' =>
            'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).',
        'Define o assunto da notificação enviada ao agente na recuperação da password' =>
            'Defines the subject for notification mails sent to agents, with token about new requested password.',
        'Define o assunto da notificação enviada ao agente, com o token para a nova password' =>
            'Defines the subject for notification mails sent to customers, about new account.',
        'Define o assunto da notificação enviada ao cliente, acerca da nova conta' =>
            'Defines the subject for notification mails sent to customers, about new password.',
        'Define o assunto da notificação enviada ao cliente, acerca da password' =>
            'Defines the subject for notification mails sent to customers, with token about new requested password.',
        'Define o assunto da notificação enviada ao cliente, acerca da recuperação da password' =>
            'Defines the subject for rejected emails.',
        'Define o assunto dos emails rejeitados' => 'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.',
        'Define o assunto por omissão em tickets por telefone no interface de agente' =>
            'Defines the default subject of a note in the ticket free text screen of the agent interface.',
        'Define o assunto por omissão na adição de notas adicionadas no ecrã de Prioridade de tickets no interface de agente' =>
            'Sets the default subject for notes added in the ticket responsible screen of the agent interface.',
        'Define o assunto por omissão na adição de notas adicionadas no ecrã de fecho de tickets no interface de agente' =>
            'Sets the default subject for notes added in the ticket move screen of the agent interface.',
        'Define o assunto por omissão na adição de notas adicionadas no ecrã de mover tickets no interface de agente' =>
            'Sets the default subject for notes added in the ticket note screen of the agent interface.',
        'Define o assunto por omissão na adição de notas adicionadas no ecrã de notas de tickets no interface de agente' =>
            'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Define o assunto por omissão na adição de notas adicionadas no ecrã de proprietário de tickets no interface de agente' =>
            'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Define o assunto por omissão na adição de notas adicionadas no ecrã de responsável de tickets no interface de agente' =>
            'Sets the default text for new email tickets in the agent interface.',
        'Define o assunto por omissão na adição de notas adicionadas no ecrã de tickets pendentes no interface de agente' =>
            'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Define o assunto por omissão para novos tickets por email no interface de agente' =>
            'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.',
        'Define o assunto por omissão para novos tickets por telefone no interface de agente' =>
            'Sets the default subject for notes added in the close ticket screen of the agent interface.',
        'Define o atribute de ordenação por omissão no ecrã de delegação no interface de agente' =>
            'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.',
        'Define o atribute de ordenação por omissão no ecrã de escalagem no interface de agente' =>
            'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.',
        'Define o atribute de ordenação por omissão no ecrã de estado no interface de agente' =>
            'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.',
        'Define o atribute de ordenação por omissão no ecrã de pesquisa no interface de agente' =>
            'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.',
        'Define o atribute de ordenação por omissão no ecrã de responsável no interface de agente' =>
            'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.',
        'Define o atribute de ordenação por omissão no ecrã de vigilância no interface de agente' =>
            'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.',
        'Define o atribute de ordenação por omissão nos resultados de pesquisa no interface de cliente' =>
            'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.',
        'Define o atributo de ligação à base de dados externa de cliente. Ex. \'target="cdb"\'' =>
            'Defines the time zone of the calendar number 1, which can be assigned later to a specific queue.',
        'Define o caminho URL das imagens para navegação' => 'Defines the URL java script path.',
        'Define o caminho URL de javascript' => 'Defines the URL rich text editor path.',
        'Define o caminho URL do editor rtf' => 'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.',
        'Define o caminho base de icons, CSS e scripts javascript' => 'Defines the URL image path of icons for navigation.',
        'Define o caminho do URL CSS' => 'Defines the URL base path of icons, CSS and Java Script.',
        'Define o caminho do ficheiro de informações, localizado em Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            'Defines the path to PGP binary.',
        'Define o caminho para o binário PGP' => 'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Define o caminho para o binário open ssl. Pode ser necessário definir variáveis de ambiente ($ENV{HOME} = \'/var/lib/wwwrun\';)' =>
            'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).',
        'Define o caminho para o ficheiro de fonte TTF bold italic monospaced para documentos PDF' =>
            'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.',
        'Define o caminho para o ficheiro de fonte TTF bold italic proportional para documentos PDF' =>
            'Defines the path and TTF-File to handle bold monospaced font in PDF documents.',
        'Define o caminho para o ficheiro de fonte TTF bold monospaced para documentos PDF' =>
            'Defines the path and TTF-File to handle bold proportional font in PDF documents.',
        'Define o caminho para o ficheiro de fonte TTF bold proportional para documentos PDF' =>
            'Defines the path and TTF-File to handle italic monospaced font in PDF documents.',
        'Define o caminho para o ficheiro de fonte TTF italic monospaced para documentos PDF' =>
            'Defines the path and TTF-File to handle italic proportional font in PDF documents.',
        'Define o caminho para o ficheiro de fonte TTF italic proportional para documentos PDF' =>
            'Defines the path and TTF-File to handle monospaced font in PDF documents.',
        'Define o caminho para o ficheiro de fonte TTF monospaced para documentos PDF' =>
            'Defines the path and TTF-File to handle proportional font in PDF documents.',
        'Define o caminho para o ficheiro de fonte TTF proportional para documentos PDF' =>
            'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.',
        'Define o comentário na adição de notas de ticket, no interface de agente' =>
            'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.',
        'Define o comentário na alteração da Prioridade de ticket, no interface de agente' =>
            'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.',
        'Define o comentário na alteração de proprietário  de ticket, no interface de agente' =>
            'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.',
        'Define o comentário na alteraçãode responsável de ticket, no interface de agente' =>
            'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.',
        'Define o comentário na colocação de pendente de ticket, no interface de agente' =>
            'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.',
        'Define o comentário na criação de tickets por telefone, no interface de agente' =>
            'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.',
        'Define o comentário na visualização do detalhe de ticket, no interface de agente' =>
            'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.',
        'Define o comentário no histórico na adição de campos de texto livrede ticket, no interface de agente' =>
            'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.',
        'Define o comentário no histórico na criação de tickets por email, no interface de agente' =>
            'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.',
        'Define o comentário no histórico na criação de tickets por telefone, no interface de agente' =>
            'Defines the history comment for the ticket free text screen action, which gets used for ticket history.',
        'Define o comentário no histórico no fecho de ticket, no interface de agente' =>
            'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.',
        'Define o corpo da mensagem de emails rejeitadas' => 'Defines the boldness of the line drawed by the graph.',
        'Define o corpo da nota por omissão no ecrã de campos de texto livre no interface do agente.' =>
            'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.',
        'Define o corpo da nota por omissão para tickets por emaill no interface de agente' =>
            'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.',
        'Define o corpo do texto das notificações enviadas aos clientes, com o token para a recuperação de password (após utilizar o link a nova password é enviada).' =>
            'Defines the body text for rejected emails.',
        'Define o corpo do texto das notificações enviadas aos clientes, sobre a nova conta' =>
            'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).',
        'Define o corpo do texto das notificações enviadas aos clientes, sobre a nova password (após utilizar o link a nova password é enviada).' =>
            'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).',
        'Define o corpo do texto das notificações enviadas por email aos agentes, com a recuperação da password (após utilizar o link a nova password é enviada).' =>
            'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).',
        'Define o corpo do texto nas notificações enviadas aos agentes,com o token para a recuparação de password (após utilizar o link a nova password é enviada).' =>
            'Defines the body text for notification mails sent to customers, about new account.',
        'Define o corpo do texto por omissão de notas no ecrã de Prioridade de tickets no interface de agente' =>
            'Sets the default body text for notes added in the ticket responsible screen of the agent interface.',
        'Define o corpo do texto por omissão de notas no ecrã de fecho de tickets no interface de agente' =>
            'Sets the default body text for notes added in the ticket move screen of the agent interface.',
        'Define o corpo do texto por omissão de notas no ecrã de mover tickets no interface de agente' =>
            'Sets the default body text for notes added in the ticket note screen of the agent interface.',
        'Define o corpo do texto por omissão de notas no ecrã de notas de tickets no interface de agente' =>
            'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Define o corpo do texto por omissão de notas no ecrã de proprietário de tickets no interface de agente' =>
            'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Define o corpo do texto por omissão de notas no ecrã de responsável de tickets no interface de agente' =>
            'Sets the default charset for the web interface to use (should represent the charset used to create the database or, in some cases, the database management system being used). "utf-8" is a good choice for environments expecting many charsets. You can specify another charset here (i.e. "iso-8859-1"). Please be sure that you will not be receiving foreign emails, or text, otherwise this could lead to problems.',
        'Define o corpo do texto por omissão de notas no ecrã de tickets pendentes no interface de agente' =>
            'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Define o corretor ortográfico por omissão' => 'Defines the default state of new customer tickets in the customer interface.',
        'Define o código de página por omissão para o interface web (deve ser o mesmo utilizado na criação da base de dados. "utf-8" é a melhor opção para ambientes com diversos códigos de página. Pode ainda especificar outro (ee. "iso-8859-1"). Confirme que não recebe emails de endereços de outros países, ou texto, senão podem ocorrer problemas de representação.' =>
            'Sets the default link type of splitted tickets in the agent interface.',
        'Define o código de página utilizado na referência de emails no ecrã de composição no interface de agente' =>
            'Defines the user identifier for the customer panel.',
        'Define o email de remetente para o sistema' => 'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.',
        'Define o email do administrador de sistema. Será mostrado nos ecrãs de erros da aplicação' =>
            'Defines the system identifier. Every ticket number and http session string contain this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).',
        'Define o endereço do servidor dns, para verificar os registos MX do email' =>
            'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).',
        'Define o enlace de estatísticas' => 'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.',
        'Define o espaçamento entre legendas' => 'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.',
        'Define o estado do ticket quando recebe uma atualização e já se encontrava fechado' =>
            'Defines the state of a ticket if it gets a follow-up.',
        'Define o estado do ticket se recebe uma atualização' => 'Defines the state type of the reminder for pending tickets.',
        'Define o estado por omissão' => 'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.',
        'Define o estado por omissão de novos tickets de cliente no interface de cliente' =>
            'Defines the default state of new tickets.',
        'Define o formato da data a utilizador nos formulários (campos option ou input )' =>
            'Defines the default CSS used in rich text editors.',
        'Define o formato de respostas do ticket na janela de composição no interface de agente ($QData{"OrigFrom"} é desde 1:1, $QData{"OrigFromName"} é o nome From ).' =>
            'Defines the free key field number 1 for articles to add a new article attribute.',
        'Define o formato do campo de remetenten nos emails (Enviado nas resposta e tickets por email)' =>
            'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Define o fuso horário do calendário 1, associado a uma fila específica.' =>
            'Defines the time zone of the calendar number 2, which can be assigned later to a specific queue.',
        'Define o fuso horário do calendário 2, associado a uma fila específica.' =>
            'Defines the time zone of the calendar number 3, which can be assigned later to a specific queue.',
        'Define o fuso horário do calendário 3, associado a uma fila específica.' =>
            'Defines the time zone of the calendar number 4, which can be assigned later to a specific queue.',
        'Define o fuso horário do calendário 4, associado a uma fila específica.' =>
            'Defines the time zone of the calendar number 5, which can be assigned later to a specific queue.',
        'Define o fuso horário do calendário 5, associado a uma fila específica.' =>
            'Defines the time zone of the calendar number 6, which can be assigned later to a specific queue.',
        'Define o fuso horário do calendário 6, associado a uma fila específica.' =>
            'Defines the time zone of the calendar number 7, which can be assigned later to a specific queue.',
        'Define o fuso horário do calendário 7, associado a uma fila específica.' =>
            'Defines the time zone of the calendar number 8, which can be assigned later to a specific queue.',
        'Define o fuso horário do calendário 8, associado a uma fila específica.' =>
            'Defines the time zone of the calendar number 9, which can be assigned later to a specific queue.',
        'Define o fuso horário do calendário 9, associado a uma fila específica.' =>
            'Defines the type of protocol, used by ther web server, to serve the application. If https protocol will be used instead of plain http, it must be specified it here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.',
        'Define o fuso horário do sistema (necessário um sistema com UTC). caso contrário será utilizada diferença para o tempo local' =>
            'Sets the ticket owner in the close ticket screen of the agent interface.',
        'Define o fuso horário por utilizador (Necessita de um sitema com UTC), caso contrário será utilizada a diferença de tempo para o relógio local' =>
            'Sets the user time zone per user based on java script / browser time zone offset feature at login time.',
        'Define o fuso horário por utilizador baseado no fuso horário de javascript/browser no momento de login' =>
            'Show a responsible selection in phone and email tickets in the agent interface.',
        'Define o horário e dias de semana do calendário 1, para contabilização de tempo de trabalho' =>
            'Defines the hours and week days of the calendar number 2, to count the working time.',
        'Define o horário e dias de semana do calendário 2, para contabilização de tempo de trabalho' =>
            'Defines the hours and week days of the calendar number 3, to count the working time.',
        'Define o horário e dias de semana do calendário 3, para contabilização de tempo de trabalho' =>
            'Defines the hours and week days of the calendar number 4, to count the working time.',
        'Define o horário e dias de semana do calendário 4, para contabilização de tempo de trabalho' =>
            'Defines the hours and week days of the calendar number 5, to count the working time.',
        'Define o horário e dias de semana do calendário 5, para contabilização de tempo de trabalho' =>
            'Defines the hours and week days of the calendar number 6, to count the working time.',
        'Define o horário e dias de semana do calendário 6, para contabilização de tempo de trabalho' =>
            'Defines the hours and week days of the calendar number 7, to count the working time.',
        'Define o horário e dias de semana do calendário 7, para contabilização de tempo de trabalho' =>
            'Defines the hours and week days of the calendar number 8, to count the working time.',
        'Define o horário e dias de semana do calendário 8, para contabilização de tempo de trabalho' =>
            'Defines the hours and week days of the calendar number 9, to count the working time.',
        'Define o horário e dias de semana do calendário 9, para contabilização de tempo de trabalho' =>
            'Defines the hours and week days to count the working time.',
        'Define o horário e dias de semana, para contabilização de tempo de trabalho' =>
            'Defines the http link for the free text field number 1 for tickets (it will be used in every ticket view).',
        'Define o identificador de utilizador para o painel de cliente' =>
            'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).',
        'Define o identificador do sistema. Todos os números de ticket e sessão possuem o identificador. O identificador garante que as atualizações são processadas de forma correta (útil na comunicação entre duas instâncias de OTRS.' =>
            'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.',
        'Define o idioma por omissão no front-end. As opções correspondem a ficheiro de idiomas disponiveis no sistema (ver a próxima definição).' =>
            'Defines the default history type in the customer interface.',
        'Define o limite de pesquisa das estatísticas' => 'Defines the separator between the agents real name and the given queue email address.',
        'Define o link http para o campo de texto livre 1 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 10 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 10 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 11 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 11 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 12 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 12 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 13 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 13 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 14 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 14 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 15 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 15 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 16 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 16 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 2 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 2 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 3 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 3 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 4 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 4 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 5 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 5 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 6 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 6 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 7 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 7 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 8 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 8 do ticket (utilizado na visualização de tickets)' =>
            'Defines the http link for the free text field number 9 for tickets (it will be used in every ticket view).',
        'Define o link http para o campo de texto livre 9 do ticket (utilizado na visualização de tickets)' =>
            'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.',
        'Define o módulo de envio de emails. "Sendmail" utiliza o binário sendmail do sistema operativo Qualquer opção "SMTP" utiliza um servidor externo. "DoNotSendEmail" não envia emails e é útil para sistemas de teste.' =>
            'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.',
        'Define o módulo de front-end por omissão, se não for indicado nada no url do interface de agente' =>
            'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.',
        'Define o módulo de front-end por omissão, se não for indicado nada no url do interface de cliente' =>
            'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.',
        'Define o módulo de log do sistema. "File" escreve as mensagens no syslog de sistema, ex: syslogd. ' =>
            'Defines the maximal size (in bytes) for file uploads via the browser.',
        'Define o módulo para autenticar clientes' => 'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).',
        'Define o módulo para gerar os cabeçalhos de refresh HTML dos sites' =>
            'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.',
        'Define o módulo para gerar os cabeçalhos de refresh HTML dos sites, no interface de cliente.' =>
            'Defines the module to generate html refresh headers of html sites.',
        'Define o módulo para guardar dados da sessão. Com "DB" o frontend pode ser separado do servidor de base de dados . "FS" é mais rápido.' =>
            'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.',
        'Define o módulo para mostrar as notificações no interface de agente, se o sistema for utilizado pelo admin.' =>
            'Defines the module to generate html refresh headers of html sites, in the customer interface.',
        'Define o módulo que carrega preferências de utilizador ou mostra as notícias' =>
            'Defines all the X-headers that should be scanned.',
        'Define o módulo que mostra todos os agentes ligados ao sistema no interface de cliente' =>
            'Defines the module that shows the currently loged in customers in the customer interface.',
        'Define o módulo que mostra todos os clientes ligados ao sistema no interface de cliente' =>
            'Defines the module to authenticate customers.',
        'Define o módulo que mostra todos os utilizadores ligados ao sistema no interface de agente' =>
            'Defines the module that shows the currently loged in agents in the customer interface.',
        'Define o nome da aplicação, mostrado no interface web, separadores e barra de titulo do browser.' =>
            'Defines the name of the calendar number 1.',
        'Define o nome da chave das sessões de cliente ' => 'Defines the name of the session key. E.g. Session, SessionID or OTRS.',
        'Define o nome da chave de sessão. Ex. Session, SessionID ou OTRS' =>
            'Defines the name of the table, where the customer preferences are stored.',
        'Define o nome da coluna para guardar o utilizador na tabela de preferências' =>
            'Defines the name of the key for customer sessions.',
        'Define o nome da coluna para guardar os dados da tabela de preferências' =>
            'Defines the name of the column to store the user identifier in the preferences table.',
        'Define o nome da tabela, onde as preferências de cliente são guardadas' =>
            'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.',
        'Define o nome do calendário número 1.' => 'Defines the name of the calendar number 2.',
        'Define o nome do calendário número 2.' => 'Defines the name of the calendar number 3.',
        'Define o nome do calendário número 3.' => 'Defines the name of the calendar number 4.',
        'Define o nome do calendário número 4.' => 'Defines the name of the calendar number 5.',
        'Define o nome do calendário número 5.' => 'Defines the name of the calendar number 6.',
        'Define o nome do calendário número 6.' => 'Defines the name of the calendar number 7.',
        'Define o nome do calendário número 7.' => 'Defines the name of the calendar number 8.',
        'Define o nome do calendário número 8.' => 'Defines the name of the calendar number 9.',
        'Define o nome do calendário número 9.' => 'Defines the name of the column to store the data in the preferences table.',
        'Define o nível de configuração do administrador. Conforme o nível de configuração, algumas opções sysconfig não serão mostradas. Os níveis de configuração ordenados de modo ascendente: Expert, Advanced, Beginner. Quanto mais elevado o nível de configuração é(ex. Beginner é o mais elevado), menos provável é que existam configurações acidentais no sistema e tornem o sistema instável.' =>
            'Sets the default article type for new email tickets in the agent interface.',
        'Define o número de linhas a serem mostradas nas mensagens de texto (ex: linhas do ticket em QueueZoom)' =>
            'Sets the number of lines that are displayed in the preview of messages (e.g. for tickets in the QueueView).',
        'Define o número de linhas mostradas na previsão de mensagem (ex: para tickets na QueueView)' =>
            'Sets the number of search results to be displayed for the autocomplete feature.',
        'Define o número de resultados mostrados na funcionalAntiguidade de autocomplete' =>
            'Sets the options for PGP binary.',
        'Define o número máximo de páginas para o ficheiro PDF.' => 'Defines the maximum size (in MB) of the log file.',
        'Define o número máximo de resultados da pesquisa na vista geral' =>
            'Defines the default next state for a ticket after customer follow up in the customer interface.',
        'Define o número mínimo de carateres antes de enviar uma query autocomplete' =>
            'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).',
        'Define o período de inativAntiguidade (em segundos) antes da sessão ser destruída e o utilizador desligado do sistema' =>
            'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.',
        'Define o prefixo da pasta de scripts no servidor, como configurado no servidor web. Esta definição é utilizada na variável OTRS_CONFIG_ScriptAlias, utilizada em todas as mensagens enviadas pelo sistema,para construir os links de tickets.' =>
            'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.',
        'Define o primeiro dia da semana para o controlo de selecção de datas' =>
            'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.',
        'Define o processo de texto nos artigos, para destacar URLs' => 'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).',
        'Define o próximo estado do ticket após adicionar uma nota no ecrã de Prioridade de ticket no interface de agente' =>
            'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.',
        'Define o próximo estado do ticket após adicionar uma nota no ecrã de campos de texto livre no interface de agente' =>
            'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.',
        'Define o próximo estado do ticket após adicionar uma nota no ecrã de fecho de ticket no interface de agente' =>
            'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.',
        'Define o próximo estado do ticket após adicionar uma nota no ecrã de notas de ticket no interface de agente' =>
            'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Define o próximo estado do ticket após adicionar uma nota no ecrã de operações em lote no interface de agente' =>
            'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.',
        'Define o próximo estado do ticket após adicionar uma nota no ecrã de pendentes de ticket no interface de agente' =>
            'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Define o próximo estado do ticket após adicionar uma nota no ecrã de proprietário de ticket no interface de agente' =>
            'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Define o próximo estado do ticket após adicionar uma nota no ecrã de responsável de ticket no interface de agente' =>
            'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.',
        'Define o próximo estado do ticket após mover o ticket no ecrã de mover de ticket no interface de agente' =>
            'Defines the parameters for the customer preferences table.',
        'Define o próximo estado do ticket após recusar o ticket no ecrã de devolução de ticket no interface de agente' =>
            'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.',
        'Define o próximo estado para novos tickets por email no interface de agente' =>
            'Sets the default next ticket state, after the creation of an email ticket in the agent interface.',
        'Define o próximo estado por omissão após adicionar uma nota em tickets por telefone no interface de agente' =>
            'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.',
        'Define o próximo estado por omissão após adicionar uma nota, no ecrã de Prioridade de ticket no interface de agente.' =>
            'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.',
        'Define o próximo estado por omissão após adicionar uma nota, no ecrã de campos de texto livre no interface de agente.' =>
            'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.',
        'Define o próximo estado por omissão após adicionar uma nota, no ecrã de fecho de ticket no interface de agente.' =>
            'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.',
        'Define o próximo estado por omissão após adicionar uma nota, no ecrã de notas de ticket no interface de agente.' =>
            'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Define o próximo estado por omissão após adicionar uma nota, no ecrã de operações em bloco no interface de agente' =>
            'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.',
        'Define o próximo estado por omissão após adicionar uma nota, no ecrã de pendentes de ticket no interface de agente.' =>
            'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Define o próximo estado por omissão após adicionar uma nota, no ecrã de proprietário de ticket no interface de agente.' =>
            'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Define o próximo estado por omissão após adicionar uma nota, no ecrã de responsável de ticket no interface de agente.' =>
            'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.',
        'Define o próximo estado por omissão após devolver um ticket no interface de agente.' =>
            'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.',
        'Define o próximo estado por omissão após encaminhar um ticket no interface de agente.' =>
            'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.',
        'Define o próximo estado por omissão após uma atualização de cliente no interface de cliente' =>
            'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.',
        'Define o próximo estado por omissão para o ecrã de composição / resposta no interface de agente' =>
            'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.',
        'Define o próximo estado, após a criação de tickets por email no interface de agente' =>
            'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.',
        'Define o remetente do ticket por telefone/email ("Queue" mostra todas as filas, "SystemAddress" mostra todos os endereços de sistema) no interface de agente.' =>
            'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.',
        'Define o remetente por omissão para tickets no interface de cliente' =>
            'Defines the default shown ticket search attribute for ticket search screen.',
        'Define o separador entre o nome do agente e o email da fila ' =>
            'Defines the spacing of the legends.',
        'Define o tamanho do gráfico de estatísticas' => 'Sets the stats hook.',
        'Define o tamanho máximo (em MB) do ficheiro de log.' => 'Defines the module that shows all the currently loged in customers in the agent interface.',
        'Define o tamanho máximo em bytes para carregamento de ficheiros via browser.' =>
            'Defines the maximal valid time (in seconds) for a session id.',
        'Define o tamanho padrão das páginas de PDF' => 'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.',
        'Define o tema do front-end (HTML) por omissão a ser utilizado por agentes e clientes. Os temas por omissão são o Standard e Lite. Se desejar pode adicionar o seu próprio tema. Consulte a documentação em http://doc.otrs.org/.' =>
            'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).',
        'Define o tempo PendingTime de um ticket a 0 se o estado do ticket é alterado para um estado não pendente' =>
            'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.',
        'Define o tempo máximo (em segundos) para a sessão.' => 'Defines the maximum number of pages per PDF file.',
        'Define o texto da nota por omissão em novos tickets por telefone. Ex: Novos ticked via chamada no interface de agente' =>
            'Sets the default priority for new email tickets in the agent interface.',
        'Define o texto do campo livre número 1 do artigo na adição de novos atributos' =>
            'Defines the free text field number 1 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 1 do ticket na adição de novos atributos' =>
            'Defines the free text field number 10 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 10 do ticket na adição de novos atributos' =>
            'Defines the free text field number 11 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 11 do ticket na adição de novos atributos' =>
            'Defines the free text field number 12 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 12 do ticket na adição de novos atributos' =>
            'Defines the free text field number 13 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 13 do ticket na adição de novos atributos' =>
            'Defines the free text field number 14 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 14 do ticket na adição de novos atributos' =>
            'Defines the free text field number 15 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 15 do ticket na adição de novos atributos' =>
            'Defines the free text field number 16 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 16 do ticket na adição de novos atributos' =>
            'Defines the free text field number 2 for articles to add a new article attribute.',
        'Define o texto do campo livre número 2 do artigo na adição de novos atributos' =>
            'Defines the free text field number 2 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 2 do ticket na adição de novos atributos' =>
            'Defines the free text field number 3 for articles to add a new article attribute.',
        'Define o texto do campo livre número 3 do artigo na adição de novos atributos' =>
            'Defines the free text field number 3 for ticket to add a new ticket attribute.',
        'Define o texto do campo livre número 3 do ticket na adição de novos atributos' =>
            'Defines the free text field number 4 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 4 do ticket na adição de novos atributos' =>
            'Defines the free text field number 5 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 5 do ticket na adição de novos atributos' =>
            'Defines the free text field number 6 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 6 do ticket na adição de novos atributos' =>
            'Defines the free text field number 7 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 7 do ticket na adição de novos atributos' =>
            'Defines the free text field number 8 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 8 do ticket na adição de novos atributos' =>
            'Defines the free text field number 9 for tickets to add a new ticket attribute.',
        'Define o texto do campo livre número 9 do ticket na adição de novos atributos' =>
            'Defines the free time key field number 1 for tickets.',
        'Define o texto por omissão em novos tickets por email no interface por agente' =>
            'Sets the display order of the different items in the preferences view.',
        'Define o timeout (em segundos) para descarregamentos http/ftp' =>
            'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".',
        'Define o timeout (em segundos) para descarregar pacotes. Re-escreve "WebUserAgent::Timeout".' =>
            'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.',
        'Define o tipo de artigo por omissão na criação de tickets por email no interface de agente' =>
            'Sets the default article type for new phone tickets in the agent interface.',
        'Define o tipo de artigo por omissão na criação de tickets por telefone no interface de agente' =>
            'Sets the default body text for notes added in the close ticket screen of the agent interface.',
        'Define o tipo de estado do lembrete de pendente do ticket' => 'Defines the subject for notification mails sent to agents, about new password.',
        'Define o tipo de histórico na adição de campos de texto livre nos tickets' =>
            'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.',
        'Define o tipo de histórico na adição de notas nos tickets' =>
            'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.',
        'Define o tipo de histórico na alteração de Prioridade nos tickets' =>
            'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.',
        'Define o tipo de histórico na alteração de pendentes nos tickets' =>
            'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.',
        'Define o tipo de histórico na alteração de proprietário nos tickets' =>
            'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.',
        'Define o tipo de histórico na alteração de responsável nos tickets' =>
            'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.',
        'Define o tipo de histórico na criação de ticket por email, no interface de agente' =>
            'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.',
        'Define o tipo de histórico na criação de ticket por telefone, no interface de agente' =>
            'Defines the history type for the ticket free text screen action, which gets used for ticket history.',
        'Define o tipo de histórico na criação de tickets' => 'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.',
        'Define o tipo de histórico na visualização de detalhe do tickets' =>
            'Defines the hours and week days of the calendar number 1, to count the working time.',
        'Define o tipo de histórico no fecho de ticket, no interface de agente' =>
            'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.',
        'Define o tipo de histórico por omissão no interface de cliente' =>
            'Defines the default maximum number of X-axis attributes for the time scale.',
        'Define o tipo de ligação \'Normal\'. Se o nome de origem e de destino forem iguais, o resultado é uma ligação não direcional; caso contrário é uma ligação direcional.' =>
            'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.',
        'Define o tipo de ligação \'ParentChild\'. Se o nome de origem e de destino forem iguais, o resultado é uma ligação não direcional; caso contrário é uma ligação direcional.' =>
            'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.',
        'Define o tipo de ligação de grupos. Os tipos de ligações do mesmo grupo, cancelam-se mutuamente. Examplo: Se o ticket A tem uma ligação \'Normal\' com o ticket B, não podem ser adicionalmente ligados numa relação \'ParentChild\' .' =>
            'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".',
        'Define o tipo de ligação por omissão para tickets duplicados no interface de agente' =>
            'Sets the default next state for new phone tickets in the agent interface.',
        'Define o tipo de protocolo utilizado no servidor web. Se for utilizado https em vez de http, tem de ser especificado aqui. Utilizada na variável OTRS_CONFIG_HttpType em todos os ecrãs e mensagens.' =>
            'Defines the used character for email quotes in the ticket compose screen of the agent interface.',
        'Define o tipo de remetente por omissão para novos tickets por email no interface de agente' =>
            'Sets the default sender type for new phone ticket in the agent interface.',
        'Define o tipo de remetente por omissão para novos tickets por telefone no interface de agente' =>
            'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.',
        'Define o tipo de tempo que deve ser mostrado' => 'Sets the timeout (in seconds) for http/ftp downloads.',
        'Define o tipo por omissão da nota no ecrã de Prioridades no interface de agente' =>
            'Defines the default type of the note in the ticket responsible screen of the agent interface.',
        'Define o tipo por omissão da nota no ecrã de campos de texto livre no interface de agente' =>
            'Defines the default type of the note in the ticket note screen of the agent interface.',
        'Define o tipo por omissão da nota no ecrã de detalhe do tickets no interface de agente' =>
            'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.',
        'Define o tipo por omissão da nota no ecrã de fecho de ticket no interface de agente' =>
            'Defines the default type of the note in the ticket bulk screen of the agent interface.',
        'Define o tipo por omissão da nota no ecrã de notas de ticket no interface de agente' =>
            'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Define o tipo por omissão da nota no ecrã de operações em bloco de ticket no interface de agente' =>
            'Defines the default type of the note in the ticket free text screen of the agent interface.',
        'Define o tipo por omissão da nota no ecrã de pendentes no interface de agente' =>
            'Defines the default type of the note in the ticket phone outbound screen of the agent interface.',
        'Define o tipo por omissão da nota no ecrã de proprietário de ticket no interface de agente' =>
            'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Define o tipo por omissão da nota no ecrã de responsável no interface de agente' =>
            'Defines the default type of the note in the ticket zoom screen of the customer interface.',
        'Define o tipo por omissão da nota no ecrã de tickets por telefone no interface de agente' =>
            'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Define o tipo por omissão em mensagens encaminhadas no interface de agente' =>
            'Defines the default type of the note in the close ticket screen of the agent interface.',
        'Define o tipo por omissão para artigo no interface de cliente' =>
            'Defines the default type of forwarded message in the ticket forward screen of the agent interface.',
        'Define o username de acesso aos webservices SOAP (bin/cgi-bin/rpc.pl).' =>
            'Defines the valid state types for a ticket.',
        'Define o valor do eixo-X máximo por omissão para a escala de tempo' =>
            'Defines the default maximum number of search results shown on the overview page.',
        'Define o valor por omissão da diferença a partir de agora (em segundos) no campo de tempo livre 1' =>
            'Defines the difference from now (in seconds) of the free time field number 2\'s default value.',
        'Define o valor por omissão da diferença a partir de agora (em segundos) no campo de tempo livre 2' =>
            'Defines the difference from now (in seconds) of the free time field number 3\'s default value.',
        'Define o valor por omissão da diferença a partir de agora (em segundos) no campo de tempo livre 3' =>
            'Defines the difference from now (in seconds) of the free time field number 4\'s default value.',
        'Define o valor por omissão da diferença a partir de agora (em segundos) no campo de tempo livre 4' =>
            'Defines the difference from now (in seconds) of the free time field number 5\'s default value.',
        'Define o valor por omissão da diferença a partir de agora (em segundos) no campo de tempo livre 5' =>
            'Defines the difference from now (in seconds) of the free time field number 6\'s default value.',
        'Define o valor por omissão da diferença a partir de agora (em segundos) no campo de tempo livre 6' =>
            'Defines the filter that processes the text in the articles, in order to highlight URLs.',
        'Define o valor por omissão para o parametro ação no interface público. O parametro ação é utilizado pelos scripts do sistema' =>
            'Defines the default viewable sender types of a ticket (default: customer).',
        'Define oa ssunto de uma nova no ecrã de campos de texto livre no interface de agente' =>
            'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.',
        'Define os anos (no futuro e passado) que podem ser selecionados no campos de tempo livre 1' =>
            'Defines the years (in future and in past) which can get selected in free time field number 2.',
        'Define os anos (no futuro e passado) que podem ser selecionados no campos de tempo livre 2' =>
            'Defines the years (in future and in past) which can get selected in free time field number 3.',
        'Define os anos (no futuro e passado) que podem ser selecionados no campos de tempo livre 3' =>
            'Defines the years (in future and in past) which can get selected in free time field number 4.',
        'Define os anos (no futuro e passado) que podem ser selecionados no campos de tempo livre 4' =>
            'Defines the years (in future and in past) which can get selected in free time field number 5.',
        'Define os anos (no futuro e passado) que podem ser selecionados no campos de tempo livre 5' =>
            'Defines the years (in future and in past) which can get selected in free time field number 6.',
        'Define os anos (no futuro e passado) que podem ser selecionados no campos de tempo livre 6' =>
            'Defines whether the free time field number 1 is optional or not.',
        'Define os campos para guardar as chaves da tabela de preferencias ' =>
            'Defines the config parameters of this item, to be shown in the preferences view.',
        'Define os critérios de pesquisa por omissão no ecrã de pesquisa' =>
            'Defines the default sort criteria for all queues displayed in the queue view, after sort by priority is done.',
        'Define os destinatários dos tickets ("Queue" mostra todas as filas, "SystemAddress" mostra todos os endereços de email) no interface de cliente.' =>
            'Defines the search limit for the stats.',
        'Define os estados que devem ser automaticamente escolhidos (conteúdo), após o tempo de pendencia (key) sere atingido.' =>
            'Delay time between autocomplete queries.',
        'Define os grupos a que todos os clientes pertecem (se estiver ativo  CustomerGroupSupport e não desejar gerir todos os utilizadores destes grupos).' =>
            'Defines the height of the legend.',
        'Define os idiomas disponíveis para a aplicação. O par Chave/Conteúdo liga o nome mostrado no front-end ao ficheiro de idioma. A chave deve ser o nome base do ficheiro PM.(ex. de.pm é o ficheiro, "de" é a chave). O valor do "Conteúdo" deve ser o nome mostrado no front-end. Especificar aqui os idiomas (ver a documentação  http://doc.otrs.org/ ). Não esquecer de utilizar os carateres equivalentes HTML para para carateres não ASCII (ex. para o carater alemão oe = o umlaut, it é necessário usar o simbolo &ouml; ).' =>
            'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.',
        'Define os parametros de configuração para este item, mostrados nas preferências.' =>
            'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.',
        'Define os parametros de configuração para este item, mostrados nas preferências. Mantenha os dicionários instalados no sistema.' =>
            'Defines the connections for http/ftp, via a proxy.',
        'Define os parametros para a tabela de preferências de cliente' =>
            'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.',
        'Define os parametros para o dashboard. "Group" é utilizado para restringir o acesso ao plugin (ex. Group: admin;group1;group2;). "Default" indica se o plugin esta ativo por omissão ou se o utilizador necessita de to ativar manualmente. "CacheTTL" indica o periodo de expiração em minutos para o plugin.' =>
            'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.',
        'Define os parametros para o dashboard. "Group" é utilizado para restringir o acesso ao plugin (ex. Group: admin;group1;group2;). "Default" indica se o plugin esta ativo por omissão ou se o utilizador necessita de to ativar manualmente. "CacheTTLLocal" indica o periodo de expiração em minutos para o plugin.' =>
            'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.',
        'Define os parametros para o dashoard. "Limit" define o número de entradas mostradas por omissão. "Group" é utilizado para restringir o acesso ao plugin (ex. Group: admin;group1;group2;). "Default" indica se o plugin está ativo por omissão ou se o utilizador necessita de o ativar manualmente. "CacheTTL" indica o período de expiração da cache em minutos.' =>
            'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.',
        'Define os parametros para o dashoard. "Limit" define o número de entradas mostradas por omissão. "Group" é utilizado para restringir o acesso ao plugin (ex. Group: admin;group1;group2;). "Default" indica se o plugin está ativo por omissão ou se o utilizador necessita de o ativar manualmente. "CacheTTLLocal" indica o período de expiração da cache em minutos.' =>
            'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).',
        'Define os tipos de bloqueios de ticket visiveis. Por omissão: unlock, tmp_lock' =>
            'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).',
        'Define os tipos de estados para tickets desbloqueados. Para desbloquear os tickets utilizar o script "bin/otrs.UnlockTickets.pl".' =>
            'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.',
        'Define os tipos de estados válidos para o ticket' => 'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.',
        'Define os tipos de remetente visíveis por omissão (omissão: cliente)' =>
            'Defines the difference from now (in seconds) of the free time field number 1\'s default value.',
        'Define quais os cabeçalhos X-headers que devem ser analizados' =>
            'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).',
        'Define se a contabilização de tempo deve ser definida em operações em bloco' =>
            'Defines the =hHeight for the rich text editor component. Enter number (pixels) or percent value (relative).',
        'Define se a contabilização de tempo é obrigatória no interface de agente' =>
            'Defines if time accounting must be set to all tickets in bulk action.',
        'Define se as mensagens são verificadas com corretor ortográfico no interface de agente' =>
            'Defines if time accounting is mandatory in the agent interface.',
        'Define se o campo de tempo livre 1 é opcional ou obrigatório' =>
            'Defines whether the free time field number 2 is optional or not.',
        'Define se o campo de tempo livre 2 é opcional ou obrigatório' =>
            'Defines whether the free time field number 3 is optional or not.',
        'Define se o campo de tempo livre 3 é opcional ou obrigatório' =>
            'Defines whether the free time field number 4 is optional or not.',
        'Define se o campo de tempo livre 4 é opcional ou obrigatório' =>
            'Defines whether the free time field number 5 is optional or not.',
        'Define se o campo de tempo livre 5 é opcional ou obrigatório' =>
            'Defines whether the free time field number 6 is optional or not.',
        'Define se o campo de tempo livre 6 é opcional ou obrigatório' =>
            'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.',
        'Define se o proprietário do ticket pode ser selecionado pelo agente' =>
            'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.',
        'Define se é necessário o bloqueio para proprietário do ticket no ecrãn de Prioridades do ticket no interface de agente (Se o ticket não estiver bloqueado, o ticket é bloqueado ao utilizador atual).' =>
            'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Define se é necessário o bloqueio para proprietário do ticket no ecrãn de alteração de cliente do ticket no interface de agente (Se o ticket não estiver bloqueado, o ticket é bloqueado ao utilizador atual).' =>
            'Defines if composed messages have to be spell checked in the agent interface.',
        'Define se é necessário o bloqueio para proprietário do ticket no ecrãn de campos de texto livre do ticket no interface de agente (Se o ticket não estiver bloqueado, o ticket é bloqueado ao utilizador atual).' =>
            'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Define se é necessário o bloqueio para proprietário do ticket no ecrãn de composição do ticket no interface de agente (Se o ticket não estiver bloqueado, o ticket é bloqueado ao utilizador atual).' =>
            'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Define se é necessário o bloqueio para proprietário do ticket no ecrãn de criação de tickets por telefone no interface de agente (Se o ticket não estiver bloqueado, o ticket é bloqueado ao utilizador atual).' =>
            'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Define se é necessário o bloqueio para proprietário do ticket no ecrãn de encaminhamento do ticket no interface de agente (Se o ticket não estiver bloqueado, o ticket é bloqueado ao utilizador atual).' =>
            'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Define se é necessário o bloqueio para proprietário do ticket no ecrãn de fecho do ticket no interface de agente (Se o ticket não estiver bloqueado, o ticket é bloqueado ao utilizador atual).' =>
            'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Define se é necessário o bloqueio para proprietário do ticket no ecrãn de fusão de tickets no interface de agente (Se o ticket não estiver bloqueado, o ticket é bloqueado ao utilizador atual).' =>
            'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Define se é necessário o bloqueio para proprietário do ticket no ecrãn de notas do ticket no interface de agente (Se o ticket não estiver bloqueado, o ticket é bloqueado ao utilizador atual).' =>
            'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Define se é necessário o bloqueio para proprietário do ticket no ecrãn de pendentes do ticket no interface de agente (Se o ticket não estiver bloqueado, o ticket é bloqueado ao utilizador atual).' =>
            'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Define se é necessário o bloqueio para proprietário do ticket no ecrãn de proprietário do ticket no interface de agente (Se o ticket não estiver bloqueado, o ticket é bloqueado ao utilizador atual).' =>
            'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Define se é necessário o bloqueio para proprietário do ticket no ecrãn de recusa do ticket no interface de agente (Se o ticket não estiver bloqueado, o ticket é bloqueado ao utilizador atual).' =>
            'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Define se é necessário o bloqueio para proprietário do ticket no ecrãn de responsável do ticket no interface de agente (Se o ticket não estiver bloqueado, o ticket é bloqueado ao utilizador atual).' =>
            'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Define todos os parametros para este item nas preferencias de cliente' =>
            'Defines all the possible stats output formats.',
        'Define todos os parametros para o objeto RefreshTime nas preferencias de cliente' =>
            'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.',
        'Define todos os parametros para o objeto ShownTickets nas preferencias de cliente' =>
            'Defines all the parameters for this item in the customer preferences.',
        'Define todos os possíveis formatos de saída de estatísticas' =>
            'Defines an alternate URL, where the login link refers to.',
        'Define um URL alternativo, ao referenciado no link de login' => 'Defines an alternate URL, where the logout link refers to.',
        'Define um URL alternativo, ao referenciado no link de saída' =>
            'Defines an alternate login URL for the customer panel..',
        'Define um URL de login alternativo para a áre a de cliente' => 'Defines an alternate logout URL for the customer panel.',
        'Define um URL de logout alternativo para a áre a de cliente' =>
            'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').',
        'Define um filtro html para adicionar links a números CVE. O elemento Image permite dois tipos de entradas.Inicialmente o nome da imagem (ex. faq.png). O caminho de imagens dos OTRS será utilizado. A segunda hipótese é inserir um link na imagem.' =>
            'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.',
        'Define um filtro html para adicionar links a números MSBulletin. O elemento Image permite dois tipos de entradas.Inicialmente o nome da imagem (ex. faq.png). O caminho de imagens dos OTRS será utilizado. A segunda hipótese é inserir um link na imagem.' =>
            'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.',
        'Define um filtro html para adicionar links a números bugtraq. O elemento Image permite dois tipos de entradas.Inicialmente o nome da imagem (ex. faq.png). O caminho de imagens dos OTRS será utilizado. A segunda hipótese é inserir um link na imagem.' =>
            'Defines a filter to process the text in the articles, in order to highlight predefined keywords.',
        'Define um filtro html para adicionar links a textos. O elemento Image permite dois tipos de entradas.Inicialmente o nome da imagem (ex. faq.png). O caminho de imagens dos OTRS será utilizado. A segunda hipótese é inserir um link na imagem.' =>
            'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.',
        'Define um filtro para o resultado do HTML para adicionar links a um determinado texto. O elemento Image permite dois tipos de entradas.Inicialmente o nome da imagem (ex. faq.png). O caminho de imagens dos OTRS será utilizado. A segunda hipótese é inserir um link na imagem.' =>
            'Define the start day of the week for the date picker.',
        'Define um filtro para processar texto nos artigos, para destacar palavras pré-definidas.' =>
            'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").',
        'Define um item de cliente, que gera um mapa google no fim do bloco de informação do cliente' =>
            'Defines a default list of words, that are ignored by the spell checker.',
        'Define um item de cliente, que gera um ícone LinkedIn no fim do bloco de informação do cliente' =>
            'Defines a customer item, which generates a XING icon at the end of a customer info block.',
        'Define um item de cliente, que gera um ícone XING no fim do bloco de informação do cliente' =>
            'Defines a customer item, which generates a google icon at the end of a customer info block.',
        'Define um item de cliente, que gera um ícone google no fim do bloco de informação do cliente' =>
            'Defines a customer item, which generates a google maps icon at the end of a customer info block.',
        'Define um link externo para a base de dados do cliente (ex. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' ou \'\').' =>
            'Defines how the From field from the emails (sent from answers and email tickets) should look like.',
        'Define uma expresaão regular que exclui endereços da verificação de sintaxe (se "CheckEmailAddresses" for "Sim"). Introduza a expressaõ regular para endereços de email, que não são sintaticamente válidos, mas são necessários para os istema but are necessary for the system (i.e. "root@localhost").' =>
            'Defines a regular expression that filters all email addresses that should not be used in the application.',
        'Defines o CSS por omissão utilizado nos editores rtf' => 'Defines the default body of a note in the ticket free text screen of the agent interface.',
        'Definir como sim se confiar em todas as chaves privadas e públicas pgp, mesmo que não estejam certificadas com uma assinatura de confiança (ex. auto assinadas)' =>
            'Sets if ticket owner must be selected by the agent.',
        'Delete this ticket!' => 'Remover ticket!',
        'Depende na sua instalação o numero de dynamic objects que pode usar' =>
            '(Note: Useful for big databases and low performance server)',
        'Desativa o envio de notificações para o responsável do ticket (Ticket::Responsible necessita de estar ativo)' =>
            'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box (to avoid the use of destructive queries, such as DROP DATABASE, and also to steal user passwords).',
        'Desativa o instalador web (http://yourhost.example.com/otrs/installer.pl), para impedir o sistema de ser invadido. Se for "Não"  o sistema pode ser re-instalado e a configuração base será carregada para base de dados. Se inativa, desabilita também o GenericAgent, PackageManager e comandos SQL (para evitar comandos como  DROP DATABASE, e roubar passwords de utilizadores ).' =>
            'Displays the accounted time for an article in the ticket zoom view.',
        'Desbloquear Tickets' => 'Unsubscribe',
        'Descarrega os pacotes via proxy, Re-escreve "WebUserAgent::Proxy".' =>
            'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.',
        'Descarregar Configuração' => 'Download all system config changes.',
        'Descarregar todas as alterações da configuração do sistema.' =>
            'Drop Database',
        'Descartar todas as modificações e retornar para o ecrã de composição' =>
            'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.',
        'Deseja realmente remover este Objeto?' => 'Do you really want to reinstall this package (all manual changes get lost)?',
        'Desempenho' => 'Bounce ticket',
        'Despachar ou filtrar mensagens recebidas de acordo com os seus Cabeçalhos-X! Pode-se usar expressões regulares.' =>
            'Do you really want to delete this Object?',
        'Desta forma pode alterar directamente o keyring configurado no Kernel/Config.pm' =>
            'Incident',
        'Destinatários' => 'Refresh',
        'DetalhesDoTicket' => 'Ticket\#',
        'Determina a forma como os objetos ligados são mostrados em cada vista de detalhe' =>
            'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.',
        'Determina as opções de remetentes válidas (ticket por telefone) no interface de agente' =>
            'Determines which queues will be valid for ticket\'s recepients in the customer interface.',
        'Determina o próximo ecrã após a criação de um ticket no interface de cliente' =>
            'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.',
        'Determina o próximo ecrã após uma atualização de ticket no interface de agente' =>
            'Determines the possible states for pending tickets that changed state after reaching time limit.',
        'Determina os possíveis estados para tickets pendentes após ' =>
            'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.',
        'Determina os próximos estados possíveis, após a criação de um ticket por email no interface de agente' =>
            'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.',
        'Determina os próximos estados possíveis, após a criação de um ticket por telefone no interface de agente' =>
            'Determines the next screen after new customer ticket in the customer interface.',
        'Determina os textos que serão mostrados como destinatários (To:) do ticket por telefone e como remetentes (From:) do email no interface de agente.Para filas como  NewQueueSelectionType "<Queue>" mostra os nomes das filas e SystemAddress "<Realname> <<Email>>" mostra o nome e email.' =>
            'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.',
        'Determina os textos que serão mostrados no destinatário (To:) do ticket no interface do cliente. Para Queue como CustomerPanelSelectionType, "<Queue>" mostra os nomes das filas, e para SystemAddress, "<Realname> <<Email>>" mostra o nome e email.' =>
            'Determines the way the linked objects are displayed in each zoom mask.',
        'Determina que filas são válidas para abertura de tickets no interface de cliente' =>
            'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be ativated).',
        'Determina se a lista de possíveis filas para mover o ticket deve ser mostrada numa combobox ou numa nova janela no interface de agente. Se for "Nova Janela" pode adicionar uma nova ao ticket.' =>
            'Determines if the search results container for the autocomplete feature should adjust its width dynamically.',
        'Determina se o módulo de estatísticas podem gerar listas de tickets' =>
            'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.',
        'Determina se os resultados de pesquisa em autocomplete devem ajustar a largura automaticamente' =>
            'Determines if the statatistics module may generate ticket lists.',
        'Deverá selecionar dois ou mais atributos dos campos slectionaveis' =>
            'You need a email address (e. g. customer@example.com) in To:!',
        'Devolver ticket' => 'Can\'t update password, invalid characters!',
        'Dia Ano Novo' => 'International Workers\' Day',
        'Dia do trabalhador' => 'Christmas Eve',
        'Dianostica as traduções. Se estiver definido com "Sim" todos os textos sem tradução são mostrados em STDERR. Útil para a criaçãod e novas localizações.' =>
            'Default ACL values for ticket actions.',
        'Dividir' => 'State Type',
        'Divirta-se!' => 'Here you can insert a description of the stat.',
        'Don\'t forget to add a new response a queue!' => 'Não se esqueça de adicionar a nova resposta a uma fila!',
        'Don\'t work with UserID 1 (System account)! Create new users!' =>
            'Não trabalhe com o UserID 1 (Conta de sistema)! Crie novos utilizadores!',
        'Editar Artigo' => 'Escalation - First Response Time',
        'Eliminar base de dados antiga' => 'Detail',
        'Endereço de Correio Electrónico do Administrador' => 'Admin-Password',
        'Endereço do Sistema' => 'The message being composed has been closed.  Exiting.',
        'Endereços de email' => 'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.',
        'Entrada falhou! Ou o nome de utilizador ou a palavra-passe foram introduzidos incorrectamente.' =>
            'Lookup',
        'Envia notificações apenas ao agente proprietário do ticket, se o ticket estiver desbloqueado(por omissão é enviada a todos os agentes)' =>
            'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.',
        'Envia notificações configuradas no interface de administração em "Notificações (Eventos)"' =>
            'Set sender email addresses for this system.',
        'Envia notificações de aviso de tickets desbloqueados, quando é atingido o tempo limite (apenas é enviado ao proprietário).' =>
            'Sends the notifications which are configured in the admin interface under "Notfication (Event)".',
        'Envia notificações de cliente apenas ao cliente mapeado. Normalmente, se não existirem clientes mapeados, o último remetente de cliente recebe a notificação' =>
            'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).',
        'Envia todos os emails de saída com bcc para um endereço de email. Utilize esta funcionalAntiguidade apenas como backup ' =>
            'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.',
        'Enviar notificação' => 'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.',
        'Enviar notificação aos utilizadores' => 'Send ticket follow up notifications',
        'Enviar notificações de atualização' => 'Sender type for new tickets from the customer inteface.',
        'Enviar-me notificação se o cliente enviar uma atualização e for proprietário do ticket ou o ticket estiver desbloqueado e estiver numa das minhas filas' =>
            'Send notifications to users.',
        'Escalamento de tickets!' => 'Ticket locked!',
        'Especifica a cor de borda do gráfico' => 'Specifies the border color of the legend.',
        'Especifica a cor de broda da legenda ' => 'Specifies the bottom margin of the chart.',
        'Especifica a cor de fundo da imagem' => 'Specifies the border color of the chart.',
        'Especifica a cor de fundo do gráfico' => 'Specifies the background color of the picture.',
        'Especifica a cor do gráfico (ex: titulo)' => 'Specifies the text color of the legend.',
        'Especifica a cor do texto da legenda' => 'Specifies the text that should appear in the log file to denote a CGI script entry.',
        'Especifica a margem de baixo do gráfico' => 'Specifies the different article types that will be used in the system.',
        'Especifica a margem de topo do gráfico' => 'Specifies user id of the postmaster data base.',
        'Especifica a margem direita do gráfico' => 'Specifies the text color of the chart (e. g. caption).',
        'Especifica a margem esqueda do gráfico' => 'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.',
        'Especifica a pasta onde os certificados SSL privados são guardados.' =>
            'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.',
        'Especifica a pasta onde os certificados SSL são guardados.' => 'Specifies the directory where private SSL certificates are stored.',
        'Especifica a pasta para guarda os dados, se for selecionado "FS" em TicketStorageModule' =>
            'Specifies the directory where SSL certificates are stored.',
        'Especifica o caminho do conversor que permite visualizar PDFs no interface web' =>
            'Specifies the path to the converter that allows the view of XML files, in the web interface.',
        'Especifica o caminho do conversor que permite visualizar ficheiros Microsoft Excel no interface web' =>
            'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.',
        'Especifica o caminho do conversor que permite visualizar ficheiros Microsoft Word no interface web' =>
            'Specifies the path to the converter that allows the view of PDF documents, in the web interface.',
        'Especifica o caminho do conversor que permite visualizar ficheiros XML no interface web' =>
            'Specifies the right margin of the chart.',
        'Especifica o caminho do ficheiro com o logotipo utilizado (gif|jpg|png, 700 x 100 pixels)' =>
            'Specifies the path of the file for the performance log.',
        'Especifica o caminho do ficheiro para o log de desempenho' => 'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.',
        'Especifica o email a ser usado pela aplicação para enviar notificações. O endereço de email é usado para construir o nome completo nas notificações (ex. "OTRS Notification Master" otrs@your.example.com). Pode utilizar a variável OTRS_CONFIG_FQDN da configuração, ou escolher outro enderço de email. Notificações são mensagens como en::Customer::QueueUpdate ou en::Agent::Move.' =>
            'Specifies the left margin of the chart.',
        'Especifica o nome a ser usado nas notificações de sistema. O nome do remetente é utilizado para construir o nome completo (ex. "OTRS Notification Master" otrs@your.example.com). Notificações são mensagens como en::Customer::QueueUpdate ou en::Agent::Move.' =>
            'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).',
        'Especifica o texto que deve aparecer no ficheiro de log para scripts CGI' =>
            'Specifies the top margin of the chart.',
        'Especifica o user id da base de dados postmaster' => 'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.',
        'Especifica os diferentes tipos de artigos que vão ser usados no sistema' =>
            'Specifies the different note types that will be used in the system.',
        'Especifica os diferentes tipos de notas utilizados no sistema' =>
            'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.',
        'Especifica se o agente deve receber um email com as suas ações' =>
            'Specifies the background color of the chart.',
        'Esta janela deve ser chamada da janela de composição' => 'Ticket %s locked.',
        'Estado Tipo' => 'Stats-Area',
        'Estado de Cliente Notificado' => 'Customer User',
        'Estado do Sistema' => 'Systemaddress',
        'Estatísticas' => 'Status view',
        'Estes valores são apenas de leitura.' => 'These values are required.',
        'Estes valores são obrigatórios.' => 'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.',
        'Executa o sistema em modo de demonstração. Se for "Sim", os agentes podem alterar as preferências,tais como seleção de idioma e tema via. As alterações são apenas válidas na sessão. Não é possível aos agentes alterar as passwords.' =>
            'S/MIME Certificate Upload',
        'Executa uma pesquisa com operadores wildcard dos vários utilizadores de cliente no acesso ao módulo AdminCustomerUser' =>
            'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.',
        'Executar comandos SQL.' => 'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.',
        'Exemplo de CMD. Ignora emails em que o comando externo CMD retorne dados para STDOUT (o email vai ser direcionado para STDIN de um bin)' =>
            'Change password',
        'Exemplo de configuração SpamAssassin. Ignora os emails marcados pelo SpamAssasin' =>
            'Spam Assassin example setup. Moves marked mails to spam queue.',
        'Exemplo de configuração SpamAssassin.Move os emails marcados para a fila de spam' =>
            'Specifies if an agent should receive email notification of his own actions.',
        'Exemplo para texto livre' => 'Execute SQL statements.',
        'Explicação' => 'Export Config',
        'Exporta a árvore completa de artigos do resultado de pesquisa (pode afetar o desempenho)' =>
            'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".',
        'Exportar configuraçao' => 'FileManager',
        'Extende a pesquisa de texto integral dos artigos (Pesquisa em From, To, Cc, Assunto e corpo do email). O motor efetuará pesquisas de texto integral em dados reais (tem um bom desempenho até 50.000 tickets). StaticDB vai tirar todos os artigos e contruir um indice após a criação do artigo, melhorando a pesquisa em texto integral em 50%. Para criar o indice inicial executar  "bin/otrs.RebuildFulltextIndex.pl".' =>
            'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.',
        'Fechar ticket' => 'Close type',
        'Fechar!' => 'Comment (internal)',
        'Ficheiro de Log' => 'Logfile too large, you need to reset it!',
        'Ficheiro de log demasiado grande, precisa de fazer reset' => 'Login failed! Your username or password was entered incorrectly.',
        'Ficheiro de log para o contador de tickets' => 'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.',
        'Ficheiro mostrado no módulo Kernel::Modules::AgentInfo, se localizado em  Kernel/Output/HTML/Standard/AgentInfo.dtl' =>
            'Filter incoming emails.',
        'Fila <-> Gestão de Respostas Automáticas' => 'Queue ID',
        'Filas <-> Respostas Automáticas' => 'Realname',
        'Filtrae entrada de email' => 'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).',
        'Filtros Postmaster' => 'PostMaster Mail Accounts',
        'Filtros do Chefe do Correio' => 'PostMaster POP3 Account',
        'Finalizar todas as sessões' => 'kill session',
        'Fonte' => 'Spell Check',
        'Forward ticket: ' => 'Encaminhar ticket',
        'Força a codificação de emails de saída (7bit|8bit|quoted-printable|base64)' =>
            'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.',
        'Força a escolha de um estado de ticket diferente do atual após a operação bloqueio. Define o estado atual como chave, e o próximo estado após o bloqueio no conteúdo.' =>
            'Forces to unlock tickets after being moved to another queue.',
        'Força a verificação de sintaxe dos endereços de email' => 'Makes the picture transparent.',
        'Força a verificação do registo MX antes de criar tickets por email ou telefone' =>
            'Makes the application check the syntax of email addresses.',
        'Força o desbloqueio de tickets após mover para outra fila' => 'Frontend language',
        'Gerador de Números de Tickets' => 'Ticket Search',
        'Gerir as chaves PGP para cifra de email' => 'Manage POP3 or IMAP accounts to fetch email from.',
        'Gerir as contas de POP3 e IMAP para descarregar emails' => 'Manage S/MIME certificates for email encryption.',
        'Gerir as sessões existentes' => 'Manage periodic tasks.',
        'Gerir as tarefas periódicos' => 'Max size (in characters) of the customer information table (phone and email) in the compose screen.',
        'Gerir os certificados S/MIM para cifra de email' => 'Manage existing sessions.',
        'Gestor de Ficheiros' => 'Filelist',
        'Gestor de pesquisas backend ' => 'Select your frontend Theme.',
        'Gestor por omissão das pesquisas backend ' => 'Search backend router.',
        'Gestão de Contas POP3' => 'Package',
        'Gestão de Correio Electrónico' => 'Mailbox',
        'Gestão de Estados do Sistema' => 'System Status',
        'Gestão de Filas' => 'Queues <-> Auto Responses',
        'Gestão de Respostas' => 'Responses <-> Attachments Management',
        'Gestão de SMIME' => 'Save Job as?',
        'Gestão de Utilizadores' => 'User will be needed to handle tickets.',
        'Gestão de Utilizadores de Cliente' => 'Customer Users',
        'Guarda o login e password na tabela de sessão na base de dados, se "DB" foi selecionado para SessionModule' =>
            'Search backend default router.',
        'Guarda os anexos nos artigos. "DB" guarda todos os dados na base de dados (não recomendado para anexos grandes). "FS" guarda os dados no sistema de ficheiros; mais rápido mas o servidor web deve ser executado com o utilizador OTRS. Pode alterar entre os dois modos, mesmo em sistemas em produção sem perca de dados.' =>
            'Saves the login and password on the session table in the database, if "DB" was selected for SessionModule.',
        'Guarda os cookies após fecho do browser' => 'Strips empty lines on the ticket preview in the queue view.',
        'Guardar Perfil de Procura como Modelo?' => 'Schedule',
        'Guardar Tarefa como?' => 'Save Search-Profile as Template?',
        'History::TicketFreeTextUpdate' => 'Atualizado: %s=%s;%s=%s;',
        'Histórico do Sistema' => 'System State Management',
        'Histórico do cliente' => 'Customer history search',
        'ID da Queue' => 'Queue Management',
        'ID da fila por omissão no sistema no interface de agente' => 'Default skin for OTRS 3.0 interface.',
        'ID de Artigo' => 'Attach',
        'ID de Ticket' => 'TicketZoom',
        'Icon de cliente que mostra os tickets abertos de cliente em bloco' =>
            'Customers <-> Groups',
        'Identificador do Ticket' => 'Ticket Lock',
        'Idioma' => 'New Year\'s Day',
        'Idioma de frontend' => 'Frontend module registration (disable company link if no company feature is used).',
        'Idioma do interface' => 'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.',
        'Idioma por Omissão' => 'Delete old database',
        'If secure mode is not ativated, ativate it via SysConfig because your application is already running.' =>
            'Se o modo seguro não está ativo, ative-o via SysConfig pois a aplicação já está em execução',
        'Ignorar artigos com o tipo de remetente de sistema (ex: auto respostas ou notificações)' =>
            'Includes article create times in the ticket search of the agent interface.',
        'Imagem' => 'Important',
        'Importante' => 'In this form you can select the basic specifications.',
        'Impossível atualizar a palavra-passe: as palavras-passe não correspondem! Tente de novo!' =>
            'Category Tree',
        'Impossível atualizar palavra-passe: caracteres inválidos!' => 'Can\'t update password, must be at least %s characters!',
        'Impossível atualizar palavra-passe: necessários pelo menos %s caracteres!' =>
            'Can\'t update password, must contain 2 lower and 2 upper characters!',
        'Impossível atualizar palavra-passe: pelo menos duas minúsculas e duas maiúsculas!' =>
            'Can\'t update password, needs at least 1 digit!',
        'Impossível atualizar palavra-passe: pelo menos um caractere!' =>
            'Can\'t update password, your new passwords do not match! Please try again!',
        'Impossível atualizar palavra-passe: pelo menos um dígito!' => 'Can\'t update password, needs at least 2 characters!',
        'Incidente' => 'Information about the Stat',
        'Incluir os tempos de criação na pesquisa de tickets no interface de agente' =>
            'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.',
        'IndexAccelerator: para escolher o módulo de backend TicketViewAccelerator. "RuntimeDB" gera a fila em tempo real a partir da tabela de tickets (sem problemas de disponibilAntiguidade até 60.000 tickets e 6.000 tickets abertos). "StaticDB" é  módulo mais poderoso, utiliza uma tabela como indice que funciona como uma vista(recomendado se existirem mais de 80.000 tickets e 6.000 tickets abertos). Para gerar o indice inicial utilizar o comando "bin/otrs.RebuildTicketIndex.pl".' =>
            'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.',
        'Informaçoes sobre estatisticas' => 'Insert of the common specifications',
        'Informação do Administrador OTRS!' => 'Of couse this feature will take some system performance it self!',
        'Inserir:' => 'Is Job Valid',
        'Inserção das especificações comuns' => 'Insert:',
        'Instalador Web' => 'WebMail',
        'Instalar ispell ou aspell no sistema para ter corretor ortográfico. Indique o caminho para os binários aspell ou ispell.' =>
            'Interface language',
        'Intervalo de atualização da vista de filas' => 'Refresh interval',
        'Início' => 'If a new hardcoded file is available this attribute will be shown and you can select one.',
        'Isto é util se nao pretende que ninguem veja os resultados de uma estatsitica ou uma estatistica nao esteja preparada e configurada' =>
            'This window must be called from compose window',
        'Isto é útil para soluções ASP.' => 'It\'s useful for a lot of users and groups.',
        'Item de barra para atalho' => 'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.',
        'Lamentamos, característica não ativa!' => 'Sort by',
        'Largura da janela de composição de emails ' => 'Permitted width for compose note windows.',
        'Largura da janela de composição de notas' => 'PostMaster Filters',
        'Lembretes' => 'Reminder messages',
        'Liga 2 tickets através de tipo de ligação "Normal" ' => 'Links 2 tickets with a "ParentChild" type link.',
        'Liga 2 tickets através de tipo de ligação "ParentChild" ' => 'List of CSS files to always be loaded for the agent interface.',
        'Liga agentes a grupos' => 'Link agents to roles.',
        'Liga agentes a papéis' => 'Link attachments to responses templates.',
        'Liga anexos a templates de resposta' => 'Link customers to groups.',
        'Liga clientes a grupos' => 'Link customers to services.',
        'Liga clientes a serviços' => 'Link queues to auto responses.',
        'Liga este ticket a outros objetos!' => 'Links 2 tickets with a "Normal" type link.',
        'Liga filas a auto respostas' => 'Link responses to queues.',
        'Liga papéis a grupos' => 'Link this ticket to other objects!',
        'Liga respostas a filas' => 'Link roles to groups.',
        'Limpar De' => 'Clear To',
        'Link this ticket to an other objects!' => 'Ligar este ticket a outros Objetos!',
        'Lista de Tarefas' => 'Keyword',
        'Lista de ficheiro CSS que são sempre carregados no interface de agente' =>
            'List of CSS files to always be loaded for the customer interface.',
        'Lista de ficheiro CSS que são sempre carregados no interface de cliente' =>
            'List of IE6-specific CSS files to always be loaded for the customer interface.',
        'Lista de ficheiros' => 'Filtername',
        'Lista de ficheiros CSS especificos  a serem sempre carregados no interface de cliente' =>
            'List of JS files to always be loaded for the agent interface.',
        'Lista de ficheiros CSS especificos para IE6 a serem sempre carregados no interface de agente' =>
            'List of IE7-specific CSS files to always be loaded for the customer interface.',
        'Lista de ficheiros CSS especificos para IE6 a serem sempre carregados no interface de cliente' =>
            'List of IE7-specific CSS files to always be loaded for the agent interface.',
        'Lista de ficheiros CSS especificos para IE7 a serem sempre carregados no interface de agente' =>
            'List of IE8-specific CSS files to always be loaded for the customer interface.',
        'Lista de ficheiros CSS especificos para IE7 a serem sempre carregados no interface de cliente' =>
            'List of IE8-specific CSS files to always be loaded for the agent interface.',
        'Lista de ficheiros JS a serem sempre carregados no interface de agente' =>
            'List of JS files to always be loaded for the customer interface.',
        'Lista de ficheiros JS a serem sempre carregados no interface de cliente' =>
            'Log file for the ticket counter.',
        'Lock it to work on it!' => 'Bloqueie o ticket para trabalhar!',
        'Maximo periodo desde' => 'new ticket',
        'Mensagem enviada para' => 'Misc',
        'Mensagem para o novo Proprietário' => 'Message sent to',
        'Mensagens com lembretes' => 'Requests:',
        'Mensagens novas' => 'New password again',
        'Mensagens pendentes' => 'Pending type',
        'Merge this ticket!' => 'Fundir este ticket a outro!',
        'Meus Tickets' => 'Name is required!',
        'Modificado' => 'Modules',
        'Modificar %s configurações' => 'Change free text of ticket',
        'Modificar a Prioridade do ticket' => 'Change responsible of ticket',
        'Modificar o proprietário do ticket' => 'Change priority of ticket',
        'Modificar users <-> configurações de grupos' => 'ChangeLog',
        'Modulo para filtrar e manipular as novas mensagens. Obter um número com 4 digítos, utilizar expressões regulares para encontrar ex. From => \'(.+?)@.+?\', e utilize () como [***] em Set =>.' =>
            'Module to generate accounted time ticket statistics.',
        'Modulo para informar os agentes através do interface web, acerca do código de página utilizado. É mostrada uma notificação se o código de página por omissão não for utilizador, ex. nos tickets.' =>
            'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).',
        'Modulo para mostrar as notificações e escalagens (ShownMax: máx. escalagens mostradas, EscalationInMinutes: Mostrar tickets que vão escalar em, CacheTime: Cache de escalagens calculados em segundos).' =>
            'Module to use database filter storage.',
        'Modulo para verificar se os novos emails devem ser marcados como internos . ArticleType e SenderType definem os valores para email/artigo.' =>
            'Module to check the agent responsible of a ticket.',
        'Mostra a lista de todos os agentes envolvidos no ticket, no ecrã de Prioridade de ticket do interface do agente' =>
            'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.',
        'Mostra a lista de todos os agentes envolvidos no ticket, no ecrã de campos de texto livre de ticket do interface do agente' =>
            'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.',
        'Mostra a lista de todos os agentes envolvidos no ticket, no ecrã de fecho de ticket do interface do agente' =>
            'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.',
        'Mostra a lista de todos os agentes envolvidos no ticket, no ecrã de notas de ticket do interface do agente' =>
            'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Mostra a lista de todos os agentes envolvidos no ticket, no ecrã de pendentes de ticket do interface do agente' =>
            'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Mostra a lista de todos os agentes envolvidos no ticket, no ecrã de proprietário de ticket do interface do agente' =>
            'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Mostra a lista de todos os agentes envolvidos no ticket, no ecrã de responsável de ticket do interface do agente' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.',
        'Mostra a mensagem do dia (MOTD) no dashboard do agente. "Group" é utilizado para restringir o acesso ao plugin (ex. Group: admin;group1;group2;). "Default" indica se o plugin está ativo por omissão ou se necessita de ser ativado manualmente.' =>
            'Shows the message of the day on login screen of the agent interface.',
        'Mostra a mensagem do dia no ecrã de login do interface do agente' =>
            'Shows the ticket history (reverse ordered) in the agent interface.',
        'Mostra a seleção de responsável em tickets por email e telefone no interface de agente' =>
            'Show article as rich text even if rich text writing is disabled.',
        'Mostra a seleção do proprietário nos tickets por email e por telefone no interface de agente' =>
            'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.',
        'Mostra artigos ordenados de forma ascendente ou descendente, no detalhe do ticket no interface de agente' =>
            'Shows the customer user information (phone and email) in the compose screen.',
        'Mostra as listas de filas pai/filho do sistema sob a forma de árvore ou lista' =>
            'Shows the ativated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).',
        'Mostra as opções de Prioridade no ecrã de Prioridade de ticket do interface de agente' =>
            'Shows the ticket priority options in the ticket responsible screen of the agent interface.',
        'Mostra as opções de Prioridade no ecrã de campos de texto livre de ticket do interface de agente' =>
            'Shows the ticket priority options in the ticket note screen of the agent interface.',
        'Mostra as opções de Prioridade no ecrã de fecho de ticket do interface de agente' =>
            'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Mostra as opções de Prioridade no ecrã de mover tickets do interface de agente' =>
            'Shows the ticket priority options in the ticket bulk screen of the agent interface.',
        'Mostra as opções de Prioridade no ecrã de notas de ticket do interface de agente' =>
            'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Mostra as opções de Prioridade no ecrã de operações em bloco de tickets do interface de agente' =>
            'Shows the ticket priority options in the ticket free text screen of the agent interface.',
        'Mostra as opções de Prioridade no ecrã de responsável de ticket do interface de agente' =>
            'Shows the title fields in the close ticket screen of the agent interface.',
        'Mostra as opções de Prioridade no ecrã de tickets pendentes do interface de agente' =>
            'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Mostra as opções de campos de texto livre de artigo no ecrã de detalhe do ticket no interface de agente. Opções possíveis : 0 = inativo, 1 = ativo, 2 = ativo e obrigatório.' =>
            'Article free text options shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Mostra as opções de campos de texto livre de artigo no ecrã de mensagem do ticket no interface de cliente. Opções possíveis : 0 = inativo, 1 = ativo, 2 = ativo e obrigatório.' =>
            'Article free text options shown in the ticket owner screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Mostra as opções de campos de texto livre de artigo no ecrã de proprietário do ticket no interface de cliente. Opções possíveis : 0 = inativo, 1 = ativo, 2 = ativo e obrigatório.' =>
            'Article free text options shown in the ticket pending screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Mostra as opções de campos de texto livre de artigo no ecrã de responsável do ticket no interface de agente. Opções possíveis : 0 = inativo, 1 = ativo, 2 = ativo e obrigatório.' =>
            'Attachments <-> Responses',
        'Mostra as opções de campos de texto livre de artigo no ecrã de tickets por telefone no interface de agente. Opções possíveis : 0 = inativo, 1 = ativo, 2 = ativo e obrigatório.' =>
            'Article free text options shown in the ticket priority screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Mostra as opções de campos de texto livre no ecrã de campos de texto livre de artigo no interface de agente. Opções possíveis : 0 = inativo, 1 = ativo, 2 = ativo e obrigatório.' =>
            'Article free text options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the artigo zoom of the customer interface, you have to enable them in CustomerTicketZoom###AttributesView.',
        'Mostra as opções de campos de texto livre no ecrã de composição de artigo no interface de agente. Opções possíveis : 0 = inativo, 1 = ativo, 2 = ativo e obrigatório.' =>
            'Article free text options shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Mostra as opções de campos de texto livre no ecrã de criação de artigo no interface de agente. Opções possíveis : 0 = inativo, 1 = ativo, 2 = ativo e obrigatório.' =>
            'Article free text options shown in the phone ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Mostra as opções de campos de texto livre no ecrã de criação de artigo por email no interface de agente. Opções possíveis : 0 = inativo, 1 = ativo, 2 = ativo e obrigatório.' =>
            'Article free text options shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Mostra as opções de campos de texto livre no ecrã de fecho de artigo no interface de agente. Opções possíveis : 0 = inativo, 1 = ativo, 2 = ativo e obrigatório.' =>
            'Article free text options shown in the email ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Mostra as opções de campos de texto livre no ecrã de mensagem de ticket no interface de cliente. Opções possíveis : 0 = inativo, 1 = ativo, 2 = ativo e obrigatório.' =>
            'Article free text options shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Mostra informação sobre o utilizador de cliente (telefone e email) na janela de composição' =>
            'Shows the customer user\'s info in the ticket zoom view.',
        'Mostra informação sobre o utilizador do cliente no detalhe do ticket.' =>
            'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.',
        'Mostra o agente responsável do ticket no ecrã de Prioridade de ticket no interface de agente' =>
            'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.',
        'Mostra o agente responsável do ticket no ecrã de campos de texto livre no interface de agente' =>
            'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.',
        'Mostra o agente responsável do ticket no ecrã de fecho de ticket no interface de agente' =>
            'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.',
        'Mostra o agente responsável do ticket no ecrã de notas de ticket no interface de agente' =>
            'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Mostra o agente responsável do ticket no ecrã de operações em bloco de ticket no interface de agente' =>
            'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.',
        'Mostra o agente responsável do ticket no ecrã de pendentes de ticket no interface de agente' =>
            'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Mostra o agente responsável do ticket no ecrã de proprietário de ticket no interface de agente' =>
            'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Mostra o agente responsável do ticket no ecrã de responsável de ticket no interface de agente' =>
            'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be ativated).',
        'Mostra o artigo como rtf mesmo que a escrita rtf esteja inativa' =>
            'Shows a count of icons in the ticket zoom, if the article has attachments.',
        'Mostra o histórico de tickets de cliente em AgentTicketPhone, AgentTicketEmail e AgentTicketCustomer' =>
            'Shows either the last customer article\'s subject or the ticket title in the small format overview.',
        'Mostra o histórico do ticket (ordem inversa) no interface de agente' =>
            'Shows the ticket priority options in the close ticket screen of the agent interface.',
        'Mostra o proprietário no ecrã de Prioridade de ticket no interface de agente' =>
            'Sets the ticket owner in the ticket responsible screen of the agent interface.',
        'Mostra o proprietário no ecrã de campos de texto livre no interface de agente' =>
            'Sets the ticket owner in the ticket note screen of the agent interface.',
        'Mostra o proprietário no ecrã de fecho de ticket no interface de agente' =>
            'Sets the ticket owner in the ticket bulk screen of the agent interface.',
        'Mostra o proprietário no ecrã de notas de ticket no interface de agente' =>
            'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Mostra o proprietário no ecrã de operações em bloco de ticket no interface de agente' =>
            'Sets the ticket owner in the ticket free text screen of the agent interface.',
        'Mostra o proprietário no ecrã de proprietário de ticket no interface de agente' =>
            'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Mostra o proprietário no ecrã de responsável de ticket no interface de agente' =>
            'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be ativated).',
        'Mostra o proprietário no ecrã de tickets pendentes no interface de agente' =>
            'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Mostra o serviço no ecrã de Prioridade de ticket (necessita de ativar Ticket::Service)' =>
            'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be ativated).',
        'Mostra o serviço no ecrã de campos de texto livre de ticket (necessita de ativar Ticket::Service)' =>
            'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be ativated).',
        'Mostra o serviço no ecrã de fecho de ticket (necessita de ativar Ticket::Service)' =>
            'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be ativated).',
        'Mostra o serviço no ecrã de notas de ticket (necessita de ativar Ticket::Service)' =>
            'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be ativated).',
        'Mostra o serviço no ecrã de pendentes de ticket (necessita de ativar Ticket::Service)' =>
            'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be ativated).',
        'Mostra o serviço no ecrã de proprietário de ticket (necessita de ativar Ticket::Service)' =>
            'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be ativated).',
        'Mostra o serviço no ecrã de responsável de ticket (necessita de ativar Ticket::Service)' =>
            'Sets the size of the statistic graph.',
        'Mostra o tempo com descrição completa (dias, horas, minutos) se for "Sim", ou apenas a primeira letra (d, h,m ) se for "Não"' =>
            'Skin',
        'Mostra o tempo contabilizado para o artigo na vista de detalhe do ticket' =>
            'Email Addresses',
        'Mostra o tempo em formato longo (dias, horas, minutos) se for "Sim"; ou em formato curto (dias, horas) se for "Não"' =>
            'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".',
        'Mostra o tipo de ticket no ecrã de Prioridade de ticket do interface de agente' =>
            'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be ativated).',
        'Mostra o tipo de ticket no ecrã de campos de texto livre de ticket do interface de agente' =>
            'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be ativated).',
        'Mostra o tipo de ticket no ecrã de fecho de ticket do interface de agente' =>
            'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be ativated).',
        'Mostra o tipo de ticket no ecrã de notas de ticket do interface de agente' =>
            'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be ativated).',
        'Mostra o tipo de ticket no ecrã de pendentes de ticket do interface de agente' =>
            'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be ativated).',
        'Mostra o tipo de ticket no ecrã de proprietário de ticket do interface de agente' =>
            'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be ativated).',
        'Mostra o tipo de ticket no ecrã de responsável de ticket do interface de agente' =>
            'Sets the time type which should be shown.',
        'Mostra o titulo do último artigo de cliente ou o title do tícket na vista pequena' =>
            'Shows existing parent/child queue lists in the system in the form of a tree or a list.',
        'Mostra os atributos ativos no interface de cliente (0 = Inativo e 1 = ativo)' =>
            'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.',
        'Mostra os campos de título no ecrã de Prioridade de ticket no interface de agente' =>
            'Shows the title fields in the ticket responsible screen of the agent interface.',
        'Mostra os campos de título no ecrã de campos de texto livre de ticket no interface de agente' =>
            'Shows the title fields in the ticket note screen of the agent interface.',
        'Mostra os campos de título no ecrã de fecho de tickets no interface de agente' =>
            'Shows the title fields in the ticket free text screen of the agent interface.',
        'Mostra os campos de título no ecrã de notas de ticket no interface de agente' =>
            'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Mostra os campos de título no ecrã de proprietário de ticket no interface de agente' =>
            'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Mostra os campos de título no ecrã de responsável de ticket no interface de agente' =>
            'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".',
        'Mostra os campos de título no ecrã de tickets pendentes  no interface de agente' =>
            'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Mostra todos os artigos do ticket (expandido) na vista de detalhe' =>
            'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).',
        'Mostra todos os identificadores de cliente num campo de multi seleção' =>
            'Shows an owner selection in phone and email tickets in the agent interface.',
        'Mostra todos os tickets em aberto (mesmo qeu bloqueados) na vista de escalagem no interface de agente' =>
            'Shows all open tickets (even if they are locked) in the status view of the agent interface.',
        'Mostra todos os tickets em aberto (mesmo qeu bloqueados) na vista de estado no interface de agente' =>
            'Shows all the articles of the ticket (expanded) in the zoom view.',
        'Mostra um contador de icons no detalhe de ticket, se o artigo tiver anexos' =>
            'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.',
        'Mostra um link no menu do dashboard para ver o detalhe do ticket no interface de agente' =>
            'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.',
        'Mostra um link no menu na vista de detalhe para adicionar m campo de texto livre ao ticket no interface de agente' =>
            'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.',
        'Mostra um link no menu na vista de detalhe para adicionar uma nota ao ticket no interface de agente' =>
            'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.',
        'Mostra um link no menu na vista de detalhe para apagar um ticket no interface de agente. Controlo de acesso adicional para mostrar este link é realizado na Chave "Group" e Conteúdo como "rw:group1;move_into:group2".' =>
            'Shows a link in the menu to go back in the ticket zoom view of the agent interface.',
        'Mostra um link no menu na vista de detalhe para bloquear/desbloquear um ticket no interface de agente' =>
            'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.',
        'Mostra um link no menu na vista de detalhe para colocar a pendencia no ticket no interface de agente' =>
            'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".',
        'Mostra um link no menu na vista de detalhe para definir a Prioridade do ticket no interface de agente' =>
            'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.',
        'Mostra um link no menu na vista de detalhe para fechar um ticket no interface de agente' =>
            'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".',
        'Mostra um link no menu na vista de detalhe para fundir dois tickets no interface de agente' =>
            'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.',
        'Mostra um link no menu na vista de detalhe para imprimir um ticket no interface de agente' =>
            'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.',
        'Mostra um link no menu na vista de detalhe para ligar dois tickets no interface de agente' =>
            'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.',
        'Mostra um link no menu na vista de detalhe para marcar um ticket como spam no interface de agente.Controlo de acesso adicional para mostrar este link é realizado na Chave "Group" e Conteúdo como "rw:group1;move_into:group2".' =>
            'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.',
        'Mostra um link no menu na vista de detalhe para mover um ticket no interface de agente' =>
            'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.',
        'Mostra um link no menu na vista de detalhe para saceder ao histórico de ticket no interface de agente' =>
            'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.',
        'Mostra um link no menu na vista de detalhe para subscrever/cancelar um ticket no interface de agente' =>
            'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.',
        'Mostra um link no menu na vista de detalhe para ver a Prioridade do ticket no interface de agente' =>
            'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.',
        'Mostra um link no menu na vista de detalhe para ver o histórico do ticket no interface de agente' =>
            'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.',
        'Mostra um link no menu na vista de detalhe para ver o proprietário do ticket no interface de agente' =>
            'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.',
        'Mostra um link no menu na vista de detalhe para ver o responsável do ticket no interface de agente' =>
            'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.',
        'Mostra um link no menu na vista de detalhe para visualizar o cliente do ticket no interface de agente' =>
            'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.',
        'Mostra um link no menu na vista de detalhe para voltar à página anterior no interface de agente' =>
            'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.',
        'Mostra um link no menu para adicionar uma nota a um ticket no interface de agente' =>
            'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.',
        'Mostra um link para aos anexos do artigo via o visualizador html na vista de detalhe no interface do agente' =>
            'Shows a link to download article attachments in the zoom view of the article in the agent interface.',
        'Mostra um link para descarregar anexos na vista de detalhe do artigo no interface de agente' =>
            'Shows a link to see a zoomed email ticket in plain text.',
        'Mostra um link para marcar um ticket como spam na vista de detalhe do ticket no interface de agente. Controlo de acesso adicional para mostrar este link é realizado na Chave "Group" e Conteúdo como "rw:group1;move_into:group2".' =>
            'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.',
        'Mostra um link para ver o email em texto simples' => 'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".',
        'Mostra uma lista dos agentes possíveis (com permissões de nota na fila/ticket) para determinar o que vai ser informado acerca da nota, no ecrã de Prioridade de tickets no interface de agente.' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.',
        'Mostra uma lista dos agentes possíveis (com permissões de nota na fila/ticket) para determinar o que vai ser informado acerca da nota, no ecrã de campos de texto livre de tickets no interface de agente.' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.',
        'Mostra uma lista dos agentes possíveis (com permissões de nota na fila/ticket) para determinar o que vai ser informado acerca da nota, no ecrã de fecho de tickets no interface de agente.' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.',
        'Mostra uma lista dos agentes possíveis (com permissões de nota na fila/ticket) para determinar o que vai ser informado acerca da nota, no ecrã de notas de tickets no interface de agente.' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Mostra uma lista dos agentes possíveis (com permissões de nota na fila/ticket) para determinar o que vai ser informado acerca da nota, no ecrã de pendentes de ticket no interface de agente.' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Mostra uma lista dos agentes possíveis (com permissões de nota na fila/ticket) para determinar o que vai ser informado acerca da nota, no ecrã de proprietário de ticket no interface de agente.' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Mostra uma lista dos agentes possíveis (com permissões de nota na fila/ticket) para determinar o que vai ser informado acerca da nota, no ecrã de responsável de tickets no interface de agente.' =>
            'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).',
        'Mostra uma previsão do ticket (CustomerInfo => 1 - mostra também Customer-Info, CustomerInfoMaxSize tamanho máximo de caraterees da Customer-Info)' =>
            'Shows all both ro and rw queues in the queue view.',
        'Mostrar' => 'Site',
        'Mostrar as filas com ambas as permissões ro e rw na lista de filas' =>
            'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.',
        'Movimento de Cliente Notificado' => 'Customer Owner Notify',
        'Mudança de Log' => 'Child-Object',
        'Mudar responsavel do ticket' => 'Change user <-> group settings',
        'Multiplas selecçoes do formato de output' => 'Multiplier:',
        'Multiplicador:' => 'MyTickets',
        'Máximo de auto respostas por email ao remetente por dia (Proteção de ciclos)' =>
            'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).',
        'Máximo de tickets mostrados' => 'Maximal auto email responses to own email-address a day (Loop-Protection).',
        'Módulo de auto registo no frontend (Desativa o link da empresa se não forem utilizadas companhias)' =>
            'Frontend module registration for the agent interface.',
        'Módulo de auto registo no interface de agente' => 'Frontend module registration for the customer interface.',
        'Módulo de auto registo no interface de cliente' => 'Frontend theme',
        'Módulo de registo de eventos. Para melhorar o desempenho pode definir um evento (ex. Event => TicketCreate). Isto é possível apenas se todos os elementos TicketFreeField necessitam do mesmo evento.' =>
            'Example for free text',
        'Módulo para cifrar mensagens  (PGP ou S/MIME)' => 'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.',
        'Módulo para escrever mensagens assinados (PGP ou S/MIME)' => 'Module to crypt composed messages (PGP or S/MIME).',
        'Módulo para filtrar e manipular novas mensange. Bloquear ou ignorar todo o spam com endereço From: noreply@' =>
            'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.',
        'Módulo para gerar estatísticas de tempos de solução e resposta de tickets' =>
            'Module to generate ticket statistics.',
        'Módulo para gerar estatísticas de tickets' => 'Module to inform agents, via the agent interface, about the used charset. A notification is displayed, if the default charset is not used, e.g. in tickets.',
        'Módulo para gerar resultado html de pesquisas de tickets em OpenSearch no interface de agente' =>
            'Module to generate html OpenSearch profile for short ticket search in the customer interface.',
        'Módulo para gerar resultado html de pesquisas de tickets em OpenSearch no interface de cliente' =>
            'Module to generate ticket solution and response time statistics.',
        'Módulo para gerar tempo contabilizado nas estatísticas de tickets' =>
            'Module to generate html OpenSearch profile for short ticket search in the agent interface.',
        'Módulo para seleção de To no ecrã de tickets no interface de cliente' =>
            'Module to check customer permissions.',
        'Módulo para utilizar base de dados para guardar filtros' => 'My Tickets',
        'Módulo para verificar as permissões de cliente' => 'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.',
        'Módulo para verificar as permissões de grupo para acesso aos tickets de cliente' =>
            'Module to check the owner of a ticket.',
        'Módulo para verificar o proprietário do ticket' => 'Module to check the watcher agents of a ticket.',
        'Módulo para verificar o responsável do ticket' => 'Module to check the group permissions for the access to customer tickets.',
        'Módulo para verificar os agentes com vigilância a um ticket' =>
            'Module to compose signed messages (PGP or S/MIME).',
        'Módulo para verificar se o utilizador pertence a um grupo especial.Acesso concedido se o utilizador pertencer a uma grupo especifico e possuir permissões de ro ou rw' =>
            'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.',
        'Módulos' => 'Move notification',
        'Nao enviar notificação' => 'Sessions',
        'Nao significa, enviar ao agent e cliente notificaçoes quando houver alterações' =>
            'No time settings.',
        'Necessária Seleção' => 'Send Notification',
        'Neste formulario pode selecionar as especificaçoes basicas' => 'In this way you can directly edit the keyring configured in Kernel/Config.pm.',
        'New TicketFreeFields' => 'Novo campo livre',
        'Next Week' => 'Próxima semana',
        'No. de Ticket' => 'Tickets shown',
        'Nome' => 'Rebuild',
        'Nome da Base de Dados OTRS' => 'OTRS DB Password',
        'Nome da fila personalizada. A fila personalizada é uma selecção das filas preferidas, escolhidas nas preferências de utilizador.' =>
            'New email ticket',
        'Nome de Utilizador do Cliente' => 'Customer User Management',
        'Nome do Filtro' => 'First Response',
        'Nota' => 'Note!',
        'Nota de Segurança: Deve Ativar o %s, pois a aplicação está já em produção!' =>
            'Select Box',
        'Nota!' => 'Notification (Customer)',
        'Notificaçao (cliente)' => 'Notifications',
        'Notificação de movimentos' => 'Multiple selection of the output format.',
        'Notificação de seguimento' => 'For very complex stats it is possible to include a hardcoded file.',
        'Notificações' => 'OTRS DB Name',
        'Notificações (eventos)' => 'Number of displayed tickets',
        'Notifique-me se um cliente enviar um seguimento e eu for proprietário deste ticket.' =>
            'Send no notifications',
        'Nova Prioridade' => 'New State',
        'Novo Agente' => 'New Customer',
        'Novo Bloqueio do Ticket' => 'New messages',
        'Novo Cliente' => 'New Group',
        'Novo Estado' => 'New Ticket Lock',
        'Novo Grupo' => 'New Priority',
        'Novo ticket por email' => 'New phone ticket',
        'Novo ticket por telefone' => 'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.',
        'Não esqueça de adicionar um novo user nos grupos!' => 'Download Settings',
        'Não existe pacotes no Framework pedido neste Repositório, mas pacotes de outro Frameworks' =>
            'No Packages or no new Packages in selected Online Repository!',
        'Não existe pacotes no Repositório selecionado' => 'No Permission',
        'Não se esqueça de adicionar um novo utilizador a grupos e/ou papeis!' =>
            'Don\'t forget to add a new user to groups!',
        'Não são possíveis *!' => 'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!',
        'Não é possivel verificar o ficheiro index do Repositório' => 'Uniq',
        'Número de linhas (por ticket) mostradas na pesquisa no interface de agente' =>
            'Number of tickets to be displayed in each page of a search result in the agent interface.',
        'Número de tickets mostrados' => 'Number of lines (per ticket) that are shown by the search utility in the agent interface.',
        'Número de tickets mostrados por páginda nos resultados de pesquisa no interface de agente' =>
            'Number of tickets to be displayed in each page of a search result in the customer interface.',
        'Número de tickets mostrados por páginda nos resultados de pesquisa no interface de cliente' =>
            'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.',
        'Número inciial para o contador de estatísticas. Cada nova estatística incrementa o contador' =>
            'Statistics',
        'Número máximo de tickets mostrados nos resultados de pesquisa no interface de agente' =>
            'Maximum number of tickets to be displayed in the result of a search in the customer interface.',
        'Número máximo de tickets mostrados nos resultados de pesquisa no interface de cliente' =>
            'Maximum size (in characters) of the customer info table in the queue view.',
        'O OTRS envia uma mensagem de notificação ao cliente se o estado do ticket for alterado.' =>
            'OTRS-Admin Info!',
        'O OTRS envia uma mensagem de notificação ao cliente se o proprietário do ticket for alterado.' =>
            'OTRS sends an notification email to the customer if the ticket state has changed.',
        'O OTRS envia uma mensagem de notificação ao cliente se o ticket for movido.' =>
            'OTRS sends an notification email to the customer if the ticket owner has changed.',
        'O binário bin/PostMasterMailAccount.pl" vai ligar-se ao servidor POP3/POP3S/IMAP/IMAPS após um número de mensagens' =>
            'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.',
        'O cabeçalho mostrdo no interface de cliente' => 'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.',
        'O formato do assunto. \'Esquerda\' significa \'[TicketHook#:12345] Assunto\', \'Direita\' significa \'Assunto [TicketHook#:12345]\', \'Nenhum\' significa \'Assunto\' sem número de ticket. No último caso deve ativar PostmasterFollowupSearchInRaw ou PostmasterFollowUpSearchInReferences para reconhecer atualizações baseadas no cabeçalho ou corpo do email.' =>
            'The headline shown in the customer interface.',
        'O idenficador do ticket, ex. Ticket#, Call#, MyTicket#. Por omissão é Ticket# ' =>
            'The logo shown in the header of the agent interface. The URL to the image must be a relative URL to the skin image directory.',
        'O logotipo mostrado no cabeçalho do interface de agente. O URL deve ser relativo à pasta de imagens da skin' =>
            'The logo shown in the header of the customer interface. The URL to the image must be a relative URL to the skin image directory.',
        'O logotipo mostrado no cabeçalho do interface de cliente. O URL deve ser relativo à pasta de imagens da skin.' =>
            'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.',
        'O logotipo mostrado no topo da janela de login do interface de agente. O URL deve ser relativo à pasta de imagens da skin' =>
            'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.',
        'O módulo e a função PreRun() vão ser executados em cada pedido.Modulo útil para verificar algumas opções de utilizador ou para mostrar notificias sobre a aplicação.' =>
            'Ticket free text options shown in the close ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'O nome interno da skin utilizado no interface de agente. Verifique as skins disponíveis em Frontend::Agent::Skins. ' =>
            'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.',
        'O nome interno da skin utilizado no interface de cliente. Verifique as skins disponíveis em Frontend::Customer::Skins. ' =>
            'The divider between TicketHook and ticket number. E.g \': \'.',
        'O separador entre o prefixo e o número de ticket Ex \': \'.' =>
            'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.',
        'O seu Ticket' => 'accept license',
        'O seu endereço de correio electrónico é novo' => 'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.',
        'Objeto-Ascendente' => 'Password is already in use! Please use an other password!',
        'Objeto-Descendente' => 'Clear From',
        'Observador da Web' => 'Welcome to OTRS',
        'Obviamente que esta opção vai por si usar alguma performance de sistema' =>
            'Open Tickets',
        'Opçoes de dados do actual user (Ex. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' =>
            'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_UserFirstname&gt;)',
        'Opçoes de permiossão. Aqui pode selecionar um ou mais grupos para efectuar a configuraçao de estatisticas visiveis para diferentes agentes' =>
            'Permissions to change the ticket owner in this group/queue.',
        'Opçoes do Cliente corrente (Ex. &lt;OTRS_CUSTOMER_DATA_UserFirstname&gt;)' =>
            'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Opçoes do dono do ticket' => 'Ticket owner options (e. g. &lt;OTRS_OWNER_UserFirstname&gt;)',
        'Opçoes do user actual que pediu esta acção' => 'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_UserFirstname&gt;)',
        'Opções acessíveis' => 'User Management',
        'Opções de Configuração' => 'Contact customer',
        'Opções de Configuração (Ex. &lt;OTRS_CONFIG_HttpType&gt;)' =>
            'Config options (e. g. <OTRS_CONFIG_HttpType>).',
        'Opções de campos de tempo livre mostradas no ecrã de Prioridade de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de tempo livre mostradas no ecrã de campos de texto livre de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###AttributesView.',
        'Opções de campos de tempo livre mostradas no ecrã de composição de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de tempo livre mostradas no ecrã de encaminhamento de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de tempo livre mostradas no ecrã de fecho de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the email ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de tempo livre mostradas no ecrã de mensagem no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de tempo livre mostradas no ecrã de mover ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the phone ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de tempo livre mostradas no ecrã de notas de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the ticket owner screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de tempo livre mostradas no ecrã de pendentes de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de tempo livre mostradas no ecrã de pesquisa de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the ticket search screen in the customer interface. Possible settings: 0 = Disabled and 1 = Enabled.',
        'Opções de campos de tempo livre mostradas no ecrã de pesquisa de ticket no interface de cliente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket overview',
        'Opções de campos de tempo livre mostradas no ecrã de proprietário de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the ticket pending screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de tempo livre mostradas no ecrã de responsável de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the ticket search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.',
        'Opções de campos de tempo livre mostradas no ecrã de ticket por email no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the move ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de tempo livre mostradas no ecrã de tickets por telefone no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the ticket priority screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de texto livre mostradas no ecrã de Prioridade de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de texto livre mostradas no ecrã de campos de texto livre de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###AttributesView.',
        'Opções de campos de texto livre mostradas no ecrã de composição de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de texto livre mostradas no ecrã de encaminhamento de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de texto livre mostradas no ecrã de fecho de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the email ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de texto livre mostradas no ecrã de mensagem no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de texto livre mostradas no ecrã de mover ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the phone ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de texto livre mostradas no ecrã de notas de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the ticket owner screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de texto livre mostradas no ecrã de pendentes de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de texto livre mostradas no ecrã de pesquisa de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the ticket search screen in the customer interface. Possible settings: 0 = Disabled and 1 = Enabled.',
        'Opções de campos de texto livre mostradas no ecrã de pesquisa de ticket no interface de cliente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free time options shown in the close ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de texto livre mostradas no ecrã de proprietário de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the ticket pending screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de texto livre mostradas no ecrã de responsável de ticket no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the ticket search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de texto livre mostradas no ecrã de tickets por email no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the move ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções de campos de texto livre mostradas no ecrã de tickets por telefone no interface de agente. Opções: 0 = inativo, 1 = ativo, 2 = ativo e obrigatório' =>
            'Ticket free text options shown in the ticket priority screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Opções do Owner do Ticket' => 'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).',
        'Opções do Responsavel do Ticket ' => 'Ticket selected for bulk action!',
        'Opções do actual cliente que pediu esta acção' => 'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Opções do dono do ticket' => 'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).',
        'Opções do utilizador que requereu a acção (Ex. &lt;OTRS_CURRENT_UserFirstname&gt;)' =>
            'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).',
        'Opções dos actuais dados do cliente' => 'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Opções dos dados do ticket' => 'Order',
        'Opções dos dados do ticket (e.g., &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' =>
            'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Ordem' => 'Other Options',
        'Ordena os tickets (ascedente ou desdente) quando uma única fila é selecionada na vista de filas depois de ordenadas por Prioridade. Valores: 0 = ascendente (mais antigo no topo, por omissão), 1 = descendente (recentes no topo). Utilize a QueueID para a chave e 0 e 1 para valor.' =>
            'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.',
        'Ordenado pela' => 'Source',
        'Outras Opções' => 'POP3 Account Management',
        'Package not correctly deployed! You should reinstall the Package again!' =>
            'Pacote não correctamente entregue! Deverá reinstalar o pacote.',
        'Package not correctly deployed! You should reinstall the package again!' =>
            'Pacote não instalado corretamente. Deve re-instalar o pacote',
        'Pacote' => 'Param 1',
        'Palavra-chave' => 'Keywords',
        'Palavra-passe da Base de Dados OTRS' => 'OTRS DB User',
        'Palavra-passe de Administrador da Base de Dados' => 'DB Admin User',
        'Palavras-chave' => 'Last update',
        'Papeis <-> Gestão de Grupos' => 'Roles <-> Users',
        'Papeis <-> Gestão de Utilizadores' => 'SMIME Certificate',
        'Papeis <-> Grupos' => 'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.',
        'Papeis <-> Utilizadores' => 'Roles <-> Users Management',
        'Papel' => 'Roles <-> Groups Management',
        'Para estatisticas muito complexas pode incluir hardcoded files' =>
            'Frontend',
        'Para obter o atributo do artigo' => 'Top of Page',
        'Parâmetro 1' => 'Param 2',
        'Parâmetro 2' => 'Param 3',
        'Parâmetro 3' => 'Param 4',
        'Parâmetro 4' => 'Param 5',
        'Parâmetro 5' => 'Param 6',
        'Parâmetro 6' => 'Parent-Object',
        'Parâmetros de exemplo para o atributo SLA Comment2' => 'Parameters of the example queue attribute Comment2.',
        'Parâmetros de exemplo para o atributo de fila Comment2' => 'Parameters of the example service attribute Comment2.',
        'Parâmetros de exemplo para o atributo de serviço Comment2' => 'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).',
        'Parâmetros para as páginas da vista de previsão de tickets' =>
            'Parameters of the example SLA attribute Comment2.',
        'Parâmetros para as páginas da vista média de tickets' => 'Parameters for the pages (in which the tickets are shown) of the small ticket overview.',
        'Parâmetros para as páginas da vista pesquena de tickets' => 'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.',
        'Parâmetros para o Objeto CreateNextMask nas preferências do interface de agente' =>
            'Parameters for the CustomQueue object in the preference view of the agent interface.',
        'Parâmetros para o Objeto CustomQueue nas preferências do interface de agente' =>
            'Parameters for the FollowUpNotify object in the preference view of the agent interface.',
        'Parâmetros para o Objeto FollowUpNotify nas preferências do interface de agente' =>
            'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.',
        'Parâmetros para o Objeto LockTimeoutNotify nas preferências do interface de agente' =>
            'Parameters for the MoveNotify object in the preference view of the agent interface.',
        'Parâmetros para o Objeto MoveNotify nas preferências do interface de agente' =>
            'Parameters for the NewTicketNotify object in the preferences view of the agent interface.',
        'Parâmetros para o Objeto NewTicketNotify nas preferências do interface de agente' =>
            'Parameters for the RefreshTime object in the preference view of the agent interface.',
        'Parâmetros para o Objeto RefreshTime nas preferências do interface de agente' =>
            'Parameters for the WatcherNotify object in the preference view of the agent interface.',
        'Parâmetros para o Objeto WatcherNotify nas preferências do interface de agente' =>
            'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.',
        'Parâmetros para o dashboard na vista de calendário de tickets do interface de agente. "Limit" é o número de entradas mostradas por omissão. "Group" é utilizado para restringir o acesso ao plugin (ex. Group: admin;group1;group2;). "Default" determina se o plugin está ativo por omissão ou se precisa de ser ativado manualmente. "CacheTTLLocal" é o tempo de cache em minutos para o plugin.' =>
            'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.',
        'Parâmetros para o dashboard na vista de escalagem de tickets do interface de agente. "Limit" é o número de entradas mostradas por omissão. "Group" é utilizado para restringir o acesso ao plugin (ex. Group: admin;group1;group2;). "Default" determina se o plugin está ativo por omissão ou se precisa de ser ativado manualmente. "CacheTTLLocal" é o tempo de cache em minutos para o plugin.' =>
            'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.',
        'Parâmetros para o dashboard na vista de estatísticas de tickets do interface de agente. "Limit" é o número de entradas mostradas por omissão. "Group" é utilizado para restringir o acesso ao plugin (ex. Group: admin;group1;group2;). "Default" determina se o plugin está ativo por omissão ou se precisa de ser ativado manualmente. "CacheTTLLocal" é o tempo de cache em minutos para o plugin.' =>
            'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.',
        'Parâmetros para o dashboard na vista de novos tickets do interface de agente. "Limit" é o número de entradas mostradas por omissão. "Group" é utilizado para restringir o acesso ao plugin (ex. Group: admin;group1;group2;). "Default" determina se o plugin está ativo por omissão ou se precisa de ser ativado manualmente. "CacheTTLLocal" é o tempo de cache em minutos para o plugin.' =>
            'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.',
        'Parâmetros para o dashboard na vista de tickets pendentes do interface de agente. "Limit" é o número de entradas mostradas por omissão. "Group" é utilizado para restringir o acesso ao plugin (ex. Group: admin;group1;group2;). "Default" determina se o plugin está ativo por omissão ou se precisa de ser ativado manualmente. "CacheTTLLocal" é o tempo de cache em minutos para o plugin.' =>
            'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.',
        'Password de admnistrador' => 'Admin-User',
        'Pedidos:' => 'Required Field',
        'Periodo Absoluto' => 'Add Customer User',
        'Permissões necessárias para alterar o cliente do ticket no interface de agente' =>
            'Required permissions to use the close ticket screen in the agent interface.',
        'Permissões necessárias para utilizar o ecrã de Prioridade de ticket no interface de agente' =>
            'Required permissions to use the ticket responsible screen in the agent interface.',
        'Permissões necessárias para utilizar o ecrã de campos de texto livre de ticket no interface de agente' =>
            'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.',
        'Permissões necessárias para utilizar o ecrã de composição de ticket no interface de agente' =>
            'Required permissions to use the ticket forward screen in the agent interface.',
        'Permissões necessárias para utilizar o ecrã de encaminhamento de ticket no interface de agente' =>
            'Required permissions to use the ticket free text screen in the agent interface.',
        'Permissões necessárias para utilizar o ecrã de fecho de ticket no interface de agente' =>
            'Required permissions to use the ticket bounce screen in the agent interface.',
        'Permissões necessárias para utilizar o ecrã de fusão de tickets no interface de agente' =>
            'Required permissions to use the ticket note screen in the agent interface.',
        'Permissões necessárias para utilizar o ecrã de notas de ticket no interface de agente' =>
            'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.',
        'Permissões necessárias para utilizar o ecrã de pendentes de ticket no interface de agente' =>
            'Required permissions to use the ticket phone outbound screen in the agent interface.',
        'Permissões necessárias para utilizar o ecrã de proprietário de ticket no interface de agente' =>
            'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.',
        'Permissões necessárias para utilizar o ecrã de recusa de ticket no interface de agente' =>
            'Required permissions to use the ticket compose screen in the agent interface.',
        'Permissões necessárias para utilizar o ecrã de responsável de ticket no interface de agente' =>
            'Resets and unlocks the owner of a ticket if it was moved to another queue.',
        'Permissões necessárias para utilizar o ecrã de telefone de ticket no interface de agente' =>
            'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.',
        'Permissões para modificar o dono do ticket neste grupo/queue' =>
            'PhoneView',
        'Permissões por omissão para agentes. Se forem necessárias mais permissões,podem ser introduzidas aqui. As permissões têm de ser definidas para ser efetivas. Outras permissões já são integrantes do sistema: nota, fechar, pendente, cliente, freetext, mover, criar, responsável, encaminhar, e recusar. Verificar que  "rw" é a última permissão.' =>
            'Start number for statistics counting. Every new stat increments this number.',
        'Permite acesso se o id de cliente do ticket coincide com o código de utilizador de cliente e possui permissões de grupo  na fila a que pertence o ticket.' =>
            'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".',
        'Permite aos administradores fazerem fazerem login como outros utilizadores, na área de administração' =>
            'Allows to set a new ticket state in the move ticket screen of the agent interface.',
        'Permite aos clientes criar contas (autoregisto)' => 'Enables file upload in the package manager frontend.',
        'Permite aos utilizadores alterar o carater separador de campos em ficheiros CSV' =>
            'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.',
        'Permite definir o novo estado do ticket no ecrã de mover ticket no interface de agente' =>
            'Article free text options shown in the close ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Permite o carregamento de ficheiro no gestor de pacotes.' => 'Enables or disable the debug mode over frontend interface.',
        'Permite ter vista em formato pequeno do ticket (CustomerInfo=>1 - mostra informação de cliente).' =>
            'Allows the administrators to login as other users, via the users administration panel.',
        'Please ativate %s first!' => 'Por favor active %s primeiro',
        'Please fill out this form to receieve login credentials.' => 'Prencha o formulário para receber as credenciais de acesso',
        'Por Omissão' => 'Default Charset',
        'Por favor contactar o seu administrador de sistemas' => 'PostMaster Filter',
        'Pormenor' => 'Discard all changes and return to the compose screen',
        'Precisa de seleccionar pelo menos um Ticket!' => 'You need to account time!',
        'Precisa de um endereço de correio electrónico (e.g., cliente@exemplo.pt) no Para:!' =>
            'You need min. one selected Ticket!',
        'Preferências de Agente' => 'Agent-Area',
        'Primeira Reposta' => 'Follow up',
        'Primeiro dia de Natal' => 'Second Christmas Day',
        'Primeiro tempo de resposta' => 'Escalation - Solution Time',
        'Print this ticket!' => 'Imprimir o ticket!',
        'Problema' => 'Queue <-> Auto Responses Management',
        'Procura' => 'Mail Management',
        'Procura de Tickets' => 'Ticket Status View',
        'Procura exaustiva no texto no artigo (ex: "Mar*in" or "Baue*")' =>
            'Group selection',
        'Procura no histórico do cliente' => 'Customer history search (e. g. "ID342425").',
        'Procura no histórico do cliente (e.g., "ID342425")' => 'Customer user will be needed to have a customer history and to login via customer panel.',
        'Procurar por' => 'Security Note: You should ativate %s because applications is already running!',
        'Proprietário de Cliente Notificado' => 'Customer State Notify',
        'Protecção de ciclos por omissão' => 'Default queue ID used by the system in the agent interface.',
        'Proteção contra falhas CSRF (Cross Site Request Forgery) (Para mais informação consultar http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Queue view',
        'Próximos estados de tickets após adicionar uma nota por telefone no interface de agente' =>
            'Notifications (Event)',
        'Página' => 'Solution',
        'Quando dois tickets são fundidos, o cliente podes ser informado por email ao ativar "informar remetente".Pode definir um texto pré-formatado que pode ser alterado pelo agente.' =>
            'Your language',
        'Quando dois tickets são fundidos,uma nota é adiciona ao ticket inativo. Edite aqui o texto(não pode ser alterado pelo agente)' =>
            'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.',
        'Quebra de linha automática após x carateres' => 'Automatically lock and set owner to current Agent after selecting for an Bulk Action.',
        'Realiza verificações em anexos de emails que não contenham o número do ticket no assunto' =>
            'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.',
        'Realiza verificações em atualizações de emails nos cabeçalhos In-Reply-To ou References, qunado não existe número de ticket no assunto' =>
            'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.',
        'Realiza verificações em emails de texto que não contenham o número do ticket no assunto.' =>
            'Experimental "Slim" skin which tries to save screen space for power users.',
        'Realiza verificações no corpo dos emails, que não contenham o número do ticket no assunto.' =>
            'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.',
        'Recomendação' => 'Agent Mailbox',
        'Reconstruir' => 'Recipients',
        'Redefine funções existentes em Kernel::System::Ticket. Utilizado para adicionar customizações' =>
            'Overview Escalated Tickets',
        'Reinicia e desbloqueia o proprietário do ticket se for movido par aoutra fila' =>
            'Responses <-> Queues',
        'Remove linhas em branco na previsão de tickets na vista de filas' =>
            'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.',
        'Resposta' => 'Artefact',
        'Resposta Automática De' => 'Benchmark',
        'Respostas <-> Filas' => 'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).',
        'Respostas <-> Gestão de Anexos' => 'Responses <-> Queue Management',
        'Respostas <-> Gestão de Filas' => 'Return to the compose screen',
        'Restaura um ticket do arquivo (apenas se o evento alterar o estdo, de fechado para aberto)' =>
            'Roles <-> Groups',
        'Resultado de Procura' => 'Search for',
        'Retornar para o ecrã de composição' => 'Role',
        'Run Search' => 'Executar pesquisa',
        'Se "SysLog" for selecionado para LogModule, o código de página pode ser especificado' =>
            'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.',
        'Se "SysLog" for selecionado para LogModule, pode ser especificada outra funcionalAntiguidade especial' =>
            'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').',
        'Se "SysLog" for selecionado para LogModule, um socket especial pode ser especificado (em solaris utilizar \'stream\') ' =>
            'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.',
        'Se a expressão regular coincidir, a mensagem de auto resposta não será enviada' =>
            'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.',
        'Se a sua conta for acreditada, cabeçalhos X-OTRS existentes à chegada (para Prioridade, etc.) serão usados! O filtro do Chefe do Correio será sempre usado, no entanto.' =>
            'Image',
        'Se ativo, o OTRS vai enviar todos os ficheiros CSS na forma mínima. AVISO: se desligar esta opção, é provável que existam problemas com o IE7 que apenas suporte 32 ficheiros css.' =>
            'If enabled, OTRS will deliver all JavaScript files in minified form.',
        'Se ativo, o OTRS vai enviar todos os ficheiros Javascript na forma mínima' =>
            'If enabled, TicketPhone and TicketEmail will be open in new windows.',
        'Se ativo, o primeiro nível do menu principal expande com o hover do rato, em vez de clique' =>
            'If set, this address is used as envelope from header in outgoing notifications. If no address is specified, the envelope from header is empty.',
        'Se ativo, os novos tickets por email ou telefone, serão criados numa nova janela' =>
            'If enabled, the OTRS version tag will be removed from the HTTP headers.',
        'Se ativo, tag com a versão de OTRS será suprimida dos cabeçalhos HTTP ' =>
            'If enabled, the first level of the main menu opens on mouse hover (instead of click only).',
        'Se configurado, todos os emails enviados pela aplicação vão conter um cabeçalho X-Header com o nome da companhia' =>
            'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.',
        'Se definido, este endereço é utilizado nos cabeçalhos das mensagens enviadas. Se não for especificado, o cabeçalho do envelope é vazio' =>
            'If this regex matches, no message will be send by the autoresponder.',
        'Se for adicionada uma nota pelo agente, define o estado do ticket no ecrã de campos de texto livre do interface de agente' =>
            'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.',
        'Se for adicionada uma nota pelo agente, define o estado do ticket no ecrã de detalhe de ticket do interface de agente' =>
            'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.',
        'Se for adicionada uma nota pelo agente, define o estado do ticket no ecrã de fecho de ticket do interface de agente' =>
            'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.',
        'Se for adicionada uma nota pelo agente, define o estado do ticket no ecrã de notas de ticket do interface de agente' =>
            'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.',
        'Se for adicionada uma nota pelo agente, define o estado do ticket no ecrã de operações em bloco do interface de agente' =>
            'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.',
        'Se for adicionada uma nota pelo agente, define o estado do ticket no ecrã de pendentes do interface de agente' =>
            'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Se for adicionada uma nota pelo agente, define o estado do ticket no ecrã de proprietário de ticket do interface de agente' =>
            'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Se for adicionada uma nota pelo agente, define o estado do ticket no ecrã de responsável de ticket do interface de agente' =>
            'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Se nada for seleccionado, então não há permissões neste grupo (tickets não estaram disponíveis para o utilizador).' =>
            'If you need the sum of every column select yes.',
        'Se pretende a soma de todas as colunas selecione Sim' => 'If you need the sum of every row select yes',
        'Se pretende a soma de todas as linhas selecione Sim' => 'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.',
        'Se selecionar "DB" para Customer::AuthModule, pode especificar a password de acesso da tabela de clientes' =>
            'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.',
        'Se selecionar "DB" para Customer::AuthModule, pode especificar o DSN de acesso da tabela de clientes' =>
            'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.',
        'Se selecionar "DB" para Customer::AuthModule, pode especificar o campo que guarda a CustomerKey na tabela de clientes' =>
            'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.',
        'Se selecionar "DB" para Customer::AuthModule, pode especificar o campo que guarda a CustomerPassword na tabela de clientes' =>
            'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.',
        'Se selecionar "DB" para Customer::AuthModule, pode especificar o nome da tabela deve ser especificado' =>
            'If "DB" was selected for SessionModule, a column for the identifiers in session table must be specified.',
        'Se selecionar "DB" para Customer::AuthModule, pode especificar o tipo de cifra nas passwords' =>
            'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.',
        'Se selecionar "DB" para Customer::AuthModule, pode especificar o utilizador de acesso da tabela de clientes' =>
            'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.',
        'Se selecionar "DB" para Customer::AuthModule, pode especificar um driver de base de dados (normalmente é utilizada auto deteção)' =>
            'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.',
        'Se selecionar "File" para LogModule, o nome do ficheiro tem de ser especificado. Se não existir será criado.' =>
            'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.',
        'Se selecionar "HTTPBasicAuth" para Customer::AuthModule, pode especificar uma expressão regular para extrair partes do REMOTE_USER (ex. para remover os domínios). RegExp-Note, $1 será o novo login.' =>
            'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).',
        'Se selecionar "HTTPBasicAuth" para Customer::AuthModule, pode especificar uma expressão regular para extrair partes do nome(ex. fpara dominios example_domain\user para user)' =>
            'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.',
        'Se selecionar "LDAP" para Customer::AuthModule e forem necessários parametros adicionais para o módulo perl Net::LDAP, pode especificar aqui. Consultar "perldoc Net::LDAP" para mais informação.' =>
            'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.',
        'Se selecionar "LDAP" para Customer::AuthModule e quiser adicionar um sufixo a cada login de cliente, pode especificar aqui, ex. apenas quer escrever o nome mas na AD o utilizador existe como user@domain.' =>
            'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.',
        'Se selecionar "LDAP" para Customer::AuthModule,  pode especificar um filtro para cada pesquisa LDAP, ex. (mail=*), (objectclass=user) ou (!objectclass=computer)' =>
            'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.',
        'Se selecionar "LDAP" para Customer::AuthModule, especifica se a aplicação deve para caso não seja possível estabelecer uma ligação ao servidor ' =>
            'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.',
        'Se selecionar "LDAP" para Customer::AuthModule, o BaseDN deve ser especificado' =>
            'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.',
        'Se selecionar "LDAP" para Customer::AuthModule, o servidor deve ser especificado' =>
            'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.',
        'Se selecionar "LDAP" para Customer::AuthModule, o utilizador deve ser especificado' =>
            'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.',
        'Se selecionar "LDAP" para Customer::AuthModule, os atributos de acesso podem ser especificados.' =>
            'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.',
        'Se selecionar "LDAP" para Customer::AuthModule, os atributos podem ser especificados. Para posixGroups LDAP utilizar UID, para grupos não posixGroups LDAP utilizar o nome completo DN.' =>
            'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.',
        'Se selecionar "LDAP" para Customer::AuthModule, pode verificar se o utilizador pode autenticar se pertencer a um posixGroup, ex. o utilizador necessita de pertencer ao grupo xyz para utilizar o OTRS. Especifique o grupo que pode aceder ao sistema.' =>
            'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).',
        'Se selecionar "Radius" para Customer::AuthModule, a password para autenticar no servidor radius tem de ser especificada' =>
            'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.',
        'Se selecionar "Radius" para Customer::AuthModule, o servidor radius tem de ser especificado' =>
            'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.',
        'Se selecionar "Radius" para Customer::AuthModule, pode especificar se a aplicação deve parar se não conseguir estabelecer uma ligação ao servidor.' =>
            'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.',
        'Se selecionar "Sendmail" para SendmailModule, a localização do binário sendmail necessita de ser especificado.' =>
            'If "SysLog" was selected for LogModule, a special log facility can be specified.',
        'Se selecionar If "LDAP" para Customer::AuthModule e os utilizadores possuem acesso anónimo à árvore LDAP, pode pesquisar através de utilizador com acesso à diretoria LDAP. Indique a password aqui.' =>
            'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.',
        'Se selecionar If "LDAP" para Customer::AuthModule e os utilizadores possuem acesso anónimo à árvore LDAP, pode pesquisar através de utilizador com acesso à diretoria LDAP. Indique o utilizador aqui.' =>
            'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.',
        'Se selecionar SessionModule, a coluna para guardar o identificador na tabela de sessão deve ser indicada' =>
            'If "DB" was selected for SessionModule, a column for the values in session table must be specified.',
        'Se selecionar SessionModule, a coluna para guardar os valores na tabela de sessão deve ser indicada' =>
            'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.',
        'Se selecionar SessionModule, a pasta para guardar os dados de sessão terá de ser especificada' =>
            'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.',
        'Se selecionar SessionModule, a tabela ser indicado' => 'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.',
        'Se selecionar qualquer forma de "SMTP" para SendmailModule, e for necessária autenticação, necessita de especificar a password' =>
            'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.',
        'Se selecionar qualquer forma de "SMTP" para SendmailModule, e for necessária autenticação, necessita de especificar o utilizador' =>
            'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.',
        'Se selecionar qualquer forma de "SMTP" para SendmailModule, é necessário especificar o porto' =>
            'If configured, all emails sent by the application will contain an X-Header with this organization or company name.',
        'Se selecionar qualquer forma de "SMTP" para SendmailModule,é necessário especificar o servidor' =>
            'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.',
        'Se um agente bloqueia um ticket e não enviar uma resposta dentro deste tempo, o ticket será desbloqueado automaticamente, ficando visível para todos os outros agentes.' =>
            'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).',
        'Se um novo Hardcoded File esta disponivel, este atributo vai ficar visivel e pode selecionar um' =>
            'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.',
        'Se um ticket estiver fechado e um cliente enviar um seguimento, será bloqueado em nome do seu proprietário.' =>
            'If a ticket will not be answered in this time, just only this ticket will be shown.',
        'Se um ticket não for respondido dentro deste tempo, apenas os tickets com este tempo vencido serão exibidos.' =>
            'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.',
        'Se usar expressões regulares, pode aceder ao valor emparelhado em () como [***] em \'Coloca\'.' =>
            'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.',
        'Se utilizar mirroring de base de dados para pesquisas em texto integral ou gerar estatísticas, especifique a password' =>
            'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.',
        'Se utilizar mirroring de base de dados para pesquisas em texto integral ou gerar estatísticas, especifique o DSN da base de dados' =>
            'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.',
        'Se utilizar mirroring de base de dados para pesquisas em texto integral ou gerar estatísticas, especifique o utilizador' =>
            'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).',
        'Search for customers (wildcards are allowed).' => 'Pesquisa de clientes (Operadores wildcard permitidos)',
        'Search-Profile as Template?' => 'Perfil de pesquisa como modelo ?',
        'Security Note: You should ativate %s because application is already running!' =>
            'Nota de Segurança: É necessário Ativar %s porque a aplicação já está a ser executada',
        'Seguimento' => 'Follow up notification',
        'Segundo dia de Natal' => 'New Year\'s Eve',
        'Seleccionar ecrã após criação de novo ticket.' => 'Select:',
        'Seleccionar fonte (para a adição)' => 'Select the element, which will be used at the X-axis',
        'Seleccionar o utilizador:permissões de grupo.' => 'Select your QueueView refresh time.',
        'Seleccionar:' => 'Selection needed',
        'Seleccione as relações papel:utilizador' => 'Select the user:group permissions.',
        'Seleccione o dicionário ortográfico por omissão.' => 'Select your frontend Charset.',
        'Seleciona o módulo gerador de numeração de tickets. "AutoIncrement" incrementa o número do ticket , o SystemID and e o contador são utilizadode no formato SystemID.counter (ex. 1010138, 1010139). Com "Date" o número do ticket será gerado com a data atual, o SystemID e o contador. O formato é semelhante a Ano.Mes.Dia.SystemID.contador (ex. 200206231010138, 200206231010139). Com "DateChecksum"  o contador será acrescentado como checksum à string da data e SystemID. O checksum é rodado diáriamente. O formato é parecido com Ano.Mes.Dia.SystemID.Contador.CheckSum (ex. 2002070110101520, 2002070110101535). "Random" gera números de forma aleatóriano formato "SystemID.Random" (ex. 100057866352, 103745394596).' =>
            'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.',
        'Seleciona o módulo para a gerir carregamentos no interface web."DB" guarda todos os ficheiros em base de dados, "FS" utiliza o sistema de ficheiros' =>
            'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).',
        'Selecionar as restricções para caracterizar o estado' => 'Select the role:user relations.',
        'Selecione a Caixa de Resultado' => 'Select Source (for add)',
        'Selecione a Visualização de Filas da Interface.' => 'Select your frontend language.',
        'Selecione a codificação da interface.' => 'Select your frontend QueueView.',
        'Selecione o elemento que vai ser usado no eixo dos X' => 'Select the restrictions to characterise the stat',
        'Selecione o idioma da interface.' => 'Select your screen after creating a new ticket.',
        'Selecione o tema do interface.' => 'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.',
        'Selecione o tempo de refrescamento da Visualização de Filas.' =>
            'Select your default spelling dictionary.',
        'Seleção do grupo' => 'Have a lot of fun!',
        'Sem Autorização' => 'No means, send agent and customer notifications on changes.',
        'Sem definições de tempo.' => 'Note',
        'Servidor Base de Dados' => 'DB Type',
        'Servidor de ligação da Base de Dados OTRS' => 'OTRS sends an notification email to the customer if the ticket is moved.',
        'Sessões' => 'Set customer user and customer id of a ticket',
        'Set this ticket to pending!' => 'Tornar o ticket pendente!',
        'Seu email com o número de ticket "<OTRS_TICKET>" foi devolvido para "<OTRS_BOUNCE_TO>". Contate este endereço para mais informações.' =>
            'Your own Ticket',
        'Shows the ticket history!' => 'Mostrar o histórico do ticket!',
        'Sim significa, não enviar ao agent e cliente notificações quando houver alterações' =>
            'Yes, save it with name',
        'Sim, guardar com o nome' => 'You got new message!',
        'Sintoma' => 'System History',
        'Skin "Slim" experimental para poupar espaço no ecrã de utilizadores avançados' =>
            'Exports the whole article tree in search result (it can affect the system performance).',
        'Skin de brancos balanceados por Felix Niklas' => 'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.',
        'Skin por omissão para o interface' => 'Default ticket ID used by the system in the agent interface.',
        'Skin por omissão para o interface OTRS 3.0' => 'Default skin for interface.',
        'Solução' => 'Sorry, feature not active!',
        'Sub-serviço de' => 'Subscribe',
        'Subfila de' => 'Sub-Service of',
        'Subscrever' => 'Symptom',
        'Substitui o remetente original com o email do cliente atual na janela de resposta do ticket no interface do agente.' =>
            'Required permissions to change the customer of a ticket in the agent interface.',
        'Take care that you also updated the default states in you Kernel/Config.pm!' =>
            'Garanta que também actualizou os estados por omissão em Kernel/Config.pm!',
        'Tamanho máximo de carateres de informação de cliente na vista de detalhe de ticket' =>
            'Module for To-selection in new ticket screen in the customer interface.',
        'Tamanho máximo de carateres de informação de cliente na vista de filas' =>
            'Maximum size (in characters) of the customer information table in the ticket zoom view.',
        'Tamanho máximo de carateres para informação de cliente (telefone e email) na janela de composição' =>
            'Max size of the subjects in an email reply.',
        'Tamanho máximo do assunto nas respostas de email' => 'Max. displayed tickets',
        'Tamanho máximo em KBytes para emails descarregados via POP3/POP3S/IMAP/IMAPS (KBytes)' =>
            'Maximum number of tickets to be displayed in the result of a search in the agent interface.',
        'Tem a certeza que pretende reinstalar este pacote ?(todas as alterações manuais vao ser perdidas)' =>
            'Don\'t forget to add a new user to groups and/or roles!',
        'Tem de Ativar %s antes de o usar!' => 'Your email address is new',
        'Tem de verificar a ortografia da mensagem!' => 'A message should have a To: recipient!',
        'Tem uma mensagem nova!' => 'You have to select two or more attributes from the select field!',
        'Tema de frontend' => 'GenericAgent',
        'Tempo Pendente' => 'Pending messages',
        'Tempo a mais' => 'Times',
        'Tempo de actualização' => 'Escalation time',
        'Tempo de escalamento' => 'Explanation',
        'Tempo de espera entre pedidos autocomplete' => 'Deletes a session if the session id is used with an invalid remote IP address.',
        'Tempo de solução' => 'Escalation - Update Time',
        'Tempo em segundos adicionado ao tempo atual para estados de pendencia (por omissão: 86400 - 1 dia)' =>
            'Toolbar Item for a shortcut.',
        'Tempos' => 'Title of the stat.',
        'Texto Livre do Ticket' => 'TicketID',
        'Texto inicial da resposta do assunto do email,  ex. RE, AW, ou AS ' =>
            'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.',
        'Texto inicial de encaminhamento no assunto do email.e.g. FW, Fwd, ou WG ' =>
            'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.',
        'Texto personalAntiguidade mostrado aos clientes que não têm tickets' =>
            'Customer item (icon) which shows the open tickets of this customer as info block.',
        'The User Name you wish to have' => 'O cód. utilizador que deseja',
        'Ticket %s bloqueado.' => 'Ticket Hook',
        'Ticket ID por omissão utilizado pelo sistema no interface de agente' =>
            'Default ticket ID used by the system in the customer interface.',
        'Ticket ID por omissão utilizado pelo sistema no interface de cliente' =>
            'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.',
        'Ticket bloqueado!' => 'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Ticket desbloqueado!' => 'Ticket-Area',
        'Ticket seleccionado para acção em lote!' => 'Ticket unlock!',
        'TicketFreeFields' => 'TicketCamposLivres',
        'Tickets Abertos' => 'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'Tickets available' => 'Tickets disponíveis',
        'Tickets da Instituição' => 'Compose Answer',
        'Tickets da companhia' => 'Configure your own log text for PGP.',
        'Tickets mostrados' => 'Timeover',
        'Time1' => 'Tempo1',
        'Time2' => 'Tempo2',
        'Time3' => 'Tempo3',
        'Time4' => 'Tempo4',
        'Time5' => 'Tempo5',
        'Time6' => 'Tempo6',
        'Tipo da Base de Dados' => 'DB connect host',
        'Tipo de fecho' => 'Close!',
        'Tipo de pendência' => 'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.',
        'Tipo de remetente em novos tickets no interface de cliente' => 'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).',
        'Tipos' => 'Update Ticket "Seen" flag if every article got seen or a new Article got created.',
        'Titulo da estatistica' => 'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).',
        'Todas as mensagens' => 'Answer',
        'Todas mensagens recebidas com este destinatário (Para:) serão despachados para a fila selecionada!' =>
            'All messages',
        'Todos os Agentes' => 'All Customer variables like defined in config option CustomerUser.',
        'Todos os tickets do cliente.' => 'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!',
        'Topo da Página' => 'Total hits',
        'Torna a imagem transparente' => 'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.',
        'Total de acertos' => 'U',
        'Um artigo tem de ter um título!' => 'A message must be spell checked!',
        'Um calendário na Web' => 'A web file manager',
        'Um cliente de correio electrónico na Web' => 'Absolut Period',
        'Um gestor de ficheiros na Web' => 'A web mail client',
        'Uma mensagem deve possuir um Para: destinatário!' => 'A message should have a body!',
        'Unlock to give it back to the queue!' => 'Desbloqueie o ticket para o devolver à fila!',
        'Unsubscrever' => 'Update:',
        'Usar UTF-8 se a base de dados o suportar' => 'Useable options',
        'Util para grandes databases e servers pouco potentes' => '(The identify of the system. Each ticket number and each http session id starts with this number)',
        'Utiliza cookies na gestão de sessões. Se os cookies estiverem inativos ou se o browser tiver os cookies inativos, o sistema vai adicionar o identificador de sessão aos links' =>
            'Manage PGP keys for email encryption.',
        'Utiliza destinatários em resposta CC nas respostas por email no interface de agente' =>
            'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.',
        'Utiliza o SystemID na deteção de tickets para atualizações (Selecione n~~ao caso  o systemID tenha alterado )' =>
            'Comment for new history entries in the customer interface.',
        'Utiliza rtf para visualizar e editar artigos, saudações, assinaturas, respostas padrão, auto respostas e notificações.' =>
            'View performance benchmark results.',
        'Utilizador Admin da Base de Dados' => 'DB Host',
        'Utilizador Cliente' => 'DB Admin Password',
        'Utilizador cliente terá de ter um historial como cliente e de se autenticar via os paineis de cliente.' =>
            'CustomerUser',
        'Utilizador de Admin' => 'Advisory',
        'Utilizador de Base de Dados OTRS' => 'OTRS DB connect host',
        'Utilizadores' => 'Users <-> Groups',
        'Utilizadores <-> Gestão de Grupos' => 'Warning! This tickets will be removed from the database! This tickets are lost!',
        'Utilizadores <-> Grupos' => 'Users <-> Groups Management',
        'Utilizadores Clientes' => 'Customer Users <-> Groups',
        'Utilizadores Clientes <-> Grupos' => 'Customer history',
        'Utilizar esta skin no frontend' => 'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).',
        'Ver mensagens de log' => 'Wear this frontend skin',
        'Verificar Ortografia' => 'Split',
        'Vista de escalagem' => 'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all TicketFreeField elements need the same event.',
        'Vista de estado' => 'Stores cookies after the browser has been closed.',
        'Vista de filas' => 'QueueView Refresh Time',
        'Vista de tickets' => 'Tickets',
        'Vista de tickets escalados' => 'Overview of all open Tickets.',
        'Vista de todos os tickets em aberto' => 'PGP Key Upload',
        'Visualização de Chamada' => 'Please contact your admin',
        'Visualização do Estado dos Tickets' => 'Ticket escalation!',
        'Vários' => 'Modified',
        'Véspera de Ano Novo' => '%s Tickets affected! Do you really want to use this job?',
        'Véspera de Natal' => 'First Christmas Day',
        'Wildcards are allowed.' => 'operadores wildcard permitidos',
        'aceitar licença' => 'customer realname',
        'ativates TypeAhead for the autocomplete feature, that enables users to type in whatever speed they desire, without losing any information. Often this means that keystrokes entered will not be displayed on the screen immediately.' =>
            'Ativa TypeAhead para a funcionalAntiguidade de autocomplete, que permite que os utilizadores escrevam à velocAntiguidade que desejarem sem perderem informação.',
        'ativates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Ativa o mecanismo de piscar da fila que contém os tickets mais antigos',
        'ativates lost password feature for agents, in the agent interface.' =>
            'Ativa a funcionalAntiguidade de recuperar password para agentes',
        'ativates lost password feature for customers.' => 'Ativa a funcionalAntiguidade de recuperar password para clientes',
        'ativates support for customer groups.' => 'Ativa o suporte para grupos de clientes',
        'ativates the article filter in the zoom view to specify which articles should be shown.' =>
            'Ativa o filtro de artigosna vista de detalhe',
        'ativates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Ativa os temas disponiveis no sistema. Valor 1 significa ativo, 0 significa inativo',
        'ativates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Ativa o sistema de arquivo de tickets para melhorar a disponibilAntiguidade do sistema ao mover alguns tickets para fora do âmbito diário. Para pesquisar estes tickets deve selecionar a opção de arquivo na pesquisa.',
        'ativates time accounting.' => 'Ative a contabilizaçãod de tempo',
        'ativating this feature might affect your system performance!' =>
            'O desempenho do sistema vai piorar se ativar esta funcionalAntiguidade',
        'automaticamente bloquear e define o proprietário para o agente atual após operações em lote' =>
            'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).',
        'automaticamente define o proprietário como responsável (se a funcionlAntiguidade de responsável estiver ativa)' =>
            'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.',
        'criar e gerir notificações enviadas a agentes' => 'Create and manage queues.',
        'decrescente' => 'false',
        'define o tamanho mínimo do contador (Se for Auto incremento selecionado em TicketNumberGenerator). Por omissão o valor é 5, e o contador inicia em 10000 ' =>
            'Sets the minimum number of characters before autocomplete query is sent.',
        'enviar' => 'sort downward',
        'falso' => 'for agent firstname',
        'finalizar sessão' => 'maximal period form',
        'nome do cliente' => 'don\'t accept license',
        'novo ticket' => 'next step',
        'não aceitar licença' => 'down',
        'ordenar crescentemente' => 'to get the first 20 character of the subject',
        'ordenar decrescentemente' => 'sort upward',
        'para o ID de utilizador do agente' => 'kill all sessions',
        'para o apelido do agente' => 'for agent login',
        'para o nome de utilizador do agente' => 'for agent user id',
        'para o nome próprio do agente' => 'for agent lastname',
        'para obter a linha "De:" da mensagem' => 'to get the realname of the sender (if given)',
        'para obter as 5 primeiras linhas da mensagem de correio electrónico' =>
            'to get the from line of the email',
        'para obter o nome do remetente (se indicado na mensagem)' => 'up',
        'para obter os 20 primeiros caracteres do assunto' => 'to get the first 5 lines of the email',
        'próximo passo' => 'send',
        'todas as variáveis de Cliente tais como definidas na opção de configuração CustomerUser' =>
            'All customer tickets.',
        'ver resultados de medição de desempenho' => 'View system log messages.',
        'Área de Administração' => 'Admin-Email',
        'Área de Agente' => 'All Agents',
        'Área de Estatísticas' => 'Sub-Queue of',
        'Área de Tickets' => 'TicketFreeText',
        'Árvore de Categorias' => 'Change %s settings',
        'É necessário o tempo dispendido' => 'You need to ativate %s first to use it!',
        'É necessário um nome!' => 'New Agent',
        'É necessário um utilizador para manipular os tickets.' => 'Users',
        'É possível configurar diferentes skins para distinguir agentes, para distinguir domínios. Utilizando uma expressão regular, pode configurar um par Chave/Conteudo para coincider com o domínio. O valor"Chave" deve coincidir com o domínio, e o "Conteúdo" deve ser uma skin válida do sistema.' =>
            'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.',
        'É possível configurar diferentes skins para distinguir clientes, para distinguir domínios. Utilizando uma expressão regular, pode configurar um par Chave/Conteudo para coincidir com o domínio. O valor"Chave" deve coincidir com o domínio, e o "Conteúdo" deve ser uma skin válida do sistema.' =>
            'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.',
        'É possível configurar diferentes temas para distinguir agentes e clientes, para distinguir domínios. Utilizando uma expressão regular, pode configurar um par Chave/Conteudo para coincidir com o domínio. O valor"Chave" deve coincidir com o domínio, e o "Conteúdo" deve ser um tema válida do sistema.' =>
            'Link agents to groups.',
        'Última actualização' => 'Load Settings',
        'Único' => 'Unlock Tickets',
        'Útil para muitos utilizadores e grupos.' => 'Job-List',

    };
    # $$STOP$$
    return;
}

1;
