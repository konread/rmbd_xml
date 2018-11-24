CREATE DIRECTORY 
    XMLFILES 
AS 
    'C:/Users/Damian/Desktop/xml_files';
    
GRANT READ, WRITE ON DIRECTORY XMLFILES TO student;

COMMIT;

/*
eksport danych XML z wielu wierszy do jednego pliku
*/
    
CREATE OR REPLACE PROCEDURE eksport_rezerwacji_klientow(name_file VARCHAR2)
IS
    CURSOR rezerwacje_klientow
    IS
        SELECT 
        XMLROOT (
                XMLElement(
                    "Klienci", 
                    XMLAgg(
                        XMLElement(
                            "Klient",
                                XMLElement("Pesel", k.pesel),
                                XMLElement("Imie", k.imie),
                                XMLElement("Nazwisko", k.nazwisko),
                                XMLElement(
                                    "Rezerwacje", 
                                        XMLAgg(
                                            XMLElement(
                                                "Rezerwacja",
                                                    XMLElement("Data_przyjazdu", r.data_przyjazdu),
                                                    XMLElement("Data_wyjazdu", r.data_wyjazdu),
                                                    XMLElement("Nr_pokoju", p.numer)
                                            )
                                        )
                                )
                            )
                        )
                    ), VERSION '1.0" encoding="UTF-8', STANDALONE YES
                )
        FROM 
            Klienci k 
                LEFT JOIN Rezerwacje r ON k.id_klienta = r.id_klienta
                    INNER JOIN Pokoje p ON r.id_pokoju = p.id_pokoju
        GROUP BY
            k.pesel, k.imie, k.nazwisko;
    
    doc DBMS_XMLDOM.DOMDocument;       
    xml_content XMLTYPE;

    BEGIN
        OPEN rezerwacje_klientow;                                                                                                         
            FETCH rezerwacje_klientow INTO xml_content;                                                                                             
        CLOSE rezerwacje_klientow;                    
        
        doc := DBMS_XMLDOM.NewDOMDocument(xml_content);             
        
        DBMS_XMLDOM.WRITETOFILE(doc, 'XMLFILES/' || name_file || '.xml');    
    END;

-- TEST -->  

EXECUTE eksport_rezerwacji_klientow('rezerwacje_klientow');   

-- TEST <--    
    
/*
eksport danych XML z jednego wiersza do jednego pliku
*/

CREATE OR REPLACE PROCEDURE eksport_danych_klienta(pesel_klienta Klienci.pesel % TYPE, name_file VARCHAR2)
IS
    CURSOR klient
    IS
        SELECT 
            XMLROOT (
                XMLElement(
                    "Klient",
                        XMLElement("Id", k.id_klienta),
                        XMLElement("Pesel", k.pesel),
                        XMLElement("Imie", k.imie),
                        XMLElement("Nazwisko", k.nazwisko)                                
                ), 
                VERSION '1.0" encoding="UTF-8', STANDALONE YES
            )
        FROM 
            Klienci k 
        WHERE
            k.pesel = pesel_klienta;
    
    doc DBMS_XMLDOM.DOMDocument;       
    xml_content XMLTYPE;

    BEGIN
        OPEN klient;                                                                                                         
            FETCH klient INTO xml_content;                                                                                             
        CLOSE klient;                    
        
        doc := DBMS_XMLDOM.NewDOMDocument(xml_content);             
        
        DBMS_XMLDOM.WRITETOFILE(doc, 'XMLFILES/' || name_file || '.xml');    
    END;

-- TEST -->  

EXECUTE eksport_danych_klienta('00000000000', 'dane_klienta');   

-- TEST <--

/*
    eksport wynikow po wywolaniu funkcji
*/

CREATE OR REPLACE FUNCTION podsumowanie_kwoty_do_zaplaty(pesel Klienci.pesel % TYPE)
RETURN NUMBER
AS
    CURSOR podsumowanie_rezerwacji 
    IS 
        SELECT
            k.pesel AS pesel_klienta,
            ((r.data_wyjazdu - r.data_przyjazdu) * cp.cena) AS cena_za_rezerwacje
        FROM
            Klienci k 
                INNER JOIN Rezerwacje r ON k.id_klienta = r.id_klienta 
                INNER JOIN Ceny_pokoi cp ON r.id_pokoju = cp.id_pokoju AND 
                                            (
                                                r.data_rezerwacji BETWEEN cp.data_obowiazywania_od AND cp.data_obowiazywania_do OR 
                                                (cp.data_obowiazywania_do IS NULL AND r.data_rezerwacji >= cp.data_obowiazywania_od)
                                            )
                                                 
        WHERE 
            r.status = 'N';
            
    pr podsumowanie_rezerwacji % ROWTYPE;  
    kwota_do_zaplaty Ceny_pokoi.cena % TYPE := 0;

    BEGIN
        OPEN podsumowanie_rezerwacji;
        
        LOOP 
            FETCH podsumowanie_rezerwacji INTO pr;
            EXIT WHEN podsumowanie_rezerwacji % NOTFOUND;
            
            IF pr.pesel_klienta = pesel
                THEN
                    kwota_do_zaplaty := kwota_do_zaplaty + pr.cena_za_rezerwacje;
            END IF;
        END LOOP;
        
        CLOSE podsumowanie_rezerwacji;
        
        return kwota_do_zaplaty;
    END;

CREATE OR REPLACE PROCEDURE eksport_do_zaplaty(name_file VARCHAR2)
IS
    CURSOR klient
    IS
        SELECT 
            XMLROOT (
                XMLElement(
                    "Klienci", 
                        XMLAgg(
                            XMLElement(
                                "Klient",
                                    XMLElement("Id", k.id_klienta),
                                    XMLElement("Pesel", k.pesel),
                                    XMLElement("Imie", k.imie),
                                    XMLElement("Nazwisko", k.nazwisko),
                                    XMLElement("Do_zaplaty", podsumowanie_kwoty_do_zaplaty(k.pesel)
                                )
                            )
                        )
                    ),
                VERSION '1.0" encoding="UTF-8', STANDALONE YES
            )
        FROM 
            Klienci k;
    
    doc DBMS_XMLDOM.DOMDocument;       
    xml_content XMLTYPE;

    BEGIN
        OPEN klient;                                                                                                         
            FETCH klient INTO xml_content;                                                                                             
        CLOSE klient;                    
        
        doc := DBMS_XMLDOM.NewDOMDocument(xml_content);             
        
        DBMS_XMLDOM.WRITETOFILE(doc, 'XMLFILES/' || name_file || '.xml');    
    END;
    
EXECUTE eksport_do_zaplaty('do_zaplaty')