ALTER SESSION SET NLS_DATE_FORMAT = 'RRRR-MM-DD';

DROP TABLE Wyposazenia_pokoi;
DROP TABLE Wyposazenia;
DROP TABLE Rezerwacje;
DROP TABLE Ceny_pokoi;
DROP TABLE Pokoje;
DROP TABLE Klienci;

CREATE TABLE Klienci
(
    id_klienta NUMBER(3) CONSTRAINT k_pk_id_klienta PRIMARY KEY,
    pesel CHAR(11) CONSTRAINT k_nn_pesel NOT NULL,
    imie VARCHAR2(25) CONSTRAINT k_nn_imie NOT NULL,
    nazwisko VARCHAR2(25) CONSTRAINT k_nn_nazwisko NOT NULL,
    
    CONSTRAINT k_u_pesel UNIQUE(pesel)
);

CREATE TABLE Pokoje
(
    id_pokoju NUMBER(3) CONSTRAINT p_pk_id_pokoju PRIMARY KEY,
    numer NUMBER(3) CONSTRAINT p_nn_numer NOT NULL,
    liczba_osob NUMBER(2) CONSTRAINT p_nn_liczba_osob NOT NULL,
    -- status: wolny (W), zajety (Z)
    status CHAR(1) CONSTRAINT p_nn_status NOT NULL  
                   CONSTRAINT p_ch_status CHECK(status IN ('W', 'Z')),
                   
    CONSTRAINT p_u_numer UNIQUE(numer)
);

CREATE TABLE Ceny_pokoi
(
    id_ceny_pokoju NUMBER(3) CONSTRAINT cp_pk_id_ceny_pokoju PRIMARY KEY,
    cena NUMBER(6,2) CONSTRAINT cp_nn_cena NOT NULL,
    data_obowiazywania_od DATE CONSTRAINT cp_nn_data_obowiazywania_od NOT NULL,
    data_obowiazywania_do DATE,
    id_pokoju NUMBER(3) CONSTRAINT cp_nn_id_pokoju NOT NULL
                        CONSTRAINT cp_fk_id_pokoju REFERENCES Pokoje(id_pokoju),
    -- status: aktualna (A), nieaktualna (N)
    status CHAR(1) CONSTRAINT cp_nn_status NOT NULL  
                   CONSTRAINT cp_ch_status CHECK(status IN ('A', 'N')),
    
    CONSTRAINT cp_ch_data_obowiazywania CHECK(data_obowiazywania_do >= data_obowiazywania_od)
);

CREATE TABLE Rezerwacje
(
    id_rezerwacji NUMBER(3) CONSTRAINT r_pk_id_rezerwacji PRIMARY KEY,
    data_rezerwacji DATE CONSTRAINT r_nn_data_rezerwacji NOT NULL,
    data_przyjazdu DATE CONSTRAINT r_nn_data_przyjazdu NOT NULL,
    data_wyjazdu DATE CONSTRAINT r_nn_data_wyjazdu NOT NULL,
    -- status: zaplacono (Z), nie zaplacono (N)
    status CHAR(1) CONSTRAINT r_nn_status NOT NULL  
                   CONSTRAINT r_ch_status CHECK(status IN ('Z', 'N')), 
    id_klienta NUMBER(3) CONSTRAINT r_nn_id_klienta NOT NULL
                         CONSTRAINT r_fk_id_klienta REFERENCES Klienci(id_klienta),
    id_pokoju NUMBER(3) CONSTRAINT r_nn_id_pokoju NOT NULL
                        CONSTRAINT r_fk_id_pokoju REFERENCES Pokoje(id_pokoju),
      
    CONSTRAINT r_ch_data_przyjazdu CHECK(data_przyjazdu > data_rezerwacji),            
    CONSTRAINT r_ch_data_wyjazdu CHECK(data_wyjazdu > data_przyjazdu)              
);

CREATE TABLE Wyposazenia
(
    id_wyposazenia NUMBER(3) CONSTRAINT w_pk_id_wyposazenia PRIMARY KEY,
    nazwa VARCHAR(50) CONSTRAINT w_nn_nazwa NOT NULL,
    liczba_szt_calk NUMBER(3) CONSTRAINT w_nn_liczba_szt_calk NOT NULL,
    liczba_szt_dost NUMBER(3) CONSTRAINT w_nn_liczba_szt_dost NOT NULL, 
    
    CONSTRAINT w_ch_liczba_szt_dost CHECK(liczba_szt_dost <= liczba_szt_calk)
);

CREATE TABLE Wyposazenia_pokoi
(
    id_wyposazenia NUMBER(3) CONSTRAINT wp_nn_id_wyposazenia NOT NULL,
    id_pokoju NUMBER(3) CONSTRAINT wp_nn_id_pokoju NOT NULL,
    
    CONSTRAINT wp_pk PRIMARY KEY(id_wyposazenia, id_pokoju)
);
