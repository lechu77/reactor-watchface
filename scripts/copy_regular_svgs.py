import os
import re

source_dir = "/Users/z0051syf/Temp/phosphor-icons/SVGs/regular/"
dest_dir = "resources/drawables/"

mapping = {
    "icon_steps.svg": "sneaker.svg",
    "icon_distance.svg": "map-pin.svg",
    "icon_calories.svg": "fire.svg",
    "icon_floors.svg": "stairs.svg"
}

for dest_name, src_name in mapping.items():
    src_path = os.path.join(source_dir, src_name)
    dest_path = os.path.join(dest_dir, dest_name)
    
    if os.path.exists(src_path):
        with open(src_path, 'r') as file:
            content = file.read()
        
        # Replace currentColor with #FFFFFF for stroke and fill
        content = content.replace('stroke="currentColor"', 'stroke="#FFFFFF"')
        content = content.replace('fill="currentColor"', 'fill="#FFFFFF"')
        
        # Strip any existing width/height from <svg> just in case
        content = re.sub(r'<svg([^>]*)width="[^"]*"', r'<svg\1', content)
        content = re.sub(r'<svg([^>]*)height="[^"]*"', r'<svg\1', content)
        
        # Inject width=40 height=40
        content = content.replace('<svg ', '<svg width="40" height="40" ')
            
        with open(dest_path, 'w') as file:
            file.write(content)
        print(f"Copied {src_name} to {dest_name}")

print("SVGs copied and processed.")
