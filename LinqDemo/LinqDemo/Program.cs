using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LinqDemo
{
    class Program
    {
        static void Main(string[] args)
        {
            var context = new AdvContext();
            var p = context.Products.FirstOrDefault();
            p.Name = "Adjustable Race";
            context.SaveChanges();

            var velos = context.Products.Where(x => x.ProductSubcategory.ProductCategory.Name == "Clothing");
            foreach(var velo in velos)
            {
                Console.WriteLine(velo.Name);
            }

            var listeEntier = new int[] { 1, 52, 69, 54, 88, 23 };

            var reponse = listeEntier.Where(x => x % 2 == 1);
            foreach (var i in reponse)
            {
                Console.WriteLine(i);
            }
            Console.Read();
        }
    }
}
