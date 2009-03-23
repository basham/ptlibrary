package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.tracking.RegionAdjacencyGraph;
	import edu.iu.vis.tracking.tuio.profiles.ITuioInterpreterProfile;
	
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
		
		private var sessions:Dictionary = new Dictionary(true);
		private var profiles:Array = new Array();
		
		private var _outboundConnection:OutboundTuioConnection;
		private var rag:RegionAdjacencyGraph;

		private var _frame:uint = 0;
		private var _sensitivity:Number = .3;
		
		private var sessionCount:uint = 0;
		private var sourceFPS:uint = 0;
		public var sourceWidth:uint = 320;
		public var sourceHeight:uint = 240;
		
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
		
		public function get sensitivity():Number {
			return _sensitivity;
		}
		
		public function set sensitivity( value:Number ):void {
			_sensitivity = value;
		}

		public function addProfile( profile:ITuioInterpreterProfile ):void {
			profile.interpreter = this;
			profiles.push( profile );
		}

		public function interpret( source:BitmapData, fps:uint = 0 ):void {
			
			// Need source dimensions to calculate percentage coordinates
			sourceWidth = source.width;
			sourceHeight = source.height;
			
			// Need FPS to calculate time-based parameters (i.e. speed, acceleration)
			sourceFPS = fps;
			
			// Create graph from source bitmap
			rag = new RegionAdjacencyGraph( source );
			rag.graph();
			
			// Loop through profiles, each interpreting the graph
			for each( var profile:ITuioInterpreterProfile in profiles )
				profile.interpretGraph( rag );
			
			// Cleanup
			rag.dispose();
			removeDeadSessions();
			
			// Every call to 'interpret()' assumes its a new frame
			_frame++;
		}
		
		override public function toString():String {
			return rag.toString();
		}
		
		public function printBounds():void {
			rag.printBounds();
		}

		public function generateEventFromObj( i:uint, x:Number, y:Number, a:Number ):void {
			
			// Continual most likely match of this Tuio to a stored Tuio session
			var bestSessionMatch:uint;
			var bestSessionDiff:Number = -1;
			
			// Attempt to find the best match in a previous Tuio session.
			for each ( var s:Tuio2DObjSession in sessions ) { // Loop through value objects
			
				if ( i != s.classId )
					continue;
					
				var diff:Number = s.difference( x, y );
				
				if ( diff >= bestSessionDiff && bestSessionDiff >= 0 ) // Ignore session if not the best match so far
					continue;
				
				// This session is the new best match
				bestSessionMatch = s.sessionId;
				bestSessionDiff = diff;
			}
			
			// Establish session for this Tuio2DObj
			var newSession:Boolean = !( bestSessionDiff < sensitivity && bestSessionDiff >= 0 );
			var sid:uint = newSession ? sessionCount++ : bestSessionMatch;
			var session:Tuio2DObjSession = newSession ? new Tuio2DObjSession( this, sid, i ) : sessions[ sid ];

			session.update( frame, sourceFPS, x, y, a );
			sessions[ sid ] = session;
			
			// Broadcast event
			var u:Tuio2DObj = session.latest.tuio;
			trace('s=' + u.s, 'i=' + u.i, 'x=' + u.x, 'y=' + u.y, 'a=' + int(u.a), 'X=' + u.X, 'Y=' + u.Y, 'A=' + u.A, 'm=' + u.m, 'r=' + u.r, newSession ? '**' : '', bestSessionDiff);
			dispatchObjEvent( new Tuio2DObjEvent( ( newSession ? Tuio2DObjEvent.ADD_TUIO_2D_OBJ : Tuio2DObjEvent.UPDATE_TUIO_2D_OBJ ), u ) );				
		}
		
		private function removeDeadSessions():void {
			for ( var sessionKey:String in sessions )
				if ( !( sessions[ sessionKey ] as Tuio2DObjSession ).alive )
					removeSession( sessionKey );
		}
		
		private function removeSession( sessionKey:String ):void {
			var session:Tuio2DObjSession = sessions[ sessionKey ];
			dispatchObjEvent( new Tuio2DObjEvent( Tuio2DObjEvent.REMOVE_TUIO_2D_OBJ, session.latest.tuio ) );
			session.dispose();
			sessions[ sessionKey ] = null;
			delete( sessions[ sessionKey ] );
		}

		private function dispatchObjEvent( tuioEvent:Tuio2DObjEvent ):void {
			this.dispatchEvent( tuioEvent );
			if ( outboundConnection )
				outboundConnection.sendObjEvent( tuioEvent );
		}
	}
}