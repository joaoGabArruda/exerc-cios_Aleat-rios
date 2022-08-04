Faça uma função que receba o id de um cliente e de uma operadora, e verifique se o cliente já possui algum telefone da operadora, se 
sim, deve dar um desconto de 50% no seu contrato que possui o maior valor. Senão deve criar um contrato do cliente com essa operadora, 
usando o menor valor do plano desta operadora.

RESPOSTA 1 - TUDO JUNTO

-- cria a função "verifica_cliente" com o id do cliente e da operadora como entradas e retorna nada
create or replace function verifica_cliente (in Cliente int, in operadora int) returns void as $$ 

-- cria as variáveis que serão usadas no programa
declare
auxiliar int := 0;
value numeric := 0.0;
comp record;
dia date;

begin
select telefone_id into auxiliar from contrato where cliente_id = cliente; -- verifica se o cliente possui algum contrato ativo

if auxiliar is null then -- se o cliente nao possui um contrato, a variável auxiliar vai ser nula

raise notice 'cliente sem contrato';

-- salva o plano_id na variável "auxiliar" e o menor preço na variável "value" para serem inseridos depois 
select id, valor into auxiliar, value from plano where valor = (select min(valor) from plano where operadora_id = 3); 

-- seleciona a data de hoje para ser inserido depois
select date(now()) into dia;

-- seleciona o numero de telefone na variável "comp" que ainda não foi usada em um contrato - usa da técnica de "exclusive full outer join"
select telefone.id into comp from telefone full outer join contrato on telefone.id = contrato.telefone_id where telefone.id is null or contrato.telefone_id is 
null and telefone.operadora_id = operadora order by telefone.id limit 1;

insert into contrato values (13, cliente,comp.id,auxiliar,dia, value);

else
select id, valor_final into auxiliar, value from contrato where valor_final = (select max(valor_final) from contrato where cliente_id = cliente);
value := value/2;

update contrato set valor_Final = value where id = auxiliar;
raise notice 'valor final atualizado';
end if;
end;$$ language plpgsql;



| Tendo a o seguinte Banco: |

Cliente (id, cpf, nome, rg, sexo, uf)
Operadora (id, nome, cnpj)
Telefone (id, numero, operadora_id)
Plano (id, valor, operadora_id, descricao)
Contrato(id, cliente_id, telefone_id, plano_id, data_contrato, valor_final)

| Populando o banco: | 
CLIENTE:
INSERT INTO cliente (id,cpf,nome,rg,sexo,uf)
VALUES
  (1,'035-743-141-14','Destiny Bishop','64462','M','Narvik'),
  (2,'094-951-717-10','Lance Atkins','09118','F','Huancayo'),
  (3,'744-437-420-00','Roth Velasquez','60651','M','Vico nel Lazio'),
  (4,'256-540-782-35','Hiroko Horne','29335','F','Alice'),
  (5,'131-335-877-52','Alyssa Hays','58198','F','Nuevo Laredo'),
  (6,'894-756-110-78','Lane Donaldson','35321','M','Hudson Bay'),
  (7,'657-673-412-17','Martena Cannon','88481','M','Liberia'),
  (8,'286-435-885-72','Troy Love','48063','M','Battagram'),
  (9,'724-452-367-78','Craig Landry','24532','M','Hebei'),
  (10,'574-611-145-62','Cruz Hansen','13674','M','Lisieux'),
  (11,'335-952-377-56','Medge Drake','66249','F','Oamaru'),
  (12,'813-705-477-55','Cassandra Schwartz','71522','F','Newton Stewart'),
  (13,'689-781-261-63','Yvonne Wilcox','72147','M','Henan'),
  (14,'871-079-224-84','Charissa Riddle','97777','M','Juliaca'),
  (15,'868-885-656-16','Isadora Melton','78925','F','Kansas City'),
  (16,'847-682-983-11','Flynn Stanley','11573','M','Liaoning'),
  (17,'061-259-448-66','Melinda Kane','23320','M','Cali'),
  (18,'489-665-603-40','Kaseem Sweeney','05127','F','Norman Wells'),
  (19,'220-231-818-73','Abraham Bird','75298','F','Long Xuyên'),
  (20,'398-308-746-42','Talon Gates','49351','M','Lviv'),
  (21,'541-467-664-20','Raven Perez','72225','M','Gwalior'),
  (22,'827-488-824-31','Azalia Talley','45975','F','Waitara'),
  (23,'439-137-484-16','Pamela Larson','95565','M','Kharan'),
  (24,'565-089-616-47','Brielle Gilbert','37833','F','Dadu'),
  (25,'148-532-738-90','Ivan Case','88763','M','Buner'),
  (26,'115-871-249-14','Derek Cox','14850','M','Trujillo'),
  (27,'286-311-653-64','Chase Dominguez','14232','F','Matamata'),
  (28,'283-841-781-21','Julie Gardner','13141','M','Radom'),
  (29,'236-492-904-98','Caesar Donaldson','36765','M','Randfontein'),
  (30,'720-857-437-46','Xantha Fuentes','75276','F','Xalapa'),
  (31,'588-266-478-19','Angelica Joyce','64449','F','Tagum'),
  (32,'342-223-561-54','Macaulay Page','48922','M','St. John''s'),
  (33,'124-415-445-22','Vladimir Stein','88233','M','Lobbes'),
  (34,'593-838-791-12','Quail Alston','47662','M','Vetlanda'),
  (35,'837-428-522-24','Blythe Pratt','14489','F','Cajamarca'),
  (36,'409-797-740-69','Laura Lamb','76426','F','Shanxi'),
  (37,'127-476-881-63','Merritt Watts','75423','F','Zoetermeer'),
  (38,'080-288-614-90','Grant Wall','51044','M','Hastings'),
  (39,'478-268-713-65','Travis Brock','78549','F','Cartagena'),
  (40,'662-863-450-25','Beverly Marshall','51735','F','Nancy'),
  (41,'685-142-286-28','Vanna Baird','15618','M','Virginia'),
  (42,'426-511-118-17','Ferris Barr','64813','M','Bünyan'),
  (43,'479-281-438-74','Kenneth Delaney','19116','F','Astore'),
  (44,'457-452-155-30','Louis Parrish','56555','M','Oslo'),
  (45,'767-411-125-17','Whitney Becker','86648','M','Buner'),
  (46,'922-746-667-68','Renee Manning','42874','M','Barry'),
  (47,'440-488-931-92','Yuli Stuart','93369','F','Barranca'),
  (48,'646-548-447-55','Ashton Martin','50808','M','Bendigo'),
  (49,'371-220-618-45','Ignacia Carney','86708','F','Mirpur'),
  (50,'613-343-545-35','Berk Ray','31367','M','Khyber Agency');

