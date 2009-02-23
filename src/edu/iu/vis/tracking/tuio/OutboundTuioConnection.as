package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.tracking.tuio.Tuio2DObjEventMessage;
	import it.h_umus.tuio.Tuio2DObj;
	
	public class OutboundTuioConnection extends AbstractTuioConnection {
		
		public function OutboundTuioConnection( connectionName:String ) {
			super( connectionName, false );
		}
		
		public function sendObjEvent( eventType:String, tuioObj:Tuio2DObj ):void {
			trace( connectionName);
			connection.send( connectionName, "tuioDispatcher", new Tuio2DObjEventMessage( eventType, tuioObj ) );
		}
	}
}