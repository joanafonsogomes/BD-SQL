USE testesclinicos;
SET GLOBAL log_bin_trust_function_creators = 1;

### QUERIE 1: Calcula a idade a partir da data de nascimento
DELIMITER //
DROP FUNCTION IF EXISTS idade //

CREATE FUNCTION idade(dta date) RETURNS INT
BEGIN
RETURN TIMESTAMPDIFF(YEAR, dta, CURDATE());
END //
DELIMITER ;

#-------------------

### QUERIE 2: Média das idades dos atletas
SELECT avg(idade(a.data_nascimento))
FROM atleta a;

#-------------------

### QUERIE 3: Média das idades dos funcionarios
SELECT avg(idade(f.data_nascimento))
FROM funcionario f;
