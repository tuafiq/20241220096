import os

def update_ramadhan_page():
    dart_file_path = r"d:\uas\lib\ramadhan_page.dart"
    dart_output_path = r"d:\uas\scratch\dart_output.txt"
    
    # Read the dart file
    with open(dart_file_path, "r", encoding="utf-8") as f:
        content = f.read()
        
    # Read the new khutbah maps
    with open(dart_output_path, "r", encoding="utf-8") as f:
        new_khutbahs = f.read()
        
    # Find the start mark
    start_pattern = "final List<Map<String, dynamic>> _khutbahIdulFitriMenu = ["
    start_idx = content.find(start_pattern)
    if start_idx == -1:
        print("Error: Could not find start pattern")
        return
        
    # Find the end mark (the start of the next variable _artikelMenu)
    end_pattern = "final List<Map<String, dynamic>> _artikelMenu = ["
    end_idx = content.find(end_pattern)
    if end_idx == -1:
        print("Error: Could not find end pattern")
        return
        
    # Find the closing bracket '];' of _khutbahIdulFitriMenu right before _artikelMenu
    # We search backwards from end_idx for '];'
    close_idx = content.rfind("];", start_idx, end_idx)
    if close_idx == -1:
        print("Error: Could not find closing bracket '];'")
        return
        
    # Extract the first khutbah from the original file (which lies between start_pattern and the closing bracket)
    # We want to keep the first khutbah map
    first_khutbah_start = content.find("{", start_idx + len(start_pattern), close_idx)
    first_khutbah_end = content.rfind("}", start_idx, close_idx)
    
    first_khutbah = content[first_khutbah_start : first_khutbah_end + 1]
    
    # Construct the new _khutbahIdulFitriMenu content
    # Combine first_khutbah and the new_khutbahs
    new_menu_content = f"\n  final List<Map<String, dynamic>> _khutbahIdulFitriMenu = [\n    {first_khutbah},\n{new_khutbahs}\n  ];\n\n  "
    
    # Replace in the original content
    replaced_content = content[:start_idx] + new_menu_content + content[end_idx:]
    
    # Write back
    with open(dart_file_path, "w", encoding="utf-8") as f:
        f.write(replaced_content)
        
    print("Successfully updated ramadhan_page.dart!")

if __name__ == "__main__":
    update_ramadhan_page()
