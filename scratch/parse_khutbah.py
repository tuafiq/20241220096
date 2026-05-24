import os
import re
from bs4 import BeautifulSoup

def clean_arabic(text):
    text = text.replace("بِإِحْsanٍ", "بِإِحْسَانٍ")
    text = text.replace("أُعِدَّtِ", "أُعِدَّتْ")
    text = text.replace("Fَحْشَاءِ", "الْفَحْشَاءِ")
    text = text.replace("وَلَذِkrُ", "وَلَذِكْرُ")
    text = text.replace("أَكْبَرُاللهُ أ٣×", "اللهُ أَكْبَرُ ٣×")
    text = text.replace("أَكْبَرُاللهُ أ٣", "اللهُ أَكْبَرُ ٣")
    
    # Use negative lookahead to only replace if NOT followed by 'ر'
    text = re.sub(r'وَقِنَا عَذَابَ النَّا(?!ر)', 'وَقِنَا عَذَابَ النَّارِ', text)
    
    # Clean up double space / tab/ extra newlines
    text = re.sub(r'\s+', ' ', text).strip()
    return text

def clean_text(text):
    text = text.replace("namعng", "namung")
    text = text.replace("Allah SAW.", "Allah SWT.")
    text = text.replace("Allah SAW ", "Allah SWT ")
    return text

def parse_html_file(file_path, fixed_date):
    with open(file_path, "r", encoding="utf-8") as f:
        html = f.read()
    
    if "---" in html:
        html = html.split("---", 1)[1]
        
    soup = BeautifulSoup(html, "html.parser")
    
    # Title
    title_tag = soup.find("h1")
    title = title_tag.get_text(strip=True) if title_tag else "Unknown Title"
    
    # Content
    content_div = soup.find("div", class_="article-content")
    if not content_div:
        content_div = soup.find("article")
        
    if not content_div:
        return None
        
    sections = []
    current_text_block = []
    
    def flush_text_block():
        nonlocal current_text_block
        if current_text_block:
            text = "\n\n".join(current_text_block).strip()
            if text:
                sections.append({
                    "type": "text",
                    "content": clean_text(text)
                })
            current_text_block = []

    # Get all relevant tags
    tags = content_div.find_all(["p", "h2", "h3", "blockquote", "ul", "ol"])
    
    for child in tags:
        text_content = child.get_text().strip()
        if not text_content:
            continue
            
        # Clean extra whitespace within paragraph
        text_content = re.sub(r'[ \t\r\f\v]+', ' ', text_content).strip()
        
        # Check if it has arabic class or contains significant Arabic character density
        is_arabic = False
        classes = child.get("class", [])
        if "arabic" in classes or (child.get("style") and "right" in child.get("style")):
            is_arabic = True
            
        # Check Arabic character ratio
        arabic_chars = len(re.findall(r'[\u0600-\u06FF]', text_content))
        if len(text_content) > 0 and (arabic_chars / len(text_content)) > 0.25:
            is_arabic = True
            
        if is_arabic:
            flush_text_block()
            cleaned = clean_arabic(text_content)
            sections.append({
                "type": "arabic",
                "content": cleaned,
                "latin": "",
                "translation": ""
            })
        else:
            # Check translation pattern
            is_translation = False
            lower_text = text_content.lower()
            if lower_text.startswith("artinya") or lower_text.startswith("maknanya") or lower_text.startswith("artosipun"):
                is_translation = True
                
            if is_translation:
                # Attach to last Arabic block if available
                if sections and sections[-1]["type"] == "arabic" and not sections[-1]["translation"]:
                    sections[-1]["translation"] = clean_text(text_content)
                else:
                    flush_text_block()
                    sections.append({
                        "type": "text",
                        "content": clean_text(text_content)
                    })
            elif child.name in ["h2", "h3"]:
                flush_text_block()
                sections.append({
                    "type": "text",
                    "content": clean_text(text_content)
                })
            else:
                current_text_block.append(text_content)
                
    flush_text_block()
    
    return {
        "title": title,
        "date": fixed_date,
        "sections": sections
    }

def format_to_dart(khutbah):
    dart = []
    dart.append("    {")
    dart.append(f"      'title': '{khutbah['title']}',")
    dart.append(f"      'date': '{khutbah['date']}',")
    dart.append("      'sections': [")
    
    for s in khutbah['sections']:
        # Escape $ for Dart interpolation
        content_esc = s['content'].replace('$', '\\$').replace("'''", "\\'\\'\\'")
        dart.append("        {")
        dart.append(f"          'type': '{s['type']}',")
        dart.append(f"          'content': '''{content_esc}''',")
        
        if s['type'] == 'arabic':
            latin_esc = s.get('latin', '').replace('$', '\\$').replace("'''", "\\'\\'\\'")
            trans_esc = s.get('translation', '').replace('$', '\\$').replace("'''", "\\'\\'\\'")
            dart.append(f"          'latin': '''{latin_esc}''',")
            dart.append(f"          'translation': '''{trans_esc}''',")
            
        dart.append("        },")
        
    dart.append("      ]")
    dart.append("    },")
    return "\n".join(dart)

files = [
    ("khutbah_16.html", "Ramadhan 1445 H"),
    ("khutbah_17.html", "Ramadhan 1445 H"),
    ("khutbah_18.html", "Ramadhan 1445 H"),
    ("khutbah_19.html", "Ramadhan 1445 H"),
    ("khutbah_20.html", "Ramadhan 1445 H")
]
base_dir = r"d:\uas\scratch\raw_html"

all_dart_blocks = []

for filename, date in files:
    path = os.path.join(base_dir, filename)
    res = parse_html_file(path, date)
    if res:
        dart_code = format_to_dart(res)
        all_dart_blocks.append(dart_code)

output_path = r"d:\uas\scratch\dart_output_4.txt"
with open(output_path, "w", encoding="utf-8") as out:
    out.write("\n".join(all_dart_blocks))

print("Successfully generated Dart output 4 in:", output_path)
