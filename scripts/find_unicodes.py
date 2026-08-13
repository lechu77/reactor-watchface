from fontTools.ttLib import TTFont

font_path = "resources/fonts/MaterialIconsTwoTone-Regular.otf"
font = TTFont(font_path)
cmap = font['cmap'].getBestCmap()

search_terms = ['fire', 'location', 'steps', 'walk', 'stairs', 'bar', 'local_fire_department', 'place']
for code, name in cmap.items():
    for term in search_terms:
        if term in name.lower() or term in str(code):
            print(f"Name: {name}, Code: {hex(code)}")
