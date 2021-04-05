CREATE TABLE IF NOT EXISTS "tblZnoRecords" (
    outid VARCHAR(90),
    year SMALLINT,
    birth VARCHAR(38),
    sextypename VARCHAR(39),
    regname VARCHAR(26),
    areaname VARCHAR(46),
    tername VARCHAR(153),
    regtypename VARCHAR(101),
    eoname VARCHAR(255),
    eotypename VARCHAR(143),
    eoregname VARCHAR(158),
    eoareaname VARCHAR(208),
    eotername VARCHAR(53),
    eoparent VARCHAR(205),
    ukrtest VARCHAR(47),
    ukrteststatus VARCHAR(153),
    ukrball100 VARCHAR(141),
    ukrball12 VARCHAR(143),
    ukrptname VARCHAR(245),
    ukrptregname VARCHAR(151),
    ukrptareaname VARCHAR(177),
    ukrpttername VARCHAR(47),
    histtest VARCHAR(118),
    histlang VARCHAR(89),
    histteststatus VARCHAR(153),
    histball100 VARCHAR(208),
    histball12 VARCHAR(143),
    histptname VARCHAR(245),
    histptregname VARCHAR(47),
    histptareaname VARCHAR(155),
    histpttername VARCHAR(168),
    mathtest VARCHAR(47),
    mathlang VARCHAR(143),
    mathteststatus VARCHAR(212),
    mathball100 VARCHAR(166),
    mathball12 VARCHAR(143),
    mathptname VARCHAR(243),
    mathptregname VARCHAR(145),
    mathptareaname VARCHAR(54),
    mathpttername VARCHAR(36),
    phystest VARCHAR(208),
    physlang VARCHAR(47),
    physteststatus VARCHAR(212),
    physball100 VARCHAR(143),
    physptname VARCHAR(241),
    physptregname VARCHAR(143),
    physptareaname VARCHAR(49),
    physpttername VARCHAR(107),
    chemtest VARCHAR(165),
    chemlang VARCHAR(143),
    chemteststatus VARCHAR(47),
    chemball100 VARCHAR(212),
    chemptname VARCHAR(241),
    chemptregname VARCHAR(143),
    chemptareaname VARCHAR(168),
    chempttername VARCHAR(36),
    biotest VARCHAR(143),
    biolang VARCHAR(25),
    bioteststatus VARCHAR(208),
    bioball100 VARCHAR(47),
    bioptname VARCHAR(245),
    bioptregname VARCHAR(153),
    bioptareaname VARCHAR(54),
    biopttername VARCHAR(168),
    geotest VARCHAR(26),
    geolang VARCHAR(107),
    geoteststatus VARCHAR(47),
    geoball100 VARCHAR(34),
    geoptname VARCHAR(241),
    geoptregname VARCHAR(25),
    geoptareaname VARCHAR(88),
    geopttername VARCHAR(35),
    engtest VARCHAR(118),
    engteststatus VARCHAR(47),
    engball100 VARCHAR(39),
    engptname VARCHAR(245),
    engptregname VARCHAR(25),
    engptareaname VARCHAR(168),
    engpttername VARCHAR(35),
    frtest VARCHAR(41),
    frteststatus VARCHAR(47),
    frball100 VARCHAR(30),
    frptname VARCHAR(168),
    frptregname VARCHAR(25),
    frptareaname VARCHAR(49),
    frpttername VARCHAR(30),
    deutest VARCHAR(108),
    deuteststatus VARCHAR(47),
    deuball100 VARCHAR(34),
    deuptname VARCHAR(188),
    deuptregname VARCHAR(25),
    deuptareaname VARCHAR(168),
    deupttername VARCHAR(30),
    sptest VARCHAR(32),
    spteststatus VARCHAR(47),
    spball100 VARCHAR(5),
    spptname VARCHAR(168),
    spptregname VARCHAR(25),
    spptareaname VARCHAR(49),
    sppttername VARCHAR(30),
    rustest VARCHAR(14),
    rusteststatus VARCHAR(47),
    rusball100 VARCHAR(5),
    rusptname VARCHAR(190),
    rusptregname VARCHAR(25),
    rusptareaname VARCHAR(49),
    ruspttername VARCHAR(30),
    stid UUID,
    tertypename VARCHAR(5),
    classprofilename VARCHAR(36),
    classlangname VARCHAR(10),
    physball12 VARCHAR(4),
    chemball12 VARCHAR(4),
    bioball12 VARCHAR(4),
    geoball12 VARCHAR(4),
    engball12 VARCHAR(4),
    fratest VARCHAR(15),
    frateststatus VARCHAR(16),
    fraball100 VARCHAR(5),
    fraball12 VARCHAR(4),
    fraptname VARCHAR(236),
    fraptregname VARCHAR(25),
    fraptareaname VARCHAR(41),
    frapttername VARCHAR(29),
    deuball12 VARCHAR(4),
    spatest VARCHAR(14),
    spateststatus VARCHAR(16),
    spaball100 VARCHAR(5),
    spaball12 VARCHAR(4),
    spaptname VARCHAR(236),
    spaptregname VARCHAR(25),
    spaptareaname VARCHAR(44),
    spapttername VARCHAR(30),
    rusball12 VARCHAR(4),
    ukrball VARCHAR(4),
    histball VARCHAR(4),
    mathball VARCHAR(4),
    physball VARCHAR(4),
    chemball VARCHAR(4),
    bioball VARCHAR(4),
    geoball VARCHAR(4),
    engdpalevel VARCHAR(21),
    engball VARCHAR(4),
    fradpalevel VARCHAR(21),
    fraball VARCHAR(4),
    deudpalevel VARCHAR(21),
    deuball VARCHAR(4),
    spadpalevel VARCHAR(21),
    spaball VARCHAR(4),
    ukradaptscale SMALLINT
);



