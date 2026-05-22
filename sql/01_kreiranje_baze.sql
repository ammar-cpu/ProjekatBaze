USE farmakologija;

CREATE TABLE biosafety_nivo (
	biosafety_id INT PRIMARY KEY AUTO_INCREMENT,
    nivo INT NOT NULL,
    naziv VARCHAR(50) NOT NULL,
    opis TEXT
);

CREATE TABLE tip_alata (
	tip_alata_id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    opis TEXT
);

CREATE TABLE resurs (
	resurs_id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    opis TEXT
);

CREATE TABLE rezim_doziranja (
	doziranje_id INT PRIMARY KEY AUTO_INCREMENT,
    vrednost DECIMAL(10,2) NOT NULL,
    jedinica VARCHAR(50) NOT NULL,
    put_primene VARCHAR(100) NOT NULL
);

CREATE TABLE tip_eksperimenta (
	tip_eks_id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    opis TEXT
);

CREATE TABLE endpoint (
	endpoint_id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    jedinica VARCHAR(50),
    opis TEXT
);

CREATE TABLE specijalizacija (
	specijalizacija_id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    opis TEXT
);

CREATE TABLE status_izvodjenja (
	status_id INT PRIMARY KEY AUTO_INCREMENT,
    opis VARCHAR(50) NOT NULL
);

CREATE TABLE laboratorija (
	lab_id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    zgrada VARCHAR(100) NOT NULL,
    sprat INT NOT NULL,
    br_prostorije VARCHAR(20) NOT NULL,
    biosafety_id INT NOT NULL,
    FOREIGN KEY (biosafety_id) REFERENCES biosafety_nivo(biosafety_id)
);

CREATE TABLE alat (
	alat_id INT PRIMARY KEY AUTO_INCREMENT,
    d_nabavke DATE NOT NULL,
    d_proizvodnje DATE,
    lab_id INT NOT NULL,
    tip_alata_id INT NOT NULL,
	FOREIGN KEY (lab_id) REFERENCES laboratorija(lab_id),
    FOREIGN KEY (tip_alata_id) REFERENCES tip_alata(tip_alata_id)
);

CREATE TABLE celijska_linija (
	resurs_id INT PRIMARY KEY,
    naziv_linije VARCHAR(100) NOT NULL,
    poreklo VARCHAR(100),
    FOREIGN KEY (resurs_id) REFERENCES resurs(resurs_id)
);

CREATE TABLE zivotinja (
	resurs_id INT PRIMARY KEY,
    soj VARCHAR(100) NOT NULL,
    vrsta VARCHAR(100) NOT NULL,
    FOREIGN KEY (resurs_id) REFERENCES resurs(resurs_id)
);

CREATE TABLE reagens (
	resurs_id INT PRIMARY KEY,
    koncentracija VARCHAR(50),
    rastvarac VARCHAR(100),
    FOREIGN KEY (resurs_id) REFERENCES resurs(resurs_id)
);

CREATE TABLE lab_resurs (
	lab_id INT NOT NULL,
    resurs_id INT NOT NULL,
    kolicina DECIMAL(10,2),
    status VARCHAR(50),
    PRIMARY KEY (lab_id, resurs_id),
    FOREIGN KEY (lab_id) REFERENCES laboratorija(lab_id),
    FOREIGN KEY (resurs_id) REFERENCES resurs(resurs_id)
);

CREATE TABLE eksperiment (
	eks_id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    doziranje_id INT NOT NULL,
    tip_eks_id INT NOT NULL,
    FOREIGN KEY (doziranje_id) REFERENCES rezim_doziranja(doziranje_id),
    FOREIGN KEY (tip_eks_id) REFERENCES tip_eksperimenta(tip_eks_id)
);

CREATE TABLE cilj_istrazivanja (
	cilj_id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    opis TEXT,
    eks_id INT NOT NULL UNIQUE,
    FOREIGN KEY (eks_id) REFERENCES eksperiment(eks_id)
    
);

CREATE TABLE uloga_resursa (
	eks_id INT NOT NULL,
    resurs_id INT NOT NULL,
    naziv varchar(100),
    opis TEXT,
    PRIMARY KEY (eks_id, resurs_id),
    FOREIGN KEY (eks_id) REFERENCES eksperiment(eks_id),
    FOREIGN KEY (resurs_id) REFERENCES resurs(resurs_id)
);

CREATE TABLE eks_endpoint (
	eks_id INT NOT NULL,
    endpoint_id INT NOT NULL,
    PRIMARY KEY (eks_id, endpoint_id),
    FOREIGN KEY (eks_id) REFERENCES eksperiment(eks_id),
    FOREIGN KEY (endpoint_id) REFERENCES `endpoint`(endpoint_id)
);

CREATE TABLE eks_tip_alata (
	eks_id INT NOT NULL,
    tip_alata_id INT NOT NULL,
    PRIMARY KEY (eks_id, tip_alata_id),
    FOREIGN KEY (eks_id) REFERENCES eksperiment(eks_id),
    FOREIGN KEY (tip_alata_id) REFERENCES tip_alata(tip_alata_id)
);

CREATE TABLE sertifikat (
	sertifikat_id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    opis TEXT,
    biosafety_id INT NOT NULL,
    FOREIGN KEY (biosafety_id) REFERENCES biosafety_nivo(biosafety_id)
);

CREATE TABLE istrazivac (
	istrazivac_id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    jmbg VARCHAR(13) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    dob DATE NOT NULL,
    dat_zaposlenja DATE NOT NULL,
    akademska_titula VARCHAR(50),
    god_iskustva INT,
    lab_id INT NOT NULL,
    FOREIGN KEY (lab_id) REFERENCES laboratorija(lab_id)
);

CREATE TABLE dizajner (
	istrazivac_id INT PRIMARY KEY,
    br_radova INT,
    orcid VARCHAR(20),
    FOREIGN KEY (istrazivac_id) REFERENCES istrazivac(istrazivac_id)
);

CREATE TABLE izvodjac (
	istrazivac_id INT PRIMARY KEY,
    FOREIGN KEY (istrazivac_id) REFERENCES istrazivac(istrazivac_id)
);

CREATE TABLE teorija (
	teorija_id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    opis TEXT,
    dizajner_id INT NOT NULL,
    FOREIGN KEY (dizajner_id) REFERENCES dizajner(istrazivac_id)
);

CREATE TABLE eksperiment_dizajner (
	eks_id INT NOT NULL,
    dizajner_id INT NOT NULL,
    PRIMARY KEY (eks_id, dizajner_id),
    FOREIGN KEY (eks_id) REFERENCES eksperiment(eks_id),
    FOREIGN KEY (dizajner_id) REFERENCES dizajner(istrazivac_id)
);

CREATE TABLE istrazivac_specijalizacija (
	istrazivac_id INT NOT NULL,
    specijalizacija_id INT NOT NULL,
    PRIMARY KEY (istrazivac_id, specijalizacija_id),
    FOREIGN KEY (istrazivac_id) REFERENCES istrazivac(istrazivac_id),
    FOREIGN KEY (specijalizacija_id) REFERENCES specijalizacija(specijalizacija_id)
);

CREATE TABLE konkretan_sertifikat (
	istrazivac_id INT NOT NULL,
    sertifikat_id INT NOT NULL,
    datum_sticanja DATE,
    PRIMARY KEY (istrazivac_id, sertifikat_id),
    FOREIGN KEY (istrazivac_id) REFERENCES istrazivac(istrazivac_id),
    FOREIGN KEY (sertifikat_id) REFERENCES sertifikat(sertifikat_id)
);

CREATE TABLE izvodjenje (
	izvodjenje_id INT NOT NULL AUTO_INCREMENT,
    lab_id INT NOT NULL,
    datum DATE NOT NULL,
    primenjena_doza DECIMAL(10,2),
    jedinica VARCHAR(50),
    put_primene VARCHAR(100),
    devijacije TEXT,
    eks_id INT NOT NULL,
	status_id INT NOT NULL,
    PRIMARY KEY (izvodjenje_id, lab_id),
    FOREIGN KEY (lab_id) REFERENCES laboratorija(lab_id),
    FOREIGN KEY (eks_id) REFERENCES eksperiment(eks_id),
    FOREIGN KEY (status_id) REFERENCES status_izvodjenja(status_id)
);

CREATE TABLE uloga (
	izvodjac_id INT NOT NULL,
    izvodjenje_id INT NOT NULL,
    lab_id INT NOT NULL,
    opis VARCHAR(100),
    beleske TEXT,
    PRIMARY KEY (izvodjac_id, izvodjenje_id, lab_id),
    FOREIGN KEY (izvodjac_id) REFERENCES izvodjac(istrazivac_id),
    FOREIGN KEY (izvodjenje_id, lab_id) REFERENCES izvodjenje(izvodjenje_id, lab_id)
);

CREATE TABLE sesija (
	sesija_id INT PRIMARY KEY AUTO_INCREMENT,
    datum DATE NOT NULL,
    pocetak TIME NOT NULL,
    zavrsetak TIME NOT NULL,
    status_sesije VARCHAR(100),
    izvodjenje_id INT NOT NULL,
    lab_id INT NOT NULL,
    FOREIGN KEY (izvodjenje_id, lab_id) REFERENCES izvodjenje(izvodjenje_id, lab_id)
);

CREATE TABLE rezultat (
	endpoint_id INT NOT NULL,
    izvodjenje_id INT NOT NULL,
    lab_id INT NOT NULL,
    vrednost DECIMAL(10,2),
    jedinica VARCHAR(50),
    PRIMARY KEY (endpoint_id, izvodjenje_id, lab_id),
    FOREIGN KEY (endpoint_id) REFERENCES `endpoint`(endpoint_id),
    FOREIGN KEY (izvodjenje_id, lab_id) REFERENCES izvodjenje(izvodjenje_id, lab_id)
);

CREATE TABLE ses_resurs (
	sesija_id INT NOT NULL,
    resurs_id INT NOT NULL,
    potrosena_kol DECIMAL(10,2),
    PRIMARY KEY (sesija_id, resurs_id),
    FOREIGN KEY (sesija_id) REFERENCES sesija(sesija_id),
    FOREIGN KEY (resurs_id) REFERENCES resurs(resurs_id)
);

CREATE TABLE ses_alat (
	sesija_id INT NOT NULL,
    alat_id INT NOT NULL,
    upotreba TEXT,
    PRIMARY KEY (sesija_id, alat_id),
    FOREIGN KEY (sesija_id) REFERENCES sesija(sesija_id),
    FOREIGN KEY (alat_id) REFERENCES alat(alat_id)
);

CREATE TABLE jedinjenje (
	resurs_id INT PRIMARY KEY,
    cas_broj VARCHAR(20) NOT NULL UNIQUE,
    formula VARCHAR(100),
    mol_masa DECIMAL(10,2),
    terapijska_klasa VARCHAR(100),
    status_razvoja VARCHAR(50),
    FOREIGN KEY (resurs_id) REFERENCES resurs(resurs_id)
);

INSERT INTO biosafety_nivo (nivo, naziv, opis) VALUES
(1, 'BSL-1', 'Najniži nivo biološke bezbednosti. Rad sa nepatogenim mikroorganizmima koji ne predstavljaju opasnost po zdravlje odraslih. Ne zahteva posebnu zaštitnu opremu osim laboratorijskog mantila i rukavica.'),
(2, 'BSL-2', 'Rad sa umerno opasnim agensima koji mogu izazvati bolest kod ljudi. Obuhvata rad sa HeLa ćelijama, hepatitis B virusom. Zahteva BSL-2 sertifikat i laminarni boks.'),
(3, 'BSL-3', 'Rad sa potencijalno smrtonosnim patogenima koji se prenose vazdušnim putem, kao što je Mycobacterium tuberculosis. Zahteva posebne ventilacione sisteme i stroge protokole zaštite.'),
(4, 'BSL-4', 'Najviši nivo biološke bezbednosti. Rad sa smrtonosnim virusima poput ebole za koje ne postoji vakcina ni tretman. Zahteva potpuno izolovane prostorije i zaštitna odela.');

INSERT INTO tip_alata (naziv, opis) VALUES
('HPLC sistem', 'Visokoefikasna tečna hromatografija za separaciju i analizu jedinjenja u uzorcima.'),
('Maseni spektrometar', 'Uređaj za merenje mase molekula i identifikaciju hemijskih jedinjenja.'),
('Čitač mikroploča', 'Uređaj za merenje apsorbance, fluorescencije ili luminescencije u pločama sa 96 jamica.'),
('CO2 inkubator', 'Inkubator koji održava konstantnu temperaturu, vlažnost i CO2 nivo za kultivaciju ćelija.'),
('Laminarni boks', 'Zaštitni boks sa BSL-2 zaštitom za sterilan rad sa biološkim materijalom.'),
('Centrifuga', 'Uređaj za razdvajanje komponenti uzorka na osnovu gustine centrifugalnom silom.'),
('Analitička vaga', 'Precizna vaga za merenje masa uzoraka sa tačnošću do 0.0001g.'),
('Invertni mikroskop', 'Mikroskop za posmatranje ćelijskih kultura u posudama odozdo.'),
('PCR termocikler', 'Uređaj za amplifikaciju DNK lanaca putem lančane reakcije polimeraze.'),
('Spektrofotometar', 'Uređaj za merenje apsorbance svetlosti kroz uzorak na različitim talasnim dužinama.');
INSERT INTO tip_alata (naziv, opis) VALUES
('Vodeno kupatilo', 'Uređaj za inkubaciju uzoraka na konstantnoj temperaturi u vodi.'),
('Vorteks mešač', 'Uređaj za brzo mešanje uzoraka u epruvetama i tubicama.'),
('pH metar', 'Uređaj za precizno merenje pH vrednosti rastvora.'),
('Zamrzivač -80°C', 'Ultra-niskotemperaturni zamrzivač za dugoročno čuvanje bioloških uzoraka.'),
('Autoklav', 'Uređaj za sterilizaciju laboratorijskog posuđa i materijala parom pod pritiskom.'),
('Pipettor', 'Automatski višekanalni pipettor za precizno doziranje tečnosti u ploče.'),
('Gel elektroforeza', 'Sistem za razdvajanje molekula DNK ili proteina kroz gel.');


INSERT INTO status_izvodjenja (opis) VALUES
('planirano'),
('zapoceto'),
('otkazano'),
('zavrseno uspesno'),
('zavrseno neuspesno');

INSERT INTO specijalizacija (naziv, opis) VALUES
('In vitro studije', 'Specijalizacija za rad sa ćelijskim kulturama i in vitro eksperimentima.'),
('In vivo studije', 'Specijalizacija za rad sa laboratorijskim životinjama i in vivo eksperimentima.'),
('Analitička hemija', 'Specijalizacija za analizu hemijskih jedinjenja i interpretaciju rezultata.'),
('Farmakokinetika', 'Specijalizacija za praćenje ADME procesa i farmakokinetičke analize.'),
('Toksikologija', 'Specijalizacija za procenu toksičnosti jedinjenja i bezbednosne studije.');

INSERT INTO tip_eksperimenta (naziv, opis) VALUES
('In vitro citotoksičnost', 'Testiranje uticaja jedinjenja na viabilnost ćelijskih linija, npr. MTT test.'),
('In vitro mehanizam dejstva', 'Ispitivanje vezivanja jedinjenja za ciljni receptor i enzimska inhibicija.'),
('In vivo akutna toksičnost', 'Utvrđivanje LD50 i parametara akutnog odgovora organizma.'),
('In vivo farmakokinetičke studije', 'Praćenje ADME procesa - apsorpcija, distribucija, metabolizam, ekskrecija.'),
('In vivo studije efikasnosti', 'Testiranje terapijskog dejstva jedinjenja na životinjskim modelima bolesti.');

INSERT INTO endpoint (naziv, jedinica, opis) VALUES
('IC50', 'µM', 'Koncentracija jedinjenja pri kojoj se postiže 50% inhibicije.'),
('LD50', 'mg/kg', 'Letalna doza jedinjenja za 50% subjekata.'),
('Viabilnost ćelija', '%', 'Procenat živih ćelija nakon tretmana jedinjnjem.'),
('Cmax', 'ng/ml', 'Maksimalna koncentracija jedinjenja u plazmi.'),
('T1/2', 'h', 'Vreme polueliminacije jedinjenja iz organizma.'),
('AUC', 'ng*h/ml', 'Površina ispod krive koncentracija-vreme.'),
('Tmax', 'h', 'Vreme potrebno da se dostigne maksimalna koncentracija u plazmi.'),
('EC50', 'µM', 'Koncentracija jedinjenja koja izaziva 50% maksimalnog efekta.');

INSERT INTO rezim_doziranja (vrednost, jedinica, put_primene) VALUES
(1.00, 'mg/kg', 'oralno'),
(2.50, 'mg/kg', 'oralno'),
(5.00, 'mg/kg', 'oralno'),
(10.00, 'mg/kg', 'oralno'),
(15.00, 'mg/kg', 'oralno'),
(20.00, 'mg/kg', 'oralno'),
(25.00, 'mg/kg', 'oralno'),
(30.00, 'mg/kg', 'oralno'),
(40.00, 'mg/kg', 'oralno'),
(50.00, 'mg/kg', 'oralno'),
(75.00, 'mg/kg', 'oralno'),
(100.00, 'mg/kg', 'oralno'),
(150.00, 'mg/kg', 'oralno'),
(200.00, 'mg/kg', 'oralno'),
(250.00, 'mg/kg', 'oralno'),
(300.00, 'mg/kg', 'oralno'),
(400.00, 'mg/kg', 'oralno'),
(500.00, 'mg/kg', 'oralno'),
(1.00, 'mg/kg', 'intravenski'),
(2.50, 'mg/kg', 'intravenski'),
(5.00, 'mg/kg', 'intravenski'),
(10.00, 'mg/kg', 'intravenski'),
(15.00, 'mg/kg', 'intravenski'),
(20.00, 'mg/kg', 'intravenski'),
(25.00, 'mg/kg', 'intravenski'),
(30.00, 'mg/kg', 'intravenski'),
(50.00, 'mg/kg', 'intravenski'),
(75.00, 'mg/kg', 'intravenski'),
(100.00, 'mg/kg', 'intravenski'),
(150.00, 'mg/kg', 'intravenski'),
(1.00, 'mg/kg', 'intraperitonealno'),
(2.50, 'mg/kg', 'intraperitonealno'),
(5.00, 'mg/kg', 'intraperitonealno'),
(10.00, 'mg/kg', 'intraperitonealno'),
(20.00, 'mg/kg', 'intraperitonealno'),
(30.00, 'mg/kg', 'intraperitonealno'),
(40.00, 'mg/kg', 'intraperitonealno'),
(50.00, 'mg/kg', 'intraperitonealno'),
(75.00, 'mg/kg', 'intraperitonealno'),
(100.00, 'mg/kg', 'intraperitonealno'),
(1.00, 'µM', 'u medijum'),
(2.50, 'µM', 'u medijum'),
(5.00, 'µM', 'u medijum'),
(10.00, 'µM', 'u medijum'),
(25.00, 'µM', 'u medijum'),
(50.00, 'µM', 'u medijum'),
(100.00, 'µM', 'u medijum'),
(200.00, 'µM', 'u medijum'),
(500.00, 'µM', 'u medijum'),
(1000.00, 'µM', 'u medijum'),
(0.10, 'µg/ml', 'u medijum'),
(0.50, 'µg/ml', 'u medijum'),
(1.00, 'µg/ml', 'u medijum'),
(2.50, 'µg/ml', 'u medijum'),
(5.00, 'µg/ml', 'u medijum'),
(10.00, 'µg/ml', 'u medijum'),
(25.00, 'µg/ml', 'u medijum'),
(50.00, 'µg/ml', 'u medijum'),
(100.00, 'µg/ml', 'u medijum'),
(200.00, 'µg/ml', 'u medijum'),
(0.10, 'mg/kg', 'oralno'),
(0.25, 'mg/kg', 'oralno'),
(0.50, 'mg/kg', 'oralno'),
(0.10, 'mg/kg', 'intravenski'),
(0.25, 'mg/kg', 'intravenski'),
(0.50, 'mg/kg', 'intravenski'),
(0.10, 'mg/kg', 'intraperitonealno'),
(0.25, 'mg/kg', 'intraperitonealno'),
(0.50, 'mg/kg', 'intraperitonealno'),
(1.00, 'µg/kg', 'intravenski'),
(5.00, 'µg/kg', 'intravenski'),
(10.00, 'µg/kg', 'intravenski'),
(25.00, 'µg/kg', 'intravenski'),
(50.00, 'µg/kg', 'intravenski'),
(1.00, 'µg/kg', 'oralno'),
(5.00, 'µg/kg', 'oralno'),
(10.00, 'µg/kg', 'oralno'),
(25.00, 'µg/kg', 'oralno'),
(50.00, 'µg/kg', 'oralno'),
(1.00, 'nmol/kg', 'intravenski'),
(5.00, 'nmol/kg', 'intravenski'),
(10.00, 'nmol/kg', 'intravenski'),
(1.00, 'nmol', 'u medijum'),
(5.00, 'nmol', 'u medijum'),
(10.00, 'nmol', 'u medijum'),
(25.00, 'nmol', 'u medijum'),
(50.00, 'nmol', 'u medijum'),
(100.00, 'nmol', 'u medijum'),
(0.01, 'µM', 'u medijum'),
(0.05, 'µM', 'u medijum'),
(0.10, 'µM', 'u medijum'),
(0.25, 'µM', 'u medijum'),
(0.50, 'µM', 'u medijum'),
(750.00, 'µM', 'u medijum'),
(1500.00, 'µM', 'u medijum'),
(600.00, 'mg/kg', 'oralno'),
(700.00, 'mg/kg', 'oralno'),
(800.00, 'mg/kg', 'oralno'),
(900.00, 'mg/kg', 'oralno'),
(1000.00, 'mg/kg', 'oralno');

INSERT INTO laboratorija (naziv, zgrada, sprat, br_prostorije, biosafety_id) VALUES
('Laboratorija za in vitro citotoksičnost', 'Zgrada A', 2, '201', 2),
('Laboratorija za farmakokinetiku i bioanalizu', 'Zgrada A', 3, '301', 2),
('Laboratorija za bihevioralna istraživanja na glodarima', 'Zgrada B', 1, '101', 2),
('Laboratorija za hroničnu toksičnost', 'Zgrada B', 2, '205', 2),
('Vivarijum', 'Zgrada C', 1, '001', 1);

