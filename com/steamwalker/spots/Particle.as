package com.steamwalker.spots {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.display.*;

	//class
	public class Particle extends Sprite{
		private var _spawnTime:Number;
		private var _vars:Object;
		private var _refreshRate:Number;
		private var _origin:Point;
		
		//trackers
		private var _lifespan:Number;
		private var _life:Number;
		private var _startingSpeed:Number;
		private var _currentSpeed:Number;
		private var _progress:Number;
		private var _angle:Number;
		private var _vx:Number;
		private var _vy:Number;
		private var _vz:Number;

		//for guided
		private var _destination:Point;
		
		//
		//constructor
		public function Particle($vars:Object, $spawnTime:Number){
			//set defaults
			_spawnTime = $spawnTime;
			_vars = $vars;
			_refreshRate = $vars.refreshRate;
			
			config();
		}
		
		//
		//config
		private function config(){
			//basics
			x = _vars.origin.x;
			y = _vars.origin.y;
			_lifespan = _vars.lifespan;
			//alpha = _vars.opacity;

			//speed
			_startingSpeed = _vars.startingSpeed;
			if(_vars._speedRandom) _startingSpeed = (_startingSpeed - ((_vars._speedRandom * _startingSpeed) / 2)) + ((_vars.speedRandom * _startingSpeed) * Math.random());
			_currentSpeed = _startingSpeed;

			//size
			var size = (_vars.size)? _vars.size : 1;
			if(_vars.sizeRandom && _vars.size != 0) size = (size - ((_vars.sizeRandom * size) / 2)) + ((_vars.sizeRandom * size) * Math.random());
			if(size < 1) size = 1;

			//color
			var color = (_vars.color)? _vars.color : 0x000000;
			if(_vars.colorRandom){
				var range = (_vars.colorRandom * 16777215);
				var colorRandom = range * Math.random();
				color = (color - (range / 2)) + colorRandom;
				if(color > 16777215) color = 16777215;
				if(color < 0) color = 0;
			}
			color = Number(_vars.opacity * 255).toString(16) + color.toString(16);
			
			//draw
			var bitmapData = new BitmapData(size,size,true, parseInt(color, 16));
			var bitmap:Bitmap = new Bitmap(bitmapData);
			addChild(bitmap); 
			//var shape:Sprite  = new Sprite;
			//graphics.beginFill(color);
//			graphics.drawCircle(0, 0, size);
//			graphics.endFill();
			//bitmapData.draw(shape);
			//cacheAsBitmap = true;
		}
		public function increment(_currentTime):void{
			_progress = (_currentTime - _spawnTime) / (_lifespan * 1000);
			_life = _currentTime - _spawnTime;
		}
		
		//
		//setters and getters
		public function get angle():Number{return _angle}						//GET angle		
		public function set angle(angle:Number){_angle = angle} 				//>SET angle
		public function get lifespan():Number{return _lifespan}					//GET lifespan
		public function set lifespan(lifespan:Number){_lifespan = lifespan}		//>SET lifespan
		public function get origin():Point{return _origin;}						//GET origin
		public function set origin(origin:Point){_origin = origin;}				//>SET origin
		public function get life():Number{return _life;}						//GET life
		public function get progress():Number{return _progress;}				//GET process
		public function get currentSpeed():Number{return _currentSpeed;}		//GET currentSpeed
		//for guided
		public function get destination():Point{return _destination}
		public function set destination(destination:Point){_destination = destination}
	}
}