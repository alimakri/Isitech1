using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccesDatabase
{
    class Program
    {
        static void Main(string[] args)
        {
            //ClassesBases();
            EntityFramework();
            Console.Read();
        }

        private static void EntityFramework()
        {
        }

        private static void ClassesBases()
        {
            var cnx = new SqlConnection();
            cnx.ConnectionString = @"Data Source=.\SQLEXPRESS;Initial Catalog=AdventureWorks2017;Integrated Security=True";
            cnx.Open();

            var cmd = new SqlCommand();
            cmd.Connection = cnx;
            cmd.CommandType = CommandType.Text;
            cmd.CommandText = "select ProductID, Name from Production.Product";

            // Mode connecté
            SqlDataReader rd = cmd.ExecuteReader();
            while (rd.Read())
            {
                Console.WriteLine("{0} - {1}", rd["ProductID"], rd["Name"]);
            }
            rd.Close();

            cmd.CommandText = "update Production.Product set Name=Name+'_YYY' where ProductId=1";
            cmd.ExecuteNonQuery();

            // Mode déconnecté
            //var da = new SqlDataAdapter();
            //var cb = new SqlCommandBuilder(da);
            //da.SelectCommand = cmd;
            //var ds = new DataSet();
            //da.Fill(ds);

            //foreach (DataRow row in ds.Tables[0].Rows)
            //{
            //    Console.WriteLine("{0} - {1}", row["ProductID"], row["Name"]);
            //}

            //ds.Tables[0].Rows[0]["Name"] += "_XXX";
            //da.Update(ds);
        }
    }
}
