/*
 dodawanie schemy dla klientow
*/
BEGIN
--DBMS_XMLSCHEMA.DELETESCHEMA('Klienci.xsd');
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
 dodawanie schemy dla pokojow
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


/*
 dodawanie schemy dla Ceny_pokoi
*/
BEGIN
--DBMS_XMLSCHEMA.DELETESCHEMA('CenyPokoi.xsd');
DBMS_XMLSCHEMA.REGISTERSCHEMA(schemaURL   => 'CenyPokoi.xsd', 
        schemaDoc   => '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="Ceny_pokoi">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="Cena_pokoju" maxOccurs="unbounded" minOccurs="0">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="id_ceny_pokoju" type="xs:string"/>
              <xs:element name="cena" type="xs:string"/>
              <xs:element name="data_obowiazywania_od" type="xs:string"/>
              <xs:element name="data_obowiazywania_do" type="xs:string"/>
              <xs:element name="id_pokoju" type="xs:string"/>
              <xs:element name="status" type="xs:string"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>
'); 
END;


/*
 dodawanie schemy dla Rezerwacji
*/
BEGIN
--DBMS_XMLSCHEMA.DELETESCHEMA('Rezerwacje.xsd');
DBMS_XMLSCHEMA.REGISTERSCHEMA(schemaURL   => 'Rezerwacje.xsd', 
        schemaDoc   => '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="Rezerwacje">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="Rezerwacja" maxOccurs="unbounded" minOccurs="0">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="id_rezerwacji" type="xs:string"/>
              <xs:element name="data_rezerwacji" type="xs:string"/>
              <xs:element name="data_przyjazdu" type="xs:string"/>
              <xs:element name="data_wyjazdu" type="xs:string"/>
              <xs:element name="status" type="xs:string"/>
              <xs:element name="id_klienta" type="xs:string"/>
              <xs:element name="id_pokoju" type="xs:string"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>
'); 
END;


/*
 dodawanie schemy dla Wyposazenia
*/
BEGIN
--DBMS_XMLSCHEMA.DELETESCHEMA('Wyposazenia.xsd');
DBMS_XMLSCHEMA.REGISTERSCHEMA(schemaURL   => 'Wyposazenia.xsd', 
        schemaDoc   => '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="Wyposazenia">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="Wyposazenie" maxOccurs="unbounded" minOccurs="0">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="id_wyposazenia" type="xs:string"/>
              <xs:element name="nazwa" type="xs:string"/>
              <xs:element name="liczba_szt_calk" type="xs:string"/>
              <xs:element name="liczba_szt_dost" type="xs:string"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>
'); 
END;


/*
 dodawanie schemy dla Wyposazenia_pokoi
*/
BEGIN
--DBMS_XMLSCHEMA.DELETESCHEMA('Wyposazenia_pokoi.xsd');
DBMS_XMLSCHEMA.REGISTERSCHEMA(schemaURL   => 'Wyposazenia_pokoi.xsd', 
        schemaDoc   => '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="Wyposazenia_pokoi">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="Wyposazenie_pokoju" maxOccurs="unbounded" minOccurs="0">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="id_wyposazenia" type="xs:string"/>
              <xs:element name="id_pokoju" type="xs:string"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>
'); 
END;
