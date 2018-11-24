/*
dodawanie uprawnien
*/
CREATE OR REPLACE DIRECTORY 
    XMLFILES 
AS 
    'C:\Users\Konrad\Desktop\rmbd_xml';
GRANT READ, WRITE ON DIRECTORY XMLFILES TO slaby;
COMMIT;


/*
--------------------------------------------------
odczyt pliku XML
*/
CREATE OR REPLACE FUNCTION odczytPlikuXML(directoryName VARCHAR2, rootNodeName VARCHAR2, childNodeName VARCHAR2)
    RETURN DBMS_XMLDOM.DOMNODELIST
IS
    xmlContent XMLTYPE;
    domNodeList DBMS_XMLDOM.DOMNODELIST;
    
    BEGIN
        xmlContent := XMLType(BFILENAME(directoryName, rootNodeName || '.xml'), nls_charset_id('AL32UTF8'));
        domNodeList := DBMS_XSLPROCESSOR.SELECTNODES(DBMS_XMLDOM.MAKENODE(DBMS_XMLDOM.NEWDOMDOCUMENT(xmlContent)), rootNodeName || '/' || childNodeName);
        RETURN domNodeList;
        
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- TEST -->
SET SERVEROUTPUT ON;

DECLARE
    domNodeList DBMS_XMLDOM.DOMNODELIST;
BEGIN
    domNodeList := odczytPlikuXML('XMLFILES', 'Klienci', 'Klient');
    DBMS_OUTPUT.PUT_LINE(DBMS_XMLDOM.GETLENGTH(domNodeList));
END;

ROLLBACK;
-- TEST <--


/*
--------------------------------------------------
funkcja sprawdzajaca czy w podanym stringu jest poprawna wartosc numeryczna
*/
CREATE OR REPLACE FUNCTION is_number(p_string VARCHAR2)
   RETURN INT
IS
    v_new_num NUMBER;
    BEGIN
        v_new_num := TO_NUMBER(p_string);
        RETURN 1;
        
    EXCEPTION
        WHEN VALUE_ERROR THEN
        RETURN 0;
END;

-- TEST -->
SET SERVEROUTPUT ON;

SELECT is_number('a') FROM dual;

ROLLBACK;
-- TEST <--


/*
--------------------------------------------------
funkcja sprawdzajaca czy w podanym stringu jest poprawna data
*/
CREATE OR REPLACE FUNCTION is_date(p_string VARCHAR2)
   RETURN INT
IS
    v_date date;
    BEGIN
        SELECT TO_DATE(p_string, 'RRRR-MM-DD') into v_date from dual;
        RETURN 1;
    
    EXCEPTION
        WHEN OTHERS THEN
        RETURN 0;
END;

-- TEST -->
SET SERVEROUTPUT ON;

SELECT is_date('2018-01-06') FROM dual;

ROLLBACK;
-- TEST <--


/*
--------------------------------------------------
import pliku XML z klientami
*/
CREATE OR REPLACE PROCEDURE wczytajKlientow(directoryName VARCHAR2)
IS
    domNodeList DBMS_XMLDOM.DOMNODELIST := odczytPlikuXML(directoryName, 'Klienci', 'Klient');
    domNode DBMS_XMLDOM.DOMNODE;
    id_klienta varchar2(100);
    pesel varchar2(100);
    imie varchar2(100);
    nazwisko varchar2(100);
    
    BEGIN
         FOR idx IN 0 .. DBMS_XMLDOM.GETLENGTH(domNodeList) - 1 LOOP
            domNode := DBMS_XMLDOM.ITEM(domNodeList, idx);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'id_klienta/text()',id_klienta);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'pesel/text()',pesel);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'imie/text()',imie);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'nazwisko/text()',nazwisko);
            
            IF is_number(id_klienta) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawne id_klienta! Wartosc nie jest wartoscia numeryczna! Pesel Klienta:' || pesel);
                RETURN;
            END IF;
            
            INSERT INTO Klienci(id_klienta, pesel, imie, nazwisko) VALUES(id_klienta, pesel, imie, nazwisko);
         END LOOP;
  
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- TEST -->
SET SERVEROUTPUT ON;

