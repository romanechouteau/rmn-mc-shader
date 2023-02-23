#version 120

varying vec2 TexCoords;

uniform sampler2D colortex0;

void main() {
    vec3 Color = texture2D(colortex0, TexCoords).rgb;

    // gamma correction
    gl_FragColor = vec4(pow(Color, vec3(1.0f / 2.2f)), 1.0f);
}