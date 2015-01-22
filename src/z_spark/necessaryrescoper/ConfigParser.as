package z_spark.necessaryrescoper
{
	import flash.filesystem.File;
	
	import z_spark.necessaryrescoper.data.ConfigFileItem;

	public class ConfigParser
	{
		public static var root:String='';
		public static var target:String='';
		public function ConfigParser()
		{
		}
		
		/**
		 * 路径相对该程序主应用；
		 * 解析优先级：{},\,|,:,~
		 * @param configFile
		 * @param itemArr
		 * 
		 */
		public function parse(configFile:String,itemArr:Array):void{
			itemArr.length=0;
			ConfigFileItem.totalItemCount=0;
			ConfigFileItem.totalResCount=0;
			
			var content:String=Utils.read(configFile);
			TextOutputter.ins.warning("配置文件路径：",configFile);
			var contentLines:Array=content.split(/\r\n|\r|\n/);
			for each( var ctt:String in contentLines){
				if(ctt.indexOf(Constance.COMMET_MARK)>=0 || ctt.length==0)continue;
				if(ctt.indexOf(Constance.ROOT)==0){
					root=ctt.substr(Constance.ROOT.length+1);
					TextOutputter.ins.warning("资源根目录：",root);
					continue;
				}
				if(ctt.indexOf(Constance.TARGET)==0){
					target=ctt.substr(Constance.TARGET.length+1);
					TextOutputter.ins.warning("目标根目录：",target);
					continue;
				}
				
				var item:ConfigFileItem=new ConfigFileItem(ctt);
				var a:int=ctt.indexOf(Constance.MARK_BIG_BRACKET);
				if(a==-1){
					a=ctt.lastIndexOf(Constance.MARK_BACK_SLASH);
					item.relativePath=ctt.substr(0,a+1);
					
					if(a==ctt.length-1){
						//整个子目录，不包含更分支的目录，只是将该目录中的非目录文件执行拷贝
						parseDirectory(ctt,item);
					}else{
						//具体的文件，可能有扩展名，可能没有
						var file:String=ctt.substr(a+1);
						if(file.indexOf(".")==-1){
							//遍历本目录看看是否有名字是这个的所有文件（扩展名可以不同）；
							pushFileWithFileName(file,item);
						}else item.push(file);
					}
				}else{
					//条目有{},不可能有目录存在；
					item.relativePath=ctt.substr(0,a);
					file=ctt.substring(a+1,ctt.length-1);//-2是不包含}
					var arr:Array=file.split(Constance.MARK_V_LINE);
					for each(var subItem:String in arr){
						parseSubItem(subItem,item);
					}
				}
				
				itemArr.push(item);
			}//end of for	
			TextOutputter.ins.warning("共有条目数量：",ConfigFileItem.totalItemCount,"		共有资源数量：",ConfigFileItem.totalResCount);
		}
		
		private function pushFileWithFileName(file:String, item:ConfigFileItem):void
		{
			if(!Utils.exists(root+item.relativePath)){
				TextOutputter.ins.error("目录不存在：",item.relativePath);
				return;
			}
			
			
			var flag:Boolean=false;
			var fileInfos:Array=Utils.getDirectoryListing(root+item.relativePath);
			for each(var fileInfo:File in fileInfos){
				if(fileInfo.isDirectory)continue;
				else{
					if(fileInfo.name.indexOf(file)>=0){
						flag=true;
						item.push(fileInfo.name);
					}
				}
			}
			
			if(!flag){
				item.push(file+'.'+Constance.EXT_ALL);
			}
		}
		
		private function parseDirectory(ctt:String, item:ConfigFileItem,requiredExtension:String=Constance.EXT_ALL):void
		{
			if(!Utils.exists(root+ctt)){
				TextOutputter.ins.error("目录不存在：",ctt);
				return;
			}
			var arr:Array=Utils.getDirectoryListing(root+ctt);
			for each(var fileInfo:File in arr){
				if(fileInfo.isDirectory || fileInfo.name=="." || fileInfo.name=="..")continue;
				else {
					if(requiredExtension==Constance.EXT_ALL)
						item.push(fileInfo.name);
					else{
						if(Utils.isExtensionRight(fileInfo.name,requiredExtension))item.push(fileInfo.name);
					}
				}
			}
		}
		
		private function parseSubItem(subItem:String,item:ConfigFileItem):void{
			if(subItem.indexOf(Constance.MARK_COLON)==-1){
				/**
				 * 没有统一的扩展名，有下面3种情况
				 * 001~013
				 * 001
				 * 015.txt
				 * */
				if(subItem.indexOf(Constance.MARK_WAVE)>=0){
					parseRange(subItem,"."+Constance.EXT_ALL,item);
				}else if(subItem.indexOf(".")>=0){
					item.push(subItem);
				}else{
					pushFileWithFileName(subItem,item);
				}
			}else{
				/**
				 * 有统一的扩展名，有下面2种情况
				 * 001~013:doc
				 * :doc
				 * */
				var arr:Array=subItem.split(Constance.MARK_COLON);
				if(subItem.indexOf(Constance.MARK_WAVE)>=0){
					parseRange(arr[0],arr[1],item);
				}else{
					//不是范围，比如:ani
					parseDirectory(item.relativePath,item,arr[1]);
				}
			}
		}
		
		private function parseRange(range:String,extension:String,item:ConfigFileItem):void{
			var arr:Array=range.split(Constance.MARK_WAVE);
			throw Error("目前暂不支持范围拷贝符号！");
		}
	}
}