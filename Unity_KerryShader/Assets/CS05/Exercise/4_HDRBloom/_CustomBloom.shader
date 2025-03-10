﻿// 第一步:把发光区域抠出来
// 第二部:
Shader "Hidden/_CustomBloom"
{
	CGINCLUDE
	#include "UnityCG.cginc"

	sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	float _Threshold;
	sampler2D _BloomTex;
	float _Intensity;

	// 第一步:把发光区域抠出来
	half4 frag_PreFilter(v2f_img i) : SV_Target
	{
		half4 d = _MainTex_TexelSize.xyxy * half4(-1, -1, 1, 1);
		half4 color = 0;
		color += tex2D(_MainTex, i.uv + d.xy);
		color += tex2D(_MainTex, i.uv + d.zy);
		color += tex2D(_MainTex, i.uv + d.xw);
		color += tex2D(_MainTex, i.uv + d.zw);
		color *= 0.25;

		// 求出rgb中颜色最亮的分量
		float br = max(max(color.r, color.g), color.b);
		br = max(0, (br - _Threshold)) / max(br, 0.00001f);	// 取出阈值
		color.rgb *= br;
		return color;
	}

	// 第二步，降采样模糊
	half4 frag_DownsampleBox(v2f_img i) : SV_Target
	{
		half4 d = _MainTex_TexelSize.xyxy * half4(-1, -1, 1, 1);

		half4 s = 0;
		s += tex2D(_MainTex, i.uv + d.xy);
		s += tex2D(_MainTex, i.uv + d.zy);
		s += tex2D(_MainTex, i.uv + d.xw);
		s += tex2D(_MainTex, i.uv + d.zw);
		s *= 0.25;
		return s;
	}

	// 第三步，升采样模糊
	half4 frag_UpsampleBox(v2f_img i) : SV_Target
	{
		half4 d = _MainTex_TexelSize.xyxy * half4(-1, -1, 1, 1);
		half4 color = 0;
		color += tex2D(_MainTex, i.uv + d.xy);
		color += tex2D(_MainTex, i.uv + d.zy);
		color += tex2D(_MainTex, i.uv + d.xw);
		color += tex2D(_MainTex, i.uv + d.zw);
		color *= 0.25;

		half4 color2 = tex2D(_BloomTex, i.uv);
		return color + color2;
	}

	// 第四步，合并
	half4 frag_Combine(v2f_img i) : SV_Target
	{
		half4 d = _MainTex_TexelSize.xyxy * half4(-1, -1, 1, 1);

		half4 base_color = tex2D(_MainTex, i.uv);
		half4 bloom_color = tex2D(_BloomTex, i.uv);
		half3 final_color = base_color.rgb + bloom_color.rgb * _Intensity;
		return half4(final_color, 1.0);
	}

	ENDCG

	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BlurOffset("BlurOffset",Float) = 1 
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always
		// 0 阈值
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag_PreFilter
			ENDCG
		}
		// 1 降采样模糊
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag_DownsampleBox
			ENDCG
		}
		// 2 升采样模糊
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag_UpsampleBox
			ENDCG
		}
		// 3 合并
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag_Combine
			ENDCG
		}
	}
}
