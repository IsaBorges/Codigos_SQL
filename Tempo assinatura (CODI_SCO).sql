/*Extração de informações para montar uma tabela e calcular a média de tempo que um processo fica na unidade 'SCO' após a unidade 'CODI' enviar o
processo para que ele seja assinado e enviado de volta para a unidade 'CODI'*/

SELECT
	tabela.processo,
    tabela.tipologia,
    tabela.unidade_origem,
    tabela.dth_envio,
	tabela.tarefa,
    uni.sigla AS unidade_destino,
    atv.dth_abertura AS dth_assinado,
    tar.nome AS tarefa_destino
FROM
(
	SELECT 
		a.protocolo_formatado AS processo,
		e.nome AS tipologia,
		c.nome AS tarefa,
		f.sigla AS unidade_origem,
		b.dth_abertura AS dth_envio,
		(
			SELECT
				t1.id_atividade
			FROM atividade t1
			WHERE t1.id_protocolo = b.id_protocolo
				  AND ( (t1.id_tarefa = 5 AND t1.id_unidade = 110000913) 
						OR (t1.id_tarefa = 39 AND t1.id_unidade = 110000914) 
                        OR (t1.id_tarefa = 40 AND t1.id_unidade = 110000913)
					  )
				  AND t1.dth_abertura >= b.dth_abertura
				  ORDER BY t1.dth_abertura
				  LIMIT 1
		) AS id_atividade
	FROM protocolo a
	INNER JOIN atividade b ON a.id_protocolo = b.id_protocolo
	INNER JOIN tarefa c ON b.id_tarefa = c.id_tarefa
	INNER JOIN procedimento d ON a.id_protocolo = d.id_procedimento
	INNER JOIN tipo_procedimento e ON d.id_tipo_procedimento = e.id_tipo_procedimento
	INNER JOIN unidade f ON b.id_unidade = f.id_unidade
	INNER JOIN atributo_andamento g ON b.id_atividade = g.id_atividade
	INNER JOIN unidade h ON g.id_origem = h.id_unidade
	WHERE c.id_tarefa = 38
		  AND e.nome LIKE '%PADO%'
		  AND f.sigla = 'CODI'
		  AND g.nome = 'UNIDADE'
		  AND h.sigla = 'SCO'
		  AND YEAR(b.dth_abertura) = 2023
)AS tabela
INNER JOIN atividade atv ON tabela.id_atividade = atv.id_atividade
INNER JOIN tarefa tar ON atv.id_tarefa = tar.id_tarefa
INNER JOIN unidade uni ON atv.id_unidade = uni.id_unidade;