INSERT INTO resurs (naziv, opis) VALUES
('Aspirin', 'Analgetik i antiinflamatorno jedinjenje, acetilsalicilna kiselina.'),
('Ibuprofen', 'Nesteroidni antiinflamatorni lek koji inhibira COX enzime.'),
('Paracetamol', 'Analgetik i antipiretik, mehanizam dejstva još uvek se istražuje.'),
('Cisplatin', 'Antikancerski lek koji formira unakrsne veze sa DNK.'),
('Doxorubicin', 'Antikancerski antibiotik koji inhibira topoizomerazu II.'),
('Metformin', 'Antidijabetik koji smanjuje produkciju glukoze u jetri.'),
('Atorvastatin', 'Inhibitor HMG-CoA reduktaze za snižavanje holesterola.'),
('Amoksicilin', 'Antibiotik iz grupe penicilina širokog spektra.'),
('Flukonazol', 'Antimikotik koji inhibira sintezu ergosterola.'),
('Oseltamivir', 'Antivirusni lek koji inhibira neuraminidazu influence.'),
('HeLa ćelije', 'Besmrtna ćelijska linija dobijena od cervikalnog karcinoma.'),
('HepG2 ćelije', 'Ćelijska linija humanog hepatocelularnog karcinoma.'),
('MCF-7 ćelije', 'Ćelijska linija karcinoma dojke.'),
('A549 ćelije', 'Ćelijska linija adenokarcinoma pluća.'),
('RAW 264.7 ćelije', 'Mišja makrofagna ćelijska linija.'),
('Wistar pacov', 'Laboratorijski soj pacova koji se koristi u farmakološkim istraživanjima.'),
('Sprague-Dawley pacov', 'Albino soj pacova koji se koristi u toksikološkim studijama.'),
('C57BL/6 miš', 'Inbred soj miša koji se koristi u imunološkim istraživanjima.'),
('BALB/c miš', 'Inbred albino soj miša koji se koristi u onkološkim istraživanjima.'),
('DMSO', 'Dimetil sulfoksid, rastvarač za rastvoranje hidrofobnih jedinjenja.'),
('PBS pufer', 'Fosfatni pufer sa fiziološkim salinitetom za razblažvanje uzoraka.'),
('DMEM medijum', 'Dulbeccov modifikovani Eagleov medijum za kultivaciju ćelija.'),
('RPMI medijum', 'Medijum za kultivaciju suspenzionih ćelija.'),
('FBS serum', 'Fetalni goveđi serum kao suplement za ćelijske kulture.'),
('Mikropipete 96-well', 'Ploče sa 96 jamica za visokoproduktivno testiranje.'),
('Špricevi 1ml', 'Jednokratni špricevi za precizno doziranje malih zapremina.'),
('Igle 25G', 'Igle za intraperitonealne i intramuskularne injekcije.'),
('MTT reagens', 'Reagens za kolorimetrijsko određivanje viabilnosti ćelija.'),
('Trypan blue', 'Boja za određivanje broja živih i mrtvih ćelija.'),
('Etanol 70%', 'Dezinficijens za sterilizaciju radnih površina.'),
('Erlotinib', 'Inhibitor EGFR tirozin kinaze za lečenje karcinoma pluća.'),
('Gefitinib', 'Selektivni inhibitor EGFR za lečenje karcinoma pluća.'),
('Sorafenib', 'Multikinazni inhibitor za lečenje hepatocelularnog karcinoma.'),
('Sunitinib', 'Inhibitor tirozin kinaze za lečenje bubrežnog karcinoma.'),
('Temozolomid', 'Alkilujući agens za lečenje glioblastoma.'),
('Vinkristin', 'Vinka alkaloid koji inhibira polimerizaciju tubulina.'),
('Paklitaksel', 'Taksanski lek koji stabilizuje mikrotubule.'),
('Karboplatina', 'Analog cisplatina sa manjim nuspojavama.'),
('Fluorouracil', 'Antimetabolit koji inhibira sintezu timidilata.'),
('Gemcitabin', 'Nukleozidni analog za lečenje karcinoma pankreasa.'),
('NIH 3T3 ćelije', 'Mišja fibroblastna ćelijska linija.'),
('Vero ćelije', 'Ćelijska linija bubrega afričke zelene majmunke.'),
('CHO ćelije', 'Ćelijska linija jajnika kineskog hrčka.'),
('PC-3 ćelije', 'Ćelijska linija karcinoma prostate.'),
('U87 ćelije', 'Ćelijska linija glioblastoma.'),
('Swiss Webster miš', 'Outbred soj miša za opšte farmakološke studije.'),
('Nude miš', 'Atimični miš za ksenograft tumorske studije.'),
('Fischer 344 pacov', 'Inbred soj pacova za kancerogene studije.'),
('Lewis pacov', 'Soj pacova za imunološka istraživanja.'),
('Gvineja svinja', 'Koristi se u alergološkim i dermatološkim studijama.'),
('Tris pufer', 'Pufer za molekularno-biološke primene.'),
('HEPES pufer', 'Pufer za ćelijske kulture i enzimske testove.'),
('Agaroza', 'Polisaharid za gel elektroforezu nukleinskih kiselina.'),
('SDS', 'Natrijum dodecil sulfat za denaturišuću elektroforezu proteina.'),
('Akrilamid', 'Monomer za pripremu poliakrilamidnih gelova.'),
('Trypsin-EDTA', 'Enzimski rastvor za odvajanje adherentnih ćelija.'),
('Penicilin-Streptomicin', 'Antibiotski suplement za sprečavanje kontaminacije kultura.'),
('L-glutamin', 'Aminokiselinski suplement za ćelijske kulture.'),
('Propidijum jodid', 'Fluorescenntna boja za detekciju mrtvih ćelija.'),
('Annexin V', 'Marker za detekciju apoptoze flow citometrijom.'),
('FITC antitelo', 'Fluorescentno obeleženo antitelo za imunohistohemiju.'),
('Western blot membrana', 'PVDF membrana za transfer proteina.'),
('ECL reagens', 'Reagens za hemiluminiscentnu detekciju proteina.'),
('Proteazni inhibitori', 'Koktel inhibitora proteaza za zaštitu uzoraka.'),
('Bradford reagens', 'Reagens za kolorimetrijsko određivanje koncentracije proteina.'),
('Lizosomski pufer', 'Pufer za liziranje ćelija i ekstrakciju proteina.'),
('Formaldehid 4%', 'Fiksativ za histološke preparate.'),
('Ksilen', 'Rastvarač za deparafinizaciju histoloških preparata.'),
('Hematoksilin', 'Boja za bojenje jedara u histologiji.'),
('Eozin', 'Boja za bojenje citoplazme u histologiji.'),
('Apsolutni etanol', 'Rastvarač i dehidratans za histološke preparate.'),
('Izofluran', 'Inhalacioni anestetik za laboratorijske životinje.'),
('Ketamin', 'Injekcioni anestetik za laboratorijske životinje.'),
('Ksilasin', 'Sedativ i analgetik za laboratorijske životinje.'),
('Heparin', 'Antikoagulans za uzorkovanje krvi.'),
('EDTA epruvete', 'Epruvete sa antikoagulansom za uzorkovanje krvi.'),
('Serum epruvete', 'Epruvete za uzorkovanje seruma.'),
('Acetonitril', 'Rastvarač za HPLC analizu.'),
('Metanol', 'Rastvarač za pripremu mobilnih faza u HPLC.'),
('Mravlja kiselina', 'Aditiv za mobilnu fazu u LC-MS analizi.'),
('Amonijum acetat', 'Pufer za mobilnu fazu u LC-MS analizi.'),
('Interni standard', 'Jedinjenje poznate koncentracije za kalibraciju LC-MS.'),
('Kalibracioni standardi', 'Set rastvora poznatih koncentracija za izradu kalibracione krive.'),
('Kontrolni uzorci', 'Uzorci poznate koncentracije za validaciju metode.'),
('Mikrotubice 1.5ml', 'Plastične tubice za čuvanje i centrifugiranje uzoraka.'),
('Mikrotubice 2ml', 'Plastične tubice većeg kapaciteta za uzorke.'),
('Kriotubice', 'Tubice za dugoročno čuvanje uzoraka na -80°C.'),
('Falkon tubice 15ml', 'Konične tubice za centrifugiranje većih zapremina.'),
('Falkon tubice 50ml', 'Konične tubice za centrifugiranje i čuvanje rastvora.'),
('Petrijevke', 'Posude za kultivaciju adherentnih ćelija.'),
('Flaskovi T25', 'Flaskovi površine 25 cm2 za kultivaciju ćelija.'),
('Flaskovi T75', 'Flaskovi površine 75 cm2 za kultivaciju ćelija.'),
('Flaskovi T175', 'Flaskovi površine 175 cm2 za veliki uzgoj ćelija.'),
('Ploče 6-well', 'Ploče sa 6 jamica za eksperimente sa većim zapreminama.'),
('Ploče 24-well', 'Ploče sa 24 jamice za srednje eksperimente.'),
('Ploče 96-well', 'Ploče sa 96 jamica za visokoproduktivno testiranje.'),
('Ploče 384-well', 'Ploče sa 384 jamice za ultra-visokoproduktivno testiranje.'),
('Nitrilne rukavice', 'Zaštitne rukavice za rad u laboratoriji.'),
('Laboratorijski mantil', 'Zaštitna odeća za rad u laboratoriji.'),
('Zaštitne naočare', 'Zaštita za oči pri radu sa hemikalijama.');

SELECT resurs_id, naziv FROM resurs;

INSERT INTO jedinjenje (resurs_id, cas_broj, formula, mol_masa, terapijska_klasa, status_razvoja) VALUES
(1, '50-78-2', 'C9H8O4', 180.16, 'Analgetik', 'Odobren'),
(2, '15687-27-1', 'C13H18O2', 206.28, 'NSAID', 'Odobren'),
(3, '103-90-2', 'C8H9NO2', 151.16, 'Analgetik', 'Odobren'),
(4, '15663-27-1', 'Cl2H6N2Pt', 300.05, 'Antikancerski', 'Odobren'),
(5, '23214-92-8', 'C27H29NO11', 543.52, 'Antikancerski', 'Odobren'),
(6, '657-24-9', 'C4H11N5', 129.16, 'Antidijabetik', 'Odobren'),
(7, '134523-00-5', 'C33H35FN2O5', 558.64, 'Hipolipemik', 'Odobren'),
(8, '26787-78-0', 'C16H19N3O5S', 365.40, 'Antibiotik', 'Odobren'),
(9, '86386-73-4', 'C13H12F2N6O', 306.27, 'Antimikotik', 'Odobren'),
(10, '204255-11-8', 'C16H28N2O4', 312.40, 'Antivirusni', 'Odobren'),
(31, '183319-69-9', 'C22H23N3O4', 393.44, 'Inhibitor kinaze', 'Odobren'),
(32, '184475-35-2', 'C22H24ClFN4O3', 446.90, 'Inhibitor kinaze', 'Odobren'),
(33, '284461-73-0', 'C21H16ClF3N4O3', 464.82, 'Antikancerski', 'Odobren'),
(34, '341031-54-7', 'C22H27FN4O2S', 452.54, 'Inhibitor kinaze', 'Odobren'),
(35, '85622-93-1', 'C6H6N6O2', 194.15, 'Alkilujući agens', 'Odobren'),
(36, '57-22-7', 'C46H56N4O10', 824.95, 'Vinka alkaloid', 'Odobren'),
(37, '33069-62-4', 'C47H51NO14', 853.91, 'Taksanski lek', 'Odobren'),
(38, '41575-94-4', 'C6H12N2O4Pt', 371.25, 'Antikancerski', 'Odobren'),
(39, '51-21-8', 'C4H3FN2O2', 130.08, 'Antimetabolit', 'Odobren'),
(40, '95058-81-4', 'C9H11F2N3O4', 263.19, 'Antimetabolit', 'Odobren');

INSERT INTO celijska_linija (resurs_id, naziv_linije, poreklo) VALUES
(11, 'HeLa', 'Humani cervikalni karcinom'),
(12, 'HepG2', 'Humani hepatocelularni karcinom'),
(13, 'MCF-7', 'Humani karcinom dojke'),
(14, 'A549', 'Humani adenokarcinom pluća'),
(15, 'RAW 264.7', 'Mišji makrofagi'),
(41, 'NIH 3T3', 'Mišji fibroblasti'),
(42, 'Vero', 'Bubreg afričke zelene majmunke'),
(43, 'CHO', 'Jajnik kineskog hrčka'),
(44, 'PC-3', 'Humani karcinom prostate'),
(45, 'U87', 'Humani glioblastom');

INSERT INTO zivotinja (resurs_id, soj, vrsta) VALUES
(16, 'Wistar', 'Rattus norvegicus'),
(17, 'Sprague-Dawley', 'Rattus norvegicus'),
(18, 'C57BL/6', 'Mus musculus'),
(19, 'BALB/c', 'Mus musculus'),
(46, 'Swiss Webster', 'Mus musculus'),
(47, 'Nude', 'Mus musculus'),
(48, 'Fischer 344', 'Rattus norvegicus'),
(49, 'Lewis', 'Rattus norvegicus');

INSERT INTO reagens (resurs_id, koncentracija, rastvarac) VALUES
(20, '100%', NULL),
(21, '1X', 'Voda'),
(22, NULL, NULL),
(23, NULL, NULL),
(24, '10%', NULL),
(25, NULL, NULL),
(26, NULL, NULL),
(27, '5mg/ml', 'PBS'),
(28, '0.4%', 'PBS'),
(29, '70%', 'Voda'),
(50, NULL, NULL),
(51, NULL, NULL),
(52, '1%', 'Voda'),
(53, '10%', 'Voda'),
(54, '30%', 'Voda'),
(55, '0.25%', 'PBS'),
(56, '10000 U/ml', 'PBS'),
(57, '200mM', 'Voda'),
(58, NULL, NULL),
(59, NULL, NULL),
(60, NULL, NULL),
(61, NULL, NULL),
(62, NULL, NULL),
(63, NULL, NULL),
(64, NULL, NULL),
(65, '4%', 'Voda'),
(66, '100%', NULL),
(67, '1%', 'Voda'),
(68, '1%', 'Etanol'),
(69, '100%', NULL),
(70, '2%', 'Sezamovo ulje'),
(71, '100mg/ml', 'Voda'),
(72, '1000 U/ml', 'Voda'),
(73, NULL, NULL),
(74, NULL, NULL),
(75, '100%', NULL),
(76, '100%', NULL),
(77, '0.1%', 'Voda'),
(78, '100mM', 'Voda'),
(79, NULL, NULL),
(80, NULL, NULL),
(81, NULL, NULL),
(82, NULL, NULL),
(83, NULL, NULL),
(84, NULL, NULL),
(85, NULL, NULL),
(86, NULL, NULL),
(87, NULL, NULL),
(88, NULL, NULL),
(89, NULL, NULL),
(90, NULL, NULL),
(91, NULL, NULL),
(92, NULL, NULL),
(93, NULL, NULL),
(94, NULL, NULL),
(95, NULL, NULL),
(96, NULL, NULL),
(97, NULL, NULL),
(98, NULL, NULL),
(99, NULL, NULL),
(100, NULL, NULL);

INSERT INTO sertifikat (naziv, opis, biosafety_id) VALUES
('GLP sertifikat', 'Good Laboratory Practice - međunarodni standard za rad u pretkliničkim laboratorijama.', 1),
('FELASA B', 'Sertifikat za rad sa laboratorijskim životinjama prema evropskim standardima, nivo B.', 2),
('FELASA C', 'Sertifikat za rad sa laboratorijskim životinjama prema evropskim standardima, nivo C.', 2),
('BSL-2 ovlašćenje', 'Ovlašćenje za rad u laboratorijama drugog nivoa biološke bezbednosti.', 2),
('GCP sertifikat', 'Good Clinical Practice - standard za klinička istraživanja.', 1),
('ISO 17025', 'Akreditacija laboratorije za ispitivanje i kalibraciju.', 2),
('AAALAC akreditacija', 'Akreditacija za negu i upotrebu laboratorijskih životinja.', 2);

