USE testesclinicos;
SET GLOBAL log_bin_trust_function_creators = 1;

### QUERIE 1: Apresenta todos exames por data
SELECT  e.idAtleta AS 'ID Atleta', a.nome AS 'Nome Atleta', e.idFuncionario AS 'ID Funcionário', f.nome AS 'Nome Funcionario', e.data_hora AS 'Data e hora'
FROM exame e, funcionario f, atleta a
WHERE e.idAtleta = a.idAtleta and e.idFuncionario = f.idFuncionario
ORDER BY data_hora;

#-------------------

### QUERIE 2: Apresenta o preço de cada tipo de exame (ordem decrescente)
SELECT DISTINCT e.designacao AS 'Tipo de Exame', e.preco AS 'Preço'
FROM exame e
ORDER BY e.preco DESC;

#-------------------

### QUERIE 3: Apresenta o número de exames que cada atleta fez
SELECT a.idAtleta AS 'ID Atleta', a.nome AS 'Nome', count(e.idExame) AS 'Nr de exames'
FROM exame e INNER JOIN atleta a ON e.idAtleta = a.idAtleta
GROUP BY a.idAtleta
ORDER BY a.nome;

#-------------------

### QUERIE 4: Apresenta os exames que um determinado atleta fez
DELIMITER //
DROP PROCEDURE IF EXISTS examesAtleta //
CREATE PROCEDURE examesAtleta(id INT) 
BEGIN
SELECT a.idAtleta AS 'ID atleta', a.nome AS 'Nome', e.idExame AS 'ID Exame', e.designacao AS 'Tipo de Exame', f.nome AS 'Funcionário que realizou o exame'
FROM exame e , atleta a , funcionario f
WHERE e.idAtleta = id and a.idAtleta = id and e.idFuncionario = f.idFuncionario;
END //
DELIMITER ;

#CALL examesAtleta(849);

#-------------------

### QUERIE 5: Apresenta os atletas que fizeram um determinado tipo de exame:
DELIMITER //
DROP PROCEDURE IF EXISTS atletasTipoExame //
CREATE PROCEDURE atletasTipoExame(tipo_exame VARCHAR(75)) 
BEGIN
SELECT DISTINCT a.idAtleta AS 'ID atleta', a.nome AS 'Nome'
FROM exame e INNER JOIN atleta a ON e.designacao=tipo_exame and e.idAtleta = a.idAtleta
ORDER BY a.nome;
END //
DELIMITER ;

#CALL atletasTipoExame('Fisioterapia');

#-------------------

### QUERIE 6: Todos os exames em que se usaram equipamentos e respetivos equipamentos usados

SELECT e.idExame AS 'ID Exame', e.designacao AS 'Tipo Exame', a.nome AS 'Atleta', f.nome AS 'Funcionário', t.designacao as 'Equipamento Usado'
FROM exame e
INNER JOIN equipamento t
ON t.idEquipamento = e.idEquipamento
INNER JOIN atleta a 
ON a.idAtleta = e.idAtleta
INNER JOIN funcionario f
ON f.idFuncionario = e.idFuncionario
WHERE e.idEquipamento != 'NULL';

#-------------------

### QUERIE 7: Apresenta todos os atletas reprovados em exames e o nome dos exames a que reprovou
SELECT a.idAtleta AS 'ID atleta', a.nome AS 'Nome do Atleta', e.idExame AS 'ID exame', e.designacao AS 'Tipo de exame'
FROM atleta a INNER JOIN exame e  ON e.idAtleta = a.idAtleta AND e.resultado = 'reprovado'
ORDER BY a.idAtleta;

#-------------------

### QUERIE 8: Verifica se um determinado atleta reprovou a algum exame (e, se reprovou, mostra quais exames)
DELIMITER //
DROP PROCEDURE IF EXISTS atletaRep //
CREATE PROCEDURE atletaRep(idA INT ) 
BEGIN
DECLARE est VARCHAR(75);
DECLARE myCount INT;

SET myCount =
	(SELECT COUNT(*) AS myCount
	FROM EXAME e, ATLETA a
	WHERE e.resultado = 'reprovado' and e.idAtleta = a.idAtleta and a.idAtleta = idA);
    
IF (myCount>0) THEN
   SET est = 'reprovou';
   SELECT a.idAtleta as 'ID Atleta', a.nome AS 'nome', e.designacao AS 'Tipo de Exame', est AS ' '
	FROM EXAME e, ATLETA a
	WHERE e.idAtleta = idA and e.idAtleta = a.idAtleta and e.resultado='reprovado';
ELSE
  SET est = 'Este atleta foi aprovado a todos os testes.';
  SELECT est AS ' ';
END IF;

END //
DELIMITER ;

#CALL atletaRep(376);
#CALL atletaRep(216);

#-------------------

