// 3ds Max DX parser
string ParamID = "0x0";

// Variables
float4x4 world: world < string UIWidget = "None"; >;
float4x4 view: view < string UIWidget = "None"; >;
float4x4 projection: projection < string UIWidget = "None"; >;
float4x4 worldInverseTranspose: worldInverseTranspose < string UIWidget = "None";>;
float4x4 viewInverse: VIEWINVERSE;

// Light UI
bool enableLight01
<
	string UIName = "Light 01";
	string UIWidget = "checkbox";
> = true;

float3 diffuseLightDirection: Direction
<  
	string UIName = "Light 01 Object";
	string Object = "TargetLight";
	int RefID = 0;
> = float3(1.0f,0.0f,0.0f);

float4 lightColor01: LightColor <
	string UIWidget = "None";
    int LightRef = 0;
> = float4( 1.0f, 1.0f, 1.0f, 1.0f ); 

bool enableLight02
<
	string UIName = "Light 02";
	string UIWidget = "checkbox";
> = true;

float3 diffuseLightDirection02: Direction
<  
	string UIName = "Light 02 Object";
	string Object = "TargetLight";
	int RefID = 1;
> = float3(1.0f,0.0f,0.0f);

float4 lightColor02: LightColor <
	string UIWidget = "None";
    int LightRef = 1;
> = float4( 1.0f, 1.0f, 1.0f, 1.0f ); 

// Ambient/Diffuse UI
float4 ambientColor: Ambient
<
	string UIName = "Ambient Color";
> = float4(0.0f, 0.0f, 0.0f, 1.0f);

float4 diffuseColor: Diffuse
<
string UIName = "Diffuse Color";
> = float4(0.5f,0.5f,0.5f,1.0f);

bool enableDiffuseTex
<
	string UIName = "Use Diffuse Map";
	string UIWidget = "checkbox";
> = false;

texture diffTexture : DiffuseMap
<
	string name = "Checkerboard_diff.tga";
	string UIName = "Diffuse Map";
>;

// Specular/Gloss UI
float4 specularColor
<
string UIName = "Specular Color";
> = float4(1.0f,1.0f,1.0f,1.0f);

float specularIntensity
<
string UIWidget = "slider";
float UIMin = 0.0f;
float UIMax = 15.0f;
float UIStep = 0.01f;
string UIName = "Specular Intensity";
> = 1.0f;

float glossiness
<
string UIWidget = "slider";
float UIMin = 0.0f;
float UIMax = 90.0f;
float UIStep = 0.1f;
string UIName = "Glossiness";
> = 10.0f;

bool enableSpecTex
<
	string UIName = "Use Specular Map";
	string UIWidget = "checkbox";
> = false;

texture specTexture: SpecularMap
<
	string name = "Checkerboard_spec.tga";
	string UIName = "Specular Map";
>;

bool enableGlossTex
<
	string UIName = "Use Gloss Map";
	string UIWidget = "checkbox";
> = false;

texture glossTexture: GlossMap
<
	string name = "Checkerboard_gloss.tga";
	string UIName = "Gloss Map";
>;

// Normal UI

float bumpFactor
<
	string UIName = "Bump Scale";
	float UIMin = -3.0f;
	float UIMax = 3.0f;
	float UIStep = 0.01f;
> = 1.0f;

bool enableBumpTex
<
	string UIName = "Use Normal Map";
	string UIWidget = "checkbox";
> = false;

texture normalTexture: NormalMap
<
	string name = "Checkerboard_ddn.tga";
	string UIName = "Normal Map";
>;

// Extra textures

bool enableOpacityTex
<
	string UIName = "Use Opacity Map";
	string UIWidget = "checkbox";
> = false;

texture opacityTexture: OpacityMap
<
	string name = "Checkerboard_opacity.tga";
	string UIName = "Opacity Map";
>;

bool enableEmissiveTex
<
	string UIName = "Use Self-Illumination Map";
	string UIWidget = "checkbox";
> = false;

texture emissiveTexture: EmissiveMap
<
	string name = "Checkerboard_selfIllum.tga";
	string UIName = "Self-Illumination Map";
>;

//texture emissive 

