BEGIN;
CREATE SCHEMA waste_management;
USE waste_management;

-- CREATE TABLES

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

CREATE TABLE DimTruck
(
    TruckId INTEGER NOT NULL,
    TruckType VARCHAR(20) NOT NULL,
    PRIMARY KEY (TruckId)
);

CREATE TABLE DimStation
(
    StationId INTEGER NOT NULL,
    City CHAR NOT NULL,
    PRIMARY KEY (StationId)
);

CREATE TABLE FactTrips
(
    TripId INTEGER NOT NULL,
    Dateid INTEGER NOT NULL,
    StationId INTEGER NOT NULL,
    TruckId INTEGER NOT NULL,
    WasteCollected FLOAT NOT NULL,
    PRIMARY KEY (TripId),
    FOREIGN KEY (TruckId) REFERENCES DimTruck (TruckId),
    FOREIGN KEY (DateId) REFERENCES DimDate (DateId),
    FOREIGN KEY (StationId) REFERENCES DimStation (StationId)
);

COMMIT;
