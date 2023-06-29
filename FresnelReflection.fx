// 3ds Max DX parser
string ParamID = "0x0";

// Variables
float4x4 world: world < string UIWidget = "None"; >;
float4x4 view: view < string UIWidget = "None"; >;
float4x4 projection: projection < string UIWidget = "None"; >;
float4x4 worldInverseTranspose: worldInverseTranspose < string UIWidget = "None";>;
float4x4 viewInverse: VIEWINVERSE;

float3 cameraPos;

// Lights
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

// Diffuse
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

// Specular / Gloss
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

// Normal
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

// Fresnel
bool enableFresnel
<
	string UIName = "Enable Fresnel";
	string UIWidget = "checkbox";
> = true;

float4 fresnelColor
<
	string UIName = "Fresnel Color";
> = float4(1.0f,1.0f,1.0f,1.0f);

float fresnelPow
<
	string UIName = "Fresnel Power";
	float UIMin = -15.0f;
	float UIMax = 15.0f;
	float UIStep = 0.1f;
> = 0.9f;

float fresnelIntensity
<
	string UIName = "Fresnel Intensity";
	float UIMin = 0.0f;
	float UIMax = 50.0f;
	float UIStep = 0.1f;
> = 0.5f;

float fresnelAngle
<
	string UIName = "Fresnel Start Angle";
	float UIMin = 0.0f;
	float UIMax = 180.0f;
	float UIStep = 1.0f;
> = 50.0f;

// Reflection
bool enableReflectionMask
<
	string UIName = "Use Reflection Map";
	string UIWidget = "checkbox";
> = false;

texture reflectTexture: NormalMap
<
	string name = "Checkerboard_ref.tga";
	string UIName = "Reflection Map";
>;

bool enableSkyBoxTex
<
	string UIName = "Enable Reflection";
	string UIWidget = "checkbox";
> = false;

float skyBoxIntensity
<
	string UIName = "Reflection Intensity";
	float UIMin = 0.0f;
	float UIMax = 10.0f;
	float UIStep = 0.1f;
> = 1.0f;

textureCUBE skyBoxTex: SkyBox 
<
	string name = "skybox.tga";
	string UIName = "Cubemap";
>;

// Samplers
samplerCUBE skyBoxSampler = sampler_state
{
	Texture = (skyBoxTex);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = MIRROR;
	AddressV = MIRROR;
};

