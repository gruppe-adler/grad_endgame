// Parameters
private ["_object", "_attach"];
_object = _this param [0, objNull, [objNull]];
_attach = _this param [1, [0.6, -0.5, 0.0], [[]]];

//Particle effect
private "_effect";
_effect = "#particlesource" createVehicleLocal position _object;
_effect setParticleClass "AmmoSmokeParticles2";

//Should effect be attached to object?
_effect attachto [_object, _attach];