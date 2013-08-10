package com {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.*;
	import flash.display.Sprite;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	//steamwalker classes
	import com.steamwalker.spots.Spots;
	import flash.sensors.Accelerometer;

	//class
	public class tester_iPhone extends MovieClip {
		private var _spotsObject:Spots;
		//trackers
		private var _date:Date;
		private var _oldTimestamp:Number;
		private var _xPosition:Number;
		private var _yPosition:Number;	
		//constructor
		public function tester_iPhone() {
			//config
			var touchSupport:Boolean = Multitouch.supportsTouchEvents;
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			_date = new Date();
			//init
			var fields = {air:5, airAngle:45};
			//var fields = {gravity:9};
			_spotsObject = Spots.omni({origin: new Point(0,0), rate: 1, lifespan: 5, startingSpeed: 1, speedRandom: 2, color:0x507090, colorRandom: 0.00001, size:2, sizeRandom: .1, fade: true, fields:fields});
			//_spotsObject = Spots.directional({speed: 50, origin: new Point(0,0), angle: 90});
			//_spotsObject = Spots.guided({speed: 20, origin: new Point(100,100), destination: new Point(300,300)});
			addChild(_spotsObject);
			setChildIndex(_spotsObject, 1);
			initBehaviour();
			//start
			_spotsObject.startEmitter();
			_spotsObject.emitterPosition = new Point(150, 150);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		//
		//behaviour
		public function initBehaviour(){
			var accl:Accelerometer;
			if(Accelerometer.isSupported){
				accl = new Accelerometer();
				accl.addEventListener(AccelerometerEvent.UPDATE, updateHandler);
			}
			bg.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchStart);
			bg.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			bg.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			bg.addEventListener(TouchEvent.TOUCH_TAP, onTouchTap);
			startBTN.addEventListener(MouseEvent.CLICK, function(){_spotsObject.startEmitter();});
			stopBTN.addEventListener(MouseEvent.CLICK, function(){_spotsObject.stopEmitter()});
		}
		//
		//events
		private function updateHandler(e:AccelerometerEvent){
			_spotsObject.airAngle = e.accelerationY;
		}
		private function onTouchStart(e:TouchEvent){
			
		}
		private function onTouchMove(e:TouchEvent){
			_xPosition = e.localX;
			_yPosition = e.localY;
		}
		private function onTouchEnd(e:TouchEvent){
		}
		public function onEnterFrame(e:Event){
			//_spotsObject.emitterPosition = new Point(_xPosition, _yPosition);
			_date = new Date();
			var ms = _date.getMilliseconds();
			tFPS.text = ("fps: " + Math.floor((ms < _oldTimestamp)? 1000 / ((ms + 1000) - _oldTimestamp) : 1000 / (ms - _oldTimestamp)));
			_oldTimestamp = ms;
		}
		private function onTouchTap(e:TouchEvent){
			//_spotsObject.emitterPosition = new Point(e.localX, e.localY);
		} 
	}
}