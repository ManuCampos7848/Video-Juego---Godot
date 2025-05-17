shader_type canvas_item;

uniform vec4 skin_color : source_color = vec4(1.0);
uniform float fill_expand : hint_range(0, 0.1) = 0.01;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Detecta bordes (color oscuro)
    if (tex_color.a > 0.0 && (tex_color.r + tex_color.g + tex_color.b) < 2.8) {
        COLOR = tex_color;
    } 
    // Detecta área para rellenar
    else {
        // Muestrea alrededor para detectar bordes cercanos
        vec4 up = texture(TEXTURE, UV + vec2(0.0, -fill_expand));
        vec4 down = texture(TEXTURE, UV + vec2(0.0, fill_expand));
        vec4 left = texture(TEXTURE, UV + vec2(-fill_expand, 0.0));
        vec4 right = texture(TEXTURE, UV + vec2(fill_expand, 0.0));
        
        if (up.a > 0.0 || down.a > 0.0 || left.a > 0.0 || right.a > 0.0) {
            COLOR = skin_color;
        } else {
            COLOR = vec4(0.0);
        }
    }
}