$input a_position, a_normal, a_texcoord0, a_color0
#if QUAD_VARIANT_MRT_TRANSPARENCY
$output v_color0, v_texcoord0, v_texcoord1
	#define v_uv v_texcoord0.xy
	#define v_clipZ v_texcoord0.z
	#define v_normal v_texcoord1.xyz
#elif QUAD_VARIANT_MRT_LIGHTING || QUAD_VARIANT_TEX
$output v_color0, v_texcoord0, v_texcoord1
	#define v_uv v_texcoord0.xy
	#define v_metadata v_texcoord0.z
	#define v_linearDepth v_texcoord0.w
	#define v_normal v_texcoord1.xyz
#elif QUAD_VARIANT_MRT_SHADOW_SAMPLE == 0
$output v_color0
#endif


#define IS_SHADOW_PASS (QUAD_VARIANT_MRT_SHADOW_PACK || QUAD_VARIANT_MRT_SHADOW_SAMPLE)

#include "./include/bgfx.sh"
#include "./include/config.sh"
#include "./include/quad_lib.sh"
#include "./include/game_uniforms.sh"
#include "./include/voxels_uniforms.sh"
#include "./include/global_lighting_uniforms.sh"
#include "./include/voxels_lib.sh"

void main() {
	vec4 model = vec4(a_position.xyz, 1.0);
	vec4 clip = mul(u_modelViewProj, model);

#if IS_SHADOW_PASS

	gl_Position = clip;
#if QUAD_VARIANT_MRT_SHADOW_PACK
	v_color0 = clip;
#endif

#else // IS_SHADOW_PASS

#if QUAD_VARIANT_MRT_LINEAR_DEPTH
	vec4 view = mul(u_modelView, model);
#endif

	vec4 color = a_color0;
#if QUAD_VARIANT_MRT_LIGHTING == 0
	float meta[5]; unpackQuadFullMetadata(a_position.w, meta);
	float unlit = meta[0];
	vec4 srgb = vec4(meta[1], meta[2], meta[3], meta[4]);

	color = mix(getNonVolumeVertexLitColor(color, srgb.x * u_bakedIntensity, srgb.yzw, u_sunColor.xyz, clip.z), color, unlit);
#endif

	gl_Position = clip;
	v_color0 = color;
#if QUAD_VARIANT_TEX
	v_uv = a_texcoord0.xy;
#endif
#if QUAD_VARIANT_MRT_TRANSPARENCY
	v_clipZ = clip.z;
#elif QUAD_VARIANT_MRT_LIGHTING || QUAD_VARIANT_TEX
	v_metadata = a_position.w;
#if QUAD_VARIANT_MRT_LINEAR_DEPTH
	v_linearDepth = view.z;
#endif
#endif // QUAD_VARIANT_MRT_TRANSPARENCY
#if QUAD_VARIANT_MRT_LIGHTING || QUAD_VARIANT_MRT_TRANSPARENCY
	v_normal = a_normal;
#endif

#endif // IS_SHADOW_PASS
}
