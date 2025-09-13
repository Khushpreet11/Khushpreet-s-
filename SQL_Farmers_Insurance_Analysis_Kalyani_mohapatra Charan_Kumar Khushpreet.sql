/* -------------------------------------------------------
   STEP 0: Enable local file loading (if required)
-------------------------------------------------------- */
SET GLOBAL local_infile = 1;

-- If the above fails, edit "my.ini" (Windows) or "my.cnf" (Linux/Mac)
-- and add: local_infile=1, then restart MySQL.

/* -------------------------------------------------------
   STEP 1: Create database (schema)
-------------------------------------------------------- */
CREATE SCHEMA IF NOT EXISTS ndap;
USE ndap;

/* -------------------------------------------------------
   STEP 2: Create table structure
-------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS FarmersInsuranceData (
    rowID INT PRIMARY KEY,
    srcYear INT,
    srcStateName VARCHAR(255),
    srcDistrictName VARCHAR(255),
    InsuranceUnits INT,
    TotalFarmersCovered INT,
    ApplicationsLoaneeFarmers INT,
    ApplicationsNonLoaneeFarmers INT,
    InsuredLandArea FLOAT,
    FarmersPremiumAmount FLOAT,
    StatePremiumAmount FLOAT,
    GOVPremiumAmount FLOAT,
    GrossPremiumAmountToBePaid FLOAT,
    SumInsured FLOAT,
    PercentageMaleFarmersCovered FLOAT,
    PercentageFemaleFarmersCovered FLOAT,
    PercentageOthersCovered FLOAT,
    PercentageSCFarmersCovered FLOAT,
    PercentageSTFarmersCovered FLOAT,
    PercentageOBCFarmersCovered FLOAT,
    PercentageGeneralFarmersCovered FLOAT,
    PercentageMarginalFarmers FLOAT,
    PercentageSmallFarmers FLOAT,
    PercentageOtherFarmers FLOAT,
    YearCode INT,
    Year_ VARCHAR(255),
    Country VARCHAR(255),
    StateCode INT,
    DistrictCode INT,
    TotalPopulation INT,
    TotalPopulationUrban INT,
    TotalPopulationRural INT,
    TotalPopulationMale INT,
    TotalPopulationMaleUrban INT,
    TotalPopulationMaleRural INT,
    TotalPopulationFemale INT,
    TotalPopulationFemaleUrban INT,
    TotalPopulationFemaleRural INT,
    NumberOfHouseholds INT,
    NumberOfHouseholdsUrban INT,
    NumberOfHouseholdsRural INT,
    LandAreaUrban FLOAT,
    LandAreaRural FLOAT,
    LandArea FLOAT
);

/* -------------------------------------------------------
   STEP 3: Load data from CSV
-------------------------------------------------------- */
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;






LOAD DATA LOCAL INFILE 'D:\new downloads\856e73f7-660a-4fa1-8345-c58062ab7710-SQL-Assg-PMFBY-Dataset-Starter.zip\SQL_Assg_PMFBY_Dataset_Starter\Data_PMFBY'
INTO TABLE FarmersInsuranceData
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

/* -------------------------------------------------------
   SECTION 1 – SELECT QUERIES (Q1–Q2)
-------------------------------------------------------- */
-- Q1
SELECT DISTINCT srcStateName FROM FarmersInsuranceData;

-- Q2
SELECT srcStateName,
       SUM(TotalFarmersCovered) AS TotalFarmersCovered,
       SUM(SumInsured) AS TotalSumInsured
FROM FarmersInsuranceData
GROUP BY srcStateName
ORDER BY TotalFarmersCovered DESC;

/* -------------------------------------------------------
   SECTION 2 – FILTERING DATA (Q3–Q6)
-------------------------------------------------------- */
-- Q3
SELECT * FROM FarmersInsuranceData WHERE srcYear = 2020;

-- Q4
SELECT * FROM FarmersInsuranceData
WHERE TotalPopulationRural > 1000000
  AND srcStateName = 'HIMACHAL PRADESH';

