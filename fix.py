with open('lib/ramadhan_page.dart', 'r', encoding='utf-8') as f:
    code = f.read()

# Replace any occurrence of Ma\\'arif with Ma\'arif
code = code.replace("Ma\\\\'arif", "Ma\\'arif")

with open('lib/ramadhan_page.dart', 'w', encoding='utf-8') as f:
    f.write(code)