INSERT INTO istrazivac (ime, prezime, jmbg, email, dob, dat_zaposlenja, akademska_titula, god_iskustva, lab_id) VALUES
('Ana', 'Petrović', '1990010112345', 'ana.petrovic@pharma.rs', '1990-01-01', '2015-03-01', 'PhD', 10, 1),
('Marko', 'Jovanović', '1985020223456', 'marko.jovanovic@pharma.rs', '1985-02-02', '2010-06-15', 'PhD', 15, 2),
('Jelena', 'Nikolić', '1992030334567', 'jelena.nikolic@pharma.rs', '1992-03-03', '2017-09-01', 'MSc', 7, 1),
('Stefan', 'Đorđević', '1988040445678', 'stefan.djordjevic@pharma.rs', '1988-04-04', '2013-01-10', 'PhD', 12, 3),
('Milica', 'Popović', '1995050556789', 'milica.popovic@pharma.rs', '1995-05-05', '2020-02-01', 'MSc', 4, 2),
('Nikola', 'Stanković', '1983060667890', 'nikola.stankovic@pharma.rs', '1983-06-06', '2008-07-20', 'PhD', 17, 4),
('Ivana', 'Vasić', '1991070778901', 'ivana.vasic@pharma.rs', '1991-07-07', '2016-04-15', 'MSc', 8, 1),
('Petar', 'Ilić', '1987080889012', 'petar.ilic@pharma.rs', '1987-08-08', '2012-11-01', 'PhD', 13, 5),
('Maja', 'Marković', '1993090990123', 'maja.markovic@pharma.rs', '1993-09-09', '2018-06-01', 'BSc', 6, 3),
('Luka', 'Stojanović', '1986101001234', 'luka.stojanovic@pharma.rs', '1986-10-10', '2011-03-15', 'PhD', 14, 2),
('Sonja', 'Đurić', '1994111112345', 'sonja.djuric@pharma.rs', '1994-11-11', '2019-09-01', 'MSc', 5, 4),
('Aleksandar', 'Pavlović', '1989121223456', 'aleksandar.pavlovic@pharma.rs', '1989-12-12', '2014-05-01', 'PhD', 11, 1),
('Tijana', 'Lazić', '1996010134567', 'tijana.lazic@pharma.rs', '1996-01-01', '2021-01-15', 'MSc', 3, 2),
('Nemanja', 'Kovačević', '1984020245678', 'nemanja.kovacevic@pharma.rs', '1984-02-02', '2009-08-01', 'PhD', 16, 3),
('Katarina', 'Simić', '1997030356789', 'katarina.simic@pharma.rs', '1997-03-03', '2022-03-01', 'BSc', 2, 5),
('Dragan', 'Tomić', '1982040467890', 'dragan.tomic@pharma.rs', '1982-04-04', '2007-06-15', 'PhD', 18, 4),
('Vesna', 'Milošević', '1990050578901', 'vesna.milosevic@pharma.rs', '1990-05-05', '2015-09-01', 'MSc', 9, 1),
('Boris', 'Radović', '1986060689012', 'boris.radovic@pharma.rs', '1986-06-06', '2011-12-01', 'PhD', 13, 2),
('Dragana', 'Filipović', '1993070790123', 'dragana.filipovic@pharma.rs', '1993-07-07', '2018-04-15', 'MSc', 6, 3),
('Miloš', 'Janković', '1988080801234', 'milos.jankovic@pharma.rs', '1988-08-08', '2013-07-01', 'PhD', 12, 4),
('Nataša', 'Aleksić', '1995090912345', 'natasa.aleksic@pharma.rs', '1995-09-09', '2020-06-01', 'MSc', 4, 5),
('Zoran', 'Marinković', '1981101023456', 'zoran.marinkovic@pharma.rs', '1981-10-10', '2006-03-15', 'PhD', 19, 1),
('Sanja', 'Nedeljković', '1992111134567', 'sanja.nedeljkovic@pharma.rs', '1992-11-11', '2017-11-01', 'MSc', 7, 2),
('Vladan', 'Kostić', '1985121245678', 'vladan.kostic@pharma.rs', '1985-12-12', '2010-09-01', 'PhD', 15, 3),
('Jelena', 'Bogdanović', '1998010156789', 'jelena.bogdanovic@pharma.rs', '1998-01-01', '2022-09-01', 'BSc', 1, 4),
('Goran', 'Đorđević', '1983020267890', 'goran.djordjevic@pharma.rs', '1983-02-02', '2008-04-15', 'PhD', 17, 5),
('Tamara', 'Vuković', '1991030378901', 'tamara.vukovic@pharma.rs', '1991-03-03', '2016-07-01', 'MSc', 8, 1),
('Ivan', 'Pejović', '1987040489012', 'ivan.pejovic@pharma.rs', '1987-04-04', '2012-02-15', 'PhD', 13, 2),
('Gordana', 'Stefanović', '1994050590123', 'gordana.stefanovic@pharma.rs', '1994-05-05', '2019-05-01', 'MSc', 5, 3),
('Nemanja', 'Živković', '1989060601234', 'nemanja.zivkovic@pharma.rs', '1989-06-06', '2014-10-01', 'PhD', 11, 4),
('Milena', 'Todorović', '1996070712345', 'milena.todorovic@pharma.rs', '1996-07-07', '2021-04-15', 'MSc', 3, 5),
('Srđan', 'Savić', '1984080823456', 'srdjan.savic@pharma.rs', '1984-08-08', '2009-11-01', 'PhD', 16, 1),
('Aleksandra', 'Lukić', '1997090934567', 'aleksandra.lukic@pharma.rs', '1997-09-09', '2022-06-01', 'BSc', 2, 2),
('Bojan', 'Mitić', '1982101045678', 'bojan.mitic@pharma.rs', '1982-10-10', '2007-09-15', 'PhD', 18, 3),
('Jovana', 'Stanojević', '1990111156789', 'jovana.stanojevic@pharma.rs', '1990-11-11', '2015-12-01', 'MSc', 9, 4),
('Dejan', 'Cvetković', '1986121267890', 'dejan.cvetkovic@pharma.rs', '1986-12-12', '2011-06-15', 'PhD', 14, 5),
('Ivana', 'Milić', '1993010178901', 'ivana.milic@pharma.rs', '1993-01-01', '2018-02-01', 'MSc', 6, 1),
('Predrag', 'Obradović', '1988020289012', 'predrag.obradovic@pharma.rs', '1988-02-02', '2013-05-01', 'PhD', 12, 2),
('Zorica', 'Đurđević', '1995030390123', 'zorica.djurdjevic@pharma.rs', '1995-03-03', '2020-09-01', 'MSc', 4, 3),
('Marko', 'Lazarević', '1981040401234', 'marko.lazarevic@pharma.rs', '1981-04-04', '2006-07-15', 'PhD', 19, 4),
('Nina', 'Bošković', '1992050512345', 'nina.boskovic@pharma.rs', '1992-05-05', '2017-03-01', 'MSc', 7, 5),
('Slobodan', 'Vukašinović', '1987060623456', 'slobodan.vukasinovic@pharma.rs', '1987-06-06', '2012-08-15', 'PhD', 13, 1),
('Jelena', 'Ristić', '1994070734567', 'jelena.ristic@pharma.rs', '1994-07-07', '2019-11-01', 'MSc', 5, 2),
('Uroš', 'Đorđević', '1989080845678', 'uros.djordjevic@pharma.rs', '1989-08-08', '2014-02-01', 'PhD', 11, 3),
('Biljana', 'Nikolajević', '1996090956789', 'biljana.nikolajevic@pharma.rs', '1996-09-09', '2021-07-15', 'MSc', 3, 4),
('Miroslav', 'Panić', '1983101067890', 'miroslav.panic@pharma.rs', '1983-10-10', '2008-12-01', 'PhD', 17, 5),
('Milena', 'Ilić', '1990111178901', 'milena.ilic2@pharma.rs', '1990-11-11', '2015-06-15', 'MSc', 9, 1),
('Aleksandar', 'Vučković', '1986121289012', 'aleksandar.vuckovic@pharma.rs', '1986-12-12', '2011-09-01', 'PhD', 14, 2),
('Jasna', 'Antonić', '1993010190123', 'jasna.antonic@pharma.rs', '1993-01-01', '2018-07-01', 'MSc', 6, 3),
('Nemanja', 'Đorđević', '1988020201234', 'nemanja.djordjevic2@pharma.rs', '1988-02-02', '2013-10-15', 'PhD', 12, 4),
('Snežana', 'Petrović', '1995030312345', 'snezana.petrovic@pharma.rs', '1995-03-03', '2020-12-01', 'MSc', 4, 5),
('Vojislav', 'Marjanović', '1981040423456', 'vojislav.marjanovic@pharma.rs', '1981-04-04', '2006-10-15', 'PhD', 19, 1),
('Tatjana', 'Milovanović', '1992050534567', 'tatjana.milovanovic@pharma.rs', '1992-05-05', '2017-06-01', 'MSc', 7, 2),
('Radoslav', 'Kovač', '1987060645678', 'radoslav.kovac@pharma.rs', '1987-06-06', '2012-11-15', 'PhD', 13, 3),
('Dragica', 'Stojadinović', '1994070756789', 'dragica.stojadinovic@pharma.rs', '1994-07-07', '2019-02-01', 'MSc', 5, 4),
('Uglješa', 'Babić', '1989080867890', 'ugljes.babic@pharma.rs', '1989-08-08', '2014-05-15', 'PhD', 11, 5),
('Olivera', 'Radosavljević', '1996090978901', 'olivera.radosavljevic@pharma.rs', '1996-09-09', '2021-10-01', 'MSc', 3, 1),
('Dušan', 'Milošević', '1983101089012', 'dusan.milosevic@pharma.rs', '1983-10-10', '2008-03-15', 'PhD', 17, 2),
('Svetlana', 'Janković', '1990111190123', 'svetlana.jankovic@pharma.rs', '1990-11-11', '2015-09-01', 'MSc', 9, 3),
('Branislav', 'Đorđević', '1986121201234', 'branislav.djordjevic@pharma.rs', '1986-12-12', '2011-12-15', 'PhD', 14, 4),
('Nataša', 'Vuković', '1993010212345', 'natasa.vukovic2@pharma.rs', '1993-01-02', '2018-10-01', 'MSc', 6, 5),
('Danilo', 'Lukić', '1988020223456', 'danilo.lukic@pharma.rs', '1988-02-03', '2013-03-01', 'PhD', 12, 1),
('Vesna', 'Jovanović', '1995030334567', 'vesna.jovanovic@pharma.rs', '1995-03-04', '2020-03-15', 'MSc', 4, 2),
('Nikola', 'Petrović', '1981040445678', 'nikola.petrovic@pharma.rs', '1981-04-05', '2006-12-01', 'PhD', 19, 3),
('Milica', 'Stanković', '1992050556789', 'milica.stankovic@pharma.rs', '1992-05-06', '2017-09-15', 'MSc', 7, 4),
('Lazar', 'Simić', '1987060667890', 'lazar.simic@pharma.rs', '1987-06-07', '2012-04-01', 'PhD', 13, 5),
('Jelena', 'Marković', '1994070778901', 'jelena.markovic2@pharma.rs', '1994-07-08', '2019-06-15', 'MSc', 5, 1),
('Vladislav', 'Filipović', '1989080889012', 'vladislav.filipovic@pharma.rs', '1989-08-09', '2014-08-01', 'PhD', 11, 2),
('Anđela', 'Đurić', '1996090990123', 'andjela.djuric@pharma.rs', '1996-09-10', '2022-01-15', 'BSc', 2, 3),
('Slobodan', 'Aleksić', '1983101001234', 'slobodan.aleksic@pharma.rs', '1983-10-11', '2009-06-01', 'PhD', 16, 4),
('Dijana', 'Nedeljković', '1990111112345', 'dijana.nedeljkovic@pharma.rs', '1990-11-12', '2016-01-15', 'MSc', 8, 5),
('Čedomir', 'Kostić', '1986121223456', 'cedomir.kostic@pharma.rs', '1986-12-13', '2012-07-01', 'PhD', 13, 1),
('Milana', 'Bogdanović', '1993010134567', 'milana.bogdanovic@pharma.rs', '1993-01-14', '2018-12-15', 'MSc', 6, 2),
('Mihailo', 'Vuković', '1988020245678', 'mihailo.vukovic@pharma.rs', '1988-02-15', '2014-11-01', 'PhD', 11, 3),
('Gordana', 'Pejović', '1995030356789', 'gordana.pejovic@pharma.rs', '1995-03-16', '2021-02-15', 'MSc', 3, 4),
('Rastko', 'Stefanović', '1981040467890', 'rastko.stefanovic@pharma.rs', '1981-04-17', '2007-03-01', 'PhD', 18, 5),
('Ivana', 'Živković', '1992050578901', 'ivana.zivkovic@pharma.rs', '1992-05-18', '2017-12-15', 'MSc', 7, 1),
('Miodrag', 'Savić', '1987060689012', 'miodrag.savic@pharma.rs', '1987-06-19', '2013-01-01', 'PhD', 12, 2),
('Bojana', 'Mitić', '1994070790123', 'bojana.mitic@pharma.rs', '1994-07-20', '2020-04-15', 'MSc', 4, 3),
('Nenad', 'Stanojević', '1989080801234', 'nenad.stanojevic@pharma.rs', '1989-08-21', '2015-03-01', 'PhD', 10, 4),
('Milijana', 'Cvetković', '1996090912345', 'milijana.cvetkovic@pharma.rs', '1996-09-22', '2022-04-15', 'BSc', 1, 5),
('Nemanja', 'Obradović', '1983101023456', 'nemanja.obradovic@pharma.rs', '1983-10-23', '2009-09-01', 'PhD', 15, 1),
('Slavica', 'Đurđević', '1990111134567', 'slavica.djurdjevic@pharma.rs', '1990-11-24', '2016-04-15', 'MSc', 8, 2),
('Predrag', 'Lazarević', '1986121245678', 'predrag.lazarevic@pharma.rs', '1986-12-25', '2012-10-01', 'PhD', 13, 3),
('Zorana', 'Bošković', '1993010156789', 'zorana.boskovic@pharma.rs', '1993-01-26', '2019-03-15', 'MSc', 5, 4),
('Vojkan', 'Vukašinović', '1988020267890', 'vojkan.vukasinovic@pharma.rs', '1988-02-27', '2014-06-01', 'PhD', 11, 5),
('Bojana', 'Ristić', '1995030378901', 'bojana.ristic@pharma.rs', '1995-03-28', '2021-05-15', 'MSc', 3, 1),
('Aleksandar', 'Kovač', '1981040489012', 'aleksandar.kovac@pharma.rs', '1981-04-29', '2007-07-01', 'PhD', 18, 2),
('Jelena', 'Nikolajević', '1992050590123', 'jelena.nikolajevic@pharma.rs', '1992-05-30', '2018-01-15', 'MSc', 6, 3),
('Mirko', 'Panić', '1987060601234', 'mirko.panic@pharma.rs', '1987-06-30', '2013-04-01', 'PhD', 12, 4),
('Sanja', 'Ilić', '1994070712345', 'sanja.ilic@pharma.rs', '1994-07-15', '2020-07-15', 'MSc', 4, 5),
('Dragan', 'Milošević', '1989080823456', 'dragan.milosevic@pharma.rs', '1989-08-16', '2015-06-01', 'PhD', 10, 1),
('Jelena', 'Janković', '1996090934567', 'jelena.jankovic@pharma.rs', '1996-09-17', '2022-07-15', 'BSc', 1, 2);
INSERT INTO istrazivac (ime, prezime, jmbg, email, dob, dat_zaposlenja, akademska_titula, god_iskustva, lab_id) VALUES
('Marija', 'Petrović', '1991010194001', 'marija.petrovic@pharma.rs', '1991-01-01', '2016-05-01', 'MSc', 8, 1),
('Filip', 'Jovanović', '1988020294002', 'filip.jovanovic@pharma.rs', '1988-02-02', '2013-08-15', 'PhD', 12, 2),
('Ana', 'Nikolić', '1995030394003', 'ana.nikolic2@pharma.rs', '1995-03-03', '2020-11-01', 'MSc', 4, 3),
('Stevan', 'Popović', '1983040494004', 'stevan.popovic@pharma.rs', '1983-04-04', '2008-06-15', 'PhD', 17, 4),
('Maja', 'Stanković', '1992050594005', 'maja.stankovic@pharma.rs', '1992-05-05', '2017-02-01', 'MSc', 7, 5),
('Bojan', 'Đorđević', '1987060694006', 'bojan.djordjevic@pharma.rs', '1987-06-06', '2012-09-15', 'PhD', 13, 1),
('Ivana', 'Vasiljević', '1994070794007', 'ivana.vasiljevic@pharma.rs', '1994-07-07', '2019-04-01', 'MSc', 5, 2);

INSERT INTO dizajner (istrazivac_id, br_radova, orcid) VALUES
(1, 45, '0000-0001-1234-5678'),
(2, 67, '0000-0002-2345-6789'),
(4, 38, '0000-0003-3456-7890'),
(6, 82, '0000-0004-4567-8901'),
(8, 51, '0000-0005-5678-9012'),
(10, 43, '0000-0006-6789-0123'),
(12, 29, '0000-0007-7890-1234'),
(14, 71, '0000-0008-8901-2345'),
(16, 55, '0000-0009-9012-3456'),
(18, 33, '0000-0010-0123-4567'),
(20, 48, '0000-0011-1234-5679'),
(22, 76, '0000-0012-2345-6780'),
(24, 41, '0000-0013-3456-7891'),
(26, 37, '0000-0014-4567-8902'),
(28, 62, '0000-0015-5678-9013'),
(30, 28, '0000-0016-6789-0124'),
(32, 54, '0000-0017-7890-1235'),
(34, 44, '0000-0018-8901-2346'),
(36, 39, '0000-0019-9012-3457'),
(38, 58, '0000-0020-0123-4568');

INSERT INTO izvodjac (istrazivac_id) VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
(41),(42),(43),(44),(45),(46),(47),(48),(49),(50),
(51),(52),(53),(54),(55),(56),(57),(58),(59),(60),
(61),(62),(63),(64),(65),(66),(67),(68),(69),(70),
(71),(72),(73),(74),(75),(76),(77),(78),(79),(80),
(81),(82),(83),(84),(85),(86),(87),(88),(89),(90),
(91),(92),(93);
INSERT INTO izvodjac (istrazivac_id) VALUES (94),(95),(96),(97),(98),(99),(100);

INSERT INTO teorija (naziv, opis, dizajner_id) VALUES
('Farmakokinetička ADME teorija', 'Teorija koja opisuje apsorpciju, distribuciju, metabolizam i ekskreciju lekova u organizmu.', 1),
('Receptorska teorija dejstva lekova', 'Teorija o vezivanju lekova za specifične receptore i izazivanju farmakološkog efekta.', 2),
('Hill-ov model doza-odgovor', 'Matematički model koji opisuje odnos između doze leka i farmakološkog odgovora.', 4),
('Teorija akutne toksičnosti', 'Teorija koja opisuje mehanizme akutnog toksičnog dejstva jedinjenja na organizam.', 6),
('Teorija enzimske inhibicije', 'Teorija o mehanizmima inhibicije enzima i njihovim farmakološkim posledicama.', 8),
('Teorija ćelijske apoptoze', 'Teorija programirane ćelijske smrti i njen značaj u antikancerskoj terapiji.', 10),
('Teorija bioraspoloživosti', 'Teorija o stepenu i brzini kojom lek dostiže sistemsku cirkulaciju.', 12),
('Teorija hroničне toksičnosti', 'Teorija o dugoročnim efektima izlaganja toksičnim supstancama.', 14),
('Teorija selektivne toksičnosti', 'Teorija o selektivnom delovanju toksičnih supstanci na određene ćelije ili organe.', 16),
('Teorija farmakodinamike', 'Teorija o mehanizmima dejstva lekova i njihovim efektima na organizam.', 18),
('Teorija transporta lekova', 'Teorija o mehanizmima transporta lekova kroz biološke membrane.', 20),
('Teorija metabolizma lekova', 'Teorija o biotransformaciji lekova u organizmu.', 22),
('Teorija distribucije lekova', 'Teorija o raspodeli lekova u tkivima i organima.', 24),
('Teorija ekskrecije lekova', 'Teorija o eliminaciji lekova iz organizma.', 26),
('Teorija interakcije lekova', 'Teorija o farmakološkim interakcijama između različitih lekova.', 28),
('Teorija rezistencije na lekove', 'Teorija o mehanizmima razvoja rezistencije tumorskih ćelija na hemoterapiju.', 30),
('Teorija oksidativnog stresa', 'Teorija o ulozi reaktivnih kiseoničnih vrsta u toksičnosti jedinjenja.', 32),
('Teorija genotoksičnosti', 'Teorija o mehanizmima oštećenja DNK i mutagenosti jedinjenja.', 34),
('Teorija imunotoksičnosti', 'Teorija o efektima jedinjenja na imunološki sistem.', 36),
('Teorija neurotoksičnosti', 'Teorija o mehanizmima toksičnog dejstva jedinjenja na nervni sistem.', 38);

INSERT INTO eksperiment (naziv, doziranje_id, tip_eks_id) VALUES
('Citotoksičnost cisplatina na HeLa ćelijama', 1, 1),
('Citotoksičnost doxorubicina na MCF-7 ćelijama', 2, 1),
('Citotoksičnost paklitaksela na A549 ćelijama', 3, 1),
('Inhibicija COX-2 ibuprofenom', 4, 2),
('Vezivanje erlotiniba za EGFR receptor', 5, 2),
('Akutna toksičnost metformina na Wistar pacovima', 6, 3),
('LD50 određivanje fluorouracila', 7, 3),
('Akutna toksičnost cisplatina na C57BL/6 miševima', 8, 3),
('Farmakokinetika atorvastatina kod Sprague-Dawley pacova', 9, 4),
('ADME profil oseltamivira kod Wistar pacova', 10, 4),
('Farmakokinetika ibuprofena nakon oralne primene', 11, 4),
('Efikasnost doxorubicina na tumorskom modelu', 12, 5),
('Antitumorska aktivnost cisplatina na ksenograft modelu', 13, 5),
('Efikasnost metformina na modelu dijabetesa', 14, 5),
('Citotoksičnost sorafeniba na HepG2 ćelijama', 15, 1),
('Inhibicija topoizomeraze II doxorubicinom', 16, 2),
('Akutna toksičnost paracetamola na BALB/c miševima', 17, 3),
('Farmakokinetika amoksicilina kod pacova', 18, 4),
('Efikasnost flukonazola na modelu kandidijaze', 19, 5),
('Citotoksičnost vinkristina na PC-3 ćelijama', 20, 1),
('Inhibicija HMG-CoA reduktaze atorvastatinom', 21, 2),
('LD50 određivanje sorafeniba', 22, 3),
('Farmakokinetika paklitaksela nakon IV primene', 23, 4),
('Efikasnost erlotiniba na modelu karcinoma pluća', 24, 5),
('Citotoksičnost gemcitabina na HepG2 ćelijama', 25, 1),
('Vezivanje gefitiniba za EGFR', 26, 2),
('Akutna toksičnost vinkristina na pacovima', 27, 3),
('Farmakokinetika sunitiniba kod miševa', 28, 4),
('Efikasnost temozolomida na modelu glioblastoma', 29, 5),
('Citotoksičnost karboplatine na U87 ćelijama', 30, 1),
('Inhibicija neuraminidaze oseltamivirom', 31, 2),
('Akutna toksičnost gemcitabina na miševima', 32, 3),
('Farmakokinetika fluorouracila kod pacova', 33, 4),
('Efikasnost cisplatina na modelu karcinoma jajnika', 34, 5),
('Citotoksičnost erlotiniba na NIH 3T3 ćelijama', 35, 1),
('Vezivanje sorafeniba za VEGFR', 36, 2),
('Akutna toksičnost karboplatine na C57BL/6 miševima', 37, 3),
('Farmakokinetika doxorubicina nakon IV primene', 38, 4),
('Efikasnost paklitaksela na modelu karcinoma dojke', 39, 5),
('Citotoksičnost temozolomida na U87 ćelijama', 40, 1),
('Inhibicija COX-1 aspirinom', 1, 2),
('LD50 određivanje vinkristina', 2, 3),
('Farmakokinetika gefitiniba kod miševa', 3, 4),
('Efikasnost gemcitabina na modelu karcinoma pankreasa', 4, 5),
('Citotoksičnost fluorouracila na HCT116 ćelijama', 5, 1),
('Vezivanje sunitiniba za PDGFR', 6, 2),
('Akutna toksičnost temozolomida na pacovima', 7, 3),
('Farmakokinetika karboplatine kod pacova', 8, 4),
('Efikasnost vinkristina na modelu leukemije', 9, 5),
('Citotoksičnost aspirina na RAW 264.7 ćelijama', 10, 1),
('Inhibicija EGFR gefitinibom', 11, 2),
('LD50 određivanje paklitaksela', 12, 3),
('Farmakokinetika erlotiniba nakon oralne primene', 13, 4),
('Efikasnost karboplatine na modelu karcinoma pluća', 14, 5),
('Citotoksičnost metformina na MCF-7 ćelijama', 15, 1),
('Vezivanje temozolomida za DNK', 16, 2),
('Akutna toksičnost gefitiniba na miševima', 17, 3),
('Farmakokinetika vinkristina kod pacova', 18, 4),
('Efikasnost fluorouracila na modelu karcinoma debelog creva', 19, 5),
('Citotoksičnost sunitiniba na HepG2 ćelijama', 20, 1),
('Inhibicija topoizomeraze I kamptotecinom', 21, 2),
('LD50 određivanje erlotiniba', 22, 3),
('Farmakokinetika gemcitabina nakon IV primene', 23, 4),
('Efikasnost sorafeniba na modelu hepatocelularnog karcinoma', 24, 5),
('Citotoksičnost amoksicilina na Vero ćelijama', 25, 1),
('Vezivanje flukonazola za CYP51', 26, 2),
('Akutna toksičnost sunitiniba na pacovima', 27, 3),
('Farmakokinetika temozolomida kod miševa', 28, 4),
('Efikasnost gefitiniba na modelu karcinoma pluća', 29, 5),
('Citotoksičnost oseltamivira na MDCK ćelijama', 30, 1),
('Inhibicija replikacije virusa influence oseltamivirom', 31, 2),
('Akutna toksičnost fluorouracila na BALB/c miševima', 32, 3),
('Farmakokinetika sorafeniba nakon oralne primene', 33, 4),
('Efikasnost sunitiniba na modelu bubrežnog karcinoma', 34, 5),
('Citotoksičnost flukonazola na CHO ćelijama', 35, 1),
('Vezivanje metformina za AMPK', 36, 2),
('Akutna toksičnost amoksicilina na Wistar pacovima', 37, 3),
('Farmakokinetika oseltamivira kod miševa', 38, 4),
('Efikasnost paracetamola na modelu bola', 39, 5),
('Citotoksičnost aspirina na PC-3 ćelijama', 40, 1),
('Inhibicija sinteze ćelijskog zida amoksicilinom', 1, 2),
('LD50 određivanje flukonazola', 2, 3),
('Farmakokinetika paracetamola kod pacova', 3, 4),
('Efikasnost ibuprofena na modelu upale', 4, 5),
('Citotoksičnost atorvastatina na HepG2 ćelijama', 5, 1),
('Vezivanje aspirina za COX enzime', 6, 2),
('Akutna toksičnost oseltamivira na miševima', 7, 3),
('Farmakokinetika flukonazola nakon oralne primene', 8, 4),
('Efikasnost aspirina na modelu tromboze', 9, 5),
('Citotoksičnost paracetamola na HepG2 ćelijama', 10, 1),
('Inhibicija HCV replikacije sofosbuvirom', 11, 2),
('LD50 određivanje ibuprofena', 12, 3),
('Farmakokinetika atorvastatina nakon oralne primene', 13, 4),
('Efikasnost amoksicilina na modelu bakterijske infekcije', 14, 5),
('Citotoksičnost karboplatine na MCF-7 ćelijama', 15, 1),
('Vezivanje paklitaksela za tubulin', 16, 2),
('Akutna toksičnost atorvastatina na pacovima', 17, 3),
('Farmakokinetika metformina kod miševa', 18, 4),
('Efikasnost vinkristina na modelu limfoma', 19, 5),
('Citotoksičnost gemcitabina na A549 ćelijama', 20, 1);

