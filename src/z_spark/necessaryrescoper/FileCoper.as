package z_spark.necessaryrescoper
{
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import z_spark.necessaryrescoper.data.ConfigFileItem;

	public class FileCoper
	{
		private var _numResCopied:uint=0;
		public function FileCoper()
		{
		}
		
		public function copy(itemArr:Array):void{
			//check path first
			if(ConfigParser.root =='' || ConfigParser.target=="")
				throw new Error("必要路径信息尚未配置，可能配置表少配，也可能程序bug，请检查！");
			
			TextOutputter.ins.warning("开始拷贝...");
			var tf:TextField=TextOutputter.ins.info("");
			var _curIndex:uint=0;
			
			copy_();
			function copy_():void{
				var item:ConfigFileItem=itemArr[_curIndex] as ConfigFileItem;
				item.forEachExe(copyFile);
				_curIndex++;
				tf.htmlText="条目进度："+_curIndex+"/"+ConfigFileItem.totalItemCount+"		资源进度："+_numResCopied+'/'+ConfigFileItem.totalResCount;
				if(_curIndex>=itemArr.length){
					TextOutputter.ins.warning("拷贝完成！");
					return;
				}
				else{
					setTimeout(copy_,Constance.CLEARANCE);
				}
			}
		}
		
		private function copyFile(relativePath:String,fileName:String):void
		{
			if(Utils.exists(ConfigParser.root+relativePath+fileName)){
				_numResCopied++;
				createDirectory(relativePath+fileName);
				var barr:ByteArray=Utils.readByteArray(ConfigParser.root+relativePath+fileName);
				Utils.writeByteArray(ConfigParser.target+relativePath+fileName,barr);
			}else{
				TextOutputter.ins.error("该资源不存在：",relativePath+fileName);
			}
		}
		
		/**
		 * 在目标根目录下面创建相同的目录结构； 
		 * @param relativePath
		 * 
		 */
		private function createDirectory(relativePath:String):void
		{
			var dir:String='';
			var dirHierarchy:Array=relativePath.split(Constance.MARK_BACK_SLASH);
			for (var i:int=0;i<dirHierarchy.length-1;i++){
				dir+=dirHierarchy[i]+Constance.MARK_BACK_SLASH;
				if(!Utils.exists(ConfigParser.target+dir)){
					Utils.createDirectory(ConfigParser.target+dir);
				}
				
			}
		}
	}
}