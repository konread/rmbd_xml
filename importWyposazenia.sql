/*
    Dodawanie wyposazen do bazy danych
*/

CREATE OR REPLACE PROCEDURE zaladujWyposazenia
IS
    x XMLType := XMLType(
    '<?xml version="1.0" encoding="UTF-8"?>
    <Wyposazenia>
        <Wyposazenie>
            <id_wyposazenia>1</id_wyposazenia>
            <nazwa>telewizor</nazwa>
            <liczba_szt_calk>3</liczba_szt_calk>
            <liczba_szt_dost>2</liczba_szt_dost>
        </Wyposazenie>
        <Wyposazenie>
            <id_wyposazenia>2</id_wyposazenia>
            <nazwa>parking</nazwa>
            <liczba_szt_calk>10</liczba_szt_calk>
            <liczba_szt_dost>3</liczba_szt_dost>
        </Wyposazenie>
    </Wyposazenia>');
    
    BEGIN
        FOR r IN (
            SELECT ExtractValue(Value(p),'/Wyposazenie/id_wyposazenia/text()') as id_wyposazenia
            ,ExtractValue(Value(p),'/Wyposazenie/nazwa/text()') as nazwa
            ,ExtractValue(Value(p),'/Wyposazenie/liczba_szt_calk/text()') as liczba_szt_calk
            ,ExtractValue(Value(p),'/Wyposazenie/liczba_szt_dost/text()') as liczba_szt_dost
        FROM TABLE(XMLSequence(Extract(x,'/Wyposazenia/Wyposazenie'))) p
        ) LOOP
            INSERT INTO Wyposazenia(id_wyposazenia, nazwa, liczba_szt_calk, liczba_szt_dost) VALUES(r.id_wyposazenia, r.nazwa, r.liczba_szt_calk, r.liczba_szt_dost);
        END LOOP;
END;

-- TEST -->

SET SERVEROUTPUT ON;

SELECT 
    *
FROM 
    Wyposazenia;
    
BEGIN
    zaladujWyposazenia;
END;

SELECT 
    *
FROM 
    Wyposazenia;

ROLLBACK;

-- TEST <--

/*
    Dodawanie Wyposazenia_pokoi do bazy danych
*/

CREATE OR REPLACE PROCEDURE zaladujWyposazeniaPokoi
IS
    x XMLType := XMLType(
    '<?xml version="1.0" encoding="UTF-8"?>
    <Wyposazenia_pokoi>
        <Wyposazenie_pokoi>
            <id_wyposazenia>1</id_wyposazenia>
            <id_pokoju>10</id_pokoju>
        </Wyposazenie_pokoi>
        <Wyposazenie_pokoi>
            <id_wyposazenia>2</id_wyposazenia>
            <id_pokoju>10</id_pokoju>
        </Wyposazenie_pokoi>
        <Wyposazenie_pokoi>
            <id_wyposazenia>2</id_wyposazenia>
            <id_pokoju>9</id_pokoju>
        </Wyposazenie_pokoi>
        <Wyposazenie_pokoi>
            <id_wyposazenia>2</id_wyposazenia>
            <id_pokoju>8</id_pokoju>
        </Wyposazenie_pokoi>
        <Wyposazenie_pokoi>
            <id_wyposazenia>2</id_wyposazenia>
            <id_pokoju>7</id_pokoju>
        </Wyposazenie_pokoi>
        <Wyposazenie_pokoi>
            <id_wyposazenia>2</id_wyposazenia>
            <id_pokoju>6</id_pokoju>
        </Wyposazenie_pokoi>
        <Wyposazenie_pokoi>
            <id_wyposazenia>2</id_wyposazenia>
            <id_pokoju>5</id_pokoju>
        </Wyposazenie_pokoi>
        <Wyposazenie_pokoi>
            <id_wyposazenia>2</id_wyposazenia>
            <id_pokoju>4</id_pokoju>
        </Wyposazenie_pokoi>
    </Wyposazenia_pokoi>');
    
    BEGIN
        FOR r IN (
            SELECT ExtractValue(Value(p),'/Wyposazenie_pokoi/id_wyposazenia/text()') as id_wyposazenia
            ,ExtractValue(Value(p),'/Wyposazenie_pokoi/id_pokoju/text()') as id_pokoju
        FROM TABLE(XMLSequence(Extract(x,'/Wyposazenia_pokoi/Wyposazenie_pokoi'))) p
        ) LOOP
            INSERT INTO Wyposazenia_pokoi(id_wyposazenia, id_pokoju) VALUES(r.id_wyposazenia, r.id_pokoju);
        END LOOP;
END;

-- TEST -->

SET SERVEROUTPUT ON;

SELECT 
    *
FROM 
    Wyposazenia_pokoi;
    
BEGIN
    zaladujWyposazeniaPokoi;
END;

SELECT 
    *
FROM 
    Wyposazenia_pokoi;

ROLLBACK;

-- TEST <--