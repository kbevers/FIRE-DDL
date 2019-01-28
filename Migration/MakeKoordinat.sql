/* -------------------------------------------------------------------------- */
/* Make KOORDINAT data. Data is stored in many tables in REFGEO (one table
/* per SRID. Tables containing 1D coordinates have the same structure, so do
/* the 2D and time series (TS), more or less.  
/* File: MakeKoordinat.sql   
/* -------------------------------------------------------------------------- */

/*
TO DO:
TID_5D er ikke medtaget. Afventer SDFE
*/

/* 
Due to identical IN_DATE values for a REFNR and due to missing VERSNR entries
we will correct data in order to migrate as many coordinates as possble.
Without a correction a large amount (200.000+) of coordinate instances would not 
be migrated due to unique constraint violations in KOORDINAT.
The correction is a two step process. First we will make sure that no REFNR
has identical IN_DATE values - this is done by adding the VERSNR in seconds 
to the IN_DATE. Second, we will establish a new VERSNR chronology to eliminate 
the missing VERSNR entries.
*/

-- Create a working table to hold corrected coordinate info 
CREATE TABLE TMP_KOORDINAT (
    KOORTABLE VARCHAR(50) NOT NULL,
    REFNR INTEGER NOT NULL,
    JNR_BSIDE NUMBER,
    IN_DATE DATE NOT NULL,
    VERSNR INTEGER NOT NULL,
    BERDATO DATE, 
    E NUMBER, 
    N NUMBER, 
    H NUMBER,
    KOOR_MF INTEGER,
    H_MF INTEGER,
    ARTSKODE INTEGER
);

