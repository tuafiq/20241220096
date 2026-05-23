import urllib.request
import re
from bs4 import BeautifulSoup

urls = [
    "https://islam.nu.or.id/ramadhan/kultum-ramadhan-puasa-dan-spirit-perlawanan-terhadap-korupsi-JTz1s",
    "https://islam.nu.or.id/ramadhan/kultum-ramadhan-menjaga-lisan-menjaga-keberkahan-puasa-Xlfye",
    "https://islam.nu.or.id/ramadhan/kultum-ramadhan-menjaga-mata-menjaga-pahala-puasa-qfRF8",
    "https://islam.nu.or.id/ramadhan/kultum-ramadhan-puasa-ramadhan-perekat-solidaritas-dan-kerukunan-warga-qjfNE",
    "https://islam.nu.or.id/ramadhan/kultum-ramadhan-bulan-puasa-dan-semangat-amal-yang-berkesinambungan-CTGl9"
]

def clean_text(text):
    text = text.replace("“", '"').replace("”", '"').replace("’", "'").replace("‘", "'").replace(' ', ' ')
    return text.strip()

def is_arabic(text):
    # Check if a significant portion of characters are Arabic
    arabic_chars = len(re.findall(r'[\u0600-\u06FF]', text))
    if arabic_chars > 5:
        return True
    return False

results = []

for url in urls:
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        html = urllib.request.urlopen(req).read()
        soup = BeautifulSoup(html, 'html.parser')
        
        title_tag = soup.find('h1')
        title = title_tag.get_text().strip() if title_tag else "Kultum"
        
        body = soup.find('div', class_='article-content') 
        if not body:
            body = soup.find('div', id='article-content')
        if not body:
            body = soup.find('div', class_='detail-content')
        if not body:
            body = soup.find('div', class_='content')
            
        if not body:
            paragraphs = soup.find_all('p')
        else:
            paragraphs = body.find_all('p')
            
        sections = []
        
        for p in paragraphs:
            text = clean_text(p.get_text())
            if not text:
                continue
                
            if 'NU Online Super App' in text or 'Download NU Online' in text or 'https://nu.or.id/superapp' in text:
                continue
                
            if is_arabic(text):
                sections.append({
                    'type': 'arabic',
                    'content': text,
                    'translation': ''
                })
            else:
                if (text.lower().startswith('artinya') or text.lower().startswith('maknanya')) and len(sections) > 0 and sections[-1]['type'] == 'arabic':
                    sections[-1]['translation'] = text
                else:
                    if len(sections) > 0 and sections[-1]['type'] == 'text':
                        sections[-1]['content'] += '\\n\\n' + text
                    else:
                        sections.append({'type': 'text', 'content': text})
                        
        results.append({
            'title': title,
            'date': '12 Ramadhan 1445 H',
            'sections': sections
        })
    except Exception as e:
        print(f"Error fetching {url}: {e}")

dart_code = ""
for item in results:
    dart_code += "    {\n"
    dart_code += f"      'title': '{item['title']}',\n"
    dart_code += f"      'date': '{item['date']}',\n"
    dart_code += "      'sections': [\n"
    for sec in item['sections']:
        dart_code += "        {\n"
        if sec['type'] == 'text':
            content = sec['content'].replace("'", "\\'").replace('\n', '\\n')
            dart_code += f"          'type': 'text',\n"
            dart_code += f"          'content': '{content}',\n"
        elif sec['type'] == 'arabic':
            content = sec['content'].replace("'", "\\'").replace('\n', '\\n')
            translation = sec['translation'].replace("'", "\\'").replace('\n', '\\n')
            dart_code += f"          'type': 'arabic',\n"
            dart_code += f"          'content': '{content}',\n"
            dart_code += f"          'latin': '',\n"
            if translation:
                dart_code += f"          'translation': '{translation}',\n"
        dart_code += "        },\n"
    dart_code += "      ]\n"
    dart_code += "    },\n"

with open('kultum_parsed2.txt', 'w', encoding='utf-8') as f:
    f.write(dart_code)
print("Parsing complete")
