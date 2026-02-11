import pandas as pd
import random 
from faker import Faker
from pathlib import Path

fake = Faker("en_IN")
random.seed(42)

TOTAL_CUSTOMERS = 150_000

CITIES = [
    "Mumbai", "Delhi", "Bengaluru", "Hyderabad", "Chennai",
    "Pune", "Ahmedabad", "Kolkata", "Jaipur", "Indore",
    "Bhopal", "Surat", "Noida", "Gurugram", "Faridabad"
]

def random_city_with_noise(city):
    """
    Docstring for random_city_with_noise
    
    :param city: Description
    """
    noise_type = random.random()
    if noise_type < 0.15:
        return city.upper()
    elif noise_type < 0.30:
        return city.lower()
    return city

def generate_customers(n=TOTAL_CUSTOMERS):
    records = []
    email_pool = []

    for i in range(1, n+1):
        name = fake.name()
        gender = random.choice(["Male", "Female", "Other"])
        age = random.randint(18, 65)
        city = random_city_with_noise(random.choice(CITIES))

        signup_date = fake.date_between(start_date='-2y', end_date='today')

        if random.random() < 0.10:
            last_active_date = None
        else:
            last_active_date = fake.date_between(
                start_date=signup_date, end_date='today')
            
        email = fake.email()
        if random.random() < 0.08:
            email = None
        elif random.random() < 0.05 and email_pool:
            email = random.choice(email_pool)
        else:
            email_pool.append(email)
        
        phone = fake.msisdn(email)

        address = fake.address().replace("\n", ", ")
        if random.random() < 0.05:
            address = None