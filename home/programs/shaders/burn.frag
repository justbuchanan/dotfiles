// close half of 10_Advanced/burn.kdl from github.com/arch-disciple/niri-shader-collection (GPL-3.0)

float hash(vec2 vector) {

  float d = dot(vector, vec2(127.1, 311.7));

  float ds = sin(d);

  float hash_value = fract(ds * 43758.5453);

  return hash_value;
}

float noise(vec2 vector) {

  vec2 i = floor(vector);
  vec2 f = fract(vector);

  f = f * f * (3.0 - 2.0 * f);

  float bottom_left = hash(i);
  float bottom_right = hash(i + vec2(1.0, 0.0));
  float top_left = hash(i + vec2(0.0, 1.0));
  float top_right = hash(i + vec2(1.0, 1.0));

  float bottom = mix(bottom_left, bottom_right, f.x);
  float top = mix(top_left, top_right, f.x);

  float blend = mix(bottom,top,f.y);

  return blend;
}

float fbm(vec2 vector) {

  float total_noise = 0.0;

  float amplitude = 0.5;

  for (int i = 0; i < 5; i++) {

    total_noise += noise(vector) * amplitude;

    vector *= 2.0;

    amplitude *= 0.5;
  }

  return total_noise;
}

vec4 burn_close(vec3 coords_geo, vec3 size_geo) {

  float progress = niri_clamped_progress;

  vec2 coords = coords_geo.xy;

  float small_seed = 3.0 + niri_random_seed * 5.0;
  float big_seed = 25.0 + niri_random_seed * 100.0;

  float fbm_noise = fbm(coords * small_seed + big_seed);

  float mask = smoothstep(progress, progress + 0.05, fbm_noise);

  float burn_width = 0.08;
  float burn_mask = smoothstep(progress - burn_width, progress, fbm_noise) * (1.0 - mask);

  vec3 burn_color = mix(vec3(1.0, 0.4, 0.2), vec3(1.0, 0.2, 0.05), burn_mask);
  vec4 burn_edge = vec4(burn_color * burn_mask * 2.0, burn_mask);

  vec3 coords_tex = niri_geo_to_tex * vec3(coords, 1.0);
  vec4 color = texture2D(niri_tex, coords_tex.st);

  color = (color * mask) + (burn_edge * color.a);

  return color;
}

vec4 close_color(vec3 coords_geo, vec3 size_geo) {
  return burn_close(coords_geo, size_geo);
}
