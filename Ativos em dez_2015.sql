-- Ativos em dez/2015, out/ 2017, jun/2018 e dez/2020,
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