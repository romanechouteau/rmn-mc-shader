#version 120

varying vec2 TexCoords;

uniform sampler2D colortex0;

#define BLOOM_INTENSITY 0.8
#define BLOOM_THRESHOLD 0.0
#define TEXTURE_RESOLUTION 2048

vec4 bloom(vec4 baseColor, vec4 blendColor) {
    return baseColor + blendColor * blendColor.a;
}

vec4 blur9(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {
    vec4 color = vec4(0.0);
    vec2 off1 = vec2(2.0) * direction;
    vec2 off2 = vec2(4.0) * direction;
    vec2 off3 = vec2(8.0) * direction;
    color += texture2D(image, uv) * 0.10;
    color += texture2D(image, uv + (off1 / resolution)) * 0.15;
    color += texture2D(image, uv - (off1 / resolution)) * 0.15;
    color += texture2D(image, uv + (off2 / resolution)) * 0.05;
    color += texture2D(image, uv - (off2 / resolution)) * 0.05;
    color += texture2D(image, uv + (off3 / resolution)) * 0.03;
    color += texture2D(image, uv - (off3 / resolution)) * 0.03;
    return color;
}

void main() {
    vec4 Color = texture2D(colortex0, TexCoords);

    vec4 bloomBlur = blur9(colortex0, TexCoords, vec2(TEXTURE_RESOLUTION), vec2(1.0, 0.0)) +
        blur9(colortex0, TexCoords, vec2(TEXTURE_RESOLUTION), vec2(0.0, 1.0));
    bloomBlur *= BLOOM_INTENSITY;
    vec4 BloomColor = bloom(Color, bloomBlur);

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = mix(Color, BloomColor, smoothstep(BLOOM_THRESHOLD - 0.2, BLOOM_THRESHOLD, length(BloomColor.rgb)));
}