-- Insert corrected coordinate data with adjusted IN_DATE and new VERSNR. 
-- During this process we will harmonize the different data structures 
-- (1D, 2D, 3D, TS) into one in order to ease querying later on.
INSERT INTO TMP_KOORDINAT (KOORTABLE, REFNR, JNR_BSIDE, IN_DATE, VERSNR, BERDATO, E, N, H, KOOR_MF, H_MF, ARTSKODE)
SELECT s.KOORTABLE, s.REFNR, s.JNR_BSIDE, s.IN_DATE, ROW_NUMBER() OVER (PARTITION BY s.KOORTABLE, s.REFNR ORDER BY s.KOORTABLE, s.REFNR, s.IN_DATE) AS VERSNR, s.BERDATO, s.E, s.N, s.H, s.KOOR_MF, s.H_MF, s.ARTSKODE FROM (
    SELECT 'dvr90' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, HBERDATO AS BERDATO, NULL AS E, NULL AS N, H, NULL AS KOOR_MF, H_MF, ARTSKODE FROM dvr90@refgeo UNION ALL
    SELECT 'fvr09' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, HBERDATO AS BERDATO, NULL AS E, NULL AS N, H, NULL AS KOOR_MF, H_MF, ARTSKODE FROM fvr09@refgeo UNION ALL
    SELECT 'geo_ed50' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM geo_ed50@refgeo UNION ALL
    SELECT 'geo_ed87' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM geo_ed87@refgeo UNION ALL
    SELECT 'geo_nad83g' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM geo_nad83g@refgeo UNION ALL
    SELECT 'gi44' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, HBERDATO AS BERDATO, NULL AS E, NULL AS N, H, NULL AS KOOR_MF, H_MF, ARTSKODE FROM gi44@refgeo UNION ALL
    SELECT 'gm91' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, HBERDATO AS BERDATO, NULL AS E, NULL AS N, H, NULL AS KOOR_MF, H_MF, ARTSKODE FROM gm91@refgeo UNION ALL
    SELECT 'gs' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM gs@refgeo UNION ALL
    SELECT 'gsb' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM gsb@refgeo UNION ALL
    SELECT 'hpot_dvr90' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, HBERDATO AS BERDATO, NULL AS E, NULL AS N, H, NULL AS KOOR_MF, H_MF, ARTSKODE FROM hpot_dvr90@refgeo UNION ALL
    SELECT 'kk' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM kk@refgeo UNION ALL
    SELECT 'kn44' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, HBERDATO AS BERDATO, NULL AS E, NULL AS N, H, NULL AS KOOR_MF, H_MF, ARTSKODE FROM kn44@refgeo UNION ALL
    SELECT 'msl' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, HBERDATO AS BERDATO, NULL AS E, NULL AS N, H, NULL AS KOOR_MF, H_MF, ARTSKODE FROM msl@refgeo UNION ALL
    SELECT 'os' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM os@refgeo UNION ALL
    SELECT 's34j' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM s34j@refgeo UNION ALL
    SELECT 's34s' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM s34s@refgeo UNION ALL
    SELECT 's45b' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM s45b@refgeo UNION ALL
    SELECT 'sb' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM sb@refgeo UNION ALL
    SELECT 'ts_lrl' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, HBERDATO AS BERDATO, NULL AS E, NULL AS N, H, NULL AS KOOR_MF, H_MF, ARTSKODE FROM ts_lrl@refgeo UNION ALL
    SELECT 'tsu32_euref89' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM tsu32_euref89@refgeo UNION ALL
    SELECT 'utm32_ed50' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM utm32_ed50@refgeo UNION ALL
    SELECT 'utm33_ed50' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM utm33_ed50@refgeo UNION ALL
    SELECT 'geo_euref89' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM geo_euref89@refgeo UNION ALL
    SELECT 'geo_gr96' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, NULL AS H, KOOR_MF, NULL AS H_MF, ARTSKODE FROM geo_gr96@refgeo UNION ALL
    SELECT 'ts_dvr90' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, HBERDATO AS BERDATO, NULL AS E, NULL AS N, H, NULL AS KOOR_MF, H_MF, ARTSKODE FROM ts_dvr90@refgeo UNION ALL
    SELECT 'ts_euref89' AS KOORTABLE, REFNR, JNR_BSIDE, IN_DATE + numToDSInterval(VERSNR, 'second' ) AS IN_DATE, CBERDATO AS BERDATO, E, N, H, KOOR_MF, KOTE_MF AS H_MF, ARTSKODE FROM ts_euref89@refgeo
) s
;

CREATE INDEX refnr_versnr ON TMP_KOORDINAT(REFNR, VERSNR);
CREATE INDEX berdato ON TMP_KOORDINAT(BERDATO);
CREATE INDEX koortable ON TMP_KOORDINAT(KOORTABLE);

-- Make lookup table KOOR_BERE_SAGSEVENTID containing every unique 
-- calculation timestamp for all coordinates and a new unique ID.
-- Will be used to create sagsevents and to populate column KOORDINAT.SAGSEVENTID 
-- and BEREGNING.SAGSEVENTID for all coordinates and calculations respectively   
CREATE TABLE KOOR_BERE_SAGSEVENTID (
    BERDATO TIMESTAMP(6) WITH TIME ZONE NOT NULL,
    SAID VARCHAR2(36) NOT NULL
);
INSERT INTO KOOR_BERE_SAGSEVENTID (BERDATO, SAID)
SELECT 
    BERDATO, 
    REGEXP_REPLACE(SYS_GUID(), '(.{8})(.{4})(.{4})(.{4})(.{12})', '\1-\2-\3-\4-\5') AS SAID
FROM TMP_KOORDINAT
GROUP BY BERDATO
;

-- Create sagsevents, one for each calculation date (BERDATO)
INSERT INTO SAGSEVENT (ID, REGISTRERINGFRA, EVENTTYPEID, SAGID)
SELECT SAID, SYSDATE, (SELECT EVENTTYPEID FROM EVENTTYPE WHERE EVENT = 'koordinat_beregnet'), '4f8f29c8-c38f-4c69-ae28-c7737178de1f'
FROM KOOR_BERE_SAGSEVENTID
;  