sampler2D diffSampler = sampler_state
{
	Texture = (diffTexture);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

sampler2D specSampler = sampler_state
{
	Texture = (specTexture);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

sampler2D glossSampler = sampler_state
{
	Texture = (glossTexture);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

sampler2D bumpSampler = sampler_state
{
	Texture = (normalTexture);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

sampler2D refSampler = sampler_state
{
	Texture = (reflectTexture);
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
	float4 normal: NORMAL0;
	float3 tangent:TANGENT0;
	float3 binormal: BINORMAL0;
	float2 texCoord: TEXCOORD0;
};

struct VertexShaderOutput
{
	float4 position: POSITION0;
	float2 texCoord: TEXCOORD0;
	float3 eye: TEXCOORD1;
	float3 normal: TEXCOORD2;
	float3 reflection: TEXCOORD3;
	float3 tangent: TEXCOORD4;
	float3 binormal: TEXCOORD5;
};

//Vertex Shader
VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
	VertexShaderOutput output;

	float4 worldPosition = mul(input.position, world);
	float4 viewPosition = mul(worldPosition, view);
	output.position = mul(viewPosition, projection);

	float4 vertexPos = mul(input.position, world);
	float3 viewDir = cameraPos - vertexPos;
	
	float3 tangent = mul(input.tangent, worldInverseTranspose);
	float3 binormal = mul(input.binormal, worldInverseTranspose);

	float3 normal = normalize(mul(input.normal, worldInverseTranspose));
	output.texCoord = input.texCoord;
	output.normal = input.normal;
	output.tangent = tangent;
	output.binormal = binormal;
	
	float3 finalPos = mul(worldPosition, view);
	finalPos = normalize(mul(finalPos, world));
	output.eye = viewInverse[3].xyz - finalPos;
	output.reflection = reflect(-normalize(viewDir), normalize(normal));
	return output;
}

//Pixel Shader
float4 PixelShaderFunction(VertexShaderOutput input): COLOR0
{
	// Variables
	float3 finalBump = input.normal;
	float4 finalDiffuse;
	float4 finalGloss;
	float4 finalSpecular;
	
	float4 cubeMap = texCUBE(skyBoxSampler, normalize(input.reflection));
	float4 diffTex = tex2D(diffSampler, input.texCoord);
	float4 specTex = tex2D(specSampler, input.texCoord);
	float4 glossTex = tex2D(glossSampler, input.texCoord);
	float4 refTex = tex2D(refSampler, input.texCoord);
	
	// Gloss
	if (enableGlossTex) {
		finalGloss = glossiness * glossTex;
	} else {
		finalGloss = glossiness;
	}
	
	// Bump Map
	if (enableBumpTex) {
		float4 bump = bumpFactor * (tex2D(bumpSampler, input.texCoord) - 0.5f);
		finalBump = input.normal + (bump.x * input.tangent + bump.y * input.binormal);
		finalBump = normalize(finalBump);
	} else {
		finalBump = normalize(input.normal);
	}
	
	// Lights - Diffuse/Specular
	if (!enableLight01) {
		diffuseLightDirection = float3(0.0f,0.0f,0.0f);
	}
	
	if (!enableLight02) {
		diffuseLightDirection02 = float3(0.0f,0.0f,0.0f);
	}
	
	float lightIntensity = dot(normalize(diffuseLightDirection), finalBump);
	float4 diffuse = saturate(diffuseColor * lightIntensity * lightColor01);
	float3 light = normalize(diffuseLightDirection);
	
	float3 eye = normalize(input.eye);
	float3 r = normalize(2*dot(light,finalBump)*finalBump-light);

	float dotProduct = dot(r,eye);
	
	
	float lightIntensity02 = dot(normalize(diffuseLightDirection02), finalBump);
	float4 diffuse02 = saturate(diffuseColor * lightIntensity02 * lightColor02);
	
	float3 light02 = normalize(diffuseLightDirection02);
	float3 r02 = normalize(2*dot(light02,finalBump)*finalBump-light02);

	float dotProduct02 = dot(r02,eye);
	
	// Specular
	float4 specular = specularIntensity * specularColor * max(pow(dotProduct, finalGloss),0)*length(diffuse);
	float4 specular02 = specularIntensity * specularColor * max(pow(dotProduct02, finalGloss),0)*length(diffuse02);
	
	// Fresnel
	float fresnel = dot(finalBump, input.eye);
	fresnel = fresnelAngle/fresnel;
	fresnel = max(pow(fresnel, fresnelPow), 0);
	
	// Final calculations
	if (enableDiffuseTex){
		finalDiffuse = (diffuse02 + diffuse) * diffTex;
	} else {
		finalDiffuse = diffuse02 + diffuse;
	}
	
	if (enableSpecTex){
		finalSpecular = (specular02 + specular) * specTex;
	} else {
		finalSpecular = (specular + specular02) * (glossiness/90);
	}
	
	float4 finalFresnel = fresnel * fresnelIntensity * fresnelColor;
	float4 finalCubeMap;

	if (!enableFresnel) {
		finalFresnel = 0.0f;
	}
	
	if (!enableSkyBoxTex) {
		finalCubeMap = 0.0f;
	} else {
		cubeMap = cubeMap * skyBoxIntensity;
		float4 cLight01 = saturate(cubeMap * lightIntensity);
		float4 cLight02 = saturate(cubeMap * lightIntensity02);
		finalCubeMap = saturate(cLight01 + cLight02);
	}
	
	if (enableReflectionMask) {
		finalCubeMap = finalCubeMap * refTex;
	} else {
		finalCubeMap = finalCubeMap;
	}
	
	float4 result = saturate(finalDiffuse + finalSpecular + finalFresnel + finalCubeMap);
	result.w = 1.0f;
	return result;
}


//Technique
technique ReflectionFresnel
{
	pass Pass1
	{
		ZEnable = true;
		CullMode = CW;
		ShadeMode = Gouraud;
		VertexShader = compile vs_3_0 VertexShaderFunction();
		PixelShader = compile ps_3_0 PixelShaderFunction();
	}
}