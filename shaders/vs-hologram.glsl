uniform mat4 iModelMat;

attribute vec3 tangent;

// TODO: can we compute this in cpu?
varying mat3 vINormMat;

varying vec3 vTang;
varying vec3 vNorm;
varying vec3 vMNorm;
varying vec3 vBino;
varying vec2 vUv;

varying vec3 vEye;
varying vec3 vMPos;
varying vec3 vPos;

$matInverse

void main(){

  vec3 pos = position;
  vUv = uv;
  

  vMNorm = normalMatrix * normal;
  vNorm = normal;
  vTang = tangent;
  
  vNorm = normal;
  vTang = tangent;

  vBino = cross( vNorm , vTang );

  mat3 normMat = mat3(
    vNorm.x , vNorm.y , vNorm.z ,
    vTang.x , vTang.y , vTang.z ,
    vBino.x , vBino.y , vBino.z 
  );

  //normMat = normalMatrix * normMat;
  vINormMat = matInverse( normMat );

  vMPos = ( modelMatrix * vec4( pos , 1. ) ).xyz;
  //vMPos = pos.xyz;

  vec3 iCamPos = ( iModelMat * vec4( cameraPosition , 1. ) ).xyz;
  vEye = iCamPos - pos;
  vPos = pos;

  gl_Position = projectionMatrix * modelViewMatrix * vec4( pos , 1. );


}
