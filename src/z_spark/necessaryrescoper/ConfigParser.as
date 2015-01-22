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

package z_spark.necessaryrescoper
{
	import flash.filesystem.File;
	
	import z_spark.necessaryrescoper.data.ConfigFileItem;

	/**
	 * FileNameN:file name without extension; 
	 * FileNameE:file name with extension;
	 * FileName:unknow has or not;
	 * @author z_Spark
	 * 
	 */
	public class ConfigParser
	{
		public static var root:String='';
		public static var target:String='';
		public function ConfigParser(){}
		
		/**
		 * 解析优先级：\,{},|,:,~.
		 * @param configFile		配置文件的本地绝对路径；
		 * @param itemArr
		 * 
		 */
		public function parse(configFile:String,itemArr:Array):void{
			itemArr.length=0;
			ConfigFileItem.totalItemCount=0;
			ConfigFileItem.totalResCount=0;
			
			TextOutputter.ins.warning("配置文件路径：",configFile);
			var contentLines:Array=Utils.read(configFile).split(Constance.LINE_BREAKER);
			for each( var content:String in contentLines){
				if(content.indexOf(Constance.COMMET_MARK)>=0 || content.length==0)continue;
				if(parseURL(content))continue;
				
				var item:ConfigFileItem=new ConfigFileItem(content);
				var a:int=content.lastIndexOf(Constance.MARK_BACK_SLASH);
				item.relativePath=content.substr(0,a+1);
				item.rightConfigPart=content.substr(a+1);
				parseItem(item);
				
				itemArr.push(item);
			}//end of for	
			TextOutputter.ins.warning("共有条目数量：",ConfigFileItem.totalItemCount,"		共有资源数量：",ConfigFileItem.totalResCount);
		}
		
		private function parseItem(item:ConfigFileItem):void
		{
			var right:String=item.rightConfigPart;
			if(right==''){
				//目录；
				pushSubDirectoryFilesIntoItem(item);
			}else if(right.charAt(0)==Constance.MARK_BIG_BRACKET){
				//有{};
				parseContentWithBigBracket(item);
			}
		}
		
		private function parseContentWithBigBracket(item:ConfigFileItem):void
		{
			var right:String=item.rightConfigPart.substring(1,item.rightConfigPart.length-1);//delete {};
			var arr:Array=right.split(Constance.MARK_V_LINE);
			for each(var subItem:String in arr){
				if(subItem.indexOf(Constance.MARK_COLON)==-1){
					/**
					 * 没有统一的扩展名，有下面3种情况
					 * 001~013
					 * 015.txt
					 * 001
					 * */
					if(subItem.indexOf(Constance.MARK_WAVE)>=0){
						parseRange(subItem,"."+Constance.EXT_ALL,item);
					}else if(subItem.indexOf(".")>=0){
						item.push(subItem);
					}else{
						pushSameNameFilesIntoItem(subItem,item);
					}
				}else{
					/**
					 * 有统一的扩展名，有下面2种情况
					 * 001~013:doc
					 * :png
					 * */
					var tmpa:Array=subItem.split(Constance.MARK_COLON);
					if(tmpa[0].indexOf(Constance.MARK_WAVE)>=0){
						parseRange(arr[0],tmpa[1],item);
					}else{
						pushSubDirectoryFilesIntoItem(item,arr[1]);
					}
				}
			}
		}
		
		private function parseURL(content:String):Boolean{
			if(content.indexOf(Constance.ROOT)==0){
				root=content.substr(Constance.ROOT.length+1);
				TextOutputter.ins.warning("资源根目录：",root);
				return true;
			}else if(content.indexOf(Constance.TARGET)==0){
				target=content.substr(Constance.TARGET.length+1);
				TextOutputter.ins.warning("目标根目录：",target);
				return true;
			}
			return false;
		}
		
		private function pushSameNameFilesIntoItem(fileNameN:String, item:ConfigFileItem):void
		{
			if(!Utils.exists(root+item.relativePath)){
				TextOutputter.ins.error("目录不存在：",item.relativePath);
				return;
			}
			
			var flag:Boolean=false;
			var fileInfos:Array=Utils.getDirectoryListing(root+item.relativePath);
			for each(var file:File in fileInfos){
				if(file.isDirectory)continue;
				else{
					if(file.name.indexOf(fileNameN)>=0){
						flag=true;
						item.push(file.name);
					}
				}
			}
			
			if(!flag){
				item.push(fileNameN+'.'+Constance.EXT_ALL);
			}
		}
		
		private function pushSubDirectoryFilesIntoItem(item:ConfigFileItem,requiredExtension:String=Constance.EXT_ALL):void
		{
			if(!Utils.exists(root+item.relativePath)){
				TextOutputter.ins.error("目录不存在：",item.relativePath);
				return;
			}
			var arr:Array=Utils.getDirectoryListing(root+item.relativePath);
			for each(var file:File in arr){
				if(file.isDirectory || file.name=="." || file.name=="..")continue;
				else {
					if(requiredExtension==Constance.EXT_ALL)
						item.push(file.name);
					else{
						if(Utils.isExtensionRight(file.name,requiredExtension))item.push(file.name);
					}
				}
			}
		}
		
		private function parseRange(range:String,extension:String,item:ConfigFileItem):void{
			var arr:Array=range.split(Constance.MARK_WAVE);
			throw Error("目前暂不支持范围拷贝符号！");
		}
		
		private function compare(a:String,b:String):void{
			
		}
	}
}