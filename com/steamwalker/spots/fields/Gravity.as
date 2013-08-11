package com.steamwalker.spots.fields {
	public class Gravity {
		public static function newVector($multiplier):Array {
			var vector = [
				0,
				$multiplier,
				0];
			return vector;
		}
		public static function newVectorDestination($multiplier, $currentPosition, $targetPosition):Array {
			var x = $targetPosition[0] - $currentPosition[0];
			var y = $targetPosition[1] - $currentPosition[1];
			var distance = Math.sqrt(Math.abs(x * x) + Math.abs(y * y));
			var multiplier = $multiplier * (1 - (distance / 1000));
			multiplier = (multiplier < 0)? 0 : multiplier;
			
			
			//var multiplier = ($multiplier / (distance * distance)) * .5 + ($multiplier * (1 - (distance / 1000)) * .5); 
			
			/*var xNew = Number(int((	1 * (x / Math.abs(x + y)) * $multiplier		) * 1000)) / 1000;
			var yNew = Number(int((	1 * (y / Math.abs(x + y)) * $multiplier		) * 1000)) / 1000;
			var distanceNew = Number(int((		Math.sqrt(Math.abs(x * x) + Math.abs(y * y))		) * 1000)) / 1000;
			
			trace("x: " + xNew + ", y: " + yNew + ", distance: " + distanceNew + ", multiplier: " + multiplier);
			trace(Math.abs(x+y));*/
			
			var vector = [
				(x / (Math.abs(x) + Math.abs(y))) * multiplier,
				(y / (Math.abs(x) + Math.abs(y))) * multiplier,
				0];
			return vector;
		}
	}
}