-- function pour vérifier le createur si il est chef ou non

CREATE OR REPLACE FUNCTION verifyRole()
    RETURNS trigger AS
$$
DECLARE
    myrec          integer;
    val            integer;
    roleUtlisateur varchar(15);
BEGIN

    val = new.utilisateur_id;

    SELECT participer.role_id into myrec
    FROM participer
    WHERE participer.utilisateur_id = val
      and participer.equipe_id = new.equipe_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'utilisateur % not found',myrec;
    END IF;

    select role.role into roleUtlisateur from role where role.id = myrec;

    IF myrec <> 1 THEN
        RAISE EXCEPTION 'le role du créateur de ce projet est --> %', roleUtlisateur
            USING HINT = 'Le role d un createur du projet doit etre chef ';
    ELSE
        RAISE NOTICE 'le role de l utilisateur est CHEF';
    END IF;

    RETURN NEW;
END;
$$
    LANGUAGE 'plpgsql';

CREATE TRIGGER verifyRole_trigger
    BEFORE INSERT
    ON projet
    FOR EACH ROW
EXECUTE PROCEDURE verifyRole();


--  drop trigger test_trigger on projet;

CREATE OR REPLACE FUNCTION init()
    RETURNS trigger AS
$$
DECLARE
    commission numeric;

BEGIN

    commission = (new.bute * 5) / 100;
    new.investiseuractuel = 0;
    new.projetstatue_id = 1;
    new.commission = commission;
    new.sommecollecte = -commission;
    RAISE NOTICE 'La commission de se projet est : --> % £', commission;


    RETURN NEW;
END;
$$
    LANGUAGE 'plpgsql';

CREATE TRIGGER init_trigger
    BEFORE INSERT
    ON projet
    FOR EACH ROW
EXECUTE PROCEDURE init();


--

CREATE OR REPLACE FUNCTION equipeVerification()
    RETURNS trigger AS
$$
DECLARE
    myrec            integer;
    val              integer;
    equipeUtlisateur varchar(15);
BEGIN

    val = new.utilisateur_id;

    SELECT participer.equipe_id into myrec
    FROM participer
    WHERE participer.utilisateur_id = val
      and participer.equipe_id = new.equipe_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'utilisateur % not found',myrec;
    END IF;

    select nomequipe into equipeUtlisateur from equipe where equipe.id = new.equipe_id;


    IF myrec <> new.equipe_id THEN
        RAISE EXCEPTION 'l utilisateur n est pas un membre de l equipe --> %', equipeUtlisateur
            USING HINT = 'Il doit etre un membre de cette equipe ';
    ELSE
        RAISE NOTICE 'Equipe de l ulilisateur est %',equipeUtlisateur;
    END IF;

    RETURN NEW;
END;
$$
    LANGUAGE 'plpgsql';

CREATE TRIGGER equipeVerification_trigger
    BEFORE INSERT
    ON projet
    FOR EACH ROW
EXECUTE PROCEDURE equipeVerification();



CREATE OR REPLACE FUNCTION Historique()
    RETURNS trigger AS
$$
DECLARE

BEGIN
    --     IF (new.bute <> OLD.bute) or (NEW.datefin <> OLD.datefin) THEN
    insert into parametres(datefin, bute, ts, projet_id) values (new.datefin, new.bute, current_timestamp, new.id);
    --     end if;
    RETURN NEW;

END;
$$
    LANGUAGE 'plpgsql';

drop trigger Historique_trigger on projet;

CREATE TRIGGER Historique_trigger
    AFTER INSERT or update
    ON projet
    FOR EACH ROW
EXECUTE PROCEDURE Historique();

----------------------


CREATE OR REPLACE FUNCTION audit_projet() RETURNS TRIGGER AS
$emp_audit$
DECLARE
    commission    numeric;
    sommecollecte numeric;

BEGIN

    IF (TG_OP = 'DELETE') THEN
        RAISE NOTICE 'DELETE %',old.id;
        delete from parametres where parametres.projet_id = old.id;
        delete from archivagestatue where archivagestatue.projet_id = old.id;
        if old.sommecollecte < 0 then
            raise exception 'vous devez payer voter commision avant de supprimer votre projet';
        end if;
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        RAISE NOTICE 'UPDATE';
        RAISE NOTICE '%',old.sommecollecte;
        RAISE NOTICE '%',old.commission;
        RAISE NOTICE '%',old.bute;
        commission = (new.bute * 5) / 100;
        new.commission = commission;
        new.sommecollecte = new.sommecollecte - (commission - old.commission);
        RAISE NOTICE 'La commission de se projet est : --> %€', commission;
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        RAISE NOTICE 'INSERT';
        commission = ((new.bute) * 5) / 100;
        new.investiseuractuel = 0;
        new.projetstatue_id = 1;
        new.commission = commission;
        new.sommecollecte = -commission;
        RAISE NOTICE 'La nouvelle commission de se projet est : --> %€', commission;
        RETURN NEW;
    END IF;
    RETURN NULL;
    -- le résultat est ignoré car il s'agit d'un trigger AFTER
END;
$emp_audit$ language plpgsql;

