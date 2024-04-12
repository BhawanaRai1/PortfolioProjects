/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM PortfolioProject..NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Alter TABLE PortfolioProject..NashvilleHousing
ADD SaleDatesConverted date;

UPDATE PortfolioProject..NashvilleHousing
SET SaleDatesConverted = CONVERT(Date, SaleDate)

SELECT SaleDatesConverted, CONVERT(Date, SaleDate) AS SaleDate
FROM PortfolioProject..NashvilleHousing;



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
 
 
SELECT *
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is null
Order by ParcelId;



 
SELECT a.ParcelId, a.PropertyAddress, b.ParcelId, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing AS a
JOIN PortfolioProject..NashvilleHousing AS b
      ON a.ParcelId = b.ParcelId
      AND a.  [UniqueId] <> b.[UniqueId]
 WHERE a.PropertyAddress is null;



 Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT
SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress) + 1, LEN (PropertyAddress))as Address
FROM PortfolioProject..NashvilleHousing;


ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitAddress NVARCHAR (255);

UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1) 

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitCity NVARCHAR (255);

UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress) + 1, LEN (PropertyAddress))


SELECT *
FROM  PortfolioProject..NashvilleHousing;



SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing;


SELECT 
PARSENAME (REPLACE( OwnerAddress, ',', '.') ,3),
PARSENAME (REPLACE( OwnerAddress, ',', '.') ,2),
PARSENAME (REPLACE( OwnerAddress, ',', '.') ,1)
FROM PortfolioProject..NashvilleHousing;



ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitAddress NVARCHAR (255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME (REPLACE( OwnerAddress, ',', '.') ,3)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitCity NVARCHAR (255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME (REPLACE( OwnerAddress, ',', '.') ,2)


ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitState NVARCHAR (255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME (REPLACE( OwnerAddress, ',', '.') ,1)


SELECT *
FROM  PortfolioProject..NashvilleHousing;


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT SoldAsVacant, COUNT (SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN  'Yes'
     WHEN SoldAsVacant = 'N' THEN 'NO'
     ELSE SoldAsVacant
     END
FROM PortfolioProject..NashvilleHousing


UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN  'Yes'
     WHEN SoldAsVacant = 'N' THEN 'NO'
     ELSE SoldAsVacant
     END


	 -----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
 WITH RowNumCTE AS (
 SELECT *,
      ROW_NUMBER () OVER (
      PARTITION BY ParcelID,
	           PropertyAddress,
	           SaleDate,
		   SalePrice,
		   LegalReference
		   ORDER BY UniqueID) as Row_num

 FROM PortfolioProject..NashvilleHousing )


SELECT *
FROM RowNumCTE
WHERE Row_num >1 
ORDER BY PropertyAddress


SELECT *
FROM  PortfolioProject..NashvilleHousing;


 ---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


SELECT *
FROM PortfolioProject..NashvilleHousing 

ALTER TABLE  PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;