-- Q5
SELECT srcStateName, srcDistrictName,
       SUM(FarmersPremiumAmount) AS TotalFarmersPremium
FROM FarmersInsuranceData
WHERE srcYear = 2018
GROUP BY srcStateName, srcDistrictName
ORDER BY TotalFarmersPremium ASC;

-- Q6
SELECT srcStateName,
       SUM(TotalFarmersCovered) AS TotalFarmersCovered,
       SUM(GrossPremiumAmountToBePaid) AS TotalGrossPremium
FROM FarmersInsuranceData
WHERE InsuredLandArea > 5.0 AND srcYear = 2018
GROUP BY srcStateName;

/* -------------------------------------------------------
   SECTION 3 – AGGREGATION (Q7–Q9)
-------------------------------------------------------- */
-- Q7
SELECT srcYear, AVG(InsuredLandArea) AS AvgInsuredLandArea
FROM FarmersInsuranceData
GROUP BY srcYear;

-- Q8
SELECT srcDistrictName,
       SUM(TotalFarmersCovered) AS TotalFarmersCovered
FROM FarmersInsuranceData
WHERE InsuranceUnits > 0
GROUP BY srcDistrictName;

-- Q9
SELECT srcStateName,
       SUM(FarmersPremiumAmount) AS TotalFarmersPremium,
       SUM(StatePremiumAmount) AS TotalStatePremium,
       SUM(GOVPremiumAmount) AS TotalGovPremium,
       SUM(TotalFarmersCovered) AS TotalFarmersCovered
FROM FarmersInsuranceData
WHERE SumInsured > 500000
GROUP BY srcStateName;

/* -------------------------------------------------------
   SECTION 4 – SORTING DATA (Q10–Q12)
-------------------------------------------------------- */
-- Q10
SELECT srcDistrictName, TotalPopulation
FROM FarmersInsuranceData
WHERE srcYear = 2020
ORDER BY TotalPopulation DESC
LIMIT 5;

-- Q11
SELECT srcStateName, srcDistrictName, SumInsured, FarmersPremiumAmount
FROM FarmersInsuranceData
WHERE FarmersPremiumAmount > 0
ORDER BY SumInsured ASC, FarmersPremiumAmount ASC
LIMIT 10;

-- Q12
SELECT srcYear, srcStateName,
       SUM(TotalFarmersCovered) / SUM(TotalPopulation) AS FarmersToPopulationRatio
FROM FarmersInsuranceData
GROUP BY srcYear, srcStateName
ORDER BY FarmersToPopulationRatio DESC
LIMIT 3;

/* -------------------------------------------------------
   SECTION 5 – STRING FUNCTIONS (Q13–Q15)
-------------------------------------------------------- */
-- Q13
SELECT DISTINCT srcStateName, LEFT(srcStateName, 3) AS StateShortName
FROM FarmersInsuranceData;

-- Q14
SELECT DISTINCT srcDistrictName
FROM FarmersInsuranceData
WHERE srcDistrictName LIKE 'B%';

-- Q15
SELECT srcStateName, srcDistrictName
FROM FarmersInsuranceData
WHERE srcDistrictName LIKE '%pur';

/* -------------------------------------------------------
   SECTION 6 – JOINS (Q16–Q18)
-------------------------------------------------------- */
-- Q16
SELECT f.srcStateName, f.srcDistrictName,
       SUM(f.FarmersPremiumAmount) AS TotalFarmersPremium
FROM FarmersInsuranceData f
INNER JOIN FarmersInsuranceData d
  ON f.srcDistrictName = d.srcDistrictName
 AND f.srcStateName = d.srcStateName
WHERE f.InsuranceUnits > 10
GROUP BY f.srcStateName, f.srcDistrictName;

-- Q17
SELECT srcStateName, srcDistrictName, srcYear, TotalPopulation,
       MAX(FarmersPremiumAmount) AS MaxPremium
FROM FarmersInsuranceData
GROUP BY srcStateName, srcDistrictName, srcYear, TotalPopulation
HAVING MAX(FarmersPremiumAmount) > 200000000;