CREATE TABLE IF NOT EXISTS tbl_region (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR			UNIQUE
);	
												
CREATE TABLE IF NOT EXISTS tbl_area (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR,
	region			INT								REFERENCES tbl_region(id),
									UNIQUE (name, region)
);
												
CREATE TABLE IF NOT EXISTS tbl_territory_type (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR			UNIQUE
);
												
CREATE TABLE IF NOT EXISTS tbl_territory (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR,
	type 			INT								REFERENCES tbl_territory_type(id),
	area 			INT								REFERENCES tbl_area(id),
									UNIQUE (name, area)
);	
	
CREATE OR REPLACE FUNCTION func_add_territory (
	reg_name VARCHAR,
	area_name VARCHAR,
	ter_type VARCHAR,
	ter_name VARCHAR
)
	RETURNS INT
LANGUAGE PLPGSQL AS $$
DECLARE
	region_id INT;
	area_id INT;
	ter_type_id INT;
	ter_id INT;
BEGIN
	INSERT INTO tbl_region (name)
	VALUES (reg_name)
	ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO region_id;
	
	INSERT INTO tbl_area (name, region)
	VALUES (area_name, region_id)
	ON CONFLICT (name, region) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO area_id;

	INSERT INTO tbl_territory_type (name)
	VALUES (ter_type)
	ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO ter_type_id;

	INSERT INTO tbl_territory (name, type, area)
	VALUES (ter_name, ter_type_id, area_id)
	ON CONFLICT (name, area) DO UPDATE SET type = EXCLUDED.type
	RETURNING id INTO ter_id;
	
	RETURN ter_id;
END; $$;



CREATE TABLE IF NOT EXISTS tbl_edu_org_type (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR			UNIQUE
);	
	
CREATE TABLE IF NOT EXISTS tbl_edu_org_parent (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR			UNIQUE
);	
	
CREATE TABLE IF NOT EXISTS tbl_edu_org (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR,
	type			INT								REFERENCES tbl_edu_org_type(id),
	territory		INT								REFERENCES tbl_territory(id),
	parent			INT								REFERENCES tbl_edu_org_parent(id),
									UNIQUE (name, territory)
);	