INSERT INTO cilj_istrazivanja (naziv, opis, eks_id) VALUES
('Ispitivanje citotoksičnosti cisplatina', 'Utvrditi IC50 vrednost cisplatina na HeLa ćelijskoj liniji.', 1),
('Ispitivanje citotoksičnosti doxorubicina', 'Utvrditi IC50 vrednost doxorubicina na MCF-7 ćelijskoj liniji.', 2),
('Ispitivanje citotoksičnosti paklitaksela', 'Utvrditi IC50 vrednost paklitaksela na A549 ćelijskoj liniji.', 3),
('Ispitivanje inhibicije COX-2', 'Utvrditi stepen inhibicije COX-2 enzima ibuprofenom.', 4),
('Ispitivanje vezivanja erlotiniba', 'Utvrditi afinitet vezivanja erlotiniba za EGFR receptor.', 5),
('Ispitivanje akutne toksičnosti metformina', 'Utvrditi LD50 metformina na Wistar pacovima.', 6),
('Određivanje LD50 fluorouracila', 'Utvrditi letalnu dozu fluorouracila za 50% subjekata.', 7),
('Ispitivanje akutne toksičnosti cisplatina', 'Utvrditi LD50 cisplatina na C57BL/6 miševima.', 8),
('Ispitivanje farmakokinetike atorvastatina', 'Utvrditi ADME profil atorvastatina kod Sprague-Dawley pacova.', 9),
('Ispitivanje ADME profila oseltamivira', 'Utvrditi farmakokinetičke parametre oseltamivira kod Wistar pacova.', 10),
('Ispitivanje farmakokinetike ibuprofena', 'Utvrditi bioraspoloživost ibuprofena nakon oralne primene.', 11),
('Ispitivanje efikasnosti doxorubicina', 'Utvrditi antitumorsku aktivnost doxorubicina na tumorskom modelu.', 12),
('Ispitivanje antitumorske aktivnosti cisplatina', 'Utvrditi efikasnost cisplatina na ksenograft tumorskom modelu.', 13),
('Ispitivanje efikasnosti metformina', 'Utvrditi terapijsko dejstvo metformina na modelu dijabetesa tipa 2.', 14),
('Ispitivanje citotoksičnosti sorafeniba', 'Utvrditi IC50 vrednost sorafeniba na HepG2 ćelijskoj liniji.', 15),
('Ispitivanje inhibicije topoizomeraze II', 'Utvrditi mehanizam inhibicije topoizomeraze II doxorubicinom.', 16),
('Ispitivanje akutne toksičnosti paracetamola', 'Utvrditi LD50 paracetamola na BALB/c miševima.', 17),
('Ispitivanje farmakokinetike amoksicilina', 'Utvrditi distribuciju amoksicilina u tkivima pacova.', 18),
('Ispitivanje efikasnosti flukonazola', 'Utvrditi antifungalnu aktivnost flukonazola na modelu kandidijaze.', 19),
('Ispitivanje citotoksičnosti vinkristina', 'Utvrditi IC50 vrednost vinkristina na PC-3 ćelijskoj liniji.', 20),
('Ispitivanje inhibicije HMG-CoA reduktaze', 'Utvrditi stepen inhibicije HMG-CoA reduktaze atorvastatinom.', 21),
('Određivanje LD50 sorafeniba', 'Utvrditi letalnu dozu sorafeniba za 50% subjekata.', 22),
('Ispitivanje farmakokinetike paklitaksela', 'Utvrditi farmakokinetičke parametre paklitaksela nakon IV primene.', 23),
('Ispitivanje efikasnosti erlotiniba', 'Utvrditi terapijsko dejstvo erlotiniba na modelu karcinoma pluća.', 24),
('Ispitivanje citotoksičnosti gemcitabina', 'Utvrditi IC50 vrednost gemcitabina na HepG2 ćelijskoj liniji.', 25),
('Ispitivanje vezivanja gefitiniba', 'Utvrditi afinitet vezivanja gefitiniba za EGFR receptor.', 26),
('Ispitivanje akutne toksičnosti vinkristina', 'Utvrditi LD50 vinkristina na laboratorijskim pacovima.', 27),
('Ispitivanje farmakokinetike sunitiniba', 'Utvrditi ADME profil sunitiniba kod laboratorijskih miševa.', 28),
('Ispitivanje efikasnosti temozolomida', 'Utvrditi terapijsko dejstvo temozolomida na modelu glioblastoma.', 29),
('Ispitivanje citotoksičnosti karboplatine', 'Utvrditi IC50 vrednost karboplatine na U87 ćelijskoj liniji.', 30),
('Ispitivanje inhibicije neuraminidaze', 'Utvrditi stepen inhibicije neuraminidaze oseltamivirom.', 31),
('Ispitivanje akutne toksičnosti gemcitabina', 'Utvrditi LD50 gemcitabina na laboratorijskim miševima.', 32),
('Ispitivanje farmakokinetike fluorouracila', 'Utvrditi distribuciju fluorouracila u tkivima pacova.', 33),
('Ispitivanje efikasnosti cisplatina', 'Utvrditi terapijsko dejstvo cisplatina na modelu karcinoma jajnika.', 34),
('Ispitivanje citotoksičnosti erlotiniba', 'Utvrditi IC50 vrednost erlotiniba na NIH 3T3 ćelijskoj liniji.', 35),
('Ispitivanje vezivanja sorafeniba', 'Utvrditi afinitet vezivanja sorafeniba za VEGFR receptor.', 36),
('Ispitivanje akutne toksičnosti karboplatine', 'Utvrditi LD50 karboplatine na C57BL/6 miševima.', 37),
('Ispitivanje farmakokinetike doxorubicina', 'Utvrditi farmakokinetičke parametre doxorubicina nakon IV primene.', 38),
('Ispitivanje efikasnosti paklitaksela', 'Utvrditi terapijsko dejstvo paklitaksela na modelu karcinoma dojke.', 39),
('Ispitivanje citotoksičnosti temozolomida', 'Utvrditi IC50 vrednost temozolomida na U87 ćelijskoj liniji.', 40),
('Ispitivanje inhibicije COX-1', 'Utvrditi stepen inhibicije COX-1 enzima aspirinom.', 41),
('Određivanje LD50 vinkristina', 'Utvrditi letalnu dozu vinkristina za 50% subjekata.', 42),
('Ispitivanje farmakokinetike gefitiniba', 'Utvrditi ADME profil gefitiniba kod laboratorijskih miševa.', 43),
('Ispitivanje efikasnosti gemcitabina', 'Utvrditi terapijsko dejstvo gemcitabina na modelu karcinoma pankreasa.', 44),
('Ispitivanje citotoksičnosti fluorouracila', 'Utvrditi IC50 vrednost fluorouracila na HCT116 ćelijskoj liniji.', 45),
('Ispitivanje vezivanja sunitiniba', 'Utvrditi afinitet vezivanja sunitiniba za PDGFR receptor.', 46),
('Ispitivanje akutne toksičnosti temozolomida', 'Utvrditi LD50 temozolomida na laboratorijskim pacovima.', 47),
('Ispitivanje farmakokinetike karboplatine', 'Utvrditi distribuciju karboplatine u tkivima pacova.', 48),
('Ispitivanje efikasnosti vinkristina', 'Utvrditi terapijsko dejstvo vinkristina na modelu leukemije.', 49),
('Ispitivanje citotoksičnosti aspirina', 'Utvrditi IC50 vrednost aspirina na RAW 264.7 ćelijskoj liniji.', 50),
('Ispitivanje inhibicije EGFR gefitinibom', 'Utvrditi stepen inhibicije EGFR receptora gefitinibom.', 51),
('Određivanje LD50 paklitaksela', 'Utvrditi letalnu dozu paklitaksela za 50% subjekata.', 52),
('Ispitivanje farmakokinetike erlotiniba', 'Utvrditi bioraspoloživost erlotiniba nakon oralne primene.', 53),
('Ispitivanje efikasnosti karboplatine', 'Utvrditi terapijsko dejstvo karboplatine na modelu karcinoma pluća.', 54),
('Ispitivanje citotoksičnosti metformina', 'Utvrditi IC50 vrednost metformina na MCF-7 ćelijskoj liniji.', 55),
('Ispitivanje vezivanja temozolomida', 'Utvrditi mehanizam vezivanja temozolomida za DNK.', 56),
('Ispitivanje akutne toksičnosti gefitiniba', 'Utvrditi LD50 gefitiniba na laboratorijskim miševima.', 57),
('Ispitivanje farmakokinetike vinkristina', 'Utvrditi distribuciju vinkristina u tkivima pacova.', 58),
('Ispitivanje efikasnosti fluorouracila', 'Utvrditi terapijsko dejstvo fluorouracila na modelu karcinoma debelog creva.', 59),
('Ispitivanje citotoksičnosti sunitiniba', 'Utvrditi IC50 vrednost sunitiniba na HepG2 ćelijskoj liniji.', 60),
('Ispitivanje inhibicije topoizomeraze I', 'Utvrditi mehanizam inhibicije topoizomeraze I kamptotecinom.', 61),
('Određivanje LD50 erlotiniba', 'Utvrditi letalnu dozu erlotiniba za 50% subjekata.', 62),
('Ispitivanje farmakokinetike gemcitabina', 'Utvrditi farmakokinetičke parametre gemcitabina nakon IV primene.', 63),
('Ispitivanje efikasnosti sorafeniba', 'Utvrditi terapijsko dejstvo sorafeniba na modelu hepatocelularnog karcinoma.', 64),
('Ispitivanje citotoksičnosti amoksicilina', 'Utvrditi IC50 vrednost amoksicilina na Vero ćelijskoj liniji.', 65),
('Ispitivanje vezivanja flukonazola', 'Utvrditi afinitet vezivanja flukonazola za CYP51 enzim.', 66),
('Ispitivanje akutne toksičnosti sunitiniba', 'Utvrditi LD50 sunitiniba na laboratorijskim pacovima.', 67),
('Ispitivanje farmakokinetike temozolomida', 'Utvrditi ADME profil temozolomida kod laboratorijskih miševa.', 68),
('Ispitivanje efikasnosti gefitiniba', 'Utvrditi terapijsko dejstvo gefitiniba na modelu karcinoma pluća.', 69),
('Ispitivanje citotoksičnosti oseltamivira', 'Utvrditi IC50 vrednost oseltamivira na MDCK ćelijskoj liniji.', 70),
('Ispitivanje inhibicije replikacije virusa', 'Utvrditi stepen inhibicije replikacije influence virusa oseltamivirom.', 71),
('Ispitivanje akutne toksičnosti fluorouracila', 'Utvrditi LD50 fluorouracila na BALB/c miševima.', 72),
('Ispitivanje farmakokinetike sorafeniba', 'Utvrditi bioraspoloživost sorafeniba nakon oralne primene.', 73),
('Ispitivanje efikasnosti sunitiniba', 'Utvrditi terapijsko dejstvo sunitiniba na modelu bubrežnog karcinoma.', 74),
('Ispitivanje citotoksičnosti flukonazola', 'Utvrditi IC50 vrednost flukonazola na CHO ćelijskoj liniji.', 75),
('Ispitivanje vezivanja metformina', 'Utvrditi mehanizam vezivanja metformina za AMPK enzim.', 76),
('Ispitivanje akutne toksičnosti amoksicilina', 'Utvrditi LD50 amoksicilina na Wistar pacovima.', 77),
('Ispitivanje farmakokinetike oseltamivira', 'Utvrditi ADME profil oseltamivira kod laboratorijskih miševa.', 78),
('Ispitivanje efikasnosti paracetamola', 'Utvrditi analgetsko dejstvo paracetamola na modelu bola.', 79),
('Ispitivanje citotoksičnosti aspirina', 'Utvrditi IC50 vrednost aspirina na PC-3 ćelijskoj liniji.', 80),
('Ispitivanje inhibicije sinteze ćelijskog zida', 'Utvrditi mehanizam inhibicije sinteze ćelijskog zida amoksicilinom.', 81),
('Određivanje LD50 flukonazola', 'Utvrditi letalnu dozu flukonazola za 50% subjekata.', 82),
('Ispitivanje farmakokinetike paracetamola', 'Utvrditi distribuciju paracetamola u tkivima pacova.', 83),
('Ispitivanje efikasnosti ibuprofena', 'Utvrditi antiinflamatorno dejstvo ibuprofena na modelu upale.', 84),
('Ispitivanje citotoksičnosti atorvastatina', 'Utvrditi IC50 vrednost atorvastatina na HepG2 ćelijskoj liniji.', 85),
('Ispitivanje vezivanja aspirina', 'Utvrditi mehanizam vezivanja aspirina za COX enzime.', 86),
('Ispitivanje akutne toksičnosti oseltamivira', 'Utvrditi LD50 oseltamivira na laboratorijskim miševima.', 87),
('Ispitivanje farmakokinetike flukonazola', 'Utvrditi bioraspoloživost flukonazola nakon oralne primene.', 88),
('Ispitivanje efikasnosti aspirina', 'Utvrditi antitrombotsko dejstvo aspirina na modelu tromboze.', 89),
('Ispitivanje citotoksičnosti paracetamola', 'Utvrditi hepatotoksičnost paracetamola na HepG2 ćelijskoj liniji.', 90),
('Ispitivanje inhibicije HCV replikacije', 'Utvrditi stepen inhibicije HCV replikacije sofosbuvirom.', 91),
('Određivanje LD50 ibuprofena', 'Utvrditi letalnu dozu ibuprofena za 50% subjekata.', 92),
('Ispitivanje farmakokinetike atorvastatina', 'Utvrditi bioraspoloživost atorvastatina nakon oralne primene.', 93),
('Ispitivanje efikasnosti amoksicilina', 'Utvrditi antibakterijsko dejstvo amoksicilina na modelu bakterijske infekcije.', 94),
('Ispitivanje citotoksičnosti karboplatine na MCF-7', 'Utvrditi IC50 vrednost karboplatine na MCF-7 ćelijskoj liniji.', 95),
('Ispitivanje vezivanja paklitaksela', 'Utvrditi mehanizam vezivanja paklitaksela za tubulin.', 96),
('Ispitivanje akutne toksičnosti atorvastatina', 'Utvrditi LD50 atorvastatina na laboratorijskim pacovima.', 97),
('Ispitivanje farmakokinetike metformina', 'Utvrditi ADME profil metformina kod laboratorijskih miševa.', 98),
('Ispitivanje efikasnosti vinkristina na limfomu', 'Utvrditi terapijsko dejstvo vinkristina na modelu Ne-Hodžkinovog limfoma.', 99),
('Ispitivanje citotoksičnosti gemcitabina na A549', 'Utvrditi IC50 vrednost gemcitabina na A549 ćelijskoj liniji.', 100);

INSERT INTO eksperiment_dizajner (eks_id, dizajner_id) VALUES
(1, 1), (2, 2), (3, 4), (4, 6), (5, 8),
(6, 10), (7, 12), (8, 14), (9, 16), (10, 18),
(11, 20), (12, 22), (13, 24), (14, 26), (15, 28),
(16, 30), (17, 32), (18, 34), (19, 36), (20, 38),
(21, 1), (22, 2), (23, 4), (24, 6), (25, 8),
(26, 10), (27, 12), (28, 14), (29, 16), (30, 18),
(31, 20), (32, 22), (33, 24), (34, 26), (35, 28),
(36, 30), (37, 32), (38, 34), (39, 36), (40, 38),
(41, 1), (42, 2), (43, 4), (44, 6), (45, 8),
(46, 10), (47, 12), (48, 14), (49, 16), (50, 18),
(51, 20), (52, 22), (53, 24), (54, 26), (55, 28),
(56, 30), (57, 32), (58, 34), (59, 36), (60, 38),
(61, 1), (62, 2), (63, 4), (64, 6), (65, 8),
(66, 10), (67, 12), (68, 14), (69, 16), (70, 18),
(71, 20), (72, 22), (73, 24), (74, 26), (75, 28),
(76, 30), (77, 32), (78, 34), (79, 36), (80, 38),
(81, 1), (82, 2), (83, 4), (84, 6), (85, 8),
(86, 10), (87, 12), (88, 14), (89, 16), (90, 18),
(91, 20), (92, 22), (93, 24), (94, 26), (95, 28),
(96, 30), (97, 32), (98, 34), (99, 36), (100, 38);

INSERT INTO uloga_resursa (eks_id, resurs_id, naziv, opis) VALUES
(1, 4, 'testirano_jedinjenje', 'Cisplatin kao testirano jedinjenje'),
(1, 11, 'test_sistem', 'HeLa ćelije kao test sistem'),
(1, 22, 'reagens', 'DMEM medijum za kultivaciju'),
(2, 5, 'testirano_jedinjenje', 'Doxorubicin kao testirano jedinjenje'),
(2, 13, 'test_sistem', 'MCF-7 ćelije kao test sistem'),
(2, 22, 'reagens', 'DMEM medijum za kultivaciju'),
(3, 37, 'testirano_jedinjenje', 'Paklitaksel kao testirano jedinjenje'),
(3, 14, 'test_sistem', 'A549 ćelije kao test sistem'),
(3, 22, 'reagens', 'DMEM medijum za kultivaciju'),
(4, 2, 'testirano_jedinjenje', 'Ibuprofen kao testirano jedinjenje'),
(4, 11, 'test_sistem', 'HeLa ćelije kao test sistem'),
(4, 28, 'reagens', 'MTT reagens'),
(5, 31, 'testirano_jedinjenje', 'Erlotinib kao testirano jedinjenje'),
(5, 11, 'test_sistem', 'HeLa ćelije kao test sistem'),
(5, 28, 'reagens', 'MTT reagens'),
(6, 6, 'testirano_jedinjenje', 'Metformin kao testirano jedinjenje'),
(6, 16, 'test_sistem', 'Wistar pacov kao test sistem'),
(6, 27, 'reagens', 'Igle 25G'),
(7, 39, 'testirano_jedinjenje', 'Fluorouracil kao testirano jedinjenje'),
(7, 16, 'test_sistem', 'Wistar pacov kao test sistem'),
(8, 4, 'testirano_jedinjenje', 'Cisplatin kao testirano jedinjenje'),
(8, 18, 'test_sistem', 'C57BL/6 miš kao test sistem'),
(9, 7, 'testirano_jedinjenje', 'Atorvastatin kao testirano jedinjenje'),
(9, 17, 'test_sistem', 'Sprague-Dawley pacov kao test sistem'),
(10, 10, 'testirano_jedinjenje', 'Oseltamivir kao testirano jedinjenje'),
(10, 16, 'test_sistem', 'Wistar pacov kao test sistem'),
(11, 2, 'testirano_jedinjenje', 'Ibuprofen kao testirano jedinjenje'),
(11, 16, 'test_sistem', 'Wistar pacov kao test sistem'),
(12, 5, 'testirano_jedinjenje', 'Doxorubicin kao testirano jedinjenje'),
(12, 16, 'test_sistem', 'Wistar pacov kao test sistem'),
(13, 4, 'testirano_jedinjenje', 'Cisplatin kao testirano jedinjenje'),
(13, 47, 'test_sistem', 'Nude miš kao test sistem'),
(14, 6, 'testirano_jedinjenje', 'Metformin kao testirano jedinjenje'),
(14, 16, 'test_sistem', 'Wistar pacov kao test sistem'),
(15, 33, 'testirano_jedinjenje', 'Sorafenib kao testirano jedinjenje'),
(15, 12, 'test_sistem', 'HepG2 ćelije kao test sistem'),
(15, 22, 'reagens', 'DMEM medijum za kultivaciju'),
(16, 5, 'testirano_jedinjenje', 'Doxorubicin kao testirano jedinjenje'),
(16, 12, 'test_sistem', 'HepG2 ćelije kao test sistem'),
(17, 3, 'testirano_jedinjenje', 'Paracetamol kao testirano jedinjenje'),
(17, 19, 'test_sistem', 'BALB/c miš kao test sistem'),
(18, 8, 'testirano_jedinjenje', 'Amoksicilin kao testirano jedinjenje'),
(18, 16, 'test_sistem', 'Wistar pacov kao test sistem'),
(19, 9, 'testirano_jedinjenje', 'Flukonazol kao testirano jedinjenje'),
(19, 16, 'test_sistem', 'Wistar pacov kao test sistem'),
(20, 36, 'testirano_jedinjenje', 'Vinkristin kao testirano jedinjenje'),
(20, 44, 'test_sistem', 'PC-3 ćelije kao test sistem'),
(20, 22, 'reagens', 'DMEM medijum za kultivaciju'),
(21, 7, 'testirano_jedinjenje', 'Atorvastatin kao testirano jedinjenje'),
(21, 12, 'test_sistem', 'HepG2 ćelije kao test sistem'),
(22, 33, 'testirano_jedinjenje', 'Sorafenib kao testirano jedinjenje'),
(22, 16, 'test_sistem', 'Wistar pacov kao test sistem'),
(23, 37, 'testirano_jedinjenje', 'Paklitaksel kao testirano jedinjenje'),
(23, 17, 'test_sistem', 'Sprague-Dawley pacov kao test sistem'),
(24, 31, 'testirano_jedinjenje', 'Erlotinib kao testirano jedinjenje'),
(24, 18, 'test_sistem', 'C57BL/6 miš kao test sistem'),
(25, 40, 'testirano_jedinjenje', 'Gemcitabin kao testirano jedinjenje'),
(25, 12, 'test_sistem', 'HepG2 ćelije kao test sistem'),
(26, 32, 'testirano_jedinjenje', 'Gefitinib kao testirano jedinjenje'),
(26, 11, 'test_sistem', 'HeLa ćelije kao test sistem'),
(27, 36, 'testirano_jedinjenje', 'Vinkristin kao testirano jedinjenje'),
(27, 16, 'test_sistem', 'Wistar pacov kao test sistem'),
(28, 34, 'testirano_jedinjenje', 'Sunitinib kao testirano jedinjenje'),
(28, 18, 'test_sistem', 'C57BL/6 miš kao test sistem'),
(29, 35, 'testirano_jedinjenje', 'Temozolomid kao testirano jedinjenje'),
(29, 45, 'test_sistem', 'U87 ćelije kao test sistem'),
(30, 38, 'testirano_jedinjenje', 'Karboplatina kao testirano jedinjenje'),
(30, 45, 'test_sistem', 'U87 ćelije kao test sistem'),
(30, 22, 'reagens', 'DMEM medijum za kultivaciju'),
(31, 10, 'testirano_jedinjenje', 'Oseltamivir kao testirano jedinjenje'),
(31, 11, 'test_sistem', 'HeLa ćelije kao test sistem'),
(32, 40, 'testirano_jedinjenje', 'Gemcitabin kao testirano jedinjenje'),
(32, 18, 'test_sistem', 'C57BL/6 miš kao test sistem'),
(33, 39, 'testirano_jedinjenje', 'Fluorouracil kao testirano jedinjenje'),
(33, 16, 'test_sistem', 'Wistar pacov kao test sistem'),
(34, 4, 'testirano_jedinjenje', 'Cisplatin kao testirano jedinjenje'),
(34, 47, 'test_sistem', 'Nude miš kao test sistem'),
(35, 31, 'testirano_jedinjenje', 'Erlotinib kao testirano jedinjenje'),
(35, 41, 'test_sistem', 'NIH 3T3 ćelije kao test sistem'),
(36, 33, 'testirano_jedinjenje', 'Sorafenib kao testirano jedinjenje'),
(36, 11, 'test_sistem', 'HeLa ćelije kao test sistem'),
(37, 38, 'testirano_jedinjenje', 'Karboplatina kao testirano jedinjenje'),
(37, 18, 'test_sistem', 'C57BL/6 miš kao test sistem'),
(38, 5, 'testirano_jedinjenje', 'Doxorubicin kao testirano jedinjenje'),
(38, 17, 'test_sistem', 'Sprague-Dawley pacov kao test sistem'),
(39, 37, 'testirano_jedinjenje', 'Paklitaksel kao testirano jedinjenje'),
(39, 19, 'test_sistem', 'BALB/c miš kao test sistem'),
(40, 35, 'testirano_jedinjenje', 'Temozolomid kao testirano jedinjenje'),
(40, 45, 'test_sistem', 'U87 ćelije kao test sistem'),
(41, 1, 'testirano_jedinjenje', 'Aspirin kao testirano jedinjenje'),
(41, 11, 'test_sistem', 'HeLa ćelije kao test sistem'),
(42, 36, 'testirano_jedinjenje', 'Vinkristin kao testirano jedinjenje'),
(42, 17, 'test_sistem', 'Sprague-Dawley pacov kao test sistem'),
(43, 32, 'testirano_jedinjenje', 'Gefitinib kao testirano jedinjenje'),
(43, 18, 'test_sistem', 'C57BL/6 miš kao test sistem'),
(44, 40, 'testirano_jedinjenje', 'Gemcitabin kao testirano jedinjenje'),
(44, 48, 'test_sistem', 'Fischer 344 pacov kao test sistem'),
(45, 39, 'testirano_jedinjenje', 'Fluorouracil kao testirano jedinjenje'),
(45, 11, 'test_sistem', 'HeLa ćelije kao test sistem'),
(46, 34, 'testirano_jedinjenje', 'Sunitinib kao testirano jedinjenje'),
(46, 11, 'test_sistem', 'HeLa ćelije kao test sistem'),
(47, 35, 'testirano_jedinjenje', 'Temozolomid kao testirano jedinjenje'),
(47, 17, 'test_sistem', 'Sprague-Dawley pacov kao test sistem'),
(48, 38, 'testirano_jedinjenje', 'Karboplatina kao testirano jedinjenje'),
(48, 16, 'test_sistem', 'Wistar pacov kao test sistem'),
(49, 36, 'testirano_jedinjenje', 'Vinkristin kao testirano jedinjenje'),
(49, 48, 'test_sistem', 'Fischer 344 pacov kao test sistem'),
(50, 1, 'testirano_jedinjenje', 'Aspirin kao testirano jedinjenje'),
(50, 15, 'test_sistem', 'RAW 264.7 ćelije kao test sistem');

