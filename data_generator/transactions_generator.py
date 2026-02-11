import pandas as pd
import random
from faker import Faker
from pathlib import Path
from datetime import timedelta

fake = Faker("en_IN")
random.seed(42)

OUTPUT_DIR = Path(r"D:\quick_commerce_capstone\output_data")
ORDERS_PATTERN = "orders_part_*.csv"
CHUNK_SIZE = 50_000

PAYMENT_MODES = ["UPI", "Credit Card", "Debit Card", "Wallet", "Net Banking", "COD"]

PAYMENT_STATUS_WEIGHTS = {
    "SUCCESS": 0.85,
    "FAILED": 0.10,
    "PENDING": 0.05
}


def choose_payment_status():
    r = random.random()
    cumulative = 0
    for status, weight in PAYMENT_STATUS_WEIGHTS.items():
        cumulative += weight
        if r <= cumulative:
            return status
    return "SUCCESS"


def generate_transactions():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    transaction_id = 1
    output_file = OUTPUT_DIR / "transactions.csv"
    first_write = True

    for orders_file in OUTPUT_DIR.glob(ORDERS_PATTERN):
        print(f"Processing {orders_file.name}")

        for chunk in pd.read_csv(orders_file, chunksize=CHUNK_SIZE):
            records = []

            for _, row in chunk.iterrows():
                payment_mode = random.choice(PAYMENT_MODES)

                if payment_mode == "COD":
                    payment_status = "SUCCESS"
                else:
                    payment_status = choose_payment_status()

                order_ts = pd.to_datetime(row["order_ts"])

                payment_ts = order_ts + timedelta(
                    seconds=random.randint(5, 300)
                )

                records.append([
                    transaction_id,
                    row["order_id"],
                    payment_mode,
                    payment_status,
                    row["order_value"],
                    payment_ts
                ])

                transaction_id += 1

            df_txn = pd.DataFrame(records, columns=[
                "transaction_id",
                "order_id",
                "payment_mode",
                "payment_status",
                "transaction_amount",
                "payment_ts"
            ])

            df_txn.to_csv(
                output_file,
                index=False,
                mode="w" if first_write else "a",
                header=first_write
            )

            first_write = False

    print("Transactions table generated successfully")


if __name__ == "__main__":
    generate_transactions()
 