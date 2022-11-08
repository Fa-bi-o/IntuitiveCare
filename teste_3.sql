# Criando database

CREATE DATABASE teste_3;
USE teste_3;

# Criando a tabela do arquivo relatório (download do e-mail)
CREATE TABLE tbl_relatorio_cadop (
id int not null auto_increment,
registro mediumint,
cnpj double,
razaoSocial varchar(150),
nomeFantasia varchar(80),
modalidade varchar(50),
logradouro varchar(80),
numero varchar(25),
complemento varchar(80),
bairro varchar(50),
cidade varchar(40),
uf varchar(2),
cep int,
ddd varchar(3),
telefone varchar(25),
fax varchar(50),
email varchar(80),
representante varchar(80),
cargoRepresentante varchar(80),
dataRegistroAns varchar(10),
primary key (id)
) default charset = utf8mb4;

# Carregando a tabela com os dados do arquivo Relatorio_cadop(1) (2).csv'
# Necessita mudar o caminho do arquivo para funcionar corretamente o script
LOAD DATA INFILE 'E:\Codigo\\Python\\teste_intuitive\\teste_3_relatorio\\Relatorio_cadop(1) (2).csv'
INTO TABLE tbl_relatorio_cadop
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 3 ROWS
(registro, cnpj, razaoSocial, nomeFantasia, modalidade, 
logradouro, numero, complemento, bairro, cidade, uf, cep,
ddd, telefone, fax, email, representante, cargoRepresentante, dataRegistroAns);

# Criando a tabela dos arquivos 2021 e 2022

CREATE TABLE tbl_docs_2021_2022 (
id int not null auto_increment,
dataRegistro varchar(10),
registroAns mediumint,
cdConta int,
descricao varchar (200),
saldoFinal varchar(80),
primary key (id)
) default charset = utf8mb4;


# Carregando a tabela com os dados dos arquivos 2021 2022
# Necessita mudar o caminho do arquivo para funcionar corretamente o script

LOAD DATA INFILE 'E:\Codigo\\Python\\teste_intuitive\\teste_3_2021\\1T2021.csv'
INTO TABLE tbl_docs_2021_2022
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(dataRegistro, registroAns, cdConta, descricao, saldoFinal);

LOAD DATA INFILE 'E:\Codigo\\Python\\teste_intuitive\\teste_3_2021\\2T2021.csv'
INTO TABLE tbl_docs_2021_2022
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(dataRegistro, registroAns, cdConta, descricao, saldoFinal);

LOAD DATA INFILE 'E:\Codigo\\Python\\teste_intuitive\\teste_3_2021\\3T2021.csv'
INTO TABLE tbl_docs_2021_2022
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(dataRegistro, registroAns, cdConta, descricao, saldoFinal);

ALTER TABLE tbl_docs_2021_2022
ADD COLUMN saldoInicial varchar(80) AFTER descricao;

UPDATE tbl_docs_2021_2022 SET saldoInicial = '0,00' WHERE saldoInicial IS NULL;

LOAD DATA INFILE 'E:\Codigo\\Python\\teste_intuitive\\teste_3_2021\\4T2021.csv'
INTO TABLE tbl_docs_2021_2022
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(dataRegistro, registroAns, cdConta, descricao, saldoInicial, saldoFinal);

LOAD DATA INFILE 'E:\Codigo\\Python\\teste_intuitive\\teste_3_2022\\1T2022.csv'
INTO TABLE tbl_docs_2021_2022
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(dataRegistro, registroAns, cdConta, descricao, saldoInicial, saldoFinal);

LOAD DATA INFILE 'E:\Codigo\\Python\\teste_intuitive\\teste_3_2022\\2T2022.csv'
INTO TABLE tbl_docs_2021_2022
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(dataRegistro, registroAns, cdConta, descricao, saldoInicial, saldoFinal);

UPDATE tbl_docs_2021_2022 SET saldoFinal=CAST(REPLACE(SaldoFinal,',','.') AS FLOAT);
UPDATE tbl_docs_2021_2022 SET saldoInicial=CAST(REPLACE(SaldoInicial,',','.') AS FLOAT);

# Quais as 10 operadoras que mais tiveram despesas com "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre?

SELECT dataRegistro, registroAns, descricao, saldoFinal#, razaoSocial
FROM tbl_docs_2021_2022#, tbl_relatorio_cadop
WHERE descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
AND dataRegistro LIKE '%04/2022' OR dataRegistro LIKE '%05/2022' OR dataRegistro LIKE '%06/2022'
#AND registro = registroAns
ORDER BY saldoFinal DESC LIMIT 10;

# Quais as 10 operadoras que mais tiveram despesas com "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último ano?

SELECT dataRegistro, registroAns, descricao, saldoFinal, razaoSocial
FROM tbl_relatorio_cadop, tbl_docs_2021_2022
WHERE descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
AND dataRegistro LIKE '%/2022'
AND registro = registroAns
ORDER BY saldoFinal	DESC LIMIT 10;