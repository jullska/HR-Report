# -*- coding: utf-8 -*-
"""
Created on Wed Jul 30 16:00:23 2025

@author: 48531
"""
import pandas as pd
import random
from faker import Faker
from datetime import datetime, timedelta

fake = Faker()
random.seed(42)

employees_df = pd.read_csv("employee_records.csv", parse_dates=["Joining_Date"])

# parameters
attrition_rate = 0.15  # let's assume 15% of employee are leaving
num_employees = len(employees_df)
num_leavers = int(num_employees * attrition_rate)

# choosing random emoloyees
leaver_indices = random.sample(range(num_employees), num_leavers)

# adding columns to df
employees_df["is_active"] = 1
employees_df["exit_date"] = pd.NaT

# creating dates of leaving
today = datetime(2025, 1, 1)

for i in leaver_indices:
    joining = employees_df.at[i, "Joining_Date"]
    min_exit = joining + timedelta(days=180)  # employee doesn't leave before 6 months of hiring
    max_exit = today

    if min_exit >= max_exit:
        # case with new employee
        continue

    
    random_exit = min_exit + timedelta(days=random.randint(0, (max_exit - min_exit).days)) # random day of leaving company
    employees_df.at[i, "is_active"] = 0 # acces value to row "i", column "is_active"
    employees_df.at[i, "exit_date"] = random_exit # acces value to row "i", column "exit_date"
    
# saving df with columns "is_active" and "exit_date" as csv
employees_df.to_csv("employees_with_attrition.csv", index=False)