-- Create sagseventinfo based on REFGEO table JSNR_BER
INSERT INTO SAGSEVENTINFO (REGISTRERINGFRA, BESKRIVELSE, SAGSEVENTID)
SELECT 
    se.REGISTRERINGFRA AS REGISTRERINGFRA, 
    'Beregningsdato: [' || TO_CHAR(jinfo.BERDATO, 'YYYY-MM-DD HH24:MI') || '], initialer: ' || jinfo.INITIALER || ', sted: ' || jinfo.STED || ', tekst: ' || jinfo.TEKST AS BESKRIVELSE, 
    se.ID AS SAGSEVENTID 
FROM JSNR_BER@refgeo jinfo
INNER JOIN (
    SELECT BERDATO FROM JSNR_BER@refgeo WHERE BERDATO IS NOT NULL GROUP BY BERDATO HAVING COUNT(*) = 1 -- exclude journal info when more than one journal exist
) unikber ON jinfo.BERDATO = unikber.BERDATO
INNER JOIN KOOR_BERE_SAGSEVENTID said ON jinfo.BERDATO = said.BERDATO
INNER JOIN SAGSEVENT se ON said.SAID = se.ID
;

-- Create sagseventinfo_rapport if possible for each sag (calculation date)
INSERT INTO SAGSEVENTINFO_HTML (SAGSEVENTINFOOBJECTID, HTML) 
SELECT se.OBJECTID, rap.RAPPORT
FROM KOOR_BERE_SAGSEVENTID said
INNER JOIN SAGSEVENT se ON said.SAID = se.ID
INNER JOIN FIRE_BEREGNING rap ON said.BERDATO = rap.BEREGNINGSDATO
;  

DELETE FROM KOORDINAT;

-- dvr90 + fvr09
INSERT INTO KOORDINAT (REGISTRERINGFRA, REGISTRERINGTIL, SRIDID, SX, SY, SZ, T, TRANSFORMERET, X, Y, Z, SAGSEVENTID, PUNKTID)
SELECT coor.IN_DATE, coor.OUT_DATE, coor.SRIDID, coor.SX, coor.SY, coor.SZ, coor.T, CASE WHEN coor.ARTSKODE = 6 THEN 'true' ELSE 'false' END, coor.X, coor.Y, coor.Z, said.SAID, p.ID
FROM PUNKT p INNER JOIN CONV_PUNKT conv ON p.ID = conv.ID
INNER JOIN 
(
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'EPSG:5799' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'dvr90' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'EPSG:5317' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'fvr09'
) coor ON conv.REFNR = coor.REFNR
INNER JOIN KOOR_BERE_SAGSEVENTID said ON coor.T = SAID.BERDATO
;

-- geo_ed50 + geo_ed87 + geo_nad83 + gi44 + gm91 + gs + gsb 
INSERT INTO KOORDINAT (REGISTRERINGFRA, REGISTRERINGTIL, SRIDID, SX, SY, SZ, T, TRANSFORMERET, X, Y, Z, SAGSEVENTID, PUNKTID)
SELECT coor.IN_DATE, coor.OUT_DATE, coor.SRIDID, coor.SX, coor.SY, coor.SZ, coor.T, CASE WHEN coor.ARTSKODE = 6 THEN 'true' ELSE 'false' END, coor.X, coor.Y, coor.Z, said.SAID, p.ID
FROM PUNKT p INNER JOIN CONV_PUNKT conv ON p.ID = conv.ID
INNER JOIN 
(
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'EPSG:4230' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'geo_ed50' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'EPSG:4231' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'geo_ed87' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'GL:NAD83G' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'geo_nad83' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'DK:GI44' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'gi44' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'DK:GM91' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'gm91' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'DK:GS' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'gs' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'DK:GSB' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'gsb'
) coor ON conv.REFNR = coor.REFNR
INNER JOIN KOOR_BERE_SAGSEVENTID said ON coor.T = SAID.BERDATO
;

