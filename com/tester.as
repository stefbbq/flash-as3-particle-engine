﻿package com {
	import flash.geom.Point;
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.utils.setTimeout;
	//steamwalker classes
	import com.steamwalker.spots.Spots;
	import com.steamwalker.Scroller;
	//class
	public class tester extends MovieClip {
		//objects
		private var _spotsObject:Spots;
		private var _fields:Object;
		private var _scrollers:Array;
		private var _fieldScrollers:Array;
		
		//trackers
		private var _date:Date;
		private var _oldTimestamp:Number;
		private var _newTimestamp:Number;
		
		//
		//constructor
		public function tester() {
			_date = new Date();			
			configStage();
			configEditor();
			configSpots();			
			onStartBTN();
		}
		public function configStage(){
			stopBTN.config("stop");
			startBTN.config("start");
			tParticles.autoSize = TextFieldAutoSize.LEFT;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			startBTN.addEventListener(MouseEvent.CLICK, onStartBTN);
			stopBTN.addEventListener(MouseEvent.CLICK, onStopBTN);
			emitterObject.addEventListener(MouseEvent.MOUSE_DOWN, onEmitterMouseDown);
			emitterObject.addEventListener(MouseEvent.MOUSE_UP, onEmitterMouseUp);
			gravObject.addEventListener(MouseEvent.MOUSE_DOWN, onGravMouseDown);
			gravObject.addEventListener(MouseEvent.MOUSE_UP, onGravMouseUp);
		}
		public function configSpots(){
			_fields = {turbulance: 1, gravity: .5, gravityDestination: .5, gravityDestinationPosition: [gravObject.x, gravObject.y]};
			//_fields = {gravityDestination: .5, gravityDestinationPosition: [gravObject.x, gravObject.y]};
			//_fields = {gravity: .5};
			//var fields = {gravity:9};
			_spotsObject = Spots.omni({origin: new Point(0,0), rate: .1, lifespan: 2, startSpeed: 1, speedRandom: 2, color:0xeebbdd, colorRandom: 0.00001, size:4, sizeRandom: .1, opacity: .5, fade: true, fields:_fields});
			//_spotsObject = Spots.directional({speed: 50, origin: new Point(0,0), angle: 90});
			//_spotsObject = Spots.guided({speed: 20, origin: new Point(100,100), destination: new Point(300,300)});
			addChild(_spotsObject);
			setChildIndex(_spotsObject, 0);
			initBehaviour();
			//start
			_spotsObject.startEmitter();
			//setTimeout(function(){ _spotsObject.stopEmitter(); }, 40);
			
		}
		public function configEditor(){
			_scrollers = [];
			_scrollers.push(new Scroller('Rate', 'rate', 0, 30, 10, true));
			_scrollers.push(new Scroller('Lifespan', 'lifespan', 1, 30, 30, true));
			_scrollers.push(new Scroller('Start Speed', 'startSpeed', 0, 10, 2));
			_scrollers.push(new Scroller('Speed Random', 'speedRandom', 0, 1, .5));
			//_scrollers.push(new Scroller('Color Random', 'colorRandom', 0, .1, 0.01));
			_scrollers.push(new Scroller('Size', 'size', 1, 10, 4, true));
			_scrollers.push(new Scroller('Size Random', 'sizeRandom', 0, 1, .5));
			_scrollers.push(new Scroller('Opacity', 'opacity', .1, 1, .5));
			for(var i = 0; i < _scrollers.length; i++){
				var target = _scrollers[i];
				target.x = 84;
				target.y = 75 + (i * 50);
				target.addEventListener("NEW_VALUE", onUpdateScroller);
				addChild(target);
			}
			_fieldScrollers = [];
			_fieldScrollers.push(new Scroller('Gravity', 'gravity', 0, 1, .5));
			_fieldScrollers.push(new Scroller('Grav Destination', 'gravityDestination', 0, 5, 2));
			_fieldScrollers.push(new Scroller('Turbulance', 'turbulance', 0, 4, 1));
			//_fieldScrollers.push(new Scroller('Drag', 'drag', 0, 20, 5));
			//_fieldScrollers.push(new Scroller('Turbulance', 'turbulance', 0, 40, 10));
			for(var i = 0; i < _fieldScrollers.length; i++){
				var target = _fieldScrollers[i];
				target.x = 84;
				target.y = _scrollers[_scrollers.length - 1].y + (i * 50) + 50;
				target.addEventListener("NEW_VALUE", onUpdateFieldScroller);
				addChild(target);
			}
		}
		
		//
		//behaviour
		public function initBehaviour(){
			/*
			for(var i = 0; i < numChildren; i++){
				var target = getChildAt(i);
				if(target is TextField){
					target.addEventListener(KeyboardEvent.KEY_DOWN,onTextEnter);
				}
			}*/
		}
		
		//
		//events
		public function onStartBTN(e:Event = null){
			_spotsObject.startEmitter();
			stopBTN.enable();
			startBTN.disable();
		}
		public function onStopBTN(e:Event){
			_spotsObject.stopEmitter();
			startBTN.enable();
			stopBTN.disable();
		}
		public function onEnterFrame(e:Event){
			_date = new Date();
			var ms = _date.getMilliseconds();
			tFPS.text = ("fps: " + Math.floor((ms < _oldTimestamp)? 1000 / ((ms + 1000) - _oldTimestamp) : 1000 / (ms - _oldTimestamp)));
			_oldTimestamp = ms;
			_spotsObject.updateVariable("origin", new Point(emitterObject.x, emitterObject.y));
			_spotsObject.updateFields("gravityDestinationPosition", [gravObject.x, gravObject.y]);
			tParticles.text = "particles: " + _spotsObject.particleCount.toString();
			tParticlePool.text = "particlePool: " + _spotsObject.particlePoolCount.toString();
		}
		private function onTextEnter(e:KeyboardEvent){
			var target = e.currentTarget;
			if(e.charCode == 13){
				trace("changing: " + target.name.substr(1) + " to " + target.text);
				_spotsObject.updateVariable(target.name.substr(1), target.text);
			}
		}
		private function onUpdateScroller(e:Event){
			var target = e.currentTarget;
			trace("changing: " + target.propertyValue + " to " + target.newValue);
			_spotsObject.updateVariable(target.propertyValue, target.newValue);
		}
		private function onUpdateFieldScroller(e:Event){
			var target = e.currentTarget;
			_spotsObject.updateFields(target.propertyValue, target.newValue);
		}
		private function onEmitterMouseDown(e:Event){
			emitterObject.startDrag();
		}
		private function onEmitterMouseUp(e:Event){
			emitterObject.stopDrag();
		}
		private function onGravMouseDown(e:Event){
			gravObject.startDrag();
		}
		private function onGravMouseUp(e:Event){
			gravObject.stopDrag();
		}
	}
}