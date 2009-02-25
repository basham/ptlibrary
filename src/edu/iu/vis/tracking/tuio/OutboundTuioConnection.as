package edu.iu.vis.tracking.tuio {
	
	import it.h_umus.tuio.events.Tuio2DObjEvent;
	
	public class OutboundTuioConnection extends AbstractTuioConnection {
		
		public function OutboundTuioConnection( connectionName:String ) {
			super( connectionName, false );
		}
		
		public function sendObjEvent( tuioObjEvent:Tuio2DObjEvent ):void {
			//trace( 'Sending to:', connectionName );
			connection.send( connectionName, "tuioDispatcher", new Tuio2DObjEventMessage( tuioObjEvent ) );
		}
	}
}