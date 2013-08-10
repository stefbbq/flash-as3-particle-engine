package com.steamwalker.spots.emitter {
	import flash.display.MovieClip;	
	import flash.geom.Point;
	//steamwalker classes
	import com.steamwalker.spots.*;
	//class
	public class Omni extends MovieClip implements IEmitter {
		private var _particles:Vector.<Particle>; //holds each active particle instance
		public var _vars:Object; //hash containing all of the user specified variables
		//trackers
		private var _date:Date;
		
		//
		
		//constructor
		public function Omni(vars:Object){
			_date = new Date();
			_particles = new Vector.<Particle>;
			_vars = vars;
			//configure basics
			if(!_vars.lifespan) _vars.lifespan = 5;
			if(!_vars.startingSpeed) _vars.startingSpeed = 5; 
		}
		
		//
		//automatic
		public function spawnParticle(){
			for(var i = 0; i < _vars.rate; i++){
				var particle:Particle = new Particle(_vars, new Date().valueOf());
				particle.angle = 360 * Math.random();
				_particles.push(particle);
				addChild(particle);
			}
		}
		public function updateParticles(){
			var offsetY:Number = 0;
			var offsetX:Number = 0;
			var offsetAngle:Number = 0;
			var applyDrag:Number = 1;
			for (var i = 0; i < _particles.length; i++){
				var target = _particles[i];
				target.increment(new Date().valueOf());
				//fields
				if(_vars.fields){
					//if(_vars.fields.turbulance) offsetAngle = ((_vars.fields.turbulance * 20) * Math.random()) - (_vars.fields.turbulance * 10);
					if(_vars.fields.air && !_vars.fields.airAngle){
						offsetY = _vars.fields.air * (target.life / 1000); 
					} else if (_vars.fields.air && _vars.fields.airAngle){
						var rA = (_vars.fields.airAngle / 180) * Math.PI;
						var rB = (90 - _vars.fields.airAngle / 180) * Math.PI;
						offsetX = Math.sin(rA) * (_vars.fields.air * (target.life) / 1000);
						offsetY = Math.cos(rB) * (_vars.fields.air * (target.life) / 1000);						
					}
					/*if(_vars.fields.drag){
						var drag = _vars.fields.drag * 1000;
						applyDrag = Math.abs((target.life < drag)? (target.life / drag) - 1 : 0);
					}*/
				}
				//calculate new position
				var radA = (target.angle / 180) * Math.PI;
				var radB = (90 - target.angle / 180) * Math.PI;
				var destinationX = ((Math.sin(radA) * target.currentSpeed) + offsetX) * applyDrag;
				var destinationY = ((Math.cos(radB) * target.currentSpeed) + offsetY) * applyDrag;
				//set updated state
				target.x += destinationX;
				target.y += destinationY;
				//if(_vars.fade) target.alpha = Math.abs(-target.progress + 1);
				if(target.progress >= 1){
					_particles.splice(i, 1);
					removeChild(target);
				}
			}
		}
		//
		//get and set
		public function get particles():Vector.<Particle>{return _particles;}
		public function get particleCount():Number{return _particles.length; }
		public function set airAngle(angle:Number){
			_vars.fields.airAngle = angle;
		}
	}
}