package com.steamwalker.spots {
	import flash.display.*
	import flash.ui.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	//
	import com.steamwalker.spots.particles.*;
	import com.steamwalker.spots.emitters.*;
	import com.steamwalker.spots.fields.*;
	//class
	public class Spots extends MovieClip {
		//data
		private var _vars:Object;
		//internal
		private var _emitter:*;
		private var _emitterPosition:Point;
		private var _emitterType:Function;
		private var _type:String;
		private var _refreshRate:Number;
		private var _active = false;
		
		//
		//constructor
		public function Spots(type:String, vars:Object):void{
			_type = type;
			_vars = vars;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event){
			_vars.refreshRate = 1000 / stage.frameRate;
			config();
		}
		private function config(){
			switch(_type){
				case "omni":
					_emitter = new Omni(_vars);
					break;
				case "directional":
					//_emitter = new Directional(_vars, stage.stageWidth, stage.stageHeight);
					break;
				case "guided":
					//_emitter = new Guided(_vars);
					break;
			}
			addChild(_emitter);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		//
		//inits
		public static function omni(vars:Object):Spots{
			return new Spots("omni", vars);
		}
		public static function directional(vars:Object):Spots{
			return new Spots("directional", vars);
		}
		public static function guided(vars:Object):Spots{
			return new Spots("guided", vars);
		}
		
		//
		//emitter control
		public function startEmitter(){
			if(this.stage) _active = true;
		}
		public function stopEmitter(){
			if(this.stage && _active) _active = false;
		}
		public function pauseEmitter(){
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		//
		//emitter animation
		private function onEnterFrame(e:Event){
			if(_active) _emitter.spawnParticle();
			_emitter.updateParticles();
		}
		
		//
		//set new parameter
		public function updateVariable($key:String, value:*){
			for(var key in _vars){
				if($key == key) _vars[key] = value;
			}
		}
		public function updateFields($key:String, value:*){
			for(var key in _vars.fields){
				if($key == key) _vars.fields[key] = value;
			}
		}
		
		//
		//getter and setter
		public function get particleCount():Number {return _emitter.particleCount; }
		public function get particlePoolCount():Number {return _emitter.particlePoolCount; }
	}
}