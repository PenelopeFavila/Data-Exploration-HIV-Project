SELECT *
FROM VIH

-- Numero de casos registrados
CREATE VIEW  V1 AS 

SELECT COUNT(Sexo) AS Casos
FROM VIH

--Listado de año
CREATE VIEW  V2 AS 

SELECT DISTINCT([Año de diagnostico])
FROM VIH
ORDER BY [Año de diagnostico]

--Numero de casos por año
CREATE VIEW  V3 AS 
SELECT [Año de diagnostico], COUNT(Sexo) Casos_por_Año 
FROM VIH
GROUP BY [Año de diagnostico]
ORDER BY Casos_por_Año DESC

-- Numero de casos por año y genero
CREATE VIEW  V4 AS
SELECT [Año de diagnostico], Sexo, COUNT(Sexo) Casos_por_Año 
FROM VIH
GROUP BY [Año de diagnostico], Sexo
ORDER BY [Año de diagnostico] DESC


--Cantidad de casos en 1996 por grupo de edad
CREATE VIEW  V5 AS
SELECT
    CASE
        WHEN Edad BETWEEN 20 AND 29 THEN '20-29'
        WHEN Edad BETWEEN 30 AND 39 THEN '30-39'
        WHEN Edad BETWEEN 40 AND 49 THEN '40-49'
        WHEN Edad BETWEEN 50 AND 59 THEN '50-59'
        WHEN Edad BETWEEN 60 AND 70 THEN '60-70'
        ELSE 'Other'
    END AS Age_Group,
    COUNT(*) AS Number_of_Cases
FROM VIH
WHERE [Año de diagnostico] = 1996
GROUP BY
    CASE
        WHEN Edad BETWEEN 20 AND 29 THEN '20-29'
        WHEN Edad BETWEEN 30 AND 39 THEN '30-39'
        WHEN Edad BETWEEN 40 AND 49 THEN '40-49'
        WHEN Edad BETWEEN 50 AND 59 THEN '50-59'
        WHEN Edad BETWEEN 60 AND 70 THEN '60-70'
        ELSE 'Other'
    END
ORDER BY MIN(Edad);

--Cantidad de casos por grupo de edad
CREATE VIEW  V14 AS
SELECT
    CASE
        WHEN Edad BETWEEN 20 AND 29 THEN '20-29'
        WHEN Edad BETWEEN 30 AND 39 THEN '30-39'
        WHEN Edad BETWEEN 40 AND 49 THEN '40-49'
        WHEN Edad BETWEEN 50 AND 59 THEN '50-59'
        WHEN Edad BETWEEN 60 AND 70 THEN '60-70'
        ELSE 'Other'
    END AS Age_Group,
    COUNT(*) AS Number_of_Cases
FROM VIH
GROUP BY
    CASE
        WHEN Edad BETWEEN 20 AND 29 THEN '20-29'
        WHEN Edad BETWEEN 30 AND 39 THEN '30-39'
        WHEN Edad BETWEEN 40 AND 49 THEN '40-49'
        WHEN Edad BETWEEN 50 AND 59 THEN '50-59'
        WHEN Edad BETWEEN 60 AND 70 THEN '60-70'
        ELSE 'Other'
    END


--No de casos por grupo de riesgo tuvo mayor incidencia
CREATE VIEW  V6 AS
SELECT [Grupo de riesgo] ,COUNT ([Grupo de riesgo]) AS No_de_casos
FROM VIH
GROUP BY [Grupo de riesgo]
ORDER BY No_de_casos DESC

--Que grupo de riesgo tuvo mayor incidencia
CREATE VIEW  V7 AS
WITH T1 AS(
		SELECT [Grupo de riesgo] ,COUNT ([Grupo de riesgo]) AS No_de_casos
		FROM VIH
		GROUP BY [Grupo de riesgo]
		),
	 T2 AS (SELECT *, RANK() OVER (ORDER BY No_de_casos DESC) AS RNK
	   FROM T1)
SELECT [Grupo de riesgo],No_de_casos
FROM T2
WHERE RNK = 1

--Porcentaje que representan del total de los casos por grupo de riesgo
CREATE VIEW  V8 AS
WITH T1 AS (
    SELECT COUNT(Sexo) AS Casos
    FROM VIH
	),
	T2 AS (
		SELECT [Grupo de riesgo], COUNT([Grupo de riesgo]) AS No_de_casos
		FROM VIH
		GROUP BY [Grupo de riesgo]
	)
SELECT T2.*, (T2.No_de_casos * 100.0 / T1.Casos) AS Porcentaje
FROM T1
CROSS JOIN T2
ORDER BY Porcentaje DESC


--No de casos por provinicia 
CREATE VIEW  V9 AS
SELECT Provincia ,COUNT ([Provincia]) AS No_de_casos
FROM VIH
GROUP BY [Provincia]
ORDER BY No_de_casos DESC

--En que provinicia se detectaron la mayoria de casos
CREATE VIEW  V10 AS
WITH T1 AS(
		SELECT Provincia ,COUNT ([Provincia]) AS No_de_casos
		FROM VIH
		GROUP BY [Provincia]
		),
	 T2 AS (SELECT *, RANK() OVER (ORDER BY No_de_casos DESC) AS RNK
	   FROM T1)
SELECT Provincia,No_de_casos
FROM T2
WHERE RNK = 1

-- Que otras nacionalidades presentaron casos ademas de la española
CREATE VIEW  V11 AS
SELECT DISTINCT ([Pais de origen]), COUNT([Pais de origen]) AS No_de_casos
FROM VIH
WHERE [Pais de origen] <> 'España'
GROUP BY [Pais de origen]
ORDER BY No_de_casos DESC

--Cuantos casos de niños menores de 15 años hubo 
CREATE VIEW  V12 AS
SELECT[Grupo de riesgo], COUNT([Grupo de riesgo])No_de_casos
FROM VIH
WHERE Edad <15 
GROUP BY [Grupo de riesgo]

--Enlista los casos de niños en el año 1996
CREATE VIEW  V13 AS
SELECT [Año de diagnostico], Sexo, Edad, [Edad en meses], Provincia, [Grupo de riesgo]
FROM VIH
WHERE Edad <15 AND [Año de diagnostico] = 1996
ORDER BY Edad