-- Q18
SELECT f.srcStateName, f.srcDistrictName,
       SUM(f.FarmersPremiumAmount) AS TotalPremium,
       AVG(f.TotalPopulation) AS AvgPopulation
FROM FarmersInsuranceData f
LEFT JOIN FarmersInsuranceData p
  ON f.srcDistrictName = p.srcDistrictName
GROUP BY f.srcStateName, f.srcDistrictName
HAVING SUM(f.FarmersPremiumAmount) > 1000000000
ORDER BY TotalPremium DESC;

/* -------------------------------------------------------
   SECTION 7 – SUBQUERIES (Q19–Q21)
-------------------------------------------------------- */
-- Q19
SELECT srcDistrictName
FROM FarmersInsuranceData
WHERE TotalFarmersCovered > (SELECT AVG(TotalFarmersCovered)
                             FROM FarmersInsuranceData);

-- Q20
SELECT DISTINCT srcStateName
FROM FarmersInsuranceData
WHERE SumInsured > (
    SELECT MAX(SumInsured)
    FROM FarmersInsuranceData
    WHERE FarmersPremiumAmount = (SELECT MAX(FarmersPremiumAmount)
                                  FROM FarmersInsuranceData)
);

-- Q21
SELECT srcDistrictName
FROM FarmersInsuranceData
WHERE FarmersPremiumAmount > (
    SELECT AVG(FarmersPremiumAmount)
    FROM FarmersInsuranceData
    WHERE srcStateName = (
        SELECT srcStateName
        FROM FarmersInsuranceData
        GROUP BY srcStateName
        ORDER BY SUM(TotalPopulation) DESC
        LIMIT 1
    )
);

/* -------------------------------------------------------
   SECTION 8 – WINDOW FUNCTIONS (Q22–Q24)
-------------------------------------------------------- */
-- Q22
SELECT rowID, srcStateName, srcDistrictName, TotalFarmersCovered,
       ROW_NUMBER() OVER (ORDER BY TotalFarmersCovered DESC) AS RowNum
FROM FarmersInsuranceData;

-- Q23
SELECT srcStateName, srcDistrictName, SumInsured,
       RANK() OVER (PARTITION BY srcStateName ORDER BY SumInsured DESC) AS RankInState
FROM FarmersInsuranceData;

-- Q24
SELECT srcStateName, srcDistrictName, srcYear, FarmersPremiumAmount,
       SUM(FarmersPremiumAmount) OVER (PARTITION BY srcStateName, srcDistrictName ORDER BY srcYear) AS CumulativePremium
FROM FarmersInsuranceData;

/* -------------------------------------------------------
   SECTION 9 – DATA INTEGRITY (Q25–Q26)
-------------------------------------------------------- */
-- Q25
CREATE TABLE states (
    StateCode INT PRIMARY KEY,
    StateName VARCHAR(255)
);

CREATE TABLE districts (
    DistrictCode INT PRIMARY KEY,
    DistrictName VARCHAR(255),
    StateCode INT
);

-- Q26
ALTER TABLE districts
ADD CONSTRAINT fk_state FOREIGN KEY (StateCode) REFERENCES states(StateCode);

/* -------------------------------------------------------
   SECTION 10 – UPDATE & DELETE (Q27–Q29)
-------------------------------------------------------- */
-- Q27
UPDATE FarmersInsuranceData
SET FarmersPremiumAmount = 500.0
WHERE rowID = 1;

-- Q28
UPDATE FarmersInsuranceData
SET srcYear = 2021
WHERE srcStateName = 'HIMACHAL PRADESH';

SET SQL_SAFE_UPDATES = 0;

-- Q29
DELETE FROM FarmersInsuranceData
WHERE rowID IN (
    SELECT rowID
    FROM (
        SELECT rowID
        FROM FarmersInsuranceData
        WHERE TotalFarmersCovered < 10000 AND srcYear = 2020
    ) AS temp
);