SELECT * FROM Klienci;

BEGIN
    wczytajKlientow('XMLFILES');
END;

ROLLBACK;
-- TEST <--


/*
--------------------------------------------------
import pliku XML z Pokojami
*/
CREATE OR REPLACE PROCEDURE wczytajPokoje(directoryName VARCHAR2)
IS
    domNodeList DBMS_XMLDOM.DOMNODELIST := odczytPlikuXML(directoryName, 'Pokoje', 'Pokoj');
    domNode DBMS_XMLDOM.DOMNODE;
    id_pokoju VARCHAR2(100);
    numer VARCHAR2(100);
    liczba_osob VARCHAR2(100);
    status VARCHAR2(100);
    
    BEGIN
         FOR idx IN 0 .. DBMS_XMLDOM.GETLENGTH(domNodeList) - 1 LOOP
            domNode := DBMS_XMLDOM.ITEM(domNodeList, idx);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'id_pokoju/text()',id_pokoju);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'numer/text()',numer);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'liczba_osob/text()',liczba_osob);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'status/text()',status);
            
            IF is_number(id_pokoju) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawne id_pokoju! Wartosc nie jest wartoscia numeryczna');
                RETURN;
            ELSIF is_number(numer) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawny numer pokoju! Wartosc nie jest wartoscia numeryczna');
                RETURN;
            ELSIF is_number(liczba_osob) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawna liczba_osob! Wartosc nie jest wartoscia numeryczna');
                RETURN;
            ELSIF status != 'W' AND status != 'Z'  THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawny status! Dozwolone wartosci: W,Z');
                RETURN;
            END IF;
            
            INSERT INTO Pokoje(id_pokoju, numer, liczba_osob, status) VALUES(id_pokoju, numer, liczba_osob, status);
         END LOOP;
  
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- TEST -->
SET SERVEROUTPUT ON;

SELECT * FROM Pokoje;

BEGIN
    wczytajPokoje('XMLFILES');
END;

ROLLBACK;
-- TEST <--


/*
--------------------------------------------------
import pliku XML z Cenami Pokoi
*/
CREATE OR REPLACE PROCEDURE wczytajCenyPokoi(directoryName VARCHAR2)
IS
    domNodeList DBMS_XMLDOM.DOMNODELIST := odczytPlikuXML(directoryName, 'Ceny_pokoi', 'Cena_pokoju');
    domNode DBMS_XMLDOM.DOMNODE;
    id_ceny_pokoju VARCHAR2(100);
    cena VARCHAR2(100);
    data_obowiazywania_od VARCHAR2(100);
    data_obowiazywania_do VARCHAR2(100);
    id_pokoju VARCHAR2(100);
    status VARCHAR2(100);
    
    BEGIN
         FOR idx IN 0 .. DBMS_XMLDOM.GETLENGTH(domNodeList) - 1 LOOP
            domNode := DBMS_XMLDOM.ITEM(domNodeList, idx);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'id_ceny_pokoju/text()',id_ceny_pokoju);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'cena/text()',cena);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'data_obowiazywania_od/text()',data_obowiazywania_od);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'data_obowiazywania_do/text()',data_obowiazywania_do);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'id_pokoju/text()',id_pokoju);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'status/text()',status);
            
            IF is_number(id_ceny_pokoju) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawne id_ceny_pokoju! Podana wartosc nie jest wartoscia numeryczna');
                RETURN;
            ELSIF is_number(cena) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawna cena pokoju! Wartosc nie jest wartoscia numeryczna');
                RETURN;
            ELSIF is_number(id_pokoju) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawne id_pokoju! Wartosc nie jest wartoscia numeryczna');
                RETURN;
            ELSIF is_date(data_obowiazywania_od) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawn data_obowiazywania_od! Wartosc nie jest typu date. Akceptowalny format: RRRR-MM-DD');
                RETURN;
            ELSIF status != 'A' AND status != 'N'  THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawny status! Dozwolone wartosci: A,N');
                RETURN;
            END IF;
            
            INSERT INTO Ceny_pokoi(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status) VALUES(id_ceny_pokoju, cena, data_obowiazywania_od, data_obowiazywania_do, id_pokoju, status);
         END LOOP;
  
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- TEST -->
SET SERVEROUTPUT ON;

