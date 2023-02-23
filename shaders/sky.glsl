// State of include guard
#ifndef SKY_GLSL
#define SKY_GLSL

#include "math.glsl"

const vec3 SKY_DAY = vec3(0.1, 0.49, 0.81);
const vec3 SKY_NIGHT = vec3(0., 0., 0.02);

const vec3 SUN_SUNRISE1 = vec3(1., 0.44, 0.23);
const vec3 SUN_SUNRISE2 = vec3(0.95, 0.74, 0.45);
const vec3 SUN_DAY = vec3(0.9, 0.9, 0.9);
const vec3 SUN_SUNSET1 = vec3(0.95, 0.74, 0.45);
const vec3 SUN_SUNSET2 = vec3(1., 0.44, 0.23);
const vec3 SUN_NIGHT = vec3(0., 0.05, 0.1);

vec3[2] getSkyColors() {
    float day = smoothstep(0.05, 0.1, sunAngle);
    float sunset1 = smoothstep(0.3, 0.4, sunAngle);
    float sunset2 = smoothstep(0.4, 0.5, sunAngle);
    float night = smoothstep(0.5, 0.6, sunAngle);
    float sunrise1 = smoothstep(0.9, 0.98, sunAngle);
    float sunrise2 = smoothstep(0.98, 1., sunAngle);

    float nightlight = smoothstep(0.5, 0.6, sunAngle);
    float daylight = smoothstep(0.8, 1., sunAngle - 0.1);

    vec3 baseNight = mix(SKY_DAY, SKY_NIGHT, nightlight);
    vec3 base = mix(baseNight, SKY_DAY, daylight);

    vec3 sunDay = mix(SUN_SUNRISE2, SUN_DAY, day);
    vec3 sunSunset1 = mix(sunDay, SUN_SUNSET1, sunset1);
    vec3 sunSunset2 = mix(sunSunset1, SUN_SUNSET2, sunset2);
    vec3 sunNight = mix(sunSunset2, SUN_NIGHT, night);
    vec3 sunSunrise1 = mix(sunNight, SUN_SUNRISE1, sunrise1);
    vec3 sun = mix(sunSunrise1, SUN_SUNRISE2, sunrise2);

    return vec3[2](base, sun);
}

vec3 getSkyGradient(vec3 pos) {
    vec3 position = normalize(pos);
    vec3 sunPos = normalize(sunPosition);
    vec3 up = normalize(gbufferModelView[1].xyz);
    vec3 horizon = normalize(up + position);
    vec3 sunAtHorizon = normalize(vec3(sunPos.x, 0., sunPos.z));

    float day = smoothstep(0.05, 0.1, sunAngle);
    float sunset = smoothstep(0.3, 0.5, sunAngle);
    float sunGradientSize = mix(mix(1., 1.5, day), 1.5, sunset);
    float sunGradient = length(sunPos - position) * sunGradientSize;

    float distSun = length(sunAtHorizon - position) * 0.2;
    float distHorizon = smoothstep(0.5, 1.0, length(horizon - position));
    float skyGradient = clamp(mix(1. - distHorizon, 1., distSun), 0., 1.);
    float gradient = smin(skyGradient, sunGradient, 0.99);

    vec3[2] skyColors = getSkyColors();

    vec3 color = mix(skyColors[1], skyColors[0], gradient);

    return color;
}

#endif