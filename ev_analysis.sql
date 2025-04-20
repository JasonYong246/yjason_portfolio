-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Table Creation -- (For data import)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ev_reg (
    vin VARCHAR(10),
    county VARCHAR(20),
    city VARCHAR(30),
    state VARCHAR(2),
    postal_code INT(5),
    year YEAR,
    make VARCHAR(30),
    model VARCHAR(30),
    ev_type VARCHAR(40),
    cafv VARCHAR(70),
    elec_range INT(5),
    msrp INT(6),
    district INT(2),
    dol_id VARCHAR(10),
    location VARCHAR(30),
    utility VARCHAR(120),
    census_tract VARCHAR(12)
);

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Data Cleaning --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
- We will focus exclusively on Washington, hence, other states will be filtered out-
SELECT 
    state, COUNT(*) AS ev_count
FROM
    ev_reg
GROUP BY state
ORDER BY ev_count DESC;


-- Create new table with only WA 
CREATE TABLE ev_reg_wa AS SELECT * FROM ev_reg
WHERE
    state = 'WA';	


-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- General Questions --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1) How many county are there in Washington?
SELECT 
    COUNT(DISTINCT county) AS num_of_county
FROM
    ev_reg_wa;

-- 2) What are the EVs manufacturers?
SELECT 
    make, COUNT(*) AS ev_count
FROM
    ev_reg_wa
GROUP BY make
ORDER BY ev_count DESC;


-- [Regional Adoption Rates of EV]
-- 1) How EV adoption has grown over time?
SELECT 
  year,
  COUNT(*) AS yearly_registrations,
  CONCAT(ROUND(
      100.0 * COUNT(*)
      / SUM(COUNT(*)) OVER (),
      2
    ), '%') AS percent_growth
FROM ev_reg_wa
GROUP BY year
ORDER BY year;

-- 2) Which model years have the highest number of registered EVs?
SELECT 
    year, COUNT(*) AS ev_count
FROM
    ev_reg_wa
GROUP BY year
ORDER BY ev_count DESC
LIMIT 5;

-- 3) Are there specific trends in EV adoption by region?
SELECT 
    county, year, COUNT(*) AS ev_count
FROM
    ev_reg_wa
GROUP BY county , year
ORDER BY ev_count DESC;

-- 4) What is the market share between BEVs and PHEVs by region?
SELECT 
    county,
    SUM(CASE
        WHEN ev_type = 'Battery Electric Vehicle (BEV)' THEN 1
        ELSE 0
    END) AS BEV_Count,
    SUM(CASE
        WHEN ev_type = 'Plug-in Hybrid Electric Vehicle (PHEV)' THEN 1
        ELSE 0
    END) AS PHEV_Count
FROM
    ev_reg_wa
GROUP BY county
ORDER BY BEV_Count DESC;

-- [Market trends and preferences among EV consumers]
-- 1) Which EV brands dominate the market?
SELECT
    make,
    COUNT(*) AS ev_count
FROM
    ev_reg_wa
GROUP BY make
ORDER BY ev_count DESC;

-- 2) How do different manufacturers compare in terms of market share?
SELECT 
    make,
    ROUND((COUNT(*) * 100.0) / (SELECT 
                    COUNT(*)
                FROM
                    ev_reg),
            2) AS market_pct
FROM
    ev_reg_wa
GROUP BY make
ORDER BY market_pct DESC;

-- 3) Are certain brands more popular in specific regions?
SELECT 
    county, make, COUNT(*) AS ev_count
FROM
    ev_reg_wa
GROUP BY county , make
ORDER BY county , ev_count DESC;

-- 4) How does the competition between BEVs and PHEVs vary among manufacturers?
SELECT 
    make,
    SUM(CASE
        WHEN ev_type = 'Battery Electric Vehicle (BEV)' THEN 1
        ELSE 0
    END) AS BEV_Count,
    SUM(CASE
        WHEN ev_type = 'Plug-in Hybrid Electric Vehicle (PHEV)' THEN 1
        ELSE 0
    END) AS PHEV_Count
FROM
    ev_reg_wa
GROUP BY make
ORDER BY BEV_Count DESC;