-- hpot_dvr90 + kk + kn44 + msl + os  
INSERT INTO KOORDINAT (REGISTRERINGFRA, REGISTRERINGTIL, SRIDID, SX, SY, SZ, T, TRANSFORMERET, X, Y, Z, SAGSEVENTID, PUNKTID)
SELECT coor.IN_DATE, coor.OUT_DATE, coor.SRIDID, coor.SX, coor.SY, coor.SZ, coor.T, CASE WHEN coor.ARTSKODE = 6 THEN 'true' ELSE 'false' END, coor.X, coor.Y, coor.Z, said.SAID, p.ID
FROM PUNKT p INNER JOIN CONV_PUNKT conv ON p.ID = conv.ID
INNER JOIN 
(
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'DK:HPOT_DVR90' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'hpot_dvr90' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'DK:KK' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'kk' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'DK:KN44' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'kn44' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'EPSG:5714' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'msl' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'DK:OS' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'os'
) coor ON conv.REFNR = coor.REFNR
INNER JOIN KOOR_BERE_SAGSEVENTID said ON coor.T = SAID.BERDATO
;

-- s34j   
INSERT INTO KOORDINAT (REGISTRERINGFRA, REGISTRERINGTIL, SRIDID, SX, SY, SZ, T, TRANSFORMERET, X, Y, Z, SAGSEVENTID, PUNKTID)
SELECT coor.IN_DATE, coor.OUT_DATE, coor.SRIDID, coor.SX, coor.SY, coor.SZ, coor.T, CASE WHEN coor.ARTSKODE = 6 THEN 'true' ELSE 'false' END, coor.X, coor.Y, coor.Z, said.SAID, p.ID
FROM PUNKT p INNER JOIN CONV_PUNKT conv ON p.ID = conv.ID
INNER JOIN 
(
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'DK:S34J' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 's34j'
) coor ON conv.REFNR = coor.REFNR
INNER JOIN KOOR_BERE_SAGSEVENTID said ON coor.T = SAID.BERDATO
;

-- s34s + s45b
INSERT INTO KOORDINAT (REGISTRERINGFRA, REGISTRERINGTIL, SRIDID, SX, SY, SZ, T, TRANSFORMERET, X, Y, Z, SAGSEVENTID, PUNKTID)
SELECT coor.IN_DATE, coor.OUT_DATE, coor.SRIDID, coor.SX, coor.SY, coor.SZ, coor.T, CASE WHEN coor.ARTSKODE = 6 THEN 'true' ELSE 'false' END, coor.X, coor.Y, coor.Z, said.SAID, p.ID
FROM PUNKT p INNER JOIN CONV_PUNKT conv ON p.ID = conv.ID
INNER JOIN 
(
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'DK:S34S' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 's34s' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'DK:S45B' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 's45b'
) coor ON conv.REFNR = coor.REFNR
INNER JOIN KOOR_BERE_SAGSEVENTID said ON coor.T = SAID.BERDATO
;

-- sb + ts_lrl + tsu32_euref89 + utm32_ed50 + utm33_ed50
INSERT INTO KOORDINAT (REGISTRERINGFRA, REGISTRERINGTIL, SRIDID, SX, SY, SZ, T, TRANSFORMERET, X, Y, Z, SAGSEVENTID, PUNKTID)
SELECT coor.IN_DATE, coor.OUT_DATE, coor.SRIDID, coor.SX, coor.SY, coor.SZ, coor.T, CASE WHEN coor.ARTSKODE = 6 THEN 'true' ELSE 'false' END, coor.X, coor.Y, coor.Z, said.SAID, p.ID
FROM PUNKT p INNER JOIN CONV_PUNKT conv ON p.ID = conv.ID
INNER JOIN 
(
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'DK:SB' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'sb' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'TS:LRL' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'ts_lrl' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'EPSG:25832' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'tsu32_euref89' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'EPSG:23032' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'utm32_ed50' UNION ALL
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'EPSG:23033' AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE FROM TMP_KOORDINAT cf LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE WHERE cf.KOORTABLE = 'utm33_ed50'
) coor ON conv.REFNR = coor.REFNR
INNER JOIN KOOR_BERE_SAGSEVENTID said ON coor.T = SAID.BERDATO
;

