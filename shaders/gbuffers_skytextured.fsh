#version 120


uniform float viewWidth;
uniform float viewHeight;
uniform vec3 sunPosition;
uniform mat4 gbufferProjectionInverse;

#define SUN_FACTOR = 0.5

void main() {
    vec4 screenPos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z, 1.0);
    vec4 viewPos = gbufferProjectionInverse * (screenPos * 2.0 - 1.0);
    viewPos /= viewPos.w;

    vec3 position = normalize(viewPos.xyz);
    vec3 sunPos = normalize(sunPosition);
    vec3 moonPos = normalize(-sunPosition);

    float circleSun = clamp(0.5 - distance(position, sunPos) * 2., 0., 1.);
    float circleMoon = clamp(0.5 - distance(position, moonPos) * 3., 0., 1.);
    float alphaSun = smoothstep(0., 0.5, circleSun);
    float alphaMoon = smoothstep(0.1, 0.3, circleMoon);

    float alpha = clamp(alphaSun + alphaMoon, 0., 1.);

    gl_FragColor = vec4(vec3(alpha).rgb, 1.);
}