/*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

package z_spark.coper
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