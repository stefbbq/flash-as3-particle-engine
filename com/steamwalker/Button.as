package com.steamwalker {
	import flash.display.MovieClip;
	import flash.events.*;
	//tweening classes
	import com.greensock.*;
	import com.greensock.easing.*;
	//class
	
	public class Button extends MovieClip {
		//constructor
		public function Button(){
			config();
		}
		
		//
		//config
		public function config(title:String = ""){
			_hit.alpha = 0;
			_title._field.text = title;
			_title._field.embedFonts = true;
		}
		
		//
		//behaviour
		public function enable(){
			initBehaviour();
			TweenMax.to(_bg, .3, {removeTint:true, scaleX: 1, scaleY: 1, ease: Sine.easeInOut});
			TweenMax.to(_title, .3, {scaleX: 1, scaleY: 1, ease: Sine.easeInOut});
		}
		private function initBehaviour(){
			buttonMode = true;
			_hit.addEventListener(MouseEvent.ROLL_OVER, onOver);
			_hit.addEventListener(MouseEvent.ROLL_OUT, onOut);
		}
		public function disable(){
			deinitBehaviour();
			TweenMax.to(_bg, .3, {tint:0x666666, scaleX: 1, scaleY: 1, ease: Sine.easeInOut});
			TweenMax.to(_title, .3, {scaleX: 1, scaleY: 1, ease: Sine.easeInOut});
		}
		private function deinitBehaviour(){
			buttonMode = false;
			_hit.removeEventListener(MouseEvent.ROLL_OVER, onOver);
			_hit.removeEventListener(MouseEvent.ROLL_OUT, onOut);
		}
		
		//
		//events
		private function onOver(e:Event){
			TweenMax.to(_bg, 1, {tint:0xFFD0A6, scaleX: 1.15, scaleY: 1.15, ease: Elastic.easeOut});
			TweenMax.to(_title, 1.3, {scaleX: 1.2, scaleY: 1.2, ease: Elastic.easeOut, delay: .08});
		}
		private function onOut(e:Event){
			TweenMax.to(_bg, .25, {removeTint: true, scaleX: 1, scaleY: 1, ease: Sine.easeInOut});
			TweenMax.to(_title, .25, {scaleX: 1, scaleY: 1, ease: Sine.easeInOut});
		}
	}
}