SELECT * FROM Ceny_pokoi;

BEGIN
    wczytajCenyPokoi('XMLFILES');
END;

ROLLBACK;
-- TEST <--


/*
--------------------------------------------------
import pliku XML z Rezerwacjami
*/
CREATE OR REPLACE PROCEDURE wczytajRezerwacje(directoryName VARCHAR2)
IS
    domNodeList DBMS_XMLDOM.DOMNODELIST := odczytPlikuXML(directoryName, 'Rezerwacje', 'Rezerwacja');
    domNode DBMS_XMLDOM.DOMNODE;
    id_rezerwacji VARCHAR2(100);
    data_rezerwacji VARCHAR2(100);
    data_przyjazdu VARCHAR2(100);
    data_wyjazdu VARCHAR2(100);
    status VARCHAR2(100);
    id_klienta VARCHAR2(100);
    id_pokoju VARCHAR2(100);
    
    BEGIN
         FOR idx IN 0 .. DBMS_XMLDOM.GETLENGTH(domNodeList) - 1 LOOP
            domNode := DBMS_XMLDOM.ITEM(domNodeList, idx);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'id_rezerwacji/text()',id_rezerwacji);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'data_rezerwacji/text()',data_rezerwacji);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'data_przyjazdu/text()',data_przyjazdu);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'data_wyjazdu/text()',data_wyjazdu);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'status/text()',status);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'id_klienta/text()',id_klienta);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'id_pokoju/text()',id_pokoju);
            
            IF is_number(id_rezerwacji) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawne id_rezerwacji! Podana wartosc nie jest wartoscia numeryczna');
                RETURN;
            ELSIF is_date(data_rezerwacji) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawna data_rezerwacji! Wartosc nie jest typu date. Akceptowalny format: RRRR-MM-DD');
                RETURN;
            ELSIF is_date(data_przyjazdu) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawna data_przyjazdu! Wartosc nie jest typu date. Akceptowalny format: RRRR-MM-DD');
                RETURN;
            ELSIF is_date(data_wyjazdu) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawna data_wyjazdu! Wartosc nie jest typu date. Akceptowalny format: RRRR-MM-DD');
                RETURN;
            ELSIF status != 'Z' AND status != 'N'  THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawny status! Dozwolone wartosci: Z,N');
                RETURN;
            ELSIF is_number(id_klienta) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawny id_klienta! Wartosc nie jest wartoscia numeryczna');
                RETURN;
            ELSIF is_number(id_pokoju) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawny id_pokoju! Wartosc nie jest wartoscia numeryczna');
                RETURN;
            END IF;
            
            INSERT INTO Rezerwacje(id_rezerwacji, data_rezerwacji, data_przyjazdu, data_wyjazdu, status, id_klienta, id_pokoju) VALUES(id_rezerwacji, data_rezerwacji, data_przyjazdu, data_wyjazdu, status, id_klienta, id_pokoju);
         END LOOP;
  
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- TEST -->
SET SERVEROUTPUT ON;

SELECT * FROM Rezerwacje;

BEGIN
    wczytajRezerwacje('XMLFILES');
END;

ROLLBACK;
-- TEST <--


/*
--------------------------------------------------
import pliku XML z Wyposazeniami
*/
CREATE OR REPLACE PROCEDURE wczytajWyposazenia(directoryName VARCHAR2)
IS
    domNodeList DBMS_XMLDOM.DOMNODELIST := odczytPlikuXML(directoryName, 'Wyposazenia', 'Wyposazenie');
    domNode DBMS_XMLDOM.DOMNODE;
    id_wyposazenia VARCHAR2(100);
    nazwa VARCHAR2(100);
    liczba_szt_calk VARCHAR2(100);
    liczba_szt_dost VARCHAR2(100);
    
    BEGIN
         FOR idx IN 0 .. DBMS_XMLDOM.GETLENGTH(domNodeList) - 1 LOOP
            domNode := DBMS_XMLDOM.ITEM(domNodeList, idx);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'id_wyposazenia/text()',id_wyposazenia);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'nazwa/text()',nazwa);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'liczba_szt_calk/text()',liczba_szt_calk);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'liczba_szt_dost/text()',liczba_szt_dost);
            
            IF is_number(id_wyposazenia) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawne id_wyposazenia! Podana wartosc nie jest wartoscia numeryczna');
                RETURN;
            ELSIF is_number(liczba_szt_calk) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawna liczba_szt_calk! Podana wartosc nie jest wartoscia numeryczna');
                RETURN;
            ELSIF is_number(liczba_szt_dost) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawna liczba_szt_dost! Podana wartosc nie jest wartoscia numeryczna');
                RETURN;
            END IF;
            
            INSERT INTO Wyposazenia(id_wyposazenia, nazwa, liczba_szt_calk, liczba_szt_dost) VALUES(id_wyposazenia, nazwa, liczba_szt_calk, liczba_szt_dost);
         END LOOP;
  
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- TEST -->
SET SERVEROUTPUT ON;

