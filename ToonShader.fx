// 3ds Max DX parser
string ParamID = "0x0";

// Variables
float4x4 world: world < string UIWidget = "None"; >;
float4x4 view: view < string UIWidget = "None"; >;
float4x4 projection: projection < string UIWidget = "None"; >;
float4x4 worldInverseTranspose: worldInverseTranspose < string UIWidget = "None";>;

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

// Diffuse UI
float4 diffuseColor: Diffuse
<
	string UIName = "Color";
	int Texcoord = 0;
	int MapChannel = 1;	
> = float4(1.0f, 1.0f, 1.0f, 1.0f);

bool enableDiffuseTex
<
	string UIName = "Use Color Map";
	string UIWidget = "checkbox";
> = false;

float colorSteps
<
	string UIName = "Number of shadow steps";
	float UIMin = 0.0f;
	float UIMax = 30.0f;
	float UIStep = 1.0f;
	string UIWidget = "slider";
> = 5.0f;

texture diffuseTexture: DiffuseMap
<
	string name = "Default_DIFF.tga";
	string UIName = "Color Map";
>;

// Toon UI
float4 outlineColor
<
	string UIName = "Outline Color";
> = float4(0.0f,0.0f,0.0f,0.0f);

float outlineThickness
<
	string UIName = "Outline Thickness";
	string UIWidget = "slider";
> = 0.5f;

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

// Structs
struct VertexShaderInput
{
	float4 position: POSITION0;
	float2 uv01: TEXCOORD0;
	float3 normal: NORMAL0;
};

struct VertexShaderOutput
{
	float4 position: POSITION0;
	float2 uv01: TEXCOORD0;
	float3 normal: TEXCOORD1;
};

//Vertex Shader Toon
VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
	VertexShaderOutput output;

	float4 worldPosition = mul(input.position, world);
	float4 viewPosition = mul(worldPosition, view);
	output.position = mul(viewPosition, projection);
	
	output.normal = normalize(mul(input.normal, (float3x3)worldInverseTranspose));

	output.uv01 = input.uv01;

	return output;
}

//Vertex Shader Outline
VertexShaderOutput VertexShaderFunction_Outline(VertexShaderInput input)
{
	VertexShaderOutput output;

	float4 worldPosition = mul(input.position, world);
	float4 viewPosition = mul(worldPosition, view);
	output.position = mul(viewPosition, projection);
	
	float4 normal = mul(mul(mul(input.normal, world), view), projection);

	output.uv01 = input.uv01;
	output.normal = input.normal;
	
	float4 edgePosition = mul(outlineThickness, normal);
	output.position = output.position + edgePosition;

	return output;
}

//Pixel Shader Toon
float4 PixelShaderFunction(VertexShaderOutput input): COLOR0
{
	float4 texDiffuse = tex2D(diffuseSampler, input.uv01);
	float4 color;
	
	float lightIntensity = dot(normalize(diffuseLightDirection), input.normal);
	
	for ( float x = 0.0f; x < colorSteps; x++) {
		float increment = 1.0f/colorSteps;
		float nextValue = (x/colorSteps) + increment;
		float prevValue =  (x/colorSteps) - increment;
		
		if (lightIntensity < nextValue) {
			if (lightIntensity > prevValue) {
				lightIntensity = x/colorSteps;
			}
		} 
		
	}
	
	color = saturate(diffuseColor * lightIntensity * lightColor01);
	
	if (enableDiffuseTex) {
		color = color * texDiffuse;
	} else {
		color = color;
	}
	
	float4 result = saturate(color);
	result.w = 1.0f;
	return result;
}

// Pixel Shader Outline
float4 PixelShaderFunction_Outline(VertexShaderOutput input): COLOR0
{
	outlineColor.w = 1.0f;
	return outlineColor;
}

//Technique
technique Diffuse_Light_Opacity
{
	pass Pass1
	{
		ShadeMode = Gouraud;
		CullMode = CCW;
		VertexShader = compile vs_3_0 VertexShaderFunction_Outline();
		PixelShader = compile ps_3_0 PixelShaderFunction_Outline();
	}
	
	pass Pass2
	{
		ShadeMode = Gouraud;
		CullMode = CW;
		VertexShader = compile vs_3_0 VertexShaderFunction();
		PixelShader = compile ps_3_0 PixelShaderFunction();
	}
}