# -*- coding: utf-8 -*-
"""
Created on Wed Jul 30 22:22:14 2025

@author: 48531
"""

import pandas as pd
import random
from faker import Faker
from datetime import datetime, timedelta

fake = Faker()
START_DATE = pd.to_datetime("2024-01-01")
END_DATE = pd.to_datetime("2024-12-31")

employees = pd.read_csv("employee_records.csv", parse_dates=["Joining_Date"])
employee_ids = employees['Employee_ID'].tolist()
#employee_age = employees['Age'].tolist()
absence_types = ['Sick Leave', 'Unpaid', 'Other'] # list with type of absences

absences = []

for emp_id in employee_ids:
    used_dates = set() # prepare set for used date
    # creating two weeks vacation for each of employee
    start_vacation = fake.date_between(start_date=START_DATE, end_date=END_DATE - timedelta(days=14))
    for i in range(14):
        day = start_vacation + timedelta(days=i)
        if day.weekday() < 5:  # only weekdays
            absences.append({
                "employee_id": emp_id,
                "absence_date": day,
                "absence_type": "Vacation",
                "hours_absent": 8
            })
            used_dates.add(day)

    # creating other absences
    for _ in range(random.randint(1, 5)): # random days of absences
        tries = 0 # set number of chances to absence
        while tries < 20:
            date = fake.date_between(start_date=START_DATE, end_date=END_DATE)
            if date.weekday() >= 5 or date in used_dates: # exclusion of weekends and previous absences
                tries += 1
                continue
            abs_type = random.choice(absence_types) # choosing random type of absence
            # adding absences to a list
            absences.append({
                "employee_id": emp_id,
                "absence_date": date,
                "absence_type": abs_type,
                "hours_absent": 8 if abs_type in ["Sick Leave"] else random.choice([4, 8])
            })
            used_dates.add(date) # adding date to previous set
            break

# creating data frame and saving to csv
df = pd.DataFrame(absences)
df.sort_values(["employee_id", "absence_date"], inplace=True)
df.to_csv("real_absences.csv", index=False)