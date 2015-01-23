/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
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

package
{
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import z_spark.necessaryrescoper.ConfigParser;
import z_spark.necessaryrescoper.Constance;
import z_spark.necessaryrescoper.DraggerController;
import z_spark.necessaryrescoper.FileCoper;
import z_spark.necessaryrescoper.TextOutputter;
import z_spark.necessaryrescoper.event.NRCDragEvent;

public class Coper extends Sprite
{
	public function Coper()
	{
		stage.align=StageAlign.TOP_LEFT;
		stage.scaleMode=StageScaleMode.NO_SCALE;
		stage.color=0x000000;
		stage.stageHeight=600;
		stage.stageWidth=800;
		
		var dc:DraggerController=new DraggerController(stage);
		dc.addEventListener(NRCDragEvent.CONFIG_FILE_GOT,onConfigFileGot);
		
		new TextOutputter(stage);
		TextOutputter.ins.custom(Constance.GRAY,"Coper is ready,Ver:1.0.0");
		TextOutputter.ins.custom(Constance.GRAY,"请将配置文件拖动到该窗口里面释放。");
		
	}
	
	private function onConfigFileGot(event:NRCDragEvent):void
	{
		var arr:Array=[];
		new ConfigParser().parse(event.path,arr);
		new FileCoper().copy(arr);
	}
}
}