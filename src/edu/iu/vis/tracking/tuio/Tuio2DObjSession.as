package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.utils.NumberUtil;
	
	import it.h_umus.tuio.Tuio2DObj;
	
	public class Tuio2DObjSession {
		
		static public var NumFrames:uint = 5;
		
		private var _sessionId:uint;
		private var _classId:uint;
		private var _frames:Array;
		
		public function Tuio2DObjSession( sessionId:uint = 0, classId:uint = 0 ) {
			_sessionId = sessionId;
			_classId = classId;
			_frames = new Array();
		}
		
		public function get sessionId():uint {
			return _sessionId;
		}
		
		public function get classId():uint {
			return _classId;
		}
		
		public function get alive():Boolean {
			for each( var t:Tuio2DObj in _frames )
				if ( t != null || t )
					return true;
			return false;
		}
		
		public function get lastest():Tuio2DObj {
			for each( var t:Tuio2DObj in _frames )
				if ( t != null || t )
					return t;
			return null;
		}
		
		public function update( x:Number, y:Number, a:Number ):void {
			
			// Calculate X, Y, A vectors
			
			var t:Tuio2DObj = new Tuio2DObj( sessionId, classId, x, y, a, 0, 0, 0, 0, 0 );
			while( _frames.length > NumFrames )
				delete( _frames.pop() );
			_frames.unshift( t );
		}
		
		public function updateByTuio( tuio:Tuio2DObj ):void {
			update( tuio.x, tuio.y, tuio.a );
		}

		public function difference( tuio:Tuio2DObj ):Number {
			
			if ( !latest || !tuio ) // Ignore any null objects
				return -1;
			
			if ( latest.i != tuio.i ) // Candidate match only if Class Id matches
				return -1;
			
			var xDiffPerc:Number = NumberUtil.PercentDifferenceRange( latest.x, tuio.x, sourceWidth ) * 100;
			var yDiffPerc:Number = NumberUtil.PercentDifferenceRange( latest.y, tuio.y, sourceHeight ) * 100;
			var aDiffPerc:Number = NumberUtil.PercentDifferenceRange( latest.a, tuio.a, 180 ) * 100;

			var diff:Number = ( xDiffPerc + yDiffPerc + aDiffPerc ) / 3; // Combine the diffs into a single, comparable value
			
			return diff;
		}

	}
}