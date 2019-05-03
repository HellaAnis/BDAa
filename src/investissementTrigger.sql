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
    return new;
end;
$$
    language 'plpgsql';

create trigger addInvToSommeTrigger
    after insert or update
    on investissement
    for each row
execute procedure addInvToSomme();
