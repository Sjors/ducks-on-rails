DROP TABLE IF EXISTS `euring_country_to_iso`;
CREATE TABLE `euring_country_to_iso` (
`ar` VARCHAR( 4 ) NOT NULL ,
`country_id` VARCHAR( 2 ) NULL,
PRIMARY KEY ( `ar` ) ,
FOREIGN KEY (country_id) REFERENCES `countries` (id)
) ENGINE = innodb;

-- Note that countryFormer_id is also part of the primary key,
-- because multiple former countries (in the ISO definition)
-- can occupy one location.
DROP TABLE IF EXISTS `euring_former_country_to_iso`;
CREATE TABLE `euring_former_country_to_iso` (
`ar` VARCHAR( 4 ) NOT NULL ,
`former_country_id` VARCHAR( 4 ) NULL ,
PRIMARY KEY ( `ar`, `former_country_id`) ,
FOREIGN KEY (former_country_id) REFERENCES `former_countries` (id)
) ENGINE = innodb;

DROP TABLE IF EXISTS `euring_country_subdivision_to_iso`;
CREATE TABLE `euring_country_subdivision_to_iso` (
`ar` VARCHAR( 4 ) NOT NULL ,
`country_subdivision_id` VARCHAR( 6 ) NULL ,
PRIMARY KEY ( `ar` ) ,
FOREIGN KEY (country_subdivision_id) REFERENCES `country_subdivisions` (id)
) ENGINE = innodb;


-- Countries
INSERT INTO `euring_country_to_iso` (
    `ar`, 
    `country_id`
) VALUES 
("NL..", "NL"),
("FR..", "FR"),
("GB..", "GB"),
("SF..", "FI"),
("DK..", "DK"),
("ER..", "IE"),
("IS..", "IS"),
("SV..", "SE"),
("IA..", "IT"),
("ES..", "ES"),
("PL..", "PL"),
("BL..", "BE"),
("PO..", "PT"),
("NO..", "NO"),
("HE..", "CH"),
("MA..", "MA"),
("TU..", "TR"),
("BG..", "BG"),
("NU..", "SN"),
("GR..", "GR"),
("HG..", "HU"),
("AG..", "DZ"),
("RU..", "RU"),
("RO..", "RO"),
("DE..", "DE"),
("DF..", "DE"),
("TO..", "TN"),
("AU..", "AT"),
("EM..", "ML"),
("RA48", "VA"); 

--Former countries

INSERT INTO `euring_former_country_to_iso` (`ar`, `former_country_id`) VALUES 
("DD..", "DDDE"),
("YU..", "YUCS"),
("CS..", "CSHH"),
("RU..", "SUH"), #Russian Federation
("SU..", "SUH"), #European part of USSR
("SI..", "SUH"), #Asiatic part of USSR
("AE00", "SUH"), #Armenia
("AK..", "SUH"), #Azerbaijan
("BY..", "SUH"), #Belarus
("ET00", "SUH"), #Estonia
("GE..", "SUH"), #Georgia
("KZ..", "SUH"), #Kazakhstan
("KI..", "SUH"), #Kyrgyzstan
("LV00", "SUH"), #Latvia
("MD00", "SUH"), #Moldava
("TD..", "SUH"), #Tajikistan
("TM..", "SUH"), #Turkmenistan
("UK..", "SUH"), #Ukraine
("UZ..", "SUH"); #Uzbekistan

