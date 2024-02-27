import os
import pandas as pd
import sqlalchemy

str_connection = 'sqlite:///{path}'

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(BASE_DIR, 'data')


files_names = [ i for i in os.listdir(DATA_DIR) if i.endswith('.csv')]

#abrindo a conexão
str_connection = str_connection.format( path=os.path.join(DATA_DIR, 'olist.db'))
connection = sqlalchemy.create_engine( str_connection )

for i in files_names:
    df_tmp = pd.read_csv(os.path.join(DATA_DIR, i))
    table_name = 'tb_' + i.replace("olist_", "").replace("_dataset","").strip(".csv")
    df_tmp.to_sql(table_name, connection)    