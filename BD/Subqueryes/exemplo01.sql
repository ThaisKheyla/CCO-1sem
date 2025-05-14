create database if not exists sprint3;

use sprint3;

create table curso(
id int not null auto_increment,
curso varchar(20) not null,
periodo_inicio  date,
primary key(id),
unique key(curso));

insert into curso(curso, periodo_inicio)
values ('1CCOA', '2025-02-01'),
       ('1CCOB', '2025-02-01'),
       ('1ADSA', '2025-02-01'),
       ('1ADSB', '2025-02-01'),
       ('1SIS', '2025-02-01'),
       ('2ADSA', '2024-07-01'),
       ('2ADSB', '2024-07-01');
       
select * from    curso;


create table aluno(
id      int not null auto_increment,
ra      char(08) not null,
nome    varchar(100) not null,
fkcurso  int,
primary key (id),
unique key uk_ra(ra));


insert into aluno(ra, nome, fkcurso)
VALUES
('20251001', 'Ana Silva', 8),
('20251002', 'Pedro Souza', 9),
('20251003', 'Carla Oliveira', 10),
('20251004', 'Lucas Santos', 11),
('20251005', 'Mariana Costa', 12),
('20242001', 'Gabriel Pereira', 13),
('20242002', 'Beatriz Rodrigues', 14),
('20251006', 'Fernando Almeida', 8),
('20251007', 'Juliana Ferreira', 9),
('20251008', 'Ricardo Martins', 10),
('20242003', 'Amanda Lima', 11),
('20251009', 'Rafael Castro', 12),
('20242004', 'Isabela Gomes', 13),
('20242005', 'Thiago Nunes', 14),
('20251010', 'Letícia Barbosa', 8);

create table materia(
id     int not null auto_increment,
nome   varchar(50),
primary key(id));

insert into materia(nome)
values ('BD'),
       ('LP'),
       ('AS'),
       ('TI'),
       ('PI');

create table sprint(
id int not null auto_increment,
descricao   varchar(20) not null,
peso        decimal(7,1) not null,
primary key (id));

insert into sprint(descricao, peso)
values ('SP-1', 25),
       ('SP-2', 35),
       ('SP-3', 40);

create table avaliacao(
id int not null auto_increment,
descricao    varchar(20) not null,
primary key (id));

insert into avaliacao (descricao)
values ('AVALIAÇÃO CONTINUATA'),
       ('INTEGRADA'),
       ('PRATICA');
	
create table sprint_avaliacao(
fksprint   int not null ,      
fkavaliacao int not null,
peso        int not null,
primary key(fksprint, fkavaliacao));

insert into sprint_avaliacao(fksprint, fkavaliacao, peso)
select sp.id, av.id, case when locate('CONT', av.descricao) > 0 then 40
                          when locate('INTE', av.descricao) > 0 then 30
                          else 30 end peso
from sprint sp, avaliacao av;    

create table sprint_curso_materia(
fkcurso   int not null,
fksprint  int not null,
fkavaliacao int not null,
fkmateria  int not null,
primary key(fkcurso, fksprint, fkavaliacao, fkmateria));


insert into sprint_curso_materia(fkcurso, fksprint, fkavaliacao, fkmateria)
select cur.id, sa.fksprint, sa.fkavaliacao, ma.id
from curso cur, sprint_avaliacao sa, materia ma;

create table nota(
fkcurso   int not null,
fksprint  int not null,
fkavaliacao int not null,
fkmateria  int not null,
fkaluno    int not null,
nota       decimal(7,1),
primary key (fkcurso, fksprint, fkavaliacao, fkmateria, fkaluno));

alter table aluno add constraint fk_aluno_curso foreign key(fkcurso) references curso(id);

alter table sprint_avaliacao add constraint fk_spav_sprint foreign key(fksprint) references sprint(id),
                             add  constraint fk_spav_avaliacao foreign key(fkavaliacao) references avaliacao(id);

alter table sprint_curso_materia add constraint fk_spcm_curso foreign key(fkcurso) references curso(id),
                             add  constraint fk_spcm_spav foreign key(fksprint, fkavaliacao) references sprint_avaliacao(fksprint, fkavaliacao),
                             add  constraint fk_spcm_materi foreign key(fkmateria) references materia(id);

alter table nota add constraint fk_nota_spcm foreign key(fkcurso, fksprint, fkavaliacao, fkmateria) references sprint_curso_materia(fkcurso, fksprint, fkavaliacao, fkmateria),
                             add  constraint fk_spcm_aluno foreign key(fkaluno) references aluno(id);

insert into nota(fkcurso, fksprint, fkavaliacao, fkmateria, fkaluno, nota)
select sc.fkcurso, fksprint, fkavaliacao, fkmateria, al.id fkaluno, case when fksprint+fkavaliacao+fkmateria > 10 then 10 else fksprint+fkavaliacao+fkmateria end nota
from sprint_curso_materia sc, aluno al;
