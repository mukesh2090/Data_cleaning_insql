use portfolio_project
go



--Cleaning Data in SQL Queries
select saledate
from Nashvillehousingdata
order by 1,2;


-- Standardize Date Format
select saledateconverted,CONVERT(date,saledate)
from Nashvillehousingdata

update Nashvillehousingdata
set SaleDate = CONVERT(date,saledate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousingdata
Add SaleDateConverted Date;

update Nashvillehousingdata
set SaleDateConverted = CONVERT(date,SaleDate)



--Populate Property Address data

select *
from Nashvillehousingdata
order by ParcelID

select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress, ISNULL(a.propertyaddress,b.PropertyAddress)
from Nashvillehousingdata  a
join Nashvillehousingdata  b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.propertyaddress,b.PropertyAddress)
from Nashvillehousingdata  a
join Nashvillehousingdata  b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--select *
--from Nashvillehousingdata
--where PropertyAddress is null



-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From Nashvillehousingdata
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From Nashvillehousingdata

ALTER TABLE NashvilleHousingdata
Add PropertySplitAddress Nvarchar(255);

Update Nashvillehousingdata
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousingdata
Add PropertySplitCity Nvarchar(255);

Update Nashvillehousingdata
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From Nashvillehousingdata

select owneraddress
from Nashvillehousingdata

select 
PARSENAME(REPLACE(owneraddress,',',','),3)
,PARSENAME(REPLACE(owneraddress,',',','),2)
,PARSENAME(REPLACE(owneraddress,',',','),1)
from Nashvillehousingdata

ALTER TABLE NashvilleHousingdata
Add OwnerSplitAddress Nvarchar(255);

Update Nashvillehousingdata
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousingdata
Add OwnerSplitCity Nvarchar(255);

Update Nashvillehousingdata
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousingdata
Add OwnerSplitState Nvarchar(255);

Update Nashvillehousingdata
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From Nashvillehousingdata

-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(soldasvacant), count(soldasvacant)
from Nashvillehousingdata
group by SoldAsVacant
order by 2

select soldasvacant
,case when soldasvacant = 'Y' then 'Yes'
      when soldasvacant = 'N' then 'No'
	  else soldasvacant
	  end
from Nashvillehousingdata

update Nashvillehousingdata
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
      when soldasvacant = 'N' then 'No'
	  else soldasvacant
	  end


-- Remove Duplicates

WITH rownumCTE as(
select *,
    ROW_NUMBER() over(
	partition by parcelid,
	             propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
				 order by
				   uniqueid
				   ) row_num
from Nashvillehousingdata
)
SELECT *
from rownumCTE
where row_num > 1
order by PropertyAddress

-- Delete Unused Columns
select *
from Nashvillehousingdata

alter table Nashvillehousingdata
drop column owneraddress,propertyaddress

alter table Nashvillehousingdata
drop column saledate

--select *
--from nashvillehousingdata;