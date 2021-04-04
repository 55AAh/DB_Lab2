import psycopg2


class Db:
    def __init__(self, auth):
        print("Connecting to db... ", flush=True, end='')
        self.conn = psycopg2.connect(**auth)
        self.curr = self.conn.cursor()
        self.mtc = "outid VARCHAR(90),year SMALLINT,birth VARCHAR(38),sextypename VARCHAR(39),regname VARCHAR(26),areaname VARCHAR(46),tername VARCHAR(153),regtypename VARCHAR(101),eoname VARCHAR(255),eotypename VARCHAR(143),eoregname VARCHAR(158),eoareaname VARCHAR(208),eotername VARCHAR(53),eoparent VARCHAR(205),ukrtest VARCHAR(47),ukrteststatus VARCHAR(153),ukrball100 VARCHAR(141),ukrball12 VARCHAR(143),ukrptname VARCHAR(245),ukrptregname VARCHAR(151),ukrptareaname VARCHAR(177),ukrpttername VARCHAR(47),histtest VARCHAR(118),histlang VARCHAR(89),histteststatus VARCHAR(153),histball100 VARCHAR(208),histball12 VARCHAR(143),histptname VARCHAR(245),histptregname VARCHAR(47),histptareaname VARCHAR(155),histpttername VARCHAR(168),mathtest VARCHAR(47),mathlang VARCHAR(143),mathteststatus VARCHAR(212),mathball100 VARCHAR(166),mathball12 VARCHAR(143),mathptname VARCHAR(243),mathptregname VARCHAR(145),mathptareaname VARCHAR(54),mathpttername VARCHAR(36),phystest VARCHAR(208),physlang VARCHAR(47),physteststatus VARCHAR(212),physball100 VARCHAR(143),physptname VARCHAR(241),physptregname VARCHAR(143),physptareaname VARCHAR(49),physpttername VARCHAR(107),chemtest VARCHAR(165),chemlang VARCHAR(143),chemteststatus VARCHAR(47),chemball100 VARCHAR(212),chemptname VARCHAR(241),chemptregname VARCHAR(143),chemptareaname VARCHAR(168),chempttername VARCHAR(36),biotest VARCHAR(143),biolang VARCHAR(25),bioteststatus VARCHAR(208),bioball100 VARCHAR(47),bioptname VARCHAR(245),bioptregname VARCHAR(153),bioptareaname VARCHAR(54),biopttername VARCHAR(168),geotest VARCHAR(26),geolang VARCHAR(107),geoteststatus VARCHAR(47),geoball100 VARCHAR(34),geoptname VARCHAR(241),geoptregname VARCHAR(25),geoptareaname VARCHAR(88),geopttername VARCHAR(35),engtest VARCHAR(118),engteststatus VARCHAR(47),engball100 VARCHAR(39),engptname VARCHAR(245),engptregname VARCHAR(25),engptareaname VARCHAR(168),engpttername VARCHAR(35),frtest VARCHAR(41),frteststatus VARCHAR(47),frball100 VARCHAR(30),frptname VARCHAR(168),frptregname VARCHAR(25),frptareaname VARCHAR(49),frpttername VARCHAR(30),deutest VARCHAR(108),deuteststatus VARCHAR(47),deuball100 VARCHAR(34),deuptname VARCHAR(188),deuptregname VARCHAR(25),deuptareaname VARCHAR(168),deupttername VARCHAR(30),sptest VARCHAR(32),spteststatus VARCHAR(47),spball100 VARCHAR(5),spptname VARCHAR(168),spptregname VARCHAR(25),spptareaname VARCHAR(49),sppttername VARCHAR(30),rustest VARCHAR(14),rusteststatus VARCHAR(47),rusball100 VARCHAR(5),rusptname VARCHAR(190),rusptregname VARCHAR(25),rusptareaname VARCHAR(49),ruspttername VARCHAR(30),stid UUID,tertypename VARCHAR(5),classprofilename VARCHAR(36),classlangname VARCHAR(10),physball12 VARCHAR(4),chemball12 VARCHAR(4),bioball12 VARCHAR(4),geoball12 VARCHAR(4),engball12 VARCHAR(4),fratest VARCHAR(15),frateststatus VARCHAR(16),fraball100 VARCHAR(5),fraball12 VARCHAR(4),fraptname VARCHAR(236),fraptregname VARCHAR(25),fraptareaname VARCHAR(41),frapttername VARCHAR(29),deuball12 VARCHAR(4),spatest VARCHAR(14),spateststatus VARCHAR(16),spaball100 VARCHAR(5),spaball12 VARCHAR(4),spaptname VARCHAR(236),spaptregname VARCHAR(25),spaptareaname VARCHAR(44),spapttername VARCHAR(30),rusball12 VARCHAR(4),ukrball VARCHAR(4),histball VARCHAR(4),mathball VARCHAR(4),physball VARCHAR(4),chemball VARCHAR(4),bioball VARCHAR(4),geoball VARCHAR(4),engdpalevel VARCHAR(21),engball VARCHAR(4),fradpalevel VARCHAR(21),fraball VARCHAR(4),deudpalevel VARCHAR(21),deuball VARCHAR(4),spadpalevel VARCHAR(21),spaball VARCHAR(4),ukradaptscale SMALLINT"
        print("done", flush=True)
    
    def get_base_columns(self):
        c = [(cn, ct) for cn, ct in [k.split(' ') for k in self.mtc.split(',')] if cn != 'outid' and cn != 'stid']
        return [((cn, "VARCHAR", int(ct[8:-1])) if ct[:7].upper() == "VARCHAR" else (cn, ct, None)) for cn, ct in c]
    
    def generate_v_1_0_sql(self, fw):
        print("Generating migration V1.0__checking_main_table... ", flush=True, end='')        
        s = []
        s.append(f'CREATE TABLE IF NOT EXISTS "tblZnoRecords" ({self.mtc})')
        r = '\n'.join(s)
        fw.write_sql_migration(r, "1.0", "checking_main_table")
        print("done", flush=True)
    
    def generate_v_1_1_sql(self, fw):
        print("Generating migration V1.1__creating_entity_tables... ", flush=True, end='')
        s = []
        for column_name, data_type, length in self.get_base_columns():
            dts = data_type.upper()
            if data_type == "character varying":
                dts = f"VARCHAR({length})"
            s.append(f'CREATE TABLE "tbl_{column_name}" ('
                     f'id SERIAL PRIMARY KEY, '
                     f'val {dts});')
        r = '\n'.join(s)
        fw.write_sql_migration(r, "1.1", "creating_entity_tables")
        print("done", flush=True)

    def generate_v_1_2_sql(self, fw):
        print("Generating migration V1.2__filling_entity_tables... ", flush=True, end='')
        s = []
        for column_name, _, _, in self.get_base_columns():
            s.append(f'INSERT INTO "tbl_{column_name}" (val) '
                     f'SELECT DISTINCT {column_name} FROM "tblZnoRecords";')
        r = '\n'.join(s)
        fw.write_sql_migration(r, "1.2", "filling_entity_tables")
        print("done", flush=True)
    
    def generate_v_1_3_sql(self, fw):
        print("Generating migration V1.3__creating_new_main_table... ", flush=True, end='')
        s = ["CREATE TABLE tbl_records ("]
        s.append("\tout_id UUID, PRIMARY KEY (out_id),")
        s.append("\tst_id UUID,")
        for column_name, _, _, in self.get_base_columns():
            s.append(f'\t{column_name}_id INT REFERENCES "tbl_{column_name}" (id),')
        s[-1] = s[-1][:-1]
        s.append(");")
        r = '\n'.join(s)
        fw.write_sql_migration(r, "1.3", "creating_new_main_table")
        print("done", flush=True)
    
    def generate_v_1_4_sql(self, fw):
        print("Generating migration V1.4__filling_new_main_table... ", flush=True, end='')
        s = ["DO $$"]
        s.append("DECLARE")
        sd, sfv, sf, ssiv, sid, siv = [], [], [], [], [], []
        sd.append("\tout_id UUID; st_id UUID;")
        sf.append("\t\toutid, stid,")
        for column_name, data_type, length in self.get_base_columns():
            dts = data_type.upper()
            if data_type == "character varying":
                dts = f"VARCHAR({length})"
            sd.append(f"\t{column_name}_val {dts}; {column_name}_id INT;")
            sfv.append(f"\t\t{column_name}_val,")
            sf.append(f"\t\t{column_name},")
            ssiv.append(f'\t\tSELECT id FROM "tbl_{column_name}" WHERE val = {column_name}_val INTO {column_name}_id;')
            sid.append(f'\t\t\t{column_name}_id,')
        if len(sfv) > 0:
            sfv[-1] = sfv[-1][:-1]
            sf[-1] = sf[-1][:-1]
            sid[-1] = sid[-1][:-1]
        s.extend(sd)
        s.append("BEGIN")
        s.append("\tFOR")
        s.append("\t\tout_id, st_id,")
        s.extend(sfv)
        s.append("\tIN SELECT")
        s.extend(sf)
        s.append('\tFROM "tblZnoRecords" WHERE NOT EXISTS (SELECT tbl_records.out_id FROM tbl_records WHERE tbl_records.out_id=outid::uuid) LOOP')
        s.extend(ssiv)
        s.append("\t\tINSERT INTO tbl_records (")
        s.append("\t\t\tout_id, st_id,")
        s.extend(sid)
        s.append("\t\t) VALUES (")
        s.append("\t\t\tout_id, st_id,")
        s.extend(sid)
        s.append("\t\t);")
        s.append("\tEND LOOP;")
        s.append("END; $$")
        r = '\n'.join(s)
        fw.write_sql_migration(r, "1.4", "filling_new_main_table")
        print("done", flush=True)
    
    def generate_v_1_5_sql(self, fw):
        print("Generating migration V1.5__denormalizing_ball... ", flush=True, end='')
        s = []
        std100 = [k+'100' for k in "bioball,chemball,deuball,engball,fraball,frball,geoball,histball,mathball,physball,spaball,ukrball".split(',')]
        std12 = [k+'12' for k in "bioball,chemball,deuball,engball,fraball,geoball,histball,mathball,physball,rusball,spaball,ukrball".split(',')]
        std = "bioball,chemball,deuball,engball,fraball,geoball,histball,mathball,physball,spaball,ukrball".split(',')
        for st in std100:
            pass
        print(u)
        r = '\n'.join(s)
        fw.write_sql_migration(r, "1.5", "denormalizing_ball")
        print("done", flush=True)
    
    def generate_v_1_6_sql(self, fw):
        print("Generating migration V1.6__parsing_nulls... ", flush=True, end='')
        s = []
        for column_name, _, _ in self.get_base_columns():
            s.append(f'UPDATE "tbl_{column_name}" SET val = NULLIF(val, \'null\');')
        r = '\n'.join(s)
        fw.write_sql_migration(r, "1.6", "parsing_nulls")
        print("done", flush=True)
        
