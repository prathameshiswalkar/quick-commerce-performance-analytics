import pandas as pd
import random
from faker import Faker
from pathlib import Path

fake = Faker("en_IN")
random.seed(42)

TOTAL_PRODUCTS = 5_000

CATEGORY_MAP = {
    "Fruits & Vegetables": ["Fruits", "Vegetables"],
    "Dairy & Bakery": ["Milk", "Cheese", "Bread", "Butter"],
    "Snacks & Beverages": ["Chips", "Soft Drinks", "Juices", "Biscuits"],
    "Staples": ["Rice", "Wheat", "Pulses", "Flour"],
    "Personal Care": ["Shampoo", "Soap", "Toothpaste", "Face Wash"],
    "Household": ["Detergent", "Cleaner", "Dishwash"],
    "Frozen Foods": ["Frozen Snacks", "Ice Cream"],
    "Baby Care": ["Diapers", "Baby Food"],
    "Pet Care": ["Pet Food", "Pet Accessories"]
}

PERISHABLE_CATEGORIES = {
    "Fruits & Vegetables", "Dairy & Bakery", "Frozen Foods"
}

PRICE_RANGES = {
    "Fruits & Vegetables": (20, 200),
    "Dairy & Bakery": (30, 300),
    "Snacks & Beverages": (20, 250),
    "Staples": (40, 500),
    "Personal Care": (60, 600),
    "Household": (80, 700),
    "Frozen Foods": (100, 800),
    "Baby Care": (150, 900),
    "Pet Care": (200, 1200)
}

def generate_products(n=TOTAL_PRODUCTS):
    records = []

    for i in range(1, n + 1):
        category = random.choice(list(CATEGORY_MAP.keys()))
        sub_category = random.choice(CATEGORY_MAP[category])
        brand = fake.company()

        price_min, price_max = PRICE_RANGES[category]
        price = round(random.uniform(price_min, price_max), 2)

        is_perishable = category in PERISHABLE_CATEGORIES

        prod_name = f"{brand} {sub_category}"

        created_at = fake.date_between(start_date="-2y", end_date="today")

        records.append([
            i, prod_name, category, sub_category,
            brand, price, is_perishable, created_at
        ])

    df = pd.DataFrame(records, columns=[
        "prod_id", "prod_name", "category",
        "sub_category", "brand", "price",
        "is_perishable", "created_at"
    ])

    return df


if __name__ == "__main__":
    output_dir = Path(r"D:\quick_commerce_capstone\output_data")
    output_dir.mkdir(parents=True, exist_ok=True)

    products_df = generate_products()
    products_df.to_csv(output_dir / "products.csv", index=False)

    print(f"products table generated with {len(products_df)} rows")
