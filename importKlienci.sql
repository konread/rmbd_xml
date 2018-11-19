/*
    PROCEDURE 1
*/

CREATE OR REPLACE PROCEDURE zaladujKlientow
IS
    x XMLType := XMLType(
    '<?xml version="1.0" encoding="UTF-8"?>
    <Klienci>
        <Klient>
            <id_klienta>1</id_klienta>
            <pesel>00000000000</pesel>
            <imie>Jan</imie>
            <nazwisko>Kowalski</nazwisko>
        </Klient>
        <Klient>
            <id_klienta>2</id_klienta>
            <pesel>11111111111</pesel>
            <imie>Patryk</imie>
            <nazwisko>Nowak</nazwisko>
        </Klient>
        <Klient>
            <id_klienta>3</id_klienta>
            <pesel>22222222222</pesel>
            <imie>Piotr</imie>
            <nazwisko>Wisniewski</nazwisko>
        </Klient>
        <Klient>
            <id_klienta>4</id_klienta>
            <pesel>33333333333</pesel>
            <imie>Robert</imie>
            <nazwisko>Lewandowski</nazwisko>
        </Klient>
        <Klient>
            <id_klienta>5</id_klienta>
            <pesel>44444444444</pesel>
            <imie>Kamil</imie>
            <nazwisko>Glik</nazwisko>
        </Klient>
        <Klient>
            <id_klienta>6</id_klienta>
            <pesel>55555555555</pesel>
            <imie>Jerzy</imie>
            <nazwisko>Dudek</nazwisko>
        </Klient>
        <Klient>
            <id_klienta>7</id_klienta>
            <pesel>66666666666</pesel>
            <imie>Adam</imie>
            <nazwisko>Nawalka</nazwisko>
        </Klient>
        <Klient>
            <id_klienta>8</id_klienta>
            <pesel>77777777777</pesel>
            <imie>Jakub</imie>
            <nazwisko>Blaszczykowski</nazwisko>
        </Klient>
        <Klient>
            <id_klienta>9</id_klienta>
            <pesel>88888888888</pesel>
            <imie>Arkadiusz</imie>
            <nazwisko>Milik</nazwisko>
        </Klient>
        <Klient>
            <id_klienta>10</id_klienta>
            <pesel>99999999999</pesel>
            <imie>Kamil</imie>
            <nazwisko>Grosicki</nazwisko>
        </Klient>
    </Klienci>');
    
    BEGIN
        FOR r IN (
            SELECT ExtractValue(Value(p),'/Klient/id_klienta/text()') as id_klienta
            ,ExtractValue(Value(p),'/Klient/pesel/text()') as pesel
            ,ExtractValue(Value(p),'/Klient/imie/text()') as imie
            ,ExtractValue(Value(p),'/Klient/nazwisko/text()') as nazwisko
        FROM TABLE(XMLSequence(Extract(x,'/Klienci/Klient'))) p
        ) LOOP
            INSERT INTO Klienci(id_klienta, pesel, imie, nazwisko) VALUES(r.id_klienta, r.pesel, r.imie, r.nazwisko);
        END LOOP;
END;

-- TEST -->

SELECT 
    *
FROM 
    Klienci;
    
BEGIN
    zaladujklientow;
END;

SELECT 
    *
FROM 
    Klienci;
    
-- TEST <--