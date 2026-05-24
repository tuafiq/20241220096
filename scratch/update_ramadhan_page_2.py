import os

def update_ramadhan_page():
    dart_file_path = r"d:\uas\lib\ramadhan_page.dart"
    dart_output_path = r"d:\uas\scratch\dart_output_3.txt"
    
    # Read the dart file
    with open(dart_file_path, "r", encoding="utf-8") as f:
        content = f.read()
        
    # Read the new khutbah maps (11 to 15)
    with open(dart_output_path, "r", encoding="utf-8") as f:
        new_khutbahs = f.read()
        
    # Find the start mark of _khutbahIdulFitriMenu
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
        
    # We want to replace the closing '];' (or the trailing whitespace and '];')
    # of the array with ',\n' + new_khutbahs + '\n  ];'
    # First, let's find the position of '  ];'
    list_end_idx = content.rfind("];", start_idx, end_idx)
    
    # Construct the replaced block
    # We replace from list_end_idx to list_end_idx + 2 (which is '];')
    replaced_list_end = ",\n" + new_khutbahs + "\n  ];"
    
    replaced_content = content[:list_end_idx] + replaced_list_end + content[list_end_idx + 2:]
    
    # Write back
    with open(dart_file_path, "w", encoding="utf-8") as f:
        f.write(replaced_content)
        
    print("Successfully appended Khutbah 11-15 to ramadhan_page.dart!")

if __name__ == "__main__":
    update_ramadhan_page()
