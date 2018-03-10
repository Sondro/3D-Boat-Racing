#version 450

#ifdef GL_ES
precision mediump float;
#endif

vec2 vUV;
vec4 fragmentColor;

uniform sampler2D tex;

void kore() {  
	gl_FragColor = fragmentColor * vec4(texture2D(tex, vUV).rgba);
}