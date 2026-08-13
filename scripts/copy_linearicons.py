import os
import re

source_dir = "/Users/z0051syf/Temp/Linearicons-Free-v1.0.0/SVG/"
dest_dir = "resources/drawables/"

# Linearicons Free doesn't have fire or steps, using approximations:
# flag for steps, map-marker for distance, heart for calories, chart-bars for floors
mapping = {
    "icon_steps.svg": "flag.svg",
    "icon_distance.svg": "map-marker.svg",
    "icon_calories.svg": "heart.svg",
    "icon_floors.svg": "chart-bars.svg"
}

for dest_name, src_name in mapping.items():
    src_path = os.path.join(source_dir, src_name)
    dest_path = os.path.join(dest_dir, dest_name)
    
    if os.path.exists(src_path):
        with open(src_path, 'r') as file:
            content = file.read()
        
        # Replace colors
        content = content.replace('stroke="currentColor"', 'stroke="#FFFFFF"')
        content = content.replace('fill="currentColor"', 'fill="#FFFFFF"')
        content = content.replace('fill="#000000"', 'fill="#FFFFFF"')
        
        # Strip existing width/height
        content = re.sub(r'<svg([^>]*)width="[^"]*"', r'<svg\1', content)
        content = re.sub(r'<svg([^>]*)height="[^"]*"', r'<svg\1', content)
        
        # Inject width=40 height=40
        content = content.replace('<svg ', '<svg width="40" height="40" fill="#FFFFFF" ')
            
        with open(dest_path, 'w') as file:
            file.write(content)
        print(f"Copied {src_name} to {dest_name}")

print("Linearicons SVGs copied.")
