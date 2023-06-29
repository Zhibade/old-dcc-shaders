float4x4 World: World < string UIWidget = "None"; >;
float4x4 WVP: WorldViewProjection < string UIWidget = "None"; >;
float4x4 WorldITXf : WorldInverseTranspose <string UIWidget = "none";>;

// UI
float3 dirLight: Direction
<  string UIName = "Light Direction";
> = float3(0.0f,-1.0f,0.0f);

float dirLightIntensity
<
	string UIWidget = "slider";
	float UIMin = 0.0f;
	float UIMax = 5.0f;
	float UIStep = 0.01f;
	string UIName = "Light Intensity";
> = 0.5f;

float ambientIntensity
<
	string UIWidget = "slider";
	float UIMin = 0.0f;
	float UIMax = 1.0f;
	float UIStep = 0.01f;
	string UIName = "Ambient Intensity";
> = 0.15f;

bool useDirLight
<
	string UIName = "Use Light";
	string UIWidget = "checkbox";
> = false;

texture diffTexture : DiffuseMap
<
	string name = "diff.tga";
	string UIName = "Diffuse Texture";
>;

float dilationXIntensity
<
	string UIWidget = "slider";
	float UIMin = 0.0f;
	float UIMax = 1.0f;
	float UIStep = 0.01f;
	string UIName = "Dilation X";
> = 0.0f;

float dilationYIntensity
<
	string UIWidget = "slider";
	float UIMin = 0.0f;
	float UIMax = 1.0f;
	float UIStep = 0.01f;
	string UIName = "Dilation Y";
> = 0.0f;

float maxDilation
<
	string UIWidget = "slider";
	float UIMin = -1.0f;
	float UIMax = 1.0f;
	float UIStep = 0.01f;
	string UIName = "Max Dilation";
> = 0.58f;

texture maskTexture : DiffuseMap
<
	string name = "diff.tga";
	string UIName = "Diffuse Texture";
>;

// Samplers
sampler2D diffuseMap = sampler_state
{
	Texture = (diffTexture);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

sampler2D eyeMask = sampler_state
{
	Texture = (maskTexture);
	MagFilter = LINEAR;
	MinFilter = LINEAR;
	MipFilter = LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

// Convert tex2D to linear
float4 tex2DLinear(sampler2D texture, float2 uvs)
{
	return pow(tex2D(texture, uvs), 2.2);
}

// Shader
struct appdata
{
	float4 position: POSITION;
	float3 normal: NORMAL;
	float2 texCoord: TEXCOORD0;
};

struct vertOut 
{
	float4 position: POSITION;
	float3 worldNormal: TEXCOORD0;
	float2 uv: TEXCOORD1;
};

//Vertex Shader
vertOut vert(appdata IN)
{
	vertOut OUT = (vertOut)0;
	
	float4 worldPosition = float4(IN.position.xyz,1);
	OUT.position = mul(WVP, worldPosition);
	
	float3 normal = IN.normal;
	OUT.worldNormal = mul(float3x3(WorldITXf), normal);
	OUT.uv = IN.texCoord;
	
	return OUT;
}

//Pixel Shader
float4 frag(vertOut IN): COLOR0
{
	// Pupil dilation
	float2 uvs = IN.uv - 0.5; // Center UVs
	float4 maskTex = tex2D(eyeMask, IN.uv);
	
	float invMaxDilation = 1 - maxDilation;
	
	uvs.x *= lerp(1, invMaxDilation, dilationXIntensity * maskTex.r);
	uvs.y *= lerp(1, invMaxDilation, dilationYIntensity * maskTex.r);
	uvs.xy += 0.5; // De-center UVs
	
	//Diffuse lighting
	float diff = saturate(dot(IN.worldNormal, normalize(-dirLight)));
	
	float4 diffTex = tex2DLinear(diffuseMap, uvs);
	
	float4 c = diffTex;
	
	if (useDirLight)
	{
		float4 cLight = c * diff * dirLightIntensity;
		c = lerp(cLight, c, ambientIntensity);
	}

	return  saturate(c);
}

//Technique
technique main {
	pass 
	{
		VertexProgram = compile arbvp1 vert();
		FragmentProgram = compile arbfp1 frag();
		DepthFunc = LEqual;
		DepthTestEnable = true;
		CullFace = back;
   }
}