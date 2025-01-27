shader_type canvas_item;

uniform sampler2D texture_albedo; // The texture applied to the TextureRect
uniform float time : hint_range(0, 100); // Uniform for the current time

const int ITER_DIST = 16;

// Random number generator
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Glitch wave function
float glitchWave(float ttime) {
    // Generate a random pulse every 1 to 2 seconds
    float interval = floor(ttime) + random(vec2(floor(ttime), 0.0)); // Random offset for timing
    return step(0.99, fract(ttime - interval)) * smoothstep(0.0, 0.5, fract(ttime - interval)); // Wave shape
}

// Big glitch wave function (occurs every 3–5 seconds)
float bigGlitchWave(float ttime) {
    // Generate a random pulse every 3 to 5 seconds
    float interval = floor(ttime / 3.0) + random(vec2(floor(ttime / 3.0), 1.0)); // Longer random interval
    return step(0.99, fract(ttime - interval * 3.0)) * smoothstep(0.0, 0.5, fract(ttime - interval * 3.0)); // Wave shape
}

// Sparse distortion function
vec2 distort(vec2 uv, float ttime, float glitch_wave_active, float big_glitch_wave_active) {
    // Make distortions sparse and amplify during glitch wave and big glitch wave
    float row_random = random(vec2(floor(uv.y * 20.0), ttime * 10.0));
    float apply_distortion = step(0.9, row_random); // Only apply to 10% of rows normally

    float base_distortion = random(vec2(uv.y * 100.0, ttime * 10.0)) * 0.04 - 0.02;
    float wave_distortion = glitch_wave_active * (random(vec2(uv.y * 50.0, ttime)) * 0.2 - 0.1); // Amplified glitch
    float big_wave_distortion = big_glitch_wave_active * (random(vec2(uv.y * 50.0, ttime)) * 0.6 - 0.3); // Bigger glitch

    float final_distortion = base_distortion * (1.0 - glitch_wave_active - big_glitch_wave_active)
                           + wave_distortion * (1.0 - big_glitch_wave_active)
                           + big_wave_distortion;
    return vec2(uv.x + final_distortion * apply_distortion, uv.y);
}

// Chromatic aberration function
vec3 chromaticAberration(vec2 uv, float ttime, float glitch_wave_active, float big_glitch_wave_active) {
    // Separate red, green, and blue channels with stronger offsets during glitch waves
    float red_offset = 0.002 * (1.0 + glitch_wave_active * 10.0 + big_glitch_wave_active * 20.0) * sin(ttime * 2.0);
    float blue_offset = -0.002 * (1.0 + glitch_wave_active * 10.0 + big_glitch_wave_active * 20.0) * sin(ttime * 2.0);
    float green_offset = 0.0;

    float r = texture(texture_albedo, distort(uv + vec2(red_offset, 0.0), ttime, glitch_wave_active, big_glitch_wave_active)).r;
    float g = texture(texture_albedo, distort(uv + vec2(green_offset, 0.0), ttime, glitch_wave_active, big_glitch_wave_active)).g;
    float b = texture(texture_albedo, distort(uv + vec2(blue_offset, 0.0), ttime, glitch_wave_active, big_glitch_wave_active)).b;

    return vec3(r, g, b);
}

// Main function to apply the effect
vec3 standardAberration(vec2 uv, float ttime) {
    // Determine if glitch wave and big glitch wave are active
    float glitch_wave_active = glitchWave(ttime);
    float big_glitch_wave_active = bigGlitchWave(ttime);

    const float step_size = 1.0 / float(ITER_DIST - 1);
    float t = step_size;

    vec3 sum_color = vec3(0.0);
    vec3 sum_weight = vec3(0.0);

    for (int i = 0; i < ITER_DIST; ++i) {
        vec3 weight = vec3(1.0); // Even weight for sharper glitches
        sum_weight += weight;
        sum_color += weight * chromaticAberration(uv, ttime, glitch_wave_active, big_glitch_wave_active);
        t += step_size;
    }

    return sum_color / sum_weight;
}

// Fragment function
void fragment() {
    vec2 uv = UV; // Use proper UV mapping
    vec3 col = standardAberration(uv, time);
    COLOR = vec4(col, 1.0);
}
