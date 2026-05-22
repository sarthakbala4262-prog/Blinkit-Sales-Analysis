# %%
import pandas as pd
import numpy as np

# %%
df_orders=pd.read_csv("C:\\Users\\Sarthak Bala\\Downloads\\blinkit_orders.csv")
print(df_orders)

# %%
df_product=pd.read_csv("C:\\Users\\Sarthak Bala\\Downloads\\blinkit_products.csv")
print(df_product)

# %%
df_inventory=pd.read_csv("C:\\Users\\Sarthak Bala\\Downloads\\blinkit_inventoryNew.csv")
print(df_inventory)

# %%
df_delivery=pd.read_csv("C:\\Users\\Sarthak Bala\\Downloads\\blinkit_delivery_performance.csv")
print(df_delivery)

# %%
df_customer=pd.read_csv("C:\\Users\\Sarthak Bala\\Downloads\\blinkit_customers.csv")
print(df_customer)

# %%
df_inventory['date']=pd.to_datetime(df_inventory['date'])

# %%
df_inventory

# %%
print(df_product.info())

# %%
print(df_product.isnull().sum())

# %%
print(df_inventory.isnull().sum())

# %%
print(df_customer.isnull().sum())

# %%
print(df_orders.isnull().sum())

# %%
print(df_delivery.isnull().sum())

# %%
df_delivery['reasons_if_delayed']=df_delivery['reasons_if_delayed'].fillna('Unspecified')

# %%
df_orders['order_date']=pd.to_datetime(df_orders['order_date'])

# %%
print(df_orders)

# %%
print(df_orders.info())

# %%
print(df_product.info())

# %%
print(df_inventory.info())

# %%
print(df_delivery.info())

# %%
print(df_customer.info())

# %%
df_orders['promised_delivery_time']=pd.to_datetime(df_orders['promised_delivery_time'])

# %%
df_orders['actual_delivery_time']=pd.to_datetime(df_orders['actual_delivery_time'])

# %%
df_product['Profit_Per_Unit']=(df_product['price']* df_product['margin_percentage'])/100

# %%
print(df_product.head())

# %%


# %%
df_inventory['Wastage_Rate']=(df_inventory['damaged_stock']/df_inventory['stock_received'])*100

# %%
print(df_inventory.head())

# %%
df_delivery['Delivery_Binary']=np.where(df_delivery['delivery_time_minutes']>0,'Late','On Time')

# %%
print(df_delivery.head())

# %%
print(df_delivery.info())

# %%


# %%
df_delivery['reasons_if_delayed']=df_delivery['reasons_if_delayed'].fillna('Not Delayed')

# %%
df_customer['registration_date']=pd.to_datetime(df_customer['registration_date'])

# %%
df_orders.to_csv('clean_orders.csv',index=False)
df_customer.to_csv('clean_customer.csv',index=False)
df_product.to_csv('cleaned_products.csv', index=False)
df_inventory.to_csv('cleaned_inventory.csv', index=False)
df_delivery.to_csv('cleaned_delivery.csv', index=False)

print("Files are ready for SQL")

# %%


# %%


# %%


# %%


# %%


# %%


# %%


# %%


# %%


# %%


# %%



