# Delivery Volume/Value by Day of Week
SELECT 
	dayname(DELIV_CREATED_AT) AS DeliveryDate,
	COUNT(DISTINCT DELIVERY_UUID) AS UniqueDeliveryCount,
	SUM(ITEM_PRICE) AS DeliveryValue
FROM DeliveryData
GROUP BY 1;

# Delivery Volume/Value by time of day
SELECT 
	CASE 
	WHEN HOUR(DELIV_CREATED_AT) BETWEEN 6 AND 11 THEN '6-12'
	WHEN HOUR(DELIV_CREATED_AT) BETWEEN 12 AND 17 THEN '12-18'
	WHEN HOUR(DELIV_CREATED_AT) BETWEEN 18 AND 23 THEN '18-24'
	ELSE '0-6'
    	END AS TimeOfDay,
    	COUNT(DISTINCT DELIVERY_UUID) AS UniqueDeliveryCount,
	SUM(ITEM_PRICE) AS DeliveryValue
FROM DeliveryData
GROUP BY 1;

# Percentage of Missing/Incorrect Order Delivery: 1.63%
SELECT 
	COUNT(DISTINCT CASE WHEN DELIV_MISSING_INCORRECT_REPORT IS TRUE THEN DELIVERY_UUID ELSE NULL END)/COUNT(DISTINCT DELIVERY_UUID) 
	AS PercentOfMissingIncorrectOrder
FROM DeliveryData;

# Percentage of Late Order Delivery: 4.68%
SELECT 
	COUNT(DISTINCT CASE WHEN DELIV_IS_20_MIN_LATE IS TRUE THEN DELIVERY_UUID ELSE NULL END)/COUNT(DISTINCT DELIVERY_UUID)
    	AS PercentOfLateOrder
FROM DeliveryData;

# Operational Key Metrics By Stores: Percent of Item Found, Item Missing, Item Substitued When Missing
SELECT 
	DELIV_STORE_NAME,
    	AVG(WAS_FOUND) AS ItemFoundRate,
	AVG(WAS_MISSING) AS ItemMissingRate,
	SUM(WAS_SUBBED)/SUM(WAS_MISSING) AS SubstitutionRate
FROM DeliveryData
GROUP BY 1;

# If substituted, did the substitute item category match the original item category?
SELECT 
	DELIV_STORE_NAME,
	AVG(CASE WHEN SUBSTITUTE_ITEM_CATEGORY LIKE ITEM_CATEGORY THEN 1 ELSE 0 END) AS SubstitutionMatchRate
FROM DeliveryData
WHERE WAS_MISSING=1 AND WAS_SUBBED=1
GROUP BY 1;

# Sales loss when stores could not substitute missing items
SELECT
	SUM(ITEM_PRICE) AS Loss
FROM DeliveryData
WHERE WAS_MISSING = 1 AND WAS_SUBBED = 0;

# Sales by product category
SELECT 
	ITEM_CATEGORY, 
	SUM(ITEM_PRICE) AS DeliveryValue
FROM DeliveryData
GROUP BY 1
ORDER BY 2 DESC;

# Top 5 products of at each store
WITH CTE AS
(
SELECT
	DELIV_STORE_NAME,
    	ITEM_CATEGORY,
	SUM(ITEM_PRICE) AS TotalOrderValue,
    	ROW_NUMBER() OVER (PARTITION BY DELIV_STORE_NAME ORDER BY SUM(ITEM_PRICE) DESC) AS rnk
FROM DeliveryData
GROUP BY 1,2
)
SELECT 
	DELIV_STORE_NAME,
    	ITEM_CATEGORY,
    	TotalOrderValue
FROM CTE 
WHERE rnk BETWEEN 1 AND 5
ORDER BY 1, rnk ASC;
