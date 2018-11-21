/*
    Dodawanie pokoi do bazy danych
*/

CREATE OR REPLACE PROCEDURE zaladujPokoje
IS
    x XMLType := XMLType(
    '<?xml version="1.0" encoding="UTF-8"?>
    <Pokoje>
        <Pokoj>
            <id_pokoju>1</id_pokoju>
            <numer>100</numer>
            <liczba_osob>1</liczba_osob>
            <status>W</status>
        </Pokoj>
        <Pokoj>
            <id_pokoju>2</id_pokoju>
            <numer>101</numer>
            <liczba_osob>1</liczba_osob>
            <status>W</status>
        </Pokoj>
        <Pokoj>
            <id_pokoju>3</id_pokoju>
            <numer>102</numer>
            <liczba_osob>1</liczba_osob>
            <status>W</status>
        </Pokoj>
        <Pokoj>
            <id_pokoju>4</id_pokoju>
            <numer>103</numer>
            <liczba_osob>2</liczba_osob>
            <status>W</status>
        </Pokoj>
        <Pokoj>
            <id_pokoju>5</id_pokoju>
            <numer>104</numer>
            <liczba_osob>2</liczba_osob>
            <status>W</status>
        </Pokoj>
        <Pokoj>
            <id_pokoju>6</id_pokoju>
            <numer>105</numer>
            <liczba_osob>2</liczba_osob>
            <status>W</status>
        </Pokoj>
        <Pokoj>
            <id_pokoju>7</id_pokoju>
            <numer>106</numer>
            <liczba_osob>3</liczba_osob>
            <status>W</status>
        </Pokoj>
        <Pokoj>
            <id_pokoju>8</id_pokoju>
            <numer>107</numer>
            <liczba_osob>3</liczba_osob>
            <status>W</status>
        </Pokoj>
        <Pokoj>
            <id_pokoju>9</id_pokoju>
            <numer>108</numer>
            <liczba_osob>3</liczba_osob>
            <status>W</status>
        </Pokoj>
        <Pokoj>
            <id_pokoju>10</id_pokoju>
            <numer>109</numer>
            <liczba_osob>4</liczba_osob>
            <status>W</status>
        </Pokoj>
    </Pokoje>');
    
    BEGIN
        FOR r IN (
            SELECT ExtractValue(Value(p),'/Pokoj/id_pokoju/text()') as id_pokoju
            ,ExtractValue(Value(p),'/Pokoj/numer/text()') as numer
            ,ExtractValue(Value(p),'/Pokoj/liczba_osob/text()') as liczba_osob
            ,ExtractValue(Value(p),'/Pokoj/status/text()') as status
        FROM TABLE(XMLSequence(Extract(x,'/Pokoje/Pokoj'))) p
        ) LOOP
            INSERT INTO Pokoje(id_pokoju, numer, liczba_osob, status) VALUES(r.id_pokoju, r.numer, r.liczba_osob, r.status);
        END LOOP;
END;

-- TEST -->

SET SERVEROUTPUT ON;

SELECT 
    *
FROM 
    Pokoje;
    
BEGIN
    zaladujPokoje;
END;

SELECT 
    *
FROM 
    Pokoje;

ROLLBACK;

-- TEST <--