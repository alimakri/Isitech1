using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DemoProcStoc
{
    class Program
    {
        static void Main(string[] args)
        {
            //ProcStock1();
            ProcStock2();
        }

        private static void ProcStock1()
        {
            var cnx = new SqlConnection();
            cnx.ConnectionString = @"Data Source=.\SQLEXPRESS;Initial Catalog=Vente;Integrated Security=True";
            cnx.Open();

            var cmd = new SqlCommand();
            cmd.Connection = cnx;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "AjoutProduit";
            cmd.Parameters.Add(new SqlParameter("libelle", "Short bicolore"));
            cmd.Parameters.Add(new SqlParameter("prix", 333.33));
            cmd.ExecuteNonQuery();
        }
        private static void ProcStock2()
        {
            var cnx = new SqlConnection();
            cnx.ConnectionString = @"Data Source=.\SQLEXPRESS;Initial Catalog=Vente;Integrated Security=True";
            cnx.Open();

            var cmd = new SqlCommand();
            cmd.Connection = cnx;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "AjoutCommande";
            cmd.Parameters.Add(new SqlParameter("data", $@"
                                <commandes>
						            <commande id=""DD96FB64-AD3E-41AE-89F6-5A6A294CB15F"">
                                        <qte>21</qte>
                                    </commande>
						            <commande id=""9484172F-F947-4D49-A3A5-09CDB4321995"">
                                        <qte>11</qte>
                                    </commande>
                                </commandes>"));
            cmd.ExecuteNonQuery();
        }
    }
}