INSERT INTO eks_endpoint (eks_id, endpoint_id) VALUES
(1, 1), (1, 3),
(2, 1), (2, 3),
(3, 1), (3, 3),
(4, 1), (4, 3),
(5, 1), (5, 3),
(6, 2), (6, 3),
(7, 2),
(8, 2),
(9, 4), (9, 5), (9, 6), (9, 7),
(10, 4), (10, 5), (10, 6), (10, 7),
(11, 4), (11, 5), (11, 6),
(12, 3),
(13, 3),
(14, 3),
(15, 1), (15, 3),
(16, 1),
(17, 2),
(18, 4), (18, 5), (18, 6),
(19, 3),
(20, 1), (20, 3),
(21, 1),
(22, 2),
(23, 4), (23, 5), (23, 6), (23, 7),
(24, 3),
(25, 1), (25, 3),
(26, 1),
(27, 2),
(28, 4), (28, 5), (28, 6),
(29, 3),
(30, 1), (30, 3),
(31, 1),
(32, 2),
(33, 4), (33, 5), (33, 6),
(34, 3),
(35, 1), (35, 3),
(36, 1),
(37, 2),
(38, 4), (38, 5), (38, 6),
(39, 3),
(40, 1), (40, 3),
(41, 1),
(42, 2),
(43, 4), (43, 5),
(44, 3),
(45, 1), (45, 3),
(46, 1),
(47, 2),
(48, 4), (48, 5),
(49, 3),
(50, 1), (50, 3),
(51, 1),
(52, 2),
(53, 4), (53, 5),
(54, 3),
(55, 1), (55, 3),
(56, 1),
(57, 2),
(58, 4), (58, 5),
(59, 3),
(60, 1), (60, 3),
(61, 1),
(62, 2),
(63, 4), (63, 5),
(64, 3),
(65, 1), (65, 3),
(66, 1),
(67, 2),
(68, 4), (68, 5),
(69, 3),
(70, 1), (70, 3),
(71, 1),
(72, 2),
(73, 4), (73, 5),
(74, 3),
(75, 1), (75, 3),
(76, 1),
(77, 2),
(78, 4), (78, 5),
(79, 3),
(80, 1), (80, 3),
(81, 1),
(82, 2),
(83, 4), (83, 5),
(84, 3),
(85, 1), (85, 3),
(86, 1),
(87, 2),
(88, 4), (88, 5),
(89, 3),
(90, 1), (90, 3),
(91, 1),
(92, 2),
(93, 4), (93, 5),
(94, 3),
(95, 1), (95, 3),
(96, 1),
(97, 2),
(98, 4), (98, 5),
(99, 3),
(100, 1), (100, 3);

INSERT INTO eks_tip_alata (eks_id, tip_alata_id) VALUES
(1, 3), (1, 4), (1, 5),
(2, 3), (2, 4), (2, 5),
(3, 3), (3, 4), (3, 5),
(4, 3), (4, 4), (4, 5),
(5, 3), (5, 4), (5, 5),
(6, 6), (6, 7),
(7, 6), (7, 7),
(8, 6), (8, 7),
(9, 1), (9, 2), (9, 6),
(10, 1), (10, 2), (10, 6),
(11, 1), (11, 6),
(12, 6), (12, 7),
(13, 6), (13, 7),
(14, 6), (14, 7),
(15, 3), (15, 4), (15, 5),
(16, 3), (16, 8),
(17, 6), (17, 7),
(18, 1), (18, 6),
(19, 6), (19, 7),
(20, 3), (20, 4), (20, 5),
(21, 3), (21, 8),
(22, 6), (22, 7),
(23, 1), (23, 2), (23, 6),
(24, 6), (24, 7),
(25, 3), (25, 4), (25, 5),
(26, 3), (26, 8),
(27, 6), (27, 7),
(28, 1), (28, 6),
(29, 6), (29, 7),
(30, 3), (30, 4), (30, 5),
(31, 3), (31, 8),
(32, 6), (32, 7),
(33, 1), (33, 6),
(34, 6), (34, 7),
(35, 3), (35, 4), (35, 5),
(36, 3), (36, 8),
(37, 6), (37, 7),
(38, 1), (38, 6),
(39, 6), (39, 7),
(40, 3), (40, 4), (40, 5),
(41, 3), (41, 8),
(42, 6), (42, 7),
(43, 1), (43, 6),
(44, 6), (44, 7),
(45, 3), (45, 4), (45, 5),
(46, 3), (46, 8),
(47, 6), (47, 7),
(48, 1), (48, 6),
(49, 6), (49, 7),
(50, 3), (50, 4), (50, 5),
(51, 3), (51, 8),
(52, 6), (52, 7),
(53, 1), (53, 6),
(54, 6), (54, 7),
(55, 3), (55, 4), (55, 5),
(56, 3), (56, 8),
(57, 6), (57, 7),
(58, 1), (58, 6),
(59, 6), (59, 7),
(60, 3), (60, 4), (60, 5),
(61, 3), (61, 8),
(62, 6), (62, 7),
(63, 1), (63, 6),
(64, 6), (64, 7),
(65, 3), (65, 4), (65, 5),
(66, 3), (66, 8),
(67, 6), (67, 7),
(68, 1), (68, 6),
(69, 6), (69, 7),
(70, 3), (70, 4), (70, 5),
(71, 3), (71, 8),
(72, 6), (72, 7),
(73, 1), (73, 6),
(74, 6), (74, 7),
(75, 3), (75, 4), (75, 5),
(76, 3), (76, 8),
(77, 6), (77, 7),
(78, 1), (78, 6),
(79, 6), (79, 7),
(80, 3), (80, 4), (80, 5),
(81, 3), (81, 8),
(82, 6), (82, 7),
(83, 1), (83, 6),
(84, 6), (84, 7),
(85, 3), (85, 4), (85, 5),
(86, 3), (86, 8),
(87, 6), (87, 7),
(88, 1), (88, 6),
(89, 6), (89, 7),
(90, 3), (90, 4), (90, 5),
(91, 3), (91, 8),
(92, 6), (92, 7),
(93, 1), (93, 6),
(94, 6), (94, 7),
(95, 3), (95, 4), (95, 5),
(96, 3), (96, 8),
(97, 6), (97, 7),
(98, 1), (98, 6),
(99, 6), (99, 7),
(100, 3), (100, 4), (100, 5);

INSERT INTO istrazivac_specijalizacija (istrazivac_id, specijalizacija_id) VALUES
(1, 1), (1, 3),
(2, 2), (2, 4),
(3, 1),
(4, 2), (4, 5),
(5, 1), (5, 3),
(6, 2), (6, 4),
(7, 1),
(8, 2), (8, 5),
(9, 1), (9, 3),
(10, 2), (10, 4),
(11, 1),
(12, 2), (12, 5),
(13, 1), (13, 3),
(14, 2), (14, 4),
(15, 1),
(16, 2), (16, 5),
(17, 1), (17, 3),
(18, 2), (18, 4),
(19, 1),
(20, 2), (20, 5),
(21, 3), (21, 4),
(22, 1), (22, 2),
(23, 3),
(24, 4), (24, 5),
(25, 1), (25, 3),
(26, 2), (26, 4),
(27, 1),
(28, 2), (28, 5),
(29, 3), (29, 4),
(30, 1), (30, 2),
(31, 3),
(32, 4), (32, 5),
(33, 1), (33, 3),
(34, 2), (34, 4),
(35, 1),
(36, 2), (36, 5),
(37, 3), (37, 4),
(38, 1), (38, 2),
(39, 3),
(40, 4), (40, 5),
(41, 1), (41, 3),
(42, 2), (42, 4),
(43, 1),
(44, 2), (44, 5),
(45, 3), (45, 4),
(46, 1), (46, 2),
(47, 3),
(48, 4), (48, 5),
(49, 1), (49, 3),
(50, 2), (50, 4),
(51, 1),
(52, 2), (52, 5),
(53, 3), (53, 4),
(54, 1), (54, 2),
(55, 3),
(56, 4), (56, 5),
(57, 1), (57, 3),
(58, 2), (58, 4),
(59, 1),
(60, 2), (60, 5),
(61, 3), (61, 4),
(62, 1), (62, 2),
(63, 3),
(64, 4), (64, 5),
(65, 1), (65, 3),
(66, 2), (66, 4),
(67, 1),
(68, 2), (68, 5),
(69, 3), (69, 4),
(70, 1), (70, 2),
(71, 3),
(72, 4), (72, 5),
(73, 1), (73, 3),
(74, 2), (74, 4),
(75, 1),
(76, 2), (76, 5),
(77, 3), (77, 4),
(78, 1), (78, 2),
(79, 3),
(80, 4), (80, 5),
(81, 1), (81, 3),
(82, 2), (82, 4),
(83, 1),
(84, 2), (84, 5),
(85, 3), (85, 4),
(86, 1), (86, 2),
(87, 3),
(88, 4), (88, 5),
(89, 1), (89, 3),
(90, 2), (90, 4),
(91, 1),
(92, 2), (92, 5),
(93, 3), (93, 4),
(94, 1), (94, 2),
(95, 3),
(96, 4), (96, 5),
(97, 1), (97, 3),
(98, 2), (98, 4),
(99, 1),
(100, 2), (100, 5);

INSERT INTO konkretan_sertifikat (istrazivac_id, sertifikat_id, datum_sticanja) VALUES
(1, 1, '2015-01-15'), (1, 4, '2015-02-20'),
(2, 1, '2010-03-10'), (2, 2, '2011-05-15'), (2, 4, '2010-04-20'),
(3, 1, '2017-06-10'), (3, 4, '2017-07-15'),
(4, 1, '2013-01-20'), (4, 2, '2014-03-10'), (4, 4, '2013-02-25'),
(5, 1, '2020-01-15'), (5, 4, '2020-02-20'),
(6, 1, '2008-05-10'), (6, 2, '2009-07-15'), (6, 4, '2008-06-20'),
(7, 1, '2016-03-10'), (7, 4, '2016-04-15'),
(8, 1, '2012-09-20'), (8, 2, '2013-11-10'), (8, 4, '2012-10-25'),
(9, 1, '2018-05-15'), (9, 4, '2018-06-20'),
(10, 1, '2011-02-10'), (10, 2, '2012-04-15'), (10, 4, '2011-03-20'),
(11, 1, '2019-08-10'), (11, 4, '2019-09-15'),
(12, 1, '2014-04-20'), (12, 2, '2015-06-10'), (12, 4, '2014-05-25'),
(13, 1, '2021-01-15'), (13, 4, '2021-02-20'),
(14, 1, '2009-07-10'), (14, 2, '2010-09-15'), (14, 4, '2009-08-20'),
(15, 1, '2022-02-10'), (15, 4, '2022-03-15'),
(16, 1, '2007-05-20'), (16, 2, '2008-07-10'), (16, 4, '2007-06-25'),
(17, 1, '2015-08-10'), (17, 4, '2015-09-15'),
(18, 1, '2011-11-20'), (18, 2, '2013-01-10'), (18, 4, '2011-12-25'),
(19, 1, '2018-03-15'), (19, 4, '2018-04-20'),
(20, 1, '2013-06-10'), (20, 2, '2014-08-15'), (20, 4, '2013-07-20'),
(21, 1, '2020-11-10'), (21, 4, '2020-12-15'),
(22, 1, '2006-02-20'), (22, 2, '2007-04-10'), (22, 4, '2006-03-25'),
(23, 1, '2017-10-10'), (23, 4, '2017-11-15'),
(24, 1, '2010-08-20'), (24, 2, '2011-10-10'), (24, 4, '2010-09-25'),
(25, 1, '2022-08-10'), (25, 4, '2022-09-15'),
(26, 1, '2008-03-20'), (26, 2, '2009-05-10'), (26, 4, '2008-04-25'),
(27, 1, '2016-06-10'), (27, 4, '2016-07-15'),
(28, 1, '2012-01-20'), (28, 2, '2013-03-10'), (28, 4, '2012-02-25'),
(29, 1, '2019-04-10'), (29, 4, '2019-05-15'),
(30, 1, '2014-09-20'), (30, 2, '2015-11-10'), (30, 4, '2014-10-25'),
(31, 1, '2021-03-10'), (31, 4, '2021-04-15'),
(32, 1, '2009-12-20'), (32, 2, '2011-02-10'), (32, 4, '2010-01-25'),
(33, 1, '2018-08-10'), (33, 4, '2018-09-15'),
(34, 1, '2013-11-20'), (34, 2, '2015-01-10'), (34, 4, '2013-12-25'),
(35, 1, '2022-05-10'), (35, 4, '2022-06-15'),
(36, 1, '2007-08-20'), (36, 2, '2008-10-10'), (36, 4, '2007-09-25'),
(37, 1, '2016-11-10'), (37, 4, '2016-12-15'),
(38, 1, '2012-04-20'), (38, 2, '2013-06-10'), (38, 4, '2012-05-25'),
(39, 1, '2019-07-10'), (39, 4, '2019-08-15'),
(40, 1, '2015-02-20'), (40, 2, '2016-04-10'), (40, 4, '2015-03-25'),
(41, 1, '2021-06-10'), (41, 4, '2021-07-15'),
(42, 1, '2010-11-20'), (42, 2, '2012-01-10'), (42, 4, '2010-12-25'),
(43, 1, '2018-11-10'), (43, 4, '2018-12-15'),
(44, 1, '2014-02-20'), (44, 2, '2015-04-10'), (44, 4, '2014-03-25'),
(45, 1, '2022-11-10'), (45, 4, '2022-12-15'),
(46, 1, '2008-09-20'), (46, 2, '2009-11-10'), (46, 4, '2008-10-25'),
(47, 1, '2017-02-10'), (47, 4, '2017-03-15'),
(48, 1, '2012-07-20'), (48, 2, '2013-09-10'), (48, 4, '2012-08-25'),
(49, 1, '2019-10-10'), (49, 4, '2019-11-15'),
(50, 1, '2015-05-20'), (50, 2, '2016-07-10'), (50, 4, '2015-06-25');

INSERT INTO alat (d_nabavke, d_proizvodnje, lab_id, tip_alata_id) VALUES
('2015-03-10', '2014-01-15', 1, 1),
('2016-05-20', '2015-02-10', 1, 2),
('2014-07-15', '2013-03-20', 1, 3),
('2017-09-25', '2016-04-30', 1, 4),
('2018-11-10', '2017-05-15', 1, 5),
('2019-01-20', '2018-06-25', 1, 6),
('2020-03-15', '2019-07-10', 1, 7),
('2021-05-25', '2020-08-20', 1, 8),
('2015-07-10', '2014-09-15', 2, 1),
('2016-09-20', '2015-10-10', 2, 2),
('2014-11-15', '2013-11-20', 2, 3),
('2017-01-25', '2016-12-30', 2, 4),
('2018-03-10', '2017-01-15', 2, 5),
('2019-05-20', '2018-02-25', 2, 6),
('2020-07-15', '2019-03-10', 2, 7),
('2021-09-25', '2020-04-20', 2, 8),
('2015-11-10', '2014-05-15', 3, 1),
('2016-01-20', '2015-06-25', 3, 2),
('2014-03-15', '2013-07-10', 3, 3),
('2017-05-25', '2016-08-20', 3, 4),
('2018-07-10', '2017-09-15', 3, 5),
('2019-09-20', '2018-10-10', 3, 6),
('2020-11-15', '2019-11-20', 3, 7),
('2021-01-25', '2020-12-30', 3, 8),
('2015-03-10', '2014-01-15', 4, 1),
('2016-05-20', '2015-02-10', 4, 2),
('2014-07-15', '2013-03-20', 4, 3),
('2017-09-25', '2016-04-30', 4, 4),
('2018-11-10', '2017-05-15', 4, 5),
('2019-01-20', '2018-06-25', 4, 6),
('2020-03-15', '2019-07-10', 4, 7),
('2021-05-25', '2020-08-20', 4, 8),
('2015-07-10', '2014-09-15', 5, 1),
('2016-09-20', '2015-10-10', 5, 2),
('2014-11-15', '2013-11-20', 5, 3),
('2017-01-25', '2016-12-30', 5, 4),
('2018-03-10', '2017-01-15', 5, 5),
('2019-05-20', '2018-02-25', 5, 6),
('2020-07-15', '2019-03-10', 5, 7),
('2021-09-25', '2020-04-20', 5, 8),
('2022-01-10', '2021-05-15', 1, 9),
('2022-03-20', '2021-06-25', 1, 10),
('2022-05-15', '2021-07-10', 1, 11),
('2022-07-25', '2021-08-20', 1, 12),
('2022-09-10', '2021-09-15', 2, 9),
('2022-11-20', '2021-10-10', 2, 10),
('2023-01-15', '2021-11-20', 2, 11),
('2023-03-25', '2021-12-30', 2, 12),
('2022-01-10', '2021-01-15', 3, 9),
('2022-03-20', '2021-02-25', 3, 10),
('2022-05-15', '2021-03-10', 3, 11),
('2022-07-25', '2021-04-20', 3, 12),
('2022-09-10', '2021-05-15', 4, 9),
('2022-11-20', '2021-06-25', 4, 10),
('2023-01-15', '2021-07-10', 4, 11),
('2023-03-25', '2021-08-20', 4, 12),
('2022-01-10', '2021-09-15', 5, 9),
('2022-03-20', '2021-10-10', 5, 10),
('2022-05-15', '2021-11-20', 5, 11),
('2022-07-25', '2021-12-30', 5, 12),
('2023-05-10', '2022-01-15', 1, 13),
('2023-07-20', '2022-02-25', 1, 14),
('2023-09-15', '2022-03-10', 1, 15),
('2023-11-25', '2022-04-20', 1, 16),
('2023-05-10', '2022-05-15', 2, 13),
('2023-07-20', '2022-06-25', 2, 14),
('2023-09-15', '2022-07-10', 2, 15),
('2023-11-25', '2022-08-20', 2, 16),
('2023-05-10', '2022-09-15', 3, 13),
('2023-07-20', '2022-10-10', 3, 14),
('2023-09-15', '2022-11-20', 3, 15),
('2023-11-25', '2022-12-30', 3, 16),
('2023-05-10', '2022-01-15', 4, 13),
('2023-07-20', '2022-02-25', 4, 14),
('2023-09-15', '2022-03-10', 4, 15),
('2023-11-25', '2022-04-20', 4, 16),
('2023-05-10', '2022-05-15', 5, 13),
('2023-07-20', '2022-06-25', 5, 14),
('2023-09-15', '2022-07-10', 5, 15),
('2023-11-25', '2022-08-20', 5, 16),
('2024-01-10', '2023-01-15', 1, 17),
('2024-03-20', '2023-02-25', 2, 17),
('2024-05-15', '2023-03-10', 3, 17),
('2024-07-25', '2023-04-20', 4, 17),
('2024-09-10', '2023-05-15', 5, 17),
('2024-01-10', '2023-06-25', 1, 1),
('2024-03-20', '2023-07-10', 2, 1),
('2024-05-15', '2023-08-20', 3, 1),
('2024-07-25', '2023-09-15', 4, 1),
('2024-09-10', '2023-10-10', 5, 1),
('2024-01-10', '2023-11-20', 1, 3),
('2024-03-20', '2023-12-30', 2, 3),
('2024-05-15', '2024-01-15', 3, 3),
('2024-07-25', '2024-02-25', 4, 3),
('2024-09-10', '2024-03-10', 5, 3),
('2024-11-20', '2024-04-20', 1, 6),
('2024-11-20', '2024-05-15', 2, 6),
('2024-11-20', '2024-06-25', 3, 6),
('2024-11-20', '2024-07-10', 4, 6),
('2024-11-20', '2024-08-20', 5, 6);

