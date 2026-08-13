from PIL import Image

def resize_and_crop(image_path, output_path, target_width, target_height):
    with Image.open(image_path) as img:
        img_ratio = img.width / img.height
        target_ratio = target_width / target_height

        if target_ratio > img_ratio:
            # Target is wider than original (relative to height)
            # Resize by width, then crop height
            new_width = target_width
            new_height = int(new_width / img_ratio)
        else:
            # Target is taller than original (relative to width)
            # Resize by height, then crop width
            new_height = target_height
            new_width = int(new_height * img_ratio)

        # Resize the image using LANCZOS for high quality
        img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)

        # Calculate crop coordinates (center crop)
        left = (new_width - target_width) / 2
        top = (new_height - target_height) / 2
        right = (new_width + target_width) / 2
        bottom = (new_height + target_height) / 2

        # Crop and save
        img = img.crop((left, top, right, bottom))
        img.save(output_path)
        print(f"Image successfully resized and cropped to {target_width}x{target_height} and saved to {output_path}")

if __name__ == "__main__":
    resize_and_crop("assets/hero.png", "assets/hero.png", 1440, 720)
