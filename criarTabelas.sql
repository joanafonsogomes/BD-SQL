/*CRIAR TABELAS*/

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS testesclinicos;
USE testesclinicos;
-- -----------------------------------------------------
-- Tabela testesclinicos.atleta
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS testesclinicos.atleta (
  idAtleta INT NOT NULL,
  nome VARCHAR(60) NOT NULL,
  data_nascimento DATE NOT NULL,
  peso DECIMAL (8,2) NOT NULL,
  altura DECIMAL (8,2) NOT NULL,
  sexo VARCHAR(45) NOT NULL,
  localidade VARCHAR(45) NOT NULL,
  idModalidade INT NOT NULL,
  PRIMARY KEY (idAtleta),
  INDEX atleta_modalidade_idx (idModalidade ASC),
  CONSTRAINT fk_atleta_modalidade
    FOREIGN KEY (idModalidade)
    REFERENCES testesclinicos.modalidade (idModalidade)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela testesclinos.modalidade
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS testesclinicos.modalidade (
  idModalidade INT NOT NULL,
  designacao VARCHAR(75) NOT NULL,
  PRIMARY KEY (idModalidade) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela testesclinicos.funcionario
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS testesclinicos.funcionario (
  idFuncionario INT NOT NULL,
  nome VARCHAR(75) NOT NULL,
  data_nascimento DATE NOT NULL,
  idCategoria INT NOT NULL,
  idEspecialidade INT,
  PRIMARY KEY (idFuncionario),
  INDEX fk_funcionario_categoria_idx (idCategoria ASC),
  CONSTRAINT fk_funcionario_categoria
    FOREIGN KEY (idCategoria)
    REFERENCES testesclinicos.categoria (idCategoria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
INDEX fk_funcionario_especialidade_idx (idCategoria ASC),
  CONSTRAINT fk_funcionario_especialidade
    FOREIGN KEY (idEspecialidade)
    REFERENCES testesclinicos.especialidade (idEspecialidade)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela testesclinicos.categoria
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS testesclinicos.categoria (
  idCategoria INT NOT NULL,
  designacao VARCHAR(75) NOT NULL,
  PRIMARY KEY (idCategoria))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela testesclinicos.exame
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS testesclinicos.exame (
  idExame INT NOT NULL,
  designacao VARCHAR(75) NOT NULL,
  idAtleta INT NOT NULL,
  idFuncionario INT NOT NULL,
  data_hora DATETIME NOT NULL,
  preco DECIMAL(6,2),
  resultado VARCHAR(45),
  idEquipamento INT,
  estado VARCHAR(45) NOT NULL,
  PRIMARY KEY (idExame),
  INDEX fk_exame_atleta_idx (idAtleta ASC),
  CONSTRAINT fk_exame_atleta
    FOREIGN KEY (idAtleta)
    REFERENCES testesclinicos.atleta (idAtleta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  INDEX fk_exame_funcionario_idx (idFuncionario ASC),
  CONSTRAINT fk_exame_funcionario
	FOREIGN KEY (idFuncionario)
	REFERENCES testesclinicos.funcionario (idFuncionario)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  INDEX fk_exame_equipamento_idx (idEquipamento ASC),
  CONSTRAINT fk_exame_equipamento
	FOREIGN KEY (idEquipamento)
	REFERENCES  testesclinicos.equipamento (idEquipamento)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela testesclinicos.equipamento
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS testesclinicos.equipamento (
  idEquipamento INT,
  designacao VARCHAR(75) NOT NULL,
  PRIMARY KEY (idEquipamento))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela testesclinicos.consulta
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS testesclinicos.consulta (
	idFuncionario INT(11) NOT NULL,
	idAtleta INT(11) NOT NULL,
    data_hora DATETIME NOT NULL,
	estado VARCHAR(45) NOT NULL,
	PRIMARY KEY (idFuncionario, idAtleta, data_hora),	
	INDEX fk_consulta_funcionario_idx (idFuncionario ASC),
    CONSTRAINT fk_consulta_funcionario
    FOREIGN KEY (idFuncionario)
    REFERENCES testesclinicos.funcionario (idFuncionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    INDEX fk_consulta_atleta_idx (idAtleta ASC),
    CONSTRAINT fk_consulta_atleta
    FOREIGN KEY (idAtleta)
    REFERENCES testesclinicos.atleta (idAtleta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela testesclinicos.especialidade
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS testesclinicos.especialidade (
  idEspecialidade INT,
  designacao VARCHAR(75) NOT NULL,
  preco DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (idEspecialidade))
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;