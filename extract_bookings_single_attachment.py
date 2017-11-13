# coding: utf-8
# env: scraper3
from __future__ import print_function
from bs4 import BeautifulSoup
import re, pandas as pd

booking_page = open('/Users/acohen/data/LVMPD/BOOKINGS/110517-ITAG-ALL, SENT 110617-DH.htm')

soup = BeautifulSoup(booking_page,'html.parser')
table = soup.find_all('table')[-1]
table = [row for row in table][1]
ws_fixer = re.compile(r"\s+")

cols = [ws_fixer.sub("_",col.text) for col in [row for row in table.find_all('tr')][0].find_all('td')]

if cols[0] == '':
    cols[0] = 'Row'
       
t1 = pd.DataFrame(columns=cols, index = [0]) # dataframe with one row, all columns == NaN

t2 = pd.DataFrame(columns=cols) # dataframe with columns, no rows

#row_marker = 0

#for row in table.find_all('tr'):
#    column_marker = 0
#    columns = row.find_all('td')
#    for column in columns:
#        new_table.iat[row_marker,column_marker] = column.get_text()
#        column_marker+=1
#    row_marker+=1
