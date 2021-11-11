CREATE TABLE IF NOT EXISTS cloudops.product (
    uniq_id text,
    sku text,
    name_title text,
    "Reviews" text,
    average_product_rating text,
    brand text,
    category text,
    category_tree text,
    description text,
    list_price decimal,
    product_image_urls text,
    product_url text,
    sale_price decimal,
    total_number_reviews int,
    PRIMARY KEY ((uniq_id), sku, name_title)
);

CREATE TABLE IF NOT EXISTS cloudops.assortment_price (
    uniq_id text,
    sku text,
    store text,
    name_title text,
    total_units int,
    sale_price decimal,
    PRIMARY KEY ((store), uniq_id, sku)
);