// Samplers
sampler2D textureSampler = sampler_state
{
	Texture = (diffTexture);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

sampler2D textureSampler02 = sampler_state
{
	Texture = (specTexture);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

sampler2D textureSampler03 = sampler_state
{
	Texture = (glossTexture);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

sampler2D textureSampler04 = sampler_state
{
	Texture = (normalTexture);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

sampler2D textureSampler05 = sampler_state
{
	Texture = (opacityTexture);
	MagFilter = NONE;
	MinFilter = NONE;
	MipFilter = NONE;
	AddressU = WRAP;
	AddressV = WRAP;
};

sampler2D textureSampler06 = sampler_state
{
	Texture = (emissiveTexture);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};
// Structs
struct VertexShaderInput
{
	float4 position: POSITION0;
	float3 normal: NORMAL0;
	float3 tangent:TANGENT0;
	float3 binormal: BINORMAL0;
	float2 texCoord: TEXCOORD0;
};

struct VertexShaderOutput
{
	float4 position: POSITION0;
	float3 normal: TEXCOORD0;
	float3 tangent: TEXCOORD3;
	float3 binormal: TEXCOORD4;
	float3 eye: TEXCOORD1;
	float2 texCoord: TEXCOORD2;
};

//Vertex Shader
VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
	VertexShaderOutput output;

	float4 worldPosition = mul(input.position, world);
	float4 viewPosition = mul(worldPosition, view);
	output.position = mul(viewPosition, projection);

	float3 normal = mul(input.normal, (float3x3)worldInverseTranspose);
	float3 tangent = mul(input.tangent, (float3x3)worldInverseTranspose);
	float3 binormal = mul(input.binormal, (float3x3)worldInverseTranspose);
	
	output.normal = normal;
	output.tangent = tangent;
	output.binormal = binormal;

	float3 finalPos = mul(worldPosition, view);
	finalPos = normalize(mul(finalPos, world));
	output.eye = viewInverse[3].xyz - finalPos;

	output.texCoord = input.texCoord;

	return output;
}

//Pixel Shader
float4 PixelShaderFunction(VertexShaderOutput input): COLOR0
{
	// Sampler loading
	
	//Gloss map
	float4 finalGloss;

	float4 texGloss = tex2D(textureSampler03, input.texCoord);
	texGloss.a = 1;

	if (enableGlossTex) {
		finalGloss = glossiness * texGloss;
	} else {
		finalGloss = glossiness;
	}

	// Diffuse, Specular, Opacity, Emissive
	float4 texDiff = tex2D(textureSampler, input.texCoord);
	texDiff.a = 1;

	float4 texSpec = tex2D(textureSampler02, input.texCoord);
	texSpec.a = 1;
	
	float4 texOpacity = tex2D(textureSampler05, input.texCoord);
	
	float4 texEmissive = tex2D(textureSampler06, input.texCoord);

	float4 finalDiffuse;
	float4 finalSpecular;
	float4 finalEmissive;
	float finalOpacity;
	
	float3 finalBump;
	
	// Bump Map
	if (enableBumpTex) {
		float4 bump = bumpFactor * (tex2D(textureSampler04, input.texCoord) - 0.5f);
		finalBump = input.normal + (bump.x * input.tangent + bump.y * input.binormal);
		finalBump = normalize(finalBump);
	} else {
		finalBump = normalize(input.normal);
	}
	
	if (!enableLight01) {
		diffuseLightDirection = float3(0.0f,0.0f,0.0f);
	}
	
	if (!enableLight02) {
		diffuseLightDirection02 = float3(0.0f,0.0f,0.0f);
	}

	// Light 01 calculations
	float lightIntensity = dot(normalize(diffuseLightDirection), finalBump);
	float4 color = saturate(diffuseColor * lightIntensity * lightColor01);
	
	float3 light = normalize(diffuseLightDirection);
	float3 eye = normalize(input.eye);
	float3 r = normalize(2*dot(light,finalBump)*finalBump-light);

	float dotProduct = dot(r,eye);
	
	// Light 02 calculations
	float lightIntensity02 = dot(normalize(diffuseLightDirection02), finalBump);
	float4 color02 = saturate(diffuseColor * lightIntensity02 * lightColor02);
	
	float3 light02 = normalize(diffuseLightDirection02);
	float3 r02 = normalize(2*dot(light02,finalBump)*finalBump-light02);

	float dotProduct02 = dot(r02,eye);
	
	// Specular calculation
	float4 specular = specularIntensity * specularColor * max(pow(dotProduct, finalGloss),0)*length(color);
	float4 specular02 = specularIntensity * specularColor * max(pow(dotProduct02, finalGloss),0)*length(color02);

	// Texture conditionals
	if (enableDiffuseTex){
		finalDiffuse = (color02 + color) * texDiff;
	} else {
		finalDiffuse = color02 + color;
	}

	if (enableSpecTex){
		finalSpecular = (specular02 + specular) * texSpec;
	} else {
		finalSpecular = (specular + specular02) * (glossiness/90);
	}
	
	if (enableEmissiveTex) {
		finalEmissive = texEmissive;
	} else {
		finalEmissive = float4(0.0f,0.0f,0.0f,0.0f);
	}
	
	if (texOpacity.x < 1.0f) {
		finalOpacity = 0.0f;
	} else {
		finalOpacity = 1.0f;
	}

	// Return pixel color
	float4 result = saturate(finalDiffuse + ambientColor + finalSpecular + finalEmissive);
	result.w = finalOpacity;
	return result;
}

//Pixel Shader
float4 PixelShaderFunction_Opacity(VertexShaderOutput input): COLOR0
{
	// Sampler loading
	
	//Gloss map
	float4 finalGloss;

	float4 texGloss = tex2D(textureSampler03, input.texCoord);
	texGloss.a = 1;

	if (enableGlossTex) {
		finalGloss = glossiness * texGloss;
	} else {
		finalGloss = glossiness;
	}

	// Diffuse, Specular, Opacity, Emissive
	float4 texDiff = tex2D(textureSampler, input.texCoord);
	texDiff.a = 1;

	float4 texSpec = tex2D(textureSampler02, input.texCoord);
	texSpec.a = 1;
	
	float4 texOpacity = tex2D(textureSampler05, input.texCoord);
	
	float4 texEmissive = tex2D(textureSampler06, input.texCoord);

	float4 finalDiffuse;
	float4 finalSpecular;
	float4 finalEmissive;
	float finalOpacity;
	
	float3 finalBump;
	
	// Bump Map
	if (enableBumpTex) {
		float4 bump = bumpFactor * (tex2D(textureSampler04, input.texCoord) - 0.5f);
		finalBump = input.normal + (bump.x * input.tangent + bump.y * input.binormal);
		finalBump = normalize(finalBump);
	} else {
		finalBump = normalize(input.normal);
	}
	
	if (!enableLight01) {
		diffuseLightDirection = float3(0.0f,0.0f,0.0f);
	}
	
	if (!enableLight02) {
		diffuseLightDirection02 = float3(0.0f,0.0f,0.0f);
	}

	// Light 01 calculations
	float lightIntensity = dot(normalize(diffuseLightDirection), finalBump);
	float4 color = saturate(diffuseColor * lightIntensity * lightColor01);
	
	float3 light = normalize(diffuseLightDirection);
	float3 eye = normalize(input.eye);
	float3 r = normalize(2*dot(light,finalBump)*finalBump-light);

	float dotProduct = dot(r,eye);
	
	// Light 02 calculations
	float lightIntensity02 = dot(normalize(diffuseLightDirection02), finalBump);
	float4 color02 = saturate(diffuseColor * lightIntensity02 * lightColor02);
	
	float3 light02 = normalize(diffuseLightDirection02);
	float3 r02 = normalize(2*dot(light02,finalBump)*finalBump-light02);

	float dotProduct02 = dot(r02,eye);
	
	// Specular calculation
	float4 specular = specularIntensity * specularColor * max(pow(dotProduct, finalGloss),0)*length(color);
	float4 specular02 = specularIntensity * specularColor * max(pow(dotProduct02, finalGloss),0)*length(color02);

	// Texture conditionals
	if (enableDiffuseTex){
		finalDiffuse = (color02 + color) * texDiff;
	} else {
		finalDiffuse = color02 + color;
	}

	if (enableSpecTex){
		finalSpecular = (specular02 + specular) * texSpec;
	} else {
		finalSpecular = (specular + specular02) * (glossiness/90);
	}
	
	if (enableEmissiveTex) {
		finalEmissive = texEmissive;
	} else {
		finalEmissive = float4(0.0f,0.0f,0.0f,0.0f);
	}
	
	if (texOpacity.x < 1.0f) {
		finalOpacity = texOpacity.x;
	} else {
		finalOpacity = 0.0f;
	}
	
	if (!enableOpacityTex) {
		finalOpacity = 1.0f;
	}

	// Return pixel color
	float4 result = saturate(finalDiffuse + ambientColor + finalSpecular + finalEmissive);
	result.w = finalOpacity;
	return result;
}

//Technique
technique FullTexturedOpacity
{
	pass Pass1
	{
		ZEnable = true;
		AlphaTestEnable = TRUE;
		DestBlend = INVSRCALPHA;
        SrcBlend = SRCALPHA;
		CullMode = CW;
		ShadeMode = Gouraud;
		VertexShader = compile vs_3_0 VertexShaderFunction();
		PixelShader = compile ps_3_0 PixelShaderFunction();
	}
	pass Pass2
	{
		ZEnable = true;
		AlphaTestEnable = TRUE;
		DestBlend = INVSRCALPHA;
        SrcBlend = SRCALPHA;
		CullMode = CW;
		ShadeMode = Gouraud;
		VertexShader = compile vs_3_0 VertexShaderFunction();
		PixelShader = compile ps_3_0 PixelShaderFunction_Opacity();
	}
}