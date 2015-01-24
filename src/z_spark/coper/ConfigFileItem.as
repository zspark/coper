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