package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.tracking.RegionAdjacencyGraph;
	import edu.iu.vis.tracking.tuio.profiles.ITuioInterpreterProfile;
	import edu.iu.vis.utils.NumberUtil;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import it.h_umus.tuio.Tuio2DObj;
	import it.h_umus.tuio.events.Tuio2DObjEvent;
	
	/**
     * @eventType it.h_umus.tuio.events.Tuio2DObjEvent.ADD_TUIO_2D_OBJ
     **/
    [Event(name="addTuio2DObj", type="it.h_umus.tuio.events.Tuio2DObjEvent")]
    
    /**
     * @eventType it.h_umus.tuio.events.Tuio2DObjEvent.UPDATE_TUIO_2D_OBJ
     **/
    [Event(name="updateTuio2DObj", type="it.h_umus.tuio.events.Tuio2DObjEvent")]
    
    /**
     * @eventType it.h_umus.tuio.events.Tuio2DObjEvent.REMOVE_TUIO_2D_OBJ
     **/
    [Event(name="removeTuio2DObj", type="it.h_umus.tuio.events.Tuio2DObjEvent")]

	
	public class TuioInterpreter extends EventDispatcher {
		
		private const SESSION_DIFF_THRESHOLD:Number = .025;
		
		private var sessions:Dictionary = new Dictionary(true);
		private var aliveSessions:Dictionary;
		private var profiles:Array = new Array();
		
		private var _outboundConnection:OutboundTuioConnection;

		private var _frame:uint = 0;
		private var sessionCount:uint = 0;
		private var sourceWidth:uint = 320;
		private var sourceHeight:uint = 240;
		
		public function TuioInterpreter() {
		}
		
		public function get frame():uint {
			return _frame;
		}
		
		public function get outboundConnection():OutboundTuioConnection {
			return _outboundConnection;
		}

		public function set outboundConnection( value:OutboundTuioConnection ):void {
			_outboundConnection = value;
		}

		public function addProfile( profile:ITuioInterpreterProfile ):void {
			profile.interpreter = this;
			profiles.push( profile );
		}

		public function interpret( source:BitmapData ):void {
			sourceWidth = source.width;
			sourceHeight = source.height;
			aliveSessions = new Dictionary(true);
			
			var rag:RegionAdjacencyGraph = new RegionAdjacencyGraph( source );
			rag.graph();
			
			for each( var profile:ITuioInterpreterProfile in profiles ) // Loop through profiles, each interpreting the graph
				profile.interpretGraph( rag );
			
			removeDeadSessions();
			
			_frame++;
		}

		public function generateEventFromObj( tuio:Tuio2DObj ):void {
			
			// Continual most likely match of this Tuio to a stored Tuio session
			var bestSessionMatch:uint;
			var bestSessionDiff:Number;
			
			// Attempt to find the best match in a previous Tuio session.
			for each ( var t:Tuio2DObj in sessions ) { // Loop through value objects
				
				if ( tuio.i != t.i ) // Candidate match only if Class Id matches
					continue;
				
				var xDiffPerc:Number = NumberUtil.PercentDifferenceRange( tuio.x, t.x, sourceWidth );
				var yDiffPerc:Number = NumberUtil.PercentDifferenceRange( tuio.y, t.y, sourceHeight );
				var aDiffPerc:Number = NumberUtil.PercentDifferenceRange( tuio.a, t.a, 180 );

				var diff:Number = xDiffPerc * yDiffPerc * aDiffPerc; // Combine the diffs into a single, comparable value
				
				if ( diff >= bestSessionDiff ) // Ignore session if its not the best match so far
					continue;
				
				// This session is the new best match
				bestSessionMatch = t.s;
				bestSessionDiff = diff;
			}
			
			// Establish session for this Tuio2DObj
			var newSession:Boolean = ( bestSessionDiff < SESSION_DIFF_THRESHOLD );
			var s:uint = newSession ? bestSessionMatch : sessionCount++;
			tuio.s = s;
			
			if ( !newSession ) {
			/*
			* TODO:
			*  - Calculate X, Y, A vector values
			*/	
			}
			
			sessions[ s ] = tuio;
			aliveSessions[ s ] = true;
			
			// Broadcast event
			trace(tuio.s, tuio.i, tuio.x, tuio.y, tuio.a);
			dispatchObjEvent( new Tuio2DObjEvent( ( newSession ? Tuio2DObjEvent.ADD_TUIO_2D_OBJ : Tuio2DObjEvent.UPDATE_TUIO_2D_OBJ ), tuio ) );
		}
		
		private function removeDeadSessions():void {
			for ( var sessionKey:String in sessions )
				if ( aliveSessions[ sessionKey ] != true )
					removeSession( sessionKey );
		}

		private function removeSession( sessionKey:String ):void {
			dispatchObjEvent( new Tuio2DObjEvent( Tuio2DObjEvent.REMOVE_TUIO_2D_OBJ, sessions[ sessionKey ] as Tuio2DObj ) );
			sessions[ sessionKey ] = null;
		}

		private function dispatchObjEvent( tuioEvent:Tuio2DObjEvent ):void {
			this.dispatchEvent( tuioEvent );
			if ( outboundConnection )
				outboundConnection.sendObjEvent( tuioEvent );
		}
	}
}