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
	 * FileName:unknow has extension or not;
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
			var contentLines:Array=Utils.splitStringBy(Utils.read(configFile),Constance.FILE_BREAKER);
			for each( var content:String in contentLines){
				if(content.length==0 || content.charAt(0)==Constance.COMMET_MARK)continue;
				if(parseURL(content))continue;
				
				var item:ConfigFileItem=new ConfigFileItem(content);
				var a:int=getLastIndexOfBackSlash(content);
				item.relativePath=content.substr(0,a+1);
				item.lastContentPart=content.substr(a+1);
				parseItem(item);
				
				itemArr.push(item);
			}//end of for	
			TextOutputter.ins.warning("共有条目数量：",ConfigFileItem.totalItemCount,
				"		共有资源数量：",ConfigFileItem.totalResCount);
		}
		
		private function parseItem(item:ConfigFileItem):void
		{
			var lastPart:String=item.lastContentPart;
			if(lastPart==''){
				//directory；
				pushDirectoryFilesIntoItem(item);
			}else if(lastPart.charAt(0)==Constance.MARK_BIG_BRACKET){
				//has {};
				parseContentWithBigBracket(item);
			}else{
				//a file with/without extension;
				if(Utils.hasSign(lastPart,Constance.MARK_DOT)){
					checkExistAndPush(lastPart,item);
				}else{
					pushSameNameFilesIntoItem(lastPart,item);
				}
			}
		}
		
		private function checkExistAndPush(fileNameE:String,item:ConfigFileItem,fixedURL:String=''):void{
			if(Utils.exists(root+item.relativePath+fixedURL+fileNameE)){
				item.push(fixedURL+fileNameE);
			}else{
				printResNotExist(item.relativePath+fixedURL+fileNameE);
			}
		}
		
		private function getLastIndexOfBackSlash(str:String):int{
			var i:int=0;
			var result:int=-1;
			var lock:Boolean=false;
			do{
				var char:String=str.charAt(i);
				if(char == Constance.MARK_BIG_BRACKET)lock=true;
				else if(char == Constance.MARK_BIG_BRACKET_RIGHT)lock=false;
				else if(char == Constance.MARK_BACK_SLASH && !lock)result=i;
				i++;
			}while(i<str.length);
			return result;
		}
		
		private function parseContentWithBigBracket(item:ConfigFileItem):void
		{
			var lastPart:String=item.lastContentPart.substring(1,item.lastContentPart.length-1);//delete {};
			var arr:Array=lastPart.split(Constance.MARK_V_LINE);
			for each(var subItem:String in arr){
				if(Utils.hasSign(subItem,Constance.MARK_COLON)){
					/**
					 * 有统一的扩展名，有下面2种情况
					 * 001~013:doc		001~013:\
					 * :png
					 * */
					var tmpa:Array=subItem.split(Constance.MARK_COLON);
					if(Utils.hasSign(tmpa[0],Constance.MARK_WAVE)){
						parseRange(tmpa[0],tmpa[1],item);
					}else{
						pushDirectoryFilesIntoItem(item,tmpa[1]);
					}
				}else{
					/**
					 * 没有统一的扩展名，有下面4种情况
					 * 001~013
					 * 015.txt
					 * 001
					 * aaa\
					 * */
					if(Utils.hasSign(subItem,Constance.MARK_WAVE)){
						parseRange(subItem,Constance.EXT_ALL,item);
					}else if(Utils.hasSign(subItem,Constance.MARK_DOT)){
						checkExistAndPush(subItem,item);
					}else if(Utils.getLastIndexOfSign(subItem,Constance.MARK_BACK_SLASH)==subItem.length-1){
						pushDirectoryFilesIntoItem(item,Constance.EXT_ALL,subItem);
					}else{
						pushSameNameFilesIntoItem(subItem,item);
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
			Utils.createDirectory(target+item.relativePath);
			
			var flag:Boolean=false;
			var files:Array=Utils.getDirectoryListing(root+item.relativePath);
			for each(var file:File in files){
				if(file.isDirectory || file.name=='.' || file.name=="..")continue;
				else{
					if(Utils.hasSign(file.name,fileNameN)){
						item.push(file.name);
						flag=true;
					}
				}
			}
			
			if(!flag){
				printResNotExist(item.relativePath+fileNameN+'.'+Constance.EXT_ALL);
			}
		}
		
		private function printResNotExist(str:String):void{
			TextOutputter.ins.error("资源不存在：",str);
		}
		
		private function pushDirectoryFilesIntoItem(item:ConfigFileItem,requiredExtension:String=Constance.EXT_ALL,fixedURL:String=''):void
		{
			var dirURL:String=root+item.relativePath+fixedURL;
			if(!Utils.exists(dirURL)){
				TextOutputter.ins.error("目录不存在：",item.relativePath+fixedURL);
				return;
			}
			
			Utils.createDirectory(target+item.relativePath+fixedURL);
			var arr:Array=Utils.getDirectoryListing(dirURL);
			for each(var file:File in arr){
				if(file.isDirectory || file.name=="." || file.name=="..")continue;
				else if(Utils.isExtensionRight(file.name,requiredExtension))item.push(fixedURL+file.name);
			}
		}
		
		private function parseRange(range:String,extension:String,item:ConfigFileItem):void{
			var r:Range=new Range(range,extension);
			
			var fileNameN:String='';
			for (var i:int=r.fromNumber;i<=r.endNumber;i++){
				if(r.differentPartLength==-1){
					//自由长度；
					fileNameN=r.samePart+i;
				}else{
					//固定长度；
					fileNameN=r.samePart+Utils.fixToLength(i,r.differentPartLength);
				}
				
				if(r.extension==Constance.MARK_BACK_SLASH){
					pushDirectoryFilesIntoItem(item,Constance.EXT_ALL,fileNameN+Constance.MARK_BACK_SLASH);
				}else if(r.extension==Constance.EXT_ALL){
					pushSameNameFilesIntoItem(fileNameN,item);
				}else {
					checkExistAndPush(fileNameN+'.'+r.extension,item);
				}
				
			}
		}
		
	}
}
import z_spark.necessaryrescoper.Constance;
import z_spark.necessaryrescoper.Utils;

class Range{
	public var samePart:String="";
	public var differentPartLength:int=-1;
	public var fromNumber:int;
	public var endNumber:int;
	public var extension:String=Constance.EXT_ALL;
	
	/**
	 * no big bracket 
	 * xxx~yyy:mbf		xxx到yyy的mbf文件
	 * xxx~yyy:\		xxx到yyy的目录
	 * xxx~yyy:*		xxx到yyy的所有类型的文件；
	 * @param 	range
	 * @param	ext
	 * 
	 */
	public function Range(range:String,ext:String){
		extension=ext;
		
		var arr:Array=range.split(Constance.MARK_WAVE);	
		var s0:String=arr[0];
		var s1:String=arr[1];
		var l:int=Math.min(s0.length,s1.length);
		
		var dIndex:int=-1;
		for (var i:int=0;i<l;i++){
			if(s0.charAt(i)!=s1.charAt(i)){
				dIndex=i;
				break;
			}
		}
		if(dIndex==-1)throw new Error("无法识别的区间名字！{"+range+':'+ext+'}');
		
		samePart=s0.substr(0,dIndex);
		if(s1.length==s0.length)differentPartLength=s0.length-dIndex;
		
		if(Utils.isStringAllDecNumbers(s0.substr(dIndex)) &&
			Utils.isStringAllDecNumbers(s1.substr(dIndex))
		){
			fromNumber=int(s0.substr(dIndex));
			endNumber=int(s1.substr(dIndex));
		}else throw new Error("名字后几位不是数字，无法知道如何步进！{"+range+':'+ext+'}');
	}
	
}