![image](https://github.com/WeberBar/procedure-stored-sql/assets/113800165/465a6419-ef5a-4f32-85e9-f3b84e8987a6)# procedure-stored-sql

Crie um banco de dados para armazenar alunos, cursos e professores de uma
universidade;
Faça a modelagem do banco e identifique as entidades, seus atributos e relacionamentos
Crie o modelo físico do banco de dados (script SQL)
![modelo-logico](modelo-logico.png)

Utilize Stored Procedures para automatizar a inserção e seleção dos cursos;
O aluno possui um email que deve ter seu endereço gerado automaticamente no seguinte formato:
nome.sobrenome@dominio.com
Como fica o email se duas pessoas tiverem o mesmo nome e sobrenome?
``` sql
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
```
![inserindo_alunos](inserir_alunos.png)
![alunos](alunos.png)
