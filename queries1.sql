USE testesclinicos;

SELECT * FROM atleta;
SELECT * FROM exame;
SELECT designacao FROM modalidade;

### QUERIE 1: Apresenta os atletas que competem em determinada modalidade
DELIMITER //
DROP PROCEDURE IF EXISTS atletasModalidade //
CREATE PROCEDURE atletasModalidade(modalidade_nome VARCHAR(75)) 
BEGIN
SELECT a.idAtleta AS 'ID Atleta', a.nome AS 'nome'
FROM modalidade m INNER JOIN atleta a ON m.designacao=modalidade_nome and a.idModalidade = m.idModalidade;
END //
DELIMITER ;

#CALL atletasModalidade('Maratona');

#-------------------

### QUERIE 2: Apresenta os atletas de uma dada modalidade que medem mais que x cm
DELIMITER //
DROP PROCEDURE IF EXISTS atletasAltura //
CREATE PROCEDURE atletasAltura(modalidade VARCHAR(75), altura INT) 
BEGIN
SELECT a.idAtleta AS 'ID atleta', a.nome AS 'Nome', a.altura AS 'Altura'
FROM atleta a INNER JOIN modalidade m ON a.idModalidade = m.idModalidade and m.designacao = modalidade and a.altura > altura
ORDER BY a.altura DESC;
END //
DELIMITER ;

#CALL atletasAltura('Maratona',180);

#-------------------

### QUERIE 3: Apresenta os atletas ordenados por peso (crescente)
SELECT idAtleta AS 'ID atleta', nome AS 'Nome', peso AS 'Peso'
FROM atleta
ORDER BY peso;

#-------------------

### QUERIE 4: Ordena os atletas por localidades
SELECT idAtleta AS 'ID atleta', nome AS 'Nome', localidade AS 'Localidade'
FROM atleta
ORDER BY localidade;

