uniform float stepDepth;
uniform float oscillationSize;
uniform vec3 lightPos;
uniform sampler2D t_text;

uniform float time;

varying mat3 vINormMat;

varying vec3 vTang;
varying vec3 vNorm;
varying vec3 vMNorm;
varying vec3 vBino;

varying vec2 vUv;

varying vec3 vEye;
varying vec3 vMPos;
varying vec3 vPos;

$hsv
$simplex

#define STEPS 5
vec4 volumeColor( vec3 ro , vec3 rd , mat3 iBasis ){

  vec3 col = vec3(0.);
  float lum = 0.;
  for( int i = 0; i < STEPS; i++ ){

    vec3 p = ro - rd * float( i ) * stepDepth;
   
    p = iBasis * p;
    float lu = snoise( (p.yz * 6. + vec2( time * .2  , 0. )) );
    lu += snoise( (p.yz * 13. + vec2( time * .1  , 0. )) );

    float id = float( i ) / float( STEPS );

    vec4 t = texture2D( t_text , vec2( -p.y * 2.  + .5 , p.z * 2. + .5 )  );

    vec3 c = hsv( p.x * 6.  + lu / 20. + sin( time  * .1 ), 1. , .4 ); 
    col += t.a * c  + ((1.-t.a) * (1.-c)) ;
    col *= ((lu+1.)/2. + t.a);

    if( lu > (-p.x  * 40.) + 2.3 ){ col =  float( STEPS ) * normalize( col );  break; }

  } 



  vec4 fC = vec4( col , 1. ) / float( STEPS );
   return vec4( vec3(1.3) - fC.xyz , 1.);


}

void main(){


  vec3 col = vTang * .5 + .5;
  float alpha = 1.;

  vec3 lightDir = normalize( lightPos - vMPos );
  vec3 reflDir = reflect( lightDir , vNorm );
  
  float lightMatch = max( 0. , dot(-lightDir ,  vNorm ) );
  float reflMatch = max( 0. , dot(reflDir ,  vEye) );

  reflMatch = pow( reflMatch , 20. );

  vec4 volCol = volumeColor( vPos , normalize(vEye) , vINormMat );

  vec3 lambCol = lightMatch * volCol.xyz;
  vec3 reflCol = reflMatch * (vec3(1.) - volCol.xyz);

  vec4 aCol = texture2D( t_text, vUv );

  col = volCol.xyz;

  gl_FragColor =  vec4( col  , 1.  );


  //gl_FragColor = vec4( normalize( vEye ) * .5 + .5 , 1. );
  //gl_FragColor = vec4( vTang , 1. ); 

}
