#version 450

vec3 pos;
vec3 normal;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

//vec3 norm;
vec3 norm;
vect4 color;

void main() {
	norm = (model * vec4(normal, 0.0)).xyz;
	color = projection * view * model * vec4(pos, 1.0);
}
