package z_spark.necessaryrescoper.data
{
	/**
	 * 配置文件里面每一行就是一个该类的实例 
	 * 不包括root与target所在的行
	 * 
	 * @author z_Spark
	 * 
	 */
	public class ConfigFileItem
	{
		public static var totalItemCount:uint=0;
		public static var totalResCount:uint=0;
		
		private var _content:String;
		public function ConfigFileItem(content:String)
		{
			_content=content;
			totalItemCount++;
		}
		
		private var _relativePath:String='';//ended with '\'
		private var _lastContentPart:String='';

		public function get content():String
		{
			return _content;
		}

		public function get lastContentPart():String
		{
			return _lastContentPart;
		}

		public function set lastContentPart(value:String):void
		{
			_lastContentPart = value;
		}

		public function get relativePath():String
		{
			return _relativePath;
		}

		public function set relativePath(value:String):void
		{
			_relativePath = value;
		}

		private var _fileArray:Array=[];//single file with extension
		public function push(file:String):void{
			_fileArray.push(file);
			totalResCount++;
		}
		
		public function forEachExe(fn:Function):void{
			for each(var str:String in _fileArray){
				fn(_relativePath,str);
			}
		}
	}
}