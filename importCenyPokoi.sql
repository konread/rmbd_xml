/*
    Dodawanie Ceny pokoi do bazy danych
*/

CREATE OR REPLACE PROCEDURE zaladujCenyPokoi
IS
    x XMLType := XMLType(
    '<?xml version="1.0" encoding="UTF-8"?>
    <Ceny_pokoi>
        <Cena_pokoju>
            <id_ceny_pokoju>1</id_ceny_pokoju>
            <cena>150</cena>
            <data_obowiazywania_od>2018-05-10</data_obowiazywania_od>
            <data_obowiazywania_do></data_obowiazywania_do>
            <id_pokoju>1</id_pokoju>
            <status>A</status>
        </Cena_pokoju>
        <Cena_pokoju>
            <id_ceny_pokoju>2</id_ceny_pokoju>
            <cena>150</cena>
            <data_obowiazywania_od>2018-04-12</data_obowiazywania_od>
            <data_obowiazywania_do></data_obowiazywania_do>
            <id_pokoju>2</id_pokoju>
            <status>A</status>
        </Cena_pokoju>
        <Cena_pokoju>
            <id_ceny_pokoju>3</id_ceny_pokoju>
            <cena>200</cena>
            <data_obowiazywania_od>2018-06-08</data_obowiazywania_od>
            <data_obowiazywania_do></data_obowiazywania_do>
            <id_pokoju>3</id_pokoju>
            <status>A</status>
        </Cena_pokoju>
        <Cena_pokoju>
            <id_ceny_pokoju>4</id_ceny_pokoju>
            <cena>150</cena>
            <data_obowiazywania_od>2018-01-01</data_obowiazywania_od>
            <data_obowiazywania_do></data_obowiazywania_do>
            <id_pokoju>4</id_pokoju>
            <status>A</status>
        </Cena_pokoju>
        <Cena_pokoju>
            <id_ceny_pokoju>5</id_ceny_pokoju>
            <cena>150</cena>
            <data_obowiazywania_od>2018-05-10</data_obowiazywania_od>
            <data_obowiazywania_do></data_obowiazywania_do>
            <id_pokoju>5</id_pokoju>
            <status>A</status>
        </Cena_pokoju>
        <Cena_pokoju>
            <id_ceny_pokoju>6</id_ceny_pokoju>
            <cena>150</cena>
            <data_obowiazywania_od>2018-04-22</data_obowiazywania_od>
            <data_obowiazywania_do></data_obowiazywania_do>
            <id_pokoju>6</id_pokoju>
            <status>A</status>
        </Cena_pokoju>
        <Cena_pokoju>
            <id_ceny_pokoju>7</id_ceny_pokoju>
            <cena>150</cena>
            <data_obowiazywania_od>2018-03-15</data_obowiazywania_od>
            <data_obowiazywania_do></data_obowiazywania_do>
            <id_pokoju>7</id_pokoju>
            <status>A</status>
        </Cena_pokoju>
        <Cena_pokoju>
            <id_ceny_pokoju>8</id_ceny_pokoju>
            <cena>150</cena>
            <data_obowiazywania_od>2018-08-10</data_obowiazywania_od>
            <data_obowiazywania_do></data_obowiazywania_do>
            <id_pokoju>8</id_pokoju>
            <status>A</status>
        </Cena_pokoju>
        <Cena_pokoju>
            <id_ceny_pokoju>9</id_ceny_pokoju>
            <cena>150</cena>
            <data_obowiazywania_od>2018-07-17</data_obowiazywania_od>
            <data_obowiazywania_do></data_obowiazywania_do>
            <id_pokoju>9</id_pokoju>
            <status>A</status>
        </Cena_pokoju>
        <Cena_pokoju>
            <id_ceny_pokoju>10</id_ceny_pokoju>
            <cena>150</cena>
            <data_obowiazywania_od>2018-02-18</data_obowiazywania_od>
            <data_obowiazywania_do></data_obowiazywania_do>
            <id_pokoju>10</id_pokoju>
            <status>A</status>
        </Cena_pokoju>
    </Ceny_pokoi>');
    
    BEGIN
        FOR r IN (
            SELECT ExtractValue(Value(p),'/Cena_pokoju/id_ceny_pokoju/text()') as id_ceny_pokoju
            ,ExtractValue(Value(p),'/Cena_pokoju/cena/text()') as cena
            ,ExtractValue(Value(p),'/Cena_pokoju/data_obowiazywania_od/text()') as data_obowiazywania_od
            ,ExtractValue(Value(p),'/Cena_pokoju/data_obowiazywania_do/text()') as data_obowiazywania_do
            ,ExtractValue(Value(p),'/Cena_pokoju/id_pokoju/text()') as id_pokoju
            ,ExtractValue(Value(p),'/Cena_pokoju/status/text()') as status
        FROM TABLE(XMLSequence(Extract(x,'/Ceny_pokoi/Cena_pokoju'))) p
        ) LOOP
            INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status) VALUES(r.id_ceny_pokoju, r.cena, r.data_obowiazywania_od, r.data_obowiazywania_do, r.id_pokoju, r.status);
        END LOOP;
END;

-- TEST -->

SET SERVEROUTPUT ON;

SELECT 
    *
FROM 
    Ceny_pokoi;
    
BEGIN
    zaladujCenyPokoi;
END;

SELECT 
    *
FROM 
    Ceny_pokoi;

ROLLBACK;

-- TEST <--