package
{
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import z_spark.necessaryrescoper.ConfigParser;
import z_spark.necessaryrescoper.Constance;
import z_spark.necessaryrescoper.DraggerController;
import z_spark.necessaryrescoper.FileItemCoper;
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
	
	protected function onConfigFileGot(event:NRCDragEvent):void
	{
		var arr:Array=[];
		new ConfigParser().parse(event.path,arr);
		new FileItemCoper().copy(arr);
	}
}
}