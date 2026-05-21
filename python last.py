
import pandas as pd

all_sheets = pd.read_excel(r"C:\Users\remoo\Downloads\dirty_ecommerce_dataset.xlsx", sheet_name=None)

orders = all_sheets['Fact_Orders']
customers = all_sheets['Dim_Customers']
products = all_sheets['Dim_Products']

# replacing the nulls with frequent customer 
orders['Customer_ID'] = orders['Customer_ID'].fillna(orders['Customer_ID'].mode().iloc[0])

# exploring the customers sheet
customers.info()
customers.isnull().sum()
customers['Gender'] = customers['Gender'].replace({'M': 'Male','F': 'Female'})
customers.shape


import numpy as np 
# Replace ages outside 18–100 with NaN
customers.loc[(customers['Age'] < 18) | (customers['Age'] > 100), 'Age'] = np.nan
# dropping the nulls
customers['Age'].dropna(inplace=True)

#exploring the products sheet
products.info()
products.isnull().sum()
# dropping the nulls
products.dropna(subset=['Product_Category'], inplace=True)

# Save all sheets back into a new Excel file
with pd.ExcelWriter("cleaned_ecommerce_dataset.xlsx") as writer:
    for sheet_name, df in all_sheets.items():
        df.to_excel(writer, sheet_name=sheet_name, index=False)

