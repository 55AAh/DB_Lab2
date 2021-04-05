DO $$
DECLARE
	remaining BOOLEAN := TRUE;
	r "tblZnoRecords" % ROWTYPE;
	reg_id UUID;
	cnt INT;
	cnt_a INT;
BEGIN
	SELECT COUNT(*) FROM tbl_reg INTO cnt;
	SELECT COUNT(*) FROM "tblZnoRecords" INTO cnt_a;
	WHILE remaining LOOP
		remaining := FALSE;
		FOR r IN SELECT * FROM "tblZnoRecords" WHERE NOT EXISTS (SELECT id FROM tbl_reg WHERE id = outid::uuid) LIMIT 1000 LOOP
			reg_id := func_add_reg(r.outid::uuid, r.year, r.birth::smallint, r.sextypename, r.regname, r.areaname, r.tertypename, r.tername, r.regtypename, r.classprofilename, r.classlangname, r.eoname, r.eotypename, r.eoregname, r.eoareaname, r.eotername, r.eoparent, r.stid);
			IF r.ukrtest != NULL THEN PERFORM func_add_test(reg_id, r.ukrtest, NULL, r.ukrteststatus, NULL, r.ukrball100, r.ukrball12, r.ukrball, r.ukradaptscale::smallint, r.ukrptname, r.ukrptregname, r.ukrptareaname, r.ukrpttername); END IF;
			IF r.histtest != NULL THEN PERFORM func_add_test(reg_id, r.histtest, r.histlang, r.histteststatus, NULL, r.histball100, r.histball12, r.histball, NULL, r.histptname, r.histptregname, r.histptareaname, r.histpttername); END IF;
			IF r.mathtest != NULL THEN PERFORM func_add_test(reg_id, r.mathtest, r.mathlang, r.mathteststatus, NULL, r.mathball100, r.mathball12, r.mathball, NULL, r.mathptname, r.mathptregname, r.mathptareaname, r.mathpttername); END IF;
			IF r.phystest != NULL THEN PERFORM func_add_test(reg_id, r.phystest, r.physlang, r.physteststatus, NULL, r.physball100, r.physball12, r.physball, NULL, r.physptname, r.physptregname, r.physptareaname, r.physpttername); END IF;
			IF r.chemtest != NULL THEN PERFORM func_add_test(reg_id, r.chemtest, r.chemlang, r.chemteststatus, NULL, r.chemball100, r.chemball12, r.chemball, NULL, r.chemptname, r.chemptregname, r.chemptareaname, r.chempttername); END IF;
			IF r.biotest != NULL THEN PERFORM func_add_test(reg_id, r.biotest, r.biolang, r.bioteststatus, NULL, r.bioball100, r.bioball12, r.bioball, NULL, r.bioptname, r.bioptregname, r.bioptareaname, r.biopttername); END IF;
			IF r.geotest != NULL THEN PERFORM func_add_test(reg_id, r.geotest, r.geolang, r.geoteststatus, NULL, r.geoball100, r.geoball12, r.geoball, NULL, r.geoptname, r.geoptregname, r.geoptareaname, r.geopttername); END IF;
			IF r.engtest != NULL THEN PERFORM func_add_test(reg_id, r.engtest, NULL, r.engteststatus, r.engdpalevel, r.engball100, r.engball12, r.engball, NULL, r.engptname, r.engptregname, r.engptareaname, r.engpttername); END IF;
			IF r.frtest != NULL OR r.fratest!= NULL THEN PERFORM func_add_test(reg_id, COALESCE(r.frtest, r.fratest), NULL, COALESCE(r.frteststatus, r.frateststatus), r.fradpalevel, COALESCE(r.frball100, r.fraball100), r.fraball12, r.fraball, NULL, COALESCE(r.frptname, r.fraptname), COALESCE(r.frptregname, r.fraptregname), COALESCE(r.frptareaname, r.fraptareaname), COALESCE(r.frpttername, r.frapttername)); END IF;
			IF r.deutest != NULL THEN PERFORM func_add_test(reg_id, r.deutest, NULL, r.deuteststatus, r.deudpalevel, r.deuball100, r.deuball12, r.deuball, NULL, r.deuptname, r.deuptregname, r.deuptareaname, r.deupttername); END IF;
			IF r.sptest != NULL OR r.spatest != NULL THEN PERFORM func_add_test(reg_id, COALESCE(r.sptest, r.spatest), NULL, COALESCE(r.spteststatus, r.spateststatus), r.spadpalevel, COALESCE(r.spball100, r.spaball100), r.spaball12, r.spaball, NULL, COALESCE(r.spptname, r.spaptname), COALESCE(r.spptregname, r.spaptregname), COALESCE(r.spptareaname, r.spaptareaname), COALESCE(r.sppttername, r.spapttername)); END IF;
			IF r.rustest != NULL THEN PERFORM func_add_test(reg_id, r.rustest, NULL, r.rusteststatus, NULL, r.rusball100, r.rusball12, NULL, NULL, r.rusptname, r.rusptregname, r.rusptareaname, r.ruspttername); END IF;
			remaining := TRUE;
			cnt := cnt + 1;
		END LOOP;
		RAISE NOTICE '%/%', cnt, cnt_a;
	END LOOP;
END $$;