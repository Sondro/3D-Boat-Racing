#version 450

#ifdef GL_ES
precision mediump float;
#endif

vec2 vUV;
vec4 fragmentColor;

uniform sampler2D tex;

vec4 color;

void kore() {  
	//gl_FragColor = fragmentColor * vec4(texture2D(tex, vUV).rgba);
		Color = fragmentColor * vec4(texture2D(tex, vUV).rgba);

}