-- Merge 2D and 1D tables to 3D when possible. SZ is missing from the 1D data so we will use sZ = 3 x SX
-- geo_euref89 (2D) will be merged with ellh_euref89 (1D). When matched we use a 3D SRID (EPSG:4937), otherwise 2D (EPSG:4258). 
INSERT INTO KOORDINAT (REGISTRERINGFRA, REGISTRERINGTIL, SRIDID, SX, SY, SZ, T, TRANSFORMERET, X, Y, Z, SAGSEVENTID, PUNKTID)
SELECT coor.IN_DATE, coor.OUT_DATE, coor.SRIDID, coor.SX, coor.SY, coor.SZ, coor.T, CASE WHEN coor.ARTSKODE = 6 THEN 'true' ELSE 'false' END, coor.X, coor.Y, coor.Z, said.SAID, p.ID
FROM PUNKT p INNER JOIN CONV_PUNKT conv ON p.ID = conv.ID
INNER JOIN 
(
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = (CASE WHEN cf.ELLH IS NOT NULL THEN 'EPSG:4937' ELSE 'EPSG:4258' END) AND ROWNUM <=1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.ELLH AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, (3*cf.KOOR_MF) AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE 
    FROM (
        SELECT xy.REFNR, xy.BERDATO, xy.E, xy.N, z.ELLH, xy.KOOR_MF, xy.IN_DATE, xy.VERSNR, xy.ARTSKODE FROM TMP_KOORDINAT xy LEFT JOIN ellh_euref89@refgeo z ON xy.REFNR = z.REFNR AND xy.BERDATO=z.CBERDATO WHERE xy.KOORTABLE = 'geo_euref89'
    ) cf 
    LEFT JOIN (
        SELECT xy.REFNR, xy.BERDATO, xy.E, xy.N, z.ELLH, xy.KOOR_MF, xy.IN_DATE, xy.VERSNR, xy.ARTSKODE FROM TMP_KOORDINAT xy LEFT JOIN ellh_euref89@refgeo z ON xy.REFNR = z.REFNR AND xy.BERDATO=z.CBERDATO WHERE xy.KOORTABLE = 'geo_euref89'
    ) ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR UNION ALL
    
    -- geo_gr96 (2D) will be merged with ellh_gr96 (1D). When matched we use a 3D SRID (EPSG:4909), otherwise 2D (EPSG:4747). 
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = (CASE WHEN cf.ELLH IS NOT NULL THEN 'EPSG:4909' ELSE 'EPSG:4747' END) AND ROWNUM <=1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.ELLH AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, (3*cf.KOOR_MF) AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE 
    FROM (
        SELECT xy.REFNR, xy.BERDATO, xy.E, xy.N, z.ELLH, xy.KOOR_MF, xy.IN_DATE, xy.VERSNR, xy.ARTSKODE FROM TMP_KOORDINAT xy LEFT JOIN ellh_gr96@refgeo z ON xy.REFNR = z.REFNR AND xy.BERDATO=z.CBERDATO WHERE xy.KOORTABLE = 'geo_gr96'
    ) cf 
    LEFT JOIN (
        SELECT xy.REFNR, xy.BERDATO, xy.E, xy.N, z.ELLH, xy.KOOR_MF, xy.IN_DATE, xy.VERSNR, xy.ARTSKODE FROM TMP_KOORDINAT xy LEFT JOIN ellh_gr96@refgeo z ON xy.REFNR = z.REFNR AND xy.BERDATO=z.CBERDATO WHERE xy.KOORTABLE = 'geo_gr96'
    ) ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR
) coor ON conv.REFNR = coor.REFNR
INNER JOIN KOOR_BERE_SAGSEVENTID said ON coor.T = SAID.BERDATO
;

