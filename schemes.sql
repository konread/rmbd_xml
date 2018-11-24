/*
 dodawanie schemy dla klientow
*/
BEGIN
--DBMS_XMLSCHEMA.DELETESCHEMA('klienci.xsd');
DBMS_XMLSCHEMA.REGISTERSCHEMA(schemaURL   => 'Klienci.xsd', 
        schemaDoc   => '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
            <xs:element name="Klienci">
                <xs:complexType>
                    <xs:sequence>
                        <xs:element name="Klient" maxOccurs="unbounded" minOccurs="0">
                            <xs:complexType>
                                <xs:sequence>
                                    <xs:element name="id_klienta" type="xs:string"/>         
                                    <xs:element name="pesel"  type="xs:string"/>
                                    <xs:element name="imie"  type="xs:string"/>
                                    <xs:element name="nazwisko"  type="xs:string"/> 
                                </xs:sequence>
                            </xs:complexType>
                        </xs:element>
                    </xs:sequence>
                </xs:complexType>
            </xs:element>
        </xs:schema>'); 
END;


/*
 dodawanie schemy dla klientow
*/
BEGIN
--DBMS_XMLSCHEMA.DELETESCHEMA('Pokoje.xsd');
DBMS_XMLSCHEMA.REGISTERSCHEMA(schemaURL   => 'Pokoje.xsd', 
        schemaDoc   => '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <xs:element name="Pokoje">
            <xs:complexType>
                <xs:sequence>
                    <xs:element name="Pokoj" maxOccurs="unbounded" minOccurs="0">
                        <xs:complexType>
                            <xs:sequence>
                                <xs:element name="id_pokoju" type="xs:string"/>
                                <xs:element name="numer" type="xs:string"/>
                                <xs:element name="liczba_osob" type="xs:string"/>
                                <xs:element name="status" type="xs:string"/>
                            </xs:sequence>
                        </xs:complexType>
                    </xs:element>
                </xs:sequence>
            </xs:complexType>
        </xs:element>
    </xs:schema>'); 
END;