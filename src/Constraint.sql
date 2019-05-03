-- les contraintes d'intégrite

--constraint de verificetion des projet supporter
ALTER table utilisateur add constraint price_discount_check CHECK (
        projets_supporte > 0);

--constraint de verification des dates
alter table projet drop constraint  date_verify_check;
ALTER table projet ADD constraint date_verify_check check
(datefin > datedebut and datedebut >= current_date);

create index test_index ON projet using hash (id);

SELECT
    tablename,
    indexname,
    indexdef,
    indextype
FROM
    pg_indexes
WHERE
        schemaname = 'public'
ORDER BY
    tablename,
    indexname;

select * from    pg_indexes;







