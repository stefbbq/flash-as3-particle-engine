package com.steamwalker.spots.emitters {
	import com.steamwalker.spots.fields.Gravity;
	import com.steamwalker.spots.fields.Turbulance;
	import com.steamwalker.spots.particles.BasicParticle;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	//class
	public class Omni extends MovieClip implements IEmitter {
		private var _particles:Vector.<BasicParticle>; //holds each active particle instance
		private var _particleID:Number;
		public var _vars:Object; //hash containing all of the user specified variables
		//trackers
		private var _date:Date;
		
		//
		//constructor
		public function Omni(vars:Object){
			_date = new Date();
			_particles = new Vector.<BasicParticle>;
			_vars = vars;
		
			//configure basics
			_particleID = 0;
			if(!_vars.lifespan) _vars.lifespan = 5;
			if(!_vars.startingSpeed) _vars.startingSpeed = 5;
		}
		
		//
		//automatic
		public function spawnParticle(){
			for(var i = 0; i < _vars.rate; i++){
				_particleID++;
				var particle:BasicParticle = new BasicParticle(_vars, _particleID, new Date().valueOf());
				particle.update({vector:[
					Math.random() * _vars.startSpeed - _vars.startSpeed / 2, 
					Math.random() * _vars.startSpeed - _vars.startSpeed / 2, 
					0]});
				_particles.push(particle);
				addChild(particle);
			}
		}
		public function updateParticles(){
			var offsetY:Number = 0;
			var offsetX:Number = 0;
			var offsetAngle:Number = 0;
			var applyDrag:Number = 1;
			
			//aggregate fields			
			for (var i = 0; i < _particles.length; i++){
				var target = _particles[i];
				target.increment(new Date().valueOf());
				var newX = 0;
				var newY = 0;
				var newZ = 0;
				
				for(var field in _vars.fields){
					switch(field){
						case "gravity":
							var newGravityVector = Gravity.newVector(_vars.fields[field]);
							newX += newGravityVector[0];
							newY += newGravityVector[1];
							newZ += newGravityVector[2];
							break;
						case "gravityDestination":
							var newGravityDestinationVector = Gravity.newVectorDestination(_vars.fields[field] * .1, [target.x, target.y], _vars.fields.gravityDestinationPosition);
							newX += newGravityDestinationVector[0];
							newY += newGravityDestinationVector[1];
							newZ += newGravityDestinationVector[2];
							break;
						case "turbulance":
							var newTurbulanceVector = Turbulance.newVector(_vars.fields[field]); 
							newX += newTurbulanceVector[0];
							newY += newTurbulanceVector[1];
							newZ += newTurbulanceVector[2];
							break;
					}
				}
				var newValues = {vector:[newX,newY,newZ], rotation:0};
				target.update(newValues);
				
				//kill expired particle				
				if(target.progress >= 1){
					_particles.splice(i, 1);
					removeChild(target);
				}
			}
		}
		//
		//get and set
		public function get particles():Vector.<BasicParticle>{return _particles;}
		public function get particleCount():Number{return _particles.length; }
		public function set airAngle(angle:Number){
			_vars.fields.airAngle = angle;
		}
	}
}