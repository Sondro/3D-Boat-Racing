#version 450

#ifdef GL_ES
precision highp float;
#endif

attribute vec3 pos;
attribute vec2 uv;

vec2 vUV;
vec4 fragmentColor;

uniform mat4 viewMatrix;

attributeOrUniform vec2 sizeWorldspace;
attributeOrUniform vec3 centerWorldspace;
attributeOrUniform vec2 rotData;
attributeOrUniform vec4 baseColor;
attributeOrUniform mat4 mvpMatrix;

vec3 CameraRightWorldspace;
vec3 CameraUpWorldspace;
vec2 rotPos;
vec3 posWorldspace;

out vec4 color;

void kore() {
	CameraRightWorldspace = normalize(vec3(viewMatrix[0][0], viewMatrix[1][0], viewMatrix[2][0]));
	CameraUpWorldspace = normalize(vec3(viewMatrix[0][1], viewMatrix[1][1], viewMatrix[2][1]));
	
	rotPos = mat2(rotData.y, -rotData.x, rotData.x, rotData.y) * pos.xy;
	
	posWorldspace = 
    centerWorldspace
    + CameraRightWorldspace * rotPos.x * sizeWorldspace.x
    + CameraUpWorldspace * rotPos.y * sizeWorldspace.y;
	
//	gl_Position = mvpMatrix * vec4(posWorldspace, 1.0);
	gl_Position = mvpMatrix * vec4(posWorldspace, 1.0);

	vUV = uv;
	//fragmentColor = baseColor;

	color = baseColor;
}