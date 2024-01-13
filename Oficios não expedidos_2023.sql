/*Extração de processos e documentos associados a esses processos da unidade 'CODI' para mostrar o que foi ou não expedido, tanto digitalmente quanto 
pelos correios, em 2023. O código também mostra os processos que estavam cadastrados ou não no litigioso (sistema da ANATEL)*/

SELECT
	t1.protocolo_formatado AS processo,
    t4.protocolo_formatado AS documento,
    t6.nome AS tipologia_documento,
    t7.sigla AS unidade_geradora,
    CONVERT(t4.dta_geracao, date) AS data_geracao,
    IF(t8.id_protocolo IS NULL, "Não expedido", "Expedido") AS Situacao_documento,
    IF(t9.id_md_lit_controle IS NULL, "Fora do litigioso", "No litigioso") AS Litigioso,
    IF(t11.id_tarefa = 1007, "Expedido pelo Correio", "Não expedido pelo correio") AS Expedição_Correios
FROM protocolo t1
INNER JOIN rel_protocolo_protocolo t2 ON t1.id_protocolo = t2.id_protocolo_1
INNER JOIN procedimento t3 ON t1.id_protocolo = t3.id_procedimento
INNER JOIN protocolo t4 ON t4.id_protocolo = t2.id_protocolo_2
INNER JOIN documento t5 ON t4.id_protocolo = t5.id_documento
INNER JOIN serie t6 ON t5.id_serie = t6.id_serie
INNER JOIN unidade t7 ON t4.id_unidade_geradora = t7.id_unidade
LEFT JOIN md_pet_int_protocolo t8 ON t4.id_protocolo = t8.id_protocolo
LEFT JOIN md_lit_controle t9 ON t1.id_protocolo = t9.id_procedimento
INNER JOIN atividade t10 ON t1.id_protocolo = t10.id_protocolo
INNER JOIN tarefa t11 ON t10.id_tarefa = t11.id_tarefa
WHERE t6.nome LIKE "Ofício" AND t7.sigla = "CODI" AND YEAR(t4.dta_geracao) = 2023 AND t11.id_tarefa NOT IN (1007)
GROUP BY t1.protocolo_formatado, t4.protocolo_formatado, t6.nome, t7.sigla, t4.dta_geracao, Situacao_documento, Litigioso, Expedição_Correios;

