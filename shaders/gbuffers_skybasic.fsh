#version 120

uniform float viewWidth;
uniform float viewHeight;
uniform float sunAngle;
uniform vec3 sunPosition;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjectionInverse;

#include "sky.glsl"

void main() {
    vec4 screenPos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z, 1.0);
    vec4 viewPos = gbufferProjectionInverse * (screenPos * 2.0 - 1.0);
    viewPos /= viewPos.w;

    vec3 color = getSkyGradient(viewPos.xyz);

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4(color, 1.0);
}