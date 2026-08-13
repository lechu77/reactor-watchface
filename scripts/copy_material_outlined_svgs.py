import os
import re

source_base = "/Users/z0051syf/Temp/material-design-icons/src"
dest_dir = "resources/drawables/"

mapping = {
    "icon_steps.svg": "maps/directions_walk/materialiconsoutlined/24px.svg",
    "icon_distance.svg": "maps/place/materialiconsoutlined/24px.svg",
    "icon_calories.svg": "social/local_fire_department/materialiconsoutlined/24px.svg",
    "icon_floors.svg": "editor/insert_chart_outlined/materialiconsoutlined/24px.svg"
}

# Wait, bar_chart vs insert_chart_outlined? The user probably wants bar_chart, let's stick to bar_chart but wait, my previous find output:
# /Users/z0051syf/Temp/material-design-icons/src/maps/local_fire_department (wait, maps not social?)
# /Users/z0051syf/Temp/material-design-icons/src/maps/place
# /Users/z0051syf/Temp/material-design-icons/src/editor/bar_chart

mapping = {
    "icon_steps.svg": "maps/directions_walk/materialiconsoutlined/24px.svg",
    "icon_distance.svg": "maps/place/materialiconsoutlined/24px.svg",
    "icon_calories.svg": "maps/local_fire_department/materialiconsoutlined/24px.svg",
    "icon_floors.svg": "editor/bar_chart/materialiconsoutlined/24px.svg"
}

for dest_name, src_rel in mapping.items():
    src_path = os.path.join(source_base, src_rel)
    dest_path = os.path.join(dest_dir, dest_name)
    
    if os.path.exists(src_path):
        with open(src_path, 'r') as file:
            content = file.read()
        
        # Remove background path which has fill="none"
        content = re.sub(r'<path[^>]*fill="none"[^>]*/>', '', content)
        
        # Replace existing fill just in case
        content = re.sub(r'fill="[^"]+"', '', content)
        
        # Force all paths to have fill="#FFFFFF"
        content = content.replace('<path', '<path fill="#FFFFFF"')
        
        # Change width and height to 40
        content = re.sub(r'width="[^"]+"', 'width="40"', content)
        content = re.sub(r'height="[^"]+"', 'height="40"', content)

        with open(dest_path, 'w') as file:
            file.write(content)
        print(f"Copied and processed {src_rel} to {dest_name}")
    else:
        print(f"NOT FOUND: {src_path}")

print("Material Outlined SVGs copied.")
