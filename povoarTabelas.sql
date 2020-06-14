USE testesclinicos;
SET SQL_SAFE_UPDATES = 0;

-- -----------------------------------------------------
-- Tabela testesclinos.modalidade
-- -----------------------------------------------------
INSERT INTO testesclinicos.modalidade
	(idModalidade, designacao)
	VALUES 
    ('1', 'Corrida de Pistas'),
    ('2', 'Maratona'),
	('3', 'Barreiras'),
	('4', 'Marcha'),
	('5', 'Salto'),
	('6', 'Lançamento');
    
#SELECT * FROM testesclinicos.modalidade;

-- -----------------------------------------------------
-- Tabela testesclinicos.atleta
-- -----------------------------------------------------
INSERT INTO testesclinicos.atleta
	(idAtleta,nome,data_nascimento,peso,altura,sexo,localidade,idModalidade)
	VALUES 
		(394,'André Marques','1996-01-02',70,153,'masculino', 'Faro',1),
		(536,'Alberto Martins','1996-01-02',70,153,'masculino', 'Braga',2),
		(847,'Alberto Silva','1999-05-10',80,202,'masculino', 'Tomar',2),
		(129,'Antónia Rodrigues','1995-11-21',83,158,'feminino', 'Aveiro',3),
		(326,'Antónia Soares','1992-10-20',71,197,'feminino', 'Bragança',4),
		(849,'Antónia Ventura','1987-11-20',71,174,'feminino', 'Ponta Delgada',2),
		(175,'António Amaro','1985-02-25',71,175,'masculino', 'Bragança',2),
		(208,'António Felix','2000-11-16',45,188,'masculino', 'Porto',5),
		(804,'Raul Rego','2000-02-21',95,150,'masculino', 'Porto',5),
		(313,'Ricardo Silva','1996-04-30',61,173,'masculino', 'Gaia',1),
		(216,'Rosa Dart','1988-04-19',96,150,'masculino', 'Guarda',4),
		(765,'Rui Mateus','1983-04-27',69,169,'masculino', 'Figueira da Foz',5),
		(598,'Rui Mota','1997-11-11',82,204,'masculino', 'Vila Real',2),
		(376,'Susana Vieira','1981-09-18',93,192,'feminino', 'Tavira',2),
		(367,'Sérgio Pinto','1982-11-06',58,170,'masculino', 'Coimbra',1),
		(109,'Sofia Cabral','1995-08-04',93,175,'feminino', 'Covilhã',1),
		(112,'Sónia Fertuzinhos','1983-03-25',95,199,'feminino', 'Viana do Castelo',4),
		(139,'Tainara Rodrigues','1985-06-09',77,193,'feminino', 'Montijo',5),
		(743,'Tatiana Carneiro','1991-11-09',73,167,'masculino', 'Bragança',2),
		(834,'Válter Moreira','1994-01-27',67,168,'masculino', 'Aveiro',4),
		(087,'Xavier Aveiro','1993-12-06',44,187,'masculino', 'Vila do Conde',3),
		(567,'Wendy Gomes','1998-05-02',56,151,'feminino', 'Chaves',4),
		(197,'Zacarias Miguel','1990-07-02',75,157,'masculino', 'Évora',6);

#SELECT * FROM testesclinicos.atleta;

-- -----------------------------------------------------
-- Tabela testesclinicos.categoria
-- -----------------------------------------------------
INSERT INTO testesclinicos.categoria
	(idCategoria,designacao) 
    VALUES
    (1, 'Médico'),
	(2, 'Fisioterapeuta'),
	(3, 'Operador de Laboratório'),
    (4, 'Enfermeiro');
    
#SELECT * FROM testesclinicos.categoria;

-- -----------------------------------------------------
-- Tabela testesclinicos.especialidade
-- -----------------------------------------------------
INSERT INTO testesclinicos.especialidade
	(idEspecialidade,designacao,preco)
    VALUES
	(1,'Cardiologia',200),
	(2,'Radiologia',250),
	(3,'Ortopedia',100),
	(4,'Gastroenterologia',50),
    (5,'Psiquiatria',150),
    (6,'Medicina Desportiva',35),
    (7,'Oftalmologia',300); 

