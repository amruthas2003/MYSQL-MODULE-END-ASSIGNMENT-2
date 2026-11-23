USE ecomm;

SELECT COUNT(*) AS Total_Rows
FROM customer_churn;

SELECT
    SUM(WarehouseToHome IS NULL) AS Missing_WarehouseToHome,
    SUM(HourSpendOnApp IS NULL) AS Missing_HourSpendOnApp,
    SUM(OrderAmountHikeFromlastYear IS NULL) AS Missing_OrderAmountHikeFromlastYear,
    SUM(DaySinceLastOrder IS NULL) AS Missing_DaySinceLastOrder
FROM customer_churn;

SELECT
    SUM(Tenure IS NULL) AS Missing_Tenure,
    SUM(CouponUsed IS NULL) AS Missing_CouponUsed,
    SUM(OrderCount IS NULL) AS Missing_OrderCount
FROM customer_churn;

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_churn
SET PreferredLoginDevice = 'Mobile Phone'
WHERE PreferredLoginDevice = 'Phone';

SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile';

SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC';

SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC';

SET SQL_SAFE_UPDATES = 1;

ALTER TABLE customer_churn
RENAME COLUMN PreferedOrderCat TO PreferredOrderCat;

ALTER TABLE customer_churn
RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;

ALTER TABLE customer_churn
ADD COLUMN ComplaintReceived VARCHAR(3);

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_churn
SET ComplaintReceived =
CASE
    WHEN Complain = 1 THEN 'Yes'
    ELSE 'No'
END;

SET SQL_SAFE_UPDATES = 1;

ALTER TABLE customer_churn
ADD COLUMN ChurnStatus VARCHAR(10);

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_churn
SET ChurnStatus =
CASE
    WHEN Churn = 1 THEN 'Churned'
    ELSE 'Active'
END;

SET SQL_SAFE_UPDATES = 1;

ALTER TABLE customer_churn
DROP COLUMN Churn,
DROP COLUMN Complain;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM customer_churn
WHERE WarehouseToHome > 100;

SET SQL_SAFE_UPDATES = 1;

SELECT MAX(WarehouseToHome) AS Maximum_WarehouseToHome
FROM customer_churn;

SELECT
    SUM(WarehouseToHome IS NULL) AS Missing_WarehouseToHome,
    SUM(HoursSpentOnApp IS NULL) AS Missing_HoursSpentOnApp,
    SUM(OrderAmountHikeFromlastYear IS NULL) AS Missing_OrderAmountHike,
    SUM(DaySinceLastOrder IS NULL) AS Missing_DaySinceLastOrder
FROM customer_churn;

SELECT
    SUM(Tenure IS NULL) AS Missing_Tenure,
    SUM(CouponUsed IS NULL) AS Missing_CouponUsed,
    SUM(OrderCount IS NULL) AS Missing_OrderCount
FROM customer_churn;

SELECT
    ChurnStatus,
    COUNT(*) AS Customer_Count
FROM customer_churn
GROUP BY ChurnStatus;

SELECT
    AVG(Tenure) AS Average_Tenure,
    SUM(CashbackAmount) AS Total_Cashback
FROM customer_churn
WHERE ChurnStatus = 'Churned';

SELECT
    COUNT(CASE WHEN ComplaintReceived = 'Yes' THEN 1 END) * 100.0
    / COUNT(*) AS Complaint_Percentage
FROM customer_churn
WHERE ChurnStatus = 'Churned';

SELECT
    CityTier,
    COUNT(*) AS Churned_Customer_Count
FROM customer_churn
WHERE ChurnStatus = 'Churned'
AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY Churned_Customer_Count DESC;

SELECT
    PreferredPaymentMode,
    COUNT(*) AS Customer_Count
FROM customer_churn
WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode
ORDER BY Customer_Count DESC;

SELECT
    SUM(OrderAmountHikeFromlastYear) AS Total_OrderAmount_Hike
FROM customer_churn
WHERE MaritalStatus = 'Single'
AND PreferredOrderCat = 'Mobile Phone';

SELECT
    AVG(NumberOfDeviceRegistered) AS Average_Devices_Registered
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';

SELECT
    CityTier,
    COUNT(*) AS Customer_Count
FROM customer_churn
GROUP BY CityTier
ORDER BY Customer_Count DESC;

SELECT
    Gender,
    SUM(CouponUsed) AS Total_Coupons_Used
FROM customer_churn
GROUP BY Gender
ORDER BY Total_Coupons_Used DESC;

SELECT
    PreferredOrderCat,
    COUNT(*) AS Customer_Count,
    MAX(HoursSpentOnApp) AS Maximum_Hours_Spent
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY Customer_Count DESC;

SELECT
    SUM(OrderCount) AS Total_Order_Count
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
AND SatisfactionScore = (
    SELECT MAX(SatisfactionScore)
    FROM customer_churn
);

SELECT
    AVG(SatisfactionScore) AS Average_Satisfaction_Score
FROM customer_churn
WHERE ComplaintReceived = 'Yes';

SELECT
    PreferredOrderCat,
    COUNT(*) AS Customer_Count
FROM customer_churn
WHERE CouponUsed > 5
GROUP BY PreferredOrderCat
ORDER BY Customer_Count DESC;

SELECT
    PreferredOrderCat,
    AVG(CashbackAmount) AS Average_Cashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY Average_Cashback DESC
LIMIT 3;

SELECT
    PreferredPaymentMode,
    AVG(Tenure) AS Average_Tenure,
    SUM(OrderCount) AS Total_Orders
FROM customer_churn
GROUP BY PreferredPaymentMode
HAVING AVG(Tenure) = 10
AND SUM(OrderCount) > 500;

SELECT
    CASE
        WHEN WarehouseToHome <= 5
            THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10
            THEN 'Close Distance'
        WHEN WarehouseToHome <= 15
            THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS Distance_Category,
    ChurnStatus,
    COUNT(*) AS Customer_Count
FROM customer_churn
GROUP BY Distance_Category, ChurnStatus
ORDER BY Distance_Category, ChurnStatus;

SELECT
    CustomerID,
    MaritalStatus,
    CityTier,
    OrderCount
FROM customer_churn
WHERE MaritalStatus = 'Married'
AND CityTier = 1
AND OrderCount > (
    SELECT AVG(OrderCount)
    FROM customer_churn
);

