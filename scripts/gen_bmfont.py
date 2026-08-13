from PIL import Image, ImageDraw, ImageFont
import os

font_path = "resources/fonts/MaterialIconsOutlined-Regular.otf"
size = 36
chars = {
    'steps': '\ue536',              # directions_walk
    'distance': '\ue55f',           # place
    'calories': '\uef55',           # local_fire_department
    'floors': '\uf1a9',             # stairs
    'heartrate': '\ue87d',          # favorite
    'stress': '\uea0b',             # bolt
    'battery': '\ue1a4',            # battery_full
    'seconds': '\ue425',            # timer
    'time': '\ue192',               # access_time
    'date': '\ue935',               # calendar_today
    'body_battery': '\ue1a3',       # battery_charging_full
    'hrv': '\ueaa2',                # monitor_heart
    'resting_hr': '\uef44',         # bedtime
    'pulse_ox': '\uefe4',           # bloodtype
    'training_readiness': '\uf0cf', # model_training
    'recovery_time': '\ue8b3',      # restore
    'vo2_max': '\uefd8',            # air
    'training_status': '\ue8e5',    # trending_up
    'acute_load': '\ueb43',         # fitness_center
    'endurance_score': '\ue566',    # directions_run
    'hill_score': '\ue564',         # terrain
    'intensity_minutes': '\ue9e4',  # speed
    'altitude': '\uea16',           # height
    'temperature': '\uf076',        # thermostat
    'weather': '\ue2bd',            # cloud
    'sunrise': '\ue1c6',            # wb_twilight
    'sunset': '\uea46',             # nights_stay
    'moon_phase': '\ue51c',         # dark_mode
    'phone_battery': '\ue32c',      # smartphone
    'bluetooth': '\ue1a7'           # bluetooth
}

font = ImageFont.truetype(font_path, size)
# Measure max height
max_h = 0
for name, char in chars.items():
    bbox = font.getbbox(char)
    max_h = max(max_h, bbox[3] - bbox[1])

# We will put them side by side
total_w = sum([font.getbbox(char)[2] - font.getbbox(char)[0] + 4 for name, char in chars.items()])
atlas = Image.new('RGBA', (total_w, max_h + 4), (0, 0, 0, 0))
draw = ImageDraw.Draw(atlas)

fnt_lines = [
    f'info face="icomoon" size={size} bold=0 italic=0 charset="" unicode=1 stretchH=100 smooth=1 aa=1 padding=0,0,0,0 spacing=1,1 outline=0',
    f'common lineHeight={size} base={size} scaleW={total_w} scaleH={max_h+4} pages=1 packed=0 alphaChnl=1 redChnl=0 greenChnl=0 blueChnl=0',
    'page id=0 file="metrics_icons.png"',
    f'chars count={len(chars)}'
]

x = 0
for name, char in chars.items():
    bbox = font.getbbox(char)
    w = bbox[2] - bbox[0]
    h = bbox[3] - bbox[1]
    # Draw character (white)
    draw.text((x - bbox[0], 2 - bbox[1]), char, font=font, fill=(255, 255, 255, 255))
    
    char_id = ord(char)
    fnt_lines.append(f'char id={char_id} x={x} y={2} width={w} height={h} xoffset={0} yoffset={0} xadvance={w+2} page=0 chnl=15')
    
    x += w + 4

atlas.save("resources/fonts/metrics_icons.png")
with open("resources/fonts/metrics_icons.fnt", 'w') as f:
    f.write("\n".join(fnt_lines))

print("BMFont generated!")
