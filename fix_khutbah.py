import re

with open(r'd:\uas\lib\khutbah_data.dart.txt', 'r', encoding='utf-8') as f:
    text = f.read()

# Fix the 4-quotes issue by adding a space:
text = text.replace("teruskanlah.''''", "teruskanlah.' '''")

with open(r'd:\uas\lib\ramadhan_page.dart', 'r', encoding='utf-8') as f:
    content = f.read()

start_marker = '  final List<Map<String, dynamic>> _khutbahMenu = ['
end_marker = '  final List<Map<String, dynamic>> _ramadhanMenu = ['

start_idx = content.find(start_marker)
end_idx = content.find(end_marker)

if start_idx != -1 and end_idx != -1:
    new_content = content[:start_idx] + text + '\n' + content[end_idx:]
    with open(r'd:\uas\lib\ramadhan_page.dart', 'w', encoding='utf-8') as f:
        f.write(new_content)
    print('Fixed and replaced _khutbahMenu.')
else:
    print('Markers not found')
