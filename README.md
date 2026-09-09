# Olist E-Commerce Analytics Dashboard

End-to-end e-commerce analytics project using Python, PostgreSQL, SQL, DAX, and Power BI to analyze 100K orders from the Brazilian Olist dataset.

The project explores sales and revenue trends, customer segmentation, seller performance, and logistics through a four-page interactive Power BI dashboard.

## Project Workflow

Python Data Loading → PostgreSQL → SQL Reporting Views → Power BI (DAX measures & modeling) → Dashboard

## Tools

- Python
- pandas
- SQLAlchemy
- PostgreSQL
- SQL
- Power BI
- DAX

## Data Pipeline

`load_olist_data.py` loads the nine Olist source datasets into PostgreSQL using pandas and SQLAlchemy.

The SQL layer then creates reusable reporting views for:

- sales and revenue analysis
- customer segmentation and spending
- seller and carrier performance

Indexes were also added to improve query performance.

## Power BI Analysis

1. **Executive Overview** - GMV, recognized revenue, lost revenue, revenue trends, and geographic and product category performance
2. **Sales & Revenue Trends** - top product categories and customer states by GMV and lost revenue
3. **Customer Segmentation** - repeat customers, above-average spenders, and top 20% spenders
4. **Seller & Logistics Performance** - seller handoff performance, review scores, carrier transit time, and seller revenue

## Limitations

- The Olist dataset contains incomplete activity in the final reporting periods. Purchase-based trend visuals are shown through August 2018, while recognized revenue trends are shown through September 2018 based on delivery date.
- Customer segmentation is based on delivered orders. A small number of customers appear under multiple city and state combinations, which can create minor duplication in location-level customer analysis.
- Review scores are recorded at the order level, not the seller level, and a single order can contain items from multiple sellers. Seller-level measures correct for this at different grains depending on the metric: review score and transit time are averaged across distinct orders, revenue is aggregated across distinct order items, and handoff performance is evaluated at the seller-order level. This prevents duplicated line items from distorting results.

## Repository Files

- `Ecommerce_Analytics_Dashboard.pbix` - Power BI report
- `Ecommerce_Analytics_Dashboard.pdf` - static dashboard preview
- `olist_reporting_views.sql` - PostgreSQL reporting views and indexes
- `load_olist_data.py` - Python script for loading the Olist CSV files into PostgreSQL
- `images/` - dashboard screenshots

## Setup

1. Create a PostgreSQL database named `OLIST`.

   The loading script assumes PostgreSQL is running locally on port `5432` with the default `postgres` user.

2. Download the Olist dataset (see [Dataset](#dataset) below) and place the nine CSV files inside a `data/` folder in the project directory.

3. Set your PostgreSQL password as the `OLIST_DB_PASSWORD` environment variable.

4. Install the required Python packages:

```bash
pip install pandas sqlalchemy psycopg2-binary
```

5. Run the loading script:

```bash
python load_olist_data.py
```

6. Run `olist_reporting_views.sql` in PostgreSQL to create the reporting views and indexes.

7. Open `Ecommerce_Analytics_Dashboard.pbix` in Power BI Desktop.

## Dataset

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle).
