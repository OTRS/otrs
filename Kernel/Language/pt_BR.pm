# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2003 Gilberto Cezar de Almeida <gibalmeida at hotmail.com>
# Copyright (C) 2005 Alterado por Glaucia C. Messina (glauglauu@yahoo.com)
# Copyright (C) 2007-2010 Fabricio Luiz Machado <soprobr gmail.com>
# Copyright (C) 2010-2011 Murilo Moreira de Oliveira <murilo.moreira 60kg gmail.com>
# Copyright (C) 2013 Alexandre <matrixworkstation@gmail.com>
# Copyright (C) 2013-2014 Murilo Moreira de Oliveira <murilo.moreira 60kg gmail.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::Language::pt_BR;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Completeness}        = 0.915816836632673;

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
        'top' => 'topo',
        'end' => 'fim',
        'Done' => 'Feito',
        'Cancel' => 'Cancelar',
        'Reset' => 'Reiniciar',
        'more than ... ago' => 'há mais de ... atrás',
        'in more than ...' => 'em mais de ...',
        'within the last ...' => 'nos últimos ...',
        'within the next ...' => 'nos próximos ...',
        'Created within the last' => 'Criado no(s) último(s)',
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
        'month(s)' => 'mês(es)',
        'week' => 'semana',
        'week(s)' => 'semana(s)',
        'quarter' => 'trimestre',
        'quarter(s)' => 'trimestre(s)',
        'half-year' => 'semestre',
        'half-year(s)' => 'semestre(s)',
        'year' => 'ano',
        'years' => 'anos',
        'year(s)' => 'ano(s)',
        'second(s)' => 'segundo(s)',
        'seconds' => 'segundos',
        'second' => 'segundo',
        's' => 's',
        'Time unit' => 'Unidade de Tempo',
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
        '-none-' => '-vazio-',
        'none' => 'Vazio',
        'none!' => 'Vazio!',
        'none - answered' => 'vazio  - respondido',
        'please do not edit!' => 'Por favor, não edite!',
        'Need Action' => 'Ação requerida',
        'AddLink' => 'Adicionar Associação',
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
        'Username' => 'Usuário',
        'Language' => 'Idioma',
        'Languages' => 'Idiomas',
        'Password' => 'Senha',
        'Preferences' => 'Preferências',
        'Salutation' => 'Saudação',
        'Salutations' => 'Saudações',
        'Signature' => 'Assinatura',
        'Signatures' => 'Assinaturas',
        'Customer' => 'Cliente',
        'CustomerID' => 'ID do Cliente',
        'CustomerIDs' => 'IDs do Cliente',
        'customer' => 'cliente',
        'agent' => 'atendente',
        'system' => 'sistema',
        'Customer Info' => 'Informação do Cliente',
        'Customer Information' => 'Informação do Cliente',
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
        'Invalid Option!' => 'Opção Inválida!',
        'Invalid time!' => 'Horário Inválido',
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
        'before/after' => 'antes/após',
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
        'Show Tree Selection' => 'Mostrar Seleção de Árvore',
        'The field content is too long!' => 'O conteúdo deste campo é muito longo!',
        'Maximum size is %s characters.' => 'O tamanho máximo é %s caracteres.',
        'This field is required or' => 'Este campo é requerido ou',
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
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            'Autenticação feita com sucesso, mas não encontrado o cadastro do cliente no backend, Por favor contacte o administrador.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Este endereço de e-mail já existe. Por favor, faça login ou redefina sua senha',
        'Logout' => 'Sair',
        'Logout successful. Thank you for using %s!' => 'Logout com sucesso. Obrigado por utilizar %s!',
        'Feature not active!' => 'Funcionalidade não inativa!',
        'Agent updated!' => 'Agent atualizado!',
        'Database Selection' => 'Seleção de banco de dados',
        'Create Database' => 'Criar banco de dados',
        'System Settings' => 'Configurações de Sistema',
        'Mail Configuration' => 'Configuração de E-mail',
        'Finished' => 'Finalizado',
        'Install OTRS' => 'Instalar o OTRS',
        'Intro' => 'Introdução',
        'License' => 'Licença',
        'Database' => 'Banco de Dados',
        'Configure Mail' => 'Configurar E-mail',
        'Database deleted.' => 'Banco de dados apagado.',
        'Enter the password for the administrative database user.' => 'Digite uma senha para o usuário administrador do banco de dados.',
        'Enter the password for the database user.' => 'Digite uma senha para o usuário do banco de dados.',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Se você tiver configurado uma senha root paro seu banco de dados, ela deve ser introduzida aqui. Se não, deixe o campo em branco.',
        'Database already contains data - it should be empty!' => 'Banco de dados já contém dados - ele deve estar vazio!',
        'Login is needed!' => 'Nome de usuário é obrigatório!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'De momento não é possível fazer login devido a manutenção no sistema.',
        'Password is needed!' => 'Senha é obrigatória!',
        'Take this Customer' => 'Atenda este Cliente',
        'Take this User' => 'Atenda este Usuário',
        'possible' => 'possível',
        'reject' => 'rejeitar',
        'reverse' => 'reverso',
        'Facility' => 'Instalação',
        'Time Zone' => 'Fuso Horário',
        'Pending till' => 'Pendente até',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Por favor, não trabalhe com a conta de superusuário no OTRS! Crie novos atendentes e trabalhe com eles!',
        'Dispatching by email To: field.' => 'Distribuição por e-mail por campo: "Para:"',
        'Dispatching by selected Queue.' => 'Distribuição por Fila selecionada',
        'No entry found!' => 'Nenhuma entrada encontrada!',
        'Session invalid. Please log in again.' => 'Sessão inválida. Por favor, entre novamente.',
        'Session has timed out. Please log in again.' => 'A sessão expirou. Por favor, entre novamente.',
        'Session limit reached! Please try again later.' => 'Limite de sessão atingido! Por favor, tente novamente em alguns minutos.',
        'No Permission!' => 'Sem permissão!',
        '(Click here to add)' => '(Clique aqui para adicionar)',
        'Preview' => 'Pré-visualizar',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Pacote não instalado corretamente! Por favor, reinstale o pacote.',
        '%s is not writable!' => '%s é somente leitura!',
        'Cannot create %s!' => 'Não foi possível criar %s!',
        'Check to activate this date' => 'Marque para ativar esta data',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Você habilitou "Fora do Escritório", gostaria de desabilitar?',
        'News about OTRS releases!' => 'Notícias sobre lançamentos OTRS!',
        'Go to dashboard!' => 'Vá para o Painel de Controle',
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
        'Customer company added!' => 'Empresa de cliente adicionada!',
        'Customer company updated!' => 'Empresa de cliente atualizada!',
        'Note: Company is invalid!' => 'Nota: Empresa inválida!',
        'Mail account added!' => 'Conta de e-mail adicionada!',
        'Mail account updated!' => 'Conta de e-mail atualizada!',
        'System e-mail address added!' => 'Endereço de e-mail do sistema adicionado!',
        'System e-mail address updated!' => 'Endereço de e-mail do sistema atualizado!',
        'Contract' => 'Contrato',
        'Online Customer: %s' => 'Clientes Online: %s',
        'Online Agent: %s' => 'Atendentes Online: %s',
        'Calendar' => 'Calendário',
        'File' => 'Arquivo',
        'Filename' => 'Nome do arquivo',
        'Type' => 'Tipo',
        'Size' => 'Tamanho',
        'Upload' => 'Enviar',
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
        'Fax' => 'Fax',
        'Mobile' => 'Celular',
        'Zip' => 'CEP',
        'City' => 'Cidade',
        'Street' => 'Rua',
        'Country' => 'País',
        'Location' => 'Localização',
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
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'Informação da ACL no banco de dados não está sincronizada com a configuração do sistema, por favor implemente todas as ACLs.',
        'printed at' => 'impresso em',
        'Loading...' => 'Carregando...',
        'Dear Mr. %s,' => 'Caro Sr. %s,',
        'Dear Mrs. %s,' => 'Cara Sra. %s,',
        'Dear %s,' => 'Caro %s,',
        'Hello %s,' => 'Olá %s,',
        'This email address is not allowed to register. Please contact support staff.' =>
            'O endereço de email não é permitido para cadastro. Por favor entre em contato com a equipe de suporte.',
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
        'Shown customer users' => 'Usuários clientes exibidos',
        'News' => 'Notícias',
        'Product News' => 'Notícias do Produto',
        'OTRS News' => 'Notícias sobre o OTRS',
        '7 Day Stats' => 'Estatísticas (7 Dias)',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'As Informações do Gerenciamento de Processo do banco de dados não estão sincronizadas com as configurações do sistema, por favor, sincronize todos os processos.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'O pacote não foi verificado pelo Grupo OTRS! O seu uso não é recomendado.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br>Se você continuar a instalação desse pacote, os seguintes erros podem ocorrer!<br><br>&nbsp;-Problemas de segurança<br>&nbsp;-`Problemas de estabilidade<br>&nbsp;-Problemas de performance<br><br>Por favor, note que todos os erros causado por trabalhar com esse pacote são serão cobertos pelos Contratos de Serviços!<br><br>',
        'Mark' => 'Marcar',
        'Unmark' => 'Desmarcar',
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
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Desfazer',
        'Redo' => 'Refazer',
        'OTRS Daemon is not running.' => 'OTRS Daemon não esta executando',
        'Can\'t contact registration server. Please try again later.' => 'Não é possível contatar o servidor de registro. Por favor, tente novamente mais tarde.',
        'No content received from registration server. Please try again later.' =>
            'Nenhum conteúdo recebido do servidor de registro. Por favor, tente novamente mais tarde.',
        'Problems processing server result. Please try again later.' => 'Problemas ao processar o resultado do servidor. Por favor, tente novamente mais tarde.',
        'Username and password do not match. Please try again.' => 'Usuário e senha não coincidem. Por favor, tente novamente mais tarde.',
        'The selected process is invalid!' => 'O processo selecionado é inválido!',
        'Upgrade to %s now!' => 'Atualize para %s agora!',
        '%s Go to the upgrade center %s' => '%s Ir para o centro de atualização %s',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'A licença do seu %s está prestes a expirar. Por favor entre em contato com %s para revonar o seu contrato!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'Uma atualização para o seu %s está disponível, porém existe um conflito com a versão do seu framework! Por favor em primeiro lugar atualize o seu framework!',
        'Your system was successfully upgraded to %s.' => 'Seu sistema foi atualizado com sucesso para %s.',
        'There was a problem during the upgrade to %s.' => 'Ocorreu um problema durante a atualização para %s.',
        '%s was correctly reinstalled.' => '%s foi corretamente instalado.',
        'There was a problem reinstalling %s.' => 'Houve um problema ao reinstalar %s.',
        'Your %s was successfully updated.' => 'Seu %s foi atualizado com sucesso.',
        'There was a problem during the upgrade of %s.' => 'Houve um problema durante a atualização de %s.',
        '%s was correctly uninstalled.' => '%s foi corretamente desinstalado.',
        'There was a problem uninstalling %s.' => 'Houve um problema ao desinstalar %s.',
        'Enable cloud services to unleash all OTRS features!' => 'Habilite serviços de nuvem para liberar todos os recursos do OTRS!',

        # Template: AAACalendar
        'New Year\'s Day' => 'Ano Novo',
        'International Workers\' Day' => 'Dia Internacional do Trabalho',
        'Christmas Eve' => 'Véspera de Natal',
        'First Christmas Day' => 'Primeiro dia de Natal',
        'Second Christmas Day' => 'Segundo dia de Natal',
        'New Year\'s Eve' => 'Véspera de Ano Novo',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS como requisitante',
        'OTRS as provider' => 'OTRS como provedor',
        'Webservice "%s" created!' => 'Webservice "%s" criado!',
        'Webservice "%s" updated!' => 'Webservice "%s" atualizado!',

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
        'User Profile' => 'Perfil do Usuário',
        'Email Settings' => 'Configurações de E-mail',
        'Other Settings' => 'Outras Configurações',
        'Notification Settings' => 'Configurações de notificação',
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
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Não é possível atualizar a senha. Ela deve conter pelo menos 2 caracteres minúsculos e 2 maiúsculos!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Não é possível atualizar a senha. Ela deve conter pelo menos 1 número!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Não é possível atualizar a senha. Ela deve conter pelo menos 2 caracteres!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Não é possível atualizar a senha. Essa senha já foi utilizada. Por favor, escolha outra!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Selecione o caractere separador usado em arquivos CSV (estatísticas e pesquisas). Se você não selecionar um separador aqui, o separador padrão para o seu idioma será usado.',
        'CSV Separator' => 'Separador CSV',

        # Template: AAATicket
        'Status View' => 'Visão de Estados',
        'Service View' => 'Visão de Serviços',
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
        'Priority added!' => 'Prioridade adicionada!',
        'Priority updated!' => 'Prioridade atualizada!',
        'Signature added!' => 'Assinatura adicionada!',
        'Signature updated!' => 'Assinatura atualizada!',
        'SLA' => 'SLA',
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
        'Email' => 'E-mail',
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
        'All tickets' => 'Todos os Chamados',
        'Available tickets' => 'Chamados Disponíveis',
        'Escalation' => 'Escalação',
        'last-search' => 'Última-Pesquisa',
        'QueueView' => 'Fila',
        'Ticket Escalation View' => 'Visão de Escalação de Chamados',
        'Message from' => 'Mensagem de',
        'End message' => 'Fim da mensagem',
        'Forwarded message from' => 'Mensagem encaminhada de',
        'End forwarded message' => 'Fim da mensagem encaminhada',
        'Bounce Article to a different mail address' => 'Devolver artigo para um endereço de e-mail diferente',
        'Reply to note' => 'Responder a nota',
        'new' => 'novo',
        'open' => 'aberto',
        'Open' => 'Aberto',
        'Open tickets' => 'Chamados abertos',
        'closed' => 'fechado',
        'Closed' => 'Fechado',
        'Closed tickets' => 'Chamados Fechados',
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
        'sms' => 'SMS',
        'webrequest' => 'chamado web',
        'lock' => 'bloqueado',
        'unlock' => 'desbloqueado',
        'very low' => 'muito baixo',
        'low' => 'baixo',
        'normal' => 'normal',
        'high' => 'alto',
        'very high' => 'muito alto',
        '1 very low' => '1 Muito Baixo',
        '2 low' => '2 Baixo',
        '3 normal' => '3 Normal',
        '4 high' => '4 Alto',
        '5 very high' => '5 Muito Alto',
        'auto follow up' => 'Autorrevisão',
        'auto reject' => 'Autorrejeitar',
        'auto remove' => 'Autorremover',
        'auto reply' => 'Autorresponder',
        'auto reply/new ticket' => 'Autorresposta/novo chamado',
        'Create' => 'Criar',
        'Answer' => 'Responder',
        'Phone call' => 'Chamada telefônica',
        'Ticket "%s" created!' => 'Chamado "%s" criado!',
        'Ticket Number' => 'Número do Chamado',
        'Ticket Object' => 'Objeto do Chamado',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Não existe o chamado "%s"! Não é possível associá-lo!',
        'You don\'t have write access to this ticket.' => 'Você não tem permissão de escrita neste chamado.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Desculpe, você precisa ser o proprietário do chamado para executar esta ação.',
        'Please change the owner first.' => 'Por favor, altere o proprietário primeiro.',
        'Ticket selected.' => 'Chamado selecionado.',
        'Ticket is locked by another agent.' => 'Chamado travado por outro atendente.',
        'Ticket locked.' => 'Chamado bloqueado.',
        'Don\'t show closed Tickets' => 'Não mostrar chamados fechados',
        'Show closed Tickets' => 'Mostrar chamados fechados',
        'New Article' => 'Novo Artigo',
        'Unread article(s) available' => 'Artigo(s) Não Lido(s) Disponível(is)',
        'Remove from list of watched tickets' => 'Remover da lista de chamados monitorados',
        'Add to list of watched tickets' => 'Adicionar à Lista de Chamados Monitorados',
        'Email-Ticket' => 'Chamado E-mail',
        'Create new Email Ticket' => 'Criar Novo Chamado via E-mail',
        'Phone-Ticket' => 'Chamado Fone',
        'Search Tickets' => 'Pesquisar Chamados',
        'Customer Realname' => 'Nome real do cliente',
        'Customer History' => 'Histórico do Cliente',
        'Edit Customer Users' => 'Editar Usuários Clientes',
        'Edit Customer' => 'Alterar Cliente',
        'Bulk Action' => 'Ação em Massa',
        'Bulk Actions on Tickets' => 'Ações em massa em chamados',
        'Send Email and create a new Ticket' => 'Enviar e-mail e criar novo chamado',
        'Create new Email Ticket and send this out (Outbound)' => 'Criar novo chamado via e-mail e enviá-lo (Saída)',
        'Create new Phone Ticket (Inbound)' => 'Criar Novo Chamado Fone (Entrada)',
        'Address %s replaced with registered customer address.' => 'Endereço %s substituído pelo endereço cadastrado do cliente.',
        'Customer user automatically added in Cc.' => 'Cliente automaticamente adicionado no Cc.',
        'Overview of all open Tickets' => 'Visão Geral de Todos os Chamados Abertos',
        'Locked Tickets' => 'Chamados Bloqueados',
        'My Locked Tickets' => 'Meus Chamados Bloqueados',
        'My Watched Tickets' => 'Meus Chamados Monitorados',
        'My Responsible Tickets' => 'Chamados na Minha Responsabilidade',
        'Watched Tickets' => 'Chamados Monitorados',
        'Watched' => 'Monitorados',
        'Watch' => 'Monitorar',
        'Unwatch' => 'Não monitorar',
        'Lock it to work on it' => 'Bloquear para trabalhar no chamado',
        'Unlock to give it back to the queue' => 'Desbloquear para devolver à fila',
        'Show the ticket history' => 'Mostrar histórico do chamado',
        'Print this ticket' => 'Imprimir este chamado',
        'Print this article' => 'Imprimir este artigo',
        'Split' => 'Dividir',
        'Split this article' => 'Dividir este artigo',
        'Forward article via mail' => 'Encaminhar artigo por e-mail',
        'Change the ticket priority' => 'Alterar prioridade do chamado',
        'Change the ticket free fields!' => 'Alterar os campos em branco no chamado!',
        'Link this ticket to other objects' => 'Vincular este chamado a outros objetos',
        'Change the owner for this ticket' => 'Alterar o dono deste chamado',
        'Change the  customer for this ticket' => 'Alterar o cliente deste chamado',
        'Add a note to this ticket' => 'Adicionar uma nota a este chamado',
        'Merge into a different ticket' => 'Mesclar com um chamado diferente',
        'Set this ticket to pending' => 'Marcar chamado como pendente',
        'Close this ticket' => 'Fechar este Chamado',
        'Look into a ticket!' => 'Examinar em detalhes o conteúdo de um chamado!',
        'Delete this ticket' => 'Apagar este chamado',
        'Mark as Spam!' => 'Marque como Spam',
        'My Queues' => 'Minhas Filas',
        'Shown Tickets' => 'Chamados Exibidos',
        'Shown Columns' => 'Colunas Exibidas',
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
        'New ticket notification' => 'Notificação de Novos Chamados',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Envie-me uma notificação se há um novo chamado em "Minhas Filas".',
        'Send new ticket notifications' => 'Enviar notificações de novos chamados',
        'Ticket follow up notification' => 'Notificação de Revisão de Chamados',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Notifique-me se um cliente enviar uma revisão e eu sou o proprietário do chamado ou o chamado está desbloqueado e está em uma de minhas filas monitoradas.',
        'Send ticket follow up notifications' => 'Enviar notificações de revisão de chamados',
        'Ticket lock timeout notification' => 'Notificação de Expiração de Bloqueio de Chamado',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Notifique-me se um chamado é desbloqueado pelo sistema.',
        'Send ticket lock timeout notifications' => 'Enviar notificações de expiração de bloqueio de chamado',
        'Ticket move notification' => 'Notificação de Movimentação de Chamados',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Notifique-me se chamados forem movimentados para "Minhas Filas"',
        'Send ticket move notifications' => 'Enviar notificações de movimentação de chamados',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Sua seleção de filas favoritas. Você também é notificado sobre essas filas por e-mail se habilitado.',
        'Custom Queue' => 'Fila Personalizada',
        'QueueView refresh time' => 'Tempo de atualização das filas',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Se habilitado, a tela de filas será automaticamente atualizada após o tempo especificado.',
        'Refresh QueueView after' => 'Atualizar a tela de filas após',
        'Screen after new ticket' => 'Tela Após Novo Chamado',
        'Show this screen after I created a new ticket' => 'Mostre esta tela após criar um novo chamado',
        'Closed Tickets' => 'Chamados Fechados',
        'Show closed tickets.' => 'Mostrar chamados fechados.',
        'Max. shown Tickets a page in QueueView.' => 'Máximo de chamados apresentados por página.',
        'Ticket Overview "Small" Limit' => 'Limite Para a Visão de Chamados "Pequeno"',
        'Ticket limit per page for Ticket Overview "Small"' => 'Limite por página para a visão de chamados "Pequeno".',
        'Ticket Overview "Medium" Limit' => 'Limite Para a Visão de Chamados "Médio"',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Limite por página para a visão de chamados "Médio".',
        'Ticket Overview "Preview" Limit' => 'Limite para "Pré-Visualização" da Visão Geral de Chamados',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Limite por página para a visão de chamados "Pré-Visualização".',
        'Ticket watch notification' => 'Notificação de Chamados Monitorados',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Envie-me as mesmas notificações para os meus chamados monitorados que os proprietários dos chamados receberão.',
        'Send ticket watch notifications' => 'Enviar notificações de chamados monitorados',
        'Out Of Office Time' => 'Período Fora do Escritório',
        'New Ticket' => 'Novo Chamado',
        'Create new Ticket' => 'Criar novo Chamado',
        'Customer called' => 'O cliente telefonou',
        'phone call' => 'Chamada telefônica',
        'Phone Call Outbound' => 'Chamada Telefônica Realizada',
        'Phone Call Inbound' => 'Chamada Telefônica Recebida',
        'Reminder Reached' => 'Lembrete Expirado',
        'Reminder Tickets' => 'Chamados com Lembrete',
        'Escalated Tickets' => 'Chamados Escalados',
        'New Tickets' => 'Chamados Novos',
        'Open Tickets / Need to be answered' => 'Chamados Abertos / Precisam ser Respondidos',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Todos os chamados abertos, estes chamados já foram trabalhados, mas precisam de uma resposta',
        'All new tickets, these tickets have not been worked on yet' => 'Todos os chamados novos, estes chamados não foram trabalhados ainda',
        'All escalated tickets' => 'Todos os chamados escalados',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Todos os chamados com lembrete cujas datas de lembrete expiraram',
        'Archived tickets' => 'Chamados arquivados',
        'Unarchived tickets' => 'Chamados não-arquivados',
        'Ticket Information' => 'Informação do Chamado',
        'including subqueues' => 'incluindo subfilas',
        'excluding subqueues' => 'excluindo subfilas',

        # Template: AAAWeekDay
        'Sun' => 'Dom',
        'Mon' => 'Seg',
        'Tue' => 'Ter',
        'Wed' => 'Qua',
        'Thu' => 'Qui',
        'Fri' => 'Sex',
        'Sat' => 'Sab',

        # Template: AdminACL
        'ACL Management' => 'Gerenciamento de ACL',
        'Filter for ACLs' => 'Filtrar por ACLs',
        'Filter' => 'Filtro',
        'ACL Name' => 'Nome da ACL',
        'Actions' => 'Ações',
        'Create New ACL' => 'Criar nova ACL',
        'Deploy ACLs' => 'Implementar ACLs',
        'Export ACLs' => 'Exportar ACLs',
        'Configuration import' => 'Importar configuração',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Aqui você pode fazer o envio de um arquivo de configuração para importar ACLs para o seu sistema. O arquivo precisa estar no formato .yml como exportado pelo módulo de edição de ACL.',
        'This field is required.' => 'Este campo é obrigatório.',
        'Overwrite existing ACLs?' => 'Sobrescrever ACLs existentes?',
        'Upload ACL configuration' => 'Upload configuração de ACL',
        'Import ACL configuration(s)' => 'Importar configuração(ões) de ACL',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Para criar uma nova ACL, você pode importar ACLs que foram exportadas de outro sistema ou criar uma completamente nova.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Mudanças nas ACLs apenas afetam o comportamento do sistema se você implementar a ACL na sequência. Implementando a ACL, as alterações realizadas recentemente serão gravadas na configuração.',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Por favor note: Esta tabela representa a ordem de execução das ACLs. Se você precisa mudar a ordem em que as ACLs são executadas, por favor mude os nomes das ACLs afetadas.',
        'ACL name' => 'Nome ACL',
        'Validity' => 'Validade',
        'Copy' => 'Copiar',
        'No data found.' => 'Nenhum dado encontrado.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Editar ACL %s',
        'Go to overview' => 'Ir Para Visão Geral',
        'Delete ACL' => 'Excluir ACL',
        'Delete Invalid ACL' => 'Excluir ACL Inválida',
        'Match settings' => 'Configurações de casamento',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Configure critérios de casamento para esta ACL. Use \'Properties\ para casar na tela atual ou \'PropertiesDatabase\' para casar atributos do chamado atual que está armazenado no banco de dados.',
        'Change settings' => 'Configurações de alteração',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Configure o que você quer alterar se o critério casar. Mantenha em mente que \'Possible\' é uma lista branca e \'PossibleNot\', uma lista negra.',
        'Check the official' => 'Verifique a oficial',
        'documentation' => 'documentação',
        'Show or hide the content' => 'Mostrar ou esconder o conteúdo',
        'Edit ACL information' => 'Editar a informação da ACL',
        'Stop after match' => 'Parar Após Encontrar',
        'Edit ACL structure' => 'Editar estrutura da ACL',
        'Save ACL' => 'Salvar ACL',
        'Save' => 'Salvar',
        'or' => 'ou',
        'Save and finish' => 'Salvar e Finalizar',
        'Do you really want to delete this ACL?' => 'Você quer realmente excluir esta ACL?',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Este item já contém subitens. Você tem certeza que quer remover este item incluindo seus subitens?',
        'An item with this name is already present.' => 'Um item com o mesmo nome já está presente.',
        'Add all' => 'Adicionar todos',
        'There was an error reading the ACL data.' => 'Houve um erro ao ler os dados da ACL.',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Crie uma nova ACL submetendo os dados do formulário. Após criar a ACL, você será capaz de adicionar itens de configuração no modo de edição.',

        # Template: AdminAttachment
        'Attachment Management' => 'Gerenciamento de Anexos',
        'Add attachment' => 'Adicionar Anexo',
        'List' => 'Lista',
        'Download file' => 'Baixar arquivo',
        'Delete this attachment' => 'Deletar este anexo',
        'Do you really want to delete this attachment?' => 'Deseja realmente excluir este anexo?',
        'Add Attachment' => 'Adicionar Anexo',
        'Edit Attachment' => 'Alterar Anexo',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Administração de Autorrespostas',
        'Add auto response' => 'Adicionar Autorresposta',
        'Add Auto Response' => 'Adicionar Autorresposta',
        'Edit Auto Response' => 'Alterar Autorresposta',
        'Response' => 'Resposta',
        'Auto response from' => 'Autorresposta de',
        'Reference' => 'Referência',
        'You can use the following tags' => 'Você pode usar os seguintes rótulos',
        'To get the first 20 character of the subject.' => 'Para obter os primeiros 20 caracteres do assunto.',
        'To get the first 5 lines of the email.' => 'Para obter as primeiras 5 linhas do e-mail.',
        'To get the name of the ticket\'s customer user (if given).' => 'Para obter o nome do usuário cliente do chamado (se fornecido).',
        'To get the article attribute' => 'Para obter o atributo do artigo',
        ' e. g.' => 'ex.',
        'Options of the current customer user data' => 'Opções para os dados do atual usuário cliente',
        'Ticket owner options' => 'Opções do proprietário do chamado',
        'Ticket responsible options' => 'Opções do responsável pelo chamado',
        'Options of the current user who requested this action' => 'Opções do usuário atual que solicitou a ação',
        'Options of the ticket data' => 'Opções dos dados do chamado',
        'Options of ticket dynamic fields internal key values' => 'Opções de valores internos de campos dinâmicos de chamados',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Opções de exibição de valores de campos dinâmicos de chamados, úteis para campos Dropdown e Multisseleção',
        'Config options' => 'Opções de Configuração',
        'Example response' => 'Resposta de exemplo',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Gestão de Serviço de Nuvem',
        'Support Data Collector' => 'Coletor de dados para suporte',
        'Support data collector' => 'Coletor de dados para suporte',
        'Hint' => 'Dica',
        'Currently support data is only shown in this system.' => 'Atualmente, dados de suporte só são exibidos neste sistema.',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'É altamente recomendado enviar estes dados para o grupo OTRS de forma a obter um melhor suporte.',
        'Configuration' => 'Configuração',
        'Send support data' => 'Enviar dados de suporte',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Isto permitirá ao sistema enviar informações adicionais de suporte ao Grupo OTRS.',
        'System Registration' => 'Registro do Sistema',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Para habilitar o envio de dados, por favor registre seu sistema no Grupo OTRS ou atualize a informação de registro de seu sistema (tenha certeza de ativar a opção \'enviar dados de suporte\').',
        'Register this System' => 'Registrar este Sistema',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'O registro de sistema está desabilitado para o seu sistema. Por favor verifique sua configuração.',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'Registro do sistema é um serviço do Grupo OTRS que fornece muitas vantagens!',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            'Por favor, note que o uso dos serviços em nuvem do OTRS requerem que o sistema esteja registrado.',
        'Register this system' => 'Registrar o sistema',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Aqui você pode configurar os serviços de nuvem disponíveis que se comunicam de forma segura com %s.',
        'Available Cloud Services' => 'Serviços de nuvem disponíveis',
        'Upgrade to %s' => 'Atualize para %s',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Gerenciamento de Entidade',
        'Wildcards like \'*\' are allowed.' => 'Coringas como \'*\' são permitidos.',
        'Add customer' => 'Adicionar Cliente',
        'Select' => 'Selecionar',
        'List (only %s shown - more available)' => 'Listar(somente %s mostrado - mais disponível)',
        'List (%s total)' => 'Listar (%s total)',
        'Please enter a search term to look for customers.' => 'Por favor, insira um termo de pesquisa para procurar clientes.',
        'Add Customer' => 'Adicionar Cliente',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Gerenciamento de Usuário Cliente',
        'Back to search results' => 'Voltar ao resultado da busca',
        'Add customer user' => 'Adicionar usuário cliente',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Usuário cliente é necessário para ter um histórico de cliente e para logar via interface de cliente.',
        'Last Login' => 'Última Autenticação',
        'Login as' => 'Logar-se como',
        'Switch to customer' => 'Trocar para cliente',
        'Add Customer User' => 'Adicionar Cliente',
        'Edit Customer User' => 'Editar Usuário Cliente',
        'This field is required and needs to be a valid email address.' =>
            'Este campo é obrigatório e deve ser um endereço de e-mail válido.',
        'This email address is not allowed due to the system configuration.' =>
            'Este endereço de e-mail não é permitido devido à configuração do sistema.',
        'This email address failed MX check.' => 'Para este endereço de e-mail, o teste MX falhou.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problema de DNS, por favor, verifique sua configuração e o log de erros.',
        'The syntax of this email address is incorrect.' => 'A sintaxe deste endereço de e-mail está incorreta.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Gerenciar Relações Clientes-Grupos',
        'Notice' => 'Aviso',
        'This feature is disabled!' => 'Esta funcionalidade está desabilitada!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Utilize esta funcionalidade apenas se desejar definir permissões de grupo para os clientes.',
        'Enable it here!' => 'Habilite-a aqui!',
        'Edit Customer Default Groups' => 'Editar os grupos-padrão para clientes',
        'These groups are automatically assigned to all customers.' => 'Estes grupos serão atribuídos automaticamente a todos os clientes.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Você pode gerenciar estes grupos através do parâmetro de configuração "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filtrar por Grupos',
        'Just start typing to filter...' => 'Basta começar a digitar para filtrar... ',
        'Select the customer:group permissions.' => 'Selecione as permissões cliente:grupo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Se nada for selecionado, então não há permissões nesse grupo (chamados não estarão disponíveis para o cliente).',
        'Search Results' => 'Resultado da Pesquisa',
        'Customers' => 'Clientes',
        'No matches found.' => 'Nenhum resultado encontrado.',
        'Groups' => 'Grupos',
        'Change Group Relations for Customer' => 'Alterar as Relações de Grupo para o Cliente',
        'Change Customer Relations for Group' => 'Alterar as Relações de Cliente para o Grupo',
        'Toggle %s Permission for all' => 'Chavear a Permissão %s para todos',
        'Toggle %s permission for %s' => 'Chavear a permissão %s para %s',
        'Customer Default Groups:' => 'Grupos-padrão para clientes:',
        'No changes can be made to these groups.' => 'Nenhuma alteração pode ser feita a estes grupos.',
        'ro' => 'Somente Leitura',
        'Read only access to the ticket in this group/queue.' => 'Acesso somente leitura de chamados neste grupo/fila.',
        'rw' => 'Leitura E Escrita',
        'Full read and write access to the tickets in this group/queue.' =>
            'Acesso de leitura e escrita de chamados neste grupo/fila.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Gerenciar Relações Clientes-Serviços',
        'Edit default services' => 'Alterar Serviços-Padrão',
        'Filter for Services' => 'Filtrar por Serviços',
        'Allocate Services to Customer' => 'Alocar Serviços Para Clientes',
        'Allocate Customers to Service' => 'Alocar Clientes Para Serviços',
        'Toggle active state for all' => 'Chavear estado ativo para todos',
        'Active' => 'Ativo',
        'Toggle active state for %s' => 'Chavear estado ativo para %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Gerenciamento de Campos Dinâmicos',
        'Add new field for object' => 'Adicionar novo campo ao objeto',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Para adicionar um novo campo, selecione o tipo de campo em uma das listas de objetos. O objeto define o domínio do campo e não pode ser alterado após a criação.',
        'Dynamic Fields List' => 'Lista de Campos Dinâmicos',
        'Dynamic fields per page' => 'Campos dinâmicos por página',
        'Label' => 'Campo',
        'Order' => 'Ordem',
        'Object' => 'Objeto',
        'Delete this field' => 'Remover este campo',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Deseja realmente remover este campo dinâmico? TODOS os dados assiciados a ele serão PERDIDOS!',
        'Delete field' => 'Removar campo',
        'Deleting the field and its data. This may take a while...' => 'Delindo o campo e seus dados.  Isto pode levar um tempo…',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Campos Dinâmicos',
        'Field' => 'Campo',
        'Go back to overview' => 'Ir Para Visão Geral',
        'General' => 'Geral',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Este campo é obrigatório e o valor deve ser composto apenas por caracteres alfabéticos e numéricos.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Deve ser único e só aceitar caracteres alfabéticos e numéricos.',
        'Changing this value will require manual changes in the system.' =>
            'Alterar este valor demandará alterações manuais no sistema.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Este é o nome a ser exibido nas telas onde o campo estará ativo.',
        'Field order' => 'Ordem do Campo',
        'This field is required and must be numeric.' => 'Este campo é obrigatório e deve ser numérico.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Esta é a ordem na qual este campo será exibido nas telas onde ele estará ativo.',
        'Field type' => 'Tipo do Campo',
        'Object type' => 'Tipo do Objeto',
        'Internal field' => 'Campo Interno',
        'This field is protected and can\'t be deleted.' => 'Este campo é protegido e não poderá ser apagado.',
        'Field Settings' => 'Configurações do Campo',
        'Default value' => 'Valor Padrão',
        'This is the default value for this field.' => 'Este é o valor padrão para este campo.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Diferença de Tempo Padrão',
        'This field must be numeric.' => 'Este campo deve ser numérico.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'A diferença de AGORA (em segundos) para calcular o valor padrão do campo (ex. 3600 ou -60).',
        'Define years period' => 'Definir Período Anual',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Ative este recurso para definir uma faixa fixa de anos (no futuro e no passado) para exibir na parte anual do campo.',
        'Years in the past' => 'Anos No Passado',
        'Years in the past to display (default: 5 years).' => 'Anos no Passado à Exibir (padrão: 5 anos).',
        'Years in the future' => 'Anos no Futuro',
        'Years in the future to display (default: 5 years).' => 'Anos no Futuro à Exibir (padrão: 5 anos).',
        'Show link' => 'Mostrar Link',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Aqui você pode especificar um link HTTP para o valor deste campo nas telas de Visão Geral e Detalhamento.',
        'Link for preview' => 'Ligação para prever',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'Se preenchido, usar-se-á este URI para prever quando se sobrevoa este vínculo na majoração do chamado.  Por favor note que para isto funcionar, deve-se preencher também o campo URI comum acima.',
        'Restrict entering of dates' => 'Restringir entrada de datas',
        'Here you can restrict the entering of dates of tickets.' => 'Aqui você pode restringir a entrada de datas de tickets.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Valores Possíveis',
        'Key' => 'Chave',
        'Value' => 'Valor',
        'Remove value' => 'Remover Valor',
        'Add value' => 'Adicionar Valor',
        'Add Value' => 'Adicionar Valor',
        'Add empty value' => 'Adicionar Valor Vazio',
        'Activate this option to create an empty selectable value.' => 'Ative essa opção para criar um valor vazio selecionável.',
        'Tree View' => 'Árvore',
        'Activate this option to display values as a tree.' => 'Ativar esta opção para exibir valores como uma árvore.',
        'Translatable values' => 'Valores Traduzíveis',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Se você ativar esta opção, os valores serão traduzidos para o idioma definido pelo usuário.',
        'Note' => 'Nota',
        'You need to add the translations manually into the language translation files.' =>
            'Você precisa adicionar as traduções manualmente nos arquivos de tradução.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Número de Linhas',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Especificar a altura (em linhas) para este campo no modo de edição.',
        'Number of cols' => 'Número de Colunas',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Especificar a largura (em caracteres) para este campo no modo de edição.',
        'Check RegEx' => 'Verifique a expressão regular',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Aqui você pode especificar uma expressão regular para validar o valor. A expressão regular será executada com os modificadores xms.',
        'RegEx' => 'Expressão Regular',
        'Invalid RegEx' => 'Expressão Regular Inválida',
        'Error Message' => 'Mensagem de Erro',
        'Add RegEx' => 'Adicionar Expressão Regular',

        # Template: AdminEmail
        'Admin Notification' => 'Notificação Administrativa',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Este módulo permite aos administradores enviar mensagens para os atendentes, membros de grupo ou papel.',
        'Create Administrative Message' => 'Criar Notificação Administrativa',
        'Your message was sent to' => 'Sua mensagem foi enviada para',
        'Send message to users' => 'Enviar Mensagem Para Usuários',
        'Send message to group members' => 'Enviar Mensagem Para Membros de Grupo',
        'Group members need to have permission' => 'Membros de Grupo Precisam ter Permissão',
        'Send message to role members' => 'Enviar Mensagem Para Membros de Papel',
        'Also send to customers in groups' => 'Enviar também para clientes nos grupos',
        'Body' => 'Corpo',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Atendente Genérico',
        'Add job' => 'Adicionar Tarefa',
        'Last run' => 'Última Execução',
        'Run Now!' => 'Executar Agora',
        'Delete this task' => 'Excluir esta Tarefa',
        'Run this task' => 'Executar esta Tarefa',
        'Do you really want to delete this task?' => 'Você realmente deseja excluir essa tarefa?',
        'Job Settings' => 'Configurações de Tarefa',
        'Job name' => 'Tarefa',
        'The name you entered already exists.' => 'O nome digitado já existe.',
        'Toggle this widget' => 'Chavear este dispositivo',
        'Automatic execution (multiple tickets)' => 'Execução automática (chamados múltiplos)',
        'Execution Schedule' => 'Agenda de execução',
        'Schedule minutes' => 'Minutos Agendados',
        'Schedule hours' => 'Horas Agendadas',
        'Schedule days' => 'Dias Agendados',
        'Currently this generic agent job will not run automatically.' =>
            'Atualmente, essa tarefa do atendente genérico não será executado automaticamente.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Para habilitar a execução automática, selecione pelo menos um valor de minutos, horas e dias!',
        'Event based execution (single ticket)' => 'Execução baseada em Evento (chamado simples)',
        'Event Triggers' => 'Disparadores de evento',
        'List of all configured events' => 'Lista de todos os eventos configurados',
        'Delete this event' => 'Excluir este evento',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Adicionalmente ou alternativamente para uma execução períodica, você pode definir eventos de chamado que irão disparar esta tarefa.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Se um evento de chamado é disparado, o filtro de chamado será aplicado para verificar se o chamado combina. Só depois a tarefa é executada sobre o chamado.',
        'Do you really want to delete this event trigger?' => 'Você quer realmente excluir este disparador de evento?',
        'Add Event Trigger' => 'Adicionar disparador de evento',
        'Add Event' => 'Adicionar Evento',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Para adicionar um novo evento, selecione um objeto de evento e um nome e clique no botão "+"',
        'Duplicate event.' => 'Duplicar evento.',
        'This event is already attached to the job, Please use a different one.' =>
            'Este evento já está associado a uma tarefa, por favor use um diferente.',
        'Delete this Event Trigger' => 'Excluir este disparador de evento',
        'Remove selection' => 'Remover tradução',
        'Select Tickets' => 'Selecionar Chamados',
        '(e. g. 10*5155 or 105658*)' => '(ex.: 10*5155 ou 105658*)',
        '(e. g. 234321)' => '(ex.: email@empresa.com.br)',
        'Customer user' => 'Usuário cliente',
        '(e. g. U5150)' => '(ex.: 12345654321)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Pesquisa textual completa no artigo (ex. "Mur*lo" ou "Gleyc*").',
        'Agent' => 'Atendente',
        'Ticket lock' => 'Chamado bloqueado',
        'Create times' => 'Horários de criação',
        'No create time settings.' => 'Ignorar horários de criação',
        'Ticket created' => 'Chamado criado',
        'Ticket created between' => 'Chamado criado entre',
        'Last changed times' => 'Última alteração',
        'No last changed time settings.' => 'Nenhuma configuração de horário alterado restante.',
        'Ticket last changed' => 'Última edição do chamado',
        'Ticket last changed between' => 'Última alteração do chamado entre',
        'Change times' => 'Horários de alteração',
        'No change time settings.' => 'Ignorar horários de alteração.',
        'Ticket changed' => 'Chamado alterado',
        'Ticket changed between' => 'Chamado alterado entre',
        'Close times' => 'Horários de fechamento',
        'No close time settings.' => 'Ignorar horários de fechamento',
        'Ticket closed' => 'Chamado fechado',
        'Ticket closed between' => 'Chamado fechado entre',
        'Pending times' => 'Horários pendentes',
        'No pending time settings.' => 'Sem configuração de horário pendente',
        'Ticket pending time reached' => 'Prazo de chamado pendente expirado',
        'Ticket pending time reached between' => 'Prazo de chamado pendente expirado entre',
        'Escalation times' => 'Prazos de escalação',
        'No escalation time settings.' => 'Sem configuração de prazo de escalação',
        'Ticket escalation time reached' => 'Prazos de escalações expirado',
        'Ticket escalation time reached between' => 'Prazos de escalação expirado entre',
        'Escalation - first response time' => 'Escalação - prazo da resposta inicial',
        'Ticket first response time reached' => 'Prazo de resposta inicial expirado',
        'Ticket first response time reached between' => 'Prazo de resposta inicial expirado entre',
        'Escalation - update time' => 'Escalação - prazo de atualização',
        'Ticket update time reached' => 'Prazo de atualização expirado',
        'Ticket update time reached between' => 'Prazo de atualização expirado entre',
        'Escalation - solution time' => 'Escalação - prazo de solução',
        'Ticket solution time reached' => 'Prazo de solução expirado',
        'Ticket solution time reached between' => 'Prazo de solução expirado entre',
        'Archive search option' => 'Opção de pesquisa de arquivo',
        'Update/Add Ticket Attributes' => 'Alterar/Adicionar Atributos do Chamado',
        'Set new service' => 'Configurar novo serviço',
        'Set new Service Level Agreement' => 'Configurar novo Acordo de Níve de Serviço',
        'Set new priority' => 'Configurar Nova Prioridade',
        'Set new queue' => 'Configurar Nova Fila',
        'Set new state' => 'Configurar Novo Estado',
        'Pending date' => 'Data de Pendência',
        'Set new agent' => 'Configurar Novo Atendente',
        'new owner' => 'Novo Proprietário',
        'new responsible' => 'Novo Responsável',
        'Set new ticket lock' => 'Configurar Novo Bloqueio de Chamado',
        'New customer user' => 'Novo usuário cliente',
        'New customer ID' => 'Novo ID de Cliente',
        'New title' => 'Novo Título',
        'New type' => 'Novo Tipo',
        'New Dynamic Field Values' => 'Novo Valor de Campo Dinâmico',
        'Archive selected tickets' => 'Arquivar chamados selecionados',
        'Add Note' => 'Adicionar Nota',
        'This field must have less then 200 characters.' => 'Este campo precisa ter menos de 200 caracteres.',
        'Time units' => 'Unidades de tempo',
        'Execute Ticket Commands' => 'Executar Comandos de Chamado',
        'Send agent/customer notifications on changes' => 'Enviar Notificações de Alterações Para Atendente/Cliente',
        'CMD' => 'Comando',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Este comando será executado. ARG[0] será o número do chamado. ARG[1] o ID do chamado.',
        'Delete tickets' => 'Excluir Chamados',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Atenção: Todos os chamados afetados serão removidos do banco de dados e não poderão ser restaurados!',
        'Execute Custom Module' => 'Executar Módulo Personalizado',
        'Param %s key' => 'Parâmetro Chave %s',
        'Param %s value' => 'Valor do Parâmetro %s',
        'Save Changes' => 'Salvar Alterações',
        'Results' => 'Resultados',
        '%s Tickets affected! What do you want to do?' => '%s chamados afetados! O que você quer fazer?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Atenção: Você usou a opção DELETE. Todos os chamados excluídos serão perdidos!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Atenção: Existem %s tickets afetados mas apenas %s podem ser modificados durante a execução de um job!',
        'Edit job' => 'Alterar tarefa',
        'Run job' => 'Executar tarefa',
        'Affected Tickets' => 'Chamados Afetados',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'Depurador GenericInterface para o Web Serviço %s',
        'You are here' => 'Você esta aqui',
        'Web Services' => 'Web Services',
        'Debugger' => 'Depurador',
        'Go back to web service' => 'Voltar para web service',
        'Clear' => 'Limpar',
        'Do you really want to clear the debug log of this web service?' =>
            'Você realmente deseja excluir o registro de depuração deste serviço web?',
        'Request List' => 'Lista de Requisições',
        'Time' => 'Hora',
        'Remote IP' => 'IP Remoto',
        'Loading' => 'Carregando...',
        'Select a single request to see its details.' => 'Selecione uma única requisição para ver os seus detalhes.',
        'Filter by type' => 'Filtrar por tipo',
        'Filter from' => 'Filtrar de',
        'Filter to' => 'Filtrar até',
        'Filter by remote IP' => 'Filtrar por IP remoto',
        'Limit' => 'Limite',
        'Refresh' => 'Atualizar',
        'Request Details' => 'Detalhes da Requisição',
        'An error occurred during communication.' => 'Ocorreu um erro durante a comunicação.',
        'Show or hide the content.' => 'Exibir ou ocultar conteúdo.',
        'Clear debug log' => 'Limpar log de depuração',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Adicione um novo Invoker para o web service %s',
        'Change Invoker %s of Web Service %s' => 'Altere o Invoker %s do web service %s',
        'Add new invoker' => 'Adicione um novo invoker',
        'Change invoker %s' => 'Altere o invoker %s',
        'Do you really want to delete this invoker?' => 'Você deseja realmente excluir este invoker?',
        'All configuration data will be lost.' => 'Todos os dados de configuração serão perdidos.',
        'Invoker Details' => 'Detalhes do invoker',
        'The name is typically used to call up an operation of a remote web service.' =>
            'O nome é comumente usado para chamar uma operação de um web service remoto.',
        'Please provide a unique name for this web service invoker.' => 'Por favor informe um nome único para este invoker de web service.',
        'Invoker backend' => 'Backend do Invocador',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Este módulo de backend do invoker do OTRS será chamado para preparar os dados que serão enviados para o sistema remoto, e para processar os dados da resposta.',
        'Mapping for outgoing request data' => 'Mapeamento para os dados de saída da requisição.',
        'Configure' => 'Configurar',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Os dados do invoker do OTRS serão processados através deste mapeamento, para transformá-los no tipo de dados esperado pelo sistema remoto.',
        'Mapping for incoming response data' => 'Mapeamento para os dados de chegada da resposta.',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'Os dados da resposta serão processados através deste mapeamento, para transformá-los no tipo de dados esperado pelo invoker do OTRS.',
        'Asynchronous' => 'Assíncrono',
        'This invoker will be triggered by the configured events.' => 'Este invoker será disparado atráves dos eventos configurados.',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            'Gatilhos de eventos asíncronos são tratados pelo OTRS Scheduler Daemon em segundo plano (recomendado).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Gatilhos (dispadores) de eventos síncronos precisam ser processados diretamente durante a requisição web.',
        'Save and continue' => 'Salva e Continuar',
        'Delete this Invoker' => 'Exclua este invoker',
        'It is not possible to add a new event trigger because the event is not set.' =>
            'Não é possível adicionar um novo disparador de eventos porque o evento não foi definido.',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'Mapeamento Simple da GenericInterface para o web service %s',
        'Go back to' => 'Voltar para',
        'Mapping Simple' => 'Mapeamento Simple',
        'Default rule for unmapped keys' => 'Regra padrão para chaves não mapeadas',
        'This rule will apply for all keys with no mapping rule.' => 'Esta regra se aplica para todas as chaves sem regra de mapeamento',
        'Default rule for unmapped values' => 'Regra padrão para valores não mapeados.',
        'This rule will apply for all values with no mapping rule.' => 'Esta regra será aplicada para todos os valores sem regra de mapeamento.',
        'New key map' => 'Novo mapa de chave',
        'Add key mapping' => 'Adicionar mapeamento de chave',
        'Mapping for Key ' => 'Mapeamento por Chave',
        'Remove key mapping' => 'Remover mapeamento de chave',
        'Key mapping' => 'Chave mapeada',
        'Map key' => 'Chave de mapa',
        'matching the' => 'correspondendo ao',
        'to new key' => 'para nova chave',
        'Value mapping' => 'Mapeamento de valor',
        'Map value' => 'Valor de mapa',
        'to new value' => 'para novo valor',
        'Remove value mapping' => 'Remover mapeamento de valor',
        'New value map' => 'Novo mapa de valor',
        'Add value mapping' => 'Adiciona mapeamento de valor',
        'Do you really want to delete this key mapping?' => 'Você realmente deseja excluir este mapeamento de chaves?',
        'Delete this Key Mapping' => 'Exclui este mapeamento de chaves',

        # Template: AdminGenericInterfaceMappingXSLT
        'GenericInterface Mapping XSLT for Web Service %s' => 'XSLT de mapeamento da GenericInterface para o web service %s',
        'Mapping XML' => 'XML de mapeamento',
        'Template' => 'Modelo',
        'The entered data is not a valid XSLT stylesheet.' => 'Os dados registrados não representam um stylesheet XSLT válido.',
        'Insert XSLT stylesheet.' => 'Insira o stylesheet XSLT.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Adicionar nova operação no web service %s',
        'Change Operation %s of Web Service %s' => 'Altera operação %s no web service %s',
        'Add new operation' => 'Criar nova operação',
        'Change operation %s' => 'Alterar operação %s',
        'Do you really want to delete this operation?' => 'Você realmente deseja excluir esta operação?',
        'Operation Details' => 'Detalhes da Operação',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'O nome é normalmente usado para chamar esta operação de web service a partir de um sistema remoto.',
        'Please provide a unique name for this web service.' => 'Por favor, forneça um único nome para este web service.',
        'Mapping for incoming request data' => 'Mapeamento para dados de chegada da requisição',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'Os dados requisitados serão processados por este mapeamento, para transformá-los no tipo de dados esperado pelo OTRS.',
        'Operation backend' => 'Backend de operação',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Este módulo de backend de operação do OTRS será chamado internamente para processar a requisição, gerando dados para a resposta',
        'Mapping for outgoing response data' => 'Mapeamento para os dados de saída da resposta',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Os dados da resposta serão processados por este mapeamento, para transformá-los no tipo de dados esperados pelo sistema remoto.',
        'Delete this Operation' => 'Excluir esta Operação',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => 'Transporte HTTP::REST da GenericInterface para o web service %s',
        'Network transport' => 'Transporte de Rede',
        'Properties' => 'Propriedades',
        'Route mapping for Operation' => 'Mapeamento da rota para a operação',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Defina a rota que precisa ser mapeada para esta operação. Variáveis marcadas com um \':\' serão mapeadas para o nome de entrada e repassadas com as demais para o mapeamento (ex.: /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Métodos de requisição válidos para a operação',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Limita esta operação para métodos de requisição específicos. Se nenhum método for selecionado, todas as requisições serão aceitas.',
        'Maximum message length' => 'Tamanho máximo da mensagem',
        'This field should be an integer number.' => 'O campo deve ser um valor inteiro.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'Aqui você pode especificar o tamanho máximo (em bytes) das mensagens REST que o OTRS vai processar.',
        'Send Keep-Alive' => 'Enviar Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Esta configuração define se conexões de entrada devem ficar fechadas ou permanecerem abertas.',
        'Host' => 'Servidor',
        'Remote host URL for the REST requests.' => 'URL do host remoto para requisições REST.',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'ex: https://www.otrs.com:10745/api/v1.0 (sem fuga da barra invertida)',
        'Controller mapping for Invoker' => 'Mapeamento do controlador para o invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'O controlador para o qual o invoker necessita enviar requisições. Variáveis marcadas com um \':\' serão substituídas pelos valores dos dados e repassadas com a requisição (ex.: /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Comando válido da requisição para o invoker',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Um comando HTTP específico para usar para as requisições com este invoker (opcional).',
        'Default command' => 'Comando padrão',
        'The default HTTP command to use for the requests.' => 'O comando HTTP padrão para usar para as requisições.',
        'Authentication' => 'Autenticação',
        'The authentication mechanism to access the remote system.' => 'O mecanismo de autenticação para acessar o sistema remoto.',
        'A "-" value means no authentication.' => 'Um valor "-" significa sem autenticação.',
        'The user name to be used to access the remote system.' => 'Nome de usuário para acesso ao sistema remoto.',
        'The password for the privileged user.' => 'A senha para o usuário privilegiado.',
        'Use SSL Options' => 'Usar opções de SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Exibir ou ocultar as opções SSL para conectar ao sistema remoto.',
        'Certificate File' => 'Arquivo de Certificado',
        'The full path and name of the SSL certificate file.' => 'O caminho completo ou o nome do arquivo do certificado SSL.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => 'ex.: /opt/otrs/var/certificates/REST/ssl.crt',
        'Certificate Password File' => 'Arquivo de senha do certificado',
        'The full path and name of the SSL key file.' => 'O caminho completo ou o nome do arquivo da chave do SSL.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => 'ex.: /opt/otrs/var/certificates/REST/ssl.key',
        'Certification Authority (CA) File' => 'Arquivo da Autoridade Certificadora (AC)',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            'O caminho completo ou o nome do arquivo de certificado da Autoridade Certificadora que valida o certificado SSL.',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => 'ex.: /opt/otrs/var/certificates/REST/CA/ca.file',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'Transporte HTTP::SOAP da GenericInterface para o web service %s',
        'Endpoint' => 'Endpoint',
        'URI to indicate a specific location for accessing a service.' =>
            'URI para indicar a localização especifica de acesso a um web service.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'ex.: http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI de contexto dos métodos SOAP, reduzindo ambiguidades.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'ex.: urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => 'Solicita esquema de nome',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Seleciona como o encapsulador da função de solicitação SOAP precisa ser construído.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\' é usado como exemplo para o verdadeiro nome de invoker/operation.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\' é usado como exemplo para o real valor configurado.',
        'Request name free text' => 'Texto livre do nome da requisição',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Texto a ser usado como sufixo ou substituto de nome da função de encapsulamento.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Por favor considere as restrições para nomeação de elementos XML (ex.: não use \'<\' e \'&\').',
        'Response name scheme' => 'Esquema de nome da resposta',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Selecione como a função de encapsulamento da resposta SOAP precisa ser construída.',
        'Response name free text' => 'Nome da resposta free text',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Aqui você pode especificar o tamanho máximo (em bytes) das mensagens SOAP que o OTRS vai processar.',
        'Encoding' => 'Codificação',
        'The character encoding for the SOAP message contents.' => 'A codificação de caracteres para o conteúdo da mensagem SOAP.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'ex.: utf-8, latin1, iso-8859-1, cp1250 etc.',
        'SOAPAction' => 'SOAPAction',
        'Set to "Yes" to send a filled SOAPAction header.' => 'Defina para "Sim" para enviar um cabeçalho SOAPAction preenchido.',
        'Set to "No" to send an empty SOAPAction header.' => 'Defina para "Não" para enviar um cabeçalho SOAPAction vazio.',
        'SOAPAction separator' => 'Separador SOAPAction',
        'Character to use as separator between name space and SOAP method.' =>
            'Caractere a ser usado como separador entre o namespace e o método SOAP.',
        'Usually .Net web services uses a "/" as separator.' => 'Geralmente web services .Net usam "/" como separador.',
        'Proxy Server' => 'Servidor Proxy',
        'URI of a proxy server to be used (if needed).' => 'URL do servidor proxy (se necessário).',
        'e.g. http://proxy_hostname:8080' => 'ex. http://proxy_hostname:8080',
        'Proxy User' => 'Usuário do Servidor Proxy',
        'The user name to be used to access the proxy server.' => 'O nome de usuário usado para acesso ao servidor proxy.',
        'Proxy Password' => 'Senha do Servidor Proxy',
        'The password for the proxy user.' => 'A senha do usuário usado para acesso ao servidor proxy',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'O caminho completo e nome do arquivo do certificado SSL (precisa estar no formato .p12).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'ex. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => 'Senha para abrir o Certificado SSL',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'O caminho completo e nome do arquivo do certificado da autoridade certificadora que valida o certificado SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'ex. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Diretório da Autoridade Certificadora (AC)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'O caminho completo do diretório da autoridade certificadora onde os certificados AC serão armazenados no sistema de arquivos.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'ex. /opt/otrs/var/certificates/SOAP/CA',
        'Sort options' => 'Ordenar opções',
        'Add new first level element' => 'Adicionar novo elemento de primeiro nível',
        'Element' => 'Elemento',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Sentido de ordenação de saída para campos xml (começo da estrutura abaixo do encapsulamento de nome de função) - veja documentação sobre transporte SOAP.',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'Gerenciamento de Web Service',
        'Add web service' => 'Adicionar Web Server',
        'Clone web service' => 'Copiar Web Service',
        'The name must be unique.' => 'O nome deve ser único',
        'Clone' => 'Copiar',
        'Export web service' => 'Exportar Web Service',
        'Import web service' => 'Importar Web Service',
        'Configuration File' => 'Arquivo de Configuração',
        'The file must be a valid web service configuration YAML file.' =>
            'O arquivo deve ser uma configuração YAML válido.',
        'Import' => 'Importar',
        'Configuration history' => 'Histórico de configuração',
        'Delete web service' => 'Apagar Web Service',
        'Do you really want to delete this web service?' => 'Você realmente deseja apagar este web service?',
        'Ready-to-run Web Services' => 'Web Services prontos para executar',
        'Here you can activate ready-to-run web services showcasing our best practices that are a part of %s.' =>
            'Aqui você pode ativar web services prontos para execução demonstrando nossas boas práticas que são parte de %s.',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            'Por favor note que estes web services podem depender de outros módulos disponíveis apenas com certos %s níveis de contrato (haverá uma notificação com maiores detalhes quando da importação).',
        'Import ready-to-run web service' => 'Importar web service pronto para execução',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated ready-to-run web services.' =>
            'Você gostaria de se beneficiar de web services criados por especialistas? Faça o upgrade para %s para importar alguns web services sofisticados prontos para execução.',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Após salvar as configuração você será redirecionado novamente para a tela de edição.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Se você deseja retornar para a visão geral, clique no botão "Ir para a visão geral"',
        'Web Service List' => 'Lista de Web Services',
        'Remote system' => 'Sistema Remoto',
        'Provider transport' => 'Transporte Provedor',
        'Requester transport' => 'Transporte Requisitante',
        'Debug threshold' => 'Tipo de Debug',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'No modo provedor, o OTRS oferece um web service para ser utilizado por sistemas remotos.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'No modo requisitante, o OTRS usa web services de sistemas remotos.',
        'Operations are individual system functions which remote systems can request.' =>
            'Operações são funções individuais do sistema que podem ser requisitadas pelo sistema remoto.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invocadores prepararam os dados para um pedido de um web service remoto, e processam os dados de sua resposta.',
        'Controller' => 'Controlador',
        'Inbound mapping' => 'Mapeamento de entrada',
        'Outbound mapping' => 'Mapeamento de saída',
        'Delete this action' => 'Excluir esta ação',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Pelo menos um %s tem um controlador que ou não está ativo ou não está presente, por favor verifique o registro do controlador ou exclua o %s',
        'Delete webservice' => 'Excluir web service',
        'Delete operation' => 'Excluir operação',
        'Delete invoker' => 'Excluir invoker',
        'Clone webservice' => 'Clonar web service',
        'Import webservice' => 'Importar Web Service',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'Histórico de configuração da GenericInterface para o web service %s',
        'Go back to Web Service' => 'Voltar para Web Service',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Aqui você pode visualizar as versões anteriores da configuração do web service corrente, exportar ou até restaurá-las.',
        'Configuration History List' => 'Lista de histórico da configuração',
        'Version' => 'Versão',
        'Create time' => 'Data de criação',
        'Select a single configuration version to see its details.' => 'Selecione apenas uma versão de configuração para ver seus detalhes.',
        'Export web service configuration' => 'Exportar configuração do web service',
        'Restore web service configuration' => 'Restaurar configuração do web service',
        'Do you really want to restore this version of the web service configuration?' =>
            'Você realmente deseja restaurar esta versão da configuração do web service?',
        'Your current web service configuration will be overwritten.' => 'A sua configuração corrente do web service será sobrescrita.',
        'Restore' => 'Restaurar',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'AVISO: Quando você altera o nome do grupo \'admin\', antes de fazer as alterações apropriadas no SysConfig, você será bloqueado para fora do painel de administração! Se isso acontecer, por favor renomeie de volta o grupo através de comandos SQL.',
        'Group Management' => 'Administração de Grupos',
        'Add Group' => 'Adicionar Grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'O grupo admin é para uso na área de administração e o grupo stats é para uso na área de estatísticas.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Crie novos grupos para manusear diferentes permissões de acesso para diferentes grupos de atendentes (ex. compras, produção, vendas...).',
        'It\'s useful for ASP solutions. ' => 'Isso é útil para soluções ASP.',
        'total' => 'total',
        'Edit Group' => 'Alterar Grupo',

        # Template: AdminLog
        'System Log' => 'Eventos do Sistema',
        'Here you will find log information about your system.' => 'Aqui você vai encontrar informações sobre eventos do seu sistema.',
        'Hide this message' => 'Esconder esta mensagem',
        'Recent Log Entries' => 'Entradas Recentes de Log',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Gerenciamento de Contas de E-mail',
        'Add mail account' => 'Adicionar Conta de E-mail',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Todos os e-mails recebidos com uma conta serão ordenados na fila selecionada!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Se a sua conta for confiável, os headers "X-OTRS" já existentes no momento da recepção (por prioridade, ...) serão utilizados! O filtro será utilizado mesmo assim.',
        'Delete account' => 'Excluir conta',
        'Fetch mail' => 'Obter E-mails',
        'Add Mail Account' => 'Adicionar Conta de E-mail',
        'Example: mail.example.com' => 'Exemplo: mail.exemplo.com',
        'IMAP Folder' => 'Pasta IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Apenas modifique aqui se você deseja obter e-mails de uma pasta diferente que INBOX.',
        'Trusted' => 'Confiável',
        'Dispatching' => 'Despachando',
        'Edit Mail Account' => 'Alterar conta de e-mail',

        # Template: AdminNavigationBar
        'Admin' => 'Administração',
        'Agent Management' => 'Gerenciamento de Atendente',
        'Queue Settings' => 'Configurações de Fila',
        'Ticket Settings' => 'Configurações de Chamado',
        'System Administration' => 'Administração do Sistema',
        'Online Admin Manual' => 'Manual Online do Administrador',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Gerenciamento de notificação de chamados',
        'Add notification' => 'Adicionar Notificação',
        'Export Notifications' => 'Exportar notificações',
        'Configuration Import' => 'Importar configurações',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Aqui você pode fazer upload de um arquivo de configuração para importar Notificações de Chamados para seu sistema. O arquivo deve estar no formato .yml como exportado pelo módulo de Notificação de Chamados.',
        'Overwrite existing notifications?' => 'Sobrescrever notificações existentes?',
        'Upload Notification configuration' => 'Suba a configuração de notificação',
        'Import Notification configuration' => 'Importe a configuração de notificação',
        'Delete this notification' => 'Excluir esta notificação',
        'Do you really want to delete this notification?' => 'Você realmente quer apagar essa notificação ?',
        'Add Notification' => 'Adicionar Notificação',
        'Edit Notification' => 'Alterar Notificação',
        'Show in agent preferences' => 'Mostras nas preferências do atende',
        'Agent preferences tooltip' => 'Tooltip das preferências de agente',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Esta mensagem vai ser exibida na tela de preferências de agente como um tooltip para esta notificação.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Aqui você pode escolher quais eventos serão acionados por esta notificação. Um filtro de chamado adicional pode ser aplicado para enviar apenas para o chamado com determinados critérios.',
        'Ticket Filter' => 'Filtro de Chamado',
        'Article Filter' => 'Filtro de Artigo',
        'Only for ArticleCreate and ArticleSend event' => 'Apenas para os eventos ArticleCreate e ArticleSend',
        'Article type' => 'Tipo de Artigo',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Se ArticleCreate ou ArticleSend for usado como evento de disparo, você precisa especificar também um filtro de artigo. Por favor selecione pelo menos um dos campos de filtro de artigo.',
        'Article sender type' => 'Tipo de Remetente do Artigo',
        'Subject match' => 'Casar Assunto',
        'Body match' => 'Casar Corpo',
        'Include attachments to notification' => 'Incluir Anexos na Notificação',
        'Recipients' => 'Destinatários',
        'Send to' => 'Enviar para',
        'Send to these agents' => 'Enviar para estes atendentes',
        'Send to all group members (agents only)' => 'Enviar para todos os membros do grupo (apenas o agente)',
        'Send to all role members' => 'Enviar para todos os membros do papel',
        'Send on out of office' => 'Enviar em fora do esritório',
        'Also send if the user is currently out of office.' => 'Também enviar se o usuário se encontra fora do escritório..',
        'Once per day' => 'Uma vez por dia',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Notificar usuário apenas uma vez por dia sobre um chamado simples usando um transporte selecionado.',
        'Notification Methods' => 'Métodos de notificação',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Estes são os possíveis métodos que podem ser usados para enviar esta notificação a cada um dos destinatários. Por favor, selecione pelo menos um método abaixo.',
        'Enable this notification method' => 'Ativar esse método de notificação',
        'Transport' => 'Transporte',
        'At least one method is needed per notification.' => 'Pelo menos um método é necessário por notificação.',
        'Active by default in agent preferences' => 'Ativado por padrão nas preferências de agente',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Esse é o valor padrão atribuído para agentes destinatários que ainda não fizeram uma escolha para essa notificação em suas preferências. Se a caixa estiver habilitada, a notificação será enviada para esses agentes.',
        'This feature is currently not available.' => 'Este recurso não está disponível no momento.',
        'No data found' => 'Dados não encontrado',
        'No notification method found.' => 'Método de notificação não existente',
        'Notification Text' => 'Texto da notificação',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Esta linguagem não está presente ou habilitada no sistema. Este texto de notificação pode ser excluído se não for mais necessário.',
        'Remove Notification Language' => 'Remover notificação de idioma',
        'Message body' => 'Corpo da mensagem',
        'This field is required and must have less than 4000 characters.' =>
            'Este campo é obrigatório e deve ter menos do que 4000 caracteres.',
        'Add new notification language' => 'Adicionar novo idioma notificação',
        'Do you really want to delete this notification language?' => 'Você realmente quer apagar este idioma notificação?',
        'Tag Reference' => 'Referência de Tag',
        'Notifications are sent to an agent or a customer.' => 'Notificações serão enviadas para um Atendente ou Cliente.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Para buscar os primeiros 20 caracteres do assunto (do último artigo do atendente)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Para buscar as primeiras 5 linhas do corpo (do último artigo do atendente)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Para buscar os primeiros 20 caracteres do assunto (do último artigo do cliente)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Para buscar as primeiras 5 linhas do corpo (do último artigo do cliente)',
        'Attributes of the current customer user data' => 'Atributos  de dados do usuário cliente atual',
        'Attributes of the current ticket owner user data' => 'Atributos de dados do usuário atual proprietário do chamado',
        'Attributes of the current ticket responsible user data' => 'Atributos de dados do usuário atual responsável pelo chamado',
        'Attributes of the current agent user who requested this action' =>
            'Atributos do usuário agente atual que solicitaram esta ação',
        'Attributes of the recipient user for the notification' => 'Atributos do usuário destinatário da notificação',
        'Attributes of the ticket data' => 'Atributos dos dados do chamado',
        'Ticket dynamic fields internal key values' => 'Chave de valores interna dos campos dinâmicos do chamado',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Campos dinâmicos bilhete exibem valores, útil para campos do tipo Dropdown e Multiselect',
        'Example notification' => 'Exemplo de notificação',

        # Template: AdminNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Caixa de endereço de e-mail adicional',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            'Você pode utilizar OTRS-tags como <OTRS_TICKET_DynamicField_...> para inserir valores do chamado atual.',
        'Notification article type' => 'Tipo de Artigo de Notificação',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Um artigo será criado se as notificações são enviadas para o usuário ou para um endereço de e-mail adicional.',
        'Email template' => 'Template de e-mail',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Use este modelo para gerar o e-mail completo (somente para e-mails HTML)',
        'Enable email security' => 'Habilitar segurança de email',
        'Email security level' => 'Nível de segurança do email',
        'If signing key/certificate is missing' => 'Se a assinatura de chave/certificado está faltando',
        'If encryption key/certificate is missing' => 'Se a chave/certificado de encriptação está faltando',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'Gerenciar %s',
        'Go to the OTRS customer portal' => 'Vá para o portal de clientes do OTRS',
        'Downgrade to ((OTRS)) Community Edition' => '',
        'Read documentation' => 'Leia a documentação',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s faz contato regular com cloud.otrs.com para verificar as atualizações disponíveis e a validade do contrato subjacente.',
        'Unauthorized Usage Detected' => 'Uso não autorizado detectado',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            'Este sistema usa o %s sem a licença correspondente! Por favor faça contato com %s para renovar ou ativar o seu contrato!',
        '%s not Correctly Installed' => '%s não instalado corretamente',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            'O seu %s não está instalado corretamente. Por favor reinstale-o usando o botão abaixo.',
        'Reinstall %s' => 'Reinstalar %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            'O seu %s não está instalado corretamente, e também há uma atualização disponível.',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            'Você pode reinstalar a versão atual ou executar uma atualização com os botões abaixo (atualização recomendada).',
        'Update %s' => 'Atualizar %s',
        '%s Not Yet Available' => '%s Não Disponível Ainda',
        '%s will be available soon.' => '%s estará disponível em breve.',
        '%s Update Available' => '%s Atualização Disponível',
        'Package installation requires patch level update of OTRS.' => 'Instalação do pacote requer atualização de nível de patch do OTRS.',
        'Please visit our customer portal and file a request.' => 'Por favor visite nosso portal de clientes e registre um pedido.',
        'Everything else will be done as part of your contract.' => 'Tudo mais será feito como parte do seu contrato.',
        'Your installed OTRS version is %s.' => 'Sua versão do OTRS instalada é %s.',
        'To install the current version of OTRS Business Solution™, you need to update to OTRS %s or higher.' =>
            'Para instalar a versão atual do OTRS Business Solution™, você precisa atualizar para OTRS %s ou superior.',
        'To install the current version of OTRS Business Solution™, the Maximum OTRS Version is %s.' =>
            'Para instalar a versão atual do OTRS Business Solution™, a versão máxima do OTRS é %s.',
        'To install this package, the required Framework version is %s.' =>
            'Para instalar este pacote, a versão do framework requerida é %s.',
        'Why should I keep OTRS up to date?' => 'Por que eu deveria manter o OTRS atualizado?',
        'You will receive updates about relevant security issues.' => 'Você receberá atualizações sobre questões de segurança relevantes.',
        'You will receive updates for all other relevant OTRS issues' => 'Você receberá atualizações para todas as outras questões relevantes do OTRS',
        'An update for your %s is available! Please update at your earliest!' =>
            'Uma atualização para seu %s está disponível! Por favor, atualize o mais breve possível!',
        '%s Correctly Deployed' => '%s Instalado Corretamente',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'Parabéns, seu %s está corretamente instalado e atualizado!',

        # Template: AdminOTRSBusinessNotInstalled
        '%s will be available soon. Please check again in a few days.' =>
            '%s estará disponível em breve. Por favor, verifique novamente em poucos dias.',
        'Please have a look at %s for more information.' => 'Por favor, dê uma olhada em %s para mais informações.',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'Antes que você possa se beneficiar do %s, por favor, entre em contato com %s para o obter seu contrato de %s.',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'Conexão com cloud.otrs.com via HTTPS não pôde ser estabelecida. Por favor, certifique-se de que seu OTRS pode se conectar a cloud.otrs.com através da porta 443.',
        'To install this package, you need to update to OTRS %s or higher.' =>
            'Para instalar este pacote, você precisa atualizar para OTRS %s ou superior.',
        'To install this package, the Maximum OTRS Version is %s.' => 'Para instalar este pacote, a versão máxima do OTRS é %s.',
        'With your existing contract you can only use a small part of the %s.' =>
            'Com seu contrato existente você pode usar apenas uma pequena parte do %s.',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            'Se você quiser aproveitar todas as vantagens do %s atualize seu contrato agora! Entre em contato com %s.',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'Cancelar downgrade e retornar',
        'Go to OTRS Package Manager' => 'Ir para o Gerenciador de Pacotes do OTRS',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            'Desculpe, mas atualmente você não pode efetuar desatualizar os seguintes pacotes que dependem de % s:',
        'Vendor' => 'Fornecedor',
        'Please uninstall the packages first using the package manager and try again.' =>
            'Por favor, desinstale os pacotes primeiro usando o Gerenciador de pacotes e tente novamente.',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            '',
        'Chat' => 'Bate-papo',
        'Report Generator' => 'Gerador de relatório',
        'Timeline view in ticket zoom' => 'Visão de linha do tempo nos detalhes do chamado',
        'DynamicField ContactWithData' => 'CampoDinâmico ContatoComDados',
        'DynamicField Database' => 'CampoDinâmico BaseDeDados',
        'SLA Selection Dialog' => 'SLA Dialogo de Seleção',
        'Ticket Attachment View' => 'Visão de Anexo do Chamado',
        'The %s skin' => 'O tema %s',

        # Template: AdminPGP
        'PGP Management' => 'Gerenciamento do PGP',
        'PGP support is disabled' => 'Suporte a PGP desabilitado',
        'To be able to use PGP in OTRS, you have to enable it first.' => 'Para poder usar PGP no OTRS, você precisa ativar isto primeiro.',
        'Enable PGP support' => 'Habilitar suporte a PGP',
        'Faulty PGP configuration' => 'Erro na configuração de PGP',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Suporte a PGP está habilitado, mas a configuração contém erros. Por favor verifique a configuração usando o botão abaixo.',
        'Configure it here!' => 'Configure aqui',
        'Check PGP configuration' => 'Checar configuração de PGP',
        'Add PGP key' => 'Adicionar chave PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Neste caso, você pode editar diretamente o "keyring" configurado no "SysConfig".',
        'Introduction to PGP' => 'Introdução ao PGP',
        'Result' => 'Resultado',
        'Identifier' => 'Identificador',
        'Bit' => 'Bit',
        'Fingerprint' => 'Impressão Digital',
        'Expires' => 'Expira',
        'Delete this key' => 'Excluir esta chave',
        'Add PGP Key' => 'Adicionar Chave PGP',
        'PGP key' => 'Chave PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Gerenciador de Pacotes',
        'Uninstall package' => 'Desinstalar Pacote',
        'Do you really want to uninstall this package?' => 'Você quer realmente desinstalar este pacote?',
        'Reinstall package' => 'Reinstalar Pacote',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Você realmente quer reinstalar este pacote? Quaisquer alterações manuais serão perdidas.',
        'Go to updating instructions' => 'Vá para instruções de atualização',
        'package information' => 'informação do pacote',
        'Package installation requires a patch level update of OTRS.' => 'Pacote de Instalação requer atualização do OTRS',
        'Package update requires a patch level update of OTRS.' => 'Atualização do pacote requer atualização de nível do OTRS',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            'Se você é um cliente OTRS Business Solution™, por favor visite nosso portal de clientes e registre um pedido.',
        'Please note that your installed OTRS version is %s.' => 'Por favor note que a sua versão do OTRS instalada é %s.',
        'To install this package, you need to update OTRS to version %s or newer.' =>
            'Para instalar este pacote, você precisa atualizar seu OTRS para versão %s ou superior.',
        'This package can only be installed on OTRS version %s or older.' =>
            'Este pacote smente pode ser instalado na versão %s ou inferior do OTRS.',
        'This package can only be installed on OTRS version %s or newer.' =>
            'Este pacote smente pode ser instalado na versão %s ou superior do OTRS.',
        'You will receive updates for all other relevant OTRS issues.' =>
            'Você receberá atualizações para todos os outros problemas relevantes do OTRS.',
        'How can I do a patch level update if I don’t have a contract?' =>
            'Como eu posso fazer uma atualização de nível de patch se eu não tenho um contrato?',
        'Please find all relevant information within the updating instructions at %s.' =>
            'Você encontra toda informação relevante dentro das informações de atualização em %s.',
        'In case you would have further questions we would be glad to answer them.' =>
            'No caso de você ter mais perguntas, teremos prazer em respondê-las.',
        'Continue' => 'Continuar',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Por favor, certifique-se de que seu banco de dados aceita pacotes com mais de %s MB de tamanho (tamanho máximo suportado é de %s MB). Altere o parâmetro max_allowed_packet do seu banco de dados para evitar erros.',
        'Install' => 'Instalar',
        'Install Package' => 'Instalar Pacote',
        'Update repository information' => 'Atualizar Informação de Repositório',
        'Cloud services are currently disabled.' => 'Serviços de nuvem atualmente desabilitados.',
        'OTRS Verify™ can not continue!' => 'OTRS Verify™ não pode continuar',
        'Enable cloud services' => 'Habilitar serviços de nuvem',
        'Online Repository' => 'Repositório Online',
        'Module documentation' => 'Documentação do Módulo',
        'Upgrade' => 'Atualizar Versão',
        'Local Repository' => 'Repositório Local',
        'This package is verified by OTRSverify (tm)' => 'Este pacote foi verificado por OTRSverify (tm)',
        'Uninstall' => 'Desinstalar',
        'Reinstall' => 'Reinstalar',
        'Features for %s customers only' => 'Características %s só para clientes',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Com %s, você pode beneficiar os seguintes recursos opcionais. Por favor, faça contato com %s se precisar de mais informações.',
        'Download package' => 'Baixar Pacote',
        'Rebuild package' => 'Reconstruir Pacote',
        'Metadata' => 'Metadados',
        'Change Log' => 'Registro de Alterações',
        'Date' => 'Data',
        'List of Files' => 'Lista de Arquivos',
        'Permission' => 'Permissões',
        'Download' => 'Baixar',
        'Download file from package!' => 'Baixar arquivo do pacote!',
        'Required' => 'Obrigatório',
        'Primary Key' => 'Chave Primária',
        'Auto Increment' => 'Auto Incremento',
        'SQL' => 'SQL',
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
        'last' => 'último',
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
        'Add filter' => 'Adicionar Filtro',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Para encaminhamento ou filtragem de e-mails recebidos com base em cabeçalhos de e-mail. O casamento usando expressões regulares também é possível.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Se você deseja corresponder apenas o endereço de e-mail, use EMAILADDRESS: info@exemplo.com em De, Para ou Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Se você usar Expressões Regulares, você também pode usar o valor encontrado em () como [***] na ação \'Set\'.',
        'Delete this filter' => 'Excluir este filtro',
        'Do you really want to delete this filter?' => 'Você realmente quer excluir este filtro?',
        'Add PostMaster Filter' => 'Adicionar Filtro PostMaster',
        'Edit PostMaster Filter' => 'Alterar Filtro PostMaster',
        'A postmaster filter with this name already exists!' => 'Um filtro postmaster com este nome já existe!',
        'Filter Condition' => 'Condição do Filtro',
        'AND Condition' => 'Condição E',
        'Check email header' => 'Checar cabeçalho do Email',
        'Negate' => 'Negado',
        'Look for value' => 'Pesquise por valor',
        'The field needs to be a valid regular expression or a literal word.' =>
            'O campo precisa ser uma expressão regular válida ou uma palavra literal.',
        'Set Email Headers' => 'Configurar Cabeçalhos de E-mail',
        'Set email header' => 'Ajustar cabeçalho do email',
        'Set value' => 'Definir Valor',
        'The field needs to be a literal word.' => 'O campo precisa ser uma palavra literal.',

        # Template: AdminPriority
        'Priority Management' => 'Gerenciamento de Prioridade',
        'Add priority' => 'Adicionar Prioridade',
        'Add Priority' => 'Adicionar Prioridade',
        'Edit Priority' => 'Alterar Prioridade',

        # Template: AdminProcessManagement
        'Process Management' => 'Gerenciamento de Processos',
        'Filter for Processes' => 'Filtrar por Processos',
        'Create New Process' => 'Criar Novo Processo',
        'Deploy All Processes' => 'Implantar todos os processos',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Você pode enviar um arquivo de configuração para importar processos em seu sistema. O arquivo precisa estar em formato .yml e ser exportado pelo módulo de gerenciamento de processos.',
        'Overwrite existing entities' => 'Substituir entidades existentes',
        'Upload process configuration' => 'Enviar Configuração de Processo',
        'Import process configuration' => 'Importar Configuração de Processo',
        'Ready-to-run Processes' => 'Processos prontos para execução',
        'Here you can activate ready-to-run processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            'Aqui você pode ativar processos prontos para execução demonstrando nossas boas práticas. Por favor note que alguma configuração adicional pode ser requerida.',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated ready-to-run processes.' =>
            'Você gostaria de se beneficiar de processos criados por especialistas? Faça o upgrade para %s para importa alguns processos prontos para execução sofisticados.',
        'Import ready-to-run process' => 'Importar processos prontos para execução',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Para criar um novo Processo você pode importar um Processo exportado de outro sistema ou criar um Processo completamente novo.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Alterações feitas aos Processos só afetam o sistema após a sincronização dos processos. Ao sincronizar os processos as alterações serão escritas nas configurações.',
        'Processes' => 'Processos',
        'Process name' => 'Nome do Processo',
        'Print' => 'Imprimir',
        'Export Process Configuration' => 'Exportar Configuração do Processo',
        'Copy Process' => 'Copiar Processo',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Cancelar e fechar',
        'Go Back' => 'Voltar',
        'Please note, that changing this activity will affect the following processes' =>
            'Por favor, note que alterar esta atividade afetará os seguintes processos',
        'Activity' => 'Atividade',
        'Activity Name' => 'Nome da Atividade',
        'Activity Dialogs' => 'Janelas de Atividade',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Você pode atribuir Janelas de Atividade à esta Atividade arrastando os elementos com o mouse a partir da lista da esquerda para a lista da direita.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Também é possível ordenar os elementos na lista através de drag \'n\' drop.',
        'Filter available Activity Dialogs' => 'Filtrar Janelas de Atividades Disponíveis',
        'Available Activity Dialogs' => 'Janelas de Atividades Disponíveis',
        'Name: %s, EntityID: %s' => 'Nome: %s, EntityID: %s',
        'Create New Activity Dialog' => 'Criar Nova Janela de Atividade',
        'Assigned Activity Dialogs' => 'Atribuir Janela de Atividade',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Assim que você usar este botão ou link, você deixará tela e seu estado atual será salvo automaticamente. Você quer continuar?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Por favor, note que alterar esta janela de atividade afetará as seguintes atividades',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Por favor, note que os usuários clientes não serão capazes de ver ou usar os seguintes campos: Proprietário, Responsável, Bloqueio, PendingTime e CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'O campo Fila só pode ser usado pelos clientes ao criar um novo chamado.',
        'Activity Dialog' => 'Janela de Atividade',
        'Activity dialog Name' => 'Nome da Janela de Atividade',
        'Available in' => 'Disponível em',
        'Description (short)' => 'Descrição (curta)',
        'Description (long)' => 'Descrição (longa)',
        'The selected permission does not exist.' => 'A permissão selecionada não existe.',
        'Required Lock' => 'Requerer Bloqueio',
        'The selected required lock does not exist.' => 'O bloqueio requerido solicitado não existe.',
        'Submit Advice Text' => 'Orientação do texto Enviar',
        'Submit Button Text' => 'Texto do botão enviar',
        'Fields' => 'Campos',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Você pode atribuir Campos para esta Janela de Atividades arrastando os elementos com o mouse a partir da lista da esquerda para a lista da direita.',
        'Filter available fields' => 'Filtrar campos disponíveis',
        'Available Fields' => 'Campos Disponíveis',
        'Name: %s' => 'Nome: %s',
        'Assigned Fields' => 'Campos Atribuidos',
        'ArticleType' => 'Tipo de Artigo',
        'Display' => 'Exibir',
        'Edit Field Details' => 'Editar Detalhes do Campo',
        'Customer interface does not support internal article types.' => 'A interface de cliente não suporta tipos internos de artigos.',

        # Template: AdminProcessManagementPath
        'Path' => 'Caminho',
        'Edit this transition' => 'Editar esta transição',
        'Transition Actions' => 'Ações de Transição',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Você pode atribuir Ações de Transição à esta transição arrastando os elementos com o mouse a partir da lista da esquerda para a lista da direita.',
        'Filter available Transition Actions' => 'Filtrar Ações de Transições Disponíveis',
        'Available Transition Actions' => 'Ações de Transição Disponíveis',
        'Create New Transition Action' => 'Criar Nova Ação de Transição',
        'Assigned Transition Actions' => 'Atribuir Ação de Transição',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Atividades',
        'Filter Activities...' => 'Filtrar Atividades',
        'Create New Activity' => 'Criar Nova Atividade',
        'Filter Activity Dialogs...' => 'Filtrar Janelas de Atividade',
        'Transitions' => 'Transições',
        'Filter Transitions...' => 'Filtrar Transições',
        'Create New Transition' => 'Criar Nova Transição',
        'Filter Transition Actions...' => 'Filtrar Ações de Transições...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Editar Processo',
        'Print process information' => 'Imprimir Informação do Processo',
        'Delete Process' => 'Excluir Processo',
        'Delete Inactive Process' => 'Excluir Processos Inativos',
        'Available Process Elements' => 'Elementos de Processo Disponíveis',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Os Elementos listamos acima nesta barra lateral podem ser movidos para a área da tela à direita usando drag\'n\'drop.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Você pode colocar Atividades na área da tela atribuindo esta Atividade ao Processo.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Para atribuir uma Janela de Atividade à uma Atividade arraste o elemento de Janela de Atividade desta barra lateral sobre a Atividade colocada na área da tela.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Você pode iniciar uma conexão entre duas atividades arrastando e soltando a transição sobre a atividade inicial da conexão. Depois disso você pode mover a ponta final livre para a atividade final.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Ações podem ser atribuidas para Transições arrastando o elemento de Ação sobre a etiqueta da Transição.',
        'Edit Process Information' => 'Editar Informação do Processo',
        'Process Name' => 'Nome do Processo',
        'The selected state does not exist.' => 'O estado selecionado não existe.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Adicionar e Editar Atividades, Janelas de Atividades e Transições',
        'Show EntityIDs' => 'Mostrar EntityIDs',
        'Extend the width of the Canvas' => 'Expandir Largura da Tela',
        'Extend the height of the Canvas' => 'Expandir Altura da Tela',
        'Remove the Activity from this Process' => 'Remover a Atividade Deste Processo',
        'Edit this Activity' => 'Editar esta Atividade',
        'Save Activities, Activity Dialogs and Transitions' => 'Salvar Atividades, Diálogos de Atividade e Transições',
        'Do you really want to delete this Process?' => 'Você realmente deseja excluir este Processo?',
        'Do you really want to delete this Activity?' => 'Você realmente deseja excluir esta Atividade?',
        'Do you really want to delete this Activity Dialog?' => 'Você realmente deseja excluir esta Janela de Atividade?',
        'Do you really want to delete this Transition?' => 'Você realmente deseja excluir esta Transição?',
        'Do you really want to delete this Transition Action?' => 'Você realmente deseja excluir esta Ação de Transição?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Você realmente deseja excluir esta atividade da tela? Esta ação poderá ser desfeita saindo desta tela sem salvar.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Você realmente deseja excluir esta transição da tela? Esta ação poderá ser desfeita saindo desta tela sem salvar.',
        'Hide EntityIDs' => 'Ocultar EntityIDs',
        'Delete Entity' => 'Excluir Entidade',
        'Remove Entity from canvas' => 'Remover Entidade da tela',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Esta Atividade já está em uso no Processo. Você não pode adicioná-la novamente!',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Esta Atividade não pode ser excluída porque ela é o Início da Atividade.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Esta Transição já está em uso nesta Atividade. Você não pode adicioná-la novamente!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Esta Ação de Transição já está em uso por este Caminho. Você não pode adicioná-la novamente!',
        'Remove the Transition from this Process' => 'Remover a transição deste processo',
        'No TransitionActions assigned.' => 'Nenhum Ação de Transição atribuída.',
        'The Start Event cannot loose the Start Transition!' => 'O Início do Evento não pode perder o Início da Transição.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Sem Janelas atribuídas ainda. Basta escolher uma Janela de Atividade da lista à esquerda e arrastar aqui.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Uma transição sem ligação já está colocada sobre a tela. Por favor conecte esta transição primeiro antes de colocar outra transição.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Nesta tela você pode criar um novo processo. Para tornar o novo processo disponível aos usuários, por favor, certifique-se de definir o estado como \'Ativo\' e sincronizar após completar o seu trabalho.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'cancelar e fechar',
        'Start Activity' => 'Início da Atividade',
        'Contains %s dialog(s)' => 'Contém %s janela(s)',
        'Assigned dialogs' => 'Janelas Atribuídas',
        'Activities are not being used in this process.' => 'Atividades não estão em uso neste processo.',
        'Assigned fields' => 'Campos Atribuídos',
        'Activity dialogs are not being used in this process.' => 'Janelas de Atividade não estão em uso neste processo.',
        'Condition linking' => 'Ligação de Condições',
        'Conditions' => 'Condições',
        'Condition' => 'Condição',
        'Transitions are not being used in this process.' => 'Transições não estão em uso neste processo.',
        'Module name' => 'Nome do Módulo',
        'Transition actions are not being used in this process.' => 'Ações de Transição não estão em uso nesse processo.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Por favor, note que alterar esta transição afetará os seguintes processos',
        'Transition' => 'Transição',
        'Transition Name' => 'Nome da Transição',
        'Conditions can only operate on non-empty fields.' => 'Condições podem operar somente em campos não vazios.',
        'Type of Linking between Conditions' => 'Tipo de Ligação Entre as Condições',
        'Remove this Condition' => 'Remover Esta Condição',
        'Type of Linking' => 'Tipo de Ligação',
        'Add a new Field' => 'Adicionar Novo Campo',
        'Remove this Field' => 'Remover Este Campo',
        'And can\'t be repeated on the same condition.' => 'E não pode ser repetido na mesma condição.',
        'Add New Condition' => 'Adicionar Nova Condição',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Por favor, note que alterar esta transição afetará os seguintes processos',
        'Transition Action' => 'Ação de Transição',
        'Transition Action Name' => 'Nome da Ação de Transição',
        'Transition Action Module' => 'Módulo da Ação de Transição',
        'Config Parameters' => 'Parâmetros de Configuração',
        'Add a new Parameter' => 'Adicionar Novo Parâmetro',
        'Remove this Parameter' => 'Remover Este Parâmetro',

        # Template: AdminQueue
        'Manage Queues' => 'Gerenciar Filas',
        'Add queue' => 'Adicionar Filas',
        'Add Queue' => 'Adicionar Filas',
        'Edit Queue' => 'Alterar Filas',
        'A queue with this name already exists!' => 'Uma fila com esse nome já existe!',
        'Sub-queue of' => 'Subfila de',
        'Unlock timeout' => 'Expiração de Desbloqueio',
        '0 = no unlock' => '0 = sem desbloqueio',
        'Only business hours are counted.' => 'Apenas horas úteis são contadas.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Se um atendente bloquear um chamado e não fechá-lo antes de expirado o tempo limite de desbloqueio, o chamado será desbloqueado e ficará disponível para outros atendentes.',
        'Notify by' => 'Notificar Por',
        '0 = no escalation' => '0 = sem escalação',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Se não há um contato com o cliente adicionado, seja por e-mail externo ou telefone, ao novo chamado antes do tempo definido aqui expirar, o chamado é escalado.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Se há um artigo adicionado, tais como revisão via e-mail ou no portal do cliente, o tempo de atualização da escalada é reiniciado. Se não houver um contato com o cliente, seja por e-mail externo ou telefone, adicionado ao chamado antes de o tempo definido aqui expirar, o chamado é escalado.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Se o chamado não é definido como fechado antes de tempo definido aqui expirar, o ticket é escalado.',
        'Follow up Option' => 'Opção de Revisão',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Especifica se a revisão de um chamado fechado deve reabri-lo, ser rejeitada ou conduzir a um novo chamado.',
        'Ticket lock after a follow up' => 'Bloqueio do Chamado após uma Revisão',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Se um chamado está fechado e o cliente envia uma revisão, o chamado será bloqueado para o antigo proprietário.',
        'System address' => 'Endereço de Sistema',
        'Will be the sender address of this queue for email answers.' => 'Será o endereço de remetente desta fila para respostas por e-mail.',
        'Default sign key' => 'Chave de Assinatura Padrão',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            'Para utilizar uma chave de assinatura, chaves PGP ou certificados S/MIME precisam ser adicionados com identificadores para o endereço de sistema da fila selecionada.',
        'The salutation for email answers.' => 'A saudação para respostas por e-mail.',
        'The signature for email answers.' => 'A assinatura para respostas por e-mail.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Gerenciar Relações Autorresposta-Fila',
        'This filter allow you to show queues without auto responses' => 'Este filtro permite que você visualize filas sem auto respostas',
        'Queues without auto responses' => 'Filas sem auto resposta',
        'This filter allow you to show all queues' => 'Este filtro permite que você mostre todas as filas',
        'Show all queues' => 'Exibir todas as filas',
        'Filter for Queues' => 'Filtrar por Filas',
        'Filter for Auto Responses' => 'Filtrar por Autorrespostas',
        'Auto Responses' => 'Autorrespostas',
        'Change Auto Response Relations for Queue' => 'Alterar Relações de Autorresposta Para Filas',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Gerenciar Relações Modelo-Fila',
        'Filter for Templates' => 'Filtrar por Modelos',
        'Templates' => 'Modelos',
        'Change Queue Relations for Template' => 'Alterar Relações de Fila para Modelo',
        'Change Template Relations for Queue' => 'Alterar Relações de Modelo para Fila',

        # Template: AdminRegistration
        'System Registration Management' => 'Gerenciamento do Registro do Sistema',
        'Edit details' => 'Editar detalhes',
        'Show transmitted data' => 'Exibir dados transmitidos',
        'Deregister system' => 'Desregistrar sistema',
        'Overview of registered systems' => 'Visão geral de sistemas registrados',
        'This system is registered with OTRS Group.' => 'Este sistema está registrado com o Grupo OTRS.',
        'System type' => 'Tipo do sistema',
        'Unique ID' => 'ID Único',
        'Last communication with registration server' => 'Última comunicação com o servidor de registro',
        'System registration not possible' => 'Registro do sistema não é possível',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'Por favor, note que você não pode registrar o seu sistema se OTRS Daemon não estiver funcionando corretamente!',
        'Instructions' => 'Instruções',
        'System deregistration not possible' => 'Cancelamento do registro do sistema não é possível.',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'Por favor, note que você não pode cancelar o registro de seu sistema se você estiver usando o %s ou tendo um contrato de serviço válido.',
        'OTRS-ID Login' => 'Login OTRS-ID',
        'Read more' => 'Leia mais',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Você precisa logar com seu OTRS-ID para registrar seu sistema. ',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Seu OTRS-ID é o endereço de e-mail usado para logar no site OTRS.com.',
        'Data Protection' => 'Proteção de Dados',
        'What are the advantages of system registration?' => 'Quais são as vantagens de registrar o sistema?',
        'You will receive updates about relevant security releases.' => 'Você irá receber informações sobre atualizações de segurança relevantes.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Com seu registro de sistema podemos melhorar nossos serviços para você, porque nós temos todas as informações relevantes disponíveis.',
        'This is only the beginning!' => 'Este é apenas o começo!',
        'We will inform you about our new services and offerings soon.' =>
            'Informaremos sobre nossos novos serviços e ofertas em breve.',
        'Can I use OTRS without being registered?' => 'Eu posso utilizar o OTRS sem registrar ?',
        'System registration is optional.' => 'Registro do sistema é opcional. ',
        'You can download and use OTRS without being registered.' => 'Você pode baixar o OTRS e usá-lo sem estar registrado.',
        'Is it possible to deregister?' => 'É possível cancelar o registro?',
        'You can deregister at any time.' => 'Você pode cancelar ser registro a qualquer momento.',
        'Which data is transfered when registering?' => 'Quais dados são transferidos ao se registrar?',
        'A registered system sends the following data to OTRS Group:' => 'Um sistema registrado envia os seguintes dados ao grupo do OTRS:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Fully Qualified Domain Name (FQDN), versão do OTRS, versão do banco de dados, Sistema Operacional e Perl.',
        'Why do I have to provide a description for my system?' => 'Por que tenho que fornecer uma descrição para o meu sistema?',
        'The description of the system is optional.' => 'A descrição do sistema é opcional.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'A descrição e o tipo de sistema que você especificar lhe ajudará a identificar e gerenciar os detalhes de seus sistemas registrados.',
        'How often does my OTRS system send updates?' => 'Quantas vezes meu sistema OTRS envia atualizações?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Seu sistema enviará atualizações para o registro do servidor em intervalos regulares.',
        'Typically this would be around once every three days.' => 'Normalmente, isso seria em torno de uma vez a cada três dias.',
        'Please visit our' => 'Por favor, visite nosso',
        'portal' => 'portal',
        'and file a request.' => 'e encaminhe uma requisição.',
        'If you deregister your system, you will lose these benefits:' =>
            'Se você cancelar o registro de seu sistema, você vai perder estes benefícios:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Você precisa fazer login com seu OTRS-ID para cancelar o registro de seu sistema.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'Não possui um OTRS-ID ainda?',
        'Sign up now' => 'Entrar agora',
        'Forgot your password?' => 'Esqueceu sua senha?',
        'Retrieve a new one' => 'Receba uma nova',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Estes dados serão transferidos frequentemente para o Grupo OTRS quando você registrar este sistema.',
        'Attribute' => 'Atributo',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'Versão do OTRS',
        'Operating System' => 'Sistema Operacional',
        'Perl Version' => 'Versão Perl',
        'Optional description of this system.' => 'Descrição opcional deste sistema.',
        'Register' => 'Registrar',
        'Deregister System' => 'Desregistrar Sistema',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Continuando com este passo irá cancelar o registro de sistema do grupo de OTRS.',
        'Deregister' => 'Desregistrar',
        'You can modify registration settings here.' => 'Você pode modificar configurações de registro aqui.',
        'Overview of transmitted data' => 'Visão geral dos dados transmitidos',
        'There is no data regularly sent from your system to %s.' => 'Não há dados regularmente enviados do seu sistema para %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Os seguintes dados de seu sistema são enviados no mínimo a cada 3 dias para %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Os dados serão transferidos através de uma conexão segura https no formato JSON.',
        'System Registration Data' => 'Dados de Registro do Sistema',
        'Support Data' => 'Dados de Suporte',

        # Template: AdminRole
        'Role Management' => 'Gerenciamento de Papéis',
        'Add role' => 'Adicionar Papel',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Crie um papel e relacione grupos a ele. Então adicione papéis aos usuários.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Até o momento não há papéis definidos. Por favor, use o botão "Adicionar Papel" para criar um novo papel.',
        'Add Role' => 'Adicionar Papel',
        'Edit Role' => 'Alterar Papel',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Gerenciar Relações Papel-Grupo',
        'Filter for Roles' => 'Filtrar por Papéis',
        'Roles' => 'Papéis',
        'Select the role:group permissions.' => 'Selecione as permissões papel:grupo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Se nada for selecionado, então não há permissões neste grupo (chamados não estarão disponíveis para o papel).',
        'Change Role Relations for Group' => 'Alterar Relações de Papel Para Grupo',
        'Change Group Relations for Role' => 'Alterar Relações de Grupo Para Papel',
        'Toggle %s permission for all' => 'Chavear permissão %s para todos',
        'move_into' => 'mover_para',
        'Permissions to move tickets into this group/queue.' => 'Permissões para mover chamados para este grupo/fila.',
        'create' => 'criar',
        'Permissions to create tickets in this group/queue.' => 'Permissões para criar chamados neste grupo/fila. ',
        'note' => 'nota',
        'Permissions to add notes to tickets in this group/queue.' => 'Permissões para adicionar notas aos chamados neste grupo/fila.',
        'owner' => 'proprietário',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permissões para alterar o proprietário do chamado para este grupo/fila.',
        'priority' => 'prioridade',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permissões para alterar a prioridade do chamado neste grupo/fila.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Gerenciar Relações Atendente-Papel',
        'Add agent' => 'Adicionar Atendente',
        'Filter for Agents' => 'Filtrar por Atendentes',
        'Agents' => 'Atendentes',
        'Manage Role-Agent Relations' => 'Gerenciar Relações Papel-Atendente',
        'Change Role Relations for Agent' => 'Alterar Relações de Papel Para Atendente',
        'Change Agent Relations for Role' => 'Alterar Relações de Atendente Para Papel',

        # Template: AdminSLA
        'SLA Management' => 'Gerenciamento de SLA',
        'Add SLA' => 'Adicionar SLA',
        'Edit SLA' => 'Alterar SLA',
        'Please write only numbers!' => 'Por favor, escreva apenas números!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gerenciamento S/MIME',
        'SMIME support is disabled' => 'Suporte a SMIME desabilitado',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            'Para poder usar o SMIME no OTRS, você precisa ativar isto primeiro.',
        'Enable SMIME support' => 'Habilitar suporte SMIME',
        'Faulty SMIME configuration' => 'Erro na configuração de SMIME',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Suporte SMIME está ativo, mas configurações importantes estão com erro. Por favor verifique as configurações usando o botão abaixo.',
        'Check SMIME configuration' => 'Verificar configuração de SMIME',
        'Add certificate' => 'Adicionar Certificado',
        'Add private key' => 'Adicionar Chave Privada',
        'Filter for certificates' => 'Filtrar por Certificados',
        'Filter for S/MIME certs' => 'Filtrar por certificados S/MIME',
        'To show certificate details click on a certificate icon.' => 'Para mostrar detalhes do certificado clique no ícone do certificado',
        'To manage private certificate relations click on a private key icon.' =>
            'Para gerenciar os certificados privados clique no ícone de chave privada.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Aqui você pode adicionar as relações de seu certificado privado, estes serão incorporados à assinatura de S/MIME toda vez que você usar este certificado para assinar um e-mail.',
        'See also' => 'Veja também',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Neste caso, você pode editar diretamente a certificação e chaves privadas no sistema de arquivos.',
        'Hash' => 'Hash',
        'Handle related certificates' => 'Gerenciar Certificados Relacionados',
        'Read certificate' => 'Ler Certificado',
        'Delete this certificate' => 'Excluir este certificado',
        'Add Certificate' => 'Adicionar Certificado',
        'Add Private Key' => 'Adicionar Chave Privada',
        'Secret' => 'Senha',
        'Related Certificates for' => 'Certificados Relacionados para',
        'Delete this relation' => 'Remover esta relação',
        'Available Certificates' => 'Certificados Disponíveis',
        'Relate this certificate' => 'Relacionar este certificado',

        # Template: AdminSMIMECertRead
        'Close dialog' => 'Fechar diálogo',
        'Certificate details' => 'Detalhes do certificado',

        # Template: AdminSalutation
        'Salutation Management' => 'Gerenciamento de Saudação',
        'Add salutation' => 'Adicionar Saudação',
        'Add Salutation' => 'Adicionar Saudação',
        'Edit Salutation' => 'Alterar Saudação',
        'e. g.' => 'ex.',
        'Example salutation' => 'Saudação de exemplo',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'O modo seguro precisa ser habilitado!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'O modo seguro é (normalmente) configurado após a instalação estar completa.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Se o modo seguro não estiver ativado, ative-o através do SysConfig, porque sua aplicação já está executando.',

        # Template: AdminSelectBox
        'SQL Box' => 'Comandos SQL',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Aqui você pode inserir SQL para enviá-lo diretamente para o banco de dados do aplicativo. Não é possível alterar o conteúdo das tabelas, são permitidas somente consultas.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Aqui você pode entrar consultas SQL para enviá-las diretamente ao banco de dados do aplicativo.',
        'Only select queries are allowed.' => 'Apenas consultas estão liberadas',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'A sintaxe da sua consulta SQL está incorreta. Por favor, verifique.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Há pelo menos um parâmetro ausente para a ligação. Por favor, verifique.',
        'Result format' => 'Formato de Resultado',
        'Run Query' => 'Executar Consulta',
        'Query is executed.' => 'Consulta executada.',

        # Template: AdminService
        'Service Management' => 'Gerenciamento de Serviços',
        'Add service' => 'Adicionar Serviço',
        'Add Service' => 'Adicionar Serviço',
        'Edit Service' => 'Alterar Serviço',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'Tamanho máximo do nome do Serviço é de 200 caracteres (incluindo Sub-Serviços)',
        'Sub-service of' => 'Subserviço de',

        # Template: AdminSession
        'Session Management' => 'Gerenciamento de Sessões',
        'All sessions' => 'Todas as Sessões',
        'Agent sessions' => 'Sessões de Atendente',
        'Customer sessions' => 'Sessões de Cliente',
        'Unique agents' => 'Atendentes Únicos',
        'Unique customers' => 'Clientes Únicos',
        'Kill all sessions' => 'Finalizar Todas as Sessões',
        'Kill this session' => 'Finalizar Esta Sessão',
        'Session' => 'Sessão',
        'Kill' => 'Finalizar',
        'Detail View for SessionID' => 'Detalhes aa SessãoID',

        # Template: AdminSignature
        'Signature Management' => 'Gerenciamento de Assinaturas',
        'Add signature' => 'Adicionar Assinatura',
        'Add Signature' => 'Adicionar Assinatura',
        'Edit Signature' => 'Alterar Assinatura',
        'Example signature' => 'Assinatura de exemplo',

        # Template: AdminState
        'State Management' => 'Gerenciamento de Estado',
        'Add state' => 'Adicionar Estado',
        'Please also update the states in SysConfig where needed.' => 'Por favor, também atualize os Estados em SysConfig onde necessário.',
        'Add State' => 'Adicionar Estado',
        'Edit State' => 'Alterar Estado',
        'State type' => 'Tipo de Estado',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            'Não é possível invalidar esta entrada porque não existe nenhum outro estado de agrupamento no sistema!',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => 'Envio de dados de suporte para o grupo OTRS não é possível',
        'Enable Cloud Services' => 'Habilitar Serviços de Nuvem',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'Estes dados são enviados para o Grupo OTRS regularmente. Para parar de enviar estes dados, por favor atualize seu registro de sistema.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Você pode disparar manualmente o envio de Dados de Suporte pressionando este botão:',
        'Send Update' => 'Enviar Atualização',
        'Sending Update...' => 'Enviando Atualização...',
        'Support Data information was successfully sent.' => 'Informação de Suporte enviada com sucesso.',
        'Was not possible to send Support Data information.' => 'Não foi possível enviar informações dados de suporte.',
        'Update Result' => 'Resultado da Atualização',
        'Currently this data is only shown in this system.' => 'Atualmente estes dados são mostrados apenas neste sistema.',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Um pacote de suporte (incluindo: informações de registro do sistema, dados de suporte, uma lista de pacotes instalados e todos os arquivos de código fonte modificados localmente) pode ser gerado pressionando este botão:',
        'Generate Support Bundle' => 'Gerar Pacote de Suporte',
        'Generating...' => 'Gerando...',
        'It was not possible to generate the Support Bundle.' => 'Não foi possível gerar o Pacote de Suporte.',
        'Generate Result' => 'Gerar Resultado',
        'Support Bundle' => 'Pacote de Suporte',
        'The mail could not be sent' => 'A mensagem não pôde ser enviada',
        'The support bundle has been generated.' => 'O pacote de suporte foi gerado.',
        'Please choose one of the following options.' => 'Por favor escolha uma das opções a seguir.',
        'Send by Email' => 'Enviar por E-mail',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'O pacote de suporte é muito grande para enviar via e-mail, esta opção foi desabilitada.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'O endereço de email para este usuário é inválido, esta opção foi desabilitada.',
        'Sending' => 'Enviando',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'O pacote de suporte será enviado para o Grupo OTRS via e-mail automaticamente.',
        'Download File' => 'Baixar Arquivo',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'Um arquivo contendo o pacote de suporte será baixado para o sistema local. Por favor, salve o arquivo e o envie para o Grupo OTRS usando um método alternativo.',
        'Error: Support data could not be collected (%s).' => 'Erro: Dados de Suporte não podem ser coletados (%s).',
        'Details' => 'Detalhes',

        # Template: AdminSysConfig
        'SysConfig' => 'Configuração do Sistema',
        'Navigate by searching in %s settings' => 'Navegar por meio de pesquisa nas configurações %s.',
        'Navigate by selecting config groups' => 'Navegar selecionando os grupos de configuração.',
        'Download all system config changes' => 'Baixar todas as alterações na configuraão do sistema',
        'Export settings' => 'Exportar Configurações',
        'Load SysConfig settings from file' => 'Carregar configurações SysConfig de um arquivo',
        'Import settings' => 'Importar Configurações',
        'Import Settings' => 'Importar Configurações',
        'Please enter a search term to look for settings.' => 'Por favor, entre com um termo de pesquisa para procurar configurações.',
        'Subgroup' => 'Subgrupo',
        'Elements' => 'Elementos',

        # Template: AdminSysConfigEdit
        'Edit Config Settings in %s → %s' => 'Editar Definições de Configurações em %s → %s',
        'This setting is read only.' => 'Essa configuração é apenas leitura',
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
        'Delete this entry' => 'Excluir esta entrada',
        'Create new entry' => 'Criar nova entrada',
        'New group' => 'Novo grupo',
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
        'NavBar module' => 'Modulo NavBar',
        'Year' => 'Ano',
        'Month' => 'Mês',
        'Day' => 'Dia',
        'Invalid year' => 'Ano inválido',
        'Invalid month' => 'Mês inválido',
        'Invalid day' => 'Dia inválido',
        'Show more' => 'Exibir mais',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Gerenciamento de Endereço de E-mail de Sistema',
        'Add system address' => 'Adicionar Endereços de Sistema',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Todos os e-mails recebidos com este endereço no campo Para ou Cc serão encaminhados para a fila selecionada.',
        'Email address' => 'Endereço de E-mail',
        'Display name' => 'Nome de Exibição',
        'Add System Email Address' => 'Adicionar Endereço de E-mail de Sistema',
        'Edit System Email Address' => 'Alterar Endereço de e-mail de Sistema',
        'This email address is already used as system email address.' => 'Este endereço de e-mail já está sendo usado como Endereço de E-mail do Sistema.',
        'The display name and email address will be shown on mail you send.' =>
            'O nome de exibição e endereço de e-mail serão mostrados no e-mail enviado.',
        'This system address cannot be set to invalid, because it is used in one or more queue(s).' =>
            'Este Endereço de E-mail do Sistema não pode ser definido como inválido, por ele já estar sendo usado em uma ou mais Filas.',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Gerenciamento de Manutenção do Sistema',
        'Schedule New System Maintenance' => 'Agendar Nova Manutenção do Sistema',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Agende um período de manutenção do sistema para anunciar aos Atendentes e Clientes que o sistema estará indisponível por um período de tempo.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Algum tempo antes da manutenção do sistema iniciar, os usuários receberão uma notificação em todas as telas anunciando sobre  este fato.',
        'Start date' => 'Data de início',
        'Stop date' => 'Data de fim',
        'Delete System Maintenance' => 'Deletar manutenção do sistema',
        'Do you really want to delete this scheduled system maintenance?' =>
            'Você quer mesmo excluir esta manutenção programada do sistema?',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => 'Editar Manutenção do Sistema  %s',
        'Edit System Maintenance Information' => 'Editar informação da manutenção de sistema',
        'Date invalid!' => 'Data inválida!',
        'Login message' => 'Mensagem de autenticação',
        'This field must have less then 250 characters.' => 'Este campo deve ter menos do que 250 caracteres.',
        'Show login message' => 'Mostrar mensagem de autenticação',
        'Notify message' => 'Mensagem de notificação',
        'Manage Sessions' => 'Gerenciar Sessões',
        'All Sessions' => 'Todas as Sessões',
        'Agent Sessions' => 'Sessões de Atendente',
        'Customer Sessions' => 'Sessões de Cliente',
        'Kill all Sessions, except for your own' => 'Matar todas as Sessões, exceto a sua.',

        # Template: AdminTemplate
        'Manage Templates' => 'Gerenciar Modelos',
        'Add template' => 'Adicionar modelo',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Um modelo é um texto padrão que ajuda os atendentes a redigir chamados, respostas ou encaminhamentos mais rapidamente.',
        'Don\'t forget to add new templates to queues.' => 'Não se esqueça de adicionar os novos modelos a filas.',
        'Do you really want to delete this template?' => 'Você quer realmente excluir este modelo?',
        'Add Template' => 'Adicionar Modelo',
        'Edit Template' => 'Editar Modelo',
        'A standard template with this name already exists!' => 'Um modelo padrão com este nome já existe!',
        'Create type templates only supports this smart tags' => 'Criar modelos de tipo apenas suporta estas etiquetas inteligentes',
        'Example template' => 'Modelo exemplo',
        'The current ticket state is' => 'O estado atual do chamado é',
        'Your email address is' => 'Seu endereço de e-mail é',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'Gerenciar Relações Modelos <-> Anexos',
        'Filter for Attachments' => 'Filtrar por Anexos',
        'Change Template Relations for Attachment' => 'Alterar Relações Modelo para Anexo',
        'Change Attachment Relations for Template' => 'Alterar Relações Anexo para Modelo',
        'Toggle active for all' => 'Chavear ativado para todos',
        'Link %s to selected %s' => 'Associar %s ao %s selecionado',

        # Template: AdminType
        'Type Management' => 'Gerenciamento de Tipo',
        'Add ticket type' => 'Adicionar Tipo de Chamado',
        'Add Type' => 'Adicionar Tipo',
        'Edit Type' => 'Alterar Tipo',
        'A type with this name already exists!' => 'Um tipo com esse nome já existe!',

        # Template: AdminUser
        'Agents will be needed to handle tickets.' => 'Atendentes serão necessários para lidar com os chamados.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Não se esqueça de adicionar o novo atendente a grupos e/ou papéis!',
        'Please enter a search term to look for agents.' => 'Por favor, digite um termo de pesquisa para localizar atendentes.',
        'Last login' => 'Última autenticação',
        'Switch to agent' => 'Trocar para atendente',
        'Add Agent' => 'Adicionar Atendente',
        'Edit Agent' => 'Alterar Atendente',
        'Title or salutation' => 'Título ou saudação',
        'Firstname' => 'Nome',
        'Lastname' => 'Sobrenome',
        'A user with this username already exists!' => 'Um usuário com esse Nome de usuário já existe!',
        'Will be auto-generated if left empty.' => 'Será autogerado se deixado em vazio.',
        'Start' => 'Início',
        'End' => 'Fim',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gerenciar Relações Atendente-Grupo',
        'Add group' => 'Adicionar Grupo',
        'Change Group Relations for Agent' => 'Alterar Relações de Grupo Para Atendente',
        'Change Agent Relations for Group' => 'Alterar Relações de Atendente Para Grupo',

        # Template: AgentBook
        'Address Book' => 'Catálogo de Endereços',
        'Search for a customer' => 'Procurar um cliente',
        'Add email address %s to the To field' => 'Adicionar endereço de e-mail %s ao campo "Para"',
        'Add email address %s to the Cc field' => 'Adicionar endereço de e-mail %s ao campo "Cc"',
        'Add email address %s to the Bcc field' => 'Adicionar endereço de e-mail %s ao campo "Cco"',
        'Apply' => 'Aplicar',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Centro de Informação do Cliente',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Usuário Cliente',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Entrada duplicada',
        'This address already exists on the address list.' => 'Este endereço já existe na lista de endereços.',
        'It is going to be deleted from the field, please try again.' => 'Será excluído do campo, por favor, tente novamente.',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Nota: Cliente inválido!',
        'Start chat' => 'Iniciar chat',
        'Video call' => 'Vídeo chamada',
        'Audio call' => 'Chamada por áudio',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'O Daemon do OTRS é um processo de daemon que executa tarefas assíncronas, por exemplo, escalonamento de chamados, enviando e-mail, etc.',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            'A execução do OTRS Daemon é obrigatório para a correta operação do sistema.',
        'Starting the OTRS Daemon' => 'Iniciado o OTRS Daemon',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            'Certifique-se de que existe o arquivo \'%s\' (sem a extensão .dist). Essa tarefa do cron irá verificar a cada 5 minutos se o OTRS Daemon está em execução e irá iniciá-lo se necessário.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            'Execute \'%s start\' para certificar-se de que as tarefas do cron do usuário \'otrs\' estão ativos.',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            'Após 5 minutos, verifique se o OTRS Daemon está em execução no sistema (\'bin/otrs.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Painel',

        # Template: AgentDashboardCalendarOverview
        'in' => 'em',

        # Template: AgentDashboardCommon
        'Save settings' => 'Salvar configurações',
        'Close this widget' => 'Fechar este widget',
        'Available Columns' => 'Colunas Disponíveis',
        'Visible Columns (order by drag & drop)' => 'Colunas Visíveis (arrastar e soltar p/ reordenar)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Chamados Escalados',

        # Template: AgentDashboardCustomerUserList
        'Customer login' => 'Autenticação do Cliente',
        'Customer information' => 'Informação do Cliente',
        'Phone ticket' => 'Chamado Fone',
        'Email ticket' => 'Chamado E-mail',
        '%s open ticket(s) of %s' => '%s chamado(s) aberto(s) de %s',
        '%s closed ticket(s) of %s' => '%s chamado(s) fechado(s) de %s',
        'New phone ticket from %s' => 'Novo chamado via fone de %s',
        'New email ticket to %s' => 'Novo chamado via e-mail de %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s está disponível!',
        'Please update now.' => 'Por favor atualize agora.',
        'Release Note' => 'Notas da Versão',
        'Level' => 'Nível',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Postado há %s atrás.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'A configuração para essa estatística contém erros, favor rever suas configurações.',
        'Download as SVG file' => 'Baixar como arquivo SVG',
        'Download as PNG file' => 'Baixar como arquivo PNG',
        'Download as CSV file' => 'Baixar como arquivo CSV',
        'Download as Excel file' => 'Baixar como arquivo Excel',
        'Download as PDF file' => 'Baixar como arquivo PDF',
        'Grouped' => 'Agrupado',
        'Stacked' => 'Empilhado',
        'Expanded' => 'Expandido',
        'Stream' => 'Fluxo',
        'No Data Available.' => 'Nenhum dado disponível.',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Por favor selecione um formato de saída de gráfico válido na configuração desse widget.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'O conteúdo desta estatística está sendo preparado para você, por favor seja paciente.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Essa estatística não pode ser usada nesse momento por que a configuração precisa ser corrigida pelo administrador de estatísticas.',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Meus Chamados Bloqueados',
        'My watched tickets' => 'Meus Chamados Monitorados',
        'My responsibilities' => 'Minhas Responsabilidades',
        'Tickets in My Queues' => 'Chamados nas Minhas Filas',
        'Tickets in My Services' => 'Chamados em Meus Serviços',
        'Service Time' => 'Tempo de Serviço',
        'Remove active filters for this widget.' => 'Remover filtros ativos para este painel.',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'Totais',

        # Template: AgentDashboardUserOnline
        'out of office' => 'fora do escritório',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'até',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'O chamado foi bloqueado',
        'Undo & close' => 'Desfazer e fechar',

        # Template: AgentInfo
        'Info' => 'Informação',
        'To accept some news, a license or some changes.' => 'Para aceitar algumas novidades, uma licença ou algumas mudanças.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Objeto Associado: %s',
        'go to link delete screen' => 'ir para a tela de exclusão de associação',
        'Select Target Object' => 'Selecionar o Objeto Alvo',
        'Link object %s with' => 'Associe objeto %s com',
        'Unlink Object: %s' => 'Desassociar Objeto: %s',
        'go to link add screen' => 'ir para a tela de inclusão de associação',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => 'Uso não autorizado de %s detectado',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => 'Alterar Suas Preferências',
        'Did you know? You can help translating OTRS at %s.' => 'Você sabia? Você pode ajudar a traduzir o OTRS em %s.',

        # Template: AgentSpelling
        'Spell Checker' => 'Verificador Ortográfico',
        'spelling error(s)' => 'erro(s) ortográficos',
        'Apply these changes' => 'Aplicar estas modificações',

        # Template: AgentStatisticsAdd
        'Statistics » Add' => 'Estatística  » Adicionar',
        'Add New Statistic' => 'Adicionar Nova Estatística',
        'Dynamic Matrix' => 'Matriz Dinâmica ',
        'Tabular reporting data where each cell contains a singular data point (e. g. the number of tickets).' =>
            'Tabela com dados de relatório na qual cada célula contém um ponto singular de dados (ex., o número de chamados).',
        'Dynamic List' => 'Lista Dinâmica',
        'Tabular reporting data where each row contains data of one entity (e. g. a ticket).' =>
            'Tabela com dados de relatório na qual cada linha contém dados de uma entidade (ex., um chamado).',
        'Static' => 'Estático',
        'Complex statistics that cannot be configured and may return non-tabular data.' =>
            'Estatísticas complexas que não podem ser configuradas e podem retornar dados não-tabulares.',
        'General Specification' => 'Especificação Geral',
        'Create Statistic' => 'Criar Estatística',

        # Template: AgentStatisticsEdit
        'Statistics » Edit %s%s — %s' => 'Estatísticas » Editar %s%s — %s',
        'Run now' => 'Executar agora',
        'Statistics Preview' => 'Pré-visualização da Estatística ',
        'Save statistic' => 'Salvar estatística',

        # Template: AgentStatisticsImport
        'Statistics » Import' => 'Estatísticas » Importar',
        'Import Statistic Configuration' => 'Importar Configuração de Estatística',

        # Template: AgentStatisticsOverview
        'Statistics » Overview' => 'Estatísticas » Visão Geral',
        'Statistics' => 'Estatísticas',
        'Run' => 'Executar',
        'Edit statistic "%s".' => 'Editar estatística "%s".',
        'Export statistic "%s"' => 'Exportar estatística "%s"',
        'Export statistic %s' => 'Exportar estatística %s',
        'Delete statistic "%s"' => 'Excluir estatística "%s"',
        'Delete statistic %s' => 'Excluir estatística %s',
        'Do you really want to delete this statistic?' => 'Você quer realmente excluir esta estatística?',

        # Template: AgentStatisticsView
        'Statistics » View %s%s — %s' => 'Estatísticas » Ver %s%s — %s',
        'Statistic Information' => 'Informação da Estatística',
        'Sum rows' => 'Somar Linhas',
        'Sum columns' => 'Somar Colunas',
        'Show as dashboard widget' => 'Exibir como componente no painel',
        'Cache' => 'Cache',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Esta estatística contém erros de configuração e não pode ser gerada agora.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'Alterar Texto Livre de %s%s',
        'Change Owner of %s%s%s' => 'Mudar proprietário de %s%s%s',
        'Close %s%s%s' => 'Fechar %s%s%s',
        'Add Note to %s%s%s' => 'Adicionar nota para %s%s%s',
        'Set Pending Time for %s%s%s' => 'Configurar horário de pendência para %s%s%s',
        'Change Priority of %s%s%s' => 'Alterar Prioridade de %s%s',
        'Change Responsible of %s%s%s' => 'Alterar Responsável de %s%s',
        'All fields marked with an asterisk (*) are mandatory.' => 'Todos os campos marcados com um asterisco (*) são obrigatórios.',
        'Service invalid.' => 'Serviço inválido.',
        'New Owner' => 'Novo Proprietário',
        'Please set a new owner!' => 'Por favor, configure um novo proprietário!',
        'New Responsible' => 'Novo Responsável',
        'Next state' => 'Próximo estado',
        'For all pending* states.' => 'Para todos os estados *pendente*.',
        'Add Article' => 'Adicionar Artigo',
        'Create an Article' => 'Criar um Artigo',
        'Inform agents' => 'Informar atendentes',
        'Inform involved agents' => 'Informar atendentes envolvidos',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Aqui você pode selecionar atendentes adicionais que deveriam receber uma notificação relacionada ao novo artigo.',
        'Text will also be received by' => 'Texto também será recebido por',
        'Spell check' => 'Verificar Ortografia',
        'Text Template' => 'Modelo de Texto',
        'Setting a template will overwrite any text or attachment.' => 'Configurar um modelo irá sobrescrever qualquer texto ou anexo.',
        'Note type' => 'Tipo de nota',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'Repassar %s%s%s',
        'Bounce to' => 'Devolver para',
        'You need a email address.' => 'Você precisa de um endereço de e-mail.',
        'Need a valid email address or don\'t use a local email address.' =>
            'ecessita de um endereço de e-mail válido; não use endereços de e-mail locais.',
        'Next ticket state' => 'Próximo Estado do Chamado',
        'Inform sender' => 'Informar ao Remetente',
        'Send mail' => 'Enviar e-mail!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ação em Massa em Chamado',
        'Send Email' => 'Enviar E-mail',
        'Merge to' => 'Agrupar com',
        'Invalid ticket identifier!' => 'Identificador de chamado inválido!',
        'Merge to oldest' => 'Agrupar com o mais antigo',
        'Link together' => 'Associar junto',
        'Link to parent' => 'Associar ao pai',
        'Unlock tickets' => 'Desbloquear chamados',
        'Execute Bulk Action' => 'Executar Ação em Massa',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Compor resposta para %s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'Esse endereço está registrado como endereço do sistema e não pode ser usado: %s',
        'Please include at least one recipient' => 'Por favor, inclua pelo menos um destinatário',
        'Remove Ticket Customer' => 'Remover Cliente do Chamado',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Por favor, remova esta entrada e digite uma nova com o valor correto.',
        'Remove Cc' => 'Remover Cc',
        'Remove Bcc' => 'Remover Bcc',
        'Address book' => 'Catálogo de Endereços',
        'Date Invalid!' => 'Data Inválida!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Alterar Cliente de %s%s',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Criar Novo Chamado Via E-mail',
        'Example Template' => 'Exemplo de Modelo',
        'From queue' => 'Da Fila',
        'To customer user' => 'Para usuário cliente',
        'Please include at least one customer user for the ticket.' => 'Por favor, inclua ao menos um usuário cliente para este chamado.',
        'Select this customer as the main customer.' => 'Selecione este cliente como principal',
        'Remove Ticket Customer User' => 'Remover Usuário Cliente do Chamado',
        'Get all' => 'Obter todos',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'E-mail de saída para %s%s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Chamado %s: tempo de resposta inicial ultrapassado (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Chamado %s: tempo de resposta inicial será ultrapassado em %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Chamado %s: tempo de atualização está ultrapassado (%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'Chamado %s: tempo de atualização será ultrapassado em %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Chamado %s: tempo de solução ultrapassado (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Chamado %s: tempo de solução será ultrapassado em %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Encaminhar %s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'Histórico de %s%s',
        'History Content' => 'Conteúdo do Histórico',
        'Zoom view' => 'Visão de detalhe',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Agrupar %s%s',
        'Merge Settings' => 'Configurações de Agrupamento',
        'You need to use a ticket number!' => 'Você deve utilizar um número de chamado!',
        'A valid ticket number is required.' => 'Um número de chamado válido é obrigatório.',
        'Need a valid email address.' => 'É necessário um endereço de e-mail válido.',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Mover %s%s',
        'New Queue' => 'Nova Fila',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Selecionar Todos',
        'No ticket data found.' => 'Nenhum dado de chamado encontrado.',
        'Open / Close ticket action menu' => 'Menu de Abrir / Fechar chamado',
        'Select this ticket' => 'Selecionar esse chamado',
        'First Response Time' => 'Prazo de Resposta Inicial',
        'Update Time' => 'Prazo de Atualização',
        'Solution Time' => 'Prazo de Solução',
        'Move ticket to a different queue' => 'Mover Chamado Para Uma Fila Diferente',
        'Change queue' => 'Alterar fila',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Alterar as Opções de Busca',
        'Remove active filters for this screen.' => 'Remover filtros ativos para esta tela.',
        'Tickets per page' => 'Chamados por página',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Redefinir visão',
        'Column Filters Form' => 'Formulário de Filtros de Coluna',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Dividir em Novo Chamado Fone',
        'Save Chat Into New Phone Ticket' => 'Salvar Chat em Novo Chamado Fone',
        'Create New Phone Ticket' => 'Criar Novo Chamado Via Fone',
        'Please include at least one customer for the ticket.' => 'Por favor, inclua pelo menos um cliente para o chamado.',
        'To queue' => 'Para a fila',
        'Chat protocol' => 'Protocolo de bate-papo',
        'The chat will be appended as a separate article.' => 'A conversa será adicionada como um artigo separado.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Telefonema para %s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'Visualizar texto do E-mail para %s%s%s',
        'Plain' => 'Plano',
        'Download this email' => 'Baixar este e-mail',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Criar Novo Chamado de Processo',
        'Process' => 'Processo',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Registrar chamado em um Processo',

        # Template: AgentTicketSearch
        'Search template' => 'Modelo de Busca',
        'Create Template' => 'Criar Modelo',
        'Create New' => 'Criar Novo',
        'Profile link' => 'Linkar Modelo',
        'Save changes in template' => 'Salvar mudanças no modelo',
        'Filters in use' => 'Filtros em uso',
        'Additional filters' => 'Filtros adicionais',
        'Add another attribute' => 'Adicionar outro Atributo',
        'Output' => 'Saída',
        'Fulltext' => 'Texto Completo',
        'Remove' => 'Remover',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'Buscas pelos atributos De, Para, Cc, Assunto e corpo do artigo, sobrescreve outros atributos com o mesmo nome.',
        'CustomerID (complex search)' => 'CustomerID (procura complexa)',
        '(e. g. 234*)' => '(ex.: 234*)',
        'CustomerID (exact match)' => 'CustomerID (correspondência exata)',
        'Customer User Login (complex search)' => 'Login de Usuário Cliente (busca complexa)',
        '(e. g. U51*)' => '(ex.: U51*)',
        'Customer User Login (exact match)' => 'Login de Usuário Cliente (correspondência exata)',
        'Attachment Name' => 'Nome do Anexo',
        '(e. g. m*file or myfi*)' => '(ex. meu*rquivo ou meuarq*)',
        'Created in Queue' => 'Criado na Fila',
        'Lock state' => 'Estado de bloqueio',
        'Watcher' => 'Monitorante',
        'Article Create Time (before/after)' => 'Tempo de Criação do Artigo (antes/depois)',
        'Article Create Time (between)' => 'Tempo de Criação do Artigo (entre)',
        'Invalid date' => 'Data Inválida',
        'Ticket Create Time (before/after)' => 'Tempo de Criação do Chamado (antes/depois)',
        'Ticket Create Time (between)' => 'Tempo de Criação do Chamado (entre)',
        'Ticket Change Time (before/after)' => 'Tempo de Modificação do Chamado (antes/depois)',
        'Ticket Change Time (between)' => 'Tempo de Modificação do Chamado (entre)',
        'Ticket Last Change Time (before/after)' => 'Tempo da Última Modificação do Chamado (antes/depois)',
        'Ticket Last Change Time (between)' => 'Tempo da Última Modificação do Chamado (entre)',
        'Ticket Close Time (before/after)' => 'Tempo de Fechamento do Chamado (antes/depois)',
        'Ticket Close Time (between)' => 'Tempo de Fechamento do Chamado (durante)',
        'Ticket Escalation Time (before/after)' => 'Tempo de Escalação do Chamado (antes/depois)',
        'Ticket Escalation Time (between)' => 'Tempo de Escalação do Chamado (entre)',
        'Archive Search' => 'Procurar Arquivo',
        'Run search' => 'Pesquisar',

        # Template: AgentTicketZoom
        'Article filter' => 'Filtro Para Artigo',
        'Article Type' => 'Tipo de Artigo',
        'Sender Type' => 'Tipo de Remetente',
        'Save filter settings as default' => 'Salvar configurações de filtro como padrão',
        'Event Type Filter' => 'Filtro de Tipo de Evento',
        'Event Type' => 'Tipo de Evento',
        'Save as default' => 'Salvar como padrão',
        'Archive' => 'Arquivar',
        'This ticket is archived.' => 'Este chamado está arquivado.',
        'Note: Type is invalid!' => 'Nota: Tipo é inválido!',
        'Locked' => 'Bloqueio',
        'Accounted time' => 'Tempo Contabilizado',
        'Linked Objects' => 'Objetos Associados',
        'Change Queue' => 'Alterar Fila',
        'There are no dialogs available at this point in the process.' =>
            'Não existem diálogos disponíveis neste ponto do processo.',
        'This item has no articles yet.' => 'Este item não tem artigos ainda.',
        'Ticket Timeline View' => 'Visão da Cronologia do Chamado',
        'Article Overview' => 'Visão Geral de Artigos',
        'Article(s)' => 'Artigo(s)',
        'Page' => 'Página',
        'Add Filter' => 'Adicionar Filtro',
        'Set' => 'Configurar',
        'Reset Filter' => 'Reiniciar Filtro',
        'Show one article' => 'Exibir um Artigo',
        'Show all articles' => 'Exibir Todos os Artigos',
        'Show Ticket Timeline View' => 'Mostrar a Cronologia do Chamado',
        'Unread articles' => 'Artigos Não Lidos',
        'No.' => 'Núm.',
        'Important' => 'Importante',
        'Unread Article!' => 'Artigo não Lido!',
        'Incoming message' => 'Mensagem de Entrada',
        'Outgoing message' => 'Mensagem de Saída',
        'Internal message' => 'Mensagem Interna',
        'Resize' => 'Redimensionar',
        'Mark this article as read' => 'Marcar este artigo como lido',
        'Show Full Text' => 'Mostrar Texto completo',
        'Full Article Text' => 'Texto Completo do Artigo',
        'No more events found. Please try changing the filter settings.' =>
            'Nenhum outro evento foi encontrado. Por favor tente mudar as configurações de filtro.',
        'by' => 'por',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Para abrir links no artigo seguinte, talvez você precise pressionar Ctrl, Cmd ou Shift enquanto clica no link (dependendo do seu navegador ou sistema operacional).',
        'Close this message' => 'Fechar esta mensagem',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'O artigo não pôde ser aberto! Talvez ele esteja em outra página de artigo?',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Para proteger sua privacidade, o conteúdo remoto foi desabilitado.',
        'Load blocked content.' => 'Carregar conteúdo bloqueado.',

        # Template: ChatStartForm
        'First message' => 'Primeira mensagem',

        # Template: CloudServicesDisabled
        'This feature requires cloud services.' => 'Está funcionalidade requer os serviços de nuvem.',
        'You can' => 'Você pode',
        'go back to the previous page' => 'retornar à página anterior',

        # Template: CustomerAccept
        'Information' => 'Informação',
        'Dear Customer,' => 'Caro Cliente,',
        'thank you for using our services.' => 'obrigado por utilizar nossos serviços.',
        'Yes, I accepted your license.' => '',

        # Template: CustomerError
        'An Error Occurred' => 'Ocorreu um erro.',
        'Error Details' => 'Detalhes do Erro',
        'Traceback' => 'Rastreamento',

        # Template: CustomerFooter
        'Powered by' => 'Desenvolvido por',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'Um ou mais erros ocorreram!',
        'Close this dialog' => 'Fechar esta janela',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Não foi possível abrir a janela popup. Desative os bloqueadores de popup para esta aplicação.',
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Se você sair desta página agora, todas as janelas popup aberta serão fechada também!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Um popup desta janela já está aberto. Você quer fechá-lo e carregar este no lugar?',
        'There are currently no elements available to select from.' => 'Não há elementos disponíveis atualmente para seleção.',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Por favor desative o Modo de Compatibilidade no Internet Explorer!',
        'The browser you are using is too old.' => 'O navegador que você está usando é muito antigo.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'O OTRS funciona com uma lista enorme de navegadores, faça a atualização para um desses.',
        'Please see the documentation or ask your admin for further information.' =>
            'Por favor, consulte a documentação ou pergunte ao seu administrador para mais informações.',
        'Switch to mobile mode' => 'Trocar para modo móvel',
        'Switch to desktop mode' => 'Trocar para modo desktop',
        'Not available' => 'Não disponível',
        'Clear all' => 'Limpar todos',
        'Clear search' => 'Limpar busca',
        '%s selection(s)...' => '%s seleção(ões)...',
        'and %s more...' => 'e %s mais...',
        'Filters' => 'Filtros',
        'Confirm' => 'Confirmar',
        'You have unanswered chat requests' => 'Você tem uma requisição de bate-papo não respondida',
        'Accept' => 'Aceitar',
        'Decline' => 'Rejeitar',
        'An internal error occurred.' => 'Um erro interno ocorreu',
        'Connection error' => 'Erro de Conexão',
        'Reload page' => 'Atualizar página',
        'Your browser was not able to communicate with OTRS properly, there seems to be something wrong with your network connection. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            'Seu navegador não foi capaz de se comunicar corretamente com o OTRS. Parece que há algo errado com a sua conexão de rede. Você pode ou tentar recarregar esta página manualmente ou esperar até que seu navegador tenha restabelecido ele mesmo a conexão.',
        'There was an error in communication with the server. Server might be experiencing some temporary problems, please reload this page to check if they have been resolved.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            'A conexão foi restabelecida após uma perda temporária de conexão. Por causa disso, elementos nesta página podem ter parado de funcionar corretamente. Para ser capaz de novamente usar todos elementos corretamente, é altamente recomendado recarregar esta página.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript não habilitado ou não é suportado.',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'A fim de experimentar o OTRS, você deve habilitar o JavaScript no seu navegador.',
        'Browser Warning' => 'Aviso de Navegador',
        'One moment please, you are being redirected...' => 'Um momento por favor, você está sendo redirecionado...',
        'Login' => 'Login',
        'User name' => 'Nome de usuário',
        'Your user name' => 'Seu nome de usuário',
        'Your password' => 'Sua senha',
        'Forgot password?' => 'Esqueceu a senha?',
        '2 Factor Token' => 'Fator de 2 autenticação',
        'Your 2 Factor Token' => 'Seu fator de 2 autenticação',
        'Log In' => 'Entrar',
        'Not yet registered?' => 'Não registrado ainda?',
        'Request new password' => 'Solicitar uma nova senha',
        'Your User Name' => 'Seu Nome de Usuário',
        'A new password will be sent to your email address.' => 'Uma nova senha será enviada ao seu e-mail.',
        'Create Account' => 'Criar Conta',
        'Please fill out this form to receive login credentials.' => 'Por favor, preencha este formulário para receber as credenciais de autenticação.',
        'How we should address you' => 'Como devemos descrever você?',
        'Your First Name' => 'Seu Primeiro Nome',
        'Your Last Name' => 'Seu Último Nome',
        'Your email address (this will become your username)' => 'Seu e-mail (este será seu nome de usuário para login)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => 'Recebendo requisições de bate-papo',
        'Edit personal preferences' => 'Editar preferências pessoais',
        'Logout %s %s' => 'Sair %s %s',

        # Template: CustomerRichTextEditor
        'Split Quote' => 'Marca de citação',
        'Open link' => 'Abrir link',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Acordo de nível de serviço',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Bem-vindo!',
        'Please click the button below to create your first ticket.' => 'Por favor, clique no botão abaixo para criar o seu primeiro chamado.',
        'Create your first ticket' => 'Criar seu primeiro chamado',

        # Template: CustomerTicketSearch
        'Profile' => 'Perfil',
        'e. g. 10*5155 or 105658*' => 'ex. 10*5155 ou 105658*',
        'Customer ID' => 'Cliente ID',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Busca de texto completa em chamados (ex. "J*ão" ou "Carl*")',
        'Recipient' => 'Destinatário',
        'Carbon Copy' => 'Cópia',
        'e. g. m*file or myfi*' => 'ex. meu*rquivo ou meuarq*',
        'Types' => 'Tipos',
        'Time restrictions' => 'Restrições de tempo',
        'No time settings' => 'Sem configurações de tempo',
        'Specific date' => 'Data específica',
        'Only tickets created' => 'Apenas chamados criados',
        'Date range' => 'Período de data',
        'Only tickets created between' => 'Apenas chamados criados entre',
        'Ticket archive system' => 'Sistema de arquivamento de chamados',
        'Save search as template?' => 'Salvar pesquisa como modelo?',
        'Save as Template?' => 'Salvar como Modelo?',
        'Save as Template' => 'Salvar como Modelo',
        'Template Name' => 'Nome do Modelo',
        'Pick a profile name' => 'Escolha um nome de perfil',
        'Output to' => 'Saída para',

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Search Results for' => 'Resultados da pesquisa para',
        'Remove this Search Term.' => 'Remova esse termo da pesquisa',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'Iniciar um bate-papo desse chamado',
        'Expand article' => 'Expandir artigo',
        'Next Steps' => 'Pŕoximos Passos',
        'Reply' => 'Responder',
        'Chat Protocol' => 'Protocolo de bate-papo',

        # Template: DashboardEventsTicketCalendar
        'All-day' => 'Dia todo',
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
        'Event Information' => 'Informação do Evento',
        'Ticket fields' => 'Campos de chamado',
        'Dynamic fields' => 'Campos dinâmicos',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Data inválida (é necessária uma data futura)!',
        'Invalid date (need a past date)!' => 'Data inválida (é necessário uma data no passado)!',
        'Previous' => 'Anterior',
        'Open date selection' => 'Abrir seleção de data',

        # Template: Error
        'An error occurred.' => 'Um erro ocorreu.',
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            'Realmente um  erro? 5 de 10 informes de erro resultam de uma errada ou incompleta instalação do OTRS.',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            'Com %s, nossos especialistas vão cuidar de uma instalação correta e da sua retaguarda com suporte e atualizações de segurança periódicas.',
        'Contact our service team now.' => 'Contacte agora a nossa equipe de serviço.',
        'Send a bugreport' => 'Enviar um relatório de erro',

        # Template: FooterJS
        'Please enter at least one search value or * to find anything.' =>
            'Por favor, insira algum valor para a pesquisa ou * para pesquisar tudo.',
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Por favor, remova as seguintes palavras da sua pesquisa porque elas não podem ser pesquisadas:',
        'Please check the fields marked as red for valid inputs.' => 'Por favor, verifique os campos marcados em vermelho para entradas válidas.',
        'Please perform a spell check on the the text first.' => 'Por favor faça primeiro uma verificação ortográfica no texto.',
        'Slide the navigation bar' => 'Deslize a barra de navegação',
        'Unavailable for chat' => 'Indisponível para bate-papo',
        'Available for internal chats only' => 'Disponível apenas para bate-papo interno',
        'Available for chats' => 'Disponível para bate-papo',
        'Please visit the chat manager' => 'Por favor visite o gerenciador de bate-papo',
        'New personal chat request' => 'Nova solicitação de bate-papo pessoal',
        'New customer chat request' => 'Nova solicitação de bate-papo do cliente',
        'New public chat request' => 'Nova solicitação publica de bate-papo',
        'Selected user is not available for chat.' => 'Usuário selecionado não está disponível para bate-papo.',
        'New activity' => 'Nova atividade',
        'New activity on one of your monitored chats.' => 'Nova atividade em um dos seus bate-papos monitorados.',
        'Your browser does not support video and audio calling.' => 'Seu navegador não suporta chamada de áudio e vídeo.',
        'Selected user is not available for video and audio call.' => 'Usuário selecionado não está disponível para chamada de áudio e vídeo.',
        'Target user\'s browser does not support video and audio calling.' =>
            'Navegador alvo do usuário não suporta chamada de áudio e vídeo.',
        'Do you really want to continue?' => 'Você realmente quer continuar?',
        'Information about the OTRS Daemon' => 'Informação sobre o OTRS Daemon',
        'Communication error' => '',
        'This feature is part of the %s.  Please contact us at %s for an upgrade.' =>
            'Esse recursos é parte do %s. Por favor contate-nos no %s para um upgrade. ',
        'Find out more about the %s' => 'Encontre mais sobre o %s',

        # Template: Header
        'You are logged in as' => 'Você está logado como',

        # Template: Installer
        'JavaScript not available' => 'JavaScript não habilitado ou não é suportado.',
        'Step %s' => 'Passo %s',
        'Database Settings' => 'Configurações de Banco de Dados',
        'General Specifications and Mail Settings' => 'Especificações Gerais e Configurações de E-mail',
        'Finish' => 'Finalizar',
        'Welcome to %s' => 'Bem-vindo a %s',
        'Germany' => '',
        'United States' => '',
        'Mexico' => '',
        'Hungary' => '',
        'Brazil' => '',
        'Singapore' => '',
        'Hong Kong' => '',
        'Web site' => 'Website',
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

        # Template: InstallerDBResult
        'Database setup successful!' => 'Sucesso na configuração do banco de dados!',

        # Template: InstallerDBStart
        'Install Type' => 'Tipo de Instalação',
        'Create a new database for OTRS' => 'Criar um novo banco para o OTRS',
        'Use an existing database for OTRS' => 'Usar um banco existente para o OTRS',

        # Template: InstallerDBmssql
        'Database name' => 'Nome do banco',
        'Check database settings' => 'Verificar configurações de banco de dados',
        'Result of database check' => 'Resultado da verificação de banco de dados',
        'Database check successful.' => 'Êxito na verificação de banco de dados.',
        'Database User' => 'Usuário do Banco',
        'New' => 'Nova',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Um novo usuário de banco de dados com direitos limitados será criado para este sistema OTRS.',
        'Repeat Password' => 'Repita a senha',
        'Generated password' => 'Gerar senha',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Senhas não coincidem',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Porta',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Para poder utilizar o OTRS você deve digitar o seginte na linha de comando (terminal/shell) como usuário administrador (root)',
        'Restart your webserver' => 'Reiniciar o webserver',
        'After doing so your OTRS is up and running.' => 'Após fazer isto, seu sistema OTRS estará pronto para uso.',
        'Start page' => 'Iniciar página',
        'Your OTRS Team' => 'Sua Equipe de Suporte',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Não aceitar licença',
        'Accept license and continue' => 'Aceite licença e continue',

        # Template: InstallerSystem
        'SystemID' => 'ID do sistema',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'O identificador do sistema. Cada número de chamado e cada ID de sessão HTTP conterão esse número.',
        'System FQDN' => 'FQDN do sistema',
        'Fully qualified domain name of your system.' => 'Nome de domínio completamente qualificado do seu sistema.',
        'AdminEmail' => 'E-mail dos Administradores',
        'Email address of the system administrator.' => 'E-mail do administrador do sistema.',
        'Organization' => 'Organização',
        'Log' => 'Registro',
        'LogModule' => 'Módulo REGISTRO',
        'Log backend to use.' => 'Protocolo de back-end a ser usado.',
        'LogFile' => 'Arquivo de registro',
        'Webfrontend' => 'Interface Web',
        'Default language' => 'Idioma Padrão',
        'Default language.' => 'Idioma Padrão.',
        'CheckMXRecord' => 'Verificar Registro MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Endereços de e-mail que são inseridos manualmente são confrontados com os registros MX encontrados no DNS. Não use esta opção se o seu DNS é lento ou não resolve endereços públicos.',

        # Template: LinkObject
        'Object#' => 'Objeto#',
        'Add links' => 'Adicionar Associações',
        'Delete links' => 'Deletar Associações',

        # Template: Login
        'Lost your password?' => 'Esqueceu sua senha?',
        'Request New Password' => 'Solicitar uma nova senha',
        'Back to login' => 'Voltar para o login',

        # Template: MetaFloater
        'Scale preview content' => 'Escalar conteúdo anterior',
        'Open URL in new tab' => 'Abrir URL em nova aba',
        'Close preview' => 'Fechar Pré-visualização',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'Uma prévia deste site não pode ser fornecida porque ele não é permitido ser embutido.',

        # Template: MobileNotAvailableWidget
        'Feature not available' => 'Recursos não está disponível',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Desculpe mas esse recurso do OTRS não está disponível para dispositivos móveis. Se você quer utilizá-lo, você pode mudar para o modo de Desktop ou usar seu computador.',

        # Template: Motd
        'Message of the Day' => 'Mensagem do Dia',
        'This is the message of the day. You can edit this in %s.' => 'Esta é a mensagem do dia. Você pode editá-la em %s.',

        # Template: NoPermission
        'Insufficient Rights' => 'Permissões Insuficientes',
        'Back to the previous page' => 'Voltar para a página anterior',

        # Template: Pagination
        'Show first page' => 'Mostrar Primeira Página',
        'Show previous pages' => 'Mostrar Página Anterior',
        'Show page %s' => 'Mostrar Página %s',
        'Show next pages' => 'Mostrar Próxima Página',
        'Show last page' => 'Mostrar Última Página',

        # Template: PictureUpload
        'Need FormID!' => 'Necessário FormID!',
        'No file found!' => 'Nenhum arquivo encontrado!',
        'The file is not an image that can be shown inline!' => 'O arquivo não é uma imagem que pode ser mostrada embutida!',

        # Template: PreferencesNotificationEvent
        'Notification' => 'Notificações',
        'No user configurable notifications found.' => 'Nenhuma notificação configurável de usuário foi encontrada.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Receba mensagens de notificações \'%s\' pelo método de transporte \'%s\'.',
        'Please note that you can\'t completely disable notifications marked as mandatory.' =>
            'Por favor note que você não pode desabilitar completamente notificações marcadas como obrigatórias.',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Desculpe, mas você não pode desabilitar todos os métodos para notificações marcadas como mandatórias.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Desculpe, mas você não pode desabilitar todos os métodos para esta notificação.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Informação de Processo',
        'Dialog' => 'Diálogo',

        # Template: Article
        'Inform Agent' => 'Informar Atendente',

        # Template: PublicDefault
        'Welcome' => 'Bem-vindo',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            'Esta é a interface pública padrão do OTRS! Não foi dado nenhum parâmetro de ação.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'Você pode instalar um módulo público customizado (por meio do gerenciador de pacotes), por exemplo o módulo de FAQ, o qual possui uma interface pública.',

        # Template: RichTextEditor
        'Remove Quote' => 'Remover citação',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Permissões',
        'You can select one or more groups to define access for different agents.' =>
            'Você pode selecionar um ou mais grupos para definir o acesso de diferentes atendentes.',
        'Result formats' => 'Formatos de Resutaldo',
        'The selected time periods in the statistic are time zone neutral.' =>
            'O período selecionado na estatística é neutro quanto ao fuso horário.',
        'Create summation row' => 'Criar linha de somatória',
        'Generate an additional row containing sums for all data rows.' =>
            'Gerar uma linha adicional contendo somas para todas as linhas de dados.',
        'Create summation column' => 'Criar coluna de somatória',
        'Generate an additional column containing sums for all data columns.' =>
            'Gerar uma coluna adicional contendo somas para todas as colunas de dados.',
        'Cache results' => 'Resultado em cache',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'Armazena em cache dados resultantes de estatísticas para serem usados em visualizações subsequentes com a mesma configuração (requer pelo menos um campo de tempo selecionado).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Prover a estatística como um componente que agentes podem ativar no painel.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Por favor note que habilitando esse widget do tipo dashboard irá ativar o cache para essa estatística no dashboard.',
        'If set to invalid end users can not generate the stat.' => 'Se configurado como inválido, usuários finais não poderão gerar a estatística.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Existem problemas na configuração desta estatística:',
        'You may now configure the X-axis of your statistic.' => 'Você pode agora configurar o eixo X da sua estatística.',
        'This statistic does not provide preview data.' => 'Esta estatística não oferece pré-visualização de dados.',
        'Preview format:' => 'Formato de pré-visualização',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Por favor, note que a visualização usa dados aleatórios e não considera os filtros de dados.',
        'Configure X-Axis' => 'Configure o eixo X',
        'X-axis' => 'Eixo-X',
        'Configure Y-Axis' => 'Configure o eixo Y',
        'Y-axis' => 'Eixo-Y',
        'Configure Filter' => 'Configurar Filtro',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Por favor, selecione apenas um elemento ou desabilite o botão "Fixo".',
        'Absolute period' => 'Periodo absoluto',
        'Between' => 'Entre',
        'Relative period' => 'Período relativo',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'Os últimos %s completo e o periodo atual + próximo periodo completo %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Não permita alterações nesse elemento quando a estatística for gerada.',

        # Template: StatsParamsWidget
        'Format' => 'Formato',
        'Exchange Axis' => 'Trocar Eixo',
        'Configurable params of static stat' => 'Parâmetros configuráveis da estatística estática',
        'No element selected.' => 'Nenhum elemento selecionado.',
        'Scale' => 'Escala',
        'show more' => 'Mostrar mais',
        'show less' => 'Mostrar menos',

        # Template: D3
        'Download SVG' => 'Download SVG',
        'Download PNG' => 'Download PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'O período de tempo selecionado define o período de tempo padrão para esta estatística coletar dados.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Define a unidade de tempo que será usada para dividir o período de tempo selecionado em pontos de dados de relatórios.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Lembre-se de que a escala do Eixo Y tem que ser maior do que a escala do Eixo X (Por exemplo, Eixo X => Mês, Eixo Y => Ano).',

        # Template: Test
        'OTRS Test Page' => 'Página de Teste do Gerenciador de Chamados',
        'Welcome %s %s' => 'Bem-vindo %s %s',
        'Counter' => 'Contador',

        # Template: Warning
        'Go back to the previous page' => 'Voltar para a página anterior',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => 'Backend de Banco de Dados',
        'View system log messages.' => 'Ver mensagens de eventos do sistema.',
        'Update and extend your system with software packages.' => 'Atualizar e estender as funcionalidades do seu sistema com pacotes de software.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'ACLs não foram importadas devido a um erro desconhecido, por favor verifique os logs do OTRS para mais informações.',
        'The following ACLs have been added successfully: %s' => 'As seguintes ACLs foram adicionadas com sucesso: %s',
        'The following ACLs have been updated successfully: %s' => 'As seguintes ACLs foram atualizadas com sucesso: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Ocorreram erros ao adicionar/atualizar as seguintes ACLs: %s. Por favor verifique o arquivo de log para mais informações.',
        'This field is required' => 'Este campo é obrigatório',
        'There was an error creating the ACL' => 'Ocorreu um erro ao criar a ACL',
        'Need ACLID!' => 'Necessário ACLID!',
        'Could not get data for ACLID %s' => 'Não foi possível obter dados da ACLID %s',
        'There was an error updating the ACL' => 'Houve um erro ao atualizar a ACL',
        'There was an error setting the entity sync status.' => 'Houve um erro ao configurar a status de sincronia da entidade',
        'There was an error synchronizing the ACLs.' => 'Houve um erro sincronizando a ACLs',
        'ACL %s could not be deleted' => 'ACL %s não pode ser excluída',
        'There was an error getting data for ACL with ID %s' => 'Houve um erro ao obter dados da ACL com ID %s',
        'Exact match' => 'Correspondência exata',
        'Negated exact match' => 'Correspondência exata negada',
        'Regular expression' => 'Expressão Regular',
        'Regular expression (ignore case)' => 'Expressão Regular(ignora maiúsculas)',
        'Negated regular expression' => 'Expressão Regular negada',
        'Negated regular expression (ignore case)' => 'Expressão Regular negada(ignora maiúsculas)',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer Company %s already exists!' => 'Empresa cliente %s já existe!',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'New phone ticket' => 'Novo chamado via fone',
        'New email ticket' => 'Novo chamado via e-mail',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Configuração do campo não é válida.',
        'Objects configuration is not valid' => 'Configuração dos objetos não são válidas',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Não foi possível resetar corretamente a ordem do campo Dinâmico, verifique o log de erros para obter mais detalhes.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Sub-ação indefinida',
        'Need %s' => 'Necessário %s',
        'The field does not contain only ASCII letters and numbers.' => 'Esse campo não pode conter somente letras e números ASCII.',
        'There is another field with the same name.' => 'Há outra campo com o mesmo nome.',
        'The field must be numeric.' => 'Esse campo deve ser numérico.',
        'Need ValidID' => 'Necessário ValidID',
        'Could not create the new field' => 'Não foi possível criar o novo campo',
        'Need ID' => 'Necessário ID',
        'Could not get data for dynamic field %s' => 'Não foi possível obter dados do campo dinâmico %s',
        'The name for this field should not change.' => 'O nome desse campo não pode ser alterado.',
        'Could not update the field %s' => 'Não foi possível atualizar o campo %s',
        'Currently' => 'Atualmente',
        'Unchecked' => 'Desmarcado',
        'Checked' => 'Marcado',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Prevenir entrada de datas no futuro',
        'Prevent entry of dates in the past' => 'Prevenir entrada de datas no passado',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => 'O valor deste campo está duplicado.',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Selecione pelo menos um destinatário.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'archive tickets' => 'arquivar chamados',
        'restore tickets from archive' => 'restaurar chamados do arquivo',
        'Need Profile!' => 'Usuário Necessário!',
        'Got no values to check.' => 'Não tem nenhum valor para verificar.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Por favor, remova as seguintes palavras, porque não podem ser utilizados para a seleção de ticket:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'WebserviceID Necessário!',
        'Could not get data for WebserviceID %s' => 'Não foi possível obter dados para WebserviceID %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Need InvokerType' => 'Necessário InvokerType',
        'Invoker %s is not registered' => 'Invoker %s não está registrado',
        'InvokerType %s is not registered' => 'InvokerType %s não está registrado',
        'Need Invoker' => 'Necessário Invoker',
        'Could not determine config for invoker %s' => 'Não foi possível determinar a configuração para o invoker %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Could not get registered configuration for action type %s' => 'Não foi possível obter a configuração registrada para o tipo de ação %s',
        'Could not get backend for %s %s' => 'Não foi possível obter o backend para %s %s',
        'Could not update configuration data for WebserviceID %s' => 'Não foi possível atualizar dados de configuração para WebserviceID %s',
        'Keep (leave unchanged)' => 'Ignorar (deixar inalterado)',
        'Ignore (drop key/value pair)' => 'Ignorar (apagar par chave/valor)',
        'Map to (use provided value as default)' => 'Mapear para (use o valor fornecido como padrão)',
        'Exact value(s)' => 'Valor(es) exato(s)',
        'Ignore (drop Value/value pair)' => 'Ignorar (descartar valor/par de valor)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'Could not find required library %s' => 'Não foi possível encontrar a biblioteca necessária %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Need OperationType' => 'Necessário OperationType',
        'Operation %s is not registered' => 'Operation %s não está registrado',
        'OperationType %s is not registered' => 'OperationType %s não está registrado',
        'Need Operation' => 'Necessário Operação',
        'Could not determine config for operation %s' => 'Não foi possível determinar a configuração para a operação %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need Subaction!' => 'Necessário Subação!',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Há outro web service com o mesmo nome.',
        'There was an error updating the web service.' => 'Houve um erro ao atualizar o web service.',
        'Web service "%s" updated!' => 'Web service "%s" atualizado!',
        'There was an error creating the web service.' => 'Houve um erro ao criar o web service.',
        'Web service "%s" created!' => 'Web service "%s" criado!',
        'Need Name!' => 'Necessário Nome!',
        'Need ExampleWebService!' => 'Necessário ExampleWebService!',
        'Could not read %s!' => 'Não pôde ser lido %s!',
        'Need a file to import!' => 'Necessário um arquivo para importar!',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            'O arquivo importado tem conteúdo YAML inválido! Por favor, verifique o log do OTRS para obter mais detalhes',
        'Web service "%s" deleted!' => 'Web service "%s" excluído!',
        'New Web service' => 'Novo web service',
        'Operations' => 'Operações',
        'Invokers' => 'Invokers',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Não há WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => 'Não foi possível obter dados do histórico para WebserviceHistoryID %s',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Email account fetch already fetched by another process. Please try again later!' =>
            'Captura de conta de e-mail já foi capturada por um outro processo. Por favor, tente novamente mais tarde!',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Notification updated!' => 'Notificação atualizada!',
        'Notification added!' => 'Notificação adicionada!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Houve um erro na obtenção de dados para a Notificação com ID:%s!',
        'Unknown Notification %s!' => 'Notificação Desconhecida %s!',
        'There was an error creating the Notification' => 'Houve algum erro ao criar a Notificação',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'Notificações não puderam ser importadas devido a um erro desconhecido. Por favor verifique os logs do OTRS para mais informações',
        'The following Notifications have been added successfully: %s' =>
            'As seguintes Notificações foram adicionados com êxito: %s',
        'The following Notifications have been updated successfully: %s' =>
            'As seguintes Notificações foram atualizados com sucesso: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Houve erros ao adicionar/atualizar as seguintes Notificações: %s. Por favor, verifique o log para mais informações!',
        'Agent who owns the ticket' => 'Atendente que possui o chamado',
        'Agent who is responsible for the ticket' => 'Atendente que é responsável pelo chamado',
        'All agents watching the ticket' => 'Todos os atendentes monitorando o chamado',
        'All agents with write permission for the ticket' => 'Todos os atendentes com permissão de escrita no chamado',
        'All agents subscribed to the ticket\'s queue' => 'Todos os atendentes assinantes da fila do chamado',
        'All agents subscribed to the ticket\'s service' => 'Todos os atendentes assinantes do serviço do chamado',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Todos os atendentes assinantes da fila e serviço do chamado',
        'Customer of the ticket' => 'Cliente do chamado',
        'Yes, but require at least one active notification method.' => 'Sim, mas necessita de ao menos um método de notificação ativo.',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'Ambiente PGP não está funcionando. Por favor, verifique o log para mais informações!',
        'Need param Key to delete!' => 'Necessário o parâmetro Chave para deletar!',
        'Key %s deleted!' => 'Chave %s deletada!',
        'Need param Key to download!' => 'Necessário parâmetro Chave para o download!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            'Desculpe, Apache::Reload é necessário como PerlModule e PerlInitHandler no arquivo de configuração do Apache. Veja também scripts/apache2-httpd.include.conf. Alternativamente, você pode usar a ferramenta de linha de comando bin/otrs.Console.pl para instalar pacotes!',
        'No such package!' => 'Não existe este pacote!',
        'No such file %s in package!' => 'Arquivo inexistente %s no pacote!',
        'No such file %s in local file system!' => 'Arquivo inexistente %s no sistema de arquivos local!',
        'Can\'t read %s!' => 'Não pôde ser lido %s!',
        'File is OK' => 'Arquivo está ok',
        'Package has locally modified files.' => 'Pacote possui arquivos locais modificados.',
        'No packages or no new packages found in selected repository.' =>
            'Nenhum pacote ou nenhum novo pacote encontrado no repositório selecionado.',
        'Package not verified due a communication issue with verification server!' =>
            'Pacote não verificado devido a um problema de comunicação com o servidor de verificação!',
        'Can\'t connect to OTRS Feature Add-on list server!' => 'Não foi possível conectar com o servidor da lista de recursos adicionais (add-ons) da OTRS!',
        'Can\'t get OTRS Feature Add-on list from server!' => 'Não foi possível obter do servidor a lista de recursos adicionais (add-ons) da OTRS!',
        'Can\'t get OTRS Feature Add-on from server!' => 'Não foi possível obter do servidor o recurso adicional (add-on) da OTRS!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Filtro inexistente: %s',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Need ExampleProcesses!' => 'Requer ExampleProcesses!',
        'Need ProcessID!' => 'Necessário ProcessID!',
        'Yes (mandatory)' => 'Sim (mandatório)',
        'Unknown Process %s!' => 'Processo Desconhecido %s!',
        'There was an error generating a new EntityID for this Process' =>
            'Ocorreu um erro durante a geração de um novo EntityID para este processo',
        'The StateEntityID for state Inactive does not exists' => 'O StateEntityID para o estado Inativo não existe',
        'There was an error creating the Process' => 'Houve um erro ao criar o Processo',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'Ocorreu um erro durante a configuração do estado de sincronização para a entidade de processo: %s',
        'Could not get data for ProcessID %s' => 'Não foi possível obter dados para ProcessID %s',
        'There was an error updating the Process' => 'Ocorreu um erro durante a atualização do processo',
        'Process: %s could not be deleted' => 'Processo: %s não pode ser excluído',
        'There was an error synchronizing the processes.' => 'Houve um erro na sincronização dos processos.',
        'The %s:%s is still in use' => 'O %s:%s ainda está em uso',
        'The %s:%s has a different EntityID' => 'O s%:%s tem um EntityID diferente',
        'Could not delete %s:%s' => 'Não foi possível deletar %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'Ocorreu um erro durante a configuração do estado de sincronização para a entidade de %s: %s',
        'Could not get %s' => 'Não foi possível obter %s',
        'Need %s!' => 'Necessário %s!',
        'Process: %s is not Inactive' => 'Processo: %s não é Inativo',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'Ocorreu um erro durante a geração de um novo EntityID para esta atividade',
        'There was an error creating the Activity' => 'Ocorreu um erro durante a criação da atividade',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Ocorreu um erro ao configurar o estado de sincronização da entidade de atividade: %s',
        'Need ActivityID!' => 'Necessário ActivityID!',
        'Could not get data for ActivityID %s' => 'Não foi possível obter dados para ActivityID %s',
        'There was an error updating the Activity' => 'Ocorreu um erro durante a atualização da atividade',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Parâmetro faltando: Necessário Activity  e ActivityDialog!',
        'Activity not found!' => 'Atividade não localizada!',
        'ActivityDialog not found!' => 'ActivityDialog não encontrado!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'Janela já atribuída à atividade. Você não pode adicionar a mesma janela duas vezes!',
        'Error while saving the Activity to the database!' => 'Erro ao salvar a atividade no banco de dados!',
        'This subaction is not valid' => 'Esta subaction não é valida',
        'Edit Activity "%s"' => 'Editar Activity "%s"',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'Ocorreu um erro durante a geração de um novo EntityID para esta janela de atividade',
        'There was an error creating the ActivityDialog' => 'Ocorreu um erro durante a criação da janela de atividade',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'Ocorreu um erro durante a configuração do estado de sincronização da entidade para a janela de diálogo: %s',
        'Need ActivityDialogID!' => 'Necessário ActivityDialogID!',
        'Could not get data for ActivityDialogID %s' => 'Não foi possível obter dados para ActivityDialogID %s',
        'There was an error updating the ActivityDialog' => 'Ocorreu um erro durante a atualização da janela de atividade',
        'Edit Activity Dialog "%s"' => 'Editar Activity Dialog "%s"',
        'Agent Interface' => 'Interface do Agente',
        'Customer Interface' => 'Interface do Cliente',
        'Agent and Customer Interface' => 'Atendente e Interface do Cliente',
        'Do not show Field' => 'Não exibir campo',
        'Show Field' => 'Exibir Campo',
        'Show Field As Mandatory' => 'Exibir campo como mandatório',
        'fax' => 'fax',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Editar Path',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'Ocorreu um erro durante a geração de um novo EntityID para esta transição',
        'There was an error creating the Transition' => 'Ocorreu um erro ao criar a alteração',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'Ocorreu um erro durante a configuração do estado de sincronização para a entidade de transição: %s',
        'Need TransitionID!' => 'Necessário TransitionID!',
        'Could not get data for TransitionID %s' => 'Não foi possível obter dados para TransitionID %s',
        'There was an error updating the Transition' => 'Ocorreu um erro durante a atualização da transição',
        'Edit Transition "%s"' => 'Editar Transição "%s"',
        'xor' => 'xor',
        'String' => 'String',
        'Transition validation module' => 'Módulo de validação de transição',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'Pelo menos, um parâmetro de configuração válido é necessário.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'Ocorreu um erro durante a geração de um novo EntityID para esta ação de transição',
        'There was an error creating the TransitionAction' => 'Ocorreu um erro durante a criação da ação de transição',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'Ocorreu um erro durante a configuração do estado de sincronização para a entidade de ação de transição: %s',
        'Need TransitionActionID!' => 'Necessário TransitionActionID!',
        'Could not get data for TransitionActionID %s' => 'Não foi possível obter dados para TransitionActionID %s',
        'There was an error updating the TransitionAction' => 'Ocorreu um erro durante a atualização da ação de transição',
        'Edit Transition Action "%s"' => 'Editar ação de transição "%s"',
        'Error: Not all keys seem to have values or vice versa.' => 'Erro: Nem todas as chaves parecem ter valores ou vice versa.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Don\'t use :: in queue name!' => 'Não use :: no nome da fila!',
        'Click back and change it!' => 'Clique voltar para mudá-lo!',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Filas (sem auto respostas)',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produção',
        'Test' => 'Teste',
        'Training' => 'Treinamento',
        'Development' => 'Desenvolvimento',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Papel',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'O ambiente S/MIME não está funcionando. Por favor, verifique o log para mais informações!',
        'Need param Filename to delete!' => 'Necessário o parâmetro Filename  para deletar!',
        'Need param Filename to download!' => 'Necessário o parâmetro Filename  para download!',
        'Needed CertFingerprint and CAFingerprint!' => 'Necessário CertFingerprint e CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint precisa ser diferente do CertFingerprint',
        'Relation exists!' => 'Relação já existe!',
        'Relation added!' => 'Associação adicionada!',
        'Impossible to add relation!' => 'Impossível adicionar relação!',
        'Relation doesn\'t exists' => 'Associação não existe',
        'Relation deleted!' => 'Associação excluída!',
        'Impossible to delete relation!' => 'Impossível excluir associação!',
        'Certificate %s could not be read!' => 'Certificado %s não pode ser lido!',
        'Needed Fingerprint' => 'Necessário Fingerprint',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation updated!' => 'Saudação atualizada!',
        'Salutation added!' => 'Saudação adicionada!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'Arquivo %s não pode ser lido!',

        # Perl Module: Kernel/Modules/AdminSysConfig.pm
        'Import not allowed!' => 'Importação não permitida!',
        'Need File!' => 'Necessário arquivo!',
        'Can\'t write ConfigItem!' => 'Não é possível escrever item de configuração!',
        '-new-' => '',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => 'Data inicial não deve ser definida após data final!',
        'There was an error creating the System Maintenance' => 'Ocorreu um erro durante a criação da manutenção de sistema',
        'Need SystemMaintenanceID!' => 'Necessário SystemMaintenanceID!',
        'Could not get data for SystemMaintenanceID %s' => 'Não foi possível obter dados para SystemMaintenanceID %s',
        'System Maintenance was saved successfully!' => 'Manutenção do Sistema foi salva com sucesso!',
        'Session has been killed!' => 'Sessão foi eliminada!',
        'All sessions have been killed, except for your own.' => 'Todas sessões foram desconectadas, exceto por esta.',
        'There was an error updating the System Maintenance' => 'Ocorreu um erro durante a atualização da manutenção de sistema',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Não foi possível excluir a entrada de manutenção de sistema: %s!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Modelo Atualizado!',
        'Template added!' => 'Modelo adicionado!',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Tipo é necessário!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'Nenhuma configuração para %s',
        'Statistic' => 'Estatística',
        'No preferences for %s!' => 'Nenhuma preferência para %s!',
        'Can\'t get element data of %s!' => 'Não foi possível obter dados do elemento %s!',
        'Can\'t get filter content data of %s!' => 'Não foi possível obter dados do conteúdo do filtro %s!',
        'Customer Company Name' => 'Nome da empresa cliente',
        'Customer User ID' => 'ID de usuário cliente',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'Necessário SourceObject e SourceKey!',
        'Please contact the administrator.' => 'Por favor, entre em contato com o administrador.',
        'You need ro permission!' => 'Você precisa de permissões de ro (apenas leitura)',
        'Can not delete link with %s!' => 'Não é possível excluir associação com %s!',
        'Can not create link with %s! Object already linked as %s.' => 'Não é possível criar associação com %s! Objeto já associado como %s.',
        'Can not create link with %s!' => 'Não é possível criar associação com %s!',
        'The object %s cannot link with other object!' => 'O Objeto %snão pode ser linkado com outro objeto!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Parametro Grupo é obrigatório. ',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Parametro %sestá vazio.',
        'Invalid Subaction.' => 'Subaction Inválida.',
        'Statistic could not be imported.' => 'Estatísticas não podem ser importadas.',
        'Please upload a valid statistic file.' => 'Por Favor, envie um arquivo de estatísticas válido.',
        'Export: Need StatID!' => 'Exportar: StatID é necessário',
        'Delete: Get no StatID!' => 'Deletar: Nenhum StatID obtido!',
        'Need StatID!' => 'StatID é necessário!',
        'Could not load stat.' => 'Não é possível carregar a estatística.',
        'Could not create statistic.' => 'Não foi possível criar estatísticas.',
        'Run: Get no %s!' => 'Executar: %s não obtido.',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'Nenhum TicketID informado.',
        'You need %s permissions!' => 'Você precisa %spermissões!',
        'Could not perform validation on field %s!' => 'Não é possível realizar validações no campo %s!',
        'No subject' => 'Sem assunto',
        'Previous Owner' => 'Proprietário Anterior',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s é necessário!',
        'Plain article not found for article %s!' => 'Artigo simples não encontrado para o artigo %s!',
        'Article does not belong to ticket %s!' => 'Artigo não pertence ao ticket %s!',
        'Can\'t bounce email!' => 'Impossível devolver o e-mail.',
        'Can\'t send email!' => 'Não é possível enviar o email!',
        'Wrong Subaction!' => 'Subação incorreta.',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Impossível bloquear o Chamado, nenhum TicketIDs foi informado!',
        'Ticket (%s) is not unlocked!' => 'Ticket (%s) não está desbloqueado!',
        'Bulk feature is not enabled!' => 'Recurso \'em massa\' não está habilitado. ',
        'No selectable TicketID is given!' => 'Nenhum TicketID selecionável foi informado!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            'Você selecionou nenhum Ticket ou somente ticket os quais estão bloqueados por outro Agente.',
        'You need to select at least one ticket.' => 'Você precisa selecionar ao menos um Ticket.',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            'Os Tickets a seguir serão ignorados porque eles estão bloquados por outro Agente ou você não tem permissão de escrita para estes Tickets: %s',
        'The following tickets were locked: %s.' => 'Os Tickets a seguir foram bloqueados: %s',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Can not determine the ArticleType!' => 'Não é possĩvel determinar o ArticleType!',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'No Subaction!' => 'Nenhuma Subaction!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'Nenhum TicketID obtido.',
        'System Error!' => 'Erro de sistema!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Invalid Filter: %s!' => 'Filtro Inválido: %s!',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'Não foi possível exibir o histórico, nenhum TicketID informado!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'Não foi possível bloquear o Ticket, nenhum TicketID informado!',
        'Sorry, the current owner is %s!' => 'Desculpe, o proprietário atual é %s!',
        'Please become the owner first.' => 'Por favor, torne-se o primeiro proprietário!',
        'Ticket (ID=%s) is locked by %s!' => 'Ticket(ID=%s) está bloqueado por %s!',
        'Change the owner!' => 'Alterar o proprietário!',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Não é possível mesclar um Ticket com ele mesmo.',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'Você precisa da permissão: mover!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Chat não está ativo.',
        'No permission.' => 'Sem permissão.',
        '%s has left the chat.' => '%ssaiu do chat.',
        'This chat has been closed and will be removed in %s hours.' => 'Este chat foi fechado e será removido em %s horas.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'Nenhum ArticleID!',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'Não foi possível ler o artigo em texto simples.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'TicketID necessário!',
        'printed by' => 'Impresso por',
        'Ticket Dynamic Fields' => 'Campos Dinâmicos de Chamado',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Não foi possĩvel pegar ActivityDialogEntityID "%s"',
        'No Process configured!' => 'Nenhum Processo configurado!',
        'Process %s is invalid!' => 'Processo %s é inválido!',
        'Subaction is invalid!' => 'Subaction é inválida!',
        'Parameter %s is missing in %s.' => 'Parâmetro %s está faltando em %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'Nenhum ActivityDialog configurado para %s em _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'Nenhum início de ActivityEntityID ou ActivityDialogEntityID para o Processo: %sem _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'Não foi possível identificar o Ticket para TicketID %s em _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'Não foi possível determinar ActivityEntityID. DynamicField ou a Configuração não está correta.',
        'Process::Default%s Config Value missing!' => 'Process::Default %s Faltando Valor de Configuração!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'Nenhum ProcessEntityID ou TicketID e ActivityDialogEntityID identificados!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'Não foi possível identificar  StartActivityDialog e StartActivityDialog para o  ProcessEntityID "%s"',
        'Can\'t get Ticket "%s"!' => 'Não foi possível obter Ticket "%s"!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'Não foi possível obter ProcessEntityID ou ActivityEntityID para o ticket "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'Não foi possível obter as configurações da Atividade para ActivityEntityID "%s!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'Não foi possível obter configuração da Janela de Atividade para ActivityDialogEntityID "%s"!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'Não foi possĩvel obter o campo "%s" para ActivityDialog "%s"',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'PendingTime só pode ser usado se State ou StateID está configurado para a mesma ActivityDialog. ActivityDialog: %s !',
        'Pending Date' => 'Data de Pendência',
        'for pending* states' => 'em estado pendente*',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID faltando!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'Não foi possível obter Config para ActivityDialogEntityID " %s"',
        'Couldn\'t use CustomerID as an invisible field.' => 'Não é possível usar CustomerID como um campo invisível.',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'ProcessEntityID não encontrado, verifique seu ActivityDialogHeader.tt!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'Nenhum StartActivityDialog ou StartActivityDialog para o processo: "%s" configurado.',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'Não é possĩvel criar Ticket para o Processo com o ProcessEntityID "%s"!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'Não é possível definir ProcessEntityID "%s" on TicketID "%s"',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'Não é possivel definir ActivityEntityID "%s" no TicketID "%s"',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'Não foi possível gravar ActivityDialog, inválido TicketID: %s!',
        'Invalid TicketID: %s!' => 'inválido TicketID: %s!',
        'Missing ActivityEntityID in Ticket %s!' => 'ActivityEntityID não encontrado no Ticket %s!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            'Esse passo não pertence mais à atividade atual no processo para o Ticket \'%s%s%s\'! Outro usuário alterou este ticket enquanto isso. Por favor, feche esta janela e recarregue o Ticket',
        'Missing ProcessEntityID in Ticket %s!' => 'Não encontrado ProcessEntityId no Ticket %s!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Não foi possível definir valor para o Campo Dinâmico %sdo Ticket com ID "%s" na Janela de Atividade "%s"',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Não foi possível definir Tempo de Pendência para o Ticket com ID "%s" na Janela de Atividade "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'Configuração incorreta para Janela de Dialogo: %snão foi possível exibir => 1 / Mostrar campo (Favor alterar esta configurar para Exibir => 0 / Não exibir o campo ou Exibir => 2 / Exibir campo como obrigatório.',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Não foi possível setar %spara o Ticket com ID "%s" na Janela de Atividade "%s" !',
        'Default Config for Process::Default%s missing!' => 'Configuração padrão para Process::Default%s não encontrada!',
        'Default Config for Process::Default%s invalid!' => 'Configuração padrão para Process::Default%sinválida!',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'Untitled' => 'Sem título',
        'Customer Name' => 'Nome do Cliente',
        'Invalid Users' => 'Usuários Inválidos',
        'CSV' => 'CSV',
        'Excel' => 'Excel',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'Recurso não habilitado!',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'Recurso não está ativo',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Associação deletada',
        'Ticket Locked' => 'Chamado bloqueado',
        'Pending Time Set' => 'Tempo de Pendência definido.',
        'Dynamic Field Updated' => 'Campo dinâmico atualizado',
        'Outgoing Email (internal)' => 'E-mail de Saĩda (interno)',
        'Ticket Created' => 'Chamado criado',
        'Type Updated' => 'Tipo atualizado',
        'Escalation Update Time In Effect' => 'Escalonamento por tempo de Atualização em efeito',
        'Escalation Update Time Stopped' => 'Escalonamento por tempo de Atualização parado.',
        'Escalation First Response Time Stopped' => 'Escalonamento por Tempo de Primeira Resposta parado.',
        'Customer Updated' => 'Cliente Atualizado',
        'Internal Chat' => 'Chat Interno',
        'Automatic Follow-Up Sent' => 'Acompanhamento automático enviado.',
        'Note Added' => 'Nota adicionada',
        'Note Added (Customer)' => 'Nota adicionada (Cliente)',
        'State Updated' => 'Estado Atualizado',
        'Outgoing Answer' => 'Resposta de saída',
        'Service Updated' => 'Serviço Atualizado',
        'Link Added' => 'Link Adicionado',
        'Incoming Customer Email' => 'E-mail de entrada do cliente',
        'Incoming Web Request' => 'Requisição Web recebida.',
        'Priority Updated' => 'Prioridade atualizada',
        'Ticket Unlocked' => 'Chamado desbloqueado',
        'Outgoing Email' => 'E-mail de saída',
        'Title Updated' => 'Título atualizado',
        'Ticket Merged' => 'Ticket mesclado.',
        'Outgoing Phone Call' => 'Chamada telefônica recebida',
        'Forwarded Message' => 'Mensagem encaminhada.',
        'Removed User Subscription' => 'Subscrição de usuário removida.',
        'Time Accounted' => 'Tempo contabilizado',
        'Incoming Phone Call' => 'Chamada telefônica recebida.',
        'System Request.' => 'Requisição do Sistema.',
        'Incoming Follow-Up' => 'Acompanhamento recebido.',
        'Automatic Reply Sent' => 'Resposta automática enviada.',
        'Automatic Reject Sent' => 'Rejeição automática enviada.',
        'Escalation Solution Time In Effect' => 'Escalonamento por Tempo de Solução aplicado.',
        'Escalation Solution Time Stopped' => 'Escalonamento por tempo de Solução parado.',
        'Escalation Response Time In Effect' => 'Escalonamento por tempo de resposta em vigor.',
        'Escalation Response Time Stopped' => 'Escalonamento por tempo de Resposta parado.',
        'SLA Updated' => 'SLA Atualizado',
        'Queue Updated' => 'Fila autalizada',
        'External Chat' => 'Chat Externo',
        'Queue Changed' => 'Fila alterada.',
        'Notification Was Sent' => 'Notificação enviada.',
        'We are sorry, you do not have permissions anymore to access this ticket in its current state.' =>
            'Lamentamos, mas você não tem mais permissão para acessar este chamado em seu estado atual.',
        'Can\'t get for ArticleID %s!' => 'Não foi possível obter o ID da Nota %s!',
        'Article filter settings were saved.' => 'Configuraçãoes de filtro de notas, salvo.',
        'Event type filter settings were saved.' => 'Configurações de filtro por Tipo de Evento, salvo.',
        'Need ArticleID!' => 'O ID do Artigo é necessário.',
        'Invalid ArticleID!' => 'ID do Artigo é inválido.',
        'Offline' => 'Desconectado.',
        'User is currently offline.' => 'No momento o usuário está desconectado.',
        'User is currently active.' => 'Atualmente o usuário está conectado.',
        'Away' => 'Ausente.',
        'User was inactive for a while.' => 'Usuário está temporariamente inativo.',
        'Unavailable' => 'Indisponível.',
        'User set their status to unavailable.' => 'Usuário definei seus status como indisponível.',
        'Fields with no group' => 'Campo sem grupo.',
        'View the source for this Article' => 'Ver código fonte da Nota.',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'ID fo campo e ID da Nota são necessários.',
        'No TicketID for ArticleID (%s)!' => 'Nenhum ID do Ticket para o ID da Nota (%s)!',
        'No such attachment (%s)!' => 'Nenhum anexo (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'Valide configuração no SysConfig para %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'Valide configuração no SysConfig para %s::TicketTypeDefault.',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'ID do Cliente é necessário.',
        'My Tickets' => 'Meus Chamados',
        'Company Tickets' => 'Chamados da Empresa',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Please remove the following words because they cannot be used for the search:' =>
            'Por Favor, remova a palavras a seguir, visto que elas não podem ser usadas para pesquisa:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'Não foi possível reabrir o Ticket nesta fila.',
        'Create a new ticket!' => 'Criar novo Ticket!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'Modo Seguro ativdado!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            'Se você deseja executar novamente o Instalador, desabilite o Modo Seguro no SysConfig.',
        'Directory "%s" doesn\'t exist!' => 'Diretório "%s" não existe!',
        'Configure "Home" in Kernel/Config.pm first!' => 'Configure "Home" em Kernel/Config.pm primeiro!',
        'File "%s/Kernel/Config.pm" not found!' => 'Arquivo "%s /Kernel/Config.pm não encontrado!',
        'Directory "%s" not found!' => 'Diretõrio "%s" não encontrado.',
        'Kernel/Config.pm isn\'t writable!' => 'Kernel/Config.pm não está gravável.',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'Se você deseje usar o Instalador, defina Kernel/Config.pm como gravável para o usuário do servidor Web.',
        'Unknown Check!' => 'Verificação desconhecida.',
        'The check "%s" doesn\'t exist!' => 'A verificação "%s" não existe.',
        'Database %s' => 'Banco de Dados %s',
        'Configure MySQL' => 'Configurar MySQL',
        'Configure PostgreSQL' => 'Configurar PostgreSQL',
        'Configure Oracle' => 'Configurar Oracle',
        'Unknown database type "%s".' => 'Tipo da Banco de Dados "%s" desconhecido.',
        'Please go back.' => 'Favor retornar.',
        'Install OTRS - Error' => 'Erro ao Installar OTRS',
        'File "%s/%s.xml" not found!' => 'Arquivo "%s/%s.xml" não encontrado.',
        'Contact your Admin!' => 'Entre em contato com o seu Administrador.',
        'Syslog' => 'Syslog',
        'Can\'t write Config file!' => 'Não foi possível gravar no arquivo de Configurações.',
        'Unknown Subaction %s!' => 'Ação secundária %s desconhecida!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Não foi possível conectar ao Banco de Dados, Múdlo Perl DBD::%s não instalado!',
        'Can\'t connect to database, read comment!' => 'Não foi possível connectar ao banco de dados, leia os comentários!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Error: Certifique-se que seu banco da dados aceita pacotes com tamanho acima de %s MB (atualmente ele aceita somente até %sMB). Por Favor, ajuste o parametro max_allowed_packet do seu banco de dados, a fim de previnir erros.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Error: Defina o valor para innodb_log_file_size no seu banco de dados para, ao menos %s MB (atualmente %sMB, recomendado: %sMB). Para mais informações verifique em %s.',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'Configuração Package::RepositoryAccessRegExp necessária.',
        'Authentication failed from %s!' => 'Falha de autenticação à partir de %s!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Sent message crypted to recipient!' => 'Enviar mensagem criptografada paro o destinatário.',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => 'Cabeçalho "PGP SIGNED MESSAGE" encontrado porém, inválido!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => 'Cabeçalho "S/MIME SIGNED MESSAGE" encontrado porém, inválido',
        'Ticket decrypted before' => 'Descriptografar Ticket antes.',
        'Impossible to decrypt: private key for email was not found!' => 'Impossível descriptografar: Chave privrada para o e-mail não foi encontrada!',
        'Successful decryption' => 'Descritografado com sucesso.',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'O tempo inicial do Ticket foi definido antes do tempo final.',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => 'Não foi possível conectar ao servidor de Notícias do OTRS.',
        'Can\'t get OTRS News from server!' => 'Não foi possível obter Notícias do servidor OTRS.',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => 'Não foi possĩvel conectar ao servidor de Novidades do Produto OTRS',
        'Can\'t get Product News from server!' => 'Não foi possível obter Novidades dos Produtos do servidor OTRS.',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => 'Não foi possível coectar em %s',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'sorted ascending' => 'Classificar Ascendente',
        'sorted descending' => 'Classificar Descendente',
        'filter not active' => 'Filtro não ativo.',
        'filter active' => 'Filtro ativo.',
        'This ticket has no title or subject' => 'O Ticket não tem título ou assunto.',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state. You can take one of the following actions:' =>
            'Lamentamos, voçê não tem permissões para acessar este Ticket no estado atual. você pode tomar algumas das ações:',
        'No Permission' => 'Sem Permissão.',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Associado como',
        'Search Result' => 'Resultados da pesquisa',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'Pesquisar arquivamento.',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s Atualize para %s agora! %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'A system maintenance period will start at: ' => 'Uma janela de manutenção de sistema será iniciada em: ',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(em progresso)',

        # Perl Module: Kernel/Output/HTML/Preferences/NotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Favor, certifique-se de ter escolhido ao menos um meio de transporte para notificações obrigatórias.',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Por favor especifique uma data final posterior à data de início.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Please supply your new password!' => 'Favor, forneça sua senha!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'No (not supported)' => 'Não (não suportado)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'Nenhum valor selecionado para tempo completado no passado ou completado no momento+no futuro.',
        'The selected time period is larger than the allowed time period.' =>
            'O período de tempo selecionado é maior que o período de tempo permitido.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'Nenhum valor para escala de tempo disponĩvel para a escala de tempo selecionado no eixo X.',
        'The selected date is not valid.' => 'A data selecionado não é válida.',
        'The selected end time is before the start time.' => 'O Tempo final é anterior ao tempo inicial.',
        'There is something wrong with your time selection.' => 'Algo errado com a sua seleção de tempo.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Favor, selecione apenas um elemento ou permita modificações em "stat Generation Time".',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Favor, selecionar ao menos um valor par ao campo, ou permitir modificações em "stat generation time"',
        'Please select one element for the X-axis.' => 'Favor selecionar um elemento para o Eixo-X',
        'You can only use one time element for the Y axis.' => 'Vocẽ só pode usar um elemento para o Exito Y.',
        'You can only use one or two elements for the Y axis.' => 'Você pode usar um ou dois elementos para o Eixo-Y',
        'Please select at least one value of this field.' => 'Favor selecionar ao menos um valor para o campo.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Favor preenchar um valor ou permita modificações em "Stat Generations time"',
        'Please select a time scale.' => 'Por favor, selecione um período de tempo.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'O  período  de tempo do seu Relatõrio  é muito pequeno, favor use um período de tempo maior,',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Favor remover as seguintes palavras, um vez que elas não podem ser usadas para restrições de Ticket %s',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Ordenar por',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            'Não foi possível ler o arquivo de configuração ACL. Por favor, certifique-se de que o arquivo é válido.',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            'Você excedeu o número de agentes concorrentes - contactar sales@otrs.com.',
        'Please note that the session limit is almost reached.' => 'Por favor note que o limite da sessão está quase alcançado.',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            'Login recusado! Você excedeu  o número máximo de Agentes concorrentes! Entre em contato com sales@otrs.com imediatamente!',
        'Session per user limit reached!' => 'Limite de sessão por usuário atingido!',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Referência de opções de configuração',
        'This setting can not be changed.' => 'Esta configuração não pode ser alterada.',
        'This setting is not active by default.' => 'Esta configuração não está ativa por padrão.',
        'This setting can not be deactivated.' => 'Esta configuração não pode ser desativada.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => 'Usuário cliente "%s" já existe.',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            'Este endereço de e-mail já está em uso por outro usuário cliente.',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => 'ex.: Text ou Te*t',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => 'Ignore este campo.',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            'Não foi possível ler o arquivo de configuração de Notificação. Por favor, certifique-se que o arquivo é válido.',
        'Imported notification has body text with more than 4000 characters.' =>
            'A notificação importada tem texto de corpo com mais de 4000 caracteres.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'não instalado',
        'File is not installed!' => 'Arquivo não instalado!',
        'File is different!' => 'Arquivo é diferente!',
        'Can\'t read file!' => 'Não pode ler o arquivo!',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            'O processo "%s" e todos os seus dados foram importados com sucesso.',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Inativo',
        'FadeAway' => 'FadeAway',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t get Token from sever' => 'Não foi possível obter o Token do servidor',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Soma',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Tipo de Estado',
        'Created Priority' => 'Prioridade',
        'Created State' => 'Criado com o Estado',
        'Create Time' => 'Hora de Criação',
        'Close Time' => 'Hora de Fechamento',
        'Escalation - First Response Time' => 'Escalação - Prazo de Resposta Inicial',
        'Escalation - Update Time' => 'Escalação - Prazo de Atualização',
        'Escalation - Solution Time' => 'Escalação - Prazo de Solução',
        'Agent/Owner' => 'Atendente/Proprietário',
        'Created by Agent/Owner' => 'Criado pelo Atendente/Proprietário',
        'CustomerUserLogin' => 'Usuário do Cliente',
        'CustomerUserLogin (complex search)' => '',
        'CustomerUserLogin (exact match)' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Avaliado por',
        'Ticket/Article Accounted Time' => 'Tempo contabilizado por Chamado/Artigo',
        'Ticket Create Time' => 'Horário de Criação do Chamado',
        'Ticket Close Time' => 'Horário de Fechamento do Chamado',
        'Accounted time by Agent' => 'Tempo contabilizado por Atendente',
        'Total Time' => 'Tempo Total',
        'Ticket Average' => 'Média de Chamados',
        'Ticket Min Time' => 'Horário Mínimo dos Chamados',
        'Ticket Max Time' => 'Horário Máximo dos Chamados',
        'Number of Tickets' => 'Número de Chamados',
        'Article Average' => 'Média de Artigos',
        'Article Min Time' => 'Horário Mínimo dos Artigos',
        'Article Max Time' => 'Horário Máximo dos Artigos',
        'Number of Articles' => 'Número de Artigos',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => 'ilimitado',
        'ascending' => 'ascendente',
        'descending' => 'descendente',
        'Attributes to be printed' => 'Atributos a serem impressos',
        'Sort sequence' => 'Sequência de Ordenamento',
        'State Historic' => 'Histórico de Estado',
        'State Type Historic' => 'Histórico de Tipo de Estado',
        'Historic Time Range' => 'Intervalo de Tempo Histórico',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'Média de Solução',
        'Solution Min Time' => 'Tempo Mínimo de Solução',
        'Solution Max Time' => 'Tempo Máximo de Solução',
        'Solution Average (affected by escalation configuration)' => 'Média de Solução (impactado pela configuração de escalonamento)',
        'Solution Min Time (affected by escalation configuration)' => 'Tempo Mínimo de Solução (impactado pela configuração de escalonamento)',
        'Solution Max Time (affected by escalation configuration)' => 'Tempo Máximo de Solução (impactado pela configuração de escalonamento)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'Média de Tempo de Funcionamento de Solução (impactada pela configuração de escalonamento)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'Tempo Mínimo de Funcionamento de Solução (impactada pela configuração de escalonamento)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'Tempo Máximo de Funcionamento de Solução (impactada pela configuração de escalonamento)',
        'First Response Average (affected by escalation configuration)' =>
            'Média de Primeira Resposta (impactado pela configuração de escalonamento)',
        'First Response Min Time (affected by escalation configuration)' =>
            'Tempo Mínimo de Primeira Resposta (impactado pela configuração de escalonamento)',
        'First Response Max Time (affected by escalation configuration)' =>
            'Tempo Máximo de Primeira Resposta (impactado pela configuração de escalonamento)',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '',
        'Number of Tickets (affected by escalation configuration)' => 'Número de Tickets (impactado pela configuração de escalonamento)',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => 'Dias',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Tabelas presente',
        'Internal Error: Could not open file.' => 'Erro interno: Não foi possível abrir o arquivo.',
        'Table Check' => 'Verificação das tabelas',
        'Internal Error: Could not read file.' => 'Erro Interno: Não foi possível ler o arquivo.',
        'Tables found which are not present in the database.' => 'Foram encontradas tabelas não presentes na base de dados.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Tamanho da Base de Dados',
        'Could not determine database size.' => 'Não foi possível determinar o tamanho da base de dados.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Versão da base de dados',
        'Could not determine database version.' => 'Não foi possível determinar a versão da base de dados.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Charset do Cliente de Conexão',
        'Setting character_set_client needs to be utf8.' => 'Parâmetro character_set_client deve ser utf8.',
        'Server Database Charset' => 'Charset do Banco de dados',
        'Setting character_set_database needs to be UNICODE or UTF8.' => 'Parâmetro character_set_database precisa ser UNICODE ou UTF8.',
        'Table Charset' => 'Chartset da Tabela',
        'There were tables found which do not have utf8 as charset.' => 'Tabelas encontradas que não possuem charset utf8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'Tamanho de arquivo de log InooDB',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'O parâmetro innodb_log_file_size deve ser ao menos 256 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Tamanho Máximo da Query',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            'O parâmetro  \'max_allowed_packet\' deve ser maior que 20MB',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Tamanho do Cache de Consulta',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'A configuração \'query_cache_size\' deve ser usada (maior que 10 MB mas não mais que 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Mecanismo de Armazenamento Padrão',
        'Table Storage Engine' => 'Engine de Armazenamento de Tabela',
        'Tables with a different storage engine than the default engine were found.' =>
            'Tabelas com um mecanismo de armazenamento diferente do mecanismo padrão foram encontrados.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x ou superior é requerido.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'Parâmetro NLS_LANG',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG deve estar definido como al32utf8 (exemplo: GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'Parâmetro NLS_DATE_FORMAT ',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT deve ser definido para \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT Configurando SQL Check',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'A configuração client_encoding precisa ser UNICODE ou UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'A configuração server_encoding precisa ser UNICODE ou UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Formato da data',
        'Setting DateStyle needs to be ISO.' => 'A configuração DateStyle precisa ser ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 8.x or higher is required.' => 'PostgreSQL 8.x ou superior é requerido',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'Partição OTRS',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Utilização em disco',
        'The partition where OTRS is located is almost full.' => 'A partição onde o OTRS se encontra localizado encontra-se quase cheia.',
        'The partition where OTRS is located has no disk space problems.' =>
            'A partição onde o OTRS está localizado não apresenta problemas de espaço.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Partições em uso',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Distribuição',
        'Could not determine distribution.' => 'Não foi possível determinar a distribuição.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Versão do Kernel',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Carga do sistema',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'A carga do sistema deve estar, no máximo, até o número de CPUs que o sistema tiver (ex.: uma carga de 8 ou menos em um sistema com 8 CPUs é adequada).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Módulos Perl',
        'Not all required Perl modules are correctly installed.' => 'Nem todos os módulos Perl não foram correctamente instalados.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Espaço de Swap livre (%)',
        'No swap enabled.' => 'Nenhum swap ativado.',
        'Used Swap Space (MB)' => 'Utilizar espaço Swap (MB)',
        'There should be more than 60% free swap space.' => 'Deve haver mais de 60% de espaço Swap livre.',
        'There should be no more than 200 MB swap space used.' => 'Não mais de 200 MB de espaço Swap deverá estar em utilização.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'OTRS' => 'OTRS',
        'Config Settings' => 'Definições de configuração',
        'Could not determine value.' => 'Não foi possível determinar o valor.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => 'Daemon',
        'Daemon is running.' => 'Daemon está ativo.',
        'Daemon is not running.' => 'Daemon não está ativo.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => 'Registros de Banco',
        'Tickets' => 'Chamados',
        'Ticket History Entries' => 'Entradas de Histórico de Chamados',
        'Articles' => 'Artigos',
        'Attachments (DB, Without HTML)' => 'Anexos (DB, sem HTML)',
        'Customers With At Least One Ticket' => 'Clientes com pelo menos um Chamado',
        'Dynamic Field Values' => 'Valores de Campos Dinâmicos',
        'Invalid Dynamic Fields' => 'Campos dinâmicos inválidos',
        'Invalid Dynamic Field Values' => 'Valor do Campo Dinâmico inválido',
        'GenericInterface Webservices' => 'GenericInterface serviços Web',
        'Process Tickets' => 'Tickets de Processo',
        'Months Between First And Last Ticket' => 'Meses Entre o Primeiro e o Último Chamado',
        'Tickets Per Month (avg)' => 'Chamados por Mês (méd.)',
        'Open Tickets' => 'Chamados Abertos',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Usuário e Senha SOAP padrão',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Risco de segurança: você usou uma configuração padrão para SOAP::User e SOAP::Password. Por favor altere-a.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => 'Senha padrão de Administrador',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Risco de segurança: a conta de atendente root@localhost possui a senha padrão. Por favor altere a senha ou desabilite a conta.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (nome do domínio)',
        'Please configure your FQDN setting.' => 'Por favor configure o seu FQDN.',
        'Domain Name' => 'Nome de Domínio',
        'Your FQDN setting is invalid.' => 'Suas configurações de FQDN estão inválidas.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => 'Sistema de Arquivo gravável ',
        'The file system on your OTRS partition is not writable.' => 'O Sistema de Arquivo da partição do OTRS não está gravável ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => 'Estado da Instalação do Pacote',
        'Some packages have locally modified files.' => 'Alguns pacotes possuem arquivos modificados localmente.',
        'Some packages are not correctly installed.' => 'Alguns pacotes não foram instalados corretamente.',
        'Package Verification Status' => 'Status da verificação do pacote.',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            'Alguns pacotes não são verificados pelo Grupo OTRS! É recomendável que você não utilize estes pacotes.',
        'Package Framework Version Status' => 'Status de Versão de Framework de Pacote',
        'Some packages are not allowed for the current framework version.' =>
            'Alguns pacotes não são permitidos para a versão atual do framework.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => 'Lista de Pacotes',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => 'Configurações de Sessão',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => 'E-mails enfileirados',
        'There are emails in var/spool that OTRS could not process.' => 'Existem e-mails em var/spool que o OTRS não conseguiu processar.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Sua configuração de SystemID não é válida, ela precisa conter apenas dígitos.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => 'Tipo de Ticket Padrão',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'O tipo de ticket padrão configurado está inválido ou faltante. Favor mudar a definição Ticket::Type::Default e selecione um tipo de ticket válido.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Módulo de Índice do Ticket',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Você possui mais de 60.000 artigos e deveria usar o backend StaticDB. Veja o manual do administrador (Performance Tuning) para mais informações.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'Usuários Inválidos com Tickets Bloqueados',
        'There are invalid users with locked tickets.' => 'Existem usuários inválidos com tickets bloqueados',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Você não deveria ter mais que 8.000 chamados abertos em seu sistema.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Módulo de Índice da Pesquisa de Tickets',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Você possui mais de 50.000 artigos e deveria usar o backend StaticDB. Veja o manual do administrador (Performance Tuning) para mais informações.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Registros órgãos na tabela ticket_lock_index',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'A tabela ticket_lock_index contém registros órfãos. Favor executar bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" para limpar o índice StaticDB.',
        'Orphaned Records In ticket_index Table' => 'Registros órfãos na tabela ticket_index',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'A tabela ticket_index contém registros órfãos. Favor executar bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" para limpar o índice StaticDB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => 'Configurações de tempo',
        'Server time zone' => 'Servidor de time zone',
        'Computed server time offset' => '',
        'OTRS TimeZone setting (global time offset)' => '',
        'TimeZone may only be activated for systems running in UTC.' => '',
        'OTRS TimeZoneUser setting (per-user time zone support)' => '',
        'TimeZoneUser may only be activated for systems running in UTC that don\'t have an OTRS TimeZone set.' =>
            '',
        'OTRS TimeZone setting for calendar ' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => 'UI - Utilização de Skin por Agente',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => 'UI - Utilização de Tema por Agente',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Servidor de Web',
        'Loaded Apache Modules' => 'Módulos Apache Carregados',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'Modelo MPM',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS necessita do apache para executar o modelo MPM \'prefork\'',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'Uso do CGI Accelerator',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Você deve utilizar o FastCGI ou mod_perl para aumentar o desempenho. ',
        'mod_deflate Usage' => 'Uso do mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Por favor, instale mod_deflate para melhorar o desempenho da GUI.',
        'mod_filter Usage' => 'Uso do mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'Por favor instale mod_filter se mod_deflate está sendo usado.',
        'mod_headers Usage' => 'Uso do mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Por favor, instale mod_headers para melhorar o desempenho da GUI',
        'Apache::Reload Usage' => 'Uso do Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload ou Apache2::Reload precisa ser usado como PerlModulo e PerlInitHandler para evitar o reset do web server ao instalar e atualizar módulos.',
        'Apache2::DBI Usage' => '',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Variáveis de ambiente',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => 'Coleta de Dados de Suporte',
        'Support data could not be collected from the web server.' => 'Dados de suporte não puderam ser coletados do servidor web.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Versão do Servidor WEB',
        'Could not determine webserver version.' => 'Não foi possível determinar a versão do servidor WEB.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => 'Detalhes de Usuários Concorrentes',
        'Concurrent Users' => 'Usuários Concorrentes',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'Unknown' => 'Desconhecido',
        'OK' => 'OK',
        'Problem' => 'Problema',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'Redefinir horário de desbloqueio.',

        # Perl Module: Kernel/System/Ticket/Event/NotificationEvent/Transport/Email.pm
        'PGP sign only' => 'Assinatura PGP apenas',
        'PGP encrypt only' => 'Criptografia PGP apenas',
        'PGP sign and encrypt' => 'Assinatura e criptografia PGP',
        'SMIME sign only' => 'Assinatura SMIME apenas',
        'SMIME encrypt only' => 'Criptografia SMIME apenas',
        'SMIME sign and encrypt' => 'Assinatura e criptografia SMIME',
        'PGP and SMIME not enabled.' => 'PGP e SMIME não habilitados.',
        'Skip notification delivery' => 'Pular entrega de notificação',
        'Send unsigned notification' => 'Enviar notificação não-assinada',
        'Send unencrypted notification' => 'Enviar notificação não-encriptada',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            'Autenticação realizada com sucesso, mas não foi encontrado registro deste usuário no banco de dados. Entre em contato com o administrador, por favor.',
        'Can`t remove SessionID.' => 'Não é possível remover o ID de Sessão.',
        'Logout successful.' => 'Logout com sucesso.',
        'Error: invalid session.' => 'Erro: sessão inválida.',
        'No Permission to use this frontend module!' => 'Nenhuma permissão para utilizar este módulo frontend!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            'Autenticação realizada com sucesso, mas não foi encontrado registro deste cliente no backend. Entre em contato com o administrador, por favor.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            'Redefinição de senha sem êxito. Por favor, entre em contato com o administrador.',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => 'Usuário cliente não pode ser adicionado@',
        'Can\'t send account info!' => 'Não foi possível enviar informações da conta!',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'Group for default access.' => 'Grupo de acesso padrão',
        'Group of all administrators.' => 'Grupo de todos os administradores.',
        'Group for statistics access.' => 'Grupo para acessar estatísticas',
        'All new state types (default: viewable).' => 'Todos os tipos de estado (padrão: visível).',
        'All open state types (default: viewable).' => 'Todos os tipos de estado aberto (padrão: visível).',
        'All closed state types (default: not viewable).' => 'Todos os tipos de estado fechado (padrão: não visível).',
        'All \'pending reminder\' state types (default: viewable).' => 'Todos os tipos \'aviso de pendência\' (padrão: visível).',
        'All \'pending auto *\' state types (default: viewable).' => 'Todos os tipos \'pendente auto*\' (padrão: visível).',
        'All \'removed\' state types (default: not viewable).' => 'Todos os tipos de estado \'removido\' (padrão: não visível).',
        'State type for merged tickets (default: not viewable).' => 'Tipo de estado para chamados agrupados (padrão: não visível).',
        'New ticket created by customer.' => 'Novo chamado criado pelo cliente.',
        'Ticket is closed successful.' => 'Chamado fechado com sucesso.',
        'Ticket is closed unsuccessful.' => 'Chamado fechado sem sucesso.',
        'Open tickets.' => 'Chamados abertos.',
        'Customer removed ticket.' => 'Cliente removeu o chamado.',
        'Ticket is pending for agent reminder.' => 'Chamado pendente com alerta de atendente.',
        'Ticket is pending for automatic close.' => 'Chamado pendente com fechamento automático.',
        'State for merged tickets.' => 'Estado para chamados agrupados.',
        'system standard salutation (en)' => 'saudação padrão do sistema (en)',
        'Standard Salutation.' => 'Saudação Padrão.',
        'system standard signature (en)' => 'assinatura padrão do sistema (en)',
        'Standard Signature.' => 'Assinatura Padrão.',
        'Standard Address.' => 'Endereço Padrão.',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Atualização de status dos chamados fechados será possível. Chamados serão reabertos.',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => 'novo chamado',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => 'Fila postmaster.',
        'All default incoming tickets.' => 'Todos tickets recebidos padrão.',
        'All junk tickets.' => 'Todos tickets lixo.',
        'All misc tickets.' => 'Todos tickets diversos.',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Resposta automática que será enviada depois que um novo ticket for criado.',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => 'Resposta padrão ( depois que novo chamado foi criado)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'Rejeição padrão (após rejeição do acompanhamento de um chamado fechado).',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => 'Não classificado',
        'tmp_lock' => 'tmp_lock',
        'email-notification-ext' => 'email-notification-ext',
        'email-notification-int' => 'email-notification-int',
        'Ticket create notification' => 'Notificação de criação de ticket',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Você receberá uma notificação a cada vez que um novo ticket for criado em uma de suas "Minhas Filas" ou "Meus Serviços".',
        'Ticket follow-up notification (unlocked)' => 'Notificação de revisão de chamado (desbloqueado)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => 'Notificação de revisão de chamado (bloqueado)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'Você irá receber uma notificação assim que um ticket de sua propriedade for desbloqueado automaticamente.',
        'Ticket owner update notification' => 'Notificação de atualização de proprietário de chamado',
        'Ticket responsible update notification' => 'Notificação de atualização de responsável por um ticket',
        'Ticket new note notification' => 'Notificação de nova nota em um ticket',
        'Ticket queue update notification' => 'Notificação de atualização de fila de um ticket',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Você irá receber uma notificação se um ticket for movido a uma de "Minhas Filas".',
        'Ticket pending reminder notification (locked)' => 'Notificação de chamado pendente (bloqueado)',
        'Ticket pending reminder notification (unlocked)' => 'Notificação de chamado pendente (desbloqueado)',
        'Ticket escalation notification' => 'Notificação de escalação de chamado',
        'Ticket escalation warning notification' => 'Notificação de alerta de escalação de chamado',
        'Ticket service update notification' => 'Notificação de atualização de serviço do chamado',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'Você receberá uma notificação se o serviço de algum chamado for alterado para um de seus "Meus Serviços".',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
Caro Cliente,

Infelizmente não conseguimos detectar um número de ticket válido
em seu assunto, portanto seu e-mail não pôde ser processado.

Favor criar um novo ticket através do painel de cliente.

Obrigado pela ajuda!

 Seu Time do Helpdesk
',
        ' (work units)' => '(unidades de trabalho)',
        '"%s" notification was sent to "%s" by "%s".' => '"%s" notificação foi enviada a "%s" por "%s".',
        '"Slim" skin which tries to save screen space for power users.' =>
            '',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s unidade(s) de tempo contabilizada. O total agora é %s unidade(s) de tempo.',
        '(UserLogin) Firstname Lastname' => '(Login) Nome Sobrenome',
        '(UserLogin) Lastname Firstname' => '(Login de Usuário) ÚltimoNome PrimeiroNome',
        '(UserLogin) Lastname, Firstname' => '(Login) Sobrenome, Nome',
        '*** out of office until %s (%s d left) ***' => '*** ausente até %s (restam %s dias) ***',
        '100 (Expert)' => '100 (Especialista)',
        '200 (Advanced)' => '200 (Avançado)',
        '300 (Beginner)' => '300 (Iniciante)',
        'A TicketWatcher Module.' => 'Um Módulo de Observação de Ticket.',
        'A Website' => 'Um website',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'Uma lista de campos dinâmicos que são agrupados no ticket principal durante uma operação de agrupamento. Somente campos dinâmicos vazios no ticket principal serão definidos.',
        'A picture' => 'Uma figura',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Módulo ACL que permite fechar os chamados-pais somente se todos os seus filhos já estejam fechados ("Estado" mostra quais estados não estão disponíveis para o chamado-pai até que todos os chamados-filhos estejam fechados).',
        'Access Control Lists (ACL)' => 'Listas de Controle de Acesso (ACL)',
        'AccountedTime' => 'Tempo contabilizado',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Ativa um mecanismo de piscar da fila que contém o chamado mais antigo.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Ativa o recurso de senha perdida para os atendentes, na interface do atendente.',
        'Activates lost password feature for customers.' => 'Ativa o recurso de senha perdida para os clientes.',
        'Activates support for customer groups.' => 'Ativa o suporte a grupos de clientes.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Ativa o filtro de artigo na visão de detalhe para especificar quais artigos devem ser mostrados.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Ativa os temas disponíveis no sistema. O valor 1 significa ativo, 0 significa inativo.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Ativa o sistema de pesquisa de chamados arquivados na interface do cliente.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Ativa o sistema de arquivamento de chamados para ter um sistema mais rápido, movendo alguns chamados para fora do escopo diário. Para procurar por estes chamados, o marcador arquivado tem que ser habilitado na busca de chamado.',
        'Activates time accounting.' => 'Ativa a contabilização de tempo.',
        'ActivityID' => 'ID de Atividade',
        'Add a comment.' => '',
        'Add a default name for Dynamic Field.' => '',
        'Add an inbound phone call to this ticket' => 'Adicionar uma nota de chamada telefônica recebida a este chamado',
        'Add an outbound phone call to this ticket' => 'Adicionar uma nota de chamada telefônica realizada a este chamado',
        'Added email. %s' => 'E-mail adicionado (%s).',
        'Added link to ticket "%s".' => 'Adicionadas associações ao chamado "%s".',
        'Added note (%s)' => 'Nota adicionada (%s).',
        'Added subscription for user "%s".' => 'Adicionada assinatura para o usuário "%s".',
        'Address book of CustomerUser sources.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Adiciona um sufixo com o ano e mês reais do arquivo de eventos do OTRS. Um arquivo de eventos para cada mês será criado.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Adiciona endereços de e-mail de clientes para destinatários na tela de composição da interface de agente. Os endereços de e-mail de clientes não serão adicionados se o tipo de artigo for email-internal.',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância "apenas uma vez". Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adiciona os dias de vacância permanente. Por favor, utilize o padrão de um só dígito para números de 1 a 9 (em vez de 01..09).',
        'Admin Area.' => 'Área Admin.',
        'After' => 'Depois',
        'Agent Name' => 'Nome do Agente',
        'Agent Name + FromSeparator + System Address Display Name' => 'Nome do Agente + FromSeparator + Nome de Exibição do Endereço de Sistema',
        'Agent Preferences.' => 'Preferências do Agente.',
        'Agent called customer.' => 'Atendente telefonou para cliente.',
        'Agent interface article notification module to check PGP.' => 'Módulo de notificação de artigo da interface de atendente para validar o PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Módulo de notificação de artigo da interface de atendente para validar o S/MIME.',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Módulo de interface de agente para acesso pesquisa CIC pela nav bar. Controle de acesso adicional para mostrar ou não este link pode ser feito usando Key "Group"  e conteúdos como "rw:group1;move_into:group2".',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Módulo da interface de agente para acessar perfis de pesquisa via a barra de navegação. Controle de acesso adicional para mostrar esse link ou não pode ser feito utilizando Chave "Group" e Conteúdo como "rw:group1;move_inte:group2".',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Módulo de interface de atendente para verificar a recepção de e-mails na tela de detalhes do chamados se a chave S/MIME está disponível e é válida.',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Módulo de notificação da interface de agente para visualizar o número de tickets bloqueados. Controle de acesso adicional para mostrar ou não este link pode ser feito ao utilizar a Chave "Group" e Conteúdo com "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Módulo de notificação da interface de agente para visualizar o número de tickets que um agente é responsável por. Controle de acesso adicional para mostrar ou não este link pode ser feito ao utilizar a Chave "Group" e Conteúdo com "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Módulo de notificação da interface de agente para visualizar o número de tickets em Meus Serviços. Controle de acesso adicional para mostrar ou não este link pode ser feito ao utilizar a Chave "Group" e Conteúdo com "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Módulo de notificação da interface de agente para visualizar o número de tickets observados. Controle de acesso adicional para mostrar ou não este link pode ser feito ao utilizar a Chave "Group" e Conteúdo com "rw:group1;move_into:group2".',
        'AgentCustomerSearch' => '',
        'AgentCustomerSearch.' => '',
        'AgentUserSearch' => '',
        'AgentUserSearch.' => '',
        'Agents <-> Groups' => 'Atendentes <-> Grupos',
        'Agents <-> Roles' => 'Atendentes <-> Papéis',
        'All customer users of a CustomerID' => 'Todos os usuários clientes de uma CustomerID.',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite adicionar notas na tela de ticket fechado da interface de agente. Pode ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite adicionar notas na tela de campos livres na interface de agente. Pode ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite adicionar notas na tela de notas da interface de agente. Pode ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite adicionar notas na tela de proprietário de ticket da interface de agente. Pode ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite adicionar notas na tela de ticket pendentes da interface de agente. Pode ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite adicionar notas na tela de prioridade de ticket da interface de agente. Pode ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite adicionar notas na tela de responsável por ticket da interface de agente. Pode ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Permite que atendentes troquem o eixo de uma estatística durante a geração de uma.',
        'Allows agents to generate individual-related stats.' => 'Permite que atendentes gerem estatística individualmente relacionadas.',
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
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            'Permite que os clientes definam o tipo de chamado na interface do cliente. Se for definido como \'Não \', o TicketTypeDefault deve ser configurado.',
        'Allows default services to be selected also for non existing customers.' =>
            'Permite selecionar serviços padrão para clientes não existentes.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Permite definir novos tipos de chamado (caso a funcionalidade tipo do chamado esteja habilitada).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permite definir serviços e SLAs para chamados (ex.: e-mail, área de trabalho, rede, ...), e atributos de escalação para SLAs (se o recurso serviço/SLA estiver habilitado).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Permite condições de pesquisa extendidas na pesquisa de ticket da interface de agente. Com esta funcionalidade, você pode pesquisar, por exemplo, o título do ticket com condições como "(*chave1*&&*chave2*)" or "(*chave1*||*chave2*)".',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Permite condições de pesquisa extendidas na pesquisa de ticket da interface de agente genérico. Com esta funcionalidade, você pode pesquisar, por exemplo, o título do ticket com condições como "(*chave1*&&*chave2*)" or "(*chave1*||*chave2*)".',
        'Allows generic agent to execute custom command line scripts.' =>
            '',
        'Allows generic agent to execute custom modules.' => '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite ter uma visão em formato médio do chamado (CustomerInfo => 1 - mostra também as informações do cliente).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite ter uma visão em formato pequeno do chamado (CustomerInfo => 1 - mostra também as informações do cliente).',
        'Allows invalid agents to generate individual-related stats.' => 'Permitr agentes inválidos para gerar estatísticas relacionadas com indivíduos.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Permite que os administradores efetuem login como outros clientes através do painel de administração de usuários clientes.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Permite que administradores personifiquem (se loguem como) outros usuários, através do painel de administração de usuários.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Permite definir um novo estado de chamado na tela de movimentação de chamado da interface de atendente.',
        'Always show RichText if available' => 'Sempre exibir RichText se disponível',
        'Arabic (Saudi Arabia)' => 'Arábico (Arábia Saudita)',
        'Archive state changed: "%s"' => 'Estado de arquivamento alterado: "%s".',
        'ArticleTree' => 'Árvore de Artigo',
        'Attachments <-> Templates' => 'Anexos <-> Modelos',
        'Auto Responses <-> Queues' => 'Autorrespostas <-> Filas',
        'AutoFollowUp sent to "%s".' => 'Revisão automática enviada para "%s".',
        'AutoReject sent to "%s".' => 'Rejeição automática enviada para "%s".',
        'AutoReply sent to "%s".' => 'Autorresposta enviada para "%s".',
        'Automated line break in text messages after x number of chars.' =>
            'Quebra de linha automatizada em mensagens de texto após x número de caracteres.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'Define e proprietário como e bloqueia o ticket para o Agente atual após abrir a tela de mover na interface de agente.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Automaticamente bloquear e definir o proprietário para o atendente atual após selecionar uma ação em massa.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            'Define automaticamente o proprietário do ticket como sendo também o responsável pelo ticket (se a funcionalidade de responsável por ticket estiver ativada). Isto só irá funcionar em ações manuais do usuário logado. Isto não funciona para ações automatizadas, como, Agente Genérico, PostMaster, e Interface Genérica.',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Automaticamente ajustar o responsável de um chamado (caso não esteja definido ainda) após a primeira atualização de proprietário.',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => 'Pele branca balanceada por Felix Niklas.',
        'Based on global RichText setting' => 'Baseado na configuração global RichText',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Bloqueia todos os e-mails recebidos que não possuam um número de chamado válido no assunto com endereço De: @exemplo.com.',
        'Bounced to "%s".' => 'Devolvido a "%s".',
        'Builds an article index right after the article\'s creation.' =>
            'Cria um índice de artigo logo após a criação do artigo.',
        'Bulgarian' => 'Búlgaro',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Configuração de exemplo CMD. Ignora e-mails nos quais o CMD externo retorna alguma saída em STDOUT (e-mail será canalizado para STDIN de algum.bin).',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Tempo de cache em segundos para autenticação de agentes na Interface Genérica.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Tempo de cache em segundos para autenticação de clientes na Interface Genérica.',
        'Cache time in seconds for the DB ACL backend.' => 'Tempo de cache em segundos para o backend DB ACL.',
        'Cache time in seconds for the DB process backend.' => 'Tempo de cache em segundos para o backend DB process.',
        'Cache time in seconds for the SSL certificate attributes.' => 'Tempo de cache em segundos para os atributos do certificado SSL.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'Tempo de cache em segundos para o módulo de saída da barra de navegação de ticket de processo',
        'Cache time in seconds for the web service config backend.' => 'Tempo de cache em segundos para o backend de configuração de webservice.',
        'Catalan' => 'Catalão',
        'Change password' => 'Alterar senha',
        'Change queue!' => 'Alterar fila!',
        'Change the customer for this ticket' => 'Alterar o Cliente deste Chamado',
        'Change the free fields for this ticket' => 'Alterar os Campos Livres para este Chamado',
        'Change the priority for this ticket' => 'Alterar a Prioridade Para Este Chamado',
        'Change the responsible for this ticket' => 'Alterar o responsável por este chamado',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Prioridade atualizada por "%s" (%s) para "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Altera o proprietário de chamados para todos (útil para ASP). Normalmente, apenas atendentes com permissões rw na fila do chamado serão mostrados.',
        'Checkbox' => 'Checkbox',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            'Verifica se o e-mail é uma continuação de um ticket existente ao pesquisar no assunto por um número de ticket válido.',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Verifica o SystemID na detecção de número de chamado para revisões (use "Não" se SystemID tiver sido alterado após usar o sistema).',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '',
        'Checks the entitlement status of OTRS Business Solution™.' => '',
        'Chinese (Simplified)' => 'Chinês (Simplificado)',
        'Chinese (Traditional)' => 'Chinês (Tradicional)',
        'Choose for which kind of ticket changes you want to receive notifications.' =>
            'Escolha para quais tipos de alterações em chamados você gostaria de receber notificações.',
        'Closed tickets (customer user)' => 'Chamados fechados (usuário cliente)',
        'Closed tickets (customer)' => 'Chamados fechados (cliente)',
        'Cloud Services' => 'Serviços de Nuvem',
        'Cloud service admin module registration for the transport layer.' =>
            'Registro de módulo da administração de serviço em nuvem para a camada de transporte.',
        'Collect support data for asynchronous plug-in modules.' => 'Coletar dados de suporte para módulos de plug-in assíncronos.',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Filtros de coluna de ticket para Visões Gerais de Ticket do tipo "Pequeno".',
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
        'Comment for new history entries in the customer interface.' => 'Comentário para novas entradas de histórico na interface de cliente.',
        'Comment2' => 'Comentário 2',
        'Communication' => 'Comunicação',
        'Company Status' => 'Situação da Empresa',
        'Company Tickets.' => 'Tickets da Empresa.',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Nome da empresa que será incluído nos e-mails enviados como X-Header.',
        'Compat module for AgentZoom to AgentTicketZoom.' => 'Módulo de compatibilidade de AgentZoom para AgentTicketZoom.',
        'Complex' => 'Complexo',
        'Configure Processes.' => 'Configurar Processos.',
        'Configure and manage ACLs.' => 'Configurar e gerenciar ACLs.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            'Configure qualquer banco de dados somente leitura espelhado adicional que você queira utilizar.',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'Configure qual tela deve ser mostrada após criar um novo chamado.',
        'Configure your own log text for PGP.' => 'Configure o seu próprio texto de registro para PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://otrs.github.io/doc/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            'Controla como disponibilizar as entradas do histórico de ticket como valores legíveis.',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            'Controla se o ID de Cliente é automaticamente copiado do endereço de envio para clientes desconhecidos.',
        'Controls if CustomerID is read-only in the agent interface.' => 'Controla se o ID de Cliente é somente leitura na interface de agente.',
        'Controls if customers have the ability to sort their tickets.' =>
            'Controla se os clientes têm a capacidade de classificar os seus chamados.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Controla se mais de uma entrada pode ser definida em um novo ticket de telefonema na interface de agente.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'Controla se o administrador pode importar uma configuração de sistema salva na Configuração do Sistema.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'Controla se o administrador pode fazer mudanças no banco de dados via AdminSelectBox.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Controla se o marcador de visualização de chamados e artigos são removidos quando um chamado é arquivado.',
        'Converts HTML mails into text messages.' => 'Converte e-mails HTML em mensagens de texto.',
        'Create New process ticket.' => 'Criar novo ticket de processo.',
        'Create Ticket' => 'Criar Ticket',
        'Create and manage Service Level Agreements (SLAs).' => 'Criar e gerenciar Acordos de Nível de Serviço (SLAs).',
        'Create and manage agents.' => 'Criar e gerenciar atendentes.',
        'Create and manage attachments.' => 'Criar e gerenciar anexos.',
        'Create and manage customer users.' => 'Criar e gerenciar usuários clientes.',
        'Create and manage customers.' => 'Criar e gerenciar clientes.',
        'Create and manage dynamic fields.' => 'Criar e gerenciar campos dinâmicos.',
        'Create and manage groups.' => 'Criar e gerenciar grupos.',
        'Create and manage queues.' => 'Criar e gerenciar filas.',
        'Create and manage responses that are automatically sent.' => 'Criar e gerenciar respostas enviadas automaticamente.',
        'Create and manage roles.' => 'Criar e gerenciar papéis.',
        'Create and manage salutations.' => 'Criar e gerenciar saudações.',
        'Create and manage services.' => 'Criar e gerenciar serviços.',
        'Create and manage signatures.' => 'Criar e gerenciar assinaturas.',
        'Create and manage templates.' => 'Criar e gerenciar modelos.',
        'Create and manage ticket notifications.' => 'Criar e gerenciar notificações de chamados',
        'Create and manage ticket priorities.' => 'Criar e gerenciar prioridades de chamados.',
        'Create and manage ticket states.' => 'Criar e gerenciar estados de chamados.',
        'Create and manage ticket types.' => 'Criar e gerenciar tipos de chamados.',
        'Create and manage web services.' => 'Criar e gerenciar web services.',
        'Create new Ticket.' => 'Criar novo Ticket.',
        'Create new email ticket and send this out (outbound).' => 'Criar um novo ticket de e-mail e enviar (enviado).',
        'Create new email ticket.' => 'Criar novo ticket de e-mail.',
        'Create new phone ticket (inbound).' => 'Criar um novo ticket de telefonema (recebido).',
        'Create new phone ticket.' => 'Criar novo ticket de telefone.',
        'Create new process ticket.' => 'Criar novo ticket de processo.',
        'Create tickets.' => 'Criar tickets.',
        'Croatian' => 'Croata',
        'Custom RSS Feed' => 'RSS Feed customizado',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => 'Administração de Cliente',
        'Customer Information Center Search.' => 'Pesquisa do Centro de Informações do Cliente',
        'Customer Information Center.' => 'Centro de Informações do Cliente.',
        'Customer Ticket Print Module.' => '',
        'Customer User <-> Groups' => 'Usuário Cliente <-> Grupos',
        'Customer User <-> Services' => 'Usuário Cliente <-> Serviços',
        'Customer User Administration' => 'Administração de Usuário Cliente',
        'Customer Users' => 'Usuários Clientes',
        'Customer called us.' => 'Cliente telefonou para atendente.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Item de cliente (ícone) que mostra os tickets fechados deste cliente como um bloco de informação. Definir CustomerUserLogin como 1 pesquisa por tickets baseado no nome de login ao invés de ID de Cliente.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Item de cliente (ícone) que mostra os tickets abertos deste cliente como um bloco de informação. Definir CustomerUserLogin como 1 pesquisa por tickets baseado no nome de login ao invés de ID de Cliente.',
        'Customer preferences.' => '',
        'Customer request via web.' => 'Requisição do cliente via web.',
        'Customer ticket overview' => '',
        'Customer ticket search.' => '',
        'Customer ticket zoom' => '',
        'Customer user search' => 'Busca de usuário cliente',
        'CustomerID search' => '',
        'CustomerName' => 'Nome do Cliente',
        'CustomerUser' => 'UsuárioCliente',
        'Customers <-> Groups' => 'Clientes <-> Grupos',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Czech' => 'Tcheco',
        'DEPRECATED: This config setting will be removed in further versions of OTRS. Sets the time (in seconds) a user is marked as active (minimum active time is 300 seconds).' =>
            '',
        'Danish' => 'Dinamarquês',
        'Data used to export the search result in CSV format.' => 'Os dados utilizados para exportar o resultado da pesquisa no formato CSV.',
        'Date / Time' => 'Data / Hora',
        'Debug' => 'Depurar',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Depura a tradução definida. Se isso for ajustado para "Sim" todas as cadeias (texto), sem traduções são escritas no stderr. Isso pode ser útil quando você está criando um novo arquivo de tradução. Caso contrário, essa opção deve permanecer definida para "Não ".',
        'Default' => 'Padrão',
        'Default (Slim)' => 'Padrão (fino)',
        'Default ACL values for ticket actions.' => 'Valores padrão de ACL para as ações de chamado.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Prefixos de entidade de Gerenciamento de Processos padrão para IDs de entidade que são automaticamente gerados.',
        'Default agent name' => '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Dados padrão para serem utilizados em atributo da tela de pesquisa de ticket. Por Exemplo: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Dados padrão para serem utilizados em atributo da tela de pesquisa de ticket. Por Exemplo: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default loop protection module.' => 'Módulo padrão de proteção de loop.',
        'Default queue ID used by the system in the agent interface.' => 'ID de fila padrão usado pelo sistema na interface de atendente.',
        'Default skin for the agent interface (slim version).' => 'Tema padrão para a interface de atendente (versão slim).',
        'Default skin for the agent interface.' => 'Tema padrão para a interface de atendente.',
        'Default skin for the customer interface.' => 'Skin padrão para a interface do cliente',
        'Default ticket ID used by the system in the agent interface.' =>
            'ID de chamado padrão usado pelo sistema na interface de atendente.',
        'Default ticket ID used by the system in the customer interface.' =>
            'ID de chamado padrão usado pelo sistema na interface de cliente.',
        'Default value for NameX' => 'Valor padrão para NameX',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            'Define Ações em que um botão de definições é disponibilizado no widget de objeto associado (LinkObject::ViewMode = "complex"). Favor observar que estas Ações deve ter registrados os seguintes arquivos JS e CSS: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definir um filtro para a saída HTML para adicionar links por trás de uma sequência definida. O elemento Imagem permite dois tipos de entrada. Em primeiro lugar o nome de uma imagem (faq.png, por exemplo). Neste caso, o caminho de imagem OTRS será usado. A segunda possibilidade é inserir o link para a imagem.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Definir um nome de campo dinâmico para tempo de término. Este campo deve ser adicionado manualmente ao sistema com Ticket "Data / Hora" e deve ser ativado nas telas de criação de ticket e/ou em quaisquer outras telas de ação de ticket.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Definir um nome de campo dinâmico para horário de início. Este campo deve ser adicionado manualmente ao sistema com Ticket "Data / Hora" e deve ser ativado nas telas de criação de ticket e/ou em quaisquer outras telas de ação de ticket.',
        'Define the max depth of queues.' => 'Define a profundidade máxima das filas.',
        'Define the queue comment 2.' => 'Defina o comentário 2 de fila.',
        'Define the service comment 2.' => 'Defina o comentário 2 de serviço.',
        'Define the sla comment 2.' => 'Defina o comentário 2 de SLA.',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            'Define o dia de início da semana no selecionador de dias do calendário indicado.',
        'Define the start day of the week for the date picker.' => 'Define o dia de início da semana para o selecionador de data.',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
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
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            'Define um filtro para coletar número CVE de textos de artigo no Zoom de Ticket de Agente. Os resultados serão exibidos em uma caixa de dados próxima ao artigo. Preencha URLPreview se você gostaria de ver uma visão prévia quando passar com o mouse sobre o elemento com o link. Isso pode ser a mesma URL que em URL, mas também uma alternativa. Favor observar que algumas páginas web bloqueiam a exibição dentro de um iframe (exemplo: Google) e, consequentemente, não funcionarão no modo visão prévia.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Define um filtro para processar o texto nos artigos, a fim de destacar palavras-chave predefinidas.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Define uma expressão regular que exclui alguns endereços da verificação de sintaxe (se "CheckEmailAddresses" está definido como "Sim"). Por favor, insira um regex neste campo para endereços de e-mail, que não são sintaticamente válidos, mas são necessários para o sistema (ou seja, "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Define uma expressão regular que filtra todos os endereços de e-mail que não devem ser utilizados na aplicação.',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            'Define um tempo de descanso, em microsegundos, entre tickets enquanto eles estão sendo processados pelo job.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Define um módulo útil para carregar opções específicas de usuário ou para exibir notícias.',
        'Defines all the X-headers that should be scanned.' => 'Define todos os X-headers que devem ser verificados.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            'Definir todos idiomas que devem estar disponíveis para a aplicação. Especificar aqui apenas nomes de idiomas em Inglês.',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            'Definir todos idiomas que devem estar disponíveis para a aplicação. Especificar aqui apenas nomes de idiomas em forma nativa.',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Define todos os parâmetros para o objeto RefreshTime das preferências de cliente da interface de cliente.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Define todos os parâmetros para o objeto ShownTickets das preferências de cliente da interface de cliente.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Define todos os parâmetros para este item nas preferências de cliente.',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            'Define todos parâmetros para este item na preferência de clientes. \'PasswordRegExp\' permite comparar senhas contra expressões regulares. Definir o número mínimo de caracteres utilizando \'PasswordMinSize\'. Definir se ao menos 2 caracteres caixa baixa e 2 caracteres caixa alta são necessários ao definir a opção apropriada para \'1\'. \'PasswordMin2Characters\' define se a senha precisa conter pelo menos 2 letras (definir como 0 ou 1). \'PasswordNeedDigit\' controla se pelo menos 1 dígito é necessário (definir como 0 ou 1 para controlar).',
        'Defines all the parameters for this notification transport.' => 'Define todos os parâmetros para este transporte de notificação.',
        'Defines all the possible stats output formats.' => 'Define todos os formatos possíveis de saída de estatísticas.',
        'Defines an alternate URL, where the login link refers to.' => 'Define uma URL alternativa, à qual o link de login se refere.',
        'Defines an alternate URL, where the logout link refers to.' => 'Define uma URL alternativa, à qual o link de logout se refere.',
        'Defines an alternate login URL for the customer panel..' => 'Define uma URL de login alternativa para o painel de cliente.',
        'Defines an alternate logout URL for the customer panel.' => 'Define uma URL de logout alternativa para o painel de cliente.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'Define um link externo para o banco de dados do cliente (por exemplo, \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' ou \'\').',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Define de quais atributos de ticket o agente pode selecionar a ordem de resultado.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Define como o campo de dos e-mails (enviados a partir das respostas e dos chamados e-mail) deve se parecer.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'Define se uma pré-ordenação por prioridade deverá ser feito na visão de fila.',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            'Define se uma pre-classificação por prioridade pode ser feita na visão de serviço.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório na tela de fechamento de chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de ticket é necessário na tela de envio de e-mail da interface de agente (se o ticket não estiver bloqueado ainda, o ticket é bloqueado e o agente atual será automaticamente definido como proprietário).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório na tela de devolução de chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório na tela de composição de chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório na tela de encaminhamento de chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório na tela de testo livre do chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório na tela de agrupamento de um chamado detalhado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório na tela de nota do chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório na tela de proprietário de um chamado detalhado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório na tela de pendência do chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório na tela de chamada telefônica recebida da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório na tela de chamado fone (saída) da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório na tela de prioridade de um chamado detalhado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório na tela de responsabilidade do chamado da interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se um bloqueio de chamado é obrigatório para alterar o cliente do chamado na interface de atendente (se o chamado não estiver bloqueado ainda, ele é bloqueado e o atendente atual será definido automaticamente como seu proprietário).',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Define se um agente deve ser autorizado a logar se não tiverem segredo compartilhado armazenado em suas preferências e, consequentemente, não estão utlizando autenticação de 2 fatores.',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Define se mensagens compostas tem que ser verificadas ortograficamente na interface do atendente.',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Define se um cliente deve ser autorizado a logar se não tiverem segredo compartilhado armazenado em suas preferências e, consequentemente, não estão utlizando autenticação de dois fatores.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'Define se o modo avançado deve ser utilizado (permite o uso de tabela, substituição, subscrito, sobrescrito, colar do Word, etc.).',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            'Define se um token previamente válido deve ser aceito para autenticação. Isso é um pouco menos seguro mas permite que os usuários tenham 30 segundos a mais para digitar suas senhas de uso único.',
        'Defines if the values for filters should be retrieved from all available tickets. If set to "Yes", only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Define a fila que é utilizada por tickets para exibir como eventos de calendário.',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Define a expressão regular IP para acessar o repositório local. Você precisa habilitar isso para ter acesso ao seu repositório local e o pacote: RepositoryList é obrigatório na máquina remota.',
        'Defines the URL CSS path.' => 'Define o caminho URL CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Define o caminho URL de ícones, CSS e Java Script.',
        'Defines the URL image path of icons for navigation.' => 'Define o caminho URL de imagem para ícones de navegação.',
        'Defines the URL java script path.' => 'Define o caminho URL de java scripts.',
        'Defines the URL rich text editor path.' => 'Define o caminho URL do editor de texto rico.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Define o endereço de um servidor DNS dedicado, se necessário, para os look-ups "CheckMXRecord".',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            'Define a chave de preferências de agente onde a chave de segredo compartilhado é armazenada.',
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
        'Defines the calendar width in percent. Default is 95%.' => 'Define o comprimento do calendário em porcentagem. O padrão é 95%.',
        'Defines the cluster node identifier. This is only used in cluster configurations where there is more than one OTRS frontend system. Note: only values from 1 to 99 are allowed.' =>
            '',
        'Defines the column to store the keys for the preferences table.' =>
            'Define a coluna para armazenar as chaves para a tabela de preferências.',
        'Defines the config options for the autocompletion feature.' => 'Define as opções de configuração para o recurso de preenchimento automático.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Define os parâmetros de configuração deste item para visualização na visão de preferências.',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => 'Define as conexões de http/ftp, através de um proxy.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            'Define a chave de preferências de cliente onde a chave de segredo compartilhado é armazenada.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Define o formato de entrada de data utilizado em formulários (opção ou campos de entrada).',
        'Defines the default CSS used in rich text editors.' => 'Define o CSS padrão utilizados nos editores rich text.',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '',
        'Defines the default auto response type of the article for this operation.' =>
            'Define o tipo padrão de autorresposta do artigo para esta operação.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Define o corpo padrão da nota na tela de ticket de campos livres da interface de agente.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://otrs.github.io/doc/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Define o idioma padrão do frontend. Todos os valores possíveis são determinados pelos arquivos de idioma disponíveis no sistema (veja a próxima definição).',
        'Defines the default history type in the customer interface.' => 'Define o tipo de histórico padrão na interface de cliente.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Define o número máximo padrão de atributos do eixo X para a escala de tempo.',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            'Define o número máximo de estatísticas por página na tela de visão geral.',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Define o próximo estado padrão de um ticket ao adicionar uma nota na tela de fechamento de ticket na interface de agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Define o próximo estado padrão de um ticket ao adicionar uma nota na tela de campos livres de ticket na interface de agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Define o próximo estado padrão de um ticket ao adicionar uma nota na tela de notas de ticket na interface de agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Define o próximo estado padrão de um ticket ao adicionar uma nota na tela de responsável pelo ticket na interface de agente.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Define o próximo estado padrão de um ticket ao encaminhar um ticket na tela de encaminhamento de ticket na interface de agente.',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            'Define o próximo estado padrão de um chamado após a mensagem ter sido enviada, na tela de envio de e-mail na interface do atendente.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Define o próximo estado padrão de um ticket após ele ter sido composto / respondido na tela de composição de ticket na interface de agente.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Define a o texto de corpo de nota padrão para tickets de telefonema na tela de telefonema recebido da interface de agente.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define a o texto de corpo de nota padrão para tickets de telefonema na tela de ticket de telefonema realizado da interface de agente.',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Define a prioridade padrão de novos tickets de cliente na interface de cliente.',
        'Defines the default priority of new tickets.' => 'Define a prioridade padrão de novos chamados.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Define a fila padrão de novos tickets de cliente na interface de cliente.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Define a seleção padrão no menu suspenso para objetos dinâmicos (Formulário: Especificação Comum). ',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Define a seleção padrão no menu suspenso para permissões (Formulário: Especificação Comum). ',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Define a seleção padrão no menu suspenso para formulário de estatísticas (Formulário: Especificação Comum). Favor inserir a chave do formato (ver Stats::Format).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Define o tipo de remetente padrão para tickets de telefonema na tela de ticket de telefonema recebido da interface de agente.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define o tipo de remetente padrão para tickets de telefonema na tela de ticket de telefonema realizado da interface de agente.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            'Define o atributo de pesquisa de ticket padrão na tela de pesquisa de ticket (Todos Tickets/Tickets Arquivados/Tickets Não Arquivados).',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Define o atributo de pesquisa de ticket padrão mostrado na tela de pesquisa de ticket. ',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'Define o atributo de pesquisa de ticket padrão mostrado na tela de pesquisa de ticket.  Por exemplo: "Chave" tem que ter o nome do Campo Dinâmico, neste caso \'X\', "Conteúdo" deve ter o valor do Campo Dinâmico baseado no tipo de Campo Dinâmico, Texto: \'a text\', Caixa de Seleção: \'1\', Data/Hora: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' e/ou \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'Define o critério padrão de ordenamento para todas filas apresentadas na visão de filas.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            'Define o critério padrão de ordenamento para todos serviços apresentados na visão de serviços.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Define a ordem de classificação padrão para todas as filas na visão de filas, após a classificação por prioridade.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            'Define o critério padrão de ordenamento para todos serviços apresentados na visão de serviços, após o ordenamento por prioridade.',
        'Defines the default spell checker dictionary.' => 'Define o dicionário padrão do corretor ortográfico.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Define o estado padrão de novos chamados de cliente na interface de cliente.',
        'Defines the default state of new tickets.' => 'Define o estado padrão de novos chamados.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Define o assunto padrão para tickets de telefonema na tela de ticket de telefonema recebido na interface de agente.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define o assunto padrão para tickets de telefonema na tela de ticket de telefonema realizado na interface de agente.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Define o assunto padrão para uma nota na tela de campo livre de ticket na interface de agente.',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            'Define o número de segundos padrão (em relação to tempo atual) para reagendar um tarefa da interface genérica que tenha falhado.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Define o atributo de ticket padrão para ordenamento de ticket na visão de escalonamento na interface de agente.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Define o atributo de ticket padrão para ordenamento de ticket na visão de ticket bloqueado da interface de agente.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Define o atributo de ticket padrão para ordenamento de ticket na visão de responsável por ticket da interface de agente.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Define o atributo de ticket padrão para ordenamento de ticket na visão de estado da interface de agente.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Define o atributo de ticket padrão para ordenamento de ticket na visão de observação da interface de agente.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Define o atributo de pesquisa de ticket padrão para ordenamento na tela de resultado de pesquisa de ticket da interface de agente. ',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'Define o atributo de ticket padrão para classificação na tela de resultado de pesquisa de ticket resultante desta operação. ',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Define o padrão de próximo estado de ticket após adicionar uma nota de telefonema na tela de ticket de telefonema recebido da interface de agente.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Define o padrão de próximo estado de ticket após adicionar uma nota de telefonema na tela de ticket de telefonema enviado da interface de agente.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define a ordem de ticket padrão (após o ordenamento por prioridade) na visão de escalonamento da interface de agente. Sobe: mais antigo no topo. Desce: mais recente no topo.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define o ordenamento de ticket padrão (após ordenamento por prioridade) na visão de estado da interface de agente. Sobe: mais antigos no topo. Desce: mais recentes no topo.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define a ordem de ticket padrão na visão de responsável na interface de agente. Sobe: mais antigo no topo. Desce: mais recente no topo.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define a ordem de ticket padrão na visão de ticket bloqueado na interface de agente. Sobe: mais antigo no topo. Desce: mais recente no topo.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define a ordem padrão de tickets no resultado da pesquisa de ticket na interface de agente. Sobe: mais antigo no topo. Desce: mais recente no topo.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            'Define a ordem padrão de tickets no resultado da pesquisa de ticket desta operação. Sobe: mais antigo no topo. Desce: mais recente no topo.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define a ordem de ticket padrão na visão de observação na interface de agente. Para cima: mais antigo no topo. Para baixo: mais recente no topo.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Define a prioridade padrão de ticket na tela de fechamento de ticket na interface de agente.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Define a prioridade padrão de ticket na tela de campos livres de ticket na interface de agente.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Define a prioridade padrão de ticket na tela de nota de ticket na interface de agente.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Define a prioridade padrão de ticket na tela de responsável por ticket na interface de agente.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'Define o tipo de ticket padrão para novos tickets de cliente na interface de cliente.',
        'Defines the default ticket type.' => 'Define o tipo de ticket padrão.',
        'Defines the default type for article in the customer interface.' =>
            'Define o tipo padrão para artigo na interface de cliente.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default type of the article for this operation.' => 'Define o tipo padrão do artigo para esta operação.',
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
            'Define o Módulo Frontend padrão utilizado se nenhum parâmetro Action tiver sido dado pela url na interface de agente.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Define o tipo de remetente visível padrão de um ticker (padrão: cliente).',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Define os campos dinâmicos que são utilizados para mostrar em eventos de calendário.',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Define o filtro que processa o texto em artigos de forma a realçar URLs.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'Define o formato de respostas na tela de composição de ticket na interface de agente ([% Data.OrigFrom | html %] é De 1:1, [% Data.OrigFromName | html %] é apenas o nome real em De).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Define o nome de domínio totalmente qualificado do sistema. Essa definição é utilizada como a variável OTRS_CONFIG_FQDN que é encontrada em todos os formatos de messageria utlizados pela aplicação para construir links dentro do seu sistema.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Define a altura do componente de edição rich text desta tela. Registre um número (pixels) ou uma porcentagem (relativo).',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Define a altura do componente de edição rich text. Registre um número (pixels) ou uma porcentagem (relativo).',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define o comentário do histórico para a ação da tela de fechamento de ticket que será utilizado no histórico de ticket na interface de agente.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define o comentário do histórico para a ação da tela de ticket de e-mail que será utilizado no histórico de ticket na interface de agente.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define o comentário do histórico para a ação da tela de ticket de telefonema que será utilizado no histórico de ticket na interface de agente.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Define o comentário de histórico para a ação campos livres de ticket, que é utilizado no histórico de ticket.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Define o comentário do histórico para a ação da tela de nota de ticket que será utilizado no histórico de ticket na interface de agente.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Define o comentário do histórico para a ação da tela de proprietário de ticket que será utilizado no histórico de ticket na interface de agente.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Define o comentário do histórico para a ação da tela de ticket pendente que será utilizado no histórico de ticket na interface de agente.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define o comentário do histórico para a ação da tela de ticket de telefonema recebido que será utilizado no histórico de ticket na interface de agente.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define o comentário do histórico para a ação da tela de ticket de telefonema realizado que será utilizado no histórico de ticket na interface de agente.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Define o comentário do histórico para a ação da tela de prioridade de ticket que será utilizado no histórico de ticket na interface de agente.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Define o comentário do histórico para a ação da tela de responsável pelo ticket que será utilizado no histórico de ticket na interface de agente.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Define o comentário do histórico para esta operação que será utilizado no histórico de ticket na interface de agente.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de histórico que será utilizado no histórico do ticket na interface de agente para a ação da tela de fechamento de ticket.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de histórico que será utilizado no histórico do ticket na interface de agente para a ação da tela de ticket de e-mail.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de histórico que será utilizado no histórico do ticket na interface de agente para a ação da tela de ticket de telefonema.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Define o tipo de histórico para a ação da tela de campos livres de ticket que é utilizado no histórico de ticket.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de histórico que será utilizado no histórico do ticket na interface de agente para a ação da tela de nota de ticket.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de histórico que será utilizado no histórico do ticket na interface de agente para a ação da tela de proprietário de ticket.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de histórico que será utilizado no histórico do ticket na interface de agente para a ação da tela de ticket pendente.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de histórico que será utilizado no histórico do ticket na interface de agente para a ação da tela de ticket de telefonema recebido.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de histórico que será utilizado no histórico do ticket na interface de agente para a ação da tela de ticket de telefonema realizado.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de histórico que será utilizado no histórico do ticket na interface de agente para a ação da tela de prioridade de ticket.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de histórico que será utilizado no histórico do ticket na interface de agente para a ação da tela de responsável pelo ticket.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de histórico que será utilizado no histórico do ticket na interface de agente para esta operação.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Define as horas e dias de semana do calendário indicado para contabilizar o tempo de trabalho.',
        'Defines the hours and week days to count the working time.' => 'Define as horas e dias de semana para contabilizar o tempo de trabalho.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Define a chave a ser verificada no módulo Kernel::Modules::AgentInfo. Se esta chave de preferência de usuário for verdadeira, então a mensagem é aceita pelo sistema.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            '',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Define o tipo de associação \'Normal\'. Se o nome de origem e o nome de destino contiverem o mesmo valor, a associação resultante será não-direcional; se não, o resultado será uma associação direcional.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Define o tipo de associação \'Pai e Filho\'. Se o nome de origem e o nome de destino contiverem o mesmo valor, a associação resultante será não-direcional; se não, o resultado será uma associação direcional.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Define os grupos de tipos de associação. Os tipos de associação do mesmo grupo cancelam um ao outro. Por exemplo: Se ticket A é associado com uma associação \'Normal\' com o ticket B, então esses tickets não pode ser associados adicionalmente com uma relação \'PaiFilho\'.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Define a lista de repositórios on-line. Uma outra instalação pode ser utilizada para repositório, exemplo: Chave="http://example.com/otrs/public.pl?Action=PublicRepository;File=" e Conteúdo="Algum Nome".',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            'Define a lista de próximas ações possíveis em uma tela de erro. Um caminho completo é necessário, então é possível adicionar links externos, se necessário.',
        'Defines the list of types for templates.' => 'Define a lista de tipos de modelos.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Define o local para buscar o repositório on-line para pacotes adicionais. O primeiro resultado disponível será utilizado.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            'Define o tamanho máximo (em bytes) para carregamento de arquivos através do navegador. Atenção! Definindo essa opção para um valor que é muito baixo pode causar muitas máscaras na sua instância OTRS a pararem de funcionar (provavelmente qualquer máscara que aceite registro de usuário).',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Define o tempo máximo válido (em segundos) para um id de sessão.',
        'Defines the maximum number of affected tickets per job.' => 'Define o número máximo de tickets impactados por job.',
        'Defines the maximum number of pages per PDF file.' => 'Define o número máximo de páginas por arquivo PDF.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => 'Define o tamanho máximo (em MB) do arquivo de log.',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            'Define o tamanho máximo em KiloByte de respostas da Interface Genérica que são registradas na tabela gi_debugger_entry_content.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Define o módulo que mostra todos os agentes logados no momento na interface de agente.',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            'Define o módulo que mostra na interface de agente todos os clientes logados no momento.',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => 'Define os módulos de autenticação dos clientes.',
        'Defines the module to display a notification if cloud services are disabled.' =>
            'Define o módulo para exibir uma notificação se serviços em nuvem estiverem desativados.',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            '',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            'Define o módulo para exibir uma notificação se o OTRS Daemon não estiver sendo executado.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'Define o módulo para exibir uma notificação na interface de agente se o usuário estiver logado enquanto uma manutenção do sistema estiver ativa.',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            'Define o módulo para exibir uma notificação na interface de agente se o alerta prévio de limite de sessão de agente tiver sido atingido.',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Define o módulo para exibir uma notificação na interface de agente se o sistema estiver em uso pelo usuário administrador (normalmente você não deveria trabalhar como administrador).',
        'Defines the module to generate code for periodic page reloads.' =>
            'Define o módulo para gerar código para atualizações periódicas de páginas.',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'Define o módulo para envio de e-mails. "Sendmail" utiliza o binário sendmail de seu sistema operacional diretamente. Qualquer dos mecanismos "SMTP" utiliza um servidor de e-mail (externo) especificado. "DoNotSendEmail" não envia e-mails e é útil para sistemas de teste.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Define o módulo utilizado para armazenar dados de sessão. Com "DB", o servidor frontend pode ser separado do servidor de banco de dados. "FS" é mais rápido.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Define o nome da aplicação que será exibido na interface web, abas e barra de título do navegador web.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Define o nome da coluna que armazena os dados da tabela de preferências.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Define o nome da coluna que armazena o identificador de usuário na tabela de preferências.',
        'Defines the name of the indicated calendar.' => 'Define o nome do calendário indicado.',
        'Defines the name of the key for customer sessions.' => '',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Define o nome da chave de sessão. Por exemplo, Sessão, ID de Sessão ou OTRS.',
        'Defines the name of the table where the user preferences are stored.' =>
            'Define o nome da tabela em que as preferências de usuário são armazenadas.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Define os próximos estados possíveis após compor / responder um ticket na tela de composição de um ticket na interface de agente.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Define os próximos estados possíveis após encaminhar um ticket na tela de encaminhamento de ticket na interface de agente.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'Define os próximos estados possíveis após enviar uma mensagem na tela de envio de e-mail na interface de agente.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Define os próximos estados possíveis após adicionar uma nota na tela de fechamento de ticket na interface de agente.',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Define o próximo estado de ticket possível após adicionar uma nota na tela de nota de ticket na interface de agente.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Define o próximo estado de ticket possível após adicionar uma nota na tela de responsável pelo ticket na interface de agente.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Define o próximo estado de ticket após mudança para uma nova fila na tela de mudança de ticket na interface de agente.',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '',
        'Defines the number of days to keep the daemon log files.' => 'Define o número de dias que os arquivos de log do daemon devem ser guardados.',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'Define o número de campos de cabeçalho em módulos frontend para adicionar e atualizar filtros postmaster. Pode ser até 99 campos.',
        'Defines the parameters for the customer preferences table.' => 'Define os parâmetros da tabela de preferências do cliente.',
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
        'Defines the path to PGP binary.' => 'Define o caminho para o binário PGP.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Define o caminho para abrir um binário SSL. Um HOME env pode ser necessário ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the postmaster default queue.' => 'Define a fila padrão do postmaster.',
        'Defines the priority in which the information is logged and presented.' =>
            'Define a prioridade em que as informações são registradas e apresentadas.',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            'Define o destinatário alvo do ticket de telefonema e o endereço de e-mail do remetente do ticket ("Queue" exibe todas filas, "System address" exibe todos endereços de sistema) na interface de agente.',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Define as permissões necessárias para mostrar um ticket na visão de escalonamento na interface de agente.',
        'Defines the search limit for the stats.' => 'Define o limite de pesquisa para as estatísticas.',
        'Defines the sender for rejected emails.' => 'Define o remetente de e-mails rejeitados.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Define o separadoe entre o nome real do agente e o endereço de e-mail da fila.',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Define as permissões padrão disponíveis para clientes dentro da aplicação. Se mais permissões são necessárias, você pode adicioná-las aqui. Permissões devem ser codificadas para serem efetivas. Por favor, assegure-se que, ao adicionar permissões que não as mencionadas, a permissão "rw" seja a última entrada.',
        'Defines the standard size of PDF pages.' => 'Define o tamanho padrão de páginas PDF.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Define o estado do chamado se ele for revisado e o chamado já estiver fechado.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Define o estado de um chamado se ele é revisado.',
        'Defines the state type of the reminder for pending tickets.' => 'Define o tipo de estado do lembrete para tickets pendentes.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Define o assunto de e-mails de notificação enviados a agentes sobr novas senhas.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Define o assunto para e-mails de notificação enviados a agentes com o token sobre uma nova senha solicitada.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Define o assunto de e-mails de notificação enviados a clientes sobre uma nova conta.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the subject for rejected emails.' => 'Define o assunto de e-mails rejeitados.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Define o endereço de e-mail do adminsitrador do sistema. Ele será apresentado nas telas de erro da aplicação.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'Define o atributo alvo no link com um banco de dados externo. Exemplo: \'AsPopup PopupType_TicketAction\'.',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Define o atributo alvo em um link para um banco de dados de cliente externo. Exemplo: "target"="cdb".',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'Define os campos de ticket que serão exibidos em eventos de calendário. A "Chave" define define o campo ou atributo de ticket e "Conteúdo" define o nome de exibição.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Define o fuso horário de um calendário indicado, que pode ser associado a uma fila específica posteriormente.',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => 'Define o módulo de autenticação de dois fatores para autenticar agentes.',
        'Defines the two-factor module to authenticate customers.' => 'Define o módulo de autenticação de dois fatores para autenticar clientes.',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Define o tipo de protocolo utilizado pelo servidor web para servir a aplicação. Se o protocolo https for utilizado no lugar do http básico, isto deve ser especificado aqui. Como isto não tem efeito nas definições ou no comportamento do servidor web, isto não irá alterar o método que a aplicação será acessada e, se estiver errado, isto não irá prevenir a realização de login na aplicação. Esta definição só é utilizada como a variável OTRS_CONFIG_HttpType que pode ser encontrada em todas as formas de messageria utlizada pela aplicação para construir links para tickets dentro do seu sistema.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => 'Define os tipos de estado válidos para um ticket.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            'Define os estados válidos para tickets desbloqueados. Para desbloquear tickets, o script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" pode ser utilizado.',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            'Define os bloqueios visíveis de um ticket. OBSERVAÇÃO: Quando você alterar esta definição, certifique-se de que o cache tenha sido excluído para poder utilizar o novo valor. Padrão: unlock, tmp_lock.',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Define quais tipos de remetente devem ser exibidos na visão prévia de um ticket.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'Define quais itens estão disponíveis em \'Ação\' no terceiro nível da estrutura de ACL.',
        'Defines which items are available in first level of the ACL structure.' =>
            'Define quais itens estão disponíveis no primeiro nível da estrutura de ACL.',
        'Defines which items are available in second level of the ACL structure.' =>
            'Define quais itens estão disponíveis em \'Ação\' no segundo nível da estrutura de ACL.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Define quais estados devem ser definidos automaticamente (Conteúdo) após um estado pendente (Chave) ter sido atingido.',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'Define quais tickets de quais tipos de estado de ticket não devem ser listados na lista de ticket associado.',
        'Delete expired cache from core modules.' => 'Excluir cache expirado de módulos core.',
        'Delete expired loader cache weekly (Sunday mornings).' => 'Excluir loader cache expirado semanalmente (manhãs de Domingo).',
        'Delete expired sessions.' => 'Excluir sessões expiradas',
        'Deleted link to ticket "%s".' => 'Associações do chamado excluídas "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Exclui a sessão se o id de sessão for utlizado por um endereço de IP remoto inválido.',
        'Deletes requested sessions if they have timed out.' => 'Exclui as sessões solicitadas se elas tiverem expirado.',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            'Entrega informações de depuração extendidas no frontend caso um erro AJAX ocorra, se ativado.',
        'Deploy and manage OTRS Business Solution™.' => 'Implementar e gerenciar o OTRS Business Solution™.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Determina se uma lista de filas disponíveis para mover um ticket para deve ser apresentada em uma lista ou em uma nova janela na interface de agente. Se "Nova Janela" for definido, você pode adicionar uma nota ao mover o ticket.',
        'Determines if the statistics module may generate ticket lists.' =>
            'Determina se o módulo de estatísticas pode gerar listas de tickets.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Determina os próximos estados de ticket possíveis após a criação de um ticket de e-mail na interface de agente.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Determina os próximos estados de ticket possíveis após a criação de um ticket de telefonema na interface de agente.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'Determina os próximos estados de ticket possíveis para tickets de processo na interface de agente.',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Determina a próxima tela após um novo ticket de cliente na interface de cliente.',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'Determina a próxima tela após um ticket ser movido. LastScreenOverview vai retornar para a última tela de visão geral (por exemplo, resultados de pesquisa, visão de filas, painel). TicketZoom irá retornar para o Zoom do Ticket.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Determina os estados possíveis para tickets pendentes que mudaram de estado após atingirem o limite de tempo.',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'Determina os strings que serão exibidos como destinatário (To:) de um ticket de telefonema e de remetente (From:) de um ticket de e-mail na interface de agente. Para Fila, como  NewQueueSelectionType "<Queue>", exibe os nomes das filas e, para Endereço de Sistema "<Realname> <<Email>>" exibe o nome e o e-mail do destinatário.',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Determina o método que objetos associados são exibidos em cada máscara de zoom.',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Determina quais opções serão válidas para o destinatário (ticket de telefonema) e para o remetente (ticket de e-mail) na interface de agente.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'Desativa o cabeçalho HTTP "Content-Security-Policy" para permitir o carregamento de conteúdos de scripts externos. Desativar este cabeçalho HTTP pode ser um problema de segurança! So desative se você souber o que está fazendo.',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'Desativa o cabeçalho HTTP "X-Frame-Options: SAMEORIGIN" para que o OTRS seja incluído como um IFrame em outras páginas web. Desativar este cabeçalho HTTP pode ser um problema de segurança! Só desative se você souber o que está fazendo.',
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
        'Display settings to override defaults for Process Tickets.' => 'Mostra definições que podem sobrepor padrões de Tickets de Processo.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Exibe o tempo contabilizado para um artigo na visão de zoom de ticket.',
        'Dropdown' => 'Suspenso',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Dynamic Fields Checkbox Backend GUI' => 'GUI de Backend para Campos Dinâmicos do Tipo Caixa de Seleção',
        'Dynamic Fields Date Time Backend GUI' => 'GUI de Backend para Campos Dinâmicos do Tipo Data Hora',
        'Dynamic Fields Drop-down Backend GUI' => 'GUI de Backend para Campos Dinâmicos do Tipo Campo Suspenso',
        'Dynamic Fields GUI' => 'GUI de Campos Dinâmicos',
        'Dynamic Fields Multiselect Backend GUI' => 'GUI de Backend para Campos Dinâmicos do Tipo Seleção Múltipla',
        'Dynamic Fields Overview Limit' => 'Limite da Visualização de Campos Dinâmicos',
        'Dynamic Fields Text Backend GUI' => 'GUI de Backend para Campos Dinâmicos do Tipo Texto',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Campos Dinâmicos utilizados para exportar os resultados de pesquisa em formato CSV.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'Grupos de campos dinâmicos para o widget de processos. A chave é o nome do grupo e o valor contém o campo a ser exibido. Por exemplo: \'Chave => Meu Grupo\', \'Conteúdo: Nome_X, NomeY\'.',
        'Dynamic fields limit per page for Dynamic Fields Overview' => 'Limite da visualização de campos dinâmicos por página.',
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
        'DynamicField' => 'CampoDinâmico',
        'DynamicField backend registration.' => 'Registro de backend de Campo Dinâmico.',
        'DynamicField object registration.' => 'Registro de objeto de Campo Dinâmico.',
        'E-Mail Outbound' => 'E-mail de Saída',
        'Edit Customer Companies.' => 'Editar Empresas Clientes.',
        'Edit Customer Users.' => 'Editar Usuários Clientes.',
        'Edit customer company' => 'Editar empresa de cliente',
        'Email Addresses' => 'Endereços de E-mail',
        'Email Outbound' => 'E-mail Enviado',
        'Email sent to "%s".' => 'E-mail enviado para "%s".',
        'Email sent to customer.' => 'E-mail enviado a cliente(s).',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => 'Filtros ativos.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Ativa suporte PGP. Quando suporte PGP é ativado para assinar e criptografar e-mail, é ALTAMENTE recomendável que o servidor web seja executado como o usuário OTRS. Se não, ocorrerão problemas com os privilégios ao acessar a pasta .gnupg.',
        'Enables S/MIME support.' => 'Habilita suporte a S/MIME.',
        'Enables customers to create their own accounts.' => '',
        'Enables fetch S/MIME from CustomerUser backend support.' => '',
        'Enables file upload in the package manager frontend.' => 'Ativa carregamento de arquivo no frontend de gerenciamento de pacotes.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            'Ativa ou desativa o cache de modelos. ATENÇÃO! NÃO desative cache de modelos em ambientes produtivos pois isto causará uma enorme queda de performance! Esta definição só deve ser desativada para razões de depuração!',
        'Enables or disables the debug mode over frontend interface.' => 'Ativa ou desativa o modo de depuração sobre a interface de frontend.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Ativa ou desativa a funcionalidade de observador de ticket, para acompanhar tickets sem ser proprietário nem responsável.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Ativar o log de performance (para registrar o tempo de resposta). Isto irá impactar na performance do sistema. Frontend::Module###AdminPerformanceLog deve ser ativado.',
        'Enables spell checker support.' => 'Habilita suporte do corretor ortográfico.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'Ativa o tamanho mínimo de contador de ticket (se "Data" foi selecionado em TicketNumberGenerator).',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Ativa a funcionalidade de responsável por um ticket, para acompanhar um ticket específico.',
        'Enables ticket watcher feature only for the listed groups.' => 'Ativa a funcionalidade de observação de ticket apenas para os grupos listados.',
        'English (Canada)' => 'Inglês (Canadá)',
        'English (United Kingdom)' => 'Inglês (Reino Unido)',
        'English (United States)' => 'Inglês (Estados Unidos)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Enroll process for this ticket' => 'Registra esse ticket em um processo',
        'Enter your shared secret to enable two factor authentication.' =>
            'Digite sua chave secreta para habilitar a autenticação em dois fatores.',
        'Escalation response time finished' => '',
        'Escalation response time forewarned' => '',
        'Escalation response time in effect' => 'Escalação - Prazo de resposta inicial em vigor.',
        'Escalation solution time finished' => 'Interrupção do prazo de solução.',
        'Escalation solution time forewarned' => '',
        'Escalation solution time in effect' => 'Escalação - Prazo de solução em vigor.',
        'Escalation update time finished' => '',
        'Escalation update time forewarned' => '',
        'Escalation update time in effect' => 'Escalação - Prazo de atualização em vigor.',
        'Escalation view' => 'Visão de Escalação',
        'EscalationTime' => 'Horário de Escalação',
        'Estonian' => 'Estoniano',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'Registro de módulo de evento. Para mais performance você pode definir um evento disparador (exemplo: Evento => TicketCreate).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Registro de módulo de evento. Para mais performance você pode definir um evento disparador (exemplo: Event => TicketCreate). Isto só é possível se todos os campos dinâmicos necessitarem do mesmo evento.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'Módulo de evento que realiza um declaração de atualização do Índice de Ticket para renomear o nome de fila, se necessário, e se StaticDB estiver em uso.',
        'Event module that updates customer user search profiles if login changes.' =>
            'Módulo de evento que atualiza os perfis de pesquisa de usuário cliente se o login for alterado.',
        'Event module that updates customer user service membership if login changes.' =>
            'Módulo de evento que atualiza a filiação de um usuário cliente a um serviço se o login for alterado.',
        'Event module that updates customer users after an update of the Customer.' =>
            'Módulo de evento que atualiza usuários clientes após uma atualização do Cliente.',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Módulo de evento que atualiza tickets após uma atualização de Usuário Cliente.',
        'Event module that updates tickets after an update of the Customer.' =>
            'Módulo de evento que atualiza tickets após uma atualização de Cliente.',
        'Events Ticket Calendar' => 'Calendário de Eventos de Chamado',
        'Execute SQL statements.' => 'Executar consultas SQL.',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            'Executa um comando customizado ou módulo. Observação: se o módulo for utlizado, função é necessária.',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Exporta toda a arvore de artigos no resultado de pesquisa (pode afetar a performance de sistema).',
        'Fetch emails via fetchmail (using SSL).' => 'Coletar e-mails via fetchmail (usando SSL).',
        'Fetch emails via fetchmail.' => 'Coletar e-mails via fetchmail.',
        'Fetch incoming emails from configured mail accounts.' => 'Coletar e-mails recebidos das contas de e-mail configuradas.',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Coleta pacotes via proxy. Sobrescreve "WebUserAgent::Proxy".',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            'Arquivo que é exibido no módulo Kernel::Modules::AgentInfo, se localizado em Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Filtro para depuração de ACLs. Observação: Mais atributos de ticket podem ser adicionados no formato <OTRS_TICKET_Attribute> exemplo <OTRS_TICKET_Priority>.',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => 'Filtrar e-mails de entrada.',
        'Finnish' => 'Filândes',
        'First Queue' => 'Primeira Fila',
        'FirstLock' => 'Primeiro Bloqueio',
        'FirstResponse' => 'Primeira Resposta',
        'FirstResponseDiffInMin' => 'Diferença de Tempo da Primeira Resposta em Minutos',
        'FirstResponseInMin' => 'Primeira Resposta em Minutos',
        'Firstname Lastname' => 'Nome Sobrenome',
        'Firstname Lastname (UserLogin)' => 'Nome Sobrenome (login)',
        'FollowUp for [%s]. %s' => 'Revisado por [%s] %s.',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Força a codificação de e-mails enviados (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Força a escolha de um estado de ticket diferente (do atual) após ação de bloqueio. Defina o estado atual como chave e o próximo estado após a ação de bloqueio como conteúdo.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Força o desbloqueio de chamados após serem movidos para outra fila.',
        'Forwarded to "%s".' => 'Encaminhado para "%s".',
        'French' => 'Frnacês',
        'French (Canada)' => 'Francês (Canadá)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Frontend' => 'Frontend',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            'Registro de módulo frontend (desativa o link AgentTicketService se a funcionalidade Serviço de Ticket não for utilizada).',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Registro de módulo frontend (desativar o link de companhia se nenhuma funcionalidade de companhia for utilizada).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'Registro de módulo frontend (desativar a tela de tickets de processo se nenhum processo estiver disponível).',
        'Frontend module registration for the agent interface.' => 'Registro de módulo frontend para a interface de agente.',
        'Frontend module registration for the customer interface.' => 'Registro de módulo front-end para a interface de cliente.',
        'Frontend module registration for the public interface.' => 'Frontend de registo do módulo para a interface pública.',
        'Frontend theme' => 'Tema da interface',
        'Frontend theme.' => '',
        'Full value' => 'Valor total',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => 'Busca em todo o texto',
        'Galician' => 'Galega',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => 'Gerar estatísticas de painel.',
        'Generic Info module.' => 'Módulo de informação genérica.',
        'GenericAgent' => 'Atendente Genérico',
        'GenericInterface Debugger GUI' => 'GUI de Depuração da Interface Genérica',
        'GenericInterface Invoker GUI' => 'GUI de Invoker da Interface Genérica',
        'GenericInterface Operation GUI' => 'GUI de Operação da Interface Genérica',
        'GenericInterface TransportHTTPREST GUI' => 'GUI TransportHTTPREST da Interface Genérica',
        'GenericInterface TransportHTTPSOAP GUI' => 'GUI TransportHTTPSOAP da Interface Genérica',
        'GenericInterface Web Service GUI' => 'GUI Webservices da Interface Genérica',
        'GenericInterface Webservice History GUI' => '',
        'GenericInterface Webservice Mapping GUI' => '',
        'GenericInterface module registration for the invoker layer.' => 'Registro de módulo da Interface Genérica para a camada do invoker.',
        'GenericInterface module registration for the mapping layer.' => 'Módulo de registro da interface genérica para a camada de mapeamento.',
        'GenericInterface module registration for the operation layer.' =>
            'Módulo de registro da interface genérica para a camada de operação.',
        'GenericInterface module registration for the transport layer.' =>
            'Módulo de registro da interface genérica para a camada de transporte.',
        'German' => 'Alemão',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Global Search Module.' => '',
        'Go back' => 'Voltar',
        'Google Authenticator' => 'Autenticador Google',
        'Graph: Bar Chart' => 'Gráfico de Barras',
        'Graph: Line Chart' => 'Gráfico de Linhas',
        'Graph: Stacked Area Chart' => '',
        'Greek' => 'Grego',
        'HTML Reference' => 'Referência HTML',
        'HTML Reference.' => 'Referência HTML.',
        'Hebrew' => 'Hebreu',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild".' =>
            '',
        'Hindi' => 'Hindu',
        'Hungarian' => 'Húngaro',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Se "DB" foi selecionado para Customer::AuthModule, um driver de banco de dados (normalmente autodetecção é utilizada) pode ser especificado.',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Se "DB" foi selecionado para Customer::AuthModule, uma senha para conectar com a tabela de clientes pode ser especificada.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Se "DB" foi selecionado para Customer::AuthModule, um nome de usuário para conectar com a tabela de clientes pode ser especificada.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Se "DB" foi selecionado para Customer::AuthModule, o DSN para conectar com a tabela de clientes deve ser especificado.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Se "DB" foi selecionado para Customer::AuthModule, o nome da coluna da Senha de Cliente na tabela do cliente deve ser especificada.',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Se "DB" foi selecionado para Customer::AuthModule, o nome da coluna da Chave de Cliente na tabela do cliente deve ser especificado.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Se "DB" foi selecionado para Customer::AuthModule, o nome da tabela onde os dados de cliente serão armazenados deve ser especificado.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Se "DB" foi selecionado para SessionModule, o nome da tabela do banco de dados onde os dados serão armazenados deve ser especificado.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Se "FS" foi selecionado para SessionModule, o diretório onde os dados de sessão serão armazenados deve ser especificado.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Se "LDAP" foi selecionado para Customer::AuthModule e você quiser adicionar um sufixo para cada nome de login de cliente, especifique isto aqui, por exemplo, você só quer escrever o nome do usuário, mas, em seu diretório LDAP existe usuário@domínio.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Se "LDAP" foi selecionado para Customer::AuthModule e parâmetros especiais são necessários para o módulo perl Net::LDAP, estes podem ser especificados aqui. Veja "perldoc Net::LDAP" para mais informações sobre os parâmetros.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Se "LDAP" foi selecionado para Customer::AuthModule e seus usuários têm apenas acesso anônimo para a árvore do LDAP, mas você quer pesquisar os dados, você pode fazer isso com um usuário que tem acesso ao diretório LDAP. Especifique aqui a senha deste usuário especial.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Se "LDAP" foi selecionado para Customer::AuthModule e seus usuários têm apenas acesso anônimo para a árvore do LDAP, mas você quer pesquisar os dados, você pode fazer isso com um usuário que tem acesso ao diretório LDAP. Especifique aqui o nome deste usuário especial.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Se "LDAP" foi selecionado para Customer::AuthModule, BaseDN precisa ser especificado.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Se "LDAP" foi selecionado para Customer::AuthModule, o host LDAP pode ser especificado.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Se "LDAP" foi selecionado para Customer::AuthModule, o identificador de usuário precisa ser especificado.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Se "LDAP" foi selecionado para Customer::AuthModule, atributos de usuários podem ser especificados. Para LDAP posixGroups utilize UID, para posixGroups que não forem LDAP utilize full user DN.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Se "LDAP" foi selecioando para Customer::AuthModule, você pode especificar atributos de acesso aqui.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Se "LDAP" foi selecionado para Customer::AuthModule, você pode especificar se as aplicações iram ser paradas se, por exemplo, uma conexão com o servidor não puder ser estabelecida por causa de problemas de rede.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'Se "LDAP" foi selecionado como Customer::Authmodule, você pode verificar se o usuário está autorizado a autenticar por pertencer a um posixGroup. Exemplo: o usuário precisa pertencer ao grupo xyz para utilizar o OTRS. Especificar o grupo que pode acessar o sistema.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Se "Radius" foi selecionado para Customer::AuthModule, a senha para autenticação com o radius deve ser especificada.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Se "Radius" foi selecionado para Customer::AuthModule, o host Radius devem ser especificado.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Se "Radius" foi selecionado para Customer::AuthModule, você pode especificar se a aplicação irá para se, por exemplo, uma conexão com o servidor não puder ser estabelecida por caus de problemas de rede.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Se "Sendmail" foi selecionado como SendmailModule, o local do binário de sendmail e as opções necessárias precisam ser especificados.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            '',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Se "SysLog" foi selecionado como Módulo de Log, o charset que deve ser utilizado para efetuar login pode ser especificado.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Se "SysLog" foi selecionado como Módulo de Log, um arquivo de log deve ser especificado. Se este arquivo não existir, ele será criado pelo sistema.',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            'Se ativo, nenhuma expressão regular pode coincidir com o e-mail do usuário para permitir o registro.',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            'Se ativo, uma expressão regular deve coincidir com o e-mail do usuário para permitir o registro.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Se algum dos mecanismos "SMTP" foi selecionado como SendmailModule, e autenticação no servidor de e-mails é necessária, uma senha precisa ser especificada.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Se qualquer mecanismo "SMTP" foi selecionado como SendmailModule e autenticação ao servidor de e-mail for necessário, um nome de usuário precisa ser especificado.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Se qualquer mecanismo "SMTP" foi selecioando como SendmailModule, o host de e-mail que envia e-mails precisa ser especificado.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Se qualquer mecanismo "SMTP" foi selecioando como SendmailModule, o port que seu servidor de e-mail está escutando para conexões recebidas precisa ser especificado.',
        'If enabled debugging information for ACLs is logged.' => 'Se ativado, informações de depuração para ACLs são registradas.',
        'If enabled debugging information for transitions is logged.' => '',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            'Se ativado, o Daemon vai redirecionar o fluxo de erro padrão para o arquivo de log.',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            'Se ativado, o Daemon vai redirecionar o fluxo de saída padrão para o arquivo de log.',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTRSHome>/var/run/ can not be used.' =>
            'Se ativado, o daemon irá utilizar este diretório para criar seus arquivos PID. Observação: Favor parar o daemon antes de realizar qualquer mudança e utilize esta definição apenas se não for possível utilizar <$OTRSHome>/var/run/.',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Se ativo, chamados por fone  e chamados por e-mail serão abertos em uma nova janela.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            'Se ativado, o tag de versão OTRS será removido da interface web, dos cabeçalhos HTTP e os X-Headers de e-mails enviados. OBSERVAÇÃO: se você alterar esta opção, favor garantir que o cache seja excluído.',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Se habilitado, os diferentes quadros (Painel, Visão de Estados, Visão de Filas) serão automaticamente atualizados após o tempo especificado.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Se ativado, o primeiro nível do menu principal é aberto ao flutuar com o mouse sobre ele (ao invés de abrir ao clicar apenas).',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            'Se nenhum SendmailNotificationEnvelopeFrom for especificado, esta definição torna possível utilizar o endereço de remetente do e-mail ao invés de um envelope de remetente vazio (necessário em algumas configurações de servidor de e-mail).',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            'Se definido, este endereço é utilizado como header de envelope de remetente em notificações enviadas. Se nenhum endereçno for especificado, o header de envelope de remetente é vazio (a não ser que SendmailNotificationEnvelopeFrom::FallbackToEmailFrom seja definido).',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            'Se definido, este endereço é utilizado com envelope de remetente em mensagens enviadas (não notificações - ver abaixo). Se nenhum endereço for especificado, o envelope de remetente é igual ao endereço de e-mail da fila.',
        'If this option is disabled, articles will not automatically be decrypted and stored in the database. Please note that this also means no decryption will take place and the articles will be shown in ticket zoom in their original (encrypted) form.' =>
            '',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If this setting is active, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            'Se você for ficar ausente, você pode desejar informar os outros usuários ao definir as datas exatas de sua ausência.',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            'Incluir tickets de subfilas como padrão quando selecionar uma fila.',
        'Include unknown customers in ticket filter.' => 'Incluir clientes desconhecidos no filtro de ticket.',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Inclui horários de criação de artigos na pesquisa de ticket da interface de agente.',
        'Incoming Phone Call.' => 'Telefonema Recebido.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indonesian' => 'Indonésio',
        'Input' => 'Entrada',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Linguagem da Interface',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Italian' => 'Italiano',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Ivory' => 'Marfim',
        'Ivory (Slim)' => 'Marfim (fino)',
        'Japanese' => 'Japonês',
        'JavaScript function for the search frontend.' => '',
        'Last customer subject' => 'Último assunto de cliente',
        'Lastname Firstname' => 'ÚltimoNome PrimeiroNome',
        'Lastname Firstname (UserLogin)' => 'ÚltimoNome PrimeiroNome (Login de Usuário)',
        'Lastname, Firstname' => 'Sobrenome, Nome',
        'Lastname, Firstname (UserLogin)' => 'Sobrenome, Nome (Login)',
        'Latvian' => 'Letão',
        'Left' => 'Esquerda',
        'Link Object' => 'Associar Objeto',
        'Link Object.' => 'Associar Objeto.',
        'Link agents to groups.' => 'Associar atendentes a grupos.',
        'Link agents to roles.' => 'Associar atendentes a papéis.',
        'Link attachments to templates.' => 'Associar anexos a modelos.',
        'Link customer user to groups.' => 'Associar usuário cliente a grupos.',
        'Link customer user to services.' => 'Associar usuário cliente a serviços.',
        'Link queues to auto responses.' => 'Associar filas a respostas.',
        'Link roles to groups.' => 'Associar papéis a grupos.',
        'Link templates to queues.' => 'Associar modelos a filas.',
        'Links 2 tickets with a "Normal" type link.' => 'Associa 2 chamados com um link do tipo "Normal".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Associa 2 chamados com um link do tipo "Pai-Filho".',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Lista de arquivos CSS que sempre serão carregados na interface de agente.',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            'Lista de arquivos JS que sempre serão carregados na interface de agente.',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'Lista de todos eventos de Empresa Cliente que serão apresentados na GUI.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'Lista de todos os eventos CustomerUser a serem exibidos na interface.',
        'List of all DynamicField events to be displayed in the GUI.' => 'Lista de todos eventos de Campos Dinâmicos a serem exibidos no GUI.',
        'List of all Package events to be displayed in the GUI.' => 'Lista de todos eventos de Pacote a serem exibidos no GUI.',
        'List of all article events to be displayed in the GUI.' => 'Lista de todos eventos de artigo a serem exibidos no GUI.',
        'List of all queue events to be displayed in the GUI.' => 'Lista de todos eventos de fila a serem exibidos no GUI.',
        'List of all ticket events to be displayed in the GUI.' => 'Lista de todos eventos de ticket a serem exibidos no GUI.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Lista de Modelos Padrão que serão designados automaticamente a novas Filas quando criadas.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            'Lista de arquivos responsivos CSS que sempre são carregados na interface de agente.',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List view' => 'Visão de lista',
        'Lithuanian' => 'Lituano',
        'Lock / unlock this ticket' => 'Bloquear / desbloquear este chamado',
        'Locked Tickets.' => 'Chamados Bloqueados.',
        'Locked ticket.' => 'Chamado bloqueado.',
        'Log file for the ticket counter.' => '',
        'Logged-In Users' => 'Usuário logados',
        'Logout of customer panel.' => 'Logout do painel de clientes.',
        'Loop-Protection! No auto-response sent to "%s".' => 'Proteção de loop! Autorresposta enviada para "%s".',
        'Mail Accounts' => 'Contas de E-mail',
        'Main menu registration.' => 'Registro do menu principal.',
        'Makes the application block external content loading.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Faz a aplicação verifica o registro MX de um endereço de e-mail antes de enviar um e-mail ou submeter um ticket de e-mail ou telefone.',
        'Makes the application check the syntax of email addresses.' => 'Faz a aplicação verificar a sintaxe de endereços de e-mail.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Malay' => 'Malásio',
        'Manage OTRS Group cloud services.' => 'Gerenciar serviços de nuvem OTRS Group.',
        'Manage PGP keys for email encryption.' => 'Gerenciar chaves PGP para encriptação de e-mail.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Gerenciar contas POP3 e IMAP para buscar e-mails.',
        'Manage S/MIME certificates for email encryption.' => 'Gerenciar certificados S/MIME para encriptação de e-mail.',
        'Manage existing sessions.' => 'Gerenciar sessões existentes.',
        'Manage support data.' => 'Gerenciar dados de suporte.',
        'Manage system registration.' => 'Gerenciar registro do sistema.',
        'Manage tasks triggered by event or time based execution.' => 'Gerenciar tarefas disparadas por evento ou com execução baseada em tempo.',
        'Mark this ticket as junk!' => 'Marcar este chamado como lixo!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Tamanho máximo (em caracteres) da tabela de informações do cliente (telefone e e-mail) na tela de composição.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Tamanho máximo (em linhas) da caixa de agentes informados na interface de agente.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Tamanho máximo (em linhas) da caixa de agentes envolvidos na interface de agente.',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            'Tamanho máximo dos assuntos em uma resposta de e-mails e em algumas telas de visão geral.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Tamanho máximo em KBytes dos e-mails que podem ser coletados via POP3/POP3S/IMAP/IMAPS (KBytes).',
        'Maximum Number of a calendar shown in a dropdown.' => 'Número Máximo de calendários exibidos em um campo de seleção.',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Tamanho máximo (em caracteres) do campo dinâmico no artigo na visão de zoom de ticket.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'Tamanho máximo (em caracteres) do campo dinâmico na barra lateral na visão de zoom de ticket.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Número máximo de tickets a serem exibidos no resultado de uma pesquisa na interface de agente.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            'Número máxiom de tickets a serem apresentados como resultado desta operação.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Tamanho máximo (em caracteres) da tabela de informação de cliente na visão de zoom de ticket.',
        'Merge this ticket and all articles into another ticket' => 'Agrupar esse ticket e todos artigos com um outro ticket',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => 'Chamado <OTRS_TICKET> agrupado com <OTRS_MERGE_TO_TICKET>.',
        'Miscellaneous' => 'Outros',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            'Módulo para verificar permissões de grupo para o acesso de clientes a tickets.',
        'Module to check the group permissions for the access to tickets.' =>
            'Módulo para verificar permissões de grupo para o acesso a tickets.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Módulo para compor mensagens assinadas (PGP ou S/MIME).',
        'Module to crypt composed messages (PGP or S/MIME).' => '',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            'Módulo para coletar certificados S/MIME de usuários clientes em mensagens recebidas.',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Módulo para filtrar e manipular mensagens recebidas. Bloquear/ignorar todo e-mail de spam  com De: endereço noreply@.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to filter encrypted bodies of incoming messages.' => 'Módulo para filtrar corpos criptografados de mensagens recebidas.',
        'Module to generate accounted time ticket statistics.' => 'Módulo para gerar estatísticas de contabilização de tempo de ticket.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            'Módulo para gerar estatísticas de tempo de solução e de resposta.',
        'Module to generate ticket statistics.' => 'Módulo para gerar estatísticas de ticket.',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            'Módulo para permitir acesso se o ID de Cliente do ticket for o mesmo que o ID de Cliente do cliente.',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            'Módulo para permitir acesso se o ID de Usuário Cliente do ticket for o mesmo que o ID de Usuário Cliente do cliente.',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            'Módulo que permite acesso a qualquer agente que tenha sido envolvido no passado com um ticket (baseado nas entradas do histórico do ticket).',
        'Module to grant access to the agent responsible of a ticket.' =>
            'Módulo que permite acesso ao agente responsável pelo ticket.',
        'Module to grant access to the creator of a ticket.' => 'Módulo que permite acesso ao criador de um ticket.',
        'Module to grant access to the owner of a ticket.' => 'Módulo que permite acesso ao proprietário de um ticket.',
        'Module to grant access to the watcher agents of a ticket.' => 'Módulo que permite acesso aos agentes observadores de um ticket.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'Módulo para exibir notificações e escalonamentos (ShownMax: máximo de escalonamentos exibidos, EscalationInMinutes: Exibir ticket que irá escalonar em, CacheTime: Cache de escalonamentos calculados em segundos).',
        'Module to use database filter storage.' => 'Módulo para utilizar armazenamento de filtro do banco de dados.',
        'Multiselect' => 'Multisseleção',
        'My Services' => 'Meus Serviços',
        'My Tickets.' => 'Meus Chamados.',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Nome da fila padrão. A fila padrão é uma seleção de fila entre as suas filas preferidas e pode ser selecionada nas definições de preferências.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            'Nome do serviço padrão. O serviço padrão é uma seleção de serviço entre os seus serviços preferidos e pode ser selecionado nas definições de preferências.',
        'NameX' => 'NomeX',
        'Nederlands' => 'Holandês',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'Novo chamado [%s] foi criado (F=%s;P=%s;E=%s).',
        'New Window' => 'Nova Janela',
        'New owner is "%s" (ID=%s).' => 'Novo proprietário é "%s" (ID=%s).',
        'New process ticket' => 'Novo chamado via processo',
        'New responsible is "%s" (ID=%s).' => 'Novo responsável é "%s" (ID=%s).',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Próximos estados de ticket possíveis após adicionar uma nota de telefonema na tela de telefonema recebido da interface de agente.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Próximos estados de ticket possíveis após adicionar uma nota de telefonema na tela de ticket de telefonema realizado da interface de agente.',
        'None' => 'Nenhum',
        'Norwegian' => 'Norueguês',
        'Notification sent to "%s".' => 'Notificação enviada para "%s".',
        'Number of displayed tickets' => 'Número de Chamados Exibidos',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Número de linhas (por ticket) que são exibidos pela utilidade de pesquisa na interface de agente.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Número de tickets a serem exibidos em cada página de resultado de pesquisa na interface de agente.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'Old: "%s" New: "%s"' => 'Ant.: "%s" Novo: "%s".',
        'Open tickets (customer user)' => 'Chamados abertos (usuário cliente)',
        'Open tickets (customer)' => 'Chamados abertos (cliente)',
        'Option' => 'Opção',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Limite opcional de fila para o módulo de permissão CreatorCheck. Se definido, permissão só é dada para tickets nas filas especificadas.',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Limite opcional de fila para módulo de permissão InvolvedCheck. Se definido, permissão só é dada para tickets nas filas especificadas.',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Limite opcional de fila para módulo de permissão OwnerCheck. Se definido, permissão só é dada para tickets nas filas especificadas.',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Limite opcional de fila para módulo de permissão ResponsibleCheck. Se definido, permissão só é dada para tickets nas filas especificadas.',
        'Out Of Office' => 'Fora do Escritório',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Sobrecarrega (redefine) funções existentes em Kernel::System::Ticket. Utilizado para facilmente adicionar customizações.',
        'Overview Escalated Tickets.' => 'Visão Geral de Chamados Escalados.',
        'Overview Refresh Time' => 'Tempo de Atualização do Painel',
        'Overview of all escalated tickets.' => 'Revisão de todos os chamados escalados.',
        'Overview of all open Tickets.' => 'Visão Geral de Todos os Chamados Abertos',
        'Overview of all open tickets.' => 'Revisão de todos os chamados abertos.',
        'Overview of customer tickets.' => 'Revisão de chamados de clientes.',
        'PGP Key Management' => 'Gerenciamento de chaves PGP',
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
            'Parâmetros para o backend de painel das informações de empresa cliente na interface de agente. "Limit" é o número de entradas exibidas como padrão. "Group" é utilizado para restringir o acesso ao plugin (exemplo Group: admin;group1;group2;). "Default" determina se o plugin é ativado como padrão ou se o usuário precisa ativar manualmente. "CacheTTLLocal" é o tempo de cache, em minutos, para o plugin.',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parâmetros para o backend de painel do widget de status de ID de usuário cliente na interface de agente. "Limit" é o número de entradas exibidas como padrão. "Group" é utilizado para restringir o acesso ao plugin (exemplo Group: admin;group1;group2;). "Default" determina se o plugin é ativado como padrão ou se o usuário precisa ativar manualmente. "CacheTTLLocal" é o tempo de cache, em minutos, para o plugin.',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parâmetros para o backend de painel da visão geral da lista de usuários clientes na interface de agente. "Limit" é o número de entradas exibidas como padrão. "Group" é utilizado para restringir o acesso ao plugin (exemplo Group: admin;group1;group2;). "Default" determina se o plugin é ativado como padrão ou se o usuário precisa ativar manualmente. "CacheTTLLocal" é o tempo de cache, em minutos, para o plugin.',
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
        'Parameters of the example SLA attribute Comment2.' => 'Parâmetros do atributo SLA de exemplo Comentário2.',
        'Parameters of the example queue attribute Comment2.' => 'Parâmetros do atributo fila de exemplo Comentário2.',
        'Parameters of the example service attribute Comment2.' => 'Parâmetros do atributo de serviço de exemplo Comentário2.',
        'ParentChild' => 'Pai e Filho',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Caminho para o arquivo de log (aplica apenas se "FS" foi selecionado para LoopProtectionModule e é mandatório).',
        'People' => 'Pessoas',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => 'Largura permitida para janelas de composição de e-mail.',
        'Permitted width for compose note windows.' => 'Largura permitida para janelas de composição de nota.',
        'Persian' => 'Persa',
        'Phone Call.' => 'Telefonema.',
        'Picture Upload' => 'Upload de Imagem',
        'Picture upload module.' => 'Módulo de upload de imagem.',
        'Picture-Upload' => '',
        'Polish' => 'Polonês',
        'Portuguese' => 'Português',
        'Portuguese (Brasil)' => 'Português (Brasil)',
        'PostMaster Filters' => 'Filtros PostMaster',
        'PostMaster Mail Accounts' => 'Contas de E-mail PostMaster',
        'Process Management Activity Dialog GUI' => 'Interface de Gerenciamento de Janela de Atividade de Processo',
        'Process Management Activity GUI' => 'Interface de Gerenciamento de Atividade de Processo',
        'Process Management Path GUI' => 'Interface de Gerenciamento de Caminho de Processo',
        'Process Management Transition Action GUI' => 'Interface de Gerenciamento de Atividade de Transição de Processo',
        'Process Management Transition GUI' => 'Interface de Gerenciamento de Transição de Processo',
        'Process Ticket.' => '',
        'Process pending tickets.' => 'Tickets pendentes de processo.',
        'Process ticket' => 'Ticket de Processo',
        'ProcessID' => 'ID de Processo',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Proteção contra exploração CSRF (Cross Site Request Forgery) (para mais informação veja http://en.wikipedia.org/wiki/Cross-site_request_forgery).',
        'Provides a matrix overview of the tickets per state per queue.' =>
            'Fornece uma visão geral dos chamados por estado e por fila.',
        'Queue view' => 'Visão de Filas',
        'Rebuild the ticket index for AgentTicketQueue.' => 'Reconstruir o índice de tickets para AgentTicketQueue.',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh interval' => 'Intervalo de atualização.',
        'Removed subscription for user "%s".' => 'Removida assinatura para o usuário "%s".',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'Remove a informação de monitoramento quando o chamado é arquivado.',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be active in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Substitui o remetente original pelo endereço de e-mail do cliente atual ao compor uma resposta na tela de composição de ticket da interface de agente.',
        'Reports' => 'Relatórios',
        'Reports (OTRS Business Solution™)' => 'Relatórios (OTRS Business Solution™)',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Permissões necessárias para alterar o cliente de um ticket na interface do agente.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Permissões necessárias para utilizar a janela de fechamento de ticket na interface de agente.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            'Permissões necessárias para utilização da tela de envio de e-mail na interface de agente.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Permissões necessárias para utilização da tela de composição de ticket na interface de agente.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Permissões necessárias para utilizar a tela de encaminhamento na interface de agente.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Permissões necessárias para utilizar a tela campos livres de ticket na interface de agente.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Permissões necessárias para utilizar a tela de adicionar nota em ticket na interface de agente.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Permissões necessárias para utilizar a tela de ticket de chamado telefônico recebido na interface de agente.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Permissões necessárias para utilizar a tela de ticket de chamado telefônico realizado na interface de agente.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Permissões necessárias para utilizar a tela de reponsável por ticket na interface de agente.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Reinicia a propriedade e desbloqueia o chamado se ele for movido para outra fila.',
        'Responsible Tickets' => 'Tickets de sua Responsabilidade',
        'Responsible Tickets.' => 'Tickets de sua Responsabilidade.',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            'Recupera um ticket do arquivo (somente se o evento é uma mudança de estado para qualquer estado aberto disponível).',
        'Retains all services in listings even if they are children of invalid elements.' =>
            'Mantém todos serviços nas listagens mesmo quando eles forem filhos de elementos inválidos.',
        'Right' => 'Direita',
        'Roles <-> Groups' => 'Papéis <-> Grupos',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            'Executa jobs de agente genérico baseados em arquivo (Observação: o nome do módulo deve estar especificado no parâmetro -configuration-module, como, por exemplo: "Kernel::System::GenericAgent").',
        'Running Process Tickets' => 'Chamados de Processo Executando',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            'Executa uma pesquisa coringa inicial dos usuários clientes existentes ao acessar o módulo Cliente na Administração',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Executa uma pesquisa coringa inicial dos usuários clientes existentes ao acessar o módulo AdminCustomerUser.',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => 'Russo',
        'SMS' => 'SMS',
        'SMS (Short Message Service)' => 'SMS (Serviço de Mensagens Curtas)',
        'Sample command output' => 'Exemplo de saída de comando',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            'Salva os anexos de artigos. "DB" armazena todos os dados no banco de dados (não recomendado para armazenar anexos grandes). "FS" armazenao os dados no filesystem; isto é mais rápido, mas o servidor web tem que rodar através do usuário OTRS. Você pode alterar entre módulos sem perder dados mesmo quando um sistema já estiver em produção. Observação: Buscar nomes de anexos não é suportado quando "FS" é utilizado.',
        'Schedule a maintenance period.' => 'Agendar um período de manutenção',
        'Screen' => 'Tela',
        'Search Customer' => 'Procurar cliente',
        'Search Ticket.' => 'Buscar Chamado.',
        'Search Tickets.' => 'Buscar Chamados.',
        'Search User' => 'Procurar Atendente',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Search.' => 'Busca.',
        'Second Queue' => 'Segunda Fila',
        'Select after which period ticket overviews should refresh automatically.' =>
            'Selecione a frequência com que a visão geral de chamados deve ser atualizada.',
        'Select how many tickets should be shown in overviews by default.' =>
            'Selecione quantos chamados deverão ser mostrados na visão geral por padrão.',
        'Select the main interface language.' => 'Selecione o idioma principal da interface.',
        'Select your default spelling dictionary.' => '',
        'Select your preferred layout for OTRS.' => '',
        'Select your preferred theme for OTRS.' => 'Selecione seu tema preferido do OTRS.',
        'Select your time zone.' => '',
        'Selects the cache backend to use.' => 'Seleciona o backend de cache que será utilizado.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Seleciona o módulo que lida com carregamentos na interface web. "DB" armazenad todos carregamentos no banco de dados, "FS" utiliza o sistema de arquivos.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            'Seleciona o módulo gerador do número do chamado. "AutoIncremento" incrementa o número do chamado: SystemID e contador são usados no formato SystemID.Contador (ex. 1010138, 1010139). Ao escolher "Data", os números dos chamados serão gerados pela junção da data atual com o SystemID e com o Contador: o formato é Ano.Mês.Dia.SystemID.Contador (ex. 200206231010138, 200206231010139). Com "DateChecksum", o contador será anexado como soma de verificação para a sequência de data mais SystemID. A soma de verificação vai ser rodada numa base diária. O formato é Ano.Mês.Dia.SystemID.Contador.CheckSum (ex. 2002070110101520, 2002070110101535). "Aleatório" gera números de chamados aleatórios no formato "SystemID.Random" (ex. 100057866352, 103745394596).',
        'Send new outgoing mail from this ticket' => 'Enviar novo e-mail de saída deste chamado',
        'Send notifications to users.' => 'Enviar notificações para usuários.',
        'Sender type for new tickets from the customer inteface.' => 'Tipo de remetente para novos tickets da interface de cliente.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Enviar notificação de atendente sobre revisões apenas para o proprietário, se o chamado estiver desbloqueado (o padrão é enviar a notificação para todos os atendentes).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Envia todos os e-mails enviados como uma cópia oculta ao endereço especificado. Favor utilizar isso apenas para motivos de backup.',
        'Sends customer notifications just to the mapped customer.' => 'Envia notificações de cliente somente para os clientes mapeados.',
        'Sends registration information to OTRS group.' => 'Envia informações de registro para o Grupo OTRS.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Envia notificações de lembrete de ticket desbloqueado após atingir a data de lembrete (enviado apenas para o proprietário do ticket).',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            'Envia as notificações que estão configuradas na interface de administração em "Notificações de Ticket".',
        'Serbian Cyrillic' => 'Sérvio Cirílico',
        'Serbian Latin' => 'Sérvio Latim',
        'Service view' => 'Visão de serviços',
        'ServiceView' => 'Visão de Serviço',
        'Set a new password by filling in your current password and a new one.' =>
            'Defina uma nova senha ao preencher sua senha atual e uma nova.',
        'Set sender email addresses for this system.' => 'Configurar endereços de e-mail de remetente para o sistema.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            'Define o limite de tickets que serão executados em uma única execução de job do Agente Genérico.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            'Define o nível mínimo de log. Se você selecionar \'error\', somente erros serão registrados. Com \'debug\' você verá todas mensagens registradas. A ordem de níveis de log é: \'debug\', \'info\', \'notice\' e \'error\'.',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if SLA must be selected by the agent.' => 'Define se o SLA deve ser selecionado pelo agente.',
        'Sets if SLA must be selected by the customer.' => 'Define se o SLA deve ser selecionado pelo cliente.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Define se uma nota deve ser preenchida por um agente. Pode ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Sets if service must be selected by the agent.' => 'Define se serviço deve ser selecionado pelo agente.',
        'Sets if service must be selected by the customer.' => 'Define se serviço deve ser selecionado pelo cliente.',
        'Sets if ticket owner must be selected by the agent.' => 'Define se o proprietário do ticket deve ser selecionado pelo agente.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Define o Tempo de Pendente de um ticket para 0 se o estado mudar para um estado que não é pendente.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Define a idade em minutos (primeiro nível) para realçar filas que contêm tickets que não foram tocados.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Define a idade em minutos (segundo nível) para realçar filas que contêm tickets que não foram tocados.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Define o nível de configuração do administrador. Dependendo no nível de configuração, algumas opções da Configuração do Sistema serão exibidas. Os níveis de configuração estão em ordem ascendente: Expert, Avançado, Iniciante. O quanto mais alto for o nível de configuração (Iniciante é o mais alto), menos provável que o usuário possa configurar o sistema de forma que ele não seja mais utilizável.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            'Define o número de artigos visíveis no modo de visão prévia de visões gerais de ticket.',
        'Sets the default article type for new email tickets in the agent interface.' =>
            '',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Define o texto de corpo padrão para notas adicionadas na tela de fechamento de ticket na interface de agente.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Define o texto de corpo padrão para notas adicionadas na tela de mover ticket na interface de agente.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Define o texto de corpo padrão para notas adicionadas na tela de nota de ticket na interface de agente.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Define o texto de corpo padrão para notas adicionadas na tela de responsável por ticket na interface de agente.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Define o tipo de associação padrão de tickets divididos na interface de agente.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            'Define a mensagem padrão da notificação que é exibida durante um período de manutenção do sistema.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Define o próximo estado de ticket padrão para novos tickets de telefonema na interface de agente.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Define o próximo estado de ticket padrão após a criação de um ticket de e-mail na interface de agente.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Define o texto de nota padrão para novos tickets de telefonema. Exemplo: \'Novo ticket via fone\' na interface de agente.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Define a prioridade padrão para novos tickets de e-mail na interface de agente.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Define a prioridade padrão para novos tickets de telefonema na interface de agente.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Define o tipo de remetente padrão para novos tickets de e-mail na interface de agente.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Define o tipo de remetente padrão para novo ticket de telefonema na interface de agente.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Define o assunto padrão para novos tickets de e-mail (exemplo: \'e-mail enviado\') na interface de agente.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Define o assunto padrão para novos tickets de telefonema (exemplo: \'Telefonema\') na interface de agente.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Define o assunto padrão para notas adicionadas na tela de fechamento de ticket na interface de agente.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Define o assunto padrão para notas adicionadas na tela de mover ticket na interface de agente.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Define o assunto padrão para notas adicionadas na tela de nota de ticket na interface de agente.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Define o assunto padrão para notas adicionadas na tela de responsável pelo ticket na interface de agente.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Define o texto padrão para novos tickets de e-mail na interface de agente.',
        'Sets the display order of the different items in the preferences view.' =>
            '',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            'Define o tempo de inatividade (em segundos) que deve transcorrer até que a sessão seja encerrada e o usuários seja deslogado.',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime before a prior warning will be visible for the logged in agents.' =>
            'Define o número máximo de agentes ativos no intervalo de tempo definido em SessionMaxIdleTime antes que um alerta fique visível para os agentes logados.',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            'Define o número máximo de agentes ativos dentro do período de tempo registrado em SessionMaxIdleTime.',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            'Define o número máximo de clientes ativos dentro do período de tempo registrado em SessionMaxIdleTime.',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            'Define o número máximo de sessões ativas dentro do período de tempo registrado em SessionMaxIdleTime.',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            'Define o número máximo de sessões ativas por cliente dentro do período de tempo registrado em SessionMaxIdleTime.',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            'Define o tamanho mínimo do contador de ticket se "AutoIncrement" tiver sido selecionado como TicketNumberGenerator. Padrão é 5, o que quer dizer que o contador começa em 10000.',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            'Define os minutes que uma notificação é exibida como alerta sobre um período futuro de manutenção de sistema.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Define o número de linhas exibidas nas mensagens de texto (exemplo: linhas de ticket na Visão de Fila)',
        'Sets the options for PGP binary.' => 'Define as opções para binário PGP.',
        'Sets the order of the different items in the customer preferences view.' =>
            '',
        'Sets the password for private PGP key.' => 'Define a senha para chave PGP privada.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Configura as unidades de tempo preferidas (ex. unidades de trabalho, horas, minutos).',
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
            'Define o agente responsável por um ticket na tela de fechamento de ticket na interface de agente.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Define o agente responsável por um ticket na tela de campos livres de ticket na interface de agente.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Define o agente responsável por um ticket na tela de nota de ticket na interface de agente.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Define o agente responsável por um ticket na tela de responsável por um ticket na interface de agente.',
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
            'Define o estado do ticket na tela de fechamento de ticket na interface de agente.',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'Define o estado de um ticket na tela de campos livres de ticket na interface de agente.',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'Define o estado de um ticket na tela de nota de ticket na interface de agente.',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'Define o estado de um ticket na tela de responsável por um ticket na interface de agente.',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the stats hook.' => 'Define os caracteres de ligação para estatísticas.',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Define o proprietário do ticket na tela de fechamento de ticket na interface de agente.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Define o proprietário do ticket na tela de campos livres de um ticket na interface de agente.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Define o proprietário do ticket na tela de nota de ticket na interface de agente.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Define o proprietário do ticket na tela de responsável por um ticket na interface de agente.',
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
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Define o tempo de encerramento (em segundos) para baixar arquivos em http/ftp.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Define o tempo de encerramento (em segundos) para baixar pacotes. Sobrescreve "WebUserAgent::Timeout".',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Shared Secret' => 'Segredo Compartilhado',
        'Should the cache data be held in memory?' => '',
        'Should the cache data be stored in the selected cache backend?' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Mostra uma seleção de responsável em tickets de telefone e e-mail na interface de agente.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Mostrar artigo como rich text mesmo quando escrita em rich text estiver desativada.',
        'Show queues even when only locked tickets are in.' => 'Mostrar filas mesmo quando apenas contiverem tickets bloqueados.',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => 'Mostrar o histórico deste chamado',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            'Mostra um contador de ícones no detalhamento do chamado, caso o artigo tenha anexos.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu que permite associar um ticket com um outro objeto na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu que permite associar tickets na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu que permite acessar o histórico de um ticket na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para adicionar um campo livre na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para adicionar uma nota na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Mostra um link no menu para adicionar uma nota em um ticket em todas visões gerais de ticket da interface de agente.',
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para adicionar um telefonema recebido na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para adicionar um telefonema realizado na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para alterar o cliente que fez a solicitação do ticket na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para alterar o proprietário do ticket na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para alterar o agente responsável por um ticket na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Mostra um link no menu para fechar um ticket em todas visões gerais de ticket da interface de agente.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para fechar um ticket na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Mostra um link no menu para excluir um ticket em todas visões gerais de ticket na interface de agente. Controle de acesso adicional para exibir ou não este link pode ser feito ao utilizar Chave "Group" e Conteúdo como "rw:group1;move_into:group2".',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para excluir um ticket na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            'Mostra um link no menu para registrar um ticket a um processo na visão de zoom do ticket na interface de agente.',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu de voltar para a página anterior na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Mostra um link no menu para bloquear / desbloquear um ticket em todas visões gerais de ticket da interface de agente.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para bloquear/desbloquear tickets na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Mostra um link no menu para mover um ticket em todas visões gerais de ticket da interface de agente.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para imprimir um ticket ou um artigo do ticket na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Mostra um link no menu para visualizar o histórico de um ticket em todas visões gerais de ticket da interface de agente.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para exibir a prioridade de um ticket na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para enviar um e-mail na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Mostra um link no menu para definir um ticket como lixo em todas visões gerais de ticket na interface de agente. Controle de acesso adicional para exibir ou não este link pode ser feito ao utilizar Chave "Group" e Conteúdo como "rw:group1;move_into:group2".',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para definir um ticket como pendente na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Mostra um link no menu para definir a prioridade de um ticket em todas visões gerais de ticket da interface de agente.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Mostra um link no menu para dar zoom em um ticket em todas visões gerais de ticket da interface de agente.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Mostra um link para acessar os anexos do artigo via visualizador html integrado na visão de detalhe do artigo da interface de atendente.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Mostra um link para baixar anexos do artigo na tela de detalhe do artigo da interface de atendente.',
        'Shows a link to see a zoomed email ticket in plain text.' => '',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Mostra um link no menu para definir um ticket como Lixo ou Spam na visão de zoom de ticket na interface de agente. Controle de acesso adicional para exibir este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo com "rw:group1;move_into:group2". Para agrupar itens de menu utilizar como Chave "ClusterName" e como Conteúdo qualquer nome que você queira exibir na interface de usuário. Utilize "ClusterPriority" para configurar a ordem de um determinado agrupamento na barra de ferramentas.',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Mostra uma lista de todos agentes envolvidos neste ticket na tela de fechamento de ticket da interface de agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Mostra a lista de todos os agentes envolvidos neste ticket na tela de campos livres de ticket na interface de agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Mostra uma lista de todos agentes envolvidos neste ticket na tela de nota de ticket da interface de agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Mostra uma lista de todos agentes envolvidos neste ticket na tela de proprietário de ticket da interface de agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Mostra uma lista de todos agentes envolvidos neste ticket na tela de responsável pelo ticket da interface de agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Mostra lista de todos agentes possíveis (todos agentes com permissão de nota na fila/ticket) para determinar quem pode ser infomado sobre esta nota na tela de fechamento de ticket da interface de agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Mostra a lista de todos os agentes possíveis (todos agentes com permissões de nota na fila/ticket) para determinar quem deve ser informado sobre essa nota na tela de campos livres de ticket na interface de agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Mostra lista de todos agentes possíveis (todos agentes com permissão de nota na fila/ticket) para determinar quem pode ser infomado sobre esta nota na tela de nota de ticket da interface de agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Mostra lista de todos agentes possíveis (todos agentes com permissões de nota na fila/ticket) para determinar quem pode ser infomado sobre esta nota na tela de responsável pelo ticket da interface de agente.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Mostra uma visão prévia da visão geral de ticket (CustomerInfo => 1 - também mostra Informação de Cliente, CustomerInfoMaxSize tamanho máximo, em caracteres, da Informação de Cliente).',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => 'Mostrar todas filas tanto ro quanto rw na visão de fila.',
        'Shows all both ro and rw tickets in the service view.' => 'Mostrar todos tickets, tanto ro quanto rw, na visão de serviço.',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Mostra todos os tickets abertos (mesmo os que estiverem bloqueados) na visão de escalonamento na interface de agente.',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Mostra todos identificadores de cliente em um campo de multiseleção (não é útil se você tiver diversos identificadores de cliente).',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            'Mostra todos identificadores de usuário cliente em um campo de multiseleção (não é útil se você tiver diversos identificadores de usuário cliente).',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Mostra uma seleção de proprietário em tickets de telefonema e e-mail na interface de agente.',
        'Shows colors for different article types in the article table.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Mostra histórico de tickets do cliente em AgentTicketPhone, AgentTicketEmail e AgentTicketCustomer.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Mostra listas existentes no sistema de filas pai/filho no formato de uma árvore ou uma lista.',
        'Shows information on how to start OTRS Daemon' => 'Mostra informações de como inciar o Daemon OTRS',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Mostra os artigos ordenados normalmente ou em reverso no zoom de ticket da interface de agente.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Mostra informações do usuário cliente (telefone e e-mail) na tela de composição.',
        'Shows the customer user\'s info in the ticket zoom view.' => '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Mostra a mensagem do dia na tela de login da interface de agente.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Mostra o histórico de ticket (em ordem reversa) na interface de agente.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Mostra as opções de prioridade de ticket na tela de fechamento de ticket na interface de agente.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Mostra as opções de prioridade de ticket na tela de mover ticket na interface de agente.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Mostra as opções de prioridade de ticket na tela de campos livres de ticket na interface de agente.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Mostra as opções de prioridade de ticket na tela de nota de ticket na interface de agente.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Mostra as opções de prioridade de ticket na tela de responsável por um ticket na interface de agente.',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            'Exibe o campo de título na tela de campos livres na interface de agente.',
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
        'Skin' => 'Tema',
        'Slovak' => 'Eslovaco',
        'Slovenian' => 'Esloveno',
        'Software Package Manager.' => 'Gerenciado de pacote de software.',
        'SolutionDiffInMin' => 'Delta de tempo de solução em minutos',
        'SolutionInMin' => 'Tempo de solução em minutos',
        'Some description!' => 'Uma descrição!',
        'Some picture description!' => 'Uma descrição de imagem!',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Ordena os tickets (ascendente ou descendente) quando uma fila tiver sido selecionada na visão de fila e após os tickets terem sido ordenados por prioridade. Valores: 0 = ascendente (mais antigos no topo, padrão), 1 = descendente (mais recentes no topo). Utilize o ID de Fila para a chave e 0 ou 1 para o valor.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            'Ordena os tickets (ascendente ou descendente) quando uma fila tiver sido selecionada na visão de serviço e após os tickets terem sido ordenados por prioridade. Valores: 0 = ascendente (mais antigos no topo, padrão), 1 = descendente (mais recentes no topo). Utilize o ID de Fila para a chave e 0 ou 1 para o valor.',
        'Spam' => 'Spam',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Exemplo de configuração de Assassino de Spam. Ignora e-mails marcados com SpamAssassin.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Exemplo de configuração de Assassino de Spam. Move e-mails marcados para a fila SPAM.',
        'Spanish' => 'Espanhol',
        'Spanish (Colombia)' => 'Espanhol (Colômbia)',
        'Spanish (Mexico)' => 'Espanhol (México)',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Especifica se um agente deve receber notificações de e-mail de suas próprias ações.',
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
        'Specifies the directory where SSL certificates are stored.' => 'Especifica o diretório em que certificados SSL são armazenados.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Especifica o diretório em que certificados SSL privados são armazenados.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            'Especifica o endereço de e-mail que deve ser utilizado pela aplicação ao enviar notificações. O endereço de e-mail é utilizado para construir o nome completo de exibição das notificações (exemplo: "Notificações OTRS" otrs@your.example.com). Você pode utilizar a variável OTRS_CONFIG_FQDN como definida na sua configuração ou escolher um outro endereço de e-mail.',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            'Especifica os endereços de e-mail para receber mensagens de notificação de tarefas agendadas.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            'Especifica o nome que deve ser utilizado pela aplicação ao enviar notificações. O nome do remetente deve ser utilizado pela aplicação ao enviar notificações. O nome do remetente é utilizado para construir o nome completo de exibição para a notificação (exemplo "Notificações OTRS" otrs@your.example).',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Especifica a ordem em que o primeiro e o último nomes de agentes serão exibidos.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Especifica o caminho para o arquivo da logo no cabeçalho da página (gif|jpg|png, 700 x 100 pixel).',
        'Specifies the path of the file for the performance log.' => 'Especifica o caminho para o arquivo com o log de performance.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Especifica o caminho do conversor que permite a visualização de arquivos Excel na interface web.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Especifica o caminho do conversor que permite a visualização de arquivos Word na interface web.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Especifica o caminho do conversor que permite a visualização de documentos PDF na interface web.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Especifica o caminho do conversor que permite a visualização de arquivos XML na interface web.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Especifica o texto que deve aparecer no arquivo de log para demonstrar uma entrada de script CGI.',
        'Specifies user id of the postmaster data base.' => 'Especifica o user id do postmaster database',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            'Especifica se todos backends de armazenamento devem ser verificados ao buscar anexos. Isso só é necessário para instalações em que alguns anexos estão no sistema de arquivo e outros estão no banco de dados.',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            'Especificar quantos níveis de subdiretórios utilizar quando criar arquivos de cache. Isso deve prevenir que muitos arquivos de cache fiquem em um diretório.',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            'Especificar o canal a ser utilizado para buscar atualizações OTRS Business Solution™. Atenção: Lançamentos de desenvolvimento podem não estar completos e seu sistema pode apresentar erros irrecuperáveis e, em casos extremos, pode se tornar não responsivo!',
        'Specify the password to authenticate for the first mirror database.' =>
            'Especificar a senha para autenticar o primeiro banco de dados espelhado.',
        'Specify the username to authenticate for the first mirror database.' =>
            'Especificar o nome de usuário para autenticar o primeiro banco de dados espelhado.',
        'Spell checker.' => '',
        'Stable' => 'Estável',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Define as permissões padrão disponíveis para atendentes dentro da aplicação. Se mais permissões são necessárias, elas podem ser adicionadas aqui. Permissões devem ser definidas para serem efetivas. Algumas outras permissões úteis foram definidas internamente: nota, fechar, lembrete de pendente, cliente, campos livres, mover, compor chamado, responsável, encaminhar e devolver. Assegure-se que a permissão "rw" é a última permissão registrada.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Número de início para contabilização de estatísticas. Cada nova estatística incrementa este número.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Inicia uma pequisa curinga do objeto ativo após a máscara de objeto de associção ter sido iniciada.',
        'Stat#' => 'Estatística Nº:.',
        'Status view' => 'Visão de Estados',
        'Stores cookies after the browser has been closed.' => 'Armazena os cookies após o navegador ser fechado.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Elimina linhas vazias na visão prévia de ticket da visão de fila.',
        'Strips empty lines on the ticket preview in the service view.' =>
            'Elimina linhas vazias na visão prévia de ticket da visão de serviço.',
        'Support Agent' => '',
        'Swahili' => 'Swahili',
        'Swedish' => 'Sueco',
        'System Address Display Name' => 'Nome de Exibição do Endereço de Sistema',
        'System Maintenance' => 'Manutenção do Sistema',
        'System Request (%s).' => 'Requisição de sistema (%s).',
        'Target' => 'Alvo',
        'Templates <-> Queues' => 'Modelos <-> Filas',
        'Textarea' => 'Área de texto',
        'Thai' => 'Thailandês',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'O Nome Interno do skin de agente que deve ser utilizado na interface de agente. Por favor verificar os skins disponíveis em Frontend::Agent::Skins.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The daemon registration for the scheduler cron task manager.' =>
            'O registro de daemon para o gerenciador de atividades cron.',
        'The daemon registration for the scheduler future task manager.' =>
            'O registro de daemon para o gerenciamento de tarefas futuramente agendadas.',
        'The daemon registration for the scheduler generic agent task manager.' =>
            'O registro de daemon para o gerenciador de agendamento de tarefa de agente genérico.',
        'The daemon registration for the scheduler task worker.' => 'O registo do Daemon do agendador de tarefas.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'O divisor entre TicketHook e o número do chamado. Ex. \': \'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'A duração em minutos após emitir um evento em que a nova nota de escalonamento e eventos de início são suprimidos.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            'O formato do assunto. \'Left\' significa \'[TicketHook#:12345] Algum Assunto\', \'Right\' significa \'Algum Assunto [TicketHook#:12345]\', \'None\' significa \'Algum Assunto\' sem o número do ticket. No último caso, você deve verificar se a definição PostMaster::CheckFollowUpModule###0200-References está ativa para reconhecer respostas baseadas em cabeçalhos de e-mail.',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'O identificador de um chamado, ex. Ticket#, Chamado#, MeuTicket# O padrão é Ticket#.',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            'O logotipo exibido no cabeçalho da interface de agente da skin "padrão" Veja "AgentLogo" para mais descrições.',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            'O logotipo exibido no cabeçalho da interface de agente da skin "Fina" Veja "AgentLogo" para mais descrições.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'O logotipo exibido no cabeçalho da interface de agente. A URL da imagem pode ser uma URL relativa ao diretório de imagem de skin ou uma URL completa a um servidor web remoto.',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'O número máximo de artigos expandidos em uma única página em AgentTicketZoom.',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            'O número máximo de artigos exibidos em uma única página em AgentTicketZoom.',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            'O número máximo de e-mails capturados por vez antes de reconectar com o servidor.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'O texto no começo do assunto de uma resposta de e-mail, por exemplo, RE, AW, ou AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'O texto no começo de um assunto quando um e-mail é encaminhado. Exemplo: FW, Fwd, ou Enc.',
        'The value of the From field' => '',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            '',
        'This is a description for TimeZone on Customer side.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This module is part of the admin area of OTRS.' => 'Este modulo é parte da área administrativa do OTRS.',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'Essa opção define o campo dinâmico em que o ID de Entidade da Atividade de Gerenciamento de Processos é armazenado.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'Essa opção define o campo dinâmico em que o ID de Entidade de Processo de Gerenciamento de Processos é armazenado.',
        'This option defines the process tickets default lock.' => 'Essa opção define o bloqueio padrão para chamados de processo',
        'This option defines the process tickets default priority.' => 'Essa opção define a prioridade padrão para chamados de processo',
        'This option defines the process tickets default queue.' => 'Essa opção define a fila padrão para chamados de processo',
        'This option defines the process tickets default state.' => 'Essa opção define o estado padrão para chamados de processo',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            'Esta opção negará acesso à tickets da mesma empresa cliente, que não são criados pelo usuário cliente.',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            'Essa definição permite que você sobrescreva a lista padrão de países por sua própria lista de países. Isso é particularmente útil quando você quer utilizar um grupo pequeno de países.',
        'This will allow the system to send text messages via SMS.' => 'Isso permitirá que o sistema envie mensagens de texto via SMS.',
        'Ticket Close.' => 'Chamado fechado',
        'Ticket Compose Bounce Email.' => 'Compor chamado de devolução de E-mail',
        'Ticket Compose email Answer.' => 'Ticket Compor e-mail de Resposta.',
        'Ticket Customer.' => 'Chamados Clientes',
        'Ticket Forward Email.' => 'E-mail de Encaminhamento de Ticket.',
        'Ticket FreeText.' => 'Chamado FreeText.',
        'Ticket History.' => 'Mostrar Histórico.',
        'Ticket Lock.' => 'Chamado bloqueado',
        'Ticket Merge.' => 'Agrupar Chamado',
        'Ticket Move.' => 'Movimentar Chamado.',
        'Ticket Note.' => 'Nota do chamado.',
        'Ticket Notifications' => 'Notificações de Chamados',
        'Ticket Outbound Email.' => 'E-mail de saída do Chamado.',
        'Ticket Owner.' => 'Proprietário do chamado.',
        'Ticket Pending.' => 'Chamado pendente.',
        'Ticket Print.' => 'Impressão do chamado.',
        'Ticket Priority.' => 'Prioridade do chamado',
        'Ticket Queue Overview' => 'Visão Geral de Fila de Chamado',
        'Ticket Responsible.' => 'Responsável pelo chamado.',
        'Ticket Watcher' => 'Monitorador do Chamado',
        'Ticket Zoom' => 'Zoom do chamado',
        'Ticket Zoom.' => 'Zoom do chamado',
        'Ticket bulk module.' => 'Módulo de chamados em massa',
        'Ticket event module that triggers the escalation stop events.' =>
            'Módulo de evento de ticket que aciona os eventos de parada de escalonamento.',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'Chamado foi movido para a Fila "%s" (%s) vindo da Fila "%s" (%s).',
        'Ticket notifications' => 'Notificações de chamados',
        'Ticket overview' => 'Visão Geral de Chamados',
        'Ticket plain view of an email.' => 'Visualizar texto plano como um e-mail',
        'Ticket title' => 'Título do chamado.',
        'Ticket zoom view.' => 'Detalhes do chamado.',
        'TicketNumber' => 'Número Chamado',
        'Tickets.' => 'Chamados.',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Tempo em segundos que é adicionado ao tempo atual ao definir um estado pendente (default: 86400 = 1 day).',
        'Title updated: Old: "%s", New: "%s"' => 'Título alterado: Ant.: "%s", Novo: "%s".',
        'To accept login information, such as an EULA or license.' => 'Aceitar informações de login, como um EULA ou licença.',
        'To download attachments.' => 'Para baixar anexos.',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Alterna a exibição da lista OTRS FeatureAddons no PackageManager.',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Item da barra de navegação para um atalho. Controle de acesso adicional para mostrar este link ou não pode ser feito ao utilizar Chave "Group" e Conteúdo como "rw:group1;move_into:group2".',
        'Transport selection for ticket notifications.' => 'Transportar seleção de notificação de chamados.',
        'Tree view' => 'Visão de árvore',
        'Triggers ticket escalation events and notification events for escalation.' =>
            'Aciona eventos de escalonamento de ticket e eventos de notificação para escalonamento.',
        'Turkish' => 'Turco',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            'Desliga validação de certificado SSL, por exemplo, quando você utiliza um proxy HTTPS transparente. Use ao seu próprio risco!',
        'Turns on drag and drop for the main navigation.' => 'Habilita "arrasta e solta" na navegação principal.',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Ukrainian' => 'Ucraniano',
        'Unlock tickets that are past their unlock timeout.' => 'Desbloqueie os tickets que estão além do tempo limite de desbloqueio.',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'Desbloqueia chamados sempre que uma nota for adicionada e o proprietário estiver fora do escritório.',
        'Unlocked ticket.' => 'Chamado desbloqueado.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Atualize o chamado sinalizado como "Visto" se todos os artigo foram vistos ou um novo artigo foi criado.',
        'Updated SLA to %s (ID=%s).' => 'SLA atualizado para %s (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Serviço atualizado para %s (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'Tipo atualizado para %s (ID=%s).',
        'Updated: %s' => 'Atualizado: %s.',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Atualizado: %s=%s;%s=%s;%s=%s;.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Atualiza o índice da escalação de chamado depois que um atributo do chamado foi atualizado.',
        'Updates the ticket index accelerator.' => 'Atualizar o indexador Acelerador de Chamados.',
        'Upload your PGP key.' => 'Envie a sua chave PGP.',
        'Upload your S/MIME certificate.' => 'Envie o seu certificado S/MME.',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            'Usa novos tipos de campos de seleção e com autocompletar na interface de agente (atendente) quando aplicável (InputFields).',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            'Usa novos tipos de campos de seleção e com autocompletar na interface de cliente quando aplicável (InputFields).',
        'UserFirstname' => 'PrimeiroNome',
        'UserLastname' => 'ÚltimoNome',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            'Usa destinatários Cc na lista de resposta Cc ao compor uma resposta de email na tela de composição de chamado da interface de agente.',
        'Uses richtext for viewing and editing ticket notification.' => 'Usar richtext para visualizar e editar notificações de chamados.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'Usar texto rico quando visualizar e editar: artigos, saudações, assinaturas, modelos, auto respostas e notificações.',
        'Vietnam' => 'Vietnamita',
        'View performance benchmark results.' => 'Ver resultados da avaliação de desempenho.',
        'Watch this ticket' => 'Monitorar esse chamado',
        'Watched Tickets.' => 'Chamados Monitorados.',
        'We are performing scheduled maintenance.' => 'Estamos realizando uma manutenção programada. ',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'Estamos realizando uma manutenção programada. O login está temporariamente indisponível.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'Estamos realizando uma manutenção programada. Estaremos de volta em breve.',
        'Web View' => 'Visualização Web',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Quando chamados são mesclados, uma nota será adicionada automaticamente no chamado que não estará mais ativo. Aqui você pode definir a Artigo dessa nota ( Esse Artigo não pode ser alterada pelo Atendente ).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'Quando chamados são mesclados, uma nota será adicionada automaticamente no chamado que não estará mais ativo. Aqui você pode definir o Assunto dessa nota ( Esse Assunto não pode ser alterado pelo Atendente ).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Quando os chamados são agrupados o cliente pode ser informado por e-mail marcando a checkbox "Informar ao Remetente". Nesta área de texto você pode definir um texto pré-formatado que pode ser posteriormente modificado pelos atendentes.',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            'Se coleta ou não meta informações de artigos utilizando filtros configurados em Ticket::Frontend::ZoomCollectMetaFilters.',
        'Yes, but hide archived tickets' => 'Sim, mas oculte chamados arquivados',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            'Seu e-mail com o número de chamado "<OTRS_TICKET>" foi devolvido para "<OTRS_BOUNCE_TO>". Contate esse endereço para informações adicionais.',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            'Sua seleção de fila favoritas. Você também é notificado sobre essas filas por e-mail se ativado.',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            'Sua seleção de serviços favoritos. Você também é notificado sobre esses serviços via e-mail se ativado.',
        'attachment' => 'anexo',
        'bounce' => 'devolver',
        'compose' => 'elaborar',
        'debug' => 'debug',
        'error' => 'erro',
        'forward' => 'encaminhar',
        'info' => 'informação',
        'inline' => 'inline',
        'notice' => 'aviso',
        'pending' => 'pendente',
        'responsible' => 'responsável',
        'stats' => 'status',

    };
    # $$STOP$$
    return;
}

1;
