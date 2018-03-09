#version 450

vec3 norm;
vec3 lightdir;
in vec3 fragmentColor;

vec4 frag;

void main() {
	frag = vec4(fragmentColor, 1.0);
}
