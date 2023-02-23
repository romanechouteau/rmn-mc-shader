// State of include guard
#ifndef SKY_GLSL
#define SKY_GLSL

const vec3 SKY_TOP_SUNRISE = vec3(0.19, 0.55, 0.85);
const vec3 SKY_BOTTOM_SUNRISE = vec3(0.81, 0.24, 0.03);
const vec3 SKY_TOP_DAY = vec3(0.1, 0.49, 0.81);
const vec3 SKY_BOTTOM_DAY = vec3(0.9, 0.9, 0.9);
const vec3 SKY_TOP_SUNSET = vec3(0.1, 0.49, 0.81);
const vec3 SKY_BOTTOM_SUNSET = vec3(0.72, 0.07, 0.003);
const vec3 SKY_TOP_NIGHT = vec3(0., 0.11, 0.21);
const vec3 SKY_BOTTOM_NIGHT = vec3(0., 0.05, 0.1);

vec3[2] getSkyColors() {
    float day = smoothstep(0.05, 0.1, sunAngle);
    float sunset = smoothstep(0.3, 0.5, sunAngle);
    float night = smoothstep(0.5, 0.6, sunAngle);
    float sunrise = smoothstep(0.9, 1., sunAngle);

    vec3 topDay = mix(SKY_TOP_SUNRISE, SKY_TOP_DAY, day);
    vec3 bottomDay = mix(SKY_BOTTOM_SUNRISE, SKY_BOTTOM_DAY, day);

    vec3 topSunset = mix(topDay, SKY_TOP_SUNSET, sunset);
    vec3 bottomSunset = mix(bottomDay, SKY_BOTTOM_SUNSET, sunset);

    vec3 topNight = mix(topSunset, SKY_TOP_NIGHT, night);
    vec3 bottomNight = mix(bottomSunset, SKY_BOTTOM_NIGHT, night);

    vec3 top = mix(topNight, SKY_TOP_SUNRISE, sunrise);
    vec3 bottom = mix(bottomNight, SKY_BOTTOM_SUNRISE, sunrise);

    return vec3[2](top, bottom);
}

vec3 getSkyGradient(vec3 pos) {
    vec3 position = normalize(pos);
    vec3 up = normalize(gbufferModelView[1].xyz);
    vec3 horizon = normalize(up + position);

    float gradient = smoothstep(0.5, 1.0, distance(position, horizon));

    vec3[2] skyColors = getSkyColors();

    vec3 color = mix(skyColors[0], skyColors[1], gradient);

    return color;
}

#endif