SELECT * FROM Wyposazenia;

BEGIN
    wczytajWyposazenia('XMLFILES');
END;

ROLLBACK;
-- TEST <--


/*
--------------------------------------------------
import pliku XML z Wyposazeniami_pokoi
*/
CREATE OR REPLACE PROCEDURE wczytajWyposazeniaPokoi(directoryName VARCHAR2)
IS
    domNodeList DBMS_XMLDOM.DOMNODELIST := odczytPlikuXML(directoryName, 'Wyposazenia_pokoi', 'Wyposazenie_pokoju');
    domNode DBMS_XMLDOM.DOMNODE;
    id_wyposazenia VARCHAR2(100);
    id_pokoju VARCHAR2(100);
    
    BEGIN
         FOR idx IN 0 .. DBMS_XMLDOM.GETLENGTH(domNodeList) - 1 LOOP
            domNode := DBMS_XMLDOM.ITEM(domNodeList, idx);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'id_wyposazenia/text()',id_wyposazenia);
            DBMS_XSLPROCESSOR.VALUEOF(domNode,'id_pokoju/text()',id_pokoju);
            
            IF is_number(id_wyposazenia) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawne id_wyposazenia! Podana wartosc nie jest wartoscia numeryczna');
                RETURN;
            ELSIF is_number(id_pokoju) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niepoprawne id_pokoju! Podana wartosc nie jest wartoscia numeryczna');
                RETURN;
            END IF;
            
            INSERT INTO Wyposazenia_pokoi(id_wyposazenia, id_pokoju) VALUES(id_wyposazenia, id_pokoju);
         END LOOP;
  
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- TEST -->
SET SERVEROUTPUT ON;

SELECT * FROM Wyposazenia_pokoi;

BEGIN
    wczytajWyposazeniaPokoi('XMLFILES');
END;

ROLLBACK;
-- TEST <--

/*
import pliku XML z dopisaniem danych do istniejącego wiersza
*/

CREATE OR REPLACE PROCEDURE import_danych_klienta(name_file VARCHAR2)
IS
    xml_content XMLTYPE := XMLTYPE(bfilename('XMLFILES', name_file || '.xml'),nls_charset_id('AL32UTF8'));
    
    BEGIN
        FOR klient IN 
        (
            SELECT
                ExtractValue(VALUE(k),'/Klient/Id/text()') AS xml_id,
                ExtractValue(VALUE(k),'/Klient/Pesel/text()') AS xml_pesel,
                ExtractValue(VALUE(k),'/Klient/Imie/text()') AS xml_imie,
                ExtractValue(VALUE(k),'/Klient/Nazwisko/text()') AS xml_nazwisko
            FROM   
                TABLE(XMLSequence(EXTRACT(xml_content,'/Klient'))) k
        ) 
        LOOP
            UPDATE 
                Klienci
            SET
                pesel = klient.xml_pesel,
                imie = klient.xml_imie,
                nazwisko = klient.xml_nazwisko
            WHERE 
                id_klienta = klient.xml_id;
        END LOOP;       
    END;
    
-- TEST -->  

SELECT 
    *
FROM
    Klienci;

EXECUTE import_danych_klienta('dane_klienta');   

SELECT 
    *
FROM
    Klienci;

-- TEST <--    