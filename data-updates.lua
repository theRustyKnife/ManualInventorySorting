local size = 1000

local data_to_check = {
	data.raw["container"],
	data.raw["logistic-container"],
	data.raw["car"],
	data.raw["cargo-wagon"]
}

for _, t in pairs(data_to_check) do
	for __, v in pairs(t) do if v.inventory_size > size then size = v.inventory_size; end; end
end

data.raw["container"]["manual-inventory-sort-tmp-chest"].inventory_size = size