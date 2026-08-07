import os
import cairosvg

def fix_icons():
    directory = "resources/drawables"
    if not os.path.exists(directory):
        print(f"Directory {directory} not found.")
        return
        
    for filename in os.listdir(directory):
        if filename.endswith(".svg"):
            svg_path = os.path.join(directory, filename)
            png_path = os.path.join(directory, filename.replace(".svg", ".png"))
            
            try:
                # Re-export all SVGs to PNGs to bypass any dataless/corrupted PNG files
                print(f"Exporting {svg_path} to {png_path}...")
                cairosvg.svg2png(url=svg_path, write_to=png_path)
            except Exception as e:
                print(f"Error exporting {svg_path}: {e}")

if __name__ == "__main__":
    fix_icons()
