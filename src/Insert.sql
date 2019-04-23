-- INSERTION Utilisateur :
-- insert into utilisateur(nom, prenom, pseudo, motdepasse, email, projets_supporte, montanttotale) values
--                                             ('zinou','merred','adlen','1995','anishella24@gmail.com','1','0')

-- INSERTION Participer:
insert into participer(utilisateur_id, equipe_id, role_id) VALUES ('4','1','2');

-- INSERTION Equipe:
insert into equipe(nombreequipe, nomequipe) VALUES ('5','paris7');
insert into equipe(nombreequipe, nomequipe) VALUES ('3','paris6');


-- INSERTION Role:
insert into  role(role) VALUES ('DEVELOPPEUR');

-- INSERTION Projet:
insert into projet (nomprojet, description, location, datedebut, datefin, bute, investiseuractuel ,utilisateur_id,projetstatue_id ,sommecollecte, equipe_id, commission)
 values ('bda','projet d"etude','paris7','20/10/2019','20/11/2019','190','0','1','1','0','1','1');

insert into projet (nomprojet, description, location, datedebut, datefin, bute ,utilisateur_id, equipe_id)
values ('bda','projet d"etude','paris7','20/10/2019','20/11/2019','200','1','1');

update projet SET bute = 1000 where utilisateur_id=1;
update projet set sommecollecte =sommecollecte+20 where id=2;
update projet set datefin= '30/10/2019' where id=42;

DELETE from projet where id =2;

-- INSERTION Statues:
-- insert into projetstatue (nomstatue)
-- values ('Create');