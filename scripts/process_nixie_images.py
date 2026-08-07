import os
from PIL import Image, ImageDraw, ImageFilter, ImageEnhance, ImageChops

def process_image(filepath, output_path):
    print(f"Processing {filepath}...")
    try:
        # Load as RGB since original images have no alpha (opaque black background)
        img = Image.open(filepath).convert("RGB")
        width, height = img.size
        
        # 1. Create Bloom/Glow (Blur the image and add it to itself)
        blur1 = img.filter(ImageFilter.GaussianBlur(radius=2))
        blur2 = img.filter(ImageFilter.GaussianBlur(radius=6))
        
        # Combine the original with blurs
        # scale > 1 means it dims it slightly before adding (e.g. scale=1.5 means /1.5)
        glow = ImageChops.add(img, blur1, scale=1.1)
        glow = ImageChops.add(glow, blur2, scale=1.4)
        
        # 2. Add unlit filament background
        # Find the bounding box of the non-black pixels
        grey = img.convert("L")
        mask = grey.point(lambda p: 255 if p > 5 else 0)
        bbox = mask.getbbox()
        
        # Create base image with black background
        final = Image.new("RGB", (width, height), (0, 0, 0))
        if bbox:
            # Draw dark red filament background
            fil_draw = ImageDraw.Draw(final)
            # Expand bbox slightly
            x1, y1, x2, y2 = bbox
            pad = 2
            x1, y1 = max(0, x1-pad), max(0, y1-pad)
            x2, y2 = min(width, x2+pad), min(height, y2+pad)
            fil_draw.rectangle([x1, y1, x2, y2], fill=(20, 5, 0))
            
        # Add glow on top of background
        final = ImageChops.add(final, glow)
        
        # 3. Apply Hex/Grid mesh OVER the lit parts
        # Create a black grid with transparent background
        mesh = Image.new("RGBA", (width, height), (0, 0, 0, 0))
        draw = ImageDraw.Draw(mesh)
        
        # Draw a fine grid (smaller for small digits, larger for big digits)
        grid_spacing = 3 if width > 20 else 2
        for y in range(0, height, grid_spacing):
            draw.line([(0, y), (width, y)], fill=(0, 0, 0, 100), width=1)
        for x in range(0, width, grid_spacing):
            draw.line([(x, 0), (x, height)], fill=(0, 0, 0, 100), width=1)
            
        # Composite mesh over final
        final.paste(mesh, (0, 0), mesh)
        
        final.save(output_path, "PNG")
    except Exception as e:
        print(f"Failed to process {filepath}: {e}")

def main():
    dirs = ["resources/drawables/vfd", "resources/drawables/vfd_small"]
    for d in dirs:
        if not os.path.exists(d):
            continue
        for f in os.listdir(d):
            if f.endswith(".png"):
                filepath = os.path.join(d, f)
                process_image(filepath, filepath)

if __name__ == "__main__":
    main()
