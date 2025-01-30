shader_type canvas_item;

uniform float noise_intensity : hint_range(0.0, 1.0) = 1.0; // Strength of static
uniform float time : hint_range(0.0, 10.0); // Time for fade-in & shutdown effect
uniform float shutdown_time : hint_range(0.0, 10.0) = 5.0; // When the screen starts turning off

// Random static noise function
float random(vec2 uv) {
    return fract(sin(dot(uv.xy + time, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    vec2 uv = UV;

    // Generate static noise
    float noise = random(uv * 100.0) * noise_intensity;

    // Linear fade-in effect (0 at time=0, fully visible at time=3)
    float fade_in = clamp(time / 3.0, 0.0, 1.0);

    // Shutdown progress (starts after `shutdown_time`)
    float shutdown_progress = clamp((time - shutdown_time) / 2.0, 0.0, 1.0);

    // Vertical squish (first phase)
    float vertical_squish = mix(1.0, 0.1, shutdown_progress);
    uv.y = (uv.y - 0.5) / vertical_squish + 0.5;

    // Horizontal squish (second phase)
    float horizontal_squish = mix(1.0, 0.1, pow(shutdown_progress, 2.0));
    uv.x = (uv.x - 0.5) / horizontal_squish + 0.5;

    // Apply noise only if UV is in valid range (prevent stretching artifacts)
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        noise = 0.0;
    }

    // Once fully shut down, hold black screen and keep it opaque
    float is_black_screen = step(1.0, shutdown_progress); // 1 when shutdown is complete

    // Ensure alpha stays at 1 after shutdown
    float alpha = mix(fade_in, 1.0, is_black_screen);
    vec3 color = mix(vec3(noise), vec3(0.0), is_black_screen);

    COLOR = vec4(color, alpha);
}
