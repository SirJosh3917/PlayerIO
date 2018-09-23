using System;
using System.IO;

namespace ExposePlayerIOClient {
	class Program {
		static void Main(string[] args) {
			using (var fs = File.Open(args[0], FileMode.OpenOrCreate))
			using (var sr = new StreamReader(fs))
			using (var outfs = File.Open(args[1], FileMode.OpenOrCreate))
			using (var sw = new StreamWriter(outfs)) {
				while(!sr.EndOfStream) {
					sw.WriteLine(
							sr.ReadLine()
								.Replace("private", "public")
						);
				}
			}
		}
	}
}
