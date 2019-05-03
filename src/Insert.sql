-- INSERTION Utilisateur :
insert into utilisateur(nom, prenom, pseudo, motdepasse, email, projets_supporte) values
('zinou','merred','adlen','1995','zinouadllen24@gmail.com','1');
insert into utilisateur(nom, prenom, pseudo, motdepasse, email, projets_supporte) values
('Anis','hellal','nisou','1995','anishella24@gmail.com','1');
insert into utilisateur(nom, prenom, pseudo, motdepasse, email, projets_supporte) values
('zaki','zikou','Zak','1993','zakzikou24@gmail.com','1');


-- INSERTION Equipe:
insert into equipe(nombreequipe, nomequipe)VALUES ('5', 'paris7');
insert into equipe(nombreequipe, nomequipe)VALUES ('3', 'paris6');
insert into equipe(nombreequipe, nomequipe)VALUES ('3', 'paris8');

-- INSERTION Participer:
insert into participer(utilisateur_id, equipe_id, role_id)VALUES ('4', '1', '2');
insert into participer(utilisateur_id, equipe_id, role_id)VALUES ('4', '2', '1');
insert into participer(utilisateur_id, equipe_id, role_id)VALUES ('1', '1', '2');

-- INSERTION Role:
insert into role(role)
VALUES ('DEVELOPPEUR');


-- INSERTION Projet:
insert into projet (nomprojet, description, location, datedebut, datefin, bute, investiseuractuel, utilisateur_id,
                    projetstatue_id, sommecollecte, equipe_id, commission)
values ('bda', 'projet d"etude', 'paris7', '20/10/2019', '20/11/2019', '190', '0', '1', '1', '0', '1', '1');

insert into projet (nomprojet, description, location, datedebut, datefin, bute, utilisateur_id, equipe_id)
values ('bda', 'projet d"etude', 'paris8', '20/10/2019', '20/11/2019', '200', '1', '1');

update projet
SET bute = 1600
where id=48;

update projet
set sommecollecte =sommecollecte + 90
where id = 38;

update projet
set datefin= '30/12/2019'
where id = 47;

DELETE
from projet
where id = 51;

-- INSERTION Statues:
insert into projetstatue (id, nomstatue)values ('1', 'Not stared yet');
insert into projetstatue (id, nomstatue)values ('2', 'Started');
insert into projetstatue (id, nomstatue)values ('3', 'working on it');
insert into projetstatue (id, nomstatue)values ('4', 'Half');
insert into projetstatue (id, nomstatue)values ('5', 'Near of completed');
insert into projetstatue (id, nomstatue)values ('6', 'completed');

update projetstatue
set nomstatue='not stared yet'
where id = 1;


--INSERTION investisseent:
insert into investissement(sommeengage, ts, projet_investissement_option_id, utilisateur_id, projet_id)
values ('1', now(), 2, 1, 51);

--Insertion catalogoption
insert into catalogoption (nomoption, engagmentmin, engagmentmax)
values ('InvPer', 500, 1000);

insert into projet_investissement_option (nomoption, descriptionoption, catalogoption_id)
values ('invper', 'invesstisemment avec partenaire', 2);