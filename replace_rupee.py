import os

target_dir = r"c:\Users\Dell\green_wash_co._flutter_app\lib"

count = 0
for root, dirs, files in os.walk(target_dir):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                if 'â‚¹' in content:
                    content = content.replace('â‚¹', '₹')
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(content)
                    count += 1
            except Exception as e:
                print(f"Error processing {filepath}: {e}")

print(f"Replaced in {count} files.")
