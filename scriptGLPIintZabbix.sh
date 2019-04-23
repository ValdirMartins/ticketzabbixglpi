#!/bin/bash

# VALDIR MARTINS DA SILVA JUNIOR
# GOIANIA - GO
# DATA: 23/04/2019

## CONEXAO GLPI
ipdb_glpi="255.255.255.255"		## IP DO BANCO DO GLPI
user_glpi="userdb"				## USUARIO DO BANCO COM PERMISSAO DE ACESSO AO DB GLPI
pass_glpi="senhadb"				## SENHA DO USUARIO CITADO ACIMA
db_glpi="namedb"				## DATABASE GLPI

entidade_glpi="2" 				## ID DA ENTIDADE
requerente_criador_glpi="11537"	## ID DO REQUERENTE CRIADOR DO CHAMADO
status_os_glpi="1" 				## ID DO STATUS DO CHAMADO: NOVO = COD: 01
origem_requisicao_glpi="8" 		## ID DA ORIGEM DE REQUISIÇÃO: ZABBIX
categoria_os_glpi="174" 		## ID DA CATEGORIA DO CHAMADO: ZABBIX
tipo_os_glpi="1"				## ID DO TIPO: INCIDENTE = COD: 01
nivel_impacto_os="4"			## ID DO IMPACTO: ALTO =  COD: 04
nivel_prioridade_os="4"			## ID DA PRIORIDADE: ALTO = COD: 04
localizacao_os_glpi="1108"		## ID DO LOCALIZACAO OU DEPARTAMENTO 

## PARAMETRO AJUDA
if [ $# -lt 1 ]; then
   	echo ''
	echo "Comando: $0"
	echo ''
	echo "Manual: $0 -c"
	echo '	{HOSTNAME}'
	echo '	DOWN - Entrada Estatica'
	echo '	{TRIGGER.STATUS}'
	echo '	{TRIGGER.NAME}'
	echo '	{TRIGGER.ID}'
	echo '	{EVENT.ID}'
	echo '	{HOST.IP}'
	echo ''
	echo 'OBSERVACOES:'
	echo ''
	echo 'Deve-se usar aspas duplas para passar os parametros.'
	echo 'Não é necessario usar o nome do parametro.'
	echo ''
   exit 1
fi


if [ "$1" != "-c" ]
then
	echo ''
	echo "Para detalhes de parametros, digite apenas o comando sem parametros. '-c'"
	echo "Faltou o parametro '-c'"
	echo ''
	else
	if [ -z "$2" ]
	then
		echo ''
		echo "Faltou o parametro 'hostname'"
		echo ''
		else
		if [ -z "$3" ]
		then
			echo ''
			echo "Faltou o parametro 'estado'"
			echo ''
			else
			if [ -z "$4" ]
			then
				echo ''
				echo "Faltou o parametro 'situação'"
				echo ''
						else
						if [ -z "$5" ]
						then
							echo ''
							echo "Faltou o parametro 'aplicacao/serviço'"
							echo ''
							else
							if [ -z "$6" ]
							then
								echo ''
								echo "Faltou o parametro 'trigger id zabbix'"
								echo ''
								else
								if [ -z "$7" ]
								then
								echo ''
								echo "Faltou o parametro 'event id zabbix'"
								echo ''
								else
									if [ -z "$8" ]
									then
									echo ''
									echo "Faltou o parametro 'IP do host'"
									echo ''
									else
								
TITULO_OS="Auto-Chamado Zabbix para o Hostname: $2 Aplicação/Serviço: $5"
CORPO_OS="Detalhes abaixo:

Hostname: $2
IP: $8
Status: $3
Situação: $4
Aplicação/Serviço: $5
Trigger ID: $6
Event ID: $7"
								
								## ABRINDO CHAMADO
								mysql -h "$ipdb_glpi" -u "$user_glpi" -p"$pass_glpi" -e"use $db_glpi; INSERT INTO glpi_tickets (entities_id, name, date, date_mod, users_id_lastupdater, status, users_id_recipient, requesttypes_id, content, itilcategories_id, locations_id, date_creation, type, impact, priority) values ('$entidade_glpi', '$TITULO_OS', now(), now(), '$requerente_criador_glpi', '$status_os_glpi', '$requerente_criador_glpi', '$origem_requisicao_glpi', '$CORPO_OS', '$categoria_os_glpi', '$localizacao_os_glpi', now(), '$tipo_os_glpi', '$nivel_impacto_os', '$nivel_prioridade_os')"
								
								
								## RELACIONADO O CHAMADO AO REQUERENTE ZABBIX
								mysql -h "$ipdb_glpi" -u "$user_glpi" -p"$pass_glpi" -e"use $db_glpi; insert into glpi_tickets_users (tickets_id,users_id,type,use_notification,alternative_email) VALUES ((select max(id) from glpi_tickets where entities_id='$entidade_glpi'), '$requerente_criador_glpi', 1, 1, NULL)"
								
							fi
						fi
					fi
				fi
			fi
		fi
	fi
fi
