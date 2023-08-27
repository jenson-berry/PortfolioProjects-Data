-- # 1. Standardise Date Format
--The time included in this format is not needed, it is set 10 00:00:00 for every observation. I will start by adding another column for purely 'date' (I don't want to alter the original data)


ALTER TABLE nashvilleHousing
Add saleDateConverted Date;
UPDATE nashvilleHousing
SET saleDateConverted = CONVERT(Date, SaleDate)


-- # 2. Populate property address

-- ## 2.1 SELECT addresses where PropertyAddress is null and retrieve matching address from ParcelID
SELECT ds1.ParcelID, ds1.PropertyAddress, ds2.ParcelID, ds2.PropertyAddress, ISNULL(ds1.PropertyAddress, ds2.PropertyAddress)
FROM [Portfolio Project]..nashvilleHousing ds1
JOIN [Portfolio Project]..nashvilleHousing ds2
	on ds1.ParcelID = ds2.ParcelID
	AND ds1.[UniqueID ] <> ds2.[UniqueID ]
WHERE ds1.PropertyAddress is null

-- ## 2.2 Update table with matching property address data

UPDATE ds1
SET PropertyAddress = ISNULL(ds1.PropertyAddress, ds2.PropertyAddress)
FROM [Portfolio Project]..nashvilleHousing ds1
JOIN [Portfolio Project]..nashvilleHousing ds2
	on ds1.ParcelID = ds2.ParcelID
	AND ds1.[UniqueID ] <> ds2.[UniqueID ]
WHERE ds1.PropertyAddress is null

-- # 3. Separate Address into Individual Columns (Address, City, State)

-- ## 3.1 Remove comma from address

SELECT PropertyAddress
FROM [Portfolio Project]..nashvilleHousing

SELECT SUBSTRING (PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(propertyAddress)) AS Address
FROM [Portfolio Project]..nashvilleHousing


-- ## 3.2. Create columns for separated address
ALTER TABLE nashvilleHousing
ADD propertySplitAddress nvarchar(255);

UPDATE nashvilleHousing
SET propertySplitAddress = SUBSTRING (PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE nashvilleHousing
ADD propertySplitCity nvarchar(255);

UPDATE nashvilleHousing
SET propertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(propertyAddress))

SELECT *
FROM [Portfolio Project]..nashvilleHousing

-- ## 3.3 Repeat steps above for OwnerAddress
-- ## 3.3.1 Separate owner address
SELECT OwnerAddress
FROM [Portfolio Project]..nashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM [Portfolio Project]..nashvilleHousing

-- ## 3.3.2  Add tabled

ALTER TABLE nashvilleHousing
ADD ownerSplitAddress nvarchar(255);

UPDATE nashvilleHousing
SET ownerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE nashvilleHousing
ADD ownerSplitCity nvarchar(255);

UPDATE nashvilleHousing
SET ownerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)


ALTER TABLE nashvilleHousing
ADD ownerSplitState nvarchar(255);

UPDATE nashvilleHousing
SET ownerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

SELECT *
FROM [Portfolio Project]..nashvilleHousing


-- # 4. Replace 'Y' and 'N' with 'Yes' and 'No'

-- ## 4.1 Look at the problem
SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM [Portfolio Project]..nashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

-- ## 4.2 Solve the problem
SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM [Portfolio Project]..nashvilleHousing

-- ## 4.3 Update the table

UPDATE nashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END

-- #4.4 Verify the solution
SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM [Portfolio Project]..nashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


-- #5. Remove duplicates
WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY
		UniqueID)
		row_num

FROM [Portfolio Project]..nashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1

-- # 6. Delete unused columns

ALTER TABLE [Portfolio Project]..nashVilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate

SELECT *
FROM [Portfolio Project]..nashvilleHousing