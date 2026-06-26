import os

def replace_in_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    content = content.replace('0xFF00ACC1', '0xFF059669')
    content = content.replace('Colors.cyan.shade800', 'Colors.green.shade800')
    content = content.replace('PdfColors.cyan900', 'PdfColors.green900')
    content = content.replace('PdfColors.cyan800', 'PdfColors.green800')

    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated: {filepath}")

def main():
    lib_dir = 'lib'
    for root, dirs, files in os.walk(lib_dir):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                replace_in_file(filepath)

if __name__ == '__main__':
    main()
