USE testesclinicos;
SET SQL_SAFE_UPDATES = 0;

### QUERIE 1: Apresenta todas as consultas por data
SELECT c.idAtleta AS 'ID Atleta', a.nome AS 'Nome Atleta', c.idFuncionario AS 'ID Funcionário', f.nome AS 'Nome Médico', e.designacao AS 'Especialidade' , c.data_hora AS 'Data e hora'
FROM consulta c, funcionario f, atleta a, especialidade e
WHERE c.idAtleta = a.idAtleta and c.idFuncionario = f.idFuncionario and f.idEspecialidade = e.idEspecialidade
ORDER BY data_hora;

#-------------------

### QUERIE 2: Apresenta todas as consultas que já foram realizadas
SELECT c.idAtleta AS 'ID Atleta', a.nome AS 'Nome Atleta', c.idFuncionario AS 'ID Funcionário', f.nome AS 'Nome Médico', e.designacao AS 'Especialidade' , c.data_hora AS 'Data e hora'
FROM consulta c, funcionario f, atleta a, especialidade e
WHERE c.idAtleta = a.idAtleta and c.idFuncionario = f.idFuncionario and f.idEspecialidade = e.idEspecialidade and c.estado='R'
ORDER BY data_hora;

#-------------------

### QUERIE 3: Apresenta todas as consultas agendadas
SELECT c.idAtleta AS 'ID Atleta', a.nome AS 'Nome Atleta', c.idFuncionario AS 'ID Funcionário', f.nome AS 'Nome Médico', e.designacao AS 'Especialidade',
 c.data_hora AS 'Data e hora'
FROM consulta c, funcionario f, atleta a, especialidade e
WHERE c.idAtleta = a.idAtleta and c.idFuncionario = f.idFuncionario and f.idEspecialidade = e.idEspecialidade and c.estado = 'A'
ORDER BY data_hora;

#-------------------

### QUERIE 4: Apresenta todas as consultas de um determinado atleta
DELIMITER //
DROP PROCEDURE IF EXISTS consultasAtleta //
CREATE PROCEDURE consultasAtleta(id INT) 
BEGIN
SELECT c.idAtleta AS 'ID Atleta', a.nome AS 'Nome Atleta', c.idFuncionario AS 'ID Funcionário', f.nome AS 'Nome Médico', e.designacao AS 'Especialidade', 
c.data_hora AS 'Data e hora', c.estado AS 'Estado' 
FROM consulta c, funcionario f, atleta a, especialidade e
WHERE c.idAtleta = a.idAtleta and c.idFuncionario = f.idFuncionario and f.idEspecialidade = e.idEspecialidade and c.idAtleta = id 
ORDER BY data_hora;
END //
DELIMITER ;

#CALL consultasAtleta(367);

#-------------------

### QUERIE 5: Apresenta o número de consultas efetuadas por cada médico
SELECT f.nome AS 'Nome Médico', c.idFuncionario AS 'ID Médico', COUNT(*) AS 'Nr Consultas'
FROM funcionario f INNER JOIN consulta c  ON c.idFuncionario = f.idFuncionario
WHERE c.estado = 'R'
GROUP BY c.idFuncionario
ORDER BY COUNT(*) DESC;

#-------------------

### QUERIE 6: Quantas consultas de uma especialidade dada (o ID) foram realizadas 
DELIMITER //
DROP FUNCTION IF EXISTS consultasRealizadasEsp //
CREATE FUNCTION consultasRealizadasEsp(idE INT(10)) RETURNS INT(10)
BEGIN
DECLARE counter INT;
SELECT COUNT(*) INTO counter FROM consulta c, funcionario f where c.idFuncionario=f.idFuncionario and f.idEspecialidade = idE and c.estado='R';
RETURN counter;
END //
DELIMITER ;

#SELECT consultasRealizadasEsp(4) AS 'Nr de consultas realizadas';

#-------------------

### QUERIE 7: Apresenta os médicos que deram mais consultas
SELECT f.nome AS 'Nome Médico', c.idFuncionario AS 'ID Médico', e.designacao AS 'Especialidade', COUNT(*) AS 'Nr Consultas'
FROM funcionario f, consulta c, especialidade e
WHERE f.idFuncionario = c.idFuncionario AND f.idEspecialidade = e.idEspecialidade AND c.estado = 'R'
GROUP BY f.idFuncionario
ORDER BY COUNT(*) DESC
LIMIT 3;

