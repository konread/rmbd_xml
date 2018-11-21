/*
import pliku XML z dopisaniem danych do istniej¹cego wiersza
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