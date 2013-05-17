# --
# Kernel/Language/pt.pm - provides pt language translation
# Copyright (C) 2004-2007 CAT - Filipe Henriques <filipehenriques at ip.pt>viz
# Copyright (C) 2012 FCCN - Rui Francisco <rui.francisco@fccn.pt>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-05-17 10:03:25

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
        'Logout successful. Thank you for using %s!' => 'Saiu com sucesso. Obrigado por utilizar o %s!',
        'Feature not active!' => 'Característica não ativa!',
        'Agent updated!' => 'Agente atualizado',
        'Database Selection' => '',
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
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => 'A sessão expirou. Por favor autentique-se novamente',
        'Session limit reached! Please try again later.' => '',
        'No Permission!' => 'Sem Permissão!',
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
        'Collapse' => 'Fechar',
        'Shown' => 'Mostrar',
        'Shown customer users' => '',
        'News' => 'Notícias',
        'Product News' => 'Novidades do produto',
        'OTRS News' => 'Notícias OTRS',
        '7 Day Stats' => 'Estatísticas dos últimos 7 dias',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
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
        'Please change the owner first.' => '',
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
        'Address %s replaced with registered customer address.' => '',
        'Customer automatically added in Cc.' => '',
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
        'History::TicketTitleUpdate' => '',

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
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
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
        'Back to search result' => '',
        'Add customer' => 'Adicionar cliente',
        'Select' => 'Selecionar',
        'Hint' => 'Sugestão',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'O cliente necessita de possuir histórico e efectuar login no interface cliente',
        'Please enter a search term to look for customers.' => 'Introduza o termo de pesquisa para clientes',
        'Last Login' => 'Último acesso',
        'Login as' => 'Entrar como',
        'Switch to customer' => '',
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
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => '',
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
        'Article sender type' => '',
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
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
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

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Filter' => 'Filtro',
        'Process Name' => '',
        'Create New Process' => '',
        'Synchronize All Processes' => '',
        'Configuration import' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '',
        'Upload process configuration' => '',
        'Import process configuration' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Processes' => '',
        'Process name' => '',
        'Copy' => '',
        'Print' => 'Imprimir',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Cancelar e fechar a janela',
        'Go Back' => '',
        'Please note, that changing this activity will affect the following processes' =>
            '',
        'Activity' => '',
        'Activity Name' => '',
        'Activity Dialogs' => '',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '',
        'Filter available Activity Dialogs' => '',
        'Available Activity Dialogs' => '',
        'Create New Activity Dialog' => '',
        'Assigned Activity Dialogs' => '',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
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
        'Read certificate' => '',
        'Delete this certificate' => 'Apagar este certificado',
        'Add Certificate' => 'Adicionar Certificado',
        'Add Private Key' => 'Adicionar Chave Privada',
        'Secret' => 'Segredo',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => '',
        'Relate this certificate' => '',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => '',
        'Close window' => 'Fechar janela',

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

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'No. Cliente',
        'Customer User' => '',

        # Template: AgentCustomerSearch
        'Search Customer' => 'Procurar Cliente',
        'Duplicated entry' => '',
        'This address already exists on the address list.' => '',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => '',

        # Template: AgentDashboardCalendarOverview
        'in' => 'em',

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
        'out of office' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

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

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'Escalado em',
        'Locked' => 'Bloqueado',

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

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

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
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
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
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
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
        'Archive' => '',
        'This ticket is archived.' => '',
        'Linked Objects' => 'Objetos ligados',
        'Article(s)' => 'Artigo(s)',
        'Change Queue' => 'Mudar fila',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
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
        'To protect your privacy, remote content was blocked.' => '',
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

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'Javascript não disponível',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Para utilizar o OTRS, necessita de ativar javascript no browser',
        'Browser Warning' => 'Aviso de browser',
        'The browser you are using is too old.' => 'O browser que está a usar está muito desatualizado',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'O OTRS corre numa lista de browsers grande, por favor atualize para um deles.',
        'Please see the documentation or ask your admin for further information.' =>
            'Consulte a informação por favor ou peça mais informação ao administrador de sistema',
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

        # Template: CustomerTicketZoom
        'Show  article' => '',
        'Expand article' => 'Expandir artigo',
        'Information' => '',
        'Next Steps' => '',
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
        'Fulltext search' => '',
        'CustomerID Search' => '',
        'CustomerUser Search' => '',
        'You are logged in as' => 'Autenticado como ',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'Javascript não disponível',
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
        'Database setup successful!' => '',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a database for OTRS' => '',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '',
        'Check database settings' => 'Verificar definições de base de dados',
        'Result of database check' => 'Resultado da verificação à base de dados',
        'Database User' => '',
        'New' => 'Novo',
        'A new database user with limited rights will be created for this OTRS system.' =>
            'Vai ser criado um novo utilizador de base de dados com permissões limitadas para o OTRS',
        'Repeat Password' => '',
        'Generated password' => '',

        # Template: InstallerDBmysql

        # Template: InstallerDBpostgresql

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
        '"Slim" Skin which tries to save screen space for power users.' =>
            '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Módulo ACL que permite o fecho de tickets apenas se todos os tickets filhos estiverem fechados("Estado" mostra os estados não disponíveis ao pai até que todos os filhos estejam fechados).',
        'AccountedTime' => '',
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
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
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
        'Agent interface module to access CIC search via nav bar.' => '',
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
        'All customer users of a CustomerID' => '',
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
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Permite definir novos tipos de tickets (se a funcionalAntiguidade de tipo de ticket estiver ativa).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permite definir serviços e SLAs para os tickets(ex. email, desktop, network, ...), e atributos de escalagem para os SLAs(caso a funcionalAntiguidade service/SLA esteja ativa).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite condições de pesquisa de tickets aumentadas no interface de cliente . Com esta funcionalAntiguidade pode pesquisar com por ex. "(key1&&key2)" or "(key1||key2)".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite ter vista em formato médio do ticket (CustomerInfo=>1 - mostra informação de cliente).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'shows also the customer information).',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'ArticleTree' => '',
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
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
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
        'Company Status' => '',
        'Company Tickets' => '',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Configures the full-text index. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => '',
        'Create and manage agents.' => '',
        'Create and manage attachments.' => '',
        'Create and manage companies.' => '',
        'Create and manage customers.' => '',
        'Create and manage dynamic fields.' => '',
        'Create and manage event based notifications.' => '',
        'Create and manage groups.' => '',
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
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User Administration' => '',
        'Customer Users' => '',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => '',
        'Customers <-> Services' => '',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => '',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
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
        'Define the max depth of queues.' => '',
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
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
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
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
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
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, Search_DynamicField_Field1StartYear=2002; Search_DynamicField_Field1StartMonth=12; Search_DynamicField_Field1StartDay=12; Search_DynamicField_Field1StartHour=00; Search_DynamicField_Field1StartMinute=00; Search_DynamicField_Field1StartSecond=00; Search_DynamicField_Field1StopYear=2009; Search_DynamicField_Field1StopMonth=02; Search_DynamicField_Field1StopDay=10; Search_DynamicField_Field1StopHour=23; Search_DynamicField_Field1StopMinute=59; Search_DynamicField_Field1StopSecond=59;.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
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
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
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
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
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
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
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
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
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
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
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
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
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
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
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
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
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
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
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
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
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
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => '',
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
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Execute SQL statements.' => '',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            '',
        'Filter incoming emails.' => '',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Frontend language' => '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
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
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
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
        'Main menu registration.' => '',
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
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
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
        'New process ticket' => '',
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
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
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
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Queue view' => '',
        'Refresh Overviews after' => '',
        'Refresh interval' => '',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
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
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => '',
        'Selects the cache backend to use.' => '',
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
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
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
        'Sets the time (in seconds) a user is marked as active.' => '',
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
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
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
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
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
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
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
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
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
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => '',
        'TicketNumber' => '',
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
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => '',
        'View system log messages.' => '',
        'Wear this frontend skin' => '',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            '',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            'Adiciona emails do cliente aos remetentes na criação de ticket no interface de agente.',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite condições de pesquisa de tickets aumentadas no interface de agente . Com esta funcionalAntiguidade pode pesquisar com por ex. "(key1&&key2)" or "(key1||key2)".',
        'Currently only MySQL is supported in the web installer.' => 'Atualmente, apenas Mysql é suportado no instalador web.',
        'Customer Data' => 'Dados do Cliente',
        'DB host' => 'Servidor de BD',
        'Database-User' => 'Utilizador da Base de Dados',
        'False' => 'Falso',
        'For more info see:' => 'Para mais informação consultar:',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Se selecionou a password de root para a base de dados, introduza-a aqui. Senão, deixe este campo em branco. Por razões de segurança recomendamos definir a password de root. Para mais informações consulte a documentação da base de dados.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Se quiser instalar o OTRS com outro motor de base de dados, consulte o ficheiro README.database',
        'Log file location is only needed for File-LogModule!' => 'A localização do ficheiro é necessário com File-LogModule',
        'Logout successful. Thank you for using OTRS!' => 'Saiu com sucesso. Obrigado por utilizar o OTRS!',
        'Package verification failed!' => 'Verificação do pacote falhou',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'O modo seguro necessita de estar inativo para re-instalar via browser',
        'default \'hot\'' => 'por omissão \'hot\'',

    };
    # $$STOP$$
    return;
}

1;
