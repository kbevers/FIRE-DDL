﻿SELECT 
    'PUNKT' AS TABLENAME, NULL AS INFOTYPE, 
    SUM(CASE WHEN REGISTRERINGTIL IS NULL THEN 1 ELSE 0 END) AS CURRENTINSTANSES, 
    SUM(CASE WHEN REGISTRERINGTIL IS NOT NULL THEN 1 ELSE 0 END) AS PREVIOUSINSTANSES, 
    COUNT(REGISTRERINGFRA) AS TOTALINSTANSES
FROM PUNKT
GROUP BY 1
UNION ALL 

SELECT 
    'GEOMETRIOBJEKT' AS TABLENAME, NULL AS INFOTYPE, 
    SUM(CASE WHEN REGISTRERINGTIL IS NULL THEN 1 ELSE 0 END) AS CURRENTINSTANSES, 
    SUM(CASE WHEN REGISTRERINGTIL IS NOT NULL THEN 1 ELSE 0 END) AS PREVIOUSINSTANSES, 
    COUNT(REGISTRERINGFRA) AS TOTALINSTANSES
FROM GEOMETRIOBJEKT 
GROUP BY 1
UNION ALL 

SELECT 
    'KOORDINAT' AS TABLENAME, SRID AS INFOTYPE, 
    SUM(CASE WHEN REGISTRERINGTIL IS NULL THEN 1 ELSE 0 END) AS CURRENTINSTANSES, 
    SUM(CASE WHEN REGISTRERINGTIL IS NOT NULL THEN 1 ELSE 0 END) AS PREVIOUSINSTANSES, 
    COUNT(REGISTRERINGFRA) AS TOTALINSTANSES
FROM KOORDINAT 
GROUP BY SRID
UNION ALL 

SELECT 
    'PUNKTINFO' AS TABLENAME, INFOTYPE AS INFOTYPE, 
    SUM(CASE WHEN REGISTRERINGTIL IS NULL THEN 1 ELSE 0 END) AS CURRENTINSTANSES, 
    SUM(CASE WHEN REGISTRERINGTIL IS NOT NULL THEN 1 ELSE 0 END) AS PREVIOUSINSTANSES, 
    COUNT(REGISTRERINGFRA) AS TOTALINSTANSES
FROM PUNKTINFO 
GROUP BY INFOTYPE
UNION ALL 

SELECT 
    'OBSERVATION' AS TABLENAME, OBSERVATIONSTYPE AS INFOTYPE, 
    SUM(CASE WHEN REGISTRERINGTIL IS NULL THEN 1 ELSE 0 END) AS CURRENTINSTANSES, 
    SUM(CASE WHEN REGISTRERINGTIL IS NOT NULL THEN 1 ELSE 0 END) AS PREVIOUSINSTANSES, 
    COUNT(REGISTRERINGFRA) AS TOTALINSTANSES
FROM OBSERVATION 
GROUP BY OBSERVATIONSTYPE
UNION ALL 

SELECT 
    'BEREGNING' AS TABLENAME, NULL AS INFOTYPE, 
    SUM(CASE WHEN REGISTRERINGTIL IS NULL THEN 1 ELSE 0 END) AS CURRENTINSTANSES, 
    SUM(CASE WHEN REGISTRERINGTIL IS NOT NULL THEN 1 ELSE 0 END) AS PREVIOUSINSTANSES, 
    COUNT(REGISTRERINGFRA) AS TOTALINSTANSES
FROM BEREGNING 
GROUP BY 1
UNION ALL 

SELECT 
    'BEREGNING_KOORDINAT' AS TABLENAME, NULL AS INFOTYPE, 
    COUNT(*), 
    0 AS PREVIOUSINSTANSES, 
    COUNT(*) AS TOTALINSTANSES
FROM BEREGNING_KOORDINAT 
GROUP BY 1
UNION ALL

SELECT 
    'BEREGNING_OBSERVATION' AS TABLENAME, NULL AS INFOTYPE, 
    COUNT(*), 
    0 AS PREVIOUSINSTANSES, 
    COUNT(*) AS TOTALINSTANSES
FROM BEREGNING_OBSERVATION 
GROUP BY 1
UNION ALL

SELECT 
    'SAG' AS TABLENAME, NULL AS INFOTYPE, 
    COUNT(REGISTRERINGFRA), 
    0 AS PREVIOUSINSTANSES, 
    COUNT(REGISTRERINGFRA) AS TOTALINSTANSES
FROM SAG 
GROUP BY 1
UNION ALL 

SELECT 
    'SAGSEVENT' AS TABLENAME, EVENT AS INFOTYPE, 
    COUNT(REGISTRERINGFRA), 
    0 AS PREVIOUSINSTANSES, 
    COUNT(REGISTRERINGFRA) AS TOTALINSTANSES
FROM SAGSEVENT 
GROUP BY EVENT

ORDER BY TABLENAME, INFOTYPE
;