--Country subdivisions
INSERT INTO `euring_country_subdivision_to_iso` (`ar`, `country_subdivision_id`) VALUES 
-- Netherlands
('NL04', 'NL-DR'),
('NL01', 'NL-FR'), # Vlieland
('NL02', 'NL-FR'), # Griend
('NL03', 'NL-FR'), # Terschelling
('NL05', 'NL-FR'), 
('NL11', 'NL-FR'), # Ameland
('NL12', 'NL-FR'), # Schiermonnik Oog
('NL17', 'NL-FL'), 
('NL06', 'NL-GE'),
('NL07', 'NL-GR'),
('NL13', 'NL-FR'), # Rottermeroog
('NL08', 'NL-LI'),
('NL09', 'NL-NB'),
('NL14', 'NL-NH'),
('NL00', 'NL-NH'), # Texel
('NL15', 'NL-OV'),
('NL16', 'NL-UT'),
('NL18', 'NL-ZE'),
('NL19', 'NL-ZH'),
-- Denmark
('DK15', 'DK-015'),
('DK20', 'DK-020'),
('DK25', 'DK-025'),
('DK30', 'DK-030'),
('DK35', 'DK-035'),
('DK40', 'DK-040'),
('DK42', 'DK-042'),
('DK50', 'DK-050'),
('DK55', 'DK-055'),
('DK60', 'DK-060'),
('DK65', 'DK-065'),
('DK70', 'DK-070'),
('DK76', 'DK-076'),
('DK80', 'DK-080'),
('DK04', 'DK-035'),
('DK10', 'DK-040'),
('DK01', 'DK-042'),
-- Germany (Niedersachsen (Saxony), Schleswig Holstein and Meecklenburg-Vorpommern)
('DEG-', 'DE-SN'),
('DEGB', 'DE-SN'),
('DEGH', 'DE-SN'),
('DEGL', 'DE-SN'),
('DEGW', 'DE-SN'),
('DEGF', 'DE-SN'),
('DEGN', 'DE-SN'),
('DFG-', 'DE-SN'),
('DFGB', 'DE-SN'),
('DFGH', 'DE-SN'),
('DFGL', 'DE-SN'),
('DFGW', 'DE-SN'),
('DFGF', 'DE-SN'),
('DFGN', 'DE-SN'),
('DEQ-', 'DE-SH'),
('DEQS', 'DE-SH'),
('DEQH', 'DE-SH'),
('DEQN', 'DE-SH'),
('DEQT', 'DE-SH'),
('DFQ-', 'DE-SH'),
('DFQS', 'DE-SH'),
('DFQH', 'DE-SH'),
('DFQN', 'DE-SH'),
('DFQT', 'DE-SH'),
('DEMV', 'DE-MV'),
('DFMV', 'DE-MV'),
-- France
('FR01','FR-01'),
('FR02','FR-02'),
('FR03','FR-03'),
('FR04','FR-04'),
('FR05','FR-05'),
('FR06','FR-06'),
('FR07','FR-07'),
('FR08','FR-08'),
('FR09','FR-09'),
('FR10','FR-10'),
('FR11','FR-11'),
('FR12','FR-12'),
('FR13','FR-13'),
('FR14','FR-14'),
('FR15','FR-15'),
('FR16','FR-16'),
('FR17','FR-17'),
('FR18','FR-18'),
('FR19','FR-19'),
('FR21','FR-21'),
('FR22','FR-22'),
('FR23','FR-23'),
('FR24','FR-24'),
('FR25','FR-25'),
('FR26','FR-26'),
('FR27','FR-27'),
('FR28','FR-28'),
('FR29','FR-29'),
('FR30','FR-30'),
('FR31','FR-31'),
('FR32','FR-32'),
('FR33','FR-33'),
('FR34','FR-34'),
('FR35','FR-35'),
('FR36','FR-36'),
('FR37','FR-37'),
('FR38','FR-38'),
('FR39','FR-39'),
('FR40','FR-40'),
('FR41','FR-41'),
('FR42','FR-42'),
('FR43','FR-43'),
('FR44','FR-44'),
('FR45','FR-45'),
('FR46','FR-46'),
('FR47','FR-47'),
('FR48','FR-48'),
('FR49','FR-49'),
('FR50','FR-50'),
('FR51','FR-51'),
('FR52','FR-52'),
('FR53','FR-53'),
('FR54','FR-54'),
('FR55','FR-55'),
('FR56','FR-56'),
('FR57','FR-57'),
('FR58','FR-58'),
('FR59','FR-59'),
('FR60','FR-60'),
('FR61','FR-61'),
('FR62','FR-62'),
('FR63','FR-63'),
('FR64','FR-64'),
('FR65','FR-65'),
('FR66','FR-66'),
('FR67','FR-67'),
('FR68','FR-68'),
('FR69','FR-69'),
('FR70','FR-70'),
('FR71','FR-71'),
('FR72','FR-72'),
('FR73','FR-73'),
('FR74','FR-74'),
('FR75','FR-75'),
('FR76','FR-76'),
('FR77','FR-77'),
('FR78','FR-78'),
('FR79','FR-79'),
('FR80','FR-80'),
('FR81','FR-81'),
('FR82','FR-82'),
('FR83','FR-83'),
('FR84','FR-84'),
('FR85','FR-85'),
('FR86','FR-86'),
('FR87','FR-87'),
('FR88','FR-88'),
('FR89','FR-89'),
('FR90','FR-90'),
('FR91','FR-91'),
('FR92','FR-92'),
('FR93','FR-93'),
('FR94','FR-94'),
('FR95','FR-95'),
-- Great Britain
-- Main problem with Great Brittain is that Euring standard refers to more aggregate 
-- areas than ISO-9136-2. This is fixed in a later (ruby) script for those captures 
-- with reliable coordinate information.
('GBAN', 'GB-AGY'),
#--('GBAV', 'GB-'), (Avon)
('GBBD', 'GB-BDF'),
#--('GBDK', 'GB-'), (Berkshire)
#--('GBBR', 'GB-'), (Border Region)
('GBBC', 'GB-BKM'),
('GBCA', 'GB-CAM'),
#--('GBCR', 'GB-'), (Central Region)
('GBCH', 'GB-CHS'),
('GBCV', 'GB-RCC'),
#--('GBCW', 'GB-'), (Clwyd, Wales)
('GBKE', 'GB-KEN'),
('GBLA', 'GB-LAN'),
('GBLE', 'GB-LCE'),
('GBLI', 'GB-LIN'),
#--('GBLO', 'GB-'), (Greater London)
#--('GBLR', 'GB-'),(Lothian Region)
#--('GBMA', 'GB-'),(Greater Manchester District)
#--('GBME', 'GB-'), (Merseyside)
('GBNK', 'GB-NFK'),
('GBNH', 'GB-NTH'),
('GBNL', 'GB-NBL'),
('GBCO', 'GB-CON'),
('GBCU', 'GB-CMA'),
('GBDB', 'GB-DER'),
('GBDV', 'GB-DEV'),
('GBDO', 'GB-DOR'),
('GBDR', 'GB-DGY'),
('GBDU', 'GB-DUR'),
#--('GBDY', 'GB-'), (Dyfed)
('GBES', 'GB-ESS'),
#-- ('GBFI', 'GB-'), (Fair Isle)
('GBFR', 'GB-FIF'),
('GBGM', 'GB-VGL'), # #--(Glamorgan W, Mid-&S =? Vale of)
('GBGL', 'GB-GLS'),
#--('GBGR', 'GB-'), (Grampian Region)
#--('GBGT', 'GB-'), (Gwent)
('GBGD', 'GB-GWN'),
('GBHA', 'GB-HAM'),
('GBHF', 'GB-HEF'),
('GBHT', 'GB-HRT'),
('GBHR', 'GB-HLD'),
#--('GBHU', 'GB-'), (Humberside)
#--('GBIM', 'GB-'), (Island of Man)
('GBIW', 'GB-IOW'),
('GBNY', 'GB-NYK'),
('GBNT', 'GB-NTT'),
('GBOR', 'GB-ORK'),
('GBOX', 'GB-OXF'),
('GBPO', 'GB-POW'),
#--('GBSA', 'GB-'), (Salop)
('GBSI', 'GB-IOS'),
('GBSH', 'GB-ZET'),
#--('GBSY', 'GB-'), (South Yorks)
('GBST', 'GB-STS'),
#--('GBSC', 'GB-'), (Strahclyde)
('GBSO', 'GB-SOM'),
('GBSK', 'GB-SFK'),
('GBSR', 'GB-SRY'),
#--('GBSX', 'GB-'), (Sussex)
#--('GBTR', 'GB-'), (Tayside region)
('GBTY', 'GB-GAT'),
('GBWK', 'GB-WAR'),
#--('GBWI', 'GB-'), (Western Islands)
#-- ('GBWM', 'GB-'), (West Midlands)
#-- ('GBWY', 'GB-'), (West Yorks)
('GBWT', 'GB-WIL'),
#-- Northern Ireland
('GBUN', 'GB-ANT'),
('GBUR', 'GB-ARM'),
('GBUD', 'GB-DOW'),
('GBUF', 'GB-FER'),
#--('GBUL', 'GB-'), (Londonderry)
#--('GBUT', 'GB-'), (Tyrone)

