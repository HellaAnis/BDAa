
-- creation des projet par les utilisateur qui ont le role=chef
-- INSERTION Projet:

insert into projet (id,nomprojet, description, location, datedebut, datefin, bute, utilisateur_id, equipe_id)
values (1,'bda', 'projet d"etude', 'paris', '20/10/2019', '20/11/2019', '200', '1', '1');
--se projet est cree par un utilisateur qui n'a pas le role chef
--  insert into projet (id,nomprojet, description, location, datedebut, datefin, bute, utilisateur_id, equipe_id)
--   values (2,'system', 'projet d"etude', 'nice', '20/10/2019', '20/11/2019', '2000', '1', '2');
-- insert into projet (id,nomprojet, description, location, datedebut, datefin, bute, utilisateur_id, equipe_id)
-- values (2,'system', 'projet d"etude', 'nice', '20/10/2019', '20/11/2019', '2000', '1','5');
insert into projet (id,nomprojet, description, location, datedebut, datefin, bute, utilisateur_id, equipe_id)
values (3,'interface', 'projet d"etude', 'lyon', '20/10/2019', '20/11/2019', '1200','3', '2');



--INSERTION investisseent:
insert into investissement(sommeengage, ts, projet_investissement_option_id, utilisateur_id, projet_id)
values ('1000', now(), 1, 2, 1);
insert into investissement(sommeengage, ts, projet_investissement_option_id, utilisateur_id, projet_id)
values ('500', now(), 3, 2, 3);
insert into investissement(sommeengage, ts, projet_investissement_option_id, utilisateur_id, projet_id)
values ('1', now(), 2, 1, 3);
--investissement avec somme > somme max de l'option
-- insert into investissement(sommeengage, ts, projet_investissement_option_id, utilisateur_id, projet_id)
-- values ('300', now(), 2, 1, 3);

--tester le changemment des parametres
-- update projet
-- SET bute = 1600 where id=1;

-- --simulation de la date
-- update dateTable set date ='21/11/2019' where id=1;
