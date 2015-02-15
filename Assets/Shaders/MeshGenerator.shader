// Shader created with Shader Forge v1.04 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.04;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,limd:0,uamb:True,mssp:True,lmpd:False,lprd:False,rprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:0,bsrc:0,bdst:1,culm:0,dpts:2,wrdp:True,dith:2,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:1,x:33446,y:32475,varname:node_1,prsc:2|diff-5933-OUT,emission-9928-OUT,custl-7229-OUT;n:type:ShaderForge.SFN_TexCoord,id:4934,x:32340,y:32500,varname:node_4934,prsc:2,uv:0;n:type:ShaderForge.SFN_Append,id:4830,x:32544,y:32500,varname:node_4830,prsc:2|A-4934-V,B-4934-V,C-4934-V;n:type:ShaderForge.SFN_Vector1,id:2126,x:32340,y:32449,varname:node_2126,prsc:2,v1:0;n:type:ShaderForge.SFN_Tex2d,id:869,x:32653,y:32767,ptovrint:False,ptlb:GridTex,ptin:_GridTex,varname:node_869,prsc:2,tex:369e23fa06d98e74096bd38a3dcdc9cd,ntxv:0,isnm:False|UVIN-1949-OUT;n:type:ShaderForge.SFN_ValueProperty,id:9792,x:32180,y:32644,ptovrint:False,ptlb:quadsX,ptin:_quadsX,varname:node_9792,prsc:2,glob:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:2156,x:32180,y:32957,ptovrint:False,ptlb:quadsZ,ptin:_quadsZ,varname:_vertsX_copy,prsc:2,glob:False,v1:1;n:type:ShaderForge.SFN_TexCoord,id:7912,x:31985,y:32685,varname:node_7912,prsc:2,uv:0;n:type:ShaderForge.SFN_Multiply,id:2099,x:32180,y:32695,varname:node_2099,prsc:2|A-7912-U,B-9792-OUT;n:type:ShaderForge.SFN_Multiply,id:7050,x:32180,y:32816,varname:node_7050,prsc:2|A-7912-V,B-2156-OUT;n:type:ShaderForge.SFN_Append,id:1949,x:32399,y:32757,varname:node_1949,prsc:2|A-2099-OUT,B-7050-OUT;n:type:ShaderForge.SFN_Add,id:7229,x:33269,y:32498,varname:node_7229,prsc:2|A-5933-OUT,B-9928-OUT;n:type:ShaderForge.SFN_Color,id:8421,x:33075,y:32358,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_8421,prsc:2,glob:False,c1:0,c2:1,c3:0.6275864,c4:1;n:type:ShaderForge.SFN_Multiply,id:5933,x:33075,y:32500,varname:node_5933,prsc:2|A-7991-OUT,B-8421-RGB,C-4970-OUT;n:type:ShaderForge.SFN_Color,id:9943,x:32846,y:32767,ptovrint:False,ptlb:GridColor,ptin:_GridColor,varname:_Color_copy,prsc:2,glob:False,c1:0,c2:1,c3:0.6275864,c4:1;n:type:ShaderForge.SFN_Multiply,id:9928,x:32846,y:32620,varname:node_9928,prsc:2|A-869-RGB,B-9943-RGB;n:type:ShaderForge.SFN_Subtract,id:7991,x:32896,y:32500,varname:node_7991,prsc:2|A-6771-OUT,B-869-RGB;n:type:ShaderForge.SFN_VertexColor,id:6405,x:32674,y:32251,varname:node_6405,prsc:2;n:type:ShaderForge.SFN_Vector1,id:413,x:32674,y:32370,varname:node_413,prsc:2,v1:1;n:type:ShaderForge.SFN_Add,id:4970,x:32843,y:32336,varname:node_4970,prsc:2|A-6405-A,B-413-OUT;n:type:ShaderForge.SFN_OneMinus,id:6771,x:32708,y:32456,varname:node_6771,prsc:2|IN-4830-OUT;proporder:869-9792-2156-8421-9943;pass:END;sub:END;*/

Shader "Shader Forge/MeshGenerator" {
    Properties {
        _GridTex ("GridTex", 2D) = "white" {}
        _quadsX ("quadsX", Float ) = 1
        _quadsZ ("quadsZ", Float ) = 1
        _Color ("Color", Color) = (0,1,0.6275864,1)
        _GridColor ("GridColor", Color) = (0,1,0.6275864,1)
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            float4 unity_LightmapST;
            #ifdef DYNAMICLIGHTMAP_ON
                float4 unity_DynamicLightmapST;
            #endif
            uniform sampler2D _GridTex; uniform float4 _GridTex_ST;
            uniform float _quadsX;
            uniform float _quadsZ;
            uniform float4 _Color;
            uniform float4 _GridColor;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
                UNITY_FOG_COORDS(1)
                #ifndef LIGHTMAP_OFF
                    float4 uvLM : TEXCOORD2;
                #else
                    float3 shLight : TEXCOORD2;
                #endif
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
/////// Vectors:
////// Lighting:
////// Emissive:
                float2 node_1949 = float2((i.uv0.r*_quadsX),(i.uv0.g*_quadsZ));
                float4 _GridTex_var = tex2D(_GridTex,TRANSFORM_TEX(node_1949, _GridTex));
                float3 node_9928 = (_GridTex_var.rgb*_GridColor.rgb);
                float3 emissive = node_9928;
                float3 node_5933 = (((1.0 - float3(i.uv0.g,i.uv0.g,i.uv0.g))-_GridTex_var.rgb)*_Color.rgb*(i.vertexColor.a+1.0));
                float3 finalColor = emissive + (node_5933+node_9928);
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