-- Ireland
('ERCW', 'IE-CW'),
('ERCV', 'IE-CN'),
('ERCL', 'IE-CE'),
('ERCK', 'IE-C'),
('ERDO', 'IE-DL'),
('ERDU', 'IE-D'),
('ERGA', 'IE-G'),
('ERKE', 'IE-KY'),
('ERKD', 'IE-KE'),
('ERKK', 'IE-KK'),
('ERLM', 'IE-LM'),
('ERLX', 'IE-LS'),
('ERLK', 'IE-LK'),
('ERLG', 'IE-LD'),
('ERLU', 'IE-LH'),
('ERMA', 'IE-MO'),
('ERME', 'IE-MH'),
('ERMO', 'IE-MN'),
('EROF', 'IE-OY'),
('ERRO', 'IE-RN'),
('ERSL', 'IE-SO'),
('ERTP', 'IE-TA'),
('ERWA', 'IE-WD'),
('ERWM', 'IE-WH'),
('ERWX', 'IE-WX'),
('ERWI', 'IE-WW'),
-- Spain 
-- ('ES0-', 'ES-'), (Altantic Coast)
('ES00', 'ES-VI'),
('ES01', 'ES-C'),
('ES02', 'ES-SS'),
('ES03', 'ES-LU'),
('ES04', 'ES-OR'),
('ES05', 'ES-O'),
('ES06', 'ES-PO'),
#--('ES07', 'ES-'), (Santander)
('ES08', 'ES-BI'),
#--('ES1-', 'ES-'), (Central, north-west)
('ES10', 'ES-AV'),
('ES11', 'ES-BU'),
('ES12', 'ES-LE'),
('ES13', 'ES-LO'),
('ES14', 'ES-P'),
('ES15', 'ES-SA'),
('ES16', 'ES-SG'),
('ES17', 'ES-SO'),
('ES18', 'ES-VA'),
('ES19', 'ES-ZA'),
#--('ES2-', 'ES-'), (Central, north-east)
('ES20', 'ES-CU'),
('ES21', 'ES-GU'),
('ES22', 'ES-HU'),
('ES23', 'ES-L'),
('ES24', 'ES-NA'),
('ES25', 'ES-TE'),
('ES26', 'ES-Z'),
#--('ES3-', 'ES-'), (North-east coast)
('ES30', 'ES-CU'),
('ES31', 'ES-CS'),
('ES32', 'ES-GI'),
('ES33', 'ES-T'),
#--('ES4-', 'ES-'), (South-east coast)
('ES40', 'ES-AB'),
('ES41', 'ES-A'),
('ES42', 'ES-AL'),
('ES43', 'ES-MU'),
('ES44', 'ES-V'),
#--('ES5-', 'ES-'), (Central, south)
('ES50', 'ES-BA'),
('ES51', 'ES-CC'),
('ES52', 'ES-CR'),
('ES53', 'ES-M'),
('ES54', 'ES-TO'),
#--('ES6-', 'ES-'), (South)
('ES60', 'ES-CA'),
('ES61', 'ES-CO'),
('ES62', 'ES-GR'),
('ES63', 'ES-H'),
('ES64', 'ES-J'),
('ES65', 'ES-MA'),
('ES66', 'ES-SE'),
#--('ES7-', 'ES-'), (Beleares)
#--('ES70', 'ES-'),
#--('ES71', 'ES-'),
#--('ES72', 'ES-'),
#--('ES8-', 'ES-'), (Islas Canarias, former+HCN)
#--('ES80', 'ES-'),
#--('ES81', 'ES-'),
#--('ES82', 'ES-'),
#--('ES83', 'ES-'),
#--('ES84', 'ES-'),
#--('ES85', 'ES-'),
#--('ES86', 'ES-'),
#-- Italy
#--('IA#--', 'IT-'), (Italy)
#--('IA0-', 'IT-'), (Alpine area)
('IA00', 'IT-BL'),
('IA01', 'IT-BG'),
('IA02', 'IT-BZ'),
('IA03', 'IT-BS'),
#-- ('IA04', 'IT-'), (Como, Sondrio, Varese)
('IA05', 'IT-CN'),
#-- ('IA06', 'IT-'), (Novara, Vercelli)
('IA07', 'IT-TO'),
('IA08', 'IT-TN'),
('IA09', 'IT-AO'),
#--('IA1-', 'IT-'), (Po area)
#-- ('IA10', 'IT-'), (Alesandria en Asti)
('IA11', 'IT-BO'),
#--('IA12', 'IT-'), (Cremona & Mantova)
('IA13', 'IT-MI'),
('IA14', 'IT-MO'),
#--('IA15', 'IT-'), (Parma & Reggio n. Emilia)
('IA16', 'IT-PV'),
('IA17', 'IT-PC'),
('IA18', 'IT-VR'),
('IA19', 'IT-VI'),
#--('IA2-', 'IT-'), (North Tyrrhenian)
('IA20', 'IT-AR'),
('IA21', 'IT-FI'),
#--('IA22', 'IT-'), (Genova & Massa, Carrara & La Spezia)
('IA23', 'IT-GR'),
#--('IA24', 'IT-'), (Imperia & Savona)
#--('IA25', 'IT-'), (Livorno & Pisa)
('IA26', 'IT-LU'),
('IA27', 'IT-SI'),
('IA28', 'IT-TR'),
('IA29', 'IT-VT'),
#--('IA3-', 'IT-'), (North Adreactic)
#-- ('IA30', 'IT-'), (Ancona & Pesaro e Urbino)
#-- ('IA31', 'IT-'), (Ascoli Picone & Macerata
#--('IA32', 'IT-'), (Ferrara & Rovigo)
('IA33', 'IT-FO'), 
#--('IA34', 'IT-'), (Gorizia & Udine)
('IA35', 'IT-PD'),
('IA36', 'IT-PG'),
('IA37', 'IT-RA'),
('IA38', 'IT-TV'),
('IA39', 'IT-VE'),
('IA76', 'IT-TS'),
#--('IA4-', 'IT-'), (South Tyrrhenian)
('IA40', 'IT-AV'),
('IA41', 'IT-BN'),
#--('IA42', 'IT-'), (Caserta & Napoli)
('IA43', 'IT-CZ'),
('IA44', 'IT-CS'),
#--('IA45', 'IT-'), (Frosinone & Latina)
('IA46', 'IT-PZ'),
('IA47', 'IT-RC'),
('IA48', 'IT-RM'),
('IA49', 'IT-SA'),
#--('IA5-', 'IT-'), (South Adratic)
('IA50', 'IT-AQ'),
('IA51', 'IT-BA'),
#--('IA52', 'IT-'), (Brindizi & Lecce)
('IA53', 'IT-CB'),
('IA54', 'IT-CH'),
('IA55', 'IT-FG'),
('IA56', 'IT-MT'),
#--('IA57', 'IT-'), (Pescara & Teramo)
('IA58', 'IT-RI'),
('IA59', 'IT-TA'),
#--('IA6-', 'IT-'), (Italian Islands)
('IA61', 'IT-LI');
#--('IA62', 'IT-88'), #--Sardegna
#--('IA63', 'IT-82'), #-- Sicilia
#--('IA64', 'IT-'), (Not used)
#--('IA65', 'IT-TP'), #-- Pantelleria
#--('IA66', 'IT-AG'); #-- Isole Pelagie