OPERADORA:
INSERT INTO operadora (id,nome,cnpj)
VALUES
  (1,'Claro','87.845.765/7341-15'),
  (2,'vivo','77.554.434/4484-83'),
  (3,'oi','95.923.870/5116-61'),
  (4,'tim','97.435.458/8875-32');
  
TELEFONE:
INSERT INTO telefone (id,numero,operadora_id)
VALUES
  (1,'(36) 27712-4038',1),
  (2,'(46) 71359-5644',3),
  (3,'(17) 50682-5535',3),
  (4,'(54) 75548-3515',4),
  (5,'(88) 64263-6886',1),
  (6,'(47) 54460-0466',3),
  (7,'(42) 75315-7752',2),
  (8,'(19) 55732-8602',4),
  (9,'(20) 78249-7855',4),
  (10,'(23) 27138-7325',2),
  (11,'(48) 31277-1965',2),
  (12,'(98) 32987-1961',3),
  (13,'(14) 80414-1346',2),
  (14,'(28) 84970-7542',4),
  (15,'(31) 38525-7762',2),
  (16,'(44) 79178-8822',3),
  (17,'(36) 57498-0056',2),
  (18,'(12) 46298-2153',3),
  (19,'(61) 84640-4415',3),
  (20,'(35) 49623-7664',3),
  (21,'(74) 45463-5756',2),
  (22,'(41) 28941-1317',2),
  (23,'(24) 65282-9615',2),
  (24,'(58) 33784-5523',2),
  (25,'(73) 87833-7088',1);
  
PLANO:
INSERT INTO plano (id,valor,operadora_id,descricao)
VALUES
  (1,40.04,3,'vitae mauris sit amet lorem semper auctor. Mauris vel'),
  (2,48.73,4,'augue eu tellus. Phasellus elit pede, malesuada vel,'),
  (3,89.87,3,'sodales. Mauris blandit enim'),
  (4,.61.24,4,'augue.'),
  (5,66.38,3,'eget metus eu'),
  (6,38.34,3,'semper, dui lectus rutrum urna, nec luctus felis purus'),
  (7,24.31,2,'nibh lacinia orci, consectetuer euismod est arcu ac'),
  (8,54.71,1,'ipsum sodales purus,');

CONTRATO:
INSERT INTO contrato (id,cliente_id,telefone_id,plano_id,data_contrato,valor_final)
VALUES
  (1,49,15,7,'2022-08-23',47.98),
  (2,27,4,4,'2023-01-16',72.29),
  (3,28,17,7,'2021-10-02',42.39),
  (4,35,17,6,'2022-05-01',98.74),
  (5,46,19,5,'2022-03-17',67.44),
  (6,1,9,3,'2022-09-30',93.82),
  (7,24,23,4,'2021-10-16',36.68),
  (8,35,5,1,'2022-04-28',67.52),
  (9,44,7,7,'2021-09-24',31.32),
  (10,12,21,5,'2022-04-28',27.47);
  
  
