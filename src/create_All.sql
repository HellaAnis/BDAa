

create table projetstatue
(
    id        serial      not null
        constraint "p.ProjetStatue_pk"
            primary key,
    nomstatue varchar(64) not null
        constraint project_status_ak_1
            unique
);

alter table projetstatue
    owner to postgres;

create table utilisateur
(
    id               serial       not null
        constraint "p.Utilisateur_pk"
            primary key,
    nom              varchar(64)  not null,
    prenom           varchar(64)  not null,
    pseudo           varchar(128) not null
        constraint user_account_ak_1
            unique,
    motdepasse       varchar(255) not null,
    email            varchar(128) not null
        constraint user_account_ak_2
            unique,
    projets_supporte integer      not null
        constraint price_discount_check
            check (projets_supporte > 0)
);

alter table utilisateur
    owner to postgres;

create table catalogoption
(
    id           serial         not null
        constraint "p.catalogOption_pk"
            primary key,
    nomoption    varchar(255)   not null
        constraint investment_option_catalog_ak_1
            unique,
    engagmentmin numeric(12, 2) not null,
    engagmentmax numeric(12, 2) not null
);

alter table catalogoption
    owner to postgres;

create table equipe
(
    id           serial      not null
        constraint "p.equipe_pk"
            primary key,
    nombreequipe integer     not null,
    nomequipe    varchar(64) not null
);

alter table equipe
    owner to postgres;

create table projet
(
    id                serial         not null
        constraint "p.projet_pk"
            primary key,
    nomprojet         varchar(255)   not null,
    description       text           not null,
    location          text           not null,
    datedebut         date           not null,
    datefin           date           not null,
    bute              numeric(12, 2) not null,
    sommecollecte     numeric(12, 2) not null,
    investiseuractuel integer        not null,
    utilisateur_id    integer        not null
        constraint fk_projet_utilisateur1
            references utilisateur,
    projetstatue_id   integer        not null
        constraint fk_projet_projetstatue1
            references projetstatue,
    equipe_id         integer        not null
        constraint fk_projet_equipe1
            references equipe,
    commission        numeric(12, 2) not null,
    constraint date_verify_check
        check ((datefin > datedebut) AND (datedebut >= CURRENT_DATE))
);

alter table projet
    owner to postgres;

create table archivagestatue
(
    id              serial    not null
        constraint "p.archivageStatue_pk"
            primary key,
    projet_id       integer   not null
        constraint project_status_history_project
            references projet,
    ts              timestamp not null,
    projetstatue_id integer   not null
        constraint fk_archivagestatue_projetstatue1
            references projetstatue
);

alter table archivagestatue
    owner to postgres;

create table parametres
(
    id        serial         not null
        constraint "p.parametres_pk"
            primary key,
    datefin   date           not null,
    bute      numeric(12, 2) not null,
    ts        timestamp      not null,
    projet_id integer        not null
        constraint fk_parametres_projet1
            references projet
);

alter table parametres
    owner to postgres;

create table projet_investissement_option
(
    id                serial       not null
        constraint "p.projet_investissement_option_pk"
            primary key,
    nomoption         varchar(255) not null,
    descriptionoption text         not null,
    catalogoption_id  integer      not null
        constraint fk_projet_investissement_option_catalogoption1
            references catalogoption
);

alter table projet_investissement_option
    owner to postgres;

create table investissement
(
    id                              serial         not null,
    sommeengage                     numeric(12, 2) not null,
    ts                              timestamp      not null,
    projet_investissement_option_id integer        not null
        constraint fk_investissement_projet_investissement_option1
            references projet_investissement_option,
    utilisateur_id                  integer        not null
        constraint fk_investissement_utilisateur1
            references utilisateur,
    projet_id                       integer        not null
        constraint investissement_projet
            references projet,
    constraint "p.investissement_pk"
        primary key (id, projet_id)
);

alter table investissement
    owner to postgres;

create table rembourcement
(
    id             serial    not null
        constraint "p.rembourcement_pk"
            primary key,
    sommerembource numeric(12, 2),
    ts             timestamp not null,
    utilisateur_id integer   not null
        constraint fk_rembourcement_utilisateur1
            references utilisateur
);

alter table rembourcement
    owner to postgres;


create table role
(
    id   serial      not null
        constraint "p.role_pk"
            primary key,
    role varchar(64) not null
);

alter table role
    owner to postgres;

create table participer
(
    utilisateur_id integer not null
        constraint fk_participant_has_project_team_utilisateur1
            references utilisateur,
    equipe_id      integer not null
        constraint fk_participant_has_project_team_equipe1
            references equipe,
    role_id        integer not null
        constraint fk_participer_role1
            references role,
    constraint "p.participer_pk"
        primary key (utilisateur_id, equipe_id)
);

alter table participer
    owner to postgres;

create table datetable
(
    id   serial not null
        constraint datetable_pkey
            primary key,
    date timestamp
);

alter table datetable
    owner to postgres;


-- les indexs
-- table archivageStatue :
-- utilisation de l'index hash puisque il est plus performent dans la supression utilisant l'id
create index project_status_history_project
    on archivagestatue using hash (projet_id);

create index fk_archivagestatue_projetstatue1_idx
    on archivagestatue (projetstatue_id);

create index fk_parametres_projet1_idx
    on parametres (projet_id);

create index fk_projet_utilisateur1_idx
    on projet (utilisateur_id);

create index fk_projet_projetstatue1_idx
    on projet using hash (projetstatue_id);

create index fk_projet_equipe1_idx
    on projet (equipe_id);

create index projectDateFin_index
    on projet using btree (datefin asc);

create index projectID_index
    on projet using hash (id);

create index fk_investissement_utilisateur1_idx
    on investissement (utilisateur_id);

create index fk_investissement_projetID_idx
    on investissement using hash (projet_id);

create index pk_investissement_ID_idx
    on investissement using hash (id);

create index fk_projet_investissement_option_catalogoption1_idx
    on projet_investissement_option (catalogoption_id);

create index fk_participant_has_project_team_equipe1_idx
    on participer using hash (equipe_id);

create index fk_participer_role1_idx
    on participer using hash (role_id);

create index fk_rembourcement_utilisateur1_idx
    on rembourcement (utilisateur_id);

create index simulationDate_index on datetable using btree (date asc);