CREATE OR REPLACE FUNCTION func_add_edu_org (
	org_name VARCHAR,
	org_type VARCHAR,
	reg_name VARCHAR,
	area_name VARCHAR,
	ter_name VARCHAR,
	org_parent VARCHAR
)
	RETURNS INT
LANGUAGE PLPGSQL AS $$
DECLARE
	org_type_id INT;
	ter_id INT;
	org_parent_id INT;
	org_id INT;
BEGIN	
	INSERT INTO tbl_edu_org_type (name)
	VALUES (org_type)
	ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO org_type_id;
	
	ter_id := func_add_territory(reg_name, area_name, NULL, ter_name);
	
	INSERT INTO tbl_edu_org_parent (name)
	VALUES (org_parent)
	ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO org_parent_id;
	
	INSERT INTO tbl_edu_org (name, type, territory, parent)
	VALUES (org_name, org_type_id, ter_id, org_parent_id)
	ON CONFLICT (name, territory) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO org_id;
	
	RETURN org_id;
END; $$;
	
CREATE TABLE IF NOT EXISTS tbl_test_point (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR,
	territory		INT								REFERENCES tbl_territory(id),
									UNIQUE (name, territory)
);	

CREATE OR REPLACE FUNCTION func_add_test_point (
	test_point_name VARCHAR,
	reg_name VARCHAR,
	area_name VARCHAR,
	ter_name VARCHAR
)
	RETURNS INT
LANGUAGE PLPGSQL AS $$
DECLARE
	ter_id INT;
	test_point_id INT;
BEGIN	
	ter_id := func_add_territory(reg_name, area_name, NULL, ter_name);
	
	INSERT INTO tbl_test_point (name, territory)
	VALUES (test_point_name, ter_id)
	ON CONFLICT (name, territory) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO test_point_id;
	
	RETURN test_point_id;
END; $$;



CREATE TABLE IF NOT EXISTS tbl_language (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR			UNIQUE
);

CREATE OR REPLACE FUNCTION func_add_language (
	language_name VARCHAR
)
	RETURNS INT
LANGUAGE PLPGSQL AS $$
DECLARE
	language_id INT;
BEGIN	
	INSERT INTO tbl_language (name)
	VALUES (language_name)
	ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO language_id;
	
	RETURN language_id;
END; $$;
	
CREATE TABLE IF NOT EXISTS tbl_class_profile (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR			UNIQUE
);	
	
CREATE TABLE IF NOT EXISTS tbl_sex_type (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR			UNIQUE
);	
	
CREATE TABLE IF NOT EXISTS tbl_reg_type (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR			UNIQUE
);	
	
CREATE TABLE IF NOT EXISTS tbl_reg (
	id				UUID			PRIMARY KEY,
	year			SMALLINT,
	sex_type 		INT								REFERENCES tbl_sex_type(id),
	birth			SMALLINT,
	reg_type	 	INT								REFERENCES tbl_reg_type(id),
	territory		INT 							REFERENCES tbl_territory(id),
	class_profile	INT								REFERENCES tbl_class_profile(id),
	class_lang		INT								REFERENCES tbl_language(id),
	edu_org			INT								REFERENCES tbl_edu_org(id),
	stid			UUID
);

CREATE OR REPLACE FUNCTION func_add_reg (
	out_id UUID,
	year_num SMALLINT,
	birth_num SMALLINT,
	sex_type_name VARCHAR,
	reg_name VARCHAR,
	area_name VARCHAR,
	ter_type VARCHAR,
	ter_name VARCHAR,
	reg_type_name VARCHAR,
	class_profile_name VARCHAR,
	class_lang_name VARCHAR,
	edu_org_name VARCHAR,
	edu_org_type_name VARCHAR,
	edu_org_reg_name VARCHAR,
	edu_org_area_name VARCHAR,
	edu_org_ter_name VARCHAR,
	edu_org_parent VARCHAR,
	st_id UUID
)
	RETURNS UUID