INSERT INTO lab_resurs (lab_id, resurs_id, kolicina, status) VALUES
(1, 1, 500.00, 'dostupno'),
(1, 2, 300.00, 'dostupno'),
(1, 3, 400.00, 'dostupno'),
(1, 4, 100.00, 'dostupno'),
(1, 5, 50.00, 'dostupno'),
(1, 11, 10.00, 'dostupno'),
(1, 13, 8.00, 'dostupno'),
(1, 14, 5.00, 'dostupno'),
(1, 20, 2000.00, 'dostupno'),
(1, 21, 5000.00, 'dostupno'),
(1, 22, 10000.00, 'dostupno'),
(1, 24, 1000.00, 'dostupno'),
(1, 25, 500.00, 'dostupno'),
(1, 28, 200.00, 'dostupno'),
(1, 29, 100.00, 'dostupno'),
(1, 30, 5000.00, 'dostupno'),
(1, 52, 200.00, 'dostupno'),
(1, 55, 100.00, 'dostupno'),
(1, 57, 50.00, 'dostupno'),
(1, 85, 1000.00, 'dostupno'),
(2, 1, 300.00, 'dostupno'),
(2, 2, 200.00, 'dostupno'),
(2, 6, 400.00, 'dostupno'),
(2, 7, 250.00, 'dostupno'),
(2, 8, 150.00, 'dostupno'),
(2, 10, 100.00, 'dostupno'),
(2, 17, 20.00, 'dostupno'),
(2, 20, 3000.00, 'dostupno'),
(2, 21, 4000.00, 'dostupno'),
(2, 75, 2000.00, 'dostupno'),
(2, 76, 1500.00, 'dostupno'),
(2, 77, 500.00, 'dostupno'),
(2, 78, 300.00, 'dostupno'),
(2, 79, 200.00, 'dostupno'),
(2, 80, 100.00, 'dostupno'),
(2, 81, 50.00, 'dostupno'),
(2, 82, 1000.00, 'dostupno'),
(2, 83, 500.00, 'dostupno'),
(2, 84, 200.00, 'dostupno'),
(2, 85, 800.00, 'dostupno'),
(3, 16, 30.00, 'dostupno'),
(3, 17, 25.00, 'dostupno'),
(3, 18, 40.00, 'dostupno'),
(3, 19, 35.00, 'dostupno'),
(3, 46, 20.00, 'dostupno'),
(3, 47, 15.00, 'dostupno'),
(3, 48, 10.00, 'dostupno'),
(3, 49, 12.00, 'dostupno'),
(3, 6, 200.00, 'dostupno'),
(3, 9, 150.00, 'dostupno'),
(3, 20, 1000.00, 'dostupno'),
(3, 21, 2000.00, 'dostupno'),
(3, 26, 500.00, 'dostupno'),
(3, 27, 200.00, 'dostupno'),
(3, 69, 100.00, 'dostupno'),
(3, 70, 50.00, 'dostupno'),
(3, 71, 200.00, 'dostupno'),
(3, 72, 100.00, 'dostupno'),
(3, 73, 500.00, 'dostupno'),
(3, 74, 300.00, 'dostupno'),
(4, 4, 80.00, 'dostupno'),
(4, 5, 60.00, 'dostupno'),
(4, 31, 40.00, 'dostupno'),
(4, 33, 30.00, 'dostupno'),
(4, 35, 20.00, 'dostupno'),
(4, 16, 50.00, 'dostupno'),
(4, 17, 40.00, 'dostupno'),
(4, 20, 2000.00, 'dostupno'),
(4, 21, 3000.00, 'dostupno'),
(4, 26, 300.00, 'dostupno'),
(4, 27, 150.00, 'dostupno'),
(4, 65, 500.00, 'dostupno'),
(4, 66, 200.00, 'dostupno'),
(4, 67, 100.00, 'dostupno'),
(4, 68, 50.00, 'dostupno'),
(4, 86, 1000.00, 'dostupno'),
(4, 87, 500.00, 'dostupno'),
(4, 88, 200.00, 'dostupno'),
(4, 89, 100.00, 'dostupno'),
(4, 90, 50.00, 'dostupno'),
(5, 16, 60.00, 'dostupno'),
(5, 17, 50.00, 'dostupno'),
(5, 18, 70.00, 'dostupno'),
(5, 19, 45.00, 'dostupno'),
(5, 46, 30.00, 'dostupno'),
(5, 47, 25.00, 'dostupno'),
(5, 48, 20.00, 'dostupno'),
(5, 49, 22.00, 'dostupno'),
(5, 20, 1500.00, 'dostupno'),
(5, 21, 2500.00, 'dostupno'),
(5, 26, 400.00, 'dostupno'),
(5, 27, 250.00, 'dostupno'),
(5, 69, 150.00, 'dostupno'),
(5, 70, 80.00, 'dostupno'),
(5, 71, 300.00, 'dostupno'),
(5, 72, 150.00, 'dostupno'),
(5, 73, 600.00, 'dostupno'),
(5, 74, 400.00, 'dostupno'),
(5, 91, 200.00, 'dostupno'),
(5, 92, 100.00, 'dostupno');

INSERT INTO izvodjenje (lab_id, datum, primenjena_doza, jedinica, put_primene, devijacije, eks_id, status_id) VALUES
(1, '2023-01-10', 50.00, 'µM', 'u medijum', NULL, 1, 4),
(1, '2023-01-15', 100.00, 'µM', 'u medijum', NULL, 2, 4),
(1, '2023-01-20', 25.00, 'µM', 'u medijum', NULL, 3, 4),
(1, '2023-02-05', 10.00, 'µM', 'u medijum', NULL, 4, 4),
(1, '2023-02-10', 50.00, 'µM', 'u medijum', NULL, 5, 4),
(2, '2023-02-15', 10.00, 'mg/kg', 'oralno', NULL, 6, 4),
(2, '2023-02-20', 25.00, 'mg/kg', 'oralno', NULL, 7, 4),
(2, '2023-03-01', 5.00, 'mg/kg', 'intravenski', NULL, 8, 4),
(2, '2023-03-05', 10.00, 'mg/kg', 'oralno', NULL, 9, 4),
(2, '2023-03-10', 25.00, 'mg/kg', 'oralno', NULL, 10, 4),
(1, '2023-03-15', 50.00, 'mg/kg', 'oralno', NULL, 11, 4),
(3, '2023-03-20', 10.00, 'mg/kg', 'intraperitonealno', NULL, 12, 4),
(3, '2023-04-01', 5.00, 'mg/kg', 'intravenski', NULL, 13, 4),
(3, '2023-04-05', 25.00, 'mg/kg', 'oralno', NULL, 14, 4),
(1, '2023-04-10', 75.00, 'µM', 'u medijum', NULL, 15, 4),
(1, '2023-04-15', 50.00, 'µM', 'u medijum', NULL, 16, 4),
(3, '2023-04-20', 50.00, 'mg/kg', 'oralno', NULL, 17, 4),
(2, '2023-05-01', 10.00, 'mg/kg', 'oralno', NULL, 18, 4),
(3, '2023-05-05', 10.00, 'mg/kg', 'oralno', NULL, 19, 4),
(1, '2023-05-10', 25.00, 'µM', 'u medijum', NULL, 20, 4),
(1, '2023-05-15', 10.00, 'µM', 'u medijum', NULL, 21, 4),
(2, '2023-05-20', 50.00, 'mg/kg', 'oralno', NULL, 22, 4),
(2, '2023-06-01', 5.00, 'mg/kg', 'intravenski', NULL, 23, 4),
(3, '2023-06-05', 10.00, 'mg/kg', 'intraperitonealno', NULL, 24, 4),
(1, '2023-06-10', 100.00, 'µM', 'u medijum', NULL, 25, 4),
(1, '2023-06-15', 50.00, 'µM', 'u medijum', NULL, 26, 4),
(2, '2023-06-20', 25.00, 'mg/kg', 'oralno', NULL, 27, 4),
(2, '2023-07-01', 10.00, 'mg/kg', 'oralno', NULL, 28, 4),
(3, '2023-07-05', 20.00, 'mg/kg', 'intraperitonealno', NULL, 29, 4),
(1, '2023-07-10', 50.00, 'µM', 'u medijum', NULL, 30, 4),
(1, '2023-07-15', 25.00, 'µM', 'u medijum', NULL, 31, 4),
(3, '2023-07-20', 15.00, 'mg/kg', 'intraperitonealno', 'Jedna životinja uginula pre kraja', 32, 5),
(2, '2023-08-01', 10.00, 'mg/kg', 'oralno', NULL, 33, 4),
(3, '2023-08-05', 5.00, 'mg/kg', 'intravenski', NULL, 34, 4),
(1, '2023-08-10', 75.00, 'µM', 'u medijum', NULL, 35, 4),
(1, '2023-08-15', 50.00, 'µM', 'u medijum', NULL, 36, 4),
(3, '2023-08-20', 10.00, 'mg/kg', 'intravenski', NULL, 37, 4),
(2, '2023-09-01', 5.00, 'mg/kg', 'intravenski', NULL, 38, 4),
(3, '2023-09-05', 20.00, 'mg/kg', 'intraperitonealno', NULL, 39, 4),
(1, '2023-09-10', 100.00, 'µM', 'u medijum', NULL, 40, 4),
(1, '2023-09-15', 10.00, 'µM', 'u medijum', NULL, 41, 4),
(2, '2023-09-20', 25.00, 'mg/kg', 'oralno', NULL, 42, 4),
(2, '2023-10-01', 10.00, 'mg/kg', 'oralno', NULL, 43, 4),
(3, '2023-10-05', 10.00, 'mg/kg', 'intraperitonealno', NULL, 44, 4),
(1, '2023-10-10', 50.00, 'µM', 'u medijum', NULL, 45, 4),
(1, '2023-10-15', 25.00, 'µM', 'u medijum', NULL, 46, 4),
(2, '2023-10-20', 30.00, 'mg/kg', 'oralno', NULL, 47, 5),
(2, '2023-11-01', 10.00, 'mg/kg', 'oralno', NULL, 48, 4),
(3, '2023-11-05', 15.00, 'mg/kg', 'intraperitonealno', NULL, 49, 4),
(1, '2023-11-10', 75.00, 'µM', 'u medijum', NULL, 50, 4),
(1, '2023-11-15', 50.00, 'µM', 'u medijum', NULL, 51, 4),
(2, '2023-11-20', 25.00, 'mg/kg', 'oralno', NULL, 52, 4),
(2, '2023-12-01', 5.00, 'mg/kg', 'intravenski', NULL, 53, 4),
(3, '2023-12-05', 20.00, 'mg/kg', 'intraperitonealno', NULL, 54, 4),
(1, '2023-12-10', 100.00, 'µM', 'u medijum', NULL, 55, 4),
(1, '2023-12-15', 50.00, 'µM', 'u medijum', NULL, 56, 4),
(2, '2024-01-10', 40.00, 'mg/kg', 'oralno', 'Inkubator imao grešku tokom noći', 57, 5),
(2, '2024-01-15', 10.00, 'mg/kg', 'oralno', NULL, 58, 4),
(3, '2024-01-20', 10.00, 'mg/kg', 'intraperitonealno', NULL, 59, 4),
(1, '2024-02-05', 75.00, 'µM', 'u medijum', NULL, 60, 4),
(1, '2024-02-10', 25.00, 'µM', 'u medijum', NULL, 61, 4),
(2, '2024-02-15', 50.00, 'mg/kg', 'oralno', NULL, 62, 4),
(2, '2024-02-20', 5.00, 'mg/kg', 'intravenski', NULL, 63, 4),
(3, '2024-03-01', 10.00, 'mg/kg', 'intraperitonealno', NULL, 64, 4),
(1, '2024-03-05', 50.00, 'µM', 'u medijum', NULL, 65, 4),
(1, '2024-03-10', 25.00, 'µM', 'u medijum', NULL, 66, 4),
(2, '2024-03-15', 25.00, 'mg/kg', 'oralno', NULL, 67, 4),
(2, '2024-03-20', 10.00, 'mg/kg', 'oralno', NULL, 68, 4),
(3, '2024-04-01', 20.00, 'mg/kg', 'intraperitonealno', NULL, 69, 4),
(1, '2024-04-05', 100.00, 'µM', 'u medijum', NULL, 70, 4),
(1, '2024-04-10', 50.00, 'µM', 'u medijum', NULL, 71, 4),
(2, '2024-04-15', 30.00, 'mg/kg', 'oralno', NULL, 72, 4),
(2, '2024-04-20', 5.00, 'mg/kg', 'intravenski', NULL, 73, 4),
(3, '2024-05-01', 10.00, 'mg/kg', 'intraperitonealno', NULL, 74, 4),
(1, '2024-05-05', 75.00, 'µM', 'u medijum', NULL, 75, 4),
(1, '2024-05-10', 25.00, 'µM', 'u medijum', NULL, 76, 4),
(2, '2024-05-15', 25.00, 'mg/kg', 'oralno', NULL, 77, 4),
(2, '2024-05-20', 10.00, 'mg/kg', 'oralno', NULL, 78, 4),
(3, '2024-06-01', 15.00, 'mg/kg', 'intraperitonealno', NULL, 79, 4),
(1, '2024-06-05', 50.00, 'µM', 'u medijum', NULL, 80, 4),
(1, '2024-06-10', 10.00, 'µM', 'u medijum', NULL, 81, 4),
(2, '2024-06-15', 50.00, 'mg/kg', 'oralno', NULL, 82, 4),
(2, '2024-06-20', 5.00, 'mg/kg', 'intravenski', NULL, 83, 4),
(3, '2024-07-01', 20.00, 'mg/kg', 'intraperitonealno', NULL, 84, 4),
(1, '2024-07-05', 100.00, 'µM', 'u medijum', NULL, 85, 4),
(1, '2024-07-10', 50.00, 'µM', 'u medijum', NULL, 86, 4),
(2, '2024-07-15', 25.00, 'mg/kg', 'oralno', NULL, 87, 4),
(2, '2024-07-20', 10.00, 'mg/kg', 'oralno', NULL, 88, 4),
(3, '2024-08-01', 10.00, 'mg/kg', 'intraperitonealno', NULL, 89, 4),
(1, '2024-08-05', 75.00, 'µM', 'u medijum', NULL, 90, 4),
(1, '2024-08-10', 25.00, 'µM', 'u medijum', NULL, 91, 4),
(2, '2024-08-15', 50.00, 'mg/kg', 'oralno', NULL, 92, 4),
(2, '2024-08-20', 5.00, 'mg/kg', 'intravenski', NULL, 93, 4),
(3, '2024-09-01', 20.00, 'mg/kg', 'intraperitonealno', NULL, 94, 4),
(1, '2024-09-05', 50.00, 'µM', 'u medijum', NULL, 95, 4),
(1, '2024-09-10', 25.00, 'µM', 'u medijum', NULL, 96, 4),
(2, '2024-09-15', 25.00, 'mg/kg', 'oralno', NULL, 97, 4),
(2, '2024-09-20', 10.00, 'mg/kg', 'oralno', NULL, 98, 4),
(3, '2024-10-01', 15.00, 'mg/kg', 'intraperitonealno', NULL, 99, 4),
(1, '2024-10-05', 100.00, 'µM', 'u medijum', NULL, 100, 4);

INSERT INTO uloga (izvodjac_id, izvodjenje_id, lab_id, opis, beleske) VALUES
(1, 1, 1, 'vodeći izvođač', 'IC50 izmerena na 3 koncentracije.'),
(3, 1, 1, 'asistent', NULL),
(2, 2, 1, 'vodeći izvođač', 'Ćelije u odličnoj viabilnosti pre tretmana.'),
(5, 2, 1, 'asistent', NULL),
(4, 3, 1, 'vodeći izvođač', 'Korišćen MTT test za određivanje viabilnosti.'),
(7, 3, 1, 'tehničar za pripremu uzoraka', NULL),
(6, 4, 1, 'vodeći izvođač', 'Enzimski test urađen u triplikatu.'),
(9, 4, 1, 'asistent', NULL),
(8, 5, 1, 'vodeći izvođač', 'Vezivanje potvrđeno Western blot analizom.'),
(11, 5, 1, 'asistent', NULL),
(10, 6, 2, 'vodeći izvođač', 'Životinje primile dozu prema protokolu.'),
(13, 6, 2, 'tehničar za pripremu uzoraka', NULL),
(12, 7, 2, 'vodeći izvođač', 'LD50 određena prema up-and-down metodi.'),
(15, 7, 2, 'asistent', NULL),
(14, 8, 2, 'vodeći izvođač', 'Uzorci krvi uzeti u definisanim vremenskim tačkama.'),
(17, 8, 2, 'asistent', NULL),
(16, 9, 2, 'vodeći izvođač', 'HPLC analiza uzoraka plazme završena uspešno.'),
(19, 9, 2, 'tehničar za pripremu uzoraka', NULL),
(18, 10, 2, 'vodeći izvođač', 'Farmakokinetički parametri izračunati pomoću softvera.'),
(21, 10, 2, 'asistent', NULL),
(20, 11, 1, 'vodeći izvođač', NULL),
(23, 11, 1, 'asistent', NULL),
(22, 12, 3, 'vodeći izvođač', 'Tumor pokazao značajno smanjenje volumena.'),
(25, 12, 3, 'tehničar za pripremu uzoraka', NULL),
(24, 13, 3, 'vodeći izvođač', 'Ksenograft model uspostavljen 2 nedelje pre tretmana.'),
(27, 13, 3, 'asistent', NULL),
(26, 14, 3, 'vodeći izvođač', 'Glikemija merena na tašte pre svakog doziranja.'),
(29, 14, 3, 'asistent', NULL),
(28, 15, 1, 'vodeći izvođač', 'MTT test urađen nakon 72h inkubacije.'),
(31, 15, 1, 'tehničar za pripremu uzoraka', NULL),
(30, 16, 1, 'vodeći izvođač', NULL),
(33, 16, 1, 'asistent', NULL),
(32, 17, 3, 'vodeći izvođač', 'Sve životinje preživele akutnu fazu.'),
(35, 17, 3, 'asistent', NULL),
(34, 18, 2, 'vodeći izvođač', NULL),
(37, 18, 2, 'tehničar za pripremu uzoraka', NULL),
(36, 19, 3, 'vodeći izvođač', 'Kolonizacija Candida albicans potvrđena pre tretmana.'),
(39, 19, 3, 'asistent', NULL),
(38, 20, 1, 'vodeći izvođač', NULL),
(41, 20, 1, 'asistent', NULL),
(40, 21, 1, 'vodeći izvođač', 'Enzimska aktivnost merena spektrofotometrijski.'),
(43, 21, 1, 'tehničar za pripremu uzoraka', NULL),
(42, 22, 2, 'vodeći izvođač', 'LD50 vrednost veća od očekivane.'),
(45, 22, 2, 'asistent', NULL),
(44, 23, 2, 'vodeći izvođač', 'Cmax postignuta 2h nakon primene.'),
(47, 23, 2, 'asistent', NULL),
(46, 24, 3, 'vodeći izvođač', 'Tumor potpuno regresovao kod 3 od 5 životinja.'),
(49, 24, 3, 'tehničar za pripremu uzoraka', NULL),
(48, 25, 1, 'vodeći izvođač', NULL),
(51, 25, 1, 'asistent', NULL),
(50, 26, 1, 'vodeći izvođač', 'Vezivanje potvrđeno kompetitivnim testom.'),
(53, 26, 1, 'asistent', NULL),
(52, 27, 2, 'vodeći izvođač', NULL),
(55, 27, 2, 'tehničar za pripremu uzoraka', NULL),
(54, 28, 2, 'vodeći izvođač', 'T1/2 sunitiniba iznosi 12h kod miševa.'),
(57, 28, 2, 'asistent', NULL),
(56, 29, 3, 'vodeći izvođač', 'Statistički značajno smanjenje veličine tumora.'),
(59, 29, 3, 'asistent', NULL),
(58, 30, 1, 'vodeći izvođač', NULL),
(61, 30, 1, 'tehničar za pripremu uzoraka', NULL),
(60, 31, 1, 'vodeći izvođač', 'Neuraminidaza inhibirana za 95% pri IC50.'),
(63, 31, 1, 'asistent', NULL),
(62, 32, 3, 'vodeći izvođač', 'Jedna životinja uginula pre kraja eksperimenta.'),
(65, 32, 3, 'asistent', NULL),
(64, 33, 2, 'vodeći izvođač', NULL),
(67, 33, 2, 'tehničar za pripremu uzoraka', NULL),
(66, 34, 3, 'vodeći izvođač', 'Cisplatin pokazao značajnu antitumorsku aktivnost.'),
(69, 34, 3, 'asistent', NULL),
(68, 35, 1, 'vodeći izvođač', NULL),
(71, 35, 1, 'asistent', NULL),
(70, 36, 1, 'vodeći izvođač', 'Sorafenib se vezao za VEGFR sa visokim afinitetom.'),
(73, 36, 1, 'tehničar za pripremu uzoraka', NULL),
(72, 37, 3, 'vodeći izvođač', NULL),
(75, 37, 3, 'asistent', NULL),
(74, 38, 2, 'vodeći izvođač', 'Doxorubicin pokazao brzu distribuciju u tkivima.'),
(77, 38, 2, 'asistent', NULL),
(76, 39, 3, 'vodeći izvođač', NULL),
(79, 39, 3, 'tehničar za pripremu uzoraka', NULL),
(78, 40, 1, 'vodeći izvođač', 'Temozolomid pokazao selektivnu citotoksičnost.'),
(81, 40, 1, 'asistent', NULL),
(80, 41, 1, 'vodeći izvođač', NULL),
(83, 41, 1, 'asistent', NULL),
(82, 42, 2, 'vodeći izvođač', 'Vinkristin inhibirao mitotičko vreteno.'),
(85, 42, 2, 'tehničar za pripremu uzoraka', NULL),
(84, 43, 2, 'vodeći izvođač', NULL),
(87, 43, 2, 'asistent', NULL),
(86, 44, 3, 'vodeći izvođač', 'Gemcitabin pokazao antitumorsku aktivnost na pankreasu.'),
(89, 44, 3, 'asistent', NULL),
(88, 45, 1, 'vodeći izvođač', NULL),
(91, 45, 1, 'tehničar za pripremu uzoraka', NULL),
(90, 46, 1, 'vodeći izvođač', 'Sunitinib inhibirao angiogenezu tumorskog tkiva.'),
(93, 46, 1, 'asistent', NULL),
(92, 47, 2, 'vodeći izvođač', 'Inkubator imao grešku, rezultati nepouzdani.'),
(94, 47, 2, 'asistent', NULL),
(95, 48, 2, 'vodeći izvođač', NULL),
(96, 49, 3, 'vodeći izvođač', 'Vinkristin pokazao efikasnost na modelu leukemije.'),
(97, 50, 1, 'vodeći izvođač', NULL),
(98, 51, 1, 'vodeći izvođač', NULL),
(99, 52, 2, 'vodeći izvođač', NULL),
(100, 53, 2, 'vodeći izvođač', NULL);

