using System;
using System.IO;
using System.Text;

class Program {
    static void Main() {
        string basePath = @"c:\Users\Lenovo\Desktop\椰汁博客";
        string[] files = Directory.GetFiles(basePath, "*.html", SearchOption.AllDirectories);
        int fixedCount = 0;
        foreach (var file in files) {
            string text = File.ReadAllText(file, Encoding.UTF8);
            if (text.Contains("\">>>>")) {
                text = text.Replace("\">>>>", "\">");
                text = text.Replace("\">>>", "\">");
                text = text.Replace("\">>", "\">");
                File.WriteAllText(file, text, Encoding.UTF8);
                fixedCount++;
                Console.WriteLine("Cleaned >>>> in " + file);
            }
        }
        Console.WriteLine("Cleaned files: " + fixedCount);
    }
}
