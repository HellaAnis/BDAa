delete FROM projet where id>0;
delete FROM participer where utilisateur_id>0;
delete FROM equipe where id>0;
delete FROM role where id>0;
delete FROM archivagestatue where id>0;
delete FROM projetstatue where id>0;
delete FROM projet_investissement_option where id>0;
delete FROM catalogoption where id>0;
delete FROM investissement where id>0;
delete FROM rembourcement where id>0;
delete FROM utilisateur where id>0;
delete from datetable where id>0;
delete from parametres where id>0;

--Date
INSERT INTO dateTable (id, date)
VALUES (1, now());

-- INSERTION Role:
insert into role(id,role)VALUES (1,'CHEF');
insert into role(id,role)VALUES (2,'DEVELOPPEUR');

-- INSERTION Utilisateur :
insert into utilisateur(id,nom, prenom, pseudo, motdepasse, email, projets_supporte) values
(1,'zinou','merred','adlen','1995','zinouadllen24@gmail.com','1');
insert into utilisateur(id,nom, prenom, pseudo, motdepasse, email, projets_supporte) values
(2,'Anis','hellal','nisou','1995','anishella24@gmail.com','1');
insert into utilisateur(id,nom, prenom, pseudo, motdepasse, email, projets_supporte) values
(3,'zaki','zikou','Zak','1993','zakzikou24@gmail.com','2');

-- INSERTION Equipe:
insert into equipe(id,nombreequipe, nomequipe)VALUES (1,'5', 'paris7');
insert into equipe(id,nombreequipe, nomequipe)VALUES (2,'6', 'paris6');
insert into equipe(id,nombreequipe, nomequipe)VALUES (3,'7', 'paris8');
insert into equipe(id,nombreequipe, nomequipe)VALUES (4,'8', 'paris5');

-- INSERTION Participer:
insert into participer(utilisateur_id, equipe_id, role_id)VALUES ('1', '1', '1');
insert into participer(utilisateur_id, equipe_id, role_id)VALUES ('2', '1', '2');
insert into participer(utilisateur_id, equipe_id, role_id)VALUES ('3', '2', '1');
insert into participer(utilisateur_id, equipe_id, role_id)VALUES ('1', '2', '2');



-- -- INSERTION Projet:
-- insert into projet (id,nomprojet, description, location, datedebut, datefin, bute, utilisateur_id, equipe_id)
-- values (1,'bda', 'projet d"etude', 'paris', '20/10/2019', '20/11/2019', '200', '1', '1');
-- insert into projet (id,nomprojet, description, location, datedebut, datefin, bute, utilisateur_id, equipe_id)
-- values (2,'system', 'projet d"etude', 'nice', '20/10/2019', '20/11/2019', '2000', '1', '2');
-- insert into projet (id,nomprojet, description, location, datedebut, datefin, bute, utilisateur_id, equipe_id)
-- values (3,'interface', 'projet d"etude', 'lyon', '20/10/2019', '20/11/2019', '1200','3', '2');

-- INSERTION Statues:
insert into projetstatue (id, nomstatue)values ('1', 'Not stared yet');
insert into projetstatue (id, nomstatue)values ('2', 'Started');
insert into projetstatue (id, nomstatue)values ('3', 'working on it');
insert into projetstatue (id, nomstatue)values ('4', 'Half');
insert into projetstatue (id, nomstatue)values ('5', 'Near of completed');
insert into projetstatue (id, nomstatue)values ('6', 'completed');

--Insertion catalogoption
insert into catalogoption (id,nomoption, engagmentmin, engagmentmax)values (1,'InvPer', 500, 1000);
insert into catalogoption (id,nomoption, engagmentmin, engagmentmax)values (2,'Don', 1, 100);
insert into catalogoption (id,nomoption, engagmentmin, engagmentmax)values (3,'InvCadeau', 500, 1000);


--Insertion projetInvestisementOption
insert into projet_investissement_option (id,nomoption, descriptionoption, catalogoption_id)
values (1,'invper', 'invesstisemment avec partenaire', 1);
insert into projet_investissement_option (id,nomoption, descriptionoption, catalogoption_id)
values (2,'invDon', 'ne gagne rien ', 2);
insert into projet_investissement_option (id,nomoption, descriptionoption, catalogoption_id)
values (3,'InvCadeau', 'invesstisemment avec cadeau', 3);



-- --INSERTION investisseent:
-- insert into investissement(sommeengage, ts, projet_investissement_option_id, utilisateur_id, projet_id)
-- values ('1000', now(), 1, 2, 1);
-- insert into investissement(sommeengage, ts, projet_investissement_option_id, utilisateur_id, projet_id)
-- values ('500', now(), 3, 2, 3);
-- insert into investissement(sommeengage, ts, projet_investissement_option_id, utilisateur_id, projet_id)
-- values ('1', now(), 2, 1, 51);