INSERT INTO sesija (datum, pocetak, zavrsetak, status_sesije, izvodjenje_id, lab_id) VALUES
('2023-01-10', '09:00:00', '13:00:00', 'završena', 1, 1),
('2023-01-15', '10:00:00', '14:00:00', 'završena', 2, 1),
('2023-01-20', '08:00:00', '12:00:00', 'završena', 3, 1),
('2023-02-05', '09:00:00', '13:00:00', 'završena', 4, 1),
('2023-02-10', '10:00:00', '15:00:00', 'završena', 5, 1),
('2023-02-15', '08:00:00', '12:00:00', 'završena', 6, 2),
('2023-02-20', '09:00:00', '14:00:00', 'završena', 7, 2),
('2023-03-01', '10:00:00', '15:00:00', 'završena', 8, 2),
('2023-03-05', '08:00:00', '13:00:00', 'završena', 9, 2),
('2023-03-10', '09:00:00', '14:00:00', 'završena', 10, 2),
('2023-03-15', '10:00:00', '15:00:00', 'završena', 11, 1),
('2023-03-20', '08:00:00', '12:00:00', 'završena', 12, 3),
('2023-04-01', '09:00:00', '13:00:00', 'završena', 13, 3),
('2023-04-05', '10:00:00', '15:00:00', 'završena', 14, 3),
('2023-04-10', '08:00:00', '12:00:00', 'završena', 15, 1),
('2023-04-15', '09:00:00', '14:00:00', 'završena', 16, 1),
('2023-04-20', '10:00:00', '15:00:00', 'završena', 17, 3),
('2023-05-01', '08:00:00', '13:00:00', 'završena', 18, 2),
('2023-05-05', '09:00:00', '14:00:00', 'završena', 19, 3),
('2023-05-10', '10:00:00', '15:00:00', 'završena', 20, 1),
('2023-05-15', '08:00:00', '12:00:00', 'završena', 21, 1),
('2023-05-20', '09:00:00', '14:00:00', 'završena', 22, 2),
('2023-06-01', '10:00:00', '15:00:00', 'završena', 23, 2),
('2023-06-05', '08:00:00', '13:00:00', 'završena', 24, 3),
('2023-06-10', '09:00:00', '14:00:00', 'završena', 25, 1),
('2023-06-15', '10:00:00', '15:00:00', 'završena', 26, 1),
('2023-06-20', '08:00:00', '12:00:00', 'završena', 27, 2),
('2023-07-01', '09:00:00', '14:00:00', 'završena', 28, 2),
('2023-07-05', '10:00:00', '15:00:00', 'završena', 29, 3),
('2023-07-10', '08:00:00', '13:00:00', 'završena', 30, 1),
('2023-07-15', '09:00:00', '14:00:00', 'završena', 31, 1),
('2023-07-20', '10:00:00', '15:00:00', 'otkazana', 32, 3),
('2023-08-01', '08:00:00', '13:00:00', 'završena', 33, 2),
('2023-08-05', '09:00:00', '14:00:00', 'završena', 34, 3),
('2023-08-10', '10:00:00', '15:00:00', 'završena', 35, 1),
('2023-08-15', '08:00:00', '12:00:00', 'završena', 36, 1),
('2023-08-20', '09:00:00', '14:00:00', 'završena', 37, 3),
('2023-09-01', '10:00:00', '15:00:00', 'završena', 38, 2),
('2023-09-05', '08:00:00', '13:00:00', 'završena', 39, 3),
('2023-09-10', '09:00:00', '14:00:00', 'završena', 40, 1),
('2023-09-15', '10:00:00', '15:00:00', 'završena', 41, 1),
('2023-09-20', '08:00:00', '12:00:00', 'završena', 42, 2),
('2023-10-01', '09:00:00', '14:00:00', 'završena', 43, 2),
('2023-10-05', '10:00:00', '15:00:00', 'završena', 44, 3),
('2023-10-10', '08:00:00', '13:00:00', 'završena', 45, 1),
('2023-10-15', '09:00:00', '14:00:00', 'završena', 46, 1),
('2023-10-20', '10:00:00', '15:00:00', 'otkazana', 47, 2),
('2023-11-01', '08:00:00', '12:00:00', 'završena', 48, 2),
('2023-11-05', '09:00:00', '14:00:00', 'završena', 49, 3),
('2023-11-10', '10:00:00', '15:00:00', 'završena', 50, 1),
('2023-11-15', '08:00:00', '13:00:00', 'završena', 51, 1),
('2023-11-20', '09:00:00', '14:00:00', 'završena', 52, 2),
('2023-12-01', '10:00:00', '15:00:00', 'završena', 53, 2),
('2023-12-05', '08:00:00', '13:00:00', 'završena', 54, 3),
('2023-12-10', '09:00:00', '14:00:00', 'završena', 55, 1),
('2023-12-15', '10:00:00', '15:00:00', 'završena', 56, 1),
('2024-01-10', '08:00:00', '12:00:00', 'otkazana', 57, 2),
('2024-01-15', '09:00:00', '14:00:00', 'završena', 58, 2),
('2024-01-20', '10:00:00', '15:00:00', 'završena', 59, 3),
('2024-02-05', '08:00:00', '13:00:00', 'završena', 60, 1),
('2024-02-10', '09:00:00', '14:00:00', 'završena', 61, 1),
('2024-02-15', '10:00:00', '15:00:00', 'završena', 62, 2),
('2024-02-20', '08:00:00', '12:00:00', 'završena', 63, 2),
('2024-03-01', '09:00:00', '14:00:00', 'završena', 64, 3),
('2024-03-05', '10:00:00', '15:00:00', 'završena', 65, 1),
('2024-03-10', '08:00:00', '13:00:00', 'završena', 66, 1),
('2024-03-15', '09:00:00', '14:00:00', 'završena', 67, 2),
('2024-03-20', '10:00:00', '15:00:00', 'završena', 68, 2),
('2024-04-01', '08:00:00', '12:00:00', 'završena', 69, 3),
('2024-04-05', '09:00:00', '14:00:00', 'završena', 70, 1),
('2024-04-10', '10:00:00', '15:00:00', 'završena', 71, 1),
('2024-04-15', '08:00:00', '13:00:00', 'završena', 72, 2),
('2024-04-20', '09:00:00', '14:00:00', 'završena', 73, 2),
('2024-05-01', '10:00:00', '15:00:00', 'završena', 74, 3),
('2024-05-05', '08:00:00', '12:00:00', 'završena', 75, 1),
('2024-05-10', '09:00:00', '14:00:00', 'završena', 76, 1),
('2024-05-15', '10:00:00', '15:00:00', 'završena', 77, 2),
('2024-05-20', '08:00:00', '13:00:00', 'završena', 78, 2),
('2024-06-01', '09:00:00', '14:00:00', 'završena', 79, 3),
('2024-06-05', '10:00:00', '15:00:00', 'završena', 80, 1),
('2024-06-10', '08:00:00', '12:00:00', 'završena', 81, 1),
('2024-06-15', '09:00:00', '14:00:00', 'završena', 82, 2),
('2024-06-20', '10:00:00', '15:00:00', 'završena', 83, 2),
('2024-07-01', '08:00:00', '13:00:00', 'završena', 84, 3),
('2024-07-05', '09:00:00', '14:00:00', 'završena', 85, 1),
('2024-07-10', '10:00:00', '15:00:00', 'završena', 86, 1),
('2024-07-15', '08:00:00', '12:00:00', 'završena', 87, 2),
('2024-07-20', '09:00:00', '14:00:00', 'završena', 88, 2),
('2024-08-01', '10:00:00', '15:00:00', 'završena', 89, 3),
('2024-08-05', '08:00:00', '13:00:00', 'završena', 90, 1),
('2024-08-10', '09:00:00', '14:00:00', 'završena', 91, 1),
('2024-08-15', '10:00:00', '15:00:00', 'završena', 92, 2),
('2024-08-20', '08:00:00', '12:00:00', 'završena', 93, 2),
('2024-09-01', '09:00:00', '14:00:00', 'završena', 94, 3),
('2024-09-05', '10:00:00', '15:00:00', 'zakazana', 95, 1),
('2024-09-10', '08:00:00', '13:00:00', 'zakazana', 96, 1),
('2024-09-15', '09:00:00', '14:00:00', 'zakazana', 97, 2),
('2024-09-20', '10:00:00', '15:00:00', 'zakazana', 98, 2),
('2024-10-01', '08:00:00', '12:00:00', 'zakazana', 99, 3),
('2024-10-05', '09:00:00', '14:00:00', 'zakazana', 100, 1);

INSERT INTO rezultat (endpoint_id, izvodjenje_id, lab_id, vrednost, jedinica) VALUES
(1, 1, 1, 25.50, 'µM'),
(3, 1, 1, 65.00, '%'),
(1, 2, 1, 18.30, 'µM'),
(3, 2, 1, 72.00, '%'),
(1, 3, 1, 12.80, 'µM'),
(3, 3, 1, 78.00, '%'),
(1, 4, 1, 45.20, 'µM'),
(3, 4, 1, 55.00, '%'),
(1, 5, 1, 32.60, 'µM'),
(3, 5, 1, 61.00, '%'),
(2, 6, 2, 285.00, 'mg/kg'),
(3, 6, 2, 48.00, '%'),
(2, 7, 2, 156.00, 'mg/kg'),
(4, 8, 2, 1250.00, 'ng/ml'),
(5, 8, 2, 4.50, 'h'),
(6, 8, 2, 8500.00, 'ng*h/ml'),
(7, 8, 2, 2.00, 'h'),
(4, 9, 2, 850.00, 'ng/ml'),
(5, 9, 2, 6.00, 'h'),
(6, 9, 2, 6200.00, 'ng*h/ml'),
(7, 9, 2, 3.00, 'h'),
(4, 10, 2, 420.00, 'ng/ml'),
(5, 10, 2, 8.00, 'h'),
(6, 10, 2, 4800.00, 'ng*h/ml'),
(7, 10, 2, 4.00, 'h'),
(4, 11, 1, 680.00, 'ng/ml'),
(5, 11, 1, 5.50, 'h'),
(6, 11, 1, 5100.00, 'ng*h/ml'),
(3, 12, 3, 42.00, '%'),
(3, 13, 3, 38.00, '%'),
(3, 14, 3, 55.00, '%'),
(1, 15, 1, 8.90, 'µM'),
(3, 15, 1, 82.00, '%'),
(1, 16, 1, 22.40, 'µM'),
(2, 17, 3, 312.00, 'mg/kg'),
(4, 18, 2, 920.00, 'ng/ml'),
(5, 18, 2, 5.00, 'h'),
(6, 18, 2, 7200.00, 'ng*h/ml'),
(3, 19, 3, 61.00, '%'),
(1, 20, 1, 15.60, 'µM'),
(3, 20, 1, 75.00, '%'),
(1, 21, 1, 38.90, 'µM'),
(2, 22, 2, 198.00, 'mg/kg'),
(4, 23, 2, 1100.00, 'ng/ml'),
(5, 23, 2, 3.50, 'h'),
(6, 23, 2, 9200.00, 'ng*h/ml'),
(7, 23, 2, 1.50, 'h'),
(3, 24, 3, 35.00, '%'),
(1, 25, 1, 9.80, 'µM'),
(3, 25, 1, 85.00, '%'),
(1, 26, 1, 28.40, 'µM'),
(2, 27, 2, 245.00, 'mg/kg'),
(4, 28, 2, 780.00, 'ng/ml'),
(5, 28, 2, 12.00, 'h'),
(6, 28, 2, 5800.00, 'ng*h/ml'),
(3, 29, 3, 45.00, '%'),
(1, 30, 1, 19.70, 'µM'),
(3, 30, 1, 68.00, '%'),
(1, 31, 1, 42.10, 'µM'),
(2, 32, 3, 178.00, 'mg/kg'),
(4, 33, 2, 560.00, 'ng/ml'),
(5, 33, 2, 7.00, 'h'),
(6, 33, 2, 4200.00, 'ng*h/ml'),
(3, 34, 3, 52.00, '%'),
(1, 35, 1, 11.30, 'µM'),
(3, 35, 1, 80.00, '%'),
(1, 36, 1, 35.80, 'µM'),
(2, 37, 3, 267.00, 'mg/kg'),
(4, 38, 2, 1450.00, 'ng/ml'),
(5, 38, 2, 5.00, 'h'),
(6, 38, 2, 10200.00, 'ng*h/ml'),
(3, 39, 3, 40.00, '%'),
(1, 40, 1, 22.90, 'µM'),
(3, 40, 1, 70.00, '%'),
(1, 41, 1, 48.60, 'µM'),
(2, 42, 2, 320.00, 'mg/kg'),
(4, 43, 2, 890.00, 'ng/ml'),
(5, 43, 2, 6.50, 'h'),
(3, 44, 3, 58.00, '%'),
(1, 45, 1, 14.20, 'µM'),
(3, 45, 1, 76.00, '%'),
(1, 46, 1, 31.50, 'µM'),
(2, 48, 2, 195.00, 'mg/kg'),
(4, 48, 2, 670.00, 'ng/ml'),
(5, 48, 2, 9.00, 'h'),
(3, 49, 3, 48.00, '%'),
(1, 50, 1, 16.80, 'µM'),
(3, 50, 1, 73.00, '%'),
(1, 51, 1, 39.20, 'µM'),
(2, 52, 2, 289.00, 'mg/kg'),
(4, 53, 2, 1020.00, 'ng/ml'),
(5, 53, 2, 4.00, 'h'),
(6, 53, 2, 7800.00, 'ng*h/ml'),
(3, 54, 3, 44.00, '%'),
(1, 55, 1, 10.50, 'µM'),
(3, 55, 1, 83.00, '%'),
(1, 56, 1, 27.30, 'µM'),
(4, 58, 2, 740.00, 'ng/ml'),
(5, 58, 2, 8.50, 'h'),
(3, 59, 3, 56.00, '%'),
(1, 60, 1, 20.40, 'µM'),
(3, 60, 1, 69.00, '%');

INSERT INTO ses_resurs (sesija_id, resurs_id, potrosena_kol) VALUES
(1, 4, 5.00),
(1, 11, 1.00),
(1, 22, 50.00),
(1, 25, 2.00),
(2, 5, 3.00),
(2, 13, 1.00),
(2, 22, 50.00),
(2, 25, 2.00),
(3, 37, 4.00),
(3, 14, 1.00),
(3, 22, 50.00),
(3, 28, 1.00),
(4, 2, 6.00),
(4, 11, 1.00),
(4, 28, 1.00),
(5, 31, 5.00),
(5, 11, 1.00),
(5, 28, 1.00),
(6, 6, 10.00),
(6, 16, 3.00),
(6, 27, 5.00),
(7, 39, 8.00),
(7, 16, 5.00),
(8, 4, 6.00),
(8, 18, 4.00),
(9, 7, 7.00),
(9, 17, 3.00),
(10, 10, 5.00),
(10, 16, 3.00),
(11, 2, 8.00),
(11, 16, 3.00),
(12, 5, 4.00),
(12, 16, 5.00),
(13, 4, 6.00),
(13, 47, 5.00),
(14, 6, 10.00),
(14, 16, 4.00),
(15, 33, 5.00),
(15, 12, 1.00),
(15, 22, 50.00),
(16, 5, 3.00),
(16, 12, 1.00),
(17, 3, 8.00),
(17, 19, 5.00),
(18, 8, 6.00),
(18, 16, 3.00),
(19, 9, 4.00),
(19, 16, 4.00),
(20, 36, 5.00),
(20, 44, 1.00),
(20, 22, 50.00),
(21, 7, 6.00),
(21, 12, 1.00),
(22, 33, 7.00),
(22, 16, 5.00),
(23, 37, 4.00),
(23, 17, 3.00),
(24, 31, 5.00),
(24, 18, 4.00),
(25, 40, 6.00),
(25, 12, 1.00),
(25, 22, 50.00),
(26, 32, 5.00),
(26, 11, 1.00),
(27, 36, 8.00),
(27, 16, 5.00),
(28, 34, 6.00),
(28, 18, 4.00),
(29, 35, 5.00),
(29, 45, 1.00),
(30, 38, 4.00),
(30, 45, 1.00),
(30, 22, 50.00),
(31, 10, 5.00),
(31, 11, 1.00),
(33, 39, 7.00),
(33, 16, 4.00),
(34, 4, 6.00),
(34, 47, 5.00),
(35, 31, 5.00),
(35, 41, 1.00),
(36, 33, 6.00),
(36, 11, 1.00),
(37, 38, 5.00),
(37, 18, 4.00),
(38, 5, 4.00),
(38, 17, 3.00),
(39, 37, 5.00),
(39, 19, 4.00),
(40, 35, 6.00),
(40, 45, 1.00),
(41, 1, 8.00),
(41, 11, 1.00),
(42, 36, 7.00),
(42, 17, 5.00),
(43, 32, 6.00),
(43, 18, 4.00),
(44, 40, 5.00),
(44, 48, 4.00),
(45, 39, 6.00),
(45, 11, 1.00);

INSERT INTO ses_alat (sesija_id, alat_id, upotreba) VALUES
(1, 3, 'Čitač mikroploča za MTT test'),
(1, 4, 'CO2 inkubator za kultivaciju'),
(1, 5, 'Laminarni boks za sterilni rad'),
(2, 3, 'Čitač mikroploča za MTT test'),
(2, 4, 'CO2 inkubator za kultivaciju'),
(2, 5, 'Laminarni boks za sterilni rad'),
(3, 3, 'Čitač mikroploča za MTT test'),
(3, 4, 'CO2 inkubator za kultivaciju'),
(4, 3, 'Čitač mikroploča za merenje apsorbance'),
(4, 5, 'Laminarni boks za sterilni rad'),
(5, 3, 'Čitač mikroploča za MTT test'),
(5, 4, 'CO2 inkubator za kultivaciju'),
(6, 6, 'Centrifuga za separaciju plazme'),
(6, 7, 'Analitička vaga za merenje doza'),
(7, 6, 'Centrifuga za separaciju plazme'),
(7, 7, 'Analitička vaga za merenje doza'),
(8, 1, 'HPLC sistem za analizu plazme'),
(8, 6, 'Centrifuga za separaciju plazme'),
(9, 1, 'HPLC sistem za analizu plazme'),
(9, 2, 'Maseni spektrometar za identifikaciju'),
(10, 1, 'HPLC sistem za analizu plazme'),
(10, 2, 'Maseni spektrometar za identifikaciju'),
(11, 1, 'HPLC sistem za analizu plazme'),
(11, 6, 'Centrifuga za separaciju plazme'),
(12, 6, 'Centrifuga za homogenizaciju tkiva'),
(12, 7, 'Analitička vaga za merenje doza'),
(13, 6, 'Centrifuga za homogenizaciju tkiva'),
(13, 7, 'Analitička vaga za merenje doza'),
(14, 6, 'Centrifuga za separaciju uzoraka'),
(14, 7, 'Analitička vaga za merenje doza'),
(15, 3, 'Čitač mikroploča za MTT test'),
(15, 4, 'CO2 inkubator za kultivaciju'),
(16, 3, 'Čitač mikroploča za merenje'),
(16, 8, 'Invertni mikroskop za posmatranje ćelija'),
(17, 6, 'Centrifuga za separaciju organa'),
(17, 7, 'Analitička vaga za merenje doza'),
(18, 1, 'HPLC sistem za analizu tkiva'),
(18, 6, 'Centrifuga za homogenizaciju'),
(19, 6, 'Centrifuga za separaciju uzoraka'),
(19, 7, 'Analitička vaga za merenje doza'),
(20, 3, 'Čitač mikroploča za MTT test'),
(20, 4, 'CO2 inkubator za kultivaciju'),
(21, 3, 'Čitač mikroploča za enzimski test'),
(21, 8, 'Invertni mikroskop za posmatranje'),
(22, 6, 'Centrifuga za separaciju plazme'),
(22, 7, 'Analitička vaga za merenje doza'),
(23, 1, 'HPLC sistem za analizu plazme'),
(23, 2, 'Maseni spektrometar za LC-MS analizu'),
(24, 6, 'Centrifuga za homogenizaciju tkiva'),
(24, 7, 'Analitička vaga za merenje doza'),
(25, 3, 'Čitač mikroploča za MTT test'),
(25, 4, 'CO2 inkubator za kultivaciju'),
(26, 3, 'Čitač mikroploča za kompetitivni test'),
(26, 5, 'Laminarni boks za sterilni rad'),
(27, 6, 'Centrifuga za separaciju plazme'),
(27, 7, 'Analitička vaga za merenje doza'),
(28, 1, 'HPLC sistem za analizu plazme'),
(28, 6, 'Centrifuga za separaciju plazme'),
(29, 6, 'Centrifuga za homogenizaciju tkiva'),
(29, 7, 'Analitička vaga za merenje doza'),
(30, 3, 'Čitač mikroploča za MTT test'),
(30, 4, 'CO2 inkubator za kultivaciju'),
(31, 3, 'Čitač mikroploča za enzimski test'),
(31, 5, 'Laminarni boks za sterilni rad'),
(33, 1, 'HPLC sistem za analizu plazme'),
(33, 6, 'Centrifuga za separaciju plazme'),
(34, 6, 'Centrifuga za homogenizaciju tkiva'),
(34, 7, 'Analitička vaga za merenje doza'),
(35, 3, 'Čitač mikroploča za MTT test'),
(35, 4, 'CO2 inkubator za kultivaciju'),
(36, 3, 'Čitač mikroploča za vezivanje'),
(36, 5, 'Laminarni boks za sterilni rad'),
(37, 6, 'Centrifuga za separaciju plazme'),
(37, 7, 'Analitička vaga za merenje doza'),
(38, 1, 'HPLC sistem za analizu plazme'),
(38, 2, 'Maseni spektrometar za identifikaciju'),
(39, 6, 'Centrifuga za homogenizaciju tkiva'),
(39, 7, 'Analitička vaga za merenje doza'),
(40, 3, 'Čitač mikroploča za MTT test'),
(40, 4, 'CO2 inkubator za kultivaciju'),
(41, 3, 'Čitač mikroploča za MTT test'),
(41, 5, 'Laminarni boks za sterilni rad'),
(42, 6, 'Centrifuga za separaciju plazme'),
(42, 7, 'Analitička vaga za merenje doza'),
(43, 1, 'HPLC sistem za analizu plazme'),
(43, 6, 'Centrifuga za separaciju plazme'),
(44, 6, 'Centrifuga za homogenizaciju tkiva'),
(44, 7, 'Analitička vaga za merenje doza'),
(45, 3, 'Čitač mikroploča za MTT test'),
(45, 4, 'CO2 inkubator za kultivaciju'),
(46, 3, 'Čitač mikroploča za MTT test'),
(46, 5, 'Laminarni boks za sterilni rad'),
(48, 1, 'HPLC sistem za analizu plazme'),
(48, 6, 'Centrifuga za separaciju plazme'),
(49, 6, 'Centrifuga za homogenizaciju tkiva'),
(49, 7, 'Analitička vaga za merenje doza'),
(50, 3, 'Čitač mikroploča za MTT test'),
(50, 4, 'CO2 inkubator za kultivaciju'),
(51, 3, 'Čitač mikroploča za MTT test'),
(51, 5, 'Laminarni boks za sterilni rad'),
(52, 6, 'Centrifuga za separaciju plazme'),
(52, 7, 'Analitička vaga za merenje doza');


