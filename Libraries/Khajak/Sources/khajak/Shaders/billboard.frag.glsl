#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;

vec2 vUV;
vec4 fragmentColor;
vec4 color;

void kore() {  
	color = fragmentColor * vec4(texture2D(tex, vUV).rgba);
}