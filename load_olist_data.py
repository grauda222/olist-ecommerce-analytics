import os
import pandas as pd
from sqlalchemy import create_engine

password = os.getenv("OLIST_DB_PASSWORD")
engine = create_engine(f"postgresql+psycopg2://postgres:{password}@localhost:5432/OLIST")

files = {
    "olist_orders_dataset": "data/olist_orders_dataset.csv",
    "olist_customers_dataset": "data/olist_customers_dataset.csv",
    "olist_order_items_dataset": "data/olist_order_items_dataset.csv",
    "olist_order_payments_dataset": "data/olist_order_payments_dataset.csv",
    "olist_order_reviews_dataset": "data/olist_order_reviews_dataset.csv",
    "olist_products_dataset": "data/olist_products_dataset.csv",
    "olist_sellers_dataset": "data/olist_sellers_dataset.csv",
    "olist_geolocation_dataset": "data/olist_geolocation_dataset.csv",
    "product_category_name_translation": "data/product_category_name_translation.csv",
}

for table, file in files.items():
    df = pd.read_csv(file)
    # if_exists="replace" rebuilds each table on every run,
    # so the script can be re-run safely without manual cleanup
    df.to_sql(table, engine, if_exists="replace", index=False)
