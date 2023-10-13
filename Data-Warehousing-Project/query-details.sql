# 1. AGGREGATION QUERIES
# Waste Collection by Station ID and Truck Type
SELECT
    ft.stationid,
    dt.TruckType,
    ROUND(SUM(ft.WasteCollected), 2) AS TotalWasteCollected
FROM FactTrips ft
LEFT JOIN DimTruck dt ON ft.TruckId = dt.TruckId
GROUP BY 1,2;

# Rollup aggregation: Waste Collection by Year, City, Station ID
SELECT 
	dd.year, ds.city, ft.stationid,
    ROUND(SUM(ft.WasteCollected),2) AS TotalWasteCollected
FROM FactTrips ft
LEFT JOIN DimDate dd ON ft.dateid = dd.dateid
LEFT JOIN DimStation ds ON ds.stationid = ft.stationid
GROUP BY 1,2,3 WITH ROLLUP;

# -----------------------------------------------------------------
# 2. CREATE VIEW
# View of max waste collection trip by city, station, truck type
CREATE VIEW max_waste_stats AS
SELECT 
	ds.city,
    ft.stationid,
    dt.trucktype,
    MAX(ft.wastecollected) AS MaxWasteCollected
FROM FactTrips ft
JOIN DimTruck dt ON ft.truckid = dt.truckid
JOIN DimStation ds ON ds.stationid =ft.stationid
GROUP BY 1,2,3;

# --------------------------------------------------------------------
# 3. Extract/Transform Data for Tableau Visualization
SELECT 
	ft.TripId, 
	DATE(dd.Date), 
    ds.City, 
    dt.Truckid, 
    dt.TruckType, 
    ft.WasteCollected
FROM FactTrips ft
JOIN DimDate dd ON ft.dateid = dd.dateid
JOIN DimTruck dt ON ft.truckid = dt.truckid
JOIN DimStation ds ON ft.stationid = ds.stationid
ORDER BY 1 ASC;