#-------------------

### QUERIE 8: Marcar uma consulta
DELIMITER //
DROP PROCEDURE IF EXISTS marcar_consulta //
CREATE PROCEDURE marcar_consulta (IN idatleta INT, IN data_ DATETIME, IN special VARCHAR(75))
START TRANSACTION;
BEGIN
DECLARE price INT;
DECLARE fun INT;
DECLARE est VARCHAR (75);
IF (EXISTS (SELECT a.nome FROM atleta a INNER JOIN consulta c ON c.idAtleta = a.idAtleta WHERE data_ = c.data_hora)) 
		THEN
		SET est = 'Este atleta já tem consulta marcada para este horário.';
		SELECT est AS ' ';  
ELSEIF (data_ < NOW()) 
		THEN
		SET est = 'Tentou marcar a consulta para uma data ultrapassada.';
		SELECT est AS ' ';  
ELSE 
	SELECT distinct f.idFuncionario INTO fun 
		FROM funcionario f INNER JOIN especialidade e ON e.idEspecialidade = f.idEspecialidade 
        WHERE e.designacao = special AND f.idFuncionario 
		NOT IN (SELECT idFuncionario FROM consulta WHERE data_hora= data_)
		ORDER BY RAND() limit 1;
	INSERT INTO testesclinicos.consulta (idFuncionario,idAtleta,data_hora,estado)
	VALUES (fun, idatleta,data_,'A');
END IF;  
END //
COMMIT;
DELIMITER ;

#CALL marcar_consulta(834,'2010-01-03 12:20','Medicina Desportiva');
#CALL marcar_consulta(743,'2020-02-20 12:20','Medicina Desportiva');

#-------------------

### QUERIE 9: Desmarcar uma consulta
DELIMITER //
DROP PROCEDURE IF EXISTS desmarcar_consulta //
CREATE PROCEDURE desmarcar_consulta (IN idatleta INT, IN data_ DATETIME)
START TRANSACTION;
BEGIN
DECLARE est VARCHAR (75);
IF (idatleta NOT IN (
	SELECT idAtleta 
    FROM consulta c
    WHERE c.data_hora = data_)
    OR
    data_ NOT IN (
	SELECT data_hora
    FROM consulta c
    WHERE c.idAtleta = idatleta)
    ) THEN
		SET est = 'A consulta que quer desmarcar não se encontra no sistema.';
		SELECT est AS ' ';
ELSEIF (SELECT idAtleta
		FROM consulta c
		WHERE c.data_hora = data_ AND c.estado = 'R'
    ) THEN
		SET est = 'A consulta que selecionou para desmarcar já foi realizada.';
		SELECT est AS ' ';
ELSE 
	DELETE FROM consulta c WHERE c.idAtleta = idatleta AND c.data_hora = data_;
END IF;
END //
COMMIT;
DELIMITER ;

#-------------------

### QUERIE 10: Atualizar preço de uma especialidade
DELIMITER //
DROP PROCEDURE IF EXISTS atualizarPrecoEspecialidade //
CREATE PROCEDURE atualizarPrecoEspecialidade(IN idE INT , IN newPrice DECIMAL(6,2))
START TRANSACTION;
BEGIN
UPDATE especialidade e SET e.preco = newPrice WHERE e.idEspecialidade = idE;
END //
COMMIT;
DELIMITER ;

#CALL atualizarPrecoEspecialidade(7,400);

#-------------------

### QUERIE 11: Calcular o total faturado em consultas entre duas datas
DELIMITER //
DROP PROCEDURE IF EXISTS totalBetween //
CREATE PROCEDURE totalBetween(data1 DATE, data2 DATE)
BEGIN
SELECT SUM(e.preco) AS 'Total Faturado'
FROM consulta c, funcionario f, especialidade e
WHERE (c.data_hora between data1 and data2) and c.estado='R' and c.idFuncionario = f.idFuncionario and f.idEspecialidade = e.idEspecialidade;
END //
DELIMITER ;

#CALL totalBetween('2019-06-01','2020-01-01');