#SELECT * FROM testesclinicos.especialidade;

-- -----------------------------------------------------
-- Tabela testesclinicos.funcionario
-- -----------------------------------------------------
INSERT INTO testesclinicos.funcionario
	(idFuncionario,nome,data_nascimento,idCategoria) 
    VALUES
	(4, 'Leonardo Avintes','1978-10-22',2),
	(5, 'Miguel Angelo','1981-01-05',2),
    (9, 'Nuno Pereira','1972-03-09',3),
    (11, 'Maria Fernandes','1988-07-03',4);
INSERT INTO testesclinicos.funcionario
	(idFuncionario,nome,data_nascimento,idCategoria,idEspecialidade) 
    VALUES
    (1, 'Alberto Matos','1982-04-08',1,3),
	(2, 'Guilherme Teles','1950-09-05',1,5),
	(3, 'Joana Arcos','1960-09-09',1,7),
	(6, 'Florbela Esteves','1953-05-09',1,1),
	(7, 'Vasco Gajo','1961-10-28',1,2),
	(8, 'Inês Castro','1989-03-21',1,4),
    (10, 'António Costa','1941-09-26',1,6);
    
#SELECT * FROM testesclinicos.funcionario;

-- -----------------------------------------------------
-- Tabela testesclinicos.equipamento
-- -----------------------------------------------------
INSERT INTO testesclinicos.equipamento
	(idEquipamento, designacao) 
    VALUES
	(1,'Laboratório'),
	(2,'Medidor de Tensão'),
	(3,'Aparelho ECG'),
	(4,'Apito'),
    (5,'Aparelho RaioX');
    
#SELECT * FROM testesclinicos.equipamento;

-- -----------------------------------------------------
-- Tabela testesclinicos.exame
-- -----------------------------------------------------
INSERT INTO testesclinicos.exame
	(idExame,designacao,idAtleta,idFuncionario,data_hora,preco,resultado,idEquipamento,estado) 
    VALUES
    (00005,'Antidoping',743,9,'2018-12-09 11:13','0','aprovado',1,'R'), 
    (00006,'ECG',087,6,'2018-12-12 12:15',150,'reprovado',3,'R'),
    (00009,'Antidoping',376,9,'2019-03-25 15:12','0','aprovado',1,'R'), 
    (00010,'ECG',175,6,'2019-04-15 17:01',150,'aprovado',3,'R'),
    (00011,'Beep',216,10,'2019-01-03 13:59',15,'reprovado',4,'R'), 
    (00013,'Medir a Tensão',216,11,'2019-01-07 18:34',25,'reprovado',2,'R'), 
    (00014,'Beep',394,10,'2019-05-28 17:36',15,'aprovado',4,'R'),
    (00024,'ECG',112,6,'2019-09-17 10:56',150,'aprovado',3,'R'),
    (00025,'ECG',197,6,'2019-01-23 16:19',150,'aprovado',3,'R'),
    (00027,'Beep',804,10,'2019-06-12 09:02',15,'reprovado',4,'R'),
    (00031,'Radiografia',804,7,'2020-03-11 09:00',15,'aprovado',5,'A'),
    (00032,'Radiografia',216,7,'2020-03-11 11:00',15,'reprovado',5,'A');
