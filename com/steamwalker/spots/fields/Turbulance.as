package com.steamwalker.spots.fields {
	public class Turbulance {
		public static function newVector($multiplier):Array {
			var vector = [
				Math.random() * $multiplier - $multiplier / 2,
				Math.random() * $multiplier - $multiplier / 2,
				0];
			return vector;
		}
		public static function newRotation($multiplier):Number {
			return Math.random() * $multiplier;
		}
	}
}