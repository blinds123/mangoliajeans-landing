import os

def parse_config(config_path):
    config = {}
    if not os.path.exists(config_path):
        return config
    
    with open(config_path, 'r') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            if '=' in line:
                key, value = line.split('=', 1)
                # Strip quotes if present
                value = value.strip('"').strip("'")
                config[key.strip()] = value
    return config

def generate_size_options(sizes_str, sold_out_str):
    if not sizes_str:
        return '<option value="">Select Size</option>'
    
    sizes = [s.strip() for s in sizes_str.split(',') if s.strip()]
    sold_out = [s.strip() for s in sold_out_str.split(',') if s.strip()] if sold_out_str else []
    
    options = ['<option value="">Select Size</option>']
    
    for size in sizes:
        label = size
        # Add weights if needed, or keeping it simple for now as requested by user "sold out next to it"
        # User request: "sizing options will be from xxs to xxxl and these sizes will have sold out next to it"
        # We will append (Sold Out) to the label if it's in the list
        
        if size in sold_out:
            label = f"{size} (Sold Out)"
            # Optionally disabled? User didn't specify, but usually sold out means disabled or strictly labelled.
            # I will disable it ensuring they can't select it, or just label it. 
            # Best practice: disable it.
            options.append(f'<option value="{size}" disabled>{label}</option>')
        else:
            # Add presumed weight guides based on typical fashion if needed?
            # User didn't strictly ask for weight guides on new sizes, but the old template had them.
            # To be safe and generic, I will omit weight guides for the generic template unless defined.
            # But wait, the user liked the "fashion template" specificness.
            # Let's just output the Size Name for now to be safe and generic.
            options.append(f'<option value="{size}">{label}</option>')
            
    return '\n'.join(options)

def generate_color_swatches(colors_str):
    # Format: "Name=Hex|Image, Name2=Hex2|Image2"
    if not colors_str:
        return ''
        
    items = [c.strip() for c in colors_str.split(',')]
    swatches = []
    
    first_color_name = "Select"
    
    for i, item in enumerate(items):
        try:
            # Parse Name=Rest
            name, rest = item.split('=')
            # Parse Hex|Image
            hex_code, img_file = rest.split('|')
            
            if i == 0:
                first_color_name = name
            
            # Extract Image Number for data-img
            img_num = '01'
            if 'product-' in img_file:
                img_num = img_file.split('product-')[1].split('.')[0]
            
            active_class = ' active' if i == 0 else ''
            
            html = f"""<div class="swatch{active_class}" data-color="{name}" data-img="{img_num}"
    style="width: 28px; height: 28px; border-radius: 50%; background: {hex_code}; cursor: pointer; border: 1px solid #ddd; box-shadow: 0 0 0 2px #fff inset;">
</div>"""
            swatches.append(html)
        except Exception as e:
            print(f"Error parsing color variant: {item} -> {e}")
            continue
            
    swatches_html = '\n'.join(swatches)
    
    # Return the FULL BLOCK
    return f"""
    <div style="margin-top: 8px;" class="color-selector-container">
      <label style="font-size: 11px; font-weight: 700; color: #666; display: block; margin-bottom: 4px;">
        SELECT COLOR: <span id="color-label-single" style="color:#000;">{first_color_name}</span>
      </label>
      <div class="color-swatches" style="display: flex; gap: 8px;">
        {swatches_html}
      </div>
    </div>
    """

def generate_js_map(colors_str):
    if not colors_str:
        return '{}'
        
    items = [c.strip() for c in colors_str.split(',')]
    js_map_entries = []
    
    for item in items:
        try:
            name, rest = item.split('=')
            hex_code, img_file = rest.split('|')
            # 'Mauve Rose': 'images/product/product-05.webp'
            js_map_entries.append(f"'{name}': 'images/product/{img_file}'")
        except:
            continue
            
    return "{\n          " + ",\n          ".join(js_map_entries) + "\n        }"

def main():
    config = parse_config('product.config')
    
    sizes = config.get('SIZES', '')
    sold_out = config.get('SOLD_OUT_SIZES', '')
    colors = config.get('COLORS', '')
    
    size_options = generate_size_options(sizes, sold_out)
    color_swatches = generate_color_swatches(colors)
    color_image_map = generate_js_map(colors)
    
    # Write to variants.config
    with open('variants.config', 'w') as f:
        # Replaces double quotes with escaped double quotes for bash
        safe_size = size_options.replace('"', '\\"')
        safe_swatches = color_swatches.replace('"', '\\"')
        
        # Replace newlines with space to keep it on one line for simple bash sourcing
        one_line_size = safe_size.replace('\n', ' ')
        one_line_swatches = safe_swatches.replace('\n', ' ')
        
        f.write(f'SIZE_OPTIONS="{one_line_size}"\n')
        f.write(f'COLOR_UI_HTML="{one_line_swatches}"\n')
        f.write(f'COLOR_IMAGE_MAP="{color_image_map.replace(chr(10), " ")}"\n')
        
    print("✅ variants.config generated")

if __name__ == "__main__":
    main()
