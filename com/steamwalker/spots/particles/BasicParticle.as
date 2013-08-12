package com.steamwalker.spots.particles {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;

	//class
	public class BasicParticle extends Sprite {
		private var _spawnTime:Number;
		private var _id:Number;
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
		
		//dynamic trackers
		private var _oldPosition:Array;	
		private var _oldRotation:Number;
		private var _vector:Array;
		private var _rotation:Number;

		//for guided
		private var _destination:Point;
		
		//
		//constructor
		public function BasicParticle($vars:Object, $id:Number, $spawnTime:Number){
			config($vars, $id, $spawnTime);
		}
		
		//
		//config
		private function config($vars:Object, $id:Number, $spawnTime:Number):void {
			_spawnTime = $spawnTime;	
			_id = $id;
			_vars = $vars;
			_refreshRate = $vars.refreshRate;
			_vector = [null, null, null];
			
			//basics
			x = _vars.origin.x;
			y = _vars.origin.y;
			z = 0;
			rotation = 0;
			_lifespan = _vars.lifespan;
			alpha = _vars.opacity;
			
			//set trackers
			_oldPosition = [x,y,z];	
			//_oldRotation = rotation;

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
			var bitmapData = new BitmapData(size, size, true, parseInt(color, 16));
			var bitmap:Bitmap = new Bitmap(bitmapData);
			addChild(bitmap); 
			/*var shape:Shape = new Shape;
			shape.graphics.beginFill(0xFFFFFF);
			shape.graphics.drawCircle(0, 0, size);
			shape.graphics.endFill();
			addChild(shape);*/
			//bitmapData.draw(shape);
			cacheAsBitmap = true;
		}
		public function increment($currentTime):void {
			//calculate vector and apply drag
			_vector[0] = (x - _oldPosition[0]) * .98;
			_vector[1] = (y - _oldPosition[1]) * .98;
			_vector[2] = (z - _oldPosition[2]) * .98;
			_oldPosition = [x,y,z];
			
			if(y > 766){ _vector[1] = -_vector[1];} 
			
			//update
			x += _vector[0];
			y += _vector[1];
			z += _vector[2];
			
			//other stuffs
			_progress = ($currentTime - _spawnTime) / (_lifespan * 1000);
			//_life = $currentTime - _spawnTime;
		}
		public function update($update):void {
			//set position
			x += $update.vector[0];
			y += $update.vector[1];
			z += $update.vector[2];
			rotation += 1;
		}
		
		//
		//utils
		public function reset($vars:Object, $id:Number, $spawnTime:Number):void {
			config($vars, $id, $spawnTime);
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
		public function get vector():Array{return _vector;}						//GET vector
		//for guided
		public function get destination():Point{return _destination}
		public function set destination(destination:Point){_destination = destination}
	}
}