DROP TRIGGER projetAudit_trigger ON projet;
CREATE TRIGGER projetAudit_trigger
    BEFORE INSERT OR UPDATE OR DELETE
    ON projet
    FOR EACH ROW
EXECUTE PROCEDURE audit_projet();



CREATE OR REPLACE FUNCTION audit_archivage() RETURNS TRIGGER AS
$emp_audit$
declare
    pourcentage numeric;

BEGIN
    pourcentage = (new.sommecollecte / new.bute) * 100;
    RAISE NOTICE 'pourcentage %',pourcentage;

    IF (TG_OP = 'DELETE') THEN
    ELSIF (TG_OP = 'UPDATE') THEN
        if (pourcentage <= 0) then
            insert into archivagestatue(projet_id, ts, projetstatue_id) values (new.id, current_timestamp, 1);
        elsif (pourcentage > 1 and pourcentage < 10) then
            insert into archivagestatue(projet_id, ts, projetstatue_id) values (new.id, current_timestamp, 2);
        elsif (pourcentage > 10 and pourcentage < 50) then
            insert into archivagestatue(projet_id, ts, projetstatue_id) values (new.id, current_timestamp, 3);
        elsif (pourcentage = 50) then
            insert into archivagestatue(projet_id, ts, projetstatue_id) values (new.id, current_timestamp, 4);
        elsif (pourcentage > 50 and pourcentage < 100) then
            insert into archivagestatue(projet_id, ts, projetstatue_id) values (new.id, current_timestamp, 5);
        elsif (pourcentage >= 100) then
            insert into archivagestatue(projet_id, ts, projetstatue_id) values (new.id, current_timestamp, 6);
        end if;
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        insert into archivagestatue(projet_id, ts, projetstatue_id) values (new.id, current_timestamp, 1);
        RETURN NEW;
    END IF;
    RETURN NULL; -- le résultat est ignoré car il s'agit d'un trigger AFTER
END;
$emp_audit$ language plpgsql;

drop trigger archivageAudit_trigger on projet;
CREATE TRIGGER archivageAudit_trigger
    AFTER INSERT OR UPDATE
    ON projet
    FOR EACH ROW
EXECUTE PROCEDURE audit_archivage();



CREATE OR REPLACE FUNCTION rembourcement()
    RETURNS trigger AS
$$
DECLARE
    r              investissement%ROWTYPE;
BEGIN

    FOR r IN
        SELECT *
        FROM investissement m
        where m.projet_id = old.id
        ORDER BY m.id, m.utilisateur_id
        LOOP
            raise notice 'id % ',r.id;

            if old.sommecollecte < old.bute then
                insert into rembourcement (sommerembource, ts, utilisateur_id)
                values (r.sommeengage, now(), r.utilisateur_id);
            end if;

            delete from investissement where investissement.id = r.id;

        END LOOP;


    RETURN old;
END;
$$
    LANGUAGE 'plpgsql';

drop trigger rembourcement_trigger on projet;

CREATE TRIGGER rembourcement_trigger
    before delete
    ON projet
    FOR EACH ROW
EXECUTE PROCEDURE rembourcement();


-- investissement_trigger:

create or replace function addInvToSomme() returns trigger as
$$
declare
    sommeInv numeric;
    sommeMax numeric;
    sommeMin numeric;
    idOption integer;
begin
    sommeInv = new.sommeengage;
    select projet_investissement_option.catalogoption_id into idOption
    from projet_investissement_option
    where projet_investissement_option.id = new.projet_investissement_option_id;
    select catalogoption.engagmentmax,
           catalogoption.engagmentmin
           into sommeMax,sommeMin
    from catalogoption
    where catalogoption.id = idOption;

    raise notice 'somemax %',sommeMax;
    raise notice 'somemax %',sommeMin;

    if (new.sommeengage < sommeMin or new.sommeengage > sommeMax) then
        raise exception 'vous devez verifier votre somme';
    end if;

    update projet set sommecollecte=sommecollecte + sommeInv where projet.id = new.projet_id;
    update projet set investiseuractuel=investiseuractuel + 1 where projet.id = new.projet_id;

    return new;
end;
$$
    language 'plpgsql';

create trigger addInvToSommeTrigger
    after insert or update
    on investissement
    for each row
execute procedure addInvToSomme();



CREATE OR REPLACE FUNCTION dateLimite()
    RETURNS trigger AS
$$
DECLARE
    r              projet%ROWTYPE;
    datelimit     timestamp;
BEGIN
    SELECT new.date INTO datelimit FROM dateTable WHERE id = 1;
    raise notice 'la date d aujourd''hui % ',datelimit;

    FOR r IN
        SELECT *
        FROM projet m
        where m.datefin < datelimit
        ORDER BY m.id, m.utilisateur_id
        LOOP
            raise notice 'id % ',r.id;
            if (r.sommecollecte>=0) then
                delete from projet where projet.id = r.id;
            end if;
        END LOOP;
    RETURN old;
END;
$$
    LANGUAGE 'plpgsql';

drop trigger rembourcement_trigger on projet;

CREATE TRIGGER dateLimite_trigger
    after update
    ON datetable
    FOR EACH ROW
EXECUTE PROCEDURE dateLimite();
