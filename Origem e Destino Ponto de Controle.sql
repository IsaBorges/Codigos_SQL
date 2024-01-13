/*Extração de uma tabela que apresenta a origem e o destino de cada ponto de controle de processos do tipo 'Ressarcimento'. Nesse caso o primeiro 
ponto de controle é a origem principal e o seu destino também é uma origem que tem outro destino e assim em diante até que chege no último ponto de 
controle que é considerado apenas como destino. Por essa razão foram usados sub selects*/

SELECT 
	tabela.processo,
	tabela.tipologia,
	tabela.origem_ponto_controle,
	tabela.dth_origem_pc,
    b.nome AS destino_ponto_controle,
    a.dth_execucao AS dth_destino_pc,
    a.sin_ultimo
FROM (	SELECT 
			t1.protocolo_formatado AS processo,
			t3.nome AS tipologia,
			t5.nome AS origem_ponto_controle,
			t4.dth_execucao AS dth_origem_pc,
			(SELECT a.id_andamento_situacao
			 FROM andamento_situacao a
			 INNER JOIN situacao b ON a.id_situacao = b.id_situacao
			 WHERE a.id_procedimento = t1.id_protocolo
				   AND a.dth_execucao >= t4.dth_execucao
				   AND b.nome <> t5.nome
			 ORDER BY a.dth_execucao
			 LIMIT 1
			) AS id_and_situ
		FROM protocolo t1
		INNER JOIN procedimento t2 ON t1.id_protocolo = t2.id_procedimento
		INNER JOIN tipo_procedimento t3 ON t2.id_tipo_procedimento = t3.id_tipo_procedimento
		INNER JOIN andamento_situacao t4 ON t1.id_protocolo = t4.id_procedimento
		INNER JOIN situacao t5 ON t4.id_situacao = t5.id_situacao
		WHERE t4.sin_ultimo <> 'S' 
			AND t5.nome LIKE 'Ressarcimento%'
		ORDER BY t4.dth_execucao
	) AS tabela
LEFT JOIN andamento_situacao a ON tabela.id_and_situ = a.id_andamento_situacao
LEFT JOIN situacao b ON a.id_situacao = b.id_situacao;
