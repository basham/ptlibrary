package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.utils.NumberUtil;
	
	import it.h_umus.tuio.Tuio2DObj;
	
	public class Tuio2DObjSession {
		
		static private var NumFrames:uint = 10;
		static private var SessionPool:Array = new Array();
		static private var TuioPool:Array = new Array();
		
		private var _sessionId:uint;
		private var _classId:uint;
		private var _frames:Array;
		
		private var _latest:Tuio2DObj;
		
		public function Tuio2DObjSession( sessionId:uint = 0, classId:uint = 0 ) {
			this.sessionId = sessionId;
			this.classId = classId;
			_frames = new Array();
		}
		
		static public function GetInstance( sessionId:uint = 0, classId:uint = 0 ):Tuio2DObjSession {
			var s:Tuio2DObjSession = ( SessionPool.length > 0 ? SessionPool.pop() : new Tuio2DObjSession() );
			s.sessionId = sessionId;
			s.classId = classId;
			s.removeFrames();
			return s;
		}
		
		static public function GetTuioInstance():Tuio2DObj {
			return ( TuioPool.length > 0 ? TuioPool.pop() : new Tuio2DObj( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ) );
		}
		
		static public function RemoveTuio( tuio:Tuio2DObj ):void {
			TuioPool.push( tuio );
		}
		
		public function get sessionId():uint {
			return _sessionId;
		}
		
		public function set sessionId( value:uint ):void {
			_sessionId = value;
			for each( var t:Tuio2DObj in _frames )
				t.s = value;
		}
		
		public function get classId():uint {
			return _classId;
		}
		
		public function set classId( value:uint ):void {
			_classId = value;
			for each( var t:Tuio2DObj in _frames )
				t.i = value;
		}
		
		public function get alive():Boolean {
			for each( var t:Tuio2DObj in _frames )
				if ( t != null || t )
					return true;
			return false;
		}
		
		public function get latest():Tuio2DObj {
			if ( _latest )
				return _latest;
			for each( var t:Tuio2DObj in _frames ) {
				if ( t != null || t ) {
					_latest = t;
					return _latest;
				}
			}
			return null;
		}
		
		public function update( frame:uint, x:Number, y:Number, a:Number ):void {
			
			// Calculate X, Y, A vectors
			
			//var t:Tuio2DObj = new Tuio2DObj( sessionId, classId, x, y, a, 0, 0, 0, 0, 0 );
			var t:Tuio2DObj = Tuio2DObjSession.GetTuioInstance();
			t.s = sessionId;
			t.i = classId;
			t.update( x, y, a, 0, 0, 0, 0, 0 );
			
			_frames.unshift( t );
			removeFrames( NumFrames );
			_latest = null;
		}
		
		public function updateByTuio( frame:uint, tuio:Tuio2DObj ):void {
			if ( tuio.i != classId )
				return;
			update( frame, tuio.x, tuio.y, tuio.a );
		}

		public function difference( tuio:Tuio2DObj ):Number {
			
			if ( !tuio || !latest ) // Ignore any null objects
				return -1;
			
			if ( tuio.i != classId ) // Ignore if Class Id doesn't match
				return -1;
			
			var sourceWidth:uint = 320;
			var sourceHeight:uint = 240;
			var xDiffPerc:Number = NumberUtil.PercentDifferenceRange( latest.x, tuio.x, sourceWidth ) * 100;
			var yDiffPerc:Number = NumberUtil.PercentDifferenceRange( latest.y, tuio.y, sourceHeight ) * 100;
			var aDiffPerc:Number = NumberUtil.PercentDifferenceRange( latest.a, tuio.a, 180 ) * 100;

			var diff:Number = ( xDiffPerc + yDiffPerc + aDiffPerc ) / 3; // Combine the diffs into a single, comparable value
			
			return diff;
		}
		
		public function remove():void {
			removeFrames();
			SessionPool.push( this );
		}
		
		private function removeFrames( remainingFrames:uint = 0 ):void {
			while( _frames.length > remainingFrames )
				Tuio2DObjSession.RemoveTuio( _frames.pop() );
		}

	}
}