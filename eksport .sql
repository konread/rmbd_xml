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