-- ovo sam samo proverila koliko redova ima u svakoj tabeli
SELECT 'biosafety_nivo' as tabela, COUNT(*) as broj_redova FROM biosafety_nivo UNION ALL
SELECT 'laboratorija', COUNT(*) FROM laboratorija UNION ALL
SELECT 'tip_alata', COUNT(*) FROM tip_alata UNION ALL
SELECT 'alat', COUNT(*) FROM alat UNION ALL
SELECT 'resurs', COUNT(*) FROM resurs UNION ALL
SELECT 'jedinjenje', COUNT(*) FROM jedinjenje UNION ALL
SELECT 'celijska_linija', COUNT(*) FROM celijska_linija UNION ALL
SELECT 'zivotinja', COUNT(*) FROM zivotinja UNION ALL
SELECT 'reagens', COUNT(*) FROM reagens UNION ALL
SELECT 'lab_resurs', COUNT(*) FROM lab_resurs UNION ALL
SELECT 'rezim_doziranja', COUNT(*) FROM rezim_doziranja UNION ALL
SELECT 'tip_eksperimenta', COUNT(*) FROM tip_eksperimenta UNION ALL
SELECT 'endpoint', COUNT(*) FROM endpoint UNION ALL
SELECT 'eksperiment', COUNT(*) FROM eksperiment UNION ALL
SELECT 'cilj_istrazivanja', COUNT(*) FROM cilj_istrazivanja UNION ALL
SELECT 'uloga_resursa', COUNT(*) FROM uloga_resursa UNION ALL
SELECT 'eks_endpoint', COUNT(*) FROM eks_endpoint UNION ALL
SELECT 'eks_tip_alata', COUNT(*) FROM eks_tip_alata UNION ALL
SELECT 'specijalizacija', COUNT(*) FROM specijalizacija UNION ALL
SELECT 'sertifikat', COUNT(*) FROM sertifikat UNION ALL
SELECT 'istrazivac', COUNT(*) FROM istrazivac UNION ALL
SELECT 'istrazivac_specijalizacija', COUNT(*) FROM istrazivac_specijalizacija UNION ALL
SELECT 'konkretan_sertifikat', COUNT(*) FROM konkretan_sertifikat UNION ALL
SELECT 'izvodjac', COUNT(*) FROM izvodjac UNION ALL
SELECT 'dizajner', COUNT(*) FROM dizajner UNION ALL
SELECT 'teorija', COUNT(*) FROM teorija UNION ALL
SELECT 'eksperiment_dizajner', COUNT(*) FROM eksperiment_dizajner UNION ALL
SELECT 'status_izvodjenja', COUNT(*) FROM status_izvodjenja UNION ALL
SELECT 'izvodjenje', COUNT(*) FROM izvodjenje UNION ALL
SELECT 'uloga', COUNT(*) FROM uloga UNION ALL
SELECT 'rezultat', COUNT(*) FROM rezultat UNION ALL
SELECT 'sesija', COUNT(*) FROM sesija UNION ALL
SELECT 'ses_resurs', COUNT(*) FROM ses_resurs UNION ALL
SELECT 'ses_alat', COUNT(*) FROM ses_alat;

-- Pogled pregled_laboratorija prikazuje laboratorije sa broj eksperimenata
-- koji su se u njima izvodili i brojem istrazivaca koji su ucestvovali.
-- Uvodi se radi lakseg pracenja aktivnosti po laboratorijama,
-- kako se ne bi svaki put pisao kompleksan JOIN upit.
CREATE VIEW pregled_laboratorija AS
SELECT
	l.naziv AS laboratorija,
    COUNT(DISTINCT izv.eks_id) AS broj_eksperimenata,
    COUNT(DISTINCT u.izvodjac_id) AS broj_istrazivaca
FROM laboratorija l
JOIN izvodjenje izv ON l.lab_id = izv.lab_id
JOIN uloga u ON izv.izvodjenje_id = u.izvodjenje_id
			AND izv.lab_id = u.lab_id
GROUP BY l.lab_id
HAVING COUNT(DISTINCT izv.eks_id) > 10;

-- select ne mora biti u istom fajlu kao create view, pozivam samo radi testiranja
SELECT * FROM pregled_laboratorija;

-- Pogled istrazivaci_klasifikacije prikazuje istrazivace sa ukupnim brojem
-- specijalizacija i sertifikata koje poseduju.
-- Uvodi se radu lakseg pregleda kvalifikovanosti istrazivaca
-- kako se ne bi svaki put pisao slozeni JOIN upiti.
CREATE VIEW istrazivaci_klasifikacije AS
SELECT
	i.ime,
    i.prezime,
    i.akademska_titula,
    COUNT(DISTINCT isp.specijalizacija_id) AS broj_specijalizacija,
    COUNT(DISTINCT ks.sertifikat_id) AS broj_sertifikata
FROM istrazivac i
JOIN konkretan_sertifikat ks ON i.istrazivac_id = ks.istrazivac_id
JOIN istrazivac_specijalizacija isp ON i.istrazivac_id = isp.istrazivac_id
GROUP BY i.istrazivac_id
HAVING COUNT(DISTINCT ks.sertifikat_id) >= 1; 

SELECT * FROM istrazivaci_klasifikacije;

-- Pogled pregled_sesija prikazuje zakazane sesije zajedno sa detaljima
-- izvođenja i eksperimenta koji se u njima izvršava.
-- Uvodi se radi lakšeg pregleda rasporeda sesija u aplikaciji administratora
-- bez potrebe da se svaki put pišu složeni JOIN upiti.
-- GROUP BY i HAVING su uvedeni radi ispunjenja tehničkih zahteva projekta,
-- grupisanjem po sesija_id obezbeđujemo jedinstvenost redova u rezultatu.
CREATE VIEW pregled_sesija AS
SELECT
	s.sesija_id,
    s.datum,
    s.pocetak,
    s.zavrsetak,
    s.status_sesije,
    l.naziv AS laboratorija,
    e.naziv AS eksperiment,
    i.datum AS datum_izvodjenja,
    si.opis AS status_izvodjenja
FROM sesija s
JOIN izvodjenje i ON s.izvodjenje_id = i.izvodjenje_id AND s.lab_id = i.lab_id
JOIN laboratorija l ON s.lab_id = l.lab_id
JOIN eksperiment e ON i.eks_id = e.eks_id
JOIN status_izvodjenja si ON i.status_id = si.status_id
GROUP BY s.sesija_id
HAVING COUNT(s.sesija_id) >= 1;

SELECT * FROM pregled_sesija;


DELIMITER $$

-- Procedura zakazi_sesiju zakazuje novu sesiju u laboratoriji.
-- Proverava tri uslova: preklapanje termina u laboratoriji,
-- dostupnost potrebnih resursa i pripadnost alata laboratoriji.
-- Ako su svi uslovi zadovoljeni, kreira sesiju sa statusom 'zakazana'.
-- Ako ijedan uslov nije zadovoljen, transakcija se poništava (ROLLBACK)
-- i sesija se ne kreira.
CREATE PROCEDURE zakazi_sesiju(
	IN p_datum DATE,
    IN p_pocetak TIME,
    IN p_zavrsetak TIME,
    IN p_izvodjenje_id INT,
    IN p_lab_id INT,
    IN p_resurs_id INT,
    IN p_potrosena_kol DECIMAL(10,2),
    IN p_alat_id INT    
)
BEGIN
	DECLARE v_preklapanje INT;
    DECLARE v_dostupna_kol DECIMAL(10,2);
    DECLARE v_alat_u_lab INT;
    
    -- proveravamo preklapanje termina - brojimo sesije koje se vremenski poklapaju sa trazenim terminom u istoj lab
    SELECT COUNT(*) INTO v_preklapanje
    FROM sesija
    WHERE lab_id = p_lab_id
    AND datum = p_datum
    AND (
		(p_pocetak >= pocetak AND p_pocetak < zavrsetak)
        OR (p_zavrsetak > pocetak AND p_zavrsetak <= zavrsetak)
        OR (p_pocetak <= pocetak AND p_zavrsetak >= zavrsetak)
    );
    
    -- proveravamo dostupnu kolicinu resursa
    SELECT kolicina INTO v_dostupna_kol
    FROM lab_resurs
    WHERE lab_id = p_lab_id AND resurs_id = p_resurs_id;
    
    -- proveravamo da li alat pripada laboratoriji
    SELECT COUNT(*) INTO v_alat_u_lab
    FROM alat
    WHERE alat_id = p_alat_id AND lab_id = p_lab_id;
    
    START TRANSACTION;
    
    IF v_preklapanje > 0 THEN
		ROLLBACK;
        SELECT 'Laboratorija nije dostupna u trazenom terminu' AS poruka;
	ELSEIF v_dostupna_kol < p_potrosena_kol THEN
		ROLLBACK;
        SELECT 'Nema dovoljno resursa u laboratoriji' AS poruka;
	ELSEIF v_alat_u_lab = 0 THEN
		ROLLBACK;
        SELECT 'Alat ne pripada ovoj laboratoriji' AS poruka;
	ELSE
		-- kreiramo sesiju
        INSERT INTO sesija (datum, pocetak, zavrsetak, status_sesije, izvodjenje_id, lab_id)
        VALUES (p_datum, p_pocetak, p_zavrsetak, 'zakazana', p_izvodjenje_id, p_lab_id);
        
        COMMIT;
        SELECT 'Sesija uspesno zakazana' AS poruka;
	END IF;
END $$
		
DELIMITER ;

-- testiranje procedure - uspesno zakazivanje
-- CALL zakazi_sesiju(
-- '2025-01-15',  -- datum
-- '09:00:00',    -- pocetak
-- '13:00:00',    -- zavrsetak
-- 1,             -- izvodjenje_id
-- 1,             -- lab_id
-- 4,             -- resurs_id (cisplatin)
-- 10.00,         -- potrosena_kol
-- 1              -- alat_id
-- );
-- SELECT * FROM sesija WHERE datum = '2025-01-15';

-- testiranje procedure - neuspesni slucajevi
-- CALL zakazi_sesiju('2025-01-15', '10:00:00', '12:00:00', 1, 1, 4, 10.00, 1);
-- CALL zakazi_sesiju('2025-02-01', '09:00:00', '13:00:00', 1, 1, 4, 99999.00, 1);
-- CALL zakazi_sesiju('2025-03-01', '09:00:00', '13:00:00', 1, 1, 4, 10.00, 10);

DELIMITER $$

-- Procedura zavrsi_sesiju se poziva po završetku sesije.
-- Menja status sesije na 'zavrsena' i automatski azurira inventar
-- laboratorije oduzimanjem potrosenih resursa od dostupnih kolicina.
-- Ako nema dovoljno resursa, transakcija se ponistava (ROLLBACK).
-- Uvodi se radi automatskog azuriranja inventara laboratorije
-- po zavrsetku sesije kroz transakciju.
CREATE PROCEDURE zavrsi_sesiju(
	IN p_sesija_id INT,
    IN p_resurs_id INT,
    IN p_potrosena_kol DECIMAL(10,2)
)
BEGIN
	DECLARE v_dostupna_kol DECIMAL(10,2);
    DECLARE v_lab_id INT;
    
    -- pronalazimo lab_id sesije
    SELECT lab_id INTO v_lab_id
    FROM sesija
    WHERE sesija_id = p_sesija_id;
    
    -- proveravamo dostupnu kolicinu resursa
    SELECT kolicina INTO v_dostupna_kol
    FROM lab_resurs
    WHERE lab_id = v_lab_id AND resurs_id = p_resurs_id;
    
    START TRANSACTION;
    
    IF v_dostupna_kol < p_potrosena_kol THEN
		ROLLBACK;
        SELECT 'Nema dovoljno resursa u laboratoriji' AS poruka;
	ELSE
		-- menjamo status sesije na zavrsena
        UPDATE sesija
        SET status_sesije = 'zavrsena'
        WHERE sesija_id = p_sesija_id;
        
        -- azuriramo inventar laboratorije
        UPDATE lab_resurs
        SET kolicina = kolicina - p_potrosena_kol
        WHERE lab_id = v_lab_id AND resurs_id = p_resurs_id;
        
        COMMIT;
        SELECT 'Sesija uspesno zavrsena i inventar azuriran' AS poruka;
	END IF;
END $$

DELIMITER ;

-- testiranje zavrsi_sesiju
-- SELECT sesija_id, datum, status_sesije FROM sesija WHERE datum = '2025-01-15';
-- CALL zavrsi_sesiju(102, 4, 5.00);
-- SELECT kolicina FROM lab_resurs WHERE lab_id = 1 AND resurs_id = 4;



DELIMITER $$

-- Procedura izmeni_sesiju menja podatke o određenoj zakazanoj sesiji.
-- Prima sesija_id, nove vrednosti za datum, vreme i status sesije.
-- Proverava preklapanje termina, a status izvođenja se automatski
-- ažurira na osnovu novog statusa sesije.
-- Uvodi se radi bezbedne izmene sesija uz automatsku sinhronizaciju
-- statusa sesije i izvođenja.
CREATE PROCEDURE izmeni_sesiju(
	IN p_sesija_id INT,
    IN p_novi_datum DATE,
    IN p_novi_pocetak TIME,
    IN p_novi_zavrsetak TIME,
    IN p_novi_status VARCHAR(50)
)
BEGIN
	DECLARE v_lab_id INT;
    DECLARE v_preklapanje INT;
    DECLARE v_izvodjenje_id INT;
    DECLARE v_novi_status_izvodjenja VARCHAR(50);
    
    -- pronalazimo lab_id sesije
    SELECT lab_id, izvodjenje_id INTO v_lab_id, v_izvodjenje_id
    FROM sesija
    WHERE sesija_id = p_sesija_id;
    
    -- automatski postavljamo status izvodjenja na osnovu statusa sesije
    IF p_novi_status = 'zakazana' THEN
        SET v_novi_status_izvodjenja = 'planirano';
    ELSEIF p_novi_status = 'u toku' THEN
        SET v_novi_status_izvodjenja = 'zapoceto';
    ELSEIF p_novi_status = 'zavrsena' THEN
        SET v_novi_status_izvodjenja = 'zavrseno uspesno';
    ELSEIF p_novi_status = 'otkazana' THEN
        SET v_novi_status_izvodjenja = 'otkazano';
    END IF;
    
    -- proveravamo preklapanje sa drugim sesija (iskljucujemo trenutnu)
    SELECT COUNT(*) INTO v_preklapanje
    FROM sesija
    WHERE lab_id = v_lab_id
    AND datum = p_novi_datum
    AND sesija_id != p_sesija_id
    AND (
		(p_novi_pocetak >= pocetak AND p_novi_pocetak < zavrsetak)
        OR (p_novi_zavrsetak > pocetak AND p_novi_zavrsetak <= zavrsetak)
        OR (p_novi_pocetak <= pocetak AND p_novi_zavrsetak >= zavrsetak)
    );
    
    START TRANSACTION;
    
    IF v_preklapanje > 0 THEN
		ROLLBACK;
        SELECT 'Laboratorija nije dostupna u novom terminu' AS poruka;
	ELSE
		UPDATE sesija
        SET datum = p_novi_datum,
			pocetak = p_novi_pocetak,
            zavrsetak = p_novi_zavrsetak,
            status_sesije = p_novi_status
		WHERE sesija_id = p_sesija_id;
        
        -- automatski menjamo status izvodjenja na osnovu statusa sesije
        UPDATE izvodjenje
        SET status_id = (
            SELECT status_id FROM status_izvodjenja 
            WHERE opis = v_novi_status_izvodjenja
        )
        WHERE izvodjenje_id = v_izvodjenje_id
        AND lab_id = v_lab_id;
        
        COMMIT;
        SELECT 'Sesija uspesno izmenjena' AS poruka;
	END IF;
END $$

DELIMITER ;

DELIMITER $$

-- Procedura obrisi_laboratoriju brise laboratoriju iz baze.
-- Dozvoljeno je samo ukoliko u toj laboratoriji ne radi nijedan istrazivac.
-- Uvodi se radi bezbednog brisanja laboratorija uz proveru
-- da li je laboratorija trenutno aktivna.
CREATE PROCEDURE obrisi_laboratoriju(
	IN p_lab_id INT
)
BEGIN
	DECLARE v_broj_istrazivaca INT;
    
    -- proveravamo da li u laboratoriji radi neki istrazivac
    SELECT COUNT(*) INTO v_broj_istrazivaca
    FROM istrazivac
    WHERE lab_id = p_lab_id;
    
    START TRANSACTION;
    
    IF v_broj_istrazivaca > 0 THEN
		ROLLBACK;
        SELECT 'Nije moguce obrisati laboratoriju jer u njoj rade istrazivaci' AS poruka;
	ELSE
		DELETE FROM laboratorija
        WHERE lab_id = p_lab_id;
        
        COMMIT;
        SELECT 'Laboratorija uspesno obrisana' AS poruka;
	END IF;
END $$

DELIMITER ;



DELIMITER $$

-- Funkcija broj_istrazivaca_u_lab prima lab_id i vraca ukupan broj
-- istrazivaca koji rade u toj laboratoriji.
-- Uvodi se radi lakseg dobijanja broja istrazivaca po laboratoriji
-- bez potrebe da se svaki put pise JOIN upit.
CREATE FUNCTION broj_istrazivaca_u_lab(p_lab_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE v_broj int;
    
    SELECT COUNT(*) INTO V_broj
    FROM istrazivac
    WHERE lab_id = p_lab_id;
    
    RETURN v_broj;
END $$

DELIMITER ;

-- testiranje da li prolazi fja - SELECT broj_istrazivaca_u_lab(1) AS br_istrazivaca_u_lab1;

DELIMITER $$

-- Test funkcija testira funkciju broj_istrazivaca_u_lab za 5 razlicitih
-- vrednosti lab_id i vraca TRUE ako su svi rezultati ispravni,
-- a FALSE ako ijedan rezultat nije ispravan.
CREATE FUNCTION test_broj_istrazivaca_u_lab()
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	DECLARE v_rezultat BOOLEAN DEFAULT TRUE;
    
    -- Test 1: lab_id = 1, ocekujemo vise od 0 istrazivaca
    IF broj_istrazivaca_u_lab(1) <= 0 THEN
		SET v_rezultat = FALSE;
	END IF;
    
    -- Test 2: lab_id = 2, ocekujemo vise od 0 istrazivaca
    IF broj_istrazivaca_u_lab(2) <= 0 THEN
		SET v_rezultat = FALSE;
	END IF;
    
    -- Test 3: lab_id = 3, ocekujemo vise od 0 istrazivaca
    IF broj_istrazivaca_u_lab(3) <= 0 THEN
		SET v_rezultat = FALSE;
	END IF;
    
    -- Test 4: lab_id = 4, ocekujemo vise od 0 istrazivaca
    IF broj_istrazivaca_u_lab(4) <= 0 THEN
		SET v_rezultat = FALSE;
	END IF;
    
    -- Test 5: lab_id = 999, ocekujemo 0 istrazivaca (ne postoji)
    IF broj_istrazivaca_u_lab(999) != 0 THEN
		SET v_rezultat = FALSE;
	END IF;
    
    RETURN v_rezultat;
END $$

DELIMITER ;

SELECT test_broj_istrazivaca_u_lab() AS rezultat_testa;

DELIMITER $$

-- Procedura dodaj_laboratoriju dodaje novu laboratoriju u bazu.
-- Proverava da li laboratorija sa istim nazivom vec postoji.
-- Ako postoji, transakcija se ponistava (ROLLBACK).
-- Ako ne postoji, nova laboratorija se dodaje u bazu (INSERT).
-- Uvodi se radi bezbednog dodavanja laboratorija uz proveru duplikata.

CREATE PROCEDURE dodaj_laboratoriju(
	IN p_naziv VARCHAR(100),
    IN p_zgrada VARCHAR(100),
    IN p_sprat INT,
    IN p_br_prostorije VARCHAR(20),
    IN p_biosafety_id INT
)
BEGIN
	DECLARE v_postojeca INT;
    
    -- proveravamo da li laboratorija sa istim nazivom vec postoji
    SELECT COUNT(*) INTO v_postojeca
    FROM laboratorija
    WHERE naziv = p_naziv;
    
    START TRANSACTION;
    
    IF v_postojeca > 0 THEN
		ROLLBACK;
        SELECT 'Laboratorija sa tim nazivom vec postoji' AS poruka;
	ELSE
		INSERT INTO laboratorija (naziv, zgrada, sprat, br_prostorije, biosafety_id)
        VALUES (p_naziv, p_zgrada, p_sprat, p_br_prostorije, p_biosafety_id);
        
        COMMIT;
        SELECT 'Laboratorija uspesno dodata' AS poruka;
	END IF;
END $$

DELIMITER ;
-- test 1: uspesno dodavanje nove laboratorije
-- CALL dodaj_laboratoriju('Laboratorija za neurobiologiju', 'Zgrada D', 2, '201', 2);
-- test 2: neuspesno dodavanje laboratorije (vec postoji)
-- CALL dodaj_laboratoriju('Vivarijum', 'Zgrada C', 1, '001', 1);










  









