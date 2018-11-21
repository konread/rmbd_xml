/*
    Dodawanie rezerwacji do bazy danych
*/

CREATE OR REPLACE PROCEDURE zaladujRezerwacje
IS
    x XMLType := XMLType(
    '<?xml version="1.0" encoding="UTF-8"?>
    <Rezerwacje>
        <Rezerwacja>
            <id_rezerwacji>1</id_rezerwacji>
            <data_rezerwacji>2018-08-12</data_rezerwacji>
            <data_przyjazdu>2018-08-20</data_przyjazdu>
            <data_wyjazdu>2018-09-02</data_wyjazdu>
            <status>N</status>
            <id_klienta>1</id_klienta>
            <id_pokoju>8</id_pokoju>
        </Rezerwacja>
        <Rezerwacja>
            <id_rezerwacji>2</id_rezerwacji>
            <data_rezerwacji>2018-08-20</data_rezerwacji>
            <data_przyjazdu>2018-09-10</data_przyjazdu>
            <data_wyjazdu>2018-09-24</data_wyjazdu>
            <status>N</status>
            <id_klienta>4</id_klienta>
            <id_pokoju>6</id_pokoju>
        </Rezerwacja>
        <Rezerwacja>
            <id_rezerwacji>3</id_rezerwacji>
            <data_rezerwacji>2018-08-22</data_rezerwacji>
            <data_przyjazdu>2018-09-11</data_przyjazdu>
            <data_wyjazdu>2018-09-28</data_wyjazdu>
            <status>N</status>
            <id_klienta>5</id_klienta>
            <id_pokoju>5</id_pokoju>
        </Rezerwacja>
        <Rezerwacja>
            <id_rezerwacji>4</id_rezerwacji>
            <data_rezerwacji>2018-08-23</data_rezerwacji>
            <data_przyjazdu>2018-09-09</data_przyjazdu>
            <data_wyjazdu>2018-09-22</data_wyjazdu>
            <status>N</status>
            <id_klienta>9</id_klienta>
            <id_pokoju>1</id_pokoju>
        </Rezerwacja>
        <Rezerwacja>
            <id_rezerwacji>5</id_rezerwacji>
            <data_rezerwacji>2018-09-02</data_rezerwacji>
            <data_przyjazdu>2018-09-12</data_przyjazdu>
            <data_wyjazdu>2018-09-22</data_wyjazdu>
            <status>N</status>
            <id_klienta>6</id_klienta>
            <id_pokoju>10</id_pokoju>
        </Rezerwacja>
        <Rezerwacja>
            <id_rezerwacji>6</id_rezerwacji>
            <data_rezerwacji>2018-10-02</data_rezerwacji>
            <data_przyjazdu>2018-10-12</data_przyjazdu>
            <data_wyjazdu>2018-10-22</data_wyjazdu>
            <status>N</status>
            <id_klienta>5</id_klienta>
            <id_pokoju>5</id_pokoju>
        </Rezerwacja>
    </Rezerwacje>');
    
    BEGIN
        FOR r IN (
            SELECT ExtractValue(Value(p),'/Rezerwacja/id_rezerwacji/text()') as id_rezerwacji
            ,ExtractValue(Value(p),'/Rezerwacja/data_rezerwacji/text()') as data_rezerwacji
            ,ExtractValue(Value(p),'/Rezerwacja/data_przyjazdu/text()') as data_przyjazdu
            ,ExtractValue(Value(p),'/Rezerwacja/data_wyjazdu/text()') as data_wyjazdu
            ,ExtractValue(Value(p),'/Rezerwacja/status/text()') as status
            ,ExtractValue(Value(p),'/Rezerwacja/id_klienta/text()') as id_klienta
            ,ExtractValue(Value(p),'/Rezerwacja/id_pokoju/text()') as id_pokoju
        FROM TABLE(XMLSequence(Extract(x,'/Rezerwacje/Rezerwacja'))) p
        ) LOOP
            INSERT INTO Rezerwacje(id_rezerwacji, data_rezerwacji, data_przyjazdu, data_wyjazdu, status, id_klienta, id_pokoju) VALUES(r.id_rezerwacji, r.data_rezerwacji, r.data_przyjazdu, r.data_wyjazdu, r.status, r.id_klienta, r.id_pokoju);
        END LOOP;
END;

-- TEST -->

SET SERVEROUTPUT ON;

SELECT 
    *
FROM 
    Rezerwacje;
    
BEGIN
    zaladujRezerwacje;
END;

SELECT 
    *
FROM 
    Rezerwacje;

ROLLBACK;

-- TEST <--