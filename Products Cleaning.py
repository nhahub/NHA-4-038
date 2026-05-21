import pandas as pd

# =========================
# 1. Load Data
# =========================
Data = pd.read_excel(r'C:\Users\LENOVO\Desktop\Project\Final E-commerce dataset\cleaned_ecommerce_dataset 1.xlsx')

# =========================
# 2. Data Types
# =========================
Data['Order_Date'] = pd.to_datetime(Data['Order_Date'])

# =========================
# 3. Create Calculated Columns
# =========================
Data['Gross_Amount'] = Data['Quantity'] * Data['Unit_Price']
Data['Check_Gross'] = Data['Quantity'] * Data['Unit_Price']
Data['Check_Net'] = Data['Gross_Amount'] - Data['Discount']

# =========================
# 4. Validate Data
# =========================
invalid_gross = Data[Data['Gross_Amount'] != Data['Check_Gross']]
invalid_net = Data[Data['Net_Amount'] != Data['Check_Net']]

# =========================
# 5. Fix Discount
# =========================
def fix_discount(row):
    if row['Discount'] < 0:
        return 0
    elif row['Discount'] > row['Gross_Amount'] * 0.5:
        return row['Gross_Amount'] * 0.5
    else:
        return row['Discount']

Data['Discount'] = Data.apply(fix_discount, axis=1)

# =========================
# 6. Discount Percentage
# =========================
Data['Discount_Percentage'] = Data['Discount'] / Data['Gross_Amount']

# =========================
# 7. Handle Duplicates
# =========================
duplicates = Data['Order_ID'].duplicated(keep='first')
duplicate_rows = Data[duplicates]

Data.loc[duplicates, 'Order_ID'] = 'ORD-1476-33319'

# =========================
# 8. Remove Helper Columns
# =========================
cleaned_data = Data.drop(columns=['Check_Gross', 'Check_Net'])

# =========================
# 9. Clean Shipping Cost
# =========================
valid_shipping = cleaned_data[
    (cleaned_data['Shipping_Cost'] >= 0) &
    (cleaned_data['Shipping_Cost'] <= 120)
]

avg_shipping = int(valid_shipping['Shipping_Cost'].mean())

cleaned_data.loc[
    (cleaned_data['Shipping_Cost'] < 0) |
    (cleaned_data['Shipping_Cost'] > 120),
    'Shipping_Cost'
] = avg_shipping

# =========================
# 10. Final Checks
# =========================
min_shipping = cleaned_data['Shipping_Cost'].min()
max_shipping = cleaned_data['Shipping_Cost'].max()

# =========================
# 11. Export Clean Data
# =========================
cleaned_data.to_excel(r'C:\Users\LENOVO\Desktop\Project\d_cleaned_data.xlsx', index=False)