package z_spark.necessaryrescoper
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import z_spark.necessaryrescoper.event.NRCDragEvent;

	final public class DraggerController extends EventDispatcher
	{
		private var _dragTarget:Sprite;
		public function DraggerController(stage:Stage)
		{
			_dragTarget=new Sprite();
			_dragTarget.graphics.beginFill(0x000000,0);
			_dragTarget.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			_dragTarget.graphics.endFill();
			stage.addChild(_dragTarget);
			_dragTarget.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDragDrop);
			_dragTarget.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragEnter);
		}
		
		protected function onDragEnter(event:NativeDragEvent):void
		{
			var clip:Clipboard = event.clipboard;
			
			if (clip.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				var file:File = clip.getData(ClipboardFormats.FILE_LIST_FORMAT)[0] as File;
				if (!file.isDirectory)
					NativeDragManager.acceptDragDrop(_dragTarget);
			}
		}
		
		private function onDragDrop(event:NativeDragEvent):void
		{
			var clip:Clipboard = event.clipboard;
			var file:File=clip.getData(ClipboardFormats.FILE_LIST_FORMAT)[0] as File;
			
			if(!file.isDirectory){
				
				var fs:FileStream=new FileStream();
				fs.open(file,FileMode.READ);
				dispatchEvent(new NRCDragEvent(NRCDragEvent.CONFIG_FILE_GOT,file.nativePath));
			}
		}	
		
	}
}