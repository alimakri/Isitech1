using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClrSQL
{
    public static class CryptoSimple
    {
        public static string Crypte(int cle, string message)
        {
            return CrypteDecrypte(cle, message);
        }
        public static string Decrypte(int cle, string message)
        {
            return CrypteDecrypte(cle, message);
        }
        private static string CrypteDecrypte(int cle, string message)
        {
            string resultat = ""; int d;
            if (cle >= 0)
            {
                foreach (char c in message)
                {
                    d = c + cle;
                    if (d > 'Z') d -= 'Z';
                    resultat += d;
                }
            }
            else
            {
                foreach (char c in message)
                {
                    d = c - cle;
                    if (d < 'A') d += 26;
                    resultat += d;
                }
            }
            return resultat;
        }
    }
}