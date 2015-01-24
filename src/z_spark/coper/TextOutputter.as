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
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;

public class TextOutputter
{
	public static var ins:TextOutputter;
	
	private var _stage:Stage;
	private var _tfCtn:Sprite;
	private var _tfArr:Array=[];
	public function TextOutputter(stage:Stage)
	{
		if(ins!=null)throw new Error("已实例化");
		ins=this;
		_stage=stage;
		_tfCtn=new Sprite();
		_tfCtn.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		
		_stage.addChild(_tfCtn);
	}
	
	private function onMouseUp(event:MouseEvent):void
	{
		_stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		_stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		_stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
	}
	
	private var _startPos:Point;
	private function onMouseDown(event:MouseEvent):void
	{
		_stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		_stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		_stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		
		_startPos=new Point(event.stageX,event.stageY);
	}
	
	private function onMouseMove(event:MouseEvent):void
	{
		var Y:int=_tfCtn.y;
		Y+=event.stageY-_startPos.y;
		if(Y>0)Y=0;
		_tfCtn.y=Y;
		
		_startPos=new Point(event.stageX,event.stageY);
	}	
	
	private var _nextX:uint=5;
	private var _nextY:uint=5;
	private function print(str):TextField{
		var tf:TextField;
		if(_tfArr.length>=Constance.MAX_TF_COUNT){
			tf=_tfArr.shift();
		}else{
			tf=new TextField();
			tf.mouseEnabled=false;
			tf.width=_stage.stageWidth-10;
			tf.textColor=0xFFFFFF;
			_tfCtn.addChild(tf);
		}
		
		tf.htmlText="["+new Date().toUTCString()+"] "+str;
		tf.x=_nextX;
		tf.y=_nextY;
		
		_tfArr.push(tf);
		_nextY+=tf.textHeight+5;
		
		return tf;
	}
	
	public function info(...args):TextField{
		var str:String=args.join(' ');
		return print(Utils.color(str,Constance.WHITE));
	}
	
	public function error(...args):TextField{
		var str:String=args.join(' ');
		return print(Utils.color(str,Constance.RED));
	}
	
	public function warning(...args):TextField{
		var str:String=args.join(' ');
		return print(Utils.color(str,Constance.YELLOW));
	}
	
	public function custom(color:String,...args):TextField{
		var str:String=args.join(' ');
		return print(Utils.color(str,color));
	}
}
}