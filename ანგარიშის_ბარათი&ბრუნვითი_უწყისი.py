import pandas as pd
import mysql.connector

df1 = pd.read_excel(
    r"C:\Users\berid\OneDrive\Desktop\ანგარიშის ბარათი [1635].xlsx")
df1.columns = ["ID", "თარიღი", "დოკუმენტი", "საფუძველი", "შინაარსი", "შენიშვნა", "დებეტი", "კრედიტი", "დრაოდენობა",
               "დფასი", "დვალუტა", "დთანხა", "კრაოდენობა", "კფასი", "კვალუტა", "კთანხა", "ნრაოდენობა", "ნფასი", "ნვალუტა", "ნთანხა"]
df1 = df1.where((pd.notnull(df1)), None)
df1 = df1.iloc[2:, :]

df2 = pd.read_excel(r"C:\Users\berid\OneDrive\Desktop\ბრუნვითი_უწყისი.xlsx")
df2.columns = ["ანგარიში", "კოდი", "დასახელება", "ერთეული", "საწყისი_რაოდენობა", "საწყისი_ფასი", "საწყისი_დებეტი",
               "დრაოდენობა", "დფასი", "დთანხა", "კრაოდენობა", "კფასი", "კთანხა", "საბოლოო_რაოდენობა", "საბოლოო_თანხა", "საბოლოო_დებეტი"]
df2 = df2.where((pd.notnull(df2)), None)
df2 = df2.iloc[2:, :]

mydb = mysql.connector.connect(
    host="localhost", user="root", password="xxx", database="xxx")
mycursor = mydb.cursor()
mycursor.execute("DROP TABLE IF EXISTS ანგარიშის_ბარათი")
mycursor.execute("""CREATE TABLE ანგარიშის_ბარათი(ანგარიშის_ბარათი_ID int auto_increment primary key,თარიღი datetime,
                        დებეტი varchar(255),კრედიტი varchar(255),დრაოდენობა decimal(65,10),კრაოდენობა decimal(65,10))""")
for row in df1.itertuples():
    mycursor.execute("INSERT INTO ანგარიშის_ბარათი(თარიღი,დებეტი,კრედიტი,დრაოდენობა,კრაოდენობა) VALUES(%s,%s,%s,%s,%s)",
                     (row.თარიღი, row.დებეტი, row.კრედიტი, row.დრაოდენობა, row.კრაოდენობა))
mycursor.execute("DROP TABLE IF EXISTS ბრუნვითი_უწყისი")
mycursor.execute("""CREATE TABLE ბრუნვითი_უწყისი(ბრუნვითი_უწყისი_ID int auto_increment primary key, ანგარიში varchar(55), კოდი varchar(55), 
                    დასახელება varchar(255), ერთეული varchar(55),საბოლოო_რაოდენობა decimal(65,10))""")
for row in df2.itertuples():
    mycursor.execute("INSERT INTO ბრუნვითი_უწყისი(ანგარიში,კოდი,დასახელება,ერთეული,საბოლოო_რაოდენობა) VALUES(%s,%s,%s,%s,%s)",
                     (row.ანგარიში, row.კოდი, row.დასახელება, row.ერთეული, row.საბოლოო_რაოდენობა))

mydb.commit()
