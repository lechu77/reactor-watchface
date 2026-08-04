import os
from PIL import Image, ImageDraw, ImageFilter

# Configuration
W, H = 54, 100  # Size of each character cell (46x92 + padding)
T = 9           # Segment thickness
C = T - 1       # Chamfer
PAD = 4         # Inner padding
COLS = 11       # 0-9 and Colon
IMG_W = W * COLS
IMG_H = H

ACTIVE_COLOR = (100, 255, 255, 255)  # Soft cyan
BLOOM_COLOR = (0, 200, 255, 255)     # Cyan glow
UNLIT_COLOR = (20, 30, 30, 255)      # Dark glass/phosphor
BG_COLOR = (5, 10, 10, 255)          # Vacuum tube background
MESH_COLOR = (0, 0, 0, 180)          # Control grid shadow

DIGIT_MASKS = [
    0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
]

def draw_chamfered_segment(draw, mask_bit, mask, x, y, w, h, t, c, color):
    if not (mask & mask_bit):
        return
    half_h = h // 2
    poly = []
    if mask_bit == 0x01: # A
        poly = [(x+c, y), (x+w-c, y), (x+w-c*2, y+t), (x+c*2, y+t)]
    elif mask_bit == 0x02: # B
        poly = [(x+w, y+c), (x+w, y+half_h-c//2), (x+w-t, y+half_h-c), (x+w-t, y+c*2)]
    elif mask_bit == 0x04: # C
        poly = [(x+w, y+half_h+c//2), (x+w, y+h-c), (x+w-t, y+h-c*2), (x+w-t, y+half_h+c)]
    elif mask_bit == 0x08: # D
        poly = [(x+c, y+h), (x+w-c, y+h), (x+w-c*2, y+h-t), (x+c*2, y+h-t)]
    elif mask_bit == 0x10: # E
        poly = [(x, y+half_h+c//2), (x, y+h-c), (x+t, y+h-c*2), (x+t, y+half_h+c)]
    elif mask_bit == 0x20: # F
        poly = [(x, y+c), (x, y+half_h-c//2), (x+t, y+half_h-c), (x+t, y+c*2)]
    elif mask_bit == 0x40: # G
        poly = [(x+c, y+half_h), (x+c*2, y+half_h-t//2), (x+w-c*2, y+half_h-t//2), 
                (x+w-c, y+half_h), (x+w-c*2, y+half_h+t//2), (x+c*2, y+half_h+t//2)]
    if poly:
        draw.polygon(poly, fill=color)

def render_digit(char_index):
    img = Image.new('RGBA', (W, H), BG_COLOR)
    
    # Calculate bounding box for segments
    x = PAD
    y = PAD
    w = W - PAD*2
    h = H - PAD*2
    t = T
    c = C
    
    # Layers
    base_layer = Image.new('RGBA', (W, H), (0,0,0,0))
    glow_layer = Image.new('RGBA', (W, H), (0,0,0,0))
    draw_base = ImageDraw.Draw(base_layer)
    draw_glow = ImageDraw.Draw(glow_layer)
    
    # Draw colon
    if char_index == 10:
        dot_size = t + 1
        qx = x + w//2 - dot_size//2
        draw_base.rectangle([qx, y + h//4, qx+dot_size, y + h//4 + dot_size], fill=UNLIT_COLOR)
        draw_base.rectangle([qx, y + h*3//4, qx+dot_size, y + h*3//4 + dot_size], fill=UNLIT_COLOR)
        
        draw_glow.rectangle([qx, y + h//4, qx+dot_size, y + h//4 + dot_size], fill=BLOOM_COLOR)
        draw_glow.rectangle([qx, y + h*3//4, qx+dot_size, y + h*3//4 + dot_size], fill=BLOOM_COLOR)
        
        draw_base.rectangle([qx, y + h//4, qx+dot_size, y + h//4 + dot_size], fill=ACTIVE_COLOR)
        draw_base.rectangle([qx, y + h*3//4, qx+dot_size, y + h*3//4 + dot_size], fill=ACTIVE_COLOR)
    else:
        # Draw Unlit Segments
        for bit in [1, 2, 4, 8, 16, 32, 64]:
            draw_chamfered_segment(draw_base, bit, 0x7F, x, y, w, h, t, c, UNLIT_COLOR)
        
        # Draw Active Segments
        mask = DIGIT_MASKS[char_index]
        for bit in [1, 2, 4, 8, 16, 32, 64]:
            draw_chamfered_segment(draw_glow, bit, mask, x, y, w, h, t, c, BLOOM_COLOR)
            draw_chamfered_segment(draw_base, bit, mask, x, y, w, h, t, c, ACTIVE_COLOR)
    
    # Apply bloom
    glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(3))
    
    # Composite
    img.alpha_composite(glow_layer)
    img.alpha_composite(base_layer)
    
    # Draw Mesh Grid
    mesh_layer = Image.new('RGBA', (W, H), (0,0,0,0))
    draw_mesh = ImageDraw.Draw(mesh_layer)
    for ly in range(0, H, 3):
        draw_mesh.line([0, ly, W, ly], fill=MESH_COLOR, width=1)
    for lx in range(0, W, 3):
        draw_mesh.line([lx, 0, lx, H], fill=MESH_COLOR, width=1)
        
    # Draw filaments
    draw_mesh.line([0, h//3, W, h//3], fill=(0,0,0,200), width=1)
    draw_mesh.line([0, h*2//3, W, h*2//3], fill=(0,0,0,200), width=1)
    
    img.alpha_composite(mesh_layer)
    return img

def generate():
    out_dir = "resources/drawables/vfd"
    os.makedirs(out_dir, exist_ok=True)
    
    chars = [str(i) for i in range(10)] + ["colon"]
    
    xml_content = '<drawables>\n'
    
    for i, char in enumerate(chars):
        char_img = render_digit(i)
        filename = f"vfd_{char}.png"
        char_img.save(os.path.join(out_dir, filename))
        
        xml_content += f'    <bitmap id="Vfd{char.capitalize()}" filename="vfd/{filename}" />\n'
        
    xml_content += '</drawables>\n'
    
    with open("resources/drawables/vfd_drawables.xml", "w") as f:
        f.write(xml_content)
        
    print("VFD large images generated successfully.")

def generate_small():
    out_dir = "resources/drawables/vfd_small"
    os.makedirs(out_dir, exist_ok=True)
    
    # 10x18 + padding => let's use 16x24
    s_W, s_H = 16, 24
    s_T = 2
    s_C = 1
    s_PAD = 3
    
    chars = [str(i) for i in range(10)]
    
    xml_content = '<drawables>\n'
    
    for i, char in enumerate(chars):
        img = Image.new('RGBA', (s_W, s_H), BG_COLOR)
        
        x, y = s_PAD, s_PAD
        w, h = s_W - s_PAD*2, s_H - s_PAD*2
        
        base_layer = Image.new('RGBA', (s_W, s_H), (0,0,0,0))
        glow_layer = Image.new('RGBA', (s_W, s_H), (0,0,0,0))
        draw_base = ImageDraw.Draw(base_layer)
        draw_glow = ImageDraw.Draw(glow_layer)
        
        # Unlit
        for bit in [1, 2, 4, 8, 16, 32, 64]:
            draw_chamfered_segment(draw_base, bit, 0x7F, x, y, w, h, s_T, s_C, UNLIT_COLOR)
            
        # Lit
        mask = DIGIT_MASKS[i]
        for bit in [1, 2, 4, 8, 16, 32, 64]:
            draw_chamfered_segment(draw_glow, bit, mask, x, y, w, h, s_T, s_C, BLOOM_COLOR)
            draw_chamfered_segment(draw_base, bit, mask, x, y, w, h, s_T, s_C, ACTIVE_COLOR)
            
        glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(1))
        
        img.alpha_composite(glow_layer)
        img.alpha_composite(base_layer)
        
        # Draw Mesh Grid
        mesh_layer = Image.new('RGBA', (s_W, s_H), (0,0,0,0))
        draw_mesh = ImageDraw.Draw(mesh_layer)
        for ly in range(0, s_H, 2):
            draw_mesh.line([0, ly, s_W, ly], fill=MESH_COLOR, width=1)
        for lx in range(0, s_W, 2):
            draw_mesh.line([lx, 0, lx, s_H], fill=MESH_COLOR, width=1)
            
        # Draw filaments
        draw_mesh.line([0, h//2, s_W, h//2], fill=(0,0,0,180), width=1)
        
        img.alpha_composite(mesh_layer)
        
        filename = f"vfd_small_{char}.png"
        img.save(os.path.join(out_dir, filename))
        
        xml_content += f'    <bitmap id="VfdSmall{char.capitalize()}" filename="vfd_small/{filename}" />\n'
        
    xml_content += '</drawables>\n'
    
    with open("resources/drawables/vfd_small_drawables.xml", "w") as f:
        f.write(xml_content)
        
    print("VFD small images generated successfully.")

if __name__ == "__main__":
    generate()
    generate_small()
