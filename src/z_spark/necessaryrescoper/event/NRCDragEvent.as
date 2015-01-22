package z_spark.necessaryrescoper.event
{
	import flash.events.Event;
	
	public class NRCDragEvent extends Event
	{
		public static const CONFIG_FILE_GOT:String="config_file_got";
		
		public var path:String='';
		public function NRCDragEvent(type:String,path_:String)
		{
			path=path_;
			super(type, false,false);
		}
		
		override public function clone():Event
		{
			return new NRCDragEvent(type,path);
		}
		
		
	}
}