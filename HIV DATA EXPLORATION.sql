SELECT *
FROM VIH

-- Numero de casos registrados
CREATE VIEW  V1 AS 

SELECT COUNT(Sexo) AS Casos
FROM VIH

--Listado de a�o
CREATE VIEW  V2 AS 

SELECT DISTINCT([A�o de diagnostico])
FROM VIH
ORDER BY [A�o de diagnostico]

--Numero de casos por a�o
CREATE VIEW  V3 AS 
SELECT [A�o de diagnostico], COUNT(Sexo) Casos_por_A�o 
FROM VIH
GROUP BY [A�o de diagnostico]
ORDER BY Casos_por_A�o DESC

-- Numero de casos por a�o y genero
CREATE VIEW  V4 AS
SELECT [A�o de diagnostico], Sexo, COUNT(Sexo) Casos_por_A�o 
FROM VIH
GROUP BY [A�o de diagnostico], Sexo
ORDER BY [A�o de diagnostico] DESC


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
WHERE [A�o de diagnostico] = 1996
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

-- Que otras nacionalidades presentaron casos ademas de la espa�ola
CREATE VIEW  V11 AS
SELECT DISTINCT ([Pais de origen]), COUNT([Pais de origen]) AS No_de_casos
FROM VIH
WHERE [Pais de origen] <> 'Espa�a'
GROUP BY [Pais de origen]
ORDER BY No_de_casos DESC

--Cuantos casos de ni�os menores de 15 a�os hubo 
CREATE VIEW  V12 AS
SELECT[Grupo de riesgo], COUNT([Grupo de riesgo])No_de_casos
FROM VIH
WHERE Edad <15 
GROUP BY [Grupo de riesgo]

--Enlista los casos de ni�os en el a�o 1996
CREATE VIEW  V13 AS
SELECT [A�o de diagnostico], Sexo, Edad, [Edad en meses], Provincia, [Grupo de riesgo]
FROM VIH
WHERE Edad <15 AND [A�o de diagnostico] = 1996
ORDER BY Edad


