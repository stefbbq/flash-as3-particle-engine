package com.steamwalker {
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import flash.text.*;
	//tweening classes
	import com.greensock.*;
	import com.greensock.easing.*;
	//class
	public class Scroller extends MovieClip {
		//objects
		private var _rect:Rectangle;
		//properties
		private var _title:String;
		private var _min:Number;
		private var _max:Number;
		private var _propertyValue:String;
		private var _currentValue:Number;
		private var _roundToWhole:Boolean;
		//trackers
		private var _range:Number;
		private var _coef:Number;
		private var _enabled:Boolean;
		private var _active:Boolean;
		//contructor
		public function Scroller(title:String, propertyValue:String, min:Number, max:Number, value:Number = 0, roundToWhole:Boolean = false) {
			_title = title;
			_min = min;
			_max = max;
			_range = _max - _min;
			_coef = 100 / _range;
			if(value != 0) _currentValue = value;
			_propertyValue = propertyValue;
			_roundToWhole = roundToWhole;
			config();
			enable();
		}
		//
		//config
		public function config(){
			//stage
			_rect = new Rectangle(-50, 0, 100, 0);
			_fTitle.text = _title;
			_rail.alpha = .2;
			_thumb._hit.alpha = 0;
			_thumb.x = -50;
			_number._field.autoSize = TextFieldAutoSize.CENTER;
			//value
			if(_currentValue) setValue();
		}
		public function setValue(){
			_thumb.x = (_currentValue * _coef) - 50;
			_number.x = (_currentValue * _coef) - 50;
			_number._field.text = _currentValue;
		}
		//
		//behaviour
		public function enable(){
			_enabled = true;
			setTimeout(initBehaviour, 200);
		}
		private function initBehaviour(){
			_thumb.buttonMode = true;
			_thumb._hit.addEventListener(MouseEvent.ROLL_OVER, onThumbOver);
			_thumb._hit.addEventListener(MouseEvent.ROLL_OUT, onThumbOut);
			_thumb._hit.addEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
			_rail.buttonMode = true;
			_rail.addEventListener(MouseEvent.ROLL_OVER, onRailOver);
			_rail.addEventListener(MouseEvent.ROLL_OUT, onRailOut);
			_rail.addEventListener(MouseEvent.CLICK, onRailClick);
			stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp);
		}
		public function disable(){
			_enabled = false;
			deinitBehaviour();
		}
		private function deinitBehaviour(){
			_thumb.buttonMode = false;
			_thumb._hit.removeEventListener(MouseEvent.ROLL_OVER, onThumbOver);
			_thumb._hit.removeEventListener(MouseEvent.ROLL_OUT, onThumbOut);
			_thumb._hit.removeEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
			_rail.buttonMode = false;
			_rail.removeEventListener(MouseEvent.ROLL_OVER, onRailOver);
			_rail.removeEventListener(MouseEvent.ROLL_OUT, onRailOut);
			_rail.removeEventListener(MouseEvent.CLICK, onRailClick);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp);
		}
		//
		//events
		private function onThumbOver(e:Event){
			TweenMax.to(_thumb, .3, {tint:0xFFB16A, ease: Sine.easeInOut});
		}
		private function onThumbOut(e:Event){
			if(!_active) animThumbOut();
		}
		private function onThumbDown(e:Event){
			_thumb.startDrag(true, _rect);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
			_active = true;
		}
		private function onThumbUp(e:Event){
			if(_active){
				_thumb.stopDrag();
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
				_active = false;
			}
		}
		private function onThumbMove(e:Event = null){
			if(_roundToWhole){
				_currentValue = Math.round(((_thumb.x + 50)/100) * _range + _min);
			} else {
				_currentValue = Math.round(100 * (((_thumb.x + 50)/100) * _range + _min)) / 100;
			}
			_number.x = _thumb.x;
			_number._field.text = _currentValue;
			dispatchEvent(new Event("NEW_VALUE"));
		}
		private function onRailOver(e:Event){
			TweenMax.to(_rail, .2, {alpha: .5, ease: Sine.easeInOut});
		}
		private function onRailOut(e:Event){
			TweenMax.to(_rail, .2, {alpha: .2, ease: Sine.easeInOut});
		}
		private function onRailClick(e:Event){
			_thumb.x = _rail.mouseX;
			if(_thumb.x < -50){
				_thumb.x = -50;
			} else if (_thumb.x > 50) {
				_thumb.x = 50;
			}
			onThumbMove();
		}
		//
		//animation
		private function animThumbOut(){
			TweenMax.to(_thumb, .2, {removeTint:true, ease: Sine.easeInOut});
		}
		//
		//get&set
		public function get propertyValue():String {return _propertyValue;}
		public function get newValue():Number {return _currentValue;}
	}	
}