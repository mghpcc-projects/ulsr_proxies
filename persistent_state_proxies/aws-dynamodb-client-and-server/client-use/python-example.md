The Python requests module http://docs.python-requests.org/en/master/, https://pypi.python.org/pypi/requests
can be used for making ``GET`` and ``PUT`` requests from a script.

* Example of ``GET``

```
import requests
import json

url='https://0e5f0zcx22.execute-api.us-east-2.amazonaws.com/e1TimTesting20180304/ulsr-res-id/flexalloc_moc_20170410_rack7_8'
headers={'x-api-key' :'KKKKK'}'
# Change KKKKK above to actual key.

r = requests.get(url, headers=headers)


print(r.text)

d=json.loads(r.text)
dd=json.loads(d['ibSplist'])
for ddd in dd:
 for key, value in ddd.iteritems():
  print key,value

```
