import os
import urllib.request

urls = {
    "6": "https://islam.nu.or.id/khutbah/khutbah-idul-fitri-bahasa-jawa-ganjaran-kamulyan-ngapuran-ngapuranan-lan-nepung-paseduluran-hmWBc",
    "7": "https://islam.nu.or.id/khutbah/khutbah-idul-fitri-bahasa-arab-1444-h-7KF9T",
    "8": "https://islam.nu.or.id/khutbah/khutbah-idul-fitri-membangun-peradaban-melalui-persatuan-dan-solidaritas-08Kuh",
    "9": "https://islam.nu.or.id/khutbah/khutbah-idul-fitri-hari-raya-fitri-dan-sikap-memaafkan-gjHJG",
    "10": "https://islam.nu.or.id/khutbah/khutbah-idul-fitri-merajut-tali-persaudaraan-di-hari-raya-idul-fitri-ZC0FZ"
}

output_dir = r"d:\uas\scratch\raw_html"
os.makedirs(output_dir, exist_ok=True)

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
}

for num, url in urls.items():
    print(f"Downloading Khutbah {num} from {url}...")
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as response:
            html = response.read().decode('utf-8')
            output_path = os.path.join(output_dir, f"khutbah_{num}.html")
            with open(output_path, "w", encoding="utf-8") as f:
                f.write(html)
            print(f"Successfully saved to {output_path}")
    except Exception as e:
        print(f"Error downloading Khutbah {num}: {e}")

print("All downloads finished.")
