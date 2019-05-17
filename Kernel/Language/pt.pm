# --
# Copyright (C) 2004-2007 CAT - Filipe Henriques <filipehenriques at ip.pt>viz
# Copyright (C) 2012 FCCN - Rui Francisco <rui.francisco@fccn.pt>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::pt;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%Y-%M-%D %T';
    $Self->{DateFormatLong}      = '%A, %D de %B de %Y, %T';
    $Self->{DateFormatShort}     = '%Y-%M-%D';
    $Self->{DateInputFormat}     = '%Y-%M-%D';
    $Self->{DateInputFormatLong} = '%Y-%M-%D - %T';
    $Self->{Completeness}        = 0.434513097380524;

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
        'Done' => 'Concluído',
        'Cancel' => 'Cancelar',
        'Reset' => 'Restaurar',
        'more than ... ago' => 'mais de ... atrás',
        'in more than ...' => 'em mais de ...',
        'within the last ...' => 'no último ...',
        'within the next ...' => 'no próximo ...',
        'Created within the last' => 'Criado no último',
        'Created more than ... ago' => 'Criado há mais de ... atrás',
        'Today' => 'Hoje',
        'Tomorrow' => 'Amanhã',
        'Next week' => 'Próxima semana',
        'day' => 'dia',
        'days' => 'dias',
        'day(s)' => 'dia(s)',
        'd' => 'd',
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
        'month(s)' => 'mes(ses)',
        'week' => 'semana',
        'week(s)' => 'semana(s)',
        'quarter' => 'quarto',
        'quarter(s)' => 'quarto(s)',
        'half-year' => 'semestre',
        'half-year(s)' => 'semestre(s)',
        'year' => 'ano',
        'years' => 'anos',
        'year(s)' => 'ano(s)',
        'second(s)' => 'segundo(s)',
        'seconds' => 'segundos',
        'second' => 'segundo',
        's' => 's',
        'Time unit' => 'Unidade de tempo',
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
        'Invalid' => 'Inválido',
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
        'Need Action' => 'Ação Necessária',
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
        'Standard' => 'Padrão',
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
        'CustomerIDs' => 'IDs de Clientes',
        'customer' => 'cliente',
        'agent' => 'agente',
        'system' => 'sistema',
        'Customer Info' => 'Informação de Cliente',
        'Customer Information' => 'Informação de cliente',
        'Customer Companies' => 'Empresas de clientes',
        'Company' => 'Empresa',
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
        'before/after' => 'antes/depois',
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
        'Show Tree Selection' => 'Mostre a seleção em árvore',
        'The field content is too long!' => 'O conteúdo do campo é muito longo!',
        'Maximum size is %s characters.' => 'O Tamanho máximo são %s caracteres',
        'This field is required or' => 'O campo é necessário ou',
        'New message' => 'Nova mensagem',
        'New message!' => 'Nova mensagem!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Por favor, responda a este(s) ticket(s) para regressar à visualização de filas!',
        'You have %s new message(s)!' => 'Tem %s mensagem(s) nova(s)!',
        'You have %s reminder ticket(s)!' => 'Tem %s lembrete(s)!',
        'The recommended charset for your language is %s!' => 'O código recomendado para o seu idioma é %s!',
        'Change your password.' => 'Alterar a sua palavra-passe',
        'Please activate %s first!' => 'Por favor active %s primeiro!',
        'No suggestions' => 'Sem sugestões',
        'Word' => 'Palavra',
        'Ignore' => 'Ignorar',
        'replace with' => 'substituir por',
        'There is no account with that login name.' => 'Não existe nenhuma conta com esse nome de utilizador',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Login falhou! Utilizador ou password errada(s).',
        'There is no acount with that user name.' => 'Não existe nenhuma conta com esse nome de utilizador.',
        'Please contact your administrator' => 'Por favor contate o administrador',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            'Autenticação efectuada com sucesso, mas não existe registo de cliente no backend de clientes. Por favor, contacte o seu administrador',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'O endereço de e-mail já existe. Por favor, entre ou altere a sua password.',
        'Logout' => 'Sair',
        'Logout successful. Thank you for using %s!' => 'Saiu com sucesso. Obrigado por utilizar o %s!',
        'Feature not active!' => 'Característica não ativa!',
        'Agent updated!' => 'Agente atualizado',
        'Database Selection' => 'Seleção da Base de Dados',
        'Create Database' => 'Criar Base de Dados',
        'System Settings' => 'Propriedades de Sistema',
        'Mail Configuration' => 'Configuração de correio',
        'Finished' => 'Terminado',
        'Install OTRS' => 'Instalar OTRS',
        'Intro' => 'Intro',
        'License' => 'Licença',
        'Database' => 'Base de dados',
        'Configure Mail' => 'Configurar Mail',
        'Database deleted.' => 'Base de dados apagada.',
        'Enter the password for the administrative database user.' => 'Insira a palavra-passe para a base de dados de administrador',
        'Enter the password for the database user.' => 'Insira a palavra-passe para o utilizador da base de dados.',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Se criou uma palavra-passe para a raiz de base de dados tem que a colocar aqui. Se não deixe o campo em branco.',
        'Database already contains data - it should be empty!' => 'A base de dados já contém dados - deveria estar vazia!',
        'Login is needed!' => 'Nome de utilizador necessário!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Não é possível efectuar autenticação devido a uma manutenção agendada do sistema.',
        'Password is needed!' => 'Palavra-passe é necessária!',
        'Take this Customer' => 'Alterar para este Cliente',
        'Take this User' => 'Alterar para este Utilizador',
        'possible' => 'possível',
        'reject' => 'rejeitar',
        'reverse' => 'reverter',
        'Facility' => 'Instalação',
        'Time Zone' => 'Fuso horário',
        'Pending till' => 'Pendente até',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Não utilize a conta de Administrador para trabalhar com o OTRS! Em vez disso, crie novos Agentes e trabalhe com essas contas.',
        'Dispatching by email To: field.' => 'Enviado através do campo de email Para:',
        'Dispatching by selected Queue.' => 'Enviado para a Fila selecionada.',
        'No entry found!' => 'Entrada não encontrada!',
        'Session invalid. Please log in again.' => 'Sessão inválida. Por favor, autentique-se novamente.',
        'Session has timed out. Please log in again.' => 'A sessão expirou. Por favor autentique-se novamente',
        'Session limit reached! Please try again later.' => 'Terminou o tempo limite de sessão! Por favor tente novamente mais tarde.',
        'No Permission!' => 'Sem Permissão!',
        '(Click here to add)' => '(Clique aqui para adicionar)',
        'Preview' => 'Pré-visualizar',
        'Package not correctly deployed! Please reinstall the package.' =>
            'O pacote não foi corretamente instalado! Por favor reinstale o pacote.',
        '%s is not writable!' => '%s não modificável',
        'Cannot create %s!' => 'Não é possível criar %s',
        'Check to activate this date' => 'Confirmar para ativar esta data',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Tem Fora do Escritório activo, deseja desactivar?',
        'News about OTRS releases!' => 'Notícias acerca dos lançamentos OTRS!',
        'Go to dashboard!' => 'Ir para o Dashboard',
        'Customer %s added' => 'Cliente %s adicionado.',
        'Role added!' => 'Papel adicionado!',
        'Role updated!' => 'Papel atualizado!',
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
        'Customer company added!' => 'Empresa cliente adicionada!',
        'Customer company updated!' => 'Empresa cliente actualizada!',
        'Note: Company is invalid!' => 'Nota: Empresa não é válida!',
        'Mail account added!' => 'Conta de Mail adicionada!',
        'Mail account updated!' => 'Conta de Mail actualizada!',
        'System e-mail address added!' => 'Endereço de e-mail de sistema adicionado',
        'System e-mail address updated!' => 'Endereço de email de sistema atualizado',
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
        'PGP' => 'PGP',
        'PGP Key' => 'Chave PGP',
        'PGP Keys' => 'Chaves PGP',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'Certificado S/MIME',
        'S/MIME Certificates' => 'Certificados S/MIME',
        'Office' => 'Gabinete',
        'Phone' => 'Telefone',
        'Fax' => 'Fax',
        'Mobile' => 'Telemóvel',
        'Zip' => 'Código Postal',
        'City' => 'Cidade',
        'Street' => 'Rua',
        'Country' => 'País',
        'Location' => 'Localização',
        'installed' => 'instalado',
        'uninstalled' => 'desinstalado',
        'Security Note: You should activate %s because application is already running!' =>
            'Nota de Segurança: Deveria activar %s porque a aplicação já está a correr!',
        'Unable to parse repository index document.' => 'Impossível processar a indexação do documento do repositório.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Não existem pacotes para a versão do software que possui, apenas existem pacotes para outra versões.',
        'No packages, or no new packages, found in selected repository.' =>
            'Não existem pacotes no repositório selecionado',
        'Edit the system configuration settings.' => 'Edite as definições de configuração do sistema.',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'A informação da Lista de Controlo de Acesso (ACL) da base da dados não está a sincronizar com o sistema, por favor carregue toda a lista.',
        'printed at' => 'impresso em',
        'Loading...' => 'A carregar...',
        'Dear Mr. %s,' => 'Exmo Sr, %s',
        'Dear Mrs. %s,' => 'Exma Sra. %s',
        'Dear %s,' => 'Caro %s,',
        'Hello %s,' => 'Cara %s,',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Não é permitido registar este endereço de e-mail. Por favor contacte a equipa de suporte.',
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
        'Shown customer users' => 'Mostrar utilizadores do cliente',
        'News' => 'Notícias',
        'Product News' => 'Novidades do produto',
        'OTRS News' => 'Notícias OTRS',
        '7 Day Stats' => 'Estatísticas de 7 dias',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Informações do Processo de Manutenção da base de dados não está a sincronizar com o sistema de configuração, por favor, sincronizar todos os processos.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'O Pacote não foi verificado pelo Groupo OTRS! Não é recomendado utilizar o Pacote.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Mark' => 'Marca',
        'Unmark' => 'Desmarca',
        'Bold' => 'Negrito',
        'Italic' => 'Itálico',
        'Underline' => 'Sublinhado',
        'Font Color' => 'Côr',
        'Background Color' => 'Côr de fundo',
        'Remove Formatting' => 'Limpar formação',
        'Show/Hide Hidden Elements' => 'Mostra/Oculta Elementos Ocultos',
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
        'OTRS Daemon is not running.' => 'O Daemon OTRS não está em execução.',
        'Can\'t contact registration server. Please try again later.' => 'Não é possivel contatar o servidor de registo. Por favor tente novamente mais tarde.',
        'No content received from registration server. Please try again later.' =>
            'Não foi recebido nenhum conteudo do servidor de registo. Por favor tente novamente mais tarde.',
        'Problems processing server result. Please try again later.' => 'Problemas a processar o resultado do servidor. Por favor tente novamente mais tarde.',
        'Username and password do not match. Please try again.' => 'Utilizador e password não coincidem. Por favor tente novamente.',
        'The selected process is invalid!' => 'O processo selecionado é invalido!',
        'Upgrade to %s now!' => 'Atualização para %s agora!',
        '%s Go to the upgrade center %s' => '%s Vá para o centro de atualização %s',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'A Licença para o seu %s está a terminar. Por favor entre em contato com %s para renovar o contrato!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'A atualização para o seu %s está disponivel, mas existe um conflito com a versão da sua estrutura! Por favor atualize a sua estrutura primeiro!',
        'Your system was successfully upgraded to %s.' => 'O seu sistema foi atualizado com sucesso até %s',
        'There was a problem during the upgrade to %s.' => 'Ocorreu um problema durante a atualização aos %s',
        '%s was correctly reinstalled.' => '%s foi corretamente reinstalado.',
        'There was a problem reinstalling %s.' => 'Existe um problema a reinstalar %s',
        'Your %s was successfully updated.' => 'O seu %s foi atualizado com sucesso.',
        'There was a problem during the upgrade of %s.' => 'Existiu um problema durante a atualização de %s',
        '%s was correctly uninstalled.' => '%s foi corretamente desinstalado.',
        'There was a problem uninstalling %s.' => 'Existiu um problema a desinstalar %s.',
        'Enable cloud services to unleash all OTRS features!' => 'Active os serviços cloud para desbloquear todas as funcionalidades OTRS!',

        # Template: AAACalendar
        'New Year\'s Day' => 'Dia de Ano Novo',
        'International Workers\' Day' => 'Dia do Trabalhador',
        'Christmas Eve' => 'Vespera de Natal',
        'First Christmas Day' => 'Dia de Natal',
        'Second Christmas Day' => 'Segundo Dia de Natal',
        'New Year\'s Eve' => 'Vespera de Ano Novo',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS como requisitante.',
        'OTRS as provider' => 'OTRS como prestador',
        'Webservice "%s" created!' => 'O serviço Web "%s" foi criado!',
        'Webservice "%s" updated!' => 'O serviço Web "%s" foi atualizado!',

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
        'User Profile' => 'Perfil do Utilizador',
        'Email Settings' => 'Definições de email',
        'Other Settings' => 'Outras definições',
        'Notification Settings' => 'Configuração de Notificações',
        'Change Password' => 'Mudar a Palavra-passe',
        'Current password' => 'Password atual',
        'New password' => 'Nova password',
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
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Não foi possível atualizar a password, tem de conter no mínimo 2 caracteres minúsculos e 2 caracteres maiusculos.',
        'Can\'t update password, it must contain at least 1 digit!' => 'Não foi possível atualizar a password, tem de ter no mínimo 1 dígito',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Não foi possível atualizar a password, tem de ter no mínimo 2 carateres',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Não foi possível atualizar a password, esta password já foi utilizada. Por favor escolha uma nova!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            '',
        'CSV Separator' => 'Separador CSV',

        # Template: AAATicket
        'Status View' => 'Vista de Estado',
        'Service View' => 'Vista de Serviço',
        'Bulk' => 'Em bloco',
        'Lock' => 'Bloquear',
        'Unlock' => 'Desbloquear',
        'History' => 'Histórico',
        'Zoom' => 'Detalhe',
        'Age' => 'Antiguidade',
        'Bounce' => 'Devolver',
        'Forward' => 'Encaminhar',
        'From' => 'De',
        'To' => 'Para',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'Assunto',
        'Move' => 'Mover',
        'Queue' => 'Fila',
        'Queues' => 'Filas',
        'Priority' => 'Prioridade',
        'Priorities' => 'Prioridades',
        'Priority Update' => 'Atualização de Prioridade',
        'Priority added!' => 'Prioridade adicionada!',
        'Priority updated!' => 'Prioridade atualizada!',
        'Signature added!' => 'Assinatura adicionada!',
        'Signature updated!' => 'Assinatura atualizada!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Acordo de Nível de Serviço',
        'Service Level Agreements' => 'Níveís de serviço',
        'Service' => 'Serviço',
        'Services' => 'Serviços',
        'State' => 'Estado',
        'States' => 'Estado',
        'Status' => 'Estado',
        'Statuses' => 'Estados',
        'Ticket Type' => 'Tipo de ticket',
        'Ticket Types' => 'Tipos de ticket',
        'Compose' => 'Compôr',
        'Pending' => 'Pendências',
        'Owner' => 'Proprietário',
        'Owner Update' => 'Atualizar Proprietário',
        'Responsible' => 'Responsável',
        'Responsible Update' => 'Atualização de Responsável',
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
        'Locked Tickets Total' => 'Total de Tickets Bloqueados',
        'Locked Tickets Reminder Reached' => 'Lembrete de tickets bloqueado atingido',
        'Locked Tickets New' => 'Novos tickets bloqueados',
        'Responsible Tickets Total' => 'Total de tickets(responsável)',
        'Responsible Tickets New' => 'Novos tickets(responsável)',
        'Responsible Tickets Reminder Reached' => 'Lembrete de tickets(responsável) atingido',
        'Watched Tickets Total' => 'Total de tickets vigiados',
        'Watched Tickets New' => 'Novos tickets vigiados',
        'Watched Tickets Reminder Reached' => 'Lembrete de tickets vigiados',
        'All tickets' => 'Todos os tickets',
        'Available tickets' => 'Pedidos Disponiveis',
        'Escalation' => 'Escalagem',
        'last-search' => 'última pesquisa',
        'QueueView' => 'Filas',
        'Ticket Escalation View' => 'Fila de tickets escalados',
        'Message from' => 'Mensagem de',
        'End message' => 'Fim da mensagem',
        'Forwarded message from' => 'Mensagem reencaminhada de',
        'End forwarded message' => 'Fim da mensagem reencaminhada',
        'Bounce Article to a different mail address' => '',
        'Reply to note' => 'Responder na nota',
        'new' => 'novo',
        'open' => 'aberto',
        'Open' => 'Aberto',
        'Open tickets' => 'Tickets abertos',
        'closed' => 'fechado',
        'Closed' => 'Fechado',
        'Closed tickets' => 'Tickets fechados',
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
        'sms' => 'sms',
        'webrequest' => 'pedido via Web',
        'lock' => 'bloquear',
        'unlock' => 'desbloquear',
        'very low' => 'muito baixa',
        'low' => 'baixa',
        'normal' => 'normal',
        'high' => 'alta',
        'very high' => 'muito alta',
        '1 very low' => '1 muito baixa',
        '2 low' => '2 baixa',
        '3 normal' => '3 normal',
        '4 high' => '4 alta',
        '5 very high' => '5 muito alta',
        'auto follow up' => 'actualizar automaticamente',
        'auto reject' => 'rejeição automática',
        'auto remove' => 'remoção automática',
        'auto reply' => 'resposta automática',
        'auto reply/new ticket' => 'resposta automática/novo pedido',
        'Create' => 'Criar',
        'Answer' => 'Resposta',
        'Phone call' => 'Chamada telefónica',
        'Ticket "%s" created!' => 'Ticket "%s" criado!',
        'Ticket Number' => 'Número do Ticket',
        'Ticket Object' => 'Objeto Ticket',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Não existe Número de Ticket "%s"! Não é possível efectuar a ligação!',
        'You don\'t have write access to this ticket.' => 'Não tem permissão de escrita neste pedido.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Desculpe, precisa de ser o proprietario deste pedido para realizar esta ação',
        'Please change the owner first.' => 'Por favor altere o proprietário primeiro.',
        'Ticket selected.' => 'Ticket selecionado',
        'Ticket is locked by another agent.' => 'Ticket bloqueado por outro agente',
        'Ticket locked.' => 'Ticket bloqueado',
        'Don\'t show closed Tickets' => 'Não mostrar tickets fechados',
        'Show closed Tickets' => 'Mostrar tickets fechados',
        'New Article' => 'Novo Artigo',
        'Unread article(s) available' => 'Artigo(s) não lido(s) disponíveis',
        'Remove from list of watched tickets' => 'Remover dos tickets vigiados',
        'Add to list of watched tickets' => 'Adicionar aos tickets vigiados',
        'Email-Ticket' => 'Mensagem',
        'Create new Email Ticket' => 'Criar novo Ticket via email',
        'Phone-Ticket' => 'Telefonema',
        'Search Tickets' => 'Procurar Tickets',
        'Customer Realname' => 'Nome Real do Cliente',
        'Customer History' => 'História do Cliente',
        'Edit Customer Users' => 'Editar Utilizadores de cliente',
        'Edit Customer' => 'Editar cliente',
        'Bulk Action' => 'Em bloco',
        'Bulk Actions on Tickets' => 'Operações em bloco sobre Tickets',
        'Send Email and create a new Ticket' => 'Enviar mensagem e criar novo Ticket',
        'Create new Email Ticket and send this out (Outbound)' => 'Criar novo Email Ticket e enviar para fora',
        'Create new Phone Ticket (Inbound)' => 'Criar novo Ticket por telefone',
        'Address %s replaced with registered customer address.' => 'Endereço %s substituído por um endereço de cliente registado ',
        'Customer user automatically added in Cc.' => 'Utilizador de Cliente adicionado automaticamente em Cc (Com Conhecimento)',
        'Overview of all open Tickets' => 'Vista de todos os tickets abertos',
        'Locked Tickets' => 'Tickets bloqueados',
        'My Locked Tickets' => 'Os meus tickets bloqueados',
        'My Watched Tickets' => 'Os meus tickets vigiados',
        'My Responsible Tickets' => 'Tickets de que sou responsável',
        'Watched Tickets' => 'Ticket vigiados',
        'Watched' => 'Vigiado',
        'Watch' => 'Vigiar',
        'Unwatch' => 'Parar de seguir',
        'Lock it to work on it' => 'Bloquear para trabalhar com ticket',
        'Unlock to give it back to the queue' => 'Desbloquear para devolver à fila',
        'Show the ticket history' => 'Mostra a história do pedido',
        'Print this ticket' => 'Imprimir este ticket',
        'Print this article' => 'Imprimir este artigo',
        'Split' => 'Divide',
        'Split this article' => 'Divide este artigo',
        'Forward article via mail' => 'Envia o artigo via e-mail',
        'Change the ticket priority' => 'Altera a prioridade do pedido',
        'Change the ticket free fields!' => 'Alterar os campos livres do ticket!',
        'Link this ticket to other objects' => 'Liga este pedido a outros objetos',
        'Change the owner for this ticket' => 'Altera o proprietário deste pedido',
        'Change the  customer for this ticket' => 'Altera o cliente deste pedido',
        'Add a note to this ticket' => 'Adiciona uma nota a este pedido',
        'Merge into a different ticket' => 'Junta-se a um pedido diferente',
        'Set this ticket to pending' => 'Coloca este pedido pendente',
        'Close this ticket' => 'Fechar este ticket',
        'Look into a ticket!' => 'Ver detalhe do ticket!',
        'Delete this ticket' => 'Apagar este ticket',
        'Mark as Spam!' => 'Marcar como Spam!',
        'My Queues' => 'As Minhas Filas',
        'Shown Tickets' => 'Tickets Apresentados',
        'Shown Columns' => 'Colunas Apresentadas',
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
        'New ticket notification' => 'Notificação de novo ticket',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Enviar notificação se houver um novo ticket nas "Minhas Filas".',
        'Send new ticket notifications' => 'Enviar notificações em novos tickets',
        'Ticket follow up notification' => 'Enviar notificações em atualizações de tickets',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Envia-me uma notificação se um cliente dá seguimento e eu sou o dono deste pedido ou o pedido destá desbloqueado e é um das minhas filas subcritas',
        'Send ticket follow up notifications' => 'Envia o pedido seguido de notificações',
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
        'Out Of Office Time' => 'Horário de fora de escritório',
        'New Ticket' => 'Novo Ticket',
        'Create new Ticket' => 'Criar novo ticket',
        'Customer called' => 'O cliente telefonou',
        'phone call' => 'chamada telefónica',
        'Phone Call Outbound' => 'Realizar chamada telefónica',
        'Phone Call Inbound' => 'Chamada telefónica de entrada',
        'Reminder Reached' => 'Limite alcançado',
        'Reminder Tickets' => 'Tickets com lembrete',
        'Escalated Tickets' => 'Tickets escalados',
        'New Tickets' => 'Novos Tickets',
        'Open Tickets / Need to be answered' => 'Tickets abertos / precisam de resposta',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Todos os tickets abertos, tickets já tratados e que precisam de resposta adicional',
        'All new tickets, these tickets have not been worked on yet' => 'Todos os tickets, ainda sem qualquer tratamento',
        'All escalated tickets' => 'Todos os tickets eecalados',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Todos os tickets com lembrete ativo e que atigiram o tempo',
        'Archived tickets' => 'Tickets arquivados',
        'Unarchived tickets' => 'Tickets não arquivados',
        'Ticket Information' => 'Informação do ticket',
        'including subqueues' => 'incluindo sub-filas',
        'excluding subqueues' => 'excluindo sub-filas',

        # Template: AAAWeekDay
        'Sun' => 'Dom',
        'Mon' => 'Seg',
        'Tue' => 'Ter',
        'Wed' => 'Qua',
        'Thu' => 'Qui',
        'Fri' => 'Sex',
        'Sat' => 'Sáb',

        # Template: AdminACL
        'ACL Management' => 'Gestão de ACLs',
        'Filter for ACLs' => 'Filtro para ACLs',
        'Filter' => 'Filtro',
        'ACL Name' => 'Nome da ACL',
        'Actions' => 'Ações',
        'Create New ACL' => 'Criar nova ACL',
        'Deploy ACLs' => 'Implementar ACLs',
        'Export ACLs' => 'Exportar ACLs',
        'Configuration import' => 'Importar configuração',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Aqui pode carregar um ficheiro de configuração para importar a Lista de Controle de Acesso (ACL) para o seu sistema. O ficheiro deve estar no formato .yml como exportado pelo módulo de edição Lista de Controle de Acesso (ACL).',
        'This field is required.' => 'Campo obrigatório',
        'Overwrite existing ACLs?' => 'Substituir ACLs existentes?',
        'Upload ACL configuration' => 'Envio de Configuração Lista de Controle de Acesso (ACL)',
        'Import ACL configuration(s)' => 'Importar configuração(ões) Lista de Controle de Acesso (ACL)',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Para criar uma nova Lista de Controle de Acesso (ACL) pode importar uma lista exportada de outro programa ou criar uma nova completa.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'As alterações na Lista de Controle de Acesso (ACL) aqui só afectam o comportamento do sistema, se instalar os dados Lista de Controle de Acesso (ACL) depois. Ao instalar os dados da Lista de Controle de Acesso (ACL), as alterações mais recentes serão gravadas na configuração.',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Atenção: Esta tabela representa a ordem de execução das Listas de Controle de Acesso (ACLs). Se precisar de alterar a ordem em que as Listas de Controle de Acesso (ACL) são executadas, por favor, altere os nomes das Lista de Controle de Acesso (ACL).',
        'ACL name' => 'Nome da ACL',
        'Validity' => 'Validade',
        'Copy' => 'Copiar',
        'No data found.' => 'não há resultados',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Editar ACL %s',
        'Go to overview' => 'Vista geral',
        'Delete ACL' => 'Eliminar ACL',
        'Delete Invalid ACL' => 'Eliminar ACL inválida',
        'Match settings' => 'Configurações correspondentes',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Defina os critérios de igualdade para este ACL. Use \'Propriedades\' para validar o ecran atual ou \'Propriedades da Bases Dados\' para validade atributos do ticket atual na base de dados.',
        'Change settings' => 'Alterar definições',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Defina o que  quer alterar se os critérios forem válidos. Lembre-se que "Possível" é uma lista branca, "Impossível" é uma lista negra.',
        'Check the official' => 'Verificar a documentação oficial',
        'documentation' => 'documentação',
        'Show or hide the content' => 'Mostrar ou esconder o conteúdo',
        'Edit ACL information' => 'Editar informação de ACL',
        'Stop after match' => 'Parar após encontrar',
        'Edit ACL structure' => 'Editar estrutura de ACL',
        'Save ACL' => 'Guardar ACL',
        'Save' => 'Guardar',
        'or' => 'ou',
        'Save and finish' => 'Grava e termina',
        'Do you really want to delete this ACL?' => 'Quer mesmo remover esta ACL?',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Este item ainda contem sub items. Tem a certeza que quer remover este item incluindo os sub items?',
        'An item with this name is already present.' => 'Um item com este nome já existe.',
        'Add all' => 'Adicionar todos',
        'There was an error reading the ACL data.' => 'Ocorreu um erro a ler os dados da ACL',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Criar uma nova ACL com dados de formulário. Após criar a ACL poderá adicionar items de configuração em modo de edição.',

        # Template: AdminAttachment
        'Attachment Management' => 'Gestão de Anexos',
        'Add attachment' => 'Adicionar anexo',
        'List' => 'Listar',
        'Download file' => 'Descarregar ficheiro',
        'Delete this attachment' => 'Remover anexo',
        'Do you really want to delete this attachment?' => 'Deseja realmente eliminar este anexo?',
        'Add Attachment' => 'Adicionar anexo',
        'Edit Attachment' => 'Editar anexo',

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
        'To get the name of the ticket\'s customer user (if given).' => 'Para obter o nome do utilizador cliente dos tickets (se fornecido).',
        'To get the article attribute' => 'Para obter os atributos do artigo',
        ' e. g.' => 'ex:',
        'Options of the current customer user data' => 'Opções disponíveis para o cliente atual',
        'Ticket owner options' => 'Opções do proprietário do ticket',
        'Ticket responsible options' => 'Opções do responsável do ticket',
        'Options of the current user who requested this action' => 'Opções do utilizador atual que pediu esta ação',
        'Options of the ticket data' => 'Opções para informação do ticket',
        'Options of ticket dynamic fields internal key values' => 'Opções de valores de chave internos dos campos dinâmicos',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'Opções de configuração',
        'Example response' => 'Resposta de exemplo',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => '',
        'Support Data Collector' => 'Agregador de Informação de Suporte',
        'Support data collector' => 'Agregador de informação de suporte',
        'Hint' => 'Sugestão',
        'Currently support data is only shown in this system.' => '',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'É bastante recomendável enviar estes dados para o Grupo OTRS para obter um melhor apoio.',
        'Configuration' => 'Configuração',
        'Send support data' => 'Enviar dados de suporte',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Isso permite que o sistema envie informações de dados de suporte adicionais para o Groupo OTRS.',
        'System Registration' => 'Registo de Sistema',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Para permitir o envio de dados, por favor registe o seu sistema no Group OTRS ou atualize a informação de registo do sistema (confirme que a opção \'Enviar dados de suporte\' está ativa)',
        'Register this System' => 'Registar este Sistema',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            '',
        'Register this system' => 'Registar este Sistema',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            '',
        'Available Cloud Services' => '',
        'Upgrade to %s' => 'Atualização para 1 %',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Gestão de clientes',
        'Wildcards like \'*\' are allowed.' => '',
        'Add customer' => 'Adicionar cliente',
        'Select' => 'Selecionar',
        'List (only %s shown - more available)' => '',
        'List (%s total)' => 'Lista (%s total)',
        'Please enter a search term to look for customers.' => 'Introduza o termo de pesquisa para clientes',
        'Add Customer' => 'Adicionar cliente',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Gestão de utilizador de clientes',
        'Back to search results' => 'Voltar aos resultados da pesquisa',
        'Add customer user' => 'Adicionar utilizador cliente',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '',
        'Last Login' => 'Último acesso',
        'Login as' => 'Entrar como',
        'Switch to customer' => 'Alterar para cliente',
        'Add Customer User' => 'Adicionar utilizador cliente',
        'Edit Customer User' => 'Editar utilizador cliente',
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
        'Edit Customer Default Groups' => 'Editar os grupos de cliente por omissão',
        'These groups are automatically assigned to all customers.' => 'Estes grupos são automaticamente atribuídos a todos os clientes',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Pode gerir estes groups via item de configuração "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filtro de grupos',
        'Just start typing to filter...' => 'Comece a escrever para filtrar ...',
        'Select the customer:group permissions.' => 'Selecionar as permissões customer:group',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Se nada for selecionado, o grupo não tem permissões (os tickets não vão estar visíveis para o cliente)',
        'Search Results' => 'Resultado da pesquisa',
        'Customers' => 'Clientes',
        'No matches found.' => 'Não foram encontrados resultados',
        'Groups' => 'Grupos',
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
        'Active' => 'Activo',
        'Toggle active state for %s' => 'Ativara estar para %s ',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Gestão de Campos Dinâmicos',
        'Add new field for object' => 'Adicionar novo campo a objeto',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => 'Lista de campos dinâmicos',
        'Dynamic fields per page' => 'Campos dinâmicos por página',
        'Label' => 'Etiqueta',
        'Order' => 'Ordenar',
        'Object' => 'Objeto',
        'Delete this field' => 'Apagar este campo',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '',
        'Delete field' => 'Apagar campo',
        'Deleting the field and its data. This may take a while...' => 'Apagar este campo e respetiva informação. Pode demorar algum tempo ...',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Campos Dinâmicos',
        'Field' => 'Campo',
        'Go back to overview' => 'Voltar para visão geral',
        'General' => 'Geral',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '',
        'Changing this value will require manual changes in the system.' =>
            '',
        'This is the name to be shown on the screens where the field is active.' =>
            '',
        'Field order' => 'Ordem dos campos',
        'This field is required and must be numeric.' => 'Este campo é necessário e tem de ser numérico',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '',
        'Field type' => 'Tipo de campo',
        'Object type' => 'Tipo de objeto',
        'Internal field' => 'Campo interno',
        'This field is protected and can\'t be deleted.' => '',
        'Field Settings' => 'Configurações de campo',
        'Default value' => 'Valor por omissão',
        'This is the default value for this field.' => 'Este é o valor por omissão deste campo',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Diferença de data por defeito',
        'This field must be numeric.' => 'Este campo deve ser numérico.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '',
        'Define years period' => 'Definir período de anos',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '',
        'Years in the past' => 'Anos no passado',
        'Years in the past to display (default: 5 years).' => 'Anos no passado a mostrar (predefinido: 5 anos).',
        'Years in the future' => 'Anos no futuro',
        'Years in the future to display (default: 5 years).' => 'Anos no futuro a mostrar (predefinido: 5 anos).',
        'Show link' => 'Mostrar endereço de ligação',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '',
        'Link for preview' => 'Ligação para prévisualizar',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'Restrict entering of dates' => '',
        'Here you can restrict the entering of dates of tickets.' => 'Aqui pode restringir a intrução de datas de tickets.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Valores possíveis',
        'Key' => 'Chave',
        'Value' => 'Valor',
        'Remove value' => 'Apagar valor',
        'Add value' => 'Adicionar valor',
        'Add Value' => 'Adicionar Valor',
        'Add empty value' => 'Adicionar valor vazio',
        'Activate this option to create an empty selectable value.' => '',
        'Tree View' => 'Vista em Árvore',
        'Activate this option to display values as a tree.' => '',
        'Translatable values' => 'Valores traduzíveis',
        'If you activate this option the values will be translated to the user defined language.' =>
            '',
        'Note' => 'Nota',
        'You need to add the translations manually into the language translation files.' =>
            '',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Número de linhas',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '',
        'Number of cols' => 'Número de colunas',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '',
        'Check RegEx' => 'RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'RegEx invalido',
        'Error Message' => 'Mensagem de erro',
        'Add RegEx' => 'Adicionar RegEx',

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
        'Do you really want to delete this task?' => 'Quer mesmo remover esta tarefa?',
        'Job Settings' => 'Definições da tarefa',
        'Job name' => 'Nome da tarefa',
        'The name you entered already exists.' => '',
        'Toggle this widget' => 'Ativar esta widget',
        'Automatic execution (multiple tickets)' => 'Execução automática (múltiplos registos)',
        'Execution Schedule' => '',
        'Schedule minutes' => 'Minutos agendados',
        'Schedule hours' => 'Horas agendada',
        'Schedule days' => 'Dias agendados',
        'Currently this generic agent job will not run automatically.' =>
            'Atualmente, esta tarefa não é executada automaticamente',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Tem de selecionar pelo menos um minuto, hora ou dia para ativar a execução automática',
        'Event based execution (single ticket)' => '',
        'Event Triggers' => '',
        'List of all configured events' => '',
        'Delete this event' => 'Apagar este evento',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'Add Event' => 'Adicionar evento',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Duplicate event.' => '',
        'This event is already attached to the job, Please use a different one.' =>
            '',
        'Delete this Event Trigger' => '',
        'Remove selection' => 'Remover seleção',
        'Select Tickets' => 'Selecionar Tickets',
        '(e. g. 10*5155 or 105658*)' => '(ex., 10*5155 ou 105658*)',
        '(e. g. 234321)' => '(ex., 234321)',
        'Customer user' => 'Utilizador do cliente',
        '(e. g. U5150)' => '(ex., U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Pesquisa em texto integral do artigo (ex. "Mar*in" ou "Baue*")',
        'Agent' => 'Agente',
        'Ticket lock' => 'Ticket bloqueado',
        'Create times' => 'Criar tempo',
        'No create time settings.' => 'Não existem definições de Tempo Criados',
        'Ticket created' => 'Ticket criado',
        'Ticket created between' => 'Ticket criado entre',
        'Last changed times' => 'Última data de modificação',
        'No last changed time settings.' => '',
        'Ticket last changed' => 'Última modificação do ticket em',
        'Ticket last changed between' => '',
        'Change times' => 'Alterar tempos',
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
        'Update/Add Ticket Attributes' => '',
        'Set new service' => 'Criar novo serviço',
        'Set new Service Level Agreement' => 'Definir novo SLA',
        'Set new priority' => 'Definir nova Prioridade',
        'Set new queue' => 'Definir nova fila',
        'Set new state' => 'Definir novo estado',
        'Pending date' => 'Data da pendência',
        'Set new agent' => 'Criar novo agente',
        'new owner' => 'Novo proprietário',
        'new responsible' => 'novo responsável',
        'Set new ticket lock' => 'Definir novo bloqueio no ticket',
        'New customer user' => '',
        'New customer ID' => 'Novo ID de cliente',
        'New title' => 'Novo título',
        'New type' => 'Novo tipo',
        'New Dynamic Field Values' => '',
        'Archive selected tickets' => 'Arquivar tickets selecionados',
        'Add Note' => 'Adicionar nota',
        'This field must have less then 200 characters.' => 'Este campo não pode conter mais de 200 caracteres',
        'Time units' => 'Unidades de tempo',
        'Execute Ticket Commands' => '',
        'Send agent/customer notifications on changes' => 'Enviar notificações de alterações a agente/cliente ',
        'CMD' => 'CMD',
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
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '',
        'Edit job' => 'Editar tarefa',
        'Run job' => 'Executar tarefa',
        'Affected Tickets' => 'Tickets afetados',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'You are here' => 'Está aqui',
        'Web Services' => 'Serviços web',
        'Debugger' => 'Depurador',
        'Go back to web service' => 'Voltar ao web service',
        'Clear' => 'Limpar',
        'Do you really want to clear the debug log of this web service?' =>
            'Confirma a eliminação do debug log deste web service?',
        'Request List' => 'Lista de pedidos',
        'Time' => 'Tempo',
        'Remote IP' => 'IP remoto',
        'Loading' => 'A carregar',
        'Select a single request to see its details.' => 'Seleccione um pedido para ver os detalhes.',
        'Filter by type' => 'Filtrar por tipo',
        'Filter from' => 'Desde',
        'Filter to' => 'Até',
        'Filter by remote IP' => 'Filtrar por IP remoto',
        'Limit' => 'Limite',
        'Refresh' => 'Atualizar',
        'Request Details' => 'Detalhes do pedido',
        'An error occurred during communication.' => 'Ocorreu um erro durante a comunicação',
        'Show or hide the content.' => 'Mostrar ou ocultar o conteúdo.',
        'Clear debug log' => 'Eliminar o log de debug',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Adicionar invocador ao web service %s',
        'Change Invoker %s of Web Service %s' => 'Modificar invocador %s do web service %s',
        'Add new invoker' => 'Adicionar novo invocador',
        'Change invoker %s' => 'Modificar o invocador %s',
        'Do you really want to delete this invoker?' => 'Confirma a remoção deste invocador?',
        'All configuration data will be lost.' => 'Os dados de configuração serão eliminados.',
        'Invoker Details' => 'Detalhes do invocador',
        'The name is typically used to call up an operation of a remote web service.' =>
            'O nome é utilizado para invocar uma operação de um web service remoto.',
        'Please provide a unique name for this web service invoker.' => 'Indique um nome único para este invocador do web service',
        'Invoker backend' => '',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '',
        'Mapping for outgoing request data' => '',
        'Configure' => 'Configurar',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Mapping for incoming response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '',
        'Asynchronous' => 'Assíncrono',
        'This invoker will be triggered by the configured events.' => '',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => 'Gravar e continuar',
        'Delete this Invoker' => 'Remover o invocador',
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => '',
        'Go back to' => 'Voltar para',
        'Mapping Simple' => 'Mapeamento Simples',
        'Default rule for unmapped keys' => 'Regra pré-definida para chaves não mapeadas',
        'This rule will apply for all keys with no mapping rule.' => '',
        'Default rule for unmapped values' => '',
        'This rule will apply for all values with no mapping rule.' => '',
        'New key map' => '',
        'Add key mapping' => '',
        'Mapping for Key ' => '',
        'Remove key mapping' => '',
        'Key mapping' => '',
        'Map key' => 'Mapear chave',
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

        # Template: AdminGenericInterfaceMappingXSLT
        'GenericInterface Mapping XSLT for Web Service %s' => '',
        'Mapping XML' => '',
        'Template' => 'Modelo',
        'The entered data is not a valid XSLT stylesheet.' => '',
        'Insert XSLT stylesheet.' => '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => '',
        'Change Operation %s of Web Service %s' => '',
        'Add new operation' => '',
        'Change operation %s' => '',
        'Do you really want to delete this operation?' => '',
        'Operation Details' => 'Detalhes da operação',
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
        'Delete this Operation' => 'Apagar esta operação',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => '',
        'Network transport' => 'Transporte de rede',
        'Properties' => 'Propriedades',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => '',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '',
        'Maximum message length' => 'Comprimento máximo da mensagem',
        'This field should be an integer number.' => 'Este campo deve ser um inteiro.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            '',
        'Send Keep-Alive' => 'Enviar Keep-alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Host' => 'Anfitrião',
        'Remote host URL for the REST requests.' => '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Controller mapping for Invoker' => '',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '',
        'Default command' => 'Comando por omissão',
        'The default HTTP command to use for the requests.' => '',
        'Authentication' => 'Autenticação',
        'The authentication mechanism to access the remote system.' => '',
        'A "-" value means no authentication.' => '',
        'The user name to be used to access the remote system.' => '',
        'The password for the privileged user.' => '',
        'Use SSL Options' => '',
        'Show or hide SSL options to connect to the remote system.' => '',
        'Certificate File' => 'Certificar ficheiro',
        'The full path and name of the SSL certificate file.' => 'Nome completo (com caminho) do ficheiro com o certificado SSL.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => 'p. ex. /opt/otrs/var/certificates/REST/ssl.crt',
        'Certificate Password File' => 'Certificar ficheiro de palavra-passe',
        'The full path and name of the SSL key file.' => '',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => 'p. ex. /opt/otrs/var/certificates/REST/ssl.key',
        'Certification Authority (CA) File' => 'Ficheiro da Autoridade de Certificação (CA)',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => 'p. ex. /opt/otrs/var/certificates/REST/CA/ca.file',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => '',
        'Endpoint' => '',
        'URI to indicate a specific location for accessing a service.' =>
            '',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'p. ex. http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => '',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Request name scheme' => '',
        'Select how SOAP request function wrapper should be constructed.' =>
            '',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '',
        '\'FreeText\' is used as example for actual configured value.' =>
            '',
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            '',
        'Response name scheme' => '',
        'Select how SOAP response function wrapper should be constructed.' =>
            '',
        'Response name free text' => '',
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
        'Proxy Server' => 'Servidor Proxy',
        'URI of a proxy server to be used (if needed).' => '',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => 'Usuário de Proxy',
        'The user name to be used to access the proxy server.' => '',
        'Proxy Password' => 'Password de Proxy',
        'The password for the proxy user.' => '',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => '',
        'The password to open the SSL certificate.' => 'Palavra-passe para abrir o certificado SSL',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '',
        'Certification Authority (CA) Directory' => '',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '',
        'Sort options' => 'Ordenar opções',
        'Add new first level element' => '',
        'Element' => 'Elemento',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => '',
        'Add web service' => '',
        'Clone web service' => '',
        'The name must be unique.' => '',
        'Clone' => '',
        'Export web service' => '',
        'Import web service' => '',
        'Configuration File' => 'Ficheiro de Configuração',
        'The file must be a valid web service configuration YAML file.' =>
            '',
        'Import' => 'Importar',
        'Configuration history' => '',
        'Delete web service' => '',
        'Do you really want to delete this web service?' => '',
        'Ready-to-run Web Services' => '',
        'Here you can activate ready-to-run web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import ready-to-run web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated ready-to-run web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '',
        'Web Service List' => '',
        'Remote system' => '',
        'Provider transport' => '',
        'Requester transport' => '',
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
        'Delete this action' => 'Eliminar esta ação',
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
        'Restore' => 'Repor',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'AVISO: Ao mudar o nome do grupo \'admin\', antes de efetuar as alterações em  SysConfig, vai perder a sessão de administração! Caso aconteça , renomeie o grupo novamente para admin através de SQL.',
        'Group Management' => 'Gestão de Grupos',
        'Add Group' => 'Adicionar Grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'O grupo admin é para acesso à área de administração e o grupo stats é para acesso à área de estatísticas.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '',
        'It\'s useful for ASP solutions. ' => 'Útil para soluções ASP',
        'total' => 'total',
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
        'Online Admin Manual' => '',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => '',
        'Add notification' => 'Adicionar notificação',
        'Export Notifications' => 'Exportar Notificações',
        'Configuration Import' => 'Importar Configuração',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '',
        'Overwrite existing notifications?' => 'Substituir notificações existentes?',
        'Upload Notification configuration' => 'Carregar configuração de Notificação',
        'Import Notification configuration' => 'Importar configuração de Notificação',
        'Delete this notification' => 'Apagar notificação',
        'Do you really want to delete this notification?' => '',
        'Add Notification' => 'Adicionar notificação',
        'Edit Notification' => 'Editar notificação',
        'Show in agent preferences' => 'Mostrar nas preferências do agente',
        'Agent preferences tooltip' => '',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '',
        'Ticket Filter' => 'Filtro de tickets',
        'Article Filter' => 'Filtro de artigo',
        'Only for ArticleCreate and ArticleSend event' => '',
        'Article type' => 'Tipo de artigo',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Article sender type' => '',
        'Subject match' => 'Igual a assunto',
        'Body match' => 'Igual ao corpo do email',
        'Include attachments to notification' => 'Incluir anexos na notificação',
        'Recipients' => 'Destinatários',
        'Send to' => 'Enviar para',
        'Send to these agents' => 'Enviar para estes agentes',
        'Send to all group members (agents only)' => 'Enviar para todos os membros do grupo (apenas agentes)',
        'Send to all role members' => 'Enviar para todos os membros do papel',
        'Send on out of office' => 'Enviar quando "Fora do Escritório"',
        'Also send if the user is currently out of office.' => 'Enviar também quando o utilizador está "Fora do Escritório"',
        'Once per day' => 'Uma vez por dia',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '',
        'Notification Methods' => 'Métodos de notificação',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '',
        'Enable this notification method' => 'Activar este método de notificação',
        'Transport' => 'Transporte',
        'At least one method is needed per notification.' => 'É necessário pelo menos um método por notificação.',
        'Active by default in agent preferences' => 'Ativo por defeito nas preferências do agente',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            '',
        'This feature is currently not available.' => 'Esta funcionalidade neste momento não está disponível.',
        'No data found' => 'não há resultados',
        'No notification method found.' => 'Nenhum método de notificação encontrado.',
        'Notification Text' => 'Texto da notificação',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            '',
        'Remove Notification Language' => '',
        'Message body' => 'Corpo da mensagem',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Add new notification language' => 'Adicionar nova língua à notificação',
        'Do you really want to delete this notification language?' => '',
        'Tag Reference' => '',
        'Notifications are sent to an agent or a customer.' => 'As notificações são enviadas para um agente ou um cliente.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Para obter os primeiros 20 carateres do assunto (do último artigo do agente)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Para obter as últimas 5 linhas do corpo do email (do último artigo do agente)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Para obter os primeiros 20 carateres do assunto (do último artigo do cliente)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Para obter as últimas 5 linhas do corpo do email (do último artigo do cliente)',
        'Attributes of the current customer user data' => '',
        'Attributes of the current ticket owner user data' => '',
        'Attributes of the current ticket responsible user data' => '',
        'Attributes of the current agent user who requested this action' =>
            '',
        'Attributes of the recipient user for the notification' => '',
        'Attributes of the ticket data' => '',
        'Ticket dynamic fields internal key values' => '',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Example notification' => 'Notificação de exemplo',

        # Template: AdminNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => '',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',
        'Notification article type' => 'Notificação de tipo de artigo',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '',
        'Email template' => 'Template de email',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '',
        'Enable email security' => 'Ativar segurança de email',
        'Email security level' => 'Nível de segurança de email',
        'If signing key/certificate is missing' => '',
        'If encryption key/certificate is missing' => '',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => '',
        'Go to the OTRS customer portal' => '',
        'Downgrade to ((OTRS)) Community Edition' => '',
        'Read documentation' => 'Ler documentação',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '',
        'Unauthorized Usage Detected' => '',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            '',
        '%s not Correctly Installed' => '',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            '',
        'Reinstall %s' => '',
        'Your %s is not correctly installed, and there is also an update available.' =>
            '',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            '',
        'Update %s' => 'Atualizar %s',
        '%s Not Yet Available' => '',
        '%s will be available soon.' => '',
        '%s Update Available' => '',
        'Package installation requires patch level update of OTRS.' => '',
        'Please visit our customer portal and file a request.' => '',
        'Everything else will be done as part of your contract.' => '',
        'Your installed OTRS version is %s.' => '',
        'To install the current version of OTRS Business Solution™, you need to update to OTRS %s or higher.' =>
            '',
        'To install the current version of OTRS Business Solution™, the Maximum OTRS Version is %s.' =>
            '',
        'To install this package, the required Framework version is %s.' =>
            '',
        'Why should I keep OTRS up to date?' => '',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTRS issues' => '',
        'An update for your %s is available! Please update at your earliest!' =>
            '',
        '%s Correctly Deployed' => '',
        'Congratulations, your %s is correctly installed and up to date!' =>
            '',

        # Template: AdminOTRSBusinessNotInstalled
        '%s will be available soon. Please check again in a few days.' =>
            '',
        'Please have a look at %s for more information.' => '',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            '',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            '',
        'To install this package, you need to update to OTRS %s or higher.' =>
            '',
        'To install this package, the Maximum OTRS Version is %s.' => '',
        'With your existing contract you can only use a small part of the %s.' =>
            '',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            '',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => '',
        'Go to OTRS Package Manager' => 'Voltar à página de gestão de pacotes do OTRS',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            '',
        'Vendor' => 'Fabricante',
        'Please uninstall the packages first using the package manager and try again.' =>
            '',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            '',
        'Chat' => '',
        'Report Generator' => '',
        'Timeline view in ticket zoom' => '',
        'DynamicField ContactWithData' => '',
        'DynamicField Database' => '',
        'SLA Selection Dialog' => '',
        'Ticket Attachment View' => '',
        'The %s skin' => '',

        # Template: AdminPGP
        'PGP Management' => 'Gestão de PGP',
        'PGP support is disabled' => '',
        'To be able to use PGP in OTRS, you have to enable it first.' => '',
        'Enable PGP support' => '',
        'Faulty PGP configuration' => '',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Configure it here!' => '',
        'Check PGP configuration' => '',
        'Add PGP key' => 'Adicionar chave PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Desta forma pode editar diretamente o anel de chaves configurado no SysConfig',
        'Introduction to PGP' => 'Introdução ao PGP',
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
        'Go to updating instructions' => '',
        'package information' => '',
        'Package installation requires a patch level update of OTRS.' => '',
        'Package update requires a patch level update of OTRS.' => '',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            '',
        'Please note that your installed OTRS version is %s.' => '',
        'To install this package, you need to update OTRS to version %s or newer.' =>
            '',
        'This package can only be installed on OTRS version %s or older.' =>
            '',
        'This package can only be installed on OTRS version %s or newer.' =>
            '',
        'You will receive updates for all other relevant OTRS issues.' =>
            '',
        'How can I do a patch level update if I don’t have a contract?' =>
            '',
        'Please find all relevant information within the updating instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            '',
        'Continue' => 'Continuar',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'Instalar',
        'Install Package' => 'Instalar pacote',
        'Update repository information' => 'Atualizar informação do repositório',
        'Cloud services are currently disabled.' => '',
        'OTRS Verify™ can not continue!' => '',
        'Enable cloud services' => '',
        'Online Repository' => 'Repositório Online',
        'Module documentation' => 'Documentação do módulo',
        'Upgrade' => 'Upgrade',
        'Local Repository' => 'Repositório Local',
        'This package is verified by OTRSverify (tm)' => '',
        'Uninstall' => 'Desinstalar',
        'Reinstall' => 'Reinstalar',
        'Features for %s customers only' => '',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
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
        'Primary Key' => 'Chave Primária',
        'Auto Increment' => '',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Diferenças entre ficheiros para %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log de desempenho',
        'This feature is enabled!' => 'Esta opção está ativa',
        'Just use this feature if you want to log each request.' => 'Use esta opção apenas se pretender registar cada pedido',
        'Activating this feature might affect your system performance!' =>
            '',
        'Disable it here!' => 'Desativar aqui',
        'Logfile too large!' => 'Ficheiro de log demasiado grande',
        'The logfile is too large, you need to reset it' => 'Ficheiro de log demasiado grande, é necessário limpar',
        'Overview' => 'Visão Geral',
        'Range' => 'Intervalo',
        'last' => 'nos últimos',
        'Interface' => 'Interface',
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
        'Do you really want to delete this filter?' => '',
        'Add PostMaster Filter' => 'Adicionar filtro de correio',
        'Edit PostMaster Filter' => 'Editar filtro de correio',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'Condição do filtro',
        'AND Condition' => '',
        'Check email header' => '',
        'Negate' => '',
        'Look for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'O filtro necessita de ser uma expressão regular válida ou uma palavra.',
        'Set Email Headers' => 'Define os cabeçalhos de email',
        'Set email header' => '',
        'Set value' => '',
        'The field needs to be a literal word.' => 'O campo necessita de ser uma palavra',

        # Template: AdminPriority
        'Priority Management' => 'Gestão de Prioridades',
        'Add priority' => 'Adicionar Prioridade',
        'Add Priority' => 'Adicionar Prioridade',
        'Edit Priority' => 'Editar Prioridade',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => 'Filtrar por Processos',
        'Create New Process' => 'Criar Novo Processo',
        'Deploy All Processes' => 'Implementar todos os Processos',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '',
        'Overwrite existing entities' => 'Substituir entidades existentes',
        'Upload process configuration' => '',
        'Import process configuration' => '',
        'Ready-to-run Processes' => '',
        'Here you can activate ready-to-run processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated ready-to-run processes.' =>
            '',
        'Import ready-to-run process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Processes' => 'Processos',
        'Process name' => 'Nome do Processo',
        'Print' => 'Imprimir',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '',
        'Go Back' => '',
        'Please note, that changing this activity will affect the following processes' =>
            '',
        'Activity' => 'Atividade',
        'Activity Name' => 'Nome de Atividade',
        'Activity Dialogs' => 'Diálogos de Atividade',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '',
        'Filter available Activity Dialogs' => 'Filtrar Diálogos de Atividade disponíveis',
        'Available Activity Dialogs' => 'Diálogos de Atividade disponíveis',
        'Name: %s, EntityID: %s' => '',
        'Create New Activity Dialog' => 'Criar novo Diálogo de Atividade',
        'Assigned Activity Dialogs' => 'Diálogos de Atividade atribuídos',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '',
        'Activity Dialog' => 'Diálogo de Atividade',
        'Activity dialog Name' => 'Nome de Diálogo de Atividade',
        'Available in' => 'Disponível em',
        'Description (short)' => 'Descrição (curta)',
        'Description (long)' => 'Descrição (longa)',
        'The selected permission does not exist.' => '',
        'Required Lock' => '',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => '',
        'Submit Button Text' => '',
        'Fields' => 'Campos',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available fields' => '',
        'Available Fields' => 'Campos Disponíveis',
        'Name: %s' => '',
        'Assigned Fields' => 'Campos Assignados',
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

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Atividades',
        'Filter Activities...' => '',
        'Create New Activity' => 'Criar nova Atividade',
        'Filter Activity Dialogs...' => 'Filtrar Diálogos de Atividade',
        'Transitions' => 'Transições',
        'Filter Transitions...' => 'Filtrar Transições...',
        'Create New Transition' => '',
        'Filter Transition Actions...' => '',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '',
        'Print process information' => 'Imprimir informação do processo',
        'Delete Process' => 'Eliminar Processo',
        'Delete Inactive Process' => '',
        'Available Process Elements' => '',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => 'Editar informação do processo',
        'Process Name' => 'Nome do Processo',
        'The selected state does not exist.' => 'O estado selecionado não existe.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Edit this Activity' => 'Editar esta Atividade',
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
        'cancel & close' => '',
        'Start Activity' => 'Iniciar Atividade',
        'Contains %s dialog(s)' => '',
        'Assigned dialogs' => '',
        'Activities are not being used in this process.' => '',
        'Assigned fields' => '',
        'Activity dialogs are not being used in this process.' => '',
        'Condition linking' => '',
        'Conditions' => 'Condições',
        'Condition' => 'Condição',
        'Transitions are not being used in this process.' => '',
        'Module name' => '',
        'Transition actions are not being used in this process.' => '',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '',
        'Transition' => 'Transição',
        'Transition Name' => '',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => '',
        'Remove this Condition' => 'Remover esta Condição',
        'Type of Linking' => 'Tipo de Ligação',
        'Add a new Field' => 'Adicionar novo Campo',
        'Remove this Field' => 'Remover este Campo',
        'And can\'t be repeated on the same condition.' => 'E não pode ser repetido na mesma condição.',
        'Add New Condition' => 'Adicionar Nova Condição',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '',
        'Transition Action' => '',
        'Transition Action Name' => '',
        'Transition Action Module' => '',
        'Config Parameters' => 'Configurar Parâmetros',
        'Add a new Parameter' => 'Adicionar novo Parâmetro',
        'Remove this Parameter' => '',

        # Template: AdminQueue
        'Manage Queues' => 'Gerir filas',
        'Add queue' => 'Adicionar fila',
        'Add Queue' => 'Adicionar Fila',
        'Edit Queue' => 'Editar fila',
        'A queue with this name already exists!' => '',
        'Sub-queue of' => 'Sub-fila de ',
        'Unlock timeout' => 'Tempo de desbloqueio',
        '0 = no unlock' => '0 = sem desbloqueio',
        'Only business hours are counted.' => 'Apenas são contabilizadas horas de expediente',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Se um ticket for bloqueado e o agente não o fechar antes de terminar o prazo pendente, o ticket fica desbloqueado e disponível para outros agentes.',
        'Notify by' => 'Notificar por',
        '0 = no escalation' => '0 = sem escalagem',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Se não tiver sido adicionado um contacto de cliente, seja de telefone ou email ao ticket, antes do período definido expirar, o ticket é escalado.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Se um novo artigo for adicionado, por email ou via browser, o tempo de escalagem é reiniciado. Caso contrário se o tempo expirar o ticket é escalado.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Se o ticket não for fechado antes do tempo definido, o ticket é escalado',
        'Follow up Option' => 'Opção de atualização',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Especifica se uma atualização reabre o ticket, rejeita a atualização ou abre um novo ticket',
        'Ticket lock after a follow up' => 'Bloqueio do ticket após atualização',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Se o ticket estiver fechado e o cliente enviar uma atualização, o ticket vai ficar bloqueado ao último proprietário',
        'System address' => 'Endereço de sistema',
        'Will be the sender address of this queue for email answers.' => 'Será o endereço de email usado para respostas nesta fila.',
        'Default sign key' => 'Chave de assinatura por omissão',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'The salutation for email answers.' => 'A saudação das respostas de email.',
        'The signature for email answers.' => 'A assinatura das respostas de email.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Gerir as relações Fila - autoresposta',
        'This filter allow you to show queues without auto responses' => '',
        'Queues without auto responses' => '',
        'This filter allow you to show all queues' => '',
        'Show all queues' => '',
        'Filter for Queues' => 'Filtro para filas',
        'Filter for Auto Responses' => 'Filtro para auto respostas',
        'Auto Responses' => 'Respostas Automáticas',
        'Change Auto Response Relations for Queue' => 'Alterar as relações de auto respostas para a fila',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '',
        'Filter for Templates' => '',
        'Templates' => '',
        'Change Queue Relations for Template' => '',
        'Change Template Relations for Queue' => '',

        # Template: AdminRegistration
        'System Registration Management' => '',
        'Edit details' => '',
        'Show transmitted data' => '',
        'Deregister system' => '',
        'Overview of registered systems' => '',
        'This system is registered with OTRS Group.' => '',
        'System type' => '',
        'Unique ID' => '',
        'Last communication with registration server' => '',
        'System registration not possible' => '',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            '',
        'Instructions' => '',
        'System deregistration not possible' => '',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            '',
        'OTRS-ID Login' => '',
        'Read more' => '',
        'You need to log in with your OTRS-ID to register your system.' =>
            '',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            '',
        'Data Protection' => '',
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
        'Please visit our' => '',
        'portal' => '',
        'and file a request.' => '',
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            '',
        'OTRS-ID' => '',
        'You don\'t have an OTRS-ID yet?' => '',
        'Sign up now' => 'Registar-se agora',
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
        'You can modify registration settings here.' => '',
        'Overview of transmitted data' => '',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => '',
        'Support Data' => '',

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
        'Permissions to create tickets in this group/queue.' => 'Permissões para criar tickets neste grupo/fila',
        'note' => 'nota',
        'Permissions to add notes to tickets in this group/queue.' => 'Permissões para adicionar notas a tickets neste grupo/fila',
        'owner' => 'proprietário',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permissões para alterar o proprietário do ticket neste grupo/fila',
        'priority' => 'prioridade',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permissões para modificar a prioridade do ticket neste grupo/fila',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Gerir relações Agente-Papel',
        'Add agent' => 'Adicionar agente',
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
        'SMIME support is disabled' => '',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            '',
        'Enable SMIME support' => '',
        'Faulty SMIME configuration' => '',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => '',
        'Add certificate' => 'Adicionar certificado',
        'Add private key' => 'Adicionar chave privada',
        'Filter for certificates' => '',
        'Filter for S/MIME certs' => '',
        'To show certificate details click on a certificate icon.' => '',
        'To manage private certificate relations click on a private key icon.' =>
            '',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Ver também',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Aqui pode editar directamente os certificados e chaves privadas presentes no sistema de ficheiros.',
        'Hash' => 'Hash',
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
        'Close dialog' => '',
        'Certificate details' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Gestão de Saudações',
        'Add salutation' => 'Adicionar saudação',
        'Add Salutation' => 'Adicionar Saudação',
        'Edit Salutation' => 'Editar saudação',
        'e. g.' => 'ex. ',
        'Example salutation' => 'Exemplo de saudação',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'O modo seguro necessita de estar ativo',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'O modo seguro vai estar ativo após a instalação inicial estar completa',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '',

        # Template: AdminSelectBox
        'SQL Box' => 'Comandos SQL',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Pode introduzir comandos SQL para executar diretamente na base de dados',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'A sintaxe do comando SQL contém erros. Corrija por favor',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Há pelo menos um parametro em falta. Corrija por favor',
        'Result format' => 'Formato do resultado',
        'Run Query' => 'Executar query',
        'Query is executed.' => 'A query foi executada',

        # Template: AdminService
        'Service Management' => 'Gestão de serviço',
        'Add service' => 'Adicionar serviço',
        'Add Service' => 'Adicionar Serviço',
        'Edit Service' => 'Editar serviço',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
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
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => '',
        'Enable Cloud Services' => '',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => '',
        'Sending Update...' => '',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => '',
        'Update Result' => 'Atualizar resultado',
        'Currently this data is only shown in this system.' => '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '',
        'Generating...' => '',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => '',
        'Support Bundle' => '',
        'The mail could not be sent' => '',
        'The support bundle has been generated.' => '',
        'Please choose one of the following options.' => '',
        'Send by Email' => '',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '',
        'The email address for this user is invalid, this option has been disabled.' =>
            '',
        'Sending' => 'Remetente',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            '',
        'Download File' => '',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => '',
        'Details' => '',

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
        'Edit Config Settings in %s → %s' => '',
        'This setting is read only.' => '',
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
        'Delete this entry' => 'Apagar esta entrada',
        'Create new entry' => 'Criar nova entrada',
        'New group' => 'Novo grupo',
        'Group ro' => 'Grupo RO',
        'Readonly group' => 'Grupo de leitura',
        'New group ro' => 'Novo grupo ro',
        'Loader' => '',
        'File to load for this frontend module' => 'Ficheiro a carregar para o módulo de frontend',
        'New Loader File' => 'Novo ficheiro de inicialização',
        'NavBarName' => '',
        'NavBar' => 'Tecla de acesso',
        'LinkOption' => 'Ligar',
        'Block' => 'Bloquear',
        'AccessKey' => 'Tecla de acesso',
        'Add NavBar entry' => 'Adicionar entrada a NavBar',
        'NavBar module' => '',
        'Year' => 'Ano',
        'Month' => 'Mês',
        'Day' => 'Dia',
        'Invalid year' => 'Ano inválido',
        'Invalid month' => 'Mês inválido',
        'Invalid day' => 'Dia inválido',
        'Show more' => '',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Gestão dos Endereços de email do Sistema',
        'Add system address' => 'Adicionar email de sistema',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Todos os emails recebidos para este endereço em To ou CC são enviados para a fila selecionada',
        'Email address' => 'Endereço email',
        'Display name' => 'Nome',
        'Add System Email Address' => 'Adicionar email de sistema',
        'Edit System Email Address' => 'Editar email de sistema',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'O nome e endereço email serão mostrados nas mensagens que enviar',
        'This system address cannot be set to invalid, because it is used in one or more queue(s).' =>
            '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '',
        'Schedule New System Maintenance' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Start date' => 'Data de início',
        'Stop date' => '',
        'Delete System Maintenance' => '',
        'Do you really want to delete this scheduled system maintenance?' =>
            '',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => '',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'Data inválida',
        'Login message' => '',
        'This field must have less then 250 characters.' => '',
        'Show login message' => '',
        'Notify message' => '',
        'Manage Sessions' => '',
        'All Sessions' => '',
        'Agent Sessions' => '',
        'Customer Sessions' => '',
        'Kill all Sessions, except for your own' => '',

        # Template: AdminTemplate
        'Manage Templates' => '',
        'Add template' => '',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '',
        'Don\'t forget to add new templates to queues.' => '',
        'Do you really want to delete this template?' => 'Deseja apagar este modelo?',
        'Add Template' => '',
        'Edit Template' => '',
        'A standard template with this name already exists!' => '',
        'Create type templates only supports this smart tags' => '',
        'Example template' => '',
        'The current ticket state is' => 'O estado atual do ticket é',
        'Your email address is' => 'O seu email é',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => '',
        'Filter for Attachments' => 'Filtro para anexos',
        'Change Template Relations for Attachment' => '',
        'Change Attachment Relations for Template' => '',
        'Toggle active for all' => 'Ativar para todos',
        'Link %s to selected %s' => 'Ligar %s a item selecionado %s',

        # Template: AdminType
        'Type Management' => 'Gestão de tipos',
        'Add ticket type' => 'Adicionar tipo de ticket',
        'Add Type' => 'Adicionar tipo',
        'Edit Type' => 'Editar tipo',
        'A type with this name already exists!' => '',

        # Template: AdminUser
        'Agents will be needed to handle tickets.' => 'São necessários agentes para tratar os tickets',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Não esquecer de adicionar um novo agente aos gruupos/papéis',
        'Please enter a search term to look for agents.' => 'Introduza um termo para pesquisar agentes ',
        'Last login' => 'Último acesso',
        'Switch to agent' => 'Alterar para agente',
        'Add Agent' => 'Adicionar agente',
        'Edit Agent' => 'Editar agente',
        'Title or salutation' => '',
        'Firstname' => 'Nome',
        'Lastname' => 'Apelido',
        'A user with this username already exists!' => '',
        'Will be auto-generated if left empty.' => '',
        'Start' => 'Início',
        'End' => 'Fim',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gerir relações Agente-grupo',
        'Add group' => 'Adicionar grupo',
        'Change Group Relations for Agent' => 'Gerir relações de grupo com o agente',
        'Change Agent Relations for Group' => 'Gerir relações de agente com o grupo',

        # Template: AgentBook
        'Address Book' => 'Lista de Endereços',
        'Search for a customer' => 'Pesquisar cliente',
        'Add email address %s to the To field' => 'Adicionar o email %s ao campo TO',
        'Add email address %s to the Cc field' => 'Adicionar o email %s ao campo CC',
        'Add email address %s to the Bcc field' => 'Adicionar o email %s ao campo BCC',
        'Apply' => 'Aplicar',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Centro de Informação de Cliente',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => '',

        # Template: AgentCustomerSearch
        'Duplicated entry' => '',
        'This address already exists on the address list.' => '',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Nota: Cliente está inválido!',
        'Start chat' => '',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            '',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            '',
        'Starting the OTRS Daemon' => '',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            '',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            '',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            '',

        # Template: AgentDashboard
        'Dashboard' => 'Painel de Controlo',

        # Template: AgentDashboardCalendarOverview
        'in' => 'em',

        # Template: AgentDashboardCommon
        'Save settings' => 'Guardar definições',
        'Close this widget' => 'Fechar',
        'Available Columns' => 'Colunas disponíveis',
        'Visible Columns (order by drag & drop)' => 'Colunas visíveis (arrastar e largar para ordenar)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer login' => 'Login de cliente',
        'Customer information' => 'Informação de cliente',
        'Phone ticket' => 'Ticket por telefone',
        'Email ticket' => 'Ticket por email',
        '%s open ticket(s) of %s' => '%s ticket(s) aberto(s) de %s',
        '%s closed ticket(s) of %s' => '%s ticket(s) fechado(s) de %s',
        'New phone ticket from %s' => 'Novo ticket via telefone de %s',
        'New email ticket to %s' => 'Novo ticket via email de %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s está disponível!',
        'Please update now.' => 'Por favor atualize o sistema',
        'Release Note' => 'Notas de versão',
        'Level' => 'Nível',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Publicado há %s',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'Configuração com erros.',
        'Download as SVG file' => 'Download como ficheiro SVG',
        'Download as PNG file' => 'Download como ficheiro PNG',
        'Download as CSV file' => 'Download como ficheiro CSV',
        'Download as Excel file' => 'Download como ficheiro Excel',
        'Download as PDF file' => 'Download como ficheiro PDF',
        'Grouped' => 'Agrupado',
        'Stacked' => 'Empilhado',
        'Expanded' => 'Expandido',
        'Stream' => '',
        'No Data Available.' => '',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '',
        'The content of this statistic is being prepared for you, please be patient.' =>
            '',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Os meus tickets bloqueados',
        'My watched tickets' => 'Os meus tickets vigiados',
        'My responsibilities' => 'Minhas responsabilidades',
        'Tickets in My Queues' => 'TIckets nas minhas Filas',
        'Tickets in My Services' => 'Tickets nos meus Serviços',
        'Service Time' => 'Tempo de serviço',
        'Remove active filters for this widget.' => 'Remover filtros',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'Totais',

        # Template: AgentDashboardUserOnline
        'out of office' => 'fora do escritório',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'até',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Ticket bloqueado',
        'Undo & close' => 'Anular e fechar',

        # Template: AgentInfo
        'Info' => 'Info',
        'To accept some news, a license or some changes.' => 'Para aceitar novidades, licença ou alterações',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Ligar objeto: %s',
        'go to link delete screen' => 'Ir para ecrã de apagar ligação',
        'Select Target Object' => 'Selecionar o Objeto de destino',
        'Link object %s with' => 'Ligar o objecto %s com',
        'Unlink Object: %s' => 'Quebrar ligação %s',
        'go to link add screen' => 'Ir para a ecrã de adicionar link',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => '',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => 'Editar preferências',
        'Did you know? You can help translating OTRS at %s.' => '',

        # Template: AgentSpelling
        'Spell Checker' => 'Corretor Ortográfico',
        'spelling error(s)' => 'erro(s) ortográfico(s)',
        'Apply these changes' => 'Aplicar modificações',

        # Template: AgentStatisticsAdd
        'Statistics » Add' => '',
        'Add New Statistic' => '',
        'Dynamic Matrix' => '',
        'Tabular reporting data where each cell contains a singular data point (e. g. the number of tickets).' =>
            '',
        'Dynamic List' => '',
        'Tabular reporting data where each row contains data of one entity (e. g. a ticket).' =>
            '',
        'Static' => '',
        'Complex statistics that cannot be configured and may return non-tabular data.' =>
            '',
        'General Specification' => '',
        'Create Statistic' => '',

        # Template: AgentStatisticsEdit
        'Statistics » Edit %s%s — %s' => '',
        'Run now' => '',
        'Statistics Preview' => '',
        'Save statistic' => '',

        # Template: AgentStatisticsImport
        'Statistics » Import' => '',
        'Import Statistic Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics » Overview' => '',
        'Statistics' => '',
        'Run' => '',
        'Edit statistic "%s".' => '',
        'Export statistic "%s"' => '',
        'Export statistic %s' => '',
        'Delete statistic "%s"' => '',
        'Delete statistic %s' => '',
        'Do you really want to delete this statistic?' => '',

        # Template: AgentStatisticsView
        'Statistics » View %s%s — %s' => '',
        'Statistic Information' => '',
        'Sum rows' => 'Mostrar linhas',
        'Sum columns' => 'Mostrar colunas',
        'Show as dashboard widget' => '',
        'Cache' => '',
        'This statistic contains configuration errors and can currently not be used.' =>
            '',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '',
        'Change Owner of %s%s%s' => 'Modificar o proprietário de %s%s%s',
        'Close %s%s%s' => 'Fechar %s%s%s',
        'Add Note to %s%s%s' => 'Adicionar nota a %s%s%s',
        'Set Pending Time for %s%s%s' => '',
        'Change Priority of %s%s%s' => 'Modificar prioridade de %s%s%s',
        'Change Responsible of %s%s%s' => 'Modificar responsável de %s%s%s',
        'All fields marked with an asterisk (*) are mandatory.' => 'Os campos marcados com * são obrigatórios',
        'Service invalid.' => 'Serviço inválido',
        'New Owner' => 'Novo Proprietário',
        'Please set a new owner!' => 'Por favor, defina o novo proprietário',
        'New Responsible' => 'Novo responsável',
        'Next state' => 'Próximo estado',
        'For all pending* states.' => '',
        'Add Article' => 'Adicionar artigo',
        'Create an Article' => 'Criar um artigo',
        'Inform agents' => '',
        'Inform involved agents' => '',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '',
        'Text will also be received by' => '',
        'Spell check' => 'Corretor ortográfico',
        'Text Template' => 'Modelo',
        'Setting a template will overwrite any text or attachment.' => 'A seleção de um modelo elimina o texto e anexo(s) existentes',
        'Note type' => 'Tipo de nota',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '',
        'Bounce to' => 'Devolver para',
        'You need a email address.' => 'Necessita de um endereço de email',
        'Need a valid email address or don\'t use a local email address.' =>
            'Necessita de um endereço de email válido, não utilize endereços de email locais',
        'Next ticket state' => 'Próximo estado do ticket',
        'Inform sender' => 'Informar o remetente',
        'Send mail' => 'Enviar mensagem de email !',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ação em bloco sobre tickets',
        'Send Email' => 'Enviar mensagem de email !',
        'Merge to' => 'Ligar a',
        'Invalid ticket identifier!' => 'Identificador de ticket inválido',
        'Merge to oldest' => 'Fundir com o mais antigo',
        'Link together' => 'Ligar tickets',
        'Link to parent' => 'Ligar ao pai',
        'Unlock tickets' => 'Desbloquear ticket',
        'Execute Bulk Action' => 'Executar ação em lote',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Escrever resposta para %s%s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'Este é um endereço de sistema e não pode ser utilizado: %s',
        'Please include at least one recipient' => 'Necessita de incluir pelo menos um destinatário',
        'Remove Ticket Customer' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Remove Cc' => 'Remover CC',
        'Remove Bcc' => 'Remover BCC',
        'Address book' => 'Lista de endereços',
        'Date Invalid!' => 'Data inválida',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Modificar cliente de %s%s%s',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Criar novo ticket',
        'Example Template' => '',
        'From queue' => 'Da fila',
        'To customer user' => 'Para o utilizador do cliente',
        'Please include at least one customer user for the ticket.' => '',
        'Select this customer as the main customer.' => '',
        'Remove Ticket Customer User' => '',
        'Get all' => 'Obter todos',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Ticket %s: A primeira resposta está atrasada (%s/%s)',
        'Ticket %s: first response time will be over in %s/%s!' => 'Ticket %s: A primeira resposta estará atrasada em %s/%s',
        'Ticket %s: update time is over (%s/%s)!' => 'Ticket %s: Atualização atrasada (%s/%s)',
        'Ticket %s: update time will be over in %s/%s!' => 'Ticket %s: A atualização estará atrasada em %s/%s',
        'Ticket %s: solution time is over (%s/%s)!' => 'Ticket %s: Resolução atrasada (%s/%s)',
        'Ticket %s: solution time will be over in %s/%s!' => 'Ticket %s: A resolução estará atrasada em %s/%s',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Encaminhar %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'Histórico de %s%s%s',
        'History Content' => 'Histórico do conteúdo',
        'Zoom view' => 'Vista de detalhe',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Fundir %s%s%s',
        'Merge Settings' => 'Definições de fusão',
        'You need to use a ticket number!' => 'Necessita de um número de ticket!',
        'A valid ticket number is required.' => 'é necessário um número de ticket válido',
        'Need a valid email address.' => 'Necessita de um email válido',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Mover %s%s%s',
        'New Queue' => 'Nova Fila',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Selecionar tudo',
        'No ticket data found.' => 'Não foram encontrados dados do ticket',
        'Open / Close ticket action menu' => '',
        'Select this ticket' => 'Selecionar este ticket',
        'First Response Time' => 'Tempo da primeira resposta',
        'Update Time' => 'Tempo de actualização',
        'Solution Time' => 'Tempo de solução',
        'Move ticket to a different queue' => 'Mover ticket para uma fila diferente',
        'Change queue' => 'Modificar a fila',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Alterar opções de pesquisa',
        'Remove active filters for this screen.' => 'Remover filtros',
        'Tickets per page' => 'Tickets por página',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Repor',
        'Column Filters Form' => 'Filtros de coluna',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Dividir para novo ticket telefónico',
        'Save Chat Into New Phone Ticket' => 'Gravar conversa para novo ticket telefónico',
        'Create New Phone Ticket' => 'Criar novo ticket por telefone',
        'Please include at least one customer for the ticket.' => 'Deve incluir pelo menos um cliente',
        'To queue' => 'Para a fila',
        'Chat protocol' => 'Protocolo de chat',
        'The chat will be appended as a separate article.' => 'A conversa será anexada como artigo separado',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Chamada telefónica para %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '',
        'Plain' => 'texto simples',
        'Download this email' => 'Descarregar este email',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Criar novo ticket de processo',
        'Process' => '',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '',

        # Template: AgentTicketSearch
        'Search template' => 'Modelo de pesquisa',
        'Create Template' => 'Criar template',
        'Create New' => 'Criar novo',
        'Profile link' => '',
        'Save changes in template' => 'Guardar alterações ao template',
        'Filters in use' => 'Filtros em uso',
        'Additional filters' => 'Filtros adicionais',
        'Add another attribute' => 'Adicionar outro atributo',
        'Output' => 'Formato do resultado',
        'Fulltext' => 'Texto integral',
        'Remove' => 'Apagar',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'Pesquisa nos campos De, Para, CC, Assunto e no texto dos artigos.',
        'CustomerID (complex search)' => '',
        '(e. g. 234*)' => '',
        'CustomerID (exact match)' => '',
        'Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Customer User Login (exact match)' => '',
        'Attachment Name' => 'Nome do anexo',
        '(e. g. m*file or myfi*)' => '(p.ex. m*file or myfi*)',
        'Created in Queue' => 'Criado na Fila',
        'Lock state' => 'Estado de bloqueio',
        'Watcher' => 'Observador',
        'Article Create Time (before/after)' => 'Data criação do artigo (antes/depois)',
        'Article Create Time (between)' => 'Data criação artigo (entre)',
        'Invalid date' => '',
        'Ticket Create Time (before/after)' => 'Data criação do ticket (antes/depois)',
        'Ticket Create Time (between)' => 'Data criação do ticket (entre)',
        'Ticket Change Time (before/after)' => 'Data alteração do ticket (antes/depois)',
        'Ticket Change Time (between)' => 'Data alteração do ticket (entre)',
        'Ticket Last Change Time (before/after)' => 'Última modificação no ticket (antes/depois)',
        'Ticket Last Change Time (between)' => 'Última modificação no ticket (entre)',
        'Ticket Close Time (before/after)' => 'Data fecho do ticket (antes/depois)',
        'Ticket Close Time (between)' => 'Data alteração do ticket (entre)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Arquivar pesquisa',
        'Run search' => 'Executar pesquisa',

        # Template: AgentTicketZoom
        'Article filter' => 'Filtro de artigos',
        'Article Type' => 'Tipo de artigo',
        'Sender Type' => 'Tipo de remetente',
        'Save filter settings as default' => 'Guardar definições do filtro como padrão',
        'Event Type Filter' => '',
        'Event Type' => '',
        'Save as default' => '',
        'Archive' => 'Arquivar',
        'This ticket is archived.' => 'Este ticket está arquivado.',
        'Note: Type is invalid!' => 'Nota: Tipo inválido!',
        'Locked' => 'Bloqueado',
        'Accounted time' => 'Tempo contabilizado',
        'Linked Objects' => 'Objetos ligados',
        'Change Queue' => 'Mudar fila',
        'There are no dialogs available at this point in the process.' =>
            'Não existem mais diálogos disponíveis no processo.',
        'This item has no articles yet.' => 'Este item ainda não tem artigos.',
        'Ticket Timeline View' => '',
        'Article Overview' => '',
        'Article(s)' => 'Artigo(s)',
        'Page' => 'Página',
        'Add Filter' => 'Adicionar filtro',
        'Set' => 'Definir',
        'Reset Filter' => 'Reiniciar filtro',
        'Show one article' => 'Mostrar um artigo',
        'Show all articles' => 'Mostrar todos os artigos',
        'Show Ticket Timeline View' => '',
        'Unread articles' => 'Artigos por ler',
        'No.' => 'Nr.',
        'Important' => 'Importante',
        'Unread Article!' => 'Artigo não lido!',
        'Incoming message' => 'Mensagem de entrada',
        'Outgoing message' => 'Mensagem de saída',
        'Internal message' => 'Mensagem interna',
        'Resize' => 'Redimensionar',
        'Mark this article as read' => '',
        'Show Full Text' => 'Mostrar texto completo',
        'Full Article Text' => 'Texto completo do artigo',
        'No more events found. Please try changing the filter settings.' =>
            '',
        'by' => 'por',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Para abrir as ligações abaixo poderá necessitar de premir a tecla CTRL (ou CMD) ou Shift (dependendo do browser e do sistema operativo) quando clicar sobre a ligação',
        'Close this message' => 'Fechar esta mensagem',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'Carregar conteúdo bloqueado',

        # Template: ChatStartForm
        'First message' => '',

        # Template: CloudServicesDisabled
        'This feature requires cloud services.' => '',
        'You can' => 'Pode ',
        'go back to the previous page' => 'Voltar à página anterior',

        # Template: CustomerAccept
        'Information' => 'Informação',
        'Dear Customer,' => '',
        'thank you for using our services.' => '',
        'Yes, I accepted your license.' => '',

        # Template: CustomerError
        'An Error Occurred' => '',
        'Error Details' => 'Detalhes do erro',
        'Traceback' => 'Retroceder',

        # Template: CustomerFooter
        'Powered by' => 'Produzido por',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'Ocorreu um ou mais erros',
        'Close this dialog' => 'Fechar esta janela',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Não foi possível abrir uma nova janela. Desabilite programas que bloqueiam popups para esta aplicação',
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Se abandonar esta página, todas as janelas popup abertas serão fechadas',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Já existe uma janela popup aberta. Deseja fecha-la e abrir uma nova ?',
        'There are currently no elements available to select from.' => '',
        'Please turn off Compatibility Mode in Internet Explorer!' => '',
        'The browser you are using is too old.' => 'O browser que está a usar está muito desatualizado',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'O OTRS corre numa lista de browsers grande, por favor atualize para um deles.',
        'Please see the documentation or ask your admin for further information.' =>
            'Consulte a informação por favor ou peça mais informação ao administrador de sistema',
        'Switch to mobile mode' => '',
        'Switch to desktop mode' => '',
        'Not available' => '',
        'Clear all' => '',
        'Clear search' => '',
        '%s selection(s)...' => '',
        'and %s more...' => '',
        'Filters' => '',
        'Confirm' => '',
        'You have unanswered chat requests' => '',
        'Accept' => '',
        'Decline' => '',
        'An internal error occurred.' => '',
        'Connection error' => '',
        'Reload page' => '',
        'Your browser was not able to communicate with OTRS properly, there seems to be something wrong with your network connection. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            'O browser não conseguiu estabelecer comunicação. Parece existir um problema com a rede de dados. Pode recarregar a página ou aguardar que o browser estabeleça a comunicação',
        'There was an error in communication with the server. Server might be experiencing some temporary problems, please reload this page to check if they have been resolved.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'Javascript não disponível',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Para utilizar o OTRS, necessita de ativar javascript no browser',
        'Browser Warning' => 'Aviso de browser',
        'One moment please, you are being redirected...' => 'Um momento por favor. Está a ser redireccionado...',
        'Login' => 'Autenticação',
        'User name' => 'Cód. utilizador',
        'Your user name' => 'O seu cód. utilizador',
        'Your password' => 'A sua password',
        'Forgot password?' => 'Esqueceu a password?',
        '2 Factor Token' => '',
        'Your 2 Factor Token' => '',
        'Log In' => 'Login',
        'Not yet registered?' => 'Ainda não está registado(a)?',
        'Request new password' => 'Solicitar nova palavra-passe',
        'Your User Name' => 'O seu cód. utilizador',
        'A new password will be sent to your email address.' => 'A nova password será enviada para o seu email.',
        'Create Account' => 'Criar conta',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => 'Como deseja ser tratado',
        'Your First Name' => 'O seu nome',
        'Your Last Name' => 'O seu apelido',
        'Your email address (this will become your username)' => '',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => 'Pedidos de chat',
        'Edit personal preferences' => 'Preferências pessoais',
        'Logout %s %s' => 'Terminar sessão como %s %s',

        # Template: CustomerRichTextEditor
        'Split Quote' => 'Dividir citação',
        'Open link' => 'Abrir a ligação',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'SLA',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Bem vindo!',
        'Please click the button below to create your first ticket.' => 'Clique no botão abaixo para criar o seu primeiro ticket',
        'Create your first ticket' => 'Criar o seu primeiro ticket',

        # Template: CustomerTicketSearch
        'Profile' => 'Perfil',
        'e. g. 10*5155 or 105658*' => 'ex. 20170102450052911 ou 201701*',
        'Customer ID' => 'No. Cliente',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Pesquisa no texto integral do ticket (ex. "John*n" ou "Will*")',
        'Recipient' => 'Destinatário',
        'Carbon Copy' => 'CC',
        'e. g. m*file or myfi*' => '',
        'Types' => 'Tipos',
        'Time restrictions' => 'Restrição horária',
        'No time settings' => '',
        'Specific date' => 'Data específica',
        'Only tickets created' => 'Apenas tickets criados',
        'Date range' => 'Intervalo de datas',
        'Only tickets created between' => 'Apenas tickets criados entre',
        'Ticket archive system' => 'Sistema de arquivo de tickets',
        'Save search as template?' => 'Gravar a pesquisa como Modelo de Pesquisa?',
        'Save as Template?' => 'Guardar como modelo?',
        'Save as Template' => 'Guardar como modelo',
        'Template Name' => 'Nome do modelo',
        'Pick a profile name' => 'Seleccione o perfil',
        'Output to' => 'Tipo de resultado',

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Search Results for' => 'Pesquisar resultados para',
        'Remove this Search Term.' => 'Remover o termo de pesquisa',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'Iniciar Conversa a partir deste ticket',
        'Expand article' => 'Expandir artigo',
        'Next Steps' => 'Próximos passos',
        'Reply' => 'Responder',
        'Chat Protocol' => 'Protocolo de conversa',

        # Template: DashboardEventsTicketCalendar
        'All-day' => 'Todo o dia',
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
        'Event Information' => '',
        'Ticket fields' => 'Campos do ticket',
        'Dynamic fields' => 'Campos dinâmicos',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Data inválida (escolha uma data futura)!',
        'Invalid date (need a past date)!' => 'Data inválida (escolha uma data passada)!',
        'Previous' => 'Anterior',
        'Open date selection' => 'Data aberta',

        # Template: Error
        'An error occurred.' => 'Ocorreu um erro.',
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            '',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '',
        'Contact our service team now.' => '',
        'Send a bugreport' => 'Enviar um relatório de erro',

        # Template: FooterJS
        'Please enter at least one search value or * to find anything.' =>
            '',
        'Please remove the following words from your search as they cannot be searched for:' =>
            '',
        'Please check the fields marked as red for valid inputs.' => '',
        'Please perform a spell check on the the text first.' => '',
        'Slide the navigation bar' => '',
        'Unavailable for chat' => 'Indisponível para conversa',
        'Available for internal chats only' => '',
        'Available for chats' => '',
        'Please visit the chat manager' => '',
        'New personal chat request' => '',
        'New customer chat request' => '',
        'New public chat request' => '',
        'Selected user is not available for chat.' => '',
        'New activity' => '',
        'New activity on one of your monitored chats.' => '',
        'Your browser does not support video and audio calling.' => '',
        'Selected user is not available for video and audio call.' => '',
        'Target user\'s browser does not support video and audio calling.' =>
            '',
        'Do you really want to continue?' => '',
        'Information about the OTRS Daemon' => '',
        'Communication error' => '',
        'This feature is part of the %s.  Please contact us at %s for an upgrade.' =>
            '',
        'Find out more about the %s' => '',

        # Template: Header
        'You are logged in as' => 'Autenticado como ',

        # Template: Installer
        'JavaScript not available' => 'Javascript não disponível',
        'Step %s' => 'Passo %s',
        'Database Settings' => 'Definições de base de dados',
        'General Specifications and Mail Settings' => 'Especificações comuns e definições de email',
        'Finish' => 'Fim',
        'Welcome to %s' => '',
        'Germany' => '',
        'United States' => '',
        'Mexico' => '',
        'Hungary' => '',
        'Brazil' => '',
        'Singapore' => '',
        'Hong Kong' => '',
        'Web site' => 'Site',
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
        'Does your SMTP host need authentication?' => 'O servidor SMTP requer autenticação?',
        'SMTP auth user' => 'Utilizador SMTP',
        'Username for SMTP auth.' => 'Utilizador para autenticação SMTP',
        'SMTP auth password' => 'Password de autenticação SMTP',
        'Password for SMTP auth.' => 'Password de autenticação SMTP',
        'Configure Inbound Mail' => 'Configuração recepção de email',
        'Inbound mail type' => 'Tipo de correio de receção',
        'Select inbound mail type.' => 'Selecione o tipo de correio de receção',
        'Inbound mail host' => 'Servidor de receção de email',
        'Inbound mail host.' => 'Servidor de receção de email',
        'Inbound mail user' => 'Utilizador de email de receção',
        'User for inbound mail.' => 'Utilizador de email de receção',
        'Inbound mail password' => 'Password de email de receção',
        'Password for inbound mail.' => 'Password de email de receção',
        'Result of mail configuration check' => 'Resultado da verificação de recepção de email',
        'Check mail configuration' => 'Verifique a configuração de correio',
        'Skip this step' => 'Saltar esta etapa',

        # Template: InstallerDBResult
        'Database setup successful!' => '',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a new database for OTRS' => '',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'Database name' => '',
        'Check database settings' => 'Verificar definições de base de dados',
        'Result of database check' => 'Resultado da verificação à base de dados',
        'Database check successful.' => 'Verificação de base de dados com sucesso',
        'Database User' => '',
        'New' => 'Novo',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Vai ser criado um novo utilizador de base de dados com permissões limitadas para o OTRS',
        'Repeat Password' => '',
        'Generated password' => '',

        # Template: InstallerDBmysql
        'Passwords do not match' => '',

        # Template: InstallerDBoracle
        'SID' => '',
        'Port' => '',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Para usar o OTRS tem de executar o seguinte comando na consola, (Terminal/Shell) como root.',
        'Restart your webserver' => 'Reinicie o servidor Web',
        'After doing so your OTRS is up and running.' => 'Depois de o fazer, o OTRS estará funcional.',
        'Start page' => 'Página inicial',
        'Your OTRS Team' => 'A equipa OTRS',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Nao aceitar licença',
        'Accept license and continue' => '',

        # Template: InstallerSystem
        'SystemID' => 'ID do sistema',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Identificador do sistema. Todos os tickets e sessões HTTP possuem este número',
        'System FQDN' => 'FQDN do sistema',
        'Fully qualified domain name of your system.' => 'FQDN do sistema',
        'AdminEmail' => 'Email do Administrador',
        'Email address of the system administrator.' => 'Email do administrador de sistema',
        'Organization' => 'Organização',
        'Log' => 'Log',
        'LogModule' => 'Módulo de Log',
        'Log backend to use.' => 'Backend de log a utilizar.',
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

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => '',
        'Close preview' => '',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '',

        # Template: MobileNotAvailableWidget
        'Feature not available' => '',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '',

        # Template: Motd
        'Message of the Day' => 'Mensagem do dia',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => 'Permissões insuficientes',
        'Back to the previous page' => 'Voltar à página anterior',

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

        # Template: PreferencesNotificationEvent
        'Notification' => 'Notificações',
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Receber mensagens por notificação \'%s\' pelo método de transporte \'%s\'. ',
        'Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            '',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '',

        # Template: ActivityDialogHeader
        'Process Information' => 'Informação do Processo',
        'Dialog' => 'Diálogo',

        # Template: Article
        'Inform Agent' => 'Informar agente',

        # Template: PublicDefault
        'Welcome' => '',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: RichTextEditor
        'Remove Quote' => '',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Permissões',
        'You can select one or more groups to define access for different agents.' =>
            'Pode selecionar um ou mais grupos para definir o acesso a diferentes agentes',
        'Result formats' => '',
        'The selected time periods in the statistic are time zone neutral.' =>
            '',
        'Create summation row' => '',
        'Generate an additional row containing sums for all data rows.' =>
            '',
        'Create summation column' => '',
        'Generate an additional column containing sums for all data columns.' =>
            '',
        'Cache results' => '',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'If set to invalid end users can not generate the stat.' => 'Se for colocada como inválida, os utilizadores não pode poderão gerar estatísticas',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '',
        'You may now configure the X-axis of your statistic.' => '',
        'This statistic does not provide preview data.' => '',
        'Preview format:' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '',
        'Configure X-Axis' => '',
        'X-axis' => 'Eixo X',
        'Configure Y-Axis' => '',
        'Y-axis' => '',
        'Configure Filter' => '',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Selecione apenas um elemento ou desligue a opção "fixo"',
        'Absolute period' => '',
        'Between' => 'Entre',
        'Relative period' => '',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '',
        'Do not allow changes to this element when the statistic is generated.' =>
            '',

        # Template: StatsParamsWidget
        'Format' => 'Formato',
        'Exchange Axis' => 'Troca de eixos',
        'Configurable params of static stat' => 'Parâmetros configuráveis de estatisticas estatísticas',
        'No element selected.' => 'Sem elemento selecionado',
        'Scale' => 'Escala',
        'show more' => '',
        'show less' => '',

        # Template: D3
        'Download SVG' => '',
        'Download PNG' => '',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            '',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            '',

        # Template: Test
        'OTRS Test Page' => 'Página de Teste do OTRS',
        'Welcome %s %s' => '',
        'Counter' => 'Contador',

        # Template: Warning
        'Go back to the previous page' => 'Voltar à página anterior',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '',
        'View system log messages.' => '',
        'Update and extend your system with software packages.' => '',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '',
        'The following ACLs have been added successfully: %s' => '',
        'The following ACLs have been updated successfully: %s' => '',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '',
        'This field is required' => 'Este campo é obrigatório',
        'There was an error creating the ACL' => '',
        'Need ACLID!' => '',
        'Could not get data for ACLID %s' => '',
        'There was an error updating the ACL' => '',
        'There was an error setting the entity sync status.' => '',
        'There was an error synchronizing the ACLs.' => '',
        'ACL %s could not be deleted' => '',
        'There was an error getting data for ACL with ID %s' => '',
        'Exact match' => '',
        'Negated exact match' => '',
        'Regular expression' => '',
        'Regular expression (ignore case)' => '',
        'Negated regular expression' => '',
        'Negated regular expression (ignore case)' => '',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer Company %s already exists!' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'New phone ticket' => 'Novo registo telefónico',
        'New email ticket' => 'Novo registo por email',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => '',
        'Objects configuration is not valid' => '',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => '',
        'Need %s' => '',
        'The field does not contain only ASCII letters and numbers.' => '',
        'There is another field with the same name.' => '',
        'The field must be numeric.' => '',
        'Need ValidID' => '',
        'Could not create the new field' => '',
        'Need ID' => '',
        'Could not get data for dynamic field %s' => '',
        'The name for this field should not change.' => '',
        'Could not update the field %s' => '',
        'Currently' => '',
        'Unchecked' => '',
        'Checked' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => '',
        'Prevent entry of dates in the past' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => '',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'archive tickets' => 'arquivar tickets',
        'restore tickets from archive' => 'restaurar tickets do arquivo',
        'Need Profile!' => '',
        'Got no values to check.' => '',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => '',
        'Could not get data for WebserviceID %s' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Need InvokerType' => '',
        'Invoker %s is not registered' => '',
        'InvokerType %s is not registered' => '',
        'Need Invoker' => '',
        'Could not determine config for invoker %s' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Could not get registered configuration for action type %s' => '',
        'Could not get backend for %s %s' => '',
        'Could not update configuration data for WebserviceID %s' => '',
        'Keep (leave unchanged)' => '',
        'Ignore (drop key/value pair)' => '',
        'Map to (use provided value as default)' => '',
        'Exact value(s)' => '',
        'Ignore (drop Value/value pair)' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'Could not find required library %s' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Need OperationType' => '',
        'Operation %s is not registered' => '',
        'OperationType %s is not registered' => '',
        'Need Operation' => '',
        'Could not determine config for operation %s' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need Subaction!' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => '',
        'There was an error updating the web service.' => '',
        'Web service "%s" updated!' => '',
        'There was an error creating the web service.' => '',
        'Web service "%s" created!' => '',
        'Need Name!' => '',
        'Need ExampleWebService!' => '',
        'Could not read %s!' => '',
        'Need a file to import!' => '',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            '',
        'Web service "%s" deleted!' => '',
        'New Web service' => '',
        'Operations' => 'Operações',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Notification updated!' => '',
        'Notification added!' => '',
        'There was an error getting data for Notification with ID:%s!' =>
            '',
        'Unknown Notification %s!' => '',
        'There was an error creating the Notification' => '',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '',
        'The following Notifications have been added successfully: %s' =>
            '',
        'The following Notifications have been updated successfully: %s' =>
            '',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '',
        'Agent who owns the ticket' => 'Agente proprietário',
        'Agent who is responsible for the ticket' => 'Agente responsável',
        'All agents watching the ticket' => 'Agentes a vigiar o ticket',
        'All agents with write permission for the ticket' => '',
        'All agents subscribed to the ticket\'s queue' => '',
        'All agents subscribed to the ticket\'s service' => '',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '',
        'Customer of the ticket' => '',
        'Yes, but require at least one active notification method.' => '',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            '',
        'Need param Key to delete!' => '',
        'Key %s deleted!' => '',
        'Need param Key to download!' => '',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            '',
        'No such package!' => '',
        'No such file %s in package!' => '',
        'No such file %s in local file system!' => '',
        'Can\'t read %s!' => '',
        'File is OK' => '',
        'Package has locally modified files.' => '',
        'No packages or no new packages found in selected repository.' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            '',
        'Can\'t connect to OTRS Feature Add-on list server!' => '',
        'Can\'t get OTRS Feature Add-on list from server!' => '',
        'Can\'t get OTRS Feature Add-on from server!' => '',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Need ExampleProcesses!' => '',
        'Need ProcessID!' => '',
        'Yes (mandatory)' => '',
        'Unknown Process %s!' => '',
        'There was an error generating a new EntityID for this Process' =>
            '',
        'The StateEntityID for state Inactive does not exists' => '',
        'There was an error creating the Process' => '',
        'There was an error setting the entity sync status for Process entity: %s' =>
            '',
        'Could not get data for ProcessID %s' => '',
        'There was an error updating the Process' => '',
        'Process: %s could not be deleted' => '',
        'There was an error synchronizing the processes.' => '',
        'The %s:%s is still in use' => '',
        'The %s:%s has a different EntityID' => '',
        'Could not delete %s:%s' => '',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '',
        'Could not get %s' => '',
        'Need %s!' => '',
        'Process: %s is not Inactive' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '',
        'There was an error creating the Activity' => '',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            '',
        'Need ActivityID!' => '',
        'Could not get data for ActivityID %s' => '',
        'There was an error updating the Activity' => '',
        'Missing Parameter: Need Activity and ActivityDialog!' => '',
        'Activity not found!' => '',
        'ActivityDialog not found!' => 'Dialogo de Atividade não encontrado!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            '',
        'Error while saving the Activity to the database!' => '',
        'This subaction is not valid' => '',
        'Edit Activity "%s"' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '',
        'There was an error creating the ActivityDialog' => '',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            '',
        'Need ActivityDialogID!' => '',
        'Could not get data for ActivityDialogID %s' => '',
        'There was an error updating the ActivityDialog' => '',
        'Edit Activity Dialog "%s"' => '',
        'Agent Interface' => '',
        'Customer Interface' => '',
        'Agent and Customer Interface' => '',
        'Do not show Field' => '',
        'Show Field' => '',
        'Show Field As Mandatory' => '',
        'fax' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            '',
        'There was an error creating the Transition' => '',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '',
        'Need TransitionID!' => '',
        'Could not get data for TransitionID %s' => '',
        'There was an error updating the Transition' => '',
        'Edit Transition "%s"' => '',
        'xor' => '',
        'String' => '',
        'Transition validation module' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '',
        'There was an error generating a new EntityID for this TransitionAction' =>
            '',
        'There was an error creating the TransitionAction' => '',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            '',
        'Need TransitionActionID!' => '',
        'Could not get data for TransitionActionID %s' => '',
        'There was an error updating the TransitionAction' => '',
        'Edit Transition Action "%s"' => '',
        'Error: Not all keys seem to have values or vice versa.' => '',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Don\'t use :: in queue name!' => '',
        'Click back and change it!' => '',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produção',
        'Test' => '',
        'Training' => 'Formação',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Papel',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            '',
        'Need param Filename to delete!' => '',
        'Need param Filename to download!' => '',
        'Needed CertFingerprint and CAFingerprint!' => '',
        'CAFingerprint must be different than CertFingerprint' => '',
        'Relation exists!' => '',
        'Relation added!' => '',
        'Impossible to add relation!' => '',
        'Relation doesn\'t exists' => '',
        'Relation deleted!' => '',
        'Impossible to delete relation!' => '',
        'Certificate %s could not be read!' => '',
        'Needed Fingerprint' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation updated!' => 'Saudação actualizada.',
        'Salutation added!' => 'Saudação adicionada.',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '',

        # Perl Module: Kernel/Modules/AdminSysConfig.pm
        'Import not allowed!' => '',
        'Need File!' => '',
        'Can\'t write ConfigItem!' => '',
        '-new-' => '',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => '',
        'There was an error creating the System Maintenance' => '',
        'Need SystemMaintenanceID!' => '',
        'Could not get data for SystemMaintenanceID %s' => '',
        'System Maintenance was saved successfully!' => '',
        'Session has been killed!' => '',
        'All sessions have been killed, except for your own.' => '',
        'There was an error updating the System Maintenance' => '',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => '',
        'Template added!' => '',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '',
        'Statistic' => '',
        'No preferences for %s!' => '',
        'Can\'t get element data of %s!' => '',
        'Can\'t get filter content data of %s!' => '',
        'Customer Company Name' => '',
        'Customer User ID' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '',
        'Please contact the administrator.' => 'Contact o administrador.',
        'You need ro permission!' => '',
        'Can not delete link with %s!' => 'Não é possível remover a ligação a %s.',
        'Can not create link with %s! Object already linked as %s.' => 'Não é possível criar a ligação a %s. Já existe uma ligação a %s!',
        'Can not create link with %s!' => '',
        'The object %s cannot link with other object!' => '',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => '',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => '',
        'Invalid Subaction.' => '',
        'Statistic could not be imported.' => '',
        'Please upload a valid statistic file.' => '',
        'Export: Need StatID!' => '',
        'Delete: Get no StatID!' => '',
        'Need StatID!' => '',
        'Could not load stat.' => '',
        'Could not create statistic.' => '',
        'Run: Get no %s!' => '',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '',
        'You need %s permissions!' => '',
        'Could not perform validation on field %s!' => '',
        'No subject' => 'Sem assunto',
        'Previous Owner' => 'Proprietário anterior',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s é necessário.',
        'Plain article not found for article %s!' => '',
        'Article does not belong to ticket %s!' => '',
        'Can\'t bounce email!' => '',
        'Can\'t send email!' => 'Não é possível enviar o email.',
        'Wrong Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => '',
        'Ticket (%s) is not unlocked!' => '',
        'Bulk feature is not enabled!' => '',
        'No selectable TicketID is given!' => '',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'You need to select at least one ticket.' => '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Can not determine the ArticleType!' => 'Não é possível determinar o tipo de artigo.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'No Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'Sem ID de Ticket!',
        'System Error!' => 'Erro do sistema.',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Invalid Filter: %s!' => 'Filtro inválido: %s.',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'Não é possível apresentar o histórico. Falta o ID do registo.',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => 'O proprietário actual é: %s.',
        'Please become the owner first.' => 'Tem que ser o proprietário do registo.',
        'Ticket (ID=%s) is locked by %s!' => 'O registo (ID=%s) está bloqueado por %s.',
        'Change the owner!' => '',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Não é possível fundir o registo com ele mesmo.',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'Necessita de permissões de movimentação',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Chat não está activo.',
        'No permission.' => 'Sem permissão.',
        '%s has left the chat.' => '%s saiu do chat.',
        'This chat has been closed and will be removed in %s hours.' => 'O chat foi fechado e será removido em %s horas.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'Sem ID do registo.',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'É necessário o ID do registo.',
        'printed by' => 'impresso por',
        'Ticket Dynamic Fields' => 'Campos Dinâmicos de Ticket',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '',
        'No Process configured!' => '',
        'Process %s is invalid!' => 'Processo %s está inválido!',
        'Subaction is invalid!' => 'sub ação está inválida!',
        'Parameter %s is missing in %s.' => '',
        'No ActivityDialog configured for %s in _RenderAjax!' => '',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => '',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            '',
        'Process::Default%s Config Value missing!' => '',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            '',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            '',
        'Can\'t get Ticket "%s"!' => '',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            '',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            '',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            '',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => '',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            '',
        'Pending Date' => 'Prazo de pendência',
        'for pending* states' => 'para os estados "pendentes ..."',
        'ActivityDialogEntityID missing!' => '',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => '',
        'Couldn\'t use CustomerID as an invisible field.' => '',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            '',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            '',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => '',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => '',
        'Could not store ActivityDialog, invalid TicketID: %s!' => '',
        'Invalid TicketID: %s!' => '',
        'Missing ActivityEntityID in Ticket %s!' => '',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => '',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Default Config for Process::Default%s missing!' => '',
        'Default Config for Process::Default%s invalid!' => '',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'Untitled' => 'Sem título',
        'Customer Name' => 'Cliente',
        'Invalid Users' => 'Utilizadores inválidos',
        'CSV' => '',
        'Excel' => '',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'Não activada.',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'Não activada',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Ligação removida',
        'Ticket Locked' => 'Registo bloqueado',
        'Pending Time Set' => 'Tempo de pendência definido',
        'Dynamic Field Updated' => 'Campo actualizado',
        'Outgoing Email (internal)' => 'Email enviado (interno)',
        'Ticket Created' => 'Registo criado',
        'Type Updated' => 'Tipo actualizado',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => '',
        'Escalation First Response Time Stopped' => '',
        'Customer Updated' => 'Cliente actualizado',
        'Internal Chat' => 'Chat interno',
        'Automatic Follow-Up Sent' => 'Actualização automática enviada',
        'Note Added' => 'Nota adicionada',
        'Note Added (Customer)' => 'Nota adicionada (Cliente)',
        'State Updated' => 'Estado actualizado',
        'Outgoing Answer' => 'Resposta enviada',
        'Service Updated' => 'Serviço actualizado',
        'Link Added' => 'Ligação adicionada',
        'Incoming Customer Email' => 'Email do cliente recebido',
        'Incoming Web Request' => 'Pedido por web recebido',
        'Priority Updated' => 'Prioridade actualizada',
        'Ticket Unlocked' => 'Ticket desbloqueado',
        'Outgoing Email' => '',
        'Title Updated' => 'Titulo actualizado',
        'Ticket Merged' => 'Ticket fundido',
        'Outgoing Phone Call' => 'Chamada realizada',
        'Forwarded Message' => 'Mensagem Encaminhada',
        'Removed User Subscription' => '',
        'Time Accounted' => 'Tempo contabilizado',
        'Incoming Phone Call' => 'Chamada recebida',
        'System Request.' => 'Pedido ao sistema.',
        'Incoming Follow-Up' => 'Actualização recebida',
        'Automatic Reply Sent' => 'Resposta automática enviada',
        'Automatic Reject Sent' => 'Rejeição automática enviada',
        'Escalation Solution Time In Effect' => '',
        'Escalation Solution Time Stopped' => '',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => '',
        'SLA Updated' => 'Nível de serviço (SLA) actualizado',
        'Queue Updated' => 'Fila actualizada',
        'External Chat' => 'Chat externo',
        'Queue Changed' => 'Fila actualizada',
        'Notification Was Sent' => 'Notificação enviada',
        'We are sorry, you do not have permissions anymore to access this ticket in its current state.' =>
            'Não dispõe de permissões para aceder a este ticket no seu estado actual',
        'Can\'t get for ArticleID %s!' => '',
        'Article filter settings were saved.' => 'Configurações de filtro de artigos gravadas.',
        'Event type filter settings were saved.' => '',
        'Need ArticleID!' => 'É necessário o ID do registo',
        'Invalid ArticleID!' => 'ID do registo inválido.',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => 'Utilizador activo.',
        'Away' => 'Ausente',
        'User was inactive for a while.' => 'Utilizador esteve ausente.',
        'Unavailable' => 'Indisponível',
        'User set their status to unavailable.' => '',
        'Fields with no group' => '',
        'View the source for this Article' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'São necessários os IDs do registo e do artigo.',
        'No TicketID for ArticleID (%s)!' => 'Não existe ID do registo para o artigo (%s).',
        'No such attachment (%s)!' => 'Anexo inexistente (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'Verificar a configuração do systema para %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'Verificar a configuração do systema para %s::TicketTypeDefault.',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'É necessário o ID de utilizador',
        'My Tickets' => 'Os meus Tickets',
        'Company Tickets' => 'Tickets da Organização',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Please remove the following words because they cannot be used for the search:' =>
            'As palavras seguintes não podem ser utilizadas na pesquisa. P.f. remova-as.',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'Não é possível reabrir o ticket nesta fila!',
        'Create a new ticket!' => 'Criar um novo ticket!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => '',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => 'A directoria "%s" não existe!',
        'Configure "Home" in Kernel/Config.pm first!' => '',
        'File "%s/Kernel/Config.pm" not found!' => '',
        'Directory "%s" not found!' => 'A directoria "%s" não existe!',
        'Kernel/Config.pm isn\'t writable!' => '',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Database %s' => '',
        'Configure MySQL' => '',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => '',
        'Please go back.' => '',
        'Install OTRS - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => '',
        'Syslog' => '',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => '',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '',
        'Authentication failed from %s!' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Sent message crypted to recipient!' => 'Enviada mensagem encriptada.',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => 'Detectado cabeçalho "PGP SIGNED MESSAGE" inválido!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => 'Detectado cabeçalho "S/MIME SIGNED MESSAGE" inválido!',
        'Ticket decrypted before' => 'Registo já desencriptado',
        'Impossible to decrypt: private key for email was not found!' => 'Impossível desencriptar: chave privada não encontrada!',
        'Successful decryption' => 'Desencriptação bem sucedida',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'A hora inicial não pode ser posterior à hora final!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => 'Sem ligação ao servidor de Notícias!',
        'Can\'t get OTRS News from server!' => 'Impossível obter Notícias do servidor!',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => 'Sem ligação ao servidor de Notícias do produto!',
        'Can\'t get Product News from server!' => 'Impossível obter Notícias do produto!',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => 'Impossível ligar a %s!',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'sorted ascending' => 'ordenado por ordem crescente',
        'sorted descending' => 'ordenado por ordem decrescente',
        'filter not active' => 'filtro não activo',
        'filter active' => 'filtro activo',
        'This ticket has no title or subject' => 'Este ticket não tem título ou assunto',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state. You can take one of the following actions:' =>
            'Não dispõem de permissões para aceder a este registo no estado actual.Pode efectuar uma das seguintes acções:',
        'No Permission' => 'Sem permissão',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Ligado como',
        'Search Result' => 'Resultado da pesquisa',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'Arquivar pesquisa',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'A system maintenance period will start at: ' => 'O sistema entrará em manutenção às:',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(em processamento)',

        # Perl Module: Kernel/Output/HTML/Preferences/NotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Please supply your new password!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'No (not supported)' => '',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '',
        'The selected date is not valid.' => '',
        'The selected end time is before the start time.' => '',
        'There is something wrong with your time selection.' => '',
        'Please select only one element or allow modification at stat generation time.' =>
            '',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '',
        'Please select one element for the X-axis.' => '',
        'You can only use one time element for the Y axis.' => '',
        'You can only use one or two elements for the Y axis.' => '',
        'Please select at least one value of this field.' => '',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => '',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Ordenado por',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '',
        'Please note that the session limit is almost reached.' => '',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '',
        'Session per user limit reached!' => '',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Referência de Opções de Configuração',
        'This setting can not be changed.' => '',
        'This setting is not active by default.' => 'Esta configuração não está ativa por omissão.',
        'This setting can not be deactivated.' => '',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '',
        'File is not installed!' => '',
        'File is different!' => '',
        'Can\'t read file!' => '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Inativo',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t get Token from sever' => '',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Somatório',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Tipo de estado',
        'Created Priority' => 'Prioridade Criada',
        'Created State' => 'Estado de Prioridade',
        'Create Time' => 'Tempo de Prioridade',
        'Close Time' => 'Tempo de Fecho',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => 'Agente/Proprietário',
        'Created by Agent/Owner' => 'Criado por Agente/Proprietário',
        'CustomerUserLogin' => 'Acesso Cliente',
        'CustomerUserLogin (complex search)' => '',
        'CustomerUserLogin (exact match)' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Avaliado por',
        'Ticket/Article Accounted Time' => 'Tempo contabilizado no Ticket/Artigo',
        'Ticket Create Time' => 'Hora de criação de Ticket',
        'Ticket Close Time' => 'Hora de fecho de Ticket',
        'Accounted time by Agent' => 'Tempo contabilizado pelo agente',
        'Total Time' => 'Tempo total',
        'Ticket Average' => 'Média de tickets',
        'Ticket Min Time' => 'Tempo Mínimo',
        'Ticket Max Time' => 'Tempo máximo',
        'Number of Tickets' => 'Nr. Tickets',
        'Article Average' => 'Média de artigos',
        'Article Min Time' => 'Tempo mínimo de artigos',
        'Article Max Time' => 'Tempo máximo de artigos',
        'Number of Articles' => 'Nr. Artigos',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => 'sem limite',
        'ascending' => 'Ascendente',
        'descending' => 'Descendente',
        'Attributes to be printed' => 'Atributos a imprimir',
        'Sort sequence' => 'Sequência de ordenação',
        'State Historic' => 'Histórico de estados',
        'State Type Historic' => 'Histórico de tipos de estado',
        'Historic Time Range' => 'Intervalo temporal',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => '',
        'Solution Min Time' => '',
        'Solution Max Time' => '',
        'Solution Average (affected by escalation configuration)' => '',
        'Solution Min Time (affected by escalation configuration)' => '',
        'Solution Max Time (affected by escalation configuration)' => '',
        'Solution Working Time Average (affected by escalation configuration)' =>
            '',
        'Solution Min Working Time (affected by escalation configuration)' =>
            '',
        'Solution Max Working Time (affected by escalation configuration)' =>
            '',
        'First Response Average (affected by escalation configuration)' =>
            '',
        'First Response Min Time (affected by escalation configuration)' =>
            '',
        'First Response Max Time (affected by escalation configuration)' =>
            '',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '',
        'Number of Tickets (affected by escalation configuration)' => '',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => 'Dias',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => '',
        'Internal Error: Could not open file.' => '',
        'Table Check' => '',
        'Internal Error: Could not read file.' => '',
        'Tables found which are not present in the database.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => '',
        'Could not determine database size.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => '',
        'Could not determine database version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => '',
        'Setting character_set_client needs to be utf8.' => '',
        'Server Database Charset' => '',
        'Setting character_set_database needs to be UNICODE or UTF8.' => '',
        'Table Charset' => '',
        'There were tables found which do not have utf8 as charset.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => '',
        'The setting innodb_log_file_size must be at least 256 MB.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => '',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => '',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => '',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => '',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => '',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => '',
        'NLS_DATE_FORMAT Setting SQL Check' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => '',
        'Setting server_encoding needs to be UNICODE or UTF8.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => '',
        'Setting DateStyle needs to be ISO.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 8.x or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => '',
        'The partition where OTRS is located is almost full.' => '',
        'The partition where OTRS is located has no disk space problems.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => '',
        'Could not determine distribution.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => '',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => '',
        'Not all required Perl modules are correctly installed.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '',
        'No swap enabled.' => '',
        'Used Swap Space (MB)' => '',
        'There should be more than 60% free swap space.' => '',
        'There should be no more than 200 MB swap space used.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'OTRS' => '',
        'Config Settings' => '',
        'Could not determine value.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => '',
        'Daemon is running.' => '',
        'Daemon is not running.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => '',
        'Tickets' => 'Tickets',
        'Ticket History Entries' => '',
        'Articles' => '',
        'Attachments (DB, Without HTML)' => '',
        'Customers With At Least One Ticket' => '',
        'Dynamic Field Values' => '',
        'Invalid Dynamic Fields' => '',
        'Invalid Dynamic Field Values' => '',
        'GenericInterface Webservices' => '',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => '',
        'Tickets Per Month (avg)' => '',
        'Open Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => '',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => '',
        'Please configure your FQDN setting.' => '',
        'Domain Name' => '',
        'Your FQDN setting is invalid.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => '',
        'The file system on your OTRS partition is not writable.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => '',
        'Some packages have locally modified files.' => '',
        'Some packages are not correctly installed.' => '',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTRS could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => '',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => '',
        'Server time zone' => '',
        'Computed server time offset' => '',
        'OTRS TimeZone setting (global time offset)' => '',
        'TimeZone may only be activated for systems running in UTC.' => '',
        'OTRS TimeZoneUser setting (per-user time zone support)' => '',
        'TimeZoneUser may only be activated for systems running in UTC that don\'t have an OTRS TimeZone set.' =>
            '',
        'OTRS TimeZone setting for calendar ' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => '',
        'Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => '',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => '',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '',
        'mod_deflate Usage' => '',
        'Please install mod_deflate to improve GUI speed.' => '',
        'mod_filter Usage' => '',
        'Please install mod_filter if mod_deflate is used.' => '',
        'mod_headers Usage' => '',
        'Please install mod_headers to improve GUI speed.' => '',
        'Apache::Reload Usage' => '',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            '',
        'Apache2::DBI Usage' => '',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => '',
        'Could not determine webserver version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => 'Utilizadores Concorrentes',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'Unknown' => '',
        'OK' => '',
        'Problem' => '',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => '',

        # Perl Module: Kernel/System/Ticket/Event/NotificationEvent/Transport/Email.pm
        'PGP sign only' => 'PGP apenas assinar',
        'PGP encrypt only' => 'PGP apenas encriptar',
        'PGP sign and encrypt' => 'PGP assinar e encriptar',
        'SMIME sign only' => 'SMIME apenas assinar',
        'SMIME encrypt only' => 'SMIME apenas encriptar',
        'SMIME sign and encrypt' => 'SMIME assinar e encriptar',
        'PGP and SMIME not enabled.' => 'PGP e SMIME não activos',
        'Skip notification delivery' => 'Não enviar notificação de entrega',
        'Send unsigned notification' => 'Enviar notificação de entrega',
        'Send unencrypted notification' => 'Enviar notificação não encriptada',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => 'Sessão terminada com sucesso',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => 'Sem permissões para utilizar este módulo!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            'Autenticação OK mas faltam os dados de utilizador. Contactar o admnistrador.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '',
        'Can\'t send account info!' => '',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'Group for default access.' => '',
        'Group of all administrators.' => '',
        'Group for statistics access.' => '',
        'All new state types (default: viewable).' => '',
        'All open state types (default: viewable).' => '',
        'All closed state types (default: not viewable).' => '',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'All \'removed\' state types (default: not viewable).' => '',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => '',
        'Ticket is closed successful.' => '',
        'Ticket is closed unsuccessful.' => '',
        'Open tickets.' => '',
        'Customer removed ticket.' => '',
        'Ticket is pending for agent reminder.' => '',
        'Ticket is pending for automatic close.' => '',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => '',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => '',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => '',
        'All default incoming tickets.' => '',
        'All junk tickets.' => '',
        'All misc tickets.' => '',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => '',
        'tmp_lock' => '',
        'email-notification-ext' => '',
        'email-notification-int' => '',
        'Ticket create notification' => 'Criação de ticket',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Receberá uma notificação quando for criado um ticket numa das suas "Minhas Filas" ou "Meus Serviços".',
        'Ticket follow-up notification (unlocked)' => '',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => '',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '',
        'Ticket owner update notification' => 'Notificação de actualização de proprietário do ticket',
        'Ticket responsible update notification' => 'Notificação de actualização de responsável do ticket',
        'Ticket new note notification' => 'Notificação de nova nota no ticket',
        'Ticket queue update notification' => 'Notificação de alteração de fila',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Receberá uma notificação sempre que um ticket for movido para uma das suas "Minhas Filas".',
        'Ticket pending reminder notification (locked)' => '',
        'Ticket pending reminder notification (unlocked)' => '',
        'Ticket escalation notification' => '',
        'Ticket escalation warning notification' => '',
        'Ticket service update notification' => '',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            '',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '',
        ' (work units)' => ' (unidades de trabalho)',
        '"%s" notification was sent to "%s" by "%s".' => '',
        '"Slim" skin which tries to save screen space for power users.' =>
            '',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s unidade(s) de tempo contabilizada(s). Total %s unidade(s) de tempo.',
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname Firstname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        '*** out of office until %s (%s d left) ***' => '',
        '100 (Expert)' => '',
        '200 (Advanced)' => '',
        '300 (Beginner)' => '',
        'A TicketWatcher Module.' => '',
        'A Website' => '',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'A picture' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Módulo ACL que permite o fecho de tickets apenas se todos os tickets filhos estiverem fechados("Estado" mostra os estados não disponíveis ao pai até que todos os filhos estejam fechados).',
        'Access Control Lists (ACL)' => '',
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
        'ActivityID' => '',
        'Add a comment.' => '',
        'Add a default name for Dynamic Field.' => '',
        'Add an inbound phone call to this ticket' => '',
        'Add an outbound phone call to this ticket' => '',
        'Added email. %s' => 'Adicionado Email. %s',
        'Added link to ticket "%s".' => 'Adicionado novo link ao ticket "%s".',
        'Added note (%s)' => 'Nota adicionada (%s)',
        'Added subscription for user "%s".' => 'Adicionada subscrição para o utilizador "%s".',
        'Address book of CustomerUser sources.' => '',
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
        'Admin Area.' => '',
        'After' => 'Após',
        'Agent Name' => 'Nome do agente',
        'Agent Name + FromSeparator + System Address Display Name' => '',
        'Agent Preferences.' => 'Preferências',
        'Agent called customer.' => 'Cliente contatado.',
        'Agent interface article notification module to check PGP.' => 'Módulo de notificações no interface de agente para verificar PGP',
        'Agent interface article notification module to check S/MIME.' =>
            'Módulo de notificações no interface de agente para verificar S/MIME',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Módulo de notificações no interface de agente para verificar a recepção de emails na vista de detalhe se a chave S/MIME estiver ativa.',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'AgentCustomerSearch' => '',
        'AgentCustomerSearch.' => '',
        'AgentUserSearch' => '',
        'AgentUserSearch.' => '',
        'Agents <-> Groups' => 'Agentes<->Grupos',
        'Agents <-> Roles' => 'Agentes<->Papéis',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
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
            'Permite definir novos tipos de tickets (se a funcionalidade de tipo de ticket estiver ativa).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permite definir serviços e SLAs para os tickets(ex. email, desktop, network, ...), e atributos de escalagem para os SLAs(caso a funcionalidade service/SLA esteja ativa).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows generic agent to execute custom command line scripts.' =>
            '',
        'Allows generic agent to execute custom modules.' => '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite ter vista em formato médio do ticket (CustomerInfo=>1 - mostra informação de cliente).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite utilizar o formato de vista geral (CustomerInfo => 1 - mostra também a informação de cliente).',
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'Always show RichText if available' => '',
        'Arabic (Saudi Arabia)' => '',
        'Archive state changed: "%s"' => '',
        'ArticleTree' => 'ArvoreDeArtigos',
        'Attachments <-> Templates' => '',
        'Auto Responses <-> Queues' => '',
        'AutoFollowUp sent to "%s".' => 'Auto Acompanhamento enviado para "%s".',
        'AutoReject sent to "%s".' => 'Rejeição automática enviada para "%s".',
        'AutoReply sent to "%s".' => 'Auto resposta enviada para "%s".',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => '',
        'Based on global RichText setting' => '',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Bounced to "%s".' => 'Devolvido para "%s".',
        'Builds an article index right after the article\'s creation.' =>
            '',
        'Bulgarian' => '',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB ACL backend.' => '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the SSL certificate attributes.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Catalan' => '',
        'Change password' => '',
        'Change queue!' => '',
        'Change the customer for this ticket' => '',
        'Change the free fields for this ticket' => '',
        'Change the priority for this ticket' => '',
        'Change the responsible for this ticket' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Alterada Prioridade de "%s" (%s) para "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '',
        'Checks the entitlement status of OTRS Business Solution™.' => '',
        'Chinese (Simplified)' => '',
        'Chinese (Traditional)' => '',
        'Choose for which kind of ticket changes you want to receive notifications.' =>
            'Seleccione as notificações que pretende receber',
        'Closed tickets (customer user)' => 'Tickets fechados (utilizador do cliente)',
        'Closed tickets (customer)' => 'Tickets fechados (cliente)',
        'Cloud Services' => 'Serviços cloud',
        'Cloud service admin module registration for the transport layer.' =>
            '',
        'Collect support data for asynchronous plug-in modules.' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => '',
        'Comment2' => '',
        'Communication' => '',
        'Company Status' => '',
        'Company Tickets.' => 'Tickets da Organização',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Compat module for AgentZoom to AgentTicketZoom.' => '',
        'Complex' => '',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => '',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'Qual o ecran que deve ser mostrado após a criação de um ticket.',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://otrs.github.io/doc/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket.' => 'Criar novo ticket de processo.',
        'Create Ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Gerir Níveis de Serviço (SLA)',
        'Create and manage agents.' => 'Gerir agentes.',
        'Create and manage attachments.' => 'Gerir anexos.',
        'Create and manage customer users.' => 'Gerir utilizadores de cliente.',
        'Create and manage customers.' => 'Gerir clientes.',
        'Create and manage dynamic fields.' => 'Gerir campos dinâmicos.',
        'Create and manage groups.' => 'Gerir grupos.',
        'Create and manage queues.' => 'Gerir filas.',
        'Create and manage responses that are automatically sent.' => 'Gerir respostas automáticas',
        'Create and manage roles.' => 'Gerir papeis.',
        'Create and manage salutations.' => 'Gerir saudações',
        'Create and manage services.' => 'Gerir serviços.',
        'Create and manage signatures.' => 'Gerir assinaturas.',
        'Create and manage templates.' => 'Gerir modelos.',
        'Create and manage ticket notifications.' => 'Criar e gerir notificações',
        'Create and manage ticket priorities.' => 'Gerir prioridades de ticket',
        'Create and manage ticket states.' => 'Gerir estados de ticket',
        'Create and manage ticket types.' => 'Gerir tipos de ticket',
        'Create and manage web services.' => '',
        'Create new Ticket.' => 'Criar ticket.',
        'Create new email ticket and send this out (outbound).' => '',
        'Create new email ticket.' => 'Criar ticket por email.',
        'Create new phone ticket (inbound).' => 'Criar novo ticket de chamada recebida.',
        'Create new phone ticket.' => 'Criar ticket de telefone.',
        'Create new process ticket.' => 'Criar novo ticket de processo.',
        'Create tickets.' => 'Criar tickets.',
        'Croatian' => '',
        'Custom RSS Feed' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => 'Gestão de clientes',
        'Customer Information Center Search.' => '',
        'Customer Information Center.' => 'Centro de Informação de Cliente.',
        'Customer Ticket Print Module.' => '',
        'Customer User <-> Groups' => '',
        'Customer User <-> Services' => '',
        'Customer User Administration' => 'Gestão de utilizadores de cliente',
        'Customer Users' => 'Utilizadores de cliente',
        'Customer called us.' => 'Cliente contatou-nos.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer preferences.' => 'Preferências de cliente.',
        'Customer request via web.' => 'Ticket de cliente via web.',
        'Customer ticket overview' => 'Lista de tickets do cliente',
        'Customer ticket search.' => 'Pesquisa de tickets de cliente.',
        'Customer ticket zoom' => '',
        'Customer user search' => '',
        'CustomerID search' => '',
        'CustomerName' => '',
        'CustomerUser' => '',
        'Customers <-> Groups' => '',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Czech' => '',
        'DEPRECATED: This config setting will be removed in further versions of OTRS. Sets the time (in seconds) a user is marked as active (minimum active time is 300 seconds).' =>
            '',
        'Danish' => '',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => 'Data / Hora',
        'Debug' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default' => '',
        'Default (Slim)' => '',
        'Default ACL values for ticket actions.' => '',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default agent name' => '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => '',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default skin for the customer interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the queue comment 2.' => '',
        'Define the service comment 2.' => '',
        'Define the sla comment 2.' => '',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            '',
        'Define the start day of the week for the date picker.' => '',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
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
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => '',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            '',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            '',
        'Defines all the parameters for this notification transport.' => '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
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
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            '',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            '',
        'Defines if the values for filters should be retrieved from all available tickets. If set to "Yes", only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
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
        'Defines the agent preferences key where the shared secret key is stored.' =>
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
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the cluster node identifier. This is only used in cluster configurations where there is more than one OTRS frontend system. Note: only values from 1 to 99 are allowed.' =>
            '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://otrs.github.io/doc/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
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
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
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
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
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
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
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
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
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
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
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
        'Defines the default ticket type.' => '',
        'Defines the default type for article in the customer interface.' =>
            '',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            '',
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
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
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
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '',
        'Defines the maximum number of affected tickets per job.' => '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => '',
        'Defines the module to display a notification if cloud services are disabled.' =>
            '',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            '',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
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
        'Defines the name of the table where the user preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
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
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '',
        'Defines the number of days to keep the daemon log files.' => '',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
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
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            '',
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
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => '',
        'Defines the two-factor module to authenticate customers.' => '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            '',
        'Defines which items are available in first level of the ACL structure.' =>
            '',
        'Defines which items are available in second level of the ACL structure.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Delete expired cache from core modules.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => '',
        'Delete expired sessions.' => '',
        'Deleted link to ticket "%s".' => 'Link de ticket apagado "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '',
        'Deploy and manage OTRS Business Solution™.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the communication between this system and OTRS Group servers that provides cloud services. If active, some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Dropdown' => '',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '',
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
        'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
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
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField' => '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'E-Mail Outbound' => '',
        'Edit Customer Companies.' => '',
        'Edit Customer Users.' => '',
        'Edit customer company' => '',
        'Email Addresses' => '',
        'Email Outbound' => '',
        'Email sent to "%s".' => 'Email enviado para "%s".',
        'Email sent to customer.' => 'Email enviado para cliente.',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => '',
        'Enables customers to create their own accounts.' => '',
        'Enables fetch S/MIME from CustomerUser backend support.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => '',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'English (Canada)' => '',
        'English (United Kingdom)' => '',
        'English (United States)' => '',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Enroll process for this ticket' => '',
        'Enter your shared secret to enable two factor authentication.' =>
            '',
        'Escalation response time finished' => '',
        'Escalation response time forewarned' => '',
        'Escalation response time in effect' => '',
        'Escalation solution time finished' => '',
        'Escalation solution time forewarned' => '',
        'Escalation solution time in effect' => '',
        'Escalation update time finished' => '',
        'Escalation update time forewarned' => '',
        'Escalation update time in effect' => '',
        'Escalation view' => '',
        'EscalationTime' => '',
        'Estonian' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer user search profiles if login changes.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            '',
        'Event module that updates customer users after an update of the Customer.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            '',
        'Event module that updates tickets after an update of the Customer.' =>
            '',
        'Events Ticket Calendar' => '',
        'Execute SQL statements.' => '',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            '',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetch emails via fetchmail (using SSL).' => '',
        'Fetch emails via fetchmail.' => '',
        'Fetch incoming emails from configured mail accounts.' => '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            '',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => '',
        'Finnish' => '',
        'First Queue' => '',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'FollowUp for [%s]. %s' => 'Atualização para [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Forwarded to "%s".' => 'Encaminhado para "%s".',
        'French' => '',
        'French (Canada)' => '',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Frontend' => '',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend module registration for the public interface.' => '',
        'Frontend theme' => '',
        'Frontend theme.' => '',
        'Full value' => '',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => '',
        'Galician' => '',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => '',
        'Generic Info module.' => '',
        'GenericAgent' => '',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPREST GUI' => '',
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
        'German' => '',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Global Search Module.' => '',
        'Go back' => 'Voltar',
        'Google Authenticator' => '',
        'Graph: Bar Chart' => '',
        'Graph: Line Chart' => '',
        'Graph: Stacked Area Chart' => '',
        'Greek' => '',
        'HTML Reference' => '',
        'HTML Reference.' => '',
        'Hebrew' => '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild".' =>
            '',
        'Hindi' => '',
        'Hungarian' => '',
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
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled debugging information for ACLs is logged.' => '',
        'If enabled debugging information for transitions is logged.' => '',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            '',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            '',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTRSHome>/var/run/ can not be used.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Tempo de actualização (se activado) das diferentes vistas (Painel de Controlo, Bloqueados, Filas).',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is disabled, articles will not automatically be decrypted and stored in the database. Please note that this also means no decryption will take place and the articles will be shown in ticket zoom in their original (encrypted) form.' =>
            '',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If this setting is active, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            '',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '',
        'Include unknown customers in ticket filter.' => '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'Incoming Phone Call.' => '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indonesian' => '',
        'Input' => '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Idioma do interface',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Italian' => '',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Ivory' => '',
        'Ivory (Slim)' => '',
        'Japanese' => '',
        'JavaScript function for the search frontend.' => '',
        'Last customer subject' => '',
        'Lastname Firstname' => '',
        'Lastname Firstname (UserLogin)' => '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'Latvian' => '',
        'Left' => '',
        'Link Object' => 'Ligar Objeto',
        'Link Object.' => '',
        'Link agents to groups.' => '',
        'Link agents to roles.' => 'Ligar agentes a papéis.',
        'Link attachments to templates.' => '',
        'Link customer user to groups.' => '',
        'Link customer user to services.' => '',
        'Link queues to auto responses.' => '',
        'Link roles to groups.' => 'Ligar papéis a grupos.',
        'Link templates to queues.' => '',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '',
        'List of all CustomerUser events to be displayed in the GUI.' => '',
        'List of all DynamicField events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all queue events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List view' => '',
        'Lithuanian' => '',
        'Lock / unlock this ticket' => '',
        'Locked Tickets.' => '',
        'Locked ticket.' => 'Ticket bloqueado.',
        'Log file for the ticket counter.' => '',
        'Logged-In Users' => '',
        'Logout of customer panel.' => '',
        'Loop-Protection! No auto-response sent to "%s".' => 'Loop-Protection! Nao foi enviada auto-resposta para "%s".',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application block external content loading.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Malay' => '',
        'Manage OTRS Group cloud services.' => '',
        'Manage PGP keys for email encryption.' => '',
        'Manage POP3 or IMAP accounts to fetch email from.' => '',
        'Manage S/MIME certificates for email encryption.' => '',
        'Manage existing sessions.' => '',
        'Manage support data.' => '',
        'Manage system registration.' => '',
        'Manage tasks triggered by event or time based execution.' => '',
        'Mark this ticket as junk!' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum Number of a calendar shown in a dropdown.' => '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Merge this ticket and all articles into another ticket' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => '',
        'Miscellaneous' => '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '',
        'Module to check the group permissions for the access to tickets.' =>
            '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to crypt composed messages (PGP or S/MIME).' => '',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to filter encrypted bodies of incoming messages.' => '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            '',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            '',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            '',
        'Module to grant access to the agent responsible of a ticket.' =>
            '',
        'Module to grant access to the creator of a ticket.' => '',
        'Module to grant access to the owner of a ticket.' => '',
        'Module to grant access to the watcher agents of a ticket.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => '',
        'My Services' => '',
        'My Tickets.' => 'Os meus tickets',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'Nederlands' => '',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'Novo Ticket [%s] criado (Q=%s;P=%s;S=%s).',
        'New Window' => '',
        'New owner is "%s" (ID=%s).' => 'Novo proprietário: "%s" (ID=%s).',
        'New process ticket' => '',
        'New responsible is "%s" (ID=%s).' => 'Atualização do responsável "%s"',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'None' => '',
        'Norwegian' => '',
        'Notification sent to "%s".' => 'Notificação enviada para "%s".',
        'Number of displayed tickets' => 'Numero de tickets listados',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'Old: "%s" New: "%s"' => 'Antigo: "%s" Novo: "%s"',
        'Open tickets (customer user)' => '',
        'Open tickets (customer)' => '',
        'Option' => '',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Out Of Office' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets.' => '',
        'Overview Refresh Time' => 'Tempo de actualização',
        'Overview of all escalated tickets.' => '',
        'Overview of all open Tickets.' => '',
        'Overview of all open tickets.' => '',
        'Overview of customer tickets.' => '',
        'PGP Key Management' => '',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the column filters of the small ticket overview.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
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
        'ParentChild' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'People' => '',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Persian' => '',
        'Phone Call.' => '',
        'Picture Upload' => '',
        'Picture upload module.' => '',
        'Picture-Upload' => '',
        'Polish' => '',
        'Portuguese' => '',
        'Portuguese (Brasil)' => '',
        'PostMaster Filters' => '',
        'PostMaster Mail Accounts' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Process Ticket.' => '',
        'Process pending tickets.' => '',
        'Process ticket' => '',
        'ProcessID' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue.' =>
            'Fornece uma visão geral em matriz dos tickets por estado e fila',
        'Queue view' => '',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh interval' => 'Tempo de actualização',
        'Removed subscription for user "%s".' => 'Subscrição de ticket removida "%s".',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be active in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Reports' => 'Relatórios',
        'Reports (OTRS Business Solution™)' => '',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the email outbound screen in the agent interface.' =>
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
        'Responsible Tickets' => '',
        'Responsible Tickets.' => '',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => '',
        'Roles <-> Groups' => '',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => '',
        'SMS' => '',
        'SMS (Short Message Service)' => '',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => '',
        'Screen' => 'Ecran',
        'Search Customer' => 'Procurar Cliente',
        'Search Ticket.' => '',
        'Search Tickets.' => '',
        'Search User' => '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Search.' => '',
        'Second Queue' => '',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => '',
        'Select your default spelling dictionary.' => '',
        'Select your preferred layout for OTRS.' => '',
        'Select your preferred theme for OTRS.' => '',
        'Select your time zone.' => '',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send new outgoing mail from this ticket' => '',
        'Send notifications to users.' => '',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer.' => '',
        'Sends registration information to OTRS group.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            '',
        'Serbian Cyrillic' => '',
        'Serbian Latin' => '',
        'Service view' => '',
        'ServiceView' => '',
        'Set a new password by filling in your current password and a new one.' =>
            '',
        'Set sender email addresses for this system.' => '',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
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
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
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
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime before a prior warning will be visible for the logged in agents.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
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
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
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
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Shared Secret' => '',
        'Should the cache data be held in memory?' => '',
        'Should the cache data be stored in the selected cache backend?' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show queues even when only locked tickets are in.' => '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
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
        'Shows information on how to start OTRS Daemon' => '',
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
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
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
        'Simple' => 'Simples',
        'Skin' => '',
        'Slovak' => 'Eslovaco',
        'Slovenian' => 'Esloveno',
        'Software Package Manager.' => '',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Some description!' => '',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam' => '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Spanish' => 'Espanhol',
        'Spanish (Colombia)' => 'Espanhol (Colômbia)',
        'Spanish (Mexico)' => 'Espanhol (México)',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            '',
        'Specifies the different article types that will be used in the system.' =>
            '',
        'Specifies the different note types that will be used in the system.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            '',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
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
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies user id of the postmaster data base.' => '',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Spell checker.' => '',
        'Stable' => 'Estável',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Stat#',
        'Status view' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Support Agent' => '',
        'Swahili' => '',
        'Swedish' => 'Sueco',
        'System Address Display Name' => '',
        'System Maintenance' => '',
        'System Request (%s).' => 'Pedido de sistema',
        'Target' => '',
        'Templates <-> Queues' => '',
        'Textarea' => 'AreadeTexto',
        'Thai' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The daemon registration for the scheduler cron task manager.' =>
            '',
        'The daemon registration for the scheduler future task manager.' =>
            '',
        'The daemon registration for the scheduler generic agent task manager.' =>
            '',
        'The daemon registration for the scheduler task worker.' => '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'The value of the From field' => '',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            '',
        'This is a description for TimeZone on Customer side.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This module is part of the admin area of OTRS.' => '',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'This will allow the system to send text messages via SMS.' => '',
        'Ticket Close.' => '',
        'Ticket Compose Bounce Email.' => '',
        'Ticket Compose email Answer.' => '',
        'Ticket Customer.' => '',
        'Ticket Forward Email.' => '',
        'Ticket FreeText.' => '',
        'Ticket History.' => 'Histórico',
        'Ticket Lock.' => '',
        'Ticket Merge.' => '',
        'Ticket Move.' => '',
        'Ticket Note.' => '',
        'Ticket Notifications' => 'Notificações',
        'Ticket Outbound Email.' => '',
        'Ticket Owner.' => '',
        'Ticket Pending.' => '',
        'Ticket Print.' => '',
        'Ticket Priority.' => '',
        'Ticket Queue Overview' => 'Visão geral das filas de tickets',
        'Ticket Responsible.' => '',
        'Ticket Watcher' => '',
        'Ticket Zoom' => '',
        'Ticket Zoom.' => '',
        'Ticket bulk module.' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'Ticket movido para a fila "%s" (%s) da fila "%s" (%s).',
        'Ticket notifications' => 'Notificações',
        'Ticket overview' => 'Listagem de tickets',
        'Ticket plain view of an email.' => '',
        'Ticket title' => 'Título do ticket',
        'Ticket zoom view.' => '',
        'TicketNumber' => 'Número do ticket',
        'Tickets.' => 'Tickets.',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Title updated: Old: "%s", New: "%s"' => '',
        'To accept login information, such as an EULA or license.' => '',
        'To download attachments.' => 'Para descarregar anexos',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Transport selection for ticket notifications.' => '',
        'Tree view' => 'Vista em árvore',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '',
        'Turkish' => 'Turco',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Ukrainian' => 'Ucraniano',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => 'Ticket desbloqueado.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Updated SLA to %s (ID=%s).' => 'SLA atualizada para %s (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Serviço atualizado para %s (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'Atualizado tipo para %s (ID=%s).',
        'Updated: %s' => 'Atualizado: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Atualizado: %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'Upload your PGP key.' => '',
        'Upload your S/MIME certificate.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'UserFirstname' => 'Nome próprio do utilizador',
        'UserLastname' => 'Apelido do utilizador',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing ticket notification.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'Vietnam' => 'Vietnam',
        'View performance benchmark results.' => '',
        'Watch this ticket' => 'Ver este ticket',
        'Watched Tickets.' => 'Tickets vigiados',
        'We are performing scheduled maintenance.' => 'Manutenção agendada em curso.',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'Manutenção agendada em curso.
Não é possível autenticar-se neste moemento.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'Manutenção agendada em curso.
Devemos voltar a estar online dentro de momentos.',
        'Web View' => 'Vista web',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '',
        'Yes, but hide archived tickets' => 'Sim, esconder tickets arquivados',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            'A sua seleção de filas preferidas. Será também notificado por email se estiver ativado.',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '',
        'attachment' => 'anexo',
        'bounce' => '',
        'compose' => 'escrever',
        'debug' => 'depurar',
        'error' => 'erro',
        'forward' => 'seguinte',
        'info' => '',
        'inline' => '',
        'notice' => 'notícia',
        'pending' => 'pendente',
        'responsible' => 'responsável',
        'stats' => 'estatística',

    };
    # $$STOP$$
    return;
}

1;
