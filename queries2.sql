USE testesclinicos;
SET SQL_SAFE_UPDATES = 0;
SET GLOBAL log_bin_trust_function_creators = 1;

### QUERIE 1: Calcular o total faturado por um funcionário selecionado (ID)
DELIMITER //
DROP FUNCTION IF EXISTS totalFaturado //
CREATE FUNCTION totalFaturado(idF INT(5)) RETURNS DECIMAL(8,2)
#NOT DETERMINISTIC
BEGIN

DECLARE incomeExames DECIMAL(8,2);
DECLARE incomeConsultas DECIMAL(8,2);
DECLARE totalIncome DECIMAL(8,2);

SELECT sum(e.preco) into incomeExames
FROM exame e
WHERE e.idFuncionario = idF and e.estado = 'R';

SELECT sum(e.preco) into incomeConsultas
FROM especialidade e, funcionario f, consulta c
WHERE c.idFuncionario = idF and f.idFuncionario = c.idFuncionario and f.idEspecialidade = e.idEspecialidade and c.estado = 'R';

SET totalIncome = IFNULL(incomeExames,0) + IFNULL(incomeConsultas,0);

RETURN totalIncome;
END //
DELIMITER ;

#SELECT totalFaturado(3) AS 'Total Faturado';

#-------------------

### QUERIE 2: Apresenta os 3 funcionários que mais faturaram no ano selecionado
DELIMITER //
DROP PROCEDURE IF EXISTS maisFaturaram //
CREATE PROCEDURE maisFaturaram(IN ano YEAR) 
BEGIN
#DECLARE ano YEAR;
#SET ano = YEAR(CURDATE());
	SELECT fun.nome AS 'Nome', fun.idFuncionario AS 'ID', COALESCE(sum.Soma,0) AS 'Total Faturado' FROM
		(SELECT idFuncionario,nome FROM funcionario fun) AS fun
		LEFT JOIN
		(SELECT idFuncionario,SUM(Soma) AS Soma FROM (
			(SELECT c.idFuncionario,SUM(preco) AS Soma FROM consulta c, especialidade e, funcionario f
			 WHERE estado!='R' and c.idFuncionario = f.idEspecialidade and f.idEspecialidade = e.idEspecialidade and DATE_FORMAT(c.data_hora,"%Y")=ano GROUP BY c.idFuncionario
			UNION ALL
			 SELECT idFuncionario,SUM(preco) AS Soma FROM exame e
			 WHERE estado!='R' and DATE_FORMAT(e.data_hora,"%Y")=ano GROUP BY idFuncionario
			ORDER BY idFuncionario)) smt
			GROUP BY idFuncionario) AS sum
		ON fun.idFuncionario=sum.idFuncionario ORDER BY Soma DESC LIMIT 3;
END //
DELIMITER ;

#CALL maisFaturaram(2019);

#-------------------

### QUERIE 3: Acrescentar à tabela funcionario uma coluna para o total faturado por cada funcionario e por lá 
ALTER TABLE testesclinicos.funcionario ADD total_faturado DECIMAL(6,2);

UPDATE funcionario f
SET f.total_faturado = totalFaturado(f.idFuncionario);

#-------------------

### QUERIE 4: Atribuir um bónus mensal aos funcionários (operadores de laboratório) cujos exames são grátis (Anti-Doping)

DELIMITER //
CREATE EVENT IF NOT EXISTS salarioOperadorLab ON SCHEDULE EVERY MONTH
STARTS CURRENT_TIMESTAMP + INTERVAL 1 DAY 
ON COMPLETION PRESERVE
ENABLE 
DO BEGIN
	UPDATE testesclinicos.funcionario
	SET total_faturado = total_faturado + 100
	WHERE idCategoria = 'Operador de Laboratório'
END 
DELIMITER ;

#-------------------

### QUERIE 5: Calcular o total mensal faturado por cada fucionário num determinado mês 
DELIMITER //
DROP PROCEDURE IF EXISTS totalMensal//
CREATE PROCEDURE totalMensal(IN mes DATE) 
BEGIN
	SELECT fun.nome AS 'Nome', fun.idFuncionario AS 'ID', COALESCE(sum.Soma,0) AS 'Total Faturado' FROM
		(SELECT idFuncionario,nome FROM funcionario fun) AS fun
		LEFT JOIN
		(SELECT idFuncionario,SUM(Soma) AS Soma FROM (
			(SELECT c.idFuncionario,SUM(preco) AS Soma FROM consulta c, especialidade e, funcionario f
			 WHERE estado!='R' and c.idFuncionario = f.idEspecialidade and f.idEspecialidade = e.idEspecialidade and DATE_FORMAT(c.data_hora,"%Y")=ano GROUP BY c.idFuncionario
			UNION ALL
			 SELECT idFuncionario,SUM(preco) AS Soma FROM exame e
			 WHERE estado!='R' and DATE_FORMAT(e.data_hora,"%Y")=ano GROUP BY idFuncionario
			ORDER BY idFuncionario)) smt
			GROUP BY idFuncionario) AS sum
		ON fun.idFuncionario=sum.idFuncionario ORDER BY Soma DESC LIMIT 3;
END //
DELIMITER ;