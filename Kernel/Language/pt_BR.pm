# --
# Kernel/Language/pt_BR.pm - provides Brazilian Portuguese language translation
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# Copyright (C) 2003 Gilberto Cezar de Almeida <gibalmeida at hotmail.com>
# Copyright (C) 2005 Alterado por Glaucia C. Messina (glauglauu@yahoo.com)
# Copyright (C) 2007-2010 Fabricio Luiz Machado <soprobr gmail.com>
# Copyright (C) 2010-2011 Murilo Moreira de Oliveira <murilo.moreira gmail.com>
# --
# $Id: pt_BR.pm,v 1.131.2.2 2012-11-22 06:58:52 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::pt_BR;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.131.2.2 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-05-17 09:59:51

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';

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
        'Reset' => 'Reiniciar',
        'last' => 'último',
        'before' => 'antes',
        'Today' => 'Hoje',
        'Tomorrow' => 'Amanhã',
        'Next week' => '',
        'day' => 'dia',
        'days' => 'dias',
        'day(s)' => 'dia(s)',
        'd' => 'D',
        'hour' => 'hora',
        'hours' => 'horas',
        'hour(s)' => 'hora(s)',
        'Hours' => 'Horas',
        'h' => 'h',
        'minute' => 'minuto',
        'minutes' => 'minutos',
        'minute(s)' => 'minuto(s)',
        'Minutes' => 'Minutos',
        'm' => 'm',
        'month' => 'mês',
        'months' => 'meses',
        'month(s)' => 'mês(s)',
        'week' => 'semana',
        'week(s)' => 'semana(s)',
        'year' => 'ano',
        'years' => 'anos',
        'year(s)' => 'ano(s)',
        'second(s)' => 'segundo(s)',
        'seconds' => 'segundos',
        'second' => 'segundo',
        's' => 's',
        'wrote' => 'escreveu',
        'Message' => 'Mensagem',
        'Error' => 'Erro',
        'Bug Report' => 'Relatório de Erros',
        'Attention' => 'Atenção',
        'Warning' => 'Aviso',
        'Module' => 'Módulo',
        'Modulefile' => 'Arquivo de Módulo',
        'Subfunction' => 'Subfunção',
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
        '-none-' => '-vazio-',
        'none' => 'Vazio',
        'none!' => 'Vazio!',
        'none - answered' => 'vazio  - respondido',
        'please do not edit!' => 'Por favor, não edite!',
        'Need Action' => 'Ação requerida',
        'AddLink' => 'Adicionar associação',
        'Link' => 'Associar',
        'Unlink' => 'Desassociar',
        'Linked' => 'Associado',
        'Link (Normal)' => 'Associação (Normal)',
        'Link (Parent)' => 'Associação (Pai)',
        'Link (Child)' => 'Associação (Filho)',
        'Normal' => 'Normal',
        'Parent' => 'Pai',
        'Child' => 'Filho',
        'Hit' => 'Acesso',
        'Hits' => 'Acessos',
        'Text' => 'Texto',
        'Standard' => 'Padrão',
        'Lite' => 'Simples',
        'User' => 'Usuário',
        'Username' => 'Login',
        'Language' => 'Idioma',
        'Languages' => 'Idiomas',
        'Password' => 'Senha',
        'Preferences' => 'Preferências',
        'Salutation' => 'Tratamento',
        'Salutations' => 'Tratamentos',
        'Signature' => 'Assinatura',
        'Signatures' => 'Assinaturas',
        'Customer' => 'Cliente',
        'CustomerID' => 'ID. do Cliente',
        'CustomerIDs' => 'IDs do Cliente',
        'customer' => 'Cliente',
        'agent' => 'Atendente',
        'system' => 'Sistema',
        'Customer Info' => 'Informação do Cliente',
        'Customer Information' => 'Informação do Cliente',
        'Customer Company' => 'Empresa de Clientes',
        'Customer Companies' => 'Empresas de Clientes',
        'Company' => 'Empresa',
        'go!' => 'ir!',
        'go' => 'ir',
        'All' => 'Todas',
        'all' => 'todas',
        'Sorry' => 'Desculpe',
        'update!' => 'atualizar!',
        'update' => 'atualizar',
        'Update' => 'Atualizar',
        'Updated!' => 'Atualizado!',
        'submit!' => 'enviar!',
        'submit' => 'enviar',
        'Submit' => 'Enviar',
        'change!' => 'alterar!',
        'Change' => 'Alterar',
        'change' => 'alterar',
        'click here' => 'clique aqui',
        'Comment' => 'Comentário',
        'Invalid Option!' => 'Opção Inválida',
        'Invalid time!' => 'Hora Inválida',
        'Invalid date!' => 'Data Inválida',
        'Name' => 'Nome',
        'Group' => 'Grupo',
        'Description' => 'Descrição',
        'description' => 'Descrição',
        'Theme' => 'Tema',
        'Created' => 'Criado',
        'Created by' => 'Criado por',
        'Changed' => 'Alterado',
        'Changed by' => 'Alterado por',
        'Search' => 'Procurar',
        'and' => 'e',
        'between' => 'entre',
        'Fulltext Search' => 'Busca por texto completo',
        'Data' => 'Dado',
        'Options' => 'Opções',
        'Title' => 'Título',
        'Item' => 'Item',
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
        'Added!' => 'Adicionado!',
        'Category' => 'Categoria',
        'Viewer' => 'Visualização',
        'Expand' => 'Expandir',
        'Small' => 'Pequeno',
        'Medium' => 'Médio',
        'Large' => 'Grande',
        'Date picker' => 'Seleção de data',
        'New message' => 'Nova mensagem',
        'New message!' => 'Nova mensagem!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Por favor, responda este(s) chamado(s) para retornar à visualização de filas!',
        'You have %s new message(s)!' => 'Você tem %s nova(s) mensagem(s)!',
        'You have %s reminder ticket(s)!' => 'Você tem %s chamado(s) com lembrete!',
        'The recommended charset for your language is %s!' => 'O conjunto de caracteres recomendado para o seu idioma é %s!',
        'Change your password.' => 'Altere sua senha.',
        'Please activate %s first!' => 'Por favor, ative %s primeiro.',
        'No suggestions' => 'Sem sugestões',
        'Word' => 'Palavra',
        'Ignore' => 'Ignorar',
        'replace with' => 'substituir por',
        'There is no account with that login name.' => 'Não existe conta com este nome de usuário',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Autenticação falhou! Nome de usuário ou senha foram digitados incorretamente.',
        'There is no acount with that user name.' => 'Não há conta com este nome de usuário.',
        'Please contact your administrator' => 'Por favor, contate seu administrador',
        'Logout' => 'Sair',
        'Logout successful. Thank you for using OTRS!' => 'Encerrado com sucesso. Obrigado por utilizar nosso gerenciador de chamados!',
        'Invalid SessionID!' => 'Identificação de Sessão Inválida',
        'Feature not active!' => 'Funcionalidade não ativada!',
        'Agent updated!' => 'Atendente atualizado!',
        'Create Database' => 'Criar Banco de Dados',
        'System Settings' => 'Configurações de Sistema',
        'Mail Configuration' => 'Configuração de E-mail',
        'Finished' => 'Finalizado',
        'Install OTRS' => '',
        'Intro' => '',
        'License' => 'Licença',
        'Database' => 'Banco de Dados',
        'Configure Mail' => '',
        'Database deleted.' => '',
        'Database setup succesful!' => '',
        'Login is needed!' => 'Nome de usuário é obrigatório!',
        'Password is needed!' => 'Senha é obrigatória!',
        'Take this Customer' => 'Atenda este Cliente',
        'Take this User' => 'Atenda este Usuário',
        'possible' => 'possível',
        'reject' => 'rejeitar',
        'reverse' => 'reverso',
        'Facility' => 'Facilidade',
        'Time Zone' => 'Zona horária',
        'Pending till' => 'Pendente até',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Por favor, não trabalhe com a conta de superusuário no OTRS! Crie novos atendentes e trabalhe com eles!',
        'Dispatching by email To: field.' => 'Distribuição de acordo com o campo e-mail para:.',
        'Dispatching by selected Queue.' => 'Distribuição de acordo com a fila selecionada',
        'No entry found!' => 'Nenhuma entrada encontrada!',
        'Session has timed out. Please log in again.' => 'A sessão expirou. Por favor, autentique novamente.',
        'No Permission!' => 'Sem permissão!',
        '(Click here to add)' => '(Clique aqui para adicionar)',
        'Preview' => 'Pré-visualizar',
        'Package not correctly deployed! Please reinstall the package.' =>
            '',
        '%s is not writable!' => '%s é somente leitura!',
        'Cannot create %s!' => 'Não foi possível criar %s!',
        'Check to activate this date' => '',
        'You have Out of Office enabled, would you like to disable it?' =>
            '',
        'Customer %s added' => 'Cliente %s adicionado',
        'Role added!' => 'Papel adicionado!',
        'Role updated!' => 'Papel atualizado!',
        'Attachment added!' => 'Anexo adicionado!',
        'Attachment updated!' => 'Anexo atualizado!',
        'Response added!' => 'Resposta adicionado!',
        'Response updated!' => 'Resposta atualizada!',
        'Group updated!' => 'Grupo atualizado!',
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
        'Online Customer: %s' => 'Clientes Online: %s',
        'Online Agent: %s' => 'Atendentes Online: %s',
        'Calendar' => 'Calendário',
        'File' => 'Arquivo',
        'Filename' => 'Nome do arquivo',
        'Type' => 'Tipo',
        'Size' => 'Tamanho',
        'Upload' => '',
        'Directory' => 'Diretório',
        'Signed' => 'Assinado',
        'Sign' => 'Assinar',
        'Crypted' => 'Criptografado',
        'Crypt' => 'Criptografar',
        'PGP' => 'PGP',
        'PGP Key' => 'Chave PGP',
        'PGP Keys' => 'Chaves PGP',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'Certificado S/MIME',
        'S/MIME Certificates' => 'Certificados S/MIME',
        'Office' => 'Escritório',
        'Phone' => 'Telefone',
        'Fax' => '',
        'Mobile' => 'Celular',
        'Zip' => 'CEP',
        'City' => 'Cidade',
        'Street' => 'Rua',
        'Country' => 'País',
        'Location' => 'Locação',
        'installed' => 'instalado',
        'uninstalled' => 'desinstalado',
        'Security Note: You should activate %s because application is already running!' =>
            'Nota de Segurança: Você deve ativar %s ',
        'Unable to parse repository index document.' => 'Impossível analisar documento de índice do repositório.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Nenhum pacote para a versão do seu framework foi encontrado neste repositório, ele contém apenas pacotes para outras versões de framework.',
        'No packages, or no new packages, found in selected repository.' =>
            'Nenhum pacote, ou nenhum novo pacote, encontrado no repositório selecionado.',
        'Edit the system configuration settings.' => 'Alterar parâmetros de configuração do sistema.',
        'printed at' => 'impresso em',
        'Loading...' => 'Carregando...',
        'Dear Mr. %s,' => 'Caro Sr. %s,',
        'Dear Mrs. %s,' => 'Cara Sra. %s,',
        'Dear %s,' => 'Caro %s,',
        'Hello %s,' => 'Olá %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'Este endereço de de e-mail já existe. Por favor, faça login ou redefina sua senha.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Nova conta criada. Enviadas informações de login para %s. Por favor, verifique seu e-mail.',
        'Please press Back and try again.' => 'Por favor, pressione Voltar e tente novamente.',
        'Sent password reset instructions. Please check your email.' => 'Enviadas instruções para redefinição de senha. Por favor, verifique seu e-mail.',
        'Sent new password to %s. Please check your email.' => 'Enviada nova senha para %s. Por favor, verifique seu e-mail.',
        'Upcoming Events' => 'Próximos Eventos',
        'Event' => 'Evento',
        'Events' => 'Eventos',
        'Invalid Token!' => 'Token Inválido!',
        'more' => 'mais',
        'Collapse' => 'Recolher',
        'Shown' => 'Exibido',
        'News' => 'Notícias',
        'Product News' => 'Notícias do Produto',
        'OTRS News' => 'Notícias sobre o OTRS',
        '7 Day Stats' => 'Estatísticas (7 Dias)',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Bold' => 'Negrito',
        'Italic' => 'Itálico',
        'Underline' => 'Sublinhado',
        'Font Color' => 'Cor da Fonte',
        'Background Color' => 'Cor do Plano de Fundo',
        'Remove Formatting' => 'Remover Formatação',
        'Show/Hide Hidden Elements' => 'Mostrar/Esconder Formatação',
        'Align Left' => 'Alinhar à Esquerda',
        'Align Center' => 'Centralizado',
        'Align Right' => 'Alinhar à Direita',
        'Justify' => 'Justificado',
        'Header' => 'Cabeçalho',
        'Indent' => 'Aumentar Recuo',
        'Outdent' => 'Diminuir Recuo',
        'Create an Unordered List' => 'Criar uma lista sem ordenação',
        'Create an Ordered List' => 'Criar uma lista ordenada',
        'HTML Link' => 'Hiperlink',
        'Insert Image' => 'Inserir Imagem',
        'CTRL' => '',
        'SHIFT' => '',
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
        'User Profile' => 'Perfil do Usuário',
        'Email Settings' => 'Configurações de E-mail',
        'Other Settings' => 'Outras Configurações',
        'Change Password' => 'Trocar senha',
        'Current password' => 'Senha atual',
        'New password' => 'Nova senha',
        'Verify password' => 'Verificar senha',
        'Spelling Dictionary' => 'Dicionário de ortografia',
        'Default spelling dictionary' => 'Dicionário de ortografia padrão',
        'Max. shown Tickets a page in Overview.' => 'Máx. chamados por página na tela Visão Geral.',
        'The current password is not correct. Please try again!' => 'A senha atual não está correta. Por favor, tente novamente!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Não é possível atualizar a senha. Suas novas senhas são diferentes. Por favor, tente novamente!',
        'Can\'t update password, it contains invalid characters!' => 'Não é possível atualizar a senha. Ela contém caracteres inválidos!',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Não é possível atualizar a senha. Ela deve conter pelo menos %s caracteres!',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            'Não é possível atualizar a senha. Ela deve conter pelo menos 2 caracteres minúsculos e 2 maiúsculos!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Não é possível atualizar a senha. Ela deve conter pelo menos 1 número!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Não é possível atualizar a senha. Ela deve conter pelo menos 2 caracteres!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Não é possível atualizar a senha. Essa senha já foi utilizada. Por favor, escolha outra!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Selecione o caractere separador usado em arquivos CSV (estatísticas e pesquisas). Se você não selecionar um separador aqui, o separador padrão para o seu idioma será usado.',
        'CSV Separator' => 'Separador CSV',

        # Template: AAAStats
        'Stat' => 'Estatística',
        'Sum' => 'Soma',
        'Please fill out the required fields!' => 'Por favor, preencha os campos obrigatórios!',
        'Please select a file!' => 'Por favor, selecione um arquivo!',
        'Please select an object!' => 'Por favor, selecione um objeto!',
        'Please select a graph size!' => 'Por favor, selecione o tamanho do gráfico!',
        'Please select one element for the X-axis!' => 'Por favor, selecione um elemento do eixo X!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Por favor, selecione apenas um elemento ou desligue o botão \'Fixo\' onde o campo selecionado está marcado!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Se você utilizar um checkbox, você deve selecionar alguns atributos do campo selecionar!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Por favor, insira um valor no campo de entrada selecionado ou desmarque a checkbox \'Fixo\'!',
        'The selected end time is before the start time!' => 'A data final selecionada é anterior à data inicial!',
        'You have to select one or more attributes from the select field!' =>
            'Você deve selecionar ao menos um atributo no campo \'selecionar\'!',
        'The selected Date isn\'t valid!' => 'A data selecionada é inválida!',
        'Please select only one or two elements via the checkbox!' => 'Por favor, selecione apenas um ou dois elementos através da checkbox!',
        'If you use a time scale element you can only select one element!' =>
            'Se você usar um elemento de escala de tempo, você deve selecionar apenas um elemento!',
        'You have an error in your time selection!' => 'Você tem um erro na hora selecionada!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'O intervalo de tempo para o relatório é muito pequeno, por favor, utilize um período maior!',
        'The selected start time is before the allowed start time!' => 'A data inicial selecionada é anterior à permitida!',
        'The selected end time is after the allowed end time!' => 'A data final selecionada é posterior à permitida!',
        'The selected time period is larger than the allowed time period!' =>
            'O período de tempo selecionado é maior que o permitido!',
        'Common Specification' => 'Especificação Comum',
        'X-axis' => 'Eixo-X',
        'Value Series' => 'Sequência de Valores',
        'Restrictions' => 'Restrições',
        'graph-lines' => 'gráfico de linhas',
        'graph-bars' => 'gráfico de barras',
        'graph-hbars' => 'gráfico de barras\(2\)',
        'graph-points' => 'gráfico de pontos',
        'graph-lines-points' => 'gráfico de linhas e pontos',
        'graph-area' => 'gráfico de área',
        'graph-pie' => 'gráfico de pizza',
        'extended' => 'extendido',
        'Agent/Owner' => 'Atendente/Proprietário',
        'Created by Agent/Owner' => 'Criado pelo Atendente/Proprietário',
        'Created Priority' => 'Prioridade',
        'Created State' => 'Criado com o Estado',
        'Create Time' => 'Hora de Criação',
        'CustomerUserLogin' => 'Usuário do Cliente',
        'Close Time' => 'Hora de Fechamento',
        'TicketAccumulation' => 'Acumulação de Chamado',
        'Attributes to be printed' => 'Atributos a serem impressos',
        'Sort sequence' => 'Sequência de Ordenamento',
        'Order by' => 'Ordenar por',
        'Limit' => 'Limite',
        'Ticketlist' => 'ListaChamado',
        'ascending' => 'ascendente',
        'descending' => 'descendente',
        'First Lock' => 'Primeiro Bloqueio',
        'Evaluation by' => 'Avaliado por',
        'Total Time' => 'Tempo Total',
        'Ticket Average' => 'Média de Chamados',
        'Ticket Min Time' => 'Horário Mínimo dos Chamados',
        'Ticket Max Time' => 'Horário Máximo dos Chamados',
        'Number of Tickets' => 'Número de Chamados',
        'Article Average' => 'Média de Artigos',
        'Article Min Time' => 'Horário Mínimo dos Artigos',
        'Article Max Time' => 'Horário Máximo dos Artigos',
        'Number of Articles' => 'Número de Artigos',
        'Accounted time by Agent' => 'Tempo contabilizado por Atendente',
        'Ticket/Article Accounted Time' => 'Tempo contabilizado por Chamado/Artigo',
        'TicketAccountedTime' => 'TempoContabilizadoChamado',
        'Ticket Create Time' => 'Horário de Criação do Chamado',
        'Ticket Close Time' => 'Horário de Fechamento do Chamado',

        # Template: AAATicket
        'Status View' => 'Estado de Visualização',
        'Bulk' => 'Massa',
        'Lock' => 'Bloquear',
        'Unlock' => 'Desbloquear',
        'History' => 'Histórico',
        'Zoom' => 'Detalhes',
        'Age' => 'Idade',
        'Bounce' => 'Devolver',
        'Forward' => 'Encaminhar',
        'From' => 'De',
        'To' => 'Para',
        'Cc' => 'Cópia ',
        'Bcc' => 'Cópia Oculta',
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
        'SLA' => '',
        'Service Level Agreement' => 'Acordo de Nível de Serviço',
        'Service Level Agreements' => 'Acordos de Nível de Serviço',
        'Service' => 'Serviço',
        'Services' => 'Serviços',
        'State' => 'Estado',
        'States' => 'Estados',
        'Status' => 'Estado',
        'Statuses' => 'Estados',
        'Ticket Type' => 'Tipo de Chamado',
        'Ticket Types' => 'Tipos de Chamado',
        'Compose' => 'Compor',
        'Pending' => 'Pendente',
        'Owner' => 'Proprietário',
        'Owner Update' => 'Atualização Proprietário',
        'Responsible' => 'Responsável',
        'Responsible Update' => 'Atualização do Responsável',
        'Sender' => 'Remetente',
        'Article' => 'Artigo',
        'Ticket' => 'Chamado',
        'Createtime' => 'Hora de criação',
        'plain' => 'texto',
        'Email' => 'E-Mail',
        'email' => 'e-mail',
        'Close' => 'Fechar',
        'Action' => 'Ação',
        'Attachment' => 'Anexo',
        'Attachments' => 'Anexos',
        'This message was written in a character set other than your own.' =>
            'Esta mensagem foi escrita utilizando um conjunto de caracteres diferente do seu.',
        'If it is not displayed correctly,' => 'Se ele não for exibido corretamente,',
        'This is a' => 'Este é um',
        'to open it in a new window.' => 'para abri-lo em uma nova janela.',
        'This is a HTML email. Click here to show it.' => 'Este é um e-Mail HTML. Clique aqui para exibi-lo.',
        'Free Fields' => 'Campos Livres',
        'Merge' => 'Agrupar',
        'merged' => 'agrupado',
        'closed successful' => 'fechado com êxito',
        'closed unsuccessful' => 'fechado sem êxito',
        'Locked Tickets Total' => 'Total de Chamados Bloqueados',
        'Locked Tickets Reminder Reached' => 'Lembrete de Chamados Bloqueados Atingido',
        'Locked Tickets New' => 'Novos Chamados Bloqueados',
        'Responsible Tickets Total' => 'Total de chamados com Responsável',
        'Responsible Tickets New' => 'Novos Chamados com Responsável',
        'Responsible Tickets Reminder Reached' => 'Lembrete de Chamados com Responsável Atingido',
        'Watched Tickets Total' => 'Total de Chamados Monitorados',
        'Watched Tickets New' => 'Novos Chamados Monitorados',
        'Watched Tickets Reminder Reached' => 'Lembrete de Chamados Monitorados Atingido',
        'All tickets' => 'Todos os chamados',
        'Available tickets' => '',
        'Escalation' => 'Escalação',
        'last-search' => 'última-pesquisa',
        'QueueView' => 'Fila',
        'Ticket Escalation View' => 'Visão de Escalação de Chamados',
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
        'pending reminder' => 'lembrete de pendente',
        'pending auto' => 'pendente automático',
        'pending auto close+' => 'pendente auto fechamento+',
        'pending auto close-' => 'pendente auto fechamento-',
        'email-external' => 'e-mail externo',
        'email-internal' => 'e-mail interno',
        'note-external' => 'nota-externa',
        'note-internal' => 'nota-interna',
        'note-report' => 'nota-relatório',
        'phone' => 'Telefone',
        'sms' => '',
        'webrequest' => 'chamado web',
        'lock' => 'Bloquear',
        'unlock' => 'Desbloquear',
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
        'auto follow up' => '',
        'auto reject' => '',
        'auto remove' => '',
        'auto reply' => '',
        'auto reply/new ticket' => '',
        'Ticket "%s" created!' => 'Chamado "%s" criado!',
        'Ticket Number' => 'Número do Chamado',
        'Ticket Object' => 'Objeto do Chamado',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Não existe o chamado "%s"! Não é possível associá-lo!',
        'You don\'t have write access to this ticket.' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '',
        'Ticket selected.' => '',
        'Ticket is locked by another agent.' => '',
        'Ticket locked.' => '',
        'Don\'t show closed Tickets' => 'Não mostrar chamados fechados',
        'Show closed Tickets' => 'Mostrar chamados fechados',
        'New Article' => 'Novo Artigo',
        'Unread article(s) available' => 'Artigo(s) não lido(s) disponível(is)',
        'Remove from list of watched tickets' => 'Remover da lista de chamados monitorados',
        'Add to list of watched tickets' => 'Adicionar à lista de chamados monitorados',
        'Email-Ticket' => 'Chamado E-mail',
        'Create new Email Ticket' => 'Criar novo Chamado E-mail',
        'Phone-Ticket' => 'Chamado Fone',
        'Search Tickets' => 'Pesquisar Chamados',
        'Edit Customer Users' => 'Editar Clientes (Usuários)',
        'Edit Customer Company' => 'Editar Companhia de Clientes',
        'Bulk Action' => 'Ação em Massa',
        'Bulk Actions on Tickets' => 'Ações em massa em chamados',
        'Send Email and create a new Ticket' => 'Enviar e-mail e criar novo chamado',
        'Create new Email Ticket and send this out (Outbound)' => 'Criar novo chamado e-mail e enviá-lo (saída)',
        'Create new Phone Ticket (Inbound)' => 'Criar novo chamado fone (entrada)',
        'Address %s replaced with registered customer address.' => '',
        'Customer automatically added in Cc.' => '',
        'Overview of all open Tickets' => 'Visão geral de todos os chamados abertos',
        'Locked Tickets' => 'Chamados Bloqueados',
        'My Locked Tickets' => 'Meus Chamados Bloqueados',
        'My Watched Tickets' => 'Meus Chamados Monitorados',
        'My Responsible Tickets' => 'Chamados na Minha Responsabilidade',
        'Watched Tickets' => 'Chamados Monitorados',
        'Watched' => 'Monitorados',
        'Watch' => 'Monitorar',
        'Unwatch' => 'Não monitorar',
        'Lock it to work on it' => '',
        'Unlock to give it back to the queue' => '',
        'Show the ticket history' => '',
        'Print this ticket' => '',
        'Print this article' => '',
        'Split this article' => '',
        'Forward article via mail' => '',
        'Change the ticket priority' => '',
        'Change the ticket free fields!' => 'Alterar os campos em branco no chamado!',
        'Link this ticket to other objects' => '',
        'Change the owner for this ticket' => '',
        'Change the  customer for this ticket' => '',
        'Add a note to this ticket' => '',
        'Merge into a different ticket' => '',
        'Set this ticket to pending' => '',
        'Close this ticket' => '',
        'Look into a ticket!' => 'Examinar em detalhes o conteúdo de um chamado!',
        'Delete this ticket' => '',
        'Mark as Spam!' => 'Marque como Spam',
        'My Queues' => 'Minhas Filas',
        'Shown Tickets' => 'Chamados Exibidos',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Seu e-mail com um número de chamado "<OTRS_TICKET>" está agrupado com o número de chamado <OTRS_MERGE_TO_TICKET>"!',
        'Ticket %s: first response time is over (%s)!' => 'Chamado %s: primeiro tempo de solução está ultrapassado (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Chamado %s: primeiro tempo de solução expirará em %s!',
        'Ticket %s: update time is over (%s)!' => 'Chamado %s: tempo de atualização está ultrapassado (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Chamado %s: tempo de atualização expirará em %s!',
        'Ticket %s: solution time is over (%s)!' => 'Chamado %s: tempo de solução está ultrapassado (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Chamado %s: tempo de solução expirará em %s!',
        'There are more escalated tickets!' => 'Há mais chamados escalados!',
        'Plain Format' => 'Formato texto',
        'Reply All' => 'Responder a Todos',
        'Direction' => 'Direção',
        'Agent (All with write permissions)' => 'Atendente (todos com permissão de escrita)',
        'Agent (Owner)' => 'Atendente (Proprietário)',
        'Agent (Responsible)' => 'Atendente (Responsável)',
        'New ticket notification' => 'Notificação de novo chamado',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Envie-me uma notificação se há um novo chamado em "Minhas Filas".',
        'Send new ticket notifications' => 'Enviar notificações de novos chamados',
        'Ticket follow up notification' => 'Notificação de acompanhamento de chamados',
        'Ticket lock timeout notification' => 'Notificação de bloqueio de chamado por tempo expirado',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Notifique-me se um chamado é desbloqueado pelo sistema.',
        'Send ticket lock timeout notifications' => 'Enviar notificação de bloqueio de chamado por tempo expirado',
        'Ticket move notification' => 'Notificação de movimentaçaõ de chamados',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Notifique-me se chamados forem movimentados para "Minhas Filas"',
        'Send ticket move notifications' => 'Enviar notificações de movimentação de chamados',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Custom Queue' => 'Fila Personalizada',
        'QueueView refresh time' => 'Tempo de atualização das filas',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Se habilitado, a tela de filas será automaticamente atualizada após o tempo especificado.',
        'Refresh QueueView after' => 'Atualizar a tela de filas após',
        'Screen after new ticket' => 'Tela após novo chamado',
        'Show this screen after I created a new ticket' => 'Mostrar esta tela após eu criar um novo chamado',
        'Closed Tickets' => 'Chamados Fechados',
        'Show closed tickets.' => 'Mostrar chamados fechados.',
        'Max. shown Tickets a page in QueueView.' => 'Máximo de chamados apresentados por página.',
        'Ticket Overview "Small" Limit' => 'Limite para a visão de chamados "pequeno"',
        'Ticket limit per page for Ticket Overview "Small"' => 'Limite por página para a visão de chamados "pequeno"',
        'Ticket Overview "Medium" Limit' => 'Limite para a visão de chamados "médio"',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Limite por página para a visão de chamados "médio"',
        'Ticket Overview "Preview" Limit' => 'Limite para a visão de chamados "pré-visualização"',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Limite por página para a visão de chamados "pré-visualização',
        'Ticket watch notification' => 'Notificação de chamados monitorados',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Envie-me as mesmas notificações para os meus chamados monitorados que os proprietários dos chamados receberão.',
        'Send ticket watch notifications' => 'Enviar notificações de chamados monitorados',
        'Out Of Office Time' => 'Fora do escritório',
        'New Ticket' => 'Novo Chamado',
        'Create new Ticket' => 'Criar novo Chamado',
        'Customer called' => 'O cliente telefonou',
        'phone call' => 'Chamada telefônica',
        'Phone Call Outbound' => 'Chamada telefônica realizada',
        'Phone Call Inbound' => '',
        'Reminder Reached' => 'Lembrete Expirado',
        'Reminder Tickets' => 'Chamados com Lembrete',
        'Escalated Tickets' => 'Chamados Escalados',
        'New Tickets' => 'Chamados Novos',
        'Open Tickets / Need to be answered' => 'Chamados Abertos / Precisam ser respondidos',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Todos os chamados abertos, estes chamados já foram trabalhados, mas precisam de uma resposta',
        'All new tickets, these tickets have not been worked on yet' => 'Todos os chamados novos, estes chamados não foram trabalhados ainda',
        'All escalated tickets' => 'Todos os chamados escalados',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Todos os chamados com lembrete cujas datas de lembrete expiraram',
        'Archived tickets' => '',
        'Unarchived tickets' => '',
        'History::Move' => 'Chamado foi movido para a Fila "%s" (%s) vindo da Fila "%s" (%s).',
        'History::TypeUpdate' => 'Tipo atualizado para %s (ID=%s).',
        'History::ServiceUpdate' => 'Serviço atualizado para %s (ID=%s).',
        'History::SLAUpdate' => 'SLA atualizado para %s (ID=%s).',
        'History::NewTicket' => 'Novo chamado [%s] foi criado (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Acompanhado por [%s]. %s',
        'History::SendAutoReject' => 'Rejeição automática enviada para "%s".',
        'History::SendAutoReply' => 'Autorresposta enviada para "%s".',
        'History::SendAutoFollowUp' => 'Acompanhamento automático enviado para "%s".',
        'History::Forward' => 'Encaminhado para "%s".',
        'History::Bounce' => 'Devolvido a "%s".',
        'History::SendAnswer' => 'E-mail enviado para "%s".',
        'History::SendAgentNotification' => '"%s"-notificação enviada para "%s".',
        'History::SendCustomerNotification' => 'Notificação enviada para "%s".',
        'History::EmailAgent' => 'E-Mail enviado a clientes.',
        'History::EmailCustomer' => 'E-Mail adicionado. %s',
        'History::PhoneCallAgent' => 'Atendente telefonou para cliente.',
        'History::PhoneCallCustomer' => 'Cliente telefonou para a equipe de suporte.',
        'History::AddNote' => 'Nota adicionada (%s)',
        'History::Lock' => 'Chamado Bloqueado.',
        'History::Unlock' => 'Chamado Desbloqueado.',
        'History::TimeAccounting' => '%s unidade(s) de tempo contabilizada. O total agora é %s unidade(s) de tempo.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Atualizado: %s',
        'History::PriorityUpdate' => 'Prioridade atualizada por "%s" (%s) to "%s" (%s).',
        'History::OwnerUpdate' => 'Novo proprietário é "%s" (ID=%s).',
        'History::LoopProtection' => 'Proteção de Loop! Autorresposta enviada para "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Atualizado: %s',
        'History::StateUpdate' => 'Anterior: "%s" Novo: "%s"',
        'History::TicketDynamicFieldUpdate' => 'Atualizado: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Requisição do cliente via web.',
        'History::TicketLinkAdd' => 'Adicionadas associações ao chamado "%s".',
        'History::TicketLinkDelete' => 'Associações do chamado excluídas "%s".',
        'History::Subscribe' => 'Adicionada assinatura para o usuário "%s".',
        'History::Unsubscribe' => 'Removida assinatura para o usuário "%s".',
        'History::SystemRequest' => 'Requisição de sistema (%s).',
        'History::ResponsibleUpdate' => 'Novo responsável é "%s" (ID=%s).',
        'History::ArchiveFlagUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => 'Dom',
        'Mon' => 'Seg',
        'Tue' => 'Ter',
        'Wed' => 'Qua',
        'Thu' => 'Qui',
        'Fri' => 'Sex',
        'Sat' => 'Sab',

        # Template: AdminAttachment
        'Attachment Management' => 'Gerenciamento de Anexos',
        'Actions' => 'Ações',
        'Go to overview' => 'Ir para visão geral',
        'Add attachment' => 'Adicionar anexo',
        'List' => 'Lista',
        'Validity' => '',
        'No data found.' => 'Nenhum dado encontrado.',
        'Download file' => 'Baixar arquivo',
        'Delete this attachment' => 'Deletar este anexo',
        'Add Attachment' => 'Adicionar anexo',
        'Edit Attachment' => 'Alterar anexo',
        'This field is required.' => 'Este campo é requerido.',
        'or' => 'ou',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Administração de Autorrespostas',
        'Add auto response' => 'Adicionar autorresposta',
        'Add Auto Response' => 'Adicionar Autorresposta',
        'Edit Auto Response' => 'Alterar autorresposta',
        'Response' => 'Resposta',
        'Auto response from' => 'Autorresposta de',
        'Reference' => 'Referência',
        'You can use the following tags' => 'Você pode usar os seguintes rótulos',
        'To get the first 20 character of the subject.' => 'Para obter os primeiros 20 caracteres do assunto.',
        'To get the first 5 lines of the email.' => 'Para obter as primeiras 5 linhas do e-mail.',
        'To get the realname of the sender (if given).' => 'Para obter o nome real do remetente (se fornecido).',
        'To get the article attribute' => 'Para obter o atributo do artigo',
        ' e. g.' => 'ex.',
        'Options of the current customer user data' => 'Opções para os dados de usuário cliente atual',
        'Ticket owner options' => 'Opções do proprietário do chamado',
        'Ticket responsible options' => 'Opções do responsável pelo chamado',
        'Options of the current user who requested this action' => 'Opções do usuário atual que solicitou a ação',
        'Options of the ticket data' => 'Opções dos dados do chamado',
        'Config options' => 'Opções de Configuração',
        'Example response' => 'Resposta de exemplo',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'Gerenciamento de Empresa de Clientes',
        'Wildcards like \'*\' are allowed.' => '',
        'Add customer company' => 'Adicionar Empresa de Clientes',
        'Please enter a search term to look for customer companies.' => 'Por favor, insira um termo de pesquisa para procurar uma empresa de clientes.',
        'Add Customer Company' => 'Adicionar Empresa de Clientes',

        # Template: AdminCustomerUser
        'Customer Management' => 'Gerenciamento de Clientes',
        'Add customer' => 'Adicionar cliente',
        'Select' => 'Selecionar',
        'Hint' => 'Dica',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Os clientes são necessárias para o fornecimento do histórico do cliente e para a autenticação via painel do cliente.',
        'Please enter a search term to look for customers.' => 'Por favor, insira um termo de pesquisa para procurar clientes.',
        'Last Login' => 'Última autenticação',
        'Add Customer' => 'Adicionar Cliente',
        'Edit Customer' => 'Alterar Cliente',
        'This field is required and needs to be a valid email address.' =>
            'Este campo é obrigatório e deve ser um endereço de e-mail válido.',
        'This email address is not allowed due to the system configuration.' =>
            'Este endereço de e-mail não é permitido devido à configuração do sistema.',
        'This email address failed MX check.' => 'Para este endereço de e-mail, o teste MX falhou.',
        'DNS problem, please check your configuration and the error log.' =>
            '',
        'The syntax of this email address is incorrect.' => 'A sintaxe deste endereço de e-mail está incorreta.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Gerenciar Relações Clientes-Grupos',
        'Notice' => 'Aviso',
        'This feature is disabled!' => 'Esta funcionalidade está desabilitada!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Utilize esta funcionalidade apenas se desejar definir permissões de grupo para os clientes.',
        'Enable it here!' => 'Habilite-a aqui!',
        'Search for customers.' => '',
        'Edit Customer Default Groups' => 'Editar os grupos-padrão para clientes',
        'These groups are automatically assigned to all customers.' => 'Estes grupos serão atribuídos automaticamente a todos os clientes.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Você pode gerenciar estes grupos através do parâmetro de configuração "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filtros para Grupos',
        'Select the customer:group permissions.' => 'Selecione as permissões cliente:grupo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Se nada for selecionado, então não há permissões nesse grupo (chamados não estarão disponíveis para o cliente).',
        'Search Result:' => 'Resultado da pesquisa:',
        'Customers' => 'Clientes',
        'Groups' => 'Grupos',
        'No matches found.' => 'Keine Treffer gefunden.',
        'Change Group Relations for Customer' => 'Alterar as Relações de Grupo para o Cliente',
        'Change Customer Relations for Group' => 'Alterar as Relações de Cliente para o Grupo',
        'Toggle %s Permission for all' => 'Chavear a Permissão %s para todos',
        'Toggle %s permission for %s' => 'Chavear a permissão %s para %s',
        'Customer Default Groups:' => 'Grupos-padrão para clientes:',
        'No changes can be made to these groups.' => 'Nenhuma alteração pode ser feita a estes grupos.',
        'ro' => 'somente leitura',
        'Read only access to the ticket in this group/queue.' => 'Acesso somente leitura de chamados neste grupo/fila',
        'rw' => 'leitura e escrita',
        'Full read and write access to the tickets in this group/queue.' =>
            'Acesso de leitura e escrita de chamados neste grupo/fila',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Gerenciar Relações Clientes-Serviços',
        'Edit default services' => 'Alterar serviços-padrão',
        'Filter for Services' => 'Filtro para Serviços',
        'Allocate Services to Customer' => 'Alocar Serviços para Clientes',
        'Allocate Customers to Service' => 'Alocar Clientes para Serviços',
        'Toggle active state for all' => 'Chavear estado ativo para todos',
        'Active' => 'Ativo',
        'Toggle active state for %s' => 'Chavear estado ativo para %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '',
        'Add new field for object' => '',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => '',
        'Dynamic fields per page' => '',
        'Label' => '',
        'Order' => 'Ordem',
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
        'Default value' => 'Valor padrão',
        'This is the default value for this field.' => '',
        'Save' => 'Salvar',

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
        'Note' => 'Nota',
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
        'Admin Notification' => 'Notificação Administrativa',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Este módulo permite aos administradores enviar mensagens para os atendentes, membros de grupo ou papel.',
        'Create Administrative Message' => 'Administratorennachricht erzeugen',
        'Your message was sent to' => 'Sua mensagem foi enviada para',
        'Send message to users' => 'Enviar mensagem para usuários',
        'Send message to group members' => 'Enviar mensagem para membros de grupo',
        'Group members need to have permission' => 'Membros de grupo precisam ter permissão',
        'Send message to role members' => 'Enviar mensagem para membros de papel',
        'Also send to customers in groups' => 'Enviar também para clientes nos grupos',
        'Body' => 'Corpo',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Atendente Genérico',
        'Add job' => 'Adicionar Tarefa',
        'Last run' => 'Última execução',
        'Run Now!' => 'Executar Agora',
        'Delete this task' => 'Excluir esta tarefa',
        'Run this task' => 'Executar esta tarefa',
        'Job Settings' => 'Configurações de tarefa',
        'Job name' => 'Tarefa',
        'Currently this generic agent job will not run automatically.' =>
            'Atualmente, esse trabalho do atendente genérico não será executado automaticamente.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Para habilitar a execução automática, selecione pelo menos um valor de minutos, horas e dias!',
        'Schedule minutes' => 'Minuto(s) do agendamento',
        'Schedule hours' => 'Hora(s) do agendamento',
        'Schedule days' => 'Dia(s) do agendamento',
        'Toggle this widget' => 'Chavear este dispositivo',
        'Ticket Filter' => 'Filtro de Chamado',
        '(e. g. 10*5155 or 105658*)' => '(ex.: 10*5155 or 105658*)',
        '(e. g. 234321)' => '(ex.: 234321)',
        'Customer login' => 'Autenticação de cliente',
        '(e. g. U5150)' => '(ex.: U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Pesquisa textual completa no artigo (ex. "Mar*in" ou "Baue*").',
        'Agent' => 'Atendente',
        'Ticket lock' => 'Chamado bloqueado',
        'Create times' => 'Horários de Criação',
        'No create time settings.' => 'Ignorar horários de criação',
        'Ticket created' => 'Chamado criado',
        'Ticket created between' => 'Chamado criada entre',
        'Change times' => '',
        'No change time settings.' => 'Ignorar horários de alteração.',
        'Ticket changed' => 'Chamado alterado',
        'Ticket changed between' => 'Chamado alterado entre',
        'Close times' => 'Horários de Fechamento',
        'No close time settings.' => 'Ignorar horários de fechamento',
        'Ticket closed' => 'Chamado fechado',
        'Ticket closed between' => 'Chamado fechado entre',
        'Pending times' => 'Horários Pendentes',
        'No pending time settings.' => 'Sem configuração de horário pendente',
        'Ticket pending time reached' => 'Prazo de chamado pendente expirado',
        'Ticket pending time reached between' => 'Prazo de chamado pendente expirado entre',
        'Escalation times' => 'Prazos de escalação',
        'No escalation time settings.' => 'Sem configuração de prazo de escalação',
        'Ticket escalation time reached' => 'Prazos de escalações expirado',
        'Ticket escalation time reached between' => 'Prazos de escalação expirado entre',
        'Escalation - first response time' => 'Escalação - Prazo da Primeira Resposta',
        'Ticket first response time reached' => 'Prazo de primeira resposta expirado',
        'Ticket first response time reached between' => 'Prazo de primeira resposta expirado entre',
        'Escalation - update time' => 'Escalação - Prazo de Atualização',
        'Ticket update time reached' => 'Prazo de atualização expirado',
        'Ticket update time reached between' => 'Prazo de atualização expirado entre',
        'Escalation - solution time' => 'Escalação - Prazo de Solução',
        'Ticket solution time reached' => 'Prazo de solução expirado',
        'Ticket solution time reached between' => 'Prazo de solução expirado entre',
        'Archive search option' => 'Opção de pesquisa de arquivo',
        'Ticket Action' => 'Ação-Chamado',
        'Set new service' => 'Configurar novo serviço',
        'Set new Service Level Agreement' => 'Configurar novo Acordo de Níve de Serviço',
        'Set new priority' => 'Configurar nova prioridade',
        'Set new queue' => 'Configurar nova fila',
        'Set new state' => 'Configurar novo estado',
        'Set new agent' => 'Configurar novo atendente',
        'new owner' => 'Novo Proprietário',
        'new responsible' => '',
        'Set new ticket lock' => 'Configurar novo bloqueio de chamado',
        'New customer' => 'Novo Cliente',
        'New customer ID' => 'Novo ID de cliente',
        'New title' => 'Novo Título',
        'New type' => 'Novo Tipo',
        'New Dynamic Field Values' => '',
        'Archive selected tickets' => 'Arquivar chamados selecionados',
        'Add Note' => 'Adicionar Nota',
        'Time units' => 'Unidades de tempo',
        ' (work units)' => ' (unidades de trabalho)',
        'Ticket Commands' => 'Comandos-Chamado',
        'Send agent/customer notifications on changes' => 'Enviar notificações de alterações para atendente/cliente',
        'CMD' => 'Comando',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Este comando será executado. ARG[0] será o número do chamado. ARG[1] o id do chamado.',
        'Delete tickets' => 'Excluir chamados',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Atenção: Todos os chamados afetados serão removidos do banco de dados e não poderão ser restaurados!',
        'Execute Custom Module' => 'Executar módulo personalizado',
        'Param %s key' => 'Parâmetro chave %s',
        'Param %s value' => 'Valor do parâmetro %s',
        'Save Changes' => 'Salvar Alterações',
        'Results' => 'Resultados',
        '%s Tickets affected! What do you want to do?' => '%s chamados afetados! O que você quer fazer?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Atenção: Você usou a opção DELETE. Todos os chamados excluídos serão perdidos!',
        'Edit job' => 'Alterar tarefa',
        'Run job' => 'Executar tarefa',
        'Affected Tickets' => 'Chamados Afetados',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'Web Services' => '',
        'Debugger' => '',
        'Go back to web service' => '',
        'Clear' => '',
        'Do you really want to clear the debug log of this web service?' =>
            '',
        'Request List' => '',
        'Time' => 'Hora',
        'Remote IP' => '',
        'Loading' => 'Lade...',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Refresh' => 'Atualizar',
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
            'AVISO: Quando você altera o nome do grupo \'admin\', antes de fazer as alterações apropriadas no SysConfig, você será bloqueado para fora do painel de administração! Se isso acontecer, por favor renomeie de volta o grupo através de comandos SQL.',
        'Group Management' => 'Administração de Grupos',
        'Add group' => 'Adicionar grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'O grupo admin é para uso na área de administração e o grupo stats é para uso na área de estatísticas.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Crie novos grupos para manusear diferentes permissões de acesso para diferentes grupos de atendentes (ex. compras, produção, vendas...).',
        'It\'s useful for ASP solutions. ' => 'Isso é útil para soluções ASP.',
        'Add Group' => 'Adicionar grupo',
        'Edit Group' => 'Alterar grupo',

        # Template: AdminLog
        'System Log' => 'Registro do Sistema',
        'Here you will find log information about your system.' => 'Aqui você vai encontrar informações sobre eventos do seu sistema.',
        'Hide this message' => 'Esconder esta mensagem',
        'Recent Log Entries' => 'Entradas recentes de log',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Gerenciamento de Contas de E-mail',
        'Add mail account' => 'Adicionar conta de e-mail',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Todos os e-mails recebidos com uma conta serão ordenados na fila selecionada!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Se a sua conta for confiável, os headers "X-OTRS" já existentes no momento da recepção (por prioridade, ...) serão utilizados! O filtro será utilizado mesmo assim.',
        'Host' => 'Servidor',
        'Delete account' => 'Excluir conta',
        'Fetch mail' => 'Obter e-mails',
        'Add Mail Account' => 'Adicionar conta de e-mail',
        'Example: mail.example.com' => 'Exemplo: mail.exemplo.com',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'Confiável',
        'Dispatching' => 'Despachando',
        'Edit Mail Account' => 'Alterar conta de e-mail',

        # Template: AdminNavigationBar
        'Admin' => '',
        'Agent Management' => 'Gerenciamento de Atendente',
        'Queue Settings' => 'Configurações de Fila',
        'Ticket Settings' => 'Configurações de Chamado',
        'System Administration' => 'Administração do Sistema',

        # Template: AdminNotification
        'Notification Management' => 'Administração de Notificações',
        'Select a different language' => '',
        'Filter for Notification' => 'Filtro por Notificação',
        'Notifications are sent to an agent or a customer.' => 'Notificações serão enviadas para um Atedente ou Cliente.',
        'Notification' => 'Notificações',
        'Edit Notification' => 'Aletar notificação',
        'e. g.' => 'ex.',
        'Options of the current customer data' => 'Opções para os dados do cliente atual',

        # Template: AdminNotificationEvent
        'Add notification' => 'Adicionar notificação',
        'Delete this notification' => 'Excluir esta notificação',
        'Add Notification' => 'Adicionar Notificação',
        'Recipient groups' => 'Grupos destinatários',
        'Recipient agents' => 'Atendentes destinatários',
        'Recipient roles' => 'Papéis destinatários',
        'Recipient email addresses' => 'Endereços de e-mail destinatários',
        'Article type' => 'Tipo de artigo',
        'Only for ArticleCreate event' => 'Apenas para o evento ArticleCreate',
        'Subject match' => 'Casar assunto',
        'Body match' => 'Casar corpo',
        'Include attachments to notification' => 'Incluir anexos na notificação',
        'Notification article type' => 'Tipo de artigo de notificação',
        'Only for notifications to specified email addresses' => 'Apenas para notificações para os endereços de e-mail especificados',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Para buscar os primeiros 20 caracteres do assunto (do último artigo do atendente)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Para buscar as primeiras 5 linhas do corpo (do último artigo do atendente)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Para buscar os primeiros 20 caracteres do assunto (do último artigo do cliente)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Para buscar as primeiras 5 linhas do corpo (do último artigo do cliente)',

        # Template: AdminPGP
        'PGP Management' => 'Gerenciamento do PGP',
        'Use this feature if you want to work with PGP keys.' => 'Use esse recurso se você quiser trabalhar com chaves PGP.',
        'Add PGP key' => 'Adicionar chave PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Neste caso, você pode editar diretamente o "keyring" configurado no "SysConfig".',
        'Introduction to PGP' => 'Introdução ao PGP',
        'Result' => 'Resultado',
        'Identifier' => 'Identificador',
        'Bit' => '',
        'Fingerprint' => 'Impressão Digital',
        'Expires' => 'Expira',
        'Delete this key' => 'Excluir esta chave',
        'Add PGP Key' => 'Adicionar chave PGP',
        'PGP key' => 'Chave PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Gerenciador de Pacotes',
        'Uninstall package' => 'Desinstalar pacote',
        'Do you really want to uninstall this package?' => 'Você quer realmente desinstalar este pacote?',
        'Reinstall package' => 'Reinstalar pacote',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Você realmente quer reinstalar este pacote? Quaisquer alterações manuais serão perdidas.',
        'Continue' => 'Continuar',
        'Install' => 'Instalar',
        'Install Package' => 'Instalar Pacote',
        'Update repository information' => 'Atualizar informação de repositório',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'Repositório Online',
        'Vendor' => 'Fornecedor',
        'Module documentation' => 'Documentação do Módulo',
        'Upgrade' => 'Atualizar Versão',
        'Local Repository' => 'Repositório Local',
        'Uninstall' => 'Desinstalar',
        'Reinstall' => 'Reinstalar',
        'Feature Add-Ons' => '',
        'Download package' => 'Baixar pacote',
        'Rebuild package' => 'Reconstruir pacote',
        'Metadata' => 'Metadados',
        'Change Log' => 'Registro de alterações',
        'Date' => 'Data',
        'List of Files' => 'Lista de Arquivos',
        'Permission' => 'Permissões',
        'Download' => 'Baixar',
        'Download file from package!' => 'Baixar arquivo do pacote!',
        'Required' => 'Requerido',
        'PrimaryKey' => 'Chave Primária',
        'AutoIncrement' => 'Autoincremento',
        'SQL' => '',
        'File differences for file %s' => 'Diferenças de arquivo para o arquivo %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Registro de Desempenho',
        'This feature is enabled!' => 'Esta funcionalidade está habilitada!',
        'Just use this feature if you want to log each request.' => 'Use esta funcionalidade se você quiser logar cada requisição.',
        'Activating this feature might affect your system performance!' =>
            'Ao ativar esta funcionalidade pode-se afetar o desempenho do seu sistema!',
        'Disable it here!' => 'Desabilite-o aqui!',
        'Logfile too large!' => 'Arquivo de registro muito grande!',
        'The logfile is too large, you need to reset it' => 'O arquivo de registro está muito grande, você precisa reiniciá-lo',
        'Overview' => 'Visão Geral',
        'Range' => 'Intervalo',
        'Interface' => 'Interface',
        'Requests' => 'Requisições',
        'Min Response' => 'Tempo mínimo de resposta',
        'Max Response' => 'Tempo máximo de resposta',
        'Average Response' => 'Média de tempo de resposta',
        'Period' => 'Período',
        'Min' => 'Mín.',
        'Max' => 'Máx.',
        'Average' => 'Média',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gerenciamento de Filtros (Postmaster)',
        'Add filter' => 'Adicionar filtro',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Para encaminhamento ou filtragem de e-mails recebidos com base em cabeçalhos de e-mail. O casamento usando expressões regulares também é possível.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Se você deseja corresponder apenas o endereço de e-mail, use EMAILADDRESS: info@exemplo.com em De, Para ou Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Se você usar Expressões Regulares, você também pode usar o valor encontrado em () como [***] na ação \'Set\'.',
        'Delete this filter' => 'Excluir este filtro',
        'Add PostMaster Filter' => 'Adicionar filtro PostMaster',
        'Edit PostMaster Filter' => 'Alterar filtro PostMaster',
        'Filter name' => 'Nome do filtro',
        'The name is required.' => '',
        'Stop after match' => 'Parar após encontrar',
        'Filter Condition' => 'Condição do filtro',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => 'Configurar cabeçalhos de e-mail',
        'The field needs to be a literal word.' => '',

        # Template: AdminPriority
        'Priority Management' => 'Gerenciamento de Prioridade',
        'Add priority' => 'Adicionar prioridade',
        'Add Priority' => 'Adicionar Prioridade',
        'Edit Priority' => 'Alterar Prioridade',

        # Template: AdminQueue
        'Manage Queues' => 'Gerenciar Filas',
        'Add queue' => 'Adicionar filas',
        'Add Queue' => 'Adicionar Filas',
        'Edit Queue' => 'Alterar Filas',
        'Sub-queue of' => 'Subfila de',
        'Unlock timeout' => 'Tempo de expiração de desbloqueio',
        '0 = no unlock' => '0 = sem desbloqueio',
        'Only business hours are counted.' => 'Apenas horas úteis são contadas.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Se um atendente bloqueiar um chamado e não fechá-lo antes de expirado o tempo limite de desbloqueio, o chamado será desbloqueado e ficará disponível para outros atendentes.',
        'Notify by' => 'Notificar por',
        '0 = no escalation' => '0 = sem escalação',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Se não há um contato com o cliente adicionado, seja por e-mail externo ou telefone, ao novo chamado antes do tempo definido aqui expirar, o chamado é escalado.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Se há um artigo adicionado, tais como acompanhamento via e-mail ou no portal do cliente, o tempo de atualização da escalada é reiniciado. Se não houver um contato com o cliente, seja por e-mail externo ou telefone, adicionado ao chamado antes de o tempo definido aqui expirar, o chamado é escalado.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Se o chamado não é definido como fechado antes de tempo definido aqui expirar, o ticket é escalado.',
        'Follow up Option' => 'Opção de acompanhamento',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Especifica se o acompanhamento de um chamado fechado deve reabri-lo, ser rejeitada ou conduzir a um novo chamado.',
        'Ticket lock after a follow up' => 'Bloqueio do chamado após um acompanhamento',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Se um chamado está fechado e o cliente envia um acompanhamento, o chamado será bloqueado para o antigo proprietário.',
        'System address' => 'Endereço de Sistema',
        'Will be the sender address of this queue for email answers.' => 'Será o endereço de remetente desta fila para respostas por e-mail.',
        'Default sign key' => 'Chave de assinatura padrão',
        'The salutation for email answers.' => 'A saudação para respostas por e-mail.',
        'The signature for email answers.' => 'A assinatura para respostas por e-mail.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Gerenciar Relações Autorresposta-Fila',
        'Filter for Queues' => 'Filtro para Filas',
        'Filter for Auto Responses' => 'Filtro para autorrespostas',
        'Auto Responses' => 'Autorrespostas',
        'Change Auto Response Relations for Queue' => 'Alterar Relações Autorresposta para Filas',
        'settings' => 'configurações',

        # Template: AdminQueueResponses
        'Manage Response-Queue Relations' => 'Gerenciar Relações Resposta-Fila',
        'Filter' => 'Filtro',
        'Filter for Responses' => 'Filtro para Respostas',
        'Responses' => 'Respostas',
        'Change Queue Relations for Response' => 'Alterar Relações de Fila para Resposta',
        'Change Response Relations for Queue' => 'Alterar Relações de Resposta para Fila',

        # Template: AdminResponse
        'Manage Responses' => 'Gerenciar Respostas',
        'Add response' => 'Adicionar resposta',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            '',
        'Don\'t forget to add new responses to queues.' => '',
        'Delete this entry' => 'Excluir esta entrada',
        'Add Response' => 'Adicionar Resposta',
        'Edit Response' => 'Alterar Resposta',
        'The current ticket state is' => 'O estado atual do chamado é',
        'Your email address is' => 'Seu endereço de e-mail é',

        # Template: AdminResponseAttachment
        'Manage Responses <-> Attachments Relations' => 'Gerenciar Relações Respostas <-> Anexos',
        'Filter for Attachments' => 'Filtro para Anexos',
        'Change Response Relations for Attachment' => 'Alterar Relações de Resposta para Anexo',
        'Change Attachment Relations for Response' => 'Alterar Relações de Anexo para Resposta',
        'Toggle active for all' => 'Chavear ativado para todos',
        'Link %s to selected %s' => 'Associar %s ao %s selecionado',

        # Template: AdminRole
        'Role Management' => 'Gerenciamento de Papéis',
        'Add role' => 'Adicionar papel',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Crie um papel e relacione grupos a ele. Então adicione papéis aos usuários.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Até o momento, não há papéis definidos. Por favor, use o botão "Adicionar Papel" para criar um novo papel.',
        'Add Role' => 'Adicionar Papel',
        'Edit Role' => 'Alterar Papel',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Gerenciar Relações Papel-Grupo',
        'Filter for Roles' => 'Filtro para Papéis',
        'Roles' => 'Papéis',
        'Select the role:group permissions.' => 'Selecione as permissões papel:grupo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Se nada for selecionado, então não há permissões neste grupo (chamados não estarão disponíveis para o papel).',
        'Change Role Relations for Group' => 'Alterar Relações de Papel para Grupo',
        'Change Group Relations for Role' => 'Alterar Relações de Grupo para Papel',
        'Toggle %s permission for all' => 'Chavear permissão %s para todos',
        'move_into' => 'mover_para',
        'Permissions to move tickets into this group/queue.' => 'Permissões para mover chamados para este grupo/fila.',
        'create' => 'criar',
        'Permissions to create tickets in this group/queue.' => 'Permissões para criar chamados neste grupo/fila. ',
        'priority' => 'prioridade',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permissões para alterar a prioridade do chamado neste grupo/fila.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Gerenciar Relações Atendente-Papel',
        'Filter for Agents' => 'Filtro para Atendentes',
        'Agents' => 'Atendentes',
        'Manage Role-Agent Relations' => 'Gerenciar Relações Papel-Atendente',
        'Change Role Relations for Agent' => 'Alterar Relações de Papel para Atendente',
        'Change Agent Relations for Role' => 'Alterar Relações de Atendente para Papel',

        # Template: AdminSLA
        'SLA Management' => 'Gerenciamento de SLA',
        'Add SLA' => 'Adicionar SLA',
        'Edit SLA' => 'Alterar SLA',
        'Please write only numbers!' => 'Por favor, escreva apenas números!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gerenciamento S/MIME',
        'Add certificate' => 'Adicionar Certificado',
        'Add private key' => 'Adicionar Chave Privada',
        'Filter for certificates' => '',
        'Filter for SMIME certs' => '',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Veja também',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Neste caso, você pode editar diretamente a certificação e chaves privadas no sistema de arquivos.',
        'Hash' => '',
        'Create' => 'Criar',
        'Handle related certificates' => '',
        'Delete this certificate' => 'Excluir este certificado',
        'Add Certificate' => 'Adicionar Certificado',
        'Add Private Key' => 'Adicionar Chave Privada',
        'Secret' => 'Senha',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => '',
        'Relate this certificate' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Gerenciamento de Saudação',
        'Add salutation' => 'Adicionar saudação',
        'Add Salutation' => 'Adicionar Saudação',
        'Edit Salutation' => 'Alterar Saudação',
        'Example salutation' => 'Saudação de exemplo',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            '',
        'Start scheduler' => '',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            '',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'O modo seguro precisa ser habilitado!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'O modo seguro é (normalmente) configurado após a instalação estar completa.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'O modo seguro deve estar desabilitado para reinstalar utilizando o instalador web.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Se o modo seguro não estiver ativado, ative-o através do SysConfig, porque sua aplicação já está executando.',

        # Template: AdminSelectBox
        'SQL Box' => 'Comandos SQL',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Aqui você pode entrar consultas SQL para enviá-las diretamente ao banco de dados do aplicativo.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'A sintaxe da sua consulta SQL está incorreta. Por favor, verifique.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Há pelo menos um parâmetro ausente para a ligação. Por favor, verifique.',
        'Result format' => 'Formato de resultado',
        'Run Query' => 'Executar consulta',

        # Template: AdminService
        'Service Management' => 'Gerenciamento de Serviços',
        'Add service' => 'Adicionar serviço',
        'Add Service' => 'Adicionar Serviço',
        'Edit Service' => 'Alterar Serviço',
        'Sub-service of' => 'Subserviço de',

        # Template: AdminSession
        'Session Management' => 'Gerenciamento de Sessões',
        'All sessions' => 'Todas as sessões',
        'Agent sessions' => 'Sessões de atendente',
        'Customer sessions' => 'Sessões de cliente',
        'Unique agents' => 'Atendentes únicos',
        'Unique customers' => 'Clientes únicos',
        'Kill all sessions' => 'Finalizar todas as sessões',
        'Kill this session' => 'Finalizar esta sessão',
        'Session' => 'Sessão',
        'Kill' => 'Finalizar',
        'Detail View for SessionID' => 'Detalhes da SessãoID',

        # Template: AdminSignature
        'Signature Management' => 'Gerenciamento de Assinaturas',
        'Add signature' => 'Adicionar assinatura',
        'Add Signature' => 'Adicionar Assinatura',
        'Edit Signature' => 'Alterar Assinatura',
        'Example signature' => 'Assinatura de exemplo',

        # Template: AdminState
        'State Management' => 'Gerenciamento de Estado',
        'Add state' => 'Adicionar estado',
        'Please also update the states in SysConfig where needed.' => '',
        'Add State' => 'Adicionar Estado',
        'Edit State' => 'Alterar Estado',
        'State type' => 'Tipo de Estado',

        # Template: AdminSysConfig
        'SysConfig' => 'Configuração do Sistema',
        'Navigate by searching in %s settings' => 'Navegar por meio de pesquisa nas configurações %s',
        'Navigate by selecting config groups' => 'Navegar selecionando os grupos de configuração',
        'Download all system config changes' => 'Baixar todas as alterações na configuraão do sistema',
        'Export settings' => 'Exportar configurações',
        'Load SysConfig settings from file' => 'Carregar configurações SysConfig de um arquivo',
        'Import settings' => 'Importar configurações',
        'Import Settings' => 'Importar Configurações',
        'Please enter a search term to look for settings.' => 'Por favor, entre com um termo de pesquisa para procurar configurações.',
        'Subgroup' => 'Subgrupo',
        'Elements' => 'Elementos',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Alterar Configurações Config',
        'This config item is only available in a higher config level!' =>
            'Este item de configuração está disponível apenas em um nível mais elevado de configuração!',
        'Reset this setting' => 'Reiniciar esta configuração',
        'Error: this file could not be found.' => 'Erro: este arquivo não pôde ser encontrado.',
        'Error: this directory could not be found.' => 'Erro: este diretório não pôde ser encontrado.',
        'Error: an invalid value was entered.' => 'Erro: um valor inválido foi digitado.',
        'Content' => 'Conteúdo',
        'Remove this entry' => 'Remover esta entrada',
        'Add entry' => 'Adicionar entrada',
        'Remove entry' => 'Remover entrada',
        'Add new entry' => 'Adicionar nova entrada',
        'Create new entry' => 'Criar nova entrada',
        'New group' => 'Novo Grupo',
        'Group ro' => 'Grupo ro',
        'Readonly group' => 'Grupo somente leitura',
        'New group ro' => 'Novo Grupo somente leitura',
        'Loader' => 'Carregador',
        'File to load for this frontend module' => 'Arquivo para carregar para este módulo de interface',
        'New Loader File' => 'Novo Arquivo de Carga',
        'NavBarName' => 'Nome da Barra de Navegação',
        'NavBar' => 'Barra de Navegação',
        'LinkOption' => 'OpçãoLink',
        'Block' => 'Bloquear',
        'AccessKey' => 'Chave de Acesso',
        'Add NavBar entry' => 'Adicionar entrada de barra de navegação',
        'Year' => 'Ano',
        'Month' => 'Mês',
        'Day' => 'Dia',
        'Invalid year' => 'Ano inválido',
        'Invalid month' => 'Mês inválido',
        'Invalid day' => 'Dia inválido',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Gerenciamento de Endereço de E-mail de Sistema',
        'Add system address' => 'Adicionar Endereços de Sistema',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Todos os e-mails recebidos com este endereço no campo Para ou Cc serão encaminhados para a fila selecionada.',
        'Email address' => 'Endereço de e-mail',
        'Display name' => 'Nome de exibição',
        'Add System Email Address' => 'Adicionar Endereço de e-mail de Sistema',
        'Edit System Email Address' => 'Alterar Endereço de e-mail de Sistema',
        'The display name and email address will be shown on mail you send.' =>
            'O nome de exibição e endereço de e-mail serão mostrados no e-mail que você enviar.',

        # Template: AdminType
        'Type Management' => 'Gerenciamento de Tipo',
        'Add ticket type' => 'Adicionar tipo de chamado',
        'Add Type' => 'Adicionar Tipo',
        'Edit Type' => 'Alterar Tipo',

        # Template: AdminUser
        'Add agent' => 'Adicionar atendente',
        'Agents will be needed to handle tickets.' => 'Atendentes serão necessários para lidar com os chamados.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Não se esqueça de adicionar o novo agente a grupos e/ou papéis!',
        'Please enter a search term to look for agents.' => 'Por favor, digite um termo de pesquisa para localizar atendentes.',
        'Last login' => 'Último login',
        'Login as' => 'Logar-se como',
        'Switch to agent' => 'Trocar para o atendente',
        'Add Agent' => 'Adicionar Atendente',
        'Edit Agent' => 'Alterar Atendente',
        'Firstname' => 'Nome',
        'Lastname' => 'Sobrenome',
        'Password is required.' => '',
        'Start' => 'Início',
        'End' => 'fim',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gerenciar Relações Atendente-Grupo',
        'Change Group Relations for Agent' => 'Altetar Relações de Grupo para Atendente',
        'Change Agent Relations for Group' => 'Altetar Relações de Atendente para Grupo',
        'note' => 'nota',
        'Permissions to add notes to tickets in this group/queue.' => 'Permissões para adicionar notas aos chamados neste grupo/queue.',
        'owner' => 'proprietário',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Berechtigung zum Ändern des Besitzers von Tickets dieser Gruppe/Queue.',

        # Template: AgentBook
        'Address Book' => 'Catálogo de Endereços',
        'Search for a customer' => 'Procurar um cliente',
        'Add email address %s to the To field' => 'Adicionar endereço de e-mail %s ao campo "Para"',
        'Add email address %s to the Cc field' => 'Adicionar endereço de e-mail %s ao campo "Cc"',
        'Add email address %s to the Bcc field' => 'Adicionar endereço de e-mail %s ao campo "Cco"',
        'Apply' => 'Aplicar',

        # Template: AgentCustomerSearch
        'Search Customer' => 'Procurar cliente',
        'Duplicated entry' => '',
        'This address already exists on the address list.' => '',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Painel de Controle',

        # Template: AgentDashboardCalendarOverview
        'in' => 'em',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s está disponível!',
        'Please update now.' => 'Por favor atualize agora.',
        'Release Note' => 'Notas da Versão',
        'Level' => 'Nível',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Postado há %s atrás.',

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
        'The ticket has been locked' => 'O chamado foi bloqueado',
        'Undo & close window' => 'Desfazer e fechar janela',

        # Template: AgentInfo
        'Info' => 'Informação',
        'To accept some news, a license or some changes.' => 'Para aceitar algumas novidades, uma licença ou algumas mudanças.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Objeto Associado: %s',
        'Close window' => 'Fechar janela',
        'go to link delete screen' => 'ir para a tela de exclusão de associação',
        'Select Target Object' => 'Selecionar o Objeto Alvo',
        'Link Object' => 'Associar Objeto',
        'with' => 'com',
        'Unlink Object: %s' => 'Desassociar Objeto: %s',
        'go to link add screen' => 'ir para a tela de inclusão de associação',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Alterar suas preferências',

        # Template: AgentSpelling
        'Spell Checker' => 'Verificador Ortográfico',
        'spelling error(s)' => 'erro(s) ortográficos',
        'Apply these changes' => 'Aplicar estas modificações',

        # Template: AgentStatsDelete
        'Delete stat' => 'Escluir estatística',
        'Stat#' => 'Estatística Nº:.',
        'Do you really want to delete this stat?' => 'Você quer realmente excluir esta estatística?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Passo %s',
        'General Specifications' => 'Especificações Gerais',
        'Select the element that will be used at the X-axis' => 'Selecione o elemento que será usado no eixo X',
        'Select the elements for the value series' => 'Selecione os elementos para cada série de valores',
        'Select the restrictions to characterize the stat' => 'Selecione as restrições para caracterizar a estatística',
        'Here you can make restrictions to your stat.' => 'Aqui você pode criar as restrições da sua estatística',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Se você remover o gancho na caixa de seleção "Fixo", o atendente gerando a estatística pode mudar os atributos do elemento correspondente.',
        'Fixed' => 'Fixo',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Por favor, selecione apenas um elemento ou desabilite o botão "Fixo".',
        'Absolute Period' => 'Período Absoluto',
        'Between' => 'Entre',
        'Relative Period' => 'Período Relativo',
        'The last' => 'O último',
        'Finish' => 'Finalizar',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Permissões',
        'You can select one or more groups to define access for different agents.' =>
            'Você pode selecionar um ou mais grupos para definir o acesso de diferentes atendentes.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Alguns formatos de resultado estão desabilitados porque pelo menos um pacote necessário não está instalado.',
        'Please contact your administrator.' => 'Por favor, entre em contato com seu administrador.',
        'Graph size' => 'Tamanho do Gráfico',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Se você usar um gráfico como formato de saída você tem que selecionar pelo menos um tamanho de gráfico.',
        'Sum rows' => 'Somar linhas',
        'Sum columns' => 'Somar colunas',
        'Use cache' => 'Usar cache',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'A maioria das estatísticas podem ser mantidas em cache. Isto tornará sua visualização mais rápida.',
        'If set to invalid end users can not generate the stat.' => 'Se configurado como inválido, usuários finais não podem gerar a estatística.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Aqui você pode definir a série de valor.',
        'You have the possibility to select one or two elements.' => 'Você tem a possibilidade de selecionar um ou dois elementos.',
        'Then you can select the attributes of elements.' => 'Então você pode selecionar os atributos dos elementos.',
        'Each attribute will be shown as single value series.' => 'Cada atributo será mostrado como uma única série de valor.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Se você não selecionar algum atributo, todos os atributos do elemento serão utilizados se você gerar uma estatística, bem como novos atributos que foram adicionados desde a última configuração.',
        'Scale' => 'Escala',
        'minimal' => 'mínimo',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Lembre que a escala para o conjunto de valores deve ser mair que o eixo X (ex.: Eixo X => Mês, Conjunto de Valores => Ano).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Aqui você pode definir o eixo-x. Você pode selecionar um elemento através do botão de rádio.',
        'maximal period' => 'período máximo',
        'minimal scale' => 'período mínimo',

        # Template: AgentStatsImport
        'Import Stat' => 'Statistik importieren',
        'File is not a Stats config' => 'Este não é um arquivo de configuração',
        'No File selected' => 'Nenhum arquivo selecionado',

        # Template: AgentStatsOverview
        'Stats' => 'Estatísticas',

        # Template: AgentStatsPrint
        'Print' => 'Imprimir',
        'No Element selected.' => 'Nenhum elemento selecionado.',

        # Template: AgentStatsView
        'Export config' => 'Exportar configuração',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Com os campos de entrada e seleção você pode influenciar o formato e o conteúdo da estatística.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Exatamente quais campos e formatos você pode influenciar é definido pelo administrador da estatística.',
        'Stat Details' => 'Detalhes da Estatística',
        'Format' => 'Formato',
        'Graphsize' => 'Tamanho do Gráfico',
        'Cache' => '',
        'Exchange Axis' => 'Trocar Eixo',
        'Configurable params of static stat' => 'Parâmetros configuráveis da estatística estática',
        'No element selected.' => 'Nenhum elemento selecionado.',
        'maximal period from' => 'máximo perído de',
        'to' => 'para',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Alterar os campos livres do chamado',
        'Change Owner of Ticket' => 'Modificar o proprietário do chamado',
        'Close Ticket' => 'Fechar Chamado',
        'Add Note to Ticket' => 'Adicionar Nota ao Chamado',
        'Set Pending' => 'Configurar como Pendente',
        'Change Priority of Ticket' => 'Modificar a Prioridade do Chamado',
        'Change Responsible of Ticket' => 'Alterar o Responsável pelo Chamado',
        'Cancel & close window' => 'Cancelar e fechar a janela',
        'Service invalid.' => 'Serviço inválido.',
        'New Owner' => 'Novo Proprietário',
        'Please set a new owner!' => 'Por favor, configure um novo proprietário!',
        'Previous Owner' => 'Proprietário Anterior',
        'Inform Agent' => 'Informar Atendente',
        'Optional' => 'Opcional',
        'Inform involved Agents' => 'Informar aos atendentes envolvidos',
        'Spell check' => 'Verificar Ortografia',
        'Note type' => 'Tipo de nota',
        'Next state' => 'Próximo estado',
        'Pending date' => 'Data de pendência',
        'Date invalid!' => 'Data inválida!',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => '',
        'Bounce to' => 'Devolver para',
        'You need a email address.' => 'Você precisa de um endereço de e-mail.',
        'Need a valid email address or don\'t use a local email address.' =>
            'ecessita de um endereço de e-mail válido; não use endereços de e-mail locais.',
        'Next ticket state' => 'Próximo estado do chamado',
        'Inform sender' => 'Informar ao remetente',
        'Send mail!' => 'Enviar e-mail!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ação em Massa em Chamado',
        'Send Email' => '',
        'Merge to' => 'Agrupar com',
        'Invalid ticket identifier!' => 'Identificador de chamado inválido!',
        'Merge to oldest' => 'Agrupar com o mais antigo',
        'Link together' => 'Associar junto',
        'Link to parent' => 'Associar ao Pai',
        'Unlock tickets' => 'Desbloquear chamados',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Compôr uma resposta para o chamado',
        'Remove Ticket Customer' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Please include at least one recipient' => '',
        'Remove Cc' => '',
        'Remove Bcc' => '',
        'Address book' => 'Catálogo de endereços',
        'Pending Date' => 'Data de pendência',
        'for pending* states' => 'em estado pendente*',
        'Date Invalid!' => 'Data Inválida!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Modificar o cliente do chamado',
        'Customer Data' => 'Dados do Cliente',
        'Customer user' => 'Usuário cliente',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Criar Novo Chamado E-mail',
        'From queue' => 'Da fila',
        'To customer' => '',
        'Please include at least one customer for the ticket.' => '',
        'Get all' => 'Obter todos',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => '',
        'Need a valid email address or don\'t use a local email address' =>
            'Necessita de um endereço de e-mail válido; não use endereços de e-mail locais.',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Histórico de',
        'History Content' => 'Conteúdo do Histórico',
        'Zoom view' => 'Visão de Zoom',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Agrupar Chamado',
        'You need to use a ticket number!' => 'Você deve utilizar um número de chamado!',
        'A valid ticket number is required.' => 'Um número de chamado válido é requerido.',
        'Need a valid email address.' => 'É necessário um endereço de e-mail válido.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Mover Chamado',
        'New Queue' => 'Nova Fila',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Selecionar todos',
        'No ticket data found.' => 'Nenhum dado de chamado encontrado.',
        'First Response Time' => 'Primeiro Tempo de Resposta',
        'Service Time' => 'Tempo de Serviço',
        'Update Time' => 'Tempo de Atualizaçao',
        'Solution Time' => 'Tempo de Solução',
        'Move ticket to a different queue' => 'Mover chamado para uma fila diferente',
        'Change queue' => 'Modificar fila',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Alterar as opções de busca',
        'Tickets per page' => 'Chamados por página',

        # Template: AgentTicketOverviewPreview
        '","26' => '',

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'Escalação em',
        'Locked' => 'Bloqueio',
        '","30' => '',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Criar novo Chamado Fone',
        'From customer' => 'Do cliente',
        'To queue' => 'Para a fila',

        # Template: AgentTicketPhoneCommon
        'Phone call' => 'Chamada Telefônica',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Visualização de e-mail em texto plano',
        'Plain' => 'Plano',
        'Download this email' => 'Baixar este e-mail',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Dados do chamado',
        'Accounted time' => 'Tempo contabilizado',
        'Linked-Object' => 'Objeto "associado"',
        'by' => 'por',

        # Template: AgentTicketPriority

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Procurar modelo',
        'Create Template' => 'Criar Modelo',
        'Create New' => 'Criar Novo',
        'Profile link' => '',
        'Save changes in template' => 'Salvar mudanças no modelo',
        'Add another attribute' => 'Adicionar outro atributo',
        'Output' => 'Saída',
        'Fulltext' => 'Texto Completo',
        'Remove' => 'Remover',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Login de Cliente',
        'Created in Queue' => 'Criado na Fila',
        'Lock state' => 'Trancar estado',
        'Watcher' => 'Monitorante',
        'Article Create Time (before/after)' => 'Tempo de Criação do Artigo (antes/depois)',
        'Article Create Time (between)' => 'Tempo de Criação do Artigo (entre)',
        'Ticket Create Time (before/after)' => 'Tempo de Criação do Chamado (antes/depois)',
        'Ticket Create Time (between)' => 'Tempo de Criação do Chamado (entre)',
        'Ticket Change Time (before/after)' => 'Tempo de Modificação do Chamado (antes/depois)',
        'Ticket Change Time (between)' => 'Tempo de Modificação do Chamado (entre)',
        'Ticket Close Time (before/after)' => 'Tempo de Fechamento do Chamado (antes/depois)',
        'Ticket Close Time (between)' => 'Tempo de Fechamento do Chamado (durante)',
        'Archive Search' => 'Procurar Arquivo',
        'Run search' => '',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Filtro por artigo',
        'Article Type' => 'Tipo de Artigo',
        'Sender Type' => 'Tipo de Remetente',
        'Save filter settings as default' => 'Salvar configurações de filtro como padrão',
        'Ticket Information' => 'Informação do Chamado',
        'Linked Objects' => 'Objetos Associados',
        'Article(s)' => 'Artigo(s)',
        'Change Queue' => 'Modificar Fila',
        'Article Filter' => 'Filtro de Artigo',
        'Add Filter' => 'Adicionar Filtro',
        'Set' => 'Configurar',
        'Reset Filter' => 'Reiniciar Filtro',
        'Show one article' => 'Exibir um artigo',
        'Show all articles' => 'Exibir todos os artigos',
        'Unread articles' => 'Artigos não lidos',
        'No.' => 'Núm.',
        'Unread Article!' => 'Artigo não Lido!',
        'Incoming message' => 'Mensagem de entrada',
        'Outgoing message' => 'Mensagem de saída',
        'Internal message' => 'Mensagem interna',
        'Resize' => 'Redimensionar',

        # Template: AttachmentBlocker
        'To protect your privacy, active or/and remote content has blocked.' =>
            'Para proteger sua privacidade, conteúdo ativos e/ou foi bloqueado.',
        'Load blocked content.' => 'Carregar conteúdo bloqueado.',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Rastreamento',

        # Template: CustomerFooter
        'Powered by' => 'Desenvolvido por',
        'One or more errors occurred!' => 'Um ou mais erros ocorreram!',
        'Close this dialog' => 'Fechar este diálogo',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Não foi possível abrir a janela popup. Desative os bloqueadores de popup para esta aplicação.',

        # Template: CustomerHeader

        # Template: CustomerLogin
        'Login' => '',
        'User name' => 'Nome de usuário',
        'Your user name' => 'Seu nome de usuário',
        'Your password' => 'Sua senha',
        'Forgot password?' => 'Esqueceu a senha?',
        'Log In' => 'Entrar',
        'Not yet registered?' => 'Não registrado ainda?',
        'Sign up now' => 'Entrar agora',
        'Request new password' => 'Solicitar uma nova senha',
        'Your User Name' => 'Seu Nome de Usuário',
        'A new password will be sent to your email address.' => 'Uma nova senha será enviada ao seu e-mail.',
        'Create Account' => 'Criar Conta',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => 'Como devemos descrever você?',
        'Your First Name' => 'Seu Primeiro Nome',
        'Please supply a first name' => 'Por favor, forneça o primeiro nome',
        'Your Last Name' => 'Seu Último Nome',
        'Please supply a last name' => 'Por favor, forneça o último nome',
        'Your email address (this will become your username)' => '',
        'Please supply a' => 'Por favor, forneça um(a)',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Alterar preferências pessoais',
        'Logout %s' => '',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Acordo de nível de serviço',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Bem-vindo!',
        'Please click the button below to create your first ticket.' => 'Por favor, clique no botão abaixo para criar o seu primeiro chamado.',
        'Create your first ticket' => 'Criar seu primeiro chamado',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Impressão de Chamado',

        # Template: CustomerTicketSearch
        'Profile' => 'Perfil',
        'e. g. 10*5155 or 105658*' => 'ex. 10*5155 ou 105658*',
        'Customer ID' => 'Cliente ID',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Busca de texto completa em chamados (ex. "J*ão" ou "Carl*")',
        'Recipient' => 'Destinatário',
        'Carbon Copy' => 'Cópia',
        'Time restrictions' => 'Restrições de tempo',
        'No time settings' => '',
        'Only tickets created' => 'Apenas chamados criados',
        'Only tickets created between' => 'Apenas chamados criados entre',
        'Ticket archive system' => '',
        'Save search as template?' => '',
        'Save as Template?' => 'Salvar como Modelo?',
        'Save as Template' => '',
        'Template Name' => 'Nome do Modelo',
        'Pick a profile name' => '',
        'Output to' => 'Saída em',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Page' => 'Página',
        'Search Results for' => 'Resultados da pesquisa para',

        # Template: CustomerTicketZoom
        '","18' => '',
        'Expand article' => 'Expandir artigo',
        'Reply' => 'Responder',

        # Template: CustomerWarning

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Data inválida (é necessária uma data futura)!',
        'Previous' => 'Anterior',
        'Sunday' => 'Domingo',
        'Monday' => 'Segunda',
        'Tuesday' => 'Terça',
        'Wednesday' => 'Quarta',
        'Thursday' => 'Quinta',
        'Friday' => 'Sexta',
        'Saturday' => 'Sábado',
        'Su' => 'D',
        'Mo' => 'S',
        'Tu' => 'T',
        'We' => 'Q',
        'Th' => 'Q',
        'Fr' => 'S',
        'Sa' => 'S',
        'Open date selection' => 'Abrir seleção de data',

        # Template: Error
        'Oops! An Error occurred.' => 'Opa! Um erro ocorreu.',
        'Error Message' => 'Mensagem de Erro',
        'You can' => 'Você pode',
        'Send a bugreport' => 'Enviar um relatório de erro',
        'go back to the previous page' => 'retornar à página anterior',
        'Error Details' => 'Detalhes do Erro',

        # Template: Footer
        'Top of page' => 'Topo da Página',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Se você sair desta página agora, todas as janelas popup aberta serão fechada também!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Um popup desta janela já está aberto. Você quer fechá-lo e carregar este no lugar?',
        'Please enter at least one search value or * to find anything.' =>
            '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'You are logged in as' => 'Você está logado como',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript não habilitado ou não é suportado.',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'A fim de experimentar o OTRS, você deve habilitar o JavaScript no seu navegador.',
        'Database Settings' => 'Configurações de Banco de Dados',
        'General Specifications and Mail Settings' => 'Especificações Gerais e Configurações de E-mail',
        'Registration' => '',
        'Welcome to %s' => 'Bem-vindo ao %s',
        'Web site' => 'Website',
        'Database check successful.' => 'Êxito na verificação de banco de dados.',
        'Mail check successful.' => 'Êxito na verificação de e-mail.',
        'Error in the mail settings. Please correct and try again.' => 'Erro nas configurações de e-mail. Por favor, corrija e tente novamente.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configurar E-mail de Saída',
        'Outbound mail type' => 'Tipo de E-mail de Saída',
        'Select outbound mail type.' => 'Selecione o tipo de e-mail de saída.',
        'Outbound mail port' => 'Porta do e-mail de saída',
        'Select outbound mail port.' => 'Selecionar a porta do e-mail de saída.',
        'SMTP host' => 'Servidor SMTP',
        'SMTP host.' => 'Servidor SMTP.',
        'SMTP authentication' => 'Autenticação SMPT',
        'Does your SMTP host need authentication?' => 'Seu servidor SMTP precisa de autenticação?',
        'SMTP auth user' => 'Usuário de autenticação SMTP',
        'Username for SMTP auth.' => 'Usuário para autenticação SMTP.',
        'SMTP auth password' => 'Senha de autenticação SMTP',
        'Password for SMTP auth.' => 'Senha para autenticação SMTP.',
        'Configure Inbound Mail' => 'Configurar E-mail de Entrada',
        'Inbound mail type' => 'Tipo de e-mail de entrada',
        'Select inbound mail type.' => 'Selecionar tipo de e-mail de entrada',
        'Inbound mail host' => 'Servidor de e-mail de entrada',
        'Inbound mail host.' => 'Servidor de e-mail de entrada.',
        'Inbound mail user' => 'Usuário de e-mail de entrada',
        'User for inbound mail.' => 'Usuário para e-mail de entrada.',
        'Inbound mail password' => 'Senha de e-mail de entrada',
        'Password for inbound mail.' => 'Senha para e-mail de entrada.',
        'Result of mail configuration check' => 'Resultado da verificação da configuração de e-mail',
        'Check mail configuration' => 'Verificar configuração de e-mail',
        'Skip this step' => 'Pular este passo',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            '',

        # Template: InstallerDBResult
        'False' => 'Falso',

        # Template: InstallerDBStart
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Se você tiver definido uma senha de root para o seu banco de dados, ela deve ser inserida aqui. Se não, deixe este campo vazio. Por razões de segurança, é recomendável definir uma senha de root. Para obter mais informações, consulte a documentação do seu banco de dados.',
        'Currently only MySQL is supported in the web installer.' => 'Atualmente, apenas o MySQL é suportado pelo instalador web.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Se você quiser instalar o OTRS em outro tipo de banco de dados, consulte o arquivo README.database.',
        'Database-User' => 'Usuário do Banco',
        'New' => 'Nova',
        'A new database user with limited rights will be created for this OTRS system.' =>
            'Um novo usuário de banco de dados com direitos limitados será criado para este sistema OTRS.',
        'default \'hot\'' => 'padrão \'quente\'',
        'DB--- host' => 'DB--- servidor',
        'Check database settings' => 'Verificar configurações de banco de dados',
        'Result of database check' => 'Resultado da verificação de banco de dados',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Para poder utilizar o OTRS você deve digitar o seginte na linha de comando (terminal/shell) como usuário administrador (root)',
        'Restart your webserver' => 'Reiniciar o webserver',
        'After doing so your OTRS is up and running.' => 'Após fazer isto, seu sistema OTRS estará pronto para uso.',
        'Start page' => 'Iniciar página',
        'Your OTRS Team' => 'Sua Equipe de Suporte',

        # Template: InstallerLicense
        'Accept license' => 'Aceitar licença',
        'Don\'t accept license' => 'Não aceitar licença',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Organização',
        'Position' => '',
        'Complete registration and continue' => '',
        'Please fill in all fields marked as mandatory.' => '',

        # Template: InstallerSystem
        'SystemID' => 'ID do sistema',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'O identificador do sistema. Cada número de chamado e cada ID de sessão HTTP conterão esse número.',
        'System FQDN' => 'FQDN do sistema',
        'Fully qualified domain name of your system.' => 'Nome de domínio completamente qualificado do seu sistema.',
        'AdminEmail' => 'E-mail dos Administradores',
        'Email address of the system administrator.' => 'E-mail do administrador do sistema.',
        'Log' => 'Registro',
        'LogModule' => 'Módulo REGISTRO',
        'Log backend to use.' => 'Protocolo de back-end a ser usado.',
        'LogFile' => 'Arquivo de registro',
        'Log file location is only needed for File-LogModule!' => 'A especificação da localização do arquivo de registro é necessária apenas para o módulo de arquivo-registro.',
        'Webfrontend' => 'Interface Web',
        'Default language' => 'Idioma Padrão',
        'Default language.' => 'Idioma Padrão.',
        'CheckMXRecord' => 'Verificar Registro MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Endereços de e-mail que são inseridos manualmente são confrontados com os registros MX encontrados no DNS. Não use esta opção se o seu DNS é lento ou não resolve endereços públicos.',

        # Template: LinkObject
        'Object#' => 'Objeto#',
        'Add links' => 'Adicionar associações',
        'Delete links' => 'Deletar associações',

        # Template: Login
        'JavaScript Not Available' => 'JavaScript não habilitado ou não é suportado.',
        'Browser Warning' => 'Aviso de Navegador',
        'The browser you are using is too old.' => 'O navegador que você está usando é muito antigo.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'O OTRS funciona com uma lista enorme de navegadores, faça a atualização para um desses.',
        'Please see the documentation or ask your admin for further information.' =>
            'Por favor, consulte a documentação ou pergunte ao seu administrador para mais informações.',
        'Lost your password?' => 'Esqueceu sua senha?',
        'Request New Password' => 'Solicitar uma nova senha',
        'Back to login' => 'Voltar para o login',

        # Template: Motd
        'Message of the Day' => 'Mensagem do Dia',

        # Template: NoPermission
        'Insufficient Rights' => 'Permissões Insuficientes',
        'Back to the previous page' => 'Voltar para a página anterior',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'Mostrar primeira página',
        'Show previous pages' => 'Mostrar página anterior',
        'Show page %s' => 'Mostrar página %s',
        'Show next pages' => 'Mostrar próxima página',
        'Show last page' => 'Mostrar última página',

        # Template: PictureUpload
        'Need FormID!' => 'Necessário FormID!',
        'No file found!' => 'Nenhum arquivo encontrado!',
        'The file is not an image that can be shown inline!' => 'O arquivo não é uma imagem que pode ser mostrada embutida!',

        # Template: PrintFooter
        'URL' => '',

        # Template: PrintHeader
        'printed by' => 'Impresso por',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'Página de Teste do Gerenciador de Chamados',
        'Welcome %s' => 'Bem-vindo %s',
        'Counter' => 'Contador',

        # Template: Warning
        'Go back to the previous page' => 'Voltar para a página anterior',

        # SysConfig
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Módulo ACL que permite fechar os chamados-pais somente se todos os seus filhos já estejam fechados ("Estado" mostra quais estados não estão disponíveis para o chamado-pai até que todos os chamados-filhos estejam fechados).',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Ativa um mecanismo de piscar da fila que contém o chamado mais antigo.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Ativa o recurso de senha perdida para os atendentes, na interface do atendente.',
        'Activates lost password feature for customers.' => 'Ativa o recurso de senha perdida para os clientes.',
        'Activates support for customer groups.' => 'Ativa o suporte a grupos de clientes.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Ativa o filtro de artigo na visão de zoom para especificar quais artigos devem ser mostrados.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Ativa os temas disponíveis no sistema. O valor 1 significa ativo, 0 significa inativo.',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Ativa o sistema de arquivo de chamado para ter um sistema mais rápido, movendo alguns chamados para fora do escopo diário. Para procurar estes chamados, a chave arquivo tem que ser habilitada na busca de chamado.',
        'Activates time accounting.' => 'Ativa a contabilização de tempo.',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Adiciona um sufixo com o ano e mês reais do arquivo de eventos do OTRS. Um arquivo de eventos para cada mês será criado.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância "apenas uma vez". Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância permanente. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Agent Notifications' => 'Notificações de Atendentes',
        'Agent interface article notification module to check PGP.' => 'Módulo de notificação de artigo da interface de atendente para validar o PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Módulo de notificação de artigo da interface de atendente para validar o S/MIME.',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Módulo de interface de atendente para acessar a pesquisa de texto completa via barra de navegação.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Módulo de interface de atendente para acessar perfis de pesquisa via barra de navegação.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Módulo de interface de atendente para verificar a recepção de e-mails na tela de detalhes do chamados se a chave S/MIME está disponível e é válida.',
        'Agent interface notification module to check the used charset.' =>
            'Módulo de interface de atendente vara validar o conjunto de caracteres utilizado.',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Módulo de interface de atendente vara visualizar o número de chamados na responsabiidade de um atendente.',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Módulo de notificação da interface de atendente para visualizar o número de chamados monitorados.',
        'Agents <-> Groups' => 'Atendentes <-> Grupos',
        'Agents <-> Roles' => 'Atendentes <-> Papéis',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            'Permite adicionar notas na tela de fechamento do chamado da interface de atendente.',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            'Permite adicionar notas na tela de textos livres do chamado da interface de atendente.',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            'Permite adicionar notas na tela de nota do chamado da interface de atendente.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Permite adicionar notas na tela de proprietário do chamado de um chamado detalhado na interface de atendente.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Permite adicionar notas na tela de pendência do chamado de um chamado detalhado na interface de atendente.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Permite adicionar notas na tela de prioridade do chamado de um chamado detalhado na interface de atendente.',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            'Permite adicionar notas na tela de responsabilidade do chamado da interface de atendente.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Permite que atedentes troquem o eixo de uma estatística durante a geração de uma.',
        'Allows agents to generate individual-related stats.' => 'Permite que atedentes gerem estatística individualmente relacionadas.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Permite escolher entre mostrar os anexos de um chamado no navegador (embutido) ou possibilitar apenas que eles sejam baixados (anexo).',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Permite escolher o próximo estado de composição os chamados de cliente na interface de cliente.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Permite que os clientes alterem a prioridade do chamado na interface de cliente.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Permite que os clientes configurem o SLA do chamado na interface de cliente.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Permite que os clientes configurem a prioridade do chamado na interface de cliente.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Permite que os clientes configurem a fila do chamado na interface de cliente. Se isso for configurado para Não, o parâmetro QueueDefault deve ser configurado.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Permite que os clientes configurem o serviço do chamado na interface de cliente.',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Permite definir novos tipos de chamado (caso a funcionalidade tipo do chamado esteja habilitada).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite estender condições de pesquisa na tela de busca de chamados da interface de cliente. Com esse recurso, você pode pesquisar fazendo uso de condições como "(chave1 & & chave2) " ou "(chave1 | | chave2)".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite ter uma visão em formato médio do chamado (CustomerInfo => 1 - mostra também as informações do cliente).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite ter uma visão em formato pequeno do chamado (CustomerInfo => 1 - mostra também as informações do cliente).',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Permite que administradores personifiquem (se loguem como) outros usuários, através do painel de administração de usuários.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Permite definir um novo estado de chamado na tela de movimentação de chamado da interface de atendente.',
        'Attachments <-> Responses' => 'Anexos <-> Respostas',
        'Auto Responses <-> Queues' => 'Autorrespostas <-> Filas',
        'Automated line break in text messages after x number of chars.' =>
            'Quebra de linha automatizada em mensagens de texto após x número de caracteres.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Automaticamente bloquear e definir o proprietário para o atedente atual após selecionar uma ação em massa.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'Automaticamente ajustar o proprietário de um chamado como o responsável por ele (caso a funcionalidade responsável chamado esteja ativado).',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Automaticamente ajustar o responsável de um chamado (caso não esteja definido ainda) após a primeira atualização de proprietário.',
        'Balanced white skin by Felix Niklas.' => 'Pele branca balanceada por Felix Niklas.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Bloqueia todos os e-mails recebidos que não possuam um número de chamado válido no assunto com endereço De: @exemplo.com.',
        'Builds an article index right after the article\'s creation.' =>
            'Cria um índice de artigo logo após a criação do artigo.',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Configuração de exemplo CMD. Ignora e-mails nos quais o CMD externo retorna alguma saída em STDOUT (e-mail será canalizado para STDIN de algum.bin).',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => 'Alterar senha',
        'Change queue!' => 'Alterar fila!',
        'Change the customer for this ticket' => '',
        'Change the free fields for this ticket' => '',
        'Change the priority for this ticket' => '',
        'Change the responsible person for this ticket' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Altera o proprietário de chamados para todos (útil para ASP). Normalmente, apenas atendentes com permissões rw na fila do chamado serão mostrados.',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Verifica o SystemID na detecção de número de chamado para acompanhamentos (use "Não" se SystemID tiver sido alterado após usar o sistema).',
        'Closed tickets of customer' => '',
        'Comment for new history entries in the customer interface.' => 'Comentário para novas entradas de histórico na interface de cliente.',
        'Companies' => 'Empresas',
        'Company Tickets' => 'Chamados de Empresa',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure your own log text for PGP.' => 'Configure o seu próprio texto de registro para PGP.',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Configures the full-text index. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            'Configura o índice de texto completo. Execute "bin/otrs.RebuildFulltextIndex.pl" de forma a gerar um novo índice.',
        'Controls if customers have the ability to sort their tickets.' =>
            'Controla se os clientes têm a capacidade de classificar os seus chamados.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Converts HTML mails into text messages.' => 'Converte e-mails HTML em mensagens de texto.',
        'Create and manage Service Level Agreements (SLAs).' => 'Criar e gerenciar Acordos de Nível de Serviço (SLAs).',
        'Create and manage agents.' => 'Criar e gerenciar atendentes.',
        'Create and manage attachments.' => 'Criar e gerenciar anexos.',
        'Create and manage companies.' => 'Criar e gerenciar empresas.',
        'Create and manage customers.' => 'Criar e gerenciar clientes.',
        'Create and manage dynamic fields.' => '',
        'Create and manage event based notifications.' => 'Criar e gerenciar notificações baseadas em eventos.',
        'Create and manage groups.' => 'Criar e gerenciar grupos.',
        'Create and manage queues.' => 'Criar e gerenciar filas.',
        'Create and manage response templates.' => 'Criar e gerenciar modelos de respostas.',
        'Create and manage responses that are automatically sent.' => 'Criar e gerenciar respostas enviadas automaticamente.',
        'Create and manage roles.' => 'Criar e gerenciar papéis.',
        'Create and manage salutations.' => 'Criar e gerenciar saudações.',
        'Create and manage services.' => 'Criar e gerenciar serviços.',
        'Create and manage signatures.' => 'Criar e gerenciar assinaturas.',
        'Create and manage ticket priorities.' => 'Criar e gerenciar prioridades de chamados.',
        'Create and manage ticket states.' => 'Criar e gerenciar estados de chamados.',
        'Create and manage ticket types.' => 'Criar e gerenciar tipos de chamados.',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => 'Cria novo chamado e-mail e o envia (saída)',
        'Create new phone ticket (inbound)' => 'Cria novo chamado fone (entrada)',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            'Texto personalizado para a página mostrada aos clientes que não têm chamados ainda.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customers <-> Groups' => 'Clientes <-> Grupos',
        'Customers <-> Services' => 'Clientes <-> Serviços',
        'DEPRECATED! This setting is not used any more and will be removed in a future version of OTRS.' =>
            '',
        'Data used to export the search result in CSV format.' => 'Os dados utilizados para exportar o resultado da pesquisa no formato CSV.',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Depura a tradução definida. Se isso for ajustado para "Sim" todas as cadeias (texto), sem traduções são escritas no stderr. Isso pode ser útil quando você está criando um novo arquivo de tradução. Caso contrário, essa opção deve permanecer definida para "Não ".',
        'Default ACL values for ticket actions.' => 'Valores padrão de ACL para as ações de chamado.',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => 'Módulo padrão de proteção de loop.',
        'Default queue ID used by the system in the agent interface.' => 'ID de fila padrão usado pelo sistema na interface de atendente.',
        'Default skin for OTRS 3.0 interface.' => 'Tema padrão para a interface 3.0 do OTRS.',
        'Default skin for interface.' => 'Tema padrão para a interface.',
        'Default ticket ID used by the system in the agent interface.' =>
            'ID de chamado padrão usado pelo sistema na interface de atendente.',
        'Default ticket ID used by the system in the customer interface.' =>
            'ID de chamado padrão usado pelo sistema na interface de cliente.',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definir um filtro para a saída HTML para adicionar links por trás de uma sequência definida. O elemento Imagem permite dois tipos de entrada. Em primeiro lugar o nome de uma imagem (faq.png, por exemplo). Neste caso, o caminho de imagem OTRS será usado. A segunda possibilidade é inserir o link para a imagem.',
        'Define the start day of the week for the date picker.' => 'Defina o dia de início da semana para o selecionador de data.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Define um item de cliente, que gera um ícone LinkedIn no final de um bloco de informação de cliente.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Define um item de cliente, que gera um ícone XING no final de um bloco de informação de cliente.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Define um item de cliente, que gera um ícone google no final de um bloco de informação de cliente.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Define um item de cliente, que gera um ícone google maps no final de um bloco de informação de cliente.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Define uma lista padrão de palavras, que são ignorados pelo corretor ortográfico.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define um filtro para a saída HTML para adicionar links atrás de números CVE. O elemento Imagem permite dois tipos de entrada. Primeiro o nome de uma imagem (faq.png, por exemplo). Neste caso, o caminho de imagem OTRS será usado. A segunda possibilidade é inserir o link para a imagem.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define um filtro para a saída HTML para adicionar links atrás de números MSBulletin. O elemento Imagem permite dois tipos de entrada. Primeiro o nome de uma imagem (faq.png, por exemplo). Neste caso, o caminho de imagem OTRS será usado. A segunda possibilidade é inserir o link para a imagem.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define um filtro para a saída HTML para adicionar links atrás de uma sequência de texto definida. O elemento Imagem permite dois tipos de entrada. Primeiro o nome de uma imagem (faq.png, por exemplo). Neste caso, o caminho de imagem OTRS será usado. A segunda possibilidade é inserir o link para a imagem.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define um filtro para a saída HTML para adicionar links atrás de números bugtraq. O elemento Imagem permite dois tipos de entrada. Primeiro o nome de uma imagem (faq.png, por exemplo). Neste caso, o caminho de imagem OTRS será usado. A segunda possibilidade é inserir o link para a imagem.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Define um filtro para processar o texto nos artigos, a fim de destacar palavras-chave predefinidas.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Define uma expressão regular que exclui alguns endereços da verificação de sintaxe (se "CheckEmailAddresses" está definido como "Sim"). Por favor, insira um regex neste campo para endereços de e-mail, que não são sintaticamente válidos, mas são necessários para o sistema (ou seja, "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Define uma expressão regular que filtra todos os endereços de e-mail que não devem ser utilizados na aplicação.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Define um módulo útil para carregar opções específicas de usuário ou para exibir notícias.',
        'Defines all the X-headers that should be scanned.' => 'Define todos os X-headers que devem ser verificados.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            'Define todos os idiomas que estão disponíveis para o aplicativo. O par Chave/Conteúdo associa o nome de exibição da interface ao arquivo de idioma PM apropriado. O valor "chave" deve ser o nome base do arquivo PM (se de.pm é o arquivo, então de é o valor de "Chave"). O valor "Conteúdo" deve ser o nome de exibição da interface. Especifique qualquer linguagem própria definida aqui (veja a documentação para desenvolvedores http://doc.otrs.org/ para mais informações). Lembre-se de usar os equivalentes em HTML para caracteres não-ASCII (ou seja, para o alemão oe = trema, é necessário utilizar o símbolo Ø).',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Define todos os parâmetros para o objeto RefreshTime das preferências de cliente da interface de cliente.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Define todos os parâmetros para o objeto ShownTickets das preferências de cliente da interface de cliente.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Define todos os parâmetros para este item nas preferências de cliente.',
        'Defines all the possible stats output formats.' => 'Define todos os formatos possíveis de saída de estatísticas.',
        'Defines an alternate URL, where the login link refers to.' => 'Define uma URL alternativa, à qual o link de login se refere.',
        'Defines an alternate URL, where the logout link refers to.' => 'Define uma URL alternativa, à qual o link de logout se refere.',
        'Defines an alternate login URL for the customer panel..' => 'Define uma URL de login alternativa para o painel de cliente.',
        'Defines an alternate logout URL for the customer panel.' => 'Define uma URL de logout alternativa para o painel de cliente.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            'Define um link externo para o banco de dados do cliente (por exemplo \'http://seuservidor/cliente.php?CID=$Data{"CustomerID"}\' or \'\').',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Define como o campo De dos e-mails (enviados a partir das respostas e dos chamados e-mail) deve se parecer.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é requerido na tela de fechamento de chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é requerido na tela de devolução de chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é requerido na tela de composição de chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é requerido na tela de encaminhamento de chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é requerido na tela de testo livre do chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é requerido na tela de agrupamento de chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é requerido na tela de nota do chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é requerido na tela de proprietário do chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é requerido na tela de pendência do chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é requerido na tela de chamado fone (saída) da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é requerido na tela de prioridade do chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é requerido na tela de responsabilidade do chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é requerido para alterar o cliente do chamado na interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Define se mensagens compostas tem que ser verificadas ortograficamente na interface do atendente.',
        'Defines if time accounting is mandatory in the agent interface.' =>
            'Define se a contabilização do tempo é obrigatória na interface de atendente.',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Define a expressão regular IP para acessar o repositório local. Você precisa habilitar isso para ter acesso ao seu repositório local e o pacote: RepositoryList é requerido na máquina remota.',
        'Defines the URL CSS path.' => 'Define o caminho URL CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Define o caminho URL de ícones, CSS e Java Script.',
        'Defines the URL image path of icons for navigation.' => 'Define o caminho URL de imagem para ícones de navegação.',
        'Defines the URL java script path.' => 'Define o caminho URL de java scripts.',
        'Defines the URL rich text editor path.' => 'Define o caminho URL do editor de texto rico.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Define o endereço de um servidor DNS dedicado, se necessário, para os look-ups "CheckMXRecord".',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Define o texto do corpo para e-mails de notificação enviados aos atendentes, sobre nova senha (após usar este link, a nova senha será enviada).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Define o texto do corpo para e-mails de notificação enviados aos atendentes, com o token relativo à senha requerida (após usar este link, a nova senha será enviada).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Define o texto do corpo para e-mails de notificação enviados aos clientes, sobre nova conta.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Define o texto do corpo para e-mails de notificação enviados aos clientes, sobre nova senha (após usar este link, a nova senha será enviada).',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Define o texto do corpo para e-mails de notificação enviados aos clientes, com o token relativo à senha requerida (após usar este link, a nova senha será enviada).',
        'Defines the body text for rejected emails.' => 'Define o texto do corpo para e-mails rejeitados.',
        'Defines the boldness of the line drawed by the graph.' => 'Define o escurecimento da linha desenhada no gráfico.',
        'Defines the colors for the graphs.' => 'Define as cores de gráficos.',
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
        'Defines the default priority of new tickets.' => 'Define a prioridade padrão de novos chamados.',
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
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, Search_DynamicField_Field1StartYear=2002; Search_DynamicField_Field1StartMonth=12; Search_DynamicField_Field1StartDay=12; Search_DynamicField_Field1StartHour=00; Search_DynamicField_Field1StartMinute=00; Search_DynamicField_Field1StartSecond=00; Search_DynamicField_Field1StopYear=2009; Search_DynamicField_Field1StopMonth=02; Search_DynamicField_Field1StopDay=10; Search_DynamicField_Field1StopHour=23; Search_DynamicField_Field1StopMinute=59; Search_DynamicField_Field1StopSecond=59;.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Define a ordem de classificação padrão para todas as filas na visão de filas, após a classificação por prioridade.',
        'Defines the default spell checker dictionary.' => 'Define o dicionário padrão do corretor ortográfico.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Define o estado padrão de novos chamados de cliente na interface de cliente.',
        'Defines the default state of new tickets.' => 'Define o estado padrão de novos chamados.',
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
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
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
        'Email Addresses' => 'Endereços de E-Mail',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Habilita suporte a S/MIME.',
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
        'Escalation view' => 'Visão de Escalação',
        'Event list to be displayed on GUI to trigger generic interface invokers.' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Example for free text' => '',
        'Execute SQL statements.' => 'Executar consultas SQL.',
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
        'Filter incoming emails.' => 'Filtrar e-mails de entrada.',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Frontend language' => 'Linguagem da Interface',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => 'Tema da Interface',
        'GenericAgent' => 'Atendente Genérico',
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
        'Interface language' => 'Limguagem da interface',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Link agents to groups.' => 'Associar atendentes a grupos.',
        'Link agents to roles.' => 'Associar atendentes a papéis.',
        'Link attachments to responses templates.' => 'Associar anexos a modelos de resposta.',
        'Link customers to groups.' => 'Associar clientes a grupos.',
        'Link customers to services.' => 'Associar clientes a serviços.',
        'Link queues to auto responses.' => 'Associar filas a respostas.',
        'Link responses to queues.' => 'Associar respostas a filas.',
        'Link roles to groups.' => 'Associar papéis a grupos.',
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
        'Manage PGP keys for email encryption.' => 'Gerenciar chaves PGP para encriptação de e-mail.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Gerenciar contas POP3 e IMAP para buscar e-mails.',
        'Manage S/MIME certificates for email encryption.' => 'Gerenciar certificados S/MIME para encriptação de e-mail.',
        'Manage existing sessions.' => 'Gerenciar sessões existentes.',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => 'Gerenciar tarefas periódicas.',
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
        'My Tickets' => 'Meus Chamados',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => 'Novo Chamado E-mail',
        'New phone ticket' => 'Novo Chamado Fone',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => 'Notificações (Eventos)',
        'Number of displayed tickets' => 'Número de chamados exibidos',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Visão geral de chamados escalados',
        'Overview Refresh Time' => '',
        'Overview of all open Tickets.' => 'Visão geral de todos os chamados abertos.',
        'PGP Key Management' => '',
        'PGP Key Upload' => 'Upload de Chave PGP',
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
        'PostMaster Filters' => 'Filtros PostMaster',
        'PostMaster Mail Accounts' => 'Contas de E-mail PostMaster',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Queue view' => 'Visão de Filas',
        'Refresh Overviews after' => '',
        'Refresh interval' => 'Intervalo de atualização',
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
        'Responses <-> Queues' => 'Respostas <-> Filas',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            '',
        'Roles <-> Groups' => 'Papéis <-> Grupos',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'Upload de certificado S/MIME',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Saves the login and password on the session table in the database, if "DB" was selected for SessionModule.' =>
            '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => 'Selecione seu tema de interface.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Notifique-me se um cliente enviar uma continuação e sou o proprietário do chamado.',
        'Send notifications to users.' => 'Enviar notificações para usuários.',
        'Send ticket follow up notifications' => 'Enviar notificações de acompanhamento de chamados',
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
        'Set sender email addresses for this system.' => 'Configurar endereços de e-mail de remetente para o sistema.',
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
        'Skin' => 'Skin',
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
        'Statistics' => 'Estatísticas',
        'Status view' => 'Visão de Estado',
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
        'Ticket overview' => 'Visão geral de chamados',
        'Tickets' => 'Chamados',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Types' => 'Tipos',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => 'Atualizar e estender as funcionalidades do seu sistema com pacotes de software.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Ver resultados da avaliação de desempenho.',
        'View system log messages.' => 'Ver mensagens de eventos do sistema.',
        'Wear this frontend skin' => 'Utilizar este tema de interface',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your language' => 'Seu idioma',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Fila de seleção das filas preferenciais. Você também será notificado sobre essas filas por e-mail se habilitado.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        '%s Tickets affected! Do you really want to use this job?' => '%s Chamados afetados! Você quer realmente utilizar este processo?',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' =>
            '(Überprüfen des MX-Eintrags der benutzen E-Mail-Adressen im Verfassen-Fenster. Benutzen Sie CheckMXRecord nicht, wenn Ihr OTRS hinter einer Wählleitung ist!)',
        '(Email of the system admin)' => '(E-Mail des System-Administrators)',
        '(Full qualified domain name of your system)' => '(Nome completo do domínio de seu sistema)',
        '(Logfile just needed for File-LogModule!)' => '(Arquivo de registro para File-LogModule)',
        '(Note: It depends on your installation how many dynamic objects you can use)' =>
            'A quantidade de objetos dinâmicos depende da sua instalação',
        '(Note: Useful for big databases and low performance server)' => '(Nota: Útil para base de dados grandes e servidores de baixa performance)',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' =>
            '(A identidade do sistema. Cada número de chamado e cada id. da sessão http, inicia com este número)',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' =>
            '(Identificador do chamado. Algumas pessoas gostam de usar por exemplo \'Chamado#\, \'Chamado#\' ou \'MeuChamado#\')',
        '(Used default language)' => '(Idioma padrão utilizado)',
        '(Used log backend)' => '(Utilizado LOG como base)',
        '(Used ticket number format)' => '(Formato usado do número do chamado)',
        'A article should have a title!' => 'O Artigo deverá ter um Título!',
        'A message must be spell checked!' => 'A mensagem necessita ser verificada ortograficamente!',
        'A message should have a To: recipient!' => 'Uma mensagem deve possuir um To: destinatário!',
        'A message should have a body!' => 'A mensagem deve conter um texto!',
        'A message should have a customer!' => 'Eine Nachtricht sollte einen Kunden haben!',
        'A message should have a subject!' => 'Uma mensagem deve conter um assunto!',
        'A required field is:' => 'Campo requerido é:',
        'A response is default text to write faster answer (with default text) to customers.' =>
            'Uma resposta padrão é um texto para responder mais rapidamente aos clientes.',
        'A ticket should be associated with a queue!' => 'Ein Ticket sollte mit einer Queue assoziert sein.',
        'A ticket should have a type!' => 'Ein Ticket sollte einen Typ haben!',
        'About OTRS' => 'Über OTRS',
        'Absolut Period' => 'Período Absoluto',
        'Activates TypeAhead for the autocomplete feature, that enables users to type in whatever speed they desire, without losing any information. Often this means that keystrokes entered will not be displayed on the screen immediately.' =>
            'Ativa TypeAhead para o recurso de autocompletar, que permite aos usuários digitar em qualquer velocidade que eles desejarem, sem perder qualquer informação. Muitas vezes isso significa que as teclas digitadas não serão exibidas na tela imediatamente.',
        'Add Customer User' => 'Adicionar Cliente',
        'Add System Address' => 'Adicionar Endereços do Sistema',
        'Add User' => 'Adicionar Usuário',
        'Add a new Agent.' => 'Adicionar um novo Atendente',
        'Add a new Customer Company.' => 'Adicionar uma nova Empresa de Clientes.',
        'Add a new Group.' => 'Adicionar um novo grupo',
        'Add a new Notification.' => 'Adicionar uma nova Notificação',
        'Add a new Priority.' => 'Adicionar nova Prioridade',
        'Add a new Role.' => 'Adicionar um novo papel',
        'Add a new SLA.' => 'Adicionar um novo SLA',
        'Add a new Salutation.' => 'Adicionar um novo Tratamento',
        'Add a new Service.' => 'Adicionar um novo Serviço',
        'Add a new Signature.' => 'Adicionar uma nova Assinatura',
        'Add a new State.' => 'Adicionar um novo Estado',
        'Add a new System Address.' => 'Adicionar um novo endereço de sistema.',
        'Add a new Type.' => 'Adicionar um novo Tipo',
        'Add a new salutation' => 'Neue Anrede hinzufügen',
        'Add a note to this ticket!' => 'Adicionar uma nota a este chamado!',
        'Add new attachment' => 'Neuen Anhang hinzufügen',
        'Add note to ticket' => 'Adicionar nota ao chamado',
        'Add to list of subscribed tickets' => 'Ticket abonnieren',
        'Added User "%s"' => 'Usuário Adicionado "%s"',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            'Adiciona endereços de e-mail de clientes para destinatários na tela de composição de chamados da tela do atendente.',
        'Adds the one time vacation days for the calendar number 1. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância "apenas uma vez" para o calendário número 1. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the one time vacation days for the calendar number 2. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância "apenas uma vez" para o calendário número 2. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the one time vacation days for the calendar number 3. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância "apenas uma vez" para o calendário número 3. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the one time vacation days for the calendar number 4. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância "apenas uma vez" para o calendário número 4. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the one time vacation days for the calendar number 5. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância "apenas uma vez" para o calendário número 5. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the one time vacation days for the calendar number 6. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância "apenas uma vez" para o calendário número 6. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the one time vacation days for the calendar number 7. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância "apenas uma vez" para o calendário número 7. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the one time vacation days for the calendar number 8. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância "apenas uma vez" para o calendário número 8. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the one time vacation days for the calendar number 9. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância "apenas uma vez" para o calendário número 9. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the permanent vacation days for the calendar number 1. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância permanente para o calendário número 1. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the permanent vacation days for the calendar number 2. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância permanente para o calendário número 2. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the permanent vacation days for the calendar number 3. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância permanente para o calendário número 3. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the permanent vacation days for the calendar number 4. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância permanente para o calendário número 4. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the permanent vacation days for the calendar number 5. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância permanente para o calendário número 5. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the permanent vacation days for the calendar number 6. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância permanente para o calendário número 6. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the permanent vacation days for the calendar number 7. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância permanente para o calendário número 7. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the permanent vacation days for the calendar number 8. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância permanente para o calendário número 8. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the permanent vacation days for the calendar number 9. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância permanente para o calendário número 9. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Admin-Area' => 'Área de Administração',
        'Admin-Password' => 'Senha do Administrador',
        'Admin-User' => 'Usuário do Administrador',
        'Admin-password' => 'Senha do Administrador',
        'Agent Mailbox' => 'Mailbox Atendente',
        'Agent Preferences' => 'Preferências Atendente',
        'Agent based' => 'Baseado em Agente',
        'Agent-Area' => 'Área de Atendente',
        'All Agent variables.' => 'Todas as variáveis do Atendente',
        'All Agents' => 'Todos os Atendentes',
        'All Customer variables like defined in config option CustomerUser.' =>
            'Todas as variáveis do cliente como foram definidas nas opções de configuração de "usuário"',
        'All customer tickets.' => 'Todas os chamados do cliente',
        'All email addresses get excluded on replaying on composing an email.' =>
            'Alle Email-Adressen werden beim Erstellen einer Antwort exkludiert.',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' =>
            'Alle eingehenden E-Mails mit diesem Empfänger (To:) werden in die ausgewählte Queue einsortiert.',
        'All messages' => 'Todas as mensagens',
        'All new tickets!' => 'Todos os novos chamados!',
        'All tickets where the reminder date has reached!' => 'Todas as olicitações cujos prazos de lembrete expiraram!',
        'All tickets which are escalated!' => 'Todas as olicitações que foram escaladas!',
        'Allocate CustomerUser to service' => 'Alocar usuário cliente a serviço',
        'Allocate services to CustomerUser' => 'Alocar serviços a usuário cliente',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attribrutes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permite definir serviços e SLA para chamados (por exemplo, e-mail, desktop, rede...), e attribrutes de escalação para SLAs (caso a funcionalidade serviço/SLA esteja habilitada).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite estender condições de pesquisa na tela de busca de chamados da interface de atendente. Com esse recurso, você pode pesquisar fazendo uso de condições como "(chave1 & & chave2) " ou "(chave1 | | chave2)".',
        'Answer' => 'Resposta',
        'Article Create Times' => 'Horário da Criação do Artigo',
        'Article created' => 'Artigo criado',
        'Article created between' => 'Artigo criado entre',
        'Article filter settings' => 'Configurações de filtro de artigos',
        'Article free text options shown in the close ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opções de texto livre do artigo mostradas na tela de fechamento de chamado da interface de atendente. Configurações possíveis: 0 = Desabilitado, 1 = Habilitado, 2 = Habilitado e requerido.',
        'Article free text options shown in the email ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opções de texto livre do artigo mostradas na tela de chamado e-mail da interface de atendente. Configurações possíveis: 0 = Desabilitado, 1 = Habilitado, 2 = Habilitado e requerido.',
        'Article free text options shown in the phone ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opções de texto livre do artigo mostradas na tela de chamado fone da interface de atendente. Configurações possíveis: 0 = Desabilitado, 1 = Habilitado, 2 = Habilitado e requerido.',
        'Article free text options shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opções de texto livre do artigo mostradas na tela de abertura de chamado da interface de atendente. Configurações possíveis: 0 = Desabilitado, 1 = Habilitado, 2 = Habilitado e requerido.',
        'Article free text options shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opções de texto livre do artigo mostradas na tela de texto livre do chamado da interface de atendente. Configurações possíveis: 0 = Desabilitado, 1 = Habilitado, 2 = Habilitado e requerido.',
        'Article free text options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###AttributesView.' =>
            'Opções de texto livre do artigo mostradas na tela de mensagem do chamado da interface de atendente. Configurações possíveis: 0 = Desabilitado, 1 = Habilitado, 2 = Habilitado e requerido. NOTA. Se desejar exibir esses campos também no chamado zoom da interface do cliente, você tem que habilitá-los no CustomerTicketZoom###AttributesView.',
        'Article free text options shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opções de texto livre do artigo mostradas na tela de nota do chamado da interface de atendente. Configurações possíveis: 0 = Desabilitado, 1 = Habilitado, 2 = Habilitado e requerido.',
        'Article free text options shown in the ticket owner screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opções de texto livre do artigo mostradas na tela de proprietário do chamado de um chamado detalhado na interface de atendente. Configurações possíveis: 0 = Desabilitado, 1 = Habilitado, 2 = Habilitado e requerido.',
        'Article free text options shown in the ticket pending screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opções de texto livre do artigo mostradas na tela de pendência do chamado de um chamado detalhado na interface de atendente. Configurações possíveis: 0 = Desabilitado, 1 = Habilitado, 2 = Habilitado e requerido.',
        'Article free text options shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opções de texto livre do artigo mostradas na tela de chamado fone (saída) da interface de atendente. Configurações possíveis: 0 = Desabilitado, 1 = Habilitado, 2 = Habilitado e requerido.',
        'Article free text options shown in the ticket priority screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opções de texto livre do artigo mostradas na tela de prioridade do chamado de um chamado detalhado na interface de atendente. Configurações possíveis: 0 = Desabilitado, 1 = Habilitado, 2 = Habilitado e requerido.',
        'Article free text options shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opções de texto livre do artigo mostradas na tela de responsabilidade do chamado da interface de atendente. Configurações possíveis: 0 = Desabilitado, 1 = Habilitado, 2 = Habilitado e requerido.',
        'Attach' => 'Anexo',
        'Attribute' => 'Atributo',
        'Auto Response From' => 'Auto-Resposta De',
        'Bounce Ticket: ' => 'Devolver chamado:',
        'Bounce ticket' => 'Devolver chamado',
        'CSV' => 'CSV',
        'Can not create link with %s!' => 'Não foi possível associar com %s!',
        'Can not delete link with %s!' => 'Não é possível deletar associação com %s!',
        'Can\'t update password, invalid characters!' => 'Senha não atualizada, caracteres inválidos!',
        'Can\'t update password, must be at least %s characters!' => 'Senha não atualizada, digite no mínimo %s caracteres!',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' =>
            'Senha não atualizada, digite no mínimo 2 caracteres minúsculos e 2 maiúsculos',
        'Can\'t update password, needs at least 1 digit!' => 'Senha não atualizada, digite no mínimo 1 número',
        'Can\'t update password, needs at least 2 characters!' => 'Senha não atualizada, digite no mínimo 2 caracteres',
        'Can\'t update password, your new passwords do not match! Please try again!' =>
            'Senha não atualizada, por que estão diferentes! Tente novamente!',
        'Category Tree' => 'Categorias',
        'Cc: (%s) added database email!' => 'Cc: (%s) adicionou e-mail do banco de dados!',
        'Change %s settings' => 'Modificar %s configurações',
        'Change Time' => 'Horário de Alteração',
        'Change Times' => 'Horário de Alteração',
        'Change free text of ticket' => 'Alterar os campos em branco no chamado',
        'Change owner of ticket' => 'Modificar o proprietário do chamado',
        'Change priority of ticket' => 'Modificar a prioridade do chamado',
        'Change responsible of ticket' => 'Alterar o responsável pelo chamado',
        'Change the ticket customer!' => 'Alterar o cliente do chamado',
        'Change the ticket owner!' => 'Alterar o proprietário do chamado!',
        'Change the ticket priority!' => 'Alterar a prioridade do chamado!',
        'Change the ticket responsible!' => 'Alterar o responsável pelo chamado!',
        'Change user <-> group settings' => 'Modificar configurações de usuários <-> grupos',
        'Check Mail Configuration' => 'Mailkonfiguration überprüfen',
        'Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behind a dial-up line!' =>
            'Aktiviert die Prüfung von MX Records von benutzten Emailadressen beim Erstellen von Antworten. Wenn Sie OTRS nur mit einer Einwahlverbindung ins Internet benutzen, sollten Sie diese Option abschalten.',
        'Child-Object' => 'Objeto Filho',
        'Classification' => 'Classificação',
        'Clear From' => 'Limpar',
        'Clear To' => 'Limpar',
        'Click here to report a bug!' => 'Clique aqui para relatar um erro!',
        'Close Times' => 'Horários de Fechamento',
        'Close this ticket!' => 'Fechar este chamado!',
        'Close ticket' => 'Fechar o chamado',
        'Close type' => 'Tipo de fechamento',
        'Close!' => 'Fechar!',
        'Collapse View' => 'Visão Recolhida',
        'Comment (internal)' => 'Comentário (interno)',
        'CompanyTickets' => 'Chamados da Empresa',
        'Compose Answer' => 'Compor Resposta',
        'Compose Email' => 'E-Mail erstellen',
        'Compose Follow up' => 'Compor Continuação',
        'Config Options' => 'Opções de Configuração',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Konfig Optionen (z. B. <OTRS_CONFIG_HttpType>)',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Opções de Configuração (ex.: <OTRS_CONFIG_HttpType>).',
        'Configures a default TicketFreeField setting. "Counter" defines the free text field which should be used, "Key" is the TicketFreeKey, "Value" is the TicketFreeText and "Event" defines the trigger event.' =>
            'Estabelece uma configuração padrão para TicketFreeField. "Contador", define o campo de texto livre que deve ser usado, "Chave" é a TicketFreeKey, "Valor" é o TicketFreeText e "Evento" define o gatilho do evento.',
        'Configures a default TicketFreeField setting. "Counter" defines the free text field which should be used, "Key" is the TicketFreeKey, "Value" is the TicketFreeText and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            'Estabelece uma configuração padrão para TicketFreeField. "Contador", define o campo de texto livre que deve ser usado, "Chave" é a TicketFreeKey, "Valor" é o TicketFreeText e "Evento" define o gatilho do evento. Por favor, verifique o manual do desenvolvedor (http://doc.otrs.org/), capítulo "Ticket Event Module".',
        'Contact customer' => 'Contatar cliente',
        'Create New Template' => 'Neue Vorlage anlegen',
        'Create Times' => 'Horários de Criação',
        'Create and manage notifications that are sent to agents.' => 'Criar e gerenciar notificações enviadas para atendentes.',
        'Create new Phone Ticket' => 'Criar novo Chamado Fone',
        'Create new database' => 'Criar novo banco de dados',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' =>
            'Crie novos grupos para manipular as permissões de acesso para diferentes grupos de agentes (exemplos: departamento de compras, departamento de suporte, departamento de vendas, etc...).',
        'Create your first Ticket' => 'Erstellen Sie ihr erstes Ticket',
        'Create/Expires' => 'Criado/Expira',
        'CreateTicket' => 'Criar Chamado',
        'Current Impact Rating' => 'Taxa de Impacto Atual',
        'Customer Move Notify' => 'Cliente Notificar Alteração',
        'Customer Owner Notify' => 'Cliente Notificar Proprietário',
        'Customer State Notify' => 'Notificar Status do Cliente',
        'Customer User' => 'Cliente',
        'Customer User Management' => 'Administração de Clientes',
        'Customer Users' => 'Clientes',
        'Customer Users <-> Groups' => 'Clientes <-> Grupos',
        'Customer Users <-> Groups Management' => 'Clientes <-> Admin Grupos',
        'Customer Users <-> Services' => 'Clientes <-> Serviços',
        'Customer Users <-> Services Management' => 'Clientes <-> Gerenciamento de Serviços',
        'Customer history' => 'Histórico do cliente',
        'Customer history search' => 'Busca no Histórico do cliente',
        'Customer history search (e. g. "ID342425").' => 'Busca no Histórico do cliente (exemplo: "ID342425")',
        'Customer item (icon) which shows the open tickets of this customer as info block.' =>
            'Item (ícone) de cliente que mostra os chamados abertos do cliente como bloco de informações.',
        'Customer user will be needed to have a customer history and to login via customer panel.' =>
            'O usuário do cliente será necessário para que exista um histórico do cliente e para login na área de clientes.',
        'CustomerUser' => 'Usuário Cliente',
        'D' => 'D',
        'DB Admin Password' => 'Password de Administrador do DB',
        'DB Admin User' => 'Usuário Administrador do DB',
        'DB connect host' => 'Servidor da Base',
        'Default' => 'Padrão',
        'Default Charset' => 'Conjunto de Caracteres Padrão',
        'Default Language' => 'Idioma Padrão',
        'Defines the =hHeight for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Define o =hHeight para o componente editor de texto rico. Digite o número (pixels) ou o valor percentual (relativo).',
        'Defines the name of the calendar number 1.' => 'Define o nome do calendário número 1.',
        'Defines the name of the calendar number 2.' => 'Define o nome do calendário número 2.',
        'Defines the name of the calendar number 3.' => 'Define o nome do calendário número 3.',
        'Defines the name of the calendar number 4.' => 'Define o nome do calendário número 4.',
        'Defines the name of the calendar number 5.' => 'Define o nome do calendário número 5.',
        'Defines the name of the calendar number 6.' => 'Define o nome do calendário número 6.',
        'Defines the name of the calendar number 7.' => 'Define o nome do calendário número 7.',
        'Defines the name of the calendar number 8.' => 'Define o nome do calendário número 8.',
        'Defines the name of the calendar number 9.' => 'Define o nome do calendário número 9.',
        'Delete old database' => 'Alte Datenbank löschen',
        'Delete this ticket!' => 'Apagar este chamado!',
        'Detail' => 'Detalhe',
        'Discard all changes and return to the compose screen' => 'Descartar todas as modificações e retornar para a tela de composição',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' =>
            'Verteilt oder Filtern einkommende E-Mail anhand der X-Headers! RegExp ist auch möglich.',
        'Do you really want to delete this Object?' => 'Você quer realmente remover este objeto?',
        'Do you really want to reinstall this package (all manual changes get lost)?' =>
            'Você quer realmente reinstalar este pacote?',
        'Don\'t forget to add a new response a queue!' => 'Não se esqueça de adicionar a nova resposta a uma fila!',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Não se esqueça de adicionar o novo usuário em grupos e/ou papéis!',
        'Don\'t forget to add a new user to groups!' => 'Não se esqueça de adicionar o novo usuário a grupos!',
        'Don\'t work with UserID 1 (System account)! Create new users!' =>
            'Não trabalhe com o UserID 1(Conta do Sistema)! Crie novos usuários!',
        'Download Settings' => 'Baixar Configurações',
        'Download all system config changes.' => 'Baixar todas as configurações do sistema que foram alteradas.',
        'Drop Database' => 'Deletar Database',
        'Dynamic-Object' => 'Objeto-Dinâmico',
        'Edit Customers' => 'Kunden bearbeiten',
        'Edit default services.' => 'Editar serviços padrão',
        'Email based' => 'Email basierend',
        'Email of the system admin.' => 'Emailadresse des Systemadministrators.',
        'Email{CustomerUser}' => 'E-Mail',
        'Escalation - First Response Time' => 'Escalação - Prazo da Primeira Resposta',
        'Escalation - Solution Time' => 'Escalação - Prazo de Solução',
        'Escalation - Update Time' => 'Escalação - Prazo de Atualização',
        'Escalation Times' => 'Prazo de Escalação',
        'Escalation time' => 'Tempo de escalação',
        'Event is required!' => 'Evento é obrigatório!',
        'Expand View' => 'Visão Expandida',
        'Explanation' => 'Explanação',
        'Export Config' => 'Exportar Configuração',
        'FAQ Search Result' => 'Resultado da procura por FAQ',
        'FAQ System History' => 'Histórico do Sistema de FAQ',
        'File-Name' => 'Nome do Arquivo',
        'File-Path' => 'Dateipfad',
        'Filelist' => 'Lista de arquivos',
        'Filter for Language' => 'Filtro por Idioma',
        'Filtername' => 'Nome do Filtro',
        'Follow up' => 'Continuação',
        'Follow up notification' => 'Notificação de continuação',
        'For more info see:' => 'Para mais informações acesse:',
        'For very complex stats it is possible to include a hardcoded file.' =>
            'Para estatísticas muito complexas é possível incluir um código fonte.',
        'Forward ticket: ' => 'Encaminhar chamado:',
        'Foward ticket: ' => 'Ticket weiterleiten',
        'Frontend' => 'Interface',
        'Full qualified domain name of your system.' => 'Name des Rechners inklusive des vollständigem Domänennamens. z. B. otrs-server.example.org',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Busca por texto completo no Artigo (ex.: "Mar*in" or "Baue*")',
        'Go' => 'ir',
        'Go to group %s' => 'Zu Gruppe %s gehen',
        'Group %s' => 'Gruppe %s',
        'Group Ro' => 'Grupo Somente Leitura',
        'Group based' => 'Baseado em Grupo',
        'Group selection' => 'Seleção de Grupo',
        'Hash/Fingerprint' => 'Hash/Assinatura',
        'Have a lot of fun!' => 'Divirta-se!',
        'Have you lost your password?' => 'Ist Ihnen ihr Passwort abhanden gekommen?',
        'Help' => 'Hilfe',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
            'É possível escolher um ou dois elementos. Então você pode selecionar os atributos dos elementos. Cada atributo será mostrado como um conjunto único de valores. Se você não selecionar nenhum atributo, todos os atributos do elemento serão utilizados para gerar a estatística. Assim como um novo atributo é adicionado desde a última configuração.',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
            'Aqui você pode definir o eixo-x. Você pode selecionar um elemento via botão de rádio. Se você não fizer uma seleção, todos os atributos do elemento serão usados se você gerar uma estatística. Assim como um novo atributo é adicionado desde a última configuração.',
        'Here you can insert a description of the stat.' => 'Aqui você pode inserir uma descrição da estatística.',
        'Here you can select the dynamic object you want to use.' => 'Aqui você pode selecionar o objeto dinâmico que você quer usar.',
        'Home' => 'Início',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' =>
            'Se um novo código estiver disponível ele pode será exibido e você poderá escolhê-lo. ',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' =>
            'Se um chamado está fechado e um cliente envia uma continuação, este mesmo chamado será bloqueado para o antigo proprietário.',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' =>
            'Se um chamado não for respondido neste prazo, apenas este chamado será exibido.',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' =>
            'Se um atendente bloquear um chamado e ele não enviar uma resposta dentro deste tempo, o chamado será desbloqueado automaticamente. Então o chamado será visível para todos os atendentes.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' =>
            'Se nada estiver selecionado, então não há nenhuma permissão neste grupo (os chamados não estarão disponíveis para o usuário).',
        'If you need the sum of every column select yes.' => 'Se você necessita da soma de todas as colunas seleciona SIM',
        'If you need the sum of every row select yes' => 'Se você necessita da soma de todos as linhas selecione SIM',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' =>
            'Se utilizar expressões regulares, você pode usar o valor encontrado no () como [***] em \'Set\'.',
        'If you want to install OTRS on other database systems, please refer to the file README.database.' =>
            'Wenn Sie OTRS mit einer anderen Datenbank benutzen wollen, so lesen Sie bitte die Anleitung in der Datei README.database.',
        'Image' => 'Imagem',
        'Important' => 'Importante',
        'Imported' => 'Importado',
        'Imported by' => 'Importiert von',
        'In order to experience OTRS, you\'ll need to enable Javascript in your browser.' =>
            'Um alle Möglichkeiten von OTRS voll ausschöpfen zu können, müssen Sie JavaScript in Ihrem Browser aktivieren.',
        'In this form you can select the basic specifications.' => 'Neste formulário você pode selecionar as especificações básicas.',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' =>
            'Neste caso, você pode editar diretamente a "keyring" configurada no Kernel/Config.pm.',
        'Inbound Mail Password' => 'Passwort',
        'Inbound Mail Type' => 'Mailempfang',
        'Inbound Mail User' => 'Benutzername',
        'Inbound Mail host' => 'Host für Mailempfang',
        'Information about the Stat' => 'Informações sobre a Estatística',
        'Insert of the common specifications' => 'Inserção das especificações comuns',
        'Instance' => 'Instanz',
        'Is Job Valid' => 'O trabalho é válido.',
        'Is Job Valid?' => 'O trabalho é válido?',
        'It\'s useful for ASP solutions.' => 'Isto é útil para soluções ASP.',
        'It\'s useful for a lot of users and groups.' => 'Isto é muito útil para uma grande quantidade de usuários e grupos.',
        'Job-List' => 'Lista de jobs',
        'Keyword' => 'Palavra-Chave',
        'Keywords' => 'Palavras-Chave',
        'Kill session' => 'Finalizar sessão',
        'Last update' => 'Última Atualização',
        'Link Table' => 'Verknüpfungstabelle',
        'Link this ticket to an other objects!' => 'Associar este chamado com outros objetos!',
        'Link this ticket to other objects!' => 'Associar este chamado a outros objetos!',
        'Link to Parent' => 'Associar a Pai',
        'LinkType' => 'Verbindungstyp',
        'Linked as' => 'Associado como',
        'Load' => 'Carregar',
        'Load Settings' => 'Carregar Configurações',
        'Lock it to work on it!' => 'Bloquear para trabalhar com o chamado!',
        'Logfile' => 'Arquivo de registro',
        'Logfile just needed for File-LogModule!' => 'Die Protokolldatei wird nur für die Protokolliermethode \'Protokolldatei\' benötigt.',
        'Logfile too large, you need to reset it!' => 'Arquivo de log muito grande, você deve reiniciá-lo!',
        'Login failed! Your username or password was entered incorrectly.' =>
            'Login incorreto! Seu login ou senha foram informados incorretamente.',
        'Lookup' => 'Buscar',
        'Mail Management' => 'Gerenciamento de E-mail',
        'Mailbox' => 'Caixa de Entrada',
        'Match' => 'Busca',
        'Max. displayed tickets' => 'Máx. chamados exibidos',
        'Max. shown Tickets a page' => 'Max. Anzahl Tickets pro Seite',
        'Merge this ticket!' => 'Agrupar este chamado!',
        'Message for new Owner' => 'Mensagem para um novo Proprietário',
        'Message sent to' => 'Mensagem enviada para',
        'Misc' => 'Variedades',
        'Modified' => 'modificado',
        'Modules' => 'Módulos',
        'Move notification' => 'Notificação de movimentos',
        'Multiple selection of the output format.' => 'Múltiplas escolhas de formato de saída.',
        'My Queue' => 'Meine Queue',
        'MyTickets' => 'Meus Chamados',
        'Name is required!' => 'O Nome é requerido',
        'Need a valid email address or don\'t use a local address!' => 'Eine gültige Email-Adresse wird benötigt, aber keine lokale Adresse benutzen.',
        'Need a valid mail address or don\'t use a local email address.' =>
            'Eine gültige Email-Adresse wird benötigt, aber keine lokale Adresse benutzen.',
        'New Agent' => 'Novo Atendente',
        'New Customer' => 'Novo Cliente',
        'New Group' => 'Novo Grupo',
        'New Group Ro' => 'Novo Grupo Somente Leitura',
        'New Password' => 'Nova senha',
        'New Priority' => 'Nova Prioridade',
        'New SLA' => 'Novo SLA',
        'New Service' => 'Novo Serviço',
        'New State' => 'Novo Estado',
        'New Ticket Lock' => 'Chamado novo bloqueado',
        'New TicketFreeFields' => 'Novos campos livres do chamado',
        'New Title' => 'Novo Título',
        'New Type' => 'Novo Tipo',
        'New account created. Sent Login-Account to %s.' => 'Nova conta criada. Enviado Login para %s.',
        'New messages' => 'Mensagens novas',
        'New password again' => 'Repita sua nova senha',
        'Next Week' => 'Próxima Semana',
        'No * possible!' => 'Não são possíveis *!',
        'No Permission' => 'Sem Permissão',
        'No matches found' => 'Keine Treffer gefunden',
        'No time settings.' => 'Sem configurações de hora.',
        'Node-Address' => 'Endereço-Nó',
        'Node-Name' => 'Nome do Nó',
        'Note Text' => 'Nota',
        'Notification (Customer)' => 'Notificação (Cliente)',
        'Notifications' => 'Notificações',
        'OTRS DB Password' => 'Password do OTRS DB',
        'OTRS sends an notification email to the customer if the ticket is moved.' =>
            'OTRS sendet eine Info-E-Mail an Kunden beim Verschieben des Tickets.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' =>
            'OTRS sendet eine Info E-Mail an Kunden beim Ändern des Besitzers.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' =>
            'OTRS sendet eine Info E-Mail an Kunden beim Ändern des Status.',
        'Object already linked as %s.' => 'Objeto já associado como %s.',
        'Of couse this feature will take some system performance it self!' =>
            'Com certeza esta funcionalidade irá consumir certa quantidade de recursos do sistema!',
        'One or more errors occured!' => 'Ein oder mehrere Fehler sind aufgetreten!',
        'Only for ArticleCreate Event.' => 'Somente para Eventos de Criação de Artigo.',
        'Open Tickets' => 'Chamados Abertos',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' =>
            'Opções de informações do cliente (ex.: &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' =>
            'Die Daten der Kundenbenutzer (z. B. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' =>
            'Opções de informações do usuário cliente (ex.: <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' =>
            'Opções do atual usuário que solicitou a ação (e. g. <OTRS_CURRENT_UserFirstname>)',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' =>
            'Opções do usuário atual que requisitou esta ação (ex.: <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' =>
            'Optionen von Ticket Daten (z. B. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' =>
            'Optionen des Tickets (z. B. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' =>
            'Opções de informação do chamado (ex.: <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Other Options' => 'Outras Opções',
        'Out Of Office' => 'Ausência do Escritório',
        'Outbound Mail Type' => 'Mailversand',
        'POP3 Account Management' => 'Gerenciamento de Contas POP3',
        'Package' => 'Pacotes',
        'Package not correctly deployed! You should reinstall the Package again!' =>
            'O pacote não foi instalado coretamente! Você deve reinstalá-lo!',
        'Package not correctly deployed! You should reinstall the package again!' =>
            'O pacote não foi instalado coretamente! Você deve reinstalá-lo!',
        'Package verification failed!' => 'A verificação do pacote falhou!',
        'Param 1' => 'Parâmetro 1',
        'Param 2' => 'Parâmetro 2',
        'Param 3' => 'Parâmetro 3',
        'Param 4' => 'Parâmatro 4',
        'Param 5' => 'Parâmetro 5',
        'Param 6' => 'Parâmetro 6',
        'Parent-Object' => 'Objeto-Pai',
        'Password for Inbound Mail' => 'Passwort für Mailempfang',
        'Password for SMTP Auth' => 'Passwort für die SMTP-Authentifizierung',
        'Password is already in use! Please use an other password!' => 'Senha em uso! Tente outra senha!',
        'Password is already used! Please use an other password!' => 'Senha está sendo utilizada! Tente outra senha!',
        'Passwords doesn\'t match! Please try it again!' => 'Senhas não são equivalentes! Tente novamente!',
        'Pending Times' => 'Horários Pendentes',
        'Pending messages' => 'Mensagens pendentes',
        'Pending type' => 'Tipo de pendência',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' =>
            'Configurações de permissão. Você pode selecionar um ou mais grupos para que as estatísticas configuradas sejam exibidas para agentes diferentes.',
        'Permissions to change the ticket owner in this group/queue.' => 'Permissões para alterar o chamado neste grupo/fila.  ',
        'PhoneView' => 'Chamada',
        'Please command us.' => 'Bitte geben Sie uns Ihre Order!',
        'Please contact your admin' => 'Por favor, contate administrador do sistema!',
        'Please enter subject.' => 'Bitte den Betreffen eingeben.',
        'Please fill out this form to recieve login credentials.' => 'Por favor, preencha este formulário para receber as credenciais de login.',
        'Please provide a name.' => 'Bitte geben Sie einen Namen an.',
        'Print this ticket!' => 'Imprimir este chamado!',
        'Prio' => 'Prioridade',
        'Process-Path' => 'Caminho do Processo',
        'Product' => 'Produkt(e)',
        'Queue <-> Auto Responses Management' => 'Fila <-> Gerenciamento de Auto Respostas',
        'Queue Management' => 'Gerenciamento de Filas',
        'Queue is required.' => 'Die Queue ist erforderlich.',
        'QueueView Refresh Time' => 'Tempo de atualização das Filas',
        'Queues <-> Auto Responses' => 'Queues <-> Auto-Antworten',
        'Realname' => 'Nome real',
        'Rebuild' => 'Reconstruir',
        'Recipients' => 'Destinatários',
        'Reminder' => 'Lembretes',
        'Reminder messages' => 'Mensagens com lembretes',
        'Remove from list of subscribed tickets' => 'Ticket-Abo kündigen',
        'Reporter' => 'Relator',
        'Required Field' => 'Campo Requerido',
        'Required!' => 'Erforderlich!',
        'Response Management' => 'Gerenciamento de Respostas',
        'Responses <-> Attachments Management' => 'Respostas <-> Gerenciamento de Anexos',
        'Responses <-> Queue Management' => 'Respostas <-> Gerenciamento de Filas',
        'Result Form' => 'Resultado',
        'Return to the compose screen' => 'Retornar para a tela de composição',
        'Role' => 'Papel',
        'Roles <-> Agents' => 'Rollen <-> Agenten',
        'Roles <-> Groups Management' => 'Papéis <-> Gerenciamento de Grupos',
        'Roles <-> Users' => 'Papéis <-> Usuários',
        'Roles <-> Users Management' => 'Papel <-> Gerenciamento de Usuários',
        'Run Search' => 'Executar pesquisa',
        'SMTP Auth Password' => 'SMTP Auth Passwort',
        'SMTP Auth User' => 'SMTP Auth Benutzer',
        'SMTP Authentication' => 'SMTP-Authentifizierung',
        'Save Job as?' => 'Salvar trabalho como?',
        'Save Search-Profile as Template?' => 'Salvar o Perfil de Busca como Modelo?',
        'Schedule' => 'Agenda',
        'Search Result' => 'Resultado da Busca',
        'Search Ticket' => 'Procurar chamado',
        'Search for' => 'Pesquisar por',
        'Search for customers (wildcards are allowed).' => 'Procurar por clientes (curingas são permitidos).',
        'Search-Profile as Template?' => 'Perfil-Pesquisa como Modelo?',
        'Search-Template' => 'Modelo de Busca',
        'Secure Mode need to be enabled!' => 'Modo de Segurança deve ser ativado!',
        'Select Box' => 'Caixa de Seleção',
        'Select Box Result' => 'Selecione a Caixa de Resultado',
        'Select Group' => 'Gruppe auswählen',
        'Select Source (for add)' => 'Selecione Origem (para adição)',
        'Select group' => 'Gruppe auswählen',
        'Select inbound mail type' => 'Art des Mailempfangs auswählen',
        'Select outbound mail type' => 'Art des Mailversands auswählen',
        'Select the customeruser:service relations.' => 'Selecione as relações cliente:serviço.',
        'Select the element, which will be used at the X-axis' => 'Selecione o elemento que será usado no eixo X',
        'Select the restrictions to characterise the stat' => 'Selecione as restrições para caracterizar o status',
        'Select the role:user relations.' => 'Selecione a relação entre o papel/usuário.',
        'Select the user:group permissions.' => 'Selecionar as permissões de  usuário:grupo.',
        'Select your QueueView refresh time.' => 'Selecione o tempo de atualização das Filas',
        'Select your default spelling dictionary.' => 'Escolha o seu corretor ortográfico padrão.',
        'Select your frontend Charset.' => 'Selecione o Conjunto de Caracteres.',
        'Select your frontend QueueView.' => 'Selecione a Visão da Fila.',
        'Select your frontend language.' => 'Selecione o Idioma.',
        'Select your out of office time.' => 'Selecione seu horário de ausência do escritório (férias, licenças etc.).',
        'Select your screen after creating a new ticket.' => 'Selecione a tela seguinte após a criação de um novo chamado.',
        'Selection needed' => 'É necessária a seleção',
        'Send Administrative Message to Agents' => 'Versenden von administrativen Nachrichten an die Agenten.',
        'Send Notification' => 'Enviar Notificação',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' =>
            'Zusenden einer Mitteilung, wenn ein Kunde eine Nachfrage stellt und ich der Besitzer bin.',
        'Send me a notification of an watched ticket like an owner of an ticket.' =>
            'Envie-me uma notificação de um chamado monitorado como no caso de um proprietário de chamado.',
        'Sent new password to: ' => 'Enviada nova senha para: ',
        'Sent new password to: %s' => 'Enviada nova senha para: %s',
        'Sent password reset instructions to %s. Please check your email.' =>
            'Anweisungen zum Ändern des Passworts wurden an %s gesendet. Bitte prüfen Sie Ihre E-Mail.',
        'Sent password token to: %s' => 'Enviado token de senha para: %s',
        'Service-Name' => 'Service-Name',
        'Sessions' => 'Sessões',
        'Set customer user and customer id of a ticket' => 'Configurar usuário e id do cliente no chamado',
        'Set this ticket to pending!' => 'Marcar este chamado como pendente!',
        'Show' => 'Visualizar',
        'Shows the ticket history!' => 'Apresentar histórico de chamados',
        'Site' => 'Site',
        'Solution' => 'Solução',
        'Some result formats are disabled because at least one needed package is not installed. Please contact your administrator.' =>
            'Einige Ergebnisformate sind deaktiviert, weil mindestens ein benötigtes Modul nicht installiert ist. Bitte kontaktieren Sie Ihren Administrator.',
        'Sort by' => 'Ordenado pela',
        'Source' => 'Origem',
        'Spell Check' => 'Checar Ortografia',
        'Split' => 'Dividir',
        'State Type' => 'Tipo de Estado',
        'Static-File' => 'Arquivo-Estático',
        'Stats-Area' => 'Área de Estatísticas',
        'Step %s of %s' => 'Schritt %s von %s',
        'Sub-Queue of' => 'Subfila de',
        'Sub-Service of' => 'Subserviço de',
        'Subscribe' => 'Monitorar',
        'System State Management' => 'Gerenciamento de Estados do Sistema',
        'System Status' => 'System Status',
        'Systemaddress' => 'Endereço do Sistema',
        'Take care that you also updated the default states in you Kernel/Config.pm!' =>
            'Tenha o cuidado de atualizar também os estados padrão no Kernel/Config.pm!',
        'Text is required!' => 'Der Text wird benötigt',
        'The Ticket was locked' => 'Das Ticket ist gesperrt',
        'The User Name you wish to have' => 'O Nome de Usuário que você deseja ter',
        'The customer id is required!' => 'Die Kunden-ID ist erforderlich!',
        'The customer is required!' => 'Der Kundenkontakt ist erforderlich!',
        'The customer is required.' => 'Ein Kundenkontakt ist erforderlich.',
        'The field is required.' => 'Die Eingabe ist zwingend erforderlich.',
        'The identify of the system. Each ticket number and each http session id starts with this number.' =>
            'Die Identität des Systems. Jede Ticketnummer und jede HTTP-Session-ID beginnt mit dieser Nummer.',
        'The message being composed has been closed.  Exiting.' => 'A mensagem sendo composta foi fechada. Saindo.',
        'The subject is required!' => 'Der Betreff ist erforderlich!',
        'The subject is required.' => 'Der Betreff ist erforderlich.',
        'The text is required!' => 'Der Text ist erforderlich!',
        'The text is required.' => 'Der Text ist erforderlich.',
        'These values are read-only.' => 'Diese Inhalte sind schreibgeschützt.',
        'These values are required.' => 'Diese Inhalte werden benötigt.',
        'This account exists.' => 'Esta conta existe.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' =>
            'Isso é útil se você não quer que ninguém obtenha o resultado da estatística ou a estatística não está configurada totalmente.',
        'This window must be called from compose window' => 'Esta janela deve ser chamada da janela de composição',
        'Ticket Lock' => 'Chamado bloqueado',
        'Ticket Number Generator' => 'Gerador de Número de Chamado',
        'Ticket Search' => 'Busca de Chamado',
        'Ticket Status View' => 'Visualização do Status do Chamado',
        'Ticket Type is required!' => 'Tipo de chamado é requerido!',
        'Ticket escalation!' => 'Escalação de chamados!',
        'Ticket locked!' => 'Chamado bloqueado!',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' =>
            'Opções do proprietário do chamado (z. B. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Informationen über den Besitzer des Tickets (z. B. <OTRS_OWNER_UserFirstname>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Opções do proprietário do Chamado (ex.: <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' =>
            'Opções do responsável pelo chamado (ex.: <OTRS_RESPONSIBLE_UserFirstname>).',
        'Ticket selected for bulk action!' => 'Chamado selecionado para execução de ação em massa!',
        'Ticket type is required.' => 'Der Typ des Tickets ist erforderlich',
        'Ticket unlock!' => 'Chamado desbloqueado!',
        'Ticket#' => 'Ticket Nr.',
        'Ticket-Area' => 'Área de Chamado',
        'TicketFreeFields' => 'Campos livres do chamado',
        'TicketFreeText' => 'Texto livre Chamado',
        'TicketZoom' => 'Detalhe do chamado',
        'Tickets available' => 'Chamados disponíveis',
        'Tickets shown' => 'Chamados mostrados',
        'Tickets which need to be answered!' => 'Chamados que precisam ser respondidos!',
        'Time units is a required field!' => 'Zeiteinheiten ist eine erforderliche Eingabe.',
        'Time units is a required field.' => 'Zeiteinheiten ist eine erforderliche Eingabe.',
        'Time units is required field.' => 'Zeiteinheiten ist eine erforderliche Eingabe.',
        'Time1' => 'Zeit1',
        'Time2' => 'Zeit2',
        'Time3' => 'Zeit3',
        'Time4' => 'Zeit4',
        'Time5' => 'Zeit5',
        'Time6' => 'Zeit6',
        'Timeover' => 'Tempo esgotado',
        'Times' => 'Hora',
        'Title is required.' => 'Ein Titel ist erforderlich',
        'Title of the stat.' => 'Título da estatística.',
        'Title{user}' => 'Anrede',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' =>
            'Para buscar o atributo do artigo (ex.: (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' =>
            'Para buscar o atributo do artigo (ex.: (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).',
        'To: (%s) replaced with database email!' => 'Para: (%s) substituído com e-mail do banco de dados!',
        'Top of Page' => 'Topo da Página',
        'Total hits' => 'Total de acertos',
        'U' => 'C',
        'Unlock Tickets' => 'Desbloquear Chamados',
        'Unlock to give it back to the queue!' => 'Desbloqueie para enviá-lo devolta à fila!',
        'Unsubscribe' => 'Desmonitorar',
        'Use utf-8 it your database supports it!' => 'Use UTF-8 se sua base de dados suportar!',
        'Useable options' => 'Opções disponíveis',
        'Used default language.' => 'Zu benutzende Standardspracheinstellung',
        'Used log backend.' => 'Benutzte Methode zur Protokollierung',
        'User Management' => 'Gerenciamento de Usuários',
        'User for Inbound Mail' => 'Benutzername für Mailempfang',
        'User will be needed to handle tickets.' => 'Será necessário um usuário para manipular os chamados.',
        'User-Name' => 'Benutzer-Name',
        'User-Number' => 'Número-Usuário',
        'Username for SMTP Auth' => 'Benutzername für die SMTP-Authentifizierung',
        'Users' => 'Usuários',
        'Users <-> Groups' => 'Usuários <-> Grupos',
        'Users <-> Groups Management' => 'Usuários <-> Gerenciamento de Grupos',
        'Verify New Password' => 'Passwort verifizieren',
        'Warning! This tickets will be removed from the database! This tickets are lost!' =>
            'Alerta! Este chamado será removido da base de dados! Este chamado esrá perdido permanentemente!',
        'Watch notification' => 'Notificação de Monitoramento',
        'We stop eating if you wish us to do.' => 'Wenn Sie wollen, hören wir sogar auf zu essen.',
        'Web-Installer' => 'Instalador Web',
        'Welcome to OTRS' => 'Bem-vindo ao OTRS',
        'Wildcards are allowed.' => 'Curingas são permitidos.',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Com uma estatística no estado de inválida não é possível gerá-la.',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' =>
            'Com os campos de inserção e seleção, você pode configurar a estatística de acordo com a sua necessidade. Os elementos da estatística que você pode editar dependem das permissões concedidas a você pelo administrador do sistema.',
        'Workflow Groups' => 'Grupos de Fluxo de Trabalho',
        'Yes, save it with name' => 'Sim, salve-o com o nome',
        'You as the customer have the ability to let us support staff people jump around as you wish because it\'s all about you.' =>
            'Sie als Kunde haben die Möglichkeit, uns Supportmitarbeiter herumzuscheuchen wie Sie wollen, weil es sich um Sie dreht.',
        'You got new message!' => 'Você recebeu uma nova mensagem',
        'You have not created a ticket yet.' => 'Sie haben noch kein Ticket erstellt.',
        'You need a email address (e. g. customer@example.com) in To:!' =>
            'Im Feld An: wird eine E-Mail-Adresse (z. B. kunde@example.com) benötigt!',
        'You need a to: recipient!.' => 'Ein Empfänger "An:" wird benötigt!',
        'You need min. one selected Ticket!' => 'Você deve selecionar ao menos 1(um) chamado!',
        'You need to account time!' => 'Você deve contabilizar o tempo!',
        'You need to activate %s first to use it!' => 'Primeiramente ative %s, para uso!',
        'You use the DELETE option! Take care, all deleted Tickets are lost!!!' =>
            'Você usou a opção DELETAR! Cuidado, todos os chamados apagados serão perdidos!!!',
        'Your Password' => 'Ihr Passwort',
        'Your email address is new' => 'Deine E-Mail-Adresse ist neu',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            'Die E-Mail mit der Ticketnummer "<OTRS_TICKET>" ist an "<OTRS_BOUNCE_TO>" gebounced. Kontaktieren Sie diese Adresse für weitere Nachfragen.',
        'Your own Ticket' => 'Seu próprio chamado',
        'Your way to communicate with us is this thing called \'ticket\'.' =>
            'Sie können mit uns durch dieses Ding namens "Ticket" kommunizieren.',
        'customer realname' => 'Nome real do cliente',
        'delete' => 'Excluir',
        'delete links' => 'Verknüpfungen löschen',
        'down' => 'Abaixo',
        'false' => 'falso',
        'for agent firstname' => 'Nome do Atendente',
        'for agent lastname' => 'Sobrenome do Atendente',
        'for agent login' => 'Login do Atendente',
        'for agent user id' => 'Id do Atendente',
        'go back' => 'Zurück',
        'kill all sessions' => 'Finalizar todas as sessões',
        'modified' => 'modificado',
        'new ticket' => 'Novo Chamado',
        'next step' => 'próximo passo',
        'not rated' => 'não avaliado',
        'not verified' => 'não verificado',
        'read' => 'gelesen',
        'send' => 'Enviar',
        'sort downward' => 'ordem decrescente',
        'sort upward' => 'ordem crescente',
        'tmp_lock' => 'gesperrt (temporär)',
        'to get the first 20 character of the subject' => 'para obter os 20 primeiros caracteres do assunto',
        'to get the first 5 lines of the email' => 'Um die ersten 5 Zeilen der E-Mail zu erhalten',
        'to get the from line of the email' => 'Um die From: Zeile zu erhalten',
        'to get the realname of the sender (if given)' => 'para obter o nome do remetente (se possuir no e-mail)',
        'unknown' => 'desconhecido',
        'unread' => 'não lida',
        'up' => 'Acima',
        'verified' => 'verificado',
        'x' => 'x',

    };
    # $$STOP$$
    return;
}

1;
