Select * 
 from Portfolio2..NashvilleHousing


----Formatting the sale date in date--------

select SaleDate,convert(Date,SaleDate), --- cast(saleDate as Date) {another method}
 from Portfolio2..NashvilleHousing

Update NashvilleHousing
	Set SaleDate=convert(Date,SaleDate)

ALter table NashvilleHousing
  add SaleDateConverted Date
  
----Populate the property address data ------

select *
 from NashvilleHousing
 --where PropertyAddress is null
 order by ParcelID

 select A.ParcelID,A.PropertyAddress,B.ParcelID,B.PropertyAddress,ISNULL(A.PropertyAddress,b.PropertyAddress)
 from NashvilleHousing as A
 join NashvilleHousing as B
 on A.ParcelID=B.ParcelID 
 and A.[UniqueID ]<>B.[UniqueID ]
 where A.PropertyAddress is null

 Update a
  set PropertyAddress = ISNULL(A.PropertyAddress,b.PropertyAddress)
 from NashvilleHousing as A
 join NashvilleHousing as B
 on A.ParcelID=B.ParcelID 
 and A.[UniqueID ]<>B.[UniqueID ]
 where A.PropertyAddress is null

 -----Breaking the owner address into Address,city,state
 select PropertyAddress
  from NashvilleHousing

Select PropertyAddress,
 SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1) as City,
 substring(PropertyAddress,charindex(',',PropertyAddress)+1,charindex(',',PropertyAddress)) as state
 from NashvilleHousing
 --// add the above column in table

 Alter table NashvilleHousing
  add propertySplitAdress Varchar(255)

Update NashvilleHousing
 set propertySplitAdress =  SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1)


 Alter table NashvilleHousing
  add propertySplitcity Varchar(255)

Update NashvilleHousing
 set propertySplitcity = substring(PropertyAddress,charindex(',',PropertyAddress)+1,charindex(',',PropertyAddress))

 -----trying in the parse name to split the PropertyAddress ---------

 --select PropertyAddress,
 --PARSENAME(replace(PropertyAddress,',','.'),2),
 --PARSENAME(replace(PropertyAddress,',','.'),1)
 --from NashvilleHousing




 --Owner Address--
--using ParseName instead of substring----
 select ownerAddress,
 ParseName(replace(OwnerAddress,',','.'),3),
 ParseName(replace(OwnerAddress,',','.'),2),
 ParseName(replace(OwnerAddress,',','.'),1)
  from NashvilleHousing

----add the split columns in table----
 Alter table NashvilleHousing
  add OwnerSplitAddress Varchar(255)

Update NashvilleHousing
 set OwnerSplitAddress =  ParseName(replace(OwnerAddress,',','.'),3)

Alter table NashvilleHousing
  add OwnerSplitCity Varchar(255)

Update NashvilleHousing
 set OwnerSplitCity =  ParseName(replace(OwnerAddress,',','.'),2)

Alter table NashvilleHousing
  add OwnerSplitstate Varchar(255)

Update NashvilleHousing
 set OwnerSplitState =  ParseName(replace(OwnerAddress,',','.'),1)

------------------
--change Y and N to Yes and No in "sold as Vacant field

select distinct(SoldasVacant),count(SoldasVacant)
 from NashvilleHousing
 Group by SoldAsVacant
 order by count(SoldAsVacant)

select soldasVacant,
 Case 
 when SoldasVacant ='Y' then 'Yes'
 when SoldasVacant = 'N' then 'No'
 else SoldasVacant
 end 
 from NashvilleHousing

Update NashvilleHousing
 set SoldAsVacant = Case 
 when SoldasVacant ='Y' then 'Yes'
 when SoldasVacant = 'N' then 'No'
 else SoldasVacant
 end 

----------------------
--Remove Duplicates
with row_numCTE as (
select *,
 ROW_NUMBER() over (partition by ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					order by
					uniqueID) row_num

 from NashvilleHousing)

 select *
  from row_numCTE
  where row_num > 1


------Delete the unused column---------

alter table NashvilleHousing
 drop column OwnerAddress, TaxDistrict, PropertyAddress

select *
 from NashvilleHousing