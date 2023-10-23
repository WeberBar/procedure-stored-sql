

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema universidade
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `universidade` DEFAULT CHARACTER SET utf8mb3 ;
USE `universidade` ;

-- -----------------------------------------------------
-- Table `universidade`.`alunos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universidade`.`alunos` (
  `id` INT NOT NULL auto_increment,
  `ra` int not null,
  `nome` VARCHAR(100) NOT NULL,
  `sobre_nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `universidade`.`cursos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universidade`.`cursos` (
  `idCursos` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCursos`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `universidade`.`alunos_has_cursos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universidade`.`alunos_has_cursos` (
  `Alunos_id` INT NOT NULL,
  `Cursos_idCursos` INT NOT NULL,
  PRIMARY KEY (`Alunos_id`, `Cursos_idCursos`),
  INDEX `fk_Alunos_has_Cursos_Cursos1_idx` (`Cursos_idCursos` ASC) VISIBLE,
  INDEX `fk_Alunos_has_Cursos_Alunos1_idx` (`Alunos_id` ASC) VISIBLE,
  CONSTRAINT `fk_Alunos_has_Cursos_Alunos1`
    FOREIGN KEY (`Alunos_id`)
    REFERENCES `universidade`.`alunos` (`id`),
  CONSTRAINT `fk_Alunos_has_Cursos_Cursos1`
    FOREIGN KEY (`Cursos_idCursos`)
    REFERENCES `universidade`.`cursos` (`idCursos`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `universidade`.`professores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universidade`.`professores` (
  `id` INT NOT NULL auto_increment,
`cracha` int not null,
  `nome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `universidade`.`cursos_has_professores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universidade`.`cursos_has_professores` (
  `Cursos_idCursos` INT NOT NULL,
  `Professores_id` INT NOT NULL,
  PRIMARY KEY (`Cursos_idCursos`, `Professores_id`),
  INDEX `fk_Cursos_has_Professores_Professores1_idx` (`Professores_id` ASC) VISIBLE,
  INDEX `fk_Cursos_has_Professores_Cursos1_idx` (`Cursos_idCursos` ASC) VISIBLE,
  CONSTRAINT `fk_Cursos_has_Professores_Cursos1`
    FOREIGN KEY (`Cursos_idCursos`)
    REFERENCES `universidade`.`cursos` (`idCursos`),
  CONSTRAINT `fk_Cursos_has_Professores_Professores1`
    FOREIGN KEY (`Professores_id`)
    REFERENCES `universidade`.`professores` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

USE `universidade` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- inserir dados dos cursos
insert into Cursos (idCursos, nome) values (0,'Engenharia aeronautica');
insert into Cursos (idCursos, nome) values (0,'Engenharia cívil');
insert into Cursos (idCursos, nome) values (0,'Engenharia mecânica');
insert into Cursos (idCursos, nome) values (0,'Engenharia quimica');
insert into Cursos (idCursos, nome) values (0,'Analise e desenvolvimento de sistemas');
insert into Cursos (idCursos, nome) values (0,'Medicina');
insert into Cursos (idCursos, nome) values (0,'Emfermagem');
insert into Cursos (idCursos, nome) values (0,'Psicologia');


-- Cria uma procedure stored que inseri os alunos lá gerando seus emails, basicamente um método que automatiza essa inserção de aluno
DELIMITER $
CREATE PROCEDURE inserir_alunos(
  ra int ,
  nome_aluno VARCHAR(100),
  sobre_nome_aluno VARCHAR(100)
)
BEGIN

  -- Declara 4 variáveis locais
  DECLARE nome_completo VARCHAR(200);
  declare parte_ra int;
  DECLARE contador INT;
  DECLARE email VARCHAR(100);

  -- Combina o nome e o sobrenome do aluno para formar o nome completo
  SET nome_completo = CONCAT(nome_aluno, '.', sobre_nome_aluno);

  -- Conta o número de alunos com o mesmo nome e sobrenome
  SET contador = (SELECT COUNT(*) FROM Alunos WHERE nome = nome_aluno AND sobre_nome = sobre_nome_aluno);

  -- Se o número de alunos for maior que 0, adiciona o número do RA ao nome completo para criar o email
  set parte_ra = substring(ra,4, 6);
  IF contador > 0 THEN
    SET email = CONCAT(nome_completo, parte_ra, '@facens.br');  
  ELSE
    SET email = CONCAT(nome_completo, '@facens.br');
  END IF;

  -- Insere os dados do aluno na tabela `Alunos`
  INSERT INTO Alunos (id,ra, nome, sobre_nome, email) VALUES (0,ra, nome_aluno, sobre_nome_aluno, email);

END$
DELIMITER ;

-- cria um metodo que mostra os alunos
delimiter $
create procedure Mostrar_alunos()
begin
select * from Alunos;
end $
delimiter ;

-- cria um metodo que mostra os alunos e os cursos que eles frequentam
delimiter $
create procedure mostrar_alunos_cursos()
begin
-- Seleciona os seguintes campos da tabela `Alunos`:
-- [] RA
-- [] Nome
-- [] Sobrenome
-- [] Uma lista de nomes de cursos

select Alunos.ra as 'RA',
Alunos.nome as 'Nome',
Alunos.sobre_nome as 'Sobrenome',
group_concat(Cursos.nome) as 'Cursos'

-- faz a junção da tabela alunos com cursos
from Alunos
join Alunos_has_cursos
 on Alunos.id = Alunos_has_cursos.Alunos_id
 join Cursos on Cursos.idCursos = Alunos_has_cursos.Cursos_idCursos

group by Alunos.ra, Alunos.nome, Alunos.sobre_nome;

 end$
 delimiter ;
 
 -- cria um metodo que mostra todos os cursos
 delimiter $
create procedure mostrar_cursos()
begin
select idCursos as ID_dos_cursos, nome as Cursos from cursos;
 end$
 delimiter ;
 
 -- cria um metodo que mostra todos os alunos, seus cursos e os´professores que lencionam os cursos
 delimiter $
create procedure Alunos_cursos_professores  ()
begin
-- Seleciona os seguintes campos da tabela `Alunos`:
-- [] RA
-- [] Nome
-- [] Sobre_nome
-- [] E-mail

select Alunos.ra as 'ra',
Alunos.nome as 'Alunos',
Alunos.sobre_nome as 'Sobre_nome',
Alunos.email as 'E-mail',

-- Seleciona uma lista de nomes de cursos

group_concat(Cursos.nome) as 'Cursos',

-- Seleciona uma lista de nomes de professores

group_concat(Professores.nome) as 'Docentes'

-- Seleciona os dados do aluno da tabela `Alunos`.

FROM Alunos

-- Relaciona a tabela `Alunos` com a tabela `Alunos_has_cursos`.
-- A condição de junção é que o `id` da tabela `Alunos` seja igual ao `Alunos_id` da tabela `Alunos_has_cursos`.

JOIN Alunos_has_cursos
ON Alunos.id = Alunos_has_cursos.Alunos_id

-- Relaciona a tabela `Alunos_has_cursos` com a tabela `Cursos`.
-- A condição de junção é que o `idCursos` da tabela `Alunos_has_cursos` seja igual ao `idCursos` da tabela `Cursos`.

JOIN Cursos
ON Cursos.idCursos = Alunos_has_cursos.Cursos_idCursos

-- Relaciona a tabela `Cursos` com a tabela `Cursos_has_professores`.
-- A condição de junção é que o `idCursos` da tabela `Cursos` seja igual ao `Cursos_idCursos` da tabela `Cursos_has_professores`.

JOIN Cursos_has_professores
ON Cursos.idCursos = Cursos_has_professores.Cursos_idCursos

-- Relaciona a tabela `Cursos_has_professores` com a tabela `Professores`.
-- A condição de junção é que o `id` da tabela `Professores` seja igual ao `Professores_id` da tabela `Cursos_has_professores`.

JOIN Professores
ON Professores.id = Cursos_has_professores.Professores_id

GROUP BY Alunos.ra, Alunos.nome, Alunos.sobre_nome;

end $
delimiter ;

-- inserir alunos da tabela
call inserir_alunos(232425,"Stephany","Squilaro");
call inserir_alunos(232524,'João','Vitor');
call inserir_alunos(234895,'João','Vitor');
call inserir_alunos(223412,'Vinicius','Squilaro');
call inserir_alunos(235320,'Vitor','Hugo');
call inserir_alunos(235902,'Vitor','Hugo');

-- inserir professores
insert into Professores values (null,532432, 'Renato Bonaparte', 'renato.bonaparte@facens.br');
insert into Professores values (null,435421, 'Napoleão Cristovão', 'napocris@facens.br');
insert into Professores values (null,357609, 'João Gomes', 'jo.gomes@facens.br');
insert into Professores values (null,373737, 'Giovanna Oliveira', 'Gioliveira@facens.br');

-- inserir o relacionamento dos alunos com os cursos
 insert into alunos_has_cursos values (1,1);
 insert into alunos_has_cursos values (2,2);
 insert into alunos_has_cursos values (3,3);
 insert into alunos_has_cursos values (3,4);
 insert into alunos_has_cursos values (4,6);
 insert into alunos_has_cursos values (5,7);
 insert into alunos_has_cursos values (6,8);
 insert into alunos_has_cursos values (6,5);
 
 -- inserir o relacionamento dos cursos com os professores
 insert into cursos_has_professores values (1,1);
 insert into cursos_has_professores values (1,2);
 insert into cursos_has_professores values (2,3);
 insert into cursos_has_professores values (2,4);
 insert into cursos_has_professores values (3,1);
 insert into cursos_has_professores values (3,2);
 insert into cursos_has_professores values (4,3);
 insert into cursos_has_professores values (4,4);
 insert into cursos_has_professores values (5,1);
 insert into cursos_has_professores values (5,4);
 insert into cursos_has_professores values (6,2);
 insert into cursos_has_professores values (7,3);
 insert into cursos_has_professores values (8,1);


-- chama os metodos para mostrar os relatorios
call mostrar_cursos(); 
call Mostrar_alunos();
call mostrar_alunos_cursos();
call Alunos_cursos_professores();
 