### QUERIE 9: Apresenta o preço do exame mais caro que cada atleta fez
SELECT a.idAtleta AS 'ID Atleta', a.nome AS 'Nome', max(e.preco) AS 'Preço exame mais caro', e.designacao AS 'Tipo de exame'
FROM atleta a 
INNER JOIN exame e  ON e.idAtleta = a.idAtleta
GROUP BY a.nome
ORDER BY a.idAtleta;

#-------------------

### QUERIE 10: Apresenta o preço do exame mais caro que o atleta com determinado ID fez
DELIMITER //
DROP PROCEDURE IF EXISTS exameMaisCaro //
CREATE PROCEDURE exameMaisCaro(id INT) 
BEGIN
SELECT a.idAtleta AS 'ID Atleta', a.nome AS 'Nome', max(e.preco) AS 'Preço exame mais caro', e.designacao AS 'Tipo de Exame'
FROM atleta a  INNER JOIN exame e  ON e.idAtleta = a.idAtleta and a.IdAtleta = id;
END //
DELIMITER ;

#CALL exameMaisCaro(216);

#-------------------
### QUERIE 11: Apresenta os exames que um determinado funcionário realizou
DELIMITER //
DROP PROCEDURE IF EXISTS examesFuncionario //
CREATE PROCEDURE examesFuncionario(idF INT) 
BEGIN
SELECT e.data_hora AS 'Data', a.nome AS 'Nome atleta', a.idAtleta AS 'ID Atleta', e.designacao AS 'Tipo de exame'
FROM exame e, funcionario f, atleta a  
WHERE  e.idFuncionario = f.idFuncionario and f.idFuncionario = idF and e.idAtleta = a.idAtleta and e.estado = 'R'
ORDER BY e.data_hora;
END //
DELIMITER ;

#CALL examesFuncionario(5);

#-------------------

### QUERIE 12: Marcar um exame
DELIMITER //
DROP PROCEDURE IF EXISTS marcar_exame //
CREATE PROCEDURE marcar_exame (IN designa VARCHAR(75), IN atleta INT, IN data_ DATETIME)
START TRANSACTION;
BEGIN
DECLARE price INT;
DECLARE res VARCHAR(75);
DECLARE equip INT;
DECLARE fun INT;
DECLARE id INT;
DECLARE est VARCHAR(75);
IF (EXISTS (SELECT a.nome FROM atleta a INNER JOIN exame e ON e.idAtleta = a.idAtleta WHERE data_ = e.data_hora)) 
		THEN
		SET est = 'Este atleta já tem exame marcado para essa hora.';
		SELECT est AS ' ';
ELSEIF (data_ < NOW()) 
		THEN
		SET est = 'Tentou marcar exame para uma data ultrapassada.';
		SELECT est AS ' ';  
ELSE
	SELECT distinct e.preco INTO price FROM exame e where e.designacao = designa;
	SELECT distinct resultado INTO res FROM exame ORDER BY RAND() limit 1;
	SELECT distinct e.idEquipamento INTO equip FROM exame e where e.designacao = designa;
	SELECT distinct f.idFuncionario INTO fun 
		FROM funcionario f WHERE f.idFuncionario 
		NOT IN (SELECT idFuncionario FROM exame WHERE data_hora= data_)
		ORDER BY RAND() limit 1;
	SELECT idExame INTO id FROM exame ORDER BY idExame DESC limit 1;
	SET id = id + 1;
	INSERT INTO testesclinicos.exame (idExame,designacao,idAtleta,idFuncionario,data_hora,preco,resultado,idEquipamento,estado)
	VALUES (id, designa, atleta, fun, data_, price, res, equip,'A');
END IF
END //
COMMIT;
DELIMITER ;


#-------------------

### QUERIE 13: Desmarcar exames caso se saiba o id do exame

DELIMITER //
DROP PROCEDURE IF EXISTS desmarcar_exame //
CREATE PROCEDURE desmarcar_exame(IN id INT)
START TRANSACTION;
BEGIN 
DECLARE est VARCHAR(75);
IF (id NOT IN (SELECT idExame FROM exame)) THEN
		SET est = 'O exame que quer desmarcar não está no sistema.';
		SELECT est AS ' ';
ELSE
	DELETE FROM exame e WHERE e.idExame = id;
END IF;
END //
COMMIT;
DELIMITER ;

#CALL desmarcar_exame (31);

#-------------------

### QUERIE 14: Desmarcar exames (com o ID do atleta e a hora do exame)
DELIMITER //
DROP PROCEDURE IF EXISTS desmarcar_exame2 //
CREATE PROCEDURE desmarcar_exame2 (IN atleta INT, IN data_ DATETIME)
START TRANSACTION;
BEGIN 
DECLARE est VARCHAR(75);
IF (atleta NOT IN (SELECT idAtleta FROM exame WHERE data_hora = data_)) THEN
		SET est = 'O exame que quer desmarcar não está no sistema.';
		SELECT est AS ' ';
ELSE
	DELETE FROM exame e WHERE e.idAtleta = atleta AND data_hora = data_;
END IF;
END //
COMMIT;
DELIMITER ;

#CALL desmarcar_exame2(87, '2019:12:29 15:20:00');