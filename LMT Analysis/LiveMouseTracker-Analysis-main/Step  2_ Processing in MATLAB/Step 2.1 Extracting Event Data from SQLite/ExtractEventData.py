# -*- coding: utf-8 -*-
"""
Step 2.1 of LMT Data processing

This script is an example for how to open an SQL file in python.

"""
import sqlite3
import pandas as pd
from sqlite3 import Error

def create_connection(db_file):
    """ create a database connection to the SQLite database
        specified by the db_file
    :param db_file: database file
    :return: Connection object or None
    """
    conn = None
    try:
        conn = sqlite3.connect(db_file)
    except Error as e:
        print(e)

    return conn

def select_all_events(conn):
    """
    Query all rows in the EVENT table
    :param conn: the Connection object
    :return:
    """
    cur = conn.cursor()
    cur.execute("SELECT * FROM EVENT")

    rows = cur.fetchall()

    for row in rows:
        print(row)
        
def main():
    database = r"C:\Users\amyrh\Documents\AA_Education\Neuroscience_MSc\MATLAB_Processing\Python\Step 2.1 Extracting Event Data from SQLite\test.sqlite"

    # create a database connection
    conn = create_connection(database)
    with conn:

        print("2. Query all tasks")
        select_all_events(conn)

if __name__ == '__main__':
    main()