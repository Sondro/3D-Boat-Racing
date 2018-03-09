#version 450

vec3 norm;
vec3 lightdir;

out vec4 frag;

void main() {
	lightdir = vec3(-0.2, 0.5, -0.3);
	frag = vec4(dot(norm, lightdir) * vec3(1.0, 1.0, 1.0), 1.0);
}
