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
    WHERE participer.utilisateur_id = val;

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
    WHERE participer.utilisateur_id = val;

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
    insert into parametres(datefin, bute, ts, projet_id) values (new.datefin, new.bute, current_timestamp, new.id);
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
    commission numeric;
    sommecollecte numeric;

BEGIN

    IF (TG_OP = 'DELETE') THEN
        RAISE NOTICE 'DELETE %',old.id;

    delete from parametres where parametres.projet_id = old.id;
    if old.sommecollecte < 0 then
            raise exception 'vous devez payer voter commision avant de supprimer votre projet';
        end if;
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        RAISE NOTICE 'UPDATE';
        RAISE NOTICE '%',old.sommecollecte;
        RAISE NOTICE '%',old.commission;
        RAISE NOTICE '%',old.bute;
        commission = (new.bute* 5) / 100;
        new.commission = commission;
        new.sommecollecte =new.sommecollecte-(commission-old.commission);
        RAISE NOTICE 'La commission de se projet est : --> %€', commission;
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        RAISE NOTICE 'INSERT';
        commission = ((new.bute)* 5) / 100;
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



CREATE OR REPLACE FUNCTION audit_archivage() RETURNS TRIGGER AS $emp_audit$
BEGIN
    --
    -- Ajoute une ligne dans emp_audit pour refléter l'opération réalisée
    -- sur emp,
    -- utilise la variable spéciale TG_OP pour cette opération.
    --
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO emp_audit SELECT 'D', now(), user, OLD.*;
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        insert into archivagestatue(projet_id, ts, projetstatue_id) values (new.id,current_timestamp,new.projetstatue_id);
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        insert into archivagestatue(projet_id, ts, projetstatue_id) values (new.id,current_timestamp,new.projetstatue_id);
        RETURN NEW;
    END IF;
    RETURN NULL; -- le résultat est ignoré car il s'agit d'un trigger AFTER
END;
$emp_audit$ language plpgsql;

CREATE TRIGGER archivageAudit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON projet
    FOR EACH ROW EXECUTE PROCEDURE audit_archivage();