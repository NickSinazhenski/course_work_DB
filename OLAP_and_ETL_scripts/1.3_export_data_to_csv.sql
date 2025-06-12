--export data
COPY dim_Date TO '/Library/PostgreSQL/17/data/export/dim_Date.csv' CSV HEADER;
COPY dim_Interest TO '/Library/PostgreSQL/17/data/export/dim_Interest.csv' CSV HEADER;
COPY dim_Box TO '/Library/PostgreSQL/17/data/export/dim_Box.csv' CSV HEADER;
COPY dim_Customer TO '/Library/PostgreSQL/17/data/export/dim_Customer.csv' CSV HEADER;
COPY bridge_Customer_Interest TO '/Library/PostgreSQL/17/data/export/bridge_Customer_Interest.csv' CSV HEADER;
COPY fact_Subscription TO '/Library/PostgreSQL/17/data/export/fact_Subscription.csv' CSV HEADER;
COPY fact_Delivery_Performance TO '/Library/PostgreSQL/17/data/export/fact_Delivery_Performance.csv' CSV HEADER;
