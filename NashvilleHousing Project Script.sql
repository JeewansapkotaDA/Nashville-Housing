/*

Cleaning Data in SQL Queries

*/





Select*
From PortfolioProject..NashvilleHousing




--Standardize Date Format





Select SaleDateConverted, Convert(Date,SaleDate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)

Alter Table NashVilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)






--Populate Property Address data






Select*
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is NUll
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL


Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null







--Breaking out Address into Individua; Columns (Address, City, State)







Select
Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1) as Address
, Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, Len(PropertyAddress)) as Address

From PortfolioProject..NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1)

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, Len(PropertyAddress))



Select *
From PortfolioProject..NashvilleHousing








--Above can also be done in a more simpler way:-








Select OwnerAddress 
From PortfolioProject..NashvilleHousing


Select
Parsename(Replace(OwnerAddress, ',', '.'), 3),
Parsename(Replace(OwnerAddress, ',', '.'), 2),
Parsename(Replace(OwnerAddress, ',', '.'), 1)
From PortfolioProject..NashvilleHousing



Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From PortfolioProject.dbo.NashvilleHousing






--Change Y and N to Yes and NO in "Sold as Vacant" field







Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group By SoldAsVacant
Order By 2


Select SoldAsVacant,
Case
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
End
From PortfolioProject..NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
End







--Remove Duplicates








WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing

)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing








--Delete Unused Columns 








Select *
From PortfolioProject.dbo.NashvilleHousing



Alter Table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress


Alter Table NashvilleHousing
Drop Column SaleDate











