from __future__ import print_function
from bs4 import BeautifulSoup
import re, pandas as pd, sys

def extract_booking(booking):
    booking_page = open(booking)
    soup = BeautifulSoup(booking_page,'html.parser')
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
    columns_to_fill = ['Booking_Date','Arrest_Date','Time', 'ID_Number', 'First_Name','S', 'R', 'Age', 'Charge_Date','Charges', 'Type', 'Event_Number', 'Arrest_Officer','St','Last_Name', 'Middle_Name']# some values are not repeated across rows and need to be filled in
    for col_name in columns_to_fill:
        col = ''
        previous = ''
        new_col = []
        if col_name in t1.columns:
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
    t1['Time'] = pd.to_datetime(t1['Booking_Date'] + ' ' + t1['Time'])
    t1['Booking_Date'] = pd.to_datetime(t1['Booking_Date'])
    for option_col in ['Arrest_Date','Charge_Date']:
        if option_col in t1.columns:
            t1[option_col] = pd.to_datetime(t1[option_col])
    t1.Charges.replace(ws_fixer," ",regex=True,inplace=True)
    t1.Last_Name.replace(ws_fixer," ",regex=True,inplace=True)
    t1.First_Name.replace(ws_fixer," ",regex=True,inplace=True)
    t1.Middle_Name.replace(ws_fixer," ",regex=True,inplace=True)
    if list(t1.Row.astype(int)) == list(t1.index):
        del t1['Row']
    col_names = {c:c.lower() for c in list(t1.columns)}
    col_names['ID_Number'] = 'id'
    col_names['S']='sex'
    col_names['R']='race'
    col_names['St']='state_'
    col_names['Time']='booking_time'
    t1.rename(columns=col_names,inplace=True)
    t1['filename'] = booking.split('/')[-1]
    return t1
    
if __name__ == '__main__':
    booking_file = sys.argv[1]
    booking = extract_booking(booking_file)
    print(booking.to_csv())
