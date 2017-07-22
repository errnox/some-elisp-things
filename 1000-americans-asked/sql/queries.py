import re
from pprint import pprint

import sqlite3


class Queries(object):
  def __init__(self, db):
    self.db = db
    self.query = 'SELECT * FROM survey WHERE gender LIKE "male" AND answer LIKE "manchester";'

  def run(self):
    connection = sqlite3.connect(self.db)
    c = connection.cursor()

    tuples = c.execute(self.query)
    results = tuples.fetchall()

    for row in results:
      if re.match("4.*|5.*", row[1]):
        pprint(row)

    # pprint(results)

    connection.commit()
    c.close()

if __name__ == '__main__':
  queries = Queries('survey.sqlite')
  queries.run()
