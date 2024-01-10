/* Código criado com o intuito de extrair os processos da unidade 'GR01CO' que estavam ativos em dezembro de 2015. Foram usadas três condições para ligados à data para funcionar com o modo em que o banco foi criado. 
A 1° condição pega todos os processos que foram iniciados em dezembro de 2015; 
A 2° condição pega todos os processos que foram iniciados antes ou em 1 de dezembro de 2015 e encerrados depois ou em 31 de dezembro de 2015, ou seja, o processo estava ativo durante o período de dezembro de 2015; 
A 3° condição pega todos os processos que foram iniciados antes ou em 1 de dezembro de 2015 e que ainda não foram encerrados, ou seja, mesmo que o processo ainda esteja em andamento ele esteve ativo em dezembro de 2015. 
Desse modo, as 3 condições fazem o código cumprir o objetivo desejado. */
	
USE prod_sei;

SELECT DISTINCT
    a.protocolo_formatado AS processo,
    c.sigla AS unidade
FROM protocolo a
    INNER JOIN atividade b ON a.id_protocolo = b.id_protocolo
    INNER JOIN unidade c ON b.id_unidade = c.id_unidade
WHERE
     c.sigla = 'GR01CO' AND a.sta_protocolo = 'P' AND(
	(YEAR(b.dth_abertura) = 2015 AND MONTH(b.dth_abertura) = 12) OR
     	(DATE(b.dth_abertura) <= '2015.12.01' AND DATE(b.dth_conclusao) >= '2015.12.31') OR
     	(DATE(b.dth_abertura) <= '2015.12.01' AND b.dth_conclusao IS NULL)
     );