INSERT INTO testesclinicos.exame
	(idExame,designacao,idAtleta,idFuncionario,data_hora,preco,resultado,estado) 
    VALUES
    (00001,'Análise da Composição Corporal',326,8,'2019-05-21 09:19', 100, 'aprovado','R'),
    (00002,'Movimento Funcional',208,1,'2019-12-15 10:36',50,'aprovado','R'),
    (00003,'Fisioterapia',139,5,'2019-12-02 13:02',50,'reprovado','R'), 
    (00004,'Aptus Mental',765,2,'2019-05-21 09:51',10,'reprovado','R'),
    (00007,'Movimento Funcional',743,1,'2019-08-30 12:39',50,'reprovado','R'),
    (00008,'Aptus Mental',367,2,'2019-06-27 09:11',10,'reprovado','R'),
	(00012,'Fisioterapia',834,5,'2019-12-13 16:40',50,'reprovado','R'), 
    (00015,'Salto e Pouso',109,4,'2019-05-17 09:35',30,'reprovado','R'),
    (00016,'Análise da Composição Corporal',197,8,'2019-11-04 10:12',100,'reprovado','R'),
    (00017,'Salto e Pouso',849,4,'2019-07-26 15:02',30,'aprovado','R'),
    (00018,'Anaeróbico',197,10,'2019-08-19 17:56',100,'reprovado','R'),
    (00019,'Movimento Funcional',536,1,'2019-06-05 11:19',50,'reprovado','R'),
    (00020,'Equílibrio',847,5,'2019-01-01 16:45',40,'reprovado','R'),
    (00021,'Movimento Funcional',129,1,'2019-11-21 13:15',50,'aprovado','R'),
    (00033,'Anaeróbico',216,10,'2019-02-20 17:56',100,'reprovado','A');
INSERT INTO testesclinicos.exame
	(idExame,designacao,idAtleta,idFuncionario,data_hora,preco,idEquipamento,estado) 
	VALUES
    (00028,'Medir a Tensão',139,11,'2020-02-20 12:11',25,2,'A');
INSERT INTO testesclinicos.exame
	(idExame,designacao,idAtleta,idFuncionario,data_hora,preco,estado) 
    VALUES
    (00022,'Fisioterapia',598,4,'2020-02-15 10:38',50,'A'), 
    (00023,'Equílibrio',394,5,'2020-02-19 15:19',40,'A'),
    (00026,'Movimento Funcional',313,1,'2020-03-19 19:21',50,'A'),
    (00029,'Fisioterapia',567,4,'2020-01-03 10:13',50,'A'), 
    (00030,'Fisioterapia',849,5,'2020-01-12 11:27',50,'A'); 

#SELECT * FROM testesclinicos.exame;

-- -----------------------------------------------------
-- Tabela testesclinicos.consulta
-- -----------------------------------------------------
INSERT INTO testesclinicos.consulta
	(idFuncionario,idAtleta,data_hora,estado)
    VALUES
	(10, 536, '2018-12-05 10:00','R'),
    (8, 367, '2018-12-12 09:00','R'),
    (7, 129, '2018-12-13 10:15','R'),
	(1, 326, '2019-01-05 12:00','R'),
	(1, 849, '2019-01-10 15:00','R'),
	(2, 765, '2019-01-15 17:30','R'),
	(7, 367, '2019-01-15 09:00','R'),
	(3, 216, '2019-01-15 10:30','R'),
	(8, 376, '2019-01-17 11:15','R'),
	(3, 109, '2019-01-17 09:30','R'),
	(1, 208, '2019-01-20 14:00','R'),
	(6, 112, '2019-01-21 15:30','R'),
	(8, 598, '2019-01-22 19:00','R'),
	(7, 087, '2019-01-22 09:30','R'),
	(2, 139, '2019-02-02 09:00','R'),
	(2, 129, '2019-02-05 10:00','R'),
    (3, 129, '2019-02-05 12:30','R'),
	(7, 847, '2019-02-07 10:00','R'),
	(6, 804, '2019-02-07 15:30','R'),
	(2, 847, '2019-02-09 17:00','R'),
	(10, 567, '2019-02-12 16:30','R'),
	(1, 567, '2019-02-12 18:00','R'),
    (8, 313, '2019-07-15 09:30','R'),
	(1, 834, '2019-08-13 10:00','R'),
    (7, 197, '2019-09-14 11:00','R'),
    (6, 197, '2019-09-15 12:30','R'),
    (7, 175, '2019-09-20 12:15','R'),
    (3, 743, '2020-02-20 12:20','A'),
    (10, 394, '2020-02-20 16:00','A'),
    (1, 313, '2020-02-22 09:15','A'),
    (1, 834, '2020-02-22 14:00','A');
    
#SELECT * FROM testesclinicos.consulta
#ORDER BY data_hora;

