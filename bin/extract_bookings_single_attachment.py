from __future__ import print_function
from bs4 import BeautifulSoup
import re, pandas as pd, sys, maya

def extract(booking):
    booking_page = open(booking)
    soup = BeautifulSoup(booking_page,'html.parser')
    booking_date_text = soup.find_all('table')[0].find_all('td')[-1].text.split("'")[-2]
    booking_date = maya.parse(booking_date_text).datetime(naive=True)
    table = soup.find_all('table')[-1]
    table = [row for row in table][1]
    ws_fixer = re.compile(r"\s+")
    cols = [ws_fixer.sub("_",col.text) for col in [row for row in table.find_all('tr')][0].find_all('td')]
    if cols[0] == '':
        cols[0] = 'Row'
    rows = table.find_all('tr')[1:]
    t1 = pd.DataFrame(columns=cols, index = range(1,len(rows)+1))
    row_marker = 0
    for row in rows:
        column_marker = 0
        columns = row.find_all('td')
        for column in columns:
            t1.iat[row_marker,column_marker] = column.get_text()
            column_marker+=1
        row_marker+=1
    t1['Booking_Date'] = t1['Booking_Date'][1]
    columns_to_fill = ['Time', 'ID_Number', 'First_Name','S', 'R', 'Age', 'Charges', 'Type', 'Event_Number', 'Arrest_Officer','St','Last_Name', 'Middle_Name']# some values are not repeated across rows and need to be filled in
    for col_name in columns_to_fill:
        col = ''
        previous = ''
        new_col = []
        for i,x in t1[col_name].iteritems():
            if x == '':
                if not col_name in ['Last_Name', 'Middle_Name']:
                    x = previous
                else:
                    if not previous == '':
                        if t1.loc[i,'First_Name'] == t1.loc[i - 1,'First_Name']:
                            x = previous
            col = x
            previous = col
            new_col.append(col)
        t1[col_name] = new_col
    return booking_date,t1
    
if __name__ == '__main__':
    booking_file = sys.argv[1]
    booking_date, booking = extract(booking_file)