-- ts_dvr90
-- Time series will be treated different as Jessenpunkt will be used as SRID    
INSERT INTO KOORDINAT (REGISTRERINGFRA, REGISTRERINGTIL, SRIDID, SX, SY, SZ, T, TRANSFORMERET, X, Y, Z, SAGSEVENTID, PUNKTID)
SELECT coor.IN_DATE, coor.OUT_DATE, coor.SRIDID, coor.SX, coor.SY, coor.SZ, coor.T, CASE WHEN coor.ARTSKODE = 6 THEN 'true' ELSE 'false' END, coor.X, coor.Y, coor.Z, said.SAID, p.ID
FROM PUNKT p INNER JOIN CONV_PUNKT conv ON p.ID = conv.ID
INNER JOIN 
(
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'TS:' || cf.JNR_BSIDE AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE 
    FROM TMP_KOORDINAT cf 
    LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE 
    WHERE cf.KOORTABLE = 'ts_dvr90'
) coor ON conv.REFNR = coor.REFNR
INNER JOIN KOOR_BERE_SAGSEVENTID said ON coor.T = SAID.BERDATO
;

-- ts_euref89
-- Time series (TS_EUREF89) will be treated different as GNSS/landsnr will be used as SRID    
INSERT INTO KOORDINAT (REGISTRERINGFRA, REGISTRERINGTIL, SRIDID, SX, SY, SZ, T, TRANSFORMERET, X, Y, Z, SAGSEVENTID, PUNKTID)
SELECT coor.IN_DATE, coor.OUT_DATE, coor.SRIDID, coor.SX, coor.SY, coor.SZ, coor.T, CASE WHEN coor.ARTSKODE = 6 THEN 'true' ELSE 'false' END, coor.X, coor.Y, coor.Z, said.SAID, p.ID
FROM PUNKT p INNER JOIN CONV_PUNKT conv ON p.ID = conv.ID
INNER JOIN 
(
    SELECT cf.REFNR, (SELECT SRIDID FROM SRIDTYPE WHERE SRID = 'TS:' || REPLACE(NVL(gnss.IDENT, landsnr.IDENT), ' ', '_') AND ROWNUM <= 1) AS SRIDID, cf.BERDATO AS T, cf.E AS X, cf.N AS Y, cf.H AS Z, cf.KOOR_MF AS SX, cf.KOOR_MF AS SY, cf.H_MF AS SZ, cf.IN_DATE AS IN_DATE, ct.IN_DATE AS OUT_DATE, cf.ARTSKODE 
    FROM TMP_KOORDINAT cf
    LEFT JOIN TMP_KOORDINAT ct ON cf.REFNR = ct.REFNR AND (cf.VERSNR+1) = ct.VERSNR AND cf.KOORTABLE = ct.KOORTABLE
    LEFT JOIN refadm.REFNR_IDENT@refgeo gnss ON cf.REFNR = gnss.REFNR AND gnss.IDENT_TYPE = 'GNSS' 
    LEFT JOIN refadm.REFNR_IDENT@refgeo landsnr ON cf.REFNR = landsnr.REFNR AND landsnr.IDENT_TYPE = 'landsnr' 
    WHERE cf.KOORTABLE = 'ts_euref89'
) coor ON conv.REFNR = coor.REFNR
INNER JOIN KOOR_BERE_SAGSEVENTID said ON coor.T = SAID.BERDATO
;

-- Clean up
DROP TABLE TMP_KOORDINAT PURGE;

COMMIT;
 