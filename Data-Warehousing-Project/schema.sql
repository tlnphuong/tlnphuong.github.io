BEGIN;
CREATE SCHEMA waste_management;
USE waste_management;
-- DROP TABLE IF EXISTS "MyFactTrips";
CREATE TABLE FactTrips
(
    TripId INTEGER NOT NULL,
    Dateid INTEGER NOT NULL,
    StationId INTEGER NOT NULL,
    TruckId INTEGER NOT NULL,
    WasteCollected FLOAT NOT NULL,
    PRIMARY KEY (TripId)
);

-- DROP TABLE IF EXISTS DimDate;
CREATE TABLE DimDate
(
    dateid INTEGER NOT NULL,
    date TIMESTAMP NOT NULL,
    Year INTEGER NOT NULL,
    Quarter INTEGER NOT NULL,
    QuarterName CHAR(2) NOT NULL,
    Month INTEGER NOT NULL,
    MonthName VARCHAR(20) NOT NULL,
    Day INTEGER NOT NULL,
    Weekday INTEGER NOT NULL,
    WeekdayName VARCHAR(20) NOT NULL,
    PRIMARY KEY (DateId)
);
-- DROP TABLE IF EXISTS DimWaste;
CREATE TABLE DimWaste
(
    WasteId INTEGER NOT NULL,
    WasteType VARCHAR(20) NOT NULL,
    PRIMARY KEY (WasteId)
);

-- DROP TABLE IF EXISTS DimZone;
CREATE TABLE DimZone
(
    ZoneId INTEGER NOT NULL,
    CollectionZone VARCHAR NOT NULL,
    PRIMARY KEY (ZoneId)
);
-- DROP TABLE IF EXISTS DimTruck;
CREATE TABLE DimTruck
(
    TruckId INTEGER NOT NULL,
    TruckType VARCHAR (20) NOT NULL,
    PRIMARY KEY (TruckId)
);
-- DROP TABLE IF EXISTS DimStation;
CREATE TABLE DimStation
(
    StationId INTEGER NOT NULL,
    City CHAR NOT NULL,
    PRIMARY KEY (StationId)
);
# Run the following queries after having created the above tables
ALTER TABLE FactTrips
    ADD FOREIGN KEY (TruckId)
    REFERENCES DimTruck (TruckId)
    NOT VALID;
ALTER TABLE FactTrips
    ADD FOREIGN KEY (DateId)
    REFERENCES DimDate (DateId)
    NOT VALID;

ALTER TABLE FactTrips
    ADD FOREIGN KEY (StationId)
    REFERENCES DimStation (StationId)
    NOT VALID;
COMMIT;

