// 3ds Max DX parser
string ParamID = "0x0";

// Variables
float4x4 world: world < string UIWidget = "None"; >;
float4x4 view: view < string UIWidget = "None"; >;
float4x4 projection: projection < string UIWidget = "None"; >;
float4x4 worldInverseTranspose: worldInverseTranspose < string UIWidget = "None";>;

// Diffuse UI
float4 diffuseColor: Diffuse
<
	string UIName = "Diffuse Color";
	int Texcoord = 0;
	int MapChannel = 1;	
> = float4(1.0f, 1.0f, 1.0f, 1.0f);

bool enableDiffuseTex
<
	string UIName = "Use Diffuse Map";
	string UIWidget = "checkbox";
> = false;

texture diffuseTexture: DiffuseMap
<
	string name = "Default_DIFF.tga";
	string UIName = "Diffuse Map";
>;

// Opacity UI
bool enableOpacityMap
<
	string UIName = "Use Opacity Map";
	string UIWidget = "checkbox";
> = false;

texture opacityTexture:OpacityMap
<
	string name = "Default_opacityMap.tga";
	string UIName = "Opacity Map";
	int Texcoord = 0;
	int MapChannel = 1;	
>;

// Lightmap UI

bool enableLightMap
<
	string UIName = "Use Light Map";
	string UIWidget = "checkbox";
> = false;

float lightMapStrength
<
	string UIName = "Light Map Strength";
	float UIMin = 0.0f;
	float UIMax = 1.0f;
	float UIStep = 0.01f;
	string UIWidget = "slider";
> = 1.0f;
	

texture lightTexture: LightMap
<
	string name = "Default_lightMap.tga";
	string UIName = "Light Map";
	int Texcoord = 1;
	int MapChannel = 2;	
>;

// Samplers
sampler2D diffuseSampler = sampler_state
{
	Texture = (diffuseTexture);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

sampler2D lightMapSampler = sampler_state
{
	Texture = (lightTexture);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

sampler2D opacitySampler = sampler_state
{
	Texture = (opacityTexture);
	MagFilter = NONE;
	MinFilter = NONE;
	MipFilter = NONE;
	AddressU = WRAP;
	AddressV = WRAP;
};

// Structs
struct VertexShaderInput
{
	float4 position: POSITION0;
	float2 uv01: TEXCOORD0;
	float2 uv02: TEXCOORD1;
};

struct VertexShaderOutput
{
	float4 position: POSITION0;
	float2 uv01: TEXCOORD0;
	float2 uv02: TEXCOORD1;
};

//Vertex Shader
VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
	VertexShaderOutput output;

	float4 worldPosition = mul(input.position, world);
	float4 viewPosition = mul(worldPosition, view);
	output.position = mul(viewPosition, projection);

	output.uv01 = input.uv01;
	output.uv02 = input.uv02;

	return output;
}

//Pixel Shader Pass1
float4 PixelShaderFunction(VertexShaderOutput input): COLOR0
{
	float4 texDiffuse = tex2D(diffuseSampler, input.uv01);
	float4 texOpacity = tex2D(opacitySampler, input.uv01);
	float4 texLightMap = tex2D(lightMapSampler, input.uv02);
	float4 color;
	float4 light;
	float opacity;
	
	if (enableDiffuseTex) {
		color = texDiffuse * diffuseColor;
	} else {
		color = diffuseColor;
	}
	
	if (enableLightMap) {
		light = texLightMap * lightMapStrength;
	} else {
		light = float4(1.0f,1.0f,1.0f,1.0f);
	}
	
	if (enableOpacityMap) {
		opacity = texOpacity.x;
	} else {
		opacity = 1.0f;
	}
	
	if (opacity < 1.0f) {
		opacity = 0.0f;
	}
	
	float4 result = saturate(color * light);
	result.w = opacity;
	return result;
}

// Pixel Shader Pass2
float4 PixelShaderFunction_Opacity(VertexShaderOutput input): COLOR0
{
	float4 texDiffuse = tex2D(diffuseSampler, input.uv01);
	float4 texOpacity = tex2D(opacitySampler, input.uv01);
	float4 texLightMap = tex2D(lightMapSampler, input.uv02);
	float4 color;
	float4 light;
	float opacity;
	
	if (enableDiffuseTex) {
		color = texDiffuse * diffuseColor;
	} else {
		color = diffuseColor;
	}
	
	if (enableLightMap) {
		light = texLightMap * lightMapStrength;
	} else {
		light = float4(1.0f,1.0f,1.0f,1.0f);
	}
	
	if (enableOpacityMap) {
		opacity = texOpacity.x;
	} else {
		opacity = 1.0f;
	}
	
	if (opacity == 1.0f) {
		opacity = 0.0f;
	}
	
	float4 result = saturate(color * light);
	result.w = opacity;
	return result;
}

//Technique
technique Diffuse_Light_Opacity
{
	pass Pass1
	{
		ZEnable = TRUE;
		ZWriteEnable = TRUE;
		AlphaBlendEnable = TRUE;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
		ShadeMode = Gouraud;
		CullMode = NONE;
		VertexShader = compile vs_3_0 VertexShaderFunction();
		PixelShader = compile ps_3_0 PixelShaderFunction();
	}
	
	pass Pass2
	{
		ZEnable = TRUE;
		ZWriteEnable = TRUE;
		AlphaBlendEnable = TRUE;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
		ShadeMode = Gouraud;
		CullMode = NONE;
		VertexShader = compile vs_3_0 VertexShaderFunction();
		PixelShader = compile ps_3_0 PixelShaderFunction_Opacity();
	}
}