# -*- coding: utf-8 -*-
"""
Created on Mon Jul  7 15:43:19 2025

@author: 48531
"""

import pandas as pd
import random
from faker import Faker
from datetime import datetime

fake = Faker()
random.seed(42)

employees = pd.read_csv("employee_records.csv")
employee_ids = employees['Employee_ID'].tolist()

START_DATE = datetime(2024, 1, 1)
END_DATE = datetime(2024, 12, 31)


# creating overtimes
overtimes = []

for emp_id in employee_ids:
    if random.random() < 0.4:  # let's assume 40% employees are doing overtimes
        for _ in range(random.randint(1, 4)):
            date = fake.date_between(start_date=START_DATE, end_date=END_DATE)
            # appending faking dates to a list
            overtimes.append({
                'employee_id': emp_id,
                'overtime_date': date,
                'hours_overtime': random.choice([1, 2, 3, 4]),
                'approved_by_hr': random.choice([True, False])
            })

# creating data frame
df_overtimes = pd.DataFrame(overtimes)
df_overtimes.to_csv('overtimes.csv', index=False)
