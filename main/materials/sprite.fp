varying mediump vec2 var_texcoord0;

uniform lowp sampler2D tex1;
uniform lowp sampler2D tex2;
uniform lowp sampler2D tex3;
uniform lowp sampler2D tex4;
uniform lowp sampler2D tex5;
uniform lowp vec4 tint;
uniform lowp vec4 resolution;
uniform lowp vec4 bg;
uniform lowp vec4 mc;

#define PI 3.14159265358979323846

float random(vec2 st)
{
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
    sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}

mat2 scale(vec2 _scale)
{
    return mat2(_scale.x,0.0,0.0,_scale.y);
}

float box(vec2 _st, vec2 _size){
    _size = vec2(0.5)-_size*0.5;
    vec2 uv = step(_size,_st);
    uv *= step(_size,vec2(1.0)-_st);
    return uv.x*uv.y;
}

vec4 random_texture(in vec2 uv, in vec3 resolution, in float _scale)
{
    vec2 id = floor(uv);
    float rot = PI*random(id);
    int index = int(id.x + id.y * resolution.x / resolution.z) % 5;

    vec4 col = vec4(0);

    vec2 box_uv = fract(uv) - vec2(0.5);
    box_uv = scale( vec2(_scale) ) * box_uv;
    box_uv = box_uv + vec2(0.5);

    float alpha = box(rotate2D(box_uv, rot),vec2(1));
    uv = rotate2D(fract(uv),rot);

    uv = fract(uv) - vec2(0.5);
    uv = scale( vec2(_scale) ) * uv;
    uv = fract(uv) + vec2(0.5);

    if (index == 0) 
    col = texture2D(tex1,uv);
    else if (index == 1) 
    col = texture2D(tex2,uv);
    else if (index == 2) 
    col = texture2D(tex3,uv);
    else if (index == 3) 
    col = texture2D(tex4,uv);
    else
    col = texture2D(tex5,uv);

    col.a *= alpha;
    
    return col;
}

void main()
{
    vec2 uv = vec2(var_texcoord0.x * resolution.x / resolution.z, var_texcoord0.y * resolution.y / resolution.z);
    uv = rotate2D(uv,PI*0.2);
    lowp vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);

    vec4 col = random_texture(uv, vec3(resolution.xy, resolution.z), 1.4);
    if (col.a > 0)
    gl_FragColor =  col * mc * tint_pm;
    else
    gl_FragColor = bg * tint_pm; //chess(botom_color, top_color, uv);
}