LANGUAGE PLPGSQL AS $$
DECLARE
	sex_type_id INT;
	ter_id INT;
	reg_type_id INT;
	class_profile_id INT;
	class_lang_id INT;
	edu_org_id INT;
	reg_id UUID;
BEGIN
	INSERT INTO tbl_sex_type (name)
	VALUES (sex_type_name)
	ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO sex_type_id;

	ter_id := func_add_territory(reg_name, area_name, ter_type, ter_name);

	INSERT INTO tbl_reg_type (name)
	VALUES (reg_type_name)
	ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO reg_type_id;

	INSERT INTO tbl_class_profile (name)
	VALUES (class_profile_name)
	ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO class_profile_id;
	
	class_lang_id = func_add_language(class_lang_name);
	
	edu_org_id = func_add_edu_org(
		edu_org_name,
		edu_org_type_name,
		edu_org_reg_name,
		edu_org_area_name,
		edu_org_ter_name,
		edu_org_parent);

	INSERT INTO tbl_reg (id, year, sex_type, birth, reg_type, territory, class_profile, class_lang, edu_org, stid)
	VALUES (out_id, year_num, sex_type_id, birth_num, reg_type_id, ter_id, class_profile_id, class_lang_id, edu_org_id, st_id)
	RETURNING id INTO reg_id;
	
	RETURN reg_id;
END; $$;



CREATE TABLE IF NOT EXISTS tbl_test_subject (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR			UNIQUE
);

CREATE TABLE IF NOT EXISTS tbl_test_status (
	id				SERIAL			PRIMARY KEY,
	name 			VARCHAR			UNIQUE
);	
	
CREATE TABLE IF NOT EXISTS tbl_dpa_level (
	id				SERIAL			PRIMARY KEY,
	name			VARCHAR			UNIQUE
);	

CREATE TABLE IF NOT EXISTS tbl_test (
	reg_id			UUID 							REFERENCES tbl_reg(id),
	subject			INT								REFERENCES tbl_test_subject(id),
	language		INT								REFERENCES tbl_language(id),
	status			INT								REFERENCES tbl_test_status(id),
	dpa_level		INT								REFERENCES tbl_dpa_level(id),
	ball_100		SMALLINT,
	ball_12			SMALLINT,
	ball			SMALLINT,
	adapt_scale		SMALLINT,
	test_point		INT								REFERENCES tbl_test_point(id),
									PRIMARY KEY(reg_id, subject)
);

CREATE OR REPLACE FUNCTION func_add_test (
	reg_id UUID,
	test_subject VARCHAR,
	test_language VARCHAR,
	test_status VARCHAR,
	dpa_level VARCHAR,
	ball_100 VARCHAR,
	ball_12 VARCHAR,
	ball VARCHAR,
	adapt_scale SMALLINT,
	test_point_name VARCHAR,
	test_point_reg_name VARCHAR,
	test_point_area_name VARCHAR,
	test_point_ter_name VARCHAR
)
	RETURNS VOID
LANGUAGE PLPGSQL AS $$
DECLARE
	subject_id INT;
	language_id INT;
	test_status_id INT;
	dpa_level_id INT;
	test_point_id INT;
BEGIN
	INSERT INTO tbl_test_subject (name)
	VALUES (test_subject)
	ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO subject_id;
	
	language_id := func_add_language(test_language);
	
	INSERT INTO tbl_test_status (name)
	VALUES (test_status)
	ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO test_status_id;
	
	INSERT INTO tbl_dpa_level (name)
	VALUES (dpa_level)
	ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
	RETURNING id INTO dpa_level_id;
	
	test_point_id := func_add_test_point(test_point_name, test_point_reg_name, test_point_area_name, test_point_ter_name);
	
	INSERT INTO tbl_test (reg_id, subject, language, status, dpa_level, ball_100, ball_12, ball, adapt_scale, test_point)
	VALUES (
		reg_id,
		subject_id,
		language_id,
		test_status_id,
		dpa_level_id,
		ROUND(REPLACE(ball_100, ',', '.')::float)::smallint,
		ball_12::smallint,
		ball::smallint,
		adapt_scale,
		test_point_id);
END; $$;