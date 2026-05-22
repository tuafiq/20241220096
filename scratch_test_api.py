import urllib.request
import json
import time

portals = ['fir', 'ks', 'ms', 'msh', 'maf', 'kj']
for p in portals:
    start = time.time()
    url = f'https://artikel-islam.netlify.app/.netlify/functions/api/{p}'
    try:
        req = urllib.request.Request(
            url, 
            headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
        )
        res = urllib.request.urlopen(req, timeout=30)
        data = json.loads(res.read().decode('utf-8'))
        success = data.get('success')
        data_obj = data.get('data')
        items = len(data_obj.get('data', [])) if data_obj else 0
        print(f'{p}: status={res.status}, success={success}, items={items}, time={time.time()-start:.2f}s')
    except Exception as e:
        print(f'{p}: error={e}, time={time.time()-start:.2f}s')
