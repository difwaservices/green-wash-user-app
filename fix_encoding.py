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
            except UnicodeDecodeError:
                continue
            
            if 'â‚¹' in content or 'ðŸ' in content or 'âˆž' in content or 'â€¢' in content:
                # Manual replacement for safety and to avoid cp1252 encode errors on other characters
                new_content = content.replace('â‚¹', '₹')
                new_content = new_content.replace('ðŸ”¥', '🔥')
                new_content = new_content.replace('ðŸŒŸ', '🌟')
                new_content = new_content.replace('âˆž', '∞')
                new_content = new_content.replace('â€¢', '•')
                new_content = new_content.replace('â˜€ï¸', '☀️')
                new_content = new_content.replace('ðŸŒ™', '🌙')
                new_content = new_content.replace('ðŸ’§', '💧')
                new_content = new_content.replace('âœ¨', '✨')
                
                if new_content != content:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    count += 1
                    print(f"Fixed: {filepath}")

print(f"Total